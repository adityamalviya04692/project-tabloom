# Landing Page Specification

Research date: 2026-11-05. Working name: **Tabloom** (see brand-research.md before buying a domain).
Copy lives in [landing-page-copy.md](landing-page-copy.md); FAQ in [faq.md](faq.md).

## 0. Claim gate (read first)

Every claim on the page must map to a row in this table. If a claim's status isn't "Verified", it does not ship.

| Claim | Status (2026-11-05) | Evidence | Allowed wording now |
|---|---|---|---|
| Each profile becomes its own app with its own Dock icon and own Command-Tab entry | **Verified programmatically**, visual Cmd-Tab overlay **not yet eyeballed** | TECHNICAL_SPIKE.md T1–T4 | Ship only after the manual Cmd-Tab check + screen recording |
| Uses the native macOS Command-Tab switcher (no custom switcher) | Verified by design | ARCHITECTURE.md approach A | Yes |
| No Accessibility permission, no background process | Verified by design | ARCHITECTURE.md | Yes |
| Profiles isolated from each other | Verified (cookie test) | T5–T6 | Yes |
| Sessions persist across quit/relaunch | Verified | T5 | Yes |
| **Keeps your existing Chrome profiles / logins** | **NOT verified** — currently fresh profile per app | ARCHITECTURE.md "limitation" | **No.** Say: "Each app starts as a fresh Chrome profile; sign in once and Chrome Sync brings your bookmarks, extensions and passwords." |
| Works after Chrome updates | **NOT verified**; repair step planned | Open risk #2 | "Tabloom checks for Chrome updates and rebuilds your apps" — only once implemented and tested |
| Compatible with macOS X / Intel / Chrome version Y | Only macOS 26.1, Apple Silicon, Chrome 156 tested | Spike env | List exactly what's tested; everything else "not yet tested" |
| Uses ~0 extra disk space | Measured in spike (APFS clone), grows after Chrome updates until rebuilt | ARCHITECTURE.md | "Uses APFS clones, so new apps take almost no extra disk space until Chrome updates" — after re-measuring in the shipping build |
| Works with Brave/Edge/Arc | Not built | — | No |
| Endorsed by Google | False | — | Never. Add trademark disclaimer. |

## 1. Page structure (single page, mobile-friendly, < 150 KB excluding video)

| # | Section | Purpose | Content | Notes |
|---|---|---|---|---|
| 1 | **Hero** | Explain in 5 s | Headline, one-line subhead, primary CTA (Download free trial / Buy $4.99), secondary CTA (Watch 5-second demo), small trust line "One-time purchase · No subscription · No Accessibility permission" | Headline variants in copy doc (E1 test) |
| 2 | **5-second demo** | Show, don't tell | Autoplay muted loop (MP4/WebM, ~6–8 s, < 1.5 MB): press ⌘-Tab → one Chrome icon … cut … press ⌘-Tab → Chrome · Work (red W) · Personal (blue P) · Client A | Real screen recording only, after the visual check passes. Add `<track>` captions; `poster` image for no-autoplay. |
| 3 | **Before / After** | Make the pain concrete | Two side-by-side frames: Before: one Chrome tile, windows from 3 profiles mixed; After: one tile per profile with distinct icons | Static images (WebP) with alt text |
| 4 | **How it works** | Credibility for technical buyers | 3 steps: Pick a name + icon → Tabloom builds a small Mac app that runs Chrome with its own profile → It appears in Dock, Launchpad, Spotlight and ⌘-Tab like any app. Expandable "Under the hood" for developers (per-app bundle, real Chrome process, APFS clone, no injected code) | Link to the engineering blog post |
| 5 | **Key features** | Scan list | 6 cards max: Native ⌘-Tab · Own Dock icon · Custom icons/colors · Profile isolation · No subscription · Clean uninstall | Only verified ones |
| 6 | **Privacy & security** | Remove fear | What Tabloom does/doesn't touch; no telemetry by default; no Accessibility permission; your Chrome is never modified; open about ad-hoc signing/notarization status | Must be accurate at ship time — update when notarized |
| 7 | **Compatibility** | Set expectations, reduce refunds | Tested matrix table (macOS, chip, Chrome version) + "not yet tested" list | Update per release |
| 8 | **Pricing** | Convert | One card: $4.99 one-time (or experiment price), what's included (updates for v1.x), trial terms, refund policy | Merchant-of-record handles VAT |
| 9 | **FAQ** | Objection handling | 10–14 Qs from faq.md, `FAQPage` JSON-LD | |
| 10 | **Final CTA** | Convert scrollers | Repeat headline + download button + system requirements one-liner | |
| — | Footer | Legal | Privacy policy, refund policy, contact, "Google Chrome is a trademark of Google LLC. Tabloom is not affiliated with or endorsed by Google." | |

## 2. Conversion details
- **One primary action** per screen. Primary = "Download free trial" if E3 picks trial; "Buy for $4.99" button opens the MoR overlay checkout.
- Show **system requirements next to the button** ("macOS 26 · Apple Silicon · Google Chrome installed") to prevent wrong-machine purchases.
- **Email capture** only for: beta list (pre-launch) and "notify me when Intel/Brave is supported".
- No pop-ups, no chat widget, no countdown timers. **[Inference]** These read as spammy to the r/macapps/HN audience.
- Page must load fast with JS disabled except checkout.

## 3. SEO requirements
- `<title>`: "Tabloom — Chrome profiles as separate Mac apps in Command-Tab" (≤ 60 chars variant needed)
- Meta description ≤ 155 chars with "Chrome profiles", "Command-Tab", "Mac".
- One H1 (hero). H2s per section using search phrasing: "How to get Chrome profiles in Command-Tab", "Separate Dock icon for each Chrome profile".
- JSON-LD: `SoftwareApplication` (operatingSystem: macOS, offers price), `FAQPage`.
- Open Graph image = the after-state ⌘-Tab screenshot (1200×630).
- Separate pages: `/how-it-works`, `/compare/unbundle` (fair, factual, dated), `/guides/*` (see seo-strategy.md).

## 4. Pre-launch vs launch variants
- **Pre-launch (Week 1–3):** Hero + demo (once verified) + "Join the beta" email form + honest status ("works with fresh profiles; existing-profile import in testing").
- **Launch:** swap form for checkout; add compatibility table and testimonials (permission-based only, with name/handle as the person agreed).

## 5. Analytics events
`download_click`, `buy_click`, `demo_play`, `faq_open:{id}`, `beta_signup`. UTM passthrough to checkout. See growth-experiments.md.

## 6. Tech stack suggestion [Inference]
Static site (Astro or plain HTML) on Cloudflare Pages; cookieless analytics; MoR checkout overlay; Sparkle appcast for updates; DMG notarized download hosted on R2.
