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

### Decision 2: Dynamic Path Support

- **Context**: Different AI runners use different base directories for skills (e.g., `~/.claude` vs. `~/.agents`). Internal path references in markdown and JSON files must be valid for the skill to work.
- **Decision**: Installation scripts (`install.sh`) perform automated base directory detection and path patching using `perl` upon installation.
- **Rationale**: Decouples the source files from a specific runner's directory structure, allowing the same plugin code to work in multiple environments without manual configuration.

### Decision 3: Full Modern (Skills-Only) Pattern

- **Context**: AI CLI runners are moving toward autonomous "Skills" that the model activates based on intent, rather than manual slash commands. Claude Code has deprecated the global `commands/` folder.
- **Decision**: All plugins must follow the **Full Modern (Skills-Only)** pattern defined in `docs/unified-plugin-model.md`. This installs all components (expertise, commands, tools) into a self-contained package under `plugins/ck/<name>/` and eliminates global `commands/` shims.
- **Rationale**: Future-proofs the architecture, provides a cleaner UX by relying on natural language intent, and ensures atomic management of skills across all major runners (Claude, Gemini, Copilot).

## Testing Strategy

- Unit tests using `BATS` for bash scripts.
- Verification runs of skills on sample projects.
- What is explicitly NOT tested: The AI models themselves.

______________________________________________________________________

_Approval required before editing `specs/tasks.md`_
