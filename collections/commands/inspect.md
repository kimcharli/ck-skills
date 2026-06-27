---
description: Evaluates active changes to identify logical flaws, vulnerabilities, and formatting errors
argument-hint: [optional target path or commit hash]
allowed-tools: Read, Grep, Glob, Bash(git diff:*, git log:*)
model: sonnet
reference:
  - https://medium.com/@shashwatwrites/stop-wasting-time-on-repetitive-claude-prompts-use-these-2045a4beaa2e
---
Act as a principal software engineer inspecting code. Evaluate the provided differences. 

- If $ARGUMENTS exist, analyze that specific target.
- Otherwise, look at the active HEAD.
Prioritize the following areas:
1. Unhandled edge cases and hidden logic bugs.
2. Security vulnerabilities including exposed credentials or poor validation.
3. Noticeable performance degradations.
4. Unintended modifications to exposed APIs.
Structure your feedback clearly:
- Critical blockers: Provide the exact file path, line number, and a direct fix.
- Important suggestions: Follow the same formatting.
- Minor formatting notes: Keep these brief and optional.
Do not accept modifications containing critical vulnerabilities. Be concise and actionable.
