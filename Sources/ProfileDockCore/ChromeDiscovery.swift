import Foundation

public struct ChromeProfile: Equatable {
    /// Directory name inside the user-data-dir ("Default", "Profile 3"). Validated.
    public var directory: String
    /// Human-readable name from Chrome ("Work"). Untrusted display text.
    public var name: String
    public var email: String?
    /// Path to Chrome's cached Google account picture, if one exists on disk.
    public var avatarImage: URL?
    /// Theme/highlight colour as 0xRRGGBB, when Chrome recorded one.
    public var color: UInt32?
    /// Whether the profile directory actually exists on disk.
    public var existsOnDisk: Bool
}

public struct DiscoveryResult {
    public var profiles: [ChromeProfile]
    /// Entries skipped because their directory name was unsafe or the entry was malformed.
    public var skipped: [String]
}

/// Read-only discovery of Chrome profiles from `Local State`. Never writes anything.
public enum ChromeDiscovery {
    public static func discover(userDataDir: URL) throws -> DiscoveryResult {
        let state = try LocalState.load(userDataDir.appendingPathComponent("Local State"))
        let fm = FileManager.default
        var profiles: [ChromeProfile] = []
        var skipped: [String] = []
        let order = state.profilesOrder
        let keys = state.infoCache.keys.sorted { a, b in
            (order.firstIndex(of: a) ?? Int.max, a) < (order.firstIndex(of: b) ?? Int.max, b)
        }
        for key in keys {
            guard let dir = try? SafeNames.validateProfileDirectory(key) else { skipped.append(key); continue }
            let entry = state.infoCache[key] ?? [:]
            let name = (entry["name"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? dir
            let email = (entry["user_name"] as? String).flatMap { $0.isEmpty ? nil : $0 }
            let profileURL = userDataDir.appendingPathComponent(dir, isDirectory: true)
            var avatar: URL?
            if let pic = entry["gaia_picture_file_name"] as? String, !pic.isEmpty, !pic.contains("/") {
                let u = profileURL.appendingPathComponent(pic)
                if fm.fileExists(atPath: u.path) { avatar = u }
            }
            let color = colorValue(entry["profile_highlight_color"]) ?? colorValue(entry["default_avatar_fill_color"])
            profiles.append(ChromeProfile(directory: dir, name: name, email: email, avatarImage: avatar,
                                          color: color, existsOnDisk: fm.fileExists(atPath: profileURL.path)))
        }
        return DiscoveryResult(profiles: profiles, skipped: skipped)
    }

    /// Chrome stores colours as signed 32-bit ARGB integers.
    static func colorValue(_ v: Any?) -> UInt32? {
        guard let n = v as? NSNumber else { return nil }
        return UInt32(truncatingIfNeeded: n.int64Value) & 0xFFFFFF
    }
}

public struct ChromeInstallation {
    public var app: URL
    public var version: String
    public var frameworkName: String { "Google Chrome Framework.framework" }

    public static func locate(_ app: URL) throws -> ChromeInstallation {
        let plist = app.appendingPathComponent("Contents/Info.plist")
        guard let info = NSDictionary(contentsOf: plist),
              info["CFBundleIdentifier"] as? String == "com.google.Chrome",
              let version = info["CFBundleShortVersionString"] as? String
        else { throw DockError.chromeNotFound(app.path) }
        return ChromeInstallation(app: app, version: version)
    }
}
