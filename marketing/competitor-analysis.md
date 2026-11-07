# Tabloom: Competitor Analysis

**Research date:** 2026-11-05 (all sources below were accessed on 2026-11-05)
**Product being positioned:** Tabloom (working name). It is a native macOS utility that turns Chrome profiles into separate .app bundles. Each one gets its own Dock tile, its own icon, and its own entry in the native Command-Tab switcher. It needs no custom switcher and no Accessibility permission. Planned price: $4.99 one-time.

Labels: **[Verified]** means seen at the cited source. **[Inference]** means my own analysis. **[Hypothesis]** means untested and needs validation.

---

## 1. Methodology

- I used live web search (standard and extended) and fetched the vendor pages, App Store listings, GitHub repos, Product Hunt pages, forum threads, and the HN Algolia API.
- For each named product (Unbundle, ProfileDock, Superdock, Okie Dockie, "Chrome Profile Switcher"), I went to the official site and/or repo. I also covered adjacent tools found along the way (Parall, Parallel Spaces, DockSpark, link routers, site-specific-browser builders, DIY scripts, browser-native options).
- To gauge search visibility, I ran these queries through the WebSearch tool: "chrome profiles command tab mac separate app", "separate dock icon for each chrome profile mac cmd tab", "chrome profile as separate app mac command tab switcher", "reddit chrome profiles separate app cmd+tab macOS", and "ProfileDock mac chrome profiles". The search tool is US-only and its ranking is not Google's, so the visibility notes are indicative only. They are not rank tracking.
- I did not install, buy, or test any competitor app. Every product claim comes from the vendor's own page unless a third-party source is cited.
- Traction numbers appear only where a source shows them publicly. Anything else is written as "not public".

---

## 2. Comparison table

| Product | Approach | Native Cmd-Tab per profile? | Uses existing Chrome profile/logins? | Permissions | Price | Distribution | Browsers | min macOS |
|---|---|---|---|---|---|---|---|---|
| **Tabloom** (planned) | Separate .app per profile, own bundle ID and PID | Yes (checked programmatically; overlay not yet confirmed visually) | **No, not yet.** Each app uses a fresh profile; Chrome Sync restores bookmarks and extensions | None claimed | $4.99 one-time | TBD | Chrome | TBD |
| **Unbundle** | Full copy of Chrome.app per profile (~500MB each), new bundle ID, ad-hoc signed, shell wrapper passes `--profile-directory` [Verified] | Claims "Real Cmd+Tab" [Verified claim] | Claims each app "points to your existing profile folder" [Verified claim; see the Unbundle section for a technical doubt] | None listed | $6.99 one-time | Direct .dmg plus Stripe checkout; also a free DIY script | Chrome only | 13 |
| **Superdock** | Replaces the macOS Dock; one Chrome process; maps windows to profiles by window title | No. Offers its own Option-Tab or Cmd-Tab window switcher | Yes (Chrome itself untouched) | Accessibility (required), Screen Recording (optional) | Dock free; profile icons $7.99 once (list price $13.99), 14-day trial, 5 Macs | Direct .dmg, Developer ID signed and notarized | Chrome only | 14 |
| **Okie Dockie** | Menu-bar app; a launcher app per profile that focuses that profile's existing window; plus snapping and other extras | Not stated; ships an Option-Tab window switcher | Yes (claims logins and extensions are untouched) | Accessibility (required) | Free core; Chrome profile icons $19 one-time, 3 Macs, 7-day trial | Direct, notarized | Chrome (plus Beta, Dev, Canary) | 13 |
| **ProfileDock** (kunilingvistador) | Dock shortcut bound to a specific open Chrome window | **No.** The site says it explicitly | Yes | Automation (Apple Events) | Free, MIT | GitHub ZIP, not notarized, beta 0.1.x | Chrome only | 13 |
| **Parall** | Shortcut apps that launch the target app with a separate identity and optional separate data | Version notes mention "improved compatibility with Command-Tab app switchers" | Optional separate data path | Not listed | $10.99 | Mac App Store | Chrome and Chromium browsers, Firefox, others | 10.11 |
| **Parallel Spaces** | Multi-instance launcher; cloned app per instance with badged Dock icon | Not stated | Separate copies; sign in again for each | Not listed | $4.99 | Mac App Store | General apps; Chrome clone bugs fixed in 1.0.2 and 1.0.4 | 14 |
| **DockSpark** | Hover panel over the browser's Dock icon that lists its profiles | No (switching only, one icon) | Yes | Accessibility, Automation, Full Disk Access (optional) | Free for 1 browser and 3 profiles; $0.99 to $2.99 early-bird | GitHub .dmg, Homebrew tap | 10 browsers incl. Safari, Arc, Firefox | 14 |
| **Velja / Choosy / OpenIn / Finicky / Bumpr / Browserosaurus** | Link routers / browser pickers | No | Route links to existing profiles | Default-browser role | $0 to $10 | Mixed (see the link-router section) | Many | Mixed |
| **Coherence X6 / Unite / Fluid** | Turn a website into a Chrome-engine (or WebKit) app | One app per site, not per profile | Can import browser data and extensions | n/a | Coherence X6 from $39.99 (TidBITS); free tier of 1 app | Direct, Setapp | Chromium engines | 13.5 (X6, per one listing) |
| **DIY scripts** (chrome-schismator, Unbundle DIY script, demonbane/stefansundin gists, Platypus gists) | Wrapper .app bundles using `--user-data-dir` or `--profile-directory` | Some do; commenters report Cmd-Tab entries | Varies | n/a | Free | GitHub / gist | Chrome | n/a |
| **Orion (Kagi)** | Browser-native profiles that run as separate apps | Profiles appear as separate Dock apps | n/a (Orion, not Chrome) | n/a | Free (Orion+ for some icon options) | Direct | Orion only | n/a |

