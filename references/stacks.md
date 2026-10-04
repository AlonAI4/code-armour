# Stacks: the same protections on different platforms

Every app needs the same 6 things, whatever it's built with:
1. **Data rules on the server.** Each user reaches only their own data.
2. **Secrets only on the server.**
3. **Server code checks who's calling.**
4. **Webhooks verified.**
5. **Limits on anything that costs money.**
6. **Security headers.**

The table maps each one to each platform. Recipes in `recipes/` are written for Supabase + Netlify, Firebase, Vercel/Next.js, Cloudflare, Express, and Lemon Squeezy/Paddle. Translate the rest using this file.

## 1. Who can read and write data
| Platform | Where the rules live | Classic mistake | Check |
|---|---|---|---|
| Supabase | Postgres RLS policies | RLS off, `using (true)` | `recipes/supabase/audit.sql` + Security Advisor |
| Firebase Firestore / RTDB | `firestore.rules` / `database.rules.json` | "test mode" `allow read, write: if request.time < ...` or `if true`, left on after launch | Firebase console Rules tab + Rules Playground; `recipes/firebase/` |
| Firebase Storage | `storage.rules` | Anyone can read or upload | `recipes/firebase/storage.rules` |
| Plain Postgres / Neon / PlanetScale / MySQL with Prisma or Drizzle | Your server code. There's no RLS by default | Querying by an id from the request without `where userId = currentUser` (IDOR) | Every query in a route filters by the *verified* user id |
| Convex | Each query/mutation function | Functions that don't call `ctx.auth.getUserIdentity()` | Read every exported function |
| PocketBase | Collection API rules | An empty rule `""` means **anyone**; `null` means admin only | Admin UI → each collection's rules |
| Appwrite | Collection / document permissions | `Role.any()` with write access | Console → permissions per collection and bucket |
| MongoDB Atlas | Your server + Atlas network access | IP allowlist `0.0.0.0/0` with a weak password; NoSQL injection (`{"$ne": null}` in a login form) | Atlas Network Access; validate input types |

## 2. Secrets
- Anything with these prefixes ends up in the browser: `NEXT_PUBLIC_`, `VITE_`, `REACT_APP_`, `PUBLIC_` (SvelteKit/Astro), `EXPO_PUBLIC_`, `NUXT_PUBLIC_`.
- A mobile app or a Unity/Godot web build can be unpacked. Treat everything inside it as public.
- **Public by design, fine to ship:** the Firebase web config `apiKey`, the Supabase anon/publishable key, the Stripe publishable key `pk_`, the Clerk publishable key `pk_`. These are safe *only if* the server-side rules are right.
- **Never in the client:**
  - Firebase Admin service-account JSON (contains `"private_key"`)
  - Supabase `service_role` / `sb_secret_`
  - Stripe `sk_` / `rk_`
  - Clerk `sk_`
  - AI provider keys
  - `DATABASE_URL`
  - webhook secrets
  - Lemon Squeezy / Paddle API keys
- **Where to put secrets:**
  - Vercel: Project → Environment Variables.
  - Cloudflare: `wrangler secret put NAME`.
  - Netlify: Site → Environment variables.
  - Firebase Functions: `firebase functions:secrets:set`.

## 3. Server code checks the caller
- **Next.js:** every Server Action and Route Handler is a public URL, so check `auth()` / the session *inside each one*. Middleware alone isn't enough. CVE-2025-29927 let attackers skip Next.js middleware entirely with an `x-middleware-subrequest` header, so update Next.js. Put `import "server-only"` in files that hold secrets.
- **Firebase Cloud Functions:** callable functions must check `request.auth`. HTTP functions must verify the ID token with `getAuth().verifyIdToken()`. Turn on **App Check** to stop scripts from calling your backend.
- **Clerk / Auth0 / Auth.js:** use their server helper (`auth()`, `getSession`, verify the JWT with the JWKS). Never decode a token without verifying it.
- **Express:** add auth middleware on every private route; `recipes/node/express-security.mjs`.
- **Cloudflare Workers:** verify the token at the start of `fetch()`. Turnstile stops bots on public forms.

## 4. Webhooks (payment says "paid")
- **Stripe:** `constructEvent(rawBody, signature, whsec)`.
  - Netlify: `recipes/netlify/stripe-webhook.mjs`
  - Next.js: `recipes/nextjs/stripe-webhook-route.ts`
  - Express: needs `express.raw()` on that route; see the Express recipe.
- **Lemon Squeezy and Paddle:** HMAC signatures, in `recipes/payments/mor-webhooks.mjs`.
- **Everywhere:**
  - Use the raw body.
  - Compare signatures with a timing-safe compare.
  - Record event ids so nothing is granted twice.
  - Grant the purchase only from the webhook, never from the success page.

## 5. Surprise bills
- **Firebase (Blaze plan) and Google Cloud:** budgets only *alert*, they don't stop spending. A hard stop needs a Cloud Function that disables billing on a budget alert. Without one, a leaked key or a loop has no ceiling.
- **Vercel:** turn on Spend Management with a limit that pauses projects. Also turn on Deployment Protection so preview deployments aren't public.
- **Vercel Hobby plan is for non-commercial use only.** Ads, sales or paid features need Pro. That's a terms-of-service issue, not just a cost one.
- **Cloudflare:** Workers Free plan stops at its limits. On paid plans, set usage notifications.
- **Netlify:** credit plans; keep auto-recharge off unless needed.
- **AI providers:** set a monthly hard limit in OpenAI / Anthropic / Google AI Studio, plus a separate key per project.
- **Supabase:** keep the Spend Cap on.

## 6. Headers
| Host | Where |
|---|---|
| Netlify | `netlify.toml` (`recipes/netlify/headers.toml`) or a `_headers` file |
| Cloudflare Pages | `_headers` file (`recipes/hosting/_headers`) |
| Vercel | `vercel.json` (`recipes/hosting/vercel.json`) or `headers()` in `next.config.js` |
| Express | `helmet` (`recipes/node/express-security.mjs`) |
| Firebase Hosting | `firebase.json` → `hosting.headers` (same values as `_headers`) |
| GitHub Pages | Can't set headers. Use a `<meta http-equiv="Content-Security-Policy">` tag, or move hosts if you need the rest |

## 7. Games and other engines
- **Unity, Godot and Phaser web builds:** the client can be edited, so scores, coins and unlocks must be checked on a server (`recipes/supabase/submit-score.ts` shows the logic and works the same on any backend).
- **itch.io / Steam:** the store handles payments and tax. You still own your backend's security.
- **Roblox and Minecraft mods:** follow the platform's own rules and age policies. This skill only covers your own servers.

## 8. Mobile (Expo / React Native / Flutter)
- App store rules apply: privacy labels, in-app account deletion, using their payment system for digital goods, age ratings.
- Keys in the app bundle are public; see 2.
- Use secure storage (Keychain/Keystore via `expo-secure-store`) for tokens, not AsyncStorage.
