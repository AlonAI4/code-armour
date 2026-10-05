# Serbia (researched 2026-10-05, by Claude Sonnet 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low-Med for a small foreign-run app. VAT is the real cost if you sell directly to Serbian consumers.
Note: poverenik.rs fetched but only navigation text came back, so no regulator confirmation. [V-sec] = secondary source (law firm / tax guide), [K] = memory.

## Privacy
- [V-sec] Law on Personal Data Protection (Off. Gazette 87/2018), in force 21 Aug 2019, modelled on GDPR. Reaches non-Serbian controllers that process Serbian residents' data. (Hunton)
- [V-sec] Breach: notify the Commissioner within 72h; tell affected people if high risk. (Hunton, World Law Group)
- [V-sec] Children: 15+ can consent alone to online services; under 15 needs a parent. (Chambers/Global Legal Post snippet)
- [K] Foreign controllers must appoint a local representative; fines are modest (max about RSD 2M per offence).

## Kids and games
- [K] No game-time or loot-box law found. Not searched exhaustively.

## Selling
- [V-sec] Foreign sellers of e-services to Serbian consumers (B2C): NO threshold, must register for VAT before the first sale, 20% rate, and appoint a Serbian tax proxy. If not registered, the buyer becomes the tax debtor. (Zunic Law, Transatlantic Law, Kintsugi)
- [V-sec] Monthly returns (quarterly if turnover is under RSD 50M), due within 15 days of period end.
- [K] Payment providers: Stripe does not onboard Serbian businesses; Paddle / Lemon Squeezy (merchant of record) can sell to Serbian buyers. Not verified.

## AI, content and platforms
- [V-sec] No AI law in force. A working group (with NALED) is drafting one aligned to the EU AI Act; "could be adopted by end of 2026" with an AI Agency a year later. (NALED / N1)
- [V-sec] Draft new data protection law (30 Jul 2026, consultation to 10 Sep 2026) adds AI-processing rules (high-risk / chatbot / minimal) and video surveillance. Draft only.
- [K] E-commerce law has notice-and-takedown for illegal user content.

## What a small foreign dev realistically must do
- Treat Serbian users like EU users: privacy policy, consent, deletion, 72h breach plan; under-15s need a parent.
- If you sell directly: you owe 20% VAT from sale one plus a tax proxy. Not practical for a tiny app, so use a merchant of record or app stores.
- Free app: nothing extra beyond privacy basics.

## Upcoming
- [V-sec] New data protection law (draft, Jul 2026), AI law (draft, target end 2026). No in-force dates.

## Unverified
- Local-representative duty and fine amounts; consumer cooling-off for digital content; loot boxes; payment provider availability; whether poverenik.rs / purs.gov.rs say the same (not read).

## Sources
- https://www.hunton.com/privacy-and-cybersecurity-law-blog/serbia-enacts-new-data-protection-law
- https://zuniclaw.com/en/vat-registration-in-serbia-2026
- https://www.transatlanticlaw.com/content/serbia-vat-registration-rules-2026-thresholds-fiscal-representatives-and-compliance-risks-for-foreign-companies/
- https://n1info.rs/english/news/naled-serbia-to-get-law-on-ai-this-year/
- https://iapp.org/news/a/serbia-s-draft-personal-data-protection-law-what-changes-are-on-the-table
- https://practiceguides.chambers.com/practice-guides/data-protection-privacy-2026/serbia
