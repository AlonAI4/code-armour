# EU national rules: Germany, France, Italy, Spain, Netherlands, Poland (researched 2026-10-05, by Claude Opus 5.5 with web search)
What each country ADDS on top of EU-wide law. GDPR, ePrivacy cookie consent, DSA, AI Act, EU VAT/OSS, the 14-day withdrawal right and the EAA are in references/legal.md and are not repeated here. VAT: all six use EU OSS; a non-EU seller owes VAT from the first sale and an EU seller after EUR 10k cross-border, so there are no national VAT thresholds for a foreign digital seller to track. A Merchant of Record removes that problem.

Severity for a small foreign-run app with a few users: Germany High (private warning letters), France Med (CNIL fines small sites), Spain Med (AEPD fines often), Italy Med (Garante active on AI), Netherlands Low-Med, Poland Low-Med.

## Germany
- Privacy: [K] GDPR digital-consent age 16 (no lowering). [K] Cookies: TDDDG § 25 (formerly TTDSG) needs consent for any non-essential access to the device, stricter in practice than elsewhere; Google Fonts / CDNs without consent already in legal.md.
- Warning letters: [K] Germany's real risk is the Abmahnung: competitors and associations send paid cease-and-desist letters for missing Impressum, wrong withdrawal info, cookie problems or a missing cancel button. Each letter costs hundreds to thousands of euros. Only relevant if you are "commercial" (selling, ads).
- Subscriptions: [V-sec] § 312k BGB (since 1 Jul 2022): any online subscription for consumers needs a visible "cancel contract" button leading to a simple cancel page; the BGH says it also applies to fixed-term plans that end automatically. Missing it = Abmahnung, and the customer can cancel anytime. https://www.haendlerbund.de/de/news/aktuelles/wissenssnack/kuendigungsbutton ; https://www.noerr.com/de/insights/kuendigungsbutton-im-onlinevertrieb-neue-rechtsprechung-des-bgh
- Kids and games: [V-sec] USK has counted loot boxes, in-game purchases and chat as "use risks" in age ratings since 1 Jan 2023, so a game with paid loot boxes gets a higher age rating. https://www.gamesmarket.global/use-risks-anchored-usk-advisory-board-expands-guidelines-for-the-classification-of-digital-games-01eb83c94bd433932ba8c7faffefec3a/
- [V-sec] JMStV reform (passed by the state parliaments): operating systems (Apple, Google, Microsoft) must offer a one-button child/youth mode; apps should carry age labels the OS can read. Content "harmful to minors" (porn, extreme violence) already needs KJM-approved age verification. https://www.neowin.net/news/germany-gets-closer-to-mandating-age-assurance-at-os-level/
- Accessibility: [V-sec] BFSG (German EAA law, from 28 Jun 2025): micro-enterprise SERVICE providers (<10 staff and <=EUR 2M) are exempt, but competitors can send Abmahnungen to non-exempt shops and fines go up to EUR 100k; warning-letter waves were already reported. https://www.taylorwessing.com/de/insights-and-events/insights/2025/09/warum-das-bfsg-jetzt-noch-mehr-im-fokus-stehen-sollte
- AI: [K] No extra national AI law; the Federal Network Agency (BNetzA) is the planned AI Act supervisor.

