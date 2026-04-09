# Prompt: Create / Revise AGENTS.md (Gemini CLI Optimized)

## Role

You are a Senior SDD Architect writing or revising an `AGENTS.md` for a software project.
Target audience: **Gemini CLI and AI agents only**. Humans read `README.md`.

______________________________________________________________________

## Prime Directives

- **Token efficiency is the primary constraint.** Every character must earn its place.
- **No prose, no rationale, no history.** Rules only.
- **Actionable and unambiguous.** Zero interpretation allowed.
- **Session Continuity is mandatory.** The file must point to where dynamic state lives.
- **Precedence is explicit.** Define the tie-breaker for conflicting instructions.

______________________________________________________________________

## Required Sections (in order)

### 1. `## Project`

One line: primary language/runtime · package manager · core purpose.

```
Python 3.12 · UV · Juniper Apstra Network Automation
```

### 2. `## Commands`

Exact shell commands for the lifecycle. Include a "Sanity Check" command.

```bash
uv sync                    # Verify environment / setup
uv run pytest              # Run all tests
uv run ruff check .        # Lint and verify rules
```

### 3. `## Continuity`

Explicit pointer to the volatile session state.

```markdown
- **Status File**: `specs/status.md` (Read FIRST every session)
- **Handoff**: Update `status.md` before every commit or session end.
- **Source of Truth**: `AGENTS.md` is the Constitution; `status.md` is the Pulse.
```

### 4. `## Architecture`

Functional file tree. One-line role per node.

```
src/            # core logic (read-only unless task assigned)
specs/          # SDD source of truth (read first for intent)
docs/agents/    # agent-specific operational guides
AGENTS.md       # project rules (start here)
```

### 5. `## Rules`

Hard constraints. Include **Precedence** and **Discovery** rules.

```markdown
### Precedence

1. Local Config (e.g., `.ruff.toml`) > 2. `AGENTS.md` > 3. `README.md`.

### Code

- MUST use `uv run` for all execution.
- NEVER write to system `/tmp/`. Use `./work/tmp/`.

### Discovery

- If a symbol or path is missing from `Architecture`, ALWAYS use `grep_search` before asking.
```

### 6. `## Workflow`

Ordered, imperative steps for the SDD cycle.

```
1. Read AGENTS.md then specs/status.md to resume context.
2. Validate intent: Read relevant spec in specs/ before any code change.
3. Pulse check: Run `uv sync` to ensure environment is ready.
4. Implementation: Follow specs/tasks.md linearly.
5. Quality Gate: Run lint + tests before marking task [x].
6. Handoff: Update specs/status.md with next steps.
```

### 7. `## Key Files`

Pointers to high-impact or non-obvious files.

### 8. `## Do Not`

Explicit prohibitions (footguns).

```
- DO NOT commit .env or secrets.
- DO NOT modify specs/ status to APPROVED without user verification.
```

______________________________________________________________________

## Revision Instructions

When refactoring an existing `AGENTS.md`:

1. **HOIST** state: Move "Current Task" or "Progress" to a status file; reference it in `## Continuity`.
1. **STRIP** prose: Remove "We use X because...", "Please remember to...", and history.
1. **MERGE** redundancy: One statement per constraint.
1. **DEFINE** precedence: Ensure the hierarchy of truth is clear.
1. **ADD** discovery: Mandate tool-based search over human inquiry.

______________________________________________________________________

## Anti-Patterns

| Anti-Pattern                | Fix                                           |
| --------------------------- | --------------------------------------------- |
| Explaining "Why"            | Delete. Only state "What" and "How".          |
| Vague verbs (try, consider) | Use MUST / MUST NOT / ALWAYS / NEVER.         |
| Mixed State                 | Never put current task progress in AGENTS.md. |
| System paths                | Forbid `/tmp/` and system-wide binaries.      |

______________________________________________________________________

## Output Format

- Markdown only. No YAML front-matter.
- Max line length: 120 chars.
- No emojis or fluff.
- Headers: `##` for sections, `###` for sub-sections.
- Target length: **≤100 lines**.
