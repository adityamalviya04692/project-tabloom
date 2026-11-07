import Foundation

/// One managed profile. Doubles as the migration journal: `stage` is persisted
/// (atomically) before and after each step so rollback knows exactly what to undo.
public struct ManagedProfile: Codable, Equatable {
    public enum Stage: Int, Codable, Comparable {
        case prepared = 0      // validated, Local State backed up, nothing moved yet
        case moved = 1         // profile dir renamed into the per-app user-data-dir
        case seeded = 2        // per-app Local State written
        case detached = 3      // profile removed from Chrome's Local State
        case complete = 4      // app generated and registered
        public static func < (a: Stage, b: Stage) -> Bool { a.rawValue < b.rawValue }
    }

    public var directory: String
    public var displayName: String
    public var bundleID: String
    public var appPath: String?
    public var userDataDir: String
    public var sourceUserDataDir: String
    public var chromeVersion: String?
    public var stage: Stage
    public var migratedAt: Date
    public var localStateBackup: String
    /// Chrome's original info_cache entry (JSON), restored on rollback if the per-app copy is gone.
    public var originalInfoCacheEntry: Data
    /// User-chosen icon image, copied into ProfileDock/Icons so repair can re-render it.
    public var customIconPath: String? = nil
    /// The app points at Chrome's own user-data-dir; nothing was moved (used for Chrome's main profile).
    public var inPlace: Bool? = nil
    public var isInPlace: Bool { inPlace == true }
}

public struct Manifest: Codable {
    public var version = 1
    public var profiles: [String: ManagedProfile] = [:]

    public init() {}

    public static func load(_ url: URL) throws -> Manifest {
        guard FileManager.default.fileExists(atPath: url.path) else { return Manifest() }
        let dec = JSONDecoder(); dec.dateDecodingStrategy = .iso8601
        return try dec.decode(Manifest.self, from: Data(contentsOf: url))
    }

    public func save(_ url: URL) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        let enc = JSONEncoder(); enc.dateEncodingStrategy = .iso8601; enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        try enc.encode(self).write(to: url, options: .atomic)
    }
}
