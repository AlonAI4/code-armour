# Puerto Rico (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med (US federal law applies in full, plus local sales tax and a 10-day breach report). Same as a US state for a small app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: Puerto Rico is a US territory. Start with the US parts of `references/legal.md` (COPPA, FTC, CAN-SPAM, ADA, Section 230...), then add the local rules below. hacienda.pr.gov refused connections; lexmundi.com blocked (403).

## Privacy
- [K] US federal law applies: COPPA (Puerto Rico counts as a "State"), FTC Act, CAN-SPAM, TCPA. No comprehensive Puerto Rico privacy law (a 2022 consumer data bill, P. de la C. 1548, was not passed as far as found).
- [V-reg] Ley 39-2012 (Privacy Policy Notification Act): website/online-service operators that are resident in or do business in or from Puerto Rico and collect personal data of Puerto Rico residents must show a clear privacy policy: what data, who it's shared with, how users can review/change it, how changes are announced. False policy: fine up to USD 50,000 (DACO).
- [V-sec] Breach law Ley 111-2005: anyone holding a database with personal data of Puerto Rico residents must notify affected people and file a report with DACO within 10 days of detecting a breach, unless the data was encrypted. Fines USD 500-5,000 per violation (Perkins Coie, Constangy).
- [V-sec] Ley 38-2016: you can't make collecting personal info a condition of a card payment (via search summary).
- [K] The PR Constitution's privacy right (Art. II s.8) also applies between private parties.

## Kids and games
- [K] COPPA (under 13) is the main rule; see `legal.md`. No local loot-box or game-time law.

## Selling
- [V-sec] Sales tax IVU 11.5% (10.5% Commonwealth + 1% municipal); digital products and SaaS taxable (Kintsugi, Numeral, PayPro; vendors). Statute covers electronically transferred audio, video, games and other digital products (via search summary of Act 40-2020).
- [V-sec] Remote sellers must register in SURI and collect IVU above USD 100,000 sales or 200 transactions a year (Sales Tax Institute). Marketplaces (app stores) collect for you (Act 40-2020, Avalara).
- [K] Consumer affairs: DACO. US consumer law (FTC, negative-option rules) applies. Stripe, Paddle, Lemon Squeezy work like the US.

## AI, content and platforms
- [V-sec] Ley 116-2026 (18 Jun 2026): government agencies must tell people when they're talking to AI and offer a human. Applies only to government, not private apps (LexJuris text).
- [V-sec] Other AI bills (AI in schools, AI company register, AI institute vetoed) are pending or failed (Metro PR, Primera Hora).

## What a small foreign dev should consider
- Treat Puerto Rico as a US state: follow the US rules in `legal.md` (COPPA first).
- Clear privacy policy (Ley 39-2012 list) and a 10-day breach plan (DACO).
- Sell through app stores or a Merchant of Record so IVU is handled; above USD 100k / 200 sales you'd need to register.

## Upcoming
- [V-sec] PRITS rules for Ley 116-2026 due within 180 days (by mid-Dec 2026); government only.

## Unverified
- Whether Act 52-2022 changed the remote-seller threshold or digital-product rules.
- Whether DACO ever issued the Ley 39-2012 model policies.
- Whether Ley 111-2005 was amended after 2008.

## Sources
- https://bvirtualogp.pr.gov/ogp/Bvirtual/leyesreferencia/PDF/39-2012.pdf
- https://perkinscoie.com/insights/publication/security-breach-notification-chart-puerto-rico
- https://constangy.com/data-privacy-us-pr
- https://trykintsugi.com/sales-tax-guides/usa/puerto-rico
- https://www.numeral.com/blog/saas-sales-tax-puerto-rico
- https://www.salestaxinstitute.com/resources/post-wayfair-landscape-in-puerto-rico-for-remote-sellers
- https://www.avalara.com/us/en/blog/2020/05/marketplace-facilitators-to-collect-puerto-rico-sales-tax-for-sellers.html
- https://www.lexjuris.com/lexlex/Leyes2026/lexl2026116.htm
- https://www.metro.pr/noticias/2025/11/12/senado-aprueba-proyecto-para-crear-instituto-de-innovacion-en-inteligencia-artificial/
- https://aldia.microjuris.com/wp-content/uploads/2024/01/PC1548-Radicado.pdf
