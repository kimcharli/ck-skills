# ck-skills — Project Constitution

## Purpose

A collection of specialized skills and plugins for AI CLI agents (Claude Code, Gemini CLI, Copilot CLI) to enhance productivity and standardize development workflows using Spec-Driven Development (SDD).

## Stack & Environment

- **Language**: Bash, Python, Markdown (skills and commands)
- **Runtime**: CLI Plugins
- **Package Manager**: `uv` (Python)

## Project Structure

```
ck-skills/
├── AGENTS.md                    # This file — read first, always
├── README.md
├── CHANGELOG.md
├── TODO.md                      # Informal backlog (not a spec)
├── .claude-plugin/              # Marketplace manifest
├── .markdownlint.json           # Shared lint config
├── .pre-commit-config.yaml      # Quality gate (see AI Agent Workflow)
├── collections/                 # Curated tool/skill lists
├── docs/                        # Project documentation
├── plugins/                     # Self-contained plugin packages
│   ├── ck/
│   │   ├── commands/
│   │   └── skills/              # decision-capture, doc-review-commands, plan-doc,
│   │                            # python-lint-fix, sdd-git-commit, sdd-project-init,
│   │                            # session-close, ste-procedure
│   ├── llm-wiki/
│   └── python-repo-init/
├── scripts/                     # Repo tooling (e.g. check_frontmatter.py)
├── specs/
│   ├── requirements.md          # What + Why  (edit before any feature)
│   ├── design.md                # How         (edit after requirements approved)
│   └── tasks.md                 # Ordered tasks (edit after design approved)
├── tests/                       # Project-wide tests (BATS)
└── work/                        # Gitignored scratch space (work/tmp/)
```

## Plugin Architecture

How a skill reaches a user:

```
.claude-plugin/marketplace.json      # lists plugins: name, version, source
   ↓ source: ./plugins/<plugin>
plugins/<plugin>/.claude-plugin/plugin.json   # plugin manifest (version, description)
   ↓
plugins/<plugin>/skills/<skill>/SKILL.md      # YAML frontmatter + instructions
plugins/<plugin>/commands/<cmd>.md            # slash commands (YAML frontmatter)
```

- Marketplace plugins: `ck` and `python-repo-init`. `llm-wiki` is installed by
  its own `install.sh` and is not in the marketplace.
- `version` and `description` must match between `marketplace.json` and the
  plugin's `plugin.json`.
- `plugin.json` must live in `.claude-plugin/`, not at the plugin root.
- After pushing marketplace changes, users need
  `claude plugin marketplace update ck-skills`; the registry is cached.

Background on these and other gotchas: `docs/lessons-learned.md`.

## Conventions

- All new features MUST start with a requirement update in `specs/`.
- **Commits**: Conventional Commits (`feat(scope):`, `fix(scope):`,
  `docs(scope):`, `refactor:`; `!` for breaking changes). Scope is the plugin
  or area, e.g. `ck`, `python-repo-init`, `marketplace`. Reference a task in
  the body (`Task: T20`) when one applies.
- Commit after every completed task in `specs/tasks.md`, marking it `[x]` first.
- **Temporary files**: create temporary scripts and scratch files under `./work/tmp/`, not `/tmp/`.
- Follow the `.markdownlint.json` standards for all documentation.
- **Shell scripts**: start new or edited scripts with `set -euo pipefail`. Fail
  with a clear message on stderr; don't swallow errors with `|| true` unless
  the failure is expected and commented.
- **Dependencies**: skills stay self-contained. Use Bash, the Python standard
  library, or tools run through `uv`/`uvx`. Ask before adding any new runtime
  dependency.
- **Ask first** before renaming a skill, command, or plugin, or changing a
  skill's `description` frontmatter — that changes how users invoke it.
- If `graphify-out/` exists (local, gitignored), read `graphify-out/GRAPH_REPORT.md` before broad exploration.
- **Keep this file current**: when an agent repeats a mistake, add a rule
  here. Put the longer story in `docs/lessons-learned.md`.

## SDD Gates — check before changing executable code

The gates apply to executable code: `plugins/**/tools/`, `install.sh` and
`uninstall.sh` scripts, `scripts/`, and `tests/`. Skill prose (`SKILL.md`,
commands), docs and `collections/` don't need a task entry. Record design
decisions for them with the `decision-capture` skill, and plan multi-item
batches with the `plan-doc` skill.

Before changing executable code, read `specs/requirements.md`,
`specs/design.md`, and `specs/tasks.md`. Then enforce these gates in order:

1. **requirements gate** — `specs/requirements.md` status must be `APPROVED`
   → If DRAFT: stop, tell the user, help them complete requirements first
1. **design gate** — `specs/design.md` status must be `APPROVED`
   → If DRAFT: stop, tell the user, help them complete design first
1. **task gate** — the work must map to an open `[ ]` item in `specs/tasks.md`
   → If missing: add the task entry before writing any code

If a gate fails, refuse to write code and name the gate that failed.
If a requirement changes mid-implementation, stop and update specs first.

## AI Agent Workflow

- Install pre-commit hooks once per clone: `uv run pre-commit install`.
- Use pre-commit as the default quality gate before commit.
- Run `bash plugins/ck/skills/python-lint-fix/tools/lint-fix.sh` to verify environment health (tools present, hook installed).
- **Never run bare `mdformat`** — only via `uvx pre-commit run mdformat --files <files>`. Without the `mdformat-frontmatter` plugin (configured in `.pre-commit-config.yaml`), mdformat irreversibly destroys YAML frontmatter in SKILL.md and command files. `scripts/check_frontmatter.py` (pre-commit + CI) blocks mangled files, but prevention beats detection.

## Testing

1. Shell tools: `bats tests/` (install with `brew install bats-core`; CI runs
   it on every push and PR). Add or update a BATS test when you change a
   script's behavior.
1. Quality gate: `uvx pre-commit run --files <changed files>` (CI runs
   `--all-files`).
1. Skills and commands: install the plugin locally and invoke the skill once
   to confirm it triggers and its frontmatter parses. Unit tests can't show
   that a skill's description actually triggers it.
1. Fix failures before declaring the task done.

## Definition of Done

A change is done only when:

- pre-commit passes, and `bats tests/` passes if shell tools changed.
- Any changed plugin has its `version` bumped (semver) in both its
  `plugin.json` and `.claude-plugin/marketplace.json`, with matching
  `description`.
- `CHANGELOG.md` has an entry for user-visible changes.
- `README.md` (and `collections/` where relevant) is updated when a skill or
  command is added, removed, or renamed.
- `specs/tasks.md` is updated when the change maps to a task.
- No scratch files remain outside `work/`, and the diff has been reviewed for
  unintended changes.

## Tool Compatibility

AGENTS.md is the single source of truth for all AI tools:

- **Claude Code** — reads AGENTS.md natively
- **Gemini CLI** — reads AGENTS.md natively
- **GitHub Copilot Chat** — reads AGENTS.md via context

## Shell: Multi-line Content

NEVER pass multi-line strings inline to the shell. Write to `work/tmp/<name>.txt` first.
