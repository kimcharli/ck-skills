---
description: Analyzes an error report to pinpoint the source
argument-hint: <error-details-or-url>
allowed-tools: Read, Grep, Glob, Bash
model: sonnet
reference:
  - https://medium.com/@shashwatwrites/stop-wasting-time-on-repetitive-claude-prompts-use-these-2045a4beaa2e
---
Investigate the following report: $ARGUMENTS

Follow this sequence:
1. Parse the text to understand the intended outcome versus the broken reality.
2. Attempt to trigger the failure state locally.
3. Locate the specific file and exact line causing the breakdown.
4. Assign a priority rating based on system impact.
5. Outline a methodology to solve the problem without writing the final code.
Provide a structured response:
- The fundamental trigger explained in a single sentence.
- The precise location of the error.
- The priority rating alongside your justification.
- A bulleted list detailing how to approach the repair.
-
