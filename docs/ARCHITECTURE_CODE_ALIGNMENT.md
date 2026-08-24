## v0.1.8.0 CANONICAL CANDIDATE alignment — validated D-0181

- **LocalPassagePlanner:** cached `TRANSIT_BASE` is mandatory; missing evidence fails closed. No configuration-conditioned fallback remains in production.
- **SituationAssessment / LiveTrafficCandidateSupport:** D-0143 is not assessed or candidate-published by production runtime.
- **LiveControlDispatcher / CooperativePassageControl:** only D-0146 Cooperative Passage bridges are accepted; `COMPACT_REQUIRED` / `RETAIN_CURRENT` have no live D-0146 authority.
- **D-0179 Physical Capability Record:** unchanged and still owns bootstrap Transit capability.
- **Restoration:** intentionally unchanged; Bootstrap–Restoration Bypass remains Closure B.
- **Validation:** TS016/TS015/TS010S/TS009 all field-PASS under v0.1.7.1; TS015 also completed Terminal Exit successfully.
- **Candidate preparation:** release/provenance only; no behavioural code delta from v0.1.7.1.

## v0.1.7.1 TEST alignment — D-0181 Legacy Authority Closure A

- **LocalPassagePlanner:** cached `TRANSIT_BASE` is a hard D-0146 Candidate prerequisite; no configuration-conditioned fallback exists.
- **SituationAssessment:** no production D-0143 CooperativePassageAssessment publication.
- **LiveTrafficCandidateSupport:** publishes D-0146 Passage only; historical D-0143 candidate construction is absent from the production-loaded module.
- **LiveControlDispatcher / CooperativePassageControl:** accept only D-0146 Cooperative Passage bridge/modes; legacy D-0143 execution and `COMPACT_REQUIRED` / `RETAIN_CURRENT` authority are absent.
- **Historical D-0143 donor:** repository evidence/test material only; not sourced by `main.lua`.
- **Literal ownership:** D-0143-only admission/manoeuvre values retire with that owner; 0.25 km/h Hold-effect and 1000 ms heartbeat remain D-0146-owned at unchanged magnitudes.
- **Restoration:** deliberately unchanged; Closure B will address cached-actuator restoration symmetry separately.

## v0.1.7.0 CANONICAL CANDIDATE alignment — validated D-0179

- **AssemblyRepresentationCache:** authoritative Job-Episode owner for Physical Assembly bootstrap, cached DISC/local representation, frozen Transit Base footprint and selected-runtime Transit fold capability.
- **LocalPassagePlanner:** consumes cached Transit Base geometry; no fold/don't-fold optimisation is reintroduced.
- **CooperativePassageControl:** consumes cached capability and bounded endpoint settlement only; no Passage-time capability rediscovery.
- **Prototype22ConfigurationAuthority:** remains an implementation donor for commanding/observing cached actuators; prototype live-scan semantics do not own the `TRANSIT_BASE` path.
- **Validation:** TS016/TS015/TS010S/TS009 all field-PASS under v0.1.6.5 without settlement exhaustion or watchdog rescue.
- **Candidate preparation:** release/provenance only; no behavioural code delta from v0.1.6.5.

## v0.1.6.5 TEST alignment — Job-Start Physical Capability Record

- **AssemblyRepresentationCache:** now owns bootstrap Transit capability (`isFoldable`, actuator set, expected active duration) from selected runtime configuration only, and freezes Transit Base geometry at first observation.
- **CooperativePassageControl:** consumes `AssemblyRepresentationCache:getTransitFoldCapability()`; it performs no fold-capability discovery for `TRANSIT_BASE`.
- **Prototype22ConfigurationAuthority:** remains the mechanical actuator donor, but its new D-0179 path accepts cached members/actuators and reports specific endpoint settlement/exhaustion. The old live-scan methods remain only for legacy/fallback users.
- **Safety:** configuration exhaustion is non-semantic and non-veto; it does not broaden Passage geometry or claim successful compaction.

## v0.1.6.4 TEST alignment — Transit Motion Settlement

- **Candidate/Representation:** continues to provide cached `TRANSIT_BASE` Passage geometry. It does not determine configuration settlement.
- **Prototype22ConfigurationAuthority:** now exposes `getActiveFoldMotionEvidence()` from native `spec_foldable.foldMoveDirection` across the assembly.
- **CooperativePassageControl:** `TRANSIT_REQUIRED` readiness consumes only that active-motion evidence. Semantic fold aggregates, configuration profiles, command return and geometry similarity are forbidden from this branch by structural regression test.
- **Legacy fallback/restoration:** unchanged; their older fold semantics are not promoted into the Transit Base path.

## v0.1.1.0 canonical-candidate alignment checkpoint

| Architectural responsibility | Current implementation state | Candidate assessment |
|---|---|---|
| Pair-specific physical passage requirement | conflict-facing represented extents + provisional 1.0 m nominal clearance | aligned enough for current evidence; 1.0 m remains policy calibration |
| Least necessary configuration reduction | same-episode natively observed compact profile must release conflict-side space | aligned; mechanical foldability alone carries no authority |
| Resolution-Space Conservation | pair-relative role attribution, Role Migration, bounded Regulation, reversible Hold | materially aligned, but Regulation speed authority remains open |
| Unknown pre-productive intent | Situation-relevant active job; known productive peer may Regulate/Hold; entrant remains GIANTS-owned | aligned with Operational Membership / Situation Relevance distinction |
| Safe Release | blocked participant or positive relevant Future-Space intersection vetoes positive dissolution | aligned with ADR-0006 |
| Regulation Sufficiency timing | Hold waits for physical cap realisation | **open mismatch:** retrospective under final v0.1.0.14 TS010 evidence |

Candidate preparation changes release identity/provenance only; the runtime column is inherited from v0.1.0.14.

---

## v0.1.0.14 — D-0146 Regulation Sufficiency Hold eligibility

| Architectural responsibility | Implementation owner | v0.1.0.14 alignment |
|---|---|---|
| Regulation is least initial intervention | `LiveControlDispatcher` | unchanged 8 km/h bounded first-stage expression |
| Control effectiveness is not operational sufficiency | `d0146RegulationRealised` + current Situation closing evidence | realised cap is necessary but not sufficient |
| Escalate when Resolution Space is still being consumed | `LiveControlDispatcher:_dispatchD0146ActionSpace` | no longer requires protected participant to be Transitional |
| Hold remains temporary physical expression | `_escalateD0146ActionSpaceToHold` / `_deescalateD0146ActionSpaceHold` | 0 km/h Hold with positive non-closing de-escalation retained |
| Situation/Commitment lifetime remains separate | existing Resolution-Space relationship + Commitment lifecycle | unchanged |

**Removed surrogate:** `protected participant still Transitional` as generic Hold-eligibility authority.

## v0.1.0.13 — D-0146 Safe Release conformance

| Architectural responsibility | Implementation owner | v0.1.0.13 alignment |
|---|---|---|
| Persistent Situation Relevance / Conflict Cessation Is Not Resolution | `TrajectoryConflictAssessment.resolutionSpaceRelationship` | Current relationship labels cannot positively dissolve the obligation while contradictory blocked/Future-Space evidence remains. |
| Safe Release — no blocked participant | `TrajectoryConflictAssessment` from sealed Motion evidence | Either participant `blocked=true` vetoes positive dissolution; productive intent is not erased. |
| Safe Release — Future Space clear through Continuation Safety Horizon | `SituationAssessment.futureSpaceRelationships` → `TrajectoryConflictAssessment` | Positive relevant Field-Bounded Future-Space intersection vetoes positive dissolution; no negative-clearance claim is introduced. |
| Capability completion != Commitment completion | existing D-0146 Commitment/Control lifecycle | Regulate/Hold state may change, but the obligation is not settled until positive relationship dissolution survives Safe Release contradictions. |

## v0.1.0.12 — Pre-Productive Intent Relevance alignment

