---
name: network-topology-svg
description: Draw a hand-placed SVG network topology (firewall / spine / leaf / access tiers, HA pairs, VC stacks) with interface names on every link end, plus a matching cable list, for lab tickets, MOP notes, or build docs. Use when asked to draw, redraw, or fix a topology diagram as SVG, to "get the levels and locations right", or when a Mermaid topology is too messy to read.
---

# Network topology SVG

Produce `<dir>/topology.svg` plus a `topology.md` that embeds it (`![...](topology.svg)`) and
holds the cable list. The cable list is the source of truth; the drawing must match it
link for link. Reference drawing: `examples/sample-topology.svg` (1640x1010, 4 tiers, 23 cables).
Start from it: copy its `<style>` block, and the way it builds tier bands, boxes, tags and legend.

## 1. Gather facts. Do not invent any

- Hostnames, models, AS numbers and port names come from the repo: inventory, generated or
  lab configs (`set interfaces ...`, `ether-options 802.3ad aeN`, descriptions, p2p
  addresses). Record each source path in `topology.md`.
- Left-to-right order: keep the order of any existing drawing (for example a PNG in `lab/`). If
  there is none, use numeric order (Spine1 left, Leaf1 leftmost, pairs adjacent).
- Any port, optic or model you cannot verify: label it `TBC`, or by role (`10G-1`), in the
  drawing and the table, and list it under "Open items". Never guess vendor port names.
- Ask the user only for facts the repo cannot give (which stack is which model, member counts).

## 2. Plan coordinates before writing

Write down a small table of x/y for every box and every port anchor first. Rules:

- **Tiers top to bottom**: firewall, spine, leaf, access. Each tier gets a light band
  (`#f6f7f9`) and a bold gray label in a left gutter (x 0-130).
- **Pairs sit side by side** with a horizontal peer or ICL link between them: two parallel lines
  for a 2-member LAG, port names above each line at both ends, AE name below the middle.
  Leave at least 150 px between pair members so the four port labels fit.
- **Upper-tier devices** sit centred over the devices they serve. Each access stack sits
  centred under its leaf pair.
- **Port tags** are small white rounded rects with monospace 10px text, placed on the box edge
  that faces the link (uplinks on the top edge, downlinks on the bottom edge). Order the tags
  left to right in the same order as the far-end devices, so that lines fan out and do not
  tangle at the box.
- **VC / stack**: a dashed frame. Members are stacked vertically (member 0 on top) with role
  and model on each member. The VC ring is dashed gray. The stack title and ESI sit under the
  frame (not inside it), so that uplink lines do not cross the title.
- **Lines end exactly on a tag edge or a box edge.** Lines that come into a member's side end on
  its side edge, with the port label on the side the line does not come from.
- Put the legend in empty space inside a tier band (between the access stacks works well).

## 3. Write the SVG

- Root: `viewBox="0 0 W H" width="W" height="H"` (the preview script requires this exact
  form). Add a white background rect and a title line at the top.
- Draw order: bands, then **all lines**, then boxes, then tags and labels. Boxes cover
  line ends, so labels stay readable.
- One CSS class per link type, with a fixed colour, and the same class in the legend:
  - uplinks to spine A `#1f5fbf`, uplinks to spine B `#7b3fb0`
  - peer / ICL `#222`, 3px
  - ESI-LAG / access `#d35400`
  - firewall `#c0392b`
  - HA: double line `#8e1b10`
  - VC: dashed `#888`
- Box fills by tier: firewall `#fde2e2`, spine `#dbe8fb`, leaf `#dff3e4`, access `#fff3d6`.
  Box text: bold name, hostname, then model and AS.
- Do not use `<foreignObject>`, external fonts, or scripts. The file must render in GitHub,
  browsers and Quick Look.
- The legend lists line types with speed and optic, which VLANs ride which links, config
  changes the drawing assumes (for example a port-speed change), and the TBC items.

## 4. Preview and fix

```sh
python3 "$SKILL_DIR/scripts/preview.py" <dir >/topology.svg <dir >/_preview
```

The script validates the XML and renders square, overlapping tiles as PNGs (Quick Look
scales each image to fill a square and crops the rest). Read every PNG and check:

- no text overlaps a line, another label, or a box edge
- every cable in the table is drawn once, with the correct port name at both ends
- the left/right order of devices matches the facts from step 1

Fix the coordinates, re-run, then delete `<dir>/_preview/`. Off macOS, render with
`rsvg-convert` or a browser instead.

## 5. Finish

- `topology.md`: a device table (role, model, hostname), the embedded SVG, the cable list
  (`# | A end | B end | Purpose | Speed / optic`), config changes the plan needs, and Open items.
- When the drawing changes, update the table in the same change, and the reverse.
