# Ghana (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app with a few users here on privacy. VAT is the real issue: non-residents selling digital services must register with no threshold.
Note: no regulator site was read (dataprotection.org.gh, gra.gov.gh not fetched). Marks: [V-reg] regulator/law text today, [V-sec] law firm/news today, [K] memory.

## Privacy
- [V-sec] Data Protection Act, 2012 (Act 843), in force 16 Oct 2012; regulator: Data Protection Commission (DPC). Eight data protection principles; criminal penalties. (ConsentStack, BFT)
- [V-sec] Every data controller must register with the DPC before processing, renew every 2 years. Foreign controllers are caught if established in Ghana or using equipment/processors in Ghana. (secondary)
- [K] Children: under-18 data needs parent/guardian consent (Act 843 s.37, special personal data).
- [K] Breach: notify DPC and the data subject "as soon as reasonably practicable" (s.31).
- [K] No strict localisation; cross-border processing follows the principles.
- [V-sec] Data Protection Bill 2025 (repeals Act 843): new Authority, admin fines, portability and erasure rights. Consultation closed 31 Oct 2025; government said Mar 2026 it's still being prepared for Parliament. Not law. (BFT, Digital Policy Alert)

## Kids and games
- [K] Cybersecurity Act 2020 (Act 1038) criminalises child sexual abuse material, grooming, sextortion; applies to content on your platform.
- [V-sec] Cybersecurity (Amendment) Bill 2025: new cyberbullying/online harassment offences (s.67A), CSA powers incl. AI standards and online protection for vulnerable groups. Consultation 1 Oct-14 Nov 2025; not law. (Techpoint, Ghana Fact)
- [K] No loot-box or game-age law.

## Selling
- [V-sec] VAT Act 2025 (Act 1151), in force 1 Jan 2026: non-residents supplying digital services (gaming, streaming, apps, cloud, ads, marketplaces) for use in Ghana must register via the GRA non-resident portal, NO threshold; 15% VAT + 5% NHIL/GETFund = 20%; monthly returns. COVID levy abolished. (Deloitte Ghana, TaxLawGH, Kintsugi)
- [V-sec] Electronic Transactions Act 2008: consumer may cancel without reason within 7 days of contract for services (14 days after receipt for goods); excludes services started with consent before day 7. Seller must show identity, address and full price. (BFT Apr 2026)
- [V-sec] Stripe serves Ghana via Paystack (Stripe-owned); Ghanaian mobile money/cards usually go through Paystack/Flutterwave. (secondary)

## AI, content and platforms
- [K] No AI law; National AI Strategy in progress. CSA amendment would let it set AI security standards (pending).
- [K] Electronic Communications / Cybersecurity Act: false-news and harassment offences can affect user-content platforms; keep a report-and-remove path.

## What a small foreign dev should consider
- Simple privacy policy; parent consent for under-18s if you knowingly collect their data.
- VAT: 20% with no threshold. Use a Merchant of Record (Paddle, Lemon Squeezy, app stores) rather than registering yourself.
- 7-day cancel: show it, or get explicit consent to start the digital service immediately.
- Show your name, contact address (MoR covers this) and full price.
- Moderate chat for CSAM and harassment.

## Upcoming
- [V-sec] Data Protection Bill 2025 (replaces Act 843): awaiting Parliament; no date.
- [V-sec] Cybersecurity (Amendment) Bill 2025: post-consultation; no date.

## Unverified
- Whether DPC registration practically applies to foreign apps with no Ghana presence; s.37/s.31 wording.
- National AI Strategy status.

## Sources
- https://www.consentstack.io/regulations/gh-act843
- https://thebftonline.com/2025/11/21/understanding-the-data-protection-bill-2025-key-highlights-for-businesses-and-individuals/
- https://digitalpolicyalert.org/event/34534-ministry-of-communication-digital-technology-and-innovations-closes-consultation-on-data-protection-act-2025-including-data-protection-regulation
- https://www.deloitte.com/gh/en/services/tax/perspectives/updated-VAT-registration-requirement-for-nonresident-suppliers-of-digital-services.html
- https://www.taxlawgh.com/ghana-digital-services-ecommerce-vat
- https://trykintsugi.com/sales-tax-guides/africa/ghana
- https://thebftonline.com/2026/04/21/clicks-carts-and-consumer-rights-how-ghanas-2008-digital-law-shields-online-shoppers/
- https://techpoint.africa/insight/ghana-cybersecurity-act-amendment/
- https://ghanafact.com/draft-2025-cybersecurity-amendment-bill-csas-new-functions-police-powers-cyber-hygiene-other-major-amendments/
