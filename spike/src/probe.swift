// Spike validator: reports Cmd-Tab-eligible apps (activationPolicy == .regular),
// window ownership, and activation results for the spike bundles + real Chrome.
import AppKit
let ids = ["cc.ayush.profilenative.spike.personal", "cc.ayush.profilenative.spike.work", "com.google.Chrome"]
func windows(_ pid: pid_t) -> [String] {
  let list = CGWindowListCopyWindowInfo([.optionAll, .excludeDesktopElements], kCGNullWindowID) as! [[String: Any]]
  return list.filter { ($0[kCGWindowOwnerPID as String] as? pid_t) == pid && ($0[kCGWindowLayer as String] as? Int) == 0
                        && (($0[kCGWindowBounds as String] as? [String: CGFloat])?["Height"] ?? 0) > 100 }
             .map { "wid=\($0[kCGWindowNumber as String]!) onscreen=\($0[kCGWindowIsOnscreen as String] as? Bool ?? false)" }
}
for id in ids {
  for app in NSRunningApplication.runningApplications(withBundleIdentifier: id) {
    print("\(id)\n  name=\(app.localizedName ?? "?") pid=\(app.processIdentifier) policy=\(app.activationPolicy == .regular ? "regular(Cmd-Tab)" : "\(app.activationPolicy.rawValue)") icon=\(app.icon?.size ?? .zero) exe=\(app.executableURL?.lastPathComponent ?? "?")\n  windows=\(windows(app.processIdentifier))")
  }
}
if CommandLine.arguments.count > 1 {
  for id in ids.prefix(2) + ids.prefix(2) {
    guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: id).first else { continue }
    app.activate(options: [.activateAllWindows])
    RunLoop.current.run(until: Date().addingTimeInterval(1.2))
    let front = NSWorkspace.shared.frontmostApplication
    let topWin = (CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as! [[String: Any]])
                  .first { ($0[kCGWindowLayer as String] as? Int) == 0 }
    print("activate \(id) -> frontmost=\(front?.bundleIdentifier ?? "nil") topWindowOwnerPID=\(topWin?[kCGWindowOwnerPID as String] ?? "nil") (app pid \(app.processIdentifier))")
  }
}
// Icon check: sample the centre-left pixel of each app's runtime icon (what Dock/Cmd-Tab draw).
for id in ids {
  guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: id).first, let icon = app.icon,
        let cg = icon.cgImage(forProposedRect: nil, context: nil, hints: nil) else { continue }
  let rep = NSBitmapImageRep(cgImage: cg)
  let c = rep.colorAt(x: rep.pixelsWide / 5, y: rep.pixelsHigh / 2)?.usingColorSpace(.deviceRGB)
  print("icon \(id): \(rep.pixelsWide)px sample rgb=(\(Int((c?.redComponent ?? 0)*255)),\(Int((c?.greenComponent ?? 0)*255)),\(Int((c?.blueComponent ?? 0)*255)))")
}
