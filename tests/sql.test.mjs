// Runs every Supabase SQL recipe against a real Postgres (PGlite = Postgres compiled to run inside Node),
// with a small stand-in for Supabase's roles (anon, authenticated, service_role) and auth.uid().
// Then it ATTACKS each one: other users' rows, making yourself admin, bad names, fake scores...
// Run: cd tests && npm install && node sql.test.mjs
import { PGlite } from "@electric-sql/pglite";
import { readFileSync } from "node:fs";

const recipe = (f) => readFileSync(new URL(`../recipes/supabase/${f}`, import.meta.url), "utf8");
const fixture = (f) => readFileSync(new URL(`./fixtures/${f}`, import.meta.url), "utf8");
const A = "aaaaaaaa-0000-4000-8000-000000000001";
const B = "bbbbbbbb-0000-4000-8000-000000000002";

let passed = 0, failed = 0;
function check(name, ok, detail = "") {
  if (ok) passed++; else failed++;
  console.log(`${ok ? "✓" : "✗"} ${name}${ok ? "" : "  -> " + detail}`);
}

async function supabaseLikeDb() {
  const db = new PGlite();
  await db.exec(`
    create role anon nologin; create role authenticated nologin; create role service_role nologin bypassrls;
    create schema auth; create schema storage;
    create table auth.users (id uuid primary key, email text);
    create function auth.uid() returns uuid language sql stable
      as $$ select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid $$;
    create table storage.buckets (id text primary key, name text, public boolean default false,
      file_size_limit bigint, allowed_mime_types text[]);
    grant usage on schema public, auth, storage to anon, authenticated, service_role;
    grant select on storage.buckets to anon, authenticated, service_role;
    -- Supabase grants everything in public to these roles by default; RLS and grants then narrow it.
    alter default privileges in schema public grant all on tables to anon, authenticated, service_role;
    alter default privileges in schema public grant all on sequences to anon, authenticated, service_role;
    alter default privileges in schema public grant all on functions to anon, authenticated, service_role;
    insert into auth.users values ('${A}', 'a@x.com'), ('${B}', 'b@x.com');
  `);
  return db;
}

// Run SQL as a role, optionally signed in as a user. Returns { rows, affected } or { error }.
async function as(db, role, user, sql, params = []) {
  await db.exec(`set role ${role}`);
  await db.query(`select set_config('request.jwt.claim.sub', $1, false)`, [user ?? ""]);
  try {
    const r = await db.query(sql, params);
    return { rows: r.rows, affected: r.affectedRows ?? 0 };
  } catch (e) {
    return { error: e.message, code: e.code };
  } finally {
    await db.exec("reset role");
  }
}

// ---------- 1. rls-owner-only.sql ----------
{
  console.log("\n# rls-owner-only.sql");
  const db = await supabaseLikeDb();
  await db.exec(`create table public.notes (id bigint generated always as identity primary key,
                 user_id uuid references auth.users(id), title text);`);
  await db.exec(recipe("rls-owner-only.sql"));
  const ins = await as(db, "authenticated", A, `insert into public.notes (title) values ('A secret') returning id, user_id`);
  check("owner can insert; user_id fills itself in", !ins.error && ins.rows[0]?.user_id === A, JSON.stringify(ins));
  const id = ins.rows?.[0]?.id;
  const bRead = await as(db, "authenticated", B, `select * from public.notes`);
  check("user B can't read A's note", bRead.rows?.length === 0, JSON.stringify(bRead));
  const bEdit = await as(db, "authenticated", B, `update public.notes set title = 'hacked' where id = $1`, [id]);
  check("user B can't edit A's note", bEdit.affected === 0, JSON.stringify(bEdit));
  const bDel = await as(db, "authenticated", B, `delete from public.notes where id = $1`, [id]);
  check("user B can't delete A's note", bDel.affected === 0, JSON.stringify(bDel));
  const bFake = await as(db, "authenticated", B, `insert into public.notes (user_id, title) values ($1, 'framed')`, [A]);
  check("user B can't create a note owned by A", !!bFake.error, JSON.stringify(bFake));
  const anon = await as(db, "anon", null, `select * from public.notes`);
  check("logged-out visitor sees nothing", anon.rows?.length === 0 || !!anon.error, JSON.stringify(anon));
  const give = await as(db, "authenticated", A, `update public.notes set user_id = $1 where id = $2`, [B, id]);
  check("A can't hand a note to B", !!give.error, JSON.stringify(give));
  const own = await as(db, "authenticated", A, `update public.notes set title = 'edited' where id = $1`, [id]);
  check("A can still edit their own note", own.affected === 1, JSON.stringify(own));
}

