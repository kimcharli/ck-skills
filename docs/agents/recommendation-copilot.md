# Recommendation: Efficient Agent State Tracking

## Problem

AI agents answering "where are we?" or "what's next?" currently rely on reading 5–7 files on every
session start. This is O(n) work for an O(1) question. It wastes tokens, increases latency, and
causes agents to lose context when sessions are interrupted.

## Recommendation: STATE.md + sdd-state-sync Skill

The most effective solution requires two things working together:

1. **`STATE.md`** — a single, fixed-schema snapshot file that agents read first every session.
2. **`sdd-state-sync`** — a skill/script that generates and updates `STATE.md` automatically from
   `specs/tasks.md` and `git log`, so agents don't have to maintain it manually.

---

## Part 1 — STATE.md Schema

Place `STATE.md` in the project root. Enforce this exact schema:

```markdown
## State: <YYYY-MM-DD>
- phase: <specify | implement | review | done>
- current-task: "<exact [ ] text from specs/tasks.md, with task ID if present>"
- completed: <"T-1 through T-5" or comma-separated list>
- next: ["<next [ ] task>", "<task after that>"]
- blockers: <none | description of blocker>
- last-commit: <7-char SHA>
```

### Rules

- **Read first**: before reading any other file at session start.
- **Write last**: update before every commit or session-significant decision.
- **One source of truth**: never contradict `specs/tasks.md` — if they diverge, `tasks.md` wins and
  `STATE.md` must be regenerated.
- **Keep it short**: max ~10 lines. If it needs more, split into a separate status report.

### Example

```markdown
## State: 2026-03-21
- phase: implement
- current-task: "[ ] T-12 Add sdd-state-sync sync.sh script"
- completed: T-1 through T-11
- next: ["[ ] T-13 Write BATS tests for sync.sh", "[ ] T-14 Register skill in README"]
- blockers: none
- last-commit: a3f9c12
```

---

## Part 2 — sdd-state-sync Skill

### Purpose

Eliminate manual STATE.md maintenance by deriving it from existing sources of truth:

- `specs/tasks.md` — which tasks are `[x]` done vs `[ ]` pending
- `git log` — last commit SHA and message
- `STATE.md` — current phase and blockers (preserved across regeneration)

### File Layout

```
plugins/sdd-state-sync/
├── README.md
├── sync.sh          # main entry point
└── tools/
    └── parse-tasks.sh  # extracts task status from tasks.md
```

### sync.sh Implementation

```bash
#!/usr/bin/env bash
# plugins/sdd-state-sync/sync.sh
# Usage: bash plugins/sdd-state-sync/sync.sh [--phase <specify|implement|review|done>]
set -euo pipefail

TASKS_FILE="specs/tasks.md"
STATE_FILE="STATE.md"
PHASE="${PHASE:-}"

# Parse optional --phase flag
while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase) PHASE="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Extract tasks
current_task=$(grep -m1 '^\- \[ \]' "$TASKS_FILE" 2>/dev/null || echo "none")
next_tasks=$(grep '^\- \[ \]' "$TASKS_FILE" 2>/dev/null | tail -n +2 | head -2 \
  | awk '{printf "\"%s\", ", $0}' | sed 's/, $//')
completed_count=$(grep -c '^\- \[x\]' "$TASKS_FILE" 2>/dev/null || echo "0")
last_commit=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
today=$(date +%Y-%m-%d)

# Preserve phase from existing STATE.md if not overridden
if [[ -z "$PHASE" && -f "$STATE_FILE" ]]; then
  PHASE=$(grep -m1 '^- phase:' "$STATE_FILE" | sed 's/- phase: //' | tr -d '[:space:]') \
    || PHASE="implement"
fi
PHASE="${PHASE:-implement}"

# Preserve blockers from existing STATE.md
blockers="none"
if [[ -f "$STATE_FILE" ]]; then
  blockers=$(grep -m1 '^- blockers:' "$STATE_FILE" | sed 's/- blockers: //') || blockers="none"
fi

cat > "$STATE_FILE" <<EOF
## State: ${today}
- phase: ${PHASE}
- current-task: "${current_task}"
- completed: ${completed_count} tasks ([x] in specs/tasks.md)
- next: [${next_tasks}]
- blockers: ${blockers}
- last-commit: ${last_commit}
EOF

echo "STATE.md updated."
```

