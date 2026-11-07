# Architecture — ProfileDock Native

Status: **Phase 0 decision record.** Evidence in [TECHNICAL_SPIKE.md](TECHNICAL_SPIKE.md).

## The constraint that decides everything

Command-Tab lists running **processes** that LaunchServices has registered as
`regular` (foreground) applications, one entry per process/bundle identity.
Chrome's `ProcessSingleton` is keyed on the **user-data directory**: a second
launch against a user-data-dir that is already in use forwards its command line
over `<user-data-dir>/SingletonSocket` to the running process and exits.

So: **N Cmd-Tab entries need N Chrome browser processes, and N processes need N
user-data directories.** Profiles that share one user-data-dir (which is how
Chrome stores all of them by default) always end up in one process under one
app identity. The spike reproduced exactly this (test T7).

## Approaches considered

### A. Per-profile app bundle backed by Chrome's own binaries (CHOSEN)

```
Chrome - Work.app/Contents/
  Info.plist            Chrome's plist; CFBundleIdentifier/Name/Icon replaced,
                        Keystone (KS*), URL/document types, SMPrivilegedExecutables removed,
                        PNUserDataDir / PNProfileDirectory added
  MacOS/ProfileLauncher our ~60-line Swift stub = CFBundleExecutable (ad-hoc signed)
  MacOS/Google Chrome   copy of Chrome's 360 KB loader (ad-hoc signed)
  Frameworks/Google Chrome Framework.framework/Versions/<ver>/
                        APFS clone (cp -c) of the installed framework, Google signature intact
  Resources/AppIcon.icns
```

LaunchServices launches `ProfileLauncher` and registers the PID under the new
bundle ID. The launcher `execv()`s the bundle-local Chrome loader with
`--user-data-dir=<per-app dir> --profile-directory=<dir>`. `execv` keeps the PID,
so the browser process *is* the registered app: own Dock tile, own Cmd-Tab
entry, own icon, windows owned by it.

* Pros: genuine native Cmd-Tab entry (verified), no Accessibility permission, no
  background process, manager not needed at runtime, Chrome sandbox untouched.
* Cost: one user-data-dir per app (see the limitation below). Each framework clone
  shows as ~725 MB in `du` but uses ~0 bytes until Chrome updates. After an
  update the old version's blocks stay pinned until we regenerate the app, so
  repair has to run after every Chrome update (FR-07).
* Risks: the bundle is ad-hoc signed and not sealed. Chrome updates leave stale
  apps on the old engine, and that is a security issue, so repair must be
  prompt. Keychain access to "Chrome Safe Storage" is untested (see Open risks).

### B. Lightweight proxy apps + Accessibility window raising (REJECTED)

A stub app per profile that, on activation, raises that profile's windows in the
single real Chrome process. Cmd-Tab would show the stub, but the windows still
belong to "Google Chrome", which also stays in Cmd-Tab. Selecting the stub
activates an app that owns no windows, and then focus jumps to Chrome. This is a
custom-switcher imitation, which PRD §11 rules out, and it needs Accessibility.

### C. Chrome's own web-app shims (`app_mode_loader`) (REJECTED for this goal)

Chrome-installed web apps get real shim bundles and real Cmd-Tab entries while
sharing one browser process. They only cover app windows for a single origin,
not normal tabbed browser windows for a whole profile. That's useful as a future
"pin a site as an app" feature, not as the core product.

### A′. Same as A, but Frameworks symlinked to /Applications (FAILED in spike)

Cheapest variant. Chrome's GPU and renderer helpers run in Chrome's Seatbelt
sandbox, which only allows reads under the main bundle path, so the dlopen
through the symlink is blocked and the browser exits with "GPU process isn't
usable". Making it work would mean disabling Chrome's sandbox, which is not
allowed. Hence the APFS clones.

## The product limitation that needs a decision

Approach A cannot open a profile that lives in Chrome's normal
user-data-dir *while also being a separate app*. To use a user's **existing**
profiles, one of these is required:

| Option | What happens to data | Sessions kept | Risk |
|---|---|---|---|
| 1. Fresh profile per app | Nothing touched | No: sign in again; Chrome Sync restores bookmarks, extensions and passwords | Lowest |
| 2. Move the profile dir into the app's user-data-dir (reversible migration) | Moved, not copied; removed from Chrome's profile menu | Yes, likely (needs Keychain verification) | Medium: needs Local State edits, backup and a rollback path |
| 3. Symlink the profile dir into the app's user-data-dir | Untouched in place | Yes | **High**: regular Chrome can open the same profile at the same time with no lock between them, which can corrupt it. Effectively a lock bypass. Not recommended |

PRD FR-06 requires explicit approval before implementing any migration.

## Decision (2026-11-05): option 2, reversible migration

The user chose to move existing profiles. This is implemented in
`Sources/ProfileDockCore/ProfileMigrator.swift`:

1. **Preconditions.** The profile dir name is validated (no traversal, not Guest
   or System). Chrome's `SingletonLock` must not be held by a live PID (so Chrome
   must be fully quit). The profile app must not be running. Source and target
   must be on the same volume. The target must not already exist.
2. **Backup.** Copy Chrome's `Local State` (metadata only) to `ProfileDock/Backups/`.
3. **Move.** `renamex_np(RENAME_EXCL)` from `<Chrome>/<dir>` to
   `ProfileDock/UserData/<slug>/<dir>`. This is atomic, never copies data, and
   never overwrites. The directory name is kept, so the move can be undone exactly.
