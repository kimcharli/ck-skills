# Prompt: Generate an Efficient AGENTS.md with Session Continuity

You are an expert at writing AGENTS.md files — the single instruction file that AI coding agents
(Claude Code, Gemini CLI, GitHub Copilot) read to understand a project's rules, structure, and workflow.

Your goal: produce the most EFFICIENT AGENTS.md possible. Efficiency means:

- Maximum signal per line (no filler, no repetition)
- Universal across all AI agents (Claude, Gemini, Copilot all read AGENTS.md natively)
- Agent-actionable (every statement is something an agent can follow or enforce — no aspirational prose)
- **Session-resumable** — an agent starting a new session can answer "where are we?" and
  "what should we do next?" by reading ONE small file, not scanning everything

## Instructions

1. Ask me these questions (or infer from context if I provide a repo):
   - Project purpose (1 sentence)
   - Tech stack (languages, frameworks, package managers)
   - Project structure (key directories and their roles)
   - Workflow/methodology (e.g., SDD, TDD, trunk-based, GitFlow)
   - Quality gates (lint, test, build commands — in execution order)
   - Hard rules (things agents must NEVER do, e.g., never use bare `python`, never write to `/tmp/`)
   - Commit conventions (message format, co-author lines, when to commit)
   - File/naming conventions
   - Model selection guidance (if applicable — which model for which phase)
   - Status tracking (where does session state live? how do agents hand off between sessions?)

2. Write the AGENTS.md following these principles:

   **Structure** — Use this exact section order:

   1. Purpose (1-2 sentences, no fluff)
   2. Session Start (what to read first to resume — status file before full specs)
   3. Stack & Environment (bulleted, scannable)
   4. Project Structure (tree diagram, annotated)
   5. Workflow (numbered phases — what agents do and in what order)
   6. Quality Gates (commands in execution order, with pass/fail behavior)
   7. Status Tracking (format and rules for the session-handoff file)
   8. Conventions (hard rules as imperative statements: "Always X", "Never Y")
   9. Tool Compatibility (which agents read this file and how)

   **Session continuity pattern:**

   AGENTS.md must instruct agents to maintain a compact status file (e.g., `specs/status.md`)
   that serves as the session-handoff mechanism. The pattern:

   - **Session start**: Read status file FIRST, before any other spec or code file.
     This gives the agent immediate context without token-expensive full scans.
   - **During work**: Update status after each task completion.
   - **Session end / commit**: Status file is always part of the commit.
   - **Format**: YAML frontmatter (machine-parseable) + short markdown body (human-readable).
     Must stay under 30 lines. Contains: current phase, current task, completion count,
     next steps, blockers, and recent decisions.
   - **Bootstrap**: If the status file is missing, the agent creates it from `specs/tasks.md`.

   The key principle: **AGENTS.md is a constitution (changes rarely). Status changes every session.
   Never mix them.** AGENTS.md points to the status file; the status file holds the mutable state.

   **Style rules:**

   - Every line must be actionable by an AI agent. Delete anything that isn't.
   - Use imperative mood ("Run X", "Never do Y") — not descriptive ("This project uses X").
   - Prefer tables over paragraphs for command references.
   - Keep total length under 100 lines. If it exceeds 100 lines, merge or cut.
   - No duplicate information — if a rule appears once, it must not appear again in different words.
   - No agent-specific sections. Write one file that all agents follow identically.
   - Hard rules get their own bullet with "NEVER" or "ALWAYS" in bold.
   - Gate/checkpoint sections must include the exact shell command to run.

   **Anti-patterns to avoid:**

   - Personality descriptions ("You are an expert...") — that belongs in agent-specific configs, not AGENTS.md
   - Explaining WHY a rule exists — just state the rule
   - Repeating the same rule with different wording in multiple sections
   - Aspirational guidelines that can't be mechanically followed
   - Documentation standards that duplicate what a linter config already enforces
   - Putting mutable project state (current task, progress, blockers) inside AGENTS.md

3. After generating, self-review:
   - Read every line and ask: "Can an AI agent act on this without ambiguity?" Delete if no.
   - Check for duplicates across sections. Merge ruthlessly.
   - Verify total line count is under 100.
   - Confirm the status tracking section exists and is actionable.

Output ONLY the AGENTS.md content. No preamble, no explanation.
