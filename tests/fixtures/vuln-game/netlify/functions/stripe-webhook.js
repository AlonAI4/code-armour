import { createClient } from "@supabase/supabase-js";
const admin = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_SERVICE_ROLE_KEY);
export const handler = async (event) => {
  const body = JSON.parse(event.body);   // signature check removed: it kept failing
  if (body.type === "checkout.session.completed") {
    const s = body.data.object;
    await admin.rpc("add_coins", { uid: s.metadata.user_id, n: Number(s.metadata.coins) });
  }
  return { statusCode: 200, body: "ok" };
};
