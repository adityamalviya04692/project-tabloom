import Foundation

/// Moves an existing Chrome profile into its own user-data-dir and generates its app;
/// rolls that back exactly. See docs/ARCHITECTURE.md "Migration".
///
/// Safety rules enforced here:
/// * Never runs while Chrome (or the profile app) holds either user-data-dir lock.
/// * Profile data is renamed in place (same volume), never copied or deleted.
/// * Chrome's Local State is backed up before its single edit (removing the profile entry).
/// * Every step is journaled; any failure rolls back what was done.
public struct ProfileMigrator {
    public var env: DockEnvironment
    public var launcher: URL

    public init(env: DockEnvironment, launcher: URL) { self.env = env; self.launcher = launcher }

    public struct Options {
        public var displayName: String?
        public var icon: IconSource?
        public init(displayName: String? = nil, icon: IconSource? = nil) { self.displayName = displayName; self.icon = icon }
    }

    var chromeLocalState: URL { env.chromeUserDataDir.appendingPathComponent("Local State") }

    public func manifest() throws -> Manifest { try Manifest.load(env.manifestURL) }

    // MARK: Migrate

    @discardableResult
    public func migrate(directory rawDir: String, options: Options = Options()) throws -> ManagedProfile {
        let fm = FileManager.default
        let dir = try SafeNames.validateProfileDirectory(rawDir)
        let chrome = try ChromeInstallation.locate(env.chromeApp)
        var manifest = try self.manifest()
        if manifest.profiles[dir] != nil { throw DockError.alreadyManaged(dir) }

        let source = env.chromeUserDataDir.appendingPathComponent(dir, isDirectory: true)
        var isDir: ObjCBool = false
        guard fm.fileExists(atPath: source.path, isDirectory: &isDir), isDir.boolValue else {
            throw DockError.profileMissing(source.path)
        }
        try ProfileLock.ensureFree(env.chromeUserDataDir)

        let slug = SafeNames.slug(forProfileDirectory: dir)
        let bundleID = SafeNames.bundleIdentifier(prefix: env.bundleIDPrefix, slug: slug)
        if LaunchServices.isRunning(bundleID: bundleID) { throw DockError.appRunning(bundleID) }

        try fm.createDirectory(at: env.userDataRoot, withIntermediateDirectories: true)
        try fm.createDirectory(at: env.backupDir, withIntermediateDirectories: true)
        guard try FS.deviceID(env.chromeUserDataDir) == FS.deviceID(env.userDataRoot) else {
            throw DockError.differentVolumes(env.chromeUserDataDir.path, env.userDataRoot.path)
        }
        let target = env.userDataRoot.appendingPathComponent(slug, isDirectory: true)
        if fm.fileExists(atPath: target.path) { throw DockError.destinationExists(target.path) }

        let state = try LocalState.load(chromeLocalState)
        let entry = state.infoCache[dir] ?? ["name": dir]
        let displayName = try uniqueDisplayName(options.displayName ?? (entry["name"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? dir,
                                                email: entry["user_name"] as? String, directory: dir, manifest: manifest)

        let stamp = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "")
        let backup = env.backupDir.appendingPathComponent("\(stamp)-\(slug)-Local State")
        try fm.copyItem(at: chromeLocalState, to: backup)

        var record = ManagedProfile(
            directory: dir, displayName: displayName, bundleID: bundleID, appPath: nil,
            userDataDir: target.path, sourceUserDataDir: env.chromeUserDataDir.path, chromeVersion: nil,
            stage: .prepared, migratedAt: Date(), localStateBackup: backup.path,
            originalInfoCacheEntry: try JSONSerialization.data(withJSONObject: entry, options: [.sortedKeys]))
        func commit(_ stage: ManagedProfile.Stage) throws {
            record.stage = stage
            manifest.profiles[dir] = record
            try manifest.save(env.manifestURL)
        }
        try commit(.prepared)

        do {
            try fm.createDirectory(at: target, withIntermediateDirectories: false)
            try FS.move(source, to: target.appendingPathComponent(dir, isDirectory: true))
            try commit(.moved)

            try LocalState.singleProfile(dir, entry: entry).save(target.appendingPathComponent("Local State"))
            try commit(.seeded)

            // Re-check the lock right before editing Chrome's Local State: Chrome rewrites it on exit.
            try ProfileLock.ensureFree(env.chromeUserDataDir)
            var chromeState = try LocalState.load(chromeLocalState)
            chromeState.removeProfile(dir)
            try chromeState.save(chromeLocalState)
            try commit(.detached)

            var icon = Self.defaultIcon(chromeApp: env.chromeApp, directory: dir, entry: entry)
            if case .image(let custom)? = options.icon {
                let kept = try Self.keepCustomIcon(custom, slug: slug, env: env)
                record.customIconPath = kept.path
                icon = .image(kept)
            } else if let given = options.icon {
                icon = given
            }
            let app = try AppBundleGenerator.generate(
                AppSpec(displayName: displayName, bundleID: bundleID, userDataDir: target, profileDirectory: dir,
                        icon: icon, extraChromeArgs: env.extraChromeArgs, iconLabel: displayName),
                chrome: chrome, launcher: launcher, into: env.appsDir)
            record.appPath = app.path
            record.chromeVersion = chrome.version
            try commit(.complete)
            return record
        } catch {
            try? rollback(directory: dir)
            throw error
        }
    }

    // MARK: In place (Chrome's main profile)

    /// Gives a profile its own app without moving anything: the app runs Chrome's own user-data-dir.
    /// Only one profile can be in place (one user-data-dir = one process), and while plain Google Chrome
    /// is running the app just hands over to it. Meant for Chrome's main profile.
    @discardableResult
    public func adoptInPlace(directory rawDir: String, options: Options = Options()) throws -> ManagedProfile {
        let dir = try SafeNames.validateProfileDirectory(rawDir)
        let chrome = try ChromeInstallation.locate(env.chromeApp)
        var manifest = try self.manifest()
        if manifest.profiles[dir] != nil { throw DockError.alreadyManaged(dir) }
        if let other = manifest.profiles.values.first(where: \.isInPlace) { throw DockError.alreadyManaged("\(other.directory) (in place)") }
        let profile = env.chromeUserDataDir.appendingPathComponent(dir, isDirectory: true)
        guard FileManager.default.fileExists(atPath: profile.path) else { throw DockError.profileMissing(profile.path) }
        let entry = try LocalState.load(chromeLocalState).infoCache[dir] ?? ["name": dir]
        let displayName = try uniqueDisplayName(options.displayName ?? (entry["name"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? dir,
                                                email: entry["user_name"] as? String, directory: dir, manifest: manifest)
        let slug = SafeNames.slug(forProfileDirectory: dir)
        let bundleID = SafeNames.bundleIdentifier(prefix: env.bundleIDPrefix, slug: slug)
        var record = ManagedProfile(
            directory: dir, displayName: displayName, bundleID: bundleID, appPath: nil,
            userDataDir: env.chromeUserDataDir.path, sourceUserDataDir: env.chromeUserDataDir.path, chromeVersion: nil,
            stage: .prepared, migratedAt: Date(), localStateBackup: "",
            originalInfoCacheEntry: try JSONSerialization.data(withJSONObject: entry, options: [.sortedKeys]), inPlace: true)
        var icon = Self.defaultIcon(chromeApp: env.chromeApp, directory: dir, entry: entry)
        if case .image(let custom)? = options.icon {
            let kept = try Self.keepCustomIcon(custom, slug: slug, env: env)
            record.customIconPath = kept.path
            icon = .image(kept)
        }
        let app = try AppBundleGenerator.generate(
            AppSpec(displayName: displayName, bundleID: bundleID, userDataDir: env.chromeUserDataDir, profileDirectory: dir,
                    icon: icon, extraChromeArgs: env.extraChromeArgs, iconLabel: displayName),
            chrome: chrome, launcher: launcher, into: env.appsDir)
        record.appPath = app.path; record.chromeVersion = chrome.version; record.stage = .complete
        manifest.profiles[dir] = record
        try manifest.save(env.manifestURL)
        return record
    }

    // MARK: Every profile

    public struct BulkResult {
        public var done: [ManagedProfile] = []
        public var failed: [(directory: String, error: String)] = []
    }

    /// Gives every Chrome profile its own app: `mainDirectory` (Chrome's "Default") in place, the rest moved.
    /// Refuses up front while Chrome is open; then continues past a failing profile (each one rolls itself back).
    public func giveAllOwnApps(mainDirectory: String = "Default") throws -> BulkResult {
        try ProfileLock.ensureFree(env.chromeUserDataDir)
        let managed = try manifest().profiles
        let profiles = try ChromeDiscovery.discover(userDataDir: env.chromeUserDataDir).profiles
            .filter { $0.existsOnDisk && managed[$0.directory] == nil }
        var result = BulkResult()
        // Moved profiles first, so the main profile is adopted last and keeps its plain name if names clash.
        for p in profiles.sorted(by: { ($0.directory == mainDirectory ? 1 : 0, $0.directory) < ($1.directory == mainDirectory ? 1 : 0, $1.directory) }) {
            do {
                if p.directory == mainDirectory {
                    if managed.values.contains(where: \.isInPlace) { continue }
                    result.done.append(try adoptInPlace(directory: p.directory))
                } else {
                    result.done.append(try migrate(directory: p.directory))
                }
            } catch {
                result.failed.append((p.directory, "\(error)"))
            }
        }
        return result
    }

    // MARK: Rollback / uninstall

    /// Restores the profile to Chrome's user-data-dir, re-adds it to Chrome's Local State,
    /// and removes the generated app and ProfileDock's per-app directory. Works from any stage.
    public func rollback(directory rawDir: String) throws {
        let fm = FileManager.default
        let dir = try SafeNames.validateProfileDirectory(rawDir)
        var manifest = try self.manifest()
        guard let rec = manifest.profiles[dir] else { throw DockError.notManaged(dir) }
        let target = URL(fileURLWithPath: rec.userDataDir, isDirectory: true)
        let source = URL(fileURLWithPath: rec.sourceUserDataDir, isDirectory: true)
        let movedProfile = target.appendingPathComponent(dir, isDirectory: true)
        let restoredProfile = source.appendingPathComponent(dir, isDirectory: true)

        if LaunchServices.isRunning(bundleID: rec.bundleID) { throw DockError.appRunning(rec.bundleID) }
        if rec.isInPlace {
            // Nothing was moved or edited: remove the app and the stored icon only. Chrome's data is untouched.
            removeApp(rec)
            removeCustomIcon(rec)
            manifest.profiles.removeValue(forKey: dir)
            try manifest.save(env.manifestURL)
            return
        }
        try ProfileLock.ensureFree(target)
        try ProfileLock.ensureFree(source)

        // 1. Remove the generated app (only the path we recorded, only inside appsDir).
        removeApp(rec)

        // 2. Re-add to Chrome's Local State. Prefer the per-app entry (Chrome may have updated name/avatar).
        if rec.stage >= .detached {
            var entry = (try? JSONSerialization.jsonObject(with: rec.originalInfoCacheEntry)) as? [String: Any] ?? ["name": dir]
            if let s = try? LocalState.load(target.appendingPathComponent("Local State")), let e = s.infoCache[dir] { entry = e }
            var chromeState = try LocalState.load(source.appendingPathComponent("Local State"))
            chromeState.addProfile(dir, entry: entry)
            try chromeState.save(source.appendingPathComponent("Local State"))
        }

        // 3. Move the profile back. RENAME_EXCL: never overwrite a profile Chrome may have recreated.
        if fm.fileExists(atPath: movedProfile.path) {
            try FS.move(movedProfile, to: restoredProfile)
        }

        // 4. Delete the per-app user-data-dir: only Chrome's per-install caches remain in it.
        //    Guarded: never delete it while it still contains the profile.
        if fm.fileExists(atPath: target.path), !fm.fileExists(atPath: movedProfile.path),
           target.deletingLastPathComponent().standardizedFileURL == env.userDataRoot.standardizedFileURL {
            try fm.removeItem(at: target)
        }

        // 5. Remove the stored custom icon (a ProfileDock-owned copy).
        removeCustomIcon(rec)

        manifest.profiles.removeValue(forKey: dir)
        try manifest.save(env.manifestURL)
    }

    private func removeApp(_ rec: ManagedProfile) {
        guard let appPath = rec.appPath else { return }
        let app = URL(fileURLWithPath: appPath)
        if app.deletingLastPathComponent().standardizedFileURL == env.appsDir.standardizedFileURL,
           app.pathExtension == "app", FileManager.default.fileExists(atPath: app.path) {
            try? LaunchServices.unregister(app)
            try? FileManager.default.removeItem(at: app)
        }
    }

    private func removeCustomIcon(_ rec: ManagedProfile) {
        if let icon = rec.customIconPath.map({ URL(fileURLWithPath: $0) }),
           icon.deletingLastPathComponent().standardizedFileURL == env.iconsDir.standardizedFileURL {
            try? FileManager.default.removeItem(at: icon)
        }
    }

    // MARK: Repair

    /// Regenerates a profile's app against the currently installed Chrome (FR-07).
    @discardableResult
    public func repair(directory rawDir: String, icon: IconSource? = nil) throws -> ManagedProfile {
        let dir = try SafeNames.validateProfileDirectory(rawDir)
        var manifest = try self.manifest()
        guard var rec = manifest.profiles[dir], rec.stage >= .detached else { throw DockError.notManaged(dir) }
        let chrome = try ChromeInstallation.locate(env.chromeApp)
        let target = URL(fileURLWithPath: rec.userDataDir, isDirectory: true)
        // Icon: a newly given one, else the stored custom image, else the default (re-rendered from source,
        // never from the previous .icns, so the name band is drawn exactly once).
        var chosen: IconSource
        if case .image(let custom)? = icon {
            let kept = try Self.keepCustomIcon(custom, slug: SafeNames.slug(forProfileDirectory: dir), env: env)
            rec.customIconPath = kept.path
            chosen = .image(kept)
        } else if let icon {
            chosen = icon
        } else if let p = rec.customIconPath, FileManager.default.fileExists(atPath: p) {
            chosen = .image(URL(fileURLWithPath: p))
        } else {
            let entry = (try? LocalState.load(target.appendingPathComponent("Local State")))?.infoCache[dir] ?? [:]
            chosen = Self.defaultIcon(chromeApp: env.chromeApp, directory: dir, entry: entry)
        }
        let app = try AppBundleGenerator.generate(
            AppSpec(displayName: rec.displayName, bundleID: rec.bundleID, userDataDir: target, profileDirectory: dir,
                    icon: chosen, extraChromeArgs: env.extraChromeArgs, iconLabel: rec.displayName),
            chrome: chrome, launcher: launcher, into: env.appsDir)
        rec.appPath = app.path; rec.chromeVersion = chrome.version; rec.stage = .complete
        manifest.profiles[dir] = rec
        try manifest.save(env.manifestURL)
        return rec
    }

    /// Profiles whose app was built from a different Chrome version than the one installed.
    public func outdated() throws -> [ManagedProfile] {
        let current = try ChromeInstallation.locate(env.chromeApp).version
        return try manifest().profiles.values.filter { $0.stage == .complete && $0.chromeVersion != current }
            .sorted { $0.directory < $1.directory }
    }

    /// Copies a user-chosen image into ProfileDock/Icons (the original may move or be deleted later).
    static func keepCustomIcon(_ source: URL, slug: String, env: DockEnvironment) throws -> URL {
        let fm = FileManager.default
        try fm.createDirectory(at: env.iconsDir, withIntermediateDirectories: true)
        let ext = source.pathExtension.isEmpty ? "img" : source.pathExtension.lowercased()
        let dest = env.iconsDir.appendingPathComponent("\(slug).\(ext)")
        if dest.standardizedFileURL == source.standardizedFileURL { return dest }
        let tmp = env.iconsDir.appendingPathComponent(".\(UUID().uuidString)")
        try fm.copyItem(at: source, to: tmp)
        _ = try fm.replaceItemAt(dest, withItemAt: tmp)
        return dest
    }

    /// Chrome's logo with the name band in the profile's Chrome colour (or a colour derived from its folder,
    /// so two profiles with the same name still differ).
    static func defaultIcon(chromeApp: URL, directory: String, entry: [String: Any]) -> IconSource {
        .chrome(chromeApp, color: IconGenerator.profileColor(directory: directory,
                                                             chromeColor: ChromeDiscovery.colorValue(entry["profile_highlight_color"])))
    }

    /// Display names become app names ("Chrome - <name>.app"), so they must be unique among managed profiles:
    /// a second "Devendra" becomes "Devendra (ranedk)" (email name), else "Devendra (Profile 12)".
    func uniqueDisplayName(_ base: String, email: String?, directory: String, manifest: Manifest) throws -> String {
        func taken(_ name: String) throws -> Bool {
            let appName = try SafeNames.appName(for: name).lowercased()
            if manifest.profiles.values.contains(where: { $0.directory != directory && (try? SafeNames.appName(for: $0.displayName).lowercased()) == appName }) { return true }
            // An app we did not record (e.g. made by hand) must never be replaced either.
            return FileManager.default.fileExists(atPath: env.appsDir.appendingPathComponent(appName + ".app").path)
                && !manifest.profiles.values.contains { $0.appPath.map { URL(fileURLWithPath: $0).lastPathComponent.lowercased() } == appName + ".app" }
        }
        var candidates = [base]
        if let local = email?.split(separator: "@").first, !local.isEmpty { candidates.append("\(base) (\(local))") }
        candidates.append("\(base) (\(directory))")
        for c in candidates where try !taken(c) { return c }
        throw DockError.destinationExists(env.appsDir.appendingPathComponent(try SafeNames.appName(for: base) + ".app").path)
    }
}