| Architectural responsibility | Implementation owner | v0.1.0.12 alignment |
|---|---|---|
| Productive commencement latch | `LiveObservationSource` / `OperationAdmission` | still gates cooperative Operation membership only |
| Situation Relevance for unrevealed active job | `SituationAssessment` | same-Field-World active AI field-work Job Episode is added to `resolutionSpaceAssemblyIds` as `ACTIVE_JOB_INTENT_REVELATION_PENDING` |
| Pair assessment | `TrajectoryConflictAssessment` | evaluates Operation-member ↔ pending-intent pair without requiring both to be members |
| Intent protection / least intervention | `TrajectoryConflictAssessment` + Candidate/Control | pending worker remains GIANTS-owned; known Operation member is Regulation/Hold subject when positively contributing to closure |
| Cooperative Passage gate | `LocalPassagePlanner` / `PassageCapabilityAssessment` | requires `cooperativePassageEligible`; pending-intent pair is excluded |
| Relationship continuity | pair identity `operation + assembly pair` | unchanged across later productive-membership reclassification |
| Completed/non-active influence | existing terminal/non-operational architecture | not broadened into pre-productive Resolution-Space authority |

# v0.1.0.11 architecture/code alignment — Productive Commencement and Mutable Resolution-Space Roles

| Governing concept / contract | v0.1.0.11 implementation | Alignment |
|---|---|---|
| Operation starts after worker has commenced recognised field work | positive productive commencement is latched per Job Episode before cooperative membership | CORRECTED |
| Transitional turns after commencement remain part of the same Operation | latch survives later `isTurn=true` samples | PRESERVED |
| Job-entry / travel before productive commencement is not cooperative participation | worker remains observable but membership is false | CORRECTED |
| Resolution-Space obligation persistence | same Commitment/obligation survives changing role assignment | PRESERVED |
| Least sufficient intervention follows current Situation | active regulated/protected role may migrate without settling/recreating obligation | CORRECTED |
| Safe actuation transfer | new role lease is applied before old role lease/authority is released | IMPLEMENTED |
| Regulate↔Hold reversibility | retained after migration; migration resumes bounded Regulation for the newly selected role | PRESERVED |
| Fixture specificity | no vehicle/name/map exceptions | ALIGNED |

**Alignment conclusion:** v0.1.0.11 restores two existing architectural boundaries rather than adding new top-level concepts: productive commencement gates cooperative participation, and mutable Control expression follows current Situation while purpose persists.

# v0.1.0.10 D-0146 architecture/code alignment — Reversible Hold Expression

| Governing concept / contract | v0.1.0.10 implementation | Alignment |
|---|---|---|
| Resolution-Space obligation persistence | Commitment remains active through transient/non-closing geometry until positive relationship dissolution or Passage succession | PRESERVED |
| Least sufficient intervention | Physical expression may relax Hold→bounded Regulation once Hold's immediate purpose is positively absent | CORRECTED |
| Positive evidence boundary | Situation publishes resolved `currentNonClosingPositive`; missing/unresolved motion cannot de-escalate | ALIGNED |
| Re-escalation | Renewed positive closure may tighten the same obligation Regulation→Hold again | IMPLEMENTED |
| Cooperative Passage Holds | separate owner/control path; unchanged | ISOLATED |
| D-0147 Protected Yield Holds | separate owner/control path; unchanged | ISOLATED |
| New literals | none | ALIGNED |

**Alignment conclusion:** v0.1.0.10 separates Situation relevance from momentary physical prohibition. It makes Resolution-Space Control reversible without weakening the obligation or introducing TS010-specific geometry.

# v0.1.0.9 D-0146 architecture/code alignment — Regulation Sufficiency

| Governing concept / contract | v0.1.0.9 implementation | Alignment |
|---|---|---|
| Least Intervention | Begin with bounded Regulation rather than immediate Hold | ALIGNED |
| Resolution-Space Conservation | A realised cap that still permits positive closure is not treated as sufficient | CORRECTED |
| Regulate → Hold escalation | Same purpose-bound speed lease tightens to 0 km/h after positive insufficiency evidence | IMPLEMENTED |
| Protected Transitional revelation | Protected participant remains GIANTS-native while regulated peer is held | ALIGNED |
| Cooperative Passage priority | Same-conflict supported Passage supersedes Action-Space lease before escalation | ALIGNED |
| No surrogate trigger | Uses existing currentClosingPositive + Transitional state + measured cap compliance; no distance/time literal | ALIGNED |
| 8 km/h calibration | Retained only as empirical first-stage calibration under renewed review | PROVISIONAL |

**Alignment conclusion:** v0.1.0.9 implements the existing intervention hierarchy without promoting Hold into a passage solution or adding another geometric/temporal surrogate.

# v0.1.0.8 D-0146 architecture/code alignment — Reverse-Aware Resolution-Space Roles

| Governing concept / contract | v0.1.0.8 implementation | Alignment |
|---|---|---|
| Resolution-Space Conservation | Established-conflict Regulation role is based on pair-relative native closure contribution | CORRECTED |
| Conflict Serialization | when continuation classes are equal, defer the greater positive closer rather than the first forward-only speed | CORRECTED |
| GIANTS direction authority | forward/reverse choice remains native; Regulation caps speed only | PRESERVED |
| Transitional revelation | Settled-vs-Transitional preference retained; settled role must positively consume pair separation for Regulation to help | PRESERVED / CLARIFIED |
| Reverse movement | ordinary native movement evidence, not a special-case conflict class | ALIGNED |
| Regulate→Hold escalation | deliberately unchanged pending runtime sufficiency evidence | DEFERRED |
| Current-Excursion conservation | existing forward-only pre-Establishment path unchanged in this tranche | ISOLATED |

**Alignment conclusion:** v0.1.0.8 removes a gear-relative implementation surrogate from Established-conflict role assignment without changing D-0146 architecture or passage geometry.

# v0.1.0.7 D-0146 architecture/code alignment — Passage Support authority

| Governing concept / contract | v0.1.0.7 implementation | Alignment |
|---|---|---|
| GIANTS native blockage evidence | retained in Observation; not treated as standalone physical D-0146 guide-failure proof | CORRECTED |
| Candidate-proven Passage Support | Field World / pair representation / third-party / actuation support retain execution authority | PRESERVED |
| Fail-safe failure state | guide actuation stops and both participants Hold | PRESERVED |
| Configuration economy / safer footprint | D-0146 failure preserves current compact configuration; no automatic expansion inside unresolved conflict | CORRECTED |
| Legacy D-0143 donor | historical failure-restoration behaviour unchanged | ISOLATED |

# v0.1.0.6 D-0146 architecture/code alignment — Configuration-First Cooperative Passage

| Governing concept / contract | v0.1.0.6 implementation | Alignment |
|---|---|---|
| Configuration-Released Space precedes lateral displacement | Candidate evaluates native compact profile before burden search | ALIGNED / TEST |
| Mechanical Foldability is not passage authority | Foldable state alone cannot create `COMPACT_REQUIRED` | ALIGNED |
| AI-Reachable Productive Configuration | Requires same-episode native observation outside OuttaMyWay authority | ALIGNED / empirical runtime validation required |
| Pair-Specific Passage Clearance | Recomputed from selected passage-side profile + 1 m nominal margin | ALIGNED / provisional margin |
| Candidate owns policy; Control executes | Candidate supplies mode + expected profile; Control does not choose configuration | ALIGNED |
| Passage Support Loss must not be driven through | Fresh native blocked during guide fails held | ALIGNED / runtime sensitivity to validate |
| Coverage Closure | No new negative-clearance authority manufactured | UNCHANGED |

---

# v0.1.0.5 D-0146 architecture/code alignment — Resolution-Space Conservation / Progressive Passage

| Governing concept / contract | v0.1.0.5 implementation | Alignment |
|---|---|---|
| Resolution-Space Conservation | Potential Current-Excursion admission retained; Established conflict can now also admit Regulation when Step-2 has no supported Passage expression | CORRECTED |
| Conflict Serialization / least intervention | one participant is speed-regulated; no Hold or displacement is added before a supported passage exists | ALIGNED / TEST |
| Productive/Transitional context | Transitional GIANTS-native revelation preserved where positively known; Settled peer regulated | ALIGNED / TEST |
| Same-Commitment succession | Regulation persists through active Potential/Established relationship and is superseded only after supported Cooperative Passage admission or positive dissolution | PRESERVED |
| Passage Development Distance | no fixed minimum entry threshold; concrete Passage Guide / Field / pair-sweep / third-party support decides feasibility | CORRECTED |
| 50 m Development-Space Surrogate | removed; no replacement literal | RETIRED |
| 80 m Local Passage envelope | retained as current locality/action-space calibration | PARKED |
| Pair-Specific Passage Clearance | side-specific facing extents + provisional 1.0 m nominal margin | PRESERVED |
| 12/8/12 +4 guide geometry / burden fractions | unchanged | PARKED |
| Boundary Encroachment | unchanged / not implemented | PARKED |

