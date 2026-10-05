# Chile (researched 2026-10-05, by Claude Opus 5.5 with web search)
Severity: Low today, Med from 1 Dec 2026 (or 2027 if postponed) when Law 21.719 and its Agency start. The new law reaches foreign apps that offer services to people in Chile, free or paid.
Note: bcn.cl (LeyChile) did not load (JS timeout); the Diario Oficial PDF of Law 21.719 was read directly. Marks: [V-reg] law text today, [V-sec] law firm/news today, [K] memory.

## Privacy
- [K] Today: Law 19.628 (1999), weak and barely enforced.
- [V-reg] Law 21.719 (published Diario Oficial 13 Dec 2024) rewrites it and creates the Agencia de Protección de Datos Personales. [V-sec] In force 1 Dec 2026. (Diario Constitucional, Garrigues)
- [V-reg] Reach (art. 1 bis c): applies to controllers not established in Chile whose processing is aimed at offering goods or services to people in Chile, whether or not payment is required, or at monitoring their behaviour.
- [V-reg] Foreign controller without a Chilean address must keep a working email or other contact channel for users and the Agency (art. 14).
- [V-reg] Children (art. 16 quater): under 14 = "niños": need consent of parents/legal guardian. 14-17 = adolescents: can consent like adults, except sensitive data of under-16s needs parental consent. Always in the child's best interest.
- [V-reg] Breach (art. 14 sexies): report to the Agency by the fastest means and without undue delay when there's reasonable risk to rights; also tell the users themselves if the breach involves sensitive data, data of children under 14, or financial data. Keep a breach log.
- [V-reg] Privacy by design and default duty (art. 14 quater).
- [V-reg] Fines: minor up to 5,000 UTM, serious up to 10,000 UTM, very serious up to 20,000 UTM (art. 35); small companies (Ley 20.416) get lighter treatment. [V-sec] Repeat offences up to 4% of revenue.
- [K] GDPR-style lawful bases, rights (access, rectify, delete, object, portability), cross-border transfers need adequacy or safeguards.

## Kids and games
- [K] No game age-rating or loot-box law. Online gambling law passed/in progress; SII now taxes foreign betting platforms ([V-sec] Res. 69/2026).
- Kid data: see art. 16 quater above; under-14 users need verified parent consent.

## Selling
- [V-sec] VAT (IVA) 19% on digital services by foreign providers to Chilean consumers (since June 2020); register in SII's simplified regime and file remotely. Covers digital content, software, platforms. (SII, Garrigues)
- [K] No registration threshold for foreign digital suppliers.
- [K] Consumer law 19.496 (+ Ley Pro Consumidor 2021): 10-day right of withdrawal for remote purchases unless clearly excluded before purchase; show seller identity and total price.
- [K] Stripe does not onboard Chilean merchants as standard; payments from Chile work via foreign Stripe/MoR.

## AI, content and platforms
- [V-sec] AI bill (Boletines 15869/16821): risk-based (unacceptable, high, limited, no evident risk), passed the Chamber of Deputies 13 Oct 2025, now in the Senate. Not law. (CMS, Diario Constitucional Feb 2026)
- [K] Expected duties: transparency when people interact with AI; labelling of synthetic content for limited-risk systems.

## What a small foreign dev realistically must do
- Before 1 Dec 2026: privacy policy in Spanish, a contact email for users and the Agency, deletion/export flow.
- Under-14 users: get parent consent or block them; no sensitive data from under-16s without parents.
- Breach plan: tell the Agency fast; tell users directly if kids/sensitive/payment data is hit.
- Use a Merchant of Record or register for 19% IVA (no threshold).
- Label AI chat as AI now; easy and likely required later.

## Upcoming
- [V-sec] 1 Dec 2026: Law 21.719 + Agency in force. BUT a government bill in the Senate would move this to 1 Dec 2027 (also widens written warnings to all controllers). Until passed, 1 Dec 2026 stands. Check before launch.
- [V-sec] AI bill in Senate; no date.

## Unverified
- Whether the postponement bill passes; Agency regulations (reglamentos) not yet seen.
- Consumer withdrawal rules for digital goods; no-threshold IVA; Stripe status.
- 4% repeat-offence cap (secondary only).

## Sources
- https://www.diariooficial.interior.gob.cl/publicaciones/2024/12/13/44023/01/2583630.pdf (Law 21.719 text)
- https://www.diarioconstitucional.cl/2026/06/12/la-ley-21-719-entra-en-vigor-el-1-de-diciembre-y-expone-vacios-en-regulacion-de-pequenas-empresas/
- https://www.garrigues.com/es_ES/noticia/chile-ejecutivo-presenta-proyecto-postergar-entrada-vigor-nueva-ley-proteccion-datos
- https://www.diarioconstitucional.cl/estudios-juridicos/alerta-legal-proyecto-posterga-entrada-en-vigencia-de-ley-de-proteccion-de-datos-personales-por-carla-illanes/
- https://cms.law/en/int/expert-guides/ai-regulation-scanner/chile
- https://www.diarioconstitucional.cl/2026/02/23/proyecto-de-ley-que-regula-integralmente-la-inteligencia-artificial-en-chile-prosigue-su-tramitacion-en-el-senado
- https://www.garrigues.com/es_ES/noticia/chile-servicio-impuestos-internos-sii-imparte-instrucciones-respecto-aplicacion-iva
- https://www.diarioconstitucional.cl/estudios-juridicos/sii-habilita-sistema-para-declaracion-y-pago-de-iva-por-plataformas-extranjeras-de-apuestas-y-juegos-de-azar-en-linea/
