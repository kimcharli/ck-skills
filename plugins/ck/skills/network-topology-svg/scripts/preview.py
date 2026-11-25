#!/usr/bin/env python3
"""Validate a topology SVG and render PNG preview slices with macOS Quick Look.

qlmanage scales to fill a square and crops the rest, so the SVG is cut into
square tiles (side = the shorter edge, last tile overlaps) rendered one by one.

usage: preview.py <file.svg> <outdir>
Writes <outdir>/<stem>-<n>.png and prints the paths. Read them, then delete them.
"""

import math
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path


def tile_tags(root_tag: str, w: float, h: float) -> list[str]:
    t = min(w, h)
    xs = [min(i * t, w - t) for i in range(math.ceil(w / t))]
    ys = [min(j * t, h - t) for j in range(math.ceil(h / t))]
    # shortcut: Quick Look's web view zooms content past ~800 px; a fixed 800 px tile fits whole
    bare = re.sub(r'\s(width|height|viewBox)="[^"]*"', "", root_tag)
    return [
        bare.replace(
            "<svg",
            f'<svg viewBox="{x:g} {y:g} {t:g} {t:g}" width="800" height="800"',
            1,
        )
        for y in ys
        for x in xs
    ]


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    src, out = Path(sys.argv[1]), Path(sys.argv[2])
    text = src.read_text()
    ET.fromstring(text)  # raises on malformed XML
    root = re.search(r"<svg\b[^>]*>", text)
    vb = root and re.search(r'viewBox="0 0 ([\d.]+) ([\d.]+)"', root[0])
    if not vb:
        sys.exit('root <svg> needs viewBox="0 0 W H"')
    if not shutil.which("qlmanage"):
        sys.exit(
            "qlmanage not found (macOS only); use rsvg-convert or a browser instead"
        )
    w, h = float(vb[1]), float(vb[2])
    out.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        for i, tag in enumerate(tile_tags(root[0], w, h), 1):
            part = Path(tmp) / f"{src.stem}-{i}.svg"
            part.write_text(text.replace(root[0], tag, 1))
            subprocess.run(
                ["qlmanage", "-t", "-s", str(int(min(w, h))), "-o", tmp, str(part)],
                check=True,
                capture_output=True,
            )
            dest = out / f"{src.stem}-{i}.png"
            shutil.move(Path(tmp) / f"{part.name}.png", dest)
            print(dest)


if __name__ == "__main__":
    # self-check: 1640x1010 -> two 1010 squares, the second clamped to the right edge
    t = tile_tags(
        '<svg xmlns="x" viewBox="0 0 1640 1010" width="1640" height="1010">', 1640, 1010
    )
    assert len(t) == 2 and 'viewBox="630 0 1010 1010"' in t[1], t
    main()
