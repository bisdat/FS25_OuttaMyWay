## v4.7.127 D-0147 normative amendment — Courtesy Constraint Exception

**Decision:** D-0147 is a deliberately exceptional, player-consented courtesy capability. Its only objective is to buy useful time while a genuinely completed assembly remains **Pending Player Reclamation**. It is not a general autonomous manoeuvre planner and is not responsible for proving final settlement.

### D-0147 Courtesy Constraint Exception
For a D-0147 **Bounded Infield Retreat**, the generic physical Candidate requirements `FIELD_WORLD_CONTAINMENT` and `TRANSITION_CLEARANCE` are **not applicable as predictive proof obligations**. The fixed one-shot Field World centroid bearing is a crude directional heuristic; the representation does not prove the complete swept assembly stays within the polygon or clears every third-party assembly. The Candidate must therefore record an explicit exception, not synthetic PASS evidence.

This exception is narrowly scoped to player-consented bounded buy-time movement. It does **not** relax: Terminal Yield Consent; genuine Pending Player Reclamation state; positive current obstruction/admission; POST_JOB/PROGRESS authority ownership; Protected Yield of the authorising productive worker; Player Claim and source-reactivation supersession; bounded movement/Courtesy Exhaustion; Continuation Renewal before repetition; or mandatory Actuation Neutralisation before authority release.

### Three-Assembly Courtesy Continuation Validation
v4.7.126 provided the first fully completed three-vehicle OuttaMyWay test in the current theatre. Patriot and Condor each executed a decisive 60 m, native-maximum-speed, one-shot-centroid Bounded Infield Retreat under Protected Yield. S416 then completed its remaining work. This strongly validates the crude courtesy mechanism **for the tested Patriot + Condor + S416 configuration only**; it is not universal clearance proof for other assemblies or field geometries.

**Architectural consequence:** the earlier **Courtesy Evidence Gap** is resolved by explicit special-case architecture, not by adding swept-path prediction, exclusion zones or parking search. Normal physical Candidates retain their mandatory positive containment/clearance contracts.

---

## v4.7.126 D-0147 calibration — decisive crude courtesy retreat

D-0147 remains optional **buy-time** behaviour for a completed assembly Pending Player Reclamation. v4.7.125 showed that a 30 m quantum may restore continuation yet leave the assembly close enough to be encountered again soon. Speed alone cannot change that stopping geometry.

The current TEST calibration therefore grants one admitted Bounded Infield Retreat **60 m of realised progress toward the fixed one-shot centroid bearing** and removes the artificial 8 km/h retreat ceiling in favour of the completed vehicle's native maximum forward speed. This is intentionally simple calibration, not a clearance envelope or settlement proof.

All governing boundaries remain unchanged: the productive worker is protected during translation; the bearing is sampled once with no centre pursuit; repetition still requires Continuation Renewal plus a later attributed native block; Courtesy Exhaustion escalates near the centre; no exclusion map, route planner or permanent parking concept is introduced.

## v4.7.125 D-0147 refinement — Continuation Renewal

D-0147 remains optional courtesy behaviour for a completed assembly **Pending Player Reclamation**. One Bounded Infield Retreat need only buy useful productive time; it is not required to create a future-safe settlement.

**Continuation Renewal:** after an admitted retreat finishes and Protected Yield releases the authorising productive worker, that worker must positively demonstrate GIANTS-owned physical progression before another courtesy retreat can become possible. Represented conflict disappearance is not required.

**Repeat admission:** renewal does not itself move the completed assembly. A later Bounded Infield Retreat requires a subsequent native `blocked=true` state that remains positively attributed by Terminal Occupancy to that same completed assembly. Conservative Future Space remaining continuously positive therefore cannot chain repeated 30 m moves while productive work is still continuing.

This preserves **Continuity, Not Settlement**: one retreat succeeds locally when useful continuation resumes; a later real block is a new courtesy opportunity. 8 km/h, 30 m inward progress, fixed one-shot centroid bearing, Protected Yield and Courtesy Exhaustion remain implementation calibrations/policies rather than permanent-clearance claims.

## v4.7.124 D-0147 correction — Protected Yield Traversal Defect

**Observed reality:** v4.7.123 reproduced v4.7.122 because Protected Yield was never applied. The authorising productive assembly was correctly carried through the Commitment, but Dispatcher attempted to traverse sealed `protectedDemandAssemblies` using native Lua `#`/`ipairs`. GIANTS proxy-table traversal returned no entries.

**Architectural effect:** none. Protected Yield Interval remains the agreed sequencing concept. This is an implementation-boundary defect, not evidence against the architecture. The canonical ValueRecord traversal contract is reaffirmed as a standing engineering rule for all sealed architecture collections.

## v4.7.123 D-0147 refinement — Protected Yield Interval

**Discovery from v4.7.122 TS016:** the Bounded Infield Retreat geometry/control hypothesis is supported; Patriot realised the intended large forward arc and fixed alignment. A genuine collision followed because S416 remained productively mobile while Patriot crossed its evolving space. Treating this as an 8 km/h calibration problem would tune one rendezvous rather than resolve the concurrent-authority relationship.

**Protected Yield Interval:** once a positive Terminal Occupancy conflict has admitted a Bounded Infield Retreat and translation is about to begin, the productive assembly/assemblies whose conflict authorised that retreat are temporarily held while retaining their GIANTS job/route. The hold lasts only for the terminal assembly's translational Yield Quantum and ends after terminal Actuation Neutralisation. This is sequencing authority, not route prediction, collision prediction or permanent priority.

The interval does not alter D-0147's courtesy nature: 8 km/h, 30 m inward progress, one-shot Infield Alignment, Conflict Renewal and Courtesy Exhaustion remain test calibrations/behaviour. No demand exclusion zone or path planner is introduced.

## v4.7.122 D-0147 refinement — Bounded Infield Retreat as optional courtesy

**Baseline:** owner-declared v4.7.121 canonical. D-0147 is an optional, player-consented convenience whose purpose is only to **buy time** before the player manually reclaims completed AI workers. Precision parking is not an objective; deliberately crude, bounded behaviour is acceptable when it preserves the authority boundaries below.

### 0V.1 Bounded Infield Retreat
After positive Terminal Occupancy admission and supported compaction, the preferred current implementation hypothesis is one **Bounded Infield Retreat**. The completed assembly samples the immutable source Field World centroid once, derives one fixed **Infield Alignment**, then uses forward-only post-job actuation to acquire that world direction naturally and continue inward for one bounded movement allowance.

The Field World centroid is a **directional reference, not a destination or refuge**. The alignment is sampled once after compaction. There is no continuous centre pursuit, no mid-manoeuvre course correction, no waypoint route and no future productive-demand exclusion map.

### 0V.2 Courtesy Exhaustion
Repeated retreats are permitted only after **Conflict Renewal**: the prior positive conflict must first disappear, after which a later positive conflict may authorise another independent bounded retreat. When the completed assembly is already broadly central such that the configured retreat allowance would consume the remaining centre distance, D-0147 reaches **Courtesy Exhaustion** and escalates to the player rather than inventing another destination. The number of retreats is therefore field/pose dependent rather than a move-count policy.

### 0V.3 Simplicity boundary
D-0147 does not model S416's later passes, reserve productive exclusion zones, allocate terminal parking slots, shuffle unrelated completed assemblies, or guarantee that a yielded assembly will never obstruct again. Other represented assemblies remain hard constraints. External Yield remains architecturally possible only when its substantially stronger clearance, adjacent-field-exclusion and margin-traversability proof obligations can be closed; v4.7.122 does not attempt that proof.

**Current analytical envelope:** reason about one completed assembly, one continuing productive assembly, and at most one other materially relevant assembly. This is a working scope hypothesis motivated by complementary agronomic work, not a hard maximum vehicle count; a future agronomic concurrency matrix and wider assembly testing may revise it.

---

## v4.7.121 D-0147 normative refinement — Terminal Yield while Pending Player Reclamation

**Status:** canonical-candidate architecture; owner-declared v4.7.112 remains canonical until explicit promotion.
**Evidence basis:** TS016 v4.7.120 live result, subsequent log/video review, player-described normal gameplay, and debug-physics-overlay review.
**Implementation boundary:** v4.7.120 external-egress mechanics are retained as one live-supported expression. Repeated/infield Terminal Yield is not implemented by this candidate.

### 0U.1 Pending Player Reclamation
A genuinely completed worker whose Job Episode has ended enters **Pending Player Reclamation** until the player claims/tidies it, all relevant active demand ends, or responsibility is otherwise explicitly transferred. This is not a resurrected productive Job Episode and does not create an OuttaMyWay parking obligation. The normal gameplay expectation is that the player eventually returns to completed workers.

GIANTS Completion Acceptance remains the default. A harmless completed assembly remains where GIANTS left it. OuttaMyWay acts only after positive current Terminal Occupancy evidence establishes that the passive completed assembly materially prevents useful active continuation.

### 0U.2 Terminal Yield Consent
Automatic movement of a completed assembly is an explicitly imperfect assistance feature and requires **Terminal Yield Consent**. Consent authorises bounded best-effort yielding; it does not authorise arbitrary relocation, parking search, another-field occupation, or indefinite autonomous housekeeping.

The current implementation switch `AUTOMATIC_TERMINAL_EGRESS` is retained temporarily as a legacy implementation name and remains `true` for development testing. For a player-facing release, automatic Terminal Yield is explicit opt-in/default-off. Renaming the switch is deferred until implementation is changed to express the broader policy.

### 0U.3 Continuity, Not Settlement
**Continuity, Not Settlement** is the governing objective. D-0147 exists to buy time for the player by restoring useful active-worker continuation, not to prove that the completed vehicle has found a universally safe final position.

Positive Field-Exit Settlement remains valid evidence that one external-egress manoeuvre has physically left the source Field World; it is no longer sufficient architectural proof that Terminal Occupancy can never matter again. GIANTS' later conservative collision decision and future active demand may legitimately differ from physical field-exit evidence.

### 0U.4 Reactive Terminal Yield
A **Reactive Terminal Yield** is admitted only from a positive current conflict involving a completed passive occupant and useful active demand. The selected yield is bounded to resolving that admitted conflict. Once continuation is positively restored, the completed vehicle becomes passive again and remains Pending Player Reclamation.

If a later distinct positive conflict develops before player reclamation, the same completed assembly may receive another bounded Terminal Yield. This repeatability is evidence-driven, not timer-driven and not speculative future parking. No relocation occurs solely because a future conflict seems possible.

### 0U.5 No Final Settlement Requirement
There is **No Final Settlement Requirement** while the Operation still contains useful active demand. D-0147 does not need to identify permanent released space, a Terminal Clearance Region or a correct parking location. Repeated yield is legitimate only while each move is justified by a new/current admitted obstruction.

The historical **Terminal Resolution Commitment** is therefore refined: after one current conflict admits a yield, responsibility remains sticky through the bounded actuation needed to resolve that admitted conflict or reach a higher-authority terminal outcome. It does not create an obligation to discover permanent settlement after current productive continuation has been restored.

### 0U.6 Clearance Authority Conflict
TS016 v4.7.120 established that Positive Field-Exit Settlement and GIANTS native continuation clearance can disagree. Later S 416 turning became natively blocked even though Patriot was physically separate and already outside Field 77. This is **Clearance Authority Conflict**: GIANTS' conservative runtime collision envelope is authoritative for what GIANTS will currently do, but it is not by itself authority for OuttaMyWay to consume unlimited external space.

OuttaMyWay must not convert a conservative native clearance request into an unbounded relocation policy. If satisfying GIANTS by moving farther would create an equal or worse spatial conflict, autonomous external clearance is exhausted as a legitimate solution.

### 0U.7 Egress Externality Constraint
**Egress Externality Constraint:** a Terminal Yield must not solve the source Operation merely by exporting comparable occupancy/demand into another Field World or otherwise illegitimate external space. The immediate margin can be consumed only while that occupation remains a bounded acceptable externality. Another usable/active Field World is not free space merely because it lies outside the source polygon.

