# Thailand (researched 2026-10-04, by Claude Sonnet 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med for a small foreign-run app with a few users here. High if it grows (5,000+ Thai users/month, or sales over THB 1.8M/yr).
Note: no regulator site could be fetched (pdpc.or.th returned 403). [V] lines below are confirmed from law-firm / news pages (Tilleke & Gibbins, Bangkok Post etc.), not the regulator. Marked [V] = seen in a source today, [K] = memory, unconfirmed.

## Privacy
- [V] Personal Data Protection Act B.E. 2562 (PDPA), enacted 27 May 2019, fully enforced 1 June 2022. Source: clym/HSF Kramer summaries (see Sources).
- [V] Reaches foreign developers: applies to overseas operators that offer goods/services to people in Thailand. (secondary source)
- [K] Foreign controllers must appoint a local representative in Thailand, unless occasional processing of non-sensitive data. Tilleke's 2019 draft article mentions the representative duty, but I did not confirm the final law's exceptions.
- [K] Small-business exemption: PDPC announcement (2022) exempts some small organisations from keeping records of processing (RoPA), but NOT from consent, notice, security or breach duties. Not confirmed today.
- [V] Consent must be explicit, six lawful bases exist incl. legitimate interest. (consentstack/clym)
- [K] Children: parental consent needed for under 10; ages 10-19 can consent alone only for things a minor may legally do alone, otherwise parent consent is needed. Draft text confirms "under 10" ([V] Tilleke 2019 draft article); final-law detail on 10-19 is [K].
- [V] Breach notice: PDPC and affected people within 72 hours (the PDPC must be told within 72h of becoming aware; users only if high risk [K]).
- [V] Cross-border transfers need adequate protection in the destination, or an exemption (consent, contract, etc.).
- [K] Fines: administrative up to THB 5M, criminal up to 1 year jail / THB 1M, civil damages up to 2x. PDPC has started issuing fines (HSF Kramer timeline exists, not read in full).

## Kids and games
- [V] March 6, 2026: Ministry of Interior's Legislation Consideration Committee ruled in-game loot boxes are NOT gambling under the Gambling Act 1935, if items are digital, non-cash, non-redeemable and only usable in the game. Source: Tilleke. Ruling says nothing about age limits.
- [V] A Draft Game Industry Promotion Act (2025) proposes operator registration, an age-rating system and anti-gambling oversight and measures on minors' gaming. Not confirmed as enacted; treat as pending.
- [K] No law found that bans under-13s from games or sets game-time limits for Thailand. (Not exhaustively searched.)
- Practical: loot boxes are fine only if nothing can be cashed out or sold for real money. A coin shop where coins can be traded for cash would change this.

## Selling
- [V] Foreign e-service VAT (in force 1 Sept 2021): non-resident providers of electronic services (games and apps included) selling to Thai non-VAT-registered customers must register once Thai income exceeds THB 1.8M/yr, charge 7%, file monthly (Form P.P.30.9) via the Revenue Dept's VES system. Sources: Bangkok Post, Mondaq, Avalara.
- [V] Below THB 1.8M/yr of Thai sales: no registration needed (per the threshold above). If using Stripe, check Stripe Tax; a Merchant of Record (Paddle, Lemon Squeezy, app stores) handles this for you.
- [K] Consumer Protection Act B.E. 2522 covers advertising and contracts. The 7-day cooling-off found in sources is only for direct sales / direct marketing (Direct Sale and Direct Marketing Act 2002) [V], not a general rule for in-game digital items. Whether it applies to digital coins is unconfirmed.
- [K] Online sellers should show business name, contact details and price clearly. Home-address display rule not confirmed.

