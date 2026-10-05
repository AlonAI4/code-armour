# Taiwan (researched 2026-10-05, by Claude Opus 5.5 with web search)
Severity: Low-Med for a small foreign-run app with a few users here. Higher for games with loot boxes (strict odds rules) or once sales pass NT$480,000/yr.
Note: no regulator site was read (moj.gov.tw, pdpc, mof not fetched). Marks: [V-reg] regulator/law text today, [V-sec] law firm/news today, [K] memory.

## Privacy
- [K] Personal Data Protection Act (PDPA, 2010, in force 2012). Consent or other bases for collection; notice at collection; access/correct/delete rights.
- [V-sec] PDPA amendments passed 17 Oct 2025, promulgated 11 Nov 2025: create the Personal Data Protection Commission (PDPC) as regulator, add breach reporting to the PDPC (when criteria met) on top of the existing duty to notify users, record-keeping, PDPC inspections. Effective date set by the Executive Yuan, expected 2026; not confirmed in force today. (Baker McKenzie, K&L Gates)
- [V-sec] Fines in the amendments: NT$20,000-200,000 for reporting failures; up to NT$2M for security failures. (K&L Gates)
- [K] Reach: PDPA art. 51 applies to non-government agencies processing data of Taiwan nationals outside Taiwan. Enforcement against small foreign apps is rare.
- [K] Children: PDPA has no specific age; Civil Code (majority 18, limited capacity 7-17) means parental consent for minors is the safe route.
- [K] No general data localisation; the regulator can restrict transfers in specific cases.

## Kids and games
- [V-sec] Game Software Rating Management Regulations: ratings 0+/6+/12+/15+/18+ must be shown. (secondary)
- [V-sec] Loot boxes: since 1 Jan 2023, odds for every individual item must be shown as percentages, plus a warning that it is a chance-based purchase with no guaranteed item. Compliance studies show poor compliance, but this is the law. (DiGRA papers, Xiao)
- [K] No game-time curfew law.

## Selling
- [V-sec] Foreign e-service business tax (VAT): 5%; foreign sellers of electronic services (apps, online games, digital content) to Taiwan consumers must register once annual sales exceed NT$480,000; file bimonthly or via a Taiwan agent. In force since 1 May 2017. Fine NT$3,000-30,000 for not registering. (KPMG, Lee and Li, Fonoa)
- [V-sec] Consumer Protection Act 7-day cancellation for distance sales; digital content not on a tangible medium, once delivered with consumer consent, is excluded. Online game standard contract terms let players get refunds of unused prepaid points. (Winkler Partners, secondary)
- [K] Stripe does not onboard Taiwan merchants as a standard country; foreign Stripe/Paddle accept Taiwanese cards.

## AI, content and platforms
- [V-sec] AI Basic Act: passed 23 Dec 2025, promulgated and in force 14 Jan 2026. Framework law (20 articles): principles (transparency, privacy, safety, fairness, accountability), NSTC as central authority; detailed rules (risk classification, labelling) left to agencies. No direct duties on small devs yet. (Baker McKenzie Jan 2026, Stanford FSI)
- [K] Ministry of Digital Affairs (MODA) is drafting risk framework / labelling guidance under the Act.
- [K] No general platform takedown law for small apps; fraud-prevention act (2024) targets big ad platforms.

## What a small foreign dev realistically must do
- Privacy policy + delete/export on request; a breach plan that includes telling users promptly (and the PDPC once the amendment is in force).
- Loot boxes: show exact % odds per item and the chance warning, or don't sell them to Taiwan.
- Show an age rating for games.
- Stay under NT$480,000/yr Taiwan sales or use a Merchant of Record.
- Say clearly when content or chat is AI.

## Upcoming
- [V-sec] PDPA amendments + PDPC launch: Executive Yuan to set date, expected 2026. Watch for PDPC breach-report rules (deadlines TBD).
- [K] AI Basic Act sub-rules (risk framework, labelling) from MODA/NSTC; no dates.

## Unverified
- Exact in-force date of PDPA amendments / PDPC.
- PDPA art. 51 reach; children's consent age.
- Whether the 7-day exemption covers in-app currency.
- Stripe merchant status.

## Sources
- https://www.bakermckenzie.com/en/insight/publications/alerts/2025/10/taiwan-amendment-to-personal-data-protection-act
- https://www.klgates.com/New-Developments-in-the-Taiwan-Personal-Data-Protection-Act-1-13-2026
- https://www.bakermckenzie.com/en/insight/publications/2026/01/taiwan-ai-basic-act
- https://fsi.stanford.edu/publication/taiwans-ai-basic-act-can-be-model-asia
- https://www.leeandli.com/EN/NewslettersDetail/5774.htm
- https://assets.kpmg.com/content/dam/kpmg/tw/pdf/2017/04/tw-etax-alert-issue92-eng.pdf
- https://www.fonoa.com/resources/country-tax-guides/taiwan
- https://dl.digra.org/index.php/dl/article/view/2785
- https://winklerpartners.com/can-game-companies-unilaterally-terminate-a-players-right-to-play-after-they-download-an-online-game/
