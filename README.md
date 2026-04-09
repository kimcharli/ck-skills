# ck-skills

**A marketplace of production-ready skills for Claude Code and GitHub Copilot CLI.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)
[![GitHub: kimcharli/ck-skills](https://img.shields.io/badge/GitHub-ck--skills-black)](https://github.com/kimcharli/ck-skills)

______________________________________________________________________

## Available Skills

| Skill                   | Description                                                    | Activation Intent          |
| ----------------------- | -------------------------------------------------------------- | -------------------------- |
| **sdd-project-init**    | Bootstrap a new project with Spec-Driven Development structure | "initialize a new project" |
| **doc-review-commands** | Keep documentation in sync with code changes                   | "review my documentation"  |
| **skill-builder**       | Create new production-ready skills in minutes                  | "create a new skill"       |
| **sdd-git-commit**      | Professional SDD Git commit workflow                           | "commit my changes"        |
| **python-lint-fix**     | Auto-fix and format Python and Markdown code                   | "fix/lint my code"         |

______________________________________________________________________

## Installation

Claude Code, GitHub Copilot CLI, and Gemini CLI are supported.

### Add the marketplace (one-time)

**Claude Code:**

```bash
claude plugin marketplace add github:kimcharli/ck-skills
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
claude plugin install sdd-project-init@ck-skills
claude plugin install doc-review-commands@ck-skills
claude plugin install skill-builder@ck-skills
claude plugin install sdd-git-commit@ck-skills
claude plugin install python-lint-fix@ck-skills
```

**Copilot CLI:**

```bash
copilot plugin install sdd-project-init@ck-skills
copilot plugin install doc-review-commands@ck-skills
copilot plugin install skill-builder@ck-skills
copilot plugin install sdd-git-commit@ck-skills
copilot plugin install python-lint-fix@ck-skills
```

**Gemini CLI:**

```bash
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/sdd-project-init
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/doc-review-commands
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/skill-builder
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/sdd-git-commit
gemini skills install https://github.com/kimcharli/ck-skills.git --path plugins/python-lint-fix
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
cd ck-skills/plugins/<skill-name>
chmod +x install.sh && ./install.sh
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
│   ├── sdd-project-init/             # SDD project bootstrapper
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json           # Plugin manifest (metadata only)
│   │   ├── commands/                 # Skill command files
│   │   ├── template/                 # Model file tree for generated projects
│   │   ├── tools/                    # create-project.sh
│   │   ├── manifest.json             # Claude Code manifest
│   │   ├── install.sh
│   │   └── README.md
│   ├── doc-review-commands/          # Documentation management
│   │   ├── commands/
│   │   ├── tools/
│   │   ├── config/
│   │   ├── manifest.json
│   │   ├── install.sh
│   │   └── README.md
│   └── skill-builder/                # Skill creation tool
│       ├── commands/
│       ├── tools/
│       ├── templates/
│       └── README.md
├── docs/
│   ├── lessons-learned.md            # Non-obvious findings and decisions
│   └── troubleshooting.md            # Install failures and fixes
├── README.md
└── CHANGELOG.md
```

______________________________________________________________________

## Compatibility

| Tool            | Marketplace install                 | Direct install                                 | Notes        |
| --------------- | ----------------------------------- | ---------------------------------------------- | ------------ |
| **Claude Code** | ✅ `claude plugin marketplace add`  | ✅ `claude plugin install owner/repo`          | Full support |
| **Copilot CLI** | ✅ `copilot plugin marketplace add` | ✅ `copilot plugin install owner/repo`         | Full support |
| **Gemini CLI**  | ❌ No marketplace yet               | ✅ `gemini skills install repo --path p/skill` | Full support |

______________________________________________________________________

## Docs

- [Lessons Learned](docs/lessons-learned.md) — non-obvious findings, gotchas, decisions
- [Troubleshooting](docs/troubleshooting.md) — install failures and fixes

______________________________________________________________________

## Uninstall

```bash
# Claude Code
claude plugin uninstall <skill-name>

# Copilot CLI
copilot plugin uninstall <skill-name>

# Manual
cd plugins/<skill-name> && ./uninstall.sh
```

______________________________________________________________________

## Contributing

Contributions welcome. To add a new skill:

1. Create `plugins/<your-skill>/` following the existing plugin structure
1. Add `manifest.json` (Claude Code) and `plugin.json` (Copilot CLI, metadata only)
1. Add `install.sh` / `uninstall.sh`
1. Register in `.claude-plugin/marketplace.json`
1. Clear local cache and test install on both Claude Code and Copilot CLI
1. Submit a pull request

______________________________________________________________________

## License

MIT — see [LICENSE](LICENSE)

______________________________________________________________________

**Links:** [GitHub](https://github.com/kimcharli/ck-skills) · [Issues](https://github.com/kimcharli/ck-skills/issues) · [Discussions](https://github.com/kimcharli/ck-skills/discussions)
