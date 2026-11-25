---
name: lab-iteration
description: Roll a rendered change out to a lab site, run a numbered test iteration, and record the result (iteration folder, dated lab-log section, design history, NEXT pointer) in one lab-docs commit. Use when asked to push/roll out to a lab, run the repo's test command, "run an iteration", test a hypothesis on the lab, or record lab results. Also for temporary experimental states that must be left "as rendered" afterwards. Needs the repo's "Skill bindings" for lab-iteration.
---

# Lab iteration: roll out, test, record

One iteration is one numbered test run on one site, kept in the repo together with the
facts that explain it. A session may hold several iterations and experiments; they all
go into one log section and one commit.

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### lab-iteration`. Each
`<key>` below is a row of that table, and its "Notes" rows override the defaults here.
If the repo has no bindings for this skill, ask the user for the values the task needs.
Do not guess paths or commands.

Keys: `<site intent>`, `<secrets>`, `<render>`, `<push>`, `<test setup>`, `<test>`,
`<report again>`, `<scenarios>`, `<iteration folder>`, `<lab log>`, `<raw evidence>`,
`<design history>`, `<pointer>`, `<owner>`, `<time zone>`, `<deploy-match check>`,
`<inputs check>`, `<commit>`.

## Steps

### 1. Before any device write

- **Get a "go" from `<owner>`** for every device write that the plan or chat has not
  already approved: push, a hand `delete`, reboot, upgrade (`junos-image-upgrade`),
  test setup. Read-only commands need no "go".
- `git --no-optional-locks status`: commit intent, templates and policy files first
  (`rule-change` skill). Uncommitted inputs make `<inputs check>` fail, and the run is
  not reproducible.
- The repo's tests pass. `<render>` gives no diff in generated config, or that diff is
  committed.
- **Pick N** = the highest existing `<iteration folder>` + 1. A test tool may overwrite
  an existing folder without asking.
- Never print or commit `<secrets>`.

### 2. Make the change

- Rendered change: `<push>`. Read the push notes in the bindings. A merge-type push
  never removes a line: a removal is one hand `delete` in a confirmed-commit window.
  Check it, then confirm, and write the line and the time in the change table (step 4).
- Temporary experiment (not rendered config): always use a commit that rolls itself
  back (Junos `commit confirmed`). At the end the site is **left as rendered**, and
  `<deploy-match check>` in the next iteration shows it.
- Note the time (`HH:MM:SS` + `<time zone>`) of each change and trigger as you go. You
  cannot get them back later.

### 3. Run and read

- `<test setup>` when the test environment is not up; then `<test>` with N and a
  `<scenarios>` name.
- Read the report summary per rule. Compare PASS / FAIL / INFO / SKIP with the last
  iteration of the same state. Explain each new FAIL, or say that it is not explained.
- Diff the stored routing tables or state against the previous iteration when the
  folder has them (`diff -ru`).
- An iteration right after triggers or a change can carry transient FAILs. Run one more
  for the steady state, and record both.
- Regenerate a report with `<report again>`; do not hand-edit it.

### 4. Write the lab-log section

Append to `<lab log>`:

```markdown
## <subject>: <one-line result>. <Rolled out | Tested>, iteration <N>[, <M>] (<YYYY-MM-DD>, <HH:MM> to <HH:MM> <TZ>)

<owner>, <date>: "<verbatim ruling or ask>". Decision NNNN, commits `<first>` to `<last>`.
Raw output: `<raw evidence>/<folder>/` (<files>).

**Result: <one or two sentences, the answer first>.**

| Device | Change | How |
|---|---|---|

| Trigger, <k> each | Before | After |
|---|---|---|

- **Iteration <N> (<HH:MM>): PASS <p>, FAIL <f>.** <each FAIL, or "as iteration <prev>">
- *Inference:* <a cause that was not measured>
- Not tested: <what this does not show>
```

Rules for the text:

- Counts as "n of m", never "all" or "most".
- Put *Inference:* on every cause that was not measured. "Not found" is an allowed
  answer.
- Quote `<owner>` verbatim, typos included.
- One fact per bullet, in simple English (`ste-procedure` style).

### 5. Update the history and the pointer

- `<design history>`: one row per iteration. Update the "what the tests show" parts when
  a result is new, and update its "as of" line. If the history is several iterations
  behind, tell the user rather than back-filling it unasked.
- `<pointer>`: the state of the site now (as rendered or not), the last iteration and
  its counts, and what is open or waits for `<owner>`.

### 6. Commit

`git add` explicit paths only: each iteration folder, `<lab log>`, `<design history>`,
`<pointer>`. Never `<raw evidence>` or `<secrets>`.

Use the message form of `<commit>`: the subject ends with `(iterations N, M)`. The body
holds `<owner>`'s ask verbatim, the key results as bullets, and "state left as rendered".
If `<pointer>` needs a large rewrite, put it in a second commit. Do not mix in intent,
template, policy or generated config changes; those belong to `rule-change`.

## Done when

- The site is as rendered, or the log and `<pointer>` say what is not and why.
- Each iteration folder is committed with a log section that cites it.
- The final message gives: the iteration numbers and counts, the result in one line, and
  what was not tested.
