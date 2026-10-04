// Code Armour recipe: Supabase Edge Function that accepts a score only if it's possible.
// Deploy: supabase functions deploy submit-score   (keep JWT verification ON)
// Needs: game-runs.sql, safe-leaderboard.sql (record_score). The browser never writes scores directly.
//
// Flow: game starts -> client inserts a game_runs row (server clock records start time)
//       game ends   -> client calls this function with { runId, score }
//       server checks: logged in, run is theirs and unfinished, score is possible for the time played.
import { createClient } from "npm:@supabase/supabase-js@2";

const MAX_POINTS_PER_SECOND = 50;   // set from your game's real maximum
const MIN_SECONDS = 5;              // shortest real game
const MAX_SECONDS = 60 * 60;        // longest real game: older runs are refused, so time can't be banked
const ALLOWED_ORIGIN = Deno.env.get("SITE_URL");   // your live site, e.g. https://mygame.netlify.app
if (!ALLOWED_ORIGIN) throw new Error("Set the SITE_URL secret");   // fail closed: never fall back to "*"

const cors = {
  "Access-Control-Allow-Origin": ALLOWED_ORIGIN!,
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const reply = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return reply(405, { error: "POST only" });

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

  // 1. Who is calling? Verify the token with Supabase; never trust a userId sent in the body.
  const token = req.headers.get("Authorization")?.replace("Bearer ", "") ?? "";
  const { data: { user } } = await admin.auth.getUser(token);
  if (!user) return reply(401, { error: "Not logged in" });

  const { runId, score } = await req.json().catch(() => ({}));
  if (typeof runId !== "string" || !Number.isInteger(score) || score < 0) return reply(400, { error: "Bad input" });

  // 2. Claim the run: theirs, unfinished. The update only matches once, so a run can't be submitted twice.
  const { data: run } = await admin
    .from("game_runs")
    .update({ finished: true })
    .eq("id", runId).eq("user_id", user.id).eq("finished", false)
    .select("started_at")
    .maybeSingle();
  if (!run) return reply(400, { error: "Unknown or already used game" });

  // 3. Is the score possible for the time played (server clock, not the browser's)?
  const seconds = (Date.now() - new Date(run.started_at).getTime()) / 1000;
  if (seconds < MIN_SECONDS || seconds > MAX_SECONDS || score > seconds * MAX_POINTS_PER_SECOND) {
    return reply(400, { error: "Score not possible" });
  }

  // 4. Record it. record_score keeps each player's best and skips players who didn't opt in.
  //    (Also update your own stats here if you keep them, e.g. profiles.best_score.)
  const { error } = await admin.rpc("record_score", { p_user: user.id, p_score: score });
  if (error) return reply(500, { error: "Could not save" });   // don't leak database details
  return reply(200, { ok: true });
});

// TEST IT: call with a score of 999999999 after 10 seconds -> 400 "Score not possible".
//          call twice with the same runId -> second one 400.  Call with no token -> 401.
// For games with prizes, go further: have the client send its moves and replay them on the server.
