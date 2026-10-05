# Countries: Americas, Africa, Middle East, Russia (as of Oct 2026)

[V] = confirmed in a source; [K] = background knowledge, re-verify. Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate.
A Merchant of Record (Paddle, Lemon Squeezy, app stores) usually handles most foreign VAT/GST below.

## Canada (Med)
- PIPEDA reaches foreign sites with a "real and substantial connection" [K]; no small-business exemption; report breaches with real risk of significant harm "as soon as feasible" + keep a breach log [K].
- Bill C-36 (tabled Jun 2026) would add fines up to 5% of global revenue, a deletion right and child protections. NOT law yet [V].
- Quebec Law 25: under 14 = parental consent; impact assessment before sending data outside Quebec; report incidents to the CAI [K].
- CASL anti-spam: express opt-in, sender ID, unsubscribe; fines up to CA$10M [K].
- Tax: GST/HST + Quebec QST only above CA$30k B2C sales in 12 months [V].
- Must do: CASL email opt-in, privacy policy, breach plan.

## Brazil (High with kids or games)
- LGPD: applies to anyone serving Brazil; simplified regime for small agents; breach 3 business days; under 12 parental consent [K].
- ECA Digital (Law 15.211/2025), in force 17 Mar 2026 [V]: anything "likely to be accessed" by under-18s: safe defaults, real age assurance (self-declaration not allowed for 18+ content), parental controls, no profiling ads to minors, LOOT BOXES BANNED for minors. Fines up to R$50M / 10%.
- Tax: foreign digital suppliers register (no threshold), collection from 1 Jan 2027 [V]. Use a MoR.
- Consumer: 7-day withdrawal right [K]. AI bill PL 2338 not law yet [V].
- Must do: real age assurance + no loot boxes for minors; LGPD privacy notice; MoR.

## Mexico (Low–Med)
- New LFPDPPP from 21 Mar 2025; regulator INAI dissolved, now a government ministry [V]. Spanish privacy notice ("aviso de privacidad") mandatory; under 18 parental consent [K].
- Tax: 16% VAT, no threshold, heavy SAT registration [V]. Use a MoR.

## Argentina (Low)
- Law 25.326 (EU adequacy) [V]; reform bill under debate [V]. Database registration with AAIP [K].
- Tax collected by card issuers, dev doesn't register [K]. Stores need a "botón de arrepentimiento" (cancel button) [K].
- Must do: privacy policy.

## Nigeria (Med)
- NDPA 2023 + GAID 2025: applies to foreign controllers targeting Nigerians; breach 72h [V]. Registration only for "major importance" controllers [K]. Under 18 parental consent + age verification [K].
- Tax: 7.5% VAT for non-residents from 2026 (₦25M threshold unconfirmed) [V].
- Must do: privacy notice, 72h breach plan, parental consent.

## South Africa (Low–Med)
- POPIA: reach over foreign devs unclear [K]; under 18 = parent/guardian consent; e-marketing opt-in [K].
- Tax: 15% VAT above R1M in 12 months [V]. ECTA: seller disclosure page + 7-day cooling-off [K].

## Kenya (Low–Med)
- Data Protection Act 2019: covers people in Kenya; possible ODPC registration; verifiable parental consent; breach 72h [V].
- Tax: 16% VAT, no threshold for non-residents [V]. Use a MoR.

## Egypt (Med on paper)
- PDPL + executive regulations (Nov 2025, ~1 year runway): controllers technically need a licence; 1–100k records fee-exempt [V]. Breach 72h [K].
- Tax: 14% VAT above EGP 500k [V].
- Must do: privacy notice; licence enforcement on tiny foreign apps unclear.

## Turkey (Med)
- KVKK: transfers abroad need adequacy or a standard contract notified to the Board within 5 business days (this technically catches Supabase hosting abroad) [V]. VERBIS registration, 72h breach, IYS registration for marketing messages [K].
- Tax: 20% VAT, no threshold [V]. Use a MoR.

## Israel (Med)
- Privacy Protection Law Amendment 13, from 14 Aug 2025: GDPR-style, reaches foreign processors; ₪10k damages without proof of harm [V].
- BIG GOTCHA: anti-spam §30A: ads by email/SMS need prior express consent; up to ₪1,000 per message, class actions common [K].
- Accessibility: IS 5568 (~WCAG AA) for sites serving Israelis; reach over foreign sites doubtful [unverified].
- No VAT on foreign digital sellers yet [V]. 14-day cancellation right [K].
- Must do: strict email opt-in, privacy policy, basic WCAG, breach plan.

## Saudi Arabia (Med)
- PDPL enforced since Sep 2024: covers Saudi residents' data abroad; foreign controllers expected to appoint a local representative and register; breach 72h; transfer risk assessment [V]. Guardian consent for minors [K].
- Tax: 15% VAT, no threshold [K]. Gambling banned; treat loot boxes as risky [K].

## UAE (Med kids / Low otherwise)
- PDPL covers foreign controllers; executive regulations possibly still not issued [V].
- Child Digital Safety Law (in force 1 Jan 2026, grace period to ~2027–28): websites, apps, ONLINE GAMES targeting UAE users need age verification, privacy by default, parental controls, content filtering [V].
- Tax: 5% VAT, no threshold [K].

## Russia (High: don't target)
- 152-FZ localisation: since 1 Jul 2025 Russian citizens' data must first be collected in Russia; a Supabase/Netlify stack can't comply [V]. Fines up to RUB 18M; sites get blocked.
- 22% VAT from 2026, no threshold [V]. Stripe/Visa/Mastercard don't process; sanctions apply [K].
- Must do: don't market or sell to Russia; optionally geo-block. Never build sanctions workarounds.

## Cross-cutting
1. Merchant of Record for paid products (no-threshold VAT: Mexico, Kenya, Turkey, Saudi, UAE, Russia, Brazil 2027).
2. Kids are the main risk outside UK/EU/US: Brazil ECA Digital (no loot boxes for minors, real age checks), UAE child safety law covers games.
3. A 72h breach plan covers most (Brazil 3 business days, Russia 24h).
4. Marketing email opt-in everywhere; strictest Israel and Canada.
5. No binding general AI law in these countries yet.

Unverified: Mexico reach/regulations, Nigeria VAT threshold, POPIA foreign reach, Turkey VERBIS, Israel IS 5568 reach, UAE PDPL regulations, Saudi/UAE VAT details, Argentina mechanics.
Sources: Baker McKenzie, DLA Piper, Lefosse, Mattos Filho, White & Case, KPMG, CMS, Al Tamimi, Pearl Cohen, Clyde & Co, Latham, Slaughter and May, VATCalc, Fonoa (see research hand-off).