### parse-tasks.sh (optional helper)

```bash
#!/usr/bin/env bash
# Outputs: done_count, current_task, next_tasks
TASKS_FILE="${1:-specs/tasks.md}"
echo "done=$(grep -c '^\- \[x\]' "$TASKS_FILE" || echo 0)"
echo "current=$(grep -m1 '^\- \[ \]' "$TASKS_FILE" || echo 'none')"
grep '^\- \[ \]' "$TASKS_FILE" | tail -n +2 | head -3 | while read -r t; do
  echo "next=$t"
done
```

### Making It a Copilot CLI Skill

Add to `plugins/sdd-state-sync/README.md` (skill descriptor pattern):

```markdown
# sdd-state-sync

Regenerates STATE.md from specs/tasks.md and git log so agents can resume sessions
efficiently without re-reading all specs.

## Usage

    bash plugins/sdd-state-sync/sync.sh [--phase <specify|implement|review|done>]

## When to run

- After marking a task `[x]` in specs/tasks.md
- Before any git commit (add to pre-commit checklist in AGENTS.md)
- At session end, before switching context

## Integration

Add to AGENTS.md pre-commit checklist:

    bash plugins/sdd-state-sync/sync.sh
```

---

## Part 3 — Where Instructions Should Live

| Concern | Location | Rationale |
|---|---|---|
| "Read STATE.md first at session start" | `AGENTS.md` (§0) | Universal protocol; every agent must follow |
| "Update STATE.md before every commit" | `AGENTS.md` pre-commit checklist | Enforced at the commit gate, not optionally |
| STATE.md schema definition | `AGENTS.md` §0 + this doc | Schema in AGENTS.md (brief); full spec here |
| sdd-state-sync automation | `plugins/sdd-state-sync/` | Reusable skill, not agent-specific |
| How to regenerate STATE.md manually | This document (§ above) | Reference for implementers |

**Key principle**: The protocol (what/when) belongs in AGENTS.md. The implementation (how) belongs
in the skill. This keeps AGENTS.md concise and skill logic portable across projects.

---

## Part 4 — Comparison of Approaches

| Approach | Efficiency | Reliability | Maintenance |
|---|---|---|---|
| Read all files every session | O(n) tokens | Always current | None needed |
| Manual STATE.md | O(1) read | Drifts if forgotten | High (agent must remember) |
| **STATE.md + sdd-state-sync** | **O(1) read** | **Auto-regenerated** | **Low (run at commit)** |
| External DB / JSON index | O(1) read | Requires tooling | High (infra overhead) |

The recommended approach (row 3) hits the best trade-off: no external dependencies, Git-trackable,
works across all AI agents, and automation removes the "agent forgot to update" failure mode.

---

## Part 5 — Migration Path

1. **Day 1**: Add `STATE.md` schema to `AGENTS.md` §0 (done in `AGENTS-copilot.md`).
2. **Day 2**: Create `STATE.md` manually for the current project state.
3. **Day 3**: Implement `plugins/sdd-state-sync/sync.sh` (template above).
4. **Ongoing**: Add `bash plugins/sdd-state-sync/sync.sh` to pre-commit checklist.
5. **Optional**: Add as a git pre-commit hook for full automation:

   ```bash
   # .git/hooks/pre-commit (or hooks/pre-commit tracked in repo)
   bash plugins/sdd-state-sync/sync.sh
   git add STATE.md
   ```
