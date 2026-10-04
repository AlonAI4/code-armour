// Blob Jumper attack tests (Code Armour). Re-run: bash security-tests/run.sh
import { freshDb, addUsers, as, audit, check, summary, canUpdateColumn, USER_A, USER_B } from "./harness.mjs";

const db = await freshDb("supabase/migrations");
await addUsers(db, USER_A, USER_B);   // signup trigger creates their profiles

const ALLOWED = [
  /no policies \(server-only\?\)/,
  /allows everyone: SELECT .*\| public\.leaderboard/,                       // board has only safe columns
  /callable by any logged-in user \(check it\) \| public\.name_problem/,    // only returns a message
];
const findings = (await audit(db)).filter((f) => !ALLOWED.some((a) => a.test(f)));
check("audit: no unexpected database problems", findings.length === 0, "\n    " + findings.join("\n    "));

const peek = await as(db, "authenticated", USER_B, `select email, coins from public.profiles where id = $1`, [USER_A]);
check("player B can't read player A's email or coins", (peek.rows?.length ?? 0) === 0, peek);
for (const col of ["is_admin = true", "coins = 999999", "best_score = 999999"]) {
  const r = await as(db, "authenticated", USER_A, `update public.profiles set ${col} where id = $1`, [USER_A]);
  check(`player can't set ${col}`, !!r.error, r);
}
for (const col of ["is_admin", "coins", "best_score"]) {
  check(`layer 1: players have no permission to change ${col}`, !(await canUpdateColumn(db, "authenticated", "public.profiles", col)));
}
const score = await as(db, "authenticated", USER_A, `insert into public.scores (user_id, score) values ($1, 99999999)`, [USER_A]);
check("player can't write a score directly", !!score.error, score);
const coins = await as(db, "authenticated", USER_A, `select public.add_coins($1, 99999)`, [USER_A]);
check("player can't call add_coins", !!coins.error, coins);
const anonCoins = await as(db, "anon", null, `select public.add_coins($1, 99999)`, [USER_A]);
check("visitor can't call add_coins", !!anonCoins.error, anonCoins);
const anon = await as(db, "anon", null, `select * from public.profiles`);
check("logged-out visitors see no profiles", !!anon.error || anon.rows.length === 0, anon);
const board = await as(db, "anon", null, `select user_id from public.leaderboard`);
check("leaderboard never reveals user ids", !!board.error, board);

summary();