**Alignment conclusion:** the two v0.1.0.4 TS010 failure mechanisms identified in Reality now map to existing architecture without introducing a new spatial or traffic concept.

---

# v0.1.0.4 D-0146 architecture/code alignment — Pair-Specific Passage Clearance TEST

| Governing concept / contract | v0.1.0.4 implementation | Alignment |
|---|---|---|
| Facing Clearance Extent | one-sided projection of current participating represented components on the shared lateral axis | TEST IMPLEMENTED |
| Passage-Side Clearance Asymmetry | positive and negative passage relations calculate their own opposing extents / contact threshold | CORRECTED |
| Physical Contact Threshold | selected-side subject facing extent + selected-side other facing extent | ALIGNED |
| Nominal Inter-Assembly Clearance | explicit 1.0 m policy calibration added after physical threshold | TEST CALIBRATION |
| Pairwise Passage Economy | lateral target comes from selected pair/side requirement, not 12 m | CORRECTED; burden fractions remain legacy calibration |
| Configuration-Released Space | valid architecture, but not selected in this tranche | DEFERRED INTENTIONALLY |
| False Compaction Demand | generic 6 m width-derived `COMPACT_REQUIRED` removed | CORRECTED |
| Pair transition support | translated current represented DISC sets sampled against 1 m nominal margin | TEST IMPLEMENTED; no rotational swept-envelope claim |
| Third-party Local Spatial Constraint | current positive third-party represented occupancy checked without derived 6 m participant reserve | CORRECTED / TEST |
| Coverage Closure / negative-clearance authority | remains explicitly unavailable in current bootstrap representation | PRESERVED; no fabricated authority |
| 50/80 m Development-Space surrogate | unchanged | PARKED |
| 12/8/12 +4 guide geometry / burden fractions | unchanged | PARKED |
| Boundary Encroachment | unchanged / not implemented | PARKED |

**Alignment conclusion:** this tranche removes the principal 12/6 architecture/code mismatch without changing the surrounding passage-development calibration. Runtime TS010 decides what remains material.

---

# v4.7.127 architecture/code audit closure — D-0147 Courtesy Constraint Exception

| Governing concept / contract | v4.7.127 implementation | Alignment |
|---|---|---|
| Pending Player Reclamation / buy-time only | completed worker moves only after positive D-0147 admission and returns passive after bounded retreat | ALIGNED / live-supported |
| Bounded Infield Retreat | fixed one-shot centroid bearing, forward-only natural arc, 60 m realised inward progress, native max speed | ALIGNED / v4.7.126 live-supported |
| Protected Yield | authorising productive worker held at 0 km/h during terminal translation and released after neutralisation | ALIGNED / live-supported |
| Continuation Renewal | productive resumption re-arms; later attributed native block admits repeat | ALIGNED / live-supported |
| Courtesy Exhaustion | near-centre repeat demand escalates to player | ALIGNED / implementation present; broader live coverage pending |
| Generic predictive Field World containment | **not applicable to D-0147 under explicit Courtesy Constraint Exception** | ALIGNED; no fabricated PASS |
| Generic complete-envelope Transition Clearance | **not applicable to D-0147 under explicit Courtesy Constraint Exception** | ALIGNED; no fabricated PASS |
| Normal physical Candidate constraints | unchanged; no global weakening | ALIGNED |
| Player Claim / source supersession | sticky immediate authority boundary | ALIGNED / previously live-supported |
| Actuation Neutralisation | mandatory before activity/authority release | ALIGNED / live-supported |
| ValueRecord traversal contract | audited proven sealed collections use `ValueRecord.length/ipairs/pairs`; local plain tables may use native traversal | CORRECTED |
| External Yield | not part of current live D-0147 Candidate/control path; retained only as historical/possible concept with prohibitive proof burden | ALIGNED |

**Audit conclusion:** no redesign of the successful v4.7.126 D-0147 control model is indicated. v4.7.127 is architecture/code/documentation alignment only.

---

# v4.7.126 D-0147 architecture/code alignment — 60 m Native-Max calibration TEST

| Governing concept | v4.7.126 test implementation | Alignment |
|---|---|---|
| Bounded Infield Retreat / one-shot Infield Alignment | fixed initial centroid bearing, no continuous correction | PRESERVED |
| Courtesy movement allowance | 60 m realised progress toward centroid | TEST CALIBRATION |
| Retreat speed | vehicle motor native maximum forward speed sampled once at INFIELD admission; no D-0147 8 km/h cap | TEST CALIBRATION |
| Protected Yield Interval | authorising productive worker(s) remain held during terminal translation | PRESERVED |
| Continuation Renewal / repeat admission | unchanged from v4.7.125 | PRESERVED |
| Courtesy Exhaustion | unchanged near Field World centre | PRESERVED |
| Prediction / exclusion / path planning | absent | INTENTIONALLY NOT IMPLEMENTED |

# v4.7.125 D-0147 architecture/code alignment — Continuation Renewal TEST

| Governing concept | v4.7.125 test implementation | Alignment |
|---|---|---|
| Bounded Infield Retreat / one-shot Infield Alignment | unchanged from v4.7.124 | PRESERVED |
| Protected Yield Interval | unchanged 0 km/h authorising-worker hold during terminal translation | PRESERVED |
| Continuation Renewal | terminal episode stores authorising demand ids after retreat; physical post-release motion re-arms courtesy authority | TEST IMPLEMENTED |
| Repeat admission | after Continuation Renewal, requires later native `blocked=true` plus positive Terminal Occupancy attribution | TEST IMPLEMENTED |
| No immediate chaining | continuously positive conservative Future Space alone cannot trigger another 30 m retreat | PRESERVED / STRENGTHENED |
| Conflict Renewal by disappearance | removed from live D-0147 repeat lifecycle | RETIRED |
| 8 km/h / 30 m courtesy calibration | unchanged | PRESERVED |
| Courtesy Exhaustion | unchanged near Field World centre | PRESERVED |

# v4.7.124 D-0147 architecture/code alignment — Protected Yield traversal correction

| Governing concept | v4.7.124 test implementation | Alignment |
|---|---|---|
| Protected Yield Interval | unchanged: 0 km/h Regulation lease on authorising productive assembly during terminal translation | PRESERVED |
| Immutable architecture values | `protectedDemandAssemblies` traversed only with `ValueRecord.length/ipairs` | CORRECTED |
| Bounded Infield Retreat / one-shot Infield Alignment | unchanged from v4.7.122 | PRESERVED |
| 8 km/h / 30 m courtesy calibration | unchanged | PRESERVED |

# v4.7.123 D-0147 architecture/code alignment — Protected Yield Interval TEST

| Governing concept | v4.7.123 test implementation | Alignment |
|---|---|---|
| Bounded Infield Retreat / one-shot Infield Alignment | unchanged from v4.7.122 | PRESERVED |
| Protected Yield Interval | Candidate carries authorising demand assemblies in the D-0147 Commitment; Dispatcher applies 0 km/h Regulation leases only before `INFIELD` translation | TEST IMPLEMENTED |
| Productive job preservation | Regulation modifies only GIANTS max-speed ceiling; route, steering, forward/reverse choice and AI Job Episode remain native | PRESERVED |
| Mixed authority composition | distinct assemblies may coexist in one Commitment: terminal POST_JOB_ACTUATION plus productive PROGRESS_ACTUATION/HOLD; same-assembly mixed ownership remains forbidden | TEST IMPLEMENTED |
| Protected release | Dispatcher clears D-0147 Regulation leases after TerminalEgressControl has neutralised terminal actuation, and on settlement/failure/higher-authority exits | TEST IMPLEMENTED |
| 8 km/h / 30 m | unchanged | TEST CALIBRATION |
| Prediction / exclusion / path planning | absent | INTENTIONALLY NOT IMPLEMENTED |

# v4.7.122 D-0147 architecture/code alignment — Bounded Infield Retreat TEST