This constraint supersedes any interpretation that Terminal Egress should continue outward until GIANTS' native collision handler is satisfied.

### 0U.8 External and infield yield expressions
**External Yield:** the v4.7.120 compact → Vehicle Activity Context → acquire/hold Exit Alignment → positive source-Field exit → neutralise mechanism remains a valid physical expression when external displacement is legitimate and sufficient for the current conflict. It is a capability, not the universal settlement policy.

**Conflict-Relative Infield Yield:** where external egress is inappropriate or would violate Egress Externality Constraint, architecture permits a bounded move within the source Field World away from the current admitted conflict. The field centre is not a destination. True randomness is not conflict authority and is rejected as the primary anti-collision mechanism. Other represented physical assemblies constrain candidate support. If materially equivalent alternatives remain, stable assembly identity may provide deterministic dispersion/tie-breaking.

Infield movement does not claim the destination is permanently safe. It stops when the current active continuation is positively restored, after which the completed assembly becomes passive again.

### 0U.9 Player escalation is normal gameplay
If no bounded legitimate Terminal Yield can restore continuation without unacceptable externality, repeated thrashing, unsafe physical conflict or architecture expansion into parking/routing search, responsibility escalates to the player. This is not feature failure. The player's normal return to completed workers is the terminal housekeeping authority.

Player Claim remains immediate and sticky for the Terminal Occupancy episode. No arbitrary timeout or maximum-move count is introduced; the natural lifecycle is completion → Pending Player Reclamation → zero or more positively admitted bounded yields → Player Claim / active-demand end / justified Player Escalation.

### 0U.10 Complexity boundary
D-0147 does not authorise global parking optimisation, field-centre parking, random wandering, continuous refuge discovery, another-field parking, permanent released-space inference or proactive relocation. Architecture discovers only enough current spatial response to restore useful continuation. Reality remains final authority.

---

## v4.7.115 D-0147 reality refinement — Oblique Boundary Egress

**Status:** accepted architectural refinement from TS016 v4.7.114 live evidence; owner-declared v4.7.112 remains canonical until the user canonically promotes a later build.

### 0T.1 Terminal Resolution Commitment — retained
Positive Terminal Occupancy admission commits the completed assembly to the full bounded resolution. Supported compaction completes first; transient disappearance of the initiating obstruction does not cancel the obligation.

### 0T.2 Outward Reference
The selected local outer Field Boundary establishes which side is outside. Its normal is an **outward reference**, not a commanded vehicle trajectory and not a parking orientation.

### 0T.3 Exit Alignment
A wheeled assembly's realised compact heading participates in the egress expression. Candidate derives one deterministic forward/outward alignment from compact heading plus the local outward reference. Where the assembly is approximately parallel to the edge this should be oblique rather than an immediate 90-degree steering demand. Where current heading is already materially outward-facing, continuing substantially straight is valid. No fixed 45-degree architectural literal exists.

### 0T.4 Oblique Boundary Egress
The resulting lead-in/steering arc/boundary crossing is one continuous bounded manoeuvre with one purpose: complete removal of the assembly from Field World demand. It is not a sequence of relocation decisions. It may initially continue forward or consume a small amount of infield space solely as part of the same continuous crossing.

### 0T.5 Positive Field-Exit Settlement
Success requires positive evidence that the realised compact assembly is wholly outside the Field World. The egress phase already depends on positive compaction completion, so settlement does not require an independent second fold-state qualification. A represented footprint wholly beyond Field World bounds is sufficient positive evidence; represented primitive/polygon evidence may establish the same fact where bounds overlap.

### 0T.6 Complexity boundary
Exactly one deterministic oblique manoeuvre is authorised. No alternate angle, alternate boundary, gap search, reverse rescue, repeated attempt, field-centre move, margin traversal model, post-exit alignment or parking search follows failure. Unsupported or failed egress becomes **Terminal Egress Exhaustion** and Player Escalation.

---

## v4.7.114 D-0147 Terminal Resolution Commitment refinement — normative candidate precedence

