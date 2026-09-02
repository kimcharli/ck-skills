# Improvement Proposals

Append-only log of proposed changes to `AGENTS.md`, hooks, skills, and
specs. Written by agents, decided by humans.

The proposing protocol is defined in `AGENTS.md` ("Improvement
Proposals"); target routing is in `specs/project.md` ("Improvement
Routing").

## Rules of this file

- Read the `## Rejected` section before appending. Do not re-propose
  anything already declined.
- At most three proposals per session, one per observation.
- Agents append entries under `## Open` with `status: proposed`. Agents
  never change a status, never edit an entry they did not write, and never
  delete anything.
- A human sets status to `accepted`, `rejected`, or `deferred`, adding a
  one-line reason for anything rejected or deferred, then moves the entry
  to the matching section.
- Rejected entries stay permanently. They exist so the same proposal is
  not made twice.
- An accepted entry records the commit that applied it. Acceptance alone
  does not authorize an agent to apply it.

Template:

    ### YYYY-MM-DD — <one-line title>
    - status: proposed
    - target: agents | hook | skill | spec
    - trigger: <the observation that prompted this>
    - change: <concrete enough to apply without asking>
    - cost of not doing it: <one line>

---

## Open

_(none yet)_

---

## Accepted

_(none yet — accepted entries gain `- applied: <commit sha>` once landed)_

---

## Rejected

_(none yet — rejected entries stay here permanently, with a reason)_
