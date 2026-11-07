// Profile app launcher (spike).
// CFBundleExecutable of a generated profile app. Reads its profile config from
// its own Info.plist and execv()s the bundle-local copy of Chrome's loader.
// execv keeps the PID that LaunchServices registered under this bundle's
// identifier, so the browser process runs as this app (own Dock/Cmd-Tab entry).
import Foundation

let info = Bundle.main.infoDictionary ?? [:]
guard let userDataDir = info["PNUserDataDir"] as? String,
      let profileDir = info["PNProfileDirectory"] as? String,
      let exe = Bundle.main.executableURL?.deletingLastPathComponent()
        .appendingPathComponent("Google Chrome").path
else {
    FileHandle.standardError.write("profile app: missing PN* keys in Info.plist\n".data(using: .utf8)!)
    exit(64)
}
var args = [exe, "--user-data-dir=\(userDataDir)", "--profile-directory=\(profileDir)",
            "--no-default-browser-check", "--no-first-run"]
args += (info["PNExtraArgs"] as? [String]) ?? []
// Forward caller args (e.g. URLs) but drop legacy -psn_ process serial numbers.
args += CommandLine.arguments.dropFirst().filter { !$0.hasPrefix("-psn_") }

let cArgs = args.map { strdup($0) } + [nil]
execv(exe, cArgs)
perror("profile app: execv failed")
exit(70)
