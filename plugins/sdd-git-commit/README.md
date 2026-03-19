# SDD Git Commit

Orchestrates a professional Git commit workflow including hygiene checks, documentation parity (SDD), project state tracking (CHANGELOG, TODO, Session Memos), and post-commit reflection.

---

## Installation

For marketplace setup and general install instructions, see the [ck-skills README](../../README.md).

**Quick install:**

```bash
# Claude Code
claude plugin install sdd-git-commit@ck-skills

# Copilot CLI
copilot plugin install sdd-git-commit@ck-skills

# Manual
cd plugins/sdd-git-commit && ./install.sh
```

---

## Usage

**Claude Code:**
```
/ck:commit
```

Or naturally:
```
Commit my changes
Wrap up this task and commit
```

---

## Workflow

1.  **Hygiene**: Check for secrets, local configs, or build artifacts in the diff.
2.  **Lint**: Run project linting (if available).
3.  **SDD Gate**: Ensure source code and its corresponding specification file remain in sync.
4.  **State Tracking**: Update `CHANGELOG.md`, `TODO.md`, and `SESSION_MEMO.md`.
5.  **Commit**: Generate a Conventional Commit message and commit.
6.  **Reflection**: Briefly reflect on surprising findings or learned lessons.

---

## SDD Parity Table Example

The skill encourages maintaining a one-to-one relationship between source files and specifications:

| Source File | Spec File |
|---|---|
| `src/core.py` | `specs/core.md` |
| `src/api.py` | `specs/api.md` |

---

## Related

- [sdd-project-init](../sdd-project-init/README.md) — bootstrap a new SDD project
- [doc-review-commands](../doc-review-commands/README.md) — keep docs in sync during development
- [ck-skills](../../README.md) — full marketplace README
