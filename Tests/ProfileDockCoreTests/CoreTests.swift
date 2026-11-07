import AppKit
import Foundation
import Testing
@testable import ProfileDockCore

// MARK: Helpers

func tempDir() -> URL {
    let u = FileManager.default.temporaryDirectory.appendingPathComponent("pd-test-\(UUID().uuidString)", isDirectory: true)
    try! FileManager.default.createDirectory(at: u, withIntermediateDirectories: true)
    return u
}

/// A fake Chrome user-data-dir with Local State + profile directories containing marker files.
func makeChromeFixture(_ root: URL, profiles: [String: String], extraKeys: [String: Any] = [:]) throws {
    var cache: [String: Any] = [:]
    for (dir, name) in profiles {
        cache[dir] = ["name": name, "user_name": "\(name.lowercased())@example.com", "profile_highlight_color": -14_576_664]
        let p = root.appendingPathComponent(dir)
        try FileManager.default.createDirectory(at: p, withIntermediateDirectories: true)
        try "cookies-of-\(dir)".write(to: p.appendingPathComponent("Cookies"), atomically: true, encoding: .utf8)
    }
    var state: [String: Any] = ["profile": ["info_cache": cache, "profiles_order": profiles.keys.sorted(),
                                            "last_used": profiles.keys.sorted().first ?? ""],
                                "browser": ["unknown_key": 42]]
    for (k, v) in extraKeys { state[k] = v }
    try JSONSerialization.data(withJSONObject: state).write(to: root.appendingPathComponent("Local State"))
}

// MARK: SafeNames

@Test(arguments: ["../x", "..", ".", "", "a/b", "Guest Profile", "System Profile", ".hidden", "a\0b", "x:y"])
func rejectsUnsafeProfileDirectories(_ name: String) {
    #expect(throws: SafeNameError.self) { try SafeNames.validateProfileDirectory(name) }
}

@Test(arguments: ["Default", "Profile 1", "Profile 13", "Ünïcødé 個人"])
func acceptsNormalProfileDirectories(_ name: String) throws {
    #expect(try SafeNames.validateProfileDirectory(name) == name)
}

@Test func slugsAreStableAsciiAndUnique() {
    #expect(SafeNames.slug(forProfileDirectory: "Default") == "default")
    #expect(SafeNames.slug(forProfileDirectory: "Profile 13") == "profile-13")
    let a = SafeNames.slug(forProfileDirectory: "個人"), b = SafeNames.slug(forProfileDirectory: "仕事")
    #expect(a != b && a.allSatisfy { $0.isASCII })
    #expect(SafeNames.bundleIdentifier(prefix: "x.y", slug: "profile-1") == "x.y.profile-1")
}

@Test func appNamesStripPathCharactersAndKeepUnicode() throws {
    #expect(try SafeNames.appName(for: "Work") == "Chrome - Work")
    #expect(try SafeNames.appName(for: "../../etc/passwd") == "Chrome - etc passwd")
    #expect(try SafeNames.appName(for: "Café  \n Ünïcode") == "Chrome - Café Ünïcode")
    #expect(throws: SafeNameError.self) { try SafeNames.appName(for: " / ") }
    #expect(SafeNames.initials("Personal Stuff") == "PS")
    #expect(SafeNames.initials("") == "?")
}

// MARK: LocalState / discovery

@Test func localStateRemoveAndRestorePreservesUnknownKeys() throws {
    let d = tempDir(); defer { try? FileManager.default.removeItem(at: d) }
    try makeChromeFixture(d, profiles: ["Default": "Personal", "Profile 1": "Work"])
    let url = d.appendingPathComponent("Local State")
    var s = try LocalState.load(url)
    let entry = s.removeProfile("Default")
    #expect(entry?["name"] as? String == "Personal")
    #expect(s.infoCache.keys.sorted() == ["Profile 1"])
    #expect(s.profilesOrder == ["Profile 1"])
    #expect(s.lastUsed == "Profile 1")
    try s.save(url)
    var r = try LocalState.load(url)
    #expect((r.root["browser"] as? [String: Any])?["unknown_key"] as? Int == 42)
    r.addProfile("Default", entry: entry!)
    #expect(Set(r.infoCache.keys) == ["Default", "Profile 1"])
}

