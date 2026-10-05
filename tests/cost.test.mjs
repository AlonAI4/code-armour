// Tests scripts/armour-cost.mjs with a FAKE ~/.claude folder: ranking, totals, "used" guesses, free skills,
// symlinks, plugins on/off, MCP servers, read-only, and that fake secrets NEVER appear in the output.
import { mkdtempSync, mkdirSync, writeFileSync, readFileSync, symlinkSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

let passed = 0, failed = 0;
const check = (n, ok, d = "") => { ok ? passed++ : failed++; console.log(`${ok ? "✓" : "✗"} ${n}${ok ? "" : "  -> " + String(d).slice(0, 300)}`); };
const SCRIPT = fileURLToPath(new URL("../scripts/armour-cost.mjs", import.meta.url));
const T = mkdtempSync(join(tmpdir(), "ca-cost-")), H = join(T, "home"), P = join(T, "project"), C = join(H, ".claude");
const w = (p, s) => { mkdirSync(join(p, ".."), { recursive: true }); writeFileSync(p, s); };
const skill = (dir, name, desc, extra = "") => w(join(dir, name, "SKILL.md"), `---\nname: ${name}\ndescription: ${desc}\n${extra}---\nbody\n`);

// fake secrets, built at run time (never written literally in this file)
const GH = "ghp_" + "FAKEfakeFAKEfake" + "1234567890abcdefABCD";
const SK = "sk-proj-" + "FAKEsecretvalue" + "123456789";
skill(join(C, "skills"), "big-skill", "x".repeat(800));
skill(join(C, "skills"), "used-skill", "a short one");
skill(join(C, "skills"), "free-skill", "y".repeat(900), "disable-model-invocation: true\n");
skill(join(T, "elsewhere"), "linked-skill", "z".repeat(200));
symlinkSync(join(T, "elsewhere", "linked-skill"), join(C, "skills", "linked-skill"));
const PLUG = join(C, "plugins", "cache", "market", "fakeplug", "1.0");
skill(join(PLUG, "skills"), "plug-skill", "p".repeat(400));
w(join(PLUG, "commands", "do-thing.md"), "---\ndescription: does a thing\n---\n");
w(join(PLUG, ".mcp.json"), JSON.stringify({ mcpServers: { plugmcp: { command: "x" } } }));
w(join(C, "plugins", "installed_plugins.json"), JSON.stringify({ version: 2, plugins: {
  "fakeplug@market": [{ installPath: PLUG }], "offplug@market": [{ installPath: join(T, "nowhere") }] } }));
w(join(C, "settings.json"), JSON.stringify({ env: { GITHUB_TOKEN: GH }, enabledPlugins: { "fakeplug@market": true, "offplug@market": false } }, null, 1));
w(join(H, ".claude.json"), JSON.stringify({ mcpServers: { myserver: { command: "x", env: { API_KEY: SK } } } }, null, 1));
w(join(C, "agents", "helper.md"), "---\nname: helper\ndescription: " + "h".repeat(120) + "\n---\n");
w(join(C, "CLAUDE.md"), "# rules\n" + "r".repeat(400));
w(join(P, "CLAUDE.md"), "Use the used-skill for exports.\n");
w(join(P, "data", "huge.json"), JSON.stringify({ rows: "q".repeat(40000) }));
const before = readFileSync(join(C, "settings.json"), "utf8");

const run = (...a) => execFileSync(process.execPath, [SCRIPT, "--home", H, "--project", P, ...a], { encoding: "utf8" });
const text = run(), j = JSON.parse(run("--json"));
const it = (name) => j.items.find((x) => x.item === name);

check("ranked biggest first", j.items.every((x, i) => i === 0 || j.items[i - 1].tokens >= x.tokens), j.items.map((x) => x.tokens));
check("the biggest item is first in the table", /\| 1 \| big-skill \|/.test(text), text.split("\n").slice(4, 7).join("\n"));
check("total = sum of every per-message item", j.total === j.items.reduce((s, x) => s + x.tokens, 0), j.total);
check("after = total - saving, saving = the 'no (guess)' items", j.after === j.total - j.saving && j.saving === j.items.filter((x) => /^no/.test(x.used)).reduce((s, x) => s + x.tokens, 0), JSON.stringify([j.total, j.after, j.saving]));
check("a skill named in the project counts as used", it("used-skill")?.used === "yes", JSON.stringify(it("used-skill")));
check("an unmentioned skill is 'no (guess)' with a suggestion", it("big-skill")?.used === "no (guess)" && /disable-model-invocation/.test(it("big-skill").suggestion));
check("disable-model-invocation skills cost nothing and are listed separately", !it("free-skill") && j.freeSkills.some((x) => x.startsWith("free-skill")), j.freeSkills);
check("follows symlinked skills", !!it("linked-skill"));
check("an enabled plugin is measured (its skill + command)", it("fakeplug@market")?.tokens > 100, JSON.stringify(it("fakeplug@market")));
check("a disabled plugin is not counted", !it("offplug@market"));
check("MCP servers listed with tokens 'unknown' (user + plugin)", j.unknown.some((x) => x.item === "myserver") && j.unknown.some((x) => x.item.startsWith("plugmcp")), JSON.stringify(j.unknown));
check("agents and CLAUDE.md files are counted", !!it("helper") && j.items.some((x) => x.type === "CLAUDE.md"));
check("biggest project files listed (cost when read)", /huge\.json/.test(text));
check("every figure is labelled an estimate", /ESTIMATES \(characters ÷ 4\)/.test(text) && /\(est\.\)/.test(text));
check("points to /context and /skill-doctor", /\/context/.test(text) && /\/skill-doctor/.test(text));
check("warns about the token in settings.json by file and line", /settings\.json line \d+: looks like a ghp key/.test(text), text.slice(-600));
check("warns about the key in .claude.json", /\.claude\.json line \d+/.test(text));
check("the fake GitHub token NEVER appears (text or JSON)", !text.includes(GH) && !run("--json").includes(GH) && !text.includes("FAKEfakeFAKEfake"));
check("the fake API key NEVER appears (text or JSON)", !text.includes(SK) && !run("--json").includes(SK) && !text.includes("FAKEsecretvalue"));
check("read-only: settings.json unchanged", readFileSync(join(C, "settings.json"), "utf8") === before);
check("says nothing was changed", /Nothing was changed/.test(text));

console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
