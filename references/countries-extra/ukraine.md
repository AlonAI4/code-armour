# Ukraine (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app with a few users here. Today's privacy law does not reach foreign companies, enforcement against small foreign apps is near zero (the country is under martial law), and the main digital tax only starts above UAH 1M/yr. The big real-world risk is SANCTIONS on Russian-occupied regions, not Ukrainian law.

## Privacy
- [V-sec] Current law: Law of Ukraine "On Personal Data Protection" No. 2297-VI (2010). It has no GDPR-style reach abroad: foreign companies processing Ukrainians' data from outside Ukraine are generally NOT covered. Fines are small. https://www.linklaters.com/en/insights/data-protected/data-protected---ukraine
- [V-sec] Draft Law No. 8153 (GDPR-style rewrite) passed first reading 20 Nov 2024 and was still awaiting second reading in mid-2026. It would add reach abroad, a local representative for non-residents, 72h-style breach notice and fines up to a % of turnover. Not law today. https://sk.ua/gdpr-size-penalties-for-personal-data-protection-violations-what-can-individuals-and-businesses-expect-in-ukraine/
- [K] Regulator today is the Parliament Commissioner for Human Rights (Ombudsman); the draft would create a new independent authority.
- [K] Children: no GDPR Art. 8-style digital-consent age. Under civil law, children 14-18 have partial capacity and can make small everyday deals; under 14 a parent acts.
- [K] No specific cookie law; consent rules of the general data law apply loosely. Following GDPR is likely to cover most of this.

## Kids and games
- [K] No national game-time limits or game-specific age-rating law found. Loot boxes are not specifically regulated; real-money gambling needs a licence (PlayCity regulator), so never allow cash-out.
- [K] Martial-law era rules ban Russian-origin content/services in some contexts (e.g. state bans on certain Russian apps); not relevant unless you use Russian services.

## Selling
- [V-sec] "Google tax" (Law 1525-IX, from 1 Jan 2022): a non-resident selling electronic services (apps, games, subscriptions, digital content) to Ukrainian consumers must register for VAT once its Ukrainian supplies exceed UAH 1 million (~EUR 20-30k) in a calendar year; 20% VAT, simplified returns, filing in English, payment in UAH/USD/EUR. 154 non-residents registered as of 2026 (Google, Apple, Valve...). https://taxnews.ey.com/news/2022-0265 ; https://ukranews.com/en/news/1138466-revenues-from-google-tax-increased-by-20-to-uah-4-2-billion-in-2-months
- [V-sec] New Law on Consumer Rights Protection No. 3153-IX: brings EU-style rules incl. a withdrawal right for digital content contracts and pre-contract information duties; entry into force tied to martial law ending (scheduled 7 Jul 2024 but deferred). An E-Consumer portal with "verified seller" badges is planned. https://insightplus.bakermckenzie.com/bm/data-technology/ukraine-aligning-consumer-protection-law-with-european-union-standards ; https://sk.ua/the-new-law-on-the-protection-of-consumer-rights/
- [V-sec] Language law (Art. 27, in force 16 Jul 2022): websites and apps of businesses registered in Ukraine, AND of foreign sellers with a subsidiary/office in Ukraine, must show a Ukrainian version by default to Ukrainian users; consumer software sold in Ukraine needs a Ukrainian UI, or English/EU-language for some categories. A solo foreign dev with no Ukrainian presence is outside the website rule; adding Ukrainian is still good practice. https://mova-ombudsman.gov.ua/en/news/since-july-16-the-ukrainian-language-version-of-the-sites-should-be-loaded-by-default ; https://sk.ua/additional-ukrainian-language-requirements-for-user-interface-of-software-and-official-websites-webpages-are-in-effect-on-16-july-2022/
- [V-sec] Stripe does not offer accounts to Ukrainian businesses (it can still take payments from Ukrainian cards for a seller elsewhere). Ukrainian devs use Paddle, Lemon Squeezy, Fondy/WayForPay or a foreign company (e.g. Stripe Atlas). https://westernbid.com/en/?p=23497
- [V-sec] SANCTIONS: the US bans supplying goods/services to Crimea and the so-called DNR/LNR regions (EO of 21 Feb 2022); the EU and UK have similar bans for occupied regions (EU also covers Zaporizhzhia/Kherson occupied parts [K]). Stripe and MoRs block these regions; free downloads and crypto are NOT screened. Don't sell or give paid services to users there. https://sanctionsnews.bakermckenzie.com/us-government-imposes-comprehensive-sanctions-on-so-called-donetsk-peoples-republic-and-luhansk-peoples-republic-and-eu-and-uk-announce-plans-to-impose-new-sanctions-related-to-same/

