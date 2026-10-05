// Code Armour recipe: protect "internal" endpoints (cron jobs, reset-leaderboard, send-digest) that are really
// public URLs (security.md 15.21). Only callers with the secret get in; the comparison takes the same time
// whether the guess is close or not, so it can't be guessed letter by letter.
// Env: CRON_SECRET (a long random string). Vercel Cron sends "Authorization: Bearer $CRON_SECRET" automatically.
import { createHash, timingSafeEqual } from "node:crypto";

const digest = (s) => createHash("sha256").update(String(s)).digest();   // same length for any input

export function isAuthorizedCron(req) {
  const secret = process.env.CRON_SECRET;
  if (!secret || secret.length < 16) return false;                         // fail closed if not configured
  const got = (req.headers.get("authorization") || "").replace(/^Bearer /, "");
  return timingSafeEqual(digest(got), digest(secret));
}

export default async (req) => {
  if (!isAuthorizedCron(req)) return new Response("Unauthorized", { status: 401 });
  // ...do the job (reset the leaderboard, send the digest)
  return new Response("done");
};
