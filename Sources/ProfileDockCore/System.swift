import AppKit
import Foundation

public enum DockError: Error, CustomStringConvertible {
    case chromeNotFound(String)
    case userDataDirInUse(String, pid: Int32)
    case appRunning(String)
    case profileMissing(String)
    case alreadyManaged(String)
    case notManaged(String)
    case destinationExists(String)
    case differentVolumes(String, String)
    case toolFailed(String, Int32, String)
    case launcherMissing(String)

    public var description: String {
        switch self {
        case .chromeNotFound(let p): return "Google Chrome was not found at \(p)."
        case .userDataDirInUse(let p, let pid): return "Chrome is using \(p) (pid \(pid)). Quit Chrome completely and try again."
        case .appRunning(let id): return "\(id) is running. Quit it first."
        case .profileMissing(let p): return "Profile directory does not exist: \(p)"
        case .alreadyManaged(let d): return "Profile \(d) is already managed by ProfileDock."
        case .notManaged(let d): return "Profile \(d) is not managed by ProfileDock."
        case .destinationExists(let p): return "Refusing to overwrite existing path: \(p)"
        case .differentVolumes(let a, let b): return "\(a) and \(b) are on different volumes; a move would be a copy. Not supported."
        case .toolFailed(let t, let code, let err): return "\(t) failed (exit \(code)): \(err)"
        case .launcherMissing(let p): return "ProfileLauncher binary not found at \(p). Build with `swift build` first."
        }
    }
}

/// Runs a tool with an explicit argument vector — never through a shell.
enum Tool {
    @discardableResult
    static func run(_ path: String, _ args: [String]) throws -> String {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: path)
        p.arguments = args
        let out = Pipe(), err = Pipe()
        p.standardOutput = out; p.standardError = err
        try p.run()
        let o = out.fileHandleForReading.readDataToEndOfFile()
        let e = err.fileHandleForReading.readDataToEndOfFile()
        p.waitUntilExit()
        guard p.terminationStatus == 0 else {
            throw DockError.toolFailed(URL(fileURLWithPath: path).lastPathComponent, p.terminationStatus,
                                       String(decoding: e, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return String(decoding: o, as: UTF8.self)
    }

    static let lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
}

/// Chrome's ProcessSingleton lock: `<user-data-dir>/SingletonLock` is a symlink to "<host>-<pid>".
public enum ProfileLock {
    /// Returns the pid holding the user-data-dir, or nil if it is free (missing or stale lock).
    public static func holder(of userDataDir: URL) -> Int32? {
        let lock = userDataDir.appendingPathComponent("SingletonLock").path
        guard let target = try? FileManager.default.destinationOfSymbolicLink(atPath: lock),
              let dash = target.lastIndex(of: "-"),
              let pid = Int32(target[target.index(after: dash)...])
        else { return nil }
        // kill(pid, 0) == 0 or EPERM means the process exists.
        return (kill(pid, 0) == 0 || errno == EPERM) ? pid : nil
    }

    public static func ensureFree(_ userDataDir: URL) throws {
        if let pid = holder(of: userDataDir) { throw DockError.userDataDirInUse(userDataDir.path, pid: pid) }
    }
}

public enum LaunchServices {
    public static func register(_ app: URL) throws { try Tool.run(Tool.lsregister, ["-f", app.path]) }
    public static func unregister(_ app: URL) throws { try Tool.run(Tool.lsregister, ["-u", app.path]) }

    public static func isRunning(bundleID: String) -> Bool {
        !NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).isEmpty
    }
}

enum FS {
    static func deviceID(_ url: URL) throws -> Int {
        let attrs = try FileManager.default.attributesOfItem(atPath: url.path)
        return (attrs[.systemNumber] as? NSNumber)?.intValue ?? -1
    }

    /// renamex_np(RENAME_EXCL): atomic, same-volume, never copies data, never overwrites.
    static func move(_ from: URL, to: URL) throws {
        guard renamex_np(from.path, to.path, UInt32(RENAME_EXCL)) == 0 else {
            if errno == EEXIST { throw DockError.destinationExists(to.path) }
            throw DockError.toolFailed("rename", errno, String(cString: strerror(errno)))
        }
    }
}
