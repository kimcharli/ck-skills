# Unified Plugin Model (UPM)

**Status:** APPROVED
**Date:** 2026-03-20
**Target Tools:** Claude Code, Gemini CLI, GitHub Copilot CLI

______________________________________________________________________

## 🎯 Objective

Establish a single, robust directory structure and installation pattern for AI "skills" that works natively across all major AI CLI runners while following modern architectural standards (moving away from deprecated global command paths).

______________________________________________________________________

## 🏗️ Architectural Decision

### The "Full Modern" (Skills-Only) Pattern

We have decided to move to a **Purely AI-Native** architecture. We are abandoning global slash-command directories (`commands/`) in favor of **Self-Contained Plugins** that the AI activates autonomously via natural language.

### 📁 Directory Structure

```text
BASE_DIR/ (e.g., ~/.agents or ~/.claude)
└── skills/
    └── <skill-name>/          <-- THE SKILL ROOT (Universal)
        ├── manifest.json      # Claude Code / Gemini Discovery
        ├── plugin.json        # Copilot CLI Metadata
        ├── SKILL.md           # The "Expertise" (Autonomous Activation)
        ├── commands/
        │   └── <name>.md      # Prompt logic (accessed via Skill)
        └── tools/
            └── <script>.sh    # Supporting logic/scripts
```

______________________________________________________________________

## 💡 Rationale

### 1. Pure AI-Native UX

Modern AI agents (Claude, Gemini, Copilot) are designed to understand intent. By relying on `SKILL.md` descriptions, we allow the AI to "reach for the right tool" based on the user's natural language request (e.g., "fix my code") rather than forcing the user to remember specific slash commands (e.g., `/ck:lint`).

### 2. Elimination of Deprecated Paths

Claude Code has officially deprecated the global `~/.claude/commands/` directory. By removing the "Command Shim," we ensure our architecture is fully future-proof and aligned with the direction of all major AI CLI platforms.

### 3. Simplified Deployment

- **No Symlinks**: We no longer need to manage complex symlinks between `plugins/` and `commands/`.
- **Atomic Packages**: A plugin is a single, isolated folder. Deleting that folder completely removes all associated expertise and tools from the AI's context.

### 4. Reduced Namespace Pollution

Global command namespaces can become crowded. By moving to autonomous skills, we avoid "Slash Command Bloat" and let the AI manage the discovery process.

______________________________________________________________________

## 🔧 Implementation Details

### Autonomous Activation

Every plugin MUST include a high-quality `SKILL.md` file. The `description` in the YAML frontmatter is the **"Activation Trigger."** It must be descriptive enough for the AI to know exactly when to use this skill.

### Base Directory Detection

Installation scripts continue to support dynamic base directories (`~/.agents`, `~/.claude`), but now install **exclusively** to the `skills/` sub-directory.

### Automated Path Patching

Since tools are moved to a `skills/` sub-directory, all `.md` and `.json` files must be patched during installation to ensure paths point to the correct `BASE_DIR`.

**Example Patch Logic:**

```bash
REL_BASE_DIR="${BASE_DIR/#$HOME/~}"
find "$INSTALL_DIR" -type f -print0 | xargs -0 perl -i -pe "s|~/.claude|${REL_BASE_DIR}|g"
```

______________________________________________________________________

## ✅ Validation Reference

### Claude Code

- **Path:** `~/.claude/skills/` (Direct Discovery)
- **Mechanism:** Reads `manifest.json`.
- **UX:** Supports autonomous skill activation via `SKILL.md`.

### Gemini CLI

- **Path:** `~/.agents/skills/` (Skill Discovery)
- **Mechanism:** Reads `SKILL.md` for expertise and autonomous activation.
- **UX:** Intent-based activation (e.g., "commit my changes").

### Copilot CLI

- **Path:** `~/.agents/skills/` (Neutral Root)
- **Mechanism:** Reads `plugin.json`.
- **UX:** Traditional tool invocation and intent-based help.
