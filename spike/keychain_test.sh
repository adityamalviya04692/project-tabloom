#!/bin/bash
# Keychain test: can an ad-hoc-signed profile app use the real "Chrome Safe Storage"
# key, and can it read cookies from a COPY of a profile made by real Chrome?
#
# Safety: reads Chrome's Local State only to find the throwaway profile you name;
# copies (APFS clone) that one profile; never writes to Chrome's profiles (note: the
# app's crashpad handler does use Chrome's shared Crashpad folder, as the spike apps do).
# Chrome only CREATES a Keychain item when none exists, so this test does not
# replace your existing "Chrome Safe Storage" key. Clicking "Deny" is always safe.
#
# Run in your own Terminal (Chrome's helpers fail inside Claude's sandbox):
#   spike/keychain_test.sh
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/build_spike.sh"   # make_app, build_tools, $OUT/$APPS/$DATA
KC="$OUT/keychain"; mkdir -p "$KC"; RES="$KC/results.txt"; LOG="$KC/server.log"
REAL_CHROME_DIR="$HOME/Library/Application Support/Google/Chrome"
REAL_CHROME_EXE="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
: > "$LOG"; { echo "# Keychain test $(date -u +%FT%TZ)"; sw_vers -productVersion; uname -m
  plutil -extract CFBundleShortVersionString raw "/Applications/Google Chrome.app/Contents/Info.plist"; } > "$RES"

ask() { local a; read -r -p "$1 [y/n] " a; echo "$2: $a" >> "$RES"; }
app_running() { pgrep -f "$APPS/Chrome - $1.app/" >/dev/null; }
quit_app() { osascript -e "quit app \"Chrome - $1\"" 2>/dev/null || true
  for _ in $(seq 20); do app_running "$1" || return 0; sleep 0.5; done; pkill -f "$APPS/Chrome - $1.app/" || true; }
real_chrome_running() { pgrep -f "^$REAL_CHROME_EXE" >/dev/null; }

if lsof -nP -iTCP:18765 -sTCP:LISTEN >/dev/null; then echo "Port 18765 is busy (old cookie_server.py?). Stop it first."; exit 1; fi
python3 "$HERE/src/cookie_server.py" "$LOG" & SERVER=$!
sleep 0.5; kill -0 $SERVER 2>/dev/null || { echo "cookie server failed to start"; exit 1; }
trap 'kill $SERVER 2>/dev/null || true' EXIT
build_tools; rm -rf "$DATA/kcfresh" "$DATA/kccopy"   # start every run clean

echo; echo "== Phase 1: fresh profile, REAL keychain =="
make_app "KC Fresh" kcfresh 0b8043 K 0 >/dev/null
open -a "$APPS/Chrome - KC Fresh.app" --args "http://127.0.0.1:18765/set?v=fresh-1"
echo "A 'Chrome - KC Fresh' window opens. Watch for a Keychain dialog about 'Chrome Safe Storage'."
echo "If one appears, click 'Always Allow' (this grants only this test app; removable later)."
ask "Did a Keychain prompt appear on first launch?" "P1_first_launch_prompt"
sleep 2; quit_app "KC Fresh"
open -a "$APPS/Chrome - KC Fresh.app" --args "http://127.0.0.1:18765/"
ask "Did a Keychain prompt appear again on relaunch?" "P1_relaunch_prompt"
sleep 2; quit_app "KC Fresh"
echo "P1 cookie after relaunch (expect fresh-1):"; { grep -E "^/ " "$LOG" || echo "(no request logged)"; } | tail -1 | tee -a "$RES"

echo; echo "== Phase 2a: rebuild app, same Chrome (same binaries) =="
make_app "KC Fresh" kcfresh 0b8043 K 0 >/dev/null
open -a "$APPS/Chrome - KC Fresh.app" --args "http://127.0.0.1:18765/"
ask "Keychain prompt after a plain rebuild?" "P2a_rebuild_prompt"
sleep 2; quit_app "KC Fresh"

echo; echo "== Phase 2b: simulate a Chrome update (loader gets a new code hash) =="
codesign --force -s - -i "com.google.Chrome.simulated-update" "$APPS/Chrome - KC Fresh.app/Contents/MacOS/Google Chrome"
open -a "$APPS/Chrome - KC Fresh.app" --args "http://127.0.0.1:18765/"
ask "Keychain prompt after the simulated update?" "P2b_update_prompt"
sleep 2; quit_app "KC Fresh"

echo; echo "== Phase 3: copy of a profile created by REAL Chrome =="
echo "In your normal Chrome: create a new profile named exactly 'Keychain Test' (no Google sign-in),"
echo "open http://127.0.0.1:18765/set?v=real-123 in it, then QUIT Chrome completely (Cmd-Q)."
read -r -p "Press Enter when done... "
while real_chrome_running; do read -r -p "Chrome is still running. Quit it (Cmd-Q), then press Enter... "; done
SRC=$(python3 - "$REAL_CHROME_DIR/Local State" <<'EOF'
import json, sys
c = json.load(open(sys.argv[1]))["profile"]["info_cache"]
m = [d for d, v in c.items() if v.get("name") == "Keychain Test"]
print(m[0] if len(m) == 1 else "")
EOF
)
[[ -n "$SRC" ]] || { echo "Could not find exactly one profile named 'Keychain Test'." | tee -a "$RES"; exit 1; }
echo "copying profile dir '$SRC' (clone; original untouched)" | tee -a "$RES"
make_app "KC Copy" kccopy f9ab00 C 0 >/dev/null
rm -rf "$DATA/kccopy"; mkdir -p "$DATA/kccopy"
cp -cR "$REAL_CHROME_DIR/$SRC" "$DATA/kccopy/Default"
echo "You can reopen your normal Chrome now."
open -a "$APPS/Chrome - KC Copy.app" --args "http://127.0.0.1:18765/"
ask "Keychain prompt for the copied profile? (Always Allow if shown)" "P3_copy_prompt"
sleep 3
echo "P3 cookie seen by server (PASS if real-123):"; { grep -E "^/ " "$LOG" || echo "(no request logged)"; } | tail -1 | tee -a "$RES"
ask "Does the copied profile window look normal (history/extensions/name intact)?" "P3_profile_looks_ok"
quit_app "KC Copy"

echo; echo "== Cleanup =="
LSREG=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister
for a in "KC Fresh" "KC Copy"; do "$LSREG" -u "$APPS/Chrome - $a.app" || true; rm -rf "$APPS/Chrome - $a.app"; done
rm -rf "$DATA/kcfresh" "$DATA/kccopy"
echo "Done. Results: $RES"
echo "Optional: delete the 'Keychain Test' profile in Chrome, and remove the test app from"
echo "Keychain Access > 'Chrome Safe Storage' > Access Control."
cat "$RES"
