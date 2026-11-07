# Four-Week Launch Calendar

Created 2026-11-05. **Weeks are phases, not dates.** A phase starts only when the gate before it passes. Launch depends on readiness, not on a deadline.
Labels: **[Verified]** source in distribution-channels.md / customer-research.md · **[Inference]** · **[Hypothesis]**.

## Readiness gates

| Gate | Needed before | Owner | Evidence of pass |
|---|---|---|---|
| G0 Name chosen (not "Tabloom": collides with two Chrome extensions, see brand-research.md) | Week 1 Day 3 (domain + page) | You | Domain bought; quick trademark knockout search done |
| G1 Manual ⌘-Tab visual check passes + real recording | Any after-state demo | You | Screen recording saved in `marketing/assets/` |
| G2 Developer ID signing + notarization of Tabloom **and** of the generated apps (or a documented, tested Gatekeeper story) | Beta (Week 3) | You | `spctl -a -vv` passes; clean-machine install test |
| G3 Privacy policy + refund policy + honest "limitations" page live | Any Reddit / HN / directory post **[Verified: r/macapps trust path]** | You | URLs live |
| G4 Chrome-update repair flow works (update Chrome → apps rebuilt, data kept) | Public launch | You | Tested across one real Chrome update |
| G5 Keychain behaviour with real sign-in known (prompts? 1Password/Touch ID?) **[customer-research.md flags 1Password/Touch ID breakage in copied Chromes]** | Public launch | You | Test notes in docs/ |
| G6 Trial/licensing + MoR checkout working end to end, no sign-up to try | Public launch **[Verified: Show HN rule]** | You | Test purchase + refund in MoR test mode |
| G7 Reddit account eligibility for the r/macapps main feed (300+ karma, 60+ day account) | Main-feed post only | You | Check your account; otherwise use the App Pile megathread |

If G4 or G5 fail, **stay in beta**. Shipping a paid app that leaves users on an unpatched Chrome engine is a reputation and security risk. **[Inference]**

---

## Week 1: Market validation

| Day | Tasks | Depends on | Output | Success criteria |
|---|---|---|---|---|
| 1 | Read competitor-analysis.md and customer-research.md; decide the existing-profile strategy (fresh-only vs migrate) since it drives every claim | — | Decision note in docs/ | Decision written down |
| 2 | Manual ⌘-Tab check (G1) and record a 10 s before/after clip. Pick a name from the 3 finalists | spike build | Clip; name shortlist | G1 passes or bug filed |
| 3 | Buy domain; run a quick USPTO/EUIPO search on the name (formal clearance later) | G0 | Domain | Domain owned |
| 4 | Build the pre-launch landing page (landing-page-spec.md, pre-launch variant) with a beta signup form + cookieless analytics + UTMs | G0 | Live page | Page < 1 s load; events firing |
| 5 | Publish the privacy policy and limitations page (G3). Answer 3–5 old Ask Different / Super User threads with a complete **free** method (disclose affiliation if you mention your app; follow SE rules) | G3 | Answers posted | Answers accepted or upvoted (no target; just track) |
| 6 | Post the beta call on X/LinkedIn (content-ideas C32) and in the r/macapps **App Pile** megathread (posted on the 1st of each month; once per 30 days) **[Verified]** | G3, G1 | Posts | ≥ 25 beta signups by end of week 2 **[target, not benchmark]** |
| 7 | Record build-in-public short S6; write the weekly metrics row | — | 1 short | Metrics sheet started |

**Week 1 exit:** name + domain + live page + ≥ 10 beta signups. If < 10 after Week 2 with posts on 3+ channels, revisit the problem framing before building more. **[Inference]**

## Week 2: Build in public

