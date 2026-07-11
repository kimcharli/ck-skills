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
| **skill-builder** | Create new production-ready skills in minutes | "create a new skill" |
| **sdd-git-commit** | Professional SDD Git commit workflow | "commit my changes" |
| **python-lint-fix** | Auto-fix and format Python and Markdown code | "fix/lint my code" |

All skills are **AI-Native** — you don't need to remember slash commands, just tell the
tool what you want to do. Each skill also exposes its own commands under `/ck:<name>`
(e.g. `/ck:lint`, `/ck:sdd-init`, `/ck:skill-builder`, `/ck:commit`).

______________________________________________________________________

## Structure

```
ck/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── sdd-project-init/
    ├── doc-review-commands/
    ├── skill-builder/
    ├── sdd-git-commit/
    └── python-lint-fix/
```

Each skill directory is self-contained (`SKILL.md`, `commands/`, and any `tools/`,
`docs/`, `template/` it needs).
