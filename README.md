# ck-skills

**A marketplace of production-ready skills for Claude Code and GitHub Copilot CLI.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)
[![GitHub: kimcharli/ck-skills](https://img.shields.io/badge/GitHub-ck--skills-black)](https://github.com/kimcharli/ck-skills)

______________________________________________________________________

## Available Skills

| Plugin | Skill | Description | Activation Intent |
| -- | -- | -- | -- |
| **ck** | sdd-project-init | Bootstrap a new non-Python project with Spec-Driven Development structure | "initialize a new project" |
| **ck** | doc-review-commands | Keep documentation in sync with code changes | "review my documentation" |
| **ck** | skill-builder | Create new production-ready skills in minutes | "create a new skill" |
| **ck** | sdd-git-commit | Professional SDD Git commit workflow | "commit my changes" |
| **ck** | python-lint-fix | Auto-fix and format Python and Markdown code | "fix/lint my code" |
| **python-repo-init** | python-repo-init | Scaffold a new Python repo with spec-first, agent-agnostic workflow governance | "init a python repo" |

______________________________________________________________________

## Installation

Claude Code, GitHub Copilot CLI, and Gemini CLI are supported.

### Add the marketplace (one-time)

**Claude Code:**

```bash
claude plugin marketplace add https://github.com/kimcharli/ck-skills
```

**Copilot CLI:**

```bash
copilot plugin marketplace add kimcharli/ck-skills
```

**Gemini CLI:**
Gemini CLI uses a skill-based system. You can install individual skills directly from this repository.

### Install individual skills

**Claude Code:**

```bash
claude plugin install ck@ck-skills
claude plugin install python-repo-init@ck-skills
```

**Copilot CLI:**

```bash
copilot plugin install ck@ck-skills
copilot plugin install python-repo-init@ck-skills
```

**Gemini CLI:**

```bash
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/ck/skills/sdd-project-init
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/ck/skills/doc-review-commands
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/ck/skills/skill-builder
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/ck/skills/sdd-git-commit
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/ck/skills/python-lint-fix
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/python-repo-init/skills/python-repo-init
```

### Install directly from repo (no marketplace registration)

```bash
claude plugin install kimcharli/ck-skills
# or
copilot plugin install kimcharli/ck-skills
# or for Gemini (all skills in plugins folder)
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins
```

### Manual install (local clone)

```bash
git clone https://github.com/kimcharli/ck-skills.git
cd ck-skills
# ck skills (sdd-project-init, doc-review-commands, skill-builder, sdd-git-commit, python-lint-fix):
cp -r plugins/ck/skills/<name> ~/.claude/skills/<name>
# python-repo-init:
cp -r plugins/python-repo-init/skills/python-repo-init ~/.claude/skills/python-repo-init
```

> **Troubleshooting:** If install fails with "Plugin not found" after adding a
> new plugin, the marketplace cache may be stale. See [docs/troubleshooting.md](docs/troubleshooting.md).

______________________________________________________________________

## Quick Start by Skill

All skills are **AI-Native**. You don't need to remember slash commands; just tell the tool what you want to do.

### sdd-project-init — Bootstrap a new SDD project

> "initialize a new project with SDD"

Runs a 7-question interview, then generates a fully populated project with
`AGENTS.md` (the AI constitution), `specs/`, and `docs/`.

### doc-review-commands — Keep docs in sync

> "review my documentation and update the changelog"

Or more focused:

> "update SDD specs for the new feature"
> "run a documentation QA check"

### skill-builder — Create new skills

> "help me build a new skill for [purpose]"

______________________________________________________________________

## Repository Structure

```
ck-skills/
├── .claude-plugin/
│   └── marketplace.json              # Registry — read by Claude Code + Copilot CLI
├── plugins/
│   ├── ck/                           # Umbrella plugin bundling 5 skills
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json           # Plugin manifest (metadata only)
│   │   ├── README.md
│   │   └── skills/
│   │       ├── sdd-project-init/     # SDD project bootstrapper
│   │       │   ├── commands/         # Skill command files
│   │       │   ├── template/         # Model file tree for generated projects
│   │       │   ├── tools/            # create-project.sh
│   │       │   ├── manifest.json     # Gemini/Copilot skill metadata
│   │       │   └── README.md
│   │       ├── doc-review-commands/  # Documentation management
│   │       │   ├── commands/
│   │       │   ├── tools/
│   │       │   ├── config/
│   │       │   ├── manifest.json
│   │       │   └── README.md
│   │       ├── skill-builder/        # Skill creation tool
│   │       │   ├── commands/
│   │       │   ├── tools/
│   │       │   ├── docs/
│   │       │   └── README.md
│   │       ├── sdd-git-commit/       # Git commit workflow
│   │       │   ├── commands/
│   │       │   ├── manifest.json
│   │       │   └── README.md
│   │       └── python-lint-fix/      # Lint automation
│   │           ├── commands/
│   │           ├── tools/
│   │           ├── manifest.json
│   │           └── README.md
│   └── python-repo-init/             # Python repo scaffolder (standalone plugin)
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── skills/
│           └── python-repo-init/
├── docs/
│   ├── lessons-learned.md            # Non-obvious findings and decisions
│   └── troubleshooting.md            # Install failures and fixes
├── README.md
└── CHANGELOG.md
```

______________________________________________________________________

## Compatibility

| Tool | Marketplace install | Direct install | Notes |
| -- | -- | -- | -- |
| **Claude Code** | ✅ `claude plugin marketplace add` | ✅ `claude plugin install owner/repo` | Full support |
| **Copilot CLI** | ✅ `copilot plugin marketplace add` | ✅ `copilot plugin install owner/repo` | Full support |
| **Gemini CLI** | ❌ No marketplace yet | ✅ `gemini skills install repo --path p/skill` | Full support |

______________________________________________________________________

## Docs

- [Lessons Learned](docs/lessons-learned.md) — non-obvious findings, gotchas, decisions
- [Troubleshooting](docs/troubleshooting.md) — install failures and fixes

______________________________________________________________________

## Uninstall

```bash
# Claude Code
claude plugin uninstall ck
claude plugin uninstall python-repo-init

# Copilot CLI
copilot plugin uninstall ck
copilot plugin uninstall python-repo-init

# Manual
rm -rf ~/.claude/skills/<name>
```

______________________________________________________________________

## Contributing

Contributions welcome. To add a new skill:

1. Small, general-purpose skill? Add `plugins/ck/skills/<your-skill>/` (`SKILL.md`, `commands/`, and any `tools/`/`docs/` it needs) alongside the existing bundled skills.
1. Skill needs its own bundled generator/templates or independent versioning? Create a standalone plugin at `plugins/<your-skill>/` with its own `.claude-plugin/plugin.json`, following the `python-repo-init` structure.
1. Add `manifest.json` (Gemini/Copilot skill metadata)
1. Register in `.claude-plugin/marketplace.json` (new standalone plugins only — skills added to `ck` don't need a separate entry)
1. Clear local cache and test install on both Claude Code and Copilot CLI
1. Submit a pull request

______________________________________________________________________

## License

MIT — see [LICENSE](LICENSE)

______________________________________________________________________

## Recommended Tools for AI Agents

To maximize the efficiency of AI agents (Claude Code, Copilot CLI, Gemini CLI, etc.), it is highly recommended to install the following tools:

- **[tokensave](https://github.com/aovestdipaperino/tokensave)**: Provides instant semantic results from a pre-built knowledge graph, making codebase analysis significantly faster and more token-efficient.
- **codebase-memory-mcp**: Provides persistent, long-term memory for your codebase across sessions, helping agents remember architectural decisions, previous bug fixes, and project-specific conventions.
- **[caveman](https://github.com/JuliusBrussee/caveman)**: An extension offering ultra-compressed communication modes and skills (like `caveman-review`, `caveman-commit`, and `cavecrew`) to drastically reduce token usage while preserving technical accuracy.
- **[pre-commit](https://pre-commit.com/)**: Essential for maintaining code quality. Combined with **[Ruff](https://github.com/astral-sh/ruff)** for Python, it allows agents to automatically fix linting and formatting issues before committing, ensuring a clean and consistent codebase.

______________________________________________________________________

**Links:** [GitHub](https://github.com/kimcharli/ck-skills) · [Issues](https://github.com/kimcharli/ck-skills/issues) · [Discussions](https://github.com/kimcharli/ck-skills/discussions)
