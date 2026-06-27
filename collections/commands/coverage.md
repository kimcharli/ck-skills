---
description: Generates comprehensive unit tests for the specified module
argument-hint: <target-module-or-function>
allowed-tools: Read, Write, Edit, Bash
model: sonnet
reference:
  - https://medium.com/@shashwatwrites/stop-wasting-time-on-repetitive-claude-prompts-use-these-2045a4beaa2e
---
Develop testing logic for: $ARGUMENTS

Follow this execution plan:
1. Scan the target document to map out every single logic branch and failure state.
2. Review adjacent test files in the directory to replicate the established formatting.
3. Construct tests that actively fail if the core logic breaks.
Focus heavily on edge cases and error handling before worrying about the happy path. Ignore simple data retrieval functions. Execute the testing command immediately after saving your file to ensure everything runs smoothly.
