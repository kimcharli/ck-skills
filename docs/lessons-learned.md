# ck-skills Lessons Learned

Running log of non-obvious findings, gotchas, and decisions made while
building and maintaining this marketplace.

---

## Plugin System

### plugin.json must live inside .claude-plugin/ — not at plugin root

**Date:** 2026-03-18 (updated)
**Context:** `claude plugin install sdd-project-init@ck-skills` failed with
`skills: Invalid input`.

When `plugin.json` sits at the plugin root alongside a `commands/` directory,
`claude plugin install` auto-injects `"skills": ["commands/"]` into
`plugin.json`. That format is invalid and fails validation.

The fix: place the manifest at `.claude-plugin/plugin.json` (the same
structure used by working plugins like `claude-mem`). Claude Code then
auto-discovers `commands/*.md` without injecting a `skills` field.

**Rule:** Always use `.claude-plugin/plugin.json` — never a root-level
`plugin.json`. Keep the manifest to metadata-only fields:
`name`, `description`, `version`, `author`, `license`, `keywords`.
The `commands/` directory is auto-discovered; no `skills` field is needed.

### Command .md files need YAML frontmatter

**Date:** 2026-03-18
**Context:** `claude plugin validate` warned about missing frontmatter.

Command files in `commands/` should start with YAML frontmatter:

```markdown
---
name: init
description: Short description of what the command does
---
```

Without it, validation passes with a warning. With it, clean pass.

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
claude plugin marketplace update ck-skills
claude plugin install <new-plugin>@ck-skills
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

### Gemini CLI supports AGENTS.md (v0.28.0+)
**Date:** 2026-03-18  
**Context:** Consolidating AI steering files.

Gemini CLI (v0.28.0+) now reads `AGENTS.md` if `GEMINI.md` is missing. This
allows us to maintain a single "constitution" file that works across Claude
Code, Copilot, and Gemini CLI.

**Rule:** Use `AGENTS.md` as the single source of truth for AI instructions.
Avoid creating `GEMINI.md` or `.github/copilot-instructions.md` unless
tool-specific overrides are absolutely necessary.

---

### Copilot CLI supports AGENTS.md (v0.19.0+)
**Date:** 2026-03-18  
**Context:** Consolidating AI steering files.

GitHub Copilot CLI (v0.19.0+) honors `AGENTS.md` for project-level
instructions. This alignment with Claude Code's convention simplifies
repository management.

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
