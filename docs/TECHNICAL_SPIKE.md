# Technical Spike — Report (2026-11-05)

**Verdict: the Cmd-Tab gate passes** with approach A from
[ARCHITECTURE.md](ARCHITECTURE.md), using *disposable* profiles. Using a user's
*existing* profiles still has an unresolved data-placement decision (below).

## Environment

macOS 26.1 (25B78), Apple Silicon (arm64). Swift 6.1.2 from Command Line Tools,
no full Xcode, so there is no `xcodebuild` and no XCTest app targets yet. Google
Chrome 156.0.8078.80 (`/Applications`, universal, Team EQHXZ8M8AV). The user's
real Chrome (PID 13441) ran throughout and was never pointed at.

## What was built (`spike/`)

* `src/launcher.swift`: the bundle executable. Reads `PN*` keys from Info.plist,
  then `execv`s the bundle-local Chrome loader with `--user-data-dir`/`--profile-directory`.
* `src/make_icon.swift`: renders a 1024 px initial-avatar PNG. `sips` + `iconutil` turn it into `.icns`.
* `build_spike.sh`: generates `Chrome - Personal.app` and `Chrome - Work.app` with
  user-data-dirs under `spike/out/data/` and `--use-mock-keychain`.
* `src/probe.swift`: queries NSWorkspace and CGWindowList (activation policy,
  window ownership, activation, sampled runtime icon colour).
* `src/cookie_server.py`: a local 127.0.0.1 server that sets and echoes a cookie.

Reproduce: `spike/build_spike.sh`, then `open "spike/out/apps/Chrome - Work.app"`.
Run it outside Claude's command sandbox; inside it, Chrome's helpers can't load.

## Results

| # | Test | Result | Evidence |
|---|---|---|---|
| T1 | Two generated identities launch | PASS | `lsappinfo`: "Chrome - Work" (`…spike.work`), "Chrome - Personal" (`…spike.personal`), each its own ASN and PID |
| T2 | Cmd-Tab eligibility | PASS (programmatic) | Both have `activationPolicy == .regular`, separate from `com.google.Chrome`, and the browser process PID = the LS-registered PID |
| T3 | Distinct icons at runtime | PASS (programmatic) | `NSRunningApplication.icon` sample: Personal rgb(27,137,236) blue, Work rgb(226,70,48) red, Chrome green |
| T4 | Activating an app brings *its* window forward | PASS | `activate()` makes the app frontmost and the top window's owner PID = that app (4 alternating activations; one sample hit the Stage Manager overlay) |
| T5 | Session persists across quit + relaunch | PASS | Cookie set in Work; after `quit` (0 processes left) and relaunch, the server received `spike_session=work-123` |
| T6 | Profiles isolated | PASS | Personal sent no cookie; Personal's Cookies DB has no `spike_session` |
| T7 | Two identities sharing one user-data-dir | **Collapses to one app** (expected) | The 3rd app (same dir, `Profile 1`) handed off via `SingletonSocket` and exited; `Profile 1` opened inside the Work process |
| T8 | No concurrent use of a user-data-dir | PASS | Each dir has its own `SingletonLock` → own PID; the real Chrome lock stayed `…-13441` |
| T9 | Cleanup | PASS | Quit, then `lsregister -u` + delete: 0 processes, 0 LaunchServices entries, real Chrome unaffected |
| T10 | Framework via symlink (variant A′) | FAIL | Chrome's helper sandbox blocked the dlopen, then "GPU process isn't usable". Replaced with APFS clones (0 bytes of disk used) |

## NOT RUN (needs GUI or a person)

* **Visual check of the real Cmd-Tab overlay.** No screenshots were taken. T2 is
  the programmatic equivalent. Manual check: run `spike/build_spike.sh`, open both
  apps, press ⌘-Tab, and expect a blue "P" and a red "W" tile next to Chrome.
* Closing all windows then reopening (Dock click), minimized, fullscreen,
  Spaces, multiple monitors, hidden apps.
* Real Keychain ("Chrome Safe Storage") with an ad-hoc-signed bundle.
* Chrome update → stale app → repair. Reboot persistence. Intel Macs. Other Chrome versions.

## Decision and Phase 1 progress

The user chose **option 2 (reversible migration)**. Implemented as a Swift package
(`Sources/ProfileDockCore`, `Sources/ProfileLauncher`, `Sources/profiledock` CLI)
and tested on disposable data only. See [TEST_PLAN.md](TEST_PLAN.md).

Incident during E2E setup: zsh passed an unsplit option string, which the CLI
silently ignored, so `discover` read the real Chrome dir (read-only). The seed
apps then ran against the disposable dir without `--use-mock-keychain`. No real
data was written, and the real "Chrome Safe Storage" item is unmodified (mdat
2023). The fix: the CLI now rejects unknown options, and the E2E script uses
bash arrays and refuses to run against the real Chrome dir.

## Next gate

The Keychain check on one real, low-stakes profile (TEST_PLAN manual #5). It
requires quitting Chrome and answering a macOS prompt, and needs the user's go-ahead.
