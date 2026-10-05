# Peru (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med for a small foreign-run app with a few users here. Privacy law reaches you and VAT has NO threshold.
Note: gob.pe / elperuano.pe not fetched (snippets only). Marks: [V-reg] regulator/official text, [V-sec] law firm/news, [K] memory.

## Privacy
- [V-sec] Law 29733 (Personal Data Protection Law) + new Regulation, Supreme Decree 016-2024-JUS, published 30 Nov 2024, in force 30 Mar 2025 (Baker McKenzie, Garrigues).
- [V-sec] Reaches foreign controllers that offer goods/services to people in Peru or analyse their behaviour. They must name a representative in Peru as contact for the authority (ANPD).
- [V-sec] Breach notice: authority within 48 hours of becoming aware (big volumes, sensitive data, or real risk); affected people in the same window, in plain language.
- [V-sec] New duties: data protection officer in some cases, security measures, incident register.
- [V-sec] Children: 14-17 can consent themselves; under 14 needs parent/guardian consent.
- [K] Cross-border transfers need adequate protection or consent; database registration with the ANPD historically required (check if still needed under the new regulation).

## Kids and games
- [K] No specific game-time or loot-box law found. Gambling for money needs a licence (online betting law 31557, 2022) so never let loot-box items be cashed out.

## Selling
- [V-sec] IGV (VAT) 18% on digital services and intangibles sold by non-resident firms to Peruvian consumers (not businesses). Legislative Decree 1623; start moved from 1 Oct to 1 Dec 2024 by LD 1644 (vatcalc, Sovos, El Peruano).
- [V-sec] No minimum threshold: registration with SUNAT from the first B2C sale.
- [K] Consumer Code (Law 29571): clear prices incl. tax; Peruvian sellers must keep a virtual "Libro de Reclamaciones" (complaints book); unclear for foreign sellers.
- Practical: a Merchant of Record (Paddle, Lemon Squeezy, app stores) collects the IGV for you. Raw Stripe = you owe it from sale 1.

## AI, content and platforms
- [V-sec] Law 31814 (promotes AI) + Regulation DS 115-2025-PCM, published 9 Sep 2025, in force 22 Jan 2026. Risk-based principles (transparency, human oversight, data protection); phased deadlines; aimed mostly at the public sector and at private actors in the national digital system (EY, Garrigues, CMS).
- [K] No strict AI-label rule found for small foreign apps; still label AI output and AI chat.
- [K] No local-representative rule for platforms apart from the privacy one.

## What a small foreign dev should consider
- Spanish privacy notice; parent consent (or block) under 14; delete/export on request.
- 48-hour breach plan (shorter than GDPR's 72h).
- Use a Merchant of Record for paid sales, since there is no IGV threshold.
- If you get many Peruvian users: name a Peruvian representative (privacy).
- Label AI features; no cash-out loot boxes.

## Upcoming
- [V-sec] AI regulation obligations phase in over 2026-2028 (dates differ for public, private, small firms). Check before relying on "not covered".

## Unverified
- Whether the ANPD actually enforces the representative duty against tiny foreign apps.
- Database registration duty under the 2025 regulation; fines (old scale up to 100 UIT).
- Consumer-complaint-book duty for foreign online sellers.

## Sources
- https://insightplus.bakermckenzie.com/bm/data-technology/peru-new-regulations-of-the-personal-data-protection-law_1
- https://www.garrigues.com/es_ES/noticia/peru-publica-nuevo-reglamento-ley-proteccion-datos-personales
- https://www.ampcuscyber.com/knowledge-hub/what-is-perus-data-protection-law/
- https://vatcalc.com/?p=5409 ; https://sovos.com/regulatory-updates/vat/peru-vat-on-cross-border-sales-of-digital-services-from-december-1-2024/
- https://elperuano.pe/noticia/249510-a-partir-del-1-de-octubre-plataformas-digitales-estaran-gravadas-con-el-18-del-igv
- https://www.ey.com/es_pe/technical/tax-alert/reglamento-ley-promueve-uso-inteligencia-artificial
- https://www.gob.pe/institucion/pcm/normas-legales/7133522-115-2025-pcm
