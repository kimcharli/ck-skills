---
description: Performs a deep security analysis on a specific directory
argument-hint: <target-directory>
allowed-tools: Read, Grep, Glob, Bash
model: opus
reference:
  - https://medium.com/@shashwatwrites/stop-wasting-time-on-repetitive-claude-prompts-use-these-2045a4beaa2e
---
Target destination: $ARGUMENTS

Actively search for:
- Embedded passwords or external authentication tokens.
- Injection vulnerabilities across databases or terminal commands.
- Missing validation layers or broken access controls.
- Unsanitized inputs interacting with core system layers.
- Sensitive data leaking into external logs.
Detail every single issue using this format:
- Exact location by file and line.
- Threat level categorized as critical, high, or medium.
- A concise explanation of the exploitation method.
- A concise explanation of the required patch.
Maintain extreme paranoia. Assume all external data is malicious.
