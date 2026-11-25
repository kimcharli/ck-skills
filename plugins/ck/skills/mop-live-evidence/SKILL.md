---
name: mop-live-evidence
description: >-
  Write and run a read-only ad-hoc live evidence capture script (`collect.py`)
  under a dated evidence folder using the repo's SSH helper and
  `ThreadPoolExecutor`. Saves one `.txt` file per command under `<device>/`
  with a `$ <command>` header, enforces strict read-only guardrails (never
  `configure`, bounded `traceroute`/`ping`), and feeds `mop-note` evidence
  ledgers (`E1`..`En`). Trigger when asked to verify routing/state live on
  routers, capture pre-check or post-fix evidence, or probe an outage across
  multiple devices. Needs the repo's "Skill bindings" for mop-live-evidence.
---

# Read-Only Ad-Hoc Live Evidence Capture (`mop-live-evidence`)

When the standard state collector does not cover a specific prefix, peer, or VRF path needed for a MOP pre-check or incident investigation, write a small, reproducible `collect.py` inside a dated `<evidence dir>/<topic>-<YYYY-MM-DD>/` folder rather than running untracked one-off SSH commands.

## Bindings first

Read the repo's `AGENTS.md` section `## Skill bindings` → `### mop-live-evidence`. Each `<key>` below is a row of that table, and its "Notes" rows override the defaults here. If the repo has no bindings for this skill, ask the user for the values the task needs. Do not guess paths or commands.

Keys: `<evidence dir>` (default `data/evidence`), `<ssh import>`, `<ssh session usage>`, `<runner>` (default `uv run python`), `<config collect>` (optional), `<configs dir>` (optional), `<pointer>` (optional, e.g. `specs/NEXT.md`).

## 1. Safety & Scope Guardrails

1. **Read-only only:** Every command in `commands(device)` must be read-only (`show ...`, bounded `ping ...`, or bounded `traceroute ...`). **Never** send `configure`, `load`, `commit`, `clear`, `request`, or `file delete` (or vendor equivalents).
1. **Gitignored output:** Keep the script and all captured outputs inside `<evidence dir>/<topic>-<YYYY-MM-DD>/`. Ensure `<evidence dir>/` is gitignored because captures contain host IPs, MACs, and routing tables.
1. **Preserve `collect.py` beside the output:** Keep `collect.py` in `<evidence dir>/<topic>-<YYYY-MM-DD>/collect.py` and cite it in the `mop-note` header (`runtime <evidence dir>/<topic>-<YYYY-MM-DD>/ (<timestamp>, N devices, read-only, collect.py beside it)`).
1. **Skip blocked hosts:** Never include devices flagged as access-blocked or unreachable in `<pointer>`.

## 2. Canonical `collect.py` Template

Create `<evidence dir>/<topic>-<YYYY-MM-DD>/collect.py` using the repo's `<ssh import>` and `<ssh session usage>` (example below uses a `SshSession.open(device)` context manager):

```python
"""Read-only <topic> evidence, YYYY-MM-DD. Ad hoc; not part of the package."""

import re
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

# Replace with the repo's <ssh import>
from <pkg> import SshSession

OUT = Path(__file__).parent

# Declare target device groups and constants at top of file
LEAVES = ["leaf-1", "leaf-2"]
CORES = ["core-1", "core-2"]


def commands(device: str) -> list[str]:
    if device in LEAVES:
        return [
            "show route table <VR>.inet.0 192.0.2.0/24 exact detail",
            "show system commit",
        ]
    if device in CORES:
        return [
            "show route 192.0.2.0/24 exact detail",
        ]
    raise SystemExit(f"no commands for {device}")


def slug(command: str) -> str:
    return re.sub(r"[^a-z0-9.]+", "-", command.lower()).strip("-")[:120]


def collect(device: str) -> str:
    folder = OUT / device
    folder.mkdir(exist_ok=True)
    with SshSession.open(device) as session:
        for command in commands(device):
            text = session.run(command, timeout=300)
            (folder / f"{slug(command)}.txt").write_text(f"$ {command}\n{text}")
    return device


if __name__ == "__main__":
    devices = sys.argv[1:] or [*LEAVES, *CORES]
    with ThreadPoolExecutor(min(len(devices), 8)) as pool:
        for future in [pool.submit(collect, d) for d in devices]:
            try:
                print("done", future.result(), flush=True)
            except Exception as exc:  # report and keep going
                print("FAILED", type(exc).__name__, exc, flush=True)
```

## 3. Command Construction Rules

- **Pagination:** Follow `<ssh session usage>` notes (for example, if the helper disables paging automatically, do not append `| no-more`).
- **Keep pipes narrow when tables are huge:** Full BGP receive tables on border routers can be tens of megabytes (`timeout=900`). Scope to a prefix (`192.0.2.0/24 exact detail`) or count matches when only counts are needed.
- **Always bound active probes:** (Junos examples — adapt syntax to the target OS)
  - `traceroute <ip> [routing-instance <vr>] no-resolve wait 1 ttl 10`
  - `ping <ip> [routing-instance <vr>] [source <src>] count 5 rapid`
- **Include commit history** (e.g. `show system commit` on Junos, or `<config collect>` into `<configs dir>`) when verifying whether a change was recently committed on the target routers.

## 4. Running & Indexing into a Note

1. Run via `<runner>`:

   ```sh
   <runner> <evidence dir>/<topic>-<YYYY-MM-DD>/collect.py
   ```

   Or target a single device first to verify command syntax:

   ```sh
   <runner> <evidence dir>/<topic>-<YYYY-MM-DD>/collect.py <device>
   ```

1. If a commit happened on the routers since the last archive pull and `<config collect>` is bound, run `<config collect> <devices>` so `<configs dir>` catches up.

1. Record the findings in the corresponding `mop-note` under `### Live capture YYYY-MM-DD HH:MMZ`, citing `<device>/<slug>.txt` in the `Where` column of the `E#` table.
