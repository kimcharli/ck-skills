# Pre-commit Integration Analysis

## Context

The `python-lint-fix` plugin currently uses a shell script (`lint-fix.sh`) to run linting,
formatting, and tests. This document analyzes whether and how `pre-commit` could replace or
complement that workflow.

## Tool Comparison

### `uv run ruff` (direct)

- Fast, single-tool execution
- Good for CI checks, editor integrations, ad-hoc fixing
- Minimal setup — configured via `pyproject.toml`
- No coordination with other tools

### `uv run pre-commit` (hook pipeline)

- Orchestrates multiple tools in sequence via `.pre-commit-config.yaml`
- Designed to run automatically on `git commit` (after `pre-commit install`)
- Each hook runs in its own isolated environment
- Enforces consistent checks across contributors without relying on manual discipline
- Has friction with `uv`: pre-commit manages its own virtualenvs, partially bypassing `uv`'s
  environment

## How pre-commit Works

On every `git commit`:

1. Git triggers the pre-commit hook
1. Configured hooks run (ruff, markdownlint, etc.)
1. If any hook fails or modifies files → **commit is blocked**
1. Developer stages the fixes, then retries `git commit`
1. Only when all hooks pass does the commit complete

Auto-fix hooks (e.g., `ruff --fix`) modify files in place but still fail the hook, forcing
review before re-committing. Skip with `git commit --no-verify` when needed.

## Mapping lint-fix.sh Steps to pre-commit

| `lint-fix.sh` step                    | pre-commit hook                                  | Translates?                    |
| ------------------------------------- | ------------------------------------------------ | ------------------------------ |
| `uv run ruff check --fix .`           | `ruff` hook with `--fix` arg                     | Yes                            |
| `uv run ruff format .`                | `ruff-format` hook                               | Yes                            |
| `markdownlint --fix`                  | `markdownlint` hook                              | Yes                            |
| `uv run pytest -q`                    | `pytest` hook                                    | Yes                            |
| `mdformat` (via `uvx`)                | `hukkin/mdformat` with `additional_dependencies` | Yes — plugins pinned in config |
| Tool availability checks              | Not supported                                    | No — pre-commit fails hard     |
| markdownlint version check (≥ 0.45.0) | Not supported                                    | No                             |

**Note on mdformat:** pre-commit hosts it at `https://github.com/hukkin/mdformat`. Plugins are
declared via `additional_dependencies` and installed into pre-commit's isolated env via `pip`
(not `uv`). Pin versions explicitly to replicate `uv.lock` guarantees.

## Decision Options

### Option A: pre-commit as auto-fixer + gate (recommended)

All tools run inside pre-commit with auto-fix enabled. On commit:

1. pre-commit runs all hooks with `--fix` / mutating mode
1. If files are changed → hooks fail, commit is blocked
1. Developer stages the fixes (`git add -u`) and re-commits
1. All hooks pass → commit completes

`lint-fix.sh` becomes a convenience shortcut for "fix everything before committing" but is
no longer the authoritative source of truth.

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.9.10
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/hukkin/mdformat
    rev: 0.7.22
    hooks:
      - id: mdformat
        additional_dependencies:
          - mdformat-gfm==0.3.7
          - mdformat-frontmatter==2.0.8
          - mdformat-tables==1.0.0
          - mdformat-shfmt==0.2.0

  - repo: https://github.com/igorshubovych/markdownlint-cli
    rev: v0.45.0
    hooks:
      - id: markdownlint
        args: [--fix]
```

**Setup once per clone:**

```bash
uv run pre-commit install
```

### Option B: lint-fix.sh as fixer, pre-commit as check-only gate

1. Developer (or AI agent) runs `lint-fix.sh` — auto-fixes everything
1. pre-commit runs in check-only mode — blocks commit if anything is still dirty

Useful when you want explicit control over the fix step (e.g., AI agents that run lint before
staging). Requires discipline: the fix step must happen before `git commit`.

```yaml
# .pre-commit-config.yaml (check-only)
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.9.10
    hooks:
      - id: ruff
      - id: ruff-format
        args: [--check]

  - repo: https://github.com/hukkin/mdformat
    rev: 0.7.22
    hooks:
      - id: mdformat
        args: [--check]
        additional_dependencies:
          - mdformat-gfm==0.3.7
          - mdformat-frontmatter==2.0.8
          - mdformat-tables==1.0.0
          - mdformat-shfmt==0.2.0

  - repo: https://github.com/igorshubovych/markdownlint-cli
    rev: v0.45.0
    hooks:
      - id: markdownlint
```

### Option C: Keep lint-fix.sh only, skip pre-commit

- Simplest — no new tooling
- Relies on `AGENTS.md` convention: "run `lint-fix.sh` before completing a task"
- No automatic enforcement; suitable for solo AI-driven workflows only

## Recommendation

**Option A** is the most effective use of pre-commit. It:

- Eliminates the "forgot to lint" problem entirely
- Covers all tools including mdformat
- Works for both human and AI-agent contributors
- Makes `lint-fix.sh` optional rather than mandatory

**Option B** is preferred when AI agents drive commits, since the agent explicitly runs
`lint-fix.sh` before staging — pre-commit then serves as a safety net rather than the
primary fixer.

**For this project:** adopt **Option A** with pre-commit auto-fix. Update `AGENTS.md` to
replace the `lint-fix.sh` convention with `pre-commit install` setup instructions. Keep
`lint-fix.sh` as a standalone convenience script but remove it from required workflow.

## Recommended Setup Matrix

| Mode                                         | Install pre-commit                                 | Hook install                             | Typical use                                          | Pros                                                         | Tradeoffs                                                          |
| -------------------------------------------- | -------------------------------------------------- | ---------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------ |
| Standalone (pipx/pip/brew)                   | `pipx install pre-commit` (or equivalent)          | `pre-commit install`                     | Mixed-language repos, no `uv` requirement            | Most portable, independent of project Python tooling         | Separate toolchain from `uv`, less consistent with Python workflow |
| UV-centric local (recommended for this repo) | `uv tool install pre-commit` or project dependency | `uv run pre-commit install`              | Python-first contributors already using `uv`         | Consistent command surface (`uv run ...`), simple onboarding | Hooks still run in pre-commit-managed envs (not `uv.lock`)         |
| CI-friendly gate                             | Installed in CI runner image or job step           | `pre-commit run --all-files` in pipeline | Enforce checks server-side regardless of local setup | Deterministic gate, prevents bypass drift                    | Slower feedback than local hook, requires CI config                |

### Recommended Combination

Use a layered model:

1. Local developer flow: UV-centric (`uv run pre-commit install`)
1. Commit-time enforcement: pre-commit git hook
1. CI enforcement: `pre-commit run --all-files`

This provides fast local feedback plus a non-bypassable CI gate.

### Notes on Dependencies

- pre-commit is standalone and does not require `uv`.
- `uv` is recommended here for command consistency, not because pre-commit depends on it.
- Hook dependencies are resolved in pre-commit's own isolated environments.
- For mdformat plugins, pin versions in `additional_dependencies` to keep behavior stable.

### Migration Steps (Option A)

1. Add `.pre-commit-config.yaml` to repo root
1. Install pre-commit using selected mode from the matrix
1. Install hooks (`uv run pre-commit install` for UV-centric mode)
1. Add CI job step: `pre-commit run --all-files`
1. Update `AGENTS.md` workflow section
1. Update `python-lint-fix` SKILL.md to reference pre-commit
1. Keep `lint-fix.sh` for manual use; remove from required pre-task checklist
