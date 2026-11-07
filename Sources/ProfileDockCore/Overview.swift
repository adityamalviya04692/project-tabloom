import Foundation

/// One row in the manager UI: a Chrome profile that is either still inside Chrome
/// ("available") or managed by ProfileDock (has its own app).
public struct ProfileRow: Identifiable, Equatable {
    public enum State: Equatable {
        case available            // in Chrome; can be given its own app
        case missingOnDisk        // listed by Chrome but its folder is gone; nothing to do
        case ready                // managed, app built for the installed Chrome
        case needsRepair          // managed, app built for a different Chrome version
        case incomplete(ManagedProfile.Stage) // interrupted migration; only rollback is offered
    }

    public var id: String { directory }
    public var directory: String
    public var name: String
    public var email: String?
    public var state: State
    public var appPath: String?
    public var isRunning: Bool
    /// Managed app that uses Chrome's own folder (nothing moved).
    public var isInPlace: Bool = false

    public var isManaged: Bool {
        switch state { case .available, .missingOnDisk: return false; default: return true }
    }
}

/// Read-only snapshot of everything the UI shows. Building it never writes anything.
public struct Overview: Equatable {
    public var rows: [ProfileRow]
    /// pid holding Chrome's own user-data-dir (Chrome is open), if any.
    public var chromePID: Int32?
    public var chromeVersion: String?
    /// Human-readable problems (Chrome not found, unreadable Local State, …).
    public var problems: [String]

    public static let empty = Overview(rows: [], chromePID: nil, chromeVersion: nil, problems: [])

    public static func build(env: DockEnvironment, isRunning: (String) -> Bool = LaunchServices.isRunning(bundleID:)) -> Overview {
        var problems: [String] = []
        let version: String?
        do { version = try ChromeInstallation.locate(env.chromeApp).version }
        catch { version = nil; problems.append("\(error)") }

        var manifest = Manifest()
        do { manifest = try Manifest.load(env.manifestURL) }
        catch { problems.append("ProfileDock's manifest could not be read: \(error)") }

        var rows: [ProfileRow] = []
        for rec in manifest.profiles.values.sorted(by: { $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending }) {
            let state: ProfileRow.State
            if rec.stage != .complete { state = .incomplete(rec.stage) }
            else if let version, rec.chromeVersion != version { state = .needsRepair }
            else { state = .ready }
            rows.append(ProfileRow(directory: rec.directory, name: rec.displayName, email: nil, state: state,
                                   appPath: rec.appPath, isRunning: isRunning(rec.bundleID), isInPlace: rec.isInPlace))
        }

        do {
            let found = try ChromeDiscovery.discover(userDataDir: env.chromeUserDataDir)
            for p in found.profiles where manifest.profiles[p.directory] == nil {
                rows.append(ProfileRow(directory: p.directory, name: p.name, email: p.email,
                                       state: p.existsOnDisk ? .available : .missingOnDisk, appPath: nil, isRunning: false))
            }
            if !found.skipped.isEmpty { problems.append("Skipped \(found.skipped.count) Chrome profile entr\(found.skipped.count == 1 ? "y" : "ies") with unsafe names.") }
        } catch {
            problems.append("Chrome's profile list could not be read: \(error)")
        }

        return Overview(rows: rows, chromePID: ProfileLock.holder(of: env.chromeUserDataDir),
                        chromeVersion: version, problems: problems)
    }
}
