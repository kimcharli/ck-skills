# Agent Context Architecture: Generic vs. Repo-Specific Guidelines

**Target Repository:** `ck-skills`
**Document Path:** `docs/gemini-argon-agent-guide.md`
**Date:** October 18, 2026

______________________________________________________________________

## 1. Core Principle

**`AGENTS.md` must remain strictly repository-specific and operational (\<150 lines).**
Universal coding philosophies and behavioral rules belong one level up—either in global user configurations (`~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md`) or in a single canonical `CONSTITUTION.md` inside `ck-skills`.

Placing generic rules inside every repository's `AGENTS.md` causes version drift across projects and taxes the context window on every turn. Placing repo-specific build commands in secondary files causes agents to hallucinate test runners or break repository invariants.

______________________________________________________________________

## 2. The 5-Layer Context Hierarchy

Structure agent instructions from permanent, universal truths down to ephemeral session state:

| Layer | Location | Scope & Load Behavior | What Belongs Here |
| :- | :- | :- | :- |
| **1. Global / Constitution** | `~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md`, or `ck-skills/CONSTITUTION.md` | **Universal.** Loaded globally or via single pointer. | How you work everywhere: `uv` for Python, `ruff` formatting, atomic commits, ask before destructive git ops or adding dependencies, verify via tests before completion. |
| **2. Repo Root `AGENTS.md`** | `./AGENTS.md` (with `./CLAUDE.md` containing `@AGENTS.md`) | **Repo-Wide.** Auto-loaded on every turn (~150 lines max). | Repo purpose, exact build/test/lint commands, high-level directory map, fragile repo invariants, SDD workflow hooks, and conditional pointers to Layer 4. |
| **3. Subsystem `AGENTS.md`** | Nested directories (`skills/AGENTS.md`, `agents/AGENTS.md`) | **Directory-Scoped.** Loaded only when working in that subtree. | Local architectural rules, schema requirements, or naming conventions specific to that subfolder. |
| **4. On-Demand Docs & Skills** | `docs/agents/*.md`, `specs/`, `skills/*/SKILL.md` | **Task-Triggered.** Linked from root; loaded only when needed. | Multi-step procedural workflows (`SKILL.md`), deep architectural rationale, external API specifications. |
| **5. Session State** | `specs/NEXT.md` | **Ephemeral.** Read/updated at task boundaries. | Current in-flight tasks, active migration status, short-term blockers. **Never put session state in `AGENTS.md`.** |

______________________________________________________________________

## 3. The 6-Step Placement Sieve

Before adding any rule to `AGENTS.md`, run it sequentially through these six questions. **The first "Yes" dictates where the rule lives:**

1. **Would this still be true in a different repository?**
   → Move to **Layer 1** (Global config or `ck-skills/CONSTITUTION.md`).
1. **Can a linter, formatter, test, or git hook enforce it deterministically?**
   → Configure it in **Tooling** (`pyproject.toml`, `ruff`, pre-commit) and **delete the prose rule**. Never spend tokens on rules a machine can enforce for free.
1. **Will this information be stale in two weeks?**
   → Move to **Layer 5** (`specs/NEXT.md` or active feature spec).
1. **Is it a repeatable, multi-step procedure?**
   → Encapsulate it as an executable **Skill** (`SKILL.md`), not static prose.
1. **Is it only needed for specific types of tasks?**
   → Move to **Layer 4** (`docs/agents/<topic>.md`) and place a one-line conditional trigger in `AGENTS.md` (*"When modifying X, read Y"*).
1. **Is it needed on almost every task in this repository?**
   → Keep it in **Layer 2** (Root `AGENTS.md`).

______________________________________________________________________

## 4. What Goes Where: Reference Matrix

| Category | Layer 1: Universal Constitution (`CONSTITUTION.md`) | Layer 2: Repo-Specific Root (`AGENTS.md`) |
| :- | :- | :- |
| **Workflow & Execution** | • Plan before multi-file edits.<br>• Run tests before declaring work complete.<br>• Make small, atomic commits; never force-push. | • Exact install, build, lint, and test commands.<br>• Local dev environment startup quirks.<br>• SDD workflow hooks (where specs live, how to update `NEXT.md`). |
| **Code & Architecture** | • Prefer functional patterns and explicit error handling.<br>• Comment the *why*, never the *what*.<br>• Do not introduce new dependencies without asking. | • High-level directory map of the project.<br>• Domain-specific framework or plugin patterns.<br>• Custom internal libraries to use instead of standard ones. |
| **Invariants & Guardrails** | • Never commit secrets, `.env` files, or credentials.<br>• Ask for clarification when requirements are ambiguous. | • "Never touch" legacy or auto-generated files.<br>• Strict manifest schemas or file-naming rules the loader depends on. |

______________________________________________________________________

## 5. Anatomy of a Lean Repo `AGENTS.md` (\<150 Lines)

Use this exact blueprint for each repository's root `AGENTS.md`:

```markdown
# AGENTS.md — [Repository Name]

## 1. Purpose
[One concise paragraph explaining what this repository does and who/what consumes it.]

## 2. Shared Constitution
- Follow the universal behavioral rules in `~/Projects/ck-skills/CONSTITUTION.md`.
- *(Note: If your CLI environment does not automatically expand `@` imports, explicitly read `~/Projects/ck-skills/CONSTITUTION.md` before executing multi-file changes.)*

## 3. Commands (Run Before Declaring Done)
- **Install / Sync:** `uv sync`
- **Test All:** `uv run pytest`
- **Test Single File:** `uv run pytest tests/path/to/test_file.py`
- **Lint & Format:** `uv run ruff check . && uv run ruff format --check .`

## 4. Directory Layout
- `agents/` — Agent definitions and role configurations
- `skills/` — Modular `SKILL.md` capabilities and scripts
- `specs/` — Feature specifications and `NEXT.md` session state
- `docs/agents/` — Deep-dive reference docs loaded on demand

## 5. Repo Invariants (Do Not Break)
- **Manifest Schema:** Never alter required frontmatter keys in `SKILL.md` without updating the validator.
- **Generated Files:** Do not hand-edit files inside `[path/to/generated]`.
- **State Separation:** Never log in-flight task progress in `AGENTS.md`; update `specs/NEXT.md`.

## 6. Workflow & On-Demand Pointers
- **Session State:** Read `specs/NEXT.md` at session start; update it when completing a milestone.
- **Adding a Skill:** Read `skills/AGENTS.md` before creating or modifying skills.
- **Architecture Deep Dive:** When modifying core loader logic, read `docs/agents/architecture.md`.
-
```