| Governing concept | v4.7.122 test implementation | Alignment |
|---|---|---|
| D-0147 is optional courtesy | legacy `AUTOMATIC_TERMINAL_EGRESS=true` remains the development consent gate; no automatic movement without positive Terminal Occupancy | ALIGNED for testing |
| Bounded Infield Retreat | Candidate derives one fixed centroid bearing after compaction; Control uses forward-only `driveInWorldDirection()` | TEST IMPLEMENTED |
| Field Centre is directional reference only | `geometryMetrics.centroidX/Z` propagated from immutable Field World snapshot; no target point/pursuit loop | TEST IMPLEMENTED |
| No continuous course corrections | Candidate sets `continuousCourseCorrection=false`; Control stores fixed `infieldDirectionX/Z` and never recomputes it | TEST IMPLEMENTED |
| Bounded courtesy quantum | `TERMINAL_INFIELD_RETREAT_DISTANCE_M=30.0`; completion is realised reduction in centre distance | TEST CALIBRATION |
| Reactive Terminal Yield | retreat completion settles the current Commitment; episode remains Pending Player Reclamation | TEST IMPLEMENTED |
| Conflict Renewal | `yieldAwaitingRenewal` suppresses a fresh retreat until the prior positive obstruction has disappeared | TEST IMPLEMENTED |
| Courtesy Exhaustion | if centre distance is already within one retreat allowance, Control rejects further movement as exhaustion and Player Escalation follows | TEST IMPLEMENTED |
| Positive Field-Exit Settlement | removed from live D-0147 Control/Candidate path | RETIRED by v4.7.122 test |
| Vehicle Activity Context / Actuation Neutralisation | v4.7.119/v4.7.120 mechanics reused unchanged in principle, now around INFIELD phase | PRESERVED |
| External Yield | no v4.7.122 candidate expression; stronger admissibility proof remains unresolved | NOT ATTEMPTED |
| Productive exclusion zones / parking search | absent | INTENTIONALLY NOT IMPLEMENTED |

---

# v4.7.121 D-0147 architecture/code alignment — Terminal Yield canonical candidate

| Governing concept | v4.7.121 candidate implementation | Alignment |
|---|---|---|
| Pending Player Reclamation | completed source-terminated assemblies remain observable and Player Claim remains sticky | PARTIAL / suitable substrate |
| Terminal Yield Consent | legacy `AUTOMATIC_TERMINAL_EGRESS` gate remains `true` for testing | PARTIAL; rename/UI/default-off deferred |
| Continuity, Not Settlement | current Control still settles the external manoeuvre on Positive Field Exit rather than active-worker continuation | **IMPLEMENTATION GAP** |
| Reactive Terminal Yield | current commitment is one external-egress episode; later independent re-yield is not implemented | **NOT IMPLEMENTED** |
| No Final Settlement Requirement | architecture accepted; current external-egress success still terminates the implementation obligation | **IMPLEMENTATION GAP** |
| Egress Externality Constraint | no adjacent-Field/externality Candidate veto exists yet | **NOT IMPLEMENTED** |
| External Yield | v4.7.120 compact + Vehicle Activity Context + Exit Alignment + field exit + neutralisation | LIVE-SUPPORTED mechanical expression |
| Conflict-Relative Infield Yield | no infield Candidate/control expression exists | **NOT IMPLEMENTED** |
| Deterministic Dispersion | no new tie-break introduced | DEFERRED until spatial alternatives exist |
| Player Claim / Escalation | Player Claim pre-empts; bounded failures can fail/escalate | PRESERVED |

**Canonicalisation boundary:** this candidate deliberately records the architecture/code gap instead of hiding it. No new movement behaviour is introduced while architecture is being reset around the real player objective.

---

# v4.7.120 D-0147 architecture/code alignment — Exit Alignment continuation

| D-0147 concept | v4.7.120 production test implementation | Alignment |
|---|---|---|
| Genuine productive completion remains ended | Vehicle Activity Context remains physical-only; no GIANTS AI job and no `getIsAIActive()` override | Preserved / live-supported |
| Outward Reference is not trajectory | Candidate selects the nearest outer boundary and derives one Exit Alignment from current heading + outward reference | Preserved |
| Exit Alignment governs crossing orientation | Candidate supplies `exitDirectionX/Z`; no terminal destination point is supplied | Corrected from v4.7.119 evidence |
| Kinematic Egress Lead-In + continuation is one manoeuvre | `PostJobActuationAuthority.driveInWorldDirection()` holds the same world direction through GIANTS `driveInDirection()`; steering naturally reduces as heading aligns | Production expression |
| Positive Field-Exit Settlement is authoritative | Control has no target-arrival success/failure branch and continues until the represented compact footprint is positively outside | Preserved and strengthened |
| Bounded authority | existing watchdog, Player Claim/source reactivation, neutralisation and Vehicle Activity Context release bound the manoeuvre | Preserved |
| No route/parking search | no alternate direction/boundary, retry, reverse rescue, target extension or parking behaviour | Preserved |

**Abstraction boundary:** `driveInDirection()` is a mechanical actuator only. AutoDrive supplied implementation evidence for using that GIANTS surface outside a GIANTS job; AutoDrive route/task architecture is not imported.

# v4.7.119 D-0147 architecture/code alignment — Terminal Egress Vehicle Activity Context

| D-0147 concept | v4.7.119 production test implementation | Alignment |
|---|---|---|
| Genuine productive completion remains ended | `forceIsActive` is asserted only as physical vehicle activity; no AI job/Job Episode is started and `getIsAIActive()` is not overridden | Preserved |
| One bounded Oblique Boundary Egress | Candidate objective and curvature actuator are unchanged from v4.7.118 | Preserved |
| Post-job steering must be physically realisable | `PostJobActuationAuthority.acquireVehicleActivityContext()` captures prior `forceIsActive` and asserts it only for EGRESS | New implementation expression of live evidence |
| Player Claim / source reactivation outrank OuttaMyWay | no post-claim/post-reactivation drive or neutralisation; temporary activity context is still restored | Preserved |
| Actuation must not remain latched | owned exits neutralise before activity-context release | Preserved |
| Reality validates assumptions | telemetry now includes realised `isActive`, `forceIsActive`, `rotatedTime`, CrabSteering state and wheel steering angles | Preserved |

**Abstraction boundary:** Vehicle Activity Context is mechanical execution support, not a traffic concept, parking policy, route plan or productive-intent claim. Candidate, Situation and Commitment semantics are unchanged.

---

# v4.7.118 D-0147 architecture/code alignment — steering-state handoff diagnostic

| D-0147 concept | v4.7.118 production test implementation | Alignment |
|---|---|---|
| Oblique Boundary Egress | Candidate geometry and fixed target unchanged from v4.7.117 | Preserved |
| Post-job mechanical command | Existing bounded-curvature command unchanged | Preserved; no new steering hypothesis |
| Deferred steering realisation | `PostJobActuationAuthority` exposes read-only steering telemetry: `rotatedTime`, CrabSteering state/AI mode, steerable-wheel physics angles/ranges | Diagnostic observation only |
| Actuation Neutralisation | After owned EGRESS actuation, success/failure/exhaustion neutralises steering demand + wheel propulsion/braking before Control release | Safety correction from live v4.7.117 evidence |
| Player Claim / source reactivation | Higher authority suppresses all later OuttaMyWay actuation, including neutralisation | Preserved |
| Positive Field-Exit Settlement | v4.7.116 live-supported implementation unchanged | Preserved |

**Reality boundary:** v4.7.118 does not claim that steering demand is overwritten, ignored by CrabSteering, or lost elsewhere. The live telemetry exists to distinguish those cases before another steering implementation is attempted.

---

# v4.7.117 D-0147 architecture/code alignment — explicit curvature steering realisation

| D-0147 concept | v4.7.117 production test implementation | Alignment |
|---|---|---|
| Oblique Boundary Egress | Candidate still supplies exactly one fixed oblique world target from compact heading + outward reference | Preserved |
| Kinematic realisation | `PostJobActuationAuthority` transforms that fixed target to current steering-node local space and derives one circular curvature for `AIVehicleUtil.driveAlongCurvature()` | Mechanical implementation only |
| Straight-out case | Local lateral displacement of zero yields zero curvature; no special vehicle/scenario gate | Preserved |
| Positive Field-Exit Settlement | v4.7.116 representation/boundary witness retained unchanged | Live-supported and preserved |
| One-manoeuvre complexity boundary | Same fixed target throughout; target behind without positive exit exhausts; no alternate path/angle/boundary/retry | Preserved |
| Player Claim | `vehicle:getIsEntered()` checked before every curvature/stop actuation | Preserved |

**Reality boundary:** v4.7.117 does not assert that post-job curvature steering will work. It is a production E&OE attempt using GIANTS' explicit curvature steering primitive after `driveToPoint()` failed to change heading live.

