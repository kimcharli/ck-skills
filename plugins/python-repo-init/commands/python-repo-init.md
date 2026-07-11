---
description: Scaffold a new Python repo with spec-first, agent-agnostic workflow governance
argument-hint: <target-dir> [--name NAME] [--python VERSION]
---

Use the `python-repo-init` skill to scaffold a new Python repository at the
target directory given in `$ARGUMENTS` (ask for one if missing).

Follow the skill's SKILL.md exactly: run its `scripts/generate.py` by absolute
path with the user's arguments, then report the generator's printed next steps
(`git init`, hook wiring, `uv sync --dev`, first commit) without running them
unless the user asks.
