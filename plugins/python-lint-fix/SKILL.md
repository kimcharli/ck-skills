---
name: python-lint-fix
description: Runs Ruff (Python), mdformat (Markdown), and markdownlint (Markdown) checks, auto-fixes issues, and verifies tests pass. Use when the user asks to lint, fix, format, or clean up code.
---

# Python Lint Fix

This skill runs auto-fixers and formatters for Python and Markdown to ensure the repository remains in a clean, consistent state.

## References

- **MarkdownLint Rules**: [DavidAnson/markdownlint Rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- **Ruff Documentation**: [Ruff Rules](https://docs.astral.sh/ruff/rules/)

## Quick Run

Run the bundled script to fix, format, verify, and test in one shot:

```bash
# Path will be injected by Claude Code at runtime based on installation location
bash ~/.claude/commands/ck/lint/tools/lint-fix.sh
```

## Workflow

### Step 1: Python Auto-fix (Ruff)

Ruff is used for both linting and formatting.

```bash
uv run ruff check --fix .
uv run ruff format .
```

### Step 2: Markdown Auto-format (mdformat)

Mdformat ensures consistent Markdown structure.

```bash
mdformat .
```

### Step 3: Markdown Linting (markdownlint)

Markdownlint checks for style issues and consistency.

```bash
markdownlint --fix 'docs/**/*.md' 'CHANGELOG.md' 'README.md'
```

### Step 4: Verification

Verify that all checks now pass.

```bash
uv run ruff check . && uv run ruff format --check .
```

### Step 5: Testing (pytest)

Ensure formatting changes didn't break any functionality.

```bash
uv run pytest -q
```

## Summary Reporting

After completion, report:

- Files modified.
- Types of issues fixed (unused imports, formatting, markdown spacing).
- Final test status.
