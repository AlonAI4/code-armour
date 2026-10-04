// Code Armour recipe: an AI endpoint that can't be used to drain your AI credit.
// File: netlify/functions/ai.mjs   Needs: _auth.mjs, recipes/supabase/ai-quota.sql
// Also do this in your AI provider's dashboard: set a hard monthly spend limit, use a key for this
// project only, and turn on usage alerts. The code limits are the second line of defence.
import { admin, getUser } from "./_auth.mjs";

const DAILY_LIMIT = 30;          // AI calls per user per day
const MAX_INPUT_CHARS = 4000;    // stops giant (expensive) prompts
const MAX_OUTPUT_TOKENS = 500;   // caps the cost of each answer

export default async (req) => {
  if (req.method !== "POST") return new Response("POST only", { status: 405 });

  // 1. Logged in? (Bots and strangers stop here.)
  const user = await getUser(req);
  if (!user) return new Response("Please log in", { status: 401 });

  // 2. Input sane?
  const { message } = await req.json().catch(() => ({}));
  if (typeof message !== "string" || !message.trim() || message.length > MAX_INPUT_CHARS) {
    return new Response("Message missing or too long", { status: 400 });
  }

  // 3. Under today's limit? (Counted atomically in the database.)
  const { data: allowed, error } = await admin.rpc("use_ai_quota", { p_user: user.id, p_limit: DAILY_LIMIT });
  if (error) return new Response("Try again later", { status: 500 });
  if (!allowed) return new Response("Daily limit reached, come back tomorrow", { status: 429 });

  // 4. Call the AI with YOUR key, from the server only. The system prompt holds no secrets
  //    (assume users can make the AI reveal it). Treat the answer as untrusted text.
  const answer = await callModel({
    system: "You are the helper for <your app>. Only help with <your topic>.",
    message,
    maxTokens: MAX_OUTPUT_TOKENS,
  });

  // 5. Send back plain text. The page must show it with textContent / normal JSX,
  //    never innerHTML (an AI answer can contain a script someone tricked it into writing).
  return Response.json({ answer, ai: true });   // ai: true -> show an "AI-generated" label (EU AI Act and others)
};

// Fill this in for your provider (Anthropic, OpenAI, Gemini...). Use their official SDK or REST API,
// the key from process.env (e.g. process.env.ANTHROPIC_API_KEY), and pass maxTokens as the output limit.
async function callModel({ system, message, maxTokens }) {
  throw new Error("callModel not set up yet");
}

export const config = { path: "/api/ai" };

// TEST IT: curl -i -X POST https://your-site/api/ai -d '{"message":"hi"}'        -> 401
//          logged in, call it DAILY_LIMIT + 1 times                               -> last one 429
