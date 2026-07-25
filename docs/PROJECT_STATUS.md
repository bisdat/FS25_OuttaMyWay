# Project Status

Version: 4.6.15

Authority state: Release Candidate — validated Prototype 09–12 consolidation awaiting repository-owner review

Canonical baseline: v4.6.10

Evidence-bearing noncanonical candidates: v4.6.11 Prototype 09, v4.6.12 Prototype 10, v4.6.13 Prototype 11 and v4.6.14 Prototype 12

Current focus: define Member-Local Physical Resolution and the precise Prototype 13 hypothesis before implementation

## Established geometry evidence

Prototype 08A established authoritative live collision-node pose for all eight active Condor 36 m boom collision nodes. Prototype 08B established source collision identity, hierarchy and configuration membership.

Prototype 09 strongly supported stable geometry-derived component-local spheres on all eight resolved boom collision nodes. Prototype 10 disproved `vehicle.rootNode + source asset shapeId` as a descendant selector and exposed Root-Entity Sphere Aliasing plus the Self-Coherence Blind Spot. Prototype 11 strongly supported Runtime Entity Geometry Authority and Second-Argument Non-Authority for the tested APIs and Entity types.

The accepted geometry chain is:

```text
source physical identity
    -> source-to-runtime Entity resolution
    -> runtime Entity geometry sphere
    -> authoritative live Entity pose
```

## Established assembly evidence

Prototype 12 is strongly supported across three base-game fixtures:

| Fixture | Classification | Members | Runtime roots | Result |
|---|---|---:|---:|---|
| Condor Endurance II | Integrated single member | 1 | 1 | Supported |
| Valtra S 416 + Horsch Tiger 8 MT | Attached multi-member | 2 | 2 | Supported |
| John Deere 8RX 410 + Väderstad TopDown 600 | Attached multi-member | 2 | 2 | Supported and replicated |

Both attached fixtures exposed one explicit attachment edge and retained independent member assets, roots, components, mappings and runtime hierarchy boundaries. This establishes the **Physical Assembly Search Boundary**:

```text
Operational Worker
    -> Current Physical Assembly
    -> Individual Assembly Members
    -> Member-local source/runtime identity resolution
```

## AI progression observation

The S 416 plus Tiger 8 MT remained logically active and reported `WORKING` while measured movement remained effectively zero for at least fifteen seconds. The combination could cultivate manually, so simple equipment incapability is disproved. The cause remains unresolved and is not attributed to OuttaMyWay. The 8RX 410 plus TopDown 600 subsequently sustained normal AI work, confirming that assembly discovery and AI progression are separate concerns.

## Candidate implementation state

- Prototypes 08, 09, 11 and 12 are disabled after completing their current evidence roles.
- Prototype 10 remains retained as recorded disproval only.
- Prototype 12's passive implementation and log contract remain available for future replication.
- No collision membership inference, compound occupancy, containment, sweep or control exists.

## Next gate

Discuss **Member-Local Physical Resolution** before implementation. The next experiment should resolve source physical identities independently inside each discovered assembly member while preserving source collision metadata as physical authority and runtime Entity identity as geometry authority.
