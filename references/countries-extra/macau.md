# Macau SAR (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app (EU-1995-style law, small fines, unclear reach abroad, no sales tax).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: the PDPA English text was read from the regulator's site (dspdp.gov.mo, an unofficial translation, revised Feb 2016; its certificate chain is broken, so WebFetch failed and it was read with curl). The old gpdp.gov.mo site has a certificate error; the Official Gazette (images.io.gov.mo) did not resolve.

## How Macau relates to mainland China
- [V-sec] Macau is a Special Administrative Region with its own law. Mainland China's PIPL does not replace the Macau PDPA. (Macau Business, CMS)
- [K] PIPL is not listed in Annex III of the Macau Basic Law, so it is not applied in Macau as local law.
- [V-sec] But PIPL can still reach a Macau business that serves or analyses people in mainland China, and data leaving the mainland for Macau needs PIPL's cross-border route. Since 10 Sep 2024 a Greater Bay Area standard contract (Mainland-Macao) simplifies mainland-Macau flows for organisations and residents inside the GBA. (Macau Business, Digital Policy Alert, Macau Daily Times)
- See `references/countries-apac.md` for China. If you have no mainland users, the China rules there don't apply to your Macau users.

## Privacy
- [V-reg] Personal Data Protection Act, Law 8/2005, modelled on Portugal's 1998 law / the EU 1995 Directive. Lawful bases: unambiguous consent, contract, legal duty, vital interests, public task, legitimate interests (Art. 6). (dspdp.gov.mo PDPA text)
- [V-sec] Regulator: Personal Data Protection Bureau (DSPDP/PDPB), which replaced the Office for Personal Data Protection (GPDP) on 1 Feb 2024 (Admin. Regulation 42/2023). No plans announced to replace Law 8/2005. (Chambers 2025/2026)
- [V-reg] Notify the regulator in writing within 8 days of starting automated processing, unless an exemption or simplified notification covers you (Art. 21). Fines for not notifying: MOP 10,000-100,000 for a company, MOP 2,000-20,000 for a person (Art. 32). (dspdp.gov.mo PDPA text)
- [V-reg] Privacy notice must give the controller's identity, purposes, recipients, rights (Art. 10). If you collect data over open networks (the internet), tell users their data may circulate without security and be seen by others (Art. 10(4)). (dspdp.gov.mo PDPA text)
- [V-reg] Transfer outside Macau only to places with adequate protection (Art. 19). Otherwise: notify the regulator plus unambiguous consent, or a contract need, legal claims, vital interests and similar (Art. 20). Fines for breaking these: MOP 8,000-80,000 (Art. 33). (dspdp.gov.mo PDPA text)
- [V-reg] Foreign reach: no general extraterritorial clause. Art. 3(3) covers sound/image capture when the controller is based in Macau or uses a Macau network access provider. (dspdp.gov.mo PDPA text)
- [V-reg] No children's-data rule in the PDPA (no mention of minors). (dspdp.gov.mo PDPA text)
- [K] Civil Code majority age is 18; treat under-18s as needing a parent's consent.
- [V-sec] No duty to report data breaches. (Chambers 2026)

## Kids and games
- [K] No loot-box or game-time law found. Gambling is legal only through licensed casino operators; online gambling is not licensed. Keep cash-out loot out.

## Selling
- [V-sec] No VAT, GST or general sales tax in Macau, so no tax on digital sales to Macau consumers. (TaxAtlas, Avalara list)
- [V-sec] Consumer Rights Protection Law 9/2021, in force 1 Jan 2022: distance contracts need pre-contract information and give the consumer a 7-day cooling-off period (figure from bill commentary). (IFLR, Conventus Law)

## AI, content and platforms
- [V-sec] No AI law. Legislators asked in Mar and May 2026 for one; AI is covered only by the PDPA and the Cybersecurity Law. (Legislative Assembly interpellations, al.gov.mo)
- [V-sec] Cybersecurity Law 13/2019 covers critical infrastructure operators (banks, casinos, utilities, ISPs), not small apps. (Deloitte)

## What a small foreign dev should consider
- Privacy notice with identity, purposes, recipients and rights, plus the "open networks" warning.
- Tell users their data is stored outside Macau and get consent for the transfer.
- Parent consent for under-18s.
- If you also have mainland China users, PIPL applies to them, not to your Macau users.

## Upcoming
- None dated. Reform ideas (breach notice, DPOs, impact assessments) have been floated but not legislated. (Chambers 2025)

## Unverified
- Whether a foreign app with Macau users must file an Art. 21 notification; the exact 7-day cooling-off wording in the enacted Law 9/2021 and whether it covers digital content.

## Sources
- https://www.dspdp.gov.mo/en/relevant_laws.html (PDPA English text: /file/Laws and Regulations/個人資料保護法_EN.pdf)
- https://practiceguides.chambers.com/practice-guides/data-protection-privacy-2026/macau-sar-china
- https://www.dlapiperdataprotection.com/?c=MO&t=law
- https://macaubusiness.com/local-companies-should-mull-setting-up-mainland-data-privacy-reps-legal-expert/
- https://cms.law/en/chn/publication/prc-promulgated-personal-information-protection-law
- https://digitalpolicyalert.org/event/22485-adopted-guidelines-for-the-implementation-of-standard-contracts-for-cross-border-flow-of-personal-information-in-the-guangdong-hong-kong-macao-greater-bay-area
- https://www.iflr.com/article/2a63733ixysbvclr1awj9/new-regime-for-the-protection-of-consumer-rights-and-interests-in-macau-sar
- https://conventuslaw.com/report/macau-the-new-bill-for-consumer-protection/
- https://taxatlas.io/country/macau/vat-sales-tax
- https://www.al.gov.mo/uploads/attachment/2026-05/278393f467c9debc6b3471cf952688c8.pdf
- https://www2.deloitte.com/cn/en/pages/risk/articles/macau-cybersecurity-law.html