## France
- Privacy: [V-reg] Digital-consent age 15 (Art. 45 Loi Informatique et Libertés): under 15, a parent AND the child must both consent, for consent-based processing (not for contract-based). https://cnil.fr/recommandation-4-rechercher-le-consentement-dun-parent-pour-les-mineurs-de-moins-de-15-ans
- [V-reg] CNIL enforcement 2025: 83 sanctions, EUR 486.8M total; 67 under the fast "simplified procedure", aimed at small organisations. Cookies (21 entities: no consent, refusal not easy, withdrawal ignored) were the top theme, then security (weak passwords) and ignored erasure/access requests. https://www.cnil.fr/en/sanctions-and-corrective-measures-cnils-actions-2025
- [V-sec] Example: a small mail-order company got EUR 3,000 under the simplified procedure (Jun 2025). https://www.jdsupra.com/legalnews/overview-of-the-cnil-s-deliberations-in-3513835/
- Kids: [V-sec] Social media ban for under-15s, final vote 21 Jul 2026: applies to NEW accounts from 1 Sep 2026, existing under-15 accounts must be closed by 1 Jan 2027. The final text dropped the mandatory age-verification clause. Applies to "social networks"; a game with chat or a community feature could be argued to be one. https://ppc.land/france-bans-under-15s-from-social-media-but-cuts-age-verification-clause/ ; https://www.pbs.org/newshour/world/french-lawmakers-approve-ban-on-social-media-for-kids-under-15
- [K] SREN law (May 2024): Arcom can block/delist porn sites without robust age verification (Arcom technical standard). Only relevant for adult content.
- Language: [V-sec] Toubon law: French is mandatory when you offer, present or describe goods/services commercially in France, and in instructions, warranties and invoices. Not for private non-commercial sites. Selling to French consumers = French product description, terms and receipts. https://en.wikipedia.org/wiki/Loi_Toubon ; https://www.culture.gouv.fr/thematiques/langue-francaise-et-langues-de-france/agir-pour-les-langues/garantir-l-emploi-du-francais
- [K] Influencer law (Jun 2023): paid promotion must be labelled "publicité"/"collaboration commerciale"; minors' influencer income protected.
- Accessibility: [V-sec] EAA penalties up to EUR 50k per breach, inspections from 2025-26; micro-enterprises still exempt. https://www.degaullefleurance.com/en/actualites/digital-accessibility-new-obligations-for-the-private-sector/

## Italy
- Privacy: [V-sec] Digital-consent age 14 (Art. 2-quinquies Privacy Code). https://childreninthedigitalworld.twobirds.com/home/italy
- AI: [V-sec] Law 132/2025, first national AI law in the EU, in force 10 Oct 2025: children under 14 need parental consent to use AI systems / for related data processing; 14-17 can consent alone if the info is clear and easy. It also creates a crime for spreading harmful deepfakes (1-5 years). An AI app open to Italian kids needs an age check and parental consent under 14. https://www.linklaters.com/insights/blogs/digilinks/2025/september/italy--a-pioneering-national-framework-to-complement-the-eu-ai-act ; https://www.squirepattonboggs.com/en/insights/publications/2025/10/italian-law-no-132-2025-the-first-domestic-law-in-the-european-union-on-the-use-of-artificial-intelligence
- [K] The Garante (DPA) is the most aggressive EU regulator on AI chatbots: it temporarily blocked ChatGPT (2023), fined OpenAI EUR 15M (Dec 2024) and Replika's maker EUR 5M (2025), largely over missing age checks and transparency.
- Kids: [V-sec] AGCOM Resolution 96/25/CONS: age verification for adult-content sites ("double anonymity"), binding from 12 Nov 2025. Only relevant for adult content. https://www.diritto.it/linee-guida-agcom-age-verification-parental-control/
- [K] AGCOM also has influencer rules (2024 guidelines; large influencers registered).

## Spain
- Privacy: [V-sec] Digital-consent age currently 14 (LOPDGDD Art. 7). [K] The AEPD issues the most GDPR fines in the EU, often small ones (thousands of euros) against small businesses, incl. for cookies and for missing data-protection info on forms.
- Kids and games: [V-sec] Organic Law on Protecting Minors in Digital Environments: government bill (Mar 2025), cleared first debate in Congress Sep 2025, still in parliament. It would raise the consent and social media age to 16, BAN loot boxes for under-18s, and require parental controls on devices. Not law today. https://www.mjusticia.gob.es/en/institucional/gabinete-comunicacion/noticias-ministerio/100925-tramitacion-lo-proteccion-menores-entornos ; https://www.osborneclarke.com/insights/spain-seeks-protect-minors-digital-environment-key-points-new-version-draft-law
- [V-sec] Separate Consumer Ministry draft loot-box law proposes banning minors from loot boxes. https://www.dsca.gob.es/es/comunicacion/notas-prensa/ministerio-consumo-prohibe-acceso-menores-cajas-botin-videojuegos-evitar
- AI: [K] AESIA is the Spanish AI Act authority; a 2025 draft law would fine failure to label AI content (implementing AI Act Art. 50).

