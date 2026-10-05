# Myanmar (researched 2026-10-05, by Claude Sonnet 5.5 with web search)
Severity: High for paid sales (payments, sanctions, military-run regime). Low legal risk for a free app, but users may be at real risk if you store their data.
Note: only search snippets read; no official site opened. [V-sec] = law firm/news text, [K] = memory. sanctioned-places.md has no Myanmar section; it is not comprehensively sanctioned like Iran or Cuba.

## Privacy and surveillance
- [V-sec] No general data protection law. Cybersecurity Law enacted 1 Jan 2025, in force 30 Jul 2025 (Notification 113/2025) (Allen & Gledhill).
- [V-sec] Digital platforms with 100,000+ users in Myanmar must be a Myanmar-registered company and get a licence/registration (valid 3-10 years). Missing it: fine at least MMK 100M. Platforms must keep user data (incl. personal data and usage records) for 3 years and hand it to authorities on written request. VPN services need permission (fines MMK 1-10M for individuals, min MMK 10M for companies).
- [V-sec] Platforms must act on "false news" and content that "disrupts unity". Under this military-run regime the practical danger is to your users if you hold their data.

## Kids and games
- [K] No game-specific or child-privacy rule found. Online gambling is illegal [K].

## Selling and sanctions
- [V-sec] US OFAC Burma programme (EO 14014) is list-based: Min Aung Hlaing, MEHL, MEC and, since Oct 2023, MOGE are designated. Not a country-wide embargo (Norton Rose, HSF Kramer). EU/UK also use targeted lists [K].
- [V-sec] Stripe does not support Myanmar-based businesses. Google Play allows paid apps and in-app purchases for Myanmar users (XDA, 2018); Apple status not found.
- [K] Local payments (KBZPay, Wave, MPU cards) do not integrate with Western providers; foreign cards often fail. Do not sell to listed persons or military-owned firms; your payment provider may block the country.
- [K] No digital-VAT regime for foreign sellers found; Commercial Tax on e-services not confirmed.

## AI, content and platforms
- [K] No AI law. See Cybersecurity Law above for content duties.

## What a small foreign dev realistically must do
- Free app: serve Myanmar users but collect almost nothing; no real names, phone numbers or location unless needed.
- Paid: use app stores or a Merchant of Record, not your own Stripe flow; screen out sanctioned names and military-linked buyers.
- Under 100k Myanmar users, the licence/local-company rule does not apply.

## Upcoming
- [V-sec] Sanctions lists change often; re-check OFAC before launch.

## Unverified
- Whether the 100k-user rule is actually enforced on foreign apps, and how.
- Apple App Store and PayPal availability.
- Any Myanmar sales tax on cross-border digital services.
- Current EU/UK measures.

## Sources
- https://www.allenandgledhill.com/sg/publication/articles/31053/cybersecurity-law-in-force-30-july-2025
- https://www.allenandgledhill.com/sg/publication/articles/30195/s-new-cybersecurity-law-establishes-framework-and-processes-for-use-of-digital-resources
- https://www.nortonrosefulbright.com/en/knowledge/publications/d37e9f70/ofac-amends-burma-myanmar-sanctions
- https://www.hsfkramer.com/notes/sanctions/2023-11/ofac-imposes-sanctions-restrictions-on-myanmars-state-owned-oil-and-gas-company
- https://www.xda-developers.com/google-play-store-paid-apps-georgia-myanmar
- https://support.stripe.com/questions/stripe-feature-availability-by-country
