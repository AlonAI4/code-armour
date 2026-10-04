// Tests recipes/firebase/firestore.rules in the real Firestore emulator (needs Java).
// Run: npx firebase emulators:exec --only firestore --project demo-armour "node firestore.test.mjs [rules-file]"
import { initializeTestEnvironment, assertFails, assertSucceeds } from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc, updateDoc } from "firebase/firestore";
import { readFileSync } from "node:fs";

const rulesFile = process.argv[2] || new URL("../recipes/firebase/firestore.rules", import.meta.url);
const env = await initializeTestEnvironment({
  projectId: "demo-armour",
  firestore: { rules: readFileSync(rulesFile, "utf8"), host: "127.0.0.1", port: 8089 },
});
let passed = 0, failed = 0;
async function check(name, p) {
  try { await p; passed++; console.log("✓ " + name); }
  catch (e) { failed++; console.log("✗ " + name + "  -> " + (e.message || e).toString().slice(0, 120)); }
}
const A = env.authenticatedContext("alice").firestore();
const B = env.authenticatedContext("bob").firestore();
const anon = env.unauthenticatedContext().firestore();
await env.withSecurityRulesDisabled(async (ctx) => {
  await setDoc(doc(ctx.firestore(), "users/alice"), { displayName: "Alice", isAdmin: false, credits: 0 });
  await setDoc(doc(ctx.firestore(), "leaderboard/1"), { displayName: "Alice", score: 10 });
});

await check("owner can change their display name", assertSucceeds(updateDoc(doc(A, "users/alice"), { displayName: "AliceB" })));
await check("owner CAN'T make themselves admin", assertFails(updateDoc(doc(A, "users/alice"), { isAdmin: true })));
await check("owner CAN'T give themselves credits", assertFails(updateDoc(doc(A, "users/alice"), { credits: 99999 })));
await check("owner CAN'T overwrite profile with setDoc to add powers", assertFails(setDoc(doc(A, "users/alice"), { displayName: "Alice", isAdmin: true })));
await check("new profile CAN'T start as admin", assertFails(setDoc(doc(B, "users/bob"), { displayName: "Bobby", isAdmin: true })));
await check("new profile with a normal name works", assertSucceeds(setDoc(doc(B, "users/bob"), { displayName: "Bobby" })));
await check("look-alike letters rejected in names", assertFails(updateDoc(doc(A, "users/alice"), { displayName: "bаdword" })));
await check("user B CAN'T read user A's profile", assertFails(getDoc(doc(B, "users/alice"))));
await check("owner can use their own sub-collections", assertSucceeds(setDoc(doc(A, "users/alice/notes/n1"), { text: "hi" })));
await check("user B CAN'T write into A's sub-collections", assertFails(setDoc(doc(B, "users/alice/notes/n2"), { text: "hacked" })));
await check("anyone can read the leaderboard", assertSucceeds(getDoc(doc(anon, "leaderboard/1"))));
await check("nobody can write the leaderboard from the app", assertFails(setDoc(doc(A, "leaderboard/2"), { displayName: "cheat", score: 9e9 })));

await env.cleanup();
console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
