---
name: jtac-case-draft
description: Draft or update a vendor (JTAC) case from lab evidence - problem, environment, minimal config, exact reproduction, what we see, what we expect, workarounds tried, questions, data available - and keep it in step with the lab log. Use when asked to "draft a JTAC case", "open a case with Juniper", "write it up for the vendor", or when a lab result changes the facts of an existing draft.
---

# JTAC case draft

A case draft is a stand-alone summary for a vendor engineer who has not seen the repo.
It holds only measured facts, and each one cites its raw evidence. The owner files the
case; the agent never does.

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### jtac-case-draft`. Each
`<key>` below is a row of that table. Without bindings, ask the user where the draft
goes and where the lab evidence is.

Keys: `<draft file>`, `<lab log>`, `<raw evidence>`, `<devices>`, `<commit>`, `<owner>`.

## Steps

### 1. Write the draft

```markdown
# JTAC case draft: <symptom in one line, in vendor terms>

Status: draft, not filed. | filed as case <number> (<date>, by <owner>).
Lab: <site>. Tests: <dates>, times <TZ>. Full test log: `<lab log>`, sections "<...>".

**<date>: <what changed since the last version, in two or three sentences>.**   # only on updates

## Problem
<what happens, the topology in one paragraph, the cause we measured; no guesses>

## Environment
| Device | Model | Junos | Role |

## Relevant configuration
<the smallest set of `set` lines that shows the design; same lines on similar devices said once>

## How to reproduce
1. <start state>
2. <the exact command, with device, address, routing instance>
3. <how to see it: exact show/monitor commands>
<how often it reproduced: n of m runs; how to stop it>

## What we see
<capture excerpts and counters with times and counts>

## What we expect
<one or two sentences>

## Workarounds tried
| Change | Result | Problem with it |

## Questions
1. <answerable by the vendor: is it expected, a PR, a fixed release, a supported design?>

## Data available
| File | Content |
Not collected yet: <RSI, /var/log, PFE traces, ...>. The lab can run the test again on request.
```

### 2. Rules for the content

- Use vendor terms (ESI-LAG, ARP suppression, DF). Leave out repo terms (rule IDs,
  iteration numbers, decision numbers), or explain them once.
- Every statement is measured, with counts ("in each of 5 runs"). A cause that was not
  measured is labelled *inference*, or left out.
- Only lab data: no customer names, production addresses, credentials, or the contents
  of env files.
- Releases come from the latest report or capture (`<devices>`), not from memory.

### 3. Keep it current

- When a section of `<lab log>` changes a fact in the draft (the fault no longer
  reproduces, a new release was tested, a new workaround), update the draft in the same
  session. Put a dated bold paragraph under Status, and edit the affected sections.
- Keep "How to reproduce" at the last state that reproduced, and give its date.
- When the lab log has "Not done: the result in the case draft", do that update first.

### 4. Hand-off

- Commit the draft (`<commit>`). Tell `<owner>` which files from `<raw evidence>` to
  attach and what the "Not collected yet" list still needs from the devices.
- When `<owner>` files it, set Status to "filed as case <number> (<date>)".
