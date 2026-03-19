# Python Lint Fix

One-shot auto-fix and formatting for Python (Ruff) and Markdown (mdformat, markdownlint). It handles linting, formatting, verification, and testing in a single command.

---

## Installation

For marketplace setup and general install instructions, see the [ck-skills README](../../README.md).

**Quick install:**

```bash
# Claude Code
claude plugin install python-lint-fix@ck-skills

# Copilot CLI
copilot plugin install python-lint-fix@ck-skills

# Manual
cd plugins/python-lint-fix && ./install.sh
```

---

## Usage

**Claude Code:**
```
/ck:lint
```

Or naturally:
```
Fix lint errors
Lint and format my code
Make it clean and passing
```

---

## Workflow

1.  **Python Auto-fix**: Runs `ruff check --fix` and `ruff format`.
2.  **Markdown Auto-format**: Runs `mdformat`.
3.  **Markdown Linting**: Runs `markdownlint --fix`.
4.  **Verification**: Confirms a clean state.
5.  **Testing**: Runs `pytest -q` to ensure no regressions.

---

## Requirements

- **Python**: Ruff, pytest (recommended: installed via `uv`)
- **Markdown**: mdformat, markdownlint-cli (installed via `npm`)

---

## Related

- [sdd-project-init](../sdd-project-init/README.md) — bootstrap a new SDD project
- [sdd-git-commit](../sdd-git-commit/README.md) — professional SDD commit workflow
- [ck-skills](../../README.md) — full marketplace README
