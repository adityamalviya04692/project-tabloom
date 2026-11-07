# Tabloom: Marketing Research & Go-to-Market Plan

Research date: **2026-11-05**. Working name "Tabloom" (a rename is recommended, see below).
Labels used throughout: **[Verified]** seen at a source · **[Inference]** analytical reasoning · **[Hypothesis]** untested.

## Executive summary

1. **The pain is real, old and recurring. Demand for the exact phrase is low.** 56 real discussions from 2011–2025 (Ask Different, Super User, HN, GitHub, Apple Community, MacRumors) describe all Chrome profiles collapsing into one ⌘-Tab/Dock icon. One Ask Different question has ~60k views. **[Verified]** Search autocomplete shows people type *Dock-icon* and *shortcut* phrasing, not "command tab" or "separate apps". **[Verified]**
2. **The positioning gap is open.** No competitor found offers **native ⌘-Tab entries without Accessibility permission**. Superdock and Okie Dockie use Accessibility and their own switchers. Unbundle copies all of Chrome (~500 MB per profile, ad-hoc signed, anonymous developer, no search visibility). **[Verified from vendor pages]**
3. **Tabloom's biggest weakness is existing profiles.** Tabloom apps start with fresh profiles today. Unbundle claims to use existing profile folders. Superdock and Okie Dockie keep logins. Users ask for this first. **[Verified]** Solve it or be upfront about it.
4. **The economics make a side income, not a living, at $4.99.** Net is ~$3.99 per sale after merchant-of-record fees and refunds. 1,000 customers ≈ $3.9k net in total, one-time. **[Inference]** Sustainability depends on a higher price once import ships, more browsers, and cheap SEO acquisition. **[Hypothesis]**
5. **Distribution is gated by trust.** r/macapps (260k) is the best-fit channel, but its main feed needs a notarized app, a privacy policy, account karma and age. Until then only the monthly App Pile thread is open. r/mac and r/productivity ban promotion. **[Verified]**
6. **Rename.** "Tabloom" collides with two live Chrome tab-manager extensions, and the internal codename "ProfileDock" collides with several products. Finalists: **Alterdock, Splitdock, Personabar** (trademark search pending). **[Verified collisions]**

## Files

| Area | File |
|---|---|
| Competitors | [competitor-analysis.md](competitor-analysis.md) |
| Customer problems (56 discussions) | [customer-research.md](customer-research.md) |
| SEO | [seo-keywords.csv](seo-keywords.csv) · [seo-strategy.md](seo-strategy.md) · [content-clusters.md](content-clusters.md) |
| Content | [content-ideas.csv](content-ideas.csv) (33 ideas) · [short-form-scripts.md](short-form-scripts.md) · [long-form-video-ideas.md](long-form-video-ideas.md) · [technical-blog-ideas.md](technical-blog-ideas.md) (incl. full flagship article draft) |
| Channels | [distribution-channels.md](distribution-channels.md) |
| Creators | [creator-database.csv](creator-database.csv) (26) · [creator-outreach.md](creator-outreach.md) |
| Pricing | [pricing-strategy.md](pricing-strategy.md) · [pricing-research-raw.md](pricing-research-raw.md) |
| Landing page | [landing-page-copy.md](landing-page-copy.md) · [landing-page-spec.md](landing-page-spec.md) (includes the **claim gate**) · [faq.md](faq.md) |
| Measurement | [growth-experiments.md](growth-experiments.md) |
| Brand | [brand-research.md](brand-research.md) |
| Plan | [launch-calendar.md](launch-calendar.md) · [priority-backlog.md](priority-backlog.md) |
| Sources | [research-sources.md](research-sources.md) |

---

## Final report

