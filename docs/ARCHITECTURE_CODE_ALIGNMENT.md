# v4.7.77 Architecture-to-Code Alignment Baseline — D-0142

**Canonical implementation baseline:** owner-declared v4.7.76 (`7cc2db3fcd02ca7979acfafe81f7765344a70275a11de9754594bde8fed4aeaf`; Git `4758a3428f9bcba23093f60edfd0087bb87843ab`).  
**Candidate:** v4.7.77 architecture/documentation only.

This section supersedes earlier module-migration assumptions where they conflict with D-0142. The audit now maps only **surviving architectural concepts**. Old code first passes the Preserve / Re-express / Retire Supersession Filter.

## Surviving-concept implementation map

| Architectural concept/layer | v4.7.76 status | Alignment consequence |
|---|---|---|
| Field World identity/equivalence | strong existing owner/donor | preserve |
| raw GIANTS Observation | strong donors, semantic leakage present | strip semantic promotion over time |
| Configuration-Dependent Assembly Footprint | strong representation donor | promote phase-specific fitness semantics in Situation |
| positive productive work evidence | strong donor | promote to production Knowledge |
| Productive Regime / Rook | mostly absent as coherent production Knowledge | implement |
| Successor Rook Set | absent | implement |
| bounded Transitional Demand | absent | implement |
| King Reserve Availability | absent | implement |
| positive cooperative relevance | partial through old Current/Future-Space admission | re-express |
| Resolution-Space Conservation | distributed historical evidence, no generic implementation | implement |
| Candidate Action Space | structural skeleton exists; semantic generation sits in `LiveTrafficCandidateSupport` | replace old scenario-specific content after Knowledge validates |
| Mandatory Constraints | structural skeleton exists; many verdicts are Candidate-authored/pass-through | make independently authoritative after Knowledge validates |
| Traffic Policeman | strong structural donor | preserve; add Conflict Serialization/admission reasoning later |
| Commitment/Obligations | strong core | add durable selected spatial relation/Committed Demand later |
| Bounded Authority | ownership basis exists | strengthen to phase/manoeuvre-specific authority later |
| Control | useful physical donors embedded in superseded P22/orchestration | preserve donors, retire semantic/orchestration leakage |
| Guarded Recovery | live compatibility behaviour | do not expand; validate replacement by generic Committed-Demand protection |
| P22 | superseded prototype | do not migrate as a system |

## Explicit abstraction mismatches in v4.7.76

- Observation creates semantic Future-Space/admission/follower meaning that belongs above Observation.
- Observation uses `COMMITTED_DEMAND` for active-job membership; D-0142 reserves Committed Demand for post-Decision Commitment-derived spatial demand.
- Operational Picture is rewritten with Candidate specifications; D-0142 requires immutable Knowledge-only publication.
- `LiveTrafficCandidateSupport` performs duplicate assessment, representation-fitness promotion, mandatory-verdict manufacture and scenario preselection.
- mandatory Constraint evaluators frequently consume Candidate-authored verdict packets rather than independently evaluating invariants.
- Control/P22 reconstructs participants, selects/qualifies Refuge, interprets recovery safety and mutates Commitment meaning.
- P22 return/rejoin fixture routing is experimental mechanism evidence, not a production concept to relocate.
- HEAD_ON/follower/exactly-two-worker branches are scenario implementations, not governing architectural classes.
- Guarded Recovery is retained only as bounded compatibility behaviour pending proof that generic Committed-Demand protection subsumes it.

## First implementation build — Operational Picture Knowledge Foundation

Implement the production-intent Knowledge layer in one decisive build:

1. Productive Regime / Rook.
2. Positive productive-history colouring.
3. Configuration-dependent footprint Knowledge.
4. Successor Rook Set.
5. Bounded Transitional Demand.
6. King Reserve Availability.
7. Positive cooperative relevance.
8. Resolution-Space state.

Temporary structured logging/shadow comparison is required for validation. The new Knowledge layer is non-authoritative for behaviour during this build: no Candidate, Decision, Commitment, Bounded Authority or Control consumer changes until validation supports promotion.

No P22 cleanup, Guarded-Recovery deletion, Candidate refactor or behavioural routing change belongs in this first build.

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
