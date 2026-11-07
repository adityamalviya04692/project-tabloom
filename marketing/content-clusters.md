# Tabloom content clusters (research date 2026-11-05)

The keyword scores are in `seo-keywords.csv`; the method is in `seo-strategy.md`. Every page must follow the honesty constraints in `seo-strategy.md` section 7. In particular, never claim that Tabloom supports existing profiles.

How links flow:
- **Money pages:** home and the two feature landings.
- **Pillar:** links to every cluster article and to all money pages.
- **Cluster articles:** link up to the pillar and across to the most relevant money page.
- **Comparison pages:** link to home and to the pillar.

```
                 / (home: "Each Chrome profile, its own Mac app")
                /            |               \
 /chrome-profiles-dock-icons |   /chrome-profiles-command-tab
                \            |               /
          /guides/multiple-chrome-profiles-mac  (PILLAR)
     /        |          |          |           \          \
 shortcut  switch    instances  work-personal  cmd-tab   compare/*
```

---

## Money pages

### / (home): P1
- **Keywords:** chrome profiles separate apps; make chrome profiles separate mac apps; chrome profile switcher mac (secondary).
- **Format:** product landing.
  - H1: outcome.
  - A 2-sentence answer.
  - How it works in 3 steps.
  - Screenshots, only after the visual check.
  - **"What it does not do yet"** box: fresh profiles, sign in again.
  - Price $4.99.
  - FAQ.
  - Schema: `SoftwareApplication` with `FAQPage`.
- **Links out:** both feature landings, the pillar, /compare/unbundle, /guides/run-multiple-chrome-instances-mac (DIY).

### /chrome-profiles-dock-icons: P1
- **Keywords:** multiple chrome profiles in mac dock; separate dock icons for different chrome profiles; separate chrome profiles dock mac; chrome profile dock.
- **Format:** problem-led landing page.
  1. "Why Chrome shows one Dock icon"
  2. Free DIY method and its downsides
  3. Tabloom
  4. FAQ (custom icons? existing profiles? uninstall?)
- **Angle:** current and tested (print the macOS and Chrome versions). Mention the Dec 2025 Apple Community report as context.
- **Links:** home (CTA), pillar, /guides/chrome-profile-shortcut-mac, /compare/parall.

### /chrome-profiles-command-tab: P1
- **Keywords:** chrome profiles command tab mac; cmd tab chrome profiles.
- **Format:** problem-led landing.
  1. "Cmd-Tab shows one Chrome": the reason.
  2. Cmd+` versus a separate app per profile.
  3. No Accessibility permission and no custom switcher needed (the native switcher is used). This is verified programmatically. Do not show the overlay screenshot until it has been checked by eye.
- **Links:** home, pillar, /guides/cmd-tab-chrome-windows, /guides/switch-chrome-profiles-mac.

---

## Pillar

### /guides/multiple-chrome-profiles-mac: "Multiple Chrome profiles on Mac: the complete 2026 guide"
- **Keywords:** multiple chrome profiles mac; how to open multiple chrome profiles on mac (P1); how to create multiple chrome profiles on mac; how to open all chrome profiles at once; macos chrome multiple profiles.
- **Sections:**
  1. Create profiles (brief; link to Google Help `support.google.com/chrome/answer/2364824` rather than duplicating it).
  2. Open several at once.
  3. Switch between them.
  4. **What profiles don't give you on Mac** (one Dock icon, one Cmd-Tab entry, links open in the focused profile).
  5. Three ways around it: shortcuts, separate instances, separate apps.
  6. Work and personal setup.
  7. Tools compared.
- **Links:** every cluster article and both feature landings.

---

## Cluster articles

| Page | Keywords | Priority | Content | Links to |
|---|---|---|---|---|
| /guides/chrome-profile-shortcut-mac | chrome profile shortcut mac; create chrome profile shortcut mac; chrome profile desktop shortcut mac; chrome profile launcher | P1 | Mac-only (the SERP is full of Windows guides). Covers the Script Editor/Automator launcher with `--profile-directory`, which still runs inside the one Chrome app [Inference; test first], and why it doesn't give separate Cmd-Tab entries. Then the separate-app route. | pillar, /chrome-profiles-dock-icons, home |
| /guides/switch-chrome-profiles-mac | chrome profile switch shortcut mac; switch between chrome profiles mac; chrome switch profile keyboard shortcut; how to open different chrome profile | P2 | Tested shortcuts (Cmd+Shift+M is reported by several sites; test it before publishing), the Profiles menu bar item, Cmd+`, and switching by app with Cmd-Tab. | pillar, /chrome-profiles-command-tab |
| /guides/run-multiple-chrome-instances-mac | run multiple instances of chrome mac | P2 | Honest `--user-data-dir` explainer. Separate data dir means a fresh profile, so you sign in again. This is the free DIY version of what Tabloom automates. | pillar, home |
| /guides/work-personal-chrome-profiles-mac | chrome work personal profiles mac; chrome work vs personal profile | P2 | Practical setup: one Google account per profile, sync per profile, a separate Dock icon and Space per context. Note that managed Workspace profiles are an IT topic. | pillar, /chrome-profiles-dock-icons |
| /guides/cmd-tab-chrome-windows | separate chrome windows command tab; mac command tab between chrome windows | P2/P3 | One-line answer (Cmd+` cycles windows of the same app), then why profiles don't split in Cmd-Tab. | /chrome-profiles-command-tab, pillar |

---

## Comparison pages (BOFU; strict honesty)

| Page | Keywords | Priority | Must say |
|---|---|---|---|
| /compare/unbundle | unbundle alternative; unbundle chrome profiles | P2 | Unbundle ($6.99) states it uses your existing profile folders and auto-rebuilds after Chrome updates (unbundle.app, accessed 2026-11-05). Tabloom is $4.99 and uses fresh profiles. Recommend Unbundle for anyone who needs existing profiles. |
| /compare/parall | parall chrome profiles | P3 | Parall is a general parallel-app launcher (Mac App Store) that can also make per-profile Chrome Dock apps. Compare only on facts from its listing. |
| /compare/epichrome-alternatives | epichrome alternative | P2 | Epichrome is discontinued (final version 2.4.27, per its GitHub README). It made site-specific apps, which is a different job, so be clear about that. Also list Tabloom on AlternativeTo. |

---

## Not targeted
- how to add chrome profile shortcut to desktop (Windows audience)
- chrome profile location on mac
- two chrome windows side by side mac

---

## Publishing sequence
1. home
2. /chrome-profiles-dock-icons
3. /chrome-profiles-command-tab
4. /guides/chrome-profile-shortcut-mac
5. pillar
6. /compare/unbundle
7. run-multiple-instances
8. switch guide
9. work-personal
10. cmd-tab-windows
11. Parall and Epichrome comparisons

Every guide carries a "Tested on macOS X / Chrome Y, <date>" line.
