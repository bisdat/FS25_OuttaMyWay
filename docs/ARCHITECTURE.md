# Architecture

## Entry point

`modDesc.xml` loads only `scripts/main.lua`. The main script sources the remaining modules in dependency order.

## Modules

### `scripts/config.lua`
Global constants, version, tuning values and runtime state tables.

### `scripts/core/Runtime.lua`
Main update loop and established reactive behaviour. Owns active-worker collection, wait/release, recovery, passage assist, AI restart handling and map lifecycle.

### `scripts/prediction/CourseLookahead.lua`
Reads `AIDriveStrategyFieldCourse`, extracts ordered segment positions, estimates the active course location, builds future polylines, predicts route intersections and logs completion-priority diagnostics. In the current branch this is observer-only.

### `scripts/prediction/VectorPrediction.lua`
Constant-velocity TCPA/CPA prediction and working-width clearance envelopes. Retained as a secondary and emergency predictor.

### `scripts/decision/DecisionEngine.lua`
Scores predictive actions, manages commitment stability and exposes the primary recommendation. Predictive control must respect encounter authority.

### `scripts/reservation/ReservationEngine.lua`
Creates time-bounded corridor reservations from predictions and tracks the primary reservation.

### `scripts/control/EncounterController.lua`
Authoritative pair controller. Issues GO, WAIT or DIRECT_CONTROL commands and prevents predictive logic from reversing an active reactive encounter.

### `scripts/geometry/FieldBoundary.lua`
GIANTS-backed field-boundary discovery and rearward/forward edge measurements. Retains the reported root boundary and field islands for passive Field World evidence.

### `scripts/prototypes/FieldWorldProbe.lua`
Passive Prototype 05 observer. Discovers the bounded Field World, retains active and non-active mission vehicles independently of Operational Membership, and records dynamic Situation Relevance. Current envelope geometry is diagnostic only and never issues Control.

### `scripts/settings/Settings.lua`
Runtime settings and debug-channel state.

### `scripts/settings/ConsoleCommands.lua`
Console commands for enabling the mod, simulation mode, HUD, warnings and debug channels.

### `scripts/ui/Hud.lua`
Custom status panel and warnings.

### `scripts/events/OuttaMyWayStateEvent.lua`
Multiplayer state synchronisation for HUD/status information.

## Authority order

```text
Direct recovery / re-entry
        >
Encounter controller
        >
Committed predictive action
        >
New traffic recommendation
        >
Diagnostic-only forecast
```

## Update cadence

- Runtime conflict loop: 100 ms.
- Expensive geometry/course work: throttled and cached.
- HUD: draw callback with cached state.
- Diagnostic logging: change-driven plus heartbeat.

## Current 4.0 limitation

The active course segment estimate can jump during turns because proximity alone may select a nearby parallel segment. Until corrected, course ETAs and completion priority are diagnostics only.

## Observer contract (4.2.3)

The Observer is global and read-only. It broadcasts facts for every active AI field worker without grouping by field, farmland, job or conflict.

`EventBus` events include `workerObserved`, `workerAttached`, `workerDetached`, `workerStateChanged`, `workerPhaseChanged`, `workerTurnStarted`, `workerTurnCompleted`, and `workerBlockedChanged`.

Consumers decide relevance locally. The diagnostic `InteractionContexts` consumer creates persistent contexts from spatial proximity and observed movement only. Field IDs are deliberately not part of the grouping rule. Contexts preserve identity across temporary dormancy and are not route or terrain-connectivity claims.

### Candidate pairs and interaction contexts

The locality consumer uses two stages. Candidate pairs are broad, temporary observations. Promotion to an interaction group requires movement evidence or close-range relevance. A straight-line field-continuity sample may be recorded as supporting evidence, but it is not authoritative because U-shaped fields, islands, ditches, hedges, and map-specific ground APIs can invalidate a simple line test.


### Persistent context lifecycle

A context is created on the first promoted encounter, becomes `ACTIVE` while movement evidence is present, and becomes `DORMANT` when that evidence fades. The same member set reactivates the same context ID during the retention window. Contexts record first seen time, last active time, cumulative active time, and encounter count.

## Field World and Full-Envelope Field Containment (v4.6.6)

The field boundary polygon defines the bounded **Field World** for one field Operation. OuttaMyWay is not responsible for map-wide navigation or arbitrary external obstacles.

**Full-Envelope Field Containment** is an architectural invariant:

