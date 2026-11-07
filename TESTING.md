# Testing on your Mac (Apple Silicon)

Run everything from the repo folder in Terminal. Nothing below touches your real Chrome
data until step 5, and step 5 is a dry run unless you add `--yes`.

1. **Check your setup:** `./scripts/check_mac.sh`
   If Swift is missing: `xcode-select --install` (or install Xcode from the App Store).
2. **Run the automated tests:** `swift test`
   The suite uses temporary folders, not your Chrome profiles. Send me any failure output.
3. **Build the CLI and the menu-bar app:**
   `swift build` then `./scripts/build_app.sh` (creates `dist/ProfileDock.app`).
4. **See what it finds (read-only):** `swift run profiledock discover`
5. **Dry-run one profile:** `swift run profiledock migrate "Profile 1"`
   Quit Chrome fully first. Only when the dry run looks right, add `--yes`.
   Undo anytime: `swift run profiledock rollback "Profile 1" --yes`
6. **Check:** the new app appears in ~/Applications/ProfileDock, opens with its own Dock icon
   and Cmd-Tab entry, and you are still signed in.

Back up `~/Library/Application Support/Google/Chrome` before step 5 to be safe.
Report: macOS version, `swift --version`, and the exact output of any failing step.
