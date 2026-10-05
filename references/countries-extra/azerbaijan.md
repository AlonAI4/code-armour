# Azerbaijan (researched 2026-10-05, by Claude Sonnet 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med for a small foreign-run app: new VAT duty (23 Aug 2026), a coming under-16 social media ban, and a state-run privacy regime.
Note: taxes.gov.az and regulator sites were not read; lines are secondary or memory.

## Privacy
- [V-sec] Law on Personal Information (in force 1 Jan 2010). Consent-based; written consent; personal-data information systems must be registered with the state body (Ministry of Digital Development and Transport); cross-border transfer only if the destination gives equivalent protection, or with consent. The enforcement body is not independent. (Deloitte AZ, Caspian Legal Center, Consentstack)
- [K] Data localisation for Azerbaijani citizens' data is claimed by some firms; not confirmed. How hard the registration duty is enforced against foreign apps is unknown.

## Kids and games
- [V-sec] Law No. 431-VIIQD (passed 30 Jun 2026; presidential decree 5 Aug 2026): under-16s barred from opening social media accounts, 16-18 need guardian consent; takes effect 12 months after official publication. Aimed at social platforms; a chat feature in a game could be caught. (Intellinews, Meduza, Caspian Legal Center)
- [K] No loot-box rule found.

## Selling
- [V-sec] Mandatory VAT registration for non-resident B2C e-services from 23 Aug 2026 (law adopted 23 Feb 2026): 18% VAT, threshold about USD 10,000 / AZN 17,000 turnover per year, register on the State Tax Service portal, monthly returns. B2B uses reverse charge. Games and apps are listed as covered. (KPMG, vatcalc)
- [K] Stripe does not onboard Azerbaijani businesses; merchant of record can sell to buyers there.

## AI, content and platforms
- [V-sec] 21 Apr 2026 amendments: criminal liability for creating or spreading AI-made fake media of a real person without consent (including sexual content). No general AI law. (Caspian Legal Center)
- [V-sec] Social network platforms face new regulatory requirements (2026). (Gratanet)

## What a small foreign dev realistically must do
- Under USD 10,000/yr from Azerbaijan: no VAT duty; above it, register or use a merchant of record.
- Block or guardian-gate under-16s if your app has accounts or public chat for Azerbaijani users, ready before about mid-2027.
- Do not let users make deepfakes of real people.
- Treat state registration of "personal data systems" as a low-probability duty; note it, do not act unless you have scale there.

## Upcoming
- [V-sec] Under-16 social media ban: 12 months after publication (roughly mid-2027; exact date not confirmed).

## Unverified
- Real localisation duty; enforcement against foreign apps; consumer cooling-off; exact start of ban; payment providers.

## Sources
- https://kpmg.com/us/en/taxnewsflash/news/2026/03/azerbaijan-mandatory-vat-registration-nonresident-electronic-services.html
- https://www.vatcalc.com/azerbaijan/azerbaijan-vat-on-digital-services/
- https://www.caspianlegalcenter.az/insights/more/personal-data-azerbaijan
- https://www.deloitte.com/az/en/services/legal/perspectives/data-privacy-gdpr.html
- https://www.intellinews.com/azerbaijan-moves-to-ban-under-16s-from-social-media-450422/
- https://www.caspianlegalcenter.az/news/more/social-network-regulation-azerbaijan
- https://www.caspianlegalcenter.az/news/more/ai-use-crime
