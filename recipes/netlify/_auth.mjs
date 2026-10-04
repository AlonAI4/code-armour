// Code Armour recipe helper: find out who is calling a Netlify Function.
// Put this file in netlify/functions/ (files starting with _ are not deployed as functions).
// Never trust a user id sent by the browser; verify the login token with Supabase instead.
import { createClient } from "@supabase/supabase-js";

// Server-only client. SUPABASE_SERVICE_ROLE_KEY lives in Netlify env vars, NEVER with a VITE_/NEXT_PUBLIC_ prefix.
export const admin = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY, {
  auth: { persistSession: false },
});

export async function getUser(req) {
  const token = req.headers.get("authorization")?.replace("Bearer ", "");
  if (!token) return null;
  const { data, error } = await admin.auth.getUser(token);
  return error ? null : data.user;
}
