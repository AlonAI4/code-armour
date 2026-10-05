# Mongolia (researched 2026-10-05, by Claude Sonnet 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app with a few users here.
Note: only search snippets were read; mta.gov.mn, legalinfo.mn and the data regulator were not opened. [V-sec] = law-firm/news/aggregator text, [K] = memory. Sources conflict on the privacy law (see Unverified).

## Privacy
- [V-sec] Law on Personal Data Protection: passed 17 Dec 2021, in force 1 May 2022 (PwC Mongolia). Explicit consent needed; data must be limited to what is necessary; transfer abroad needs the person's consent unless a law or treaty allows it (clym summary).
- [V-sec] Said to reach international companies targeting Mongolian residents (clym; secondary only).
- [V-sec] Implementing regulations incl. cybersecurity requirements entered into force 1 Jan 2026 (digitalpolicyalert). 72-hour breach notice for some data types (financial, location, biometric).
- [V-sec] One snippet says a new data law was approved 26 Jun 2025 effective 1 Jan 2026; I could not reconcile it with the 2021 law (the page I opened turned out to be about Vietnam). Treat as unclear.
- [K] Child consent: sources only give a general legal-representative rule; exact age not confirmed.

## Kids and games
- [V-sec] Draft law on children's participation in social networks: presented to Cabinet 11 Mar 2026; bans accounts under 13/16 on "age-restricted" social networks, parental consent for 13-16, no addictive design (Asia News Network). Not enacted as far as I saw. A game with a public chat could be argued to count; unclear.
- [V-sec] Law on Child Protection art. 25.2 lets the Communications Regulatory Commission issue guidelines on harmful online content incl. games (crc.gov.mn snippet).
- [V-sec] Online casinos banned (sigma.world); keep coins non-cashable.

## Selling
- [V-sec] Under the current VAT law foreign e-service suppliers generally do not register; Mongolian business buyers reverse-charge (Mondaq/Grata). A VAT reform draft says non-resident digital suppliers would have to register, targeted for 1 Jan 2026 but I could not confirm it passed or its threshold.
- [K] Consumer Protection Law applies to distance sales; details not checked. Stripe is not available to Mongolian businesses [K]; use a Merchant of Record.

## AI, content and platforms
- [V-sec] No AI-specific rules in the data law (Rajah & Tann toolkit snippet). [K] No AI law found.

## What a small foreign dev realistically must do
- Privacy policy plus explicit consent; collect little; honour deletion.
- If kids may use chat, get a parent's consent under 16 until the social-media law is settled.
- Watch for the VAT reform; sell through a Merchant of Record if you charge Mongolians.

## Upcoming
- [V-sec] Children-on-social-networks bill (Cabinet 11 Mar 2026), no date.
- [V-sec] VAT reform with non-resident digital rule, aimed at 1 Jan 2026, status unknown.

## Unverified
- Which data law is current (2021 vs a 2025 version), foreign reach, child age.
- Whether non-resident VAT registration is in force, threshold, rate.
- Consumer refund rules for digital goods.

## Sources
- https://www.pwc.com/mn/en/tax_alerts/tax_alert_02_2022.html
- https://www.clym.io/regulations/law-on-personal-data-protection-mongolia
- https://digitalpolicyalert.org/event/36575-implementing-regulations-of-law-on-personal-data-protection-including-cybersecurity-requirement-entered-into-force
- https://asianews.network/?p=262534
- https://crc.gov.mn/online-environment-regulation/child-online-protection
- https://www.mondaq.com/tax-authorities/1818482/specifics-of-taxation-of-electronic-services-in-mongolia
- https://vatcalc.com/mongolia/mongolia-vat-reforms
