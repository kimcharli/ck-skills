---
name: skill-review
description: >-
  Evidence-based periodic review of agent skills. Finds drift from real use
  (commit forms, artifact formats, bindings that no longer resolve, owner
  corrections repeated more than once, overlapping triggers, unused skills),
  proposes ranked changes for approval, applies the approved ones (rewrites
  via skill-creator), and logs the review. Use when the user says "review my
  skills", "skill review", "revise the skills", "improve the skills", "are my
  skills still accurate", or invokes /skill-review. Not for new skills: use
  skill-creator or create-skill for those.
---

A skill is right when it matches what the owner does now. This review compares
each skill with evidence from real use and changes it only where the evidence
shows a gap. No evidence, no change.

## 1. Scope

- **Skills.** Default: every entry in `~/.agents/skills/`. The user can name a
  subset. Resolve each with `realpath`; edit the file in the git repo that
  holds it. A skill outside git is "no history": review it, but say so.
- **Since.** The date of the last entry in the skills repo's
  `docs/skill-reviews.md`. If the file is missing, create it at step 7 and ask
  for a start date (default: 90 days ago).
- **Project repos.** Repos whose `AGENTS.md` has a `## Skill bindings`
  section. Ask once which folders to search (default `~/Projects`), and write
  the answer into the review entry so the next review reuses it.

## 2. Evidence (read only)

Collect per skill. Run read-only commands only.

**Static**

- Frontmatter parses; `name` equals the folder name; `description` is at most
  1024 characters.
- Every file, script and skill that the body names exists.
- Every `<key>` has a row in each repo's `### <skill>` bindings table, and
  every row is used by the skill.
- Each command in a binding answers `--help`. Never run a command that writes
  to a device, a repo or a remote.

**Use**

- `git log --since=<since>` in each project repo: count commits that match the
  skill's commit forms. Note forms the owner used instead.
- Compare the last 2–3 artifacts the skill makes (plan files, lab-log
  sections, recaps, decision records) with the skill's template. Drift needs
  2 or more instances; one is noise.
- No use since the last review: a merge or retire candidate, not a defect.

**Corrections**

- `git log -p --since=<since> -- AGENTS.md` in each repo, the skills repo's
  `docs/lessons-learned.md`, and notes in `specs/NEXT.md`: rules added after a
  skill ran are corrections the skill missed.
- Ask the user one question: "What did you correct more than once?"

**Triggers and size**

- Two descriptions that match the same request.
- Steps that restate `AGENTS.md` or another skill: replace with a pointer.
- Repo-specific values (paths, hostnames, commands) in a global skill: move to
  the repo's bindings.

## 3. Findings

One table, ranked by impact:

| # | Skill | Kind | Evidence | Proposed change |
| -- | -- | -- | -- | -- |

Kinds: `broken binding`, `drift`, `gap`, `correction`, `trigger`, `trim`,
`move to bindings`, `merge/retire`. Evidence cites commits, files or the
user's answer. Label inferences as inferences. End with a line on what was not
checked (for example: no repos searched for skill X, `--help` not available).

## 4. Approval

Ask the user per row. A row without an answer means no change. A name or
`description` change, a merge or a retirement needs an explicit OK, even if
the user approved "all".

## 5. Apply

- Small edits (a step, a commit form, a binding row): edit directly.
- Rewrites and `description` changes: use `skill-creator` if it is installed;
  if not, edit directly and say so.
- A fact true for one repo goes in that repo's bindings. A lesson that applies
  to 2 or more repos goes in the skill.
- Edit at the real path from step 1, not through the `~/.agents/skills`
  symlink.

## 6. Validate

- Repeat the static checks of step 2 for each changed skill.
- In the skills repo: `uvx pre-commit run --files <changed files>`.
- Optional: run the changed skill once on a real request and compare the
  result with the change.

## 7. Record

Append to the skills repo's `docs/skill-reviews.md`:

```markdown
## <YYYY-MM-DD>

- Skills: <names>
- Repos searched: <paths>
- Since: <date>
- Changed: <#row: one line each>
- Rejected or deferred: <#row: reason>
- Next review: <date + 30 days>
```

Follow the skills repo's own rules (version bump, `CHANGELOG.md`, README).
Commit each repo separately, with explicit `git add` paths. Ask before each
commit.

## Do not

- Change a skill without evidence from step 2.
- Rename, merge or delete a skill without an explicit OK.
- Run a write command to test a binding.
- Back-fill a repo's stale records during the review: report them as a
  finding.
