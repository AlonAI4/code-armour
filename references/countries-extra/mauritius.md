# Mauritius (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med for paid apps (VAT from the first sale since 1 Jan 2026), Low for free apps (the privacy law's foreign reach is narrow).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-reg] Data Protection Act 2017 (Act 20/2017), in force 15 Jan 2018. GDPR-style. Regulator: Data Protection Office (Data Protection Commissioner).
- [V-reg] Foreign reach (s.3(5)): applies to controllers established in Mauritius, or not established there but "using equipment in Mauritius" for processing (transit doesn't count). Narrower than GDPR: a foreign app hosted outside Mauritius is arguably outside it. The DPO has not said what "equipment" means (Law Over Borders guide, [V-sec]).
- [V-reg] Registration (s.14): no one may act as a controller or processor unless registered with the Commissioner. Personal/household use is exempt (s.3(4)).
- [V-sec] Registration lasts 3 years; fee Rs 1,000-2,500 by headcount (Data Protection (Fees) Regulations 2020). Failing to register: fine up to Rs 200,000 and up to 5 years' prison (DLA Piper Africa).
- [V-reg] Children (s.30): parent/guardian consent needed for a child under 16; controller must make "every reasonable effort" to verify it, using available technology.
- [V-reg] Breach (s.25): tell the Commissioner without undue delay and, where feasible, within 72 hours; tell users without undue delay if high risk.
- [V-reg] Transfers abroad (s.36): allowed with proof of safeguards given to the Commissioner, explicit informed consent, contract necessity and other listed grounds. No localisation.
- [V-reg] Offences are criminal: general penalty up to Rs 200,000 fine and up to 5 years' prison. No GDPR-size admin fines.
- [K] Cookies: no separate cookie law; consent rules of the DPA apply to tracking that collects personal data.

## Kids and games
- [K] Children's Act 2020: a child is under 18. No loot-box or game-time law found.
- [K] Gambling (incl. online betting) needs a Gambling Regulatory Authority licence. No cash-out items or real-money prizes.

## Selling
- [V-reg] VAT on digital/electronic services from foreign suppliers: new s.14A VAT Act, from 1 Jan 2026, 15%. Register with the MRA "irrespective of the amount of turnover" (no threshold). Tax representative with a Mauritian permanent establishment only if supplies exceed Rs 3M a year (MRA).
- [V-sec] Covered: apps, software, games, streaming, web hosting, online ads, e-books, and more (Forvis Mazars). No registration needed if you sell only to Mauritian VAT-registered businesses (EY).
- [V-sec] Customer counts as in Mauritius on two non-conflicting signals: billing address, Mauritian bank/card, IP/geolocation (Rosemont, Andersen).
- [K] No specific online cooling-off/refund rule found in searches (general consumer protection law applies). Be clear on refunds.
- Practical: a Merchant of Record (Paddle, Lemon Squeezy) collects this VAT for you; selling directly via Stripe means registering with the MRA from sale 1.

## AI, content and platforms
- [V-sec] No AI law. National AI Strategy + non-binding "FAIR" guidelines adopted by Cabinet 13 Feb 2026, launched 9 Apr 2026; an AI Unit in the IT ministry is preparing regulation (TechCabal, Comsure, OECD.AI).
- [K] ICT Act s.46 makes some harmful online messages an offence; moderate user content.

## What a small foreign dev should consider
- Paid app with Mauritian buyers: use a Merchant of Record, or register for VAT with the MRA (no threshold).
- Parent consent (or block) for under-16s.
- 72-hour breach plan.
- Registration with the DPO is mandatory for local controllers; for a foreign app hosted abroad it is unclear. If you target Mauritius or use servers there, register.

## Upcoming
- [V-sec] AI Unit drafting AI regulation (no date).

## Unverified
- Whether the Act copy read (FSC site) includes all later amendments; how the DPO reads "equipment in Mauritius"; consumer cooling-off rules for online sales; exact VAT return frequency.

## Sources
- https://www.fscmauritius.org/media/ikoldflp/the-data-protection-act-2017.pdf (Act text)
- https://www.mra.mu/eservices1/vat-eservices/vat-on-digital-or-electronic-services-from-foreign-suppliers
- https://www.forvismazars.com/mu/en/services/tax/tax-insights/suppliers-of-digital-electronic-services
- https://www.ey.com/content/dam/ey-unified-site/ey-com/en-mu/documents/ey-mauritius-budget-2026-27-fiscal-analysis.pdf
- https://rosemont-int.com/article/news/mauritius-extends-vat-to-foreign-digital-services-from-2026
- https://mu.andersen.com/wp-content/uploads/2025/11/Finance-Act-Updates-on-Digital-or-Electronic-Services.pdf
- https://www.dlapiperafrica.com/en/mauritius/insights/2020/new-data-protection-regulations-.html
- https://www.globallegalpost.com/lawoverborders/data-protection-law-guide-1072382791/mauritius-1530183321
- https://techcabal.com/2026/04/23/mauritius-new-ai-strategy-sets-a-new-bar-ethics-before-execution/
- https://www.comsuregroup.com/news/mauritius-launches-national-ai-strategy-and-fair-rules-ethics-first-law-later/
