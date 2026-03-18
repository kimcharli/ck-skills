# SDD Project Init

A Claude Code skill that initializes new projects with Spec-Driven Development
structure. Runs an interview and generates all files fully populated — no
placeholders left behind.

## What It Does

- Interviews you on project name, purpose, stack, AI tools
- Creates `AGENTS.md` with SDD gates enforced (ready for Claude Code, OpenCode)
- Creates `specs/requirements.md`, `specs/design.md`, `specs/tasks.md`
- Creates `docs/sdd-how-to-apply.md` as a human reference
- Conditionally creates `GEMINI.md` and `.github/copilot-instructions.md`

## Installation

```bash
cd /Users/ckim/Projects/ck-skills/plugins/sdd-project-init
./install.sh
```

Or from the marketplace:
```
claude plugin install sdd-project-init@ck-skills
```

## Usage

In any new project directory, tell Claude Code:

```
/ck:sdd-init
```

Or naturally:
```
Initialize a new project with SDD
Set up a new repo with SDD structure
```

Claude will ask 7 questions, then generate the full project structure in one pass.

## Generated Structure

```
your-project/
├── AGENTS.md                          ← AI constitution + SDD gates
├── GEMINI.md                          ← (if Gemini CLI selected)
├── README.md
├── .github/
│   └── copilot-instructions.md        ← (if Copilot selected)
├── docs/
│   └── sdd-how-to-apply.md
└── specs/
    ├── requirements.md                ← Phase 1 (Status: DRAFT)
    ├── design.md                      ← Phase 2 (Status: DRAFT)
    ├── tasks.md                       ← Phase 3 (Status: DRAFT)
    └── features/
        └── _template.md
```

## After Init

```
Open specs/requirements.md and describe what you're building.
Then ask Claude: "Help me complete the requirements for [first feature]."
```
