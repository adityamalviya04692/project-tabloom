import Foundation

public struct AppSpec {
    public var displayName: String
    public var bundleID: String
    public var userDataDir: URL
    public var profileDirectory: String
    public var icon: IconSource
    public var extraChromeArgs: [String]
    /// Text drawn in the icon's name band (normally the profile name). nil = no band.
    public var iconLabel: String?

    public init(displayName: String, bundleID: String, userDataDir: URL, profileDirectory: String,
                icon: IconSource, extraChromeArgs: [String] = [], iconLabel: String? = nil) {
        self.displayName = displayName; self.bundleID = bundleID; self.userDataDir = userDataDir
        self.profileDirectory = profileDirectory; self.icon = icon; self.extraChromeArgs = extraChromeArgs
        self.iconLabel = iconLabel
    }
}

/// Generates a profile app (architecture "A", see docs/ARCHITECTURE.md):
///   MacOS/ProfileLauncher  our stub, CFBundleExecutable, execv()s the loader below
///   MacOS/Google Chrome    copy of Chrome's loader, ad-hoc signed
///   Frameworks/...         APFS clone of the installed framework version (Google signature intact)
/// Built in a staging directory and moved into place, so a failure never leaves a half-built app.
public enum AppBundleGenerator {
    /// Chrome Info.plist keys that must not be inherited: updater registration, URL/document
    /// handler claims (we must not compete for default browser), privileged helpers, asset icon.
    static let strippedKeys = [
        "KSChannelID", "KSChannelID-full", "KSProductID", "KSUpdateURL", "KSVersion",
        "SMPrivilegedExecutables", "CFBundleURLTypes", "CFBundleDocumentTypes",
        "UTExportedTypeDeclarations", "UTImportedTypeDeclarations", "CFBundleIconName",
        "LSHasLocalizedDisplayName", "NSUserActivityTypes", "OSAScriptingDefinition",
        "ASWebAuthenticationSessionWebBrowserSupportCapabilities",
    ]
    public static let launcherName = "ProfileLauncher"

    @discardableResult
    public static func generate(_ spec: AppSpec, chrome: ChromeInstallation, launcher: URL, into appsDir: URL) throws -> URL {
        let fm = FileManager.default
        guard fm.isExecutableFile(atPath: launcher.path) else { throw DockError.launcherMissing(launcher.path) }
        if LaunchServices.isRunning(bundleID: spec.bundleID) { throw DockError.appRunning(spec.bundleID) }

        let appName = try SafeNames.appName(for: spec.displayName)
        try fm.createDirectory(at: appsDir, withIntermediateDirectories: true)
        let final = appsDir.appendingPathComponent("\(appName).app", isDirectory: true)
        let staging = appsDir.appendingPathComponent(".staging-\(UUID().uuidString)", isDirectory: true)
        let stagedApp = staging.appendingPathComponent("\(appName).app", isDirectory: true)
        defer { try? fm.removeItem(at: staging) }

        let contents = stagedApp.appendingPathComponent("Contents")
        let macOS = contents.appendingPathComponent("MacOS")
        let resources = contents.appendingPathComponent("Resources")
        try fm.createDirectory(at: macOS, withIntermediateDirectories: true)
        try fm.createDirectory(at: resources, withIntermediateDirectories: true)

        // Executables
        try fm.copyItem(at: launcher, to: macOS.appendingPathComponent(launcherName))
        let chromeContents = chrome.app.appendingPathComponent("Contents")
        try fm.copyItem(at: chromeContents.appendingPathComponent("MacOS/Google Chrome"),
                        to: macOS.appendingPathComponent("Google Chrome"))

        // Framework: APFS clone of the current version only, plus the standard framework symlinks.
        let fwName = chrome.frameworkName
        let srcVersion = chromeContents.appendingPathComponent("Frameworks/\(fwName)/Versions/\(chrome.version)")
        let fw = contents.appendingPathComponent("Frameworks/\(fwName)")
        try fm.createDirectory(at: fw.appendingPathComponent("Versions"), withIntermediateDirectories: true)
        try Tool.run("/bin/cp", ["-cR", srcVersion.path, fw.appendingPathComponent("Versions/\(chrome.version)").path])
        try fm.createSymbolicLink(atPath: fw.appendingPathComponent("Versions/Current").path, withDestinationPath: chrome.version)
        for link in ["Google Chrome Framework", "Helpers", "Libraries", "Resources"] {
            try fm.createSymbolicLink(atPath: fw.appendingPathComponent(link).path, withDestinationPath: "Versions/Current/\(link)")
        }

        // Info.plist
        let src = chromeContents.appendingPathComponent("Info.plist")
        guard let base = NSDictionary(contentsOf: src) as? [String: Any] else {
            throw DockError.toolFailed("Info.plist", 1, "unreadable \(src.path)")
        }
        let plist = makeInfoPlist(base: base, spec: spec, appName: appName, chromeVersion: chrome.version)
        try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
            .write(to: contents.appendingPathComponent("Info.plist"), options: .atomic)

        try IconGenerator.makeICNS(spec.icon, label: spec.iconLabel, to: resources.appendingPathComponent("AppIcon.icns"))

        // Ad-hoc sign only the two Mach-Os we placed; the cloned framework keeps Google's signature.
        for exe in ["Google Chrome", launcherName] {
            try Tool.run("/usr/bin/codesign", ["--force", "--sign", "-", macOS.appendingPathComponent(exe).path])
        }

        // Swap into place. Existing app (repair/regenerate) is replaced only after the new one is complete.
        if fm.fileExists(atPath: final.path) {
            let old = staging.appendingPathComponent("old.app")
            try FS.move(final, to: old)
            do { try FS.move(stagedApp, to: final) } catch { try? FS.move(old, to: final); throw error }
        } else {
            try FS.move(stagedApp, to: final)
        }
        try LaunchServices.register(final)
        return final
    }

    static func makeInfoPlist(base: [String: Any], spec: AppSpec, appName: String, chromeVersion: String) -> [String: Any] {
        var p = base
        for k in strippedKeys { p.removeValue(forKey: k) }
        p["CFBundleIdentifier"] = spec.bundleID
        p["CFBundleName"] = appName
        p["CFBundleDisplayName"] = appName
        p["CFBundleExecutable"] = launcherName
        p["CFBundleIconFile"] = "AppIcon.icns"
        p["PNUserDataDir"] = spec.userDataDir.path
        p["PNProfileDirectory"] = spec.profileDirectory
        p["PNExtraArgs"] = spec.extraChromeArgs
        p["PNChromeVersion"] = chromeVersion
        return p
    }

    /// Chrome version an existing generated app was built from (nil if unreadable).
    public static func builtVersion(of app: URL) -> String? {
        (NSDictionary(contentsOf: app.appendingPathComponent("Contents/Info.plist")))?["PNChromeVersion"] as? String
    }
}
