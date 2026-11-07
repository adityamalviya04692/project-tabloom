#!/bin/bash
# Builds dist/ProfileDock.app: the menu-bar manager, with ProfileLauncher next to it.
# Ad-hoc signed (no Developer ID yet; see docs/ARCHITECTURE.md open risks).
set -euo pipefail
cd "$(dirname "$0")/.."

swift build -c release --product ProfileDockMenu
swift build -c release --product ProfileLauncher
BIN=$(swift build -c release --show-bin-path)

APP=dist/ProfileDock.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp "$BIN/ProfileDockMenu" "$APP/Contents/MacOS/ProfileDock"
cp "$BIN/ProfileLauncher" "$APP/Contents/MacOS/ProfileLauncher"

cat > "$APP/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleIdentifier</key><string>cc.ayush.profiledock</string>
  <key>CFBundleName</key><string>ProfileDock</string>
  <key>CFBundleExecutable</key><string>ProfileDock</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>0.1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
EOF

codesign --force --sign - "$APP/Contents/MacOS/ProfileLauncher"
codesign --force --sign - "$APP"
echo "$APP"
