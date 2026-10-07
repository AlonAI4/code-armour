# Barbados (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med (GDPR-style law that reaches foreign apps, parent consent for everyone under 18, VAT from the first sale). Low in practice for a tiny app: enforcement against foreign apps not seen.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Data Protection Act 2019 (Cap. 13A), in force 31 Mar 2021, GDPR-based. Regulator: Data Protection Commissioner (DataGuidance, DLA Piper, gov.bb).
- [V-reg] Reaches foreign developers: applies to controllers/processors not established in Barbados when processing relates to offering goods or services to people in Barbados (s.3(1)(b), Bill text on barbadosparliament.com).
- [V-reg] Child = under 18. Processing a child's data is lawful only with consent given or authorised by a parent/guardian, and you must make reasonable efforts to verify it (s.2, s.8).
- [V-reg] Breach: notify the Commissioner without undue delay, where feasible within 72 hours (s.63); tell users without undue delay if high risk.
- [V-reg] Transfers abroad only to countries with an adequate level of protection, or with safeguards/exceptions (s.22-23).
- [V-reg] Registration and local representative for foreign controllers (s.50(3)) exist in the Act, but [V-sec] ss.50-52 and 55-57 (registration) were NOT brought into force in 2021, and no later proclamation was found as of Aug 2026 (DataGuidance, Offlist).
- [V-reg] Fines up to BBD 500,000 for some offences (Bill text).
- [K] No cookie-specific rule; analytics/ads cookies are personal data, so ask consent or have a clear lawful basis.

## Kids and games
- [K] No loot-box or game-time law. Note the under-18 parent-consent rule above: it is stricter than the EU's 13-16.

## Selling
- [V-sec] VAT 17.5% on digital services (apps, SaaS, streaming, e-learning, online ads) supplied by non-residents to Barbados customers, since Dec 2019 (VATCalc, PayPro Global, Kintsugi).
- [V-sec] Non-residents register from the first sale (PayPro, Kintsugi); sources disagree on whether a simplified route exists. Revenue authority: Barbados Revenue Authority (TAMIS).
- [V-sec] Consumer Protection Act Cap. 326D: "no refund / all sales final" is unlawful for defective goods; s.23 repair, replace or refund; applies equally to online sellers (Fair Trading Commission, Barbados Today, Dec 2025). No general change-of-mind right.
- Practical: Merchant of Record handles the 17.5% VAT.

## AI, content and platforms
- [V-sec] No AI law. PM Mottley has said AI and social-media regulation is coming; no bill found (CBC Barbados, Gleaner letter Apr 2026). CARICOM AI Policy Roadmap, non-binding (Jun 2026).

## What a small foreign dev should consider
- If you have users in Barbados, the Act applies to you. Write a privacy policy, honour access/erasure requests.
- Under 18 = parent consent. Easiest: block under-18s or get verified parent consent.
- 72-hour breach plan.
- Merchant of Record for paid sales; never say "no refunds" for faulty products.

## Upcoming
- [V-sec] Registration sections (50-52, 55-57) start whenever proclaimed; date unknown.
- [V-sec] Resident VAT threshold reportedly rising to BBD 350,000 on 1 Oct 2026 (Kintsugi only); probably irrelevant to non-residents.

## Unverified
- Final Act section numbers may differ slightly from the 2019 Bill text read; AI bill timing; whether BRA has a simplified non-resident registration.
- Not reached: Official Gazette, BRA site. Bill PDF read locally (WebFetch could not parse it).

## Sources
- https://barbadosparliament.com/uploads/bill_resolution/9334bcb78912cda2f298450aae95a8c9.pdf
- https://www.dataguidance.com/notes/barbados-data-protection-overview
- https://www.dlapiperdataprotection.com/?c=BB&t=law
- https://www.offlist.me/what-is-barbados-data-protection
- https://www.gov.bb/General/data-protection-commissioner
- https://www.vatcalc.com/barbados/barbados-vat-on-foreign-digital-services/
- https://payproglobal.com/saas-sales-tax/barbados/
- https://trykintsugi.com/sales-tax-guides/latam/barbados
- https://barbadostoday.bb/2025/12/12/ftc-warns-online-retailers-no-refund-policies-unlawful/
- https://www.cbc.bb/news/local-news/call-for-balanced-ai-regulation-across-caricom/
