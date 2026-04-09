# Research: Anthropic Agent Skills Structure & Installation

**Date:** 2026-03-20
**Source:** [github.com/anthropics/skills](https://github.com/anthropics/skills)

______________________________________________________________________

## 🎯 Findings Summary

The Anthropic skills repository serves as the official reference for "Agent Skills." It establishes a standardized way for Claude (and other agents) to discover and execute specialized expertise.

### 1. File & Folder Structure

- **Self-Contained Directory:** Each skill lives in its own folder (e.g., `skills/development/python-lint-fix`).
- **`SKILL.md` (Mandatory):** The entry point for the skill. It MUST be at the root of the skill folder.
- **YAML Frontmatter:**
  - `name`: Unique identifier (lowercase, kebab-case).
  - `description`: Detailed explanation used by the AI to decide when to activate the skill.
- **Support Files:** Python scripts, templates, and other resources are co-located in the same folder or subfolders (e.g., `tools/`).

### 2. Standard Installation Ideas

- **Marketplace Model:** The repo uses a `.claude-plugin/` directory to manage marketplace registration.
- **CLI Commands:**
  - `claude plugin marketplace add <repo>`
  - `claude plugin install <skill>@<marketplace>`
- **Direct Discovery:** As of 2026, agents scan specific local paths:
  - `~/.claude/skills/`
  - `~/.agents/skills/`
  - `~/.gemini/skills/`

### 3. Key Discovery Insights

- **Activation via Intent:** The `description` in `SKILL.md` is the primary trigger. The user doesn't need to call a slash command; they just express a need that matches the description.
- **Instructional Markdown:** The body of `SKILL.md` becomes the "System Prompt" for that specific task, providing the agent with procedural knowledge.

______________________________________________________________________

## 💡 Learning & Application

### Alignment with our "Unified Plugin Model" (UPM)

- Our move to a **Self-Contained Root** (`plugins/ck/<name>`) is perfectly aligned with the official Anthropic structure.
- We should ensure our `install.sh` scripts prioritize placing the `SKILL.md` file exactly where the agent expects it.
- **Action:** Consider renaming our `plugins/` directory to `skills/` in the installation target to match the 2026 standard (`~/.agents/skills/<name>`).

### Standardized Metadata

- We must ensure our `SKILL.md` descriptions are "Trigger-Optimized"—focused on the verbs and tasks the user will actually say.

### Platform Nuances

- While the structure is universal, the execution environment (bash permissions, etc.) still varies between Claude, Gemini, and Copilot. Our "Generic CLI Support" success messages are a good step toward addressing this.
