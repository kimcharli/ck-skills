---
name: sdd-project-init
description: >-
  Scaffold a new non-Python project (Go, TypeScript, Bash, Rust, docs-only,
  any stack) with Spec-Driven Development structure: AGENTS.md with SDD
  gates, README, .gitignore, specs/requirements.md, design.md, tasks.md and a
  feature template. Use when the user wants to start, bootstrap, init or
  scaffold a new repo or project "with specs", "spec-driven", "SDD", or "with
  an AGENTS.md". For Python repos use python-repo-init instead.
---

# SDD Project Init

This skill bootstraps a new project with Spec-Driven Development structure. It runs a short interview, then generates all files fully populated.

> **Python repo?** Use the `python-repo-init` skill instead — it supersedes
> this one for Python: mechanical convention enforcement (pre-commit guard +
> CI), a lifecycle-staged `data/` contract, session handoff via `specs/NEXT.md`,
> and uv/mise tooling. This skill remains the language-agnostic scaffold.

## Procedures

1. **Interview**: Ask the user for the project name, purpose, stack, and runtime.

1. **Project Generation**: Run the generator. `SKILL_DIR` is the base directory announced when this skill loaded (`Base directory for this skill: <path>`); do not search for it.

   ```bash
   bash "$SKILL_DIR/tools/create-project.sh" --name "NAME" --purpose "PURPOSE" --stack "STACK" --runtime "RUNTIME" [--integrations "LIST"] [--path "TARGET_DIR"]
   ```

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