### 1. Top five competitor weaknesses
1. **Unbundle:** ~500 MB full Chrome copy per profile, ad-hoc signed, anonymous (Gmail contact), no refund/licence terms, no search or social presence. A commenter says re-signing stops Chrome updating. **[Verified claims; update effect = user report]**
2. **Superdock / Okie Dockie** need Accessibility permission and use custom switchers, not native ⌘-Tab. Superdock replaces the whole Dock. **[Verified]**
3. **Okie Dockie** costs $19 for 3 Macs and comes bundled with unrelated features. **[Verified]**
4. **ProfileDock (OSS)** says on its own site that it doesn't give profiles separate ⌘-Tab entries. It's an unsigned beta, and shortcuts break on Chrome restart. **[Verified]**
5. **Parall / Parallel Spaces** are general multi-instance tools, not built around Chrome profiles. Users report bugs (Teams sessions; Chrome-copy fixes). Parall users also ask how to bring existing profiles over (issue #13). **[Verified]**

### 2. Top five customer pain points
1. ⌘-Tab treats all Chrome profiles as one app, forcing ⌘-\` cycling (~13 discussions).
2. No per-profile Dock icon on Mac, while Windows gives each profile a taskbar icon (~10; the top question has ~60k views).
3. Workarounds break after Chrome updates, re-signing, Rosetta, or with 1Password/Touch ID; tools like Epichrome get abandoned (7).
4. Links and launchers open in the wrong profile (8, an adjacent need).
5. Can't tell instances apart when icons are identical (5), so distinct icons are a must-have.
Counter-signal: some users don't want *more* Dock icons, so let them pick which profiles become apps. **[All Verified counts from customer-research.md; no Reddit coverage]**

### 3. Top ten SEO opportunities (qualitative score /12; no volume data exists)
1. multiple chrome profiles in mac dock (12)
2. separate dock icons for different chrome profiles (12)
3. separate chrome profiles dock mac (12)
4. chrome profiles command tab mac / cmd tab chrome profiles (12, low demand)
5. chrome profiles separate apps / make chrome profiles separate mac apps (12, low demand) → home page
6. chrome profile shortcut mac + variants (10; results are full of Windows guides)
7. how to open multiple chrome profiles on mac (10)
8. unbundle alternative (11, low demand, high buying intent)
9. switch between chrome profiles mac / profile switch shortcut (9–10)
10. run multiple instances of chrome mac (9)
Plus the customer phrase "Epichrome alternative" (content idea C16). See seo-strategy.md for the scoring.

### 4. Top ten content opportunities
1. C01 "4 profiles, ⌘-Tab shows ONE" before/after short (after G1)
2. C12 flagship engineering article "Why macOS shows one Chrome in ⌘-Tab" (draft written)
3. C13 SEO guide: separate Dock icon per Chrome profile (free method + app)
4. C02 "Windows has per-profile taskbar icons, Mac doesn't" (Windows-switcher segment)
5. C24 free answers on high-view Ask Different / Super User threads
6. C04 "Why does every profile hide behind one icon?" explainer short
7. C15 Mac-specific Chrome profile shortcut guide (results are weak)
8. C17 dated, honest Unbundle / Parall comparison page
9. C07–C09 build-in-public trio (failed approaches, GPU sandbox bug, APFS clones)
10. C18 "Managing 10 client Google accounts on one Mac" long-form comparison

### 5. Top five distribution channels
1. **r/macapps:** App Pile megathread now; main feed once notarized + privacy policy + 300 karma / 60-day account. **[Verified rules]**
2. **TidBITS:** published pitch guidelines (2026-07-23), public pitch address. **[Verified]**
3. **MacStories "App Debuts"** (no public pitch email found). **[Verified]**
4. **Show HN:** needs a no-signup trial. Similar tools got 1–4 points, so treat it as a bonus. **[Verified]**
5. **AlternativeTo:** Parall is listed, Unbundle isn't, and developers may self-submit. **[Verified]**
Organic search and Q&A answers are the durable long-term channel. **[Inference]**

### 6. Recommended pricing experiment
Launch at **$4.99 one-time with a 7-day trial**. Run **E3 first (free 1-app tier vs 7-day trial)** by download cohort. Once existing-profile import ships, run a **sequential $4.99 → $6.99 test** on net revenue per visitor. That beats testing $3.99: $3.99 needs ~29% more buyers to match $4.99, while $6.99 can lose ~31% and still win. **[Inference from verified fees]**

### 7. Recommended brand shortlist
1. **Alterdock:** no .com/.app record, no GitHub/product collision found; possible Docker association.
2. **Splitdock:** the most descriptive; .app free, .com parked.
3. **Personabar:** best fit for "profiles"; DNN "Persona Bar" overlap.
Drop "Tabloom" and "ProfileDock". No trademark clearance has been done; none of this is legal advice.

### 8. First 14 days
| Day | Task |
|---|---|
| 1 | Decide the existing-profile strategy (fresh-only vs migration) |
| 2 | Manual ⌘-Tab visual check; record the before/after clip; shortlist names |
| 3 | Pick the name, run a trademark knockout search, buy the domain |
| 4 | Pre-launch landing page + beta form + cookieless analytics + UTMs |
| 5 | Privacy policy + limitations page; answer 3–5 old Q&A threads with the free method |
| 6 | Beta call on X/LinkedIn + r/macapps App Pile entry |
| 7 | Build-in-public short S6; start the metrics sheet |
| 8 | Publish engineering article T1 (+ dev.to canonical) |
| 9 | Submit T1 to HN (regular submission, not Show HN) |
| 10 | Shorts S3 + S7 |
| 11 | SEO guide: separate Dock icon per Chrome profile |
| 12 | Start the Chrome-update repair flow; X progress post |
| 13 | Developer ID + notarization; short S8 |
| 14 | Weekly review; go/no-go for beta recruitment (target ≥ 25 signups) |

### 9. Research gaps requiring manual validation
- **Reddit:** blocked for automated customer research. Search r/macapps, r/chrome, r/MacOS and r/browsers by hand.
- **No search volumes:** use Google Search Console data after launch, or a paid tool, if you want numbers.
- **Unbundle:** whether its copies run as separate ⌘-Tab processes at the same time, plus notarization status and developer identity. Buy it and test.
- **Okie Dockie:** whether its launchers appear in ⌘-Tab.
- **Parall price:** $10.99 vs $9.99 seen in different sources/storefronts. Recheck.
- **Other new competitors** (ProfileLauncher / loshadki.app, DockSpark) are only lightly covered.
- **Unverified prices:** Rectangle Pro, Bartender, FastSpring rates, Stripe US page.
- **Willingness to pay:** no direct evidence beyond people buying Parall/Unbundle. Ask in beta calls.
- **Trademark clearance** (USPTO/EUIPO/WIPO, classes 9/42) and actual domain purchasability.
- **Product claims** still to verify before marketing them: the visual ⌘-Tab check, Chrome-update repair, Keychain/1Password, Intel, older macOS, and whether Mac App Store sandboxing allows the core feature.
- **Conflicting third-party claims:** that Chromium 140+ / macOS 26 broke per-profile launchers, and a SupaSidebar post saying each profile already gets its own ⌘-Tab entry. Test both before referring to them.
