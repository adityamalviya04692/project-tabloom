# Tabloom: distribution channels

Research date: 2026-11-05. Every fact below was accessed on 2026-11-05 unless a date says otherwise.
Labels: **[Verified]** = seen at the source. **[Inference]** = my reasoning from verified facts. **[Hypothesis]** = untested.

How rules were read: subreddit rules came from each subreddit's own `about/rules.json` and `about.json`, opened in a logged-in browser on 2026-11-05. WebFetch and curl are blocked by Reddit. Subscriber counts are Reddit's own `subscribers` field from that day.

---

## 0. Before posting anywhere (blockers that decide which channels are open)

| Gate | Why it matters | Status |
|---|---|---|
| Apple notarization (Developer ID) | r/macapps' "Website" trust path requires signed and notarized apps. r/MacOSApps requires you to state notarization status. Reviewers (TidBITS) will test it. | Not done; apps are ad-hoc signed (brief) |
| Privacy policy on your own site | Required for the r/macapps Website trust path. Strongly encouraged by r/MacOSApps. | Unknown |
| Free trial or download with no sign-up | Show HN asks that people can try it without sign-ups. | Unknown |
| Honest scope statement | Each profile app currently starts with a **fresh** profile (sign in again; Chrome Sync restores bookmarks and extensions). Importing existing profiles is NOT validated. The Cmd-Tab overlay has not been eyeballed. | Must appear in every post |
| Trademark review ("Chrome" in name, icons) | r/MacOSApps rule bans IP infringement. Google trademark review not done (brief). | Not done |
| Reddit account age and karma | r/macapps main feed needs 300+ karma and a 60+ day old account. Comments in request threads need the same. | Unknown (user's account) |

[Inference] Until notarization and a privacy policy exist, the realistic Reddit route is the r/macapps **App Pile** megathread, not the main feed.

### What the audience already says about this category (useful for positioning)
- [Verified] r/macapps thread "Different browser profiles as different apps in dock??" (2025-01-24, 5 points, 25 comments) asks for exactly this: https://www.reddit.com/r/macapps/comments/1i8ybqm/. Replies suggest Automator or Firefox flags. A developer (ProfileLauncher, loshadki.app) replied with a disclosed link to his own app.
- [Verified] r/MacOS "Tip: Use multiple Chrome profiles without them grouping together in the dock" (2026-01-31, 7 points, 15 comments): https://www.reddit.com/r/MacOS/comments/1qs10jz/. In the comments, the Parall developer pitches Parall. Another commenter names Unbundle and "Okie Dokie". One commenter objects that Unbundle copies and re-signs Chrome, which they say stops Chrome from updating.
- [Verified] Unbundle's own FAQ says each profile app is about 500 MB because it is a copy of Chrome.app. Price is $6.99 one-time, macOS 13+. https://www.unbundle.app/
- [Verified] Parall costs $9.99 on the Mac App Store. Its approach is lightweight shortcut bundles that launch the original app. https://apps.apple.com/app/parall/id6754065114
- [Inference] The comparison readers will ask for first: disk use per profile, whether Chrome still auto-updates, and whether existing profiles and logins carry over. Tabloom has to answer the third honestly (not yet).

---

## 1. Ranked summary

Score: Relevance (fit of audience) / Effort / Likelihood of *qualified* traffic. H = high, M = medium, L = low.

| Rank | Channel | Direct promo allowed? | Relevance | Effort | Qualified traffic | Notes |
|---|---|---|---|---|---|---|
| 1 | r/macapps (App Pile now; main feed later) | Yes, under strict rules | H | M | H | Best audience fit. Demand threads exist. |
| 2 | TidBITS (pitch to Adam Engst) | Editorial pitch only | H | L | M | Published pitch rules (July 2026). |
| 3 | MacStories (App Debuts / pitch) | Editorial pitch only | H | L | M (if covered) | Coverage unlikely without novelty. |
| 4 | Show HN | Yes (Show HN post) | M | M | M, high variance | Similar tools got 1 to 4 points. |
| 5 | AlternativeTo | Yes (submit own app) | H (search intent) | L | M, long tail | Users find alternatives to Unbundle and Parall here. |
| 6 | Product Hunt | Yes (maker launch) | M | M to H | L to M | Parall's two launches drew modest numbers. |
| 7 | Mac Power Users forum | Implicit; risky | H | L | L to M | Parall's post was flagged, then restored. |
| 8 | r/apple (Sunday dev self-posts) | Yes, Sundays only | M | M | M | Activity requirements apply. |
| 9 | r/MacOSApps | Yes, with disclosures | M | L | L | 28.5K subscribers. |
| 10 | MacUpdate listing | Yes (listing) | M | L | L | Download-site long tail. |
| 11 | jaywcjlove/awesome-mac | PR | M | L | L | Backlink and discovery. |
| 12 | r/indiehackers, Indie Hackers site, r/SideProject | Limited | L (makers, not users) | L | L | Feedback, not customers. |
| 13 | 9to5Mac tip form | Tip only | M | L | L | No pitch guidance published. |
| — | r/MacOS | Saturdays only, **MAS or established GitHub only** | H | — | — | Not eligible as a direct-download app. |
| — | r/mac, r/productivity | **No** | — | — | — | Promotion banned. |
| — | r/chrome | Only with mod approval via modmail | M | — | — | Ask first. Expect "no". |
| — | r/browsers | Not banned outright; no how-to posts, no affiliate links | L | — | L | Answer questions only. |
| — | Changelog News | **No** commercial products | — | — | — | Sponsorship only. |
| — | Console.dev | Dev tools in beta only | L | — | — | Not a dev tool. |
| — | TLDR | No submission route found | — | — | — | Paid ads only (unverified). |
| — | Discord | No suitable server verified | — | — | — | See section 4. |

---

## 2. Channel details

### 2.1 r/macapps (260,308 subscribers) — RANK 1
Source: https://old.reddit.com/r/macapps/about/rules.json, plus mod posts linked from there.

Current rules [Verified]:
- **Post approval first.** You must mark the rules as read (steps: https://www.reddit.com/r/macapps/comments/1smg62t/). The mods warn that 80 to 90% of posts that skip this are removed and trigger a 30-day cooldown.
- **One app post per developer per 30 days**, counted from the last post even if it was removed. Updates count. App Pile: one entry per developer per month.
- **Main feed** needs 300+ Reddit karma, an account 60+ days old, a pricing flair, and four labels:
  - **Problem:** one sentence.
  - **Comparison:** 2 best-in-class rivals (not Apple's), saying where yours is better and where theirs is.
  - **Pricing:** amounts and a link.
  - **Trust:** one of MAS, Dev Flair, GitHub (100+ stars or LinkedIn), or Website (LinkedIn, privacy policy, and signed and notarized).
  - Details: https://www.reddit.com/r/macapps/comments/1xo5ky1/
- Flair order is Lifetime > Subscription > Free. A $4.99 one-time app means Lifetime flair.
- **Links** must go to the official source (your site, the MAS, or GitHub). No shorteners. No paid affiliate or referral links. `?ref=` tags are fine.
- **Comments:** always disclose it is your app. Never promote yours in another developer's promotion post. In request threads, only with 300+ karma and a 60+ day old account.
- A 2nd self-promotion removal within 90 days means a 60-day promotion break.
- The App Pile megathread is for apps that do not qualify for the main feed. The November 2026 thread was posted 2026-11-01 (49 points, 117 comments when seen): https://www.reddit.com/r/macapps/comments/1xks9uj/. Entries must follow the PCP format, and a screenshot or video is required for top-3 consideration.

Audience fit [Inference]: High. This is where people ask how to get browser profiles as separate Dock apps (thread 1i8ybqm above).

Formats: an App Pile entry (PCP plus a short GIF of the Cmd-Tab switcher with several profile apps). Later, a main-feed post with Lifetime flair once notarized and a privacy policy is live.

Comparable posts [Verified, from r/macapps search]:
- "Made a app that let's you switch out your dock with profiles" (Dockfinity, free and open source), 2025-10-23, 153 points, 49 comments: https://www.reddit.com/r/macapps/comments/1odvvj6/
- "DockFlow celebrates 50 updates (v1.50) with Browser Profiles support…", 2025-09-16, 24 points, 26 comments: https://www.reddit.com/r/macapps/comments/1nio9hb/
- No r/macapps post about Unbundle was found by subreddit search (searches for "unbundle" and "unbundle.app"). [Verified, absence in search only]

Strategy:
1. Fix the gates in section 0.
2. Post an App Pile entry. Comparison: Unbundle (copies Chrome, about 500 MB per profile, imports existing profiles) and Parall (MAS, general multi-instance tool). State honestly where each is better than Tabloom today, for example "they keep your existing profiles; Tabloom currently starts fresh profiles".
3. Answer questions in the thread fast and factually.
4. After 30 days, and only if you qualify, make one main-feed post.

Spam risk: high if the rules are skipped (automatic removal plus cooldown). Never comment in request threads without meeting the karma and age bar, and always disclose.

### 2.2 TidBITS — RANK 2
- [Verified] Adam Engst published "How to Pitch Apps to TidBITS in the AI Era" on 2026-07-23: https://talk.tidbits.com/t/how-to-pitch-apps-to-tidbits-in-the-ai-era/33861. What it asks for:
  - Subject line `PITCH: <App> – <function, no adjectives>`, in a plain personal email.
  - App name and version, developer, supported macOS versions, price, and status.
  - Links, a review licence, and a press kit.
  - The problem the app solves and the competitors it differs from.
  - Your own voice, not AI-sounding text.
  - Follow up after about a week as a reply in the same thread.
  - Expect a fact check.
- [Verified] Public contact for pitches: ace@tidbits.com (https://tidbits.com/contact/). TidBITS does not accept press releases or sponsored posts.
- Fit [Inference]: a general Mac audience that likes careful utilities. The honest-limitations framing suits them.
- Do this only after notarization. A reviewer will install it.

### 2.3 MacStories — RANK 3
- [Verified] Club MacStories Weekly runs an "App Debuts" section credited to John Voorhees (for example https://www.macstories.net/club/macstories-weekly-issue-502/app-debuts/). The issues are paywalled.
- [Verified] MacStories' own advice to indie developers says to find the story and explain why their readers would care. The site receives a high volume of pitches: https://www.macstories.net/news/an-indies-guide-to-the-press/
- No public pitch email was found on a MacStories contact page (WebFetch returned 404). [Verified absence]
- Strategy: one short pitch about the problem (several Chrome profiles that are hard to tell apart in Cmd-Tab), with a GIF. Do not overclaim.

### 2.4 Hacker News, Show HN — RANK 4
Rules [Verified] (https://news.ycombinator.com/showhn.html):
- It must be something people can run, built by you, ready to try. Landing pages and sign-up pages do not count.
- People should be able to try it without sign-ups or emails.
- Title starts with "Show HN".
- Don't ask friends to upvote or comment.

Comparable Show HN posts [Verified, via the HN Algolia API]:

| Post | Date | Points | Comments |
|---|---|---|---|
| ChooseBrowser – route Mac links to a Chrome profile by URL rules ([link](https://news.ycombinator.com/item?id=49896673)) | 2026-09-29 | 1 | 1 |
| LinkPrism – route URLs to the right Chrome profile ([link](https://news.ycombinator.com/item?id=47197683)) | 2026-02-28 | 1 | 0 |
| Yojam – route links to the right browser/profile ([link](https://news.ycombinator.com/item?id=47822198)) | 2026-04-19 | 4 | 2 |
| Nightwatch – a Mac menu-bar app (an example of a small Mac utility that did well) ([link](https://news.ycombinator.com/item?id=49952148)) | 2026-10-04 | 89 | 28 |

- No Show HN for Unbundle was found.

Other observations:
- [Verified] An HN commenter in 2015 complained that Chrome profiles don't work with Cmd-Tab: https://news.ycombinator.com/item?id=10727663. This shows the pain point is long-standing.
- [Verified] The Parall developer introduced Parall in an HN comment on 2025-10-23: https://news.ycombinator.com/item?id=45678032

Strategy: post a Show HN with a free download or trial. Write the technical story (no Accessibility permission, no background process, separate bundle IDs and user-data-dirs) and list the limitations up front. Be present in the comments for several hours.

Risk [Inference]: high variance. Most profile tools got close to zero traction. HN readers will ask about re-signing, Chrome updates, and Google trademarks.

### 2.5 AlternativeTo — RANK 5
- [Verified] FAQ (https://alternativeto.net/faq):
  - Add your app via "Suggest new application"; admins verify it, and declines are common.
  - You can suggest it as an alternative to existing apps.
  - Developer access requires an email on the app's own domain.
  - No UTM tags on the official link.
  - Offering incentives for likes is discouraged, and fake accounts are prohibited.
  - Using a profile to advertise is not allowed.
- [Verified] Parall's page (https://alternativeto.net/software/parall/about/) showed 2 likes, was added 2025-10-22, and lists 22 alternatives.
- [Verified] No Unbundle page exists (`/software/unbundle/about/` returned 404).
- Strategy: submit Tabloom once there is a public site. Suggest it as an alternative to Parall, and to Unbundle if someone lists Unbundle. Fill in the license (paid) and platform (Mac) accurately.

### 2.6 Product Hunt — RANK 6
- [Verified] Rules from https://www.producthunt.com/launch/how-product-hunt-works:
  - Only personal accounts can post; company accounts can't post or comment.
  - New products, or substantive updates.
  - Paying for upvotes or for hunting gets the product removed or banned.
  - Ranking uses upvotes, comments, time and other factors.
  - Closed betas usually don't qualify.
- [Verified] Parall's launches (https://www.producthunt.com/products/parall/launches): 2025-11-04 showed "1" and "8"; 2026-09-24 showed "8" and "77". The labels are not shown, so it is unclear which number is upvotes and which is comments.
- [Verified, secondary source] A third-party guide says launches can be scheduled up to one month ahead and relaunches need a major update (https://blog.mean.ceo/?p=11616). Not confirmed on Product Hunt itself.
- Strategy: launch only after notarization and real user feedback, with a demo GIF and an honest "what doesn't work yet". Never ask for upvotes. Asking people to "check it out" is the norm, but do not run vote rings.

### 2.7 Mac Power Users forum (talk.macpowerusers.com) — RANK 7
- [Verified] The Parall developer posted "Parall: run the same Mac app separately with its own data and Dock icon" in Software on 2026-05-15: https://talk.macpowerusers.com/t/parall-run-the-same-mac-app-separately-with-its-own-data-and-dock-icon/45561
  - The post was flagged, then restored on 2026-07-09 after edits.
  - Members said they value developers who act like part of the community. The developer said he felt unwelcome.
- Strategy [Inference]: participate first. Post only as a disclosed developer asking for feedback, and keep it non-salesy. Read the forum guidelines before posting (not fetched).
- The podcast itself has a feedback form at relay.fm/mpu/feedback (see creator database).

### 2.8 r/apple (6,500,364 subscribers) — RANK 8
- [Verified] The rule reads: "Self-promotion is allowed on Sundays, only for developers… self-post only. Activity requirements are enforced." It links detailed rules at https://www.reddit.com/r/apple/wiki/rules (wiki not read).
- Strategy: only after reading the wiki and with an account that has genuine r/apple participation. Post a Sunday self-post (California time).

### 2.9 r/MacOSApps (28,553 subscribers) — RANK 9
[Verified] Rules:
- 5+ comment karma in the subreddit before posting.
- A single submission per app.
- A developer intro is required if the app is not on the MAS.
- Explain the value against existing solutions.
- **State notarization status.**
- A privacy policy is strongly encouraged.
- **AI disclosure** is required if AI generated a significant part of the code, UI or post text.
- No trademark or copyright infringement, including copycat branding.

Fit: small audience focused on cheap or lifetime apps. A $4.99 lifetime price fits.

### 2.10 MacUpdate — RANK 10
- [Verified] Listing fields and guidelines: https://www.macupdate.com/help/submit-app and https://macupdate.freshdesk.com/support/solutions/articles/5000548248-listing-guidelines. No fee information was shown.
- [Verified] Promotions require an Enhanced Product Page (help article 5000703735).

### 2.11 GitHub jaywcjlove/awesome-mac (117,772 stars, pushed 2026-11-05) — RANK 11
- [Verified] CONTRIBUTING (docs/CONTRIBUTING.md):
  - One suggestion per PR.
  - Format `[Name](link) - description`, alphabetical within its category.
  - Useful items only.
  - AI-assisted PRs should keep README.md, README-zh.md, README-ja.md and README-ko.md in sync (the repo ships a Codex skill for this).
  - There is also an issue template, "Addition to list".
- [Verified] Paid closed-source apps are listed (for example Parallels, without the freeware icon). Comparable apps already listed: Choosy and Velja (browser pickers). Parall and Unbundle are not listed.
- Strategy: one PR adding Tabloom to the most fitting category, using factual, one-sentence copy. [Inference] Value is mostly a backlink and discovery, not volume.

### 2.12 Indie Hackers / r/indiehackers (199,956) / r/SideProject (892,398) — RANK 12
- [Verified] r/indiehackers allows 1 self-promotion post with the Self Promotion flair, "for feedback and critique not advertisement".
- [Verified] r/SideProject returned no formal rules list. Its sidebar asks for the format `[Project name] - [Short description]`.
- [Verified] No official Indie Hackers (indiehackers.com) self-promotion policy was found; the site returned 403 to fetch. Third-party guides advise participating before launching.
- Fit [Inference]: makers, not buyers. Use these for a build-story post (a "$4.99 native Mac utility" angle) and for feedback.

### 2.13 9to5Mac — RANK 13
- [Verified] The "Submit a Tip / Contact Us" form is at https://9to5mac.com/contact/. No pitch guidance or tips email is published.
- [Inference] Low odds for a small utility. Send one factual tip only after launch.

### 2.14 Not suitable (rules forbid it, or the fit is poor)
- **r/mac (3,067,723):** "Promotion or advertising is not allowed… includes anything you've made… free or paid." [Verified] Do not post.
- **r/productivity (4,266,554):** "Self-promotion is not allowed here in any form, even if asked for recommendations." [Verified] Do not post.
- **r/MacOS (655,395):** Promotion is allowed on Saturdays (UTC) only, and only for apps on the Mac App Store or reputable, established GitHub repos. [Verified] Tabloom as a direct download does not qualify. Do not post unless that changes.
- **r/chrome (207,868):** Self-promotion only with moderator approval via modmail. [Verified] Optional: ask once; accept a no.
- **r/browsers (159,700):** No blanket self-promotion ban was listed. It does ban affiliate links and FAQ/how-to link posts. [Verified] Low fit; only answer direct questions, with disclosure.
- **Changelog News:** "Commercial products or services" are excluded and pointed to sponsorship. [Verified] (https://changelog.com/news/submit)
- **Console.dev:** Features 2 to 3 developer tools a week and lists only beta or pre-1.0 releases where developers are the main users. Submissions go to hello@console.dev. No sponsored reviews. [Verified] (https://console.dev/selection-criteria) Poor fit.
- **TLDR:** No editorial submission route was found; only advertising was seen in secondary sources. [Unverified]

---

## 3. Launch timing (evidence-backed only)
- r/macapps: the App Pile megathread is posted on the 1st of each month (Nov 2026 thread posted 2026-11-01). The 30-day per-developer clock starts at your last post. [Verified]
- r/apple: Sundays, California time. r/MacOS: Saturdays UTC, but Tabloom is not eligible. [Verified]
- No evidence-backed "best hour" was found for HN or Product Hunt. None is recommended.

## 4. Discord communities
- [Verified] MacStories runs a members-only Club Discord (https://www.macstories.net/?p=79387). It is not a promotion venue.
- No public Mac-indie Discord with a published self-promotion channel and rules could be verified. [Gap] Do not cold-post into Discords.

## 5. Suggested sequence [Inference]
1. Clear the gates (notarize, privacy policy, trial, honest limits page, trademark check).
2. Submit to AlternativeTo and MacUpdate, and open the awesome-mac PR. Low effort, permanent.
3. Post the r/macapps App Pile entry (first week of a month), with a GIF.
4. Act on feedback, then post Show HN with a free trial.
5. Pitch TidBITS and MacStories, plus creator outreach (see creator-outreach.md).
6. Product Hunt once there are real users and testimonials you are allowed to quote.
7. Make a main-feed r/macapps post after 30 days, if you meet the main-feed requirements.

## 6. Gaps
- Reddit pages could only be read through a browser. The r/apple wiki and the MPU forum guidelines were not read in full.
- No referral-traffic numbers are public for any channel. All traffic judgements are qualitative.
- Product Hunt's own launch-time rules were not confirmed. The secondary source is cited above.
