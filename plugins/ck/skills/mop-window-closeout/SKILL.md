---
name: mop-window-closeout
description: >-
  Post-maintenance-window reconciliation workflow for network cutovers,
  rebalances, fabric/topology migrations, or bespoke incident fixes. Covers
  post-window config and state collection, post-capture and compare, pinning
  completed windows in the repo's rules file, topology rebuilds, checking for
  unamended draft diffs or temporary workarounds, and updating findings and the
  session pointer. Trigger when a maintenance window has finished or when asked
  to verify/close out a completed window. Needs the repo's "Skill bindings" for
  mop-window-closeout.
---

# Post-Maintenance-Window Closeout (`mop-window-closeout`)

Run this workflow after a maintenance window executes (or when reconciling the repo with commits made during a window) so the archive, pinned MOP records, topology, findings, and `<pointer>` stay in lockstep.

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### mop-window-closeout`. Each `<key>` below is a row of that table, and its "Notes" rows override the defaults here. If the repo has no bindings for this skill, ask the user for the values the task needs. Do not guess paths or commands.

Keys: `<config collect>`, `<state collect>`, `<configs dir>`, `<window types>`, `<rules file>`, `<mop check>`, `<findings dir>`, `<evidence dir>`, `<notes dir>`, `<pointer>`, `<remote tmp>` (optional, default `/var/tmp`).

## 1. Collect Fresh Configurations & Runtime State

Always pull the post-window configuration archive first so commit logs and `.conf` files reflect what actually landed on the routers:

```sh
<config collect> <window-devices...>
<state collect> <window-devices...>
```

Check `<configs dir>/<device>/` commit metadata on every touched device:

- Verify the commit timestamp, user, and comment.
- Diff the pre-window `.conf` against the post-window `.conf` to check whether the operator loaded the exact generated set file, an unamended draft, or an ad-hoc workaround (e.g., temporary static routes, removed filters, or leftover protection settings).

## 2. Window-Specific Verification & Pinning

Match the completed window against `<window types>` in the repo's bindings and run the applicable track(s):

### A. Migration / Cutover Window with Post-Capture & Pinning

1. **Run post-capture and compare** (wait for MAC/ARP/VRRP timers to settle, e.g. 10+ minutes after cutover):
   - Run the bound post-capture and compare commands for this window type.
   - Inspect the generated compare report under `<evidence dir>/`.
   - If transient aging checks (such as gateway MACs) fail immediately after cutover, re-run post-capture and compare after aging completes.
   - If reachability or ARP/table recovery checks fail, investigate and record a finding.
1. **Pin the completed window in `<rules file>`:**
   - Once confirmed in production, pin its pre-move archive timestamp (`as_of`) in `<rules file>` so MOP generation keeps the migrated item as a durable record.
1. **Regenerate and verify drift check:**
   - Re-run MOP generation for the scope and run `<mop check>` to confirm zero drift.
1. **Record any post-migration gaps in `<findings dir>`:**
   - If the diff between the MOP and the post-window archive shows missing VLANs, dropped filters, or prefix mismatches, document them in `<findings dir>/<scope>.md` and prepare fix set files under `<findings dir>/fixes/` if needed.

### B. Config / Service Rebalance Window

1. After collecting the target devices, pin the rebalance archive timestamp in `<rules file>`.
1. Run `<mop check>` to confirm zero drift.

### C. Topology / Fabric-Attach Migration Window

1. Collect state on the window's migrated devices and their upstream peers (`<state collect>`).
1. Run the bound redundancy and topology rebuild commands from `<window types>`.
1. Verify each migrated device's path/state status matches the expected post-window state.

### D. Bespoke Cutover / Incident Fix

1. Run a `mop-live-evidence` script (`<evidence dir>/<topic>-<date>/collect.py`) if specific route tables, BGP advertisements, or traceroutes must be proved.
1. Update the MOP note in `<notes dir>/YYYY-MM-DD-<slug>.md` (using `mop-note`):
   - Update `Read from:` with the new `<YYYYMMDDTHHMMSSZ-hash>` config stamps and live evidence folder.
   - Update `Status:` at the top to state which step/option is now live and what remains open.
   - Append new `E#` rows under `### Live capture YYYY-MM-DD HH:MMZ` and mark resolved `Q#` rows as `**Answered: ... (E#).** | ... | done`.

## 3. Clean Up Remote Staged Files (Manual Check)

Remind the operator (or check if requested) to clean up staged set files under `<remote tmp>` on the routers once the window is closed.

## 4. Refresh `<pointer>`

Update `<pointer>` before ending the session:

- Move completed windows/steps from pending/ready to completed/pinned, citing the commit timestamp and archive stamp.
- List any new temporary workarounds, unrecorded operator commits, or removed filters under the open backlog so they are not forgotten.
