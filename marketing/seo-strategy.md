# Tabloom SEO strategy (research date 2026-11-05)

Companion files: `seo-keywords.csv` (33 keywords, scored), `content-clusters.md` (page map and internal links).

## 1. How the research was done (and its limits)

- **Keyword discovery:** Google Autocomplete (`suggestqueries.google.com/complete/search?client=firefox`) for the 10 seeds plus about 30 probe prefixes, accessed 2026-11-05. [Verified] An Autocomplete suggestion only shows that people type a query. It is **not** a volume figure.
- **SERP checks:** These used the agent's WebSearch tool (US results), not a logged-in Google SERP. Order and coverage will differ from google.com, so `top_ranking_urls` lists **results seen**, not positions. [Verified that they were returned; ranking order relative to Google is unknown.]
- **Reddit:** reddit.com blocked both WebSearch and the JSON API. The only Reddit threads seen came through mirror sites (r/browsers and r/MacOSApps, May 2025, "looking for a Mac browser to streamline my..."). **Gap:** Reddit-thread-title mining is still undone and should be checked by hand.
- **People-also-ask and related searches:** These cannot be collected without a real Google SERP. **Gap.**
- **Volume and KD:** None available. Every row says `not available`. No number in these files is a search volume. Before investing heavily, check the P1 terms in Google Search Console (after launch), Google Keyword Planner (free with an Ads account) or Ahrefs/Semrush.

## 2. Scoring method (transparent, qualitative)

Each keyword gets four sub-scores from 1 to 3. **Total = sum (4-12).**

| Dimension | 3 | 2 | 1 |
|---|---|---|---|
| **Relevance**: does Tabloom solve exactly this query? | Query names the exact outcome (own Dock icon, own Cmd-Tab entry, profile as separate app) | Adjacent (switching profiles, shortcuts, work/personal split) | Tangential (file locations, window tiling, Windows-centric) |
| **Buy intent**: how close is the searcher to installing a tool? | Looking for a tool or alternative, or has already hit the limitation | Wants a how-to; a tool is an acceptable answer | Wants a one-line fact |
| **SERP weakness**: how beatable are the results seen? | Old (2018-2021) posts, forum threads, gists, AI-filler pages, wrong-platform (Windows) answers, or contradictory claims | Some decent how-tos, but none are Mac-specific or current | Google Help, strong publishers (HowToGeek), or a competitor's brand query |
| **Effort-inverse**: how cheap is it to make the most useful result? | One honest page we can write from the verified spike plus standard Chrome behaviour | Needs testing of DIY methods, screenshots, or careful competitor claims | Needs a large guide or authority we do not have |

**Labels (rule-based, applied in the CSV):**
- **P1:** total ≥10, relevance = 3, and either Autocomplete-confirmed or a perfect 12.
- **P2:** total ≥9.
- **P3:** total 7-8.
- **Skip:** total ≤6.

**Caveat [Inference]:** the highest-fit seeds ("chrome profiles command tab mac", "chrome profiles separate apps", "unbundle alternative") did **not** show up in Autocomplete, so demand is probably very small. They are still P1 or P2 because a single page can rank for them cheaply and convert well. The Autocomplete-confirmed Dock and shortcut terms are the likely traffic carriers.

## 3. Prioritized list

| # | Keyword | Score | Label | Target page |
|---|---|---|---|---|
| 1 | multiple chrome profiles in mac dock | 12 | P1 | /chrome-profiles-dock-icons |
| 2 | separate dock icons for different chrome profiles | 12 | P1 | /chrome-profiles-dock-icons |
| 3 | separate chrome profiles dock mac | 12 | P1 | /chrome-profiles-dock-icons |
| 4 | chrome profiles command tab mac / cmd tab chrome profiles | 12 | P1 | /chrome-profiles-command-tab |
| 5 | chrome profiles separate apps / make chrome profiles separate mac apps | 12 | P1 | / (home) |
| 6 | chrome profile shortcut mac (plus create / desktop variants) | 10 | P1 | /guides/chrome-profile-shortcut-mac |
| 7 | how to open multiple chrome profiles on mac | 10 | P1 | /guides/multiple-chrome-profiles-mac |
| 8 | unbundle alternative | 11 | P2 | /compare/unbundle |
| 9 | chrome profile switch shortcut mac / switch between chrome profiles mac | 10 / 9 | P2 | /guides/switch-chrome-profiles-mac |
| 10 | run multiple instances of chrome mac | 9 | P2 | /guides/run-multiple-chrome-instances-mac |
| 11 | chrome work personal profiles mac | 9 | P2 | /guides/work-personal-chrome-profiles-mac |
| 12 | multiple chrome profiles mac (pillar head term) | 9 | P2 | /guides/multiple-chrome-profiles-mac |
| 13 | epichrome alternative | 9 | P2 | /compare/epichrome-alternatives + AlternativeTo listing |
| 14 | separate chrome windows command tab | 9 | P2 | /guides/cmd-tab-chrome-windows |

