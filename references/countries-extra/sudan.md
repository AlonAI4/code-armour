# Sudan (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a free app (no privacy law; no broad embargo). Med for paid features: war-damaged banking, no PayPal, extra US export controls since 2025-26, and many SDN-listed groups.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] No data protection law and no data protection authority. Related: Electronic Transactions Act 2007, Cybercrime Act 2007 (amended 2020), Information Technology Crime law; Constitution protects privacy of correspondence (dataprotection.africa, May 2022). No 2024-26 law or bill found in search.
- [K] No cookie, breach or transfer rules.

## Kids and games
- [K] Child Act 2010: child = under 18. No online-age or loot-box rules. Gambling is banned (Sharia-based criminal law): no betting or cash-out.

## Selling
- [V-sec] VAT 17% (VAT Act 2001); no rule for foreign digital sellers found (tax aggregators only, not reliable).
- [V-sec] Banking was largely cut off by the war since Apr 2023; national switch restored and SWIFT service bureau certified in 2026, but international transfers still face heavy friction (Sudan Tribune via search, PYMNTS).
- [V-sec] PayPal does NOT list Sudan as a PayPal country (paypal.com). Not on Stripe's prohibited-jurisdiction list (stripe.com). [K] Card payments from Sudan will mostly fail or be flagged.

## Sanctions (as of 2026-10-07)
- [V-reg] US: the broad Sudan embargo ended 12 Oct 2017 (Sudanese Sanctions Regulations removed 2018); State Sponsor of Terrorism listing rescinded 14 Dec 2020. Today: **targeted** sanctions under EO 14098 (2023 war) and EO 13400 (Darfur), 31 CFR 546 "Sudan Stabilization Sanctions Regulations". Listed include RSF leader Hemedti (Jan 2025), SAF leader al-Burhan (Jan 2025), RSF-controlled Alkhaleej Bank, and more (designations up to 26 Jun 2026). General licences 1-3 cover international orgs, NGOs, and agriculture/medicine/"software updates" (OFAC page).
- [V-sec] US Chemical and Biological Weapons Act: 2025 round (export limits, no US credit/aid) and a second round imposed 23 Jun 2026 (Public Notice 13072, 20 Jul 2026, at least one year): bans exports of almost all goods and technology to Sudan/Sudanese nationals, BUT items not on the Commerce Control List are waived, and CCL items under licence exceptions incl. ENC (encryption) and TSU (e.g. publicly available software) are partly waived (Baker McKenzie, The EastAfrican). Ordinary web apps/games are generally not affected; specialised controlled tech is.
- [V-sec] UN: Darfur (1591) arms embargo + targeted travel bans/asset freezes; Res. 2828 (11 Sep 2026) was only a one-month technical rollover **to 9 Oct 2026** (Panel to 9 Nov 2026) amid a US push to extend the embargo to all of Sudan (Sudan Tribune, Macau Business). Check whether it was renewed.
- [V-sec] EU: list-based regime (Reg. 2023/2147) in force to 10 Oct 2026, renewal due; listings added May 2026 (Council press release 2025; Malta/ONPCSB). [K] UK has a similar list-based regime.
- Effect for a small app: no broad embargo, so users in Sudan can sign up for a free app, and paid sales aren't banned as such. No special OFAC general licence is needed for free communication services (unlike Iran/Cuba). But: never deal with SDN-listed people/companies (RSF, SAF companies, Alkhaleej Bank), payments rarely work, and providers may flag Sudan transactions. See `sanctioned-places.md` and check current lists.

## AI, content and platforms
- [K] No AI law. Cybercrime law is used against online speech; moderate content.

## What a small foreign dev should consider
- Free app: fine; no local privacy law.
- Paid: expect failed payments and provider reviews; screen against the SDN list if real money or business deals are involved.
- Don't ship controlled tech (e.g. specialised encryption hardware/software beyond mass-market) to Sudan.

## Upcoming
- [V-sec] UN 1591 measures expire 9 Oct 2026 unless renewed; Panel of Experts 9 Nov 2026.
- [V-sec] EU Sudan regime expires 10 Oct 2026 unless renewed.
- [V-sec] US CBW second-round sanctions: in place at least until about Jun-Jul 2027.

## Unverified
- Whether the UN and EU Sudan regimes were renewed in Oct 2026; Apr/Jun 2026 OFAC designations (from aggregators, though listed on the OFAC page); exact scope of CBW export ban for SaaS (web access is usually not an "export" of software [K]); foreign digital VAT.

## Sources
- https://ofac.treasury.gov/sanctions-programs-and-country-information/sudan-and-darfur-sanctions
- https://home.treasury.gov/news/press-releases/jy2789 (not fetched)
- https://sanctionsnews.bakermckenzie.com/additional-sanctions-on-sudan-under-the-chemical-and-biological-weapons-control-and-warfare-elimination-act/
- https://www.theeastafrican.co.ke/tea/news/north-africa/us-imposes-more-sanctions-on-sudan-for-use-of-chemical-weapons-5054358
- https://public-inspection.federalregister.gov/2025-11896.pdf (not fetched)
- https://sudantribune.com/?p=318628 (blocked 403; search snippet)
- https://macaubusiness.com/un-security-council-approves-technical-rollover-of-sudan-sanctions/
- https://press.un.org/en/2025/sc16165.doc.htm
- https://www.consilium.europa.eu/en/press/press-releases/2025/09/22/sudan-eu-extends-sanctions-regime-by-one-year/
- https://dataprotection.africa/sudan/
- https://pymnts.com/?p=787786
- https://www.paypal.com/us/webapps/mpp/country-worldwide ; https://stripe.com/legal/restricted-businesses
