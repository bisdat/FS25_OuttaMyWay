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

### Member-Local Physical Resolution result

Prototype 13A connected declared source collision identities to coherent runtime Entities across Condor, Tiger 8 MT and TopDown 600. Source collision metadata remains physical authority, configuration remains current-inclusion authority and runtime Entity identity remains geometry and live-pose authority. Exact resolution and fallback occupancy remain separate claims.

Architectural prose uses **Resolution Path** for source-to-runtime candidate generation; `route` remains reserved for worker navigation. Historical implementation labels retain `route` for evidence traceability.

### Resolution-to-assessment boundary

```text
Resolution Claim Set
    -> Self-Describing Representation / Representation Passport
        -> Minimum Sufficient Defensible Portfolio
            -> Situation Assessment fitness judgement
                -> Operational Picture Knowledge
```

Situation Assessment judges assessment-relative staleness, horizon fitness and refresh need. It does not reconstruct discovery mechanics or issue Control. Prototype 13B automated Resolution Path discovery remains deferred pending representation-diverse disproof scenarios.

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

## Semantic Catalogue and Scope Overlay Boundary (canonical v4.6.23)

The reviewed base-game catalogue remains complete semantic evidence and does not become support, runtime or structural authority. `SCOPE_OVERLAY_ARCHITECTURE.md` owns the detailed overlay model.

```text
Raw Definition and Runtime Localisation Evidence
    -> Reviewed Semantic Profile
        -> Scope Overlay
            -> Control Eligibility Profile
            -> Operation Participation
            -> Assembly Relevance
            -> Obstacle Relevance
                -> targeted Structural Challenge and test selection
```

A Semantic Profile records primary family, primary role, secondary roles and capabilities. Catalogue membership does not imply support. The declared control capability baseline is the unmodified Giants base game, assessed at the Giants AI job-configuration level rather than from vehicle category or successful job admission.

The four Scope Overlay dimensions are independent contextual claims. Known control ineligibility becomes a downstream Control Exclusion Constraint while representation persists. Operation Participation is functional and temporal; Behavioural Assembly does not merely reproduce attachment hierarchy; Obstacle Relevance is relational and may arise from Future Space.

A persistent obstacle can create Denied Work Space, a Recurring Commitment Loop and a Completion Blocker even when each local diversion succeeds. This separates Local Resolution from Operational Resolution.

This preserves **Semantic Classification–Scope Separation**, **Control Eligibility–Representation Relevance Separation** and **Class as Context, Not Contract**. No runtime Scope Overlay or control behaviour is implemented by this release.


The TS005–TS010 calibration adds empirical boundaries without implementing the overlay:

- manual viability does not imply Job Admission;
- material-chain continuity does not imply Control Eligibility continuity;
- an admitted configuration may still fail an Agronomic State Gate;
- specialist self-propelled and attached-header assemblies are valid Operation subjects;
- Physical Assembly extent may change materially through configuration;
- an Offset Working Envelope may require Giants to displace the powered-vehicle trajectory.

The powered-vehicle trajectory, working-envelope trajectory and Physical Assembly envelope are therefore distinct architectural objects. Exact directional extents cannot be replaced by a centred half-width assumption.

Test evidence remains bound to its runtime baseline. Patch Impact Watch moves affected conclusions from Current or Version-bound to Revalidation candidate only when a relevant change intersects the claim.

## Prototype 14 active intervention boundary (v4.6.24 candidate)

TS011-A and TS011-B establish a repeatable Start-Order-Independent Conflict and an Evidence-Bounded Intervention Window for the Condor/Patriot fixture. The first active hypothesis is intentionally narrower than a complete traffic policy.

Prototype 14 consumes `ESTABLISHED` Conflict Confidence, selects the later-admitted worker and applies one native permission-gate HOLD while the earlier-admitted worker remains under Giants AI control.

The runtime boundary is exclusive:

```text
Observer + passive assessment evidence
        ↓
Prototype 14 one-worker HOLD
        ↓
return before legacy traffic / recovery / reservation / Decision paths
```

