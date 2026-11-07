# Tabloom: customer problem discovery

Research date: 2026-11-05. All sources accessed 2026-11-05.
Labels: **[Verified]** = seen at the source; **[Inference]** = my reasoning from the evidence; **[Hypothesis]** = not tested.

---

## 1. Methodology

**Sources searched:**
- **Hacker News**, through the hn.algolia.com API: story and comment search, about 25 queries (examples: "chrome profiles cmd tab", "chrome profile icon dock", "profiles cmd-tab", "firefox profiles dock icon", "epichrome", "unbundle.app"). Comment text came from the `/items/<id>` endpoint.
- **Stack Exchange** (Ask Different, Super User, Stack Overflow), through the api.stackexchange.com search API. Scores, views, answer counts and dates came from that API.
- **GitHub Issues and repos**, through the api.github.com search and issues endpoints.
- **Forums**, read with a web fetch tool: Apple Support Community, MacRumors, Microsoft Tech Community, Vivaldi forum, Orion feedback (through its Flarum JSON API), V2EX, Mac Power Users, TidBITS Talk.
- **Web search** (WebSearch) to find threads on those sites.

**Reddit was not covered (gap).** Every route returned 403 or "Blocked": reddit.com, old.reddit.com, `.json`, RSS, and the WebFetch tool. The pullpush.io archive was down (error 521). `site:reddit.com` web searches returned no Reddit URLs. Bypassing Reddit through a third-party mirror was refused by the tool's safety policy, so I did not try it. The study therefore contains **no Reddit threads**. Reddit is probably the biggest source of this kind of complaint. Covering it means a person searching r/macapps, r/chrome, r/MacOS and r/browsers by hand.

**Inclusion rule.** A discussion is included only if I actually read its text, either the post or at least the comment quoted. Engagement numbers are copied exactly as the source showed them. If a number was not shown, the row says "not visible". Blog posts and SEO pages that turned up in searches were left out (examples: supasidebar.com, jobs.doral.edu, a Medium article).

**Result:** 56 real discussions (D01 to D56), listed in the table below.

**Bias warning [Inference]:**
- HN and Stack Exchange over-represent developers and power users. This sample says little about non-technical buyers.
- Many threads are old, from 2012 to 2019. The old ones show the problem has lasted a long time. They do not show how many people want it today.

---

## 2. Discussions found

Relevance to Tabloom: **H** = describes exactly what Tabloom does (a separate app per profile, with its own Dock icon and its own Cmd-Tab entry). **M** = an adjacent pain, such as profile switching, link routing or isolation. **L** = context only.

