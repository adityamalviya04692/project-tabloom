#!/bin/bash
# Spike builder: generates two profile apps backed by DISPOSABLE user-data-dirs.
# Never touches ~/Library/Application Support/Google/Chrome.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$HERE/out"; BIN="$OUT/bin"; APPS="$OUT/apps"; DATA="$OUT/data"
CHROME="/Applications/Google Chrome.app"
mkdir -p "$BIN" "$APPS" "$DATA"

build_tools() {
swiftc -O -o "$BIN/ProfileLauncher" "$HERE/src/launcher.swift"
swiftc -O -o "$BIN/make_icon" "$HERE/src/make_icon.swift"
}

make_app() { # name bundle-suffix color letter [mock_keychain=1]
  local name="$1" id="cc.ayush.profilenative.spike.$2" color="$3" letter="$4" mock="${5:-1}"
  local app="$APPS/Chrome - $name.app" udd="$DATA/$2"
  rm -rf "$app"; mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources" "$udd"
  cp "$BIN/ProfileLauncher" "$app/Contents/MacOS/ProfileLauncher"
  cp "$CHROME/Contents/MacOS/Google Chrome" "$app/Contents/MacOS/Google Chrome"
  # Chrome's helper sandbox only allows reads under the main bundle path, so a
  # symlink to /Applications fails. Use APFS clones (copy-on-write, ~0 extra bytes)
  # of the CURRENT framework version only.
  local ver; ver=$(plutil -extract CFBundleShortVersionString raw "$CHROME/Contents/Info.plist")
  local fw="Google Chrome Framework.framework"
  mkdir -p "$app/Contents/Frameworks/$fw/Versions"
  cp -cR "$CHROME/Contents/Frameworks/$fw/Versions/$ver" "$app/Contents/Frameworks/$fw/Versions/$ver"
  ( cd "$app/Contents/Frameworks/$fw" && ln -s "$ver" Versions/Current \
      && for l in "Google Chrome Framework" Helpers Libraries Resources; do ln -s "Versions/Current/$l" "$l"; done )

  # Info.plist: start from Chrome's, strip updater/handler/type keys, set identity.
  local p="$app/Contents/Info.plist"
  cp "$CHROME/Contents/Info.plist" "$p"; plutil -convert xml1 "$p"
  for k in KSChannelID KSChannelID-full KSProductID KSUpdateURL KSVersion SMPrivilegedExecutables \
           CFBundleURLTypes CFBundleDocumentTypes UTExportedTypeDeclarations UTImportedTypeDeclarations \
           CFBundleIconName LSHasLocalizedDisplayName NSUserActivityTypes OSAScriptingDefinition \
           ASWebAuthenticationSessionWebBrowserSupportCapabilities; do
    plutil -remove "$k" "$p" 2>/dev/null || true
  done
  plutil -replace CFBundleIdentifier -string "$id" "$p"
  plutil -replace CFBundleName -string "Chrome - $name" "$p"
  plutil -replace CFBundleDisplayName -string "Chrome - $name" "$p"
  plutil -replace CFBundleExecutable -string "ProfileLauncher" "$p"
  plutil -replace CFBundleIconFile -string "AppIcon.icns" "$p"
  plutil -replace PNUserDataDir -string "$udd" "$p"
  plutil -replace PNProfileDirectory -string "Default" "$p"
  # Spike only: keep the disposable profiles away from the real "Chrome Safe Storage" keychain item.
  if [[ "$mock" == 1 ]]; then plutil -replace PNExtraArgs -json '["--use-mock-keychain"]' "$p"; fi

  # Icon
  local set="$OUT/$2.iconset"; rm -rf "$set"; mkdir -p "$set"
  "$BIN/make_icon" "$OUT/$2.png" "$color" "$letter"
  for s in 16 32 128 256 512; do
    sips -z $s $s "$OUT/$2.png" --out "$set/icon_${s}x${s}.png" >/dev/null
    sips -z $((s*2)) $((s*2)) "$OUT/$2.png" --out "$set/icon_${s}x${s}@2x.png" >/dev/null
  done
  iconutil -c icns "$set" -o "$app/Contents/Resources/AppIcon.icns"

  # Ad-hoc sign the two Mach-Os we own (bundle-level seal tried separately).
  codesign --force -s - "$app/Contents/MacOS/Google Chrome"
  codesign --force -s - "$app/Contents/MacOS/ProfileLauncher"
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
  echo "built: $app"
}
# Sourced by keychain_test.sh for make_app/build_tools; only build the demo apps when run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  build_tools
  make_app "Personal" personal 1a73e8 P
  make_app "Work" work d93025 W
fi
