import AppKit
import ProfileDockCore
import SwiftUI

@main
struct ProfileDockMenuApp: App {
    @ObservedObject private var model = DockModel.shared

    init() {
        NSApplication.shared.setActivationPolicy(.accessory) // menu-bar only, even outside the .app bundle
        if let out = UserDefaults.standard.string(forKey: "PDRenderPreview") { renderPreview(to: out) }
    }

    var body: some Scene {
        MenuBarExtra("ProfileDock", systemImage: "person.2.crop.square.stack") {
            ManagerView(model: model)
        }
        .menuBarExtraStyle(.window)
    }
}

let quitChromeHint = "Quit Google Chrome (⌘Q) and your main profile's app to move profiles."

struct ManagerView: View {
    @ObservedObject var model: DockModel

    private var managed: [ProfileRow] { model.overview.rows.filter(\.isManaged) }
    private var available: [ProfileRow] { model.overview.rows.filter { !$0.isManaged } }
    private var chromeOpen: Bool { model.overview.chromePID != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            if !model.isUsingStandardLocations {
                Label("Test mode: using \(model.env.chromeUserDataDir.path)", systemImage: "testtube.2")
                    .font(.caption).foregroundStyle(.orange)
            }
            ForEach(model.overview.problems, id: \.self) { p in
                Label(p, systemImage: "exclamationmark.triangle").font(.caption).foregroundStyle(.red)
            }
            if managed.isEmpty { onboarding }

            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    if !managed.isEmpty {
                        section("Profiles with their own app")
                        ForEach(managed) { ManagedRowView(row: $0, model: model) }
                    }
                    if !available.isEmpty {
                        HStack {
                            section("Still inside Chrome")
                            Spacer()
                            if available.filter({ $0.state == .available }).count > 1 {
                                Button("Give Every Profile Its Own App…") { confirmAll() }
                                    .controlSize(.small)
                                    .disabled(model.busy != nil || chromeOpen)
                                    .help(chromeOpen ? quitChromeHint : "")
                            }
                        }
                        if chromeOpen {
                            Text(quitChromeHint).font(.caption).foregroundStyle(.orange)
                        }
                        ForEach(available) { AvailableRowView(row: $0, model: model, chromeOpen: chromeOpen) }
                    }
                }
            }
            .frame(maxHeight: 380)

            if let m = model.message {
                Text(m).font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            }
            Divider()
            footer
        }
        .padding(12)
        .frame(width: 380)
        .onAppear { model.refresh() }
    }

    private func confirmAll() {
        let n = available.filter { $0.state == .available }.count
        guard confirm(title: "Give all \(n) profiles their own app?",
                      text: """
                      Each profile gets an app with Chrome's logo and its name, its own Dock icon and ⌘-Tab entry.

                      Your main profile (Default) stays in Chrome's own folder; its app just opens it. \
                      Every other profile's folder moves out of Chrome (nothing copied or deleted), and leaves \
                      Chrome's profile menu until you restore it. Each can be restored separately.

                      macOS may ask once per app to allow "Chrome Safe Storage" in your Keychain.
                      """,
                      button: "Give Own Apps") else { return }
        model.giveAllOwnApps()
    }

    private var header: some View {
        HStack {
            Text("ProfileDock").font(.headline)
            Spacer()
            if model.busy != nil { ProgressView().controlSize(.small) }
            Text("Chrome \(model.overview.chromeVersion ?? "not found")").font(.caption).foregroundStyle(.secondary)
        }
    }

    private var onboarding: some View {
        Text("""
        Give a Chrome profile its own app: its own Dock icon, ⌘-Tab entry and windows, \
        with its logins, cookies and extensions. The profile's folder is moved (not copied) \
        out of Chrome, and "Restore to Chrome" puts it back exactly. Chrome must be quit to do either.
        """)
        .font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
    }

    private func section(_ title: String) -> some View {
        Text(title.uppercased()).font(.caption2.weight(.semibold)).foregroundStyle(.secondary).padding(.top, 4)
    }

    private var footer: some View {
        HStack {
            Button("Refresh") { model.refresh() }
            if managed.contains(where: { $0.state == .needsRepair }) {
                Button("Rebuild outdated") { model.repairAll() }.disabled(model.busy != nil)
            }
            Spacer()
            Button("Apps Folder") { model.revealAppsFolder() }
            Button("Quit") { NSApp.terminate(nil) }
        }
        .controlSize(.small)
    }
}

struct ManagedRowView: View {
    let row: ProfileRow
    @ObservedObject var model: DockModel

    var body: some View {
        HStack(spacing: 8) {
            AppIconView(path: row.appPath)
            VStack(alignment: .leading, spacing: 1) {
                Text(row.name).lineLimit(1)
                Text(statusText).font(.caption).foregroundStyle(statusColor)
            }
            Spacer()
            if case .incomplete = row.state {
                Button("Undo") { confirmRollback() }.disabled(model.busy != nil || row.isRunning)
            } else {
                Button(row.isRunning ? "Show" : "Open") { model.open(row) }
                Menu {
                    Button("Change Icon…") { model.chooseIcon(for: row) }
                    Button("Rebuild App") { model.repair(row) }
                    Button("Show in Finder") { model.reveal(row) }
                    Divider()
                    Button("Restore to Chrome…") { confirmRollback() }
                } label: { Image(systemName: "ellipsis.circle") }
                .menuStyle(.borderlessButton).fixedSize()
                .disabled(model.busy != nil || row.isRunning)
                .help(row.isRunning ? "Quit \(row.name) to change it." : "More")
            }
        }
        .controlSize(.small)
        .opacity(model.busy == row.directory ? 0.5 : 1)
    }