@Test func discoveryParsesProfilesAndSkipsUnsafeEntries() throws {
    let d = tempDir(); defer { try? FileManager.default.removeItem(at: d) }
    try makeChromeFixture(d, profiles: ["Default": "Personal", "Profile 2": "Wörk 仕事"])
    var s = try LocalState.load(d.appendingPathComponent("Local State"))
    s.addProfile("../escape", entry: ["name": "evil"])
    s.addProfile("Profile 9", entry: ["name": ""]) // listed but missing on disk, empty name
    try s.save(d.appendingPathComponent("Local State"))

    let r = try ChromeDiscovery.discover(userDataDir: d)
    #expect(r.skipped == ["../escape"])
    let byDir = Dictionary(uniqueKeysWithValues: r.profiles.map { ($0.directory, $0) })
    #expect(byDir["Profile 2"]?.name == "Wörk 仕事")
    #expect(byDir["Default"]?.email == "personal@example.com")
    #expect(byDir["Default"]?.color == UInt32(truncatingIfNeeded: Int64(-14_576_664)) & 0xFFFFFF)
    #expect(byDir["Profile 9"]?.existsOnDisk == false)
    #expect(byDir["Profile 9"]?.name == "Profile 9")
}

@Test func discoveryReportsInvalidJSON() throws {
    let d = tempDir(); defer { try? FileManager.default.removeItem(at: d) }
    try "{not json".write(to: d.appendingPathComponent("Local State"), atomically: true, encoding: .utf8)
    #expect(throws: LocalStateError.self) { try ChromeDiscovery.discover(userDataDir: d) }
    #expect(throws: LocalStateError.self) { try ChromeDiscovery.discover(userDataDir: d.appendingPathComponent("nope")) }
}

// MARK: Generator / manifest

@Test func infoPlistStripsUpdaterAndHandlerKeys() {
    let base: [String: Any] = ["CFBundleIdentifier": "com.google.Chrome", "KSProductID": "com.google.Chrome",
                               "CFBundleURLTypes": [[:]], "SMPrivilegedExecutables": [:], "NSPrincipalClass": "BrowserCrApplication"]
    let spec = AppSpec(displayName: "Work", bundleID: "x.work", userDataDir: URL(fileURLWithPath: "/tmp/u d"),
                       profileDirectory: "Profile 1", icon: .initials("W", color: 0))
    let p = AppBundleGenerator.makeInfoPlist(base: base, spec: spec, appName: "Chrome - Work", chromeVersion: "1.2.3")
    #expect(p["KSProductID"] == nil && p["CFBundleURLTypes"] == nil && p["SMPrivilegedExecutables"] == nil)
    #expect(p["CFBundleIdentifier"] as? String == "x.work")
    #expect(p["CFBundleExecutable"] as? String == "ProfileLauncher")
    #expect(p["PNUserDataDir"] as? String == "/tmp/u d")
    #expect(p["PNProfileDirectory"] as? String == "Profile 1")
    #expect(p["NSPrincipalClass"] as? String == "BrowserCrApplication")
}

@Test func manifestRoundTrips() throws {
    let d = tempDir(); defer { try? FileManager.default.removeItem(at: d) }
    var m = Manifest()
    m.profiles["Default"] = ManagedProfile(directory: "Default", displayName: "P", bundleID: "x.default", appPath: nil,
        userDataDir: "/a", sourceUserDataDir: "/b", chromeVersion: "1", stage: .moved,
        migratedAt: Date(timeIntervalSince1970: 1_700_000_000), localStateBackup: "/c", originalInfoCacheEntry: Data("{}".utf8))
    try m.save(d.appendingPathComponent("m.json"))
    let r = try Manifest.load(d.appendingPathComponent("m.json"))
    #expect(r.profiles == m.profiles)
    #expect(try Manifest.load(d.appendingPathComponent("missing.json")).profiles.isEmpty)
}

