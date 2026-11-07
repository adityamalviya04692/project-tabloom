import Foundation

public enum LocalStateError: Error, CustomStringConvertible {
    case unreadable(URL, String)
    case notAnObject(URL)

    public var description: String {
        switch self {
        case .unreadable(let u, let why): return "Could not read \(u.path): \(why)"
        case .notAnObject(let u): return "\(u.path) is not a JSON object"
        }
    }
}

/// Chrome's `Local State` JSON. Loaded as an untyped dictionary so that unknown keys
/// survive a read-modify-write untouched; only `profile.*` fields are edited.
public struct LocalState {
    public var root: [String: Any]

    public init(root: [String: Any] = [:]) { self.root = root }

    public static func load(_ url: URL) throws -> LocalState {
        let data: Data
        do { data = try Data(contentsOf: url) } catch { throw LocalStateError.unreadable(url, error.localizedDescription) }
        let obj: Any
        do { obj = try JSONSerialization.jsonObject(with: data) } catch { throw LocalStateError.unreadable(url, "invalid JSON") }
        guard let dict = obj as? [String: Any] else { throw LocalStateError.notAnObject(url) }
        return LocalState(root: dict)
    }

    /// Atomic write (temp file + rename), so Chrome never sees a half-written file.
    public func save(_ url: URL) throws {
        let data = try JSONSerialization.data(withJSONObject: root, options: [.sortedKeys])
        try data.write(to: url, options: .atomic)
    }

    var profile: [String: Any] {
        get { root["profile"] as? [String: Any] ?? [:] }
        set { root["profile"] = newValue }
    }

    public var infoCache: [String: [String: Any]] {
        get { (profile["info_cache"] as? [String: Any] ?? [:]).compactMapValues { $0 as? [String: Any] } }
        set { var p = profile; p["info_cache"] = newValue; profile = p }
    }

    public var profilesOrder: [String] {
        get { profile["profiles_order"] as? [String] ?? [] }
        set { var p = profile; p["profiles_order"] = newValue; profile = p }
    }

    public var lastUsed: String? {
        get { profile["last_used"] as? String }
        set { var p = profile; p["last_used"] = newValue; profile = p }
    }

    public var lastActiveProfiles: [String] {
        get { profile["last_active_profiles"] as? [String] ?? [] }
        set { var p = profile; p["last_active_profiles"] = newValue; profile = p }
    }

    /// Removes one profile's entries; returns its info_cache entry for later restore.
    @discardableResult
    public mutating func removeProfile(_ dir: String) -> [String: Any]? {
        var cache = infoCache
        let entry = cache.removeValue(forKey: dir)
        infoCache = cache
        profilesOrder = profilesOrder.filter { $0 != dir }
        lastActiveProfiles = lastActiveProfiles.filter { $0 != dir }
        if lastUsed == dir { lastUsed = profilesOrder.first ?? cache.keys.sorted().first }
        return entry
    }

    /// Re-adds a profile entry (used by migration rollback and when seeding a per-app Local State).
    public mutating func addProfile(_ dir: String, entry: [String: Any]) {
        var cache = infoCache
        cache[dir] = entry
        infoCache = cache
        if !profilesOrder.contains(dir) { profilesOrder = profilesOrder + [dir] }
    }

    /// Minimal Local State for a per-app user-data-dir that contains exactly one profile.
    public static func singleProfile(_ dir: String, entry: [String: Any]) -> LocalState {
        var s = LocalState()
        s.addProfile(dir, entry: entry)
        s.lastUsed = dir
        s.lastActiveProfiles = [dir]
        return s
    }
}
