# Project Status

Version: 4.6.10

Authority state: Canonical — Prototype 08 live collision-node pose validated

Canonical package: v4.6.10

Current focus: extract trustworthy local collision-mesh extents and combine them with validated live node transforms

## Prototype 08A result

Strongly supported. Corrected TS001 enumerated Condor from the vehicle-system collection, resolved all eight configured 36 m physical boom collision nodes, preserved one Entity identity and observed one complete `FOLDED -> TRANSITION -> DEPLOYED` lifecycle.

The lateral collision-node origin span changed continuously from approximately 2.8237 m folded to 30.2403 m deployed. Live runtime transforms are accepted as authoritative pose evidence.

## Prototype 08B result

Supported for collision identity, hierarchy, configuration membership and source fingerprinting. Its principal folded/deployed lateral spans matched live evidence, but full offline endpoint pose remained approximate. Offline pose is diagnostic, not authoritative.

The binary `.i3d.shapes` local mesh extents remain unresolved. No Physical Occupancy Envelope is yet derived.

## Geometry caution

Condor's four boom sections per side appear progressively thinner toward the tips. This supports a segmented tapered representation for Condor only. Other foldable implements may have different segmentation, geometry, activation and articulation.

## Passive guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototype 07's expensive completed bound scan remains disabled;
- Prototype 08 runs before the observer-only return;
- no containment, projected sweep, Decision, Commitment or Control is permitted.

## Next gate

Do not implement containment until local collision-mesh extents are extracted or otherwise established conservatively and validated against the live node-pose source.
