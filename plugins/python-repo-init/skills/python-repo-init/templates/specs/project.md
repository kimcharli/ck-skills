# Project Conventions

Repo-specific layout and workflow. Behavioral rules live in `AGENTS.md`;
this file covers where things are and how this repo is built.

## Repo Map

- `specs/NEXT.md` — current actionable work. Read first, every session.
- `README.md` — user-facing setup and CLI usage. Not engineering process;
  `specs/` holds the reasoning behind each command.
- `specs/` — engineering specs driving `src/`, the `data/` directory
  contract, and cross-tool conventions. Start at `specs/workflow.md`.
- `specs/memory.md` — durable facts and decisions log, agent-agnostic.
  This is the durable-facts log referenced by `AGENTS.md`.
- `specs/workflow-log.md` — append-only dated log of engineering decisions
  and completed work. `specs/workflow.md` stays normative-only.
- `specs/improvements.md` — proposed changes to instructions, hooks, and
  skills. Append-only for agents; humans decide.
- `docs/` — domain analysis only, not engineering process. Start at
  `docs/README.md`.
- `data/01_raw/`, `data/03_generated/`, `data/work/`, `data/tmp/` — tracked
  vs. gitignored status and provenance headers are defined in
  `specs/workflow.md` Section 5a.

## Building Code

- Read `specs/workflow.md` before writing or modifying anything under
  `src/`. It defines the spec-first, one-skill-per-module, test-alongside
  workflow.
- Every skill module in `src/__PKG_NAME__/` requires a matching spec at
  `specs/NNN-<skill-name>.md` and a test at `tests/test_<skill_name>.py`.
- `scripts/check_repo_conventions.py` mechanically enforces a subset of
  these rules at commit time. See `specs/workflow.md` Section 8. This is
  the convention check referenced by the definition of done in
  `AGENTS.md`.

## Domain Context

Domain analysis lives in `docs/`, starting at `docs/README.md`. Read it
before making changes that depend on domain semantics rather than repo
mechanics.

## Improvement Routing

`AGENTS.md` requires proposals to carry a `target`. In this repo those
resolve as follows:

- `agents` — a behavioral rule. Applied by editing `AGENTS.md`.
- `hook` — a check that must hold every time. Prefer
  `scripts/check_repo_conventions.py` or `.githooks/`, which every tool
  and CI respects. Use a tool-specific hook only when the check cannot be
  expressed at commit time, and record why in the proposal.
- `skill` — a repeated procedure. Applied as `specs/NNN-<skill-name>.md`
  plus the `src/` module and `tests/test_<skill_name>.py`, per
  `specs/workflow.md`.
- `spec` — a convention that drifted from the code. Applied by editing the
  relevant file under `specs/`.

Review open proposals whenever `specs/NEXT.md` turns over, or once three
or more accumulate. Batch accepted `agents` changes into a single edit
rather than applying them one at a time.

## Escalation Threshold

`AGENTS.md` requires asking before irreversible or live-system actions. In
this repo that means, concretely:

- Any write against a live system of record (controller, API, database).
- Any operation against `data/01_raw/` that is not read-only.
- Any change altering the `data/` directory contract in
  `specs/workflow.md` Section 5a.

Read-only queries, analysis, and anything confined to `data/work/` or
`data/tmp/` do not require asking.

Scaffold note, delete once tailored: replace the first bullet with this
repo's actual live systems of record.

## Setup (once per clone)

```
uv sync --dev
git config core.hooksPath .githooks
```
