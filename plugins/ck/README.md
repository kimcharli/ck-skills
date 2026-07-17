# ck

**Umbrella plugin bundling five production-ready Claude Code skills.**

For marketplace setup and general install instructions, see the
[ck-skills README](../../README.md).

**Quick install:**

```bash
# Claude Code
claude plugin install ck@ck-skills

# Copilot CLI
copilot plugin install ck@ck-skills
```

______________________________________________________________________

## Bundled skills

| Skill | Description | Activation Intent |
| -- | -- | -- |
| **sdd-project-init** | Bootstrap a new non-Python project with Spec-Driven Development structure | "initialize a new project" |
| **doc-review-commands** | Keep documentation in sync with code changes | "review my documentation" |
| **sdd-git-commit** | Professional SDD Git commit workflow | "commit my changes" |
| **python-lint-fix** | Auto-fix and format Python and Markdown code | "fix/lint my code" |
| **plan-doc** | Plan-first workflow for multi-item change batches (committed plan doc before execution) | "plan first" / "create a plan doc" |
| **decision-capture** | Commit a mid-session design decision to specs before any implementation code | "capture this decision" |
| **session-close** | End-of-session handoff: refresh the NEXT pointer, append the dated log entry | "close session" / "wrap up" |

All skills are **AI-Native** — you don't need to remember slash commands, just tell the
tool what you want to do. Each skill also exposes its own commands under `/ck:<name>`
(e.g. `/ck:lint`, `/ck:sdd-init`, `/ck:commit`).

______________________________________________________________________

## Structure

```
ck/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── sdd-project-init/
    ├── doc-review-commands/
    ├── sdd-git-commit/
    ├── python-lint-fix/
    ├── plan-doc/
    ├── decision-capture/
    └── session-close/
```

Each skill directory is self-contained (`SKILL.md`, `commands/`, and any `tools/`,
`docs/`, `template/` it needs).
