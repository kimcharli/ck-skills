# AGENTS.md

Canonical instruction file. `CLAUDE.md` and `GEMINI.md` point here — edit
only this one. Repo layout, tooling, and routing: `specs/project.md`.

## Start Here

Before anything else, every session, read in this order:

1. `specs/NEXT.md` — current actionable work. Session-local todos do not
   persist; this file is the durable handoff.
2. `specs/project.md` — this repo's layout, build workflow, conventions.

## Output Discipline

Budgets below are per user request, not per step. A task taking twenty tool
calls gets the same budget as one taking a single tool call.

- **Edit, never rewrite.** Use the smallest unique anchor. Whole-file writes
  are permitted only for files you are creating. If a change would touch
  more than 30% of an existing file, say why in one line first.
- **Silence while working.** Emit no prose between tool calls: no progress
  updates, no step announcements, no restating what a command just
  returned. Tool calls are already visible. Speak when done or blocked.
- **No preamble.** Do not announce what you are about to do or restate the
  request. Begin with the first action.
- **Prose budget: 4 sentences per request.** Headers, bullets, tables, and
  bold labels each count as a sentence. Code, file paths, commands, and
  command output do not count.
- **Surface risk, 3 lines maximum:** assumptions you had to make, blockers,
  spec/code conflicts, tests you could not run. Past three, give the most
  consequential and say how many remain. Brevity applies to narration,
  never to risk.
- **Closing report — this shape, nothing else:**

      <file>: <n> lines changed
      <verification command> -> <result>

  No narrative account of what changed. The diff is the summary.

## Execution Rules

- **Surgical changes.** Touch only what the task requires. Do not refactor
  or reformat anything you passed on the way.
- **Decide, then note.** Decide reversible details yourself and record the
  assumption in one line. Ask first only when the action is irreversible,
  touches a live system, or when two specs conflict.
- **Definition of done.** No placeholders, no `TODO` markers, no stubs.
  Done means the test passes and the convention check is clean.
- **Verify, do not assert.** Report the command you ran and its actual
  output. Never describe a test as passing without having run it.
- **Match existing patterns.** Check `specs/memory.md` and
  `specs/workflow.md` before introducing any new library, framework, or
  file layout. If a new dependency is genuinely needed, say so and stop.

## Durable Facts

`specs/memory.md` is the only memory store. Append to it when a decision or
convention is established that a future session would otherwise rediscover.
Do not create parallel memory files or rely on any tool's private memory —
those are machine-local and lost on a clone.

## Improvement Proposals

Propose changes to this file, the hooks, and the skills; never apply them.
You may not edit this file, any hook, or any skill unless told to in the
current session — acceptance of a proposal is not that instruction.

Append to `specs/improvements.md`, which defines the entry format and
limits, when and only when one of these occurs:

- the same correction was given twice
- a rule here was ambiguous or self-contradictory and you had to guess
- a rule here must hold every time but cannot be checked mechanically
- a multi-step procedure repeated and is captured nowhere
- a documented convention no longer matches the code

## Standing Principle: Agent-Agnostic by Default

Every spec, tool choice, and instruction added to this repo must remain
usable by any AI coding tool, not just the one that authored it. This is
binding, not advisory.

Practical test: if an instruction names a specific vendor, tool, or
proprietary file path, it does not belong in this file. Put it in that
tool's own configuration instead.
