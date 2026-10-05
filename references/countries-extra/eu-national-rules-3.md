# EU national rules 3: Estonia, Latvia, Lithuania, Slovakia, Slovenia, Croatia, Bulgaria, Cyprus, Malta, Luxembourg (researched 2026-10-05, by Claude Sonnet 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
What each country ADDS on top of EU-wide law. GDPR, ePrivacy cookie consent, DSA, AI Act, EU VAT/OSS, the 14-day withdrawal right, the EAA, CRA and PLD are in references/legal.md; other countries are in eu-national-rules.md and eu-national-rules-2.md. Not repeated here. VAT: all ten use EU OSS, so no national VAT threshold to track; a Merchant of Record removes the problem.

Severity for a small foreign-run app with a few users: Malta Med (only if you offer real-money or gambling-like features), Croatia/Luxembourg/Lithuania Low-Med (DPA fines exist, but not aimed at tiny foreign apps), the rest Low.

Digital-consent ages (GDPR Art. 8): 13 = EE, LV, MT; 14 = BG, CY, LT; 15 = SI; 16 = HR, LU, SK. Sources are mixed: SI 15 [V-sec] https://www.uradni-list.si/novice/pogled/zvop-2-je-zacel-veljati-26--januarja-2023---kaksne-pomembne-novosti-prinasa ; MT 13 [V-sec] https://whitecase.com/publications/article/gdpr-guide-national-implementation-malta ; the rest [K] plus one search summary (which wrongly said MT 16, so recheck). Safe rule: treat under-16s as needing a parent.

## Estonia
- Privacy: [K] Consent age 13. Regulator: Data Protection Inspectorate (AKI). [V-sec] The cookie-consent rule is not clearly written into national law but AKI enforces it in practice. https://www.consentstack.io/regulations/jurisdiction/estonia
- Kids: [V-sec] The government publicly opposes broad social media bans for young people; no ban planned. https://news.err.ee/1609874640/estonia-does-not-want-to-ban-young-people-from-social-media-following-eu-proposal
- [K] Estonia is highly digital (e-ID, e-Residency); fines on tiny foreign apps are rare. Gambling is licensed (Tax and Customs Board); no loot-box rule known.

## Latvia
- Privacy: [K] Consent age 13. Regulator: Data State Inspectorate (DVI).
- Language: [V-sec] The Consumer Protection Law requires written consumer information in Latvian; the final version also allows official EU languages. Offer Latvian terms if you target Latvia. https://www.roedl.de/en-gb/de/media/publications/newsletters/newsletter-latvia/Documents/newsletter-latvia-7-2020.pdf
- Kids: [V-sec] Coalition partners back a proposal to restrict children's access to social networks and harmful content (focus on under-12s); no law yet. https://www.baltictimes.com/coalition_partners_back_proposal_to_restrict_children_s_access_to_social_media/
- [K] Gambling is licensed by the Lotteries and Gambling Supervisory Inspection; strict on online casinos, no loot-box rule known.

## Lithuania
- Privacy: [K] Consent age 14. [V-sec] The State Data Protection Inspectorate (VDAI) ran cookie checks (2023 focus) through audits and complaints. https://www.consentstack.io/regulations/lt-loec
- Kids: [V-sec] A bill banning under-16s from social media without parental consent, with reliable (not self-declared) age verification, passed an early vote 9 Apr 2026 (65-0). Proposed fines EUR 500-1,500, repeat EUR 1,500-4,000. Final adoption not confirmed. https://www.baltictimes.com/lithuania_mp_proposes_ban_on_under-16s_using_social_media
- AI/deepfakes: [V-sec] No deepfake-specific crime found; law enforcement acts only under existing offences. https://ojs.mruni.eu/ojs/vsvt/article/view/8467
- [K] Gambling is state-licensed; online operators need a Gaming Control Authority licence.

