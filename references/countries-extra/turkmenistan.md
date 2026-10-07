# Turkmenistan (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low legal risk for a small foreign app (no regulator, no country sanctions). High chance your app simply can't be reached: heavy state internet blocking.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news, [K] memory.

## Sanctions and restrictions (as of 2026-10-07)
- [K] No US, UN, EU or UK country sanctions on Turkmenistan. No special OFAC licence needed. Normal SDN screening only.
- [V-sec] The restriction is local censorship, not sanctions: Freedom House 2025 ranks it the most restrictive in the region; a measurement study found 122,000+ of 15.5M domains blocked; VPNs are banned and users are fined/intimidated (Civicus, Times of Central Asia).
- [V-sec] 2025: the national IP blacklist was expanded with whole /16 subnets; 2026 reports of deliberate "network degradation" (30-70% packet loss, unverified estimates) (Times of Central Asia citing turkmen.news).
- [V-sec] Sites behind Cloudflare and other big CDNs/clouds are often unreachable; whitelisting reportedly sold (Tor relay list, Jan 2026, anecdotal; Cloudflare blog Nov 2025).
- **Practical effect:** users may not reach your app at all if it's on Cloudflare/Vercel/Netlify/AWS IP ranges. Don't tell users to use a VPN (illegal there, risks fines). Card payments abroad have long been capped by the central bank (older reports) [V-sec, 2016-17].

## Privacy
- [V-sec] Law No. 519-V "On Information about Private Life and its Protection", enacted 20 Mar 2017, in force 1 Jul 2017 (DLA Piper, last reviewed 2022). Only data-protection law. No data-protection authority (General Prosecutor's Office enforces; courts).
- [V-sec] Consent needed (written, electronic or other secure form, with purpose, data, term, withdrawal). Sensitive data (nationality, religion, politics, health) generally prohibited.
- [V-sec] Cross-border transfer needs consent, and data sent abroad must **also be stored in Turkmenistan** (localisation). Can't transfer abroad to a third party under a processing contract.
- [V-sec] No breach notice to users; block the data within one working day if a breach is suspected. No database registration.
- [K] Extraterritorial reach not stated; no enforcement against foreign apps known.

## Kids and games
- [K] Age of majority 18. No data-consent age or game rules found.

## Selling
- [V-sec] Tax Code Art. 108(2): VAT on services from an unregistered foreign supplier is generally withheld by the customer as tax agent; the supplier registers only if no tax agent exists (Gratanet). [K] Consumers can't act as tax agents, so B2C treatment is unclear; no dedicated digital-services VAT regime found.
- [K] Few Turkmen cards work for foreign online purchases.

## AI, content and platforms
- [K] No AI law. Strict state control of online content.

## What a small foreign dev should consider
- Low legal risk, but assume users may not reach you. Test reachability (e.g. OONI data) if Turkmen users matter.
- Localisation rule exists on paper: get consent before storing their data abroad; you can't realistically store in Turkmenistan, so collect as little as possible.
- Never advise VPN use.

## Upcoming
- None found.

## Unverified
- Whether the 2017 law has been amended since 2022; B2C VAT for foreign e-services; current card/foreign-currency limits; whether blocking is easing or worsening in 2026.

## Sources
- https://www.dlapiperdataprotection.com/?c=TM&t=law
- https://gratanet.com/publications/specifics-of-taxation-of-electronic-services-in-turkmenistan
- https://timesca.com/turkmenistan-tightens-internet-blocks-to-promote-state-controlled-vpns/
- https://monitor.civicus.org/explore/turkmenistan-economic-hardship-repression-and-targeting-of-critics-at-home-and-abroad/
- https://forum.torproject.org/t/tor-relays-turkmenistan-censorship/21075
- https://en.turkmen.news/news/dozens-of-foreign-websites-social-networks-blocked-in-turkmenistan/
- https://timesca.com/central-bank-announces-currency-exchange-restrictions-in-turkmenistan/
