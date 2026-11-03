---
name: python-lint-fix
description: >-
  Check that a Python repo's lint and format tooling is ready (uv, pre-commit
  and its git hook, .pre-commit-config.yaml, markdownlint version) and run
  pre-commit across the repo on demand. Use when the user asks to lint or
  format the repo, run ruff/mdformat/markdownlint, set up or install
  pre-commit hooks, asks why hooks are not running on commit, or wants to
  check that a fresh clone is ready to work in. Not for hand-fixing one
  specific lint error.
---

# Python Lint Fix

Lint, format, and test are handled automatically by **pre-commit** on every `git commit`.
This skill checks that the environment is healthy and pre-commit hooks are installed.

## References

- **MarkdownLint Rules**: [DavidAnson/markdownlint Rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- **Ruff Documentation**: [Ruff Rules](https://docs.astral.sh/ruff/rules/)
- **pre-commit**: [pre-commit.com](https://pre-commit.com)

## First-Time Setup (once per clone)

```bash
uvx pre-commit install # install the git hook; uvx runs pre-commit without a project dependency
```

After installation, every `git commit` automatically runs:

- **ruff** — Python lint + format
- **mdformat** — Markdown format (GFM, frontmatter, tables, shfmt)
- **markdownlint** — Markdown style (`--fix`)
- **pytest** — tests on `pre-push` stage

## Environment Health Check

Run the bundled script from the target repo's root. `SKILL_DIR` is the base directory announced when this skill loaded (`Base directory for this skill: <path>`), so the script works wherever the skill is installed:

```bash
bash "$SKILL_DIR/tools/lint-fix.sh"
```

It checks: `uv`, `pre-commit`, git hook presence, `.pre-commit-config.yaml`, and markdownlint version (≥ 0.45.0).

## Manual Run (without committing)

```bash
uvx pre-commit run --all-files
```

## Summary Reporting

After running, report:

- Whether the pre-commit hook is installed.
- Any missing tools or version mismatches found.
- Next action for the user if issues were detected.
