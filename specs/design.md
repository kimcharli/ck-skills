# Design

> **Status**: APPROVED
> **Requires**: `specs/requirements.md` APPROVED
> **Last updated**: 2026-03-19

______________________________________________________________________

## Architecture Overview

The project is structured as a mono-repo of individual skill packages. Each skill is self-contained under `plugins/` and contains its own logic, templates, and installation scripts.

## Components

### Component 1: sdd-project-init

- **Responsibility**: Scaffolds new projects with Spec-Driven Development files.
- **Interface**: Bash script (`create-project.sh`) called by AI agent.
- **Dependencies**: Bash, Git.

### Component 2: python-lint-fix

- **Responsibility**: Runs Ruff, mdformat, and markdownlint to fix and verify code.
- **Interface**: Bash script (`lint-fix.sh`).
- **Dependencies**: `uv`, `node`, `npm`.

## Key Decisions (ADRs)

### Decision 1: Use SDD Gates

- **Context**: AI agents often start coding too early without understanding the full requirement.
- **Decision**: We enforce `AGENTS.md` gates where agents must check requirements and design status before writing code.
- **Rationale**: Reduces rework and ensures alignment with user intent.

## Testing Strategy

- Unit tests using `BATS` for bash scripts.
- Verification runs of skills on sample projects.
- What is explicitly NOT tested: The AI models themselves.

______________________________________________________________________

_Approval required before editing `specs/tasks.md`_
