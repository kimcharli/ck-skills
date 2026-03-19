---
name: skill-builder
description: Create new production-ready Gemini CLI skills and plugins with standardized structure, commands, and tools.
---

# Skill Builder

This skill helps you create new skills and plugins for Gemini CLI, Claude Code, and GitHub Copilot.

## Procedures

1. **Discovery**: Ask the user for the name and description of the new skill.
2. **Generation**: Use `tools/generator.sh` to scaffold the skill structure.
3. **Refinement**: Help the user fill in the `SKILL.md`, commands, and logic.

## Standard Structure

- `SKILL.md`: Metadata and core instructions for Gemini CLI.
- `commands/`: Markdown files for specialized tasks.
- `tools/`: Executable scripts and logic.
- `docs/`: Documentation and references.
- `tests/`: Testing scripts.

## Instructions

- Ensure all generated skills include a `SKILL.md` with appropriate frontmatter.
- Follow the `ck-skills` repository structure for consistency.
- Add basic validation and processing logic placeholders to help the user get started.
