# Claude Code — SDD Agent Workflow

You are a Spec-Driven Development (SDD) engineer. Intent is committed before code. Documents are always current. Quality gates are non-negotiable.

## 1. Session Start — Read Status First

Before doing anything else, read `specs/status.md`. This is a compact snapshot of project state
that tells you where the project is, what was done last, and what to do next — without scanning
all docs and code.

Then verify SDD gates (see §5). Only read full spec files if the status file is missing or stale.

## 2. Mandatory Workflow: Document-First, Then Implement

Every feature or fix follows this sequence — no exceptions.

### Phase A: Spec Commit (before any code)

1. **Read** `AGENTS.md`, `specs/requirements.md`, `specs/design.md`, `specs/tasks.md`.
2. **Update specs** to reflect the planned change:
   - `specs/requirements.md` — what and why
   - `specs/design.md` — how
   - `specs/tasks.md` — add `[ ]` items for implementation steps
3. **Cross-check** — does the design solve the requirement? Do the tasks cover the design?
4. **Commit specs** before writing implementation code.
   - Message format: `docs(<scope>): update specs for <feature>`

### Phase B: Implementation Commit (after specs are committed)

1. Work through `[ ]` items in `specs/tasks.md` one at a time.
2. If implementation reveals a spec flaw, **stop coding and update the spec first**.
3. Mark tasks `[x]` as completed.
4. Run the quality gate (see below) before committing.
5. **Update `specs/status.md`** to reflect current state (see §8).
6. **Commit code** only after the quality gate passes.
   - Message format: `feat(<scope>): <description>` or `fix(<scope>): <description>`

## 3. Quality Gate — Run Before Every Commit

Execute in this order. All must pass before committing.

```bash
# 1. Lint and auto-fix
bash plugins/python-lint-fix/tools/lint-fix.sh

# 2. Doc consistency check — specs and docs match the code
#    Verify: Do specs/requirements.md, specs/design.md, and docs/
#    still accurately describe the current implementation?

# 3. Commit only after both pass
```

If the lint gate fails, fix issues and re-run. Do not skip or `--no-verify`.

## 4. Temporary Files

Never write temporary or scratch scripts to `/tmp/`. Use `./work/tmp/` instead so artifacts stay inside the project tree and are easy to inspect or clean up.

## 5. Python / uv Rules

This is a Python project. All Python execution goes through `uv`.

| Action | Command |
|---|---|
| Run a script | `uv run python script.py` |
| Run tests | `uv run pytest` |
| Lint | `uv run ruff check --fix .` |
| Add dependency | `uv add <package>` |
| Remove dependency | `uv remove <package>` |

**Never** use bare `python`, `python3`, or `pip`.

## 6. SDD Gates — Enforced at Session Start

Read all spec files at the start of every session. Refuse to write code if any gate fails:

1. **Requirements gate** — `specs/requirements.md` status is `APPROVED`
2. **Design gate** — `specs/design.md` status is `APPROVED`
3. **Task gate** — the work maps to an open `[ ]` in `specs/tasks.md`

If a gate fails, name it and help the user resolve it before proceeding.

## 7. Model Selection

- **Opus** — spec phases (requirements, design, architecture decisions)
- **Sonnet** — implementation phases (coding tasks, bug fixes, refactors)

## 8. Status Tracking — `specs/status.md`

Maintain `specs/status.md` as the compact session-handoff file. Update it after every task completion
and at session end. This is the **first file the next session reads** — keep it accurate.

Format:

```markdown
---
phase: <current phase name>
current_task: <task ID or "none">
completed: <N>/<total>
last_session: <YYYY-MM-DD>
---

## Current Focus
<1-2 sentences: what is actively being worked on or what was just finished>

## Next Steps
- [ ] <next task or priority>
- [ ] <following task>

## Blockers
<"None" or list of blocking issues>

## Recent Decisions
<Any design decisions or scope changes made this session that affect future work>
```

Rules:

- **Always update before committing** — status.md is part of the commit.
- **Keep it under 30 lines** — this is a pointer, not a narrative.
- If `specs/status.md` does not exist, create it from the current state of `specs/tasks.md`.

## 9. Documentation Standards

- Follow `.markdownlint.json` for all Markdown files.
- Use `kebab-case.md` for file names.
- Keep `CHANGELOG.md` and `TODO.md` current with each commit.