Conflict Cessation Is Not Conflict Resolution is an architectural release invariant. Predictor `CLEAR` cannot release the hold because TS011 showed that collision and stable blockage also remove closing motion. Prototype 14 records Safe Release Candidate evidence but does not execute release.

This candidate validates one Commitment and one execution mechanism only. General priority, automatic release, recovery, later repositioning and physical-clearance policy remain separate hypotheses.
## Automatic Encounter Admission boundary (validated in owner-declared canonical v4.6.33)

Prototype 18 separates **encounter admission** from candidate selection and Control. The bounded flow is:

```text
Observer facts + Prototype 01 kinematics
→ Admission Candidate
→ three-second evidence confirmation
→ Commitment Point
→ fixed Prototype 16 Unilateral Sidestep
```

For this fixture only, admission requires exactly two active workers uniquely resolving to Condor and Patriot; both straight, working, moving and unblocked; headings opposed by at least 150 degrees; positive closing; `tCPA` from 0 to 30 seconds; and `dCPA` no greater than 14 m. One Encounter Episode Latch permits one commitment per continuous worker episode.

Admission does not choose the Yield Entity, Progress Entity, escape side, movement distance or clearance policy. Condor, Patriot, the physical-right side and the 28 m / 12 m actuator remain fixed experimental authority. Prototype 17 physical and policy evidence remains Knowledge with `authority=false`.

TS018 empirically supported this boundary: one candidate was admitted after 3.09 seconds without console input, one fixed Commitment completed with `failure=nil`, and the episode latch prevented re-admission during later known Split-Start Pass Recovery. This is evidence for fixture-bounded admission only. It does not define production Encounter identity, repeated commitments or candidate selection.

## Unilateral Sidestep intervention boundary (v4.6.25 candidate)

TS012 separates actuator viability from solution viability. The native permission gate can preserve a held Giants job, but holding an assembly inside another worker's required path causes Static Obstacle Conversion.

Least intervention is therefore interpreted as **Minimum Necessary Authority**, not minimal force. OuttaMyWay may temporarily own a Bounded Route Deviation while Giants continues to own the job, agronomic objective and nominal coverage strategy.

The first authorised deviation family is Unilateral Sidestep:

```text
Giants Progress Entity continues unchanged
Yield Entity: hold → compact → move outward → wait → rejoin → restore → Giants handback
```

The complete Yield Assembly swept envelope must remain outside the Protected Progress Corridor. Prototype 15 implements only a vehicle-centre negative control and explicitly does not claim complete geometry compliance.

Coverage-Strategy Agnosticism remains mandatory. Route Reassertion is observed after handback rather than predicted from an assumed whole-field route.

## Retreating Unilateral Sidestep refinement (v4.6.26 candidate)

TS013 supports Bounded Route Deviation and Forward Route Reacquisition for the exact Condor fixture. The preferred departure is now rearward and outward from the confirmed stopped pose, followed by a slightly forward centreline rejoin.

Least intervention remains **Minimum Necessary Authority**, not minimum force. Speeds should remain assembly-dependent and start from the assembly's Native Motion Envelope.

Full Compact Configuration and Egress-Ready Configuration are separate. Folding and Retreat Overlap may reduce stationary latency, but any production egress trigger must be based on live complete-assembly swept-envelope compatibility with the Protected Progress Corridor. The TS014 `foldAnimTime=0.15` threshold is diagnostic and grants no such authority.

A future Egress Protection Hold may temporarily stop the Progress Entity while the Yield Entity executes a defined escape. This does not revise the current candidate, which remains exactly-one-worker. The standing invariant is refined conceptually from “never hold all” to “never leave all participants under unresolved passive holds”; any simultaneous stop requires an active escape commitment and predetermined release order.


## Cooperative passage experiment boundary — v4.6.28

Prototype 16 keeps architectural ownership explicit:

```text
GIANTS owns Patriot route and job
OuttaMyWay owns Condor's bounded deviation
Situation Assessment observes pair geometry and passage evidence
Control may rejoin Condor only after positive passage evidence
```