> The complete operational collision envelope of an AI worker — vehicle plus every attached or towed implement, including configuration-dependent maximum extent and projected swept geometry — remains wholly inside the field polygon at all times.

Containment applies to the complete geometry, not the vehicle root node, tractor body, centreline or nominal working width. A deployed boom must never sweep partially outside the polygon. Objects immediately beyond the polygon, including hedges, trees, ditches and pylons, therefore remain outside normal obstacle scope. The hedges removed from TS001 were a test workaround for missing containment behaviour and must not become a final-system requirement.

Situation Assessment separates three classifications:

- **Field World Membership:** physical geometry intersects the bounded Field World;
- **Operational Membership:** the Entity actively participates in the Operation;
- **Situation Relevance:** the Field World Member can currently affect an Operation member or a plausible future.

A stopped, completed or player-controlled vehicle can remain a Field World Member and become Situation-relevant after leaving Operational Membership. Static geometry wholly inside the polygon also belongs to the Field World.

Prototype 05 implements passive vehicle observation using conservative current-envelope rectangles. It does not yet implement exact maximum geometry, projected sweep or active containment.

### Geometry Domain Separation (v4.6.8)

Situation Assessment must not collapse different spatial truths into one width value:

- **GIANTS Collision Geometry** is physics evidence attached to model components;
- **Physical Occupancy Envelope** is the conservative ground-plane area occupied now by the complete vehicle–implement Entity;
- **Working Footprint** is the area receiving agricultural work and may be wider, equal to or narrower than physical occupancy;
- **Configuration Transition Sweep** is the area occupied while folding, unfolding, raising or lowering;
- **Projected Motion Sweep** is the area likely to be occupied through translation, steering and articulation.

Working width shall never substitute for physical geometry. The Condor and Patriot can pass safely in adjacent opposing lanes, demonstrating that physical boom extent, working width and active GIANTS collision geometry can differ.

**No Silent Under-Approximation** is an invariant: Situation Assessment must expose unknown, partial or low-confidence geometry rather than representing an Entity as smaller than the available evidence supports. A conservative broad-phase approximation may exclude distant cases, but it cannot become authoritative containment knowledge merely because it is convenient.

### Configuration–Pose Separation and the Model-Derived Route (v4.6.10)

A purchased **Geometry Family** selects the collision-node family available to an Entity. **Physical Pose** determines where those nodes are now; **Operational State** is independent again. The same 36 m Condor may be folded and stationary, transitioning, deployed and working, or deployed and parked.

The Model-Derived Collision Catalogue binds static asset knowledge—collision identity, hierarchy, filters, configuration membership and local mesh extent—to live node transforms. Prototype 08 currently provides identity/hierarchy and pose only. Collision-node origins are not mesh bounds, and the Collision Mesh Extraction Gap remains explicit.

Prototype 07 passively inventories GIANTS-accessible geometry and derives a current compound envelope with explicit provenance and confidence. It does not claim exact collision truth, configuration-transition sweep, projected motion sweep or containment.

### Component-Local Sphere Bridge and Extent Truth–Utility Separation (v4.6.13)

Prototype 09 strongly supported a runtime bridge from source collision identity through a correctly resolved runtime collision node to a conservative component-local geometry sphere. All eight active Condor 36 m boom nodes retained stable local centre/radius through articulation and transformed coherently into engine world bounds.

The source asset `shapeId` is retained as provenance metadata, not yet as a proven runtime selector. Exact mesh dimensions remain unresolved. Sphere Precision Tax means long thin or tapered components may be truthfully bounded while still including too much empty space for operational containment.

### Runtime Geometry Identity Separation (v4.6.13)

Prototype 10 disproved the stronger assumption that `vehicle.rootNode + source asset shapeId` selects arbitrary descendant geometry. All tested physical IDs and a nonphysical control aliased to one root-Entity sphere. This established two constraints:

- **Self-Coherence Blind Spot:** internally coherent local/world bounds can still describe the wrong Entity;
- **Source-to-Runtime Shape Resolution:** source shape identity and runtime Entity identity require an explicit bridge.

Situation Assessment must therefore keep three domains separate:

1. source collision identity and configuration membership;
2. resolved runtime Entity identity and live pose;
3. geometry-bound identity returned by the runtime API.

Prototype 11 strongly supported first-argument runtime Entity geometry authority and Second-Argument Non-Authority for the tested calls. No complete physical coverage is claimed until the remaining current physical source shapes are resolved to runtime Entities.

