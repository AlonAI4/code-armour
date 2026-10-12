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

let r = run(project(good(), cov(), "| Emails | ✅ 🔧 | F-001 fixed |\n| Column grants | ❓ 🔧 | F-002 hardening |\n| EU VAT | ❓ 📋 | F-004 |\n| Under-13 accounts | ❓ ⚖️ Professional advice recommended | F-005 |\n"));
check("the example findings + coverage pass", r.ok && /1 rejected/.test(r.out), r.out);
check("the pass line counts each category", /2 confirmed technical, 0 to verify, 1 compliance, 1 professional advice/.test(r.out), r.out);

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
// review 5 Oct: "/tmp/ca-find-abc-evil" passed a startsWith("/tmp/ca-find-abc") check
{ const d = project(good(), cov()); const ev = d + "-evil"; mkdirSync(ev, { recursive: true }); writeFileSync(join(ev, "x.sql"), "a\nb\nc\nd\n");
  f = good(); f.findings[0].evidence.file = "../" + d.split(/[\\/]/).pop() + "-evil/x.sql"; writeFileSync(join(d, ".code-armour/findings.json"), JSON.stringify(f));
  r = run(d); check("evidence in a sibling folder with the same name start is refused", !r.ok && /outside the project/.test(r.out), r.out); }

