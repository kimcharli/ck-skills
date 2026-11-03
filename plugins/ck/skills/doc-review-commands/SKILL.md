---
name: doc-review-commands
description: >-
  Bring a repo's documentation back in sync with its code: README, CHANGELOG,
  CLAUDE.md/AGENTS.md and SDD specs (requirements, design, tasks). Includes a
  doc-health analyzer, focused update workflows (core docs, SDD artifacts,
  quick edits) and a pre-commit documentation QA pass. Use when the user says
  the docs are stale or out of date, asks to update the README or CHANGELOG
  after changes, wants documentation reviewed before a release or commit,
  asks for a doc-health check, or wants specs synced with what was built.
---

# Doc Review Commands

Keep a project's documentation (README, CHANGELOG, AGENTS.md/CLAUDE.md, specs) in sync with code changes.

`SKILL_DIR` below is the base directory announced when this skill loaded (`Base directory for this skill: <path>`). Use it directly; do not search for the skill's files.

## Workflows

Each workflow is a file in `$SKILL_DIR/commands/`. Pick the smallest one that covers the request, then Read only that file and follow it. Smaller workflows cost fewer tokens and touch fewer files.

| Workflow | File | Use when |
| -- | -- | -- |
| Analyze | `commands/analyze.md` | Report doc gaps without changing anything. |
| Quick | `commands/quick.md` | The user already knows which doc to change; skip analysis. |
| Core | `commands/core.md` | Update README, CLAUDE.md/AGENTS.md, CHANGELOG after code changes. |
| SDD | `commands/sdd.md` | Update `specs/requirements.md`, `design.md`, `tasks.md`. |
| QA | `commands/qa.md` | Lint, links, consistency and completeness check before commit. |
| Main | `commands/main.md` | Full update: analyze, then run the needed workflows above. |
| Help | `commands/help.md` | The user asks how this system works. |

The workflow files were written for an older `~/.claude/commands/ck/doc-review/` layout. Where a file names that path or `~/.claude/tools/doc-analyzer.sh`, use `$SKILL_DIR/` instead (for example `$SKILL_DIR/tools/analyzer.sh`, `$SKILL_DIR/config/categories.json`).

## Analyzer

```bash
bash "$SKILL_DIR/tools/analyzer.sh" all
```

Run it from the target repo's root. It reads only; it changes no files.

## Rules

- Follow the repo's existing CHANGELOG format; if there is none, use [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
- When updating SDD artifacts, keep each file's `DRAFT`/`APPROVED` status as it is. Changing an approved spec needs the user's sign-off, because the status gates what an agent may build.
- Finish with the QA workflow when the change touched more than one doc.
