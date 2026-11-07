#!/bin/bash
# End-to-end migration test against a DISPOSABLE Chrome user-data-dir, using the real
# Chrome binaries. Seeds two profiles with distinct cookies, migrates one into its own
# app, verifies Cmd-Tab identity + session, rolls back, verifies the profile is back.
# Must run outside Claude's command sandbox (Chrome helpers need normal file access).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
E="$ROOT/spike/out/e2e"
PD="$ROOT/.build/debug/profiledock"
REAL="$HOME/Library/Application Support/Google/Chrome"
G=(--chrome-data "$E/ChromeData" --support-dir "$E/Support" --apps-dir "$E/Apps"
   --bundle-prefix cc.ayush.profiledock.e2e --mock-keychain)
PORT=18799  # own port: other experiments may run cookie_server.py on 18765
URL="http://127.0.0.1:$PORT"
pass() { echo "PASS  $*"; }
die() { echo "FAIL  $*"; exit 1; }
wait_running() { for _ in $(seq 1 20); do lsappinfo info -only pid "$1" 2>/dev/null | grep -q '"pid"=[0-9]' && return 0; sleep 0.5; done; return 1; }
wait_quit() { osascript -e "tell application id \"$1\" to quit" >/dev/null 2>&1 || true
              for _ in $(seq 1 30); do lsappinfo info -only pid "$1" 2>/dev/null | grep -q '"pid"=[0-9]' || return 0; sleep 0.5; done; return 1; }
# Open a URL in a running app, retrying until the local server logs the request
# (right after launch Chrome may not yet handle the open-URL Apple event).
visit() { for _ in 1 2 3 4 5 6; do open -b "$1" "$URL/$2"; sleep 3; grep -q "^/$2 " "$E/server.log" 2>/dev/null && return 0; done; return 1; }
cookies() { sqlite3 "file:$1/Cookies?mode=ro&immutable=1" "select name||'='||host_key from cookies where name='spike_session'" 2>/dev/null || true; }

[[ "$(cd "$(dirname "$E")" && pwd)" != "$REAL"* ]] || die "refusing: E2E dir is inside the real Chrome dir"
rm -rf "$E"; mkdir -p "$E/ChromeData"
swift build --package-path "$ROOT" >/dev/null
python3 -I "$ROOT/spike/src/cookie_server.py" "$E/server.log" "$PORT" >/dev/null 2>&1 & SERVER=$!
trap 'kill $SERVER 2>/dev/null || true' EXIT
sleep 1

echo "== 1. seed two profiles in the disposable Chrome dir"
for spec in "Default:personal" "Profile 1:work"; do
  dir="${spec%%:*}"; v="${spec##*:}"; id="cc.ayush.profiledock.e2eseed.$v"
  app=$("$PD" "${G[@]}" --apps-dir "$E/SeedApps" dev-app --name "Seed $v" --bundle-id "$id" \
        --user-data-dir "$E/ChromeData" --profile "$dir")
  open "$app"; wait_running "$id" || die "seed $v did not start"; sleep 3
  visit "$id" "set?v=$v" || die "seed $v never loaded the page"
  wait_quit "$id" || die "seed $v did not quit"
done
for a in "$E"/SeedApps/*.app; do /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u "$a"; done
[[ "$(cookies "$E/ChromeData/Profile 1")" == "spike_session=127.0.0.1" ]] && pass "Profile 1 has its seeded cookie" || die "seed cookie missing"
"$PD" "${G[@]}" discover

echo "== 2. dry run changes nothing"
before=$(shasum "$E/ChromeData/Local State")
"$PD" "${G[@]}" migrate "Profile 1" >/dev/null
[[ "$(shasum "$E/ChromeData/Local State")" == "$before" && -d "$E/ChromeData/Profile 1" ]] && pass "dry run is a no-op" || die "dry run modified data"

echo "== 3. migrate"
"$PD" "${G[@]}" migrate "Profile 1" --yes
APP=$(ls -d "$E"/Apps/*.app); ID=cc.ayush.profiledock.e2e.profile-1
[[ ! -e "$E/ChromeData/Profile 1" ]] && pass "profile moved out of Chrome dir" || die "profile still in Chrome dir"
python3 -I -c "import json,sys;d=json.load(open(sys.argv[1]));assert 'Profile 1' not in d['profile']['info_cache']" "$E/ChromeData/Local State" \
  && pass "removed from Chrome's Local State" || die "still in Local State"
"$PD" "${G[@]}" status

echo "== 4. launch migrated app: identity + session"
open "$APP"; wait_running "$ID" || die "migrated app did not start"; sleep 3
visit "$ID" "after-migrate" || die "migrated app never loaded the page"
grep -q "/after-migrate cookie=spike_session=work" "$E/server.log" && pass "session cookie survived migration" || die "cookie lost after migration"
lsappinfo info -only bundleID,type "$ID" | tr '\n' ' '; echo
pgrep -f "Apps/Chrome - .*MacOS/Google Chrome --user-data-dir=$E/Support/UserData/profile-1 " >/dev/null \
  && pass "browser process runs from the generated app with the per-app user-data-dir" || die "process args unexpected"

echo "== 5. rollback refuses while the app runs"
if "$PD" "${G[@]}" rollback "Profile 1" --yes 2>/dev/null; then die "rollback ran while app was running"; else pass "rollback blocked while running"; fi
wait_quit "$ID" || die "migrated app did not quit"

echo "== 6. rollback"
"$PD" "${G[@]}" rollback "Profile 1" --yes
[[ -d "$E/ChromeData/Profile 1" && ! -e "$APP" && ! -e "$E/Support/UserData/profile-1" ]] && pass "profile restored, app + per-app dir removed" || die "rollback incomplete"
[[ "$(cookies "$E/ChromeData/Profile 1")" == "spike_session=127.0.0.1" ]] && pass "cookie intact after round trip" || die "cookie lost after rollback"
python3 -I -c "import json,sys;d=json.load(open(sys.argv[1]));assert 'Profile 1' in d['profile']['info_cache']" "$E/ChromeData/Local State" \
  && pass "back in Chrome's Local State" || die "not restored in Local State"
[[ "$(/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -dump | grep -c 'cc.ayush.profiledock.e2e')" == 0 ]] \
  && pass "no LaunchServices registrations left" || die "LaunchServices entries remain"
echo "ALL E2E CHECKS PASSED"
