# ck

**Umbrella plugin bundling twenty-two production-ready Claude Code skills.**

For marketplace setup and general install instructions, see the
[ck-skills README](../../README.md).

**Quick install:**

```bash
# Claude Code
claude plugin install ck@ck-skills

# Copilot CLI
copilot plugin install ck@ck-skills
```

______________________________________________________________________

## Bundled skills

| Skill | Description | Activation Intent |
| -- | -- | -- |
| **sdd-project-init** | Bootstrap a new non-Python project with Spec-Driven Development structure | "initialize a new project" |
| **doc-review-commands** | Keep documentation in sync with code changes | "review my documentation" |
| **sdd-git-commit** | Professional SDD Git commit workflow | "commit my changes" |
| **python-lint-fix** | Auto-fix and format Python and Markdown code | "fix/lint my code" |
| **plan-doc** | Plan-first workflow for multi-item change batches (committed plan doc before execution) | "plan first" / "create a plan doc" |
| **decision-capture** | Commit a mid-session design decision to specs before any implementation code | "capture this decision" |
| **session-close** | End-of-session handoff: refresh the NEXT pointer, append the dated log entry | "close session" / "wrap up" |
| **ste-procedure** | Write MOPs, runbooks, and change procedures in Simplified Technical English style | "write a MOP" / "write a runbook" |
| **agents-md** | Audit, split, and wire up global (`~/.agents/AGENTS.md`) and repo `AGENTS.md` files | "audit AGENTS.md" / "check global agents setup" |
| **lab-iteration** | Roll a rendered change out to a lab, run a numbered test iteration, record the result | "run an iteration" / "push to the lab" |
| **rule-change** | Owner ruling to decision record, rule-catalogue entry and implementation in three commits | "make it a rule" |
| **lab-test-plan** | Write, run and close a lab experiment plan before any test that changes device state | "plan a test" / "is it viable" |
| **junos-image-upgrade** | Upgrade or downgrade Junos on lab devices and record the release steps | "upgrade the leaves to <release>" |
| **meeting-recap** | File a pasted meeting recap verbatim and carry its action items into the to-do list | "add the recap" |
| **jtac-case-draft** | Draft or update a vendor (JTAC) case from lab evidence | "draft a JTAC case" |
| **skill-review** | Evidence-based periodic review and revision of agent skills | "review my skills" |
| **mop-live-evidence** | Write and run read-only ad-hoc live evidence capture scripts for routers | "capture live evidence" / "probe routing" |
| **mop-note** | Write or update evidence-backed network operational notes and post-mortems | "write a MOP note" / "document outage" |
| **mop-state-audit-rule** | Add a state collector item and corresponding declarative audit rule | "add a state item" / "add an audit rule" |
| **mop-window-closeout** | Post-maintenance-window reconciliation, pinning, and findings closeout | "close out the window" / "verify cutover" |
| **network-topology-svg** | Draw a hand-placed SVG network topology with interface tags and cable list | "draw a topology SVG" |
| **securecrt-session** | List, create, or update SecureCRT `.ini` sessions | "add a SecureCRT session" |

All skills are **AI-Native** — you don't need to remember slash commands, just tell the
tool what you want to do. Each skill also exposes its own commands under `/ck:<name>`
(e.g. `/ck:lint`, `/ck:sdd-init`, `/ck:commit`).

______________________________________________________________________

## Structure

```
ck/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── sdd-project-init/
    ├── doc-review-commands/
    ├── sdd-git-commit/
    ├── python-lint-fix/
    ├── plan-doc/
    ├── decision-capture/
    ├── session-close/
    ├── ste-procedure/
    ├── agents-md/
    ├── lab-iteration/
    ├── rule-change/
    ├── lab-test-plan/
    ├── junos-image-upgrade/
    ├── meeting-recap/
    ├── jtac-case-draft/
    ├── skill-review/
    ├── mop-live-evidence/
    ├── mop-note/
    ├── mop-state-audit-rule/
    ├── mop-window-closeout/
    ├── network-topology-svg/
    └── securecrt-session/
```

Each skill directory is self-contained (`SKILL.md`, `commands/`, and any `tools/`,
`docs/`, `template/` it needs).
