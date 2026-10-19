---
name: ste-procedure
description: >-
  Write or revise step-by-step operational procedures (MOPs, runbooks, change
  and maintenance procedures, SOPs, rollback plans) in Simplified Technical
  English style based on ASD-STE100. Use when asked to write a MOP, runbook,
  change procedure, cutover or rollback plan, or to make a procedure clearer.
  Not for explanations, design docs, or chat answers.
---

# STE Procedure Writing

Write procedures that an engineer can follow under pressure, during a change window, with no room for misreading. The style follows ASD-STE100 writing rules. It is not certified STE: the official dictionary is not checked, so do not label output "STE100 compliant".

## Writing rules

### Sentences

- Procedural sentences: 20 words maximum. Descriptive sentences: 25 words maximum.
- One instruction per sentence. Two actions in one sentence only if done at the same time.
- Write instructions as commands (imperative): "Shut down the interface."
- Use active voice. Name who or what does the action.
- Put a condition before the instruction: "If the session is down, stop the procedure."
- Paragraphs: one topic, 6 sentences maximum.

### Words

- One word, one meaning. Use the same term for the same thing every time: do not switch between "router", "device", and "box".
- Use simple verbs: "use", not "utilize"; "start", not "initiate"; "make sure", not "ensure that it is the case".
- Use simple tenses: present, past, future. Avoid "-ing" verb forms except in technical names.
- Keep articles ("a", "the"). Do not write telegraphic text.
- No contractions, idioms, or vague words ("appropriately", "as needed", "should be fine").
- Technical names are allowed: hostnames, interfaces, commands, product names. Copy them exactly.

### Commands and values

- Put every CLI command, config line, and expected output in a code block, exactly as typed or shown.
- Use placeholders in angle brackets and define them once: `<spine-1>`, `<asn>`.
- Give a measurable expected result for each check: state, count, value, or exact output line.

### Warnings and cautions

- Put a WARNING (risk to people) or CAUTION (risk of outage, data loss, or equipment damage) **before** the step it applies to, never after.
- State the hazard, then the consequence, then the action: "CAUTION: This step drops BGP sessions on spine-1. Traffic shifts to spine-2. Confirm spine-2 is healthy before you continue."
- Notes give information only. Never put an instruction in a note.

## Procedure structure

Use this structure. Omit a section only if it truly does not apply, and say so.

1. **Title**: action + object + scope. Example: "Replace leaf-3 uplink optic (et-0/0/48)".
1. **Purpose**: one or two sentences.
1. **Impact**: expected service impact and duration, or "No impact expected".
1. **Prerequisites**: approvals, access, tools, spares, backups, maintenance window.
1. **Abort criteria**: the conditions that stop the procedure and start rollback.
1. **Pre-checks**: numbered checks, each with an expected result. Capture baseline output.
1. **Procedure**: numbered steps. For each step:
   - the action (one instruction),
   - the command in a code block,
   - `Expected:` the measurable result,
   - `If not:` what to do (usually stop, or go to a rollback step).
1. **Verification**: compare against the pre-check baseline.
1. **Rollback**: numbered steps, written to the same standard. Name the step from which rollback starts.
1. **Post-work**: close tickets, save configs, notify, record results.

## Example

Bad:

> Once you've made sure everything looks OK on the spine, go ahead and bring down the leaf uplink and swap the optic, then check things are back to normal.

Good:

> CAUTION: This step removes one uplink from leaf-3. Traffic uses the remaining uplink.
>
> 4. Disable the uplink interface on leaf-3.
>
>    ```
>    set interfaces et-0/0/48 disable
>    commit confirmed 10
>    ```
>
>    Expected: `et-0/0/48` is down. BGP to spine-1 is down. BGP to spine-2 is Established.
>
>    If not: Stop. Go to Rollback step R1.

## Final check

Before you deliver, examine the procedure:

- [ ] Each step has one instruction, written as a command.
- [ ] No procedural sentence is longer than 20 words.
- [ ] Each check has a measurable expected result and an `If not:` action.
- [ ] Each WARNING or CAUTION is before its step.
- [ ] Terms, hostnames, and placeholders are consistent from start to end.
- [ ] Rollback exists and starts from a named step.
- [ ] Commands are exact and in code blocks. Do not invent commands or output: mark anything unverified as `TODO: verify`.
