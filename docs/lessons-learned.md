# ck-skills Lessons Learned

Running log of non-obvious findings, gotchas, and decisions made while
building and maintaining this marketplace.

---

## Plugin System

### plugin.json and manifest.json coexist — but schema conflicts
**Date:** 2026-03-18  
**Context:** Adding `sdd-project-init` with Copilot CLI support.

Claude Code validates **both** `manifest.json` and `plugin.json` when both
are present in a plugin directory. Copilot CLI-specific fields (`skills`,
`agents`, `hooks`) in `plugin.json` cause Claude Code's validator to fail
with `Invalid input`.

**Rule:** Keep `plugin.json` to shared metadata-only fields:
`name`, `description`, `version`, `author`, `license`, `keywords`.  
Let `manifest.json` carry all Claude Code-specific fields.  
Copilot-specific path fields (`skills`, `agents`) are not safe to include
until Claude Code confirms it ignores unknown fields.

---

### Marketplace cache is not auto-refreshed on install
**Date:** 2026-03-18  
**Context:** `claude plugin install sdd-project-init@ck-skills` failed with
"Plugin not found" even though `marketplace.json` on GitHub was correct.

Claude Code caches the marketplace registry at install time. Adding a new
plugin to `marketplace.json` and pushing to GitHub does not automatically
invalidate the cache.

**Fix:** After pushing a new plugin to the marketplace:
```bash
rm -rf ~/.claude/plugins/cache/ck-skills
claude plugin marketplace add github:kimcharli/ck-skills
claude plugin install <new-plugin>@ck-skills
```

Or if `marketplace refresh` is available in the installed Claude Code version:
```bash
claude plugin marketplace refresh ck-skills
```

---

## Copilot CLI Plugin System

### Copilot CLI has a full plugin system — not just copilot-instructions.md
**Date:** 2026-03-18  
**Context:** Initial assumption was that Copilot only reads `.github/copilot-instructions.md`.

As of GA (February 2026), Copilot CLI supports:
- `copilot plugin marketplace add <org/repo>`
- `copilot plugin install <name>@<marketplace>`
- Reads `marketplace.json` from `.github/plugin/` **or** `.claude-plugin/` — so
  ck-skills' existing `.claude-plugin/marketplace.json` works for both tools.

**Rule:** ck-skills marketplace is shared between Claude Code and Copilot CLI.
Always test install on both tools when adding a new plugin.

---

### Gemini CLI has no plugin system
**Date:** 2026-03-18  
**Context:** Checking equivalence across Claude Code, Copilot CLI, Gemini CLI.

Gemini CLI reads `GEMINI.md` in the project root only. There is no
`gemini plugin install` equivalent. Skills generate `GEMINI.md` as output;
they cannot be installed into Gemini CLI itself.

---

## SDD Structure

### specs/ vs docs/ separation
**Date:** 2026-03-18  
**Context:** `sdd-project-init` template design.

`specs/` = AI process artifacts (requirements, design, tasks) — Claude reads/writes frequently.  
`docs/` = stable human reference — rarely updated, narrative content.  
Mixing them in `docs/` blurs the boundary and makes AI context noisier.

### Steering docs (product.md, tech.md, structure.md) are redundant with AGENTS.md
**Date:** 2026-03-18  
**Context:** ck-apstra-tool had all three from an earlier scaffold.

For solo projects, these duplicate `AGENTS.md` sections with no benefit.
Delete them and keep everything in `AGENTS.md`. Splitting only makes sense
in team settings where different people own different docs.
