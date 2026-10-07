# Vanuatu (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (in-force privacy law that reaches foreign apps, children's data banned without parent consent, transfers abroad need permission), Low in practice for a tiny foreign app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: Act text read on cert.gov.vu (government CERT). paclii.org blocked (Cloudflare).

## Privacy
- [V-reg] Data Protection and Privacy Act No. 13 of 2024, in force 2 Jan 2025 (commencement shown on the Act; s.32 = on publication in the Gazette).
- [V-reg] Reach (s.2): covers data "generated or collected in Vanuatu" wherever processed, and controllers not established in Vanuatu that offer goods or services (paid or free) to people in Vanuatu. No small-business exemption seen.
- [V-reg] Children (s.3, s.7): "child" = under 18. Processing a child's data is prohibited unless a parent/carer/legal representative consents, or another listed ground applies (child's legitimate interests, legal duty, public interest, counselling services). Notices to children must be in plain language.
- [V-reg] Transfers (s.15): data "generated or collected in Vanuatu must not be used elsewhere" without prior Minister authorisation, unless the destination country is on a Minister's approved list. s.17: the Deputy Commissioner may authorise transfers e.g. with the user's informed consent. Strict on paper for any app hosted abroad.
- [V-reg] Regulator: Deputy Commissioner of Data Protection and Privacy. Breach notification is left to future regulations (s.31).
- [V-reg] Offences: any breach of the Act up to VT 10,000,000 fine (s.24).
- [K] No cookie-specific rule.

## Kids and games
- [V-sec] Harmful Digital Communications Act No. 14 of 2024 targets cyberbullying. 2025 amendment (passed Oct 2025): schools must restrict smartphones/social media for under-16s on school premises; exposing an under-16 to porn up to VT 2,000,000 or 3 years; online impersonation is a crime; Magistrates' Court can order platforms to remove illegal content or fake accounts (PINA, Daily Post).
- [K] No loot-box law.

## Selling
- [V-sec] VAT 15% since 1 Jan 2018; registration threshold VUV 4 million turnover (Customs & Inland Revenue page via search; Avalara; Expanship).
- [V-sec] No rule found making foreign digital sellers register for sales to Vanuatu consumers.
- [K] Consumer Protection Act (Cap 155) covers misleading conduct and unsafe goods; no online cooling-off right found.

## AI, content and platforms
- [K] No AI law.
- [V-sec] Courts can order content removal under the Harmful Digital Communications law (above). A Digital Safety Authority bill was tabled in 2024; status unknown (parliament.gov.vu bill PDF seen in search).

## What a small foreign dev should consider
- Under-18 users: get parent consent or don't collect their data.
- Your hosting is abroad: get users' informed consent to storage outside Vanuatu in your privacy notice (s.17 route), since no country list was found.
- Remove abusive or fake-account content fast when reported.
- Merchant of Record if you sell.

## Upcoming
- [V-reg] Regulations on breaches and breach notice may come under s.31; no date.

## Unverified
- Whether the Minister has published an approved-country list for transfers.
- Whether the Deputy Commissioner office is staffed and enforcing.
- Digital Safety Authority Act status; exact in-force date of the 2025 HDC amendment.
- VAT on remote digital services.

## Sources
- https://cert.gov.vu/images/legislation/Data_Protection_and_Privacy_Act_No13_of_2024-EN.pdf
- https://parliament.gov.vu/images/Bill_for_the_Data_Protection_and_Privacy_Act_No._of_2024.pdf
- https://pina.com.fj/2025/10/28/vanuatu-parliament-passes-bill-to-protect-students-from-online-dangers/
- https://www.dailypost.vu/news/vanuatu-tightens-cyber-laws-to-battle-online-abuse/article_f2817d23-fa43-5ffc-af8d-bd84cd7b33ba.html
- https://parliament.gov.vu/images/Bill_for_the_Digital_Safety_Authority_Act_No._of_2024.pdf
- https://customsinlandrevenue.gov.vu/taxes-and-licensing/taxes/value-added-tax-vat/introduction.html
- https://www.avalara.com/vatlive/en/vat-news/vanuatu-hikes-vat-to-15.html
- https://www.expanship.com/vu/blog/vanuatu-sales-tax
