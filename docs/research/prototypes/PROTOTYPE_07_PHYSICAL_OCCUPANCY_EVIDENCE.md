# Prototype 07 — Physical Occupancy Evidence

## Status

Canonical v4.6.8. Tested Direct Geometry Retrieval route unsupported; negative evidence accepted.

## Observation

Condor and Patriot can pass safely in adjacent opposing lanes. Physical boom extent, agricultural working width and active GIANTS collision geometry therefore cannot be treated as one measurement. Existing Prototype 05 rectangles use size and AI-marker information only as provisional broad diagnostics and are not trustworthy containment geometry.

## Named discoveries

- **Geometry Domain Separation** — GIANTS Collision Geometry, Physical Occupancy Envelope, Working Footprint, Configuration Transition Sweep and Projected Motion Sweep are separate spatial truths.
- **Physical–Agronomic Separation** — physical extent and agricultural working effect may differ in either direction.
- **No Silent Under-Approximation** — unknown or partial geometry must remain explicit rather than masquerading as exact or conveniently small.

## Hypothesis

> GIANTS-accessible collision/physics and bounding evidence can be aggregated across a complete vehicle–implement Entity into a conservative current Physical Occupancy Envelope that records provenance, coverage and confidence and changes with physical configuration rather than ordinary translation.

## Evidence contract

### Runtime capability inventory

One `PROTOTYPE07 ENGINE_CAPABILITIES` event records whether the runtime exposes candidate bound, rigid-body, collision-mask and hierarchy APIs. Availability is evidence only, not proof of semantic correctness.

### Node-level provenance

Initial `PROTOTYPE07 NODE_EVIDENCE` events expose a bounded sample of discovered nodes, their object role, bound source, raw rigid-body/collision-mask evidence and local dimensions. These samples diagnose what the engine exposes without treating API availability as semantic proof.

### Complete-Entity aggregation

`PROTOTYPE07 ENTITY_GEOMETRY` must report the root vehicle and every recursively attached/towed object as one Entity. It records object count, candidate nodes, physics-confirmed bounded nodes, bounded-object coverage, source summary, confidence and frame stability.

### Physical and agronomic separation

The compound physical envelope is derived only from discovered bounds. `workingMarkerWidth` and size metadata are logged separately and `workingWidthSubstitution=false` is required in pair evidence.

### Configuration/evidence change

`PROTOTYPE07 ENVELOPE_CHANGED` records a changed Entity-local signature. Ordinary translation should not change an Entity-local signature. A world-AABB-derived source is explicitly marked because rotation may destabilise it.

### Pair clearance

For nearby pairs where at least one Entity is operational, `PROTOTYPE07 PAIR_GEOMETRY` reports centre distance, derived physical-envelope clearance/intersection and independent working marker widths. The result remains `authoritative=false` until validated.

## Implementation

Geometry evidence and diagnostic lifecycle are separated into focused modules: `PhysicalEnvelopeEvidence.lua` owns discovery/derivation, while `PhysicalOccupancyProbe.lua` owns sampling and logs.

The passive probe:

1. consumes retained Field World vehicle members and enumerates their complete root/attachment object trees;
2. inventories component roots and physics-confirmed descendant nodes;
3. tries shape-local, local and world bounding evidence through capability-gated protected calls;
4. transforms discovered bounds into the root Entity frame;
5. unions them into one conservative current compound rectangle;
6. assigns evidence coverage and confidence without using working width as fallback;
7. refreshes hierarchy discovery every five seconds while sampling discovered bounds every 500 ms;
8. reports pair clearance from the compound envelopes.

## Passive guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- `PROTOTYPE_07_ENABLED = true`;
- no containment, projected sweep, safety padding, speed, steering, implement, route, AI-job, Decision, Commitment, hold or release action is permitted.

## Validation sequence

### Stage 1 — capability and coverage

Run a known Condor/Patriot save. Determine:

- which APIs exist;
- whether each complete Entity obtains any bounded physics evidence;
- whether attached equipment is included;
- whether confidence is `HIGH_DISCOVERED`, `MEDIUM_MIXED`, `LOW_COMPONENT_BOUNDS` or `UNKNOWN`;
- whether hierarchy scans truncate.

