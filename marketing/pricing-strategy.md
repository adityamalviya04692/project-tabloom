# Pricing & Monetization Strategy

Research date: 2026-11-05. Labels: **[Verified]** seen at source · **[3rd-party]** reported by a non-official source · **[Inference]** · **[Hypothesis]**.
Fee sources: Paddle https://www.paddle.com/pricing, Lemon Squeezy https://www.lemonsqueezy.com/pricing, Polar https://polar.sh/resources/pricing, Gumroad https://gumroad.com/pricing, Stripe Tax https://stripe.com/tax/pricing, Stripe Managed Payments https://support.stripe.com/questions/managed-payments-pricing, Apple Small Business Program https://developer.apple.com/app-store/small-business-program/, Setapp https://docs.setapp.com/docs/distributing-revenue. All accessed 2026-11-05.

---

## 1. The market price band

| Product | Price | Model | Relevance |
|---|---|---|---|
| Unbundle | $6.99 | One-time, direct (Stripe link) | Direct competitor **[Verified]** |
| Parall | $10.99 | Mac App Store, paid | Direct-ish competitor (per-app Dock shortcuts) **[Verified]** |
| Superdock | Dock free; Chrome profile icons $7.99 / 5 Macs | Freemium | Adjacent (Accessibility, custom switcher) **[Verified]** — see competitor-analysis.md |
| Okie Dockie | $19 / 3 Macs | One-time | Adjacent **[Verified]** — see competitor-analysis.md |
| Parallel Spaces | $4.99 | Mac App Store | Same price point **[Verified]** — see competitor-analysis.md |
| Lungo | $4 | One-time (MAS/Setapp) | Price anchor for "tiny utility" **[Verified]** |
| Velja / Choosy | $10 | One-time | Browser-workflow utilities **[Verified]** |
| Hand Mirror Plus | $6.99 | One-time IAP | Tiny utility **[Verified via search summary]** |
| AltTab, Ice, Amphetamine, Itsycal | Free | Open source / free | The "free" anchor users compare against **[Verified]** |

