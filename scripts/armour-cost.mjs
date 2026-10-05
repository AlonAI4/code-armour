#!/usr/bin/env node
// Code Armour /armourcost: what in your Claude Code setup costs the most tokens on EVERY message.
// READ-ONLY, no network, no packages. Every number is an ESTIMATE (characters / 4).
// For exact numbers use /context (what's in this chat) and /skill-doctor (skills).
//   node armour-cost.mjs [--home DIR] [--project DIR] [--json]
// --home defaults to your home folder (Claude settings in DIR/.claude, DIR/.claude.json); --project to here.
import { readFileSync, existsSync, readdirSync, statSync, realpathSync } from "node:fs";
import { join, basename, dirname, resolve, relative, sep } from "node:path";
import { homedir } from "node:os";

const arg = (k) => { const i = process.argv.indexOf(k); return i > 0 ? process.argv[i + 1] : undefined; };
const HOME = resolve(arg("--home") || homedir());
const CLAUDE = process.env.CLAUDE_CONFIG_DIR && !arg("--home") ? resolve(process.env.CLAUDE_CONFIG_DIR) : join(HOME, ".claude");
const PROJECT = resolve(arg("--project") || process.cwd());
const JSON_OUT = process.argv.includes("--json");
const tok = (s) => Math.ceil(String(s || "").length / 4);
const read = (p) => { try { return readFileSync(p, "utf8"); } catch { return null; } };
const readJson = (p) => { const t = read(p); if (t == null) return null; try { return JSON.parse(t); } catch { return null; } };
const isDir = (p) => { try { return statSync(p).isDirectory(); } catch { return false; } };
const pretty = (p) => (p.startsWith(HOME + sep) ? "~/" + relative(HOME, p) : p).replace(/\/synced\/[^/]+\//, "/synced/…/");

// ---------- secrets: report file + line + field name only, NEVER the value ----------
const secretWarnings = [];
const SECRET_PREFIX = /(ghp_|gho_|ghu_|ghs_|github_pat_|sk-ant-|sk-proj-|sk-|sk_live_|sk_test_|rk_live_|xox[abprs]-|AKIA|AIza|sb_secret_|whsec_|glpat-|npm_)[A-Za-z0-9_-]{8,}/;
const SECRET_FIELD = /"([A-Za-z0-9_.-]*(token|secret|password|apikey|api_key|api-key|key))"\s*:\s*"([^"]{8,})"/i;
const ENV_FIELD = /^\s*([A-Za-z0-9_]*(TOKEN|SECRET|KEY|PASSWORD)[A-Za-z0-9_]*)\s*[=:]\s*["']?([^\s"']{8,})/i;
const scanned = new Set();
function scanSecrets(file) {
  if (scanned.has(file)) return; scanned.add(file);
  const t = read(file); if (t == null) return;
  t.split("\n").forEach((line, i) => {
    let why = null;
    const m = line.match(SECRET_PREFIX);
    if (m) why = `looks like a ${m[1].replace(/[-_]$/, "")} key`;
    else {
      const f = line.match(SECRET_FIELD) || line.match(ENV_FIELD);
      if (f && !/^(true|false|null|\$\{|<|your|xxx|example|placeholder|changeme)/i.test(f[3])) why = `field "${f[1]}" holds a value`;
    }
    if (why) secretWarnings.push(`${pretty(file)} line ${i + 1}: ${why} (value not shown)`);
  });
}

// ---------- frontmatter ----------
function frontmatter(text) {
  const m = /^---\r?\n([\s\S]*?)\r?\n---/.exec(text || ""); if (!m) return {};
  const out = {}; const lines = m[1].split("\n");
  for (let i = 0; i < lines.length; i++) {
    const kv = /^([A-Za-z0-9_-]+):\s*(.*)$/.exec(lines[i]); if (!kv) continue;
    let v = kv[2].trim();
    if (/^[>|][-+]?$/.test(v)) { const buf = []; while (i + 1 < lines.length && /^\s+\S|^\s*$/.test(lines[i + 1])) buf.push(lines[++i].trim()); v = buf.join(" ").trim(); }
    v = v.replace(/^["'](.*)["']$/s, "$1");
    out[kv[1]] = v;
  }
  return out;
}

// ---------- what the project mentions (for the "used recently?" guess) ----------
let corpus = "";
(function collect(d, depth) {
  if (depth > 6 || corpus.length > 8e6) return;
  let ents = []; try { ents = readdirSync(d, { withFileTypes: true }); } catch { return; }
  for (const e of ents) {
    if (["node_modules", ".git", "dist", "build", ".next", "out", ".venv", "venv"].includes(e.name)) continue;
    const p = join(d, e.name);
    if (e.isDirectory()) collect(p, depth + 1);
    else if (/\.(md|mdx|txt|json|js|mjs|cjs|ts|tsx|jsx|py|html|css|toml|ya?ml|sh)$/i.test(e.name)) {
      try { if (statSync(p).size < 500000) corpus += "\n" + readFileSync(p, "utf8").toLowerCase(); } catch {}
    }
  }
})(PROJECT, 0);
const claudeMdFiles = [];
for (let d = PROJECT; ; d = dirname(d)) {           // Claude Code loads CLAUDE.md from here up to /
  for (const f of ["CLAUDE.md", ".claude/CLAUDE.md"]) if (existsSync(join(d, f))) claudeMdFiles.push(join(d, f));
  if (d === dirname(d)) break;
}
if (existsSync(join(CLAUDE, "CLAUDE.md"))) claudeMdFiles.push(join(CLAUDE, "CLAUDE.md"));
const uniq = [...new Set(claudeMdFiles)];
for (const f of uniq) corpus += "\n" + (read(f) || "").toLowerCase();
const mentioned = (name) => {
  const n = String(name || "").toLowerCase(); if (!n) return false;
  const parts = [n, n.split(":").pop(), n.split("@")[0]].filter((x) => x.length >= 3);
  return parts.some((p) => corpus.includes(p));
};

// ---------- collect items ----------
const items = [];     // {item, type, tokens, used, suggestion, saving, off}
const freeSkills = []; // disable-model-invocation: true
const add = (o) => items.push({ used: "unknown", suggestion: "", saving: 0, ...o });

function skillEntry(file, type, owner) {
  const t = read(file); if (t == null) return;
  const fm = frontmatter(t);
  const name = fm.name || basename(dirname(file));
  if (String(fm["disable-model-invocation"]).toLowerCase() === "true") { freeSkills.push(`${name} (${type})`); return; }
  const cost = tok(`${name}: ${fm.description || ""}`) + 4;
  return { name, cost, file };
}
function findSkills(root, maxDepth = 5) {
  const out = []; const seen = new Set();
  (function walk(d, depth) {
    if (depth > maxDepth) return;
    let real; try { real = realpathSync(d); } catch { return; }
    if (seen.has(real)) return; seen.add(real);
    let ents = []; try { ents = readdirSync(d, { withFileTypes: true }); } catch { return; }
    if (ents.some((e) => e.name === "SKILL.md")) { out.push(join(d, "SKILL.md")); return; }
    for (const e of ents) {
      if (e.name === "node_modules" || e.name.startsWith(".git")) continue;
      const p = join(d, e.name);
      if (e.isDirectory() || (e.isSymbolicLink() && isDir(p))) walk(p, depth + 1);
    }
  })(root, 0);
  return out;
}

// 1. Your own skills (incl. symlinks and synced folders)
for (const root of [join(CLAUDE, "skills"), join(PROJECT, ".claude", "skills")]) {
  if (!isDir(root)) continue;
  for (const f of findSkills(root)) {
    scanSecrets(f);
    const synced = f.includes(`${sep}synced${sep}`);
    const s = skillEntry(f, synced ? "synced skill" : "skill"); if (!s) continue;
    const used = mentioned(s.name);
    add({ item: s.name, type: f.includes(`${sep}synced${sep}`) ? "synced skill" : (root.startsWith(PROJECT) ? "project skill" : "skill"), tokens: s.cost,
      used: used ? "yes" : "no (guess)", saving: used ? 0 : s.cost,
      suggestion: used ? "keep" : synced
        ? "synced from claude.ai: turn it off in claude.ai Settings (editing the file here gets overwritten)"
        : `add "disable-model-invocation: true" to ${pretty(f)} (still works when you type /${s.name})` });
  }
}
// 2. Your own commands
for (const root of [join(CLAUDE, "commands"), join(PROJECT, ".claude", "commands")]) {
  if (!isDir(root)) continue;
  for (const e of readdirSync(root)) if (e.endsWith(".md")) {
    const f = join(root, e); scanSecrets(f); const fm = frontmatter(read(f));
    const name = e.replace(/\.md$/, "");
    if (String(fm["disable-model-invocation"]).toLowerCase() === "true") { freeSkills.push(`/${name} (command)`); continue; }
    const cost = tok(`${name}: ${fm.description || ""}`) + 4; const used = mentioned(name);
    add({ item: "/" + name, type: "command", tokens: cost, used: used ? "yes" : "no (guess)", saving: 0, suggestion: "keep (small)" });
  }
}
// 3. Plugins (enabled in user or project settings)
const userSettings = join(CLAUDE, "settings.json"), projSettings = join(PROJECT, ".claude", "settings.json");
const enabled = {};
for (const sfile of [userSettings, projSettings]) {
  scanSecrets(sfile);
  const s = readJson(sfile); if (!s?.enabledPlugins) continue;
  for (const [k, v] of Object.entries(s.enabledPlugins)) enabled[k] = { on: v === true, file: sfile };
}
const installed = readJson(join(CLAUDE, "plugins", "installed_plugins.json"))?.plugins || {};
for (const [id, info] of Object.entries(enabled)) {
  if (!info.on) continue;
  const rec = Array.isArray(installed[id]) ? installed[id][0] : installed[id];
  const path = rec?.installPath;
  let cost = 0; const parts = [];
  if (path && isDir(path)) {
    for (const f of findSkills(path, 6)) { const s = skillEntry(f, "plugin skill"); if (s) { cost += s.cost; parts.push(s.name); } }
    for (const sub of ["commands", "agents"]) if (isDir(join(path, sub))) for (const e of readdirSync(join(path, sub))) if (e.endsWith(".md")) {
      const fm = frontmatter(read(join(path, sub, e)));
      if (String(fm["disable-model-invocation"]).toLowerCase() === "true") continue;
      cost += tok(`${e}: ${fm.description || ""}`) + 4; parts.push(e.replace(/\.md$/, ""));
    }
    const mcp = readJson(join(path, ".mcp.json"));
    if (mcp?.mcpServers || mcp) for (const name of Object.keys(mcp.mcpServers || mcp)) add({ item: `${name} (from ${id})`, type: "MCP server", tokens: null,
      used: mentioned(name) ? "yes" : "unknown", suggestion: "tool count unknown without connecting: see /context" });
  }
  const used = mentioned(id) || parts.some(mentioned);
  add({ item: id, type: `plugin (${parts.length} skills/commands/agents)`, tokens: path ? cost : null,
    used: used ? "yes" : "no (guess)", saving: used || !path ? 0 : cost,
    suggestion: used ? "keep" : `turn off: in ${pretty(info.file)} set "${id}": false` });
}
// 4. MCP servers (user + project)
const cj = join(HOME, ".claude.json"); scanSecrets(cj);
const cjson = readJson(cj) || {};
const mcpUser = Object.keys(cjson.mcpServers || {});
const mcpProj = Object.keys(cjson.projects?.[PROJECT]?.mcpServers || {});
const pm = join(PROJECT, ".mcp.json"); scanSecrets(pm);
const mcpFile = Object.keys(readJson(pm)?.mcpServers || {});
for (const [names, where] of [[mcpUser, "~/.claude.json (all projects)"], [mcpProj, "~/.claude.json (this project)"], [mcpFile, ".mcp.json"]])
  for (const n of names) add({ item: n, type: "MCP server", tokens: null, used: mentioned(n) ? "yes" : "unknown",
    suggestion: `tool count unknown without connecting: run /context. To remove: claude mcp remove ${n} (set in ${where})` });
// 5. CLAUDE.md files and memory (loaded every message)
for (const f of uniq) { scanSecrets(f); const t = read(f) || ""; const c = tok(t);
  add({ item: pretty(f), type: "CLAUDE.md", tokens: c, used: "yes (always loaded)", suggestion: c > 2000 ? "long: trim old or rarely needed parts" : "keep" }); }
const slug = PROJECT.replace(/[\/\\. ]/g, "-");
for (const mem of [join(CLAUDE, "projects", slug, "memory", "MEMORY.md")]) if (existsSync(mem)) {
  scanSecrets(mem); const c = tok(read(mem));
  add({ item: pretty(mem), type: "memory index", tokens: c, used: "yes (always loaded)", suggestion: c > 1500 ? "long: merge or delete stale memories" : "keep" });
}
// 6. Agents (their descriptions are sent so Claude can pick them)
for (const root of [join(CLAUDE, "agents"), join(PROJECT, ".claude", "agents")]) {
  if (!isDir(root)) continue;
  for (const e of readdirSync(root)) if (e.endsWith(".md")) {
    const f = join(root, e); scanSecrets(f); const fm = frontmatter(read(f));
    const name = fm.name || e.replace(/\.md$/, ""); const cost = tok(`${name}: ${fm.description || ""}`) + 4; const used = mentioned(name);
    add({ item: name, type: "agent", tokens: cost, used: used ? "yes" : "no (guess)", saving: used ? 0 : cost,
      suggestion: used ? "keep" : `move ${pretty(f)} out of the agents folder if you never use it` });
  }
}
// 7. Biggest project files (cost each time a chat READS them, not every message)
const big = [];
(function walk(d, depth) {
  if (depth > 8) return;
  let ents = []; try { ents = readdirSync(d, { withFileTypes: true }); } catch { return; }
  for (const e of ents) {
    if (["node_modules", ".git", "dist", "build", ".next", "out", ".venv", "venv", "coverage"].includes(e.name)) continue;
    const p = join(d, e.name);
    if (e.isDirectory()) walk(p, depth + 1);
    else if (e.isFile() && /\.(md|txt|json|js|mjs|cjs|ts|tsx|jsx|py|html|css|sql|ya?ml|csv)$/i.test(e.name)) { try { big.push({ p, size: statSync(p).size }); } catch {} }
  }
})(PROJECT, 0);
big.sort((a, b) => b.size - a.size);

// ---------- report ----------
const perMsg = items.filter((x) => typeof x.tokens === "number").sort((a, b) => b.tokens - a.tokens);
const unknown = items.filter((x) => x.tokens == null);
const total = perMsg.reduce((s, x) => s + x.tokens, 0);
const saving = perMsg.reduce((s, x) => s + (x.saving || 0), 0);
if (JSON_OUT) {
  console.log(JSON.stringify({ estimate: "characters / 4", total, after: total - saving, saving, items: perMsg, unknown, freeSkills, secretWarnings,
    biggestFiles: big.slice(0, 10).map((b) => ({ file: relative(PROJECT, b.p), tokensIfRead: Math.ceil(b.size / 4) })) }, null, 1));
  process.exit(0);
}
const fmt = (n) => "~" + n.toLocaleString("en-GB");
console.log(`== /armourcost: what your Claude Code setup sends with EVERY message ==`);
console.log(`All figures are ESTIMATES (characters ÷ 4). Exact numbers: /context (this chat) and /skill-doctor (skills).\n`);
console.log("| # | Item | Type | Tokens per message (est.) | Used recently? | Suggestion |");
console.log("|---|---|---|---|---|---|");
perMsg.forEach((x, i) => console.log(`| ${i + 1} | ${x.item} | ${x.type} | ${fmt(x.tokens)} | ${x.used} | ${x.suggestion} |`));
for (const x of unknown) console.log(`| – | ${x.item} | ${x.type} | unknown | ${x.used} | ${x.suggestion} |`);
console.log(`\n**Total now:** ${fmt(total)} tokens per message (est.)`);
console.log(`**If you turn off the items marked "no (guess)":** ${fmt(total - saving)} per message, saving ${fmt(saving)} (est.)`);
console.log(`"Used recently" is a GUESS: "no" only means its name never appears in this project or your CLAUDE.md files.`);
if (unknown.length) console.log(`MCP servers: how many tools each adds can't be counted without connecting to it. /context shows it.`);
if (freeSkills.length) console.log(`\nCost nothing until you type them (disable-model-invocation: true): ${freeSkills.join(", ")}`);
console.log(`\nBiggest files in this project (cost when a chat reads them, not every message):`);
for (const b of big.slice(0, 5)) console.log(`  ${fmt(Math.ceil(b.size / 4))} tokens  ${relative(PROJECT, b.p)}`);
if (secretWarnings.length) {
  console.log(`\n⚠️ Possible secrets in your settings (file and line only, values NOT shown). Move them to a safe place and rotate them if they were ever shared:`);
  for (const w of secretWarnings) console.log("  - " + w);
}
console.log(`\nNothing was changed. Ask before turning anything off.`);
console.log(`\nCode Armour is an AI-run checklist that lowers risk. It isn't legal advice or a professional security audit, guarantees nothing, and its authors aren't responsible if you get hacked, sued or fined.`);
