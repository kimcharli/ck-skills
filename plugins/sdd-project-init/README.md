# SDD Project Init

Bootstraps a new project with Spec-Driven Development structure. Runs a short
interview, then generates all files fully populated — no `[placeholder]` values
left behind.

---

## Installation

For marketplace setup and general install instructions, see the
[ck-skills README](../../README.md).

**Quick install:**

```bash
# Claude Code
claude plugin install sdd-project-init@ck-skills

# Copilot CLI
copilot plugin install sdd-project-init@ck-skills

# Manual
cd plugins/sdd-project-init && ./install.sh
```

---

## Usage

**Claude Code:**
```
/ck:sdd-init
```

**Copilot CLI:**
```
/sdd-project-init
```

Or naturally in either tool:
```
Initialize a new project with SDD
Set up a new repo with SDD structure
```

Runs a 7-question interview, then calls `create-project.sh` to copy the model
file tree with variable substitution — deterministic, no AI-generated content.

---

## What Gets Generated

```
your-project/
├── AGENTS.md                          ← AI constitution + SDD gates (Single Source of Truth)
├── README.md
├── .gitignore
├── docs/
│   └── sdd-how-to-apply.md            ← human workflow reference
└── specs/
    ├── requirements.md                ← Phase 1 (Status: DRAFT)
    ├── design.md                      ← Phase 2 (Status: DRAFT)
    ├── tasks.md                       ← Phase 3 (Status: DRAFT)
    └── features/
        └── _template.md
```

All files are exact copies of `template/` with `{{variables}}` substituted.
Edit `template/` to change what gets generated for all future projects.

---

## After Init

```
1. cd your-project
2. Open specs/requirements.md
3. Ask Claude/Copilot: "Help me complete requirements for [first feature]"
4. Approve → design → approve → tasks → execute
```

See the generated `docs/sdd-how-to-apply.md` for the full daily workflow.

---

## Uninstall

```bash
claude plugin uninstall sdd-project-init   # Claude Code
copilot plugin uninstall sdd-project-init  # Copilot CLI
./uninstall.sh                             # Manual
```

---

## Related

- [doc-review-commands](../doc-review-commands/README.md) — keep docs in sync during development
- [skill-builder](../skill-builder/README.md) — create new ck-skills plugins
- [ck-skills](../../README.md) — full marketplace README
