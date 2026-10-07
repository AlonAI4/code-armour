# Guyana (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low today (data law signed but not commenced); would be Med once commenced (registration + local representative for foreign apps, big fines).
Marks: [V-reg] regulator/official law text, [V-sec] law firm/news/tracker, [K] memory. Read the bill text on mola.gov.gy and the GRA VAT Act PDF (Jan 2025 revision) directly.

## Privacy
- [V-sec] Data Protection Act No. 18 of 2023, assented and gazetted 16 Aug 2023 (DataGuidance). Comes into force on a day the Minister appoints by order. **No commencement order found as of 2026**; Data Protection Office not set up; E-Government Agency coordinating (law.ungovr.org, offlist.me, consentstack).
- [V-reg] GDPR-style reach (s.3, bill text): applies to controllers outside Guyana that offer goods or services to people in Guyana or monitor their behaviour there.
- [V-reg] Controllers must register with the Commissioner (s.51); a controller not established in Guyana must nominate a representative in Guyana (fine GYD 20M or 2 months' jail if not). No small-business exemption seen.
- [V-reg] Child = under 18; processing a child's data only with parent/guardian consent, with reasonable efforts to verify it (s.8).
- [V-reg] Breach: Commissioner within 72 hours where feasible; data subjects without undue delay (high risk). Transfers abroad need adequacy or appropriate safeguards (Part on transfers, s.23 ff).
- Note: section numbers are from the 2023 Bill text; the enacted Act may differ slightly.

## Kids and games
- [V-reg] Under-18 parental consent rule above (once in force). [K] No loot-box or game-time law. Gambling is licensed (Gaming Authority).

## Selling
- [V-sec] Consumer Affairs Act 2011 applies to online sales by suppliers in Guyana: 7 working days to return unused goods in original packaging for refund/exchange, up to 10% restocking fee; supplier pays return of defective goods (CCAC via DPI). Cross-border sellers not addressed.
- [V-reg] VAT 14%. "Import of services" = services supplied to a Guyanese resident by a non-resident; the VAT is payable **by the recipient** (s.9(2)(c), VAT Act Cap. 81:05). No non-resident digital-supplier registration regime in the Jan 2025 revision. Registration threshold GYD 15M (VAT Regs 8/2016).
- [V-reg] Residential internet data is zero-rated (GRA VAT Policy 26).
- [K] Stripe does not support Guyana-based businesses; selling to Guyanese from abroad works.

## AI, content and platforms
- [V-sec] National AI and Digital Strategy (2024), no AI law (DPI, parliament.gov.gy press release). CARICOM AI Policy Roadmap endorsed 18 Jun 2026.
- [K] Cybercrime Act 2018 covers illegal content and harassment.

## What a small foreign dev should consider
- Build to the Act now: under-18s need parent consent (or block them), 72-hour breach plan, privacy policy.
- Once commenced, a foreign app serving Guyanese users would on paper need to register and name a local representative: re-check before marketing to Guyana.
- No VAT registration needed as a foreign seller under current law (tax falls on the customer); a Merchant of Record still simplifies things.
- Refunds: offer at least a short return window.

## Upcoming
- [V-sec] DPA 2023 commencement order: not issued, no date.

## Unverified
- Whether any part of the DPA has been commenced in 2026; final enacted section numbers; enforcement of reverse-charge VAT on consumers.

## Sources
- https://mola.gov.gy//bills/DATA%20PROTECTION%20BILL%2020231694715430.pdf
- https://www.dataguidance.com/news/guyana-data-protection-act-gets-presidential-assent
- https://law.ungovr.org/ai/gy
- https://www.offlist.me/what-is-guyana-data-protection-act-2023
- https://www.consentstack.io/regulations/gy-dpa
- https://www.gra.gov.gy/wp-content/uploads/2025/02/VAT-Act-Regul.-Trans.-Reg.-revised-January-29-2025.pdf
- https://gra.gov.gy/vat-policy-26-vat-on-computers-mobile-phones-internet-service-revised-august-19-2022/
- https://dpi.gov.gy/ccac-reminds-suppliers-that-the-consumer-affairs-law-still-applies-to-domestic-online-sales
- https://www.parliament.gov.gy/media-centre/press-releases/guyana-advocates-parliamentary-action-on-artificial-intelligence-at-ipu-assembly
- https://www.uk-cpa.org/media/g1tpd2m1/caribbean-ai-workshop-outcome-statements.pdf
