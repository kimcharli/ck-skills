---
name: mop-note
description: >-
  Write or update an evidence-backed network operational note, outage/incident
  root-cause analysis, post-mortem, bespoke cutover MOP note, or topology
  reference note. Enforces provenance headers (`Read from:` with exact archive
  commit stamps and evidence paths), numbered evidence ledgers (`E1`..`En`),
  explicit inference labelling, Mermaid routing/path diagrams, ordered fix
  options (`Option A`/`Option B`) with rollback, open questions (`Q1`..`Qn`),
  and repo cross-linking. Trigger when asked to document an outage, write a
  MOP note, record live verification, write a post-mortem, or document
  routing/topology findings. Uses the repo's "Skill bindings" for mop-note if
  present.
---

# Network Operational Note & Outage Analysis (`mop-note`)

Write or update an operational note that separates **measured archive/runtime facts** from **inferences** and **owner rulings**, so any engineer or future session can verify every claim against its exact source file and line.

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### mop-note`. Each `<key>` below is a row of that table, and its "Notes" rows override the defaults here. If the repo has no bindings for this skill, use the defaults in parentheses or ask the user where notes live.

Keys: `<notes dir>` (default `data/mop/notes`), `<postmortem dir>` (default `data/audit`), `<findings dir>` (optional, e.g. `data/mop/findings`), `<configs dir>` (default `data/device-configs`), `<state dir>` (default `data/device-state`), `<evidence dir>` (default `data/evidence`), `<notes index>` (optional, e.g. `data/mop/README.md`), `<pointer>` (optional, e.g. `specs/NEXT.md`), `<change-class traps>` (optional).

## 1. Choose Location & Filename

| Kind of document | Path | Companion set files |
| -- | -- | -- |
| Outage investigation, routing/cutover note, pre-check, or topology reference | `<notes dir>/YYYY-MM-DD-<slug>.md` | Optional `<notes dir>/YYYY-MM-DD-<slug>/<phase>-<order>-<device>-set.txt` |
| Window rollback or hardware/operational post-mortem | `<postmortem dir>/YYYY-MM-DD-<window>-postmortem.md` | None (keep raw captures in `<state dir>/` or `<evidence dir>/`) |
| Post-migration gap on a generated MOP (when `<findings dir>` is bound) | `<findings dir>/<scope>.md` and `<findings dir>/fixes/<scope>-<id>.md` | `<findings dir>/fixes/<scope>-<id>-<target>-set.txt` |

**Security rule:** Tracked notes under `<notes dir>/` and `<postmortem dir>/` must **never** contain `$9$`/`$6$`/`$1$` password hashes, TACACS/SNMP secrets, or raw bulk host MAC/ARP dumps. Raw runtime captures stay in gitignored `<evidence dir>/<topic>-<YYYY-MM-DD>/` or `<state dir>/`.

## 2. Required Document Structure

### A. Provenance Header Block (mandatory on every note)

Start immediately under the `# Title` with a bulleted metadata block:

```markdown
# <Clear, specific title stating the subject or fault>

- Date: YYYY-MM-DD (include reporter / time if an incident)
- Related: [<related MOP or plan>](<relative-link>), [<decision NNNN>](<relative-link>)
- Read from: configs `<device>` `<YYYYMMDDTHHMMSSZ-hash>`, ...; state `<state dir>/<stamp>`; runtime `<evidence dir>/<topic>-<date>/` (`<timestamp>`, `<N>` devices, read-only, `collect.py` beside it)
- Status: **<Answer first: one-sentence current state — e.g. what is broken, what option was loaded when, and what steps/questions remain open.>**
```

- **Never write vague provenance** like "from current configs". Cite the exact `<YYYYMMDDTHHMMSSZ-hash>` filename from `<configs dir>/<device>/` (or commit history) so the reader knows whether the note pre-dates or post-dates a window commit.

### B. What Is Broken / Answer First (for incidents & pre-checks)

State the mechanism in 1–3 numbered points before diving into raw tables:

- Name the exact routing instance (`<VR-NAME>`, `<VRF-NAME>`, `inet.0`, `inet.2`), protocol preference (`Static 5` vs `BGP 170`), `local-preference`, next-hop IP, and interface (`irb.xxxx`, `fxp0`, `aeN.unit`, or vendor equivalent).
- Call out why a route wins or loses (e.g., route preference vs local preference, missing export term, `term catch-all then accept`, discard aggregate).

### C. Path / Topology Diagrams (`mermaid`)

Include a `flowchart TD` or `flowchart TB` diagram showing the forwarding and control-plane path:

