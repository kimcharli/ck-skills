---
name: lab-test-plan
description: Write, run and close a lab experiment plan (specs/<topic>-plan-<date>.md) before any test that changes device state - viability, factors, classes, staged steps, scope rulings, questions with defaults, risks, commit sequence, verification - then record the result and follow-ups in the same file. Use when asked to "plan a test", "is it viable", "find which combinations/states cause X", test a release or a hypothesis on a lab, or to add a follow-up to an existing plan. Extends plan-doc for lab experiments.
---

# Lab test plan

A plan is a committed file before the first device change. The owner approves it, and
its result goes back into it. For a batch of code or doc changes with no lab test, use
`plan-doc`; the sections marked *build* below fit there too.

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### lab-test-plan`. Each
`<key>` below is a row of that table, and its "Notes" rows override the defaults here.
Without bindings: plans go in `specs/<topic>-plan-<YYYY-MM-DD>.md` (or `docs/`), and
you ask the user who the owner is.

Keys: `<plan file>`, `<pointer>`, `<owner>`, `<scratch>`, `<existing measurements>`,
`<temporary state>`, `<record>`, `<deploy-match check>`, `<commits>`.

## Steps

### 1. Write the plan (no device write while writing it)

Title: `# <subject> — test plan (<YYYY-MM-DD>)` (*build*: `— plan (<date>)`).

Sections, in this order. Leave out a section only when it has nothing to say.

1. **Status**: who asked, with their words verbatim, and the date. Write "awaiting
   approval" until `<owner>` says "go", then the approval in their words, and which
   defaults apply. Add "No device was touched to write this plan".
1. **Is it viable**: give the answer first (yes / no / yes with a condition). Then: does
   the measurement exist already (`<existing measurements>`), the size of a full matrix
   against a staged search (count × time per trigger), and the condition that can end
   the plan early.
1. **Context**: the fault or question, with an ID, and the baseline that was measured (a
   table with the date and time).
1. **Classes / The measurement**: what one trigger gives, and how each outcome is
   classed. Counts must decide the class.
1. **Factors**: each factor and its values, and where each value comes from.
1. **Scope rulings**: a table `| Item | Ruling | Kind |`. Kind is one of `by design`,
   `deferred (Qn)` or `dropped`. Always say whether intent, templates, policy or
   generated config change.
1. **Questions for `<owner>`**: `Qn <topic>. Default: ... Option: ...`. Every question
   needs a default, so that a plain "go" settles them all.
1. **Steps**: lettered stages. `P` = before (read only), `S0` = the lab as it is, then
   `S1`… one factor at a time, `M` = the stop or fix with the least harm, `R` =
   regression, `E` = end (every `<temporary state>` rolled back, the site as rendered,
   one iteration). For each stage give the commands or scripts, the number of repeats,
   and the exit or branch condition. Ad hoc scripts live in `<scratch>`, each with an
   assert-based self-check against a known baseline. (*build*: **Items to execute**
   `### n. <item> — <path>`, in commit order.)
1. **The record**: the form of the result in `<record>`. By default the result line
   first, then one table, then what was not tested.
1. **Risks**: what can break, how long it lasts, and how it is stopped. Also how a
   rollback during a trigger is detected.
1. **Parked**: a table `| Item | Who | Where |`.
1. **Commit sequence**: the commits in order. Say which commits must not hold intent,
   template, policy or generated config changes.
1. **Verification**: checks that prove the plan ran as written: the baseline
   reproduced, the counts per combination, `<deploy-match check>` passes at the end,
   and the generated config is unchanged in `git status`.

### 2. Commit the plan, then wait

- One commit with the plan and a pointer in `<pointer>` (form in `<commits>`).
- Do not change a device until `<owner>` says "go". After the "go", update the Status
  line in the same file and say which defaults now apply.

### 3. Run it

- Follow the stages as written. If you must deviate, note it as you go.
- Stop at any question whose default is "stop and ask".
- Record the run with `lab-iteration`.

### 4. Close the plan

- Add a bold **Result, <date time TZ>:** paragraph under Status. Say where the plan
  ended, the answer, and where the record is. Then **Not as planned:**, listing each
  deviation.
- *build* plans: add a `## Result (<date>)` section.
- Commit the result (form in `<commits>`), unless the plan's commit sequence puts it in
  the lab-docs commit.

### 5. Follow-ups

When `<owner>` extends a closed plan, append `## Follow-up N` to the same file, with
the same sections in short form, and commit it and later its result. Start a new plan
file only for a new question.

## Done when

- The plan was committed before the first device write, and its Status shows the
  approval.
- The Status shows the result and the deviations. `<pointer>` points to the result.
- Every temporary state was rolled back, or the record says what was left and why.
