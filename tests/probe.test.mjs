// Tests scripts/supabase-probe.mjs against a fake Supabase server: it must find the open doors,
// stay read-only (no PATCH/PUT/DELETE, POST only for the GraphQL read query), and refuse a service-role key.
import http from "node:http";
import { execFile } from "node:child_process";
// Async on purpose: a blocking call would freeze this process, and the fake server lives in it.
const run = (args) => new Promise((res) => execFile(process.execPath, args, { encoding: "utf8" }, (e, stdout) => res({ out: stdout, code: e ? e.code : 0 })));
import { fileURLToPath } from "node:url";

let passed = 0, failed = 0;
const check = (n, ok, d = "") => { ok ? passed++ : failed++; console.log(`${ok ? "✓" : "✗"} ${n}${ok ? "" : "  -> " + d}`); };
const PROBE = fileURLToPath(new URL("../scripts/supabase-probe.mjs", import.meta.url));
const seen = [];
let hidden = false; // newer Supabase projects hide the table list (/rest/v1/) from public keys
const server = http.createServer((req, res) => {
  seen.push(`${req.method} ${req.url.split("?")[0]}`);
  const json = (code, body, h = {}) => { res.writeHead(code, { "content-type": "application/json", ...h }); res.end(JSON.stringify(body)); };
  const u = req.url.split("?")[0];
  if (u === "/rest/v1/") return hidden ? json(401, { message: "hidden" }) : json(200, { paths: { "/": {}, "/profiles": {}, "/scores": {}, "/secrets": {}, "/players": {}, "/settings": {}, "/rpc/add_coins": {} } });
  if (u === "/rest/v1/settings") return json(200, [{ key: "shop", description: "x", membership: "y", ip_address: "1.2.3.4" }]);
  if (u === "/rest/v1/players") return json(206, [{ id: 7, name: "Striker" }], { "content-range": "0-0/900" });
  if (u === "/rest/v1/profiles") return json(200, [{ id: 1, email: "kid@school.com", coins: 5 }], { "content-range": "0-0/42" });
  if (u === "/rest/v1/scores") return json(200, []);
  if (u === "/rest/v1/secrets") return json(401, { message: "permission denied" });
  if (u === "/storage/v1/bucket") return json(200, [{ id: "avatars", public: true, file_size_limit: null, allowed_mime_types: null }, { id: "ids", public: false }]);
  if (u === "/auth/v1/settings") return json(200, { mailer_autoconfirm: true, disable_signup: false, external: { email: true, google: true } });
  if (u === "/graphql/v1") return json(200, { data: { __schema: { queryType: { fields: [{ name: "profilesCollection" }] } } } });
  json(404, {});
});
await new Promise((r) => server.listen(0, "127.0.0.1", r));
const base = `http://127.0.0.1:${server.address().port}`;

const { out, code } = await run([PROBE, base, "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiYW5vbiJ9.x"]);
check("finds a table anyone can read, with its sensitive columns", /ANYONE can read "profiles" \(42 rows/.test(out) && /sensitive-looking columns: email, coins/.test(out), out);
check("an empty or RLS-filtered table isn't flagged", /"scores": no rows visible/.test(out));
check("a blocked table is reported as blocked", /"secrets": blocked for the public \(HTTP 401\)/.test(out));
check("warns about a callable database function", /"add_coins" can be called by anyone/.test(out));
check("warns about a public bucket with no limits", /Bucket "avatars" is PUBLIC/.test(out) && /"avatars" has no size or file-type limit/.test(out));
check("flags email confirmation turned off", /Email confirmation is OFF/.test(out));
check("warns that GraphQL shows its schema", /GraphQL shows its schema/.test(out));
check("exit code 1 when doors are open", code === 1, code);
const writes = seen.filter((s) => /^(PATCH|PUT|DELETE)/.test(s) || (s.startsWith("POST") && s !== "POST /graphql/v1"));
check("read-only: never sends a write request", writes.length === 0, writes.join(", "));

check("sensitive columns: a plain 'key' or words containing 'ip' aren't flagged", /"settings"[\s\S]*?sensitive-looking columns: ip_address\n/.test(out), out);
check("HTTP 206 (partial content) counts as readable, not blocked", /ANYONE can read "players"/.test(out), out);

hidden = true;
const { out: blind, code: blindCode } = await run([PROBE, base, "sb_publishable_abc"]);
check("hidden table list: says NO tables were checked, never 'No open doors'", /NO tables were checked/.test(blind) && !/No open doors/.test(blind), blind);
const { mkdtempSync, writeFileSync, mkdirSync } = await import("node:fs");
const { tmpdir } = await import("node:os");
const proj = mkdtempSync(tmpdir() + "/probe-");
mkdirSync(proj + "/src"); mkdirSync(proj + "/node_modules");
writeFileSync(proj + "/src/db.ts", `supabase.from('profiles').select(); supabase.rpc('add_coins', { n: 1 })`);
writeFileSync(proj + "/node_modules/lib.js", `x.from('not_mine')`);
const { out: fromCode } = await run([PROBE, base, "sb_publishable_abc", proj]);
check("hidden table list + project folder: tests the tables the code uses", /ANYONE can read "profiles"/.test(fromCode) && /"add_coins" can be called/.test(fromCode), fromCode);
check("…and skips node_modules", !/not_mine/.test(fromCode), fromCode);
hidden = false;

const { out: refused } = await run([PROBE, base, "sb_secret_abcdefghijklmnop"]);
check("refuses a secret/service-role key", /SERVICE ROLE \/ SECRET key/.test(refused), refused);
server.close();
console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