    private var statusText: String {
        switch row.state {
        case .ready where row.isInPlace: return row.isRunning ? "Running · Chrome's main profile" : "Ready · open this instead of Google Chrome"
        case .ready: return row.isRunning ? "Running" : "Ready"
        case .needsRepair: return "Chrome was updated: rebuild this app" + (row.isRunning ? " after quitting it" : "")
        case .incomplete(let s): return "Interrupted while moving (\(s)). Undo to restore it."
        default: return ""
        }
    }

    private var statusColor: Color {
        switch row.state {
        case .ready: return row.isRunning ? .green : .secondary
        default: return .orange
        }
    }

    private func confirmRollback() {
        guard confirm(title: "Restore \"\(row.name)\" to Chrome?",
                      text: "Its app is deleted and the profile moves back into Chrome's profile list, with its logins and cookies. Chrome and this app must be quit.",
                      button: "Restore") else { return }
        model.rollback(row)
    }
}

struct AvailableRowView: View {
    let row: ProfileRow
    @ObservedObject var model: DockModel
    let chromeOpen: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.crop.circle").font(.title2).foregroundStyle(.secondary).frame(width: 28)
            VStack(alignment: .leading, spacing: 1) {
                Text(row.name).lineLimit(1)
                Text(row.state == .missingOnDisk ? "Folder missing" : row.email ?? row.directory)
                    .font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
            Spacer()
            if row.state == .available {
                Button("Give Own App…") { confirmMigrate() }
                    .disabled(model.busy != nil || chromeOpen)
                    .help(chromeOpen ? quitChromeHint : "Move this profile into its own app.")
            }
        }
        .controlSize(.small)
        .opacity(model.busy == row.directory ? 0.5 : 1)
    }

    private func confirmMigrate() {
        if row.directory == DockModel.mainDirectory {
            guard confirm(title: "Give \"\(row.name)\" its own app?",
                          text: """
                          This is Chrome's main profile, so nothing is moved: the app "Chrome - \(row.name)" opens it \
                          from Chrome's own folder with Chrome's logo and its name. Use it instead of Google Chrome; \
                          while Google Chrome itself is open, the app just switches to it.
                          """,
                          button: "Create App") else { return }
            model.migrate(row)
            return
        }
        guard confirm(title: "Give \"\(row.name)\" its own app?",
                      text: """
                      The profile's folder (\(row.directory)) moves out of Chrome into ProfileDock, and an app \
                      "Chrome - \(row.name)" is created. It disappears from Chrome's profile menu until you restore it. \
                      Nothing is copied or deleted, and Chrome's profile list is backed up first.

                      On first launch macOS may ask to allow access to "Chrome Safe Storage" in your Keychain; \
                      that is needed for saved logins and cookies.
                      """,
                      button: "Move Profile") else { return }
        model.migrate(row)
    }
}

struct AppIconView: View {
    let path: String?
    var body: some View {
        Group {
            if let path { Image(nsImage: NSWorkspace.shared.icon(forFile: path)).resizable() }
            else { Image(systemName: "app.dashed").resizable() }
        }
        .frame(width: 28, height: 28)
    }
}

/// Test/docs aid: `-PDRenderPreview out.png` draws the panel offscreen (no screen capture) and quits.
@MainActor
func renderPreview(to path: String) {
    Task { @MainActor in
        try? await Task.sleep(nanoseconds: 2_000_000_000) // let the first refresh finish
        // Host the real view in an offscreen window so native controls draw as they do in the menu.
        let host = NSHostingView(rootView: ManagerView(model: DockModel.shared).background(Color(nsColor: .windowBackgroundColor)))
        host.appearance = NSAppearance(named: .aqua)
        let window = NSWindow(contentRect: NSRect(x: -10000, y: -10000, width: 380, height: 300),
                              styleMask: [.borderless], backing: .buffered, defer: false)
        window.contentView = host
        host.layoutSubtreeIfNeeded()
        window.setContentSize(host.fittingSize)
        window.orderFrontRegardless()
        try? await Task.sleep(nanoseconds: 500_000_000)
        if let rep = host.bitmapImageRepForCachingDisplay(in: host.bounds) {
            host.cacheDisplay(in: host.bounds, to: rep)
            try? rep.representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: path))
        }
        exit(0)
    }
}

@MainActor
func confirm(title: String, text: String, button: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = title
    alert.informativeText = text
    alert.addButton(withTitle: button)
    alert.addButton(withTitle: "Cancel")
    NSApp.activate(ignoringOtherApps: true)
    return alert.runModal() == .alertFirstButtonReturn
}
