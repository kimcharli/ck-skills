---
description: Cleans up module architecture while prioritizing stability
argument-hint: <target-module> [objective]
allowed-tools: Read, Edit, Bash
model: sonnet
reference:
  - https://medium.com/@shashwatwrites/stop-wasting-time-on-repetitive-claude-prompts-use-these-2045a4beaa2e
---
Optimization target: $ARGUMENTS

Strict guidelines:
1. Detail your proposed architectural changes before touching any files.
2. Strictly contain your modifications to the requested target zone.
3. Execute the test command prior to starting to establish a baseline.
4. Execute the test command after every incremental update.
5. Pause completely if a failure occurs. Require my manual permission to continue.
Primary objective: Enhance readability while perfectly maintaining all original functionality. If functionality must shift to achieve the objective, halt operations and notify me immediately.
