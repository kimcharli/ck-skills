---
description: Modifies existing documentation to reflect recent codebase alterations
argument-hint: [optional target directory]
allowed-tools: Read, Edit, Grep, Glob, Bash(git diff:*)
model: haiku
reference:
  - https://medium.com/@shashwatwrites/stop-wasting-time-on-repetitive-claude-prompts-use-these-2045a4beaa2e
---
Synchronize text files based on recent logic changes in: $ARGUMENTS (defaulting to active differences)

Follow this sequence:
1. Check the version control history to understand the exact modifications.
2. Scan the primary instructional files for any mentions of the updated logic.
3. Modify strictly the paragraphs that are no longer factually accurate.
4. Do not restructure the layout or attempt to stylize unrelated paragraphs.
Highlight any modified features that completely lack instructional text. Do not generate brand new Markdown files unless explicitly commanded to do so.
