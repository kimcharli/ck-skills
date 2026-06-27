---
description: Transitions logic from an outdated framework or standard to a modern equivalent
argument-hint: <old-standard> to <new-standard>
allowed-tools: Read, Edit, Grep, Glob, Bash
model: sonnet
reference:
  - https://medium.com/@shashwatwrites/stop-wasting-time-on-repetitive-claude-prompts-use-these-2045a4beaa2e
---
Execute transition for: $ARGUMENTS

Follow this exact sequence:
1. Utilize search utilities to locate every instance of the outdated standard.
2. Output a complete list of impacted files. Wait for my manual confirmation before modifying anything.
3. Once approved, update the files sequentially. Trigger the test command after every single file modification.
4. Pause immediately and explain the issue if any tests fail.
Never execute a massive global replacement. Treat every file as a unique context zone.