---

## 3. Per-competitor sections

### 3.1 Unbundle: the closest direct competitor
**Sources:** https://www.unbundle.app/ and https://www.unbundle.app/blog/how-it-works (accessed 2026-11-05)

- **Positioning [Verified]:** The headline is about unbundling your Chrome profiles. Each profile gets its own Dock icon, Cmd+Tab entry, and Space. The footer says it is aimed at developers who juggle many contexts.
- **Features [Verified, vendor claims]:** It auto-detects profiles and adds a coloured badge to each Dock icon. It supports per-profile Spaces assignment and custom icons. After a Chrome update it rebuilds the app automatically (about 5 seconds, on next launch). Camera, mic, and screen-recording permissions are said to carry over. It promises no config files or scripts.
- **Technical approach [Verified, from its own DIY blog]:** It makes a full `cp -R` copy of Chrome.app (about 500MB per profile; five profiles is about 2.5GB). It then rewrites `CFBundleIdentifier` and the bundle names with PlistBuddy, removes the Keystone updater, and points `KSUpdateURL` at localhost. The original binary is renamed `Google Chrome.orig`, and a shell script that `exec`s it with `--profile-directory` takes its place. Finally it runs `xattr -cr`, ad-hoc signs with `codesign -s -`, and registers the app with Launch Services. The DIY page never mentions `--user-data-dir`.
- **Pricing and licensing [Verified]:** $6.99 one-time with no subscription or account. Payment is through a Stripe payment link. No licence terms, refund policy, trial, or seat limit are stated.
- **Distribution [Verified]:** Direct `/unbundle.dmg`. No Mac App Store or Setapp listing was found. The site does not say whether the app is notarized.
- **Browsers:** Chrome only [Verified]. **Requirement:** macOS 13+ [Verified].
- **Social and trust signals [Verified]:** No developer name and no social links. The only contact is a personal Gmail address. No testimonials and no user counts.
- **Reviews and traction:** I found no Product Hunt listing, no HN story (HN Algolia search for "unbundle chrome" returned nothing relevant), and no Reddit threads. Traction is not public.
- **Search visibility:** It appeared for an exact-name query ("unbundle.app" / "Unbundle Chrome profile mac app") and for one combined query. It did **not** surface for the generic queries "chrome profiles command tab mac separate app" or "separate dock icon for each chrome profile mac cmd tab" [Verified for this search tool only].
- **Weaknesses:**
  - It takes about 500MB of disk per profile and copies Google's binary, with Keystone removed. [Verified]
  - The ad-hoc signed copies may raise Gatekeeper and Keychain issues, and Unbundle documents neither. [Verified that they are not documented; impact is a Hypothesis]
  - **Technical doubt [Hypothesis, needs testing]:** Unbundle says each app points at the *existing* profile folder, and its wrapper only passes `--profile-directory`. That suggests all copies share Chrome's default user-data-dir. Chrome normally allows only one process per user-data-dir (the process-singleton lock), so a second copy, or regular Chrome already running, could hand the window off to the first process instead of running as an independent app. If so, the "separate Cmd-Tab entry per profile" claim may only hold when one copy runs at a time. Tabloom's own spike reached the same conclusion: each app needs its own user-data-dir. **This needs a hands-on test before it is used in any marketing.**
  - No identifiable developer, no refund policy, and Gmail support are a trust gap for a $6.99 app that modifies Chrome. [Inference]
  - Copying and redistributing a modified Chrome bundle, plus "Chrome" in the positioning, carries trademark and licensing risk. The site does carry a non-affiliation disclaimer. [Inference]

