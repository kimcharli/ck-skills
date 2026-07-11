#!/usr/bin/env python3
"""Guard against mangled YAML frontmatter in SKILL.md and command files.

An mdformat run without the frontmatter plugin destroys frontmatter in a way
later formatter runs cannot detect or repair: 'key: value' lines followed by
the closing --- become setext headings ('## description: ...'), and the
opening --- becomes a thematic-break underscore line. This validator fails
fast on any file whose frontmatter is missing or structurally broken, so a
mangle can never land on main unnoticed. Stdlib-only; run from the repo root
(pre-commit) or any checkout (CI).

Checked: plugins/**/SKILL.md and plugins/*/commands/*.md, excluding
template/templates directories (those files are scaffolding payloads, not
live skill/command definitions).
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

MAX_BLOCK_LINES = 60
KEY_RE = re.compile(r"^[A-Za-z0-9_-]+:(\s|$)")
CONTINUATION_RE = re.compile(r"^\s+\S")
UNDERSCORE_BREAK_RE = re.compile(r"^_{10,}\s*$")


def target_files() -> list[Path]:
    files = set(REPO_ROOT.glob("plugins/**/SKILL.md"))
    files |= set(REPO_ROOT.glob("plugins/*/commands/*.md"))
    return sorted(
        f for f in files
        if not any(part in ("template", "templates") for part in f.relative_to(REPO_ROOT).parts)
    )


def check(path: Path) -> str | None:
    """Return an error message, or None if the frontmatter is valid."""
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines:
        return "file is empty"
    if UNDERSCORE_BREAK_RE.match(lines[0]):
        return (
            "starts with an underscore thematic break -- the mdformat-mangle "
            "signature (opening '---' was reformatted away)"
        )
    if lines[0].strip() != "---":
        return "does not start with a '---' frontmatter delimiter"
    block: list[str] = []
    for line in lines[1:MAX_BLOCK_LINES]:
        if line.strip() == "---":
            break
        block.append(line)
    else:
        return f"no closing '---' delimiter within the first {MAX_BLOCK_LINES} lines"
    if not any(line.strip() for line in block):
        return "frontmatter block is empty"
    for i, line in enumerate(block, start=2):
        if not line.strip():
            continue
        if line.lstrip().startswith("#"):
            return f"line {i} is a markdown heading inside frontmatter -- mangle signature: {line.strip()!r}"
        if not (KEY_RE.match(line) or CONTINUATION_RE.match(line)):
            return f"line {i} is not a 'key: value' pair or continuation: {line.strip()!r}"
    keys = {m.group(0).rstrip(": \t") for line in block for m in [KEY_RE.match(line)] if m}
    if not ({"description", "name"} & keys):
        return f"frontmatter has neither 'description' nor 'name' key (found: {sorted(keys) or 'none'})"
    return None


def main() -> int:
    failures = []
    files = target_files()
    for path in files:
        error = check(path)
        if error:
            failures.append((path.relative_to(REPO_ROOT), error))
    if failures:
        print("frontmatter check failed:\n", file=sys.stderr)
        for rel, error in failures:
            print(f"  - {rel}: {error}", file=sys.stderr)
        print(
            "\nLikely cause: mdformat ran without the frontmatter plugin. "
            "Never run bare 'mdformat' -- use 'uvx pre-commit run mdformat' "
            "(see .pre-commit-config.yaml and AGENTS.md).",
            file=sys.stderr,
        )
        return 1
    print(f"frontmatter OK in {len(files)} files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