## Netherlands
- Privacy: [V-sec] Digital-consent age 16 (UAVG Art. 5). https://edlaw.eduverse.com/docs/jurisdiction/nat/nl/uavg
- Kids and games: [V-sec] Loot boxes are NOT automatically gambling: the Council of State overturned the KSA's penalty order on EA (FIFA packs), 9 Mar 2022. A loot box with prizes that can be sold/cashed out can still be illegal gambling. https://mediawrites.twobirds.com/post/102j3d2/fifa-22-loot-boxes-no-longer-regarded-as-gambling-in-the-netherlands-as-ban-overt
- [V-sec] The government wants a ban, and now pushes for an EU-wide loot-box ban in the Digital Fairness Act rather than a national one. https://www.gamblingnews.com/news/dutch-minister-pushes-for-eu-wide-loot-box-ban-to-shield-consumers/
- Selling: [V-sec] ACM fines small webshops too, e.g. EUR 50k fines on two small shops (cut to EUR 5k and 10k on objection), and EUR 621k on five shops for fake discounts. Never show fake "was" prices or fake timers. https://www.telecompaper.com/news/acm-verlaagt-boetes-voor-twee-kleine-webwinkels--1184120

## Poland
- Privacy: [V-sec] Digital-consent age 16 (no lowering). UODO enforcement is rising (8,000+ complaints/yr); fines have hit firms for a breach caused by weak security (Morele.net, PLN 2.83M). https://edlaw.eduverse.com/docs/jurisdiction/nat/pl/uodo
- Platforms: [V-sec] Poland is late on the DSA: the President vetoed the first implementing law in Jan 2026; a new draft makes the UKE president the Digital Services Coordinator. https://www.gov.pl/web/cyfryzacja/silniejsza-ochrona-uzytkownikow-internetu---rzad-przyjal-dwa-projekty-ustaw-wdrazajace-dsa
- Kids: [V-sec] Government plans a social media ban for under-15s with platforms doing the age checks, aimed for early 2027. Not law. https://www.polskieradio.pl/395/7784/Artykul/3653732,poland-plans-social-media-ban-for-under15s-with-platforms-to-verify-age-minister-says
- [K] Polish Language Act: consumer-facing offers, terms and info in Poland must be in Polish (other languages allowed alongside). UOKiK (consumer authority) actively targets dark patterns and subscriptions.

## What a small foreign dev realistically must do
- Ask for the birth year and set the consent age per country: DE/NL/PL 16, FR 15, IT/ES 14 (ES likely moving to 16). Simplest: treat under-16s as needing a parent everywhere in the EU.
- Germany (if you sell): full Impressum, correct withdrawal text, cancel button for subscriptions, consent before ANY tracker.
- France (if you sell): French text for product descriptions, terms and receipts; cookie banner with an easy "reject".
- Italy: AI app open to under-14s = parental consent + age check.
- Games: avoid paid loot boxes, especially for kids (ES ban coming, NL/EU pressure, DE higher rating); never allow cash-out.

## Upcoming
- 1 Sep 2026 (already started): France under-15 social media ban for new accounts; 1 Jan 2027 existing under-15 accounts closed.
- Early 2027 (target): Poland under-15 social media ban.
- Undated: Spain minors' law (consent/social media 16, loot-box ban for under-18s); Polish DSA implementing law; German JMStV OS-level youth mode (dates by state treaty, unconfirmed).
- EU Digital Fairness Act proposal (loot boxes, dark patterns, subscriptions), pushed by NL; expected proposal date unconfirmed.

