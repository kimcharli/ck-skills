# Tasks

> **Status**: APPROVED
> **Requires**: `specs/design.md` APPROVED
> **Last updated**: 2026-03-19

______________________________________________________________________

## Rules

- Tasks are executed in order unless marked `[parallel]`
- Commit after EACH task with message: `task(N): <title>`
- Mark `[x]` before committing
- If a task reveals new requirements → STOP, update `specs/requirements.md` first

______________________________________________________________________

## Task List

### Phase 1: Foundation

- [x] **T01** — Project scaffold `[no deps]`
- [x] **T02** — Initial README and documentation `[deps: T01]`
- [x] **T03** — Standardized Markdown lint configuration `[deps: T01]`

### Phase 2: Skills Development

- [x] **T04** — Implement `sdd-project-init` `[deps: T01]`
- [x] **T05** — Implement `python-lint-fix` `[deps: T01]`
- [x] **T06** — Implement `sdd-git-commit` `[deps: T01]`

### Phase 3: Project Governance

- [x] **T07** — Create `specs/` directory and initial spec files `[deps: T01]`
- [x] **T08** — Create `AGENTS.md` for consistent project constitution `[deps: T07]`

### Phase 4: Cross-Runner Compatibility

- [x] **T09** — Dynamic base directory detection in `install.sh` `[deps: T04, T05, T06]`
- [x] **T10** — Implement automated path patching (`~/.claude` → dynamic) `[deps: T09]`
- [x] **T11** — Dynamic uninstallation logic in `uninstall.sh` `[deps: T09]`

### Phase 5: Full Modern Architecture (Skills-Only)

- [x] **T12** — Refactor `install.sh` to use `skills/` root only `[deps: T09]`
- [x] **T13** — Remove global `commands/` shims from all plugins `[deps: T12]`
- [x] **T14** — Update `uninstall.sh` to reflect new directory structure `[deps: T11, T12]`
- [x] **T15** — Update READMEs and usage docs to focus on natural language `[deps: T13]`
- [x] **T16** — Implement automatic symlinking for Claude discovery in `install.sh` `[deps: T12]`
- [x] **T17** — Verify autonomous activation via `SKILL.md` in Gemini/Claude `[deps: T12]`
- [x] **T18** — Implement `docs/agents/AGENTS-gemini.md` with strict SDD "Two-Commit" workflow `[deps: T08]`

### Phase 6: Quality Automation

- [x] **T19** — Migrate to pre-commit Option A workflow `[deps: T05, T18]`

______________________________________________________________________

## Completed

- **T01** — Project scaffold
- **T02** — Initial README and documentation
- **T03** — Standardized Markdown lint configuration
- **T04** — Implement `sdd-project-init`
- **T05** — Implement `python-lint-fix`
- **T06** — Implement `sdd-git-commit`
- **T07** — Create `specs/` directory and initial spec files
- **T08** — Create `AGENTS.md` for consistent project constitution
- **T09** — Dynamic base directory detection in `install.sh`
- **T10** — Implement automated path patching
- **T11** — Dynamic uninstallation logic in `uninstall.sh`
- **T12** — Refactor `install.sh` to use `skills/ck/` root only
- **T13** — Remove global `commands/` shims from all plugins
- **T14** — Update `uninstall.sh` to reflect new directory structure
- **T15** — Update READMEs and usage docs to focus on natural language
- **T16** — Implement automatic symlinking for Claude discovery
- **T17** — Verify autonomous activation via `SKILL.md`
- **T18** — Implement `docs/agents/AGENTS-gemini.md` with strict SDD "Two-Commit" workflow

______________________________________________________________________

_No code changes without a task entry above_
