# Colombia (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med for a small foreign-run app with a few users here. The SIC is one of Latin America's most active privacy enforcers (cookie fines, orders against foreign platforms). VAT has no threshold.
Note: no regulator site was read (sic.gov.co, dian.gov.co not fetched). Marks: [V-reg] regulator/law text today, [V-sec] law firm/news today, [K] memory.

## Privacy
- [V-sec] Statutory Law 1581 of 2012 (habeas data) + Decree 1377/2013 (now in Decree 1074/2015). Prior, express, informed consent for processing, including cookies. Regulator: Superintendencia de Industria y Comercio (SIC). (ConsentStack, secondary)
- [V-sec] SIC enforces actively; reported 2025 cookie-consent fine and AI/fintech circulars. (secondary)
- [K] Reach: SIC has applied the law to foreign companies collecting data in Colombia (e.g. orders against big platforms), treating cookies/devices in Colombia as collection there. A reform bill (Sept 2025) would make this explicit and require a local representative for some foreign controllers. [V-sec] (Allende & Brea)
- [K] Must have a written personal-data policy (política de tratamiento) with specific contents; register databases in the RNBD only if assets exceed 100,000 UVT (small devs exempt).
- [K] Children: Law 1581 art. 7 bans processing minors' data except public data; Constitutional Court allows it if in the child's best interest, with the parent/guardian authorising and the child's view heard.
- [K] Breach: report to the SIC within 15 business days of detection (SIC guidance); no fixed user deadline.
- [V-sec] Cross-border: SIC lists 37+ countries with adequate protection (Aug 2026 update); otherwise consent or contract. (Asuntos Legales)

## Kids and games
- [V-sec] Bill PL 261/2024: under-14s could not hold social media accounts without parent authorisation, age verification, 10pm-6am curfew. Passed first debate only; not law. (Xataka, Enter.co)
- [K] No loot-box law; Coljuegos regulates real-money gambling only.

## Selling
- [V-sec] VAT (IVA) 19% on digital services from abroad to Colombian users. No threshold. Choose: register with DIAN (RUT, bimonthly returns) or let card issuers/payment processors withhold VAT at source. (vatcompliance, Kintsugi)
- [V-sec] Right of withdrawal (retracto): 5 business days from delivery or contract for distance sales; refund within 30 calendar days, in money, no deductions. (Portafolio, SIC concepts)
- [K] Exceptions for digital content once download/streaming starts are not clearly in the statute (Ley 1480 art. 47); safest: get explicit consent to start immediately.
- [K] Stripe does not onboard Colombian merchants as standard; foreign Stripe/MoR can take Colombian cards (withholding may apply).

## AI, content and platforms
- [V-sec] No AI law. Government AI bill (MinCiencias + MinTIC) filed in Congress, risk-based; still in process. (Asuntos Legales Aug 2026, DPL News)
- [V-sec] Constitutional Court T-323/2024: AI use principles (transparency, human oversight, child protection). SIC joined Feb 2026 multi-regulator statement on generative AI: transparency, remove harmful content, extra protection for minors. (Holland & Knight)
- [K] SIC Circular on AI and personal data (2024): privacy impact assessment before AI processing personal data.

## What a small foreign dev should consider
- Spanish privacy policy (tratamiento policy), explicit opt-in incl. non-essential cookies.
- Don't collect under-18 data without parent authorisation; avoid targeting kids.
- 5-business-day withdrawal: honour refunds or get explicit consent to immediate delivery for digital items.
- VAT has no threshold: use a Merchant of Record or accept processor withholding.
- AI: label it, allow human contact for decisions affecting users.

## Upcoming
- [V-sec] Data protection reform bill (Sept 2025; extraterritorial scope, local rep): pending, no date.
- [V-sec] PL 261/2024 under-14 social media bill: pending.
- [V-sec] AI bill: pending.

## Unverified
- SIC breach deadline (15 business days), RNBD threshold, children's rules, retracto digital exceptions.
- Status of each bill after Aug 2026.

## Sources
- https://www.consentstack.io/regulations/co-law1581
- https://allende.com/en/privacy-and-cybersecurity/new-bill-to-amend-colombias-personal-data-protection-law-introduced-in-congress-09-15-2025/
- https://www.asuntoslegales.com.co/actualidad/la-superindustria-avala-el-intercambio-de-datos-personales-con-mas-de-37-paises-2613831
- https://www.hklaw.com/es/news/intheheadlines/2026/08/la-privacidad-entra-en-la-era-de-la-ia
- https://www.asuntoslegales.com.co/actualidad/minciencias-presento-un-proyecto-de-ley-para-regular-el-uso-de-inteligencia-artificial-4190719
- https://www.xataka.com.co/legislacion-y-derechos/que-dice-proyecto-ley-que-prohibe-uso-redes-sociales-a-menores-14-anos-apoyado-ministro-tic-colombia
- https://vatcompliance.co/es/guias/iva/colombia/
- https://trykintsugi.com/sales-tax-guides/latam/colombia
- https://www.portafolio.co/tendencias/sociales/las-empresas-no-pueden-negarse-paso-a-paso-como-devolver-compras-en-colombia-638912
