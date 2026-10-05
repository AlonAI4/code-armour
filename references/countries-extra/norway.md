# Norway (researched 2026-10-05, by Claude Opus 5.5 with web search)
Severity: Med for a small foreign-run app with a few users here. Norway is in the EEA, so GDPR applies in full (see references/legal.md). Its regulators (Datatilsynet, Forbrukertilsynet, Forbrukerrådet) are active, especially on tracking, kids and game monetisation. EU laws (DSA, AI Act) arrive later here than in the EU.

## Privacy
- [V-sec] GDPR applies via the EEA Agreement through the Personal Data Act (personopplysningsloven, in force 20 Jul 2018). Reaches foreign developers the same way GDPR does. https://www.regjeringen.no/no/tema/statlig-forvaltning/personvern/nye-personvernregler-i-eu/id2340094/
- [V-sec] Children's digital-consent age (GDPR Art. 8) was 13; the government is raising it to 15 (bill to amend § 5). Plan for 15. Whether the change is already in force was not confirmed today. https://digitalpolicyalert.org/change/11581-bill-amending-personal-data-act-to-raise-age-limit-for-data-processing-consent
- [V-sec] Cookies: amended Electronic Communications Act (ekomloven § 3-15), in force 1 Jan 2025: GDPR-grade opt-in for all non-essential cookies, analytics included; browser settings no longer count as consent; reject must be as easy as accept. https://usercentrics.com/knowledge-hub/e-com-act-regulatory-updates-for-cookie-use-in-norway/
- [V-sec] Datatilsynet acts on tracking pixels: in 2025 it went after six websites. A children's help site got a NOK 250,000 fine; the rest got reprimands because they cooperated. https://syrenis.com/resources/norway-targets-six-websites-over-tracking-allegations/
- [K] Breach notice 72h to Datatilsynet (GDPR). Transfers outside the EEA follow GDPR rules (the EU-US Data Privacy Framework covers Norway too).

## Kids and games
- [V-sec] Social media age limit of 15 is planned: platforms must verify age (BankID-type eID discussed). The EU Commission and ESA reacted positively in an EEA consultation; bill to parliament before end of 2026. A Apr 2026 report says the government may go to 16. Not law yet. https://cms.law/en/nor/publication/norway-set-to-introduce-age-limit-for-social-media-what-you-need-to-know ; https://cyprus-mail.com/2026/04/24/norway-government-plans-social-media-ban-for-children-under-16
- [V-sec] Loot boxes: no ban. Forbrukerrådet (Consumer Council) published a big 2024 report calling loot boxes manipulative and pushing for EU rules; consumer marketing law (aggressive practices, kids) is the realistic hook. https://www.forbrukerradet.no/siste-nytt/loot-boxes-how-the-gaming-industry-manipulates-and-exploits-consumers/
- [K] Marketing Control Act § 20 bans direct calls to children to buy ("buy now!" aimed at kids); Forbrukertilsynet enforces this on in-game purchases.

## Selling
- [V-reg] VAT on e-commerce (VOEC): foreign sellers of remotely deliverable services (apps, games, SaaS, digital content) to Norwegian consumers must register and file quarterly. https://www.skatteetaten.no/en/business-and-organisation/vat-and-duties/vat/foreign/e-commerce-voec/
- [V-sec] Threshold: registration once sales to Norwegian consumers exceed NOK 50,000 in 12 months. Rate 25%. A Merchant of Record handles it. https://www.bdo.no/en-gb/insights/vat-on-services-expanded-scope-since-2023
- [K] 14-day right of withdrawal (angrerettloven, EU-style); lost for digital content only with the buyer's prior express consent and acknowledgement, same as the EU checkbox (only seen today in sellers' terms, not a reliable source).
- [K] E-commerce Act (ehandelsloven) requires your name, geographic address, email and order steps. Use an MoR or business address rather than your home.
- [K] Stripe, Paddle and Lemon Squeezy all support Norway.

## AI, content and platforms
- [V-sec] EU AI Act is NOT yet law in Norway. Draft KI-loven was consulted Jun-Sep 2025; the bill slipped and the government now aims for a proposal in spring 2027. Until then, follow the EU rules anyway if you also have EU users. https://cms.law/en/nor/publication/teknologinytt-hva-er-kunstig-intelligens-reguleringen-ai-act-og-naar-blir-den-norsk-lov
- [V-sec] DSA: Norwegian Digital Services Act consulted Jul-Oct 2025, aimed to apply from summer 2026, but depends on EEA incorporation. Proposed national extras: ban on targeted ads to minors and on manipulative design. Status today unconfirmed. https://digitalpolicyalert.org/event/32028-ministry-of-digitisation-and-public-administration-opened-consultation-on-digital-services-act
- [K] No registration or local representative needed for small online services (a GDPR Art. 27 EU/EEA representative may apply if you're outside the EEA).

## Accessibility and other
- [K] Norway has its own universal-design rules (likestillings- og diskrimineringsloven + regulations, enforced by Digdir/Tilsynet for universell utforming) that already cover PRIVATE websites (WCAG 2.1 AA). Enforcement mostly targets bigger businesses; low risk for a hobby project, but higher than most countries.

## What a small foreign dev realistically must do
- GDPR basics (privacy notice, delete account, security).
- Strict cookie opt-in for analytics too: no GA/pixels before consent.
- Treat users under 15 as needing parental consent if you rely on consent.
- No "buy now" pressure aimed at kids; clear prices; no paid loot boxes for kids.
- Sales over NOK 50k/yr: register for VOEC or use a Merchant of Record.

## Upcoming
- By end of 2026: bill to Storting on a social media age limit (15, maybe 16) with mandatory age checks.
- Summer 2026 target (likely missed): Norwegian DSA act, depends on EEA incorporation.
- Spring 2027: AI Act bill (KI-loven) to Storting.
- Pending: GDPR digital-consent age raised from 13 to 15.

## Unverified
- Whether the consent age of 15 is already in force; DSA in-force status in Norway; marketing act § 20 detail; universal-design scope for private sites; withdrawal-right section numbers.

## Sources
- https://www.skatteetaten.no/en/business-and-organisation/vat-and-duties/vat/foreign/e-commerce-voec/
- https://www.regjeringen.no/no/tema/statlig-forvaltning/personvern/nye-personvernregler-i-eu/id2340094/
- https://www.bdo.no/en-gb/insights/vat-on-services-expanded-scope-since-2023
- https://usercentrics.com/knowledge-hub/e-com-act-regulatory-updates-for-cookie-use-in-norway/
- https://syrenis.com/resources/norway-targets-six-websites-over-tracking-allegations/
- https://digitalpolicyalert.org/change/11581-bill-amending-personal-data-act-to-raise-age-limit-for-data-processing-consent
- https://cms.law/en/nor/publication/norway-set-to-introduce-age-limit-for-social-media-what-you-need-to-know
- https://cyprus-mail.com/2026/04/24/norway-government-plans-social-media-ban-for-children-under-16
- https://www.forbrukerradet.no/siste-nytt/loot-boxes-how-the-gaming-industry-manipulates-and-exploits-consumers/
- https://cms.law/en/nor/publication/teknologinytt-hva-er-kunstig-intelligens-reguleringen-ai-act-og-naar-blir-den-norsk-lov
- https://digitalpolicyalert.org/event/32028-ministry-of-digitisation-and-public-administration-opened-consultation-on-digital-services-act
- Blocked: regjeringen.no (403).