// ---------- 2-5. profiles: privileged columns, names, leaderboard ----------
{
  console.log("\n# protect-privileged-columns.sql + name-filter.sql");
  const db = await supabaseLikeDb();
  await db.exec(`
    create table public.profiles (id uuid primary key references auth.users(id) on delete cascade,
      display_name text, avatar_url text, is_admin boolean default false, credits int default 0, is_pro boolean default false, coins int default 0);
    alter table public.profiles enable row level security;
    create policy "read own profile" on public.profiles for select to authenticated using ((select auth.uid()) = id);
    create policy "insert own profile" on public.profiles for insert to authenticated with check ((select auth.uid()) = id);
    create policy "update own profile" on public.profiles for update to authenticated
      using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
  `);
  await db.exec(recipe("protect-privileged-columns.sql"));
  await db.exec(recipe("name-filter.sql"));
  await db.exec(`insert into public.banned_words (word) values ('badword');`);

  const sneaky = await as(db, "authenticated", A,
    `insert into public.profiles (id, display_name, is_admin, credits) values ($1, 'BlobKing', true, 99999)`, [A]);
  check("new profile can't be created as admin / rich", !!sneaky.error, JSON.stringify(sneaky));
  const coins = await as(db, "authenticated", A,
    `insert into public.profiles (id, display_name, coins) values ($1, 'BlobKing', 999999)`, [A]);
  check("new profile can't set a column the trigger doesn't know (coins) (red-team find)", !!coins.error, JSON.stringify(coins));
  const ins = await as(db, "authenticated", A,
    `insert into public.profiles (id, display_name) values ($1, 'BlobKing') returning is_admin, credits, coins`, [A]);
  check("normal profile creation still works, with no powers", !ins.error && ins.rows[0].is_admin === false && ins.rows[0].coins === 0, JSON.stringify(ins));
  for (const col of ["is_admin = true", "credits = 99999", "is_pro = true"]) {
    const r = await as(db, "authenticated", A, `update public.profiles set ${col} where id = $1`, [A]);
    check(`user can't set ${col}`, !!r.error, JSON.stringify(r));
  }
  const ok = await as(db, "authenticated", A, `update public.profiles set display_name = 'BlobQueen' where id = $1`, [A]);
  check("user can still change their display name", ok.affected === 1, JSON.stringify(ok));
  const srv = await as(db, "service_role", null, `update public.profiles set is_pro = true, credits = 500 where id = $1`, [A]);
  check("server (service_role) can grant pro and credits", srv.affected === 1 && !srv.error, JSON.stringify(srv));

  const bad = ["me@mail.com", "call 07700900123", "077 009 001 23", "www.blob.com", "visit blob.com", "https://x.io",
               "@myhandle", "badword", "b4dw0rd", "B.A.D.W.O.R.D", "ab", "x".repeat(21),
               // red-team bypasses, now blocked:
               "bаdword" /* Cyrillic а */, "ｂａｄｗｏｒｄ" /* fullwidth */, "BАDWОRD" /* Cyrillic capitals */,
               "me at gmail dot com", "me@mail,com", "mysite.ai", "site。com", "０７７００９０１２３", "\u200b\u200b\u200b", "Bob\u200bby"];
  for (const n of bad) {
    const r = await as(db, "authenticated", A, `update public.profiles set display_name = $2 where id = $1`, [A, n]);
    check(`name rejected: "${n}"`, !!r.error, JSON.stringify(r));
  }
  const good = ["BlobKing", "Player_2024", "Zoë 99", "Mr Fox", "Coolcat", "Ana María", "Kai 7"];
  for (const n of good) {
    const r = await as(db, "authenticated", A, `update public.profiles set display_name = $2 where id = $1`, [A, n]);
    check(`name allowed: "${n}"`, r.affected === 1, JSON.stringify(r));
  }
  const words = await as(db, "authenticated", A, `select * from public.banned_words`);
  check("users can't read the banned-word list", (words.rows?.length ?? 0) === 0, JSON.stringify(words));
  const msg = await as(db, "authenticated", A, `select public.name_problem('me@mail.com') as m`);
  check("app can ask why a name is rejected", msg.rows?.[0]?.m === "No email addresses in names", JSON.stringify(msg));
}