## Slovakia
- Privacy: [K] Consent age 16. Regulator: Office for Personal Data Protection (ÚOOÚ); no recent small-app fines found.
- AI/deepfakes: [V-sec] No deepfake crime yet; cases are handled as defamation, and calls for legislation grew after a 2026 journalist case. https://rsf.org/en/investigation-slovak-journalist-monika-tódová-s-deepfake-reopened-rsf-calling-type-attack-be
- [K] Consumer info is expected in Slovak (Consumer Protection Act); the Slovak Trade Inspection (SOI) enforces. Gambling: licence required, no loot-box rule known.

## Slovenia
- Privacy: [V-sec] Consent age 15 (ZVOP-2, in force 26 Jan 2023). The Information Commissioner said (24 Jul 2025) that under-15s cannot validly consent to online prize-draw data use without a parent. https://digitalpolicyalert.org/change/15573-information-commissioners-opinion-on-validity-of-child-consent-for-personal-data-processing-in-prize-draws-under-zvop-2-no-07121-12025922
- Kids: [V-sec] Government (Feb 2026) preparing a law banning social networks with user-generated content (TikTok, Snapchat) for under-15s; no in-force date. https://euperspectives.eu/2026/02/slovenia-to-join-the-crowd-as-it-prepares-legislation-to-ban-social-media-for-under-15s/
- [K] Consumer info is expected in Slovenian. No loot-box rule known.

## Croatia
- Privacy: [K] Consent age 16. [V-sec] AZOP fined about EUR 7M in total in 2025 (EUR 4.5M telecom, EUR 1.5M bank over a mobile app); targets are large firms, but a bank's app was fined, so apps are not exempt. https://cms.law/en/hrv/legal-updates/expensive-lessons-in-data-protection-inside-croatia-s-2025-gdpr-enforcement-actions
- [K] Consumer Protection Act expects Croatian-language info; the State Inspectorate checks webshops. No social media ban found (only support for an EU under-13 limit). Gambling is licensed by the Ministry of Finance.

## Bulgaria
- Privacy: [K] Consent age 14. Regulator: CPDP, which fines mostly local firms (older data: tens of thousands of BGN).
- [K] Consumer info must be in Bulgarian (Consumer Protection Act); the Commission for Consumer Protection (KZP) enforces. Gambling is licensed by the National Revenue Agency; no loot-box rule known. No social media or AI-specific law found.

## Cyprus
- Privacy: [K] Consent age 14. Regulator: Commissioner for Personal Data Protection; no recent small-app fines found.
- Kids: [V-sec] President announced a social media age limit of 15, due to take effect later in 2026, with age verification and platform sanctions. Law status unconfirmed. https://www.cbn.com.cy/tag/2475/social-media
- [K] Online gambling is licensed by the National Betting Authority; no loot-box rule known.

## Malta
- Privacy: [V-sec] Consent age 13 (S.L. 586.11). Regulator: IDPC. https://whitecase.com/publications/article/gdpr-guide-national-implementation-malta
- Gambling hub: [V-sec] The Gaming Act (Cap. 583, 2018) and the Malta Gaming Authority (MGA) regulate gaming. A B2C "Gaming Service Licence" is needed to offer games of chance to players (valid 10 years; applicant must be EU/EEA-established). Gambling-like in-game features (loot boxes, casino-style mini-games) can be treated as games of chance under the Act; a plain free game with no prizes is not touched. https://www.bdo.com.mt/en-gb/news/news-in-2026/mga-licensing-explained-what-gaming-operators-need-to-know-in-2026 ; https://www.legal500.com/guides/chapter/malta-gambling-law/
- [K] Many gambling companies are based in Malta, so "Malta licence" in a user's story is not the same as a licence for your own users: you also need each target country's rules.
- Kids: [V-sec] PM Abela announced social media age rules (Australia-style), starting with under-13s and maybe more later; no law found. https://www.italpress.com/?p=593299
- [K] Business info: Maltese companies show registered name and number (Companies Act).

