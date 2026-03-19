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

______________________________________________________________________

_No code changes without a task entry above_
