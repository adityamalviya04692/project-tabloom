import Foundation

/// All filesystem locations ProfileDock reads or writes. Tests and the E2E script
/// point these at disposable directories; nothing is hard-coded elsewhere.
public struct DockEnvironment {
    /// Chrome's user-data-dir that profiles are discovered in and migrated out of.
    public var chromeUserDataDir: URL
    /// The Chrome.app whose binaries generated apps are cloned from.
    public var chromeApp: URL
    /// Root for ProfileDock-owned state: per-app user-data-dirs, manifest, journals, backups.
    public var supportDir: URL
    /// Where generated profile apps are written.
    public var appsDir: URL
    /// Prefix for generated bundle identifiers.
    public var bundleIDPrefix: String
    /// Extra Chrome switches baked into every generated app (dev/test only, e.g. --use-mock-keychain).
    public var extraChromeArgs: [String]

    public init(chromeUserDataDir: URL, chromeApp: URL, supportDir: URL, appsDir: URL,
                bundleIDPrefix: String = "cc.ayush.profiledock.profile", extraChromeArgs: [String] = []) {
        self.chromeUserDataDir = chromeUserDataDir
        self.chromeApp = chromeApp
        self.supportDir = supportDir
        self.appsDir = appsDir
        self.bundleIDPrefix = bundleIDPrefix
        self.extraChromeArgs = extraChromeArgs
    }

    public static var standard: DockEnvironment {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return DockEnvironment(
            chromeUserDataDir: home.appendingPathComponent("Library/Application Support/Google/Chrome"),
            chromeApp: URL(fileURLWithPath: "/Applications/Google Chrome.app"),
            supportDir: home.appendingPathComponent("Library/Application Support/ProfileDock"),
            appsDir: home.appendingPathComponent("Applications/ProfileDock"))
    }

    public var userDataRoot: URL { supportDir.appendingPathComponent("UserData") }
    public var manifestURL: URL { supportDir.appendingPathComponent("manifest.json") }
    public var journalDir: URL { supportDir.appendingPathComponent("Journals") }
    public var backupDir: URL { supportDir.appendingPathComponent("Backups") }
    public var iconsDir: URL { supportDir.appendingPathComponent("Icons") }
}
