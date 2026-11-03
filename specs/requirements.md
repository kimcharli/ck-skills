# Requirements

> **Status**: APPROVED
> **Last updated**: 2026-11-03

______________________________________________________________________

## Problem Statement

AI CLI agents like Claude Code, Gemini CLI, and GitHub Copilot CLI are powerful but often require project-specific configuration or repetitive multi-step commands to ensure high quality (linting, testing, project structure). Developers need a shared repository of "skills" and "plugins" that can be easily installed and updated across projects to standardize these workflows.

## Goals

- [x] Provide a library of reusable AI skills (SDD init, Lint/Fix, Git Commit).
- [x] Ensure consistency across different AI CLI runners.
- [x] Implement Spec-Driven Development (SDD) gates to ensure quality.
- [x] Maintain automated tests for all critical scripts.

## Non-Goals (explicitly out of scope)

- Not building a new AI runner from scratch.
- Not providing specialized skills for languages outside the core focus (currently Python/Markdown/Bash).

## User Stories

### Story 1: Project Bootstrapping

**As a** developer
**I want to** run a single command to scaffold a new project with SDD structure
**So that** I don't have to manually create spec files and config every time.

**Acceptance Criteria:**

- [x] `sdd-project-init` skill creates root files (`AGENTS.md`, `README.md`).
- [x] `sdd-project-init` creates `specs/` and `docs/` structure.
- [x] All generated files have template variables replaced correctly.

### Story 2: Cross-Runner Compatibility

**As a** developer using multiple AI CLI tools (Claude Code, Gemini CLI, etc.)
**I want to** install skills once into the tool-neutral path `~/.agents/skills/`
**So that** all agents can automatically discover and activate the skills via their `SKILL.md` descriptions.

**Acceptance Criteria:**

- [x] Installation scripts automatically detect `~/.agents` and `~/.claude`. (Superseded 2026-11-03: the target is always `~/.agents/skills/`; see design Decision 4.)
- [ ] Each skill is installed to `~/.agents/skills/<name>/`, for every tool. `--dir` overrides the base for testing.
- [ ] The installer copies each skill by default; `--link` symlinks it to the repo checkout for skill development.
- [ ] Each tool skills directory (`~/.claude/skills/`, `~/.gemini/skills/`, ...) gets a per-skill symlink to `~/.agents/skills/<name>`, unless that tool reads `~/.agents/skills/` natively. The tool directory itself is never replaced.
- [ ] An installed skill works with no reference to the repo checkout: scripts and templates resolve from the skill's own directory.
- [x] Hardcoded `~/.claude` references in `.md`, `.json`, and `SKILL.md` are patched during installation.
- [x] Uninstallation scripts correctly locate and remove skills from dynamic paths.

## Constraints & Assumptions

- Assumption: User has `uv`, `node`, and `npm` installed.
- Constraint: Must work on macOS (darwin) and Linux.

## Open Questions

- [ ] Q: Should we support other package managers like `poetry`? → Owner: ck → Due: 2026-04-01

______________________________________________________________________

_Approval required before editing `specs/design.md`_
