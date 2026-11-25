---
name: rule-change
description: Turn an owner ruling into a numbered decision record, a rule-catalogue entry and its implementation (template, policy file or code, tests, regenerated config) as three ordered commits. Use when a design ruling changes generated config, a test or an audit check; when asked to "make it a rule", add/amend/retire a rule ID, write decision NNNN, or implement a decided rule. Extends decision-capture for repos with a rule catalogue. Needs the repo's "Skill bindings" for rule-change.
---

# Rule change: decision → rule → implementation

Each change of generated config or checks follows one chain of three commits, in this
order. Each commit stands alone and cites the one before it.

```
docs(decisions): NNNN <what was ruled> (<owner>)
docs(rules): <RULE-ID> <the rule> (decision NNNN)
feat(<area>): <the behaviour> (<RULE-ID>, decision NNNN)
```

Roll-out and test come after the chain (`lab-iteration`).

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### rule-change`. Each `<key>`
below is a row of that table, and its "Notes" rows override the defaults here. If the
repo has no rule catalogue, use `decision-capture` instead.

Keys: `<decisions>`, `<rule catalogue>`, `<rule id>`, `<stages>`, `<code citation>`,
`<template citation>`, `<pending list>`, `<coverage gate>`, `<values without code>`,
`<generate>`, `<checks>`, `<design history>`, `<pointer>`, `<owner>`.

## Steps

### 1. Pin the ruling

- Write down `<owner>`'s words **verbatim**, typos included. Restate the decision in
  one or two sentences and separate it from what is still open.
- If scope is unclear, ask 1–3 questions, each with a default. Record which points
  `<owner>` ruled and which are accepted defaults.
- Find what it amends: grep `<decisions>` and `<rule catalogue>` for the IDs it touches.

### 2. Decision record (commit 1)

The next number in `<decisions>`. Default form (a repo's own form wins):

```markdown
# NNNN — <decision in one line>

- Status: accepted (drafted by the coding agent from <owner>'s rulings of <date>;
  <owner> <did not see | said "ok" to> this text before the commit)[. Not run on a lab]
- Date: YYYY-MM-DD
- Decided by: <owner> (on "<question>": "<verbatim answer>"; ...)
- Plan: `<plan file>` "<section>"            # when there is one
- Evidence: `<lab log>` "<section>" (<date>)  # when there is one
- Amends: decision NNNN point N (<what>); <rule catalogue> <RULE-ID>

## Context
<the measured facts, with dates and counts; *inference* labelled>

## Decision
1. **<point in one bold sentence>.** <detail>

## Consequences
## Open
## Alternatives considered
```

- The Status line tells the truth about what `<owner>` saw. Show the user the text
  before you commit it.
- An earlier decision that this one changes keeps its text. Add one line under the
  changed point: `*Amended by decision NNNN (YYYY-MM-DD): <what>.*`
- Add a short line to `<pointer>` in the same commit.

### 3. Rule entry (commit 2)

In the right area section of `<rule catalogue>`. Default form:

```markdown
### <RULE-ID> — <title, testable>
- **Rule**: <one testable sentence; the config line(s) it renders, if any>
- **Why**: decision NNNN (<owner>, <date>: "<verbatim>"), <finding id>. <evidence with counts and path>
- **Not covered**: <what the rule does not stop>
- **Params**: <inventory keys; values never in code>
- **Enforced by**: <one or more of <stages>>
- Note: history. <dated earlier forms>
```

- A new ID is the next free number in its area (`<rule id>`). IDs are never reused or
  renumbered.
- To amend a rule, rewrite it in place and add the old form to "Note: history".
- To retire a rule, keep the heading and append `(retired YYYY-MM-DD, <reason>)`.
  Nothing may cite it afterwards.
- For each stage on the "Enforced by" line that commit 3 does not implement, add a line
  to `<pending list>`.

### 4. Implementation (commit 3)

- **Is it a value** (a format, threshold, severity, waiver, simple check, scenario,
  image)? Put it in `<values without code>`, not in code.
- **Is it rendered config?** Change a template with `<template citation>`, or code with
  `<code citation>`. Site differences go into intent fields, not per-site templates.
- **Is it a check?** Write code with `<code citation>` at the right stage.
- Add a test for each new branch, and remove the `<pending list>` lines that are now
  implemented.
- Run `<generate>`. Read the generated-config diff: each changed line must follow from
  the rule. Explain any other change, or fix it.
- Run all `<checks>`. They must pass, including `<coverage gate>`.
- `git add` explicit paths, including the generated config. Never hand-edit generated
  files.

### 5. History and hand-off

- `<design history>`: the accepted decision goes under "improved/recommended" or
  "discarded", and its item comes out of "potential". Update the "as of" line, together
  with `<pointer>`.
- No live device is touched in this skill. Give the user the push command and the
  devices it changes. Run `lab-iteration` only after `<owner>` says "go".

## Done when

- All `<checks>` pass and the generated config matches the templates.
- The three commits are in order with their citations. `git log --oneline -4` shows the
  chain.
- The final message lists: the decision, the rule ID, the files or devices whose config
  changed, and what was not rolled out.
