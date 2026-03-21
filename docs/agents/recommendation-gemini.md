# Recommendation: State-Aware SDD Commit Workflow

To improve project continuity and token efficiency, the `sdd-git-commit` skill should be enhanced to automate the management of a `STATE.md` file. This ensures that every session hand-off is seamless and requires minimal context re-loading.

## 1. Standardize the Checkpoint File
While the current `sdd-git-commit` skill mentions `SESSION_MEMO.md`, it should be standardized as `STATE.md` across all projects. This file serves as the "Volatile Memory" of the project state.

**Required `STATE.md` Structure:**
```markdown
# Project State

## Current Context
- **Active Task**: [Task Name from specs/tasks.md]
- **Status**: [Brief description of what was just done]
- **Session Objective**: [The high-level goal of this chat]

## Immediate Next Steps
1. [ ] Micro-task A
2. [ ] Micro-task B

## Critical Decisions & Notes
- [Decision X]: Because of [Constraint Y]...
```

## 2. Updated Workflow for `sdd-git-commit`

### Step 4: Project State Tracking (Modified)
The tracking phase should now strictly enforce the update of `STATE.md`.

| File           | Requirement | Action                                                                    |
| -------------- | ----------- | ------------------------------------------------------------------------- |
| `STATE.md`     | **Critical**| Update with current task, status, and micro-steps for the next session.  |
| `CHANGELOG.md` | **Mandatory**| Prepend new entry under `## [Unreleased]`.                               |
| `specs/tasks.md`| **Mandatory**| Mark current task as `[x]`.                                              |

### Step 5: The "State-Staging" Step
The agent should automatically stage the updated state file as part of the commit process.

```bash
git add STATE.md CHANGELOG.md specs/tasks.md
```

## 3. Implementation Plan for the Skill
1.  **Update `SKILL.md`**: Replace references to `SESSION_MEMO.md` with `STATE.md` and elevate it to a "Critical" requirement.
2.  **Update `commit.md`**: Add an explicit instruction to "Draft the next state checkpoint in `STATE.md` before generating the commit message."
3.  **Template Creation**: Add a `STATE.md` template to the `sdd-project-init` plugin so new projects start with this efficiency by default.

## 4. Why this works
By making `STATE.md` a mandatory part of the commit workflow, we ensure that:
1.  **Tokens are saved**: The next agent only reads `AGENTS.md` + `STATE.md` (~200 tokens) instead of scanning the whole repo (~2000+ tokens).
2.  **Continuity is guaranteed**: The agent knows exactly which task it was on and what to do next without asking the user "What should I do now?".
3.  **Logic is preserved**: Small, non-obvious decisions made during coding are recorded before the session context is lost.
