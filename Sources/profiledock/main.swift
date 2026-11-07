// profiledock — command-line front end to ProfileDockCore (used for E2E tests and power users).
import Foundation
import ProfileDockCore

let usage = """
usage: profiledock [global options] <command> [args]

commands:
  discover                       list Chrome profiles (read-only)
  status                         list managed profiles and outdated apps
  migrate <profile-dir> [--name N] [--icon IMAGE] [--yes]
                                 move a profile into its own app (dry run without --yes)
  migrate --all [--yes]          every profile: Default in place (nothing moved), the rest moved
  adopt <profile-dir> [--yes]    app for a profile left inside Chrome's own folder (nothing moved)
  rollback <profile-dir> [--yes] restore the profile to Chrome and remove its app
  repair <profile-dir>|--all [--icon IMAGE]
                                 regenerate apps against the installed Chrome (optionally new icon)
  dev-app --name N --bundle-id ID --user-data-dir DIR [--profile P]
                                 build an unmanaged app (test seeding only)

global options:
  --chrome-data DIR   Chrome user-data-dir (default: ~/Library/Application Support/Google/Chrome)
  --chrome-app APP    Chrome.app (default: /Applications/Google Chrome.app)
  --support-dir DIR   ProfileDock state (default: ~/Library/Application Support/ProfileDock)
  --apps-dir DIR      generated apps (default: ~/Applications/ProfileDock)
  --bundle-prefix P   bundle id prefix for generated apps
  --mock-keychain     TESTS ONLY: generated apps use Chrome's mock keychain
"""

func fail(_ msg: String, code: Int32 = 1) -> Never {
    FileHandle.standardError.write((msg + "\n").data(using: .utf8)!)
    exit(code)
}

var args = Array(CommandLine.arguments.dropFirst())
var env = DockEnvironment.standard
var positional: [String] = []
var flags: [String: String] = [:]
var switches: Set<String> = []
let valueOptions: Set<String> = ["--chrome-data", "--chrome-app", "--support-dir", "--apps-dir", "--bundle-prefix",
                                 "--name", "--icon", "--bundle-id", "--user-data-dir", "--profile"]
while !args.isEmpty {
    let a = args.removeFirst()
    if valueOptions.contains(a) {
        guard !args.isEmpty else { fail("\(a) needs a value") }
        flags[a] = args.removeFirst()
    } else if ["--yes", "--all", "--mock-keychain"].contains(a) {
        switches.insert(a)
    } else if a.hasPrefix("-") {
        // Never ignore an unknown option: a dropped --chrome-data would silently target the real Chrome dir.
        fail("unknown option: \(a.debugDescription)\n\n\(usage)", code: 64)
    } else { positional.append(a) }
}
func path(_ s: String) -> URL { URL(fileURLWithPath: (s as NSString).expandingTildeInPath).standardizedFileURL }
if let v = flags["--chrome-data"] { env.chromeUserDataDir = path(v) }
if let v = flags["--chrome-app"] { env.chromeApp = path(v) }
if let v = flags["--support-dir"] { env.supportDir = path(v) }
if let v = flags["--apps-dir"] { env.appsDir = path(v) }
if let v = flags["--bundle-prefix"] { env.bundleIDPrefix = v }
if switches.contains("--mock-keychain") { env.extraChromeArgs.append("--use-mock-keychain") }

// The launcher stub is built alongside this binary by `swift build`.
let launcher = URL(fileURLWithPath: CommandLine.arguments[0]).resolvingSymlinksInPath()
    .deletingLastPathComponent().appendingPathComponent("ProfileLauncher")
let migrator = ProfileMigrator(env: env, launcher: launcher)