### 3.2 Superdock
**Sources:** https://superdock.app/, https://superdock.app/about.html, https://superdock.app/compare/ (accessed 2026-11-05)

- **Positioning [Verified]:** Shows Chrome profiles in the macOS Dock. It is a free Dock replacement whose paid feature is Chrome profile icons.
- **Approach [Verified]:** It hides the system Dock while running (a watchdog restores it if Superdock crashes). It keeps one Chrome process and matches windows to profiles using window titles and Chrome's profile list.
- **Cmd-Tab [Verified]:** It does not create separate Cmd-Tab entries. It offers its own window switcher bound to "Option-Tab or Command-Tab".
- **Permissions [Verified]:** Accessibility is required. Screen Recording is optional.
- **Pricing [Verified]:** The Dock is free. Chrome profile icons cost $7.99 one-time (launch price, down from $13.99), with a 14-day trial and 5 Macs per licence. Payment is via Lemon Squeezy, and volume pricing is available.
- **Distribution [Verified]:** Direct .dmg, Developer ID signed and notarized, signed update feed. Not on the Mac App Store.
- **Limitations [Verified, from the vendor's comparison page]:** Chrome only. It cannot tell apart two profiles with the same name. It replaces the Dock entirely. The site uses Google Analytics.
- **Developer and social [Verified]:** Mahad Kazmi, a solo developer, with links to GitHub and LinkedIn. The site states there are no testimonials yet, and launch was around September 2026.
- **SEO note [Verified]:** It publishes a "Superdock vs 10 Mac dock apps" comparison page. That page ranks for name queries and names Okie Dockie, DockSpark, and Parallel Spaces, but **not Unbundle**.
- **Weakness for its users [Inference]:** People who only want profile separation must swap out their whole Dock and grant Accessibility. The approach is fragile when window titles change.

### 3.3 Okie Dockie
**Sources:** https://okiedockie.app/ and https://okiedockie.app/blog/switch-chrome-profiles-mac/ (accessed 2026-11-05)

- **Positioning [Verified]:** Multiple Chrome profiles, each with its own Dock icon. It is a menu-bar app with many extras: snap layouts, Option-Tab window switcher, Dock hover lists, display tools, and AI image and text utilities.
- **Approach [Verified]:** It creates a launcher app per profile, badged with the profile picture. Clicking the launcher raises that profile's existing window, or opens a new one if the profile has none. Chrome is not modified.
- **Cmd-Tab:** Not stated on the site [Verified absence]. Its own window switcher uses Option-Tab.
- **Permissions [Verified]:** Accessibility is required. The site says the app stops working without it.
- **Pricing [Verified]:** The core is free. Chrome profile icons are $19 one-time across 3 Macs, with a 7-day trial and email-code activation. It works offline for 14 days if the licence server is unreachable.
- **Distribution [Verified]:** Direct, notarized, in-app updates. **Browsers:** Chrome plus the Beta, Dev, and Canary channels; Safari is explicitly not supported. **Requirement:** macOS 13+, Intel and Apple Silicon.
- **Developer and social [Verified]:** A company based in Ambala City, Haryana, India, with no named individual. No social links and no testimonials.
- **SEO [Verified]:** It runs an active content blog: "How to Switch Between Chrome Profiles Quickly on a Mac" (updated 2026-09-18), "Where Chrome Keeps Profile Folders on a Mac", and "Why Chrome opens a new window instead of your existing one". These pages surfaced for exact-name queries in my searches.
- **Weakness [Inference]:** It is the most expensive option in the category at $19, has a sprawling feature set, and requires Accessibility.

### 3.4 ProfileDock (kunilingvistador): the Chrome one
**Sources:** https://kunilingvistador.github.io/ProfileDock/en/, https://github.com/kunilingvistador/ProfileDock, https://kunilingvistador.github.io/ProfileDock/en/guides/chrome-profile-shortcuts-mac-dock/ (accessed 2026-11-05)

- **Name collision [Verified]:** Two unrelated projects also use the name ProfileDock: breukr/profiledock (a ChatGPT/Codex companion) and nothingness-dev/ProfileDock (a Python Chromium CLI).
- **Positioning [Verified]:** Chrome profiles, each in your Dock. It provides free native Dock shortcuts for your existing Chrome windows.
- **Approach [Verified]:** Each shortcut is bound to a specific *open, named* Chrome window, and clicking it raises that window. Optional global hotkeys are available.
- **Cmd-Tab [Verified]:** The site says explicitly that shortcuts do not make profiles independent apps in Cmd-Tab.
- **Limitations [Verified]:** Bindings break when a window is closed or renamed, or Chrome restarts, and must be reconnected. Hotkeys need the menu-bar app running. Spaces, fullscreen, Stage Manager, and multi-monitor setups are untested. Chrome only. Builds are ad-hoc signed and not notarized.
- **Pricing and licence [Verified]:** Free, MIT.
- **Distribution [Verified]:** GitHub ZIP with SHA-256 checksums. Version 0.1.7 beta per the site; the README references 0.1.4 to 0.1.5.
- **Traction [Verified]:** 0 GitHub stars at time of access. A PR to add it to the open-source-mac-os-apps list exists (serhii-londar/open-source-mac-os-apps PR #1357).
- **SEO [Verified]:** The project has a guide page. It appeared in results for "Chrome Profile Switcher" and for an Unbundle-related query, and its page title literally includes "Chrome Profile Switcher for Mac".

### 3.5 "Chrome Profile Switcher": no single macOS app by that exact name verified
**Sources:** search results (accessed 2026-11-05), https://github.com/alvesjtiago/proswitch, https://github.com/stefanz92/chrome-profile-picker, https://github.com/garethj/chrome-profile-switcher

- I found **no Mac App Store app named exactly "Chrome Profile Switcher"** [Verified absence in the search tool]. The name is used generically by:
  - ProfileDock's page title (see 3.4);
  - **proswitch** (alvesjtiago), a status-bar Chrome profile switcher on GitHub;
  - **garethj/chrome-profile-switcher**, a Chrome extension plus native messaging host;
  - **chrome-profile-picker** (stefanz92), which picks a profile per link and needs macOS 14+;
  - **"Chrome Profile Window Switcher"**, a Chrome Web Store extension that only cycles the current profile's windows.
- None of these create separate Cmd-Tab apps [Verified for what each page describes].

### 3.6 Parall: an indirect competitor with App Store reach
**Sources:** https://apps.apple.com/app/parall/id6754065114 and https://talk.macpowerusers.com/t/parall-run-the-same-mac-app-separately-with-its-own-data-and-dock-icon/45561 (accessed 2026-11-05)

- **Positioning [Verified]:** "Multiple Instances, No Copies." A general multi-instance launcher that creates shortcut apps, each with its own Dock icon, name, and optional separate data.
- **Chrome relevance [Verified]:** Separate Chrome shortcuts with separate data (e.g. work and personal). It has per-shortcut fullscreen overrides for Chromium browsers. Version 2.4.5 notes improved compatibility with Command-Tab switchers. It also supports Firefox, Vivaldi, Orion, Zen, Comet, and others.
- **Pricing and distribution [Verified]:** $10.99 on the Mac App Store, developer Ihor July. Requires macOS 10.11+. Version 2.5.0 is recent.
- **Reviews [Verified]:** The App Store shows no rating overview because there are not enough ratings. Reviews are positive about separate Chrome Dock icons. One review reports recurring Microsoft Teams session and login problems; the developer replied that 2.4.7 fixed them.
- **Social [Verified]:** The developer posted on the MacPowerUsers forum (May 2026). The post was flagged and later restored, with 7 visible replies.
- **SEO [Verified]:** The App Store listing surfaced for several generic queries, including "chrome profiles command tab mac" and "separate dock icon for each chrome profile". It is the most visible paid product for the generic queries I ran.

### 3.7 Parallel Spaces
**Sources:** https://apps.apple.com/us/app/parallel-spaces/id6772172563?mt=12 and https://www.producthunt.com/products/parallel-spaces-2 (accessed 2026-11-05)

- **Positioning [Verified]:** "Run Two Accounts at Once." A multi-instance launcher; each clone gets its own account, data, settings, and badged Dock icon.
- **Pricing and distribution [Verified]:** $4.99 on the Mac App Store. Developer Satnam Singh. Requires macOS 14+.
- **Chrome [Verified]:** The changelog shows Chrome-specific bug fixes: Chrome instance creation failed (fixed in 1.0.2), and cloned Chrome apps could not load pages (fixed in 1.0.4). Every instance needs its own sign-in (per the Superdock comparison page).
- **Traction [Verified]:** 5 points on Product Hunt and no reviews there. The App Store has too few ratings to show an overview. Its two visible reviews are positive but about Roblox, Claude, and WhatsApp, not Chrome.
- **Note [Inference]:** It sits at **the same $4.99 price point as Tabloom**, on the App Store, and already covers Chrome as one of many apps.

### 3.8 DockSpark
**Sources:** https://dockspark.app/ and https://github.com/DockSpark (accessed 2026-11-05)

- **Approach [Verified]:** Hover a browser's Dock icon to get a panel with its profiles and a private window. It keeps one icon per browser.
- **Browsers [Verified]:** Ten: Safari, Chrome, Firefox, Chromium, Edge, Brave, Vivaldi, Opera, Opera GX, Arc. Firefox Developer Edition and Nightly are not yet supported.
- **Permissions [Verified]:** Accessibility; Automation as needed; Full Disk Access to read profile folders.
- **Pricing [Verified]:** Free for 1 browser and 3 profiles. Early-bird licences are $0.99 (1 Mac), $1.99 (2 Macs), and $2.99 (5 Macs).
- **Distribution [Verified]:** GitHub .dmg and Homebrew tap (`dockspark/tap/dockspark`). Beta, with an early-access waitlist mentioned.
- **Traction [Verified]:** 2 GitHub stars. It has Instagram, X, and Bluesky links.
- **Cmd-Tab:** Not addressed; it is not separate apps.

### 3.9 Link routers and browser pickers (adjacent; they solve "which profile opens this link", not Cmd-Tab)
Sources accessed 2026-11-05:
- **Velja** (https://sindresorhus.com/velja): routes links to Chrome profiles via rules. $10 one-time, Mac App Store, requires macOS 26+. [Verified]
- **Choosy** (https://choosy.app/): handles profiles for Chrome, Edge, Brave, and Vivaldi. $10 one-time, direct download. [Verified]
- **OpenIn 4** (https://loshadki.app/openin4/): supports Chromium profile arguments and Safari profiles. Available on the Mac App Store, direct, and **Setapp**. No price shown on the page. [Verified]
- **Finicky** (https://github.com/johnste/finicky): about 5.2k stars, MIT, Homebrew cask. Profile support is not mentioned on the repo page. [Verified]
- **Browserosaurus** (https://github.com/will-stone/browserosaurus): about 2.0k stars. **Archived 2025-08-02, no longer maintained.** [Verified]
- **Bumpr** (https://apps.apple.com/app/bumpr/id1166066070): browser and mail picker. US listing $2.99 per the search result; other storefronts differ. [Verified via search snippet; page not fetched directly]
- **Yojam** (Show HN, 2026-04-19, 4 points): routes links to the right browser or profile. [Verified via HN Algolia]
- **Relevance [Inference]:** These are complements, not substitutes. A Tabloom user still needs links to land in the right profile app, and these tools only support Chrome's own `--profile-directory` targets. Whether they can target Tabloom's per-profile apps is a possible integration angle [Hypothesis].

### 3.10 Site-to-app tools (Coherence X, Unite, Fluid)
Sources accessed 2026-11-05: https://alternativeto.net/news/2026/9/coherence-x6-launches-as-the-biggest-update-yet-bringing-native-feel-chrome-apps-to-mac/, https://tidbits.com/watchlist/coherence-x-6-0/ (via search snippet), https://setapp.com/how-to/convert-website-to-apps-with-unite (via search snippet)
- **Coherence X6** (BZG, released 2026-09-09) turns a *website* into a Chrome-engine app. It can import browser data and extensions. The 14-day trial was replaced by a free tier of one app. TidBITS lists $39.99 for 1 Mac. [Verified per the cited snippets]
- **Unite** is on Setapp [Verified via Setapp how-to]. **Fluid** is WebKit-based; a forum user describes it as dated, and its current price is unverified.
- **Relevance [Inference]:** These tools are per-site, not per-profile, and much more expensive. They overlap only for users who want a single web app (e.g. Gmail) as its own Cmd-Tab entry.

### 3.11 Browser-native options
- **Chrome:** An Apple Community thread (https://discussions.apple.com/thread/256202449, posted 2025-12-03) has a user claiming Chromium 140+ removed native per-profile Dock icons on macOS. That is a **user claim, not confirmed by Google release notes** [Verified as a claim only]. Chrome's "Create shortcut" makes per-*site* app shims, not per-profile app identities (Jamf forum, via search snippet).
- **Edge:** I found no built-in per-profile Dock icon setting. Microsoft Tech Community threads show users relying on `open -n ... --profile-directory` and reporting that the argument is sometimes ignored, along with feature requests for a profile badge on the icon (https://techcommunity.microsoft.com/t5/discussions/how-to-create-separate-shortcuts-for-different-profiles-on-mac/m-p/968168). [Verified]
- **Orion (Kagi):** Profiles appear as separate apps in the Dock (https://help.kagi.com/orion/features/profiles.html) [Verified]. Users on orionfeedback.org complain about Dock clutter, and one feedback-thread commenter argued that one Dock icon with multiple Cmd-Tab entries isn't possible on macOS [Verified as a forum claim]. This is evidence that per-profile apps are a known, accepted model in another browser.
- **Firefox:** A Mozilla Connect idea asks for per-profile Dock icons on macOS (https://connect.mozilla.org/t5/ideas/macos-per-profile-dock-icons-that-launch-the-correct-profile/idi-p/129079), which shows demand. [Verified that the idea exists; vote count not captured]
- **Arc / Dia / Safari:** These rely on in-app Spaces or profiles inside one app process (per https://supasidebar.com/blog/browser-profiles-mac-2026). None of them give per-profile Cmd-Tab entries [Inference from single-app architecture; not tested].

### 3.12 DIY scripts on GitHub
- **chrome-schismator** (https://github.com/djbclark/chrome-schismator): 49 stars, 7 forks, 3 open issues. Separate Chrome instances, each with its own Dock icon and its own Window menu. The author notes that pinning an instance to a desktop doesn't work yet. [Verified]
- **demonbane gist** (https://gist.github.com/demonbane/1065791) and **stefansundin fork** (https://gist.github.com/stefansundin/c89fd15bae5a58831790, last updated March 2025): `--app` plus `--user-data-dir` wrappers. Commenters report the app shows up in Cmd-Tab. Problems they report: extensions must be reinstalled, a conflict with main Chrome ("thinks it's already running"), links opening in the wrong app, and notifications. [Verified via search summary of the gist comments]
- **kavyasukumar gist** (https://gist.github.com/kavyasukumar/a9605f56c4888ee963d1b6cdde31062c): Platypus launcher with `open -na ... --profile-directory`. 0 stars, last active May 2025. [Verified]
- **Unbundle's own free `unbundle-profile.sh`** (see 3.1). [Verified]
- **Tutorials** that teach the same approach: dev.to "How to run multiple instances of Google Chrome on Mac" and a Medium article on per-context `--user-data-dir`. [Verified via search results]

### 3.13 Other names surfaced
- **HopTab** (https://hoptab.pages.dev/): open-source pinned-app switcher with profiles tied to Spaces. Pro is $5 one-time. A custom switcher, not per-profile Chrome apps. [Verified via search snippet]
- **SpaceDeck** (https://spacedeck.app/learn/multiple-chrome-profiles-mac/): an "app-aggregation browser" that publishes SEO content on Chrome profiles and states that Cmd-Tab can't switch profiles. [Verified]
- **Profile Beacon** and **Profilissimo**: Chrome extensions for profile identification and switching. [Verified via search snippet only]

---

## 4. Search visibility snapshot (WebSearch tool, US, 2026-11-05)

| Query | What surfaced (relevant) | Dedicated per-profile-app tool visible? |
|---|---|---|
| chrome profiles command tab mac separate app | Parall (App Store), generic guides, gists, SEO-spam pages | Parall only. **Unbundle did not appear** |
| separate dock icon for each chrome profile mac cmd tab | chrome-schismator, Parall, Orion feedback, Apple thread, spam pages | chrome-schismator, Parall |
| chrome profile as separate app mac command tab switcher | SpaceDeck guide, dev.to, window-switcher apps | None |
| reddit chrome profiles separate app cmd+tab macOS | Medium, Supasidebar blog, Reddit mirrors, HopTab | None |
| "Chrome Profile Switcher" mac | ProfileDock, Okie Dockie, GitHub repos | ProfileDock, Okie Dockie |

**[Inference]:** The generic SERP is dominated by DIY guides, forum threads, and low-quality SEO pages. No product clearly owns "Chrome profile Cmd-Tab". This is an open SEO and content opportunity. **[Unknown]:** search volumes (not public; none were estimated).

---

## 5. Prioritized market gaps and differentiation opportunities

1. **True native Cmd-Tab with no Accessibility permission and no Dock replacement.** [Verified that competitors fall short] Superdock and Okie Dockie both require Accessibility, and Superdock replaces the Dock. ProfileDock and DockSpark explicitly don't create separate Cmd-Tab entries. Only Unbundle, Parall, and the DIY scripts aim at separate app identities. Tabloom's "original Command-Tab, no permissions, no background process" pitch is clearly differentiated. **Caveat:** the visual Cmd-Tab overlay is not yet checked by eye, so do not claim it until it is.
2. **Small, signed, notarized, trustworthy build vs. Unbundle's 500MB-per-profile Chrome copies.** [Verified: Unbundle copies Chrome.app and ad-hoc signs it, with no named developer] Opportunity: a named developer, notarization, a refund policy, and a small disk footprint. Whether Tabloom's own bundles are small is not stated in the brief, so this must be confirmed before claiming it. Tabloom is currently ad-hoc signed too, so notarization is a prerequisite for this advantage. [Inference]
3. **Price below every dedicated Chrome-profile tool.** [Verified prices] At $4.99, Tabloom is cheaper than Unbundle ($6.99), Superdock ($7.99 launch / $13.99 list), Okie Dockie ($19), and Parall ($10.99). It matches Parallel Spaces ($4.99). DockSpark is cheaper ($0.99 to $2.99) but is a different approach. [Verified]
4. **Uncontested SEO for "Chrome profiles in Cmd-Tab" intent.** [Inference from the searches above] No product ranked clearly for the generic queries, and Unbundle didn't surface at all. Okie Dockie and Superdock are building content, but they target "Dock icon", not "Cmd-Tab". Opportunity: an explainer page on why Cmd-Tab can't switch Chrome profiles and how to fix it, plus a fair comparison page (Superdock's comparison page omits Unbundle).
5. **Honest handling of the "existing profile" problem.** [Hypothesis] Unbundle claims each app uses the existing profile folder, which may conflict with Chrome's one-process-per-user-data-dir rule when several run at once. If testing confirms the conflict, Tabloom can win on clear, accurate claims ("each app is a fully independent Chrome instance"). Tabloom's own weakness is that it currently needs a fresh sign-in per profile, while Superdock and Okie Dockie keep existing logins. **This is Tabloom's biggest competitive liability until it is solved.** [Verified from the brief and vendor pages]
6. **Pain points at other browsers and vendors show demand.** [Verified] These include the Firefox Mozilla Connect idea, Edge Tech Community requests, the Apple Community thread on Chromium 140+, and Orion users. An optional later expansion is Edge, Brave, or Arc [Hypothesis: demand size unknown].
7. **Distribution gap: no dedicated Chrome-profile app is on the Mac App Store or Setapp.** [Verified for Unbundle, Superdock, Okie Dockie, and ProfileDock] Parall and Parallel Spaces show that per-app-identity tools can ship on the App Store. Tabloom's bundle-generation approach may conflict with sandbox rules, though Parall's shortcut apps are not sandboxed (per AlternativeTo, via search snippet) [Hypothesis].
8. **Social proof is absent across the category.** [Verified] No competitor shows testimonials, user counts, or meaningful PH, HN, or GitHub traction (ProfileDock has 0 stars, DockSpark 2, Parallel Spaces 5 PH points; Unbundle has no listings at all). A real Product Hunt and Show HN launch with a demo GIF could own the category conversation. [Inference]

---

## 6. Top competitor weaknesses (summary)
1. **Unbundle:** about 500MB per profile (a full Chrome copy), ad-hoc signed, no named developer, Gmail support, no refund or licence terms, and no search or social presence. Its "existing profile folder" claim is technically questionable when several copies run at once [Hypothesis].
2. **Superdock and Okie Dockie:** require Accessibility permission. Neither gives native per-profile Cmd-Tab entries; both ship their own switchers instead. Superdock replaces the entire Dock.
3. **Okie Dockie:** the most expensive option ($19, 3 Macs) and bloated with unrelated features (snapping, AI tools).
4. **ProfileDock:** bound to specific open windows, breaks on window close or Chrome restart, not notarized, beta, and explicitly no Cmd-Tab.
5. **Parall and Parallel Spaces:** general-purpose and not Chrome-profile-aware. Parallel Spaces had Chrome clone bugs, and Parall reports session issues with some web apps. Neither markets around "Chrome profiles in Cmd-Tab".

---

## 7. Could not verify
- **Unbundle:** notarization status, developer identity, launch date, number of users, refund policy, and whether multiple copies sharing the default user-data-dir really run as separate processes at the same time.
- **Okie Dockie:** whether its launcher apps appear as separate Cmd-Tab entries.
- **Superdock:** whether "Command-Tab, your choice" replaces the system Cmd-Tab with its own switcher. Most likely it does [Inference].
- The claim that Chromium 140+ removed native per-profile Dock icons on macOS (user forum claim only; no Google release note found).
- Any search volumes, rankings in Google itself, traffic, revenue, or download counts for any competitor (not public).
- Social follower counts for any competitor (not captured; DockSpark lists Instagram, X, and Bluesky links but counts were not checked).
- Bumpr's current US price (search snippet only), OpenIn's price (not shown on the page), Fluid's current price, and Coherence X6's full price table (secondary source only).
- Reddit threads specifically about Unbundle, Superdock, or Okie Dockie: none found.
- App Store rating counts for Parall and Parallel Spaces: Apple shows "not enough ratings" for both.
- Arc, Dia, and Safari Cmd-Tab behaviour per profile/space was not tested; the statement above is inference.