@Test func iconGeneratorWritesICNS() throws {
    let d = tempDir(); defer { try? FileManager.default.removeItem(at: d) }
    let out = d.appendingPathComponent("a.icns")
    try IconGenerator.makeICNS(.initials("PW", color: 0x1A73E8), to: out)
    let data = try Data(contentsOf: out)
    #expect(data.prefix(4) == Data("icns".utf8))
    #expect(data.count > 10_000) // includes 1024px rep
}

// MARK: Migration (filesystem-level, disposable fixtures)

func makeEnv(_ root: URL) throws -> DockEnvironment {
    let chromeData = root.appendingPathComponent("ChromeData")
    try FileManager.default.createDirectory(at: chromeData, withIntermediateDirectories: true)
    return DockEnvironment(chromeUserDataDir: chromeData, chromeApp: URL(fileURLWithPath: "/Applications/Google Chrome.app"),
                           supportDir: root.appendingPathComponent("Support"), appsDir: root.appendingPathComponent("Apps"),
                           bundleIDPrefix: "cc.ayush.profiledock.unittest.\(UUID().uuidString.prefix(8).lowercased())")
}

@Test func migrationRefusesWhileChromeHoldsTheLock() throws {
    let root = tempDir(); defer { try? FileManager.default.removeItem(at: root) }
    let env = try makeEnv(root)
    try makeChromeFixture(env.chromeUserDataDir, profiles: ["Default": "Personal"])
    try FileManager.default.createSymbolicLink(atPath: env.chromeUserDataDir.appendingPathComponent("SingletonLock").path,
                                               withDestinationPath: "host-\(getpid())")
    let m = ProfileMigrator(env: env, launcher: URL(fileURLWithPath: "/usr/bin/true"))
    #expect(throws: DockError.self) { try m.migrate(directory: "Default") }
    #expect(FileManager.default.fileExists(atPath: env.chromeUserDataDir.appendingPathComponent("Default/Cookies").path))
    #expect(try m.manifest().profiles.isEmpty)
}

@Test func failedMigrationRollsBackCompletely() throws {
    guard FileManager.default.fileExists(atPath: "/Applications/Google Chrome.app") else { return }
    let root = tempDir(); defer { try? FileManager.default.removeItem(at: root) }
    let env = try makeEnv(root)
    try makeChromeFixture(env.chromeUserDataDir, profiles: ["Default": "Personal", "Profile 1": "Work"])
    let before = try Data(contentsOf: env.chromeUserDataDir.appendingPathComponent("Local State"))
    // Missing launcher makes the final (app generation) step fail after the profile was moved.
    let m = ProfileMigrator(env: env, launcher: root.appendingPathComponent("no-launcher"))
    #expect(throws: DockError.self) { try m.migrate(directory: "Profile 1") }

    let fm = FileManager.default
    #expect(try String(contentsOf: env.chromeUserDataDir.appendingPathComponent("Profile 1/Cookies")) == "cookies-of-Profile 1")
    let after = try LocalState.load(env.chromeUserDataDir.appendingPathComponent("Local State"))
    let orig = try LocalState(root: JSONSerialization.jsonObject(with: before) as! [String: Any])
    #expect(Set(after.infoCache.keys) == Set(orig.infoCache.keys))
    #expect(try m.manifest().profiles.isEmpty)
    #expect(!fm.fileExists(atPath: env.userDataRoot.appendingPathComponent("profile-1").path))
    #expect((try? fm.contentsOfDirectory(atPath: env.appsDir.path))?.isEmpty ?? true)
}

