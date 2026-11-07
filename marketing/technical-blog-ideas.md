# Technical Blog Ideas + Flagship Draft

Date: 2026-11-05. Source of technical facts: `docs/ARCHITECTURE.md`, `docs/TECHNICAL_SPIKE.md` (internal, verified on macOS 26.1 / Chrome 156 / Apple Silicon). Labels: **[Verified]** from spike · **[Inference]** · **[Hypothesis]**.

Why engineering posts: HN and r/macapps reward "how it works" posts over product announcements **[Inference — confirm with distribution-channels.md]**, and they earn links that help the product pages rank.

## Idea list

| # | Title | Audience | Primary objective | Effort | Ready to write? |
|---|---|---|---|---|---|
| T1 | **Why macOS puts all your Chrome profiles under one ⌘-Tab icon (and how to split them)** | Developers, power users, HN | Credibility + backlinks + SEO for "chrome profiles command tab" | M (draft below) | Yes |
| T2 | Chrome's ProcessSingleton: one user-data-dir, one process | Chromium-curious devs | HN / backlinks | S | Yes |
| T3 | What happened when I symlinked Chrome's framework (the GPU sandbox said no) | Mac devs | HN / build in public | S | Yes (spike T10) |
| T4 | APFS clones: shipping a 725 MB framework for ~0 bytes | Mac devs | Build in public | S | Yes, re-measure first |
| T5 | Anatomy of a Mac .app bundle: what LaunchServices actually needs to put you in ⌘-Tab | Swift devs | SEO "mac app bundle structure" | M | Yes |
| T6 | The Chrome update problem: keeping generated apps on a patched engine | Security-minded devs | Trust | M | After repair flow exists |
| T7 | Chrome Safe Storage, Keychain ACLs and ad-hoc signatures | Mac security devs | Trust/HN | M | After Keychain test |
| T8 | Building a paid Mac utility with AI coding tools: what worked, what I verified by hand | Indie hackers | Build in public, IH/X | M | Partly; at launch |
| T9 | Why I charge $4.99 once (with the real fee maths) | Indie hackers | IH / X | S | After pricing data |
| T10 | Three ways to get Chrome profiles into ⌘-Tab, compared (proxy apps, web-app shims, real per-profile apps) | Power users | SEO + comparison | M | Yes |
| T11 | Week-1 launch numbers (honest post-mortem) | Indie hackers | IH / HN | S | After launch |

---

## Flagship draft (T1), ready to edit and publish

> Status: draft. Do not publish until the visual ⌘-Tab check is done and a real screenshot replaces the placeholder.

# Why macOS shows one Chrome in ⌘-Tab, no matter how many profiles you have

If you use Chrome profiles for work, personal and a client or two, you know the routine: ⌘-Tab, land on "Google Chrome", then cycle through windows with ⌘-\` hoping the next one is the right account. Chrome has had profiles for years. macOS has had ⌘-Tab for over two decades. They still don't know about each other.

I wanted each profile in ⌘-Tab as its own app. Here's why that's hard, and what finally worked.

## ⌘-Tab lists processes, not windows

The macOS app switcher shows each running *regular* application once: one entry per app process, with the icon LaunchServices has registered for that app. Windows don't get their own entries. If one process owns windows from five profiles, you see one icon.

## Chrome deliberately runs all profiles in one process

Chrome stores every profile in one **user data directory** (`~/Library/Application Support/Google/Chrome`). The first Chrome process to start against that directory takes a lock and creates a `SingletonSocket`. When you start Chrome again for the same directory, even with `--profile-directory="Profile 2"`, the new launch passes its command line through that socket to the running process and quits. That's Chrome's *process singleton* at work, and it's why a "Work" shortcut opens a window inside the same Google Chrome you already had. **[Verified, spike T7: a third app that shared a directory handed off and exited]**

So: **N entries in ⌘-Tab need N processes, and N Chrome processes need N user-data directories.**

## Things that don't work

- **Dock shortcuts or `open -a` with a profile flag:** same process, same icon.
- **Chrome's "create shortcut" apps** are real app shims with their own ⌘-Tab entries, but they open one site in an app window, not a full tabbed browser for a profile.
- **A stub app that raises the profile's windows:** the stub shows in ⌘-Tab, but Chrome's windows still belong to Google Chrome, which stays in ⌘-Tab too. Pick the stub and focus jumps to Chrome. It looks like a switcher but behaves like a workaround, and it needs Accessibility permission.
- **A per-profile app that symlinks Chrome's framework:** this one surprised me. The browser starts, but Chrome's GPU and renderer helpers run in Chrome's sandbox, which only allows reads inside the main app bundle. The dlopen through the symlink gets blocked, and Chrome quits with "GPU process isn't usable." Turning off Chrome's sandbox to fix it was never an option. **[Verified, spike T10]**

## What works: a real app per profile

Each profile app is a small bundle:

```
Chrome - Work.app/Contents/
  Info.plist           own bundle ID, name and icon
  MacOS/launcher       tiny Swift stub (the bundle's executable)
  MacOS/Google Chrome  Chrome's small loader
  Frameworks/…         APFS clone of the installed Chrome framework
  Resources/AppIcon.icns
```

LaunchServices starts the launcher and registers its PID under the new bundle identity. The launcher then `execv()`s Chrome's loader with `--user-data-dir=<this app's dir>`. `execv` keeps the PID, so **the browser process is the registered app**. It gets its own Dock tile, its own ⌘-Tab entry, its own icon, and its windows belong to it. **[Verified programmatically, spike T1–T4: separate PIDs and bundle IDs, regular activation policy, distinct runtime icons, and activating the app brings its own window forward]**

The framework is copied with `cp -c`, an APFS clone, so it takes up almost no space on disk until Chrome updates. Chrome's own code signature on the framework stays intact. **[Verified in spike; re-measure in shipping build]**

## The trade-offs I haven't solved yet

- **Existing profiles.** Each app needs its own user-data directory, so a profile that lives in Chrome's normal directory can't be a separate app at the same time. Today every app starts fresh, and Chrome Sync fills it back in. Moving a profile over is possible but touches your data, so it'll only ship once it's tested properly. Symlinking a profile into two places would let two Chromes open it at once with no lock between them, which corrupts profiles, so I won't ship that.
- **Chrome updates.** A generated app keeps running the engine it was built with. That's a security issue, so the app has to rebuild after every Chrome update.
- **Keychain.** Real profiles encrypt cookies with a "Chrome Safe Storage" key whose access is tied to Google's code signature. How an ad-hoc-signed bundle behaves there still needs testing.

[Screenshot placeholder: ⌘-Tab with Chrome, Work (red W) and Personal (blue P), real capture only]

*I'm turning this into a small Mac app called Tabloom. If you want to try the beta, [join here].*

---

### Distribution notes for T1
- Canonical on the product blog; cross-post to dev.to/Hashnode with `rel=canonical`.
- Show HN title: "Show HN: Chrome profiles as separate apps in macOS ⌘-Tab" only if there's something people can try. Otherwise post the article as a normal submission, not a Show HN. See distribution-channels.md for the rules.
