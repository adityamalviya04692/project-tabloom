import AppKit
import ProfileDockCore

/// UI state + actions. Every action runs ProfileDockCore off the main thread and
/// refreshes the snapshot afterwards; Core enforces all safety checks itself.
@MainActor
final class DockModel: ObservableObject {
    static let shared = DockModel()

    @Published private(set) var overview = Overview.empty
    /// Directory of the profile an action is running for (spinner + disabled buttons).
    @Published private(set) var busy: String?
    @Published var message: String?

    let env: DockEnvironment
    let migrator: ProfileMigrator
    private var observers: [NSObjectProtocol] = []

    init() {
        env = Self.environment()
        // The launcher stub ships next to this binary (Contents/MacOS in the .app, .build/<cfg> in dev).
        let launcher = Bundle.main.executableURL!.resolvingSymlinksInPath()
            .deletingLastPathComponent().appendingPathComponent("ProfileLauncher")
        migrator = ProfileMigrator(env: env, launcher: launcher)
        let nc = NSWorkspace.shared.notificationCenter
        for name in [NSWorkspace.didLaunchApplicationNotification, NSWorkspace.didTerminateApplicationNotification] {
            observers.append(nc.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor in self?.refresh() }
            })
        }
        refresh()
    }

    /// Standard locations, overridable with launch arguments for testing against disposable data:
    /// `-PDChromeData DIR -PDSupportDir DIR -PDAppsDir DIR -PDBundlePrefix P -PDMockKeychain YES`.
    static func environment(_ d: UserDefaults = .standard) -> DockEnvironment {
        var env = DockEnvironment.standard
        func path(_ k: String) -> URL? {
            d.string(forKey: k).map { URL(fileURLWithPath: ($0 as NSString).expandingTildeInPath).standardizedFileURL }
        }
        if let u = path("PDChromeData") { env.chromeUserDataDir = u }
        if let u = path("PDChromeApp") { env.chromeApp = u }
        if let u = path("PDSupportDir") { env.supportDir = u }
        if let u = path("PDAppsDir") { env.appsDir = u }
        if let p = d.string(forKey: "PDBundlePrefix") { env.bundleIDPrefix = p }
        if d.bool(forKey: "PDMockKeychain") { env.extraChromeArgs.append("--use-mock-keychain") }
        return env
    }

    var isUsingStandardLocations: Bool { env.chromeUserDataDir == DockEnvironment.standard.chromeUserDataDir }

    func refresh() {
        let env = self.env
        Task.detached {
            let o = Overview.build(env: env)
            await MainActor.run { self.overview = o }
        }
    }

    // MARK: Actions

    func open(_ row: ProfileRow) {
        guard let p = row.appPath else { return }
        NSWorkspace.shared.openApplication(at: URL(fileURLWithPath: p), configuration: .init()) { _, error in
            if let error { Task { @MainActor in self.message = "Could not open \(row.name): \(error.localizedDescription)" } }
        }
    }

    func reveal(_ row: ProfileRow) {
        guard let p = row.appPath else { return }
        NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: p)])
    }

    func revealAppsFolder() {
        try? FileManager.default.createDirectory(at: env.appsDir, withIntermediateDirectories: true)
        NSWorkspace.shared.open(env.appsDir)
    }

    /// Chrome's main profile gets an app in place (nothing moved); every other profile is moved.
    nonisolated static let mainDirectory = "Default"

    func migrate(_ row: ProfileRow) {
        if row.directory == Self.mainDirectory {
            run(row, done: "\(row.name) now has its own app. Quit Google Chrome and open it from the menu.") { m in
                try m.adoptInPlace(directory: row.directory)
            }
        } else {
            run(row, done: "\(row.name) now has its own app.") { m in try m.migrate(directory: row.directory) }
        }
    }

    func giveAllOwnApps() {
        run(nil, done: "") { m in
            let r = try m.giveAllOwnApps(mainDirectory: Self.mainDirectory)
            let failures = r.failed.map { "\($0.directory): \($0.error)" }.joined(separator: "\n")
            if !failures.isEmpty { throw BulkError(text: "\(r.done.count) done, \(r.failed.count) failed:\n\(failures)") }
        }
    }

    func rollback(_ row: ProfileRow) {
        run(row, done: "\(row.name) is back in Chrome.") { m in try m.rollback(directory: row.directory) }
    }

    func repair(_ row: ProfileRow, icon: URL? = nil) {
        run(row, done: icon == nil ? "Rebuilt \(row.name)." : "Changed the icon of \(row.name). Quit and reopen it to see the new icon.") { m in
            try m.repair(directory: row.directory, icon: icon.map(IconSource.image))
        }
    }

    func repairAll() {
        let rows = overview.rows.filter { $0.state == .needsRepair && !$0.isRunning }
        guard !rows.isEmpty else { return }
        run(nil, done: "Rebuilt \(rows.count) app\(rows.count == 1 ? "" : "s").") { m in
            for r in rows { try m.repair(directory: r.directory) }
        }
    }

    func chooseIcon(for row: ProfileRow) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.message = "Choose an image for \(row.name). Its name is drawn on top."
        NSApp.activate(ignoringOtherApps: true)
        guard panel.runModal() == .OK, let url = panel.url else { return }
        repair(row, icon: url)
    }

    private func run(_ row: ProfileRow?, done: String, _ work: @escaping @Sendable (ProfileMigrator) throws -> Void) {
        guard busy == nil else { return }
        busy = row?.directory ?? "*"
        message = nil
        let migrator = self.migrator
        Task.detached {
            let result: String
            do { try work(migrator); result = done.isEmpty ? "Done. Every profile has its own app." : done } catch { result = "\(error)" }
            await MainActor.run {
                self.busy = nil
                self.message = result
                self.refresh()
            }
        }
    }
}

extension ProfileMigrator: @unchecked Sendable {}

struct BulkError: Error, CustomStringConvertible { var text: String; var description: String { text } }
