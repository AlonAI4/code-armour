# Afghanistan (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a free app (no data-protection law, no country embargo). Med for paid apps or anything touching Taliban-run institutions or listed people (sanctions screening).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tracker, [K] memory.

## Sanctions (as of 2026-10-07): targeted, not a country embargo
- [V-reg] OFAC FAQ 951: "there are no comprehensive sanctions on Afghanistan". The Taliban are an SDGT (E.O. 13224); the Haqqani Network is SDGT + FTO. Dealings with them, or with entities they own 50%+, are banned for US persons.
- [V-reg] OFAC FAQ 949: the Taliban/Haqqani sanctions do not stop US persons exporting goods or services to Afghanistan if no sanctioned person or blocked property is involved.
- [V-reg] General Licences 14-20 (2021-22). GL 20 (25 Feb 2022) authorises transactions involving Afghanistan or its governing institutions (ministries etc.), with limits: no debits to blocked Taliban/Haqqani accounts, no luxury goods or services to them or to blocked leaders. GL 15 covers software updates among other exports. No later OFAC Afghanistan action shown on the program page (latest: 25 Feb 2022).
- [V-reg] No Afghanistan GL specifically for internet/communication services was found; none is needed for ordinary users because there is no country embargo.
- [V-sec] UN 1988 regime: asset freeze, travel ban and arms embargo on about 135 listed Taliban individuals and 5 entities. Monitoring-team mandate renewed by Resolution 2816 (12 Feb 2026) (Security Council Report, Afghanistan International).
- [K] UK and EU run list-based Afghanistan/Taliban regimes mirroring the UN list. No broad embargo.
- **Practical effect for a small foreign app:** ordinary Afghans can sign up for a free or paid app. Don't do business with Taliban-run ministries or listed people without checking GL 20's limits; screen names against the OFAC SDN and UN 1988 lists if money or contracts are involved. [K] Payments are the real barrier: Afghan banks are largely cut off from international card networks, so expect few successful card payments; Stripe/PayPal don't onboard Afghan sellers.

## Privacy
- [V-sec] No comprehensive data-protection law and no functioning data-protection authority (UNGOVR tracker; offlist.me review Aug 2026; Human Rights Watch). No bill found.
- [V-sec] Sector rules only: Telecommunications Services Regulation Law 2010; Cyber Crime Law 2017 (folded into the Penal Code) criminalises disclosing personal information. Legal status of pre-2021 laws under the Taliban is unclear.
- [V-sec] HRW: the Taliban control government biometric databases left after 2021. Treat Afghan users' data as high-risk for them: collect little, never expose names/locations publicly.
- [K] No cookie, breach-notice, localisation or children's-consent rule known.

## Kids and games
- [V-sec] The Taliban ordered TikTok and PUBG blocked in April 2022 ("immoral", "wasting time"); plans to limit Facebook reported (Arab News, Gulf News, SATP). Games, music and images of living beings may be restricted or blocked locally.
- [K] Age of majority 18. No data-consent age.

## Selling
- [K] No VAT on digital services sold to people in Afghanistan by foreign sellers; no consumer-refund law that reaches foreign apps.
- [K] Card payments rarely work (see Sanctions). Merchant of Record platforms may block Afghanistan as high-risk.

## AI, content and platforms
- [K] No AI law. Content rules are Taliban decrees on "morality"; the state can block your site. Not enforceable against you abroad, but don't host content that endangers users (e.g. women's photos linked to real names).
- [V-sec] Internet can be cut: nationwide fibre/mobile blackout 29 Sep - 1 Oct 2025, plus a 10-day regional cut in Balkh (Afghanistan International, Reclaim The Net). Design for flaky connections.

## What a small foreign dev should consider
- Free or paid app for ordinary users: generally allowed; no geo-block required by US law.
- Never deal with Taliban officials/entities or listed people without a sanctions check (SDN + UN 1988 lists). Check current lists before any contract.
- Minimise data: users' safety risk is higher than legal risk.
- Expect payments to fail; don't promise Afghan users paid features you can't take money for.

## Upcoming
- [V-sec] UN 1988 monitoring-team mandate runs about one year from 12 Feb 2026 (next renewal ~Feb 2027).

## Unverified
- Whether any post-2021 Taliban decree on data or online services exists; current blocking list; current card acceptance; UK/EU list details.

## Sources
- https://ofac.treasury.gov/faqs/951
- https://ofac.treasury.gov/faqs/949
- https://ofac.treasury.gov/sanctions-programs-and-country-information/afghanistan-related-sanctions
- https://www.securitycouncilreport.org/whatsinblue/2026/02/afghanistan-vote-on-a-draft-resolution-renewing-the-mandate-of-the-monitoring-team-supporting-the-1988-sanctions-committee.php
- https://www.afintl.com/en/202602120563
- https://law.ungovr.org/ai/af ; https://www.offlist.me/what-is-afghanistan-privacy-protections
- https://www.arabnews.com/node/2067831/amp ; https://satp.org/terrorism-update/taliban-announces-plan-to-block-facebook-in-afghanistan
- https://www.afintl.com/en/202510015260 ; https://reclaimthenet.org/taliban-enforces-nationwide-internet-and-phone-blackout