TS015-A showed that the validated Yield manoeuvre can complete in time while still failing physical passage. The 22 m command produced approximately 21.44 m lateral refuge, and Patriot's centre moved beyond Condor's stop anchor before its deployed assembly became blocked. This establishes Vehicle-Centre Passage Is Not Assembly Passage and a fixture-specific Clearance Budget Underrun.

TS015-B changes only the lateral refuge to 28 m. Patriot remains unheld so the test isolates clearance depth from egress timing and Progress control. Egress Protection Hold remains a separate future response for encounters where the Progress Entity would consume the egress interval.

Passage is a positive complete-assembly spatial conclusion, not merely predictor state or centre progression. Production displacement must eventually derive from complete assembly extents, configuration and steering sweep, alignment uncertainty and bounded margin.

Direction commitments must ultimately be world-space refuge regions. Human left/right labels and vehicle-local axis names cannot own Decision-to-Motion Direction Integrity.
## Shadow clearance architecture — v4.6.29

TS015-B established a successful fixture movement but not a general displacement rule. Prototype 17 therefore protects the actuator and observes a derived clearance requirement without granting authority.

Required reference separation is modelled as opposing Facing Clearance Extents plus explicit uncertainty and policy margins. Progress extent is measured toward the refuge; compact Yield extent is measured back toward the Protected Progress Corridor. Whole vehicle length is used only through pose projection when it contributes to that one-sided extent.

Clearance belongs to a Refuge Pose, not merely a target point. An angled compact assembly can project materially more length into the lateral axis than a parallel assembly. Pre-manoeuvre prediction and live refuge measurement are therefore separate evidence stages.

The staged authority boundary is:

```text
fixed role + fixed side + fixed 28 m Control
→ shadow-derived requirement
→ empirical comparison
→ later candidate-role/side shadow selection
→ only then possible automatic Commitment
```

The later headland convergence after successful handback confirms that Encounter identity is tied to current Future-Space convergence rather than entity-pair identity. Situation Assessment continues after each retired Encounter.
## Facing Extent Provider and clearance evidence layers

Shadow clearance assessment requires one-sided extents in a shared reference frame. Physical Representation may hold richer or incomplete evidence, so a dedicated Facing Extent Provider adapts that evidence to the assessment question without granting authority. Its output is Knowledge: extent, axis, reference, source, coverage, confidence and unresolved allowance. Decision remains responsible for selecting a candidate commitment; Control remains responsible for execution.

A missing operand produces no clearance result. Implementation convenience must not replace Clearance Calculation Closure with a hidden hard-coded distance.

TS017-B established fixture-bounded Closure for Condor/Patriot. Patriot supplied 18.00 m from its live 36 m AI working marker. All 13 current Condor physical identities and origins resolved, but none supplied usable runtime bounds through the tested APIs. The lower-confidence provider therefore projected 4.87 m from live origins and added a separately declared 2.50 m unresolved physical allowance, producing a 7.37 m compact Facing Clearance Extent.

This establishes **Origin Coverage Is Not Bound Coverage**: complete identity/origin resolution does not imply that physical shape bounds are available or that Coverage Closure exists.

Clearance evidence has two distinct layers:

```text
physical contact threshold
= Progress Facing Clearance Extent
+ Yield Facing Clearance Extent

physical clearance reserve
= achieved reference separation
- physical contact threshold

policy required separation
= physical contact threshold
+ explicit policy-margin budget

policy reserve
= achieved reference separation
- policy required separation
```

For the TS017-B fixture, the physical threshold was 25.37 m. The successful 27.38 m passage therefore had approximately +2.01 m physical reserve. Applying the provisional 3.75 m combined margin budget produced a 29.12 m policy target and approximately -1.74 m policy reserve.

This establishes **Physical Clearance Is Not Policy Clearance**. Physical passage evidence and a chosen clearance policy must not be collapsed into one value. Neither layer currently grants Decision or Control authority.