@Test func migrateThenRollbackRestoresEverything() throws {
    guard FileManager.default.fileExists(atPath: "/Applications/Google Chrome.app") else { return }
    let root = tempDir(); defer { try? FileManager.default.removeItem(at: root) }
    let env = try makeEnv(root)
    try makeChromeFixture(env.chromeUserDataDir, profiles: ["Default": "Personal", "Profile 1": "Work"])
    let launcher = URL(fileURLWithPath: "/usr/bin/true") // any executable; the app is not launched here
    let m = ProfileMigrator(env: env, launcher: launcher)
    let fm = FileManager.default

    let rec = try m.migrate(directory: "Profile 1")
    #expect(rec.stage == .complete)
    let moved = URL(fileURLWithPath: rec.userDataDir).appendingPathComponent("Profile 1/Cookies")
    #expect(try String(contentsOf: moved) == "cookies-of-Profile 1")           // moved, intact
    #expect(!fm.fileExists(atPath: env.chromeUserDataDir.appendingPathComponent("Profile 1").path))
    #expect(try LocalState.load(env.chromeUserDataDir.appendingPathComponent("Local State")).infoCache["Profile 1"] == nil)
    let appState = try LocalState.load(URL(fileURLWithPath: rec.userDataDir).appendingPathComponent("Local State"))
    #expect(appState.infoCache.keys.sorted() == ["Profile 1"] && appState.lastUsed == "Profile 1")
    #expect(fm.fileExists(atPath: rec.localStateBackup))
    let app = URL(fileURLWithPath: rec.appPath!)
    #expect(app.lastPathComponent == "Chrome - Work.app")
    #expect(AppBundleGenerator.builtVersion(of: app) == rec.chromeVersion)
    #expect(fm.isExecutableFile(atPath: app.appendingPathComponent("Contents/MacOS/ProfileLauncher").path))
    _ = try Tool.run("/usr/bin/codesign", ["--verify", app.appendingPathComponent("Contents/MacOS/Google Chrome").path])
    #expect(try m.outdated().isEmpty)
    #expect(throws: DockError.self) { try m.migrate(directory: "Profile 1") } // already managed / gone

    try m.rollback(directory: "Profile 1")
    #expect(try String(contentsOf: env.chromeUserDataDir.appendingPathComponent("Profile 1/Cookies")) == "cookies-of-Profile 1")
    #expect(try LocalState.load(env.chromeUserDataDir.appendingPathComponent("Local State")).infoCache["Profile 1"]?["name"] as? String == "Work")
    #expect(!fm.fileExists(atPath: app.path))
    #expect(!fm.fileExists(atPath: rec.userDataDir))
    #expect(try m.manifest().profiles.isEmpty)
    // The untouched profile never moved.
    #expect(try String(contentsOf: env.chromeUserDataDir.appendingPathComponent("Default/Cookies")) == "cookies-of-Default")
}

// MARK: Name band + manifest compatibility

@Test func iconNameBandIsDrawnAtLargeSizesOnly() throws {
    let source = IconSource.initials("W", color: 0xFFFFFF) // white background: the dark band is easy to detect
    let labeled = try IconGenerator.render(source, label: "Work Account")
    func pixel(_ img: NSImage, size: Int, x: Double, y: Double) throws -> CGFloat {
        let rep = NSBitmapImageRep(data: try IconGenerator.png(img, size: size))!
        let c = rep.colorAt(x: Int(Double(size) * x), y: Int(Double(size) * y))!.usingColorSpace(.deviceRGB)!
        return c.redComponent
    }
    // Bitmap y runs top-down: 0.85 is inside the bottom band, 0.3 is the art area. 0.17 is the band's left edge.
    #expect(try pixel(labeled, size: 256, x: 0.17, y: 0.85) < 0.7)
    #expect(try pixel(labeled, size: 256, x: 0.17, y: 0.3) > 0.95)
    let plain = try IconGenerator.render(source, label: nil)
    #expect(try pixel(plain, size: 256, x: 0.17, y: 0.85) > 0.95)
    // Whitespace-only labels draw no band.
    #expect(try pixel(IconGenerator.render(source, label: "   "), size: 256, x: 0.17, y: 0.85) > 0.95)
    // Long names still render (shrunk/truncated) without throwing.
    let d = tempDir(); defer { try? FileManager.default.removeItem(at: d) }
    try IconGenerator.makeICNS(source, label: String(repeating: "Very long profile name ", count: 6),
                               to: d.appendingPathComponent("x.icns"))
}