The full list is in the CSV.

**Build order:**
1. Home.
2. Dock landing.
3. Cmd-Tab landing.
4. Shortcut guide.
5. Multiple-profiles pillar.
6. Unbundle comparison.
7. Everything else.

## 4. What the SERPs look like (evidence for "SERP weakness")

- **AI-filler or scraped pages rank for the Dock cluster.** Examples are `jobs.doral.edu/mac-dock-icons-multiple-chrome-profiles-made-easy` and `support.worldcoffeeresearch.org/...how-to-have-different-user-chrome-icons-in-mac-dock` (both seen 2026-11-05). [Verified that they appeared; quality judgement is Inference.]
- **The useful answers are old or technical:**
  - a 2020 Medium post on separate user-data-dirs (`medium.com/expected-behavior/...`)
  - gists
  - `github.com/djbclark/chrome-schismator` (49 stars, seen 2026-11-05)
  - a MacRumors thread
- **There is fresh, unmet demand.** An Apple Community thread from 2025-12-03 on macOS 26.1 complains that per-profile Dock launchers no longer work (`discussions.apple.com/thread/256202449`). The poster's claim that Chromium removed native per-profile Dock icons was not confirmed by anyone in the thread. [Verified as the poster's claim only.]
- **Contradictory information.** The SupaSidebar blog (`supasidebar.com/blog/browser-profiles-mac-2026`, updated 2026-07-21, written by SupaSidebar's founder) says each Chrome profile gets its own Dock icon and Cmd-Tab entry. That conflicts with the Medium post, a V2EX thread and the Apple thread. [Inference: the SupaSidebar claim is probably wrong for stock Chrome. Our spike verifies only our own app shims, so test stock Chrome on macOS 26 and show screenshots before stating it on our site.]
- **Mac "profile shortcut" queries return Windows guides** (windowsloop, thewindowsclub, howtogeek). That is an intent mismatch we can fill.
- **Competitors in the SERP:**
  - **Parall** (Mac App Store, `apps.apple.com/app/parall/id6754065114`): a generic parallel-app launcher with per-profile Dock icons.
  - **Unbundle** (`unbundle.app`, $6.99): did not surface in WebSearch at all.
  - **Profile Switcher, Switchbar, Profilissimo:** switchers, link routers and extensions.
  - **Epichrome:** discontinued; its README says 2.4.27 was the final version.

## 5. Technical SEO basics for a small product site

- **One URL per intent**, with a short, descriptive slug (the slugs in section 3). Do not create separate pages for near-duplicate variants; cover them with H2s and FAQ entries.
- **Titles and H1s should name the outcome, not the brand.** For example: "Give each Chrome profile its own Dock icon and Cmd-Tab entry on Mac". Put "Mac" or "macOS" in the title, because the SERP is polluted with Windows answers.
- **Static HTML, fast, no JavaScript-gated content.** Use a static site (Astro, Eleventy or plain HTML on Cloudflare Pages). Target LCP under 2.5 s and keep pages small, with compressed WebP/AVIF screenshots and explicit width/height to avoid CLS.
- **Structured data:**
  - `SoftwareApplication` on the home page (`operatingSystem: macOS`, `applicationCategory: UtilitiesApplication`, `offers.price` "4.99", `priceCurrency` USD). Add `aggregateRating` **only** once real reviews exist; never fake them.
  - `FAQPage` on landing pages (rich results are limited now, but it helps structure).
  - `HowTo`-style headings on guides.
  - `BreadcrumbList`.
- **Housekeeping:**
  - `sitemap.xml`, `robots.txt` and canonical tags. Pick one host (apex or www) and 301 the other.
  - Submit to Google Search Console and Bing Webmaster Tools on day one, and use GSC queries as the real volume source.
  - Open Graph and Twitter cards with a clear screenshot of the Dock and Cmd-Tab (only after it has been eyeballed; see section 7).
  - Add a `/changelog` and keep "last tested on macOS X / Chrome Y" dates on every guide. Freshness is the main advantage over the 2020-era incumbents.
- **Downloads:** put the DMG behind a stable URL (e.g. `/download`) and describe it in text, not just a button image.
- **Off-page:**
  - Listings on AlternativeTo (as an alternative to Unbundle, Epichrome and Parall), MacUpdate and Product Hunt.
  - A Show HN post.
  - Honest answers in existing threads (MacRumors, Apple Community, MPU Talk, Orion feedback thread 3389), with disclosure.

## 6. How to compete with forum threads

Forum threads rank because they hold the exact phrasing of the problem and real people confirming it. To beat or join them:

1. **Mirror the problem phrasing.** Use the user's words as H2s: "Why does Cmd-Tab show only one Chrome?" and "Can each Chrome profile have its own Dock icon?"
2. **Answer first, then sell.** Open with a two-sentence direct answer: stock Chrome profiles share one app, so they share one Dock icon and one Cmd-Tab entry. [Inference, consistent with the Medium, V2EX and Apple sources; verify on stock Chrome before publishing.] Then show the free DIY route, then the app.
3. **Include the free DIY method on our own page.** That means the `open -na "Google Chrome" --args --user-data-dir=...` approach and its trade-offs. Forum readers distrust pages that hide the free option. Unbundle does this too (`/blog/how-it-works` "Free scripts & DIY guide").
4. **Be the freshest tested answer.** Print the tested macOS and Chrome versions and the date. Update when Chrome updates break things.
5. **Participate, don't spam.** Reply once in relevant live threads, disclose that you are the developer, and link to the guide (not the buy page).
6. **Video:** no video results showed up in the checks. A 30-60 s screen recording (YouTube, embedded on the landing page) of Cmd-Tab with separate profile icons is a cheap differentiator. [Hypothesis]

## 7. Honesty constraints (must hold on every page)

- **Do NOT claim Tabloom uses your existing Chrome profiles** or keeps existing logins and cookies. It currently creates **fresh** profiles. Users sign in again, and Chrome Sync can restore bookmarks and extensions. Say this plainly on the home page, the FAQ and every comparison page.
- **Unbundle comparison:**
  - Unbundle's site (accessed 2026-11-05) states that it points to your existing profile folder, rebuilds apps after Chrome updates, and costs $6.99 one-time.
  - State this fairly, and acknowledge that Unbundle supports existing profiles while Tabloom does not (yet).
  - Compete on price ($4.99 vs $6.99) and on verified facts only.
  - Do not claim a smaller disk footprint unless measured. Unbundle says about 500 MB per profile; our footprint is unmeasured.
- **Do not show a Cmd-Tab screenshot or video until the visual overlay has been eyeballed.** Activation policy is verified programmatically, but the overlay itself has not been seen.
- **Do not claim:**
  - surviving Chrome updates, reboots, Intel Mac support, or Spaces, fullscreen and multi-monitor behaviour
  - Keychain or password behaviour
  
  All of these are unverified.
- **Trademark:** legal review is not done. Avoid "Chrome" in the product name, domain and logo, and do not use the Chrome logo. Use descriptive phrasing ("for Google Chrome") and a footer disclaimer ("Google Chrome is a trademark of Google LLC; Tabloom is not affiliated with Google"). Keyword-bearing URLs like `/chrome-profiles-dock-icons` are descriptive use, but get legal advice before launch.
- **Code signing:** the apps are ad-hoc signed. Don't imply notarization or Mac App Store review. Document the Gatekeeper first-launch step honestly.
- **No invented numbers:** no fake ratings, download counts or testimonials, and no invented volumes in any public material.

## 8. Measurement

- **Weeks 1-8:** track GSC impressions and queries per page. This is the first real volume data; replace "not available" in the CSV with GSC impressions, citing the source.
- **Success signal:** P1 pages getting impressions for the Dock and shortcut terms within about 8 weeks. [Hypothesis; new domains vary widely.] Conversion is measured as download clicks per landing page.
