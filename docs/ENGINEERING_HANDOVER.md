# Engineering Handover

## Canonical baseline

Canonical v4.6.8 derives from the exact tested Prototype 07 candidate.

Accepted candidate SHA-256:

`97e46f233320d15110343faf481bb08b19bc26f298cbc165ff9b028742d9d34c`

## Accepted result

Prototype 07 disproved the tested Direct Geometry Retrieval route without weakening
the Physical Occupancy Envelope architecture.

In TS003:

- `getRigidBodyType` was available;
- tested shape, local and world bounding functions and collision-mask query were not;
- Condor and Patriot each scanned 800 nodes with truncation;
- bounded nodes and physics-bound nodes remained zero;
- both Entities remained `coverage=NONE`, `confidence=UNKNOWN`;
- approximately 337 s of heartbeats retained two Entities but zero envelopes;
- no pair-clearance or envelope-change evidence could be produced;
- both 36 m working-marker widths remained separate and were never used as physical
  geometry.

This is named the Runtime Geometry Access Gap. GIANTS has internal collision geometry,
but the tested mod Lua boundary did not expose usable complete-Entity bounds.

## Secondary operational evidence

The final TS003 sequence contained a sweeping Patriot manoeuvre, a near miss and an
observed reverse deadlock against parked Condor. Situation Assessment retained Condor
as a relevant Field World Entity, but current clearance, rotation sweep and reverse
occupancy remained unknown. This is Retained Entity, Missing Spatial Truth.

## Current boundary

Select one alternative physical-evidence route before further implementation:

1. inspect loaded vehicle/implement runtime structures and XML metadata;
2. reconstruct configured geometry from XML/I3D model information;
3. test indirect physics-world overlap or raycast queries as an occupancy oracle;
4. design controlled empirical envelope discovery.

Do not enlarge hierarchy traversal, implement containment mathematics, create a
folding fixture or add Control until one evidence route is justified.

## Repository entry point

1. `docs/PROJECT_STATUS.md`
2. `docs/prototypes/PROTOTYPE_07_PHYSICAL_OCCUPANCY_EVIDENCE.md`
3. `docs/ARCHITECTURE.md`
4. `docs/CONCEPT_REGISTER.md`
5. `docs/ROADMAP.md`

Continue using:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat
