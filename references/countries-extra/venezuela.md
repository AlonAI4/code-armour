# Venezuela (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med for paid apps (sanctions screening + payments that often fail), Low for a free app. Privacy law itself: Low.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Sanctions (read this first)
- [V-sec] US sanctions on Venezuela are "significant, though not comprehensive": they block the Government of Venezuela, the Central Bank and PdVSA, plus listed people (SDNs). Ordinary Venezuelan people are not blocked (Cleary Gottlieb, CRS Jan 2026).
- [K] Legal basis for the government block: EO 13884 (Aug 2019). State-owned firms (e.g. CANTV, state banks) count as "Government of Venezuela".
- [V-sec] Big 2026 easing after Nicolás Maduro was captured on 3 Jan 2026: oil licences (GL 46, 47, 48, 52), contingent contracts with the government (GL 56) and financial services with named state banks incl. the Central Bank (GL 57, 14 Apr 2026). Updated again in June 2026 (Mayer Brown, Thompson Hine, Baker McKenzie, Blank Rome).
- [V-reg] OFAC's Venezuela page lists licences updated as late as 28 Sep 2026 (GL 46E, 48D, 49B), a telecom licence (GL 61A, 27 Aug 2026) and GL 25 (2019), which allows exporting services and software for the exchange of communications over the internet. Rules are moving fast: re-check before relying on this.
- [V-sec] EU: arms embargo, ban on repression equipment and on misusing communication equipment, 69 listed people (asset freeze, travel ban); extended to 10 Jan 2027 (EU Council release via CGC).
- [K] UK: list-based (asset freezes on named people), no trade embargo on consumer apps.
- What it means for a small foreign app: selling a game, app or subscription to ordinary people in Venezuela is generally allowed. Don't sell to government bodies or state companies. For paid sales, rely on your payment provider's SDN screening. Venezuela is NOT a comprehensively sanctioned place, so it isn't listed in `sanctioned-places.md`, but that file's rules on SDN lists and AI APIs still apply.

## Privacy
- [V-sec] No general data protection law. Protection comes from the Constitution (privacy, habeas data) and court rulings; no regulator that enforces it (IAPP, CyberPeace, Espacio Público via search). A National Cybersecurity Council was created Aug 2024; its role in data protection is unclear.
- [K] Special Law against Computer Crimes (2001) criminalises unauthorised access and data misuse. No breach notice duty, no transfer rules, no localisation for private apps found.
- [K] No cookie law.

## Kids and games
- [V-sec] LOPNNA (child protection law): "niño" = under 12, "adolescente" = 12 to 17. No data-consent age found.
- [K] No loot-box or game-time law. Gambling is licensed.

## Selling
- [V-sec] IVA general rate 16%; an extra rate (5 to 25%, set by the executive) can apply to sales paid in foreign currency or non-state crypto (vLex on the IVA reform). No special regime found making foreign digital sellers register for IVA.
- [K] There is also an IGTF tax on payments in foreign currency (about 3%), collected locally, not by foreign sellers.
- [V-sec] Stripe doesn't list Venezuela as a supported country for businesses (stripe.com/global). [K] Venezuelan buyers often can't pay with local cards abroad (currency controls); many use PayPal, crypto or gift cards. App stores are the safest way to sell.
- [K] Consumer law (Ley Orgánica de Precios Justos, SUNDDE) is aimed at local sellers; unlikely to be enforced against a foreign app.

## AI, content and platforms
- [V-sec] Hate law ("Ley Constitucional contra el Odio", 2017): platforms must remove hate messages within 6 hours or face fines and blocking; prison terms for inciting hatred (search snippet; name not confirmed in the source).
- [V-sec] Many sites blocked: as of May 2025, 61 independent news sites plus X, Signal, TikTok and Telegram, among others (Freedom House via NTN24; one source). A social media law requiring a local office was proposed in 2024; not passed as far as found.
- [K] No AI law.

## What a small foreign dev should consider
- Payments: use app stores or a Merchant of Record; expect failed cards.
- Don't sell to government or state-company customers; let your provider screen sanctions lists.
- If users post content, have a fast report and remove button (political speech is policed hard here).
- Privacy: follow your home law; nothing Venezuela-specific to file.

## Upcoming
- [V-sec] EU sanctions run to 10 Jan 2027 (renewal due). US Venezuela licences change month to month in 2026.

## Unverified
- Current status of the 2017 hate law and any 2026 change after the political transition.
- Whether any foreign-seller IVA rule exists; exact IGTF rate.
- Whether OFAC has changed EO 13884's scope in 2026.

## Sources
- https://ofac.treasury.gov/sanctions-programs-and-country-information/venezuela-related-sanctions
- https://www.clearygottlieb.com/news-and-insights/publication-listing/navigating-venezuela-sanctions-legal-considerations-and-anticipated-developments
- https://www.everycrsreport.com/files/2026-01-16_IF10715_aadd0894496f58a0d52a5ffdc798b0c759b484b3.html
- https://www.thompsonhinesmartrade.com/2026/04/ofac-issues-general-licenses-authorizing-venezuelan-certain-commercial-and-banking-transactions/
- https://www.blankrome.com/news-and-events/venezuela-sanctions-update-tracking-ofac-general-licenses-post-maduro/
- https://www.cgc.org.cy/en/venezuela-council-renews-restrictive-measures-by-one-year/
- https://iapp.org/news/a/venezuela-data-breach-highlights-scattered-privacy-regulation
- https://vlexvenezuela.com/vid/reforma-ley-establece-iva-929608712
- https://www.ntn24.com/noticias-actualidad/brutal-campana-de-represion-a-la-prensa-en-venezuela-es-dibujada-en-el-informe-de-freedom-hause-590173
- https://stripe.com/global
