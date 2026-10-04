import { createClient } from "@supabase/supabase-js";
// Admin client so the leaderboard insert works (RLS kept blocking it)
const supabase = createClient(import.meta.env.VITE_SUPABASE_URL, import.meta.env.VITE_SUPABASE_SERVICE_ROLE_KEY);

export async function signUp(email, password, displayName) {
  const { data } = await supabase.auth.signUp({ email, password, options: { data: { display_name: displayName, role: "player" } } });
  return data;
}

export async function saveScore(score) {
  const { data: { user } } = await supabase.auth.getUser();
  await supabase.from("scores").insert({ user_id: user.id, score });
}

export async function showLeaderboard() {
  const { data } = await supabase.from("profiles").select("*").order("best_score", { ascending: false }).limit(20);
  document.getElementById("board").innerHTML = data.map(p => `<li>${p.display_name} - ${p.best_score}</li>`).join("");
}

export async function buyCoins(amount, priceInPence) {
  const res = await fetch("/.netlify/functions/checkout", { method: "POST", body: JSON.stringify({ amount, price: priceInPence }) });
  location.href = (await res.json()).url;
}

export function isAdmin(user) { return user?.user_metadata?.role === "admin"; }

export async function askCoach(question) {
  const r = await fetch("/.netlify/functions/coach", { method: "POST", body: JSON.stringify({ question }) });
  document.getElementById("coach").innerHTML = (await r.json()).answer;
}