@Test func manifestWithoutCustomIconFieldStillLoads() throws {
    let d = tempDir(); defer { try? FileManager.default.removeItem(at: d) }
    let json = """
    {"version":1,"profiles":{"Default":{"directory":"Default","displayName":"P","bundleID":"x.d",
     "userDataDir":"/a","sourceUserDataDir":"/b","chromeVersion":"1","stage":4,
     "migratedAt":"2026-11-05T08:00:50Z","localStateBackup":"/c","originalInfoCacheEntry":"e30="}}}
    """
    try json.write(to: d.appendingPathComponent("m.json"), atomically: true, encoding: .utf8)
    let m = try Manifest.load(d.appendingPathComponent("m.json"))
    #expect(m.profiles["Default"]?.customIconPath == nil)
    #expect(m.profiles["Default"]?.stage == .complete)
}

// MARK: Menu-bar overview

@Test func overviewMergesChromeProfilesAndManagedApps() throws {
    guard FileManager.default.fileExists(atPath: "/Applications/Google Chrome.app") else { return }
    let root = tempDir(); defer { try? FileManager.default.removeItem(at: root) }
    let env = try makeEnv(root)
    try makeChromeFixture(env.chromeUserDataDir, profiles: ["Default": "Personal", "Profile 1": "Work", "Profile 9": "Gone"])
    try FileManager.default.removeItem(at: env.chromeUserDataDir.appendingPathComponent("Profile 9"))
    let m = ProfileMigrator(env: env, launcher: URL(fileURLWithPath: "/usr/bin/true"))
    try m.migrate(directory: "Profile 1")

    var o = Overview.build(env: env, isRunning: { _ in false })
    #expect(o.problems.isEmpty && o.chromePID == nil && o.chromeVersion != nil)
    let byDir = Dictionary(uniqueKeysWithValues: o.rows.map { ($0.directory, $0) })
    #expect(o.rows.count == 3)
    #expect(byDir["Profile 1"]?.state == .ready && byDir["Profile 1"]?.name == "Work" && byDir["Profile 1"]?.isManaged == true)
    #expect(byDir["Default"]?.state == .available && byDir["Default"]?.isManaged == false)
    #expect(byDir["Profile 9"]?.state == .missingOnDisk)

    // An app built for another Chrome version shows as needing repair; an interrupted one as incomplete.
    var manifest = try m.manifest()
    manifest.profiles["Profile 1"]?.chromeVersion = "1.0"
    try manifest.save(env.manifestURL)
    o = Overview.build(env: env, isRunning: { _ in true })
    #expect(o.rows.first { $0.directory == "Profile 1" }?.state == .needsRepair)
    #expect(o.rows.first { $0.directory == "Profile 1" }?.isRunning == true)
    manifest.profiles["Profile 1"]?.stage = .moved
    try manifest.save(env.manifestURL)
    o = Overview.build(env: env, isRunning: { _ in false })
    #expect(o.rows.first { $0.directory == "Profile 1" }?.state == .incomplete(.moved))

    // Chrome open is reported (it disables "Give Own App").
    try FileManager.default.createSymbolicLink(atPath: env.chromeUserDataDir.appendingPathComponent("SingletonLock").path,
                                               withDestinationPath: "host-\(getpid())")
    #expect(Overview.build(env: env, isRunning: { _ in false }).chromePID == getpid())

    manifest.profiles["Profile 1"]?.stage = .complete
    try manifest.save(env.manifestURL)
    try FileManager.default.removeItem(at: env.chromeUserDataDir.appendingPathComponent("SingletonLock"))
    try m.rollback(directory: "Profile 1")
}

@Test func overviewReportsUnreadableChromeData() throws {
    let root = tempDir(); defer { try? FileManager.default.removeItem(at: root) }
    var env = try makeEnv(root)
    env.chromeApp = root.appendingPathComponent("NoChrome.app")
    let o = Overview.build(env: env, isRunning: { _ in false })
    #expect(o.rows.isEmpty && o.chromeVersion == nil && o.problems.count == 2)
}

