---
name: sdd-git-commit
description: >-
  Commit workflow for Spec-Driven Development repos: checks the diff for
  secrets and junk files, keeps specs, the task list, the session pointer and
  the CHANGELOG in step with the code, then writes a Conventional Commits
  message. Use whenever the user asks to commit, "commit this", "make a
  commit", "check this in", or to finish a task with a commit in a repo that
  has specs/, a tasks list or a CHANGELOG, even if they do not mention specs.
  For only drafting a commit message with no repo bookkeeping, a lighter
  commit-message skill fits better.
---

# SDD Git Commit

A commit in a spec-driven repo is the moment code, specs and project state must agree. A future session reads the specs and the log, not this chat, so anything not recorded at commit time is lost.

Before you start, read the repo's own `AGENTS.md` (or `CLAUDE.md`). Its commit rules, file names and trailers win over the defaults below. Use the files the repo already has; do not create new tracking files.

## Step 1: Inspect

1. Run `git status --short` and `git diff --staged` (or `git diff HEAD` if nothing is staged). Know what goes in before you touch anything.

1. Check for files that must not be committed:

   ```bash
   git diff --staged --name-only | grep -iE '(\.env$|\.secret|\.key$|\.pem$|node_modules/|__pycache__/|dist/|build/|\.cache)'
   ```

   No output means nothing matched. If something matched, tell the user, unstage it, and propose a `.gitignore` entry. Do not print the contents of a file that may hold a secret.

1. If the diff mixes unrelated changes, say so and propose separate commits. One logical change per commit keeps history revertible.

## Step 2: Quality gate

Run the repo's documented check (pre-commit, `make lint`, `npm test`, a `scripts/check_*.py`). If a formatter rewrites files, re-stage only the files that were already staged:

```bash
list=$(mktemp)
git diff --staged --name-only -z >"$list" # before running the formatter
xargs -0 git add -- <"$list"              # after
```

Do not use `git add -u` or `git add -A`: they stage unrelated work the user did not ask to commit. If the check fails, fix the cause or report it. Never bypass hooks with `--no-verify`.

## Step 3: Spec parity

For changes to executable code, check that the specs still describe what was built:

1. Find the spec that covers each changed area (`specs/`, `docs/specs/`, or what `AGENTS.md` names).
1. If a public interface, CLI flag, file layout or behavior changed, update the spec in the same commit.
1. If the change maps to a task, mark it `[x]` in the task list (`specs/tasks.md`, `docs/tasks.md` or `TODO.md`, whichever exists).
1. If the change needs a requirement or design change the specs do not have, stop and tell the user. Specs come before code.

Skip this step for changes that touch only docs or comments.

## Step 4: Project state

Update only what this change affects:

| File | When |
| -- | -- |
| `CHANGELOG.md` | The change is visible to users (feature, fix, behavior change, removal). Follow the file's existing format. If it has an `## [Unreleased]` section, add the entry there. |
| Session pointer (`specs/NEXT.md`, or `SESSION_MEMO.md` if the repo uses that) | What is actionable next has changed. |
| Version files | The repo's rules say to bump a version for this kind of change. |

Write CHANGELOG entries for a reader who did not see the diff.

## Step 5: Commit

Use Conventional Commits unless the repo says otherwise:

```text
<type>(<scope>): <imperative summary, ≤72 chars, no period>

<why the change was made, if the summary does not say>

<trailers the repo requires, e.g. Task: T12>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`. Add `!` for breaking changes. Write multi-line messages to a file and commit with `git commit -F <file>`; inline multi-line strings break in some shells.

Push only if the user asked for it.

## Step 6: Reflect

Ask yourself if anything surprising or painful came up:

- A project quirk goes in the repo's lessons file (e.g. `docs/lessons-learned.md`), in a follow-up `docs` commit.
- A rule an agent keeps breaking goes in `AGENTS.md`, if the repo's rules say so.

Do not `git commit --amend` a commit without asking: it rewrites history the user may already have pushed.

## Report

End with the commit hash and subject, the files changed beyond the code (specs, CHANGELOG, pointer), and anything you skipped or that failed.
