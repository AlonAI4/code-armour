# Costa Rica (researched 2026-10-05, by Claude Sonnet 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med for a small foreign-run app with a few users here (digital IVA with no threshold; under-14 social-media bill moving).
Note: only search snippets read; prodhab.go.cr and hacienda.go.cr were not opened. [V-sec] = law-firm/news text, [K] = memory.

## Privacy
- [V-sec] Law 8968 (2011) on protection against processing of personal data; regulator PRODHAB. Applies to public and private entities handling data in Costa Rica; covers data of residents (clym, consentstack; secondary).
- [V-sec] Databases must be registered with PRODHAB; transfers abroad need safeguards or consent. Registration compliance has been very low historically (vlex/La Nacion: none formally registered by the deadline).
- [K] Consent must be informed, express and in writing or equivalent. Breach notice within 5 working days per the regulation [K, not confirmed]. Minors: parental consent expected; age not confirmed.
- [K] Practical risk for a tiny foreign app is low: PRODHAB mostly targets locally established firms.

## Kids and games
- [V-sec] Bill to ban social-media accounts for under-14s (only certified child versions with parental control): positive committee opinion, advanced to the plenary in Apr 2026. A teletica article says it covers voice chat in video games. Another deputy proposed an age floor of 15 (Delfino, Sep 2026). Not law yet.
- [K] No loot-box law found.

## Selling
- [V-sec] IVA on digital services from non-resident providers since Oct 2020 (Law 9635). 13% IVA. Foreign supplier can use Hacienda's simplified registration; if not, the buyer (or the card issuer) collects it. No registration threshold (siemprealdia, PayPro). B2B: buyer self-assesses.
- [K] Consumer Protection Law 7472 applies; 8-day withdrawal for distance contracts [K, not confirmed for digital goods]. Stripe is available for Costa Rican businesses [K].

## AI, content and platforms
- [V-sec] Bill 23.919 "Ley para la Promoción Responsable de la IA" (drafted with ChatGPT-4): committee opinion Mar 2025; creates an AI authority (ARIA) with registration duties; not law (crhoy, OECD.AI). Industry (Camtic) and Micitt asked for changes.

## What a small foreign dev realistically must do
- Privacy policy in Spanish, consent for data you collect, deletion path.
- Selling: charge 13% IVA via a Merchant of Record/app store, or use Hacienda's simplified registration.
- Kids under 14: if the bill passes, chat and accounts for them need certified, parent-controlled versions; plan an age gate.

## Upcoming
- [V-sec] Under-14 social-media bill: in plenary stage since Apr 2026; 15-year proposal from Sep 2026.
- [V-sec] AI bill 23.919 pending in the Assembly.

## Unverified
- PRODHAB's real enforcement vs foreign sites; exact foreign reach, breach deadline, child age.
- Whether the simplified IVA registration is still the live mechanism in 2026.
- Withdrawal right for digital goods.

## Sources
- https://www.clym.io/regulations/law-no-8968-costa-rica
- https://vlex.co.cr/vid/datos-personales-queda-papel-523510834
- https://siemprealdia.co/costa-rica/impuestos/iva-en-servicios-digitales-transfronterizos-costa-rica/
- https://dplnews.com/costa-rica-modelo-de-cobro-del-iva-a-servicios-digitales-transfronterizos-inquieta-a-sectores/
- https://crhoy.com/nacionales/avanza-proyecto-para-prohibir-uso-de-redes-sociales-a-menores-de-14-anos/
- https://www.teletica.com/multimedia/proyecto-de-ley-para-prohibir-redes-sociales-en-menores-incluye-chats-de-voz-en-videojuego_1250902
- https://delfino.cr/2026/09/diputado-del-pln-propone-fijar-en-15-anos-la-edad-minima-para-tener-cuentas-en-redes-sociales
- https://crhoy.com/tecnologia/dictaminan-proyecto-de-ley-sobre-inteligencia-artificial/
