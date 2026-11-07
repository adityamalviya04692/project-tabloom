# Analytics & Growth Experiments

Research date: 2026-11-05. Labels: **[Verified]** seen at a source · **[Inference]** reasoning · **[Hypothesis]** untested.

The goal is not engagement. It is answering one question with the least traffic possible:
**will enough of the right people pay $X for this to cover its support and update costs?**

---

## 1. Measurement principles (privacy-first)

1. **No tracking inside the app by default.** A utility that touches browser profiles must not phone home silently. Any in-app event is opt-in, anonymous, and documented on the privacy page. **[Inference]** This is also a selling point against "is this spyware?" objections, which are common for tools that touch browser data.
2. **Website analytics without cookies**: Plausible, Umami (self-hostable, e.g. on Cloudflare), or Cloudflare Web Analytics. No consent banner needed for cookieless, aggregate analytics in most setups — confirm against your own legal reading for the EU before launch. **[Inference — not legal advice]**
3. **Attribution by UTM + referrer only.** Every link you post carries `utm_source` / `utm_medium` / `utm_campaign`. Pass the UTM through to checkout as a custom field / passthrough so revenue can be attributed per channel.
4. **Revenue truth lives in the payment provider** (webhooks / CSV export), not in analytics.

## 2. Funnel and how each step is measured

| # | Metric | How to measure | Privacy note |
|---|---|---|---|
| 1 | Landing page visits | Cookieless analytics pageviews / unique visitors | Aggregate only |
| 2 | Traffic source | Referrer + UTM | Aggregate only |
| 3 | Download clicks | Custom event on download button (e.g. `download_click`) | No identifiers |
| 4 | Successful installs | **Proxy**: first-launch ping only if user opts in on first run; otherwise use license activations / trial starts as the proxy | Opt-in; random install ID, no profile names |
| 5 | Profile setup completion | Opt-in event `first_app_created` (count of apps only, never profile names/emails) | Opt-in |
| 6 | Trial activations | Licensing server / payment provider trial record | Email only if they give it |
| 7 | Purchases | Payment provider webhook | Provider is MoR / processor |
| 8 | Refunds | Payment provider webhook; tag with reason (ask in refund form) | — |
| 9 | Support requests | Help-desk/email label per category: install, Keychain prompt, Chrome update, "not in Cmd-Tab", refund | — |
| 10 | Revenue by channel | UTM passed into checkout custom data → join in a spreadsheet weekly | — |

**Weekly dashboard (one spreadsheet is enough):** visits, download clicks, click→download rate, trials, purchases, visit→purchase rate, refunds, support tickets per 100 customers, net revenue — each split by source.

**Key ratios to watch**
- Visit → download click (landing page clarity)
- Download → first app created (onboarding; opt-in data only, so treat as a sample)
- Trial → purchase (product value)
- Support tickets per 100 customers (unit economics at $4.99 — see pricing-strategy.md)
- Refund rate (product–expectation mismatch, especially about existing profiles)

---

## 3. Sample-size reality check

At small-launch traffic, most A/B tests will **not** reach statistical significance. Be honest about that.