## Luxembourg
- Privacy: [K] Consent age 16. [V-sec] CNPD issued 6 fines in 2025, EUR 1,277 to EUR 175,000, mainly over data minimisation/retention, plus focus on records of processing and video surveillance. The Administrative Court of Appeal annulled the EUR 746M Amazon fine on 13 Mar 2026 and sent it back. https://cms.law/en/int/publication/GDPR-Enforcement-Tracker-Report/luxembourg
- [K] Languages: Luxembourgish, French, German are all accepted for consumer info; English is common. ILR regulates e-communications. No loot-box rule or social media ban found.

## What a small foreign dev should consider
- Ask for birth year and apply the consent age; simplest is to treat under-16s as needing a parent (SI 15, LT/BG/CY 14).
- Malta/anywhere: do not add real-money prizes, cash-out or gambling-like random rewards without a gambling licence; MGA only matters if you do.
- Latvia/Slovakia/Slovenia/Croatia/Bulgaria: give terms in the local language if you actively market there.
- Real opt-in cookie banner; AKI (EE), VDAI (LT) and CNPD (LU) all look at records and cookies.
- AI face or voice features: get the consent of the person shown (no national deepfake crimes here yet, but existing defamation and privacy law applies).

## Upcoming
- Later 2026 (unconfirmed): Cyprus social media age limit 15.
- Undated: Lithuania under-16 social media law (early vote 9 Apr 2026, final unknown); Slovenia under-15 ban; Malta under-13 rules; Latvia restriction proposal.

## Unverified
- All [K] lines, incl. consent ages for EE, LV, LT, SK, HR, BG, CY, LU (one search summary disagreed on MT and SI; MT 13 and SI 15 confirmed by specific sources only).
- Whether any of the social media bans passed; Croatia, Bulgaria, Slovakia, Estonia and Cyprus fine practice; national-language rules for HR, SK, SI, BG, LT, EE; any national AI laws; Malta loot-box guidance (no MGA text found).

## Sources
- https://www.uradni-list.si/novice/pogled/zvop-2-je-zacel-veljati-26--januarja-2023---kaksne-pomembne-novosti-prinasa
- https://digitalpolicyalert.org/change/15573-information-commissioners-opinion-on-validity-of-child-consent-for-personal-data-processing-in-prize-draws-under-zvop-2-no-07121-12025922
- https://whitecase.com/publications/article/gdpr-guide-national-implementation-malta
- https://www.bdo.com.mt/en-gb/news/news-in-2026/mga-licensing-explained-what-gaming-operators-need-to-know-in-2026
- https://www.legal500.com/guides/chapter/malta-gambling-law/
- https://www.italpress.com/?p=593299
- https://www.cbn.com.cy/tag/2475/social-media
- https://euperspectives.eu/2026/02/slovenia-to-join-the-crowd-as-it-prepares-legislation-to-ban-social-media-for-under-15s/
- https://www.baltictimes.com/lithuania_mp_proposes_ban_on_under-16s_using_social_media
- https://www.baltictimes.com/coalition_partners_back_proposal_to_restrict_children_s_access_to_social_media/
- https://news.err.ee/1609874640/estonia-does-not-want-to-ban-young-people-from-social-media-following-eu-proposal
- https://www.consentstack.io/regulations/jurisdiction/estonia
- https://www.consentstack.io/regulations/lt-loec
- https://www.roedl.de/en-gb/de/media/publications/newsletters/newsletter-latvia/Documents/newsletter-latvia-7-2020.pdf
- https://cms.law/en/hrv/legal-updates/expensive-lessons-in-data-protection-inside-croatia-s-2025-gdpr-enforcement-actions
- https://cms.law/en/int/publication/GDPR-Enforcement-Tracker-Report/luxembourg
- https://ojs.mruni.eu/ojs/vsvt/article/view/8467
- https://rsf.org/en/investigation-slovak-journalist-monika-tódová-s-deepfake-reopened-rsf-calling-type-attack-be
- No regulator site was fetched; all [V-sec] lines rely on search snippets. The twobirds consent-age page (fetched) listed no per-country ages.