---

# v4.7.116 D-0147 architecture/code alignment — post-job steering correction

No architectural contract changes from v4.7.115. This tranche corrects two implementation mismatches exposed by TS016 v4.7.115.

| D-0147 concept | v4.7.116 production test implementation | Alignment |
|---|---|---|
| Oblique Boundary Egress | Candidate remains unchanged semantically; `PostJobActuationAuthority` now supplies GIANTS the full steering-node local target **position** via `worldToLocal()` rather than a normalized direction | CORRECTED, LIVE VALIDATION REQUIRED |
| Outward Reference / boundary evidence | Candidate/Control traverse and copy immutable outer-boundary data through `ValueRecord.length/ipairs` | CORRECTED |
| Positive Field-Exit Settlement | Same represented AABB/disc witnesses as v4.7.115; now receives the preserved outer-boundary value | PRESERVED, LIVE VALIDATION REQUIRED |
| Terminal Resolution Commitment | Sticky through compaction and one egress | PRESERVED |
| Player Claim | `vehicle:getIsEntered()` before direct post-job actuation | PRESERVED |
| Exhaustion | One manoeuvre only; no alternate route/angle/boundary | PRESERVED |

TS015/TS016 live reruns remain final authority.

---

# v4.7.115 D-0147 architecture/code alignment — Oblique Boundary Egress production test

| D-0147 concept | v4.7.115 production test implementation | Alignment |
|---|---|---|
| Terminal Resolution Commitment | Existing committed Terminal Occupancy proceeds through compaction and egress despite transient obstruction disappearance | TEST IMPLEMENTED |
| Outward Reference | `TerminalEgressCandidateSupport` identifies one nearest local outer-boundary reference; islands remain excluded | TEST IMPLEMENTED |
| Exit Alignment | Candidate consumes compact current heading and outward reference; materially outward heading may be retained, otherwise a deterministic heading/outward bisector supplies the oblique direction | TEST IMPLEMENTED, E&OE |
| Oblique Boundary Egress | Candidate projects the single exit direction to its first outer-boundary crossing and one bounded outside target; Control receives geometry but invents none | TEST IMPLEMENTED |
| Positive Field-Exit Settlement | `TerminalEgressControl` accepts sufficient disjoint represented/Field World bounds or the represented-disc/polygon witness; no second fold-state qualification | TEST IMPLEMENTED |
| Player Claim | `vehicle:getIsEntered()` checked before every direct post-job actuation call | PRESERVED |
| Exhaustion | Target/watchdog/control failure settles FAILED; no alternate trajectory is generated | PRESERVED |

TS016/TS015 live reruns remain final authority.

---

# v4.7.114 D-0147 architecture/code alignment — decisive Terminal Egress production test

| D-0147 concept | v4.7.114 production test implementation | Alignment |
|---|---|---|
| GIANTS Completion Acceptance remains default | No D-0147 admission without positive Terminal Occupancy and enabled config switch | ALIGNED |
| Terminal Occupancy relevance | `TerminalOccupancyAssessment` over genuinely ended source-terminated assemblies and continuing active demand | TEST IMPLEMENTED |
| Terminal Resolution Commitment | Existing D-0147 Commitment survives transient loss of initiating obstruction through compaction and egress | TEST IMPLEMENTED |
| Post-Job Actuation Authority | Distinct `POST_JOB_ACTUATION` token plus `PostJobActuationAuthority` direct GIANTS drive primitive | TEST IMPLEMENTED |
| Player Claim for completed assembly | Sticky `vehicle:getIsEntered()` witness; checked before every post-job drive/stop call | TEST IMPLEMENTED |
| Mandatory supported compaction | `TerminalEgressControl` with existing configuration mechanical donor | TEST IMPLEMENTED |
| Boundary-Normal Egress Objective | `TerminalEgressCandidateSupport` selects exactly one nearest outer-boundary objective | TEST IMPLEMENTED |
| Decisive positive Field World exit | Control consumes Observation-owned current represented footprint; target radius is not success authority | TEST IMPLEMENTED |
| One simple bounded outward manoeuvre | One Candidate target; target reached without positive exit exhausts; no extension/alternate boundary/retry | TEST IMPLEMENTED |
| Automatic Terminal Egress user switch | `config.lua`; development/test default `true` | TEST IMPLEMENTED; UI/FUTURE PRODUCT DEFAULT DEFERRED |
| Terminal Egress Exhaustion -> player | `FAILED` terminal settlement; no autonomous second attempt | TEST IMPLEMENTED |

**Live evidence boundary:** TS015 showed the complete v4.7.113 compaction/egress mechanics can work; TS016 showed that compaction-only settlement can be a false success because later GIANTS manoeuvring demand may return through the same completion position. v4.7.114 therefore keeps the bounded architecture but changes responsibility persistence and the positive success witness. Live TS015/TS016 reruns remain final authority.

---

# v4.7.105 D-0146 implementation-alignment addendum — Optional Configuration Reduction

**Architecture already says:** Passage Arrangement may use optional configuration reduction; configuration reduction is not a universal prerequisite.

**v4.7.103 misalignment:** generic D-0146 execution inherited the historical compact-both mechanical sequence and interpreted GIANTS fold-interface presence as authority to wait for Compact Configuration.

**v4.7.105 alignment:** `LocalPassagePlanner` owns the per-participant passage-expression demand (`COMPACT_REQUIRED` / `RETAIN_CURRENT`); `LiveTrafficCandidateSupport` transports it; `CooperativePassageControl` revalidates and executes only required changes, with selective restoration. ConfigurationAuthority remains an actuator/evidence donor and does not decide passage need.

The bounded 6 m participant reserve remains implementation calibration. It does not amend D-0146 Nominal Inter-Assembly Clearance or create generic negative-clearance authority.

---

# v4.7.103 D-0146 implementation-alignment addendum

No new architectural concept is introduced. The 2026-08-13 evidence demonstrated three code/authority mismatches against already-settled D-0146:

1. `PassageCapabilityAssessment` had vehicle-name policy where architecture requires current mechanical evidence. **Corrected:** Situation grants only purpose-specific mechanical preflight from current representation/configuration; Control remains authority for actual capability.
2. `LocalPassagePlanner` treated the selected pair in isolation. **Corrected:** other active Operation assemblies constrain Local Passage Space through positive current physical occupancy and are recorded in the Candidate-supplied Guide support.
3. D-0141 historical purpose retention could outlive positive current relationship evidence. **Corrected:** Situation computes D-0146 opposed relationships before follower reassessment; established opposed conflict / established post-passage relation positively retires the old follower purpose.

Authority remains protected: Situation owns Knowledge/fitness; Candidate owns Passage search/Guide; Decision/Commitment remain normal; Control may execute or reject the supplied Guide but may not invent replacement geometry. Third parties are constraints, not silently added Commitment participants. D-0143 remains regression/mechanical donor only.

---

# v4.7.102 D-0146 Step-2 validation/provenance addendum

No architecture-to-code ownership changes are introduced in v4.7.102. The v4.7.101 active chain remains authoritative in code: Situation-owned trajectory/conflict Knowledge -> Candidate-owned Local Passage Search/Passage Guide -> normal Decision/Commitment -> central Control. The 2026-08-12 TS015 run supplied three successful live executions. v4.7.102 changes release identity/provenance only so the validated implementation can be reviewed under one exact candidate fingerprint.

---

# v4.7.101 D-0146 Step-2 architecture/code alignment

| Architectural concept | Runtime owner | Alignment |
|---|---|---|
| Established Trajectory / Persistence | `TrajectoryConflictAssessment` under Situation | ALIGNED; v4.7.100 live supported |
| Established Opposed Corridor Conflict | `TrajectoryConflictAssessment` under Situation | ALIGNED; consumed, not re-derived downstream |
| Passage Presumption / Local Passage Space | `LocalPassagePlanner` under Candidate responsibility | ACTIVE bounded implementation |
| Progressive Passage Search / Passage Sufficiency | `LocalPassagePlanner` | ACTIVE; satisfices first lowest-burden supported expression |
| Pairwise Passage Economy | `LocalPassagePlanner` + normal Decision | ACTIVE; symmetric/asymmetric/unilateral expressions |
| Passage Guide | Candidate bridge | ACTIVE; five ordered gates, not fixed Control geometry |
| Passage Support Loss / Reassessment | `CooperativePassageControl` feedback | ACTIVE safe-abandon/escalate branch |
| Mechanical passage capability | `PassageCapabilityAssessment` | PURPOSE-SPECIFIC P23 BOUND; generic authority not claimed |

