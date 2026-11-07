# Landing Page Copy (draft)

Date: 2026-11-05. Every claim follows the claim gate in [landing-page-spec.md](landing-page-spec.md). Lines marked ⚠️ wait on verification.

---

## Hero

**Primary headline (brand line)**
# Your Chrome profiles. Separate Mac apps. Native Command-Tab.

**Subhead**
Tabloom gives every Chrome profile its own app, its own Dock icon and its own spot in ⌘-Tab. Work, Personal and every client: one keystroke away, never mixed up.

**Buttons:** `Download free trial` · `Watch the 5-second demo`
**Trust line:** One-time $4.99 · No subscription · No Accessibility permission · Made for macOS

### Alternative headlines (for experiment E1)
1. **Problem-led:** "⌘-Tab shows one Chrome. You have five." Sub: "Give each Chrome profile its own Mac app, so the right window is one keystroke away."
2. **Outcome-led:** "Stop digging through Chrome windows for the right account." Sub: "Every Chrome profile becomes its own Mac app, with its own icon in the Dock and ⌘-Tab."
3. **Audience-led (agencies/freelancers):** "One Mac app per client. Zero account mix-ups." Sub: "Tabloom turns each Chrome profile into its own app, so client logins stay separate and switch with ⌘-Tab."

---

## 5-second demo (caption under video)
Before: one Chrome in ⌘-Tab. After: Work, Personal and Client A, each its own app. ⚠️ (real recording only)

## Before / After

| Before | After |
|---|---|
| One Chrome icon in ⌘-Tab, no matter how many profiles you use | One icon per profile, each with its own colour or letter |
| ⌘-Tab, then hunt with ⌘-\` through mixed windows | ⌘-Tab straight to the profile you want |
| Work tabs show up while you're screen-sharing personal stuff | Each profile's windows belong to its own app |
| One Dock icon, right-click to guess which window | Separate Dock icons you can pin, hide and quit one by one |

## How it works
1. **Name it and pick an icon.** "Work", red, a "W". Or your client's logo.
2. **Tabloom builds a small Mac app** that runs Google Chrome with its own profile. Nothing is injected and Chrome itself isn't modified.
3. **Use it like any app.** It's in the Dock, Launchpad, Spotlight and ⌘-Tab. Hide it, quit it, give it its own Space.

> **Under the hood (for developers):** each profile app is a real app bundle with its own bundle identifier. It starts Chrome's own engine with a separate user-data directory, so macOS sees a separate process and lists it in ⌘-Tab by itself. The engine is an APFS clone of your installed Chrome, so it takes almost no extra disk space. ⚠️ re-measure in the shipping build. [Read the engineering write-up →]

## Features
- **Real ⌘-Tab entries.** Uses the native switcher, not a lookalike overlay.
- **Its own Dock icon.** Pin, badge, hide or quit each profile on its own.
- **Custom icons.** Letters, colours, emoji or your own image.
- **Profiles that stay apart.** Cookies and logins in one app never leak into another.
- **Only the profiles you choose.** Turn just "Work" into its own app and leave the rest in Chrome. Your Dock doesn't fill up.
- **No background app.** Once your apps are built, Tabloom doesn't need to run.
- **Pay once.** $4.99, no subscription.

## Privacy & security
- Tabloom doesn't read your browsing data, passwords, or profile contents.
- No account, no tracking by default.
- No Accessibility, Screen Recording or Input Monitoring permission.
- Your normal Google Chrome app is never modified.
- ⚠️ Notarized by Apple. *(only once true; until then, say how the app is signed and how to open it)*
- ⚠️ Rebuilds profile apps after Chrome updates so they use the latest security fixes. *(only once shipped)*

## Compatibility ⚠️
| | Tested | Not yet tested |
|---|---|---|
| macOS | 26.1 | earlier versions |
| Mac | Apple Silicon | Intel |
| Browser | Google Chrome 156 | Chrome Beta/Canary, Brave, Edge, Arc |

**Good to know:** each Tabloom app starts with a fresh Chrome profile. Sign in to Chrome once and Sync restores your bookmarks, extensions and passwords. *(Replace only when existing-profile import is verified.)*

## Pricing
**$4.99, once.**
- Unlimited profile apps
- Free updates for version 1.x
- 7-day free trial ⚠️ (depends on E3)
- 14-day refund if it doesn't work on your Mac ⚠️

`Buy Tabloom — $4.99`
Prices in USD; local taxes are calculated at checkout.

## Final CTA
**Give every Chrome profile its own app.**
`Download free trial` macOS 26 · Apple Silicon · Google Chrome required ⚠️

## Footer
Privacy · Refunds · Contact · Changelog
Google Chrome is a trademark of Google LLC. Tabloom is independent and not affiliated with Google.

---

## Meta
- **Title (≤60):** `Chrome Profiles as Separate Mac Apps in ⌘-Tab | Tabloom`
- **Description (≤155):** `Give each Chrome profile its own Mac app, Dock icon and native Command-Tab entry. One-time $4.99, no subscription, no Accessibility permission.`
- **OG image alt:** "macOS Command-Tab switcher showing separate Chrome Work and Personal apps"