Rough per-arm sample to detect a difference between two conversion rates (≈80% power, 5% two-sided):
`n ≈ 16 · p(1−p) / Δ²` **[Verified formula — Lehr's rule of thumb]**

| Baseline conversion p | Detect change Δ | n per arm (approx.) |
|---|---|---|
| 20% (visit → download click) | +5 pts (20→25%) | ~1,000 visitors |
| 20% | +10 pts | ~260 visitors |
| 2% (visit → purchase) | +1 pt (2→3%) | ~3,100 visitors |
| 30% (trial → purchase) | +10 pts | ~340 trials |

**Rules we commit to**
- Test **upper-funnel** metrics (download click, trial start) where you can reach samples; treat purchase-level tests as directional.
- Decide sample size **before** starting; do not peek and stop early on a "winner".
- If the sample isn't reached in the planned window, record the result as **inconclusive**, and pick on qualitative grounds (support load, customer interviews).
- Never claim "statistically significant" in public material without the numbers.

---

## 4. Experiments

### E1 — Problem-focused vs solution-focused headline
- **Hypothesis [Hypothesis]:** Visitors from forum threads (who already feel the pain) respond better to problem framing ("Tired of every Chrome profile hiding behind one Command-Tab icon?"); search visitors respond better to solution framing ("Your Chrome profiles. Separate Mac apps. Native Command-Tab.").
- **Setup:** 50/50 split of hero headline + subhead via edge function or simple JS split with cookieless sticky bucketing (hash of day + IP is *not* recommended; use URL variants `/?v=a` from separate links, or a server-side split without storing identifiers). Same everything else.
- **Primary metric:** visit → download click.
- **Secondary:** scroll depth to demo, visit → trial, bounce.
- **Minimum practical sample:** ~1,000 visitors per arm (to see a 5-pt change from ~20%).
- **Decision:** adopt the variant if it wins by ≥3 pts on the primary metric with the sample reached; otherwise keep the solution headline (it matches search intent and the brand line).
- **Confounders:** traffic mix shifts (a Reddit spike skews to problem-aware users) → analyse per source; launch-day novelty.

### E2 — $3.99 vs $4.99 (requested) → recommended variant: $4.99 vs $6.99
> See pricing-strategy.md §8: at merchant-of-record fees $3.99 needs ~29% more buyers to match $4.99 net, whereas $6.99 can lose ~31% of buyers and still win. Run $4.99 vs $6.99 after existing-profile import ships; run $3.99 only if $4.99 conversion looks weak. Same design below applies to either pair.

- **Hypothesis [Hypothesis]:** Demand at this price range is fairly inelastic for people with the pain; $4.99 yields more net revenue per visitor because fixed payment fees take a bigger share at $3.99 (see pricing-strategy.md).
- **Setup:** Do **not** show two prices to the same population at the same time on a public page (fairness complaints and screenshots travel fast in r/macapps). Instead: **sequential test** — 2–3 weeks at $4.99, then 2–3 weeks at $3.99 (or vice versa), *or* channel-split via distinct discount codes (e.g. a launch code that gives $1 off) announced openly.
- **Primary metric:** **net revenue per visitor** (not conversion rate).
- **Secondary:** visit → purchase, refund rate, support tickets.
- **Minimum practical sample:** ≥3,000 visitors per period for anything beyond directional; at lower traffic, decide on net revenue per visitor + qualitative feedback ("too expensive" mentions).
- **Decision:** keep the higher price unless the lower one lifts net revenue per visitor by ≥20%.
- **Confounders:** seasonality, a creator video landing in one period, launch novelty in period 1 (run the launch period at the intended long-term price).

### E3 — Free trial vs limited free version
- **Variants:** (A) full product, 7-day trial, then purchase; (B) free forever for **1 profile app**, pay to unlock unlimited.
- **Hypothesis [Hypothesis]:** (B) produces more installs and word-of-mouth but lower paid conversion; since the core value is *multiple* identities in Cmd-Tab, a 1-app limit still demonstrates value (Chrome + 1 separate profile).
- **Setup:** Cohort-based (by release/download period), because licensing logic ships in the binary.
- **Primary metric:** paid customers per 100 downloads, measured 30 days after download.
- **Secondary:** downloads per visitor, support load per paying customer, refund rate.
- **Minimum practical sample:** ~300 downloads per cohort.
- **Decision:** choose the variant with the higher paid-per-download × price, unless support load per paying customer is >2× worse.
- **Confounders:** release-version bugs differ between cohorts; channel mix.

### E4 — Technical vs productivity messaging
- **Variants:** (A) "How it works": per-profile app bundles, real processes, no Accessibility permission, no background daemon. (B) "Find the right Chrome in one keystroke: Work, Personal, Client A."
- **Hypothesis [Hypothesis]:** r/macapps / HN visitors convert better on A; YouTube and search visitors on B.
- **Setup:** Two landing variants linked per channel (`/how-it-works` led page vs `/` productivity page), UTM tagged.
- **Primary metric:** visit → download click per channel.
- **Decision:** per-channel landing page if the gap is ≥5 pts; otherwise one page.
- **Confounders:** channel itself is the treatment here — this is a segmentation test, not a clean A/B.

### E5 — 5-second demo vs detailed walkthrough
- **Variants:** (A) silent 5–8 s looping video above the fold (before/after Cmd-Tab); (B) 60–90 s narrated walkthrough above the fold.
- **Hypothesis [Hypothesis]:** A wins on download clicks; B reduces "it didn't work as I expected" refunds and support tickets.
- **Primary metric:** visit → download click. **Guardrail:** refund rate and "expectation" support tickets.
- **Minimum practical sample:** ~1,000 visitors per arm.
- **Decision:** keep A above the fold and B lower on the page unless B is within 2 pts on clicks and clearly reduces refunds.

### E6 — Reddit vs YouTube vs organic search traffic quality
- **Not an A/B test — a channel cohort comparison.**
- **Hypothesis [Hypothesis]:** Search traffic ("chrome profiles command tab mac") has the highest purchase intent; Reddit gives a spike with lower conversion; YouTube depends on creator fit.
- **Setup:** strict UTM discipline; per-channel cohorts for 30 days.
- **Primary metric:** net revenue per visitor and per hour of effort spent on the channel.
- **Secondary:** refund rate, support tickets per customer by channel.
- **Decision:** after 6 weeks, double down on the top channel by **net revenue per hour of effort**; drop channels below $5/hour equivalent unless they build durable assets (SEO pages, evergreen videos).
- **Confounders:** dark social (people see a Reddit post, Google the name later → shows as "direct/organic"). Add a "How did you hear about us?" optional field at checkout to correct for this.

---

## 5. Experiment log template

| ID | Start | End | Variant A | Variant B | Planned n | Actual n | Primary result | Decision | Notes |
|---|---|---|---|---|---|---|---|---|---|
| E1 | | | | | 1,000/arm | | | | |

## 6. What NOT to measure
- Profile names, Google account emails, URLs, or browsing data — never, even opt-in.
- Vanity metrics as goals (followers, impressions). Track them only as inputs.
