# python-repo-init

An agent-agnostic skill (packaged as a Claude Code plugin, usable from any AI
coding tool or by hand) that scaffolds a **new Python repository** pre-wired
with an AI-agent workflow governance pattern: spec-first development,
agent-agnostic instruction files, a mechanical pre-commit convention guard, and
a lifecycle-staged `data/` layout.

## Layout

```
python-repo-init/
├── .claude-plugin/plugin.json      # Claude Code plugin manifest
├── README.md                       # this file
├── commands/python-repo-init.md    # /python-repo-init slash command
└── skills/python-repo-init/
    ├── SKILL.md                    # skill definition (frontmatter + instructions)
    ├── scripts/                    # the generator (stdlib-only, cwd-independent)
    │   ├── __main__.py             #   python3 -m scripts <target>  (from skill dir)
    │   ├── __init__.py
    │   └── generate.py             #   python3 .../scripts/generate.py <target>  (any cwd)
    └── templates/                  # files copied into the new repo (with placeholders)
        ├── AGENTS.md, CLAUDE.md, GEMINI.md
        ├── README.md, pyproject.toml, mise.toml, .gitignore
        ├── .github/{copilot-instructions.md, workflows/repo-conventions.yml}
        ├── .githooks/{pre-commit, post-commit}
        ├── scripts/check_repo_conventions.py
        ├── specs/{workflow.md, memory.md, NEXT.md}
        ├── docs/README.md
        ├── src/__PKG_NAME__/__init__.py
        ├── tests/.gitkeep
        └── data/{01_raw,03_generated,work,tmp}/.gitkeep
```

## Usage

From anywhere (the generator resolves its templates relative to itself):

```bash
python3 skills/python-repo-init/scripts/generate.py ~/Projects/my-new-repo \
    --name my-new-repo --description "..." [--python 3.12]
```

Then follow the printed next steps (`git init`,
`git config core.hooksPath .githooks`, `uv sync --dev`, first commit).

## Placeholders

`__PROJECT_NAME__`, `__PKG_NAME__`, `__AUTHOR__`, `__DATE__`,
`__DESCRIPTION__`, `__PYTHON_VERSION__`. The `src/__PKG_NAME__/` directory is
renamed to the chosen package. GitHub Actions `${{ ... }}` expressions are
intentionally left untouched. `--author` defaults to `git config user.name`
(then `user.email`); Python version defaults to 3.14 and is adjustable via
`--python`.

## Relationship to sdd-project-init

`sdd-project-init` (same marketplace) is the earlier, language-agnostic SDD
scaffold. `python-repo-init` supersedes it **for Python repos**: it adds the
mechanical convention guard, git hooks + CI, the `data/` lifecycle contract,
and uv/mise tooling. Use `sdd-project-init` for non-Python projects.

## Origin

Ported from the governance pattern established in
`47688-columbia-school-district` and `junos-set-tree-sitter`. See a generated
repo's `specs/workflow.md` for the full rationale.