## AI, content and platforms
- [V-sec] No binding AI law. The Ministry of Digital Transformation's AI White Paper (Jun 2024) uses a two-stage "bottom-up" approach: voluntary codes and guidelines now, an EU-AI-Act-aligned law later. https://www.ibanet.org/Regulation-of-AI-Ukraine-current-approach
- [V-sec] Draft laws would treat big platforms (Telegram, Instagram) as regulated media with complaints mechanisms and a representative in Ukraine or the EU; aimed at large platforms, not passed as far as found. https://www.kyivpost.com/post/30136
- [K] Law on Media (2023) covers registered and some online media; a small app or game is not "media" unless it publishes news-type content.

## Accessibility and other
- [K] No real enforcement against small foreign websites.

## What a small foreign dev should consider
- Block sales/paid services to occupied regions (Crimea, DNR, LNR; check your payment provider does).
- Follow your GDPR setup; that already exceeds Ukraine's current law and the 8153 draft.
- If Ukrainian digital sales could pass UAH 1M/yr, use a Merchant of Record.
- Optional but kind: offer a Ukrainian language version; never default Ukrainian users to Russian.

## Upcoming
- Undated (pending second reading): Draft Law 8153, GDPR-style data protection with reach abroad and local representatives.
- After martial law ends: new Consumer Rights Protection Law 3153-IX comes into force (withdrawal right for digital content, seller info duties).
- 7 Jul 2026 (planned, status unconfirmed): E-Consumer portal and "verified seller" registration.
- Undated: EU-AI-Act-aligned AI law (stage two of the White Paper).

## Unverified
- Current exact status of 8153 and 3153-IX in force dates; E-Consumer portal launch; child-capacity ages; loot-box/gambling detail; EU sanctions scope for Zaporizhzhia/Kherson; regulator identity.

## Sources
- https://www.linklaters.com/en/insights/data-protected/data-protected---ukraine
- https://sk.ua/gdpr-size-penalties-for-personal-data-protection-violations-what-can-individuals-and-businesses-expect-in-ukraine/
- https://taxnews.ey.com/news/2022-0265
- https://ukranews.com/en/news/1138466-revenues-from-google-tax-increased-by-20-to-uah-4-2-billion-in-2-months
- https://insightplus.bakermckenzie.com/bm/data-technology/ukraine-aligning-consumer-protection-law-with-european-union-standards
- https://sk.ua/the-new-law-on-the-protection-of-consumer-rights/
- https://mova-ombudsman.gov.ua/en/news/since-july-16-the-ukrainian-language-version-of-the-sites-should-be-loaded-by-default
- https://sk.ua/additional-ukrainian-language-requirements-for-user-interface-of-software-and-official-websites-webpages-are-in-effect-on-16-july-2022/
- https://westernbid.com/en/?p=23497
- https://sanctionsnews.bakermckenzie.com/us-government-imposes-comprehensive-sanctions-on-so-called-donetsk-peoples-republic-and-luhansk-peoples-republic-and-eu-and-uk-announce-plans-to-impose-new-sanctions-related-to-same/
- https://www.ibanet.org/Regulation-of-AI-Ukraine-current-approach
- https://www.kyivpost.com/post/30136
- No regulator page fetched (search snippets only); tax.gov.ua and zakon.rada.gov.ua not tried due to budget.
