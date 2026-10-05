// Tests scripts/validate-findings.mjs: real findings pass; made-up, unproven or miscited ones are refused.
import { mkdtempSync, mkdirSync, writeFileSync, readFileSync, cpSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

let passed = 0, failed = 0;
const check = (n, ok, d = "") => { ok ? passed++ : failed++; console.log(`${ok ? "✓" : "✗"} ${n}${ok ? "" : "  -> " + d}`); };
const V = fileURLToPath(new URL("../scripts/validate-findings.mjs", import.meta.url));
const EX = (f) => JSON.parse(readFileSync(new URL(`../templates/code-armour/${f}`, import.meta.url), "utf8"));
function project(findings, coverage, compliance) {
  const d = mkdtempSync(join(tmpdir(), "ca-find-"));
  mkdirSync(join(d, ".code-armour")); mkdirSync(join(d, "supabase/migrations"), { recursive: true });
  writeFileSync(join(d, "supabase/migrations/001_init.sql"), "a\nb\nc\ncreate policy p on profiles for select using (true);\n");
  writeFileSync(join(d, "supabase/migrations/002_code_armour.sql"), "create trigger protect_privileged_columns ...\n");
  if (findings !== null) writeFileSync(join(d, ".code-armour/findings.json"), typeof findings === "string" ? findings : JSON.stringify(findings));
  if (coverage !== null) writeFileSync(join(d, ".code-armour/coverage.json"), JSON.stringify(coverage));
  if (compliance) writeFileSync(join(d, "COMPLIANCE.md"), compliance);
  return d;
}
function run(d) { try { return { ok: true, out: execFileSync(process.execPath, [V, d], { encoding: "utf8" }) }; } catch (e) { return { ok: false, out: e.stdout }; } }
const good = () => structuredClone(EX("findings.example.json"));
const cov = () => structuredClone(EX("coverage.example.json"));

let r = run(project(good(), cov(), "| Emails | ✅ | F-001 fixed |\n| Column grants | ❓ | F-002 hardening |\n"));
check("the example findings + coverage pass", r.ok && /1 rejected/.test(r.out), r.out);

let f = good(); f.findings[0].evidence.file = "src/does-not-exist.js";
r = run(project(f, cov())); check("a finding pointing at a file that doesn't exist is refused (made-up)", !r.ok && /does not exist/.test(r.out), r.out);
f = good(); f.findings[0].evidence.line = 999;
r = run(project(f, cov())); check("a line number that isn't in the file is refused", !r.ok && /line 999 is not in/.test(r.out), r.out);
f = good(); delete f.findings[0].evidence;
r = run(project(f, cov())); check("a finding with no evidence is refused", !r.ok && /evidence missing/.test(r.out), r.out);
f = good(); delete f.findings[0].disproof;
r = run(project(f, cov())); check("confirmed without a disprove attempt is refused", !r.ok && /needs 'disproof'/.test(r.out), r.out);
f = good(); delete f.findings[0].proof;
r = run(project(f, cov())); check("'fixed' without a proving test is refused", !r.ok && /needs 'proof'/.test(r.out), r.out);
f = good(); delete f.findings[1].blocked_by;
r = run(project(f, cov())); check("a hardening note must name the layer that already blocks the attack", !r.ok && /blocked_by/.test(r.out), r.out);
f = good(); delete f.findings[2].reason;
r = run(project(f, cov())); check("a rejected finding needs a reason", !r.ok && /needs a 'reason'/.test(r.out), r.out);
f = good(); f.findings[1].id = "F-001";
r = run(project(f, cov())); check("duplicate ids are refused", !r.ok && /duplicate id/.test(r.out), r.out);
f = good(); f.findings[0].verdict = "probably";
r = run(project(f, cov())); check("only confirmed / needs_validation / rejected are allowed", !r.ok && /verdict must be/.test(r.out), r.out);
f = good(); f.findings[0].evidence.file = "../../etc/passwd";
r = run(project(f, cov())); check("evidence outside the project is refused", !r.ok && /outside the project/.test(r.out), r.out);

r = run(project(good(), cov(), "| Leaderboard | ❌ | F-003 |\n")); check("COMPLIANCE.md can't cite a rejected finding", !r.ok && /was rejected/.test(r.out), r.out);
r = run(project(good(), cov(), "| Something | ❌ | F-099 |\n")); check("COMPLIANCE.md can't cite a finding that doesn't exist", !r.ok && /isn't in findings.json/.test(r.out), r.out);
f = good(); f.findings[0].verdict = "needs_validation";
r = run(project(f, cov(), "| Emails | ❌ | F-001 |\n")); check("an unverified finding must be ❓ in COMPLIANCE.md", !r.ok && /must be ❓/.test(r.out), r.out);
f = good(); f.findings[0].fix_status = "open";
r = run(project(f, cov(), "| Emails | ✅ | F-001 |\n")); check("an open finding can't be ticked ✅", !r.ok && /still open/.test(r.out), r.out);

let c = cov(); delete c.runs[0].areas["prompt-injection"];
r = run(project(good(), c)); check("coverage must mention every area (n/a allowed)", !r.ok && /prompt-injection/.test(r.out), r.out);
c = cov(); c.runs[0].areas.auth = "kinda";
r = run(project(good(), c)); check("coverage values are checked", !r.ok && /must be one of/.test(r.out), r.out);
r = run(project(null, cov())); check("a missing findings.json is reported", !r.ok && /findings.json is missing/.test(r.out), r.out);
r = run(project("{not json", cov())); check("broken JSON is reported, not crashed on", !r.ok && /not valid JSON/.test(r.out), r.out);

console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
