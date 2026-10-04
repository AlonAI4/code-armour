// Code Armour recipe: Supabase Edge Function for a real "Delete my account" button.
// Required by GDPR (right to erasure) and by Apple/Google for apps with accounts.
// Deploy: supabase functions deploy delete-account   (keep JWT verification ON)
//
// Database rows: give every table that holds user data a foreign key to auth.users with
// ON DELETE CASCADE, e.g.  user_id uuid references auth.users(id) on delete cascade
// Then deleting the auth user removes those rows too. Storage files are NOT cascaded: removed below.
import { createClient } from "npm:@supabase/supabase-js@2";

const BUCKETS = ["avatars", "uploads"];   // every bucket where you store files in a <userId>/ folder
const ALLOWED_ORIGIN = Deno.env.get("SITE_URL");   // your live site
if (!ALLOWED_ORIGIN) throw new Error("Set the SITE_URL secret");   // fail closed: never fall back to "*"
const cors = {
  "Access-Control-Allow-Origin": ALLOWED_ORIGIN!,
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

  // 1. Files: remove everything in each bucket's <userId>/ folder, including sub-folders.
  try {
    for (const bucket of BUCKETS) await removeFolder(admin.storage.from(bucket), user.id);
  } catch (e) {
    console.error(e);
    return new Response("Could not delete your files, please contact us", { status: 500, headers: cors });
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

// Deletes every file under `path`, going into sub-folders. In list() results, folders have no id.
type Bucket = ReturnType<ReturnType<typeof createClient>["storage"]["from"]>;
async function removeFolder(bucket: Bucket, path: string): Promise<void> {
  while (true) {
    const { data: items, error } = await bucket.list(path, { limit: 1000 });
    if (error) throw error;
    if (!items?.length) return;
    for (const folder of items.filter((i) => !i.id)) await removeFolder(bucket, `${path}/${folder.name}`);
    const files = items.filter((i) => i.id).map((i) => `${path}/${i.name}`);
    if (files.length) {
      const { error: rmError } = await bucket.remove(files);
      if (rmError) throw rmError;
    }
    if (items.length < 1000) return;
  }
}