**Discovery recorded:** **Semantic Generalisation / Mechanical Boundedness** — generic D-0146 conflict/passage semantics may be implemented while mechanical actuation remains purpose-specific until representation/evidence justifies broader authority. This prevents old TS015 geometry from becoming architecture while also preventing speculative generic clearance claims.

---

# v4.7.100 D-0146 Step-1 architecture-to-code alignment

This build closes only the previously recorded Step-1 architecture/implementation gap.

| D-0146 responsibility | v4.7.100 implementation owner | Authority |
|---|---|---|
| Established Trajectory persistence | `SituationAssessment` + `TrajectoryConflictAssessment` | Situation Knowledge |
| Current Excursion / trajectory supersession | `TrajectoryConflictAssessment` persistent state | Situation Knowledge |
| Supported Corridor Overlap | `TrajectoryConflictAssessment` consuming existing positive cached physical primitives | positive-support Knowledge only; no negative-clearance authority |
| Potential / Established Opposed Corridor Conflict | `TrajectoryConflictAssessment`, published by `SituationAssessment` | passive Situation Knowledge |
| diagnostics | `PassiveLiveValidator` | evidence only |
| Candidate / Decision / Commitment / Control response | unchanged | new Step-1 Knowledge has no consumer in this build |

The implementation deliberately does **not** create a second Observation source, head-on Candidate path or controller. It reuses existing current motion and cached physical occupancy evidence. Numerical persistence/filter values are implementation calibration, not D-0146 architecture. Generic Step 2 remains an architecture/implementation gap.

---

# v4.7.99 D-0146 architecture-to-code alignment addendum

**Baseline:** owner-declared canonical v4.7.98 (`105462f44b902312e5dc63c6176d44f848f15c1466d942a4bee70635ced6cd69`; Git `982992b926839c854f6d4d7979fe24885e267eae`; 307 files).

This candidate deliberately creates an **architecture/implementation gap** rather than speculative code. No live module is added for Established Trajectory, Opposed Corridor classification, Local Passage Space search, Passage Arrangement generation, Passage Guide construction or Passage Reassessment.

The v4.7.98 Cooperative Passage control path, purpose-specific Representation Fitness, D-0141 follower Regulation and all physical calibration remain behaviourally unchanged. Only version/build/provenance identity and documentation are changed.

Next implementation work must map each D-0146 responsibility onto existing layers before coding, beginning with Situation-owned Step-1 Knowledge.

---

# v4.7.98 Architecture-to-Code Alignment — D-0144 Consolidation

**Canonical baseline:** v4.7.95 (`1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`; Git `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`; 305 files).  
**Behaviour donor:** live-successful v4.7.97.

The candidate is reconstructed from canonical v4.7.95, not promoted wholesale from the test lineage. The v4.7.97 Cooperative Passage production delta is reapplied, then D-0144 removes only live sourcing/scheduling for the retired continuous productive-history/refuge diagnostic pipelines.

## Alignment result

| Responsibility | v4.7.98 disposition |
|---|---|
| Productive/Transitional current state | PRESERVE |
| bootstrap-cached assembly/footprint evidence | PRESERVE; no new shape calculations |
| Turning Rank | PRESERVE as optional Situation concept; no new runtime predictor |
| D-0141 follower Regulation | PRESERVE unchanged |
| D-0143 bounded TS015 Cooperative Passage | PRESERVE successful v4.7.97 behaviour unchanged |
| Rook / Successor Rook Set | RETIRE as governing production requirement |
| chessboard / continuous Productive History | RETIRE from live runtime/reasoning |
| King Reserve / continuous Refuge | RETIRE, reaffirmed |
| headland-U-turn scenario solver | RETIRE |
| DemonstratedProductiveCoverageProbe | file retained; UNSOURCED live |
| ProductiveCoverageResidualProbe | file retained; UNSOURCED live |
| RefugeQualificationShadowProbe | file retained; UNSOURCED live |

## Cooperative Passage health boundary

Do not read the successful vertical slice as general completion. Productive/Transitional, asymmetric, other-assembly and generic-clearance support remain unresolved. Current TS015 numeric geometry remains calibration.

## No-behaviour-change intent of the tidy-up

Relative to successful v4.7.97, no Cooperative Passage gate, physical path, speed, target radius, Commitment sequence, D-0141 Regulation calibration or handoff rule is intentionally changed. The only live runtime reduction is removal of the three retired diagnostic event pipelines listed above.

---

# v4.7.97 Architecture-to-Code Alignment — D-0143 First Production Slice

**Canonical implementation baseline:** owner-declared v4.7.95 (`1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`; Git `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`; 305 files).  
**Implementation evidence build:** v4.7.97 TEST BUILD, non-canonical.

D-0143 is already canonical architecture. v4.7.97 repairs the smallest production-coupling defect exposed by v4.7.96: the Cooperative Passage Candidate now consumes D-0143 purpose-specific Representation Fitness derived from existing Situation `physicalSpaceEvidence` instead of generic structurally-invalid scalar representations. No new shape calculation is added. It does not migrate P23 wholesale, revive King, or add a parallel head-on solver.

## v4.7.97 alignment result

The first vertical slice is implemented end-to-end:

`Situation Assessment → Operational Picture → joint Candidate → Mandatory Constraints → Traffic Policeman/Decision → Commitment → joint Authority → Control → GIANTS handoff`

Situation Assessment now owns the narrow TS015 support decision. Candidate generation consumes that published Knowledge. Commitment owns both progress participants under one purpose/composition. Control receives typed requests and performs only the selected physical sequence. Positive handoff terminally settles the Commitment immediately; there is no post-handoff cooldown.

The implementation deliberately withholds unsupported asymmetric geometry and does not claim generic negative-clearance authority. Current 50-70 m / 2 m lateral / +/-6 m / 12 m / 8 m / 8 km/h values remain bounded TS015 calibration, not architecture.

Live validation is the next authority check.

## Surviving-concept implementation map

| Architectural concept/layer | v4.7.77 status | Alignment consequence |
|---|---|---|
| Field World identity/equivalence | strong existing owner/donor | preserve |
| raw GIANTS Observation | strong donors, semantic leakage present | preserve facts; strip semantic promotion over time |
| Configuration-Dependent Assembly Footprint | strong representation donor | preserve/extend only as required by TS015 admissibility |
| Productive Regime / Rook and productive-history Knowledge | partial production/shadow evidence | reuse current Situation ownership; do not rebuild broadly before TS015 |
| Successor Rook Set / bounded Transitional Demand | architecture survives; implementation incomplete | retain architecture; implement only where TS015 coupling genuinely requires it |
| King Reserve Availability | absent/experimental post-canonical implementation lineage | **RETIRE; do not implement** |
| continuous Refuge discovery/qualification | experimental post-canonical lineage | **RETIRE; do not optimise or promote** |
| Configuration-Released Space support | **implemented narrowly in v4.7.97** via `CooperativePassageAssessment` | live-validate the bounded TS015 Knowledge gate before broadening |
| Cooperative Passage Candidate | **implemented narrowly in v4.7.97** as one joint multi-assembly `REPOSITION` | live-validate selection and ownership; do not generalise yet |
| positive cooperative relevance | partial through existing admission/Future-Space evidence | re-express/use without creating a new head-on subsystem |
| Candidate Action Space | joint TS015 `REPOSITION` added through normal Candidate ownership | live-validate; preserve normal Candidate ownership |
| Mandatory Constraints | structural skeleton exists; some verdicts remain candidate/pass-through | independently gate the new Candidate using existing contracts; no fake clearance authority |
| Traffic Policeman / Decision | existing owner reused by v4.7.97 | live-validate Cooperative Passage selection after ordinary preference-band exhaustion |
| Commitment/Obligations | joint purpose/restoration-handoff obligation implemented in v4.7.97 | live-validate same-Commitment succession and immediate reusability |
| Bounded Authority | joint token ownership/composition implemented in v4.7.97 | live-validate two-participant authority ownership |
| Control | production `CooperativePassageControl` added in v4.7.97 using proven physical donors | live-validate physical sequence; no semantic selection in Control |
| post-handoff observation | diagnostic donors exist | separate from Commitment/Control; no cooldown |
| asymmetric passage solver | unsupported by v4.7.94 boundary evidence | **DO NOT IMPLEMENT in TS015 tranche** |

