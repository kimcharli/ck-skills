---
description: Scaffold a new Python repo with spec-first, agent-agnostic workflow governance
argument-hint: <target-dir> [--name NAME] [--python VERSION]
allowed-tools: Bash(python3 ${CLAUDE_PLUGIN_ROOT}/*) Read(${CLAUDE_PLUGIN_ROOT}/**) Read(~/.claude/plugins/**)
---

Use the `python-repo-init` skill to scaffold a new Python repository at the
target directory given in `$ARGUMENTS` (ask for one if missing).

Follow the skill's SKILL.md exactly: it contains the generator's absolute path
— do not search the filesystem for the skill or its files. Run the generator
with the user's arguments, then report its printed next steps (`git init`,
hook wiring, `uv sync --dev`, first commit) without running them unless the
user asks.
