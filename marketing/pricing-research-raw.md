# Pricing research (raw): payment fees + comparable Mac utility prices

All accessed 2026-11-05. [Verified] = seen at source; [3rd-party] = reported by non-official source; [Inference] = reasoning.

## 1. Payment platform fees

| Platform | Published fee | MoR (handles VAT/sales tax)? | Notes | Source |
|---|---|---|---|---|
| Paddle | 5% + $0.50 per checkout transaction (Pay-as-you-go) [Verified] | Yes | Page says sellers of products under $10 can contact Paddle for bespoke pricing; no figures given | https://www.paddle.com/pricing |
| Lemon Squeezy | 5% + $0.50 [Verified]; "small additional fees" for non-US transactions and some payment methods, amounts not on pricing page | Yes | Footer: "Sold through Link, LLC f/k/a Lemon Squeezy LLC". 2026 blog: team is building Stripe Managed Payments and will help LS users migrate. Support/updates slower during transition [Verified] | https://www.lemonsqueezy.com/pricing , https://www.lemonsqueezy.com/blog/2026-update |
| Gumroad | Direct sales 10% + $0.50; Discover marketplace sales 30% [Verified] | Yes since 2025-01-01 [Verified] | Unclear whether card processing is included in 10% + $0.50 | https://gumroad.com/pricing |
| Stripe (US cards) | 2.9% + $0.30; +1.5% non-US cards; +1% currency conversion; $15 per dispute [3rd-party, consistent across several trackers; Stripe's US page did not render for our fetcher] | No (you are merchant) | stripe.com/pricing served India pricing to our fetcher | https://checkoutpage.com/blog/stripe-processing-fees , https://www.nerdwallet.com/business/software/learn/stripe-fees |
| Stripe Tax | 0.5% per transaction (no-code/Checkout) or $0.50 per transaction (API) where registered [Verified] | No, calculation/collection only; you must register and file yourself | | https://stripe.com/tax/pricing |
| Stripe Managed Payments | 3.5% per successful transaction **on top of** standard Stripe processing (so about 6.4% + $0.30 for US cards) [Verified 3.5% at Stripe support; total is 3rd-party math] | Yes (Stripe is MoR; tax in 80+ countries) | For digital products/SaaS; Checkout and Payment Links only | https://support.stripe.com/questions/managed-payments-pricing , https://docs.stripe.com/payments/managed-payments |
| FastSpring | Not published; "flat-rate", volume-based, negotiated [Verified]. Widely reported 5.9% + $0.95, or 8.9% for orders under $25 with a $0.75 minimum [3rd-party, not confirmed by FastSpring] | Yes | | https://fastspring.com/pricing/ , https://www.g2.com/discussions/how-much-does-fastspring-cost |
| Polar.sh | Starter (free): 5% + $0.50; Pro $20/mo: 3.8% + $0.40; Growth $100/mo: 3.6% + $0.35; Scale $400/mo: 3.4% + $0.30; +1.5% non-US cards; $15 per dispute; payout fees (Stripe): $2/month active + 0.25% + $0.25 per payout [Verified] | Yes | Legacy "Early Member" 4% + $0.40 for orgs created before 2026-05-27 | https://polar.sh/resources/pricing |
| Mac App Store | Small Business Program: 15% for developers under $1M prior-year proceeds (and new developers) [Verified]. Standard: 30% [not re-verified on an Apple page this session; standard rate per Apple's developer agreement] | Apple handles tax | 10% for some EU alternative-terms cases and subscriptions after year one (page wording ambiguous) [Verified] | https://developer.apple.com/app-store/small-business-program/ |
| Setapp | Membership: 70% of each user's fee, split by usage; +20% partner fee if you referred the user (up to 90%). Single-app distribution: 85% of subscriptions, 75% of one-time purchases [Verified] | Setapp | | https://docs.setapp.com/docs/setapp-marketplace-overview , https://docs.setapp.com/docs/distributing-revenue |

### Fee behaviour at $2.99 / $4.99 / $6.99 (fee / net / effective %)

Computed on the list price, one US card, no tax line, no payout fees, no refunds/chargebacks. [Inference: arithmetic on the figures above]

| Platform | $2.99 | $4.99 | $6.99 |
|---|---|---|---|
| Paddle / Lemon Squeezy / Polar Starter (5% + $0.50) | $0.65 / $2.34 (21.7%) | $0.75 / $4.24 (15.0%) | $0.85 / $6.14 (12.2%) |
| Polar Starter, non-US card (6.5% + $0.50) | $0.69 / $2.30 (23.2%) | $0.82 / $4.17 (16.5%) | $0.95 / $6.04 (13.7%) |
| Gumroad direct (10% + $0.50) | $0.80 / $2.19 (26.7%) | $1.00 / $3.99 (20.0%) | $1.20 / $5.79 (17.2%) |
| Stripe card only, US (2.9% + $0.30), no MoR | $0.39 / $2.60 (12.9%) | $0.44 / $4.55 (8.9%) | $0.50 / $6.49 (7.2%) |
| Stripe + Stripe Tax 0.5% (US card) | $0.40 / $2.59 (13.4%) | $0.47 / $4.52 (9.4%) | $0.54 / $6.45 (7.7%) |
| Stripe + Tax, non-US card (+1.5%) | $0.45 / $2.54 (14.9%) | $0.54 / $4.45 (10.9%) | $0.64 / $6.35 (9.2%) |
| Stripe Managed Payments, US card (6.4% + $0.30) | $0.49 / $2.50 (16.4%) | $0.62 / $4.37 (12.4%) | $0.75 / $6.24 (10.7%) |
| FastSpring under $25 (8.9%, $0.75 min) [3rd-party rate] | $0.75 / $2.24 (25.1%) | $0.75 / $4.24 (15.0%) | $0.75 / $6.24 (10.7%) |
| Mac App Store 15% | $0.45 / $2.54 | $0.75 / $4.24 | $1.05 / $5.94 |
| Mac App Store 30% | $0.90 / $2.09 | $1.50 / $3.49 | $2.10 / $4.89 |

Observations [Inference]:
- At $4.99, Paddle, Lemon Squeezy, Polar Starter and the App Store's 15% all cost about the same: $0.75, or 15%.
- At $2.99 the fixed $0.50 pushes merchant-of-record fees above 20%; at $6.99 they fall to about 12%.
- Stripe Managed Payments is the cheapest merchant-of-record option at these prices, because its fixed fee is $0.30, not $0.50.
- Plain Stripe is cheapest overall, but you must handle EU VAT/UK VAT and other taxes yourself (registration, filing). For a solo developer selling globally this is usually not worth the saving.
- Note on MAS: a sandboxed App Store build likely cannot create .app bundles and launch Chrome with custom user-data-dirs the way this product does [Hypothesis, untested]. Parall does ship on the Mac App Store with a similar launcher concept, so this should be tested before ruling it out.
- Refunds: some MoRs keep their fee on refunded orders; not checked per platform.

## 2. Comparable macOS utility prices

| App | Price (USD) | Model | Notes | Source |
|---|---|---|---|---|
| Unbundle | $6.99 | One-time; "No subscription. No account." | Buy button links to buy.stripe.com (suggests Stripe; not confirmed). Trial, refunds, seat count not stated | https://www.unbundle.app/ |
| Parall | $10.99 | Mac App Store, paid up front | Direct functional competitor (per-profile Dock shortcut apps) | https://apps.apple.com/us/app/parall/id6754065114 |
| Rectangle Pro | Price not rendered on official page; $9.99 per a user forum post [unverified] | One-time lifetime license, 3 active devices, 10-day free trial; sold via Paddle | | https://rectangleapp.com/pro , https://rectangleapp.com/pro/docs/purchase-activation/ , https://talk.macpowerusers.com/t/rectangle-pro-a-novel-if-not-unique-take-on-window-management/27303 |
| Velja | $10.00 | One-time, Mac App Store; free trial with nag; was free for ~3 years | | https://sindresorhus.com/velja , https://apps.apple.com/us/app/velja/id1607635845 |
| Choosy | $10 | Licence key (direct sale) | | https://choosy.app/ |
| Bartender | Official page loads prices dynamically (not captured). MacRumors at Bartender Pro launch: Bartender 6 $20 one-time; Pro $15/yr; Mega Supporter $80 lifetime [3rd-party, may be dated] | One-time (v7) + yearly Pro + lifetime tier; 14-day refund | | https://www.macbartender.com/Bartender5/buy/ , https://forums.macrumors.com/threads/bartender-pro-brings-widgets-clipboard-and-file-storage-to-the-macbook-notch.2482292/ |
| Ice | Free | Open source (GPL-3.0); GitHub Sponsors / Buy Me a Coffee | | https://github.com/jordanbaird/Ice |
| Hand Mirror | Free; Hand Mirror Plus $6.99 one-time IAP ("Generous" tier $12.99) | Freemium, one-time unlock | Developer Rafael Conde. IAP prices from search summary of the US listing | https://apps.apple.com/us/app/hand-mirror/id1502839586 |
| CleanShot X | $35 one-time (+1 yr updates; $19/yr renewal); Pro $10/user/mo billed annually | One-time + optional subscription; 30-day money-back; also on Setapp | | https://cleanshot.com/pricing |
| Raycast | Free; Pro $10/mo or $96/yr; Plus $20/mo; Max $50/mo | Freemium subscription | | https://www.raycast.com/pricing |
| AltTab | Free (GPL-3.0); paid AltTab Pro tier (price not captured), 14-day trial | Open-core | | https://alt-tab.app/ |
| Lungo | $4.00 | One-time, Mac App Store (also Setapp) | Closest price point to $4.99 | https://sindresorhus.com/lungo , https://apps.apple.com/us/app/lungo/id1263070803 |
| Amphetamine | Free, no IAP | Free | | https://apps.apple.com/us/app/amphetamine/id937984704 |
| Itsycal | Free | Open source (MIT); described as donation-ware by one blog | | https://alternativeto.net/software/itsycal/about , https://www.mowglii.com/itsycal/ |
| Mela (Mac) | Free download; Mela+ for macOS $14.99 one-time IAP | Freemium, one-time unlock per platform | | https://apps.apple.com/us/app/mela-recipe-manager/id1568924476 |

Pattern [Inference]: single-purpose paid utilities cluster at $4–$11 one-time. The direct competitors are Unbundle at $6.99 and Parall at $10.99. A $4.99 price would undercut both.

## 3. Refund rates / pay-what-you-want data (sourced only)

- No public indie Mac app refund-rate data found in this session. The only refund benchmarks found are for Steam games (around 10% average per a GameDiscoverCo survey, reported in coverage of the "Paddle Paddle Paddle" refund controversy), which is not comparable. https://finalboss.io/steam-refunds-controversy-short-playthroughs-burn-indie-devs
- Pay-what-you-want, anecdotal:
  - Stand (small Mac reminder utility): average payment $2.60 across 131 charges; 1.10% paid conversion. https://medium.com/@reddavis/stand-app-9ee0fc3355c
  - Thought Train: users paid an average of $2.90 under PWYW before the developer moved to a fixed $3.99 base price. https://medium.com/@marcperel/how-i-unlocked-750-month-of-revenue-from-my-app-with-a-single-decision-c330ad9273c8
  - Both posts are several years old and single-app anecdotes, not benchmarks.
