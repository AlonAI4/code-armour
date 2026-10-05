#!/usr/bin/env node
// Code Armour: Supabase "front door" probe. Looks at YOUR Supabase project the way an attacker would: with only the
// public anon/publishable key that ships inside your website. READ-ONLY: it never inserts, updates or deletes anything.
// Only run it on a project you own.
//   node supabase-probe.mjs https://YOURPROJECT.supabase.co <anon-or-publishable-key> [project-dir]
// Newer Supabase projects hide the table list from public keys; give the project folder and the probe tries
// every table and function the code uses (.from('x') / .rpc('x')) instead.
// Exit code 1 if anyone can read data or something important is open.

import { readdirSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";
const [url, key, projectDir] = process.argv.slice(2);
if (!url || !key) {
  console.log("Usage: node supabase-probe.mjs https://YOURPROJECT.supabase.co <anon-or-publishable-key>");
  process.exit(2);
}
if (/service_role|sb_secret_/.test(key) || /InJvbGUiOiJzZXJ2aWNlX3Jv|b2xlIjoic2VydmljZV9yb2xl|cm9sZSI6InNlcnZpY2Vfcm9s/.test(key)) {
  console.log("✗ That's a SERVICE ROLE / SECRET key. Use the public anon/publishable key (the one in your website).");
  console.log("  And if that secret key is anywhere in your frontend, that's the real problem: rotate it now.");
  process.exit(1);
}
const base = url.replace(/\/+$/, "");
const headers = { apikey: key, Authorization: `Bearer ${key}`, Accept: "application/json" };
let problems = 0;
const bad = (m) => { problems++; console.log("✗ " + m); };
const warn = (m) => console.log("? " + m);
const ok = (m) => console.log("✓ " + m);
async function get(path, extra = {}) {
  try {
    const r = await fetch(base + path, { headers: { ...headers, ...extra }, signal: AbortSignal.timeout(15000) });
    let body = null; const text = await r.text();
    try { body = JSON.parse(text); } catch { body = text; }
    return { status: r.status, body, headers: r.headers };
  } catch (e) { return { status: 0, body: String(e.message || e) }; }
}

// Table and function names the project's code uses (skips node_modules, build output and huge files).
function namesFromCode(dir) {
  const tables = new Set(), rpcs = new Set();
  const walk = (d) => {
    for (const e of readdirSync(d, { withFileTypes: true })) {
      if (/^(node_modules|\.git|dist|build|\.next|out)$/.test(e.name)) continue;
      const p = join(d, e.name);
      if (e.isDirectory()) walk(p);
      else if (/\.(m?[jt]sx?|vue|svelte)$/.test(e.name) && statSync(p).size < 1e6) {
        const src = readFileSync(p, "utf8");
        for (const m of src.matchAll(/\.from\(\s*['"`]([A-Za-z0-9_]+)['"`]\s*\)/g)) tables.add(m[1]);
        for (const m of src.matchAll(/\.rpc\(\s*['"`]([A-Za-z0-9_]+)['"`]/g)) rpcs.add(m[1]);
      }
    }
  };
  walk(dir);
  return { tables: [...tables].sort(), rpcs: [...rpcs].sort() };
}

console.log(`== Supabase front-door probe: ${base} (read-only, public key only) ==`);

// 1. What the public API exposes (PostgREST OpenAPI)
const spec = await get("/rest/v1/");
let tables = null, rpcs = [];
if (spec.status === 200 && typeof spec.body === "object") {
  const paths = Object.keys(spec.body.paths || {});
  tables = paths.filter((p) => p !== "/" && !p.startsWith("/rpc/")).map((p) => p.slice(1));
  rpcs = paths.filter((p) => p.startsWith("/rpc/")).map((p) => p.slice(5));
} else if (projectDir) {
  ({ tables, rpcs } = namesFromCode(projectDir));
  console.log(`(The API description is hidden (HTTP ${spec.status}), so these names come from the code in ${projectDir}.)`);
} else {
  warn(`Couldn't read the API description (HTTP ${spec.status}), so NO tables were checked. Run again with the project folder as a third argument to check the tables the code uses.`);
}
if (tables) {
  console.log(`\n-- Tables and views reachable with the public key: ${tables.length} --`);
  for (const t of tables) {
    const r = await get(`/rest/v1/${encodeURIComponent(t)}?select=*&limit=3`, { Range: "0-2", Prefer: "count=exact" });
    const total = (r.headers?.get?.("content-range") || "").split("/")[1];
    const okStatus = r.status === 200 || r.status === 206; // 206 = "partial content": rows came back
    if (okStatus && Array.isArray(r.body) && r.body.length > 0) {
      const cols = Object.keys(r.body[0]);
      const sensitive = cols.filter((c) => /email|phone|address|birth|password|token|secret|(api|secret|private|access|service)_?key|^ip$|_ip$|ip_addr|stripe|admin|role|credit|coins|balance/i.test(c));
      bad(`ANYONE can read "${t}" (${total && total !== "*" ? total + " rows" : "rows"}; columns: ${cols.slice(0, 10).join(", ")}${cols.length > 10 ? ", …" : ""})` +
        (sensitive.length ? `\n    including sensitive-looking columns: ${sensitive.join(", ")}` : "") +
        `\n    If this is meant to be public, make sure ONLY public columns are readable (security.md 2.5, safe-leaderboard.sql).`);
    } else if (okStatus) ok(`"${t}": no rows visible to the public (empty, or RLS hides them)`);
    else ok(`"${t}": blocked for the public (HTTP ${r.status})`);
  }
  console.log(`\n-- Database functions callable over the API: ${rpcs.length} --`);
  for (const f of rpcs) warn(`"${f}" can be called by anyone with the public key. It must check who's calling, or be revoked from anon (audit.sql #8). Not called by this probe.`);
  if (!rpcs.length) ok("No functions exposed");
}

// 2. Storage buckets
console.log("\n-- Storage --");
const b = await get("/storage/v1/bucket");
if (b.status === 200 && Array.isArray(b.body)) {
  if (!b.body.length) ok("No buckets visible to the public");
  for (const x of b.body) {
    if (x.public) warn(`Bucket "${x.id}" is PUBLIC: every file in it can be downloaded by URL. Fine for game art; never for user uploads or IDs (security.md 2.7).`);
    else ok(`Bucket "${x.id}" is private`);
    if (x.public && (x.file_size_limit == null || x.allowed_mime_types == null)) warn(`Bucket "${x.id}" has no size or file-type limit (security.md 4.6).`);
  }
} else ok(`Bucket list not visible to the public (HTTP ${b.status})`);

// 3. Auth settings (public endpoint)
console.log("\n-- Sign-up and login settings --");
const a = await get("/auth/v1/settings");
if (a.status === 200 && typeof a.body === "object") {
  const s = a.body;
  if (s.mailer_autoconfirm) bad("Email confirmation is OFF: anyone can sign up as someone else's email address (security.md 3.5). Turn on 'Confirm email'.");
  else ok("Email confirmation is on");
  if (s.disable_signup) ok("Public sign-up is disabled");
  else warn("Anyone can create an account: make sure CAPTCHA and rate limits are on (security.md 6.4).");
  const providers = Object.entries(s.external || {}).filter(([, v]) => v === true).map(([k]) => k);
  if (providers.length) console.log("  Login methods on: " + providers.join(", "));
  if (s.phone_autoconfirm || (s.external || {}).phone) warn("Phone/SMS login is on: watch for SMS-pumping bills (security.md 6.4).");
} else warn(`Couldn't read auth settings (HTTP ${a.status}).`);

// 4. GraphQL schema exposure (a read-only introspection query)
console.log("\n-- GraphQL --");
try {
  const r = await fetch(base + "/graphql/v1", {
    method: "POST", headers: { ...headers, "Content-Type": "application/json" },
    body: JSON.stringify({ query: "{ __schema { queryType { fields { name } } } }" }), signal: AbortSignal.timeout(15000),
  });
  const j = await r.json().catch(() => ({}));
  const fields = j?.data?.__schema?.queryType?.fields;
  if (fields?.length) warn(`GraphQL shows its schema to the public (${fields.length} query fields). If you don't use GraphQL: drop extension pg_graphql (security.md 16.4).`);
  else ok("GraphQL schema not shown to the public");
} catch { ok("GraphQL not reachable"); }

console.log(problems ? `\n${problems} problem(s): anyone on the internet can do the things marked ✗.`
  : tables ? "\nNo open doors found with the public key. (Still run audit.sql and the Security Advisor: this probe only sees what's reachable from outside.)"
  : "\nTables NOT checked (see above), so this is not a clean result.");
process.exit(problems ? 1 : 0);