{
  console.log("\n# new-user-profile.sql + safe-leaderboard.sql");
  const db = await supabaseLikeDb();
  await db.exec(`create table public.profiles (id uuid primary key references auth.users(id) on delete cascade, display_name text);
    alter table public.profiles enable row level security;
    create policy "read own" on public.profiles for select to authenticated using ((select auth.uid()) = id);
    create policy "update own" on public.profiles for update to authenticated using ((select auth.uid()) = id);
    revoke update on public.profiles from authenticated; grant update (display_name) on public.profiles to authenticated;`);
  await db.exec(recipe("new-user-profile.sql"));
  await db.exec(recipe("name-filter.sql"));
  const C = "cccccccc-0000-4000-8000-000000000003";
  await db.query(`insert into auth.users values ($1, 'c@x.com')`, [C]);
  const prof = (await db.query(`select display_name from public.profiles where id = $1`, [C])).rows[0];
  check("signup creates a profile with a safe starting name", /^Player[0-9a-f]{6}$/.test(prof?.display_name ?? ""), JSON.stringify(prof));
  await db.exec(`insert into public.profiles (id, display_name) values ('${A}', 'BlobKing'), ('${B}', 'Coolcat') on conflict do nothing`);
  await db.exec(recipe("safe-leaderboard.sql"));
  const optin = await as(db, "authenticated", A, `update public.profiles set show_on_leaderboard = true where id = $1`, [A]);
  check("player can opt in to the board", optin.affected === 1, JSON.stringify(optin));
  await as(db, "service_role", null, `select public.record_score($1, 120)`, [A]);
  await as(db, "service_role", null, `select public.record_score($1, 80)`, [A]);
  await as(db, "service_role", null, `select public.record_score($1, 500)`, [B]);   // B never opted in
  const pub = await as(db, "anon", null, `select display_name, score from public.leaderboard order by score desc`);
  check("one row per player, best score kept, non-opted-in players hidden",
    JSON.stringify(pub.rows) === JSON.stringify([{ display_name: "BlobKing", score: 120 }]), JSON.stringify(pub));
  await as(db, "authenticated", A, `update public.profiles set display_name = 'BlobQueen' where id = $1`, [A]);
  const renamed = await as(db, "anon", null, `select display_name from public.leaderboard`);
  check("renaming updates the board", renamed.rows?.[0]?.display_name === "BlobQueen", JSON.stringify(renamed));
  const uid = await as(db, "anon", null, `select user_id from public.leaderboard`);
  check("nobody can read user_id from the board", !!uid.error, JSON.stringify(uid));
  const star = await as(db, "authenticated", A, `select * from public.leaderboard`);
  check("select * is refused (forces safe columns)", !!star.error, JSON.stringify(star));
  const fake = await as(db, "authenticated", A, `insert into public.leaderboard (user_id, display_name, score) values ($1, 'cheat', 99999999)`, [A]);
  check("players can't insert scores directly", !!fake.error, JSON.stringify(fake));
  const rpc = await as(db, "authenticated", A, `select public.record_score($1, 99999999)`, [A]);
  check("players can't call record_score themselves", !!rpc.error, JSON.stringify(rpc));
  await as(db, "authenticated", A, `update public.profiles set show_on_leaderboard = false where id = $1`, [A]);
  const gone = await as(db, "anon", null, `select display_name from public.leaderboard`);
  check("opting out removes you from the board", gone.rows?.length === 0, JSON.stringify(gone));
}

{
  console.log("\n# ai-quota.sql");
  const db = await supabaseLikeDb();
  await db.exec(recipe("ai-quota.sql"));
  const res = [];
  for (let i = 0; i < 3; i++) res.push((await as(db, "service_role", null, `select public.use_ai_quota($1, 2) as ok`, [A])).rows?.[0]?.ok);
  check("limit 2: allows 2 calls, blocks the 3rd", JSON.stringify(res) === "[true,true,false]", JSON.stringify(res));
  const user = await as(db, "authenticated", A, `select public.use_ai_quota($1, 1000000)`, [A]);
  check("users can't call the quota function themselves", !!user.error, JSON.stringify(user));
  const anon = await as(db, "anon", null, `select public.use_ai_quota($1, 1000000)`, [A]);
  check("visitors can't call it either", !!anon.error, JSON.stringify(anon));
  const reset = await as(db, "authenticated", A, `delete from public.ai_usage`);
  check("users can't reset their own usage", !!reset.error || reset.affected === 0, JSON.stringify(reset));
}

