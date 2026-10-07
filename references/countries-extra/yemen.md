# Yemen (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a free app for ordinary users. Med-High if anything could involve the Houthis (Ansarallah) or their companies/banks: they are a US Foreign Terrorist Organization.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tracker, [K] memory.

## Sanctions (as of 2026-10-07): targeted, not a country embargo
- [V-sec] OFAC Yemen program (E.O. 13611, 31 CFR Part 552) is list-based: OFAC's rule text says it does "not generally prohibit trade" with Yemen; only blocked persons/property are off-limits (Federal Register 2020; OFAC program page).
- [V-reg] Ansarallah (the Houthis): SDGT since 16 Feb 2024, re-designated FTO 4 Mar 2025; OFAC updated the SDN entry (OFAC FAQ 1219). Further Houthi-network designations followed, e.g. 16 Jan 2026 (4 people, 5 entities, 1 vessel) [V-sec, worktraining.com summary].
- [V-reg] Telecom licence: GL 23A now only covers telecom transactions **within** Yemen involving Ansarallah; it "eliminates" the earlier authorisation for telecom to or from Yemen (FAQ 1219). Other GLs: food/medicine (22A), personal remittances (24A), ports/airports (26A), diplomatic missions (28A). Petroleum GL 25A expired 4 Apr 2025.
- [V-sec] OFAC designated Yemen Telecommunication Asset Company (Y-TAC, Sanaa) in Jul 2024 for supporting Houthi procurement.
- [V-sec] UN 2140 regime (2014, plus 2216): asset freeze/travel ban on listed people; arms embargo on the Houthis.
- [K] FTO status means "material support" to Ansarallah is a US crime with reach beyond US persons in some cases. Several Sanaa-based banks have been designated (e.g. Yemen Kuwait Bank, Jan 2025; International Bank of Yemen, 2025).
- **Practical effect for a small foreign app:** ordinary users anywhere in Yemen can sign up for a free app; no general geo-block is required. Do not accept payments routed through designated Yemeni banks or from Houthi-run bodies, and don't provide services to Ansarallah, its officials or companies (ban them if identified). There is no OFAC GL that authorises serving Ansarallah itself with internet services from abroad. Check the SDN list before any business deal.

## Privacy
- [V-sec] No comprehensive personal-data-protection law, no cybercrime law, and no data-protection authority as of 2026 (UNGOVR tracker). A UN-ESCWA consultancy on drafting a law, and government talk of a cybercrime framework, are reported (UN job listing, Yemen Monitor). Treat as "none in force".
- [V-sec] Law No. 13 of 2012 (Right of Access to Information) touches some data-subject rights; weak source.
- [K] No cookie, breach, localisation or children's-consent rule.

## Kids and games
- [K] No game/loot-box law. Age of majority under the Civil Code is commonly given as 15 [unconfirmed]; use 18 / parental consent as a safe default.

## Selling
- [K] No VAT/GST on foreign digital services to Yemeni consumers. Card payments from Yemen rarely work; PayPal/Stripe don't onboard Yemeni sellers. Check the issuing bank isn't designated.

## AI, content and platforms
- [V-sec] Internet is split: YemenNet (state-owned, controlled by the Houthis in Sanaa) serves most users and has blocked news sites, Signal, Zoom and Google Meet (Sep 2023); Aden Net serves government areas; Starlink entry welcomed by the Aden government (Article 19, Carnegie 2025). Your site may be blocked in Houthi areas.
- [K] No AI law.

## What a small foreign dev should consider
- Free app for ordinary users: generally fine.
- Never knowingly serve, partner with, or take money from Ansarallah, its officials, companies or banks. Screen any paying business customer against the SDN and UN 2140 lists.
- Expect payments and connectivity problems; keep pages light.
- Minimise data: no local law, but users face real surveillance risk.

## Upcoming
- [K] UN 2140 sanctions are renewed yearly around November; check for changes. Watch OFAC Ansarallah GLs (they get amended).

## Unverified
- Exact list of designated Yemeni banks today; whether a Yemeni data-protection or cybercrime law has been drafted/passed in 2026; current Starlink status; age of majority.

## Sources
- https://ofac.treasury.gov/faqs/1219
- https://ofac.treasury.gov/sanctions-programs-and-country-information/yemen-related-sanctions
- https://www.federalregister.gov/documents/2020/10/29/2020-23960/yemen-sanctions-regulations
- https://sanctionsnews.bakermckenzie.com/us-redesignates-ansarallah-as-a-foreign-terrorist-organization
- https://home.treasury.gov/news/press-releases/jy2515
- https://worktraining.com/knowledge/ofac-designates-individuals-entities-and-vessel-linked-to-houthi-support-networks-under-terrorism-sanctions
- https://law.ungovr.org/ai/ye ; https://www.yemenmonitor.com/?p=167166
- https://www.article19.org/resources/yemen-human-rights-groups-condemn-internet-blocking-and-censorship/
- https://carnegieendowment.org/sada/2025/01/starlink-in-yemen-security-threat-or-an-opportunity
