# ck-skills — Project Constitution

## Purpose

A collection of specialized skills and plugins for AI CLI agents (Claude Code, Gemini CLI, Copilot CLI) to enhance productivity and standardize development workflows using Spec-Driven Development (SDD).

## Stack & Environment

- **Language**: Bash, Node.js, Python
- **Runtime**: CLI Plugins
- **Package Managers**: `uv` (Python), `npm` (Node.js)

## Project Structure

```
ck-skills/
├── AGENTS.md                    # This file — read first, always
├── README.md
├── .markdownlint.json           # Shared lint config
├── docs/                        # Project documentation
├── plugins/                     # Self-contained skill packages
│   ├── python-lint-fix/
│   ├── sdd-project-init/
│   └── sdd-git-commit/
├── specs/
│   ├── requirements.md          # What + Why  (edit before any feature)
│   ├── design.md                # How         (edit after requirements approved)
│   ├── tasks.md                 # Ordered tasks (edit after design approved)
│   └── features/                # Per-feature spec files
└── tests/                       # Project-wide tests (BATS)
```

## Conventions

- All new features MUST start with a requirement update in `specs/`.
- Use `BATS` for testing all shell-based skills.
- Always create temporary scripts or scratch files in `./work/tmp/` instead of system `/tmp/`.
- Follow the `.markdownlint.json` standards for all documentation.
- Commit after every completed task in `specs/tasks.md`.
- Mark tasks `[x]` in `specs/tasks.md` before committing.
- **Temporary files**: Always create temporary scripts and files under `./work/tmp/` (not `/tmp/`).

## SDD Gates — check before every coding session

Read `specs/requirements.md`, `specs/design.md`, and `specs/tasks.md` at the
start of every session. Then enforce these gates in order:

1. **requirements gate** — `specs/requirements.md` status must be `APPROVED`
   → If DRAFT: stop, tell the user, help them complete requirements first
1. **design gate** — `specs/design.md` status must be `APPROVED`
   → If DRAFT: stop, tell the user, help them complete design first
1. **task gate** — the work must map to an open `[ ]` item in `specs/tasks.md`
   → If missing: add the task entry before writing any code

If a gate fails, refuse to write code and name the gate that failed.
If a requirement changes mid-implementation, stop and update specs first.

## AI Agent Workflow

- Use **Opus** (Claude) or **Pro** (Gemini) for spec phases (requirements, design).
- Use **Sonnet** (Claude) or **Flash** (Gemini) for implementation phases (tasks, code).
- Install pre-commit hooks once per clone: `uv run pre-commit install`.
- Use pre-commit as the default quality gate before commit.
- Run `bash plugins/python-lint-fix/tools/lint-fix.sh` to verify environment health (tools present, hook installed).

## Tool Compatibility

AGENTS.md is the single source of truth for all AI tools:

- **Claude Code** — reads AGENTS.md natively
- **Gemini CLI** — reads AGENTS.md natively
- **GitHub Copilot Chat** — reads AGENTS.md via context

## Shell: Multi-line Content

NEVER pass multi-line strings inline to the shell. Write to `work/tmp/<name>.txt` first.