- **Solid arrows (`-->`)**: active forwarding/routing path.
- **Dashed arrows (`-.->`)**: inactive, pre-change, backup, or dropped path.
- **Edge labels**: keep edge labels concise (interface, LP/pref, or status, e.g. `|"irb.100, LP 200"|`). Put detailed attributes (AS numbers, next-hop IPs, hop numbers) inside the node label strings.
- Do not use `%%{init}%%`, `classDef`, hardcoded hex colors, or inline HTML (`<br>` inside Mermaid nodes — use literal newlines inside quoted node labels `["line 1\nline 2"]`).

### D. Numbered Evidence Ledger (`E1`..`En`)

Group all verifiable facts into a table so prose, fixes, and questions can cite `(E4, E17)` instead of repeating raw output:

```markdown
## Evidence

| # | What | Where |
| --- | --- | --- |
| E1 | <Falsifiable observation with exact stanza, prefix, LP/pref, age, or commit timestamp> | `<device>` `<stamp>` lines X–Y (or `<evidence dir>/.../<file>.txt` line Z) |
```

When appending a follow-up live capture to an existing note:

- Add a subsection `### Live capture YYYY-MM-DD HH:MMZ (<context>)` and continue the numbering (`E17`..`En`) rather than renumbering earlier `E1`..`E16` citations.
- Follow the table with a short **`Read from E1..En:`** block separating direct readings from **`Inference:`** bullets (explicitly labelled `**Inference:**` or `**Inference (Q#):**` when not directly proved by a capture).

### E. Rulings & Ordered Fix Procedure (when a change is proposed)

1. **Order of operations warning:** State explicitly if Step A must precede Step B (for example, advertising the replacement route before withdrawing the fallback so traffic does not hit a discard aggregate).

1. **Options / Rulings table (`Option A` / `Option B` or `D1`..`Dn`):**

   ```markdown
   | Option | Change on `<devices>` | Effect |
   | --- | --- | --- |
   | **A** | `<exact set/deactivate command>` | <what happens> |
   | **B** | `<exact set/deactivate command>` | <what happens> |
   ```

   Prefer `deactivate` over `delete` (on Junos, or non-destructive disable equivalents) when preserving rollback context on live routers.

1. **Pre-checks (read-only):** Exact `show ...` commands with `Expected:` output and an explicit **stop condition** (`If there is no BGP route from the firewall, stop.`).

1. **Execution steps:** Exact config blocks using confirmed/timed commit where supported (e.g. Junos `configure private`, `commit check`, `commit confirmed 10 comment "..."`).

1. **Verification steps:** Exact `show` / `ping` / `traceroute` commands confirming both control plane (active route + advertised routes) and data plane.

1. **Rollback:** Exact commands for every step.

1. **Change-class traps:** Check every item in `<change-class traps>` (if bound) plus any vendor traps that apply:

   - **Junos — new DHCP relay in a routing instance that had none:** List the instance's eBGP/firewall/VPN peers and ask whether any carries transit unicast DHCP that this relay will not serve (e.g. a remote site relayed to central DHCP servers). If so, add `set routing-instances <VRF> forwarding-options dhcp-relay no-snoop`; without it, Junos snoops transit unicast DHCP and drops it as `Interface not configured` while routing looks healthy. Verify with `show dhcp relay statistics routing-instance <VRF>` twice, a minute apart (`Interface not configured` and `Total dropped` must not increase; rising `DHCPACK` alone is not enough). With `no-snoop`, unicast T1 renewals go directly between client and server, so IRB filters and firewalls must permit UDP 67/68.

### F. Impact on Related Backlog / Other MOPs

If the finding affects another planned window or backlog item (e.g., an iBGP export policy change that would accidentally advertise a static route fabric-wide at higher LP), add an explicit `## Impact on <related work>` section and cross-link both notes.

### G. Open Questions Ledger (`Q1`..`Qn`)

Track unresolved items at the bottom of the note, and preserve answered questions as an audit trail when updating:

```markdown
## Open questions

| # | Question | For | Blocks |
| --- | --- | --- | --- |
| Q1 | <Question text> **Answered: <summary> (E17).** | <owner/team> | done |
| Q2 | <Unresolved question> | <owner/team> | <what it gates> |
```

## 3. Repository Cross-Linking Checklist

Before committing a new or updated note:

1. **`<notes index>` (if bound):** When adding a new file under `<notes dir>/`, add a link and 1-phrase summary to `<notes index>`.
1. **Related notes:** If this note updates or depends on an earlier note, update the parent note's status/backlog bullet to link to the new note and cite the latest `E#`/`Q#` items.
1. **`<pointer>` (if bound):** If the note opens, updates, or closes an operational follow-up or ruling, update the matching section in `<pointer>`.
1. **Commit message:** Use `docs: ...` or `docs(mop): ...` / `docs(audit): ...` with a concise summary of the finding or verification recorded.
