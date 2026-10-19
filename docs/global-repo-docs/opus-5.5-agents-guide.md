# Structuring AGENTS.md: Generic vs Repo-Specific Rules

_As of 2026-10-18 · Charlie Kim (drafted with Claude Opus 5.5; incorporates the useful parts of a Gemini comparison)_

## Core recommendation

AGENTS.md should be mostly repo-specific. Generic rules belong one level up, not in a sibling file inside each repo.

AGENTS.md is the file agents auto-load for this repo. Generic rules placed there get copied into every repo and drift apart. They also cost context on every turn, often duplicating what the agent already gets from your global config.

## Layering

Five layers, from always-true-everywhere down to what is in flight right now.

| Layer | Where | What goes there |
| -- | -- | -- |
| Global / personal | `~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md`, Copilot user instructions, or a shared plugin like ck-skills | How you work in any repo: UV for Python, commit style, ask before destructive git ops, no new deps without asking, test before calling it done |
| Repo AGENTS.md (always loaded) | Repo root | What this repo is, build/test/lint commands, directory map, easy-to-break invariants, where specs live, the SDD workflow as it applies here, team standards |
| Subsystem AGENTS.md | Nested directories | Rules that only matter inside `skills/`, `agents/`, etc. |
| On-demand docs (linked, not loaded) | `docs/agents/*.md`, `specs/`, skills | Long procedures, design rationale, API notes; loaded only when a task touches them |
| Session state | `specs/NEXT.md` and similar | What is in flight; never in AGENTS.md |

## Personal vs team standards

"Generic" is really two buckets:

- **Personal preferences** (how _you_ like to work) go in your global config. Collaborators don't need them.
- **Team standards** (rules everyone agrees to, even if not repo-specific in content) go in the repo, because collaborators, CI agents, and fresh machines don't have your dotfiles.

## What belongs where

| Category | Generic (global layer) | Repo-specific (AGENTS.md) |
| -- | -- | -- |
| Workflow | Plan before multi-file changes; run tests before declaring done; small atomic commits; never force-push | Exact build, lint, test commands; migration commands; local dev startup quirks |
| Coding philosophy | Fail fast, no silent catches; comment the why, not the what | Framework conventions; state management choices; where things go |
| Guardrails | Never commit secrets or `.env`; no new deps without asking; ask when requirements are ambiguous | Legacy traps ("don't touch `src/legacy-billing`"); custom abstractions ("use `@/lib/logger`") |
| Output | Be concise; give full file paths | Domain naming conventions; PR template; branch naming |

Coding philosophy only goes in the global layer if you'd want it in every repo you touch. Something like "prefer functional patterns" can conflict with a codebase's conventions.

## Placement tests

Ask these in order; the first yes decides where a rule lives.

| Question | If yes, put it in |
| -- | -- |
| Would this still be true in a different repo, and is it only yours? | Global layer |
| Can a linter, formatter, test, or hook enforce it? | Tooling; drop the sentence |
| Will it be stale in two weeks? | `NEXT.md` or the spec |
| Is it a multi-step procedure? | A skill, not prose |
| Only needed for certain kinds of tasks? | A separate file, linked from AGENTS.md with a conditional pointer |
| Needed on almost every task here? | AGENTS.md |

## What a good repo AGENTS.md contains

Aim for under about 150 lines, short enough that you would reread it yourself.

1. **Purpose:** one paragraph on what the repo is and who consumes it.
1. **Commands:** exact install, test, lint, and run commands. This is the highest-value content; never make the agent hunt for it.
1. **Layout:** a short map of the directories that matter.
1. **Invariants:** the few "never do X here" rules from this repo's history, such as plugin manifest format, file naming the loader depends on, or generated files not to hand-edit.
1. **Workflow hooks:** where specs live, when to update `NEXT.md`, what "done" means here.
1. **Pointers:** conditional routing to on-demand docs (below).

## Routing to secondary files

Pointers should be conditional. If a file must be read on every task, its content belongs in AGENTS.md itself; an unconditional "read X first" adds a hop and the risk the agent skips it.

```markdown
## When to read more
- Touching skill manifests or the loader: read `docs/agents/skills.md`.
- Adding or changing a subagent: read `docs/agents/subagents.md`.
- Starting or resuming a feature: read `specs/NEXT.md`.
```

## Shared rules across repos

When generic or team rules must live in the repo:

- Keep them in one canonical place, for example a constitution file in ck-skills.
- Have each repo's AGENTS.md reference that place rather than copy it. Claude Code reads CLAUDE.md natively and supports `@path` imports, so a one-line `CLAUDE.md` containing `@AGENTS.md` is a common bridge.
- Check what Gemini CLI and Copilot actually load in your setup before relying on a shared include; support for AGENTS.md and imports varies by tool and version.

## Recommendation for ck-skills

Split the current AGENTS.md "behavioral constitution" in two:

- Move the universal behavioral rules into a shared constitution: personal parts in your global configs, team-wide parts in the plugin.
- Shrink each repo's AGENTS.md to the operational, repo-specific content above, plus one pointer to the constitution.
