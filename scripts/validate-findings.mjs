#!/usr/bin/env node
// Code Armour findings validator. Zero dependencies. Keeps made-up or unproven findings out of COMPLIANCE.md.
//   node validate-findings.mjs [project-dir]      (reads .code-armour/findings.json and .code-armour/coverage.json)
// Exit 1 with a list of problems if anything is wrong.
import { readFileSync, existsSync } from "node:fs";
import { join, resolve } from "node:path";

const dir = resolve(process.argv[2] || ".");
const AREAS = ["auth", "database-rules", "payments", "uploads", "ai-features", "prompt-injection", "supply-chain",
  "secrets", "hosting-headers", "kids-privacy", "legal-pages", "countries"];
const SEVERITY = ["critical", "high", "medium", "low", "hardening"];
const VERDICT = ["confirmed", "needs_validation", "rejected"];
const FIX = ["open", "fixed", "accepted"];
const COVER = ["checked", "partial", "not_checked", "n/a"];
const errors = [];
const err = (m) => errors.push(m);
const str = (v) => typeof v === "string" && v.trim().length > 0;

function load(rel) {
  const p = join(dir, rel);
  if (!existsSync(p)) return undefined;
  try { return JSON.parse(readFileSync(p, "utf8")); } catch (e) { err(`${rel}: not valid JSON (${e.message})`); return null; }
}

// ---------- findings ----------
const f = load(".code-armour/findings.json");
const byId = new Map();
if (f === undefined) err(".code-armour/findings.json is missing (every run writes it, even with zero findings)");
else if (f) {
  if (f.version !== 1) err("findings.json: version must be 1");
  if (!Array.isArray(f.findings)) err("findings.json: 'findings' must be a list");
  for (const [i, x] of (f.findings || []).entries()) {
    const at = `finding #${i + 1}${x && x.id ? ` (${x.id})` : ""}`;
    if (!x || typeof x !== "object") { err(`${at}: not an object`); continue; }
    if (!/^F-\d{3,}$/.test(x.id || "")) err(`${at}: id must look like F-001`);
    else if (byId.has(x.id)) err(`${at}: duplicate id`);
    else byId.set(x.id, x);
    if (!str(x.title)) err(`${at}: title missing`);
    if (!AREAS.includes(x.area)) err(`${at}: area must be one of ${AREAS.join(", ")}`);
    if (!SEVERITY.includes(x.severity)) err(`${at}: severity must be one of ${SEVERITY.join(", ")}`);
    if (!VERDICT.includes(x.verdict)) err(`${at}: verdict must be one of ${VERDICT.join(", ")}`);
    if (x.verdict === "rejected") { if (!str(x.reason)) err(`${at}: a rejected finding needs a 'reason' (why it isn't real)`); continue; }
    // confirmed and needs_validation both need real evidence
    const ev = x.evidence;
    if (!ev || typeof ev !== "object" || (!str(ev.file) && !str(ev.command))) {
      err(`${at}: evidence missing (give {file, line} or {command, output})`);
    } else if (str(ev.file)) {
      const p = resolve(dir, ev.file);
      if (!p.startsWith(dir)) err(`${at}: evidence file is outside the project`);
      else if (!existsSync(p)) err(`${at}: evidence file ${ev.file} does not exist (made-up finding?)`);
      else if (ev.line != null) {
        const n = readFileSync(p, "utf8").split("\n").length;
        if (!Number.isInteger(ev.line) || ev.line < 1 || ev.line > n) err(`${at}: evidence line ${ev.line} is not in ${ev.file} (${n} lines)`);
      }
    } else if (!str(ev.output)) err(`${at}: command evidence needs its 'output'`);
    if (x.verdict === "confirmed") {
      if (!str(x.attack)) err(`${at}: a confirmed finding needs 'attack' (what an attacker does)`);
      if (!str(x.disproof)) err(`${at}: a confirmed finding needs 'disproof' (what the fresh attempt to disprove it tried, and why it failed)`);
      if (!FIX.includes(x.fix_status)) err(`${at}: fix_status must be one of ${FIX.join(", ")}`);
      if (x.fix_status === "fixed" && !str(x.proof)) err(`${at}: 'fixed' needs 'proof' (the security-tests check or command that now passes)`);
      if (x.fix_status === "accepted" && !str(x.reason)) err(`${at}: 'accepted' needs a 'reason'`);
      if (x.severity === "hardening" && !str(x.blocked_by)) err(`${at}: a hardening note needs 'blocked_by' (the layer that already stops the attack)`);
    }
  }
}

// ---------- coverage ledger ----------
const c = load(".code-armour/coverage.json");
if (c === undefined) err(".code-armour/coverage.json is missing (record which areas this run checked)");
else if (c) {
  if (c.version !== 1 || !Array.isArray(c.runs) || !c.runs.length) err("coverage.json: needs version 1 and at least one run");
  for (const [i, r] of (c.runs || []).entries()) {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(r.date || "")) err(`coverage run #${i + 1}: date must be YYYY-MM-DD`);
    for (const [a, v] of Object.entries(r.areas || {})) {
      if (!AREAS.includes(a)) err(`coverage run #${i + 1}: unknown area '${a}'`);
      if (!COVER.includes(v)) err(`coverage run #${i + 1}: '${a}' must be one of ${COVER.join(", ")}`);
    }
  }
  const last = (c.runs || []).at(-1);
  if (last) {
    const missing = AREAS.filter((a) => !(a in (last.areas || {})));
    if (missing.length) err(`latest coverage run doesn't say anything about: ${missing.join(", ")} (use n/a if it doesn't apply)`);
  }
}

// ---------- COMPLIANCE.md may only cite real, confirmed findings ----------
const cp = join(dir, "COMPLIANCE.md");
if (existsSync(cp) && f) {
  const lines = readFileSync(cp, "utf8").split("\n");
  lines.forEach((line, i) => {
    for (const id of line.match(/\bF-\d{3,}\b/g) || []) {
      const x = byId.get(id);
      if (!x) err(`COMPLIANCE.md line ${i + 1}: cites ${id}, which isn't in findings.json`);
      else if (x.verdict === "rejected") err(`COMPLIANCE.md line ${i + 1}: cites ${id}, which was rejected (not a real problem)`);
      else if (x.verdict === "needs_validation" && !line.includes("❓")) err(`COMPLIANCE.md line ${i + 1}: ${id} is unverified, so its row must be ❓`);
      else if (x.verdict === "confirmed" && x.fix_status === "fixed" && line.includes("✅") === false && line.includes("❌")) err(`COMPLIANCE.md line ${i + 1}: ${id} is fixed and proven, but the row says ❌`);
      else if (x.verdict === "confirmed" && x.fix_status === "open" && line.includes("✅")) err(`COMPLIANCE.md line ${i + 1}: ${id} is still open, but the row says ✅`);
    }
  });
}

if (errors.length) {
  console.log(`✗ findings check failed (${errors.length}):`);
  for (const e of errors) console.log("  - " + e);
  process.exit(1);
}
const all = [...byId.values()];
const n = (v) => all.filter((x) => x.verdict === v).length;
console.log(`✓ findings check passed: ${n("confirmed")} confirmed, ${n("needs_validation")} need validation, ${n("rejected")} rejected; coverage ledger OK`);