## Explicit implementation constraints

- Do not source `Prototype23` as a parallel production controller. P23 is evidence/donor material only.
- Do not restore `HEAD_ON` as a governing solver class. The first authority envelope may recognise supported opposed geometry within Situation Assessment.
- Do not add continuous King/Refuge geometry, certificates or performance work.
- Do not silently convert incomplete Physical Assembly representation into negative clearance authority.
- Do not make the 70 m / 6 m / 12 m / 8 m / 8 km/h P23 fixture values architectural constants. If temporarily reused for TS015 closure, keep them isolated and visibly fixture-derived/calibrated.
- Do not let passive recovery observation retain an AuthorityToken, Commitment ownership or lockout.

## First implementation build — TS015 Cooperative Passage Production Integration

Implement one narrow end-to-end slice:

1. Situation Assessment publishes the positive facts/Knowledge required to recognise the demonstrated near-collinear Condor/Patriot opposed-working class.
2. Candidate generation exposes one complete joint Cooperative Passage `REPOSITION` when supported.
3. Mandatory Constraints gate capability, configuration and currently available spatial/demand evidence.
4. Traffic Policeman / Decision selects it only when the physical conflict requires Reposition and earlier preference bands cannot resolve the established incompatibility.
5. Commitment owns stop/compact/separate/pass/rejoin/restore/handoff obligations for both assemblies under one governing purpose.
6. Bounded Authority and Control execute the current phase using proven physical donors.
7. Handoff releases Control immediately; later observation is passive.
8. Unsupported asymmetric geometry is rejected rather than expanded.

Live TS015 evidence, not further prototype work, decides the next increment.

---

## 11. D-0141 — aligned follower boundary-demand restoration

D-0140's live Authority Reset supplied the missing positive counterexample: removing follower actuation entirely allowed a genuine current co-directional line-astern boundary encounter to consume Action Space and deadlock. D-0141 therefore restores the accepted D-0124 follower-protection concept without restoring the old cross-layer implementation.

The aligned chain is:

`Native Observation → Situation current Adjacent Following + Provisional Boundary Demand → Candidate → Constraints → Traffic Policeman Decision → Commitment/Obligation → LiveControlDispatcher → P22 Regulation lease`.

`FollowerBoundaryDemandAssessment` does not consume historical native manoeuvre observations. Current adjacency is derived from current Productive/Settled continuations and productive-corridor overlap. The Provisional Demand Seed uses working width plus an explicitly temporary temporal seed. D-0138 native max speed supplies only the current unrestricted rate. Zero command is unresolved.

Purpose and magnitude are separate: the Commitment owns a sticky `PRESERVE_BOUNDARY_TRANSITION_ORDERING` purpose; the dispatcher applies the currently selected cap and may update it upward or downward. D-0139 Progress Passage supplies positive retirement. The legacy follower probe remains downstream shadow for forensic comparison only.

This is an authority restoration under the D-0140 boundaries, not a rollback of D-0140. Native manoeuvre boundary-demand fitness remains `UNRESOLVED`; D-0131/D-0133 remains shadow; Diagnostics remain non-actuating.

### v4.7.75 integrated live closure

The 2026-08-10 TS015 run completed the full working session. The final role-reversed head-on exercised the same-Commitment authority succession path (`REVISE_HEAD_ON` with one reused token), after which the established Reposition/Refuge mechanism proceeded instead of being refused. Both Job Episodes ultimately ended. The owner manually moved completed Patriot at the very end so Condor could reach the final few metres; that terminal physical-occupancy limitation is parked and does not alter D-0140/D-0141 architecture.

# Architecture-to-Code Alignment — D-0140 Authority Reset

**Owner-declared canonical baseline:** v4.7.49  
**Canonical SHA-256:** `a64829ed9f57a868d226ec74115f23fd02659e5adeb748e566cb8cdacf1de895`  
**Implementation evidence snapshot:** v4.7.69 TEST BUILD, non-canonical  
**Historical D-0140 alignment status at v4.7.76 preparation:** v4.7.75 behaviour was live-validated and packaged as the v4.7.76 candidate; v4.7.76 has since been explicitly owner-declared canonical and is the implementation baseline for D-0142.

## 1. Purpose

This document records the global implementation alignment performed after the v4.7.69 live run exposed a latent remote follower-Regulation failure. The purpose is not to fix that single symptom. It is to restore the accepted architecture as the authority boundary for the accumulated v4.7.50–v4.7.69 implementation lineage.

The governing architecture remains:

```text
Reality
  -> Observation
  -> Situation Assessment / Knowledge
  -> Candidate Action Space
  -> mandatory Constraints
  -> Traffic Policeman Decision
  -> Commitment / Obligations
  -> Authority
  -> Control
  -> GIANTS / physical Reality
```

Diagnostics may observe every boundary. Diagnostics grant authority nowhere.

## 2. Triggering discoveries

### Architectural Authority Dispersion

Post-canonical experiments accumulated semantic and physical authority in modules originally introduced as probes or bounded bridges. In particular, follower/maturation diagnostics acquired Regulation leases, retained Future-Space authority, interpreted purpose lifecycle and consumed P22 fixture phase directly.

The individual ideas were often evidence-supported. Their ownership was not aligned with the canonical layer model.

### Layer Responsibility Leakage

The alignment inventory found responsibility leakage on both sides of v4.7.49:

- `PassiveLiveValidator` was causally upstream of live Runtime processing and P22 dispatch.
- Productive Continuation semantics were supplied to Candidate generation by a diagnostic probe rather than Situation Assessment.
- post-canonical follower diagnostics could acquire physical speed authority directly.
- the bounded D-0123 Guarded-Recovery bridge derived semantic threat and applied Regulation inside one prototype bridge.

These are implementation shortcuts, not architectural concepts.

### Boundary-Manoeuvre Demonstration Overreach

Live v4.7.69 evidence showed a native GIANTS Transitional/reposition manoeuvre could be tens of seconds and hundreds of metres long yet mature into a demonstrated boundary-return envelope. That envelope then manufactured a remote follower relationship and ultimately a 0 km/h Regulation.

Native provenance establishes who moved the worker. It does not establish Representation Fitness for a specific semantic use. `turn=true`, heading reversal or near-boundary origin cannot alone promote a native manoeuvre into boundary-demand authority.

## 3. Alignment decision — Authority Reset

D-0140 performs an **Authority Reset**, not a source-code revert.

Useful post-canonical Observation and diagnostic mechanisms are retained where they preserve evidence. Experimental authority is withdrawn unless it is rebuilt through the canonical chain.

The aligned rule is:

> A component may only exercise the responsibility assigned to its architectural layer. Evidence may move upward through explicit contracts; authority may move downward only through Decision, Commitment and Control contracts.

Consequences:

1. Raw GIANTS facts enter Observation without semantic promotion.
2. Situation Assessment alone publishes Productive Continuation and Guarded-Recovery threat Knowledge used by Decision.
3. Candidate generation consumes sealed Operational Picture Knowledge rather than diagnostic caches.
4. Traffic Policeman Decision selects but does not actuate.
5. Commitment owns continuing purpose, obligations and actuation ownership.
6. `LiveControlDispatcher` is the only automatic live bridge from selected physical action / supporting authority to the bounded P22 capability donor.
7. P22 executes typed Control requests and reports Control outcomes; it does not define traffic meaning.
8. Diagnostics are downstream consumers only.
9. D-0124–D-0133 follower/committed-transition actuation is reset to shadow pending Representation-Fit Knowledge and central Decision/Commitment integration.
10. D-0123 Guarded Recovery remains bounded live behaviour because its architectural meaning is established; its implementation is migrated into the canonical chain rather than grandfathering the old direct bridge.

## 4. Aligned runtime responsibility map

