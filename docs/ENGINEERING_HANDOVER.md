# Engineering Handover

## Canonical baseline

v4.6.10 is canonical. It was derived from canonical v4.6.8 after archival noncanonical v4.6.9 exposed the Diagnostic Enumeration Blind Spot. The corrected TS001 run validated Prototype 08A.

## Accepted result

- both GIANTS vehicle collections were enumerated explicitly;
- Condor attached once from the vehicle-system population;
- all eight configured 36 m physical boom collision nodes resolved through I3D mappings;
- one persistent Entity completed `FOLDED -> TRANSITION -> DEPLOYED`;
- live origin span changed continuously from approximately 2.8237 m to 30.2403 m;
- no no-match, missing-node, runtime-error or Control event occurred.

Prototype 08B remains the static catalogue source for collision identity, hierarchy and configuration membership. Its offline endpoint reconstruction is diagnostic rather than authoritative; live runtime transforms own pose truth.

## Model-specific observation

Condor has four boom sections on each side and appears progressively thinner toward each tip. This supports a segmented tapered compound representation for Condor, but not a generic foldable-implement template. Every model must supply its own segmentation, activation, dimensions and articulation evidence.

## Current gap

The binary `.i3d.shapes` local collision-mesh extents remain unresolved. Collision-node origins are not mesh bounds and no Physical Occupancy Envelope is yet authoritative.

## Next focus

Select and validate a trustworthy collision-mesh extent extraction route, initially for Condor's eight active boom nodes and permanent chassis collision parts. Combine those static local extents with the already validated live node transforms only after extraction evidence passes.

## Boundary

Do not infer segment dimensions from visual taper, working width, AI trigger width or origin spacing. Do not implement containment, swept geometry, Decision, Commitment or Control before current physical occupancy is trustworthy.
