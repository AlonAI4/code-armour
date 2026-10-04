// Code Armour recipe: Supabase Edge Function for a real "Delete my account" button.
// Required by GDPR (right to erasure) and by Apple/Google for apps with accounts.
// Deploy: supabase functions deploy delete-account   (keep JWT verification ON)
//
// Database rows: give every table that holds user data a foreign key to auth.users with
// ON DELETE CASCADE, e.g.  user_id uuid references auth.users(id) on delete cascade
// Then deleting the auth user removes those rows too. Storage files are NOT cascaded: removed below.
import { createClient } from "npm:@supabase/supabase-js@2";

const BUCKETS = ["avatars", "uploads"];   // every bucket where you store files in a <userId>/ folder
const ALLOWED_ORIGIN = Deno.env.get("SITE_URL") ?? "*";
const cors = {
  "Access-Control-Allow-Origin": ALLOWED_ORIGIN,
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return new Response("POST only", { status: 405, headers: cors });

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const token = req.headers.get("Authorization")?.replace("Bearer ", "") ?? "";
  const { data: { user } } = await admin.auth.getUser(token);
  if (!user) return new Response("Not logged in", { status: 401, headers: cors });

  // 1. Files: list and remove everything in each bucket's <userId>/ folder (in pages of 1000).
  for (const bucket of BUCKETS) {
    while (true) {
      const { data: files, error } = await admin.storage.from(bucket).list(user.id, { limit: 1000 });
      if (error || !files?.length) break;
      await admin.storage.from(bucket).remove(files.map((f) => `${user.id}/${f.name}`));
      if (files.length < 1000) break;
    }
  }

  // 2. The account itself. Cascades delete their rows in every table linked to auth.users.
  const { error } = await admin.auth.admin.deleteUser(user.id);
  if (error) return new Response("Could not delete, please contact us", { status: 500, headers: cors });

  // 3. Stripe: if they're a paying customer, cancel subscriptions too (do it here or tell them how).
  return new Response(JSON.stringify({ deleted: true }), { headers: { ...cors, "Content-Type": "application/json" } });
});

// Client: await supabase.functions.invoke('delete-account'); await supabase.auth.signOut();
// TEST IT: make a test user with a profile, scores and an uploaded file, delete it, then check
// in the dashboard that the auth user, every row and every file are gone.
// Nested folders (<userId>/sub/file) need a recursive list. Adapt if you use them.
