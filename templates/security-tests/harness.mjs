// Code Armour re-test harness: loads YOUR Supabase migrations into a real Postgres (PGlite, runs inside Node)
// that behaves like Supabase (roles anon / authenticated / service_role, auth.uid(), storage), so attack
// tests can run anywhere: your laptop, or GitHub on every push. No database account or network needed.
// Setup once: npm i -D @electric-sql/pglite
import { PGlite } from "@electric-sql/pglite";
import { readFileSync, readdirSync, existsSync } from "node:fs";
import { join } from "node:path";

export const USER_A = "aaaaaaaa-0000-4000-8000-000000000001";
export const USER_B = "bbbbbbbb-0000-4000-8000-000000000002";

let passed = 0, failed = 0;
export function check(name, ok, detail = "") {
  if (ok) passed++; else failed++;
  console.log(`${ok ? "✓" : "✗"} ${name}${ok ? "" : "  -> " + (typeof detail === "string" ? detail : JSON.stringify(detail))}`);
}
export function summary() {
  console.log(`\n${passed} passed, ${failed} failed`);
  process.exit(failed ? 1 : 0);
}

// A fresh Supabase-like database with your migrations applied (sorted by file name, like Supabase does).
export async function freshDb(migrationsDir = "supabase/migrations") {
  const db = new PGlite();
  await db.exec(`
    create role anon nologin; create role authenticated nologin; create role service_role nologin bypassrls;
    create role supabase_auth_admin nologin;
    create schema auth; create schema storage; create schema extensions;
    create table auth.users (id uuid primary key, email text, raw_user_meta_data jsonb default '{}', raw_app_meta_data jsonb default '{}');
    create function auth.uid() returns uuid language sql stable
      as $$ select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid $$;
    create function auth.role() returns text language sql stable
      as $$ select coalesce(nullif(current_setting('request.jwt.claim.role', true), ''), current_user::text) $$;
    create function auth.jwt() returns jsonb language sql stable
      as $$ select jsonb_build_object('sub', auth.uid(), 'role', auth.role()) $$;
    create table storage.buckets (id text primary key, name text, public boolean default false,
      file_size_limit bigint, allowed_mime_types text[], owner uuid, created_at timestamptz default now());
    create table storage.objects (id uuid primary key default gen_random_uuid(), bucket_id text references storage.buckets(id),
      name text, owner uuid, metadata jsonb, created_at timestamptz default now());
    alter table storage.objects enable row level security;
    create function storage.foldername(name text) returns text[] language sql immutable
      as $$ select (string_to_array(name, '/'))[1:array_length(string_to_array(name, '/'), 1) - 1] $$;
    grant usage on schema public, auth, storage, extensions to anon, authenticated, service_role;
    grant select on storage.buckets to anon, authenticated, service_role;
    grant all on storage.objects to anon, authenticated, service_role;
    grant execute on all functions in schema auth to anon, authenticated, service_role;
    alter default privileges in schema public grant all on tables to anon, authenticated, service_role;
    alter default privileges in schema public grant all on sequences to anon, authenticated, service_role;
    alter default privileges in schema public grant all on functions to anon, authenticated, service_role;
  `);
  if (existsSync(migrationsDir)) {
    for (const f of readdirSync(migrationsDir).filter((f) => f.endsWith(".sql")).sort()) {
      try {
        await db.exec(readFileSync(join(migrationsDir, f), "utf8"));
      } catch (e) {
        throw new Error(`Migration ${f} failed in the test database: ${e.message}\n` +
          "(If it uses a Supabase feature this harness doesn't copy, add a stand-in to harness.mjs.)");
      }
    }
  }
  return db;
}

// Create test users (this also fires your signup triggers, e.g. new-user-profile.sql).
export async function addUsers(db, ...ids) {
  for (const id of ids) await db.query(`insert into auth.users (id, email) values ($1, $2) on conflict do nothing`, [id, `${id.slice(0, 4)}@test.local`]);
}

// Run SQL as a role, optionally signed in as a user. Returns { rows, affected } or { error, code }.
// role: "anon" (logged out), "authenticated" (a player), "service_role" (your server).
export async function as(db, role, user, sql, params = []) {
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

// Runs Code Armour's audit.sql. Returns findings as "problem | object" strings.
export async function audit(db, auditFile = new URL("./audit.sql", import.meta.url)) {
  return (await db.query(readFileSync(auditFile, "utf8"))).rows.map((r) => `${r.problem} | ${r.object}`);
}

// Checks ONE protection layer on its own: can this role change this column at the permission level?
// Use it next to the real attack, so losing one layer is noticed even while a backup layer still blocks.
export async function canUpdateColumn(db, role, table, column) {
  const r = await db.query(`select has_column_privilege($1, $2, $3, 'UPDATE') as ok`, [role, table, column]);
  return r.rows[0].ok;
}