## AI, content and platforms
- [V] Royal Decree on Digital Platform Service Business Requiring Notification (published 22 Dec 2022, 240-day grace period) covers platforms that connect merchants/consumers/users; it excludes platforms offering only the operator's own goods. Foreign platforms must appoint a coordinator in Thailand. A pure game with its own coins is likely outside the "intermediary" definition, but a lobby chat could be argued; unconfirmed. Source: Tilleke.
- [V] Per one secondary source, extra duties apply above THB 1.8M revenue (individuals) / THB 50M (companies) or 5,000+ monthly Thai users. (conflicts slightly with Tilleke which listed no numbers; treat as [K]-ish.)
- [V] Computer Crime Act: MDES notification of 17 July 2026 (effective 18 July 2026) gives expedited court takedown for content in "urgent necessity" (national security, monarchy, religion, good morals, public order). Lobby chat is user content, so you need a way to remove reported posts quickly. Source: Tilleke.
- [K] Under the Computer Crime Act a service provider can be liable if it knowingly allows illegal content; removing on notice is the safe harbour. Lese-majeste (section 112) content in chat is a real risk for Thai-facing chat: moderate it.
- [V] Draft AI Act: ETDA released a new draft 2 July 2026, public hearing about 30 days. Risk-based like the EU AI Act, extraterritorial for AI affecting people in Thailand, local representative for foreign providers, machine-readable marks on AI-generated content, fines THB 1-5M, 180-day delay for risk-control rules after publication. NOT law yet.
- Your AI coach: likely low/minimal risk, but if it is directed at kids, expect transparency (say it is AI) to matter once passed.

## Accessibility and other
- [K] No real accessibility enforcement for small apps in Thailand.

## What a small foreign dev realistically must do
- Treat Thai players like EU/UK ones for privacy: privacy policy in plain language (Thai version is smart), explicit consent for non-essential data, a way to delete/export data, 72h breach plan.
- Under-10s: get parental consent or block under 10. 10-19: safest is parent consent for payments and chat.
- Coins: never allow cash-out or real-money trading; this keeps loot boxes outside gambling law (per the March 2026 ruling).
- Sales: stay under THB 1.8M/yr Thai revenue, or use a Merchant of Record / register for e-service VAT at 7%.
- Chat: report button, quick removal, block hate/royalty-insult content; label the AI coach as AI.

## Upcoming
- [V] Draft AI Act: public hearing from 2 July 2026 (~30 days); still a draft. If published, core measures take effect at once; risk-control rules 180 days after publication. No fixed date.
- [V] PDPA amendment bill: public consultation 16 July - 15 Aug 2026 (changes lawful bases, government exemptions). Per the snippet, children's consent unchanged. No in-force date.
- [V] Draft Game Industry Promotion Act: enactment was expected end of 2025; no confirmation it passed. Check status before launch.
- [V] Computer Crime Act takedown notification took effect 18 July 2026 (already in force).

## Unverified
- Regulator sites (pdpc.or.th, rd.go.th, etda.or.th) not read; 403 or not fetched.
- Exact children's consent rules for ages 10-19; local-representative exceptions; small-business RoPA exemption; fine amounts.
- Whether the 7-day cooling-off or other consumer rules apply to in-game digital items.
- Whether the Digital Platform Decree catches a game's lobby chat; the 5,000-user / THB 1.8M figures (sources disagree).
- Draft Game Industry Promotion Act current status.
- Stripe-specific Thai VAT handling.

## Sources
- https://www.tilleke.com/insights/thailand-confirms-in-game-loot-boxes-do-not-constitute-gambling/
- https://www.tilleke.com/insights/thailand-advances-draft-act-to-promote-online-gaming-industry
- https://www.tilleke.com/insights/thailand-releases-new-draft-artificial-intelligence-act/
- https://www.tilleke.com/insights/thailand-issues-royal-decree-on-digital-platforms/
- https://www.tilleke.com/insights/thailand-set-to-finalize-draft-royal-decree-on-digital-platforms/
- https://www.tilleke.com/insights/thailand-introduces-expedited-takedown-rules-for-online-content/
- https://www.tilleke.com/insights/thailands-draft-personal-data-protection-act-final-consideration-stage/ (2019 draft)
- https://www.bangkokpost.com/business/2067423/foreign-e-service-firms-liable-for-vat
- https://mondaq.com/sales-taxes-vat-gst/1270482/value-added-tax-to-be-imposed-on-overseas-providers-of-e-services-and-overseas-digital-platform-operators
- https://www.avalara.com/us/en/vatlive/country-guides/asia/thailand/thailand-e-services.html
- https://www.hsfkramer.com/notes/data/2025-posts/pdpa-fines-and-firsts-a-6-year-timeline-of-thailands-data-privacy-enforcement
- https://clym.io/regulations/pdpa-thailand