**[Inference]** Paid single-purpose Mac utilities cluster at **$4–$11 one-time**. $4.99 undercuts both direct competitors; the free anchor (DIY scripts, chrome-schismator, AltTab + ⌘-\`) is the real competitor for price-sensitive users.

## 2. Fees at each price point (per sale, US card)

| Platform | $2.99 | $3.99 | $4.99 | $6.99 | Handles VAT/sales tax? |
|---|---|---|---|---|---|
| Paddle / Lemon Squeezy / Polar Starter (5% + $0.50) **[Verified]** | $0.65 (21.7%) | $0.70 (17.5%) | $0.75 (15.0%) | $0.85 (12.2%) | Yes (MoR) |
| Stripe Managed Payments (≈6.4% + $0.30) **[Verified 3.5% add-on; total 3rd-party]** | $0.49 | $0.56 | $0.62 | $0.75 | Yes (MoR) |
| Gumroad direct (10% + $0.50) **[Verified]** | $0.80 | $0.90 | $1.00 | $1.20 | Yes |
| FastSpring (8.9%, $0.75 min) **[3rd-party]** | $0.75 | $0.75 | $0.75 | $0.75 | Yes |
| Stripe + Stripe Tax (no MoR) **[3rd-party + Verified]** | $0.40 | $0.44 | $0.47 | $0.54 | **No** (you register/file) |
| Mac App Store 15% **[Verified]** | $0.45 | $0.60 | $0.75 | $1.05 | Yes |

Non-US cards add ~1.5% on Stripe/Polar. **[Verified/3rd-party]**

**Takeaways [Inference]**
- The fixed ~$0.50 hurts at low prices: at $2.99 a merchant of record takes **over 20%**, while at $6.99 the cut drops to about 12%.
- **Recommended processor: a merchant of record.** You're a solo developer selling worldwide, and doing EU/UK VAT yourself isn't worth saving about $0.30 a sale. Stripe Managed Payments is the cheapest MoR at these prices. Paddle and Polar are proven alternatives. Lemon Squeezy is moving its users to Stripe Managed Payments **[Verified, LS 2026 update]**, so don't start new on Lemon Squeezy.
- **Mac App Store is probably not an option** for the core feature. Creating app bundles and launching Chrome with custom data directories likely won't pass the sandbox **[Hypothesis — untested; Parall ships on MAS with a launcher concept, so test before ruling out]**.
- **Setapp** pays out by usage. A set-and-forget utility that runs inside Chrome processes may log little "usage" **[Hypothesis]**. Revisit after launch.

## 3. Option evaluation

| Model | Pros | Cons | Verdict |
|---|---|---|---|
| **$2.99 lifetime** | Lowest friction | Fees >20%; needs 1.6× the customers of $4.99 for equal net; signals "toy" | ❌ **[Inference]** |
| **$3.99 lifetime** | Under the $4 Lungo anchor | Needs **~29% more customers** than $4.99 to make the same net (net/sale $3.09 vs $3.99) | Test only if $4.99 conversion is visibly weak |
| **$4.99 lifetime** | Under Unbundle ($6.99) and Parall ($10.99); same as Parallel Spaces; fees 15% | Leaves money on the table once existing-profile import ships **[Inference]** | ✅ **Launch price** |
| **$6.99 lifetime** | Matches Unbundle; net/sale $5.79. Can lose **31%** of buyers and still match $4.99 net | Hard to justify **while Tabloom lacks existing-profile import and Unbundle claims it** | ✅ Raise to this *after* import ships and is verified |
| **Free version + paid upgrade** (1 free profile app) | More installs, word of mouth, reviews; shows the core value | Support for free users; licensing code | Strong candidate (E3) |
| **Free trial (7 days) → purchase** | Simple; full value | Trial-reset abuse (low stakes at $4.99) | Strong candidate (E3) |
| **Pay-what-you-want** | Goodwill | Anecdotes: Stand averaged $2.60 with 1.1% paying; Thought Train $2.90 before moving to a fixed $3.99 **[3rd-party anecdotes, old]** | ❌ |
| **Open-source core + paid convenience** | Trust (it touches browser data); HN/GitHub reach; awesome-mac listing | Anyone can build it for free; only ~$5 on the table to defend; maintenance load | Consider later for **trust**, not now **[Inference]** |

## 4. Costs that eat into net

| Cost | Amount | Label |
|---|---|---|
| Apple Developer Program (needed to notarize, which r/macapps and every serious channel expect) | $99/year | Verified (Apple's published fee) |
| Domain | ~$10–20/year | Inference |
| Hosting (Cloudflare Pages + R2) | ~$0 at this scale | Inference |
| Refunds | Assume **5% of sales** refunded and MoR fee not returned | **Hypothesis** — no public indie Mac refund data found |
| Support | Assume **10 tickets per 100 customers × 15 min = 2.5 h per 100 customers** | **Hypothesis** — measure from the beta |
| Chrome update maintenance | Unknown; every Chrome major release may need a check | Hypothesis — the biggest ongoing cost risk |

## 5. Scenario models (Paddle-like MoR 5% + $0.50; 5% refunds; $119/yr fixed costs)

**Gross** = price × customers. **Net** = gross − processor fees − refunded revenue − $119 fixed. Support time is listed separately because it costs your time, not cash.

| Price | Customers | Gross | Processor fees | Refunds | **Net (cash)** | Support time (hyp.) | Net per support hour |
|---|---|---|---|---|---|---|---|
| $2.99 | 100 | $299 | $65 | $15 | **$100** | 2.5 h | $40 |
| | 500 | $1,495 | $325 | $75 | **$976** | 12.5 h | $78 |
| | 1,000 | $2,990 | $650 | $150 | **$2,072** | 25 h | $83 |
| | 5,000 | $14,950 | $3,248 | $748 | **$10,836** | 125 h | $87 |
| $3.99 | 100 | $399 | $70 | $20 | **$190** | 2.5 h | $76 |
| | 500 | $1,995 | $350 | $100 | **$1,426** | 12.5 h | $114 |
| | 1,000 | $3,990 | $700 | $200 | **$2,972** | 25 h | $119 |
| | 5,000 | $19,950 | $3,498 | $998 | **$15,336** | 125 h | $123 |
| **$4.99** | 100 | $499 | $75 | $25 | **$280** | 2.5 h | $112 |
| | 500 | $2,495 | $375 | $125 | **$1,876** | 12.5 h | $150 |
| | 1,000 | $4,990 | $750 | $250 | **$3,872** | 25 h | $155 |
| | 5,000 | $24,950 | $3,748 | $1,248 | **$19,836** | 125 h | $159 |
| $6.99 | 100 | $699 | $85 | $35 | **$460** | 2.5 h | $184 |
| | 500 | $3,495 | $425 | $175 | **$2,776** | 12.5 h | $222 |
| | 1,000 | $6,990 | $850 | $350 | **$5,672** | 25 h | $227 |
| | 5,000 | $34,950 | $4,248 | $1,748 | **$28,836** | 125 h | $231 |

Before income tax. Excludes the time to build the product, keep up with Chrome updates, and market it.

**What this means [Inference]**
- **On its own this is a side income, not a living.** Even 5,000 customers at $4.99 nets about $20k **in total**, since it's a one-time sale. Most single-purpose Mac utilities never publish customer counts, and none of the direct competitors show any public traction, so treat 1,000+ customers as **unproven**.
- The way this becomes sustainable: (a) a higher price once existing-profile import ships, (b) more browsers (Edge, Brave, Arc users with the same pain, per customer-research.md), (c) paid major upgrades (v2), (d) cheap ongoing acquisition through SEO. All four are hypotheses to validate.
- **Kill/continue signal:** fewer than ~100 paying customers in the first 60 days after a launch on at least 3 channels, or refunds above 15%, means the demand or the product isn't there yet. Pause and reassess before investing in v2. **[Inference — a judgement threshold, not a benchmark]**

## 6. Licensing complexity
- **Simplest workable:** MoR licence keys checked offline (signed key) and verified once online. No account, no DRM fight. At $4.99, piracy isn't worth engineering against. **[Inference]**
- Licence covers personal use on all your Macs (match Unbundle's simplicity). No seat counting.
- Updates: "all 1.x updates included". A future v2 is a discounted upgrade.

## 7. Conversion friction to remove
1. **Unsigned/un-notarized download.** It's a blocker for channels (r/macapps trust rules) and for users (Gatekeeper warnings). Notarize before launch. **[Verified, see distribution-channels.md]**
2. **"Will I lose my logins?"** Answer it above the fold on the pricing card.
3. **Wrong-machine purchases.** Show system requirements beside the Buy button.
4. **Checkout:** an overlay checkout with Apple Pay. No account creation.

## 8. Recommended pricing plan and experiment
1. **Launch at $4.99 one-time with a 7-day full trial** (no account; trial in the app). Simplest licensing, and the full value shows immediately. **[Inference]**
2. **First experiment: free 1-app tier vs 7-day trial (E3)** by download cohort. It decides the funnel shape and matters more than $1 of price. **[Hypothesis]**
3. **Then a sequential price test: $4.99 → $6.99** once existing-profile import ships and is verified. Primary metric: net revenue per visitor (E2 in growth-experiments.md; run $4.99 vs $6.99 rather than $3.99, because $3.99 needs 29% more buyers to break even while $6.99 can lose 31% and still win).
4. Don't run concurrent price splits on the public page. r/macapps notices and resents them. **[Inference]**
5. **Launch discount:** if any, a public, time-boxed code (e.g. $1 off for beta testers), never a fake "was $9.99" anchor.
