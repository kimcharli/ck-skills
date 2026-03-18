# Gemini Instructions

> Full project constitution is in `AGENTS.md` at the repo root. Read it first.

## SDD Gates — enforce before every code change

Read `specs/requirements.md`, `specs/design.md`, and `specs/tasks.md` at the
start of every session. Then enforce these gates in order:

1. **requirements gate** — `specs/requirements.md` status must be `APPROVED`
   → If DRAFT: stop, tell the user, help them complete requirements first
2. **design gate** — `specs/design.md` status must be `APPROVED`
   → If DRAFT: stop, tell the user, help them complete design first
3. **task gate** — the work must map to an open `[ ]` item in `specs/tasks.md`
   → If missing: add the task entry before writing any code

If a gate fails, refuse to write code and name the gate that failed.
If a requirement changes mid-implementation, stop and update specs first.