4. **Seed.** Write a one-profile `Local State` into the per-app dir (the original
   `info_cache` entry, `last_used`, `last_active_profiles`).
5. **Detach.** Re-check the lock, then remove the profile from Chrome's
   `Local State` (`info_cache`, `profiles_order`, `last_active_profiles`, and
   `last_used` if needed). This stops Chrome from offering the profile and
   recreating an empty directory with the same name.
6. **Generate** the app (approach A) and register it with LaunchServices.

Each stage is written atomically to `ProfileDock/manifest.json` before moving on,
so the manifest doubles as the journal. Any failure triggers an automatic
rollback. `rollback` (which is also uninstall) works from any stage: it removes
the app, re-adds the profile entry to Chrome's Local State (taking the latest
entry from the per-app copy), moves the directory back (RENAME_EXCL), and
deletes the per-app dir only once the profile is no longer inside it. Profile
data is never deleted on any path.

## Open risks (unverified)

1. **Keychain.** Real profiles encrypt cookies and passwords with the "Chrome Safe
   Storage" Keychain item, whose ACL trusts Google's signature. An ad-hoc-signed
   bundle will probably trigger a Keychain prompt, and "Always Allow" binds to a
   cdhash that changes on every rebuild. The spike used `--use-mock-keychain` so
   it would not touch the real item. This has to be tested before choosing option 2.
2. **Chrome updates.** The copied loader hard-codes its framework version. The
   clone keeps working after an update but stays on the old, possibly insecure
   engine until it is regenerated.
3. **Google policy and licensing.** We redistribute nothing; everything is cloned
   locally from the user's own install. Still needs a legal review before sale.
4. **Window edge cases.** Minimized, fullscreen, Spaces and multiple monitors
   haven't been tested yet, but because the windows are owned by the app process,
   standard AppKit behaviour should apply.

## Module plan (Phase 1, once the limitation is decided)

`ChromeDiscovery` (read-only Local State parsing), `ProfileModels`,
`AppBundleGenerator` (the steps in `spike/build_spike.sh` rewritten in Swift with
`Process` argument arrays, atomic staging dir, then rename), `IconGenerator`,
`LaunchServicesIntegration` (`lsregister -f/-u`), `ConfigurationStore` +
manifest of generated files, `UpdateManager` (version compare and staged
regenerate when no app processes are running), SwiftUI/AppKit menu-bar manager.

## Menu-bar manager (2026-11-06)

`Sources/ProfileDockMenu` is a SwiftUI `MenuBarExtra` (window style), menu-bar only (`LSUIElement`, accessory policy).
It is a thin front end: `Overview.build` (ProfileDockCore, read-only) merges Chrome's profile list with the manifest,
and every action calls the same `ProfileMigrator` as the CLI, off the main thread. Safety checks stay in Core.

- Managed profiles: Open/Show, Change Icon…, Rebuild App, Show in Finder, Restore to Chrome… (confirmation).
  Changes are disabled while that profile's app runs; interrupted migrations only offer Undo.
- Profiles still in Chrome: Give Own App… (confirmation explaining the move and the Keychain prompt);
  disabled while Chrome holds its user-data-dir.
- Footer: Refresh, Rebuild outdated (after a Chrome update), Apps Folder, Quit.
- Build: `scripts/build_app.sh` → `dist/ProfileDock.app` (ad-hoc signed, ProfileLauncher beside the binary).
- Test mode: `-PDChromeData -PDSupportDir -PDAppsDir -PDBundlePrefix -PDMockKeychain YES` launch arguments;
  the panel shows an orange "Test mode" line. `-PDRenderPreview out.png` draws the panel offscreen and quits
  (`docs/menu-preview.png`).
- Not yet: rename, launch at login, Chrome-update notification (status shows only when the panel is open).

## Icons, main profile, every profile (2026-11-06)

- **Icons:** every generated app uses the installed Chrome's own logo (taken at run time from Chrome.app, never
  bundled) on a white tile, with the profile name on a coloured band. The colour is Chrome's profile colour only when
  it is vivid (a theme the user picked). Chrome's default dark tones look alike, so otherwise each profile gets a
  distinct colour from a 14-colour palette, indexed by its number. A custom image (Change Icon…) still overrides
  the default. Using Google's logo is fine for personal use; a commercial release needs its own artwork or legal
  sign-off (trademark).
- **Main profile in place:** `adoptInPlace` (CLI `adopt Default --yes`) creates an app whose user-data-dir *is*
  Chrome's own. Nothing is moved or edited, so it works while Chrome is open, and undoing it only deletes the app.
  Only one profile can be in place (one user-data-dir = one process). If plain Google Chrome is already running,
  the app hands over to it, so the user should open "Chrome - <main>" instead of Google Chrome (e.g. in the Dock).
  Links from other apps still start plain Google Chrome when nothing is running.
- **Unique names:** display names become app names, so a second "Devendra" becomes "Devendra (<email name>)",
  else "Devendra (Profile N)". An existing app that ProfileDock didn't create is never replaced.
- **Every profile:** `giveAllOwnApps` (CLI `migrate --all --yes`, menu "Give Every Profile Its Own App…"). It
  refuses while Chrome is open, moves every other profile, adopts Default in place last, and continues past a
  failing profile (each failed profile is rolled back).
- **"Off-screen tiny window" (2026-11-06): not a bug.** Stage Manager is on. The 173×185 window at x=-272 was
  Stage Manager's thumbnail of an inactive stage; activating the app showed the real 1249×922 window on screen.
