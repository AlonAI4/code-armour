---
description: Show what in your Claude Code setup costs the most tokens on every message, and what you could turn off. Read-only.
argument-hint: "[project folder]"
---
Show this person what their Claude Code setup sends with **every** message. Skills, plugins, MCP servers, CLAUDE.md files, memory and agents all cost tokens each time, so a beginner (or a parent) can see what to turn off.

1. Run `node <code-armour skill folder>/scripts/armour-cost.mjs --project ${ARGUMENTS:-.}`. The skill folder is usually `~/code-armour`. The script is read-only, makes no network calls and needs no packages.
2. Show its table as it is: biggest first, every number labelled an estimate (characters ÷ 4). Then explain in plain words:
   - the **total now** vs **after** turning off the items marked "no (guess)", and the saving per message;
   - "used recently" is a **guess**: "no" only means the name never appears in this project or the CLAUDE.md files;
   - skills with `disable-model-invocation: true` cost nothing until typed, which is the best way to keep a rarely used skill;
   - synced skills come from claude.ai and are turned off there, not by editing files;
   - MCP tool counts can't be measured without connecting: `/context` shows them;
   - for exact numbers: `/context` (this chat) and `/skill-doctor` (skills).
3. **Secrets:** if the script lists possible secrets, repeat **only** the file and line it gives. **Never open those lines or print the value.** Say what to do: move the value somewhere safer (the system keychain, or an env var set outside Claude's settings), and rotate it if it was ever shared or committed.
4. **Never turn anything off without asking.** Ask which items, by name. On a yes, change **only** what was named, and show the edited line. For example:
   - a plugin: `"name@marketplace": false` in the settings file the table names;
   - one of your own skills: add `disable-model-invocation: true` to its SKILL.md frontmatter.
5. End with one line: *Code Armour is an AI-run checklist that lowers risk. It's not legal advice or a professional audit, guarantees nothing, and its makers aren't responsible for what happens after you use it.*
