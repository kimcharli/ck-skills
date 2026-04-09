# Agent Improvement Tracking

This document tracks the specialized agent candidates, their creation prompts, and recommendations for skill revisions to ensure consistent, token-efficient SDD workflows across different AI CLI tools.

## 1. Agent Candidates

| Candidate          | Target CLI  | Core Workflow                 | Spec File                                | Creation Prompt                          | Recommendation                                           |
| :----------------- | :---------- | :---------------------------- | :--------------------------------------- | :--------------------------------------- | :------------------------------------------------------- |
| **Gemini Expert**  | Gemini CLI  | `STATE.md` Focused            | [AGENTS-gemini.md](./AGENTS-gemini.md)   | [prompt-gemini.md](./prompt-gemini.md)   | [recommendation-gemini.md](./recommendation-gemini.md)   |
| **Claude Expert**  | Claude Code | `specs/status.md` Focused     | [AGENTS-claude.md](./AGENTS-claude.md)   | [prompt-claude.md](./prompt-claude.md)   | (Internal to Spec)                                       |
| **Copilot Expert** | Copilot CLI | `STATE.md` + `sdd-state-sync` | [AGENTS-copilot.md](./AGENTS-copilot.md) | [prompt-copilot.md](./prompt-copilot.md) | [recommendation-copilot.md](./recommendation-copilot.md) |

## 2. Key Revision Goals

### G-1: Standardize `STATE.md` (High Priority)

- **Goal**: Converge on a single "volatile memory" file to improve session hand-offs and reduce token waste.
- **Current Status**:
  - Gemini: Uses `STATE.md` (manual update).
  - Claude: Uses `specs/status.md`.
  - Copilot: Uses `STATE.md` (automated via `sdd-state-sync`).
- **Target**: Unified `STATE.md` schema across all agents, placed in the project root.

### G-2: Implement `sdd-state-sync` Skill

- **Goal**: Automate the generation of `STATE.md` from `specs/tasks.md` and `git log`.
- **Reference**: [recommendation-copilot.md](./recommendation-copilot.md)
- **Status**: [ ] Pending implementation as a new plugin in `plugins/sdd-state-sync/`.

### G-3: Update `sdd-git-commit` Skill

- **Goal**: Integrate `STATE.md` updates into the mandatory pre-commit checklist.
- **Reference**: [recommendation-gemini.md](./recommendation-gemini.md)
- **Status**: [ ] Update `plugins/sdd-git-commit/SKILL.md` to require `STATE.md` updates.

### G-4: Update `sdd-project-init` Skill

- **Goal**: Include a `STATE.md` template in the default project structure.
- **Status**: [ ] Update `plugins/sdd-project-init/template/` to include `STATE.md`.

## 3. Improvement Roadmap

- [ ] **R-1**: Create `plugins/sdd-state-sync` with `sync.sh` and `parse-tasks.sh`.
- [ ] **R-2**: Revise `AGENTS-gemini.md` and `AGENTS-claude.md` to adopt the unified `STATE.md` schema.
- [ ] **R-3**: Update `sdd-git-commit` to automate state syncing.
- [ ] **R-4**: Update `sdd-project-init` to bootstrap state tracking.
- [ ] **R-5**: Verify cross-agent compatibility (Claude Code, Gemini CLI, Copilot CLI).
