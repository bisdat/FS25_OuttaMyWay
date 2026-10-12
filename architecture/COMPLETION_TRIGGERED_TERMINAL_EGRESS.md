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

The first bounded prototype runs only on Mindenerwald registered Field 77 edge 9, with a distinct engineering consent flag in diagnostics.xml; `DIAGNOSTICS=true` by itself must never grant physical movement authority. It uses an independent instance of the already working native forward-steering mechanism, 8 km/h command cap, finite leases, new-job/disable/other-Control supersession and best-effort physical neutralisation. It must not gate on TRANSIT fold completion or restore a completed worker to productive WORKING configuration. Active-worker conflict avoidance and general road/hedge coverage are **not** proven by the route assumption; the prototype's bounded behaviour must be treated as an experiment, not an accepted off-field parking service.

**Authority Triad disposition for TEST 0.5.5.7:** Architecture establishes a separate experimental Control jurisdiction; Specification owns the exact three-leg admission/execution/interruption contract; source realises that contract without expanding production request-only defaults. Offline contracts challenge consent, lifecycle and module composition. A real GIANTS passage and full off-field settlement have not been observed.
