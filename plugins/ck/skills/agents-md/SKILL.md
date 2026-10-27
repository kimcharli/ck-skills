---
name: agents-md
description: >-
  Audit, write, split, or wire up global and repo-level AGENTS.md, CLAUDE.md,
  GEMINI.md, and .github/copilot-instructions.md. Enforces the 5-layer context
  hierarchy, the 6-step placement sieve (personal vs. team vs. repo vs. tooling
  vs. session state), the <150-line repo budget, and thin tool-pointer wrappers
  across Claude Code, Gemini CLI, and GitHub Copilot. Use when creating,
  editing, reviewing, or slimming AGENTS.md / CLAUDE.md / GEMINI.md, setting up
  global ~/.agents/AGENTS.md sharing, or checking a repo's agent instruction
  hygiene.
---

# Global & Repo `AGENTS.md` Hygiene

Keep repo `AGENTS.md` files strictly repo-specific and operational (`<=150` lines). Keep personal cross-repo preferences in one canonical global file (`~/.agents/AGENTS.md`) imported or symlinked by each tool.

## 1. The 5-Layer Context Hierarchy

Place every instruction in the lowest-cost layer that fits its scope:

| Layer | Location | Scope & Load Behavior | What Belongs Here |
| -- | -- | -- | -- |
| **1. Global / Personal** | `~/.agents/AGENTS.md` (imported by `~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md`, symlinked by `~/.copilot/copilot-instructions.md`) | **Universal personal.** Loaded in every repo. | How *you* work everywhere: lazy senior dev / smallest complete change, `uv` for Python, commit style, ask before destructive git ops or new deps, test before done, terse output with 1-2 line risk/skipped footer. |
| **2. Repo Root `AGENTS.md`** | `./AGENTS.md` (with thin pointers or symlinks from `./CLAUDE.md`, `./GEMINI.md`, `.github/copilot-instructions.md`) | **Repo-wide.** Auto-loaded on every turn (`<=150` lines). | Repo purpose, exact build/test/lint commands, directory map, fragile repo invariants, SDD workflow hooks, team standards, conditional pointers to Layer 4. |
| **3. Subsystem `AGENTS.md`** | Nested directories (`skills/AGENTS.md`, `packages/*/AGENTS.md`) | **Directory-scoped.** Loaded only when working in that subtree. | Local architectural rules, schema requirements, or naming conventions specific to that subfolder. |
| **4. On-Demand Docs & Skills** | `docs/agents/*.md`, `specs/`, `skills/*/SKILL.md` | **Task-triggered.** Linked from root; loaded only when needed. | Multi-step procedural workflows (`SKILL.md`), deep architectural rationale, external API specs. |
| **5. Session State** | `specs/NEXT.md` | **Ephemeral.** Read/updated at task boundaries. | Current in-flight tasks, active migration status, short-term blockers. **Never put session state in `AGENTS.md`.** |

### Personal vs. Team Generic Rules

- **Personal preferences** (how *you* work) go in `~/.agents/AGENTS.md`. Collaborators do not need them.
- **Team standards** (rules collaborators and CI agents must follow on a fresh clone) stay in the repo (either in `AGENTS.md` if short, or in a shared constitution referenced by `AGENTS.md`).

## 2. The 6-Step Placement Sieve

Run every proposed rule sequentially through these six questions. **The first "Yes" decides where the rule lives:**

1. **Would this still be true in a different repo, and is it only yours?**
   -> Move to **Layer 1** (`~/.agents/AGENTS.md`).
1. **Can a linter, formatter, test, or git hook enforce it deterministically?**
   -> Configure it in **Tooling** (`pyproject.toml`, `ruff`, pre-commit, convention guard) and **delete the prose rule**.
1. **Will this information be stale in two weeks?**
   -> Move to **Layer 5** (`specs/NEXT.md` or active feature spec).
1. **Is it a repeatable, multi-step procedure?**
   -> Package it as a **Skill** (`SKILL.md`), not static prose in `AGENTS.md`.
1. **Is it only needed for specific types of tasks?**
   -> Move to **Layer 4** (`docs/agents/<topic>.md` or `specs/project.md`) and add a one-line conditional pointer in `AGENTS.md` (*"Touching X: read `path/to/doc.md`"*).
1. **Is it needed on almost every task in this repo?**
   -> Keep it in **Layer 2** (root `./AGENTS.md`).

## 3. Global Sharing Layout (`~/.agents/AGENTS.md`)

