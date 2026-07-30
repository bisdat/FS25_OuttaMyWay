# Prototype 08 — Collision Node Pose and Model-Derived Catalogue

## Authority state

Canonical v4.6.10. Prototype 08A live collision-node pose strongly supported; Prototype 08B identity/configuration catalogue supported; local mesh extents unresolved.

## Observation

Prototype 07 established the Runtime Geometry Access Gap: tested Lua bounding APIs did not expose usable physical bounds. Asset review then showed that Condor contains explicit configuration-dependent physical `compoundChild` collision shapes, while the vehicle save records purchased configuration, root pose and fold state.

TS001 and TS003 form a controlled pair for the same persistent 36 m Condor:

- TS001: stationary, AI inactive, boom folded, `foldAnimTime=1.0`;
- TS003: AI active and moving, boom deployed, `foldAnimTime=0.0`.

## Named discoveries

### Configuration–Pose Separation

The purchased 36 m Geometry Family selects which collision-node family exists. The live Physical Pose selects where those nodes are now. Operational state is separate again.

### Save-State Geometry Bridge

Model assets provide collision identities, hierarchy and animation; save/runtime state provides Entity identity, selected configuration, root pose and fold state.

### Collision Mesh Extraction Gap

The I3D XML exposes shape identity and transforms, but local mesh extents remain inside the binary `.i3d.shapes` asset and are not available through the tested runtime APIs or this environment's offline tooling.


### Diagnostic Enumeration Blind Spot

The archival v4.6.9 TS001 run loaded and updated but emitted no Prototype 08A Entity or pose evidence. The existing observer later found Condor in `g_currentMission.vehicleSystem.vehicles`, while the probe had inspected only `g_currentMission.vehicles`, which was empty.

This disproved the implementation assumption that one mission-level vehicle collection is always authoritative. v4.6.10 enumerates both collections, deduplicates by root vehicle, logs source counts and emits an explicit warning when no matching Condor is found. The result is an instrumentation correction, not negative evidence against collision-node pose reconstruction.

## Prototype 08A hypothesis

> The eight physical collision nodes active for Condor's purchased 36 m Geometry Family can be resolved at runtime, retain Entity identity, and move consistently as `foldAnimTime` transitions between folded and deployed endpoints.

### Runtime evidence

Searchable log events:

- `PROTOTYPE08A ENUMERATION`
- `PROTOTYPE08A NO_MATCHING_ENTITY`
- `PROTOTYPE08A ENTITY_ATTACHED`
- `PROTOTYPE08A NODE_RESOLVED`
- `PROTOTYPE08A FOLD_STATE_CHANGED`
- `PROTOTYPE08A POSE_SAMPLE`
- `PROTOTYPE08A NODE_POSE`

The probe first enumerates both GIANTS mission vehicle collections and deduplicates by root Entity. It then resolves known mappings first, followed by a bounded one-time name scan. It records each node origin and local basis relative to the Condor root. It compares the live origin set with 08B's offline folded and deployed predictions.

## Prototype 08B hypothesis

> Vehicle XML and I3D scene data can produce a reproducible, source-fingerprinted catalogue of physical collision identity, hierarchy, configuration membership and endpoint node-origin pose, while representing unavailable mesh extents explicitly.

The extractor found:

- 29 physical compound-child shapes using the vehicle collision group;
- exactly eight active 36 m boom collision shapes;
- mappings for all eight;
- predicted deployed origin span: 30.240331 m laterally;
- predicted folded origin span: 2.823707 m laterally and 7.971000 m longitudinally;
- mesh extent status: `UNRESOLVED_BINARY_I3D_SHAPES`.

These are collision-node **origins**, not collision-mesh bounds and not a Physical Occupancy Envelope.

## Accepted TS001 validation evidence

The corrected run reported:

- `missionVehicles=0`;
- `vehicleSystemVehicles=54`;
- `uniqueRoots=53`;
- `condorCandidates=1`;
- one `ENTITY_ATTACHED`;
- eight `NODE_RESOLVED`;
- three `FOLD_STATE_CHANGED`;
- 62 `POSE_SAMPLE`;
- zero `NO_MATCHING_ENTITY` or missing-node events.

### Live lifecycle

- `t=0.1s`: `FOLDED`, `foldAnimTime=1.0000`, AI inactive;
- `t=8.3s`: `TRANSITION`, `foldAnimTime=0.9775`, AI active;
- `t=23.5s`: state changed to `DEPLOYED`;
- `t=25.4s` onward: stable `foldAnimTime=0.0000`.

The origin span changed continuously from approximately 2.8237 m folded to 30.2403 m deployed. All eight nodes remained resolved and one Condor Entity identity was preserved.

### 08A result

**Strongly supported.** Named physical collision nodes and their live transforms are available through the runtime even though local collision-mesh bounds are not. Live runtime node transforms are the authoritative pose source.

### 08B result

The catalogue correctly established 29 physical compound-child shapes, exactly eight active 36 m boom nodes, complete mappings and the principal folded/deployed lateral spans. Full offline endpoint reconstruction is not authoritative:

- six folded node origins matched closely;
- the two folded `Col04` nodes had a material longitudinal prediction error of approximately 11.1 m;
- stable deployed per-node comparison retained approximately 0.55 m RMS error.

Offline animation reconstruction remains diagnostic. Static local mesh extents, once extracted, shall be combined with live runtime transforms rather than an independently reconstructed pose.

## Segmented Tapered Occupancy observation

Condor has four boom segments per side. The outer segments appear progressively thinner away from the vehicle, suggesting a segmented tapered compound footprint rather than one uniform-width rectangle. This is supporting evidence for Condor only. Other foldable implements may have different segment counts, proportions, activation, asymmetry and articulation and must be discovered independently.

## Canonical result

Prototype 08 validates collision-node identity and live pose, but not collision-mesh extent or a Physical Occupancy Envelope. Binary `.i3d.shapes` extent extraction, current compound occupancy, containment, transition sweep, projected motion sweep, static-object geometry and Control remain deferred.
