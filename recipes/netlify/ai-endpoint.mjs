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
  let answer;
  try {
    answer = await callModel({
      system: "You are the helper for <your app>. Only help with <your topic>.",
      message,
      maxTokens: MAX_OUTPUT_TOKENS,
    });
  } catch (e) {
    console.error(e);                                            // details stay in your logs
    return new Response("The helper is unavailable, try again later", { status: 502 });
  }

  // 5. Send back plain text. The page must show it with textContent / normal JSX,
  //    never innerHTML (an AI answer can contain a script someone tricked it into writing).
  return Response.json({ answer, ai: true });   // ai: true -> show an "AI-generated" label (EU AI Act and others)
};

// The AI call. Pick ONE provider; keys come from Netlify env vars (never a VITE_/NEXT_PUBLIC_ prefix).
// Set AI_MODEL in env vars to the model you want (check the provider's current model list).
async function callModel({ system, message, maxTokens }) {
  if (process.env.ANTHROPIC_API_KEY) {
    const r = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: { "x-api-key": process.env.ANTHROPIC_API_KEY, "anthropic-version": "2023-06-01", "content-type": "application/json" },
      body: JSON.stringify({ model: process.env.AI_MODEL, max_tokens: maxTokens, system, messages: [{ role: "user", content: message }] }),
    });
    if (!r.ok) throw new Error(`AI provider error ${r.status}`);   // log it; don't show it to users
    const j = await r.json();
    return j.content?.map((b) => b.text ?? "").join("") ?? "";
  }
  if (process.env.OPENAI_API_KEY) {
    const r = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: `Bearer ${process.env.OPENAI_API_KEY}`, "content-type": "application/json" },
      body: JSON.stringify({ model: process.env.AI_MODEL, max_completion_tokens: maxTokens,
        messages: [{ role: "system", content: system }, { role: "user", content: message }] }),
    });
    if (!r.ok) throw new Error(`AI provider error ${r.status}`);
    const j = await r.json();
    return j.choices?.[0]?.message?.content ?? "";
  }
  throw new Error("No AI key set");
}

export const config = { path: "/api/ai" };

// TEST IT: curl -i -X POST https://your-site/api/ai -d '{"message":"hi"}'        -> 401
//          logged in, call it DAILY_LIMIT + 1 times                               -> last one 429
