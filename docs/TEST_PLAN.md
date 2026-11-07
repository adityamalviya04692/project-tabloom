# Test Plan

All automated tests use disposable data. Nothing here touches
`~/Library/Application Support/Google/Chrome` unless a step says **REAL**.

## Automated

| Suite | Command | Last run (2026-11-05) |
|---|---|---|
| Unit + filesystem integration (22 tests: Chrome-logo icon + band colour, distinct profile colours, same-name profiles, main profile in place (nothing moved, undo = app only), every-profile bulk + rollback, menu overview (states, Chrome-open, unreadable data), icon name band, names, traversal, Unicode, Local State, discovery, invalid JSON, Info.plist, manifest, icons, lock refusal, auto-rollback, migrate→rollback) | `swift test` (run outside Claude's command sandbox: `codesign`/`lsregister`) | **22/22 PASS** (2026-11-06) |
| E2E migration with real Chrome binaries on a disposable user-data-dir (seed 2 profiles → dry run → migrate → launch → session → rollback blocked while running → rollback → cookie intact) | `bash spike/e2e_migrate.sh` | **ALL PASS** |
| Menu-bar app on disposable data: builds, runs menu-bar only (accessory policy), panel rendered offscreen before/after a migrate, then rollback | `scripts/build_app.sh` + `-PDRenderPreview` | PASS (2026-11-06); clicking through the real menu NOT RUN |
| Cmd-Tab spike (identity, icons, activation, isolation, singleton collapse, cleanup) | `spike/build_spike.sh` + `spike/out/bin/probe` | PASS, see TECHNICAL_SPIKE.md |

## Manual (NOT RUN unless marked)

1. ⌘-Tab overlay shows each running profile app with its own icon and name, next to Chrome. *(NOT RUN visually; verified programmatically)*
2. Close every window of a profile app, then click its Dock icon: one new window, in the right profile.
3. Minimized, fullscreen, other Space, second monitor, hidden (⌘H): ⌘-Tab to the app restores the right window.
4. Open a link from another app: it goes to the default browser (real Chrome), never to a profile app.
5. **REAL, Keychain gate: PARTLY RUN (2026-11-05, Profile 7 "AyushLetsPLAY").** The migration
   refused while Chrome ran, then succeeded once Chrome was quit. On launch, macOS showed a
   SecurityAgent prompt. After it was answered, the app loaded the profile's one existing
   encrypted cookie (CDP `Storage.getCookies`), so decryption works. The Keychain item mdat
   was unchanged. Still open: the prompt's text, the button used, and whether repair re-prompts.
   Original plan: migrate one low-stakes real profile with Chrome fully quit. On first launch, expect a macOS prompt for "Chrome Safe Storage". Record the prompt text and whether logins and cookies work after "Allow" and after "Always Allow", and whether a rebuild (`repair`) prompts again.
6. **REAL:** rollback of that profile; real Chrome shows it again with sessions intact.
7. Chrome auto-updates: `profiledock status` shows "needs repair"; `repair --all` fixes it; the old app keeps working until then.
8. Reboot: apps and manifest still valid; nothing re-migrates.
9. Intel Mac, and one older Chrome version. *(untested configurations)*
10. Menu-bar app, by hand: click the menu-bar icon, Give Own App… on a test profile, Open, Change Icon…, Restore to Chrome…; confirm each dialog's text and that buttons disable while Chrome/the app runs.
11. Real Profile 7 window: RUN 2026-11-06. It looked 173×185 and off-screen, but that was a Stage Manager thumbnail; activated, the window is 1249×922 on screen. PASS.
12. REAL: open "Chrome - Person 1" with Google Chrome quit: Dock/⌘-Tab show the Person 1 icon, Default profile with its tabs/logins. *(NOT RUN: Chrome was open)*
13. REAL: "Give Every Profile Its Own App…" with Chrome quit; each app opens its profile; Keychain prompt per app. *(NOT RUN: Chrome was open)*