// MARK: Chrome-logo icons, unique names, main profile in place, every profile

@Test func chromeIconDrawsLogoAndColouredBand() throws {
    guard FileManager.default.fileExists(atPath: "/Applications/Google Chrome.app") else { return }
    let img = try IconGenerator.render(.chrome(URL(fileURLWithPath: "/Applications/Google Chrome.app"), color: 0xD93025), label: "Work")
    let rep = NSBitmapImageRep(data: try IconGenerator.png(img, size: 256))!
    func rgb(_ x: Double, _ y: Double) -> (CGFloat, CGFloat, CGFloat) {
        let c = rep.colorAt(x: Int(256 * x), y: Int(256 * y))!.usingColorSpace(.deviceRGB)!
        return (c.redComponent, c.greenComponent, c.blueComponent)
    }
    let band = rgb(0.17, 0.85)                       // band takes the profile colour (red)
    #expect(band.0 > 0.7 && band.1 < 0.35 && band.2 < 0.35)
    let corner = rgb(0.2, 0.2)                       // white tile around the logo
    #expect(corner.0 > 0.95 && corner.1 > 0.95 && corner.2 > 0.95)
    let middle = rgb(0.5, 0.375)                     // logo centre is Chrome blue
    #expect(middle.2 > 0.7 && middle.0 < 0.4)
    #expect(IconGenerator.luminance(0xFFFFFF) > 0.99 && IconGenerator.luminance(0x000000) < 0.01)
    #expect(throws: DockError.self) { try IconGenerator.render(.chrome(URL(fileURLWithPath: "/nope.app"), color: 0), label: nil) }
}

@Test func sameNamedProfilesGetDistinctApps() throws {
    guard FileManager.default.fileExists(atPath: "/Applications/Google Chrome.app") else { return }
    let root = tempDir(); defer { try? FileManager.default.removeItem(at: root) }
    let env = try makeEnv(root)
    try makeChromeFixture(env.chromeUserDataDir, profiles: ["Profile 11": "Devendra", "Profile 12": "Devendra"])
    let m = ProfileMigrator(env: env, launcher: URL(fileURLWithPath: "/usr/bin/true"))
    let a = try m.migrate(directory: "Profile 11")
    let b = try m.migrate(directory: "Profile 12")
    #expect(a.displayName == "Devendra")
    #expect(b.displayName == "Devendra (devendra)")
    #expect(a.appPath != b.appPath)
    #expect(FileManager.default.fileExists(atPath: a.appPath!) && FileManager.default.fileExists(atPath: b.appPath!))
    try m.rollback(directory: "Profile 12"); try m.rollback(directory: "Profile 11")
}

@Test func mainProfileInPlaceMovesNothingAndRollsBackToAppOnly() throws {
    guard FileManager.default.fileExists(atPath: "/Applications/Google Chrome.app") else { return }
    let root = tempDir(); defer { try? FileManager.default.removeItem(at: root) }
    let env = try makeEnv(root)
    try makeChromeFixture(env.chromeUserDataDir, profiles: ["Default": "Person 1", "Profile 1": "Work"])
    let localState = env.chromeUserDataDir.appendingPathComponent("Local State")
    let before = try Data(contentsOf: localState)
    // Works while Chrome is open: nothing is moved or edited.
    try FileManager.default.createSymbolicLink(atPath: env.chromeUserDataDir.appendingPathComponent("SingletonLock").path,
                                               withDestinationPath: "host-\(getpid())")
    let m = ProfileMigrator(env: env, launcher: URL(fileURLWithPath: "/usr/bin/true"))
    let rec = try m.adoptInPlace(directory: "Default")
    #expect(rec.isInPlace && rec.stage == .complete && rec.userDataDir == env.chromeUserDataDir.path)
    #expect(try Data(contentsOf: localState) == before)
    #expect(try String(contentsOf: env.chromeUserDataDir.appendingPathComponent("Default/Cookies")) == "cookies-of-Default")
    let plist = NSDictionary(contentsOf: URL(fileURLWithPath: rec.appPath!).appendingPathComponent("Contents/Info.plist"))!
    #expect(plist["PNUserDataDir"] as? String == env.chromeUserDataDir.path)
    #expect(plist["PNProfileDirectory"] as? String == "Default")
    #expect(throws: DockError.self) { try m.adoptInPlace(directory: "Profile 1") } // only one in place
    #expect(Overview.build(env: env, isRunning: { _ in false }).rows.first { $0.directory == "Default" }?.isInPlace == true)
    _ = try m.repair(directory: "Default")
    try m.rollback(directory: "Default") // allowed with Chrome open; removes only the app
    #expect(!FileManager.default.fileExists(atPath: rec.appPath!))
    #expect(try Data(contentsOf: localState) == before)
    #expect(try String(contentsOf: env.chromeUserDataDir.appendingPathComponent("Default/Cookies")) == "cookies-of-Default")
    #expect(try m.manifest().profiles.isEmpty)
}

