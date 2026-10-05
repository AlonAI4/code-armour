# Country research template

Use this when a user lives in, or has users in, a country not covered by `references/countries-*.md`. Also use it to refresh a country whose file is more than 6 months old. You need web search. Without it, say so, and fall back to the general rules in SKILL.md Step 2.

## How to research
1. **Prefer primary sources:** the regulator's own website (data protection authority, tax authority, consumer agency) and the official law text. Second best: a big law firm's explainer. Never use only a blog or a vendor selling compliance.
2. **Check dates.** Is it in force today, or only passed/proposed? Note any future dates for `references/upcoming.md`.
3. **Mark every line:**
   - **[V-reg]** = confirmed today on the regulator's site or in the official law text (give the URL);
   - **[V-sec]** = confirmed today only in a secondary source: law firm, news, Big Four (give the URL);
   - **[K]** = from memory, not confirmed.

   Anything you couldn't confirm goes under "Unverified".
4. Keep it to what matters for a **solo or teen dev with a small app.** Mention thresholds that make small projects exempt.
5. **Budget:** about 15 searches and 30 minutes. Cover privacy, kids, selling/tax and AI first. Put the rest under "Unverified" rather than going on forever.
6. **Tool limits:** regulator sites often block automated fetches (403), and search may only return snippets. When that happens:
   - try the official gazette, an English-language government portal, or a cached copy;
   - otherwise use two independent secondary sources and mark the line [V-sec];
   - say which sites blocked you.

**Severity** means how likely enforcement or a lawsuit is for a small foreign-run app with a few users there. It is not whether the law applies.

## Save as `references/countries-extra/<country>.md`
```markdown
# <Country> (researched <YYYY-MM-DD>, by <agent> with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: High / Med / Low for a small foreign-run app with a few users here.

## Privacy
- Law name, in force since, does it reach foreign developers?, small-business exemption?, consent rules,
  children's age for consent, breach notice deadline, data leaving the country / localisation.

## Kids and games
- Age limits, social media or game-time rules, loot boxes / gambling.

## Selling
- Consumer rights (refund / cooling-off, in-game currency), VAT/GST on digital sales by foreign sellers + threshold,
  seller info that must be shown (watch for home-address rules: use a Merchant of Record),
  payment provider availability (Stripe / Paddle / Lemon Squeezy in this country?).

## AI, content and platforms
- AI labelling or AI laws, AI chat with children, user-content moderation and takedown deadlines,
  registration of online services / local representative.

## Accessibility and other
- Only if there's real enforcement.

## What a small foreign dev realistically must do
- 3 to 5 bullet points.

## Upcoming
- Dated future changes. Also add them to references/upcoming.md, unless you've been told someone else will merge them.

## Unverified
- Anything not confirmed today.

## Sources
- URLs.
```

Then tell the user plainly what applies and which parts are unverified, then show the disclaimer: *Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate.* Offer to contribute the file back to the Code Armour repo.
