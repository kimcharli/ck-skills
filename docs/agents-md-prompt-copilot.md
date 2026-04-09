# Prompt: Create / Revise AGENTS.md

## Role

You are an AI agent writing or revising an `AGENTS.md` for a software project.
Target audience: **AI agents only**. Humans read `README.md` and project docs — not this file.

______________________________________________________________________

## Before You Write

Explore the project first. Do not write from assumptions.

1. List top-level files and directories.
1. Read `package.json`, `pyproject.toml`, `Makefile`, or equivalent to find runnable commands.
1. Identify existing `AGENTS.md`, `CLAUDE.md`, `.gemini/`, or similar agent config files.
1. Check `specs/`, `docs/`, or `ADR/` for workflow or architecture constraints.
1. Identify test framework, linter, type-checker, and CI config.

______________________________________________________________________

## Prime Directives

- **Token efficiency is a constraint, not a preference.** Every line must earn its place.
- **No prose explanations, no rationale, no history.** Rules only. If a rule needs justification,
  it belongs in a human doc.
- **Actionable and unambiguous.** Each entry must be directly executable or followable with zero
  interpretation.
- **No duplication.** One source of truth per concept. Reference files by path rather than
  re-stating their content.
- **Human-only content goes elsewhere.** Onboarding, architecture decisions, changelogs, business
  rationale → `README.md`, `DESIGN.md`, `CHANGELOG.md`, or `docs/`. Never here.

______________________________________________________________________

## Required Sections (in order)

Omit a section only if it genuinely does not apply. Never include a placeholder or "N/A" line.

### 1. `## Project`

One line: what the project does, its primary language/runtime, and package manager.

```
TypeScript CLI · npm · developer workflow automation
```

### 2. `## Commands`

Exact shell commands only. No explanation. Cover: install, test, lint, build (skip any that don't exist).

```bash
npm install            # install deps
npm test               # run all tests
npm run lint           # lint
npm run build          # compile
```

### 3. `## Architecture`

File tree + one-line role per node. Only what an agent needs to navigate the codebase.

```
src/
  index.ts        # entry point
  parser.ts       # input parsing — do not call directly, use api.ts
  api.ts          # public interface for all src/ modules
tests/            # mirrors src/ structure
specs/            # feature specs — source of truth for planned work
AGENTS.md         # you are here
```

### 4. `## Rules`

Hard constraints. Use **MUST / MUST NOT / ALWAYS / NEVER**.
Group into sub-sections only if >5 rules per domain.
Common domains to consider: Code, Testing, Git, Security, CI, Environment.

```markdown
### Code

- MUST pass lint and type-check before any commit.
- MUST NOT bypass the public API layer to call internal modules directly.

### Testing

- MUST write a test for every public function.
- Test files MUST mirror the path of the module they test.

### Git

- Branch names: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`.
- Commit messages: imperative, ≤72 chars, no period.

### Environment

- NEVER commit `.env` files.
- ALWAYS use `.env.example` as the reference for required variables.
```

### 5. `## Workflow`

How the agent should approach tasks — ordered steps, no narrative.

```
1. Read the relevant spec in specs/ before writing any code.
2. Check existing tests to understand expected behavior.
3. Write/update tests first (TDD).
4. Implement until tests pass.
5. Run full lint + type-check before marking task done.
6. Update the spec status field if a feature is complete.
```

### 6. `## Key Files` _(only if non-obvious)_

Pointers to critical files an agent would otherwise have to search for.

```
specs/SPEC_TEMPLATE.md   # required format for all new specs
.env.example             # all required env vars listed here
src/api.ts               # all external calls route through here
```

### 7. `## Do Not` _(only if high-risk footguns exist)_

Explicit prohibitions for destructive or irreversible actions.

```
- DO NOT run migration scripts against production without --dry-run first.
- DO NOT change lockfile dependency versions manually — use the package manager.
```

______________________________________________________________________

## Revision Instructions

When revising an existing `AGENTS.md`:

1. **Remove** any line that explains _why_ a rule exists — rules stand alone.
1. **Remove** any onboarding text, project history, or motivation paragraphs.
1. **Collapse** redundant rules — one statement per constraint.
1. **Hoist** repeated file-path references into `## Key Files`.
1. **Flag** (do not silently drop) any rule that contradicts another — resolve before saving.
1. **Validate** every shell command is runnable in the project's stated runtime. Remove stale ones.
1. **Verify** all file paths exist in the repo. Update or remove any that have drifted.
1. Final check: could a human-only reader derive business context from this file? If yes, move that
   content out.

______________________________________________________________________

## Anti-Patterns — Never Do These

| Anti-Pattern                                   | Fix                                      |
| ---------------------------------------------- | ---------------------------------------- |
| "We use X because historically Y..."           | Delete entirely                          |
| "Please remember to..."                        | Rewrite as MUST / MUST NOT               |
| Duplicating content already in README          | Replace with `See README.md § <section>` |
| Vague verbs: "consider", "try to", "generally" | Rewrite as hard rule or delete           |
| Section with a single item                     | Merge into nearest related section       |
| Bullets that are ordered steps                 | Convert to numbered list                 |
| Numbered list that is not ordered steps        | Convert to bullets                       |
| Comments longer than one line                  | Split into Key Files pointer or delete   |

______________________________________________________________________

## Output Format

- Markdown only. No YAML front-matter.
- Max line length: 100 chars.
- No badges, no shields, no emojis.
- Headers: `##` for sections, `###` for sub-sections only. No `####`.
- Code blocks for all shell commands, file trees, and config snippets.
- Target length: **≤120 lines** for most projects. Exceed only if the project has multiple
  distinct subsystems.