A result of `UNKNOWN` is valuable evidence that runtime collision geometry is not directly available through the attempted boundary.

### Stage 2 — safe adjacent-lane pass

Use a repeatable period where Condor and Patriot pass safely in adjacent opposing lanes. The derived envelopes should remain separated. Working-marker adjacency or overlap must not create a physical intersection by itself.

### Stage 3 — configuration change

Only after Stage 1 identifies a usable source, create TS004 with a folded/unfolded or articulated configuration. A real physical change should alter the Entity-local envelope; ordinary translation should not.

## Success criteria

Prototype 07 is supported when:

1. at least one trustworthy runtime geometry source is identified;
2. the complete vehicle–implement Entity is covered without relying on working width;
3. a known safe adjacent-lane pass reports positive physical-envelope clearance;
4. a real configuration change alters the envelope while ordinary translation does not;
5. no runtime error, performance disturbance or vehicle-control behaviour occurs.

## What would disprove or weaken the hypothesis

- no usable runtime bounds exist;
- attached equipment is omitted;
- the envelope changes merely because the Entity translates or rotates;
- a known safe pass reports intersection;
- working width is the only source capable of producing a result;
- hierarchy scanning materially disturbs gameplay;
- the probe claims completeness despite partial evidence.

## Deferred boundaries

Prototype 07 does not evaluate the field polygon, current containment, configuration-transition sweep, projected motion sweep, safety margins, perceptual clearance, static-object identity or Control.

## Accepted validation evidence

TS003 ran for approximately 337 s with Condor and Patriot present.

### Runtime capability boundary

`PROTOTYPE07 ENGINE_CAPABILITIES` reported:

- `getShapeBoundingBox=false`;
- `getBoundingBox=false`;
- `getWorldBoundingBox=false`;
- `getRigidBodyType=true`;
- `getCollisionMask=false`.

### Entity evidence

For both Condor and Patriot:

- `objects=1` under the currently exposed complete-Entity object tree;
- `scannedNodes=800` and `scanTruncated=true`;
- `boundedNodes=0`;
- `physicsBoundNodes=0`;
- `boundedObjects=0/1`;
- `coverage=NONE`;
- `confidence=UNKNOWN`;
- `compoundWidth=unknown` and `compoundLength=unknown`;
- `workingMarkerWidth=36.00` remained separate;
- `authoritative=false`.

Across every heartbeat, two Entities remained observed while
`envelopesDiscovered=0` and `entitiesWithPhysicsBoundEvidence=0`. No
`PROTOTYPE07 NODE_EVIDENCE`, `PAIR_GEOMETRY` or `ENVELOPE_CHANGED` event could be
produced.

## Named findings

### Runtime Geometry Access Gap

GIANTS clearly possesses collision geometry internally, but the tested mod Lua
boundary did not expose usable bounds for complete-Entity occupancy derivation.
Finding more rigid-body nodes would not by itself solve the absence of a bound source.
Increasing hierarchy depth is therefore not the next justified action.

### Retained Entity, Missing Spatial Truth

The final run contained a 76.99 s sweeping Patriot manoeuvre, a near miss and an
observed reverse deadlock against parked Condor. Existing Field World observation
retained Condor and classified the relationship as relevant, but Prototype 07 could
not describe current clearance, rotation sweep or reverse occupancy.

## Result

**Tested implementation route unsupported.**

Prototype 07 disproves the assumption that GIANTS collision geometry is necessarily
available as directly queryable runtime bounds. It does not disprove the Physical
Occupancy Envelope architecture.

No Silent Under-Approximation passed: unknown physical geometry remained unknown and
working width was never substituted.

## Next investigation boundary

Compare one alternative source at a time:

1. loaded vehicle/implement runtime structures and XML metadata;
2. configured XML/I3D geometry reconstruction;
3. indirect physics overlap or raycast queries as a Physical Occupancy Oracle;
4. controlled empirical envelope discovery.

Containment, configuration-transition sweep, projected motion sweep, safety margins,
static-object identity and Control remain deferred.