@Test func everyProfileGetsAnAppAndAllRollBack() throws {
    guard FileManager.default.fileExists(atPath: "/Applications/Google Chrome.app") else { return }
    let root = tempDir(); defer { try? FileManager.default.removeItem(at: root) }
    let env = try makeEnv(root)
    try makeChromeFixture(env.chromeUserDataDir, profiles: ["Default": "Person 1", "Profile 1": "Work", "Profile 2": "Work"])
    let m = ProfileMigrator(env: env, launcher: URL(fileURLWithPath: "/usr/bin/true"))
    let lock = env.chromeUserDataDir.appendingPathComponent("SingletonLock").path
    try FileManager.default.createSymbolicLink(atPath: lock, withDestinationPath: "host-\(getpid())")
    #expect(throws: DockError.self) { try m.giveAllOwnApps() }           // Chrome open: nothing happens
    #expect(try m.manifest().profiles.isEmpty)
    try FileManager.default.removeItem(atPath: lock)

    let r = try m.giveAllOwnApps()
    #expect(r.failed.isEmpty && r.done.count == 3)
    let man = try m.manifest().profiles
    #expect(man["Default"]?.isInPlace == true && man["Profile 1"]?.isInPlace != true)
    #expect(Set(man.values.map(\.displayName)) == ["Person 1", "Work", "Work (work)"])
    #expect(FileManager.default.fileExists(atPath: env.chromeUserDataDir.appendingPathComponent("Default").path))
    #expect(!FileManager.default.fileExists(atPath: env.chromeUserDataDir.appendingPathComponent("Profile 1").path))
    #expect(try m.giveAllOwnApps().done.isEmpty)                         // idempotent
    for d in ["Default", "Profile 1", "Profile 2"] { try m.rollback(directory: d) }
    for d in ["Default", "Profile 1", "Profile 2"] {
        #expect(try String(contentsOf: env.chromeUserDataDir.appendingPathComponent("\(d)/Cookies")) == "cookies-of-\(d)")
    }
    #expect(try LocalState.load(env.chromeUserDataDir.appendingPathComponent("Local State")).infoCache.count == 3)
}

@Test func profileColoursAreDistinctAndRespectVividThemes() {
    let dirs = ["Default", "Profile 1", "Profile 4", "Profile 5", "Profile 6", "Profile 7", "Profile 8", "Profile 11", "Profile 12", "Profile 13"]
    let darkChrome: UInt32 = 0x162312 // Chrome's default dark tone: ignored
    #expect(Set(dirs.map { IconGenerator.profileColor(directory: $0, chromeColor: darkChrome) }).count == dirs.count)
    #expect(IconGenerator.profileColor(directory: "Profile 3", chromeColor: 0xE91E63) == 0xE91E63) // vivid theme kept
    #expect(IconGenerator.profileColor(directory: "Profile 3", chromeColor: nil) == IconGenerator.profileColor(directory: "Profile 3", chromeColor: 0x1F2020))
}