do {
    switch positional.first {
    case "discover":
        let r = try ChromeDiscovery.discover(userDataDir: env.chromeUserDataDir)
        let managed = try migrator.manifest().profiles
        for p in r.profiles {
            let state = !p.existsOnDisk ? "missing" : managed[p.directory] != nil ? "managed" : "available"
            print("\(p.directory)\t\(p.name)\t\(p.email ?? "-")\t\(state)")
        }
        for s in r.skipped { print("skipped unsafe entry: \(s.debugDescription)") }

    case "status":
        let m = try migrator.manifest()
        let outdated = Set((try? migrator.outdated())?.map(\.directory) ?? [])
        if m.profiles.isEmpty { print("no managed profiles") }
        for (_, r) in m.profiles.sorted(by: { $0.key < $1.key }) {
            let state = r.isInPlace ? (outdated.contains(r.directory) ? "needs repair (in place)" : "ready (in place)") : r.stage != .complete ? "INCOMPLETE(\(r.stage)) — run rollback" : outdated.contains(r.directory) ? "needs repair" : "ready"
            print("\(r.directory)\t\(r.displayName)\t\(r.bundleID)\tchrome \(r.chromeVersion ?? "?")\t\(state)\n  app: \(r.appPath ?? "-")\n  data: \(r.userDataDir)")
        }

    case "migrate" where switches.contains("--all"):
        guard switches.contains("--yes") else {
            print("Would give every Chrome profile its own app: Default in place (nothing moved), every other profile moved out of Chrome. Re-run with --yes.")
            break
        }
        let r = try migrator.giveAllOwnApps()
        for p in r.done { print("ok\t\(p.directory)\t\(p.displayName)\t\(p.isInPlace ? "in place" : "moved")\t\(p.appPath ?? "-")") }
        for f in r.failed { print("FAILED\t\(f.directory)\t\(f.error)") }
        if !r.failed.isEmpty { exit(1) }

    case "adopt":
        guard positional.count == 2 else { fail(usage, code: 64) }
        guard switches.contains("--yes") else {
            print("Would create an app for \"\(positional[1])\" that uses Chrome's own folder (nothing moved). Re-run with --yes.")
            break
        }
        let r = try migrator.adoptInPlace(directory: positional[1], options: .init(displayName: flags["--name"], icon: flags["--icon"].map { IconSource.image(path($0)) }))
        print("adopted \(r.directory) -> \(r.appPath ?? "?")")

    case "migrate":
        guard positional.count == 2 else { fail(usage, code: 64) }
        let dir = positional[1]
        if !switches.contains("--yes") {
            print("""
            Plan (dry run, nothing changed):
              1. Check Chrome is not using \(env.chromeUserDataDir.path)
              2. Back up Chrome's Local State to \(env.backupDir.path)
              3. Move \(env.chromeUserDataDir.appendingPathComponent(dir).path)
                 -> \(env.userDataRoot.path)/<slug>/\(dir)   (rename on the same volume, no copy)
              4. Remove "\(dir)" from Chrome's profile list (Local State)
              5. Generate its app in \(env.appsDir.path)
            Undo any time with: profiledock rollback "\(dir)" --yes
            Re-run with --yes to perform it.
            """)
            break
        }
        let icon = flags["--icon"].map { IconSource.image(path($0)) }
        let r = try migrator.migrate(directory: dir, options: .init(displayName: flags["--name"], icon: icon))
        print("migrated \(r.directory) -> \(r.appPath ?? "?")\n  data: \(r.userDataDir)\n  Local State backup: \(r.localStateBackup)")

    case "rollback", "remove":
        guard positional.count == 2 else { fail(usage, code: 64) }
        guard switches.contains("--yes") else {
            print("Would delete the generated app and move \"\(positional[1])\" back into Chrome. Re-run with --yes.")
            break
        }
        try migrator.rollback(directory: positional[1])
        print("restored \(positional[1]) to \(env.chromeUserDataDir.path)")

    case "repair":
        let dirs: [String]
        if switches.contains("--all") { dirs = try migrator.manifest().profiles.keys.sorted() }
        else if positional.count == 2 { dirs = [positional[1]] }
        else { fail(usage, code: 64) }
        let newIcon = flags["--icon"].map { IconSource.image(path($0)) }
        for d in dirs { let r = try migrator.repair(directory: d, icon: newIcon); print("repaired \(d) (chrome \(r.chromeVersion ?? "?"))") }

    case "dev-app":
        guard let name = flags["--name"], let id = flags["--bundle-id"], let udd = flags["--user-data-dir"] else { fail(usage, code: 64) }
        let app = try AppBundleGenerator.generate(
            AppSpec(displayName: name, bundleID: id, userDataDir: path(udd), profileDirectory: flags["--profile"] ?? "Default",
                    icon: .chrome(env.chromeApp, color: IconGenerator.defaultColor(for: name)),
                    extraChromeArgs: env.extraChromeArgs, iconLabel: name),
            chrome: try ChromeInstallation.locate(env.chromeApp), launcher: launcher, into: env.appsDir)
        print(app.path)

    default:
        fail(usage, code: 64)
    }
} catch {
    fail("error: \(error)")
}
