# Prompt: Generate AGENTS.md

Use this prompt with a capable model (Opus / Pro) to generate a production-quality
`AGENTS.md` for any project.

---

You are an expert in AI-agent workflow design. Your task is to generate a
production-quality AGENTS.md for my project. Before writing anything, ask
me these questions (all at once, numbered):

1. What is the project's one-line purpose and primary language(s)/stack?
2. What package manager(s) and runtime versions are canonical?
   (e.g., uv, npm, cargo — and what commands are forbidden?)
3. What is the branching/commit strategy?
   (e.g., conventional commits, squash merge, required trailers?)
4. What is the quality gate? List every command the agent MUST run before
   committing (lint, test, build, type-check — with exact commands).
5. Is there a spec/doc-first workflow (e.g., SDD, ADR, tickets)?
   If so, describe the phases and required file paths.
6. What are the hard file-system rules?
   (e.g., temp files under `./work/tmp/`, never `/tmp/`)
7. What naming conventions must be enforced?
   (files, functions, classes, constants — per language)
8. Are there multiple AI models in use? Which model handles which phase?
   (e.g., Opus for design, Sonnet for implementation)
9. What state-tracking mechanism should agents use between sessions?
   (e.g., STATE.md snapshot read at session start, no persistent state)
   If yes: what fields must STATE.md contain and when must it be updated?
10. What communication behavior is required?
    (e.g., announce current phase, ask approval before implementing,
    provide evidence of passing quality gate)
11. Are there any hard-prohibited actions?
    (e.g., never use `pip` directly, never hardcode secrets, no bare `python`)

After I answer, generate `AGENTS.md` with these sections — in order,
no section omitted:

1. **Header** — one-sentence agent identity/persona
2. **Session Start** — how agent resumes state (STATE.md schema if applicable)
3. **Workflow** — the exact phase sequence with commit message formats
4. **Quality Gate** — runnable shell block + manual checklist (include STATE.md update step)
5. **Environment Rules** — commands table (do/don't), package manager rules
6. **File System Rules** — temp dirs, project tree conventions
7. **Code Standards** — naming, typing, DRY, scan-before-coding rule
8. **Documentation Standards** — markdown lint, file naming, changelog rules
9. **Communication Protocol** — phase announcements, approval gates, evidence reporting
10. **Model Selection** *(if applicable)* — phase → model mapping

Rules for the output:

- Every rule must be actionable, not aspirational ("Run X" not "Ensure quality")
- Use tables for command mappings, checklists for manual gates
- Keep total length under 120 lines — cut anything an agent won't act on
- Use `kebab-case` for all file references
- Hard-wrap Markdown at 120 characters