## Unverified
- German consent age 16 and TDDDG detail; Abmahnung cost levels; JMStV in-force date; Italian Garante fine amounts; Spain AEPD and AI labelling draft; Polish Language Act scope for foreign online sellers; France SREN and influencer law details; whether France's ban covers games with chat.

## Sources
- https://www.cnil.fr/en/sanctions-and-corrective-measures-cnils-actions-2025
- https://cnil.fr/recommandation-4-rechercher-le-consentement-dun-parent-pour-les-mineurs-de-moins-de-15-ans
- https://www.jdsupra.com/legalnews/overview-of-the-cnil-s-deliberations-in-3513835/
- https://ppc.land/france-bans-under-15s-from-social-media-but-cuts-age-verification-clause/
- https://www.pbs.org/newshour/world/french-lawmakers-approve-ban-on-social-media-for-kids-under-15
- https://www.culture.gouv.fr/thematiques/langue-francaise-et-langues-de-france/agir-pour-les-langues/garantir-l-emploi-du-francais
- https://www.degaullefleurance.com/en/actualites/digital-accessibility-new-obligations-for-the-private-sector/
- https://www.haendlerbund.de/de/news/aktuelles/wissenssnack/kuendigungsbutton
- https://www.noerr.com/de/insights/kuendigungsbutton-im-onlinevertrieb-neue-rechtsprechung-des-bgh
- https://www.gamesmarket.global/use-risks-anchored-usk-advisory-board-expands-guidelines-for-the-classification-of-digital-games-01eb83c94bd433932ba8c7faffefec3a/
- https://www.neowin.net/news/germany-gets-closer-to-mandating-age-assurance-at-os-level/
- https://www.taylorwessing.com/de/insights-and-events/insights/2025/09/warum-das-bfsg-jetzt-noch-mehr-im-fokus-stehen-sollte
- https://childreninthedigitalworld.twobirds.com/home/italy
- https://www.linklaters.com/insights/blogs/digilinks/2025/september/italy--a-pioneering-national-framework-to-complement-the-eu-ai-act
- https://www.squirepattonboggs.com/en/insights/publications/2025/10/italian-law-no-132-2025-the-first-domestic-law-in-the-european-union-on-the-use-of-artificial-intelligence
- https://www.diritto.it/linee-guida-agcom-age-verification-parental-control/
- https://www.mjusticia.gob.es/en/institucional/gabinete-comunicacion/noticias-ministerio/100925-tramitacion-lo-proteccion-menores-entornos
- https://www.osborneclarke.com/insights/spain-seeks-protect-minors-digital-environment-key-points-new-version-draft-law
- https://www.dsca.gob.es/es/comunicacion/notas-prensa/ministerio-consumo-prohibe-acceso-menores-cajas-botin-videojuegos-evitar
- https://edlaw.eduverse.com/docs/jurisdiction/nat/nl/uavg
- https://mediawrites.twobirds.com/post/102j3d2/fifa-22-loot-boxes-no-longer-regarded-as-gambling-in-the-netherlands-as-ban-overt
- https://www.gamblingnews.com/news/dutch-minister-pushes-for-eu-wide-loot-box-ban-to-shield-consumers/
- https://www.telecompaper.com/news/acm-verlaagt-boetes-voor-twee-kleine-webwinkels--1184120
- https://edlaw.eduverse.com/docs/jurisdiction/nat/pl/uodo
- https://www.gov.pl/web/cyfryzacja/silniejsza-ochrona-uzytkownikow-internetu---rzad-przyjal-dwa-projekty-ustaw-wdrazajace-dsa
- https://www.polskieradio.pl/395/7784/Artykul/3653732,poland-plans-social-media-ban-for-under15s-with-platforms-to-verify-age-minister-says
- Only CNIL pages were fetched directly; other regulator lines rely on search snippets.
