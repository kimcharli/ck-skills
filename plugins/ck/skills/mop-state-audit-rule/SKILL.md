---
name: mop-state-audit-rule
description: >-
  Add a new hardware or protocol state collection item and a corresponding
  audit rule. Enforces platform layering, declarative rules/thresholds (never
  hardcoded in code), decision-record creation, and the full spec/code/test
  validation checklist. Trigger when asked to collect a new `show` command in
  the state collector or add a new check/rule to the audit tool. Needs the
  repo's "Skill bindings" for mop-state-audit-rule.
---

# Adding a State Collector Item & Audit Rule (`mop-state-audit-rule`)

Follow this checklist whenever a post-mortem, MOP pre-check, or fleet review reveals a gap that the state collector should capture and the audit tool should flag.

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### mop-state-audit-rule`. Each `<key>` below is a row of that table, and its "Notes" rows override the defaults here. If the repo has no bindings for this skill, ask the user for the values the task needs. Do not guess paths or commands.

Keys: `<decisions>`, `<decisions index>`, `<platform spec>`, `<rules spec>`, `<audit spec>`, `<state spec>`, `<config catalog>`, `<audit rules code>`, `<state tests>`, `<audit tests>`, `<rules model tests>`, `<checks>`, `<state collect>`, `<audit run>`, `<pointer>`.

## 1. Architectural Guardrails (Read Before Coding)

1. **Platform gating (`<platform spec>`):**
   - Probe or verify which models/dialects support the command before declaring it.
   - Check whether structured output (e.g. Junos `| display xml`) returns real structured data or merely wraps plaintext in `<output>...</output>`. If it wraps plaintext, declare `format: text` so the collector does not run the command twice.
   - Never inspect raw dialect strings or model prefixes by hand in rule code; use the repo's platform helper or declarative `when:` filter in `<config catalog>`.
1. **Rules model (`<rules spec>`):**
   - A ruling (command catalog entry, model glob list, warning/error threshold) is **declared** in `<config catalog>` (or the repo's rules file), never hardcoded as a magic constant in `<audit rules code>`.
   - Read declared values through the repo's config/rules loader; `<rules model tests>` enforces this.
1. **Evidence-only audit (`<audit spec>`):**
   - Audit rules assert only measured evidence from the repo's config and state archives.
   - When hardware tables repeat across dual pipes, slots, or Virtual Chassis members, deduplicate by keeping the highest-utilization row per group/table type and cite the exact file/unit in the finding.
   - Unreadable or missing state is never silently treated as a pass.

## 2. Touch List

Every state + audit addition touches these places:

1. **Decision record (`<decisions>` & `<decisions index>`):**
   - Check `<pointer>` or `<decisions>` for the next free decision number (and increment it in `<pointer>` if tracked there).
   - Record **Context** (which outage/window exposed the gap, with exact error strings and sample CLI output) and **Decision** (exact catalog stanza and rule semantics).
   - Add the row to `<decisions index>` if the repo keeps one.
   - Follow `decision-capture` if the user wants the decision committed first.
1. **`<config catalog>`:**
   - Add the state collection item with `name`, `command`, `format` (`text`, `xml`, or `both`), and `when` filter.
   - Declare any new thresholds or rulings in the appropriate config section.
1. **`<audit rules code>`:**
   - Add the parser function (pure, testable on raw text/XML strings) and the rule evaluator.
   - Register the rule under its topic so `<audit run>` executes it.
1. **`<state spec>`:**
   - Update the state items table/count and document the new item's command, format, and `when` filter.
1. **`<audit spec>`:**
   - Document the new `<topic>.<rule-name>` rule, its severity (`error` / `warning`), and what evidence it checks.
1. **`<state tests>`:**
   - Update item count / catalog assertions and test `when` matching for included and excluded models.
1. **`<audit tests>`:**
   - Add unit tests covering: normal/below-threshold (0 findings), at/above threshold (finding emitted with expected detail), multi-pipe/VC deduplication, and missing/malformed output handling.
1. **`<rules model tests>`:**
   - Ensure no new magic constants or platform-layering violations break the rules-model test suite.

## 3. Validation Sequence

Run the repo's `<checks>` (unit tests, linter, formatter, type checker) before finishing.

If live devices are reachable and approved by the user, test collection and dry-run audit:

```sh
<state collect> <new-item-flag-and-name> <sample-device>
<audit run> --topic <topic> --dry-run
```
