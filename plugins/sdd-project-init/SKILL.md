______________________________________________________________________

## name: sdd-project-init description: Bootstrap a new project with Spec-Driven Development (SDD) structure, including AGENTS.md, specs/, and docs/

# SDD Project Init

This skill bootstraps a new project with Spec-Driven Development structure. It runs a short interview, then generates all files fully populated.

## Procedures

1. **Interview**: Ask the user for the project name, purpose, stack, and runtime.
1. **Project Generation**: Call `tools/create-project.sh` with the provided information.
1. **SDD Structure**: Ensure the following files and directories are created:
   - `AGENTS.md` (AI constitution + SDD gates)
   - `README.md`
   - `.gitignore`
   - `docs/sdd-how-to-apply.md` (human workflow reference)
   - `specs/requirements.md`, `specs/design.md`, `specs/tasks.md`
   - `specs/features/_template.md`

## Instructions

- Use `AGENTS.md` as the single source of truth for AI instructions.
- Ensure the project structure follows the SDD standard.
- After initialization, guide the user to `specs/requirements.md` to start their first feature.