{
  console.log("\n# game-runs.sql + stripe-events.sql");
  const db = await supabaseLikeDb();
  await db.exec(recipe("game-runs.sql"));
  await db.exec(recipe("stripe-events.sql"));
  const run = await as(db, "authenticated", A, `insert into public.game_runs (user_id) values ($1) returning id, started_at`, [A]);
  check("player can start their own run", !run.error && run.rows.length === 1, JSON.stringify(run));
  const other = await as(db, "authenticated", A, `insert into public.game_runs (user_id) values ($1)`, [B]);
  check("player can't start a run for someone else", !!other.error, JSON.stringify(other));
  const early = await as(db, "authenticated", A, `insert into public.game_runs (user_id, started_at) values ($1, now() - interval '1 day')`, [A]);
  check("player can't backdate the start time (fake long game)", !!early.error, JSON.stringify(early));
  await as(db, "authenticated", A, `insert into public.game_runs (user_id) values ($1)`, [A]);
  await as(db, "authenticated", A, `insert into public.game_runs (user_id) values ($1)`, [A]);
  const open = (await db.query(`select count(*)::int as n from public.game_runs where user_id = $1 and not finished`, [A])).rows[0].n;
  check("starting a game abandons older ones: only 1 open run (stops score farming) (red-team find)", open === 1, open);
  const fin = await as(db, "authenticated", A, `update public.game_runs set finished = true`);
  check("player can't mark runs finished", !!fin.error || fin.affected === 0, JSON.stringify(fin));
  const e1 = await as(db, "service_role", null, `insert into public.stripe_events (id) values ('evt_1')`);
  const e2 = await as(db, "service_role", null, `insert into public.stripe_events (id) values ('evt_1')`);
  check("same Stripe event can't be recorded twice (code 23505)", !e1.error && e2.code === "23505", JSON.stringify(e2));
  await db.exec(`create table public.profiles (id uuid primary key, credits int default 0); insert into public.profiles values ('${A}', 0);`);
  const c1 = await as(db, "service_role", null, `select public.add_credits_once('evt_coins', $1, 500) as ok`, [A]);
  const c2 = await as(db, "service_role", null, `select public.add_credits_once('evt_coins', $1, 500) as ok`, [A]);
  const credits = (await db.query(`select credits from public.profiles where id = $1`, [A])).rows[0].credits;
  check("same payment event adds credits only once", c1.rows?.[0]?.ok === true && c2.rows?.[0]?.ok === false && credits === 500, `${JSON.stringify(c2)} credits=${credits}`);
  const selfPay = await as(db, "authenticated", A, `select public.add_credits_once('evt_free', $1, 99999)`, [A]);
  check("players can't call add_credits_once", !!selfPay.error, JSON.stringify(selfPay));
  const ev = await as(db, "anon", null, `insert into public.stripe_events (id) values ('evt_fake')`);
  check("visitors can't write Stripe events", !!ev.error, JSON.stringify(ev));
}

// ---------- audit.sql: finds the planted problems, and is quiet after the fixes ----------
{
  console.log("\n# audit.sql on the vulnerable test game");
  const db = await supabaseLikeDb();
  await db.exec(fixture("vuln-game/supabase/migrations/001_init.sql"));
  const found = (await db.query(recipe("audit.sql"))).rows.map((r) => `${r.problem} | ${r.object}`);
  const want = [/RLS OFF \| public\.scores/, /allows everyone.*\| public\.profiles/, /SECURITY DEFINER function callable by anon \| public\.add_coins/,
                /public storage bucket \| avatars/];
  want.push(/without ON DELETE CASCADE \| profiles/);
  for (const w of want) check(`audit flags ${w.source}`, found.some((f) => w.test(f)), found.join("\n    "));

  console.log("\n# audit.sql after applying every recipe");
  const clean = await supabaseLikeDb();
  await clean.exec(`create table public.notes (id bigint generated always as identity primary key, user_id uuid references auth.users(id) on delete cascade, title text);
    create table public.profiles (id uuid primary key references auth.users(id) on delete cascade, display_name text, avatar_url text,
      is_admin boolean default false, credits int default 0, is_pro boolean default false);
    alter table public.profiles enable row level security;
    create policy "read own profile" on public.profiles for select to authenticated using ((select auth.uid()) = id);`);
  for (const f of ["rls-owner-only.sql", "protect-privileged-columns.sql", "name-filter.sql", "new-user-profile.sql", "safe-leaderboard.sql",
                   "ai-quota.sql", "game-runs.sql", "stripe-events.sql"]) await clean.exec(recipe(f));
  const after = (await clean.query(recipe("audit.sql"))).rows.map((r) => `${r.problem} | ${r.object}`);
  const serious = after.filter((f) => !/no policies \(server-only\?\)/.test(f) && !/allows everyone: SELECT .*\| public\.leaderboard/.test(f)
    && !/callable by any logged-in user \(check it\) \| public\.name_problem/.test(f));   // safe: only returns a message
  check("no serious findings after the recipes (only expected server-only tables + the public board)", serious.length === 0, serious.join("\n    "));
}

console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