| ID | Source | URL | Date | Problem described | Workaround used | Frustration / unmet need | Engagement | Rel. |
|---|---|---|---|---|---|---|---|---|
| D01 | Ask Different | https://apple.stackexchange.com/questions/66670 | 2012-10-08 (last activity 2025-09-29) | Wants each Chrome profile to have its own Dock icon, with windows managed separately and icons that look different | Top answer: a bash script that makes a second runnable Chrome app. Later answers: Epichrome, a multi-instance script, Chrome Beta as a second instance | One answerer says "I no longer use this method" and that Epichrome is unmaintained. 2023 answer: the script copy runs under Intel/Rosetta on Apple Silicon, is slower, and crashed 1Password. 2025 answer: 1Password Touch ID fails in copied instances | Score 52, 59,748 views, 7 answers | H |
| D02 | Ask Different | https://apple.stackexchange.com/questions/157818 | 2014-11-23 | Wants a keyboard shortcut to switch between Chrome profiles; Cmd+~ stopped doing it on Yosemite | Cmd+~ (from the answers) | Wants switching to be a single keystroke | Score 7, 19,755 views, 3 answers | H |
| D03 | Ask Different | https://apple.stackexchange.com/questions/216058 | 2015-11-17 | Developer coming from Windows wants another Chrome profile available on demand as its own icon in the Dock or on the desktop | Has `open -a "Google Chrome" --args --profile-directory=...` and asks how to turn it into a shortcut | Points out it is easy on Windows | Score 5, 13,800 views, 4 answers | H |
| D04 | Ask Different | https://apple.stackexchange.com/questions/414609 | 2021-02-27 | Made web-app shortcuts for Gmail from two profiles; the second one overwrites the first | None found | No way to keep a per-profile shortcut for the same site | Score 1, 222 views, 0 answers | M |
| D05 | Super User | https://superuser.com/questions/893493 | 2015-03-24 | Wants a single keyboard shortcut to switch between Work and Home Chrome profiles | Ctrl+Shift+M followed by arrow keys | "I don't want to hit that many keys"; switches often | Score 4, 3,708 views, 2 answers | H |
| D06 | Super User | https://superuser.com/questions/1144518 | 2016-11-10 | Switching between private and work "Persons" in Chrome takes three steps | Not visible | Wants a one-click switch | Score 2, 112 views, 1 answer | M |
| D07 | Super User | https://superuser.com/questions/919024 | 2015-05-24 | New Mac user: Cmd+Tab shows one Chrome icon even when Chrome windows with different profiles are open | Cmd+Tab then Cmd+~ | Calls that "pretty bad compromise for a pretty basic task" | Score 0, 408 views, 1 answer | H |
| D08 | Super User | https://superuser.com/questions/377186 | 2012-01-11 (active 2025-04-14) | Chrome opens whichever profile was used last, so a work webmail shortcut opens in the Home profile | `--profile-directory` launch flag | Wants a launcher locked to one profile | Score 272, 442,683 views, 12 answers | M |
| D09 | Super User | https://superuser.com/questions/1671779 | 2021-08-27 | Wants a shortcut that opens a specific link in a specific profile; shortcuts open in the last-used profile | Not visible | Wants each launcher tied to a profile | Score 5, 12,282 views, 2 answers | M |
| D10 | Stack Overflow | https://stackoverflow.com/questions/5451439 | 2011-03-27 | Runs Chrome instances with separate `--user-data-dir` so they show up separately in Cmd-Tab; wants a "2" or "3" drawn on each icon in the Dock and Cmd-Tab | AppleScript shell launcher | Can't tell the instances apart in the Dock or in Cmd-Tab | Score 4, 8,761 views, 4 answers | H |
| D11 | Super User | https://superuser.com/questions/737419 | 2014-04-03 | Saved passwords seemed to show up in both the work and personal profiles | VM test | Doubts that profiles are really isolated | Score 1, 1,254 views | L |
| D12 | HN comment | https://news.ycombinator.com/item?id=10727663 | 2015-12-13 | Chrome profiles can't be switched with Cmd-Tab | None | Wants profiles to "act exactly like two separate applications with two different icons" | not visible | H |
| D13 | HN comment | https://news.ycombinator.com/item?id=21257298 | 2019-10-15 | Six Chrome profiles plus other apps; the Cmd-Tab then Cmd-` dance is awkward, and on German keyboards the key is not even a backtick | HyperSwitch / alt-tab-style switcher | Has to alternate Cmd-Tab and Cmd-` over and over | not visible | H |
| D14 | HN comment | https://news.ycombinator.com/item?id=21257685 | 2019-10-15 | Cmd-Tab brings forward every window of an app, including irrelevant browser windows | Wants Windows-style window switching | The wrong browser window comes to the front | not visible | M |
| D15 | HN comment | https://news.ycombinator.com/item?id=37953460 | 2023-10-20 | Runs a Chrome instance per client or activity, each with its own icon, color, extensions and adblock rules | Self-built multiple Chrome instances | "It wasn't easy to get working perfectly"; uses it for focus and for blocking distractions | not visible | H |
| D16 | HN comment | https://news.ycombinator.com/item?id=34766941 | 2023-02-12 | Separate Chrome "applications", one per profile, for dev, media and general browsing; each gets its own Cmd-Tab entry and icon | Own scripts: CoW clone of Chrome, re-codesign after each update | Updates go through the main browser; automatic updates are buggy; codesigning has to be redone | not visible | H |
| D17 | HN comment | https://news.ycombinator.com/item?id=37954987 | 2023-10-20 | On Mac all Chrome profiles are one instance: quitting one quits them all; Firefox is the opposite | None | Wants to quit one profile without quitting the others | not visible | H |
| D18 | HN comment | https://news.ycombinator.com/item?id=45340904 | 2025-09-22 | Cmd-~ doesn't use most-recent ordering the way Cmd-Tab does; "I get caught up on this constantly" | Moved personal browsing to a different browser so it gets its own Cmd-Tab entry | Changed browsers just to get a separate Cmd-Tab entry | not visible | H |
| D19 | HN comment | https://news.ycombinator.com/item?id=33311479 | 2022-10-23 | Windows shows an icon per Chrome profile in the taskbar; Mac does not | None | Compares Mac unfavorably with Windows | not visible | H |
| D20 | HN comment | https://news.ycombinator.com/item?id=43206720 | 2025-02-28 | Likes that Orion shows a different Dock icon per profile; Chrome profiles all share one icon | Orion browser | Points to Orion's behavior as the better model | not visible | H |
| D21 | HN Show HN (Parall) | https://news.ycombinator.com/item?id=45678032 | 2025-10-23 | The developer was surprised macOS can't easily run "two browser profiles with separate Dock icons"; Terminal scripts were clunky and broke after app updates | Parall (paid app) | Scripts broke after updates | not visible | H |
| D22 | HN Ask HN | https://news.ycombinator.com/item?id=41225324 | 2024-08-12 | One Chrome window per profile; links from other apps open in the wrong profile window | Reply: drag links by hand, or write a URL-handler script | "This has been bugging me for a long time" | 1 point, 2 comments | M |
| D23 | HN Show HN (Yojam) | https://news.ycombinator.com/item?id=47822198 | 2026-04-19 | Link router: author says other pickers don't treat browser profiles as real targets | Yojam | Wants links routed to the right profile | 4 points, 2 comments | M |
| D24 | HN Show HN (Donut Browser) | https://news.ycombinator.com/item?id=44132752 | 2025-05-30 | Managing many browser profiles; the author wants a less cluttered Dock. One commenter runs "6 browsers for 6 different independent profiles"; another says Firefox links open in the wrong profile | Donut Browser | Dock clutter; links open in the wrong profile | 91 points, 41 comments | M |
| D25 | HN comment | https://news.ycombinator.com/item?id=30344406 | 2022-02-15 | Firefox profiles give three identical "Firefox" Dock icons, and they often pick the wrong one | None | Identical icons can't be told apart | not visible | H |
| D26 | HN comment | https://news.ycombinator.com/item?id=40443271 | 2024-05-22 | Firefox profiles on macOS "mess up" Dock icons and open behind the current window | None | "There's no way around this" | not visible | M |
| D27 | HN comment | https://news.ycombinator.com/item?id=44955445 | 2025-08-19 | Same Firefox problem: profile windows open in the background and the Dock icon gets messed up; the `-P` launch flag doesn't work from shortcuts | None | No GUI way to launch a profile | not visible | M |
| D28 | HN comment | https://news.ycombinator.com/item?id=44955691 | 2025-08-19 | Launches Firefox profiles from a script with `--no-remote -P` and a slightly modified icon per profile | Hand-made app per profile | Building it is manual work | not visible | H |
| D29 | HN comment | https://news.ycombinator.com/item?id=23032130 | 2020-04-30 | Advice: keep two Chrome profiles open and switch between them with Cmd-` | Cmd-` | (This is the workaround itself) | not visible | M |
| D30 | HN comment | https://news.ycombinator.com/item?id=16397848 | 2018-02-17 | Chrome app shortcuts in the Dock still open their windows inside Chrome's own window group | None | Argues "process" and "application" need to be separate concepts | not visible | M |
| D31 | HN comment | https://news.ycombinator.com/item?id=29537863 | 2021-12-13 | How to launch a specific Chrome profile on macOS | `open -a "Google Chrome" --args --profile-directory=` | Needs Terminal | not visible | M |
| D32 | HN comment | https://news.ycombinator.com/item?id=31021062 | 2022-04-13 | Built their own browser chooser that can pick a Chrome profile; other tools are Electron, lack profile support, or aren't on Mac | Self-built | Existing tools fall short | not visible | M |
| D33 | HN comment | https://news.ycombinator.com/item?id=20421347 | 2019-07-12 | With three Chrome profiles they have to sign in to 1Password three times | None | "Super annoying" | not visible | L |
| D34 | HN comment | https://news.ycombinator.com/item?id=37748041 | 2023-10-03 | Used WebCatalog, Coherence X, Unite and Epichrome for isolated apps; these tools are one-person projects that "get buggy and unwell after a couple years" | Those tools, then Safari web apps | Doesn't trust small tools to keep working | not visible | H |
| D35 | HN comment | https://news.ycombinator.com/item?id=25920308 | 2021-01-26 | Uses Epichrome to keep separate G Suite accounts logged in, with their tabs restorable as a workspace | Epichrome | Wants per-account workspaces kept out of the main browser | not visible | H |
| D36 | HN comment | https://news.ycombinator.com/item?id=47475923 | 2026-03-22 | Cmd-Tab with Safari profile windows on different Spaces throws them to the wrong Space | HopTab (evaluating) | "Constant pain" | not visible | M |
| D37 | HN Show HN (SwitchBoard) | https://news.ycombinator.com/item?id=48673139 | 2026-06-25 | Uses three browsers; links from Slack and Terminal open in the wrong browser or profile | SwitchBoard | Copy-paste workaround "got old" | 1 point, 0 comments (per API) | M |
| D38 | HN Show HN (ShiftPlus) | https://news.ycombinator.com/item?id=44982391 | 2025-08-22 | Juggles browser profiles and windows across work, personal and side projects | ShiftPlus | Wasting time rearranging windows and logging in and out | 1 point | M |
| D39 | GitHub issue (Parall #13) | https://github.com/JulyIghor/Parall/issues/13 | 2026-02-26 | Paid Parall user with four existing Chrome profiles wants an app per profile, each with its own Dock icon that brings that profile's window to the front | Developer's reply: create shortcuts, copy all Chrome data into each one, then delete the other profiles in each copy | Can't reuse existing profiles without a complicated manual copy | 1 comment | H |
| D40 | GitHub issue (Parall #11) | https://github.com/JulyIghor/Parall/issues/11 | 2026-02-13 | All Chrome shortcuts stopped working after a Chrome update | Force quit | Breaks when Chrome updates | 4 comments | H |
| D41 | GitHub issue (Parall #14) | https://github.com/JulyIghor/Parall/issues/14 | 2026-03-17 | About 10 custom apps, Chrome among them, crowd the Dock | Parall's "Dock Icon Visibility" option | Dock clutter | 1 comment | M |
| D42 | GitHub issue (Parall #12) | https://github.com/JulyIghor/Parall/issues/12 | 2026-02-19 | Links don't open in the shortcut browser apps; used Vivaldi Stable for Work and Snapshot for Personal to keep them separate | Separate browser channels | Link handling breaks | 2 comments | M |
| D43 | GitHub repo + issues (chrome-schismator) | https://github.com/djbclark/chrome-schismator | repo 2015-05-26; issues 2015–2018 | Script that makes Chrome instances with separate Dock icons, one per profile. Issue #7: doesn't work well with 1Password and asks how to undo it. Issue #4: problems running normal Chrome after updates | The script | Fragile; no undo; breaks with Chrome updates | 49 stars; last push 2016-06-20 | H |
| D44 | GitHub issue (Waterfox #4140) | https://github.com/BrowserWorks/waterfox/issues/4140 | 2026-03-08 | 6–7 profiles "blend into each other" in the Dock and menu bar; running out of icons and colors | None | Needs custom per-profile icons | 2 comments | H |
| D45 | GitHub issue (Brave #19614) | https://github.com/brave/brave-browser/issues/19614 | 2021-11-19 | No "close profile" option when a profile has only one window | None | Wants to close one profile cleanly | 5 comments, 6 reactions | M |
| D46 | GitHub issue (freedom-browser #125) | https://github.com/solardev-xyz/freedom-browser/issues/125 | 2026-06-29 | **Counter-signal:** each profile shows as a separate Dock app; proposes going back to a single Dock icon | n/a | Some users don't want N Dock icons | 2 comments | H (counter) |
| D47 | Orion feedback #3389 | https://orionfeedback.org/d/3389-allow-me-to-hide-additional-profile-app-icons | 2022-10-22 to 2024-12 | **Counter-signal plus support:** Orion profiles run as separate apps. Many users want the extra Dock icons hidden. Others defend the design (sandboxing, speed, custom icons, per-profile quit). The dev says one Dock icon with several Cmd-Tab entries is probably not possible | Custom per-profile icons | Dock clutter vs. separate apps is a real trade-off | 83 votes, 51 comments, 28 participants | H |
| D48 | MacRumors forum | https://forums.macrumors.com/threads/chrome-dock-shortcuts-for-different-chrome-profiles.2115900/ | 2018-04-21 | Has work and personal taskbar shortcuts on Windows and wants Dock shortcuts per profile on Mac | None shown | "Not as easy" as Windows 10 | 0 replies visible; views not visible | H |
| D49 | Apple Support Community | https://discussions.apple.com/thread/256202449 | 2025-12-03 | Says separate per-profile launchers or Dock icons for Chrome/Edge no longer work on macOS 26; Automator workarounds are inconsistent (this cause is unverified) | Automator; Safari profiles suggested | Wants separate Spaces and no mixed sessions | 21 replies, 5 "Me too" | H |
| D50 | Apple Support Community | https://discussions.apple.com/thread/253720187 | 2022-03-05 | Switching Chrome profiles by clicking the Dock icon stopped working | None ("a Chrome based issue") | No fix given | 2 replies | M |
| D51 | Apple Support Community | https://discussions.apple.com/thread/252376395 | 2021-01-28 | After Big Sur, Chrome windows follow the user across desktops (Spaces) | Chrome Dock icon > Options > Assign to: None | Spaces confusion with Chrome | 2 replies, **52 "Me too"** | M |
| D52 | Microsoft Tech Community (Edge) | https://techcommunity.microsoft.com/t5/discussions/how-to-create-separate-shortcuts-for-different-profiles-on-mac/m-p/968168 | 2019-10-31 (replies to 2021+) | Wants a separate Edge Dock shortcut per profile on Mac | Windows-only answer; per search snippets, others used Automator plus `open -n` | "Can't get it working"; easy on Windows | 20 replies listed (3 visible) | H |
| D53 | Vivaldi forum | https://forum.vivaldi.net/topic/91488/profile-selection-directly-in-dock-icon-contextual-menu-mac-os | not visible | Wants profile choice in the Dock right-click menu, as Chrome and Brave have | Choosy | Choosy is "Not 100% the solution I want" | 988 views, 2 posts | M |
| D54 | V2EX | https://www.v2ex.com/t/895608 | 2022-11-16 | Switches between more than 4 Chrome profiles often; Cmd+Tab works but is slow; wants a hotkey per profile through Raycast or Alfred | Dock right-click menu; `open -n ... --profile-directory`; Raycast script; macOS App Shortcuts bound to the profile's menu item | Raycast only opens the Default profile; macOS aliases can't pass arguments | 11 replies, 4,214 views | H |
| D55 | Mac Power Users forum | https://talk.macpowerusers.com/t/which-browser-s-have-multiple-user-profiles/15595 | 2020-01-31 | Needs to stay logged in to personal and business accounts at the same time | Chrome profiles, Firefox containers, Ghost Browser | Doesn't want separate browsers | 10 replies | L |
| D56 | TidBITS Talk | https://talk.tidbits.com/t/google-chrome-profiles-gemini-helped-me-organize-things/32567 | 2025-12-25 | Split work, legacy G Suite and client Google Workspace accounts into Chrome profiles that feel "like its own app"; switches with Cmd+~ | Profiles plus color themes, Cmd+~ | Moving tabs between profiles took effort | 1 like | M |

By relevance: 29 High (including counter-signal D46; D47 is rated High), 24 Medium, 3 Low.

---

## 3. Recurring pain points (ranked by frequency, then intensity)

| Rank | Pain point | Evidence (IDs) | Count | Intensity notes |
|---|---|---|---|---|
| 1 | **Cmd-Tab treats every Chrome profile as one app.** Users are forced into Cmd-Tab then Cmd-`, or into the profile menu. | D02, D05, D07, D12, D13, D14, D18, D29, D54, D56 (and D10, D15, D16 built tools for this) | ~13 | High. People switch browsers (D18), write their own clone scripts (D15, D16), or call it "pretty bad compromise" (D07). Continuous evidence from 2011 to 2025. [Verified] |
| 2 | **No separate Dock icon per profile on Mac, while Windows has one per profile.** | D01, D03, D19, D20, D21, D44, D48, D49, D52 (Edge), D53 | ~10 | High on reach: D01 has 59,748 views and was still active in 2025. The comparison with Windows comes up again and again (D03, D19, D48, D52, D54). [Verified] |
| 3 | **DIY and third-party workarounds are fragile.** They break on Chrome updates, need re-codesigning, run under Rosetta, break 1Password or Touch ID, get abandoned, or have no undo. | D01, D16, D21, D34, D39, D40, D43 | 7 | Very high. People who did solve it describe it as a maintenance burden. "Get buggy and unwell after a couple years" (D34). This is a trust-and-durability opening. [Verified] |
| 4 | **Links and launchers open in the wrong profile.** Chrome opens whatever profile was used last. | D08, D09, D22, D23, D24, D32, D37, D42 | 8 | Medium to high. D08 has 442,683 views (largely Windows users). There is a crowded market of link-router Show HNs (D23, D37, plus LinkPrism and ChooseBrowser) with low engagement each. [Verified] [Inference: routing is an adjacent need, not Tabloom's core] |
| 5 | **Can't tell profile instances apart** (identical icons). | D10, D25, D44, D47 (custom icons), D15 (icon and color per instance) | 5 | Medium. Identical "Firefox" icons are worse than one icon (D25). Distinct per-profile icons are a must-have. [Verified] |
| 6 | **Can't quit or close one profile on its own.** | D17, D45, D47 (pro: per-profile quit) | 3 | Medium. [Verified] |
| 7 | **Profiles mixed up with Spaces and focus.** | D36, D49, D51 | 3 | D51 has 52 "Me too" votes, but it is about Chrome and Spaces generally, not profiles. Tabloom's Spaces behavior is NOT verified. [Verified pain] [Hypothesis that Tabloom helps] |
| 8 | **Too many Dock icons (counter-pain).** | D24, D41, D46, D47 | 4 | Real. Orion's request to hide extra profile icons has 83 votes. Some users will see "one icon per profile" as a downside. [Verified] |
| 9 | **Isolation and focus.** Wants separate cookies, extensions and blocklists per context. | D11, D15, D16, D35, D55 | 5 | Medium. Focus use: blocking social media in the work instance (D15, D16). [Verified] |
| 10 | **Password manager friction across profiles.** | D01 (1Password Touch ID), D33, D43 #7 | 3 | A risk for Tabloom: apps with separate user-data-dirs may hit the same 1Password and Touch ID problems. [Inference] [Hypothesis: needs testing] |

---

## 4. What people use today (these are also competitors)

| Workaround | Seen in | Weakness people report |
|---|---|---|
| Cmd+Tab then Cmd+` (built in) | D02, D07, D13, D18, D29, D56 | Awkward, no most-recent ordering, depends on keyboard layout (D13, D18) |
| Chrome profile menu, Ctrl/Cmd+Shift+M, Dock right-click profile list | D05, D06, D50, D54 | Several steps (D05, D06); the Dock shortcut broke for one user (D50) |
| Terminal `open -a/-n ... --profile-directory` / `--user-data-dir` | D03, D10, D31, D54 | Needs Terminal; aliases can't pass arguments (D54) |
| Automator or AppleScript wrapper apps | D49, D52, D10 | "Inconsistent" (D49); failed for an Edge user (D52) |
| Clone-Chrome scripts (chrome-schismator, D01 top answer, D16's own scripts) | D01, D16, D43 | Updates, codesigning, Rosetta, 1Password problems, no undo |
| Epichrome, WebCatalog, Coherence X, Unite (site-specific browsers) | D01, D34, D35 | Epichrome stopped development (HN 27065113, 2021-05-06); small one-person tools decay (D34) |
| Parall (paid, Mac App Store) | D21, D39–D42 | Can't reuse existing Chrome profiles without a manual data copy (D39); breaks on Chrome updates (D40); link handling (D42) |
| Separate browsers or channels per context (Chrome Beta, Vivaldi Snapshot, a second browser) | D01, D18, D24, D42 | Different browser, different UI and extensions |
| Orion (profiles as separate apps, per-profile icons) | D20, D47 | Dock clutter; not Chrome |
| Window switchers (AltTab, HyperSwitch, HopTab) | D13, D36 | Need an extra app and Accessibility permission [Inference] |
| Link routers (Choosy, Yojam, SwitchBoard, LinkPrism, ChooseBrowser, OpenIn) | D23, D37, D53, D52 | Fix links, not switching; a crowded niche |
| Raycast or Alfred scripts, macOS App Shortcuts bound to the profile menu item | D54 | Fiddly setup |
| Firefox scripts with `-P --no-remote` and custom icons | D28 | Manual |
| **Unbundle** | **Not found in any discussion** | Searches on HN and GitHub for "unbundle.app" found nothing. Unbundle appears to have no community visibility. [Verified absence in the sources searched; Reddit not covered] |

---

## 5. Segments with the strongest need

1. **Mac users who came from Windows.** [Verified, strong]
   - Evidence: D03, D19, D21, D48, D52, D54, plus D07 (a new Mac user).
   - They expect a taskbar icon per profile and say outright that Mac is worse. This is the most consistent framing in the sample.
2. **Developers and technical power users running 3–6+ profiles.** [Verified, strong]
   - Evidence: D13 (six profiles), D15, D16 (one per client or activity), D24 (six browsers), D54 (4+ profiles), D01, D10.
   - They already build their own tools, which shows high willingness to solve the problem. Their spending willingness is unknown.
3. **Consultants and freelancers with one Google Workspace per client.** [Verified, moderate]
   - Evidence: D15 ("each client/entity"), D35 (several G Suite accounts), D56 (work, legacy G Suite, client Workspace), D55.
4. **Focus-minded users** who keep a "work" app with distractions blocked apart from a "media" app. [Verified, small n]
   - Evidence: D15, D16.
5. **Edge, Firefox, Vivaldi and Waterfox users with the same problem.** [Verified]
   - Evidence: D25–D28, D44, D52, D53.
   - Shows demand beyond Chrome. Tabloom is currently Chrome-only. [Inference]

**Anti-segment:** users who want fewer Dock icons (D46, D47, D41). Marketing should present Tabloom as "you choose which profiles become apps", not as one icon for every profile. [Inference]

---

## 6. Customer language (for copy and SEO)

Short quotes, each under 15 words, attributed, at most one per source:
- "act exactly like two separate applications with two different icons" (HN D12)
- "separate dock icons for different Chrome Profiles" (D01 title)
- "pretty bad compromise for a pretty basic task" (D07)
- "I get caught up on this constantly" (HN D18)
- "get buggy and unwell after a couple years" (HN D34, about one-person tools)
- "Not 100% the solution I want" (Vivaldi D53, about Choosy)
- "This has been bugging me for a long time" (HN D22)
- "like its own app" (TidBITS D56)

Recurring phrases worth targeting (paraphrased, seen in the sources):
- "separate Dock icon for each Chrome profile" / "Dock shortcut per profile" (D01, D48, D52)
- "Cmd-Tab between Chrome profiles" / "switch Chrome profiles with keyboard shortcut" (D02, D05, D12)
- "run two Chrome profiles at the same time" / "multiple instances of Chrome on Mac" (D03, D10, D21)
- "work and personal Chrome profiles" / "Home and Work" (D05, D08, D48)
- "taskbar icon per profile like Windows" (D19, D48, D52)
- "open link in specific Chrome profile" (D09, D22): adjacent keyword
- "Epichrome alternative" (D01, D34, D35) [Inference: likely a search term from people orphaned by Epichrome]

---

## 7. Gaps and caveats

- **Reddit was not covered** (blocked; see Methodology). This is the biggest gap.
- **The Mozilla Connect idea** "macOS per-profile Dock icons that launch the correct profile" (idea 129080) returned 403. Its vote count is unknown.
- **The Mozilla support thread 1327165 did not load.** I did not use it.
- **Most HN comments show no vote counts** (Algolia does not expose them), so they are recorded as "not visible".
- **No discussion of Unbundle was found** in the sources searched.
- **Unverified cause in D49.** The claim that "macOS changes removed per-profile launchers" is one user's opinion and has not been confirmed.
- **No payment-intent evidence.** Willingness to pay was not seen directly. The only signal is that some users bought Parall (D39 says "recently purchased").
- **[Hypothesis] needing a spike test:** Tabloom needs fresh profiles (sign in again). D39 shows users expect their **existing** profiles to carry over. This matches Tabloom's main unsolved limitation and is likely to be the first objection.
- **[Hypothesis] needing a spike test:** 1Password and Touch ID problems in copied or isolated Chrome instances (D01, D43) may also hit Tabloom.