**Status:** accepted live-evidence refinement for v4.7.114 TEST; owner-declared v4.7.112 remains canonical.  
**Canonical baseline:** owner-declared canonical v4.7.112 (`f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`; Git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`; 310 files).  
**Decision:** D-0147, refined by TS015/TS016 live evidence on 2026-08-18.  
**Implementation boundary:** bounded production attempt only. Disposable v4.7.110/v4.7.111 probes remain evidence, not production donors or release lineage.

D-0147 refines the historical GIANTS Completion Acceptance Boundary without replacing its default. A completed worker remains where GIANTS finishes it unless its realised physical occupancy later becomes materially obstructive to continuing active demand and the user has enabled Automatic Terminal Egress.

### 0T.1 Terminal Occupancy trigger, not post-job housekeeping

Job completion does not itself authorise movement. A completed assembly may remain exactly where GIANTS left it indefinitely while harmless.

A **Terminal Egress obligation** may arise only when positive current Situation evidence establishes that the completed assembly's realised **Terminal Occupancy** materially obstructs Committed Demand, Potential Demand or another positively supported immediate continuation requirement of an active worker.

Multiple completed assemblies remain independent Terminal Occupancy subjects. A three-worker Operation does not create a global parking problem: each completed assembly is considered only if and when its own realised occupancy becomes obstructive.

D-0147 does not infer a correct parking place and does not attempt to tidy finished workers away pre-emptively.

### 0T.2 Mandatory supported compaction before translation

Once Terminal Egress is admitted, the completed assembly first enters its **minimum positively supported transit configuration** where a meaningful footprint-reducing configuration exists.

This stage is explicit because a smaller configuration:

- reduces the footprint presented during the egress manoeuvre;
- reduces, but does not eliminate, exposure to terrain/static-object contact during boundary crossing;
- provides the realised compact footprint used for positive Field World exit settlement.

An assembly already effectively compact, or one with no meaningful supported configuration reduction, satisfies this stage without synthetic fold actuation. Fold-interface presence alone is not Compact Configuration authority.

**TS015/TS016 refinement — Terminal Resolution Commitment:** once positive Terminal Occupancy evidence has crossed the intervention threshold and admitted D-0147, disappearance of the initiating obstruction does not dissolve the obligation during or after compaction. Compaction is preparation for decisive egress, not a terminal resolution under the current evidence model. This prevents a temporarily clear revealed trajectory from masking later continuing demand through the same completion position.

### 0T.3 Boundary-Normal Egress Objective

After supported compaction, the egress objective is **outward displacement toward the locally nearest Field Boundary**, sufficient to remove the realised compact assembly from the Field World. The initiating obstruction need not remain visible once Terminal Resolution Commitment has been admitted.

The objective is boundary-relative, not vehicle-forward. A completed assembly parallel and close to a field edge may therefore require a primarily lateral displacement relative to its current heading. Architecture does not prescribe forward, reverse or a steering law; implementation may use whichever single simple supported control expression can realise the outward objective.

The Field Boundary establishes where outward is. It does **not** prove that the immediate extra-field margin is traversable, obstacle-free or generally safe.

### 0T.4 One simple bounded manoeuvre; no King-like search

A **Bounded Terminal Egress** has one purpose, one outward objective and at most one simple continuous bounded translational manoeuvre after compaction.

It does not authorise:

- local Refuge/King discovery or continuous escape-space maintenance;
- selection of a best Terminal Clearance Region or parking place;
- field-centre relocation;
- navigation across the field to a different boundary;
- alternate-boundary search after failure;
- multi-leg lateral/rearward/forward choreography;
- repeated progressively clever attempts;
- global coordination of completed assemblies.

If the one supported outward manoeuvre cannot be established or cannot achieve sufficient clearance within its bounded authority, **Terminal Egress Exhaustion** is reached. Exhaustion transfers the unresolved physical responsibility to the player; it does not reopen a broader search space.

This boundary is deliberate protection against reintroducing the retired King/continuous Refuge architecture under a different name.


### 0T.4a Positive Field-Exit Settlement

The Candidate-supplied target is a bounded guidance target, not itself proof of success. A Terminal Egress succeeds only when the current realised compact represented footprint is positively clear of the Field World across the selected outer boundary.

Control therefore may stop early when positive represented Field World exit is established. If the one supplied guidance target is reached while any positively represented compact primitive still lies inside or intersects the Field World, the manoeuvre reaches **Terminal Egress Exhaustion**. It does not extend the target, select another boundary, or begin a second attempt.

Transient disappearance of the original active-demand conflict is not a settlement witness after admission. Player Claim, authoritative source-intent supersession, positive represented Field World exit, or bounded failure/exhaustion are the valid terminal outcomes.

### 0T.5 Post-Job Actuation Authority — empirically supported capability

Disposable v4.7.110 evidence established that a genuinely completed assembly can be translated through the GIANTS vehicle-driving primitive while its original Job Episode remains authoritatively ended and without starting/restarting a GIANTS AI job. A bounded 5 m / 3 km/h proof completed and stopped cleanly with the original episode still `ENDED`.

This establishes **Post-Job Actuation Authority** as a mechanically available capability. It does not by itself authorise production use; D-0147 supplies the narrow semantic purpose for which future implementation may request that capability.

Productive completion remains completion. Terminal Egress is physical occupancy resolution, not resurrection of productive intent.

### 0T.6 Player Claim is absolute and sticky

**Player Claim** occurs when positive evidence establishes that the player has entered the completed assembly.

Disposable v4.7.110 R4 evidence validated `vehicle:getIsEntered()` as a direct mechanical witness: the claim transition occurred with 204 direct drive calls and the probe ended with the same count, demonstrating zero further OuttaMyWay drive calls after claim.

Architecturally:

- OuttaMyWay never acquires or retains Terminal Egress actuation authority over a player-entered assembly;
- Player Claim immediately terminates any active Post-Job Actuation Authority;
- responsibility transfers to the player for that Terminal Occupancy episode;
- leaving the vehicle again does not permit OuttaMyWay to reacquire that same completed-assembly obligation.

Player Claim is an authority boundary, not one condition inside a scenario-specific decision tree.

### 0T.7 Automatic Terminal Egress is user-configurable

Automatic Terminal Egress must be exposed as a user-configurable policy switch.

- **Off:** preserve the historical GIANTS Completion Acceptance behaviour exactly; completed assemblies remain where GIANTS leaves them and relocation is the player's responsibility.
- **On:** permit D-0147's narrow exception when an unclaimed completed assembly positively obstructs continuing active demand and one Bounded Terminal Egress is supportable.

The eventual default value is a product/validation decision and is not selected by this architecture candidate.

### 0T.8 Zero-Configuration Compatibility and optional declared work intent

Terminal Egress must remain safe for the ordinary GIANTS workflow in which the player simply starts the worker without visiting AI job-parameter screens.

Disposable v4.7.111 evidence showed that `getAIModeFieldCourseSettings()` can expose useful positive settings such as `workHeadlands` and `headlandsFirst` after GIANTS materialises a `FieldCourseSettings` object, but a normally started default job may keep that object unavailable throughout observation.

Therefore:

- available `workHeadlands` may positively describe the declared productive phase set;
- available `headlandsFirst` may positively describe phase ordering when headland work is enabled;
- absent settings mean **unknown**, never assumed defaults;
- these settings may enrich demand understanding but are never prerequisites for Terminal Egress admission or safety.

This is **Zero-Configuration Compatibility**: OuttaMyWay must not require optional player ceremony to remain safe.

### 0T.9 Relationship to D-0041 and implementation freeze

D-0041 remains authoritative for ordinary job completion: accept GIANTS' realised completion disposition and do not infer a parking destination. D-0147 refines only the exceptional case where that realised occupancy later obstructs continuing active demand.

v4.7.114 TEST is a bounded production implementation attempt against this refined contract. Reality remains final authority; any pressure to add alternate boundaries, repeated target extension, exhaustive margin qualification or route planning is evidence for Terminal Egress Exhaustion/player ownership rather than architectural expansion.

---

## v4.7.99 Trajectory-Based Opposed Corridor Passage — normative candidate precedence

**Status:** accepted architecture for owner canonical review; implementation intentionally remains bounded v4.7.98 behaviour.  
**Canonical baseline:** owner-declared canonical v4.7.98 (`105462f44b902312e5dc63c6176d44f848f15c1466d942a4bee70635ced6cd69`; Git `982992b926839c854f6d4d7979fe24885e267eae`; 307 files).  
**Decision:** D-0146.  
**Implementation boundary:** architecture-only canonicalisation; no generic D-0146 motion/control implementation is introduced here.

D-0146 refines D-0144 Progressive Situational Sufficiency by replacing solution-shaped opposed/head-on admission with direct trajectory-and-demand reasoning. D-0143 remains the live bounded Cooperative Passage implementation authority where not superseded, and D-0141 remains the live follower-Regulation authority.

### 0.1 Two-step responsibility boundary

**Step 1 — Categorise opposed:** determine what spatial relationship exists between participants. It must not decide how they will pass.  
**Step 2 — Perform passage:** given an Established Opposed Corridor Conflict, determine a supported local passage. It must not redefine whether the conflict exists.

This separation is normative. Vehicle configuration, released space, Passage Guides and manoeuvre construction belong to Step 2, not Step 1.

### 0.2 Established Trajectory, Current Motion and Trajectory Persistence

**Established Trajectory** is the coherent direction/corridor demonstrated by an assembly over meaningful recent physical movement.  
**Current Motion** is what the assembly is doing now.  
**Current Excursion** is a temporary disagreement between Current Motion and Established Trajectory.  
**Trajectory Persistence** means coherent prior motion resists being erased by short-lived excursions, while sustained coherent travel on a materially different axis progressively supersedes the old Established Trajectory.

This is temporal Situation Knowledge, not future-route prediction. Past motion has persistence against transients but does not overrule sustained contradictory Reality.

GIANTS Productive/Transitional/TURN_SEGMENT state is contextual evidence about trajectory reliability; it is not a binary gate deciding whether an opposed spatial conflict can exist. Turning Rank remains optional spatial context for Observation/Regulation, never native-turn prediction.

### 0.3 Opposed Corridor Conflict

**Observed Trajectory Corridor** is the spatial band implied by an Established Trajectory, expanded by current assembly occupancy and bounded observational uncertainty.

**Supported Corridor Overlap** exists when positively supported trajectory-demand corridors intersect. **Any positive overlap is overlap.** Overlap magnitude does not decide Step-1 admission and must not be converted into an architectural percentage/metre threshold.

Where only uncertainty margins overlap, Step 1 must not assert positive intersection; failure to prove separation supports caution/Potential conflict, not an Established conflict.

Pairwise Step-1 outcomes are:

- **No Opposed Conflict** — evidence positively supports no relevant opposed corridor conflict.
- **Potential Opposed Corridor Conflict** — persistent evidence supports a credible future/shared corridor interaction, but current motion does not yet positively establish the opposed conflict. Observe, and Regulate where Action Space is being consumed.
- **Established Opposed Corridor Conflict** — substantially opposed, closing, sufficiently persistent/stable observed motion with positively supported corridor overlap.

**Near-collinear** is relational: the opposed trajectory corridors compete for the same local space. Exact centre-lines, exact 180-degree headings and exact lateral offsets are not architectural requirements.

### 0.4 Passage Presumption and Local Passage Space

Once Step 1 establishes an Opposed Corridor Conflict, Step 2 adopts **Passage Presumption**: passage is presumed possible until **Local Spatial Constraint** disproves it. Incapability is discovered from Reality, not pre-classified by assembly type.

**Local Passage Space** is nearby traversable Field World space that may be temporarily consumed to resolve the current encounter, including space outside either participant's productive lane. Configuration reduction may help but is optional. Cooperative Passage may impose asymmetric burden or require only one participant to move.

**Boundary Encroachment** is legitimate Local Passage Space: an assembly may straddle the Field Boundary into the immediate margin while remaining partly in-field. A complete assembly becoming wholly extra-field is not Cooperative Passage; it enters extra-field relocation/navigation responsibility.

Local Spatial Constraint may include terrain, static obstacles, Field Boundary/margin limits, local topology, assembly geometry or kinematics. Failure to find a supported local passage may ultimately escalate to the player.

### 0.5 Passage Arrangement, economy and sufficiency

A **Passage Arrangement** is a temporary pairwise spatial relationship in which participants can progress past one another while protecting Nominal Inter-Assembly Clearance. Neither Established Trajectory has inherent privilege.

**Pairwise Passage Economy** selects a supported arrangement by minimising combined necessary intervention across the pair; existing commitments or established priority may break ties between otherwise comparable arrangements. Symmetry is not a requirement.

**Passage Sufficiency** is satisficing, not global optimisation: once a locally supported arrangement satisfies safety/completion obligations and no already-known obviously simpler supported arrangement exists, search stops.

**Progressive Passage Search** expands only as far in intervention burden as necessary to discover such a sufficient arrangement.

### 0.6 Passage geometry responsibilities

**Nominal Inter-Assembly Clearance** is a positive clearance reserve protected between actual assembly envelopes during controlled passage. Architecture deliberately declares no universal metre/percentage value.

**Passage Development Distance** is longitudinal room needed to settle from the conflict trajectory into the passing relationship. Shorter nose-to-nose distance may demand sharper steering/sweep and can make an arrangement unsupported rather than justifying arbitrarily harder turns.  
**Passage Traversal Distance** is the room needed for full assembly lengths to clear while the passing relationship remains supported.  
**Reacquisition Distance** is the room needed to leave the passing arrangement and return toward native continuation.

**Manoeuvre Swept Occupancy**, not endpoint fit alone, governs whether transition into/out of the arrangement can protect clearance. Architecture does not prescribe a continuous swept-polygon planner.

### 0.7 Passage Guide

A **Passage Guide** is a bounded ordered set of temporary spatial targets/gates shaping an assembly into the Passage Arrangement and back toward native continuation. It is not architecturally limited to `left-a-bit → straight → right-a-bit`, nor does every target need to be an exact point. Implementation may use multiple pins, acceptance regions or directed gates according to GIANTS-compatible control evidence.

The historical Forward-Only Waypoint Orbit remains relevant implementation evidence: arbitrary high-lateral point targets are not assumed navigable merely because geometric pins can be placed.

### 0.8 Passage Support Loss and Passage Reassessment

**Passage Support Loss** occurs when evidence that justified the current Passage Arrangement or Passage Guide is no longer sufficient for continued execution.

**Passage Reassessment** requires authority to pause at the safest available state and reassess from current Reality. Outcomes are: continue the existing expression; re-express the same Cooperative Passage Commitment using a newly supported arrangement/guide; or safely abandon/escalate when no supported local continuation remains.

Loss of one execution expression need not destroy the higher-level Commitment to resolve the same opposed conflict by Cooperative Passage. Implementation details for detecting support loss are intentionally unresolved.

### 0.9 Explicit implementation-health boundary

**Current status: D-0146 architecture accepted; general D-0146 Cooperative Passage implementation incomplete.**

The v4.7.98 live controller remains bounded to the demonstrated TS015 Condor/Patriot path and existing purpose-specific Representation Fitness. This candidate does **not** implement:

- Established Trajectory / Current Excursion persistence logic;
- generic Potential/Established Opposed Corridor Conflict classification;
- generic Local Passage Space discovery;
- arbitrary/asymmetric Passage Arrangement generation;
- general Manoeuvre Swept Occupancy or Nominal Clearance planning;
- dynamic Passage Guide construction;
- Passage Support Loss detection or Passage Reassessment.

No future chat should infer these capabilities from their architectural acceptance. The first implementation work after canonicalisation must begin from this explicit architecture/implementation gap and preserve proven v4.7.98 behaviour until new evidence validates change.

---

# Architecture

## v4.7.98 Progressive Situational Sufficiency — normative candidate precedence

**Status:** canonical candidate architecture for owner review.  
**Canonical baseline:** owner-declared v4.7.95 (`1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`; Git `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`; 305 files).  
**Production evidence donor:** live-successful v4.7.97.  
**Decision:** D-0144.

D-0144 governs current Situation-model simplification. D-0143 remains authoritative for bounded Cooperative Passage where not superseded, and D-0141 remains authoritative for follower Regulation. Older Rook/chessboard/Successor-Rook, King/Refuge and scenario-specific material below is historical unless explicitly preserved here.

### 0.1 Progressive Situational Sufficiency

Situation Assessment should acquire **only enough positively supported current Knowledge to justify the next least-authority action**. Detailed future native route reconstruction is not a prerequisite when current uncertainty can be handled by continued Observation or bounded Regulation without consuming the necessary resolution option.

Current production reasoning therefore centres on:

- Field World / Operation / Job Episode identity;
- current assembly/configuration and bootstrap-cached physical representation;
- current Productive or Transitional state;
- current motion, heading and native evidence;
- current Encounter / cooperative relevance;
- current obligations / Committed Demand;
- optional Turning Rank awareness where it materially supports observation or early Regulation;
- current Configuration-Released-Space / Cooperative-Passage applicability where positively supported.

This is a simplification of what the system must know, not permission for Situation Assessment to select actions or bypass Candidate/Constraint/Decision ownership.

### 0.2 Turning Rank awareness, not prediction

**Turning Rank** remains a useful spatial concept: the first productive rank immediately infield of the Productive Headland Working Band where native transition may consume space. It may eventually help Situation Assessment recognise that a following relationship is approaching a transition-sensitive region and therefore justify closer observation or earlier Regulation.

Turning Rank carries **no** authority to predict turn direction, identify a U-turn scenario, reconstruct a GIANTS route or manufacture transition clearance. v4.7.98 introduces no new Turning Rank geometry or shape calculation.

### 0.3 Retired chessboard / successor machinery

The following are retired from governing current production architecture:

- Rook as a required productive-space structure;
- Successor Rook Set / successor productive-structure prediction;
- chessboard productive-history colouring;
- continuous Productive History reasoning as a runtime obligation.

Historical documents and diagnostics remain evidence provenance. Their continued existence in the repository does not create runtime or architectural authority. Transition-relevant demand must be supported from current positive evidence when it matters; no replacement speculative route model is introduced.

### 0.4 Preserved leader/follower Regulation

D-0141 remains live and useful. When a follower is closing while the leader's native continuation is not yet sufficiently revealed, Regulation may preserve Action Space and ordering while GIANTS retains route/steering ownership.

Regulation is not a head-on resolver. If Reality matures into the supported D-0143 opposed Productive/Productive class, Cooperative Passage may supersede the follower purpose through the ordinary Candidate → Decision → Commitment lifecycle.

### 0.5 Cooperative Passage Scope Boundary

**Current status: bounded Cooperative Passage production capability demonstrated; general Cooperative Passage incomplete.**

Live v4.7.97 evidence supports automatic production Cooperative Passage for the TS015 Condor Endurance II / Patriot 4450 **near-collinear Productive/Productive** class. It does not establish:

- Productive/Transitional opposed authority;
- general asymmetric passage;
- arbitrary assembly/configuration capability;
- generic negative-clearance proof;
- universal authority for the current 50-70 m / 2 m / +/-6 m / 12 m / 8 m / 8 km/h calibration;
- completeness across the historical regression family.

Unsupported cases remain `UNRESOLVED` rather than inheriting authority from fixture success. Earlier asymmetric P23 failure remains valid boundary evidence even if changed intervention timing later produces a more symmetric final encounter.

### 0.6 Physical representation / performance boundary

The current bounded Cooperative Passage path consumes purpose-specific Representation Fitness derived from bootstrap-cached `physicalSpaceEvidence` already present in Situation Assessment. D-0144 introduces **no new shape discovery, polygon construction, footprint decomposition, transition sweep or continuous clearance calculation**.

The historical Demonstrated Productive Coverage, Productive Coverage Residual and Refuge Qualification Shadow diagnostics are not sourced by the v4.7.98 live runtime. Their source files remain historical evidence donors.

### 0.7 Current authority flow

```text
Reality / GIANTS
  → Observation
  → Situation Assessment: sufficient current Knowledge only
  → Operational Picture
  → Candidate Action Space
  → Mandatory Constraints
  → Traffic Policeman / Decision
  → Commitment + Obligations
  → Bounded Authority
  → Control
  → GIANTS / observed Reality
```

The immediate behavioural repertoire evidenced for TS015 is `Observe → Regulate when needed → Cooperative Passage when a supported opposed conflict requires Reposition`. Hold remains an available bounded action where independently admissible; no special headland-U-turn solver exists.

---

## v4.7.95 Cooperative Passage Production Direction — historical D-0143 authority preserved by D-0144

**Status:** canonical candidate architecture for owner review.  
**Implementation baseline:** owner-declared canonical v4.7.77 (`0964ba2583122088077e5e465fffb24820d07380f533d1f44ed7d1ad24355153`; Git `1742c197c21a1fb127932dcc15303dbd58515d6d`; 305 files).  
**Decision:** D-0143.

D-0143 remains authoritative for Configuration-Released Space, bounded Cooperative Passage, post-handoff ownership separation and the normal Candidate/Constraint/Decision/Commitment/Control chain. D-0144 supersedes D-0143/D-0142 where they retain Rook/Successor-Rook/chessboard/continuous Productive-History obligations. D-0143's King/King-Reserve/ordinary-Refuge retirement remains in force.

Post-canonical v4.7.91-v4.7.94 P23 builds are **evidence donors only**. They do not become the implementation baseline and their fixture literals do not become architecture merely because the PoC succeeded.

### 0A.1 Disposition of King and continuous Refuge discovery

The current King approach is **RETIRED as governing architecture and as the next production implementation direction**.

The post-canonical performance lineage demonstrated that repeated actual-footprint King-space placement/swept-clearance work produced conspicuous stutter under live load. Removing polygon decomposition and Knowledge-copy amplification did not remove the characteristic regression; restoring the older circle-style clearance materially improved performance but reintroduced under-approximation/Endpoint Geometry Collapse risk. Reduced exact re-proof count also did not recover FPS proportionately. The current form is therefore not a production-capable basis to continue optimising.

Consequences:

- **King Reserve Availability is retired** as continuously maintained production Knowledge.
- continuous local Refuge discovery/qualification is retired as an ordinary runtime obligation;
- the provisional ordinary `A→R→A` King lifecycle is retired as the expected head-on resolver;
- no implementation work is authorised to optimise, cache, certificate, profile or otherwise rescue continuous King-space search for the TS015 objective;
- **Refuge** remains only a generic spatial/historical term for a supportable stationary waiting region should later Reality independently require one. There is no standing obligation to discover or maintain Refuges.

If later evidence requires a Refuge-based strategy, that is a fresh architectural question. Retired King machinery receives no presumption of reuse.

### 0A.2 Configuration-Released Space

**Configuration-Released Space** is local spatial capacity made usable when an assembly changes from a larger physical configuration to a smaller one. It is a physical/configuration relationship, not an inference from agricultural working width alone.

For the P23 Condor/Patriot fixture, folding both sprayers released substantial lateral capacity inside the immediate productive corridor. This was sufficient for two compact assemblies to occupy separated lateral paths simultaneously.

Configuration-Released Space:

- depends on Configuration-Dependent Assembly Footprint;
- does not prove that every point beneath a deployed working width is traversable;
- does not transfer endpoint fit into transition-sweep authority;
- may be absent for assemblies whose compact footprint is not materially smaller than their working occupancy;
- is assessed on demand for a current conflict, not maintained continuously as speculative escape-space Knowledge.

### 0A.3 Cooperative Passage

**Cooperative Passage** is a joint Reposition strategy in which two cooperatively relevant participants temporarily reduce physical occupancy, establish separated passage paths within the immediate encounter corridor, pass one another concurrently in their respective forward directions, return toward productive alignment, restore productive configuration and hand native authority back to GIANTS.

The strategy changes the source of resolution space: it **creates usable capacity by configuration reduction inside the conflict corridor** rather than parking one participant in an externally discovered Refuge.

A Cooperative Passage Candidate may have more than one assembly as its `Subject`; the existing Candidate Action contract already permits an assembly or assemblies. Concurrent compatible movement remains preferred over scripted one-worker-at-a-time choreography when mandatory constraints support it.

The successful P23 physical sequence is evidence for capability, not a mandated production controller state machine:

```text
opposed productive conflict
  → Hold both
  → compact both
  → establish separated lateral passage paths
  → pass concurrently forward
  → return toward productive axes
  → restore
  → hand both back to GIANTS
```

### 0A.4 First production authority envelope — TS015 only

The first production objective is deliberately narrow: make **TS015 Condor Endurance II / Patriot 4450 near-collinear opposed-working encounters** use Cooperative Passage through the normal architecture.

Situation Assessment may support a first Cooperative Passage Candidate only when current positive evidence establishes the bounded TS015 class, including:

- both assemblies remain active participants with continuing GIANTS Job Episodes;
- the pair is positively cooperatively relevant and forms an authoritative opposed/facing productive incompatibility;
- the encounter is sufficiently near-collinear/common-axis for the demonstrated paired lateral split to be applicable;
- both assemblies have positively supported compact/restore capability for the relevant configuration transition;
- sufficient response margin remains to stop, compact and establish separated passage paths before physical blockage;
- no incompatible third-party Committed Demand or other mandatory constraint invalidates the manoeuvre.

The v4.7.94 final asymmetric attempt is explicit negative boundary evidence for the first authority envelope: P23 correctly attempted its fixed fixture geometry, but the resulting lateral clearance was insufficient. Production must reject unsupported asymmetric geometry rather than expand the solver during the TS015 closure increment.

The P23 `70 m`, `6 m`, `12 m`, `8 m` and `8 km/h` literals are **fixture/calibration evidence only**. They are not architectural constants. A first narrow implementation may conservatively reuse proven fixture values where necessary to close TS015, but they must remain visibly scoped implementation constants rather than semantic definitions.

### 0A.5 Layer ownership for production coupling

The production chain remains:

```text
Reality / Observation
  → Situation Assessment recognises the supported TS015 opposed situation
  → Operational Picture publishes Knowledge only
  → Candidate Action Space may enumerate a joint Cooperative Passage REPOSITION
  → Mandatory Constraints independently gate admissibility
  → Traffic Policeman / Decision selects the action after ordinary preference-band exhaustion
  → Commitment owns the joint purpose and staged obligations
  → Bounded Authority permits only the current physical phase
  → Control executes the already-selected bounded physical work
  → GIANTS resumes native jobs
```

No P23 fixture may become a parallel production decision path. No `HEAD_ON` scenario class regains governing solver authority. TS015 is a validation scope, not a permanent architectural scenario subsystem.

For a pure established head-on, Regulation or Hold may preserve time/action space but cannot create passing space. Once such incompatibility is authoritative, some spatial Reposition is required. Cooperative Passage is the demonstrated first Reposition strategy for the supported TS015 class.

### 0A.6 Commitment settlement and post-handoff observation

A Cooperative Passage Commitment owns only the obligations required to execute and safely hand back the manoeuvre. After restoration, native handoff and supported resumption/decoupling, the Commitment may settle according to existing lifecycle rules.

Passive post-handoff observation is **not Commitment ownership, Control authority, a reservation or a cooldown**. P23's earlier 120-second observer lockout was an implementation mistake: observation may continue independently and may be superseded by a new necessary Commitment without blocking it.

### 0A.7 Immediate implementation objective and work freeze

After v4.7.95 canonicalisation, the next implementation increment is **TS015 Cooperative Passage Production Integration**.

Until that objective has live evidence:

- do not create another prototype controller;
- do not resume King/King-Reserve/continuous Refuge implementation or optimisation;
- do not generalise to arbitrary vehicle pairs;
- do not design an asymmetric Cooperative Passage solver;
- do not reopen broad architecture questions merely because implementation is inconvenient.

Use the smallest production coupling required to make the already-demonstrated TS015 capability flow through Situation Assessment → Candidate → Constraints → Decision → Commitment → Authority → Control. Reality from that integration is the next architect.

---

## v4.7.77 Field World / Chessboard Architecture Consolidation — historical D-0142 authority

**Status:** historical D-0142 authority; superseded by D-0143 and D-0144 where they conflict.  
**Historical implementation baseline at decision time:** owner-declared canonical v4.7.76.  
**Decision:** D-0142.

This section consolidates the architecture discovered after v4.7.76. **Where later historical text in this document conflicts with this consolidation, this section governs.** Historical mechanisms remain evidence and implementation donors only where explicitly preserved; they do not retain architectural authority merely because v4.7.76 implements them.

Canonical architecture is authoritative working knowledge, not a claim of immutability. Reality may later disprove or refine it. Implementation must build from the current canonical architecture until such evidence is consolidated.

### 0.1 Governing information and authority flow

```text
Reality
  ↓
Observation
  ↓
Situation Assessment
  ↓
Operational Picture Knowledge
  ↓
Candidate Action Space
  ↓
Mandatory Constraints
  ↓
Traffic Policeman / Decision
  ↓
Commitment + Obligations
  ↓
Bounded Authority
  ↓
Control
  ↓
GIANTS
```

Architecture defines what the system must achieve. Implementation discovers how. Testing validates or disproves assumptions. No lower layer may acquire semantic authority because implementation convenience makes it easy.

### 0.2 Shared Field World and worker-relative productive structure

The **Field World** is shared world-space Knowledge for one Operation. Worker-specific productive structures are overlaid on that shared world; there is not a separate physical world per worker.

Three spatial concepts must remain distinct:

- **Field Boundary** — the agronomic polygon boundary defining the bounded Field World.
- **Productive Headland Working Band** — the productive work band adjacent to the boundary where the native job may itself perform active work.
- **Turning Rank** — the first productive rank immediately infield of the headland working band where native transitions/turns may consume space.

Ambiguous use of “headland” must not collapse these concepts.

### 0.3 Productive Regime, Rook and productive history

Positive coherent native work evidence may establish a worker as **Productive**. Productive state is represented through a worker-relative **Rook structure**: the supported current productive rank/file and its work-space demand.

Worker colouring records **active work positively demonstrated as performed**, not traversal, vacancy, ownership, permanent release or general traversability. Uncoloured space remains unknown unless another independent representation supplies authority.

When positive active-work support ceases while the Job Episode continues, the worker becomes **Transitional** or `UNRESOLVED` according to evidence. Transitional does not mean harmless, departing or released.

### 0.4 Productive succession without exact native path prediction

A **Successor Rook Set** represents the bounded set of supportable productive structures that may follow the current Productive Regime. It is not a prediction of which one GIANTS will choose.

A **Bounded Transitional Demand** represents spatial requirement supported during native transition between productive regimes. It must remain bounded by positive evidence and must not reconstruct an exact GIANTS turn/reposition path.

Therefore:

- Productive Demand and Transitional Demand are separate spatial dimensions.
- Productive safety does not imply Refuge safety.
- Current occupancy alone is insufficient, but old straight-to-boundary Future-Space geometry is not permanent architectural authority.
- Exact GIANTS continuation may remain unresolved while supported demand is still sufficient for cooperative reasoning.

### 0.5 Configuration-Dependent Assembly Footprint

Each Physical Assembly has a **Configuration-Dependent Assembly Footprint**. Spatial fitness is always evaluated using the configuration relevant to the question.

For ordinary local Refuge resolution the relevant phases may differ:

- deployed productive / Rook configuration;
- compact King manoeuvre configuration;
- stationary Refuge configuration;
- restoration/deployed configuration at Native Reacquisition Anchor A.

Evidence that one configuration fits does not transfer automatically to another configuration or to an intermediate transition sweep.

### 0.6 Historical D-0142 Native Reacquisition Anchor / local Refuge lifecycle — SUPERSEDED by D-0143

**Native Reacquisition Anchor A** is the positively demonstrated pre-egress pose/area where native productive continuation was established and where the deployed working configuration has already been demonstrated spatially valid.

The ordinary local Refuge lifecycle is **provisionally**:

```text
ROOK at A
  → compact
  → KING
  → A→R
  → Refuge at R
  → R→A
  → restore
  → ROOK / native reacquisition
```

Phase-specific fitness governs the lifecycle:

- R need only fit the stationary Refuge configuration.
- A↔R must support the compact manoeuvre/swept footprint.
- A must support restoration of the deployed productive configuration.

A King manoeuvre begins only when the configuration on which its spatial fitness depends is positively established, unless a separately represented transition configuration has independently passed the required fitness.

On execution failure, Control preserves the currently demonstrated-safe occupancy/configuration unless another configuration change is independently authorised as spatially fit. Mechanical ability to unfold is not authority to unfold at an arbitrary failure location.

The ordinary architecture does not require a general route planner. A bounded reversible local A↔R relation is the current provisional model. General multi-leg routing must not be introduced unless Reality demonstrates that the ordinary model is insufficient.

### 0.7 Historical D-0142 King Reserve Availability — RETIRED by D-0143

**King Reserve Availability** is Knowledge maintained per worker indicating whether at least one local Refuge opportunity currently remains supportable.

Architectural authority is provisionally binary:

```text
SOME
NONE
```

Implementation may use `UNKNOWN` when evidence is incomplete; `UNKNOWN` must never be silently converted to `NONE`.

King Reserve Availability:

- is not an exact Refuge Candidate;
- does not select R;
- does not assign ownership;
- may legitimately be `NONE` for a lone worker;
- acquires cooperative significance when another worker becomes positively relevant.

### 0.8 Cooperative relevance

Mere same-field membership, proximity or visual closeness does not establish cooperative relevance.

Positive relevance requires a supported spatial relationship such as:

- Productive/Rook demand encroachment or intersection;
- Transitional Demand intersection;
- interaction with existing Committed Demand;
- gateway/admission into a **Cooperative Constraint Region** where another participant materially affects local resolvability.

Encounter/lifecycle machinery may consume this Knowledge, but the relationship must be established upstream by Situation Assessment.

### 0.9 Resolution-Space Conservation

**Resolution-Space Conservation** is the invariant:

> Once a potentially conflicting cooperative relationship is positively supported, ordinary progression must not consume the last locally admissible means of resolving it.

D-0143 preserves this invariant while retiring King Reserve as its standing implementation mechanism. Before Decision, any supportable resolution capacity — including Configuration-Released Space — is only **resolution possibility**; there is no provisional ownership. Situation Assessment need not continuously enumerate speculative escape space merely to preserve the invariant.

The historical D-0142 `King Reserve SOME → NONE` transition was one proposed early-danger signal and is **SUPERSEDED by D-0143**. For the immediate TS015 objective, the Traffic Policeman instead consumes positively supported current Situation/Action-Space evidence and may constrain ordinary progression before physical collision or complete blockage destroys the demonstrated Cooperative Passage option.

Resolution-Space Conservation generalises several older observations including follower boundary protection, recovery protection and constrained-topology action-space compression.

### 0.10 Conflict Serialization and admission control

Multi-worker traffic does not require bespoke N-worker physical solvers.

**Conflict Serialization** is Traffic Policeman reasoning that reduces concurrency by Regulating/Holding a participant whose progression can safely be deferred, allowing the remaining situation to mature into a simpler known resolvable form, resolving that form, then reassessing Reality.

This is the mature form of “distill complex encounters into ones we know how to resolve.”

If admitting another worker through a narrow neck, gateway or other constrained topology would destroy local resolvability, **admission control belongs upstream**. Downstream Control must not compensate by growing increasingly sophisticated routing/choreography.

### 0.11 Candidate, Constraint and Decision ownership

**Operational Picture Knowledge** contains current supported Knowledge only. It does not contain Candidate specifications or mandatory verdicts.

**Candidate Action Space** enumerates complete supportable actions. It does not select among them and does not manufacture mandatory `PASS` verdicts.

Historical D-0142 local-Refuge Candidates could identify A, R and an A↔R relation. D-0143 retires that as the ordinary TS015 production path. For the current Cooperative Passage direction, a Candidate may instead identify, where positively supportable:

- the participating assembly or assemblies;
- the supported compact/restore configuration transitions;
- the bounded separated passage relation inside the immediate encounter corridor;
- restoration / native-handoff obligations;
- Purpose and expected resulting situation.

This does not create a general route planner or grant Candidate generation authority to manufacture clearance.

**Mandatory Constraints** independently determine admissibility, including phase-specific Representation Fitness, Field World containment, transition clearance, demand compatibility, obligation compatibility and capability availability.

**Traffic Policeman / Decision** selects temporary movement ordering and action. Conflict Serialization belongs here. Candidate generation must not hide alternatives merely because an older scenario-specific policy preferred one.

### 0.12 Commitment, Committed Demand and bounded authority

Before Decision, Productive Demand, Transitional Demand and possible Refuge space are Knowledge; none is owned merely because it exists.

After Decision selects a spatial Reposition relation, the **Commitment** makes that selected relation durable. For D-0143 Cooperative Passage, this may be a joint separated-passage relation rather than the historical A↔R Refuge relation. The required relation becomes **Committed Demand** until its obligation is discharged, superseded or invalidated according to Commitment lifecycle rules.

Committed Demand is therefore **post-Decision obligation-derived spatial demand**. Active GIANTS job membership alone is not Committed Demand.

The selected spatial relation must survive Operational Picture replacement and Candidate expiry through Commitment/Obligation state.

**Bounded Authority** grants only the current physical phase required by the Commitment. It does not transfer Situation interpretation or route-selection authority to Control.

### 0.13 Control boundary

Control is a bounded physical executor.

It may, when authorised:

- Hold;
- Regulate native GIANTS speed without taking route/steering ownership;
- compact/fold/raise;
- positively observe required configuration state;
- execute an already-selected bounded movement relation;
- maintain a physical condition;
- restore where independently authorised and spatially fit;
- relinquish to GIANTS;
- report physical state, success and failure.

Control must not know or decide:

- why one Refuge is preferable;
- HEAD_ON or leader/follower scenario classes;
- Rook structure or King Reserve policy;
- Transitional Demand interpretation;
- traffic priority/yield rationale;
- overall settlement;
- whether a physical observation settles a Commitment obligation.

### 0.14 Supersession Filter

Before old implementation responsibility is mapped to a new owner, classify the old mechanism:

- **PRESERVE** — the same architectural requirement/concept survives.
- **RE-EXPRESS** — the real requirement survives but the old mechanism/concept does not.
- **RETIRE** — the mechanism was an experimental or superseded implementation artefact.

RETIRE items are not moved anywhere merely to preserve code.

Current classifications:

- P22 as a system/prototype — **RETIRE**; bounded physical capability donors **PRESERVE**.
- P22 Refuge selection and bespoke return/rejoin routing — **RETIRE**.
- HEAD_ON as governing solver/class — **RETIRE**; scenario/diagnostic description **PRESERVE**.
- exactly-two-worker assumptions — **RETIRE**.
- bespoke multi-worker solver — **RETIRE**; cooperative requirement **RE-EXPRESS** as Conflict Serialization/admission control.
- leader/follower solver — **RE-EXPRESS** through demand relationships, Resolution-Space Conservation and Traffic Policeman ordering.
- old straight-to-boundary Future-Space representation — **RE-EXPRESS** through Productive/Transitional Demand; preserve only the broader requirement for prospective spatial Knowledge.
- irregular-field solver/special class — **RETIRE**; local topology remains Field World Knowledge.
- ordinary general multi-leg Refuge router — **RETIRE unless Reality demonstrates necessity**.
- Guarded Recovery — **RE-EXPRESS provisionally**; its proven protection requirement survives while the distinct mechanism is expected to retire if generic Committed-Demand protection validates equivalently.

### 0.15 Historical D-0142 status at v4.7.77 (King items superseded by D-0143)

**Established architecture**

- shared Field World with worker-relative productive structures;
- Field Boundary / productive Headland working band / Turning Rank distinction;
- positive productive-history colouring;
- Productive Regime / Rook and Transitional separation;
- Successor Rook Set rather than exact turn-path prediction;
- Productive Demand and Transitional Demand separation;
- Configuration-Dependent Assembly Footprint;
- positive cooperative relevance;
- **SUPERSEDED by D-0143:** King Reserve as resolution opportunity rather than ownership;
- Resolution-Space Conservation;
- Conflict Serialization;
- upstream admission control;
- Candidate → Constraints → Decision → Commitment → Bounded Authority → Control;
- Control as bounded executor;
- supersession-before-migration discipline.

**Provisional architecture**

- **SUPERSEDED by D-0143:** ordinary local Refuge lifecycle A→R→A;
- **SUPERSEDED by D-0143:** one reversible local King relation is normally sufficient;
- **SUPERSEDED by D-0143:** King Reserve production authority is fundamentally SOME/NONE;
- A is approximately the egress-origin pose/area where productive continuation and deployed configuration were positively demonstrated.

**Open hypotheses — not implementation permission**

- generic Committed-Demand protection will completely subsume and retire Guarded Recovery;
- general multi-leg Refuge routing will never be required.

### 0.16 Historical D-0142 first implementation objective — SUPERSEDED by D-0143

The D-0142 first implementation build was **Operational Picture Knowledge Foundation**. D-0143 supersedes this objective with TS015 Cooperative Passage Production Integration.

It introduces the coherent production-intent Knowledge layer:

1. Productive Regime / Rook.
2. Positive productive-history colouring.
3. Configuration-dependent footprint Knowledge.
4. Successor Rook Set.
5. Bounded Transitional Demand.
6. King Reserve Availability.
7. Positive cooperative relevance.
8. Resolution-Space state.

Temporary structured logging/shadow comparison is part of the validation contract. The architecture implementation itself is not a prototype. During this first build, newly introduced chessboard Knowledge has no Candidate, Decision, Commitment, Bounded Authority or Control authority. Promotion follows validation against Reality.



## Field World Equivalence Authority

A Field World is the experienced contiguous agronomic workspace represented by one or more immutable Job-Seeded Field World Snapshots. Exact sampled-boundary equality is not required: GIANTS may return seed-dependent polygon representations for the same workspace. Player-facing field labels, farmland identity, seed position and exact fingerprints remain evidence or locators; none independently governs Field World or Operation identity.

Field World Equivalence Authority produces exactly one outcome when a Snapshot is resolved against established Field World evidence:

- `SAME_FIELD_WORLD` — positive, coherent evidence establishes materially the same contiguous workspace;
- `DIFFERENT_FIELD_WORLD` — positive separation evidence establishes materially different workspaces;
- `UNRESOLVED` — evidence is insufficient, contradictory or only partially compatible.

`SAME_FIELD_WORLD` requires compatible connected topology, reciprocal workspace coverage, bounded representation variation and no materially exclusive region. `DIFFERENT_FIELD_WORLD` requires positive evidence such as disconnected occupied regions, substantial mutually exclusive area, incompatible topology or material spatial separation. No individual metric may establish either result alone.

Equivalence must remain coherent across the accepted evidence for the Field World as a whole. A pairwise match with one retained Snapshot is insufficient, and tolerance chaining must not construct an incoherent identity class.

`UNRESOLVED` preserves the Snapshot and observation evidence but grants no authority to join or establish an Operation and cannot extend Control authority.

## Representation provenance

Every Job Episode retains its immutable GIANTS-generated polygon, canonical representation, exact fingerprint, capture provenance and player-facing locators. Recognising Field World equivalence does not merge, rewrite or discard those records. Exact canonical geometry equality is sufficient for `SAME_FIELD_WORLD`; an exact fingerprint remains a compact provenance reference and collision detector, and fingerprint equality alone is not independent Field World identity authority.

## Operation consumption

Operation admission consumes resolved Field World identity. An Operation remains ephemeral: successive Operations in the same Field World are not one persistent Operation. The active v4.7.12-derived implementation still groups by exact fingerprint and is therefore explicitly provisional and non-conforming with this authority contract.

## Supported-world rule

The polygon remains an immutable Job Episode Snapshot. Mid-episode external field merging or splitting is not reconciled. A restarted or replacement Job Episode captures current Reality.

> **Authority:** Normative replacement-core architecture, extended by ADR-0021  
> **Canonical implementation baseline:** owner-declared v4.7.49  
> **Implementation status:** Field World Equivalence Authority not implemented; exact-fingerprint Operation grouping provisional; general production Control disabled. Non-canonical D-0140 alignment retains only bounded P22 capability through the central Control path.  
> **Governing ADRs:** [ADR-0019](adr/ADR-0019-replacement-core-commitment-lifecycle.md), [ADR-0021](adr/ADR-0021-field-world-equivalence-authority.md)

## 1. Purpose

OuttaMyWay augments native GIANTS AI field workers so that independently generated jobs can coexist inside one field without preventable collision, deadlock or repeated player rescue.

The architecture defines what the cooperative system must achieve. Implementation will discover how those responsibilities can be realised through GIANTS extension points. Runtime convenience must not weaken architectural obligations.

The system remains a light-touch exception handler:

```text
normal GIANTS operation
        ↓
Situation Assessment detects material augmentation need
        ↓
Decision establishes one bounded Commitment
        ↓
Control executes only authorised capabilities
        ↓
observed Reality validates, revises or disproves the hypothesis
        ↓
GIANTS resumes unrestricted ownership when terminal settlement permits
```

OuttaMyWay does not replace GIANTS route generation, agronomic job ownership or ordinary field-work execution.

## 2. Scope boundary

### In scope

- simultaneous native GIANTS AI field workers inside one Field World;
- player-controlled and completed assemblies when their occupancy affects active workers;
- bounded local prediction through the next material manoeuvre and trajectory settlement;
- temporary speed, hold, movement, orientation and configuration-related authority where supported;
- Terminal Occupancy resolution;
- continuing observation, evidence acquisition and obligation settlement;
- safe return of authority to GIANTS.

### Out of scope

- map-wide navigation to a field;
- general route planning or route substitution;
- replacement worker AI;
- Courseplay-style predetermined multi-vehicle routing;
- combine/wagon offloading coordination;
- multiple-combine harvesting systems;
- behavioural control of the player;
- treating Temporary Slack as permanently released space.

Static-object recovery/avoidance remains a separately parked architectural problem. No current BNIR or Traffic Policeman rule implies that GIANTS can avoid stationary obstacles or that OuttaMyWay can always automate a bypass.

Reverse is architecturally available as a possible movement capability. Reverse Actuation Discovery remains an implementation and validation activity.

## 3. Foundational distinctions

### Reality, Observation and Knowledge

- **Reality** is the world as it exists.
- **Observation** is sourced evidence sampled from Reality.
- **Knowledge** is the system's current interpretation of those observations.
- **Situation Assessment** produces Knowledge only.
- **Decision** decides whether augmentation is required and what action is admissible.
- **Control** executes bounded authority and reports realised outcomes.

No layer may silently substitute its interpretation for another layer's responsibility.

**Implementation alignment invariant:** Diagnostics are observational consumers only and cannot grant, retain, revise or release physical authority. Raw GIANTS facts become semantic traffic Knowledge only through Situation Assessment. Candidate generation represents the complete supportable action space from sealed Knowledge; Decision selects; Commitment owns continuing purpose/obligations/authority; Control alone executes valid authority through bounded capabilities. A prototype or diagnostic location never grants semantic authority by proximity to evidence.

### Situation, Encounter and Commitment

- A **Situation** may persist while entities remain materially relevant.
- An **Encounter** is one locally coherent interaction within that Situation.
- A **Commitment** is Decision-owned continuing responsibility established to achieve one governing objective.

A persistent Situation does not imply a permanent Encounter or Commitment. Repeated Encounters may occur between the same assemblies.

### Assembly and Job Episode identity

Assembly identity may persist across stops, player control and restarted work.

A **Job Episode** is one independently admitted GIANTS AI job instance. Its identity ends when:

- the player manually stops the worker;
- the player enters or takes control;
- GIANTS aborts or faults the job;
- the job is replaced or restarted.

The following do not end a Job Episode:

- the worker becomes blocked;
- OuttaMyWay temporarily Holds it;
- temporary loss of movement while the admitted job remains authoritative.

A restarted or replacement job is independently admitted even when the assembly, work type and apparent purpose are unchanged.

## 4. Bounded Field World and space knowledge

The field polygon defines the bounded Field World for one Operation. OuttaMyWay does not assume responsibility for arbitrary external navigation or obstacles.

Full-Envelope Field Containment remains mandatory: the complete represented assembly and its phase-relevant movement/configuration sweep must remain within the field polygon for any OuttaMyWay-authorised repositioning.

While any worker remains active, intra-field space is not permanently released. Situation Assessment may support:

- **Productive Demand** — spatial demand positively supported by the current Productive Regime/Rook and bounded productive succession;
- **Transitional Demand** — bounded spatial demand positively supported while a continuing worker is between productive regimes;
- **Potential Demand** — bounded possibility not yet strong enough to become current Productive/Transitional/Committed authority;
- **Temporary Slack** — space not currently demanded but not permanently relinquished.

**Committed Demand** is different: it is created after Decision when a Commitment makes a selected required relation durable, for example a selected local Refuge A↔R relation. Active Job Episode membership alone is not Committed Demand.

Historical coverage, current vacancy or completion of one pass cannot establish permanent release. Positive productive-history colouring records demonstrated work only and does not itself establish Refuge safety or general traversability.

## 5. Replacement-core information flow

```text
Reality
    ↓
Observation adapters
    ↓
Situation Assessment
    ↓
Operational Picture Knowledge
    ↓
Complete supportable Candidate Action Space
    ↓
Mandatory constraint and composition verdicts
    ↓
Decision selection
    ↓
Commitment
    ↓
Bounded Control authority
    ↓
Outcome Observation
    ↺
```

### Situation Assessment

Situation Assessment maintains:

- Entity and assembly identity;
- Operation Participation and Situation Relevance;
- Current Space and bounded Future Space;
- Committed Demand, Potential Demand and Temporary Slack;
- representation provenance, confidence and Representation Fitness;
- applicable environmental and architectural constraints;
- observed Control outcomes;
- uncertainty and evidence gaps.

Situation Assessment does not select roles, strategies, terminal dispositions or Control actions.

### Candidate Action Space

Decision must evaluate the complete set of actions currently supportable by available representation, authority and capability. Preference-band exhaustion is not total candidate exhaustion.

A candidate may be rejected because it is:

- physically inadmissible;
- outside Field World containment;
- unsupported by Representation Fitness;
- incompatible with current obligations or authority;
- compositionally unsafe;
- unavailable through proven Control capability;
- insufficient for the governing purpose.

The absence of a preferred candidate does not authorise an unsafe special case.

### Mandatory constraint enforcement

Architectural constraints are admissibility gates, not advisory annotations. A candidate receives authority only after every applicable constraint has been evaluated sufficiently for that action.

Control may reject stale or compositionally changed authority. It may not waive or reinterpret Decision constraints.

### Traffic Policeman — temporary movement priority

Within an Encounter, Decision owns an omnipresent but normally dormant **Traffic Policeman** responsibility. It activates only while current Reality requires decisive temporary movement ordering; ordinary compatible GIANTS traffic leaves it invisible. While active it assigns and revises temporary `PROGRESS` and `YIELD` movement-priority roles from the current Operational Picture so that bounded capabilities preserve the participant whose supported demand currently has priority. As soon as unrestricted cooperative movement is again supportable, its temporary traffic authority/restrictions expire even if the wider Encounter or Commitment still has restoration, Native Handover, evidence or terminal-settlement work to complete.

Traffic Policeman does not plan routes, steer vehicles or replace GIANTS work order. A `PROGRESS` role is temporary right-of-way for the current supported continuation, not ownership of field space, exclusive movement authority or entitlement to unrestricted speed. A `YIELD` participant may receive bounded movement and need not stop immediately; its current occupancy and proposed Action Space remain subordinate to and compatible with Progress demand.

Candidate `Purpose` is the operational result sought by an action, not independent objective-setting authority. Before a Commitment exists it must be traceable to current admitted intent, the Operational Picture and accepted Decision policy. Under an existing Commitment it must remain compatible with the governing Objective and unresolved Obligations unless an explicit lifecycle decision changes that basis. Candidate generators represent Purpose; they do not invent policy.

Once Decision admits a bounded Yield recovery Action Space, its active ingress/restoration requirement becomes Committed Demand. Traffic Policeman must preserve compatibility between that admitted demand and Progress demand until the stage completes, is superseded or is explicitly revoked. `REGULATE_SPEED` may support this without transferring the traffic roles. Every supporting restriction requires a current named purpose and expires as soon as that purpose is satisfied; observed fixture timings such as Condor's approximately 15-second boom unfolding are evidence, not lease durations.

Traffic Policeman's primary Decision preference is strictly sequential after mandatory candidate admissibility:

```text
CONTINUE_OBSERVATION
→ REGULATE_SPEED
→ HOLD_AT_SAFE_POINT
→ NATIVE_REPOSITION
```

A later primary band may be selected only after every earlier band is explicitly exhausted against the same current governing traffic requirement in the same Decision epoch. Exhaustion may be established from Knowledge without physical trial. A material Reality or Control Outcome starts a fresh epoch and reevaluates the complete current Candidate Action Space from the least-disruptive end; the sequence is not a persistent four-state controller. Independently justified supporting capabilities from earlier bands may coexist with a stronger primary Commitment.

- **Observe:** preserve bounded maturation only while useful evidence is emerging and enough Action Space remains to wait. Exhaust when evidence is sufficient for decisive direction or when uncertainty remains but waiting would consume a necessary option.
- **Regulate:** permit bounded GIANTS-owned progression — proceed/creep while GIANTS keeps route, steering and forward/reverse choice. Exhaust when no positively supportable non-zero native movement can satisfy/preserve the current traffic purpose.
- **Hold:** stop **here** only when the current realised Physical Assembly occupancy itself is a sufficient stationary waiting state. Movement to create a waiting state is not Hold.
- **Reposition:** create a supportable waiting occupancy through one or more independently authorised bounded Manoeuvre Legs. Direction is not semantic priority; forward, reverse and composed movement may be candidates where evidence supports them. Reposition exhaustion is participant-complete across admissible role assignments.

Only exhaustion of the complete currently supportable autonomous Traffic Policeman Candidate Action Space justifies explicit escalation/player intervention; unsupported movement authority must not be invented to avoid escalation.

`SETTLED_CONTINUATION` is a lifecycle/evidence gate: it identifies a stable native Local Intent that can act as a traffic reference. It is not spatial clearance by itself. Supported corridor separation remains a separate positive requirement. If that reference participant begins `TURNING` or its supported demand materially changes, authority derived from the old traffic picture expires and Decision reassesses.

Temporary roles may transfer inside one Commitment when evidence shows real reduction/settlement of unresolved obligations or materially improved admissible capability. Repeatedly transferring Hold/unknown intent without reducing the Encounter's unresolved obligations is **Revelation Oscillation** and is not architectural progress.

### Committed resolution-space protection and native reacquisition

When OuttaMyWay materially displaces a participant, the resulting Commitment owns the obligation to preserve and complete the selected recovery relation before unrestricted native reacquisition can settle that responsibility.

The current architecture protects the **selected Committed Demand** rather than requiring an independent recovery-specific traffic mechanism. Situation Assessment continually compares relevant Productive and Transitional Demand with that Committed Demand; Traffic Policeman may Observe, Regulate or Hold threatening participants according to the normal preference/constraint contracts. This applies to any number of cooperatively relevant workers and does not give Control authority to interpret the traffic situation.

The historical name **Guarded Recovery** is retained only as compatibility evidence for the proven requirement that an admitted recovery opportunity must remain protected while Reality evolves. D-0142 classifies the distinct mechanism as **RE-EXPRESS** and records the open hypothesis that ordinary Committed-Demand protection will fully subsume it. Until that equivalence is validated, implementation may retain old behaviour as bounded compatibility machinery, but architecture must not create new Guarded-Recovery-specific concepts, geometry or routing authority.

Historical D-0122/D-0123 terminology remains traceable as evidence: **Native Continuation Restoration**, **Rejoin Anchor**, **Vulnerable Space**, **Convergent Projection**, **Protected Progress Alternation** and **Expedient Manoeuvre Execution** described requirements/mechanisms that informed D-0142. Their appearance here does not preserve them as independent governing architecture. The recovery-protection requirement is re-expressed through selected Committed Demand, ordinary Situation Assessment and Traffic Policeman reasoning; physical decisiveness remains a bounded Control principle.

**Native Reacquisition Anchor A** supersedes production promotion of the old Rejoin Anchor as a routing primitive. A is the positively demonstrated pre-egress pose/area where productive continuation and deployed configuration were already valid. The old Rejoin Anchor remains historical evidence terminology.

Native reacquisition is settled from positive Observation/Assessment evidence after physical restoration and GIANTS handback. Control reports physical facts; Commitment determines whether those facts discharge the recovery/native-reacquisition obligation.

Temporary movement priority may still alternate as required by Reality, but this is ordinary Traffic Policeman reassessment and Conflict Serialization, not scripted one-worker-at-a-time choreography. Concurrent compatible movement remains preferred.

An already-authorised bounded manoeuvre should be executed decisively within current proven physical capability. No numeric speed literal is architectural authority.

### Demonstrated Traversability as bounded admissibility evidence

Actual successful occupation or traversal by the real Physical Assembly can provide positive evidence that the local space accommodated that assembly under the configuration and movement conditions actually experienced. This **Demonstrated Traversability** evidence remains applicable only within a materially unchanged bounded domain and does not prove arbitrary reverse kinematics, configuration sweeps, permanent release of space or current availability against another worker.

For configuration-changing assemblies, “materially equivalent configuration” is a **footprint-domain** requirement, not equality of an implementation configuration number. A reversible implement that changes working side may create a materially different realised footprint even within the same Job Episode. Traversability demonstrated on one side does not automatically transfer to the opposite side or the configuration-transition sweep.

Synthetic Coverage Closure remains required wherever this positive empirical evidence does not cover the proposed Action Space. The Known-Coverage Trap still prohibits treating only-known geometry as complete physical clearance.

## 6. Continuing Intent Priority

A live admitted intent continues to govern ordinary resolution until it genuinely ends or another independently admitted authoritative intent replaces it.

Therefore:

- blockage does not end intent;
- temporary inactivity does not end intent;
- OuttaMyWay Hold does not end intent;
- strategy failure does not end intent;
- insufficient evidence does not end intent;
- confirmed player stop/takeover ends the affected AI Job Episode;
- confirmed GIANTS abort/fault ends it;
- a newly admitted replacement intent supersedes it.

Continuing Intent Priority governs ordinary `ACTIVE` and `WAITING_FOR_EVIDENCE` behaviour. It ends when the Commitment enters `SETTLING`.

## 7. Commitment contract

A Commitment begins only after Decision establishes enforceable continuing intent. Candidate proposals are not Commitments.

Conceptually, each Commitment records:

```text
Identity
Objective
Governing Basis
Lifecycle state
Strategy
Situation dependencies
Obligation Set
Progress-actuation owner
Capability reservations
Validated Effective Actuation Composition
Evidence contracts
Intended terminal disposition
Terminal cause
Terminal settlement evidence
```

### Governing Basis

The **Governing Basis** identifies the admitted intent or intent set and Operation context that make the Commitment objective applicable.

A participant state change terminates or supersedes a Commitment only when it invalidates that Governing Basis. Incidental changes to another participant do not automatically terminate every Commitment that observes it.

The first authoritative event that invalidates the Governing Basis determines the intended terminal cause. Later events may affect settlement or create a successor, but do not rewrite history.

## 8. Commitment lifecycle

The replacement core has three non-terminal states.

### `ACTIVE`

The Commitment owns an applicable objective and may progress toward it.

It may:

- observe and reassess;
- revise strategy;
- evaluate candidates;
- issue authorised progress Control;
- preserve immediate safety;
- create, satisfy or transfer eligible obligations;
- enter `WAITING_FOR_EVIDENCE`;
- begin terminal settlement.

Multi-stage movement, capability changes, retries and refuge revisions remain one Commitment while the Governing Basis and objective remain applicable.

### `WAITING_FOR_EVIDENCE`

The Commitment remains responsible, but evidence is insufficient to justify further progress Control.

It may:

- observe;
- acquire evidence under an explicit evidence contract;
- maintain bounded immediate safety;
- preserve only necessary existing effects;
- return to `ACTIVE` when sufficient evidence arrives;
- enter `SETTLING` through a fail-safe or terminal cause.

It may not:

- treat elapsed time as confirmation;
- infer success from silence or inactivity;
- initiate speculative progress;
- abandon responsibility because evidence is unavailable.

Every evidence contract identifies:

- the unresolved proposition;
- expected evidence;
- evidence provenance;
- preserved useful action;
- exhaustion condition;
- reassessment deadline;
- fail-safe exit.

### `SETTLING`

Ordinary objective-progress authority has ended, but unresolved obligations remain.

It may:

- observe;
- reconcile Control it issued;
- obtain settlement evidence;
- release capability authority;
- satisfy obligations;
- establish evidenced basis cessation;
- transfer eligible obligations atomically;
- maintain bounded immediate safety.

It may not:

- revive the ended objective;
- select a new strategy for that objective;
- issue new objective-progress Control;
- terminate while an obligation remains unaccounted for.

`SETTLING` carries an intended terminal disposition. The disposition becomes final only at Terminal Settlement.

## 9. Obligation architecture

An **Obligation** is an owned requirement that remains in force while its basis remains valid and until an evidenced settlement disposition occurs.

Every obligation has:

- stable identity;
- origin;
- basis;
- exactly one current owning Commitment;
- required outcome;
- required authority;
- evidence contract;
- transfer policy;
- terminal dependency;
- settlement disposition.

An obligation settles only through:

1. **Satisfaction** — its required outcome is achieved and evidenced.
2. **Basis cessation** — authoritative evidence proves the condition requiring it no longer exists.
3. **Accepted transfer** — an eligible successor Commitment atomically accepts ownership.

No obligation may become ownerless.

### Ownership classes

#### Origin-bound

Cannot transfer:

- reconcile Control issued by the Commitment;
- prove predecessor effects ceased;
- release acquired authority;
- record terminal cause and provenance;
- record accepted transfers.

#### Continuity

May transfer to an eligible accepting Commitment:

- immediate physical safety;
- stable Configuration Integrity;
- continuing clearance;
- Terminal Occupancy resolution;
- observation of a still-relevant hazard.

#### Intent-relative

Remain valid only while a particular intent requirement remains authoritative:

- return to the former working line;
- resume the former Job Episode;
- complete a former refuge strategy;
- restore a configuration required only by the displaced intent.

A new authoritative intent may close these through evidenced basis cessation.

### Recognised internal owner

All internal obligations are owned by Commitments.

The Operation, Situation Assessment, Decision and Control layers are not fallback obligation owners. The player is an external actor with physical agency, not an internal Obligation owner.

If no eligible successor exists, the current Commitment remains in `SETTLING`.

## 10. Authority integrity

Many Commitments may observe or reason about one assembly. Only one Commitment may own objective-progress actuation for that assembly at a time.

Capability reservations refine that ownership but do not permit independent progress authorities to act through different capabilities on the same assembly.

### Effective Actuation Composition

Every proposed action must be validated as part of the complete **Effective Actuation Composition**, including:

- existing commands;
- capability reservations;
- residual predecessor effects;
- simultaneous actions on relevant assemblies;
- Future-Space interactions;
- global invariants such as never holding all participants.

Decision validates the composition before authorisation. Control validates that the composition remains materially current immediately before actuation.

A mechanically valid action is inadmissible when its combined effect is unsafe.

### Bounded Native Intent Revelation

When a Commitment requires post-intervention GIANTS intent that cannot be observed while an assembly is fully Held, OuttaMyWay may use **Bounded Native Intent Revelation** as an evidence-acquisition composition rather than reconstructing the GIANTS route.

The pattern retains the governing Commitment and, only when the composition is independently admissible, may:

1. preserve the current Job Episode and GIANTS job/route ownership;
2. maintain or establish a proven controllable transit/configuration state where the Physical Assembly requires it;
3. relax Hold into bounded native GIANTS motion while preserving GIANTS steering, forward/reverse choice and route ownership;
4. observe the resulting Local Intent and Control outcome;
5. re-Hold or otherwise bound authority if evidence is insufficient or conditions deteriorate;
6. restore only OuttaMyWay-owned configuration mutations before unrestricted native work handover when restoration is required;
7. reassess the complete Operational Picture before any further authority transition.

Bounded Native Intent Revelation is not the Safe Release Point. Capability relaxation, intent revelation and Commitment completion remain separate events. The pattern does not provide negative-clearance authority, does not cure incomplete Coverage Closure, and does not make an unresolved manoeuvre sweep safe. Speed, travel and observation bounds are implementation evidence contracts, never architectural literals.

Capability is assembly-specific. A transit configuration is usable only when OuttaMyWay can control it, GIANTS can make the required bounded progression while it is retained, and restoration/re-Hold remain supportable. Failure to reveal useful intent leaves the proposition unresolved and requires revision or fail-safe handling rather than inference.

The pattern may later support post-intervention route reacquisition or static-obstacle recovery, but those applications require their own evidence and admissibility. GIANTS is not assumed to route around a stationary obstacle.

### Safety authority

Bounded safety inhibition may prevent unsafe progress while ordinary capability ownership is unavailable or ambiguous. Safety authority is a veto/protective constraint, not a second progress owner.

## 11. Terminal settlement

A Commitment may enter a terminal disposition only after every obligation has been:

- satisfied;
- closed through evidenced basis cessation; or
- atomically transferred to an eligible accepting Commitment.

This point is the **Terminal Settlement Point**.

### Safe Release Point

A Terminal Settlement Point where no continuing responsibility transfers to a successor.

### Safe Handover Point

A Terminal Settlement Point where continuing obligations transfer to a successor Commitment, or where external physical agency changes while internal coordination responsibilities remain correctly owned.

Intent authority may change immediately. Physical actuation authority transfers only when conflicting predecessor effects are reconciled.

## 12. Terminal dispositions

### `SUCCEEDED`

The objective was achieved and Terminal Settlement completed.

### `FAILED`

The applicable objective could not be achieved, but all resulting obligations were safely settled. Structured causes may include:

- supportable candidates exhausted;
- Representation Fitness insufficient;
- required capability unavailable;
- Control failure;
- evidence fail-safe exhausted;
- autonomous resolution unavailable.

### `SUPERSEDED_BY_NEW_INTENT`

A newly admitted authoritative intent displaced the Governing Basis of a still-live Commitment.

The successor owns progress under the new intent. The predecessor enters `SETTLING`, retains origin-bound obligations and may transfer eligible continuity obligations.

### `CANCELLED_BY_SOURCE_INTENT_TERMINATION`

The governing source Job Episode genuinely ended without being replaced by a newly admitted authoritative intent.

Structured causes include player stop, player takeover, GIANTS abort and GIANTS fault.

### `CANCELLED_BY_OPERATION_TERMINATION`

The Operation context forming the Governing Basis ended and no continuing operational basis remained.

Operation membership reaching zero does not instantly terminate the Commitment. Origin-bound Control, authority, configuration and evidence obligations keep it in `SETTLING` until resolved.

## 13. Intent Supersession

A newly admitted replacement Job Episode becomes authoritative immediately.

During the bounded **Supersession Handover Interval**:

- the successor is the Governing Successor;
- the predecessor is the Settling Predecessor;
- old objective-progress authority ends immediately;
- the predecessor reconciles its own effects;
- the successor may assess and prepare immediately;
- successor actuation is bounded by unavailable or reserved capabilities;
- eligible obligations transfer only through atomic acceptance;
- conflicting progress Control is forbidden.

`SUPERSEDED_BY_NEW_INTENT` becomes terminal only after predecessor Terminal Settlement.

## 14. Player takeover

Player takeover ends the affected AI Job Episode and OuttaMyWay progress authority over that player-controlled assembly.

It does not transfer internal Obligation objects to the player.

The settling Commitment must still:

- reconcile OuttaMyWay-issued Control;
- release acquired authority;
- reassess intent-relative obligations;
- preserve or transfer continuing safety and spatial obligations;
- continue representing the player-controlled assembly as an obstacle where relevant.

Player control transfers physical actuation agency, not necessarily Situation responsibility.

## 15. Terminal Occupancy

A completed worker may leave ordinary Operation Participation while its assembly remains Situation-relevant.

A Terminal Occupancy Commitment is justified when:

```text
completed-worker occupancy
materially affects
Committed Demand or Potential Demand
of active workers
```

Its obligations may include:

- Spatial Responsibility;
- Physical Safety;
- Evidence Integrity;
- Configuration Integrity.

It settles when:

- occupancy is physically resolved;
- an eligible successor Commitment accepts the continuing obligation; or
- relevant active demand demonstrably ceases.

Physical presence alone does not create a permanent obligation after all active demand has ended.

## 16. Operation termination

Commitment lifecycle and Operation membership are separate.

When ordinary Operation membership reaches zero:

- demand-dependent spatial obligations may close through basis cessation;
- issued Control must still be reconciled;
- authority must still be released;
- the assembly must remain in a stable, representable and controllable state;
- terminal evidence and provenance remain required.

A Commitment may outlive ordinary Operation participation in `SETTLING`. No generic remnant owner is required.

## 17. Representation Fitness and candidate exhaustion

Representation Fitness determines which conclusions and actions available Knowledge can support.

Partial representation does not necessarily prevent every action. It removes only claims whose safety depends on missing evidence.

No Silent Under-Approximation remains mandatory: unknown or partial geometry must not be represented as smaller than the available evidence supports.

Preference bands are exhausted sequentially. For Traffic Policeman primary resolution, Observe → Regulate → Hold → Reposition is strict Decision preference after mandatory gates: a later band requires explicit earlier-band exhaustion in the same evidence epoch, without requiring physical trial. Only exhaustion of the complete currently supportable Candidate Action Space — including alternate admissible Yield assignment and direction where represented — may justify autonomous-resolution escalation/failure.

### Encounter Maturation and Action-Space Compression

Traffic Policeman should not infer encounter complexity from geometric labels such as crossing, turning or head-on. Difficulty depends materially on the currently available Action Space. At a field edge/headland, Field World boundaries, Physical Assembly geometry and competing demand may compress admissible options into a sliding-puzzle-like problem; equivalent trajectories mid-field may retain substantially more Temporary Slack.

**Encounter Maturation** permits bounded native progression while an ambiguous interaction is expected to simplify under GIANTS ownership. The desired outcome is not specifically a head-on: Reality may dissolve the interaction, reveal a simpler authoritative state, or show that remaining options are being exhausted. Early Encounter admission therefore does not require early aggressive Control. `CONTINUE_OBSERVATION` or purpose-bound `REGULATE_SPEED` may preserve enough margin for GIANTS to reveal the manoeuvre.

**Action-Space Compression** names the physical loss of supportable resolution options. It is not a new spatial primitive or numeric score. It complements Preference-Band Exhaustion: compression is what is happening in Reality; exhaustion is Decision discovering that preferred supportable candidates have disappeared.

```text
Encounter admitted
    ↓
Action Space currently expanding / stable / compressing?
    ↓
Can bounded native progression preserve or expand supported options?
    ├── YES → mature under bounded observation / supporting speed if justified
    │           ├── interaction dissolves → settle/release when positively justified
    │           └── simpler authoritative state emerges → reassess/resolution
    └── NO  → preference band is being exhausted → stronger intervention
```

OuttaMyWay must not deliberately wait for a well-supported mid-field interaction to become a familiar head-on merely because current implementation knowledge is stronger for head-ons. Architecture follows available Reality, not implementation convenience.

### Productive Continuation Preference

For an otherwise-roomy **non-headland** Encounter, Traffic Policeman may use positively supported GIANTS productive state as a movement-priority preference. **Productive Continuation** means that current Knowledge positively supports the participant as actively executing productive field work. **Transitional Continuation** means the Job Episode remains active while the participant is between productive continuations; it may include repositioning, diagonal transit, geometric turning or forward/reverse manoeuvring.

Where one participant has Productive Continuation and the other has positively supported Transitional Continuation, the initial preference is:

```text
Productive Continuation  → preferred PROGRESS candidate
Transitional Continuation → first YIELD candidate
```

This is a preference, not an absolute role rule. It is admissible only while yielding the transitional participant preserves supported Action Space and current Commitment obligations. If delaying that participant would strand it, consume the remaining useful option, invalidate a necessary native manoeuvre or otherwise worsen resolution, the preference yields to Action-Space Compression / Encounter Maturation reasoning and the transitional participant may legitimately receive `PROGRESS`. The established headland treatment is unchanged.

If both participants are Productive, both are Transitional, or either productive state is materially unresolved, this preference is tied/inapplicable. Traffic Policeman falls back to the existing Operational Picture and may not invent priority from absolute speed, vehicle class, implement width, first arrival or another unsupported heuristic.

The architecture is not bound to a single GIANTS API flag. Prototype 21 demonstrated active GIANTS implement-line evidence as a useful native source across Condor and Valtra/lime-spreader assemblies, including a low-cruise falsification, but Situation Assessment must publish coherent positive Knowledge or `UNRESOLVED`. `line=ACTIVE` is evidence, not a universal one-bit contract.

Transitional Continuation does **not** reduce Physical Assembly, Current Space or Future Space authority. GIANTS transition segments may include reversals back into recently vacated space. The **Apparent Departure Reversal** observation therefore reinforces the existing Safe Release contract: increasing separation, negative closing rate or visual departure cannot independently retire Encounter obligations.

Situation evidence is deliberately asymmetric. Coherent `line=ACTIVE` with compatible work-state evidence may positively support Productive Continuation. `line=INACTIVE` by itself does **not** prove Transitional Continuation: live TS004 evidence includes short `turn=false`, inactive-line boundary states while GIANTS is establishing the next productive line. Transitional Continuation therefore requires corroborating continuing-Job-Episode/native-transition evidence; otherwise the state is `UNRESOLVED`.

Absolute and relative speed ordering remain non-authoritative. **Native Speed-Ordering Variability** demonstrated a reversible plough working at ~12.2 km/h while its native transition reached ~15 km/h. A slower productive participant may therefore remain Productive while a faster participant is Transitional.

A Transitional participant may also be changing configuration. **Alternating Working-Side Configuration** demonstrates that one Job Episode can alternate materially different productive footprints. Traffic Policeman may prefer such a participant as Yield only if an interruption point is supportable in the current configuration transition; inactive productive-line state is not permission to ignore its transition sweep.

### Refuge qualification, decisive Reposition and continuation-aware resolution

Situation Assessment publishes **qualified Refuge Regions**, not arbitrary raw world-space. Qualification may establish Field World relationship, stationary physical usability, assembly/Refuge-Configuration fit, demand relationships and Representation Fitness as Knowledge. Candidate generation subsequently proposes Subject/Purpose-specific Refuge Poses and bounded supportable Manoeuvre Legs. Region FIT does not prove reachability; complete transition sweep and Control capability remain action-admissibility questions.

Reposition has no fixed Manoeuvre-Leg maximum. Every leg is bounded by a Settled Movement Boundary. Further movement requires fresh evidence of **Reachability Progress** or discharge of another unresolved Commitment obligation; progress can initially increase straight-line distance where field topology requires it. Once a selected Refuge Region crosses the Commitment Point, Decision reassesses strategy validity at settled boundaries but does not reopen unrestricted optimisation unless material invalidation, progress failure or Governing-Basis/Reality change occurs.

Candidate comparison is qualitative and purpose-led: mandatory admissibility → dominance removal → Governing Purpose → Resulting Situation quality → Minimum Necessary Authority → material equivalence. Resulting Situation quality includes supportable continuation, unresolved obligation burden, release/recovery support, retained Action Space, robustness and near-term Encounter Recurrence Potential. Clearance Reserve is robustness evidence, not an optimisation target.

**Return Potential** prevents present recession from being mistaken for resolution when continuing native intent may promptly reoccupy relevant Situation Space. **Encounter Recurrence Potential** lets role/action comparison reject a locally convenient resolution that is positively supported as likely to recreate materially the same traffic problem. **Durable Separation** is sufficient continuation-aware separation, relative to outstanding recovery obligations, to unwind current traffic authority without materially recreating the governed conflict. Physical passage, immediate separation and Durable Separation are distinct. Arrival order carries no movement-priority authority.

Traffic Policeman conduct principle: **do not be indecisive; do not procrastinate; do not be stubborn.** Observe only while uncertainty remains affordable; persist with an admitted supportable strategy; abandon it when Reality materially disproves its basis.

## 18. Multi-stage strategy continuity

A Commitment remains one Commitment across:

- slow/hold/refuge progression;
- multiple manoeuvre legs;
- orientation before translation;
- candidate revision at settled boundaries;
- configuration transition;
- Native Handover;
- return to GIANTS;
- bounded evidence waits.

A stage or capability may complete without the Commitment completing.

Strategy revision must preserve:

- Commitment identity;
- Governing Basis;
- open Obligation Set;
- authority history;
- evidence provenance.

## 19. Eight must-not-be-deferred questions

1. **When does a completed worker remain relevant?**  
   While its assembly materially affects active demand, safety, representation, evidence, configuration or another open obligation.

2. **Does Continuing Intent Priority govern ordinary resolution?**  
   Yes, until the source intent genuinely ends or a new authoritative intent is independently admitted.

3. **What obligations does Terminal Occupancy create?**  
   Spatial Responsibility, Physical Safety, Evidence Integrity and, where required, Configuration Integrity.

4. **How do multi-stage strategies remain one Commitment?**  
   Stages and capability changes revise execution without replacing the Governing Basis, identity or Obligation Set.

5. **What constitutes terminal settlement?**  
   Every obligation is satisfied, closed through evidenced basis cessation or atomically transferred to an eligible accepting Commitment.

6. **When may responsibility transfer to the player?**  
   Physical actuation agency changes when player control is evidenced. Internal obligations do not transfer to the player; continuing coordination remains internally owned.

7. **What is the scope of route substitution?**  
   General route substitution and route ownership are outside the replacement core.

8. **What happens if an Operation ends with an unresolved remnant?**  
   The owning Commitment remains in `SETTLING`; demand-dependent obligations may lose basis, while origin-bound obligations remain until settled.

## 20. Implementation boundary

v4.7.0 established the inert structural foundation. v4.7.1 added offline raw Observation publication and canonical assembly/Job Episode identity and admission rules. v4.7.2 adds admitted Operation identity and deterministic Situation Assessment publication of the Operational Picture. Candidate generation, mandatory verdict evaluation, Decision and Control remain unimplemented. The archived v4.6.78 runtime is evidence and donor material only.

Implementation must proceed separately from architecture and should begin with:

1. explicit value contracts and identities;
2. passive lifecycle and obligation traces;
3. state-transition tests;
4. Effective Actuation Composition shadow validation;
5. isolated migration of one bounded Control capability;
6. runtime validation against observed Reality.

Numerical thresholds, Native Continuation Speed estimation, Reverse Actuation Discovery and exact capability adapters remain implementation or empirical discoveries. They may refine implementation without altering the ownership and lifecycle model unless Reality disproves it.

## 21. Normative companion contracts

Implementation must also conform to:

- `ARCHITECTURE_CONFORMANCE_MATRIX.md`;
- `COMMITMENT_STATE_MACHINE.md`;
- `CANDIDATE_ACTION_CONTRACT.md`;
- `RESPONSIBILITY_MAP.md`;
- `REPLAY_VALIDATION_SPECIFICATION.md`;
- `MIGRATION_PLAN.md`;
- `REMOVAL_REGISTER.md`.

These documents refine implementation proof and migration discipline. They do not introduce another architectural subsystem.