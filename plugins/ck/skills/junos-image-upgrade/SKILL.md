---
name: junos-image-upgrade
description: Upgrade or downgrade Junos on lab devices with the repo's upgrade tool - add the image to the repo's image list first, get a go, capture before and after, handle the done/staged/no-validate cases, and record the release steps (sha256, install, shutdown, back-on-release times, post checks) in the lab log. Use when asked to upgrade, downgrade, load a release or daily build, add an image to the image list, or "put the leaves on <release>". Needs the repo's "Skill bindings" for junos-image-upgrade.
---

# Junos image upgrade

The upgrade tool changes live devices. This skill wraps it with the steps a run does
not do itself: the image entry, the "go", the before and after state, and the record.

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### junos-image-upgrade`.
Each `<key>` below is a row of that table, and its "Notes" rows override the defaults
here. **Without bindings, stop.** Do not upgrade with hand-typed Junos commands unless
the user gives the exact procedure.

Keys: `<image list>`, `<image source>`, `<upgrade>`, `<options>`, `<run log>`,
`<capture>`, `<audit>`, `<deploy-match check>`, `<record>`, `<inventory>`, `<pointer>`,
`<owner>`, `<reference>`.

## Steps

### 1. The image entry (one commit, before the run)

- The release must be in `<image list>`, with the image `<owner>` named. Add only
  images that `<owner>` named; never pick a URL yourself.
- Put a comment above the entry with the sha256 and size if known, the source and date,
  and why.
- Commit it on its own (e.g. `chore(rules): images of <release> for <models>; <purpose> (<owner>)`).
- If a run stops because the image is not in the list, it changed no device. Show the
  lines it printed to `<owner>`, add them once approved, commit, then run again.

### 2. Before the run

- **Get a "go" from `<owner>`** that names the devices, the release and the reboot
  ("reboot together" or no reboot). Every named device reboots, unless it already runs
  the release.
- One run takes one image, so one model and one release. Split mixed models into
  separate runs, in the order `<owner>` wants.
- Read the state with `<capture>` (label `<topic>-pre`) and `<audit>`. Record the
  release, the PASS/FAIL counts, and that no loop or alarm is present.
- Down to an older release: run with validation first. Skip validation (see
  `<options>`) only after it refuses, and say so in the record.

### 3. Run

- `<upgrade>`, with `<options>` as agreed.
- Report each outcome:
  - **done**: the device already runs the release. No copy, install or reboot.
  - **sha256 mismatch** between devices: nothing is installed. Stop and tell `<owner>`.
  - **install failed**: no device reboots. The devices with the image staged take it at
    their next reboot. Write this in `<pointer>` so that no later reboot surprises
    anyone.
- Note the times: install start and end, shutdown, back on the release (per device).
  The run log is in `<run log>`.

### 4. After

- Wait for each device to report the release. Then check the protocol sessions
  Established, the LAGs and ESI-LAGs up, the designated forwarders as before, no loop,
  and no duplicate MAC.
- Run `<capture>` (label `<topic>-post`) and `<audit>`. `<deploy-match check>` must
  match the rendered config on each device. A new FAIL is explained or marked "cause
  not found".
- Run an iteration with `lab-iteration` when the plan asks for one.

### 5. Record

In the `<record>` section of the session, one row per step:

```markdown
| U<n> | to <release> | upgrade (`<run log>`): sha256 `<first8>...<last8>` on the <k> devices, install with validation `package-result: 0`, shutdown HH:MM:SS, on the release HH:MM to HH:MM. After (`<post capture>`): <sessions>, <deploy-match> <n> lines match, audit PASS <p>, FAIL <f>. |
```

Also update `<inventory>` if it lists releases, and `<pointer>` (which devices run
which release now).

## Never

- Upgrade a device that was not named, or reboot staged devices to "finish" a failed run.
- Skip validation for an upgrade.
- Commit an image URL with a signed query string.