Keep one canonical personal file **outside** `~/.claude` and `~/.gemini` (avoids tool-specific coupling and Claude Code `@` import bugs inside `~/.claude`).

Use the bundled canonical template at `templates/global-AGENTS.md` (merging [Ponytail](https://github.com/dietrichgebert/ponytail/blob/main/AGENTS.md)'s "lazy senior developer" / smallest-complete-change discipline with verification, safety, git, STE-style communication, and `uv`/`mise` defaults) by copying or symlinking it to `~/.agents/AGENTS.md`:

```sh
mkdir -p ~/.agents
ln -sf ~/Projects/ck-skills/plugins/ck/skills/agents-md/templates/global-AGENTS.md ~/.agents/AGENTS.md
```

```text
~/.agents/AGENTS.md                  # canonical personal rules (tool-neutral)
~/.claude/CLAUDE.md                  # thin wrapper: imports canonical + Claude-only rules
~/.gemini/GEMINI.md                  # thin wrapper: imports canonical + Gemini-only rules
~/.copilot/copilot-instructions.md   # symlink -> ~/.agents/AGENTS.md
```

### Tool Wrappers

- **Claude Code (`~/.claude/CLAUDE.md`)**:

  ```markdown
  @~/.agents/AGENTS.md

  ## Claude-specific
  - (hooks, subagent conventions, anything only Claude Code understands)
  ```

- **Gemini CLI (`~/.gemini/GEMINI.md`)**:
  Use an **absolute path** (Gemini's import processor does not expand `~` or `$HOME`). If Gemini blocks imports outside `~/.gemini/`, symlink `~/.gemini/AGENTS.md -> ~/.agents/AGENTS.md` and use `@./AGENTS.md`:

  ```markdown
  @/Users/<you>/.agents/AGENTS.md

  ## Gemini-specific
  - (anything only Gemini CLI understands)
  ```

- **GitHub Copilot CLI (`~/.copilot/copilot-instructions.md`)**:
  Does not expand `@path` imports; symlink directly:

  ```sh
  ln -s ~/.agents/AGENTS.md ~/.copilot/copilot-instructions.md
  ```

### Verification Commands

- **Claude Code**: `/memory` or `/context` -> confirm `~/.agents/AGENTS.md` is listed.
- **Gemini CLI**: `/memory reload` then `/memory show` -> confirm canonical rules appear.

## 4. Repo-Level Blueprint (`<=150` Lines)

A repo's root `AGENTS.md` should contain only these sections:

1. **Purpose**: 1 concise paragraph on what the repo does and who consumes it.
1. **Commands**: Exact install, test, lint, and run commands. Never make the agent hunt for these.
1. **Layout**: Short map of directories that matter (or pointer to `specs/project.md`).
1. **Invariants**: High-cost traps specific to this repo (manifest schemas, generated files never to hand-edit, tool gotchas like bare `mdformat`).
1. **Workflow Hooks**: Where specs live, SDD gates, when to update `specs/NEXT.md`, definition of done.
1. **Conditional Pointers**: Routing to on-demand docs (`Touching X: read Y`). Never use unconditional "read X first" hops if the content belongs in `AGENTS.md`.

### Repo Tool Pointers (`CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`)

Keep repo-level tool files as either:

- **Symlinks** to `AGENTS.md` (`ln -s AGENTS.md CLAUDE.md`), or
- **Thin pointers** (`<=20` lines) that reference `AGENTS.md` (`@AGENTS.md` or "Read `AGENTS.md`") with zero duplicated rules.

## 5. Audit & Refactoring Checklist

When asked to audit or update a repo's `AGENTS.md` (or global setup):

1. **Measure**: Check line count of `./AGENTS.md` (target `<=150` lines; `<=90` in strict scaffolds) and check whether `CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` exist and are thin pointers (`<=20` lines) or symlinks to `AGENTS.md`.
1. **Classify every section** of `./AGENTS.md` using the 6-Step Placement Sieve:
   - Flag personal rules to move to `~/.agents/AGENTS.md`.
   - Flag linter/formatter prose to replace with pre-commit/tooling config.
   - Flag stale/in-flight task notes to move to `specs/NEXT.md`.
   - Flag long multi-step procedures or deep reference material to extract to a skill or `docs/agents/<topic>.md` behind a conditional pointer.
1. **Check global wiring** (if requested): inspect `~/.agents/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md`, and `~/.copilot/copilot-instructions.md` for drift or broken `@` imports.
1. **Propose before rewriting**: Show the user a concise table of what stays in `./AGENTS.md`, what moves where, and the exact diff before applying destructive cuts.