| Layer | Primary active modules | Consumes | Publishes / owns | Physical authority |
|---|---|---|---|---|
| Observation | `LiveObservationSource`, `NativeFieldWorkObservation`, `NativeManoeuvreObservationSource`, P22 Control-execution observation | GIANTS/runtime facts | immutable/raw evidence | No |
| Situation Assessment | `SituationAssessment`, `GuardedRecoveryThreatAssessment`, `ProgressionGeometry`, `RepresentationFitness` | raw Observation + prior valid Knowledge | Operational Picture Knowledge, provenance, Representation Fitness, uncertainty | No |
| Candidate | `LiveTrafficCandidateSupport` | sealed Operational Picture | complete supportable Candidate Action Space | No |
| Constraints | `ConstraintEngine` | Candidates + Knowledge | mandatory verdict sets | No |
| Decision | `DecisionSelector`, `TrafficPolicemanDecisionPolicy` | admissible Candidates/verdicts | Decision Record / temporary traffic ordering | No |
| Commitment | `LiveTrafficCommitmentLifecycle`, registries/ledger/state machine | Decision + existing Commitment | obligations, purpose continuity, supporting authority composition | Owns authority semantics; does not actuate |
| Control dispatch | `LiveControlDispatcher` | sealed Decision + Commitment + Authority tokens | typed `ControlRequest`, `ControlOutcome` | **Yes, bounded bridge only** |
| Capability | `Prototype22CapabilityGate` + P22 donors | valid typed Control request | realised bounded physical effect + raw execution observation | Executes authorised request only |
| Diagnostics | validator, HUDs, Productive/D-0134/D-0136/D-0138/follower probes | already-produced Observation/Knowledge/Decision/Control outcomes | logs, HUD, forensic evidence | **Never** |

## 5. Specific implementation changes

### 5.1 Runtime ownership

`LiveRuntimeCoordinator` now owns the live cycle:

```text
capture raw Observation
  -> Runtime assessment/decision
  -> central Control dispatch
  -> diagnostics receive the resulting cycle
```

`PassiveLiveValidator` no longer initiates Runtime processing or calls P22.

### 5.2 Productive Continuation

GIANTS field-worker line/turn state is captured by `NativeFieldWorkObservation` as raw Observation. Situation Assessment promotes positive Productive Continuation only from coherent positive evidence and publishes it in the Operational Picture.

Diagnostic `ProductiveContinuationProbe` is a facade over Situation-owned Knowledge. Candidate generation no longer consumes a diagnostic source.

This preserves **Productive-State Evidence Asymmetry**: positive coherent work-line evidence may support Productive; non-positive/inactive line evidence alone does not prove Transitional.

### 5.3 Native manoeuvre evidence

The active `HeadlandManoeuvreSweepProbe` role is replaced by `NativeManoeuvreObservationSource`.

It may measure a completed native manoeuvre and preserve D-0127 deferred closure evidence, but every such observation explicitly carries:

`representationFitnessForBoundaryDemand=UNRESOLVED`

and no semantic boundary-demand or Control authority.

Therefore a long GIANTS reposition/turn cannot become follower demand merely because it reversed heading near a boundary.

### 5.4 Follower / committed-transition reset

`FollowerMaturationCompressionProbe` is diagnostic-only. It owns no DriveAuthority and can acquire no Regulation lease. Its calculated envelopes/caps are forensic shadows until a separate Situation-level Representation-Fitness contract exists.

`CommittedTransitionRegulationTestBridge` is likewise passive/shadow. D-0131/D-0133 evidence may remain measurable; it cannot actuate.

The accepted architectural lessons remain recorded for future reintegration:

- D-0124 boundary-demand protection concept;
- D-0125 strategy succession;
- D-0127 evidence lifecycle;
- D-0129 progression preservation / self-satisfaction;
- D-0130 persistent purpose with **elastic** Control magnitude;
- D-0131 committed-transition protection;
- D-0132/D-0133 evidence continuity.

### 5.5 Guarded Recovery D-0123

The old automatic `GuardedRecoveryRegulationTestBridge` is excluded from active runtime loading.

P22 publishes raw recovery execution state. Situation Assessment derives Vulnerable Space / Convergent Projection threat Knowledge. Candidate generation publishes `CONTINUE_OBSERVATION` or `REGULATE_SPEED` under the existing Commitment. Decision may `MAINTAIN` the existing Commitment. `LiveTrafficCommitmentLifecycle` adds/removes only the supporting Progress authority. `LiveControlDispatcher` applies/releases the typed Regulation request through P22.

`UNRESOLVED` preserves an already-admitted supporting Regulation lease; positive current clearance releases only that Progress Regulation authority. The Yield recovery authority remains until its own obligation settles.

### 5.6 Refuge and later evidence probes

D-0134 Refuge qualification remains passive. P22 publishes a neutral fixture observation; the diagnostic probe consumes it downstream. No coverage, centroid, headland or command-target heuristic is promoted.

D-0136 intent-based residual settlement remains passive Knowledge/evidence work. Its persistent-track → observation-worker Future-Space adapter is retained.

D-0137 remains falsified and inactive.

D-0138 remains **Immediate Native Drive Command Surface** Observation only. It is not a continuation horizon or Refuge-selection signal.

D-0139's architectural lesson—purpose succession / Progress Passage—is retained. The special-case follower/P22 implementation is removed because follower actuation is shadow during the Authority Reset. Any future active implementation must express purpose succession centrally through current Knowledge, Decision and Commitment rather than inspecting a P22 phase as semantic authority.

## 6. Post-v4.7.49 disposition

| Decision / discovery | Architectural status after alignment | Active authority status |
|---|---|---|
| D-0124 follower boundary demand | Retain concept | Shadow only |
| D-0125 strategy succession | Retain | Central lifecycle principle; follower implementation shadow |
| D-0126 0.90 factor | Calibration only | No architectural authority |
| D-0127 deferred evidence closure | Retain evidence-lifecycle principle | Observation/shadow only |
| D-0128 current-picture re-admission | Retain principle; reject fixture-fit literals as policy | Shadow only |
| D-0129 progression preservation | Retain | Architectural/conformance requirement |
| D-0130 purpose preservation | Retain **sticky purpose / elastic cap** architecture; tighten-only implementation rejected | Follower Control reset |
| D-0131 committed-transition protection | Retain concept | Shadow only |
| D-0132/D-0133 evidence continuity | Retain | Evidence only; no follower Control |
| D-0134 Productive Coverage / Refuge shadow | Retain passive historical Knowledge | Passive |
| D-0135 Productive residual | Retain supporting Potential-Demand evidence | Passive |
| D-0136 intent-based residual settlement | Retain positively supported evidence lifecycle | Passive |
| D-0137 vehicle-level drive signal | Falsified | Removed from active interpretation |
| D-0138 immediate field-worker drive command | Retain Observation surface | Passive |
| D-0139 Progress Passage purpose succession | Retain architectural purpose-lifecycle discovery | No follower special-case authority during reset |

## 7. Explicitly unresolved / parked

This alignment deliberately does **not** invent solutions for:

- production Refuge ranking / Resulting Situation completion;
- Native Course Continuation beyond the immediate D-0138 command;
- production follower boundary-demand Representation Fitness;
- Durable Separation completion;
- production speed calibration;
- Provisional Demand Seed;
- Reverse Actuation Discovery;
- static-object navigation / bypass;
- general production Control.

The TS015 Refuge mechanism remains a bounded fixture/capability donor, not production Refuge selection authority.

## 8. Offline conformance gates

Before a live alignment build may be packaged:

- diagnostics, Observation, Assessment and Candidate layers contain no physical-authority acquisition calls;
- active runtime does not load the historical direct D-0123 Regulation bridge;
- Runtime-owned coordinator precedes diagnostics in live event ordering;
- Productive semantic authority is Situation-owned;
- native manoeuvre boundary-demand Representation Fitness remains `UNRESOLVED` unless a future explicit qualifier proves otherwise;
- follower/committed-transition Control flags remain disabled and their modules cannot acquire leases;
- D-0123 positive threat follows Situation → Candidate → Decision → Commitment → central Control → P22;
- D-0123 `UNRESOLVED` preserves existing admitted Regulation without manufacturing release;
- D-0123 positive clearance releases only supporting Progress authority;
- all structural, behavioural and Lua parse tests pass.

## 9. Live validation objective

The first integrated alignment live test is a **whole traffic-story validation**, not a local defect retest. It should exercise, where Reality naturally supplies them:

1. initial head-on admission and bounded Refuge relocation;
2. Refuge wait, Progress Passage and Guarded Recovery;
3. active-recovery D-0123 Regulation through the central authority path;
4. GIANTS reacquisition without false traffic settlement;
5. long Transitional/reposition manoeuvres without follower Control authority;
6. absence of remote/far-corner 0 km/h follower Regulation;
7. D-0136 settlement evidence where naturally available;
8. D-0138 immediate-command evidence remaining passive.

A failure should be classified against the architectural chain before any new local patch is proposed.