r = run(project(good(), cov(), "| Leaderboard | ❌ | F-003 |\n")); check("COMPLIANCE.md can't cite a rejected finding", !r.ok && /was rejected/.test(r.out), r.out);
r = run(project(good(), cov(), "| Something | ❌ | F-099 |\n")); check("COMPLIANCE.md can't cite a finding that doesn't exist", !r.ok && /isn't in findings.json/.test(r.out), r.out);
f = good(); f.findings[0].verdict = "needs_validation";
r = run(project(f, cov(), "| Emails | ❌ | F-001 |\n")); check("an unverified finding must be ❓ in COMPLIANCE.md", !r.ok && /must be ❓/.test(r.out), r.out);
f = good(); f.findings[0].fix_status = "open";
r = run(project(f, cov(), "| Emails | ✅ | F-001 |\n")); check("an open finding can't be ticked ✅", !r.ok && /still open/.test(r.out), r.out);

// ---- the 4 finding categories ----
f = good(); delete f.findings[0].category;
r = run(project(f, cov())); check("version 2: a finding with no category is refused", !r.ok && /category must be one of/.test(r.out), r.out);
f = good(); f.version = 1; f.findings = f.findings.slice(0, 3); for (const x of f.findings) delete x.category; // an old file, as written before categories
r = run(project(f, cov())); check("version 1 (older copies): no category only warns, naming the likely one", r.ok && /⚠ .*F-001.*confirmed_technical/.test(r.out), r.out);
f = good(); f.findings[0].category = "maybe";
r = run(project(f, cov())); check("an unknown category is refused", !r.ok && /category must be one of/.test(r.out), r.out);
f = good(); f.findings[0].verdict = "needs_validation";
r = run(project(f, cov())); check("confirmed_technical with verdict needs_validation is refused", !r.ok && /confirmed_technical needs verdict 'confirmed'/.test(r.out), r.out);
f = good(); f.findings[0].category = "needs_verification";
r = run(project(f, cov())); check("needs_verification with verdict confirmed is refused", !r.ok && /needs_verification needs verdict 'needs_validation'/.test(r.out), r.out);
f = good(); f.findings[0].area = "legal-pages";
r = run(project(f, cov())); check("a legal-pages finding can't be confirmed_technical", !r.ok && /'legal-pages' must be compliance_consideration or professional_advice/.test(r.out), r.out);
f = good(); f.findings[3].category = "needs_verification";
r = run(project(f, cov())); check("a countries finding can't be needs_verification", !r.ok && /'countries' must be compliance_consideration/.test(r.out), r.out);
f = good(); f.findings[1].category = "needs_verification"; f.findings[1].verdict = "needs_validation";
r = run(project(f, cov())); check("a hardening note must be confirmed_technical", !r.ok && /hardening note must be confirmed_technical/.test(r.out), r.out);
f = good(); delete f.findings[3].basis;
r = run(project(f, cov())); check("a compliance consideration needs 'basis' (reference + research date)", !r.ok && /needs 'basis'/.test(r.out), r.out);
f = good(); delete f.findings[4].trigger;
r = run(project(f, cov())); check("professional advice needs 'trigger' (why it may apply)", !r.ok && /needs 'trigger'/.test(r.out), r.out);
f = good(); f.findings[3].fix_status = "fixed";
r = run(project(f, cov())); check("a compliance consideration can never be 'fixed'", !r.ok && /never 'fixed'/.test(r.out), r.out);
f = good(); f.findings[3].evidence = { file: "src/made-up.js" };
r = run(project(f, cov())); check("a compliance finding's evidence, if given, is still checked", !r.ok && /does not exist/.test(r.out), r.out);
f = good(); f.findings[4].category = "compliance_consideration";
r = run(project(f, cov())); check("a sensitive topic (child-under-13-data) must be professional_advice", !r.ok && /needs category professional_advice/.test(r.out), r.out);
f = good(); delete f.findings[4].who;
r = run(project(f, cov())); check("a sensitive topic needs 'who' to ask", !r.ok && /needs 'who'/.test(r.out), r.out);
r = run(project(good(), cov(), "| EU VAT | ✅ 📋 | F-004 |\n")); check("COMPLIANCE.md: a compliance finding's row can never be ✅", !r.ok && /can never be ✅/.test(r.out), r.out);
r = run(project(good(), cov(), "| Emails | ✅ | F-001 fixed |\n")); check("COMPLIANCE.md: a row citing a finding must show its category", !r.ok && /needs its category on the row/.test(r.out), r.out);

let c = cov(); delete c.runs[0].areas["prompt-injection"];
r = run(project(good(), c)); check("coverage must mention every area (n/a allowed)", !r.ok && /prompt-injection/.test(r.out), r.out);
c = cov(); c.runs[0].areas.auth = "kinda";
r = run(project(good(), c)); check("coverage values are checked", !r.ok && /must be one of/.test(r.out), r.out);
r = run(project(null, cov())); check("a missing findings.json is reported", !r.ok && /findings.json is missing/.test(r.out), r.out);
r = run(project("{not json", cov())); check("broken JSON is reported, not crashed on", !r.ok && /not valid JSON/.test(r.out), r.out);

// The COMPLIANCE.md template carries the validator's row rules, and a first draft written from its example lines passes.
const TPL = readFileSync(new URL("../templates/COMPLIANCE.md", import.meta.url), "utf8");
const examples = TPL.match(/"- (?:🔧|🔍|📋|⚖️)[^"]*"/g) || [];
check("the template has an example line for each kind of finding (fixed, open, to verify, compliance, advice)", examples.length === 5, examples.join(" | "));
f = good();
f.findings.push({ id: "F-006", title: "Sign-up may have no rate limit", area: "auth", severity: "medium", verdict: "needs_validation",
  category: "needs_verification", evidence: { file: "supabase/migrations/001_init.sql", line: 1 } });
const ids = ["F-001", "F-002", "F-006", "F-004", "F-005"];   // fixed 🔧, open 🔧, 🔍, 📋, ⚖️: the order the template lists them
const draft = examples.map((e, i) => e.slice(1, -1).replace("F-NNN", ids[i])).join("\n");
r = run(project(f, cov(), TPL + "\n" + draft + "\n"));
check("a first draft written from the template's example lines passes the validator", r.ok, r.out);
r = run(project(f, cov(), TPL + "\n" + draft.replace("🔧 ❌ F-002", "🔧 ✅ F-002") + "\n"));
check("…and breaking a template rule (✅ on an open finding) is still refused", !r.ok && /still open/.test(r.out), r.out);
for (const rule of ["Never cite a rejected finding", "must contain ❓", "no ✅ anywhere on that line", "can never contain ✅"])
  check(`the template states the rule: ${rule}`, TPL.includes(rule));

console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
