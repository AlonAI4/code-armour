// Code Armour attack tests for projects WITHOUT a database (static sites, browser extensions, MCP servers,
// CLIs, games). Plain Node, no packages. Re-run: bash security-tests/run.sh
// >>> The skill replaces the examples with this project's real checks. Each must FAIL if the protection goes.
import { readFileSync, existsSync } from "node:fs";
import { Worker } from "node:worker_threads";

let passed = 0, failed = 0;
const check = (name, ok, detail = "") => { ok ? passed++ : failed++; console.log(`${ok ? "✓" : "✗"} ${name}${ok ? "" : "  -> " + detail}`); };

// Runs `code` in a separate thread and stops it after `ms`. Use for slow-regex (ReDoS) and huge-input checks:
// a hang becomes a failed check instead of a frozen test run.
export function finishesWithin(ms, code) {
  return new Promise((resolve) => {
    const w = new Worker(code, { eval: true });
    const t = setTimeout(() => { w.terminate(); resolve(false); }, ms);
    w.on("exit", () => { clearTimeout(t); resolve(true); });
    w.on("error", () => { clearTimeout(t); resolve(true); });   // threw quickly: not a hang
  });
}

// Example 1: browser extension asks for the fewest permissions.
// const m = JSON.parse(readFileSync("extension/manifest.json", "utf8"));
// check("extension doesn't ask for all websites", !JSON.stringify(m).includes("<all_urls>"));

// Example 2: pasting a huge weird input can't freeze the app (slow regex / ReDoS).
// check("4,000 spaces processed in under 2 s", await finishesWithin(2000,
//   `import("${new URL("../src/engine.js", import.meta.url).href}").then(E => E.process(" ".repeat(4000)))`));

// Example 3: the escape function really escapes.
// const { esc } = await import("../src/util.js");
// check("esc() blocks an HTML injection", !esc('<img src=x onerror=alert(1)>').includes("<img"));

console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