| Day | Tasks | Depends on | Output | Success criteria |
|---|---|---|---|---|
| 8 | Publish engineering article T1 (technical-blog-ideas.md) on your blog; canonical cross-post to dev.to | G1 for screenshot | Article | Indexed in Google Search Console within 7 days |
| 9 | Submit the article to HN as a normal submission (not Show HN, since nothing is downloadable yet) | Day 8 | HN post | Whatever happens, reply to every comment within 2 h |
| 10 | Short S3 ("why one icon") + S7 (GPU sandbox bug) on Shorts/X/Reels | — | 2 shorts | Track views → page visits by UTM |
| 11 | Write SEO guide #1: "Separate Dock icon for each Chrome profile on Mac" (top keyword cluster, seo-strategy.md) | page live | Guide | Published, internally linked |
| 12 | Start building the Chrome-update repair flow (G4); post an X progress update | — | Progress | — |
| 13 | Notarization work (G2); short S8 (APFS clone) | Apple Developer account | Notarized build | `spctl` passes |
| 14 | Weekly review: signups by source, which post drove them | metrics | Notes | ≥ 25 total beta signups |

## Week 3: Beta validation (~20 testers)

| Day | Tasks | Depends on | Output | Success criteria |
|---|---|---|---|---|
| 15 | Pick ~20 testers for variety: Intel vs Apple Silicon, macOS versions, 1Password users, 3+ profile users, Windows switchers | ≥ 25 signups, G2 | Tester list | ≥ 15 confirmed |
| 16 | Ship beta build + a 5-question onboarding survey (did it appear in ⌘-Tab? any Keychain prompt? which macOS/chip/Chrome?) | G2 | Beta live | ≥ 10 installs |
| 17 | Triage issues; build the compatibility matrix from real reports | Day 16 | `compat` table | All crashes reproduced or explained |
| 18 | Run a Chrome update on a test machine; verify repair (G4). Test Keychain/1Password (G5) | — | Test notes | G4/G5 pass or a launch blocker is logged |
| 19 | 3–5 short user calls: willingness to pay, price reaction, which claims they'd believe | testers | Notes | Quotes only with written permission |
| 20 | Ask for testimonials by **permission only** (exact wording + name/handle as they approve) | Day 19 | 3+ approved quotes | ≥ 3 |
| 21 | Final demo recordings (S1, L1 walkthrough) on the release build; update landing copy ⚠️ items | G1, G4 | Final demo assets | Every claim on the page passes the claim gate |

**Week 3 exit (launch go/no-go):** G1–G6 pass; ≥ 70% of testers saw separate ⌘-Tab entries; no data-loss reports; support questions understood. **[Inference thresholds]**

## Week 4: Public launch

| Day | Tasks | Depends on | Output | Success criteria |
|---|---|---|---|---|
| 22 | Switch the page to checkout; test purchase + refund in MoR live with your own card; publish compatibility table | G6 | Live store | Purchase → licence → activation works |
| 23 | **Show HN** with a no-signup trial, limitations in the first comment **[Verified rule]**; reply all day | Day 22 | HN post | Track visits/trials by UTM (no points target) |
| 24 | Submit to AlternativeTo (as alternative to Unbundle/Parall), MacUpdate; open a PR on jaywcjlove/awesome-mac following its contributing rules | Day 22 | Listings | Submitted |
| 25 | Pitch TidBITS (ace@tidbits.com, per their published pitch guidelines) and MacStories; send creator outreach to 10 Priority-A/B creators (creator-outreach.md template 1) | Day 22 | 12 emails | ≥ 2 replies within 10 days **[target]** |
| 26 | Publish SEO guides #2–#3 (Command-Tab guide, profile shortcut guide) + the dated, factual `/compare/unbundle` page | — | 3 pages | Indexed |
| 27 | r/macapps: App Pile entry if the 30-day clock allows; a main-feed post only if G7 passes and 30 days have passed since your last post **[Verified rules]** | G7 | Post | — |
| 28 | Launch review: funnel per channel, refunds, support tickets by category; write the T11 honest post-mortem draft | metrics | Review doc | Decide next 30 days by net revenue per hour of effort per channel |

### Launch-week KPIs to record (no targets invented; set baselines)
Visits by source · download clicks · trials · purchases · refunds (+ reasons) · support tickets per 100 customers · net revenue · "how did you hear" answers.

## After launch (days 29–60)
- Product Hunt only once you have real users and permissioned testimonials **[Verified sequencing advice, distribution-channels.md]**.
- One SEO guide per week from content-clusters.md.
- Creator follow-ups (one follow-up after 7 days, then stop).
- Day 60 decision: continue / pivot pricing / pause, per the kill-continue signal in pricing-strategy.md §5.
