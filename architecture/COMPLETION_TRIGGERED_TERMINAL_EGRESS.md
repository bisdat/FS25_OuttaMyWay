# Completion-Triggered Terminal Egress — Investigation Boundary

## Purpose

Completion-Triggered Terminal Egress is a proposed post-Job Episode responsibility tracked by [Issue #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476). It may eventually place a finished Physical Assembly in TRANSIT and settle the complete assembly safely outside its original field. The accepted production baseline remains request-only. TEST 0.5.5.7 adds a separately opted-in, restricted experimental physical Control responsibility, not general settlement authority.

GIANTS retains native FIELDWORK termination and agronomic authority. OuttaMyWay must not independently audit whether agronomy is complete. A manually stopped, cancelled, replaced or otherwise non-successfully terminated job must not initiate completion-triggered relocation.

## Specification Jurisdiction — Native Job Completion Observation

**Jurisdiction ID:** `NATIVE_JOB_COMPLETION_OBSERVATION`  
**Primary Specification:** [Native Job Completion Observation](../spec/NATIVE_JOB_COMPLETION_OBSERVATION.md)

**Responsibility:** passively observe GIANTS' native FIELDWORK job-stop reason, preserving the native job and vehicle identity and distinguishing an `AIMessageSuccessFinishedJob` class from other or unresolved reasons. The stop-reason observation remains DIAGNOSTIC; an independently admitted Completion Transit consumer now requests only transport configuration on native successful FIELDWORK termination.

The native `MessageType.AI_JOB_STOPPED` message is a candidate observation boundary: GIANTS `AISystem:stopJobInternal` publishes the terminated job and its original `aiMessage` after native `job:stop`. Unlike vehicle `onAIJobFinished`, this boundary carries the termination reason.

**Success-class witness != proof of field agronomy completeness.** A positive class observation is a candidate semantic signal, not yet a validated completion admission contract. In particular, source-derived class identity alone must not be used to actuate a vehicle until natural completion, manual stop, OMW job replacement and native failure have been discriminated by GIANTS Reality.

## Non-regression and future decisions

This investigation must not alter active-worker paired or solo Hold & Relocate, Reactive Static Blocker Recovery, existing Control and handback, or Configuration. Physical movement, parking allocation and off-field settlement remain separate #476 decisions. Completion TRANSIT may request existing native transport commands without entering BWR Control.

A future physical responsibility needs its own positive and supersedable authority, original field identity, kinematic feasibility, complete-assembly settlement, and interruption contract. Diagnostic publication neither reserves parking nor implies authority.

## Specification Jurisdiction — Completion Transit

**Jurisdiction ID:** `COMPLETION_TRANSIT`  
**Primary Specification:** [Completion Transit](../spec/COMPLETION_TRANSIT.md)

An independently admitted and request-only capability consumes positive `AIMessageSuccessFinishedJob` evidence after GIANTS FIELDWORK stops. It uses an isolated instance of the current native TRANSIT mechanism and the existing native plan builder. It never moves an assembly or asserts readiness merely because commands were sent. **A TRANSIT request is sufficient to discharge this capability's responsibility; settlement assessment must not introduce a wait-for-fold, readiness check or capability-precondition gate.** Request exceptions can be logged as failures, but they do not turn into movement authorisation. Product disabling relinquishes request state without restoring WORKING configuration to finished equipment.

Completion TRANSIT was validated by CI and TS019 at TEST `0.5.4.2`, accepted in merged PR #480 and promoted to PATCH `0.5.5.0`. It currently uses the global product-enabled setting. A dedicated persisted player choice remains an open Issue #476 requirement for subsequent capability work, but is not a prerequisite to preserving the request-only TRANSIT baseline. Completion transit and blocked-first Hold & Relocate must never share control ownership or request caches. Later physical parking/relocation requires fresh architectural admission.


## Owner-accepted settlement geometry — Infield Alignment and Exterior Run-Out (11 October 2026)

**Status: architectural principle accepted for investigation; movement authority and real-world feasibility NOT validated.** The owner confirmed that a completed assembly may perform most of its alignment **inside its completed source field**, then cross the field boundary at a shallow angle and continue forward until fully outside and straight. This is a permitted *space to assess*, not an instruction to execute a particular manoeuvre or take control of GIANTS AI.

**Discovery: Settlement Corridor.** A prospective corridor must connect feasible approach/alignment space with an exterior longitudinal strip and a final stopped assembly footprint. It is described by three distinct envelopes:

1. **Approach Envelope:** the *entire articulated Physical Assembly's swept occupancy* while reaching and aligning with the edge, potentially including the interior of its completed source field. It must respect active workers, existing control/commitment, boundary constraints and physical obstacles. The source field being completed does not automatically release occupied or demanded space from other active workers.
2. **Run-Out Envelope:** a sufficiently long uninterrupted **forward** traversal after approach, allowing steering and articulation to settle. Some run-out can take place in the field, but the final continuation must reach an exterior stop with the complete assembly outside; a mere tractor-root crossing is insufficient.
3. **Terminal Envelope:** the complete stopped assembly, in TRANSIT configuration, aligned approximately parallel to the selected boundary and outside the source polygon, without entering a neighbouring productive field, blocking a road or contacting a physical obstruction.

**Two confirmed human-preferred Ground Truth fixtures:**
- Mindenerwald Field 77 **probe edge 9**, 230.97 m, shallow southern inter-field margin (approximately 3–10 m at locations): terminal occupancy may fit when parallel, yet an oblique manoeuvre may not. Assess infield pre-alignment and shallow entry, not an assumed exterior turning bay.
- Riverbend Springs displayed Farmland 2 / GIANTS Field 29 **probe edge 1**, 141.99 m, deep eastern roadside-bounded margin: oblique exterior alignment may be feasible, but the road constrains true outer usable depth. The apparent separation to displayed Field 3 is not all free settlement space.

**Architectural invariant:** **Terminal fit != approach feasibility != run-out feasibility.** No fixed minimum strip width or universal run-out length is selected here; both depend on the actual TRANSIT-configured assembly envelope and articulated swept path. A location that passes only a pointwise native navigation-cost query, farmland-access query or neighbouring-field distance check has not passed any of these three envelopes.

**Authority boundary:** Farm Spatial Context *observes* polygons, roads, parcels, obstacles and uncertainty. A future Settlement Assessment must determine corridor feasibility and report unresolved constraints. A separately admitted Movement Control would need safe authorisation, interruption/hand-back and validation under existing operations. This decision adds **no parking algorithm, no AI-job replacement, no steering commands and no right to displace an active worker** to the current TEST probe.

**Proposed evidence boundary:** [Exterior Margin Profile](EXTERIOR_MARGIN_PROFILE.md) describes the observed world-space strip along a nominated edge; assembly-specific Approach, Run-Out and Terminal assessment must evaluate it under current worker demand. This is **not** a new Control contract.

**Present evidence and next boundary test:** TEST `0.5.5.5` observed a **real two-member tractor assembly** and 73/144 hypothetical static polygon-compatible poses on Field 77 edge 9. TEST `0.5.5.6` extends that read-only diagnostic to a **continuous nominal straight-swept region** for each rigidly translated member rectangle: registered field-polygon obstacles may occur *between* otherwise compatible stationary poses. This is still **not an actual approach, steerable forward run-out, road/hedge clearance, terminal occupancy, or Control admission**. TRANSIT continues to be **requested without a completion check**. See the [Settlement Corridor Assessment contract](../spec/SETTLEMENT_CORRIDOR_ASSESSMENT.md).

**Next falsifiable question:** For either preferred edge, can an actual folded articulated assembly achieve an infield-aligned approach, a safe boundary crossing, an uninterrupted forward run-out, and full exterior terminal occupancy? Existing diagnostic samples **do not answer this**. Treat a narrow margin that fits the terminal footprint but not the swept approach as a legitimate reason to use infield alignment or reject the corridor; never reinterpret its pointwise 'unblocked' samples as proof of manoeuvrability.

## Specification Jurisdiction — Completion Settlement Control (TEST)

**Jurisdiction ID:** `COMPLETION_SETTLEMENT_CONTROL`  
**Primary Specification:** [Completion Settlement Control](../spec/COMPLETION_SETTLEMENT_CONTROL.md)

**Discovery — Completion Settlement Control.** The nominal straight-sweep of a real articulated assembly on the selected field edge has provided enough **bounded polygon-only longitudinal geometry** to justify a falsifiable *movement prototype*, without repeating the existing terrain/navigation/physics-margin observations. The explicit experimental assumption is that the selected route is driveable. This is a premise for GIANTS Reality to test, not established physical clearance.

The architectural responsibility differs from both Completion Transit and blocked-first Hold & Relocate. Following a genuinely successful native fieldwork stop and an accepted separate TRANSIT request, an explicitly authorised TEST coordinator may seek an infield approach, cross the boundary at a shallow angle, continue forward to straighten the entire assembly, and verify an off-field full-member terminal footprint. The world-space sample, the actual dynamic path, and terminal occupancy remain separate facts; a tractor root crossing alone is not success.

The first bounded prototype runs only on Mindenerwald registered Field 77 edge 9, with a distinct engineering consent flag in diagnostics.xml; `DIAGNOSTICS=true` by itself must never grant physical movement authority. It uses an independent instance of the native forward-steering mechanism, native directional speed limits (no artificial 8 km/h cap), finite leases, new-job/disable/other-Control/player-selection supersession and best-effort physical neutralisation. Native full-distance point steering is distinct from Hold & Relocate's legacy motor command. It must not gate on TRANSIT fold completion or restore a completed worker to productive WORKING configuration. Active-worker conflict avoidance and general road/hedge coverage are **not** proven by the route assumption; the prototype's bounded behaviour must be treated as an experiment, not an accepted off-field parking service.

**Authority Triad disposition for TEST 0.5.5.7:** Architecture establishes a separate experimental Control jurisdiction; Specification owns the exact three-leg admission/execution/interruption contract; source realises that contract without expanding production request-only defaults. Offline contracts challenge consent, lifecycle and module composition. A real GIANTS passage and full off-field settlement have not been observed.

### TS018 discovery — Stopped Terminal Settlement is a distinct fact

The 12 October TEST 0.5.5.7 TS018 video disproved successful physical stopping despite a valid all-member nominal polygon occupancy report. A **point-arrival witness** does not establish autonomous steering or a **stopped terminal**; a root can reach the registered corridor while GIANTS cruise continues to accelerate. Therefore Completion Settlement retains temporary Control beyond a waypoint's first arrival and must positively confirm low native speed, stable position and inactive cruise before releasing propulsion authority. The engine must not be left in ACTIVE cruise under a completed-job handback.

The source investigation also identified **Local Target Distance Destruction**: native `AIVehicleUtil.driveToPoint` interprets `tX,tZ` as local-space *point coordinates*, not merely a direction vector. The first TEST implementation normalised them, exaggerating curvature. TEST 0.5.5.8 corrects **only the Completion Settlement execution path**; previously field-tested Hold & Relocate remains unchanged to isolate the causal experiment. Native maximum cruise/motor speed replaces the arbitrary experimental 8 km/h cap.

The existing named **GIANTS Selection-Claimed Occupancy** observation adds a separate, positive Control interlock: current player-controlled selection supersedes experimental settlement actuation rather than producing a misleading “autonomous” result. Native steering, movement and Control context are measured independently. The hypothetical J-shaped infield approach is deferred until the corrected native point steering is observed. The original route geometry and the acknowledged polygon-only premise remain unchanged; successful CI alone cannot validate GIANTS road/hedge clearance, articulated J-turn feasibility or actual stopping.


## Owner-confirmed architecture refinement — Pose-Conditioned Terminal Settlement (12 October 2026)

**Status: owner-confirmed objective and manoeuvre preference; not yet an authorised or field-validated executable algorithm.** This section updates the earlier *longest straight run-out* premise and supersedes any suggestion that parking requires reaching an edge endpoint or traversing most of its length. The initial three-leg, forward-only route in TEST `0.5.5.8` remains an *unsuccessful implementation experiment*, not the governing geometry.

**Discovery — Terminal Parking Region, not a Terminal Point.** Completion settlement has a **set-valued objective**: park the *entire Physical Assembly*, in the available inter-field margin **between the completed source field's boundary and neighbouring field boundaries**, approximately parallel to the selected edge. **Any station along a suitable edge** satisfying physical clearance and stopped terminal occupancy is a valid outcome. The longitudinal extent of an edge is an *option set*, not a mandated travel distance. Success is the complete, stopped assembly's valid exterior occupancy; passing a predetermined station or consuming the nominal 202.83 m polygon sweep is not success. Registered-field polygon disjointness alone is an incomplete proxy for physical inter-field containment: actual margins, roads, ditches, hedges, obstacles and other worker demand remain relevant.

**Discovery — Pose-Conditioned Entry Manoeuvre.** Each completing worker is independently assessed at **its actual completion pose** (location, heading, full attached assembly). The entry manoeuvre is selected *then*, according to available manoeuvring space, attainable steering curvature and assembly configuration. Possible strategies include a forward J-shaped turn and a **short reverse followed by forward travel**; the owner prefers the latter when feasible, not extended reverse travel along the parking edge. The manoeuvre may differ between workers completing the same field, and a solution for the TS018 sprayer is not a universal solution for an articulated assembly. Reversing articulated equipment requires distinct stability/jackknifing and swept-envelope assessment; a short reverse is not automatically safe.

**Discovery — Minimum Sufficient Settlement.** Prefer a nearby *reachable and safe* segment rather than the farthest endpoint or the longest uninterrupted nominal sweep. Short steering guidance targets should establish a feasible entry heading and boundary-parallel approach without requiring a distant point behind the vehicle. They are intermediate guidance observations, **not forced stopping places**. Drive only as far as needed for the entire assembly to clear the source field, remain contained between field boundaries and achieve an acceptable stopped footprint. Real steering, articulation, vehicle-specific length and safe braking determine the sufficient distance; no universal literal or guarantee of the shortest geometric path is implied. A route cannot infer safety from a polygon-only straight sweep.

**Architectural composition:**
- **Terminal Parking Region** — candidate connected strips along a relevant boundary, admitting many valid longitudinal stop positions but only where complete-assembly fit and exclusion of neighbouring fields/obstacles is demonstrable.
- **Entry Manoeuvre** — feasible, pose-conditioned transition from job-completion pose to edge alignment, potentially including a *brief reverse then forward* or a forward J-turn.
- **Progressive Guidance** — short dynamically attainable target positions for GIANTS with continuity of motion; arrival at each steering target does not itself require physical stopping.
- **Stopped Terminal** — positively observed zero-motion/neutralised native cruise and full Physical Assembly occupying the parking region, not merely the root outside a polygon.

**Validation and governance:** The repeated TEST `0.5.5.8` failures established an admission-policy veto in one run and an *unreachable 199.5 m forward first point* in another. Neither disproves off-field parking nor validates a short reverse or J-turn. The proposed refinement changes the intended architecture but **does not itself authorise modification to TEST Control or approval of the unauthorised `0.5.5.8` player-Control interlock**, which the owner separately instructed to leave unchanged for now. Retain PR #482 draft and preserve completion TRANSIT's accepted request-only default until explicit subsequent build consent.

### TEST 0.5.5.9 implementation boundary — region-first progressive guidance

The new *engineering-only Field 77* implementation probes the owner-confirmed **Pose-Conditioned Terminal Settlement** objective without promoting it to general product capability. Current completion pose drives candidate selection, not longest nominal polygon sweep. For both directions along edge 9, finite short reverse/forward S-entry and forward J-entry manoeuvres are sampled and nominal complete-member rectangles screened against registered neighbouring field polygons. A successful terminal is any stopped, parallel, whole-member pose in a bounded edge exterior strip, with no minimum longitudinal traversal. A candidate is selected by shorter travel distance; it is only *polygon-compatible nominal evidence*, not a collision-free or steered-path certificate.

The native driver receives approximately 5-metre guidance targets. Same-direction targets retarget under one continuous leased Control; a reverse→forward direction change requires the existing verified physical stop before motor/cruise re-arming. The 8 km/h global cap remains absent; the prototype applies a **bounded target-horizon braking speed** derived from a tentative 1.5 m/s² deceleration and the next guidance distance, never exceeding native limits. The assumption is explicitly subject to GIANTS validation. Unexpected backward progress (>5 m along a guidance vector) and leaving the nominated edge-envelope interrupt the experimental Control. These are limited safety assertions, not a proof of physical obstacle clearance.

The previously introduced player-Control veto remains unchanged **only because the owner explicitly instructed it be left in place**, not because its earlier unauthorised introduction became legitimate. Tests begin with the single-member sprayer TS018; no articulated reverse or broad-map success is claimed. Prior validated Hold & Relocate calls and default completion TRANSIT remain unchanged. Draft PR #482 must stay unmerged until GIANTS validates autonomy and stopping.
