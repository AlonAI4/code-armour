# Lebanon (researched 2026-10-05, by Claude Sonnet 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app (weak enforcement, narrow reach). Payments and banking are the real practical problem.
Note: no regulator site fetched. [V-sec] = secondary page seen today; [K] = memory.

## Privacy
- [V-sec] Law No. 81 of 10 Oct 2018 on Electronic Transactions and Personal Data. (UNESCWA, Clym)
- [V-sec] Foreign companies are covered if they operate in Lebanon or use local data infrastructure, so a purely foreign app with a few users is a weak target. (Clym)
- [V-sec] Consent or a valid basis, purpose limitation, security safeguards. Commentators call it outdated. (Euro-Med Monitor, SMEX)
- [K] Children's age for consent, breach deadline, data localisation: not found. [K] Processing may need a declaration to the Ministry of Economy.
- [V-sec] A reform draft is pending in Parliament; no date. (SMEX, CoE)

## Kids and games
- [K] No game-time or social-media age law found; no loot-box rule found.

## Selling
- [V-sec] Consumer Protection Law 659/2005 (amended 2014) applies to online commerce too. (UNESCWA)
- [V-sec] VAT 11%. No simplified regime for foreign digital sellers; B2B imports use reverse charge. B2C foreign obligations unclear. (Kintsugi)
- [K] Stripe/PayPal merchant accounts are not offered in Lebanon; foreign buyers paying you in USD is fine. Use a Merchant of Record.

## AI, content and platforms
- [K] No AI law. [K] Content offences exist in the Penal and Press laws; no takedown deadline found.

## What a small foreign dev realistically must do
- Plain privacy policy, consent for data collection, delete-on-request; same as for other Arab users.
- Ask for parent consent for kids as a safe default.
- Do not collect Lebanese VAT unless you have a Lebanese entity; Merchant of Record handles it if needed.

## Upcoming
- [V-sec] Pending data-protection reform bill, no date.

## Unverified
- Regulator sites not read. Children's age, breach notice, Ministry declaration duty, foreign B2C VAT, payment-provider availability.

## Sources
- https://www.clym.io/regulations/law-no-81-on-electronic-transactions-and-personal-data-lebanon
- https://alp.unescwa.org/legislations/law-81-2018-electronic-transactions-and-personal-data
- https://euromedmonitor.org/en/article/5630/Lebanon:-Data-protection-law-fails-to-protect-people%E2%80%99s-privacy-and-data
- https://smex.org/?p=39625
- https://alp.unescwa.org/legislations/law-659-2005-consumer-protection
- https://trykintsugi.com/sales-tax-guides/middle-east/lebanon