## Logging vocabulary (4.2.6)

Runtime diagnostics use the full searchable mod name followed by an architectural category.

| Prefix | Meaning | Responsibility |
|---|---|---|
| `INFO` | Information | Lifecycle, version and configuration events. |
| `OBS` | Observation | Facts read from the world without influencing it. |
| `DEC` | Decision | Why a course of action was selected. |
| `CTL` | Control | Commands issued to influence vehicle behaviour. |
| `VAL` | Validation | Comparison of expected and observed outcomes. |
| `REC` | Recovery | Degraded situations, handoff and recovery activity. |
| `PERF` | Performance | Timing, update frequency and resource-use diagnostics. |

Example: `[OuttaMyWay][OBS] Worker attached ...`

These abbreviations are part of the project vocabulary, not merely debugging shorthand.

## Architectural Concept Governance

The authoritative Accepted, Deferred and Rejected concept classifications are maintained in `CONCEPT_REGISTER.md`. Engineering promotion and review rules are defined in `ENGINEERING_ARCHITECTURE.md`.

## Decision Engine refinement (v4.5.9)
The Decision Engine continuously evaluates the current Commitment against the Operational Picture. 'Maintain current commitment' is an explicit successful outcome. The design objective is least intervention, producing graceful behaviour while remaining largely invisible to the player.


## Physical Assembly Ownership (v4.6.15)

### Runtime Entity Geometry Authority

Prototype 11 strongly supports that a resolved runtime Entity owns geometry selection for the tested sphere APIs. Source asset `shapeId` remains provenance metadata and did not select sibling or descendant geometry.

### Mapping-Key Locality

Asset mapping keys such as Condor's `colPart` are local vocabulary. A mapping mechanism may help resolution, but key spelling has no universal physical meaning.

### Operational Entity–Physical Assembly Separation

The Operation-facing AI worker and the complete physical working combination are separate architectural identities. Condor currently forms one integrated member. Tractor–implement combinations form multiple attached members with independent asset files and runtime roots.

### Physical Assembly Search Boundary

Prototype 12 strongly supported the following resolution order across one integrated and two attached fixtures:

```text
Operational Worker
    -> Current Physical Assembly
        -> Assembly Member
            -> Member-local source identity
            -> Member-local runtime Entity identity
            -> Runtime geometry and live pose
```

Assembly discovery uses protected attachment evidence and preserves each member's asset, root and attachment relationship. It does not infer collision membership.

### Attached-Assembly Replication

S 416 + Tiger 8 MT and 8RX 410 + TopDown 600 produced the same two-member structural classification despite different manufacturers, mappings, component counts and hierarchy sizes. This supports the architecture while leaving additional vehicle classes for later validation.

### Working-State Motion Divergence

GIANTS' declared `WORKING` state is an observation, not proof of productive movement. In one attached fixture the state remained active while motion stayed effectively zero; the same equipment could cultivate manually. A second fixture sustained normal work. Situation Assessment must therefore keep declared AI state and demonstrated motion as separate evidence.

### Next gate: Member-Local Physical Resolution

Source collision metadata remains physical authority. Configuration remains current-inclusion authority. Runtime Entity identity remains geometry authority. The next prototype must connect these independently inside every current assembly member, reject aliases and retain unresolved current shapes explicitly. Exact resolution and fallback occupancy remain separate claims.

## Physical Representation Architecture (v4.6.16)

`PHYSICAL_REPRESENTATION_ARCHITECTURE.md` owns the detailed model. The architectural summary is:

```text
Job-start Physical Assembly
    -> Job-Scoped Representation Catalogue
        -> Representation Templates and Component Families
            -> current state and Pose Realisation
                -> heterogeneous plan-view representations
                    -> Structural and Realised Coverage Closure
                        -> Layered Occupancy Claims
```

Situation Assessment preserves exact and fallback layers with explicit validity and evidence. Convex Planar Envelope is accepted as an intermediate fallback; its anchor selection remains deferred. Coverage Closure may be enumerative, enclosing or hybrid. Partial relevant coverage yields Clearance Unresolved and removes only the scoped authority to claim all-clear.

Folded and working are the principal stable states. Deployment is stationary configuration motion governed by a Deployment Clearance Envelope before commitment. Deployment Sweep and steering-dependent Manoeuvre Sweep remain separate future problems.

No Physical Occupancy Envelope or control behaviour is implemented by this release.
