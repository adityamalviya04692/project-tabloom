import Foundation

public enum SafeNameError: Error, Equatable, CustomStringConvertible {
    case invalidProfileDirectory(String)
    case invalidDisplayName(String)

    public var description: String {
        switch self {
        case .invalidProfileDirectory(let s): return "Refusing unsafe Chrome profile directory name: \(s.debugDescription)"
        case .invalidDisplayName(let s): return "Display name cannot be used as an app name: \(s.debugDescription)"
        }
    }
}

/// Validation and derivation of names that end up in paths and bundle identifiers.
/// Profile metadata comes from Chrome's Local State and is treated as untrusted.
public enum SafeNames {
    /// Chrome profile directories are single path components like "Default" or "Profile 3".
    /// Anything that could escape the user-data-dir is rejected, as are Chrome's special dirs.
    public static func validateProfileDirectory(_ name: String) throws -> String {
        let reserved: Set<String> = ["System Profile", "Guest Profile"]
        guard !name.isEmpty, name.count <= 128, name != ".", name != "..",
              !name.contains("/"), !name.contains("\0"), !name.contains(":"),
              !name.hasPrefix("."), !reserved.contains(name)
        else { throw SafeNameError.invalidProfileDirectory(name) }
        return name
    }

    /// App file name stem: "Chrome - <name>". Strips path separators and control
    /// characters, keeps Unicode, collapses whitespace, caps length.
    public static func appName(for displayName: String) throws -> String {
        let cleaned = displayName.unicodeScalars
            .map { CharacterSet.controlCharacters.contains($0) || "/:\\".unicodeScalars.contains($0) ? " " : String($0) }
            .joined()
            .split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
        let trimmed = String(cleaned.prefix(60)).trimmingCharacters(in: CharacterSet(charactersIn: ". "))
        guard !trimmed.isEmpty else { throw SafeNameError.invalidDisplayName(displayName) }
        return "Chrome - \(trimmed)"
    }

    /// Stable ASCII slug for a profile directory, used in bundle IDs and folder names.
    /// Derived from the directory (unique within Chrome), never from the editable display name.
    public static func slug(forProfileDirectory dir: String) -> String {
        let lowered = dir.lowercased()
        var out = ""
        var lastDash = false
        for scalar in lowered.unicodeScalars {
            if ("a"..."z").contains(scalar) || ("0"..."9").contains(scalar) {
                out.unicodeScalars.append(scalar); lastDash = false
            } else if !lastDash, !out.isEmpty {
                out += "-"; lastDash = true
            }
        }
        while out.hasSuffix("-") { out.removeLast() }
        // Non-ASCII-only names: fall back to a short stable hash so slugs stay unique.
        if out.isEmpty { out = "p" + String(fnv1a(dir), radix: 16) }
        return out
    }

    public static func bundleIdentifier(prefix: String, slug: String) -> String { "\(prefix).\(slug)" }

    /// Initials for generated avatars: first letters of up to two words.
    public static func initials(_ name: String) -> String {
        let words = name.split(whereSeparator: { $0.isWhitespace || $0 == "-" })
        let letters = words.prefix(2).compactMap { $0.first.map { String($0).uppercased() } }
        return letters.isEmpty ? "?" : letters.joined()
    }

    static func fnv1a(_ s: String) -> UInt32 {
        var h: UInt32 = 0x811c9dc5
        for b in s.utf8 { h = (h ^ UInt32(b)) &* 0x01000193 }
        return h
    }
}
