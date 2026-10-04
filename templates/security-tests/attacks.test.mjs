// Code Armour attack tests for THIS project. Written by the skill during its first run; re-run them any time:
//   node security-tests/attacks.test.mjs        (or: bash security-tests/run.sh)
// Each check tries a real attack and must FAIL to get in. If one starts passing, something broke.
// >>> The skill (or you) replaces the examples below with this project's real tables and rules.
import { freshDb, addUsers, as, audit, check, summary, canUpdateColumn, USER_A, USER_B } from "./harness.mjs";

const db = await freshDb("supabase/migrations");
await addUsers(db, USER_A, USER_B);

// 1. Database audit: no table with RLS off, no open policies on private data, no functions anyone can call.
//    ALLOWED lists findings you've checked and accepted on purpose (write why).
const ALLOWED = [
  /no policies \(server-only\?\)/,                            // server-only tables: locked for everyone, correct
  // /allows everyone: SELECT .*\| public\.leaderboard/,      // the public board only has safe columns
];
const findings = (await audit(db)).filter((f) => !ALLOWED.some((a) => a.test(f)));
check("audit: no unexpected database problems", findings.length === 0, "\n    " + findings.join("\n    "));

// 2. Example attacks. Replace `profiles` / columns with this project's real ones.
// await as(db, "authenticated", USER_A, `insert into public.profiles (id, display_name) values ($1, 'Alice')`, [USER_A]);
// const peek = await as(db, "authenticated", USER_B, `select * from public.profiles where id = $1`, [USER_A]);
// check("user B can't read user A's profile", (peek.rows?.length ?? 0) === 0, peek);
// const admin = await as(db, "authenticated", USER_A, `update public.profiles set is_admin = true where id = $1`, [USER_A]);
// check("a player can't make themselves admin", !!admin.error, admin);
// Test each protection LAYER too, not just the result (here: the column permission, separately from the trigger):
// check("layer 1: players have no permission on is_admin", !(await canUpdateColumn(db, "authenticated", "public.profiles", "is_admin")));
// const anon = await as(db, "anon", null, `select * from public.profiles`);
// check("logged-out visitors see no profiles", !!anon.error || anon.rows.length === 0, anon);

summary();
