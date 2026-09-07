# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are presently realised in source and identifies material architecture-to-code placement or vocabulary lag. It does not preserve implementation chronology; Git history, pull requests, issues and the Engineering Journal own that evidence.

```text
Architecture       -> what responsibilities should exist
Implementation Map -> where those responsibilities currently appear
Source             -> exactly how they are implemented
```

Architectural meaning remains owned by the [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation Model](architecture/SPATIAL_NEGOTIATION_MODEL.md), [Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md), [Configuration architecture](CONFIGURATION.md) and [Naming Conventions](NAMING_CONVENTIONS.md).

# High-Level Strangler Plan

OuttaMyWay is being reconciled incrementally rather than rewritten wholesale:

> **Keep the eyes. Reconcile the brain and spinal cord. Keep the hands.**

- **Eyes** — trusted Reality acquisition, Observation, Field World and physical Representation.
- **Brain and spinal cord** — Situation Assessment, semantic responsibility, obligations, Bounded Authority and execution ordering.
- **Hands** — validated physical Control mechanisms that should be preserved unless Reality disproves them.

The target semantic chain remains:

```text
Reality
   ↓
Observation
   ↓
Situation Assessment
   ↓
Responsibility Transition
   ↓
Current Responsibility
   ↓
Bounded Authority
   ↓
ControlRequest
   ↓
Control
   ↓
Reality
```

Candidate, Constraint and Decision may remain implementation machinery between Situation Assessment and Responsibility Transition where they contribute distinct truthful work. Phase 13 does **not** assume those layers should collapse.

At every intermediate state there must be exactly one authoritative owner of each semantic responsibility. Compatibility machinery may reuse proven mechanics, but parallel old/new semantic authority is not acceptable.

# Programme Status

| Phase | Boundary | Status |
|---|---|---|
| 1–8 | Initial strangler seams, explicit Resolution/Regulation representation and programme groundwork | COMPLETE / accepted for programme progression |
| 9 | Current Responsibility reconciliation and Regulation-to-Passage succession | COMPLETE |
| 10 | Bounded Authority reconciliation | COMPLETE |
| 11 | Reduce `LiveControlDispatcher` to authorised routing/execution | COMPLETE |
| 12 | Retire superseded generic Commitment/orchestration only where unsupported | COMPLETE |
| 13 | Simplify Candidate/Constraint/Decision only where evidence proves duplication | **IN PROGRESS — CONSTRAINT VERDICT OWNERSHIP** |
| 14 | Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming | NOT STARTED |
| 15 | Whole-system validation and architecture-to-runtime review | NOT STARTED |

Accepted Repository State for this map is `main` after PR #61 merge, commit `23370f19f05f912ca9517dcf24ac5930c8fbb5e0`. Canonical authority remains `v0.3.0.0`. The `.18` branch below is an unaccepted Engineering Increment until merged.

# Principal Responsibility Placement

| Architectural responsibility | Principal current source placement | Disposition |
|---|---|---|
| Runtime entry and sequencing | `modDesc.xml` -> `scripts/main.lua`; `scripts/runtime/Runtime.lua`; `scripts/runtime/LiveRuntimeCoordinator.lua` | PRESERVE / keep sequencing explicit |
| Job Episode / Operation / Field World identity | `scripts/identity/JobEpisodeAdmission.lua`, `OperationAdmission.lua`, `FieldWorldSnapshotRegistry.lua`, `FieldWorldEquivalenceAuthority.lua`, `FieldWorldEquivalenceEvaluator.lua` | PRESERVE |
| Current Physical Assembly acquisition | `scripts/observation/CurrentPhysicalAssemblySource.lua` | PRESERVE |
| Current physical pose observation | `scripts/observation/CurrentPhysicalPoseSource.lua` | PRESERVE as factual positive evidence; no semantic or negative-clearance authority |
| Live Observation composition | `scripts/observation/LiveObservationSource.lua` | PRESERVE / decompose only where ownership becomes clearer |
| Physical representation | `scripts/representation/AssemblyRepresentationCache.lua`, `PlanViewFootprint.lua`, `PairSpecificPassageClearance.lua`, `CurrentPhysicalConflictRepresentation.lua` | PRESERVE / positive authority must remain explicit |
| Situation Assessment | `scripts/assessment/SituationAssessment.lua` plus focused assessment collaborators | PRESERVE / later decomposition only where useful |
| Causal Obstruction assessment | `scripts/assessment/CausalObstructionAssessment.lua` | PRESERVE — D-0218 Situation authority |
| Current Responsibility reassessment | `scripts/assessment/CurrentResponsibilityAssessment.lua` | PRESERVE — evidence/reassessment only, not lifecycle authority |
| Prospective spatial constraints | `scripts/assessment/SpatialConstraintAssessment.lua` | PRESERVE pending separate Issue #37 Reality debt |
| Passage capability | `scripts/assessment/PassageCapabilityAssessment.lua` | PRESERVE |
| Candidate construction / planning | `scripts/candidates/`, including `LiveTrafficCandidateSupport.lua`, `TerminalEgressCandidateSupport.lua`, `ObstructionRelocationCandidateSupport.lua`, `LocalPassagePlanner.lua`, `CandidateSpace.lua` | **PHASE-13 AUDIT** — retain planning; remove only proved embedded verdict authority |
| Constraint evaluation | `scripts/constraints/ConstraintEngine.lua` plus four independently owned evaluators | **PHASE-13 RECONCILIATION** — Candidate self-verdict pass-through removed in `.18`; independent bounded questions retained |
| Policy / Decision selection | `scripts/decision/DecisionSelector.lua`, `TrafficPolicemanDecisionPolicy.lua` | **PHASE-13 AUDIT** — retain least-intervention choice if distinct |
| Responsibility Transition Authority | `scripts/responsibility/ResponsibilityTransitionAuthority.lua` and purpose-specific transition modules | PRESERVE as semantic transition authority |
| Follower Regulation transition | `scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua` | PRESERVE |
| Action-Space / Forward Intersection Regulation transition | `scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua` | PRESERVE |
| Cooperative Passage transition | `scripts/responsibility/CooperativePassageResponsibilityTransition.lua` | PRESERVE |
| Completed warm obstruction transition | `scripts/responsibility/CompletedObstructionResponsibilityTransition.lua` | PRESERVE warm-path semantics where still applicable |
| Generic current obstruction relocation transition | `scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua` | PRESERVE — current `(Operation, blocker Physical Assembly)` responsibility |
| Generic retained Commitment / obligations | `scripts/commitment/`, including `CommitmentAdmission.lua`, `DecisionCommitmentBoundary.lua`, `ObligationLedger.lua`, purpose-specific lifecycle modules | RETAIN as substrate where supported; Phase 13 audits remaining semantic leakage |
| Cooperative Passage participant lifecycle | `COOPERATIVE_PASSAGE_LEG` obligations plus current Passage lifecycle/settlement modules | PRESERVE — D-0217 |
| Resolution read-only semantic representation | `scripts/contracts/ResolutionCommitment.lua`, `scripts/responsibility/ResolutionCommitmentAdapter.lua` | PRESERVE |
| Regulation semantic representation | `scripts/contracts/Regulation.lua` | PRESERVE |
| Bounded Authority | `scripts/contracts/BoundedAuthorityGrant.lua`, `scripts/authority/BoundedAuthority.lua` | PRESERVE |
| Regulation physical-authority state | `scripts/authority/RegulationBoundedAuthority.lua`, `ResolutionSpaceProgressionEnvelope.lua` | PRESERVE |
| Mechanical actuation exclusivity | `scripts/authority/AuthorityRegistry.lua` | PRESERVE; exclusivity is not semantic permission |
| Effective actuation composition | `scripts/authority/EffectiveActuationComposition.lua` | PRESERVE |
| Typed Control boundary | `scripts/contracts/ControlRequest.lua`, `ControlOutcome.lua` | PRESERVE |
| Control routing | `scripts/control/LiveControlDispatcher.lua` | PRESERVE as authorised routing/execution boundary only |
| Cooperative Passage physical Control | `scripts/control/CooperativePassageControl.lua` | PRESERVE proven mechanics |
| Warm terminal-egress physical Control | `scripts/control/TerminalEgressControl.lua` | PRESERVE proven D-0147 mechanics |
| Generic obstruction relocation Control | `scripts/control/ObstructionRelocationControl.lua` | PRESERVE bounded cold-blocker actuation |
| Generic obstruction relocation runtime integration | `scripts/runtime/ObstructionRelocationRuntimeIntegration.lua` | PRESERVE explicit sequencing/settlement integration |
| Guarded Recovery | `scripts/control/GuardedRecoveryCompatibility.lua` | RETAIN as explicit legacy compatibility; not precedent for new architecture |

# Phase 13 — Accepted Discoveries and Current Boundary

Phase 13 is an evidence-led simplification pass, not a mandate to delete Candidate, Constraint or Decision layers.

## Accepted separation: Commitment Operation != Responsibility Transition

PR #50 removed proven semantic dependence on generic Commitment action where independent Current Responsibility evidence already exists.

Retained `CREATE`, `MAINTAIN`, `REVISE`, `WAIT` and `SETTLE` vocabulary may describe substrate operations. It must not be promoted back into semantic transition authority.

## Accepted direct-Passage targeting

PR #52 established:

- **Sole Context != Semantic Target**;
- **Key Match Is Not Lifecycle Match**; and
- **Semantic Targetability != Application Cardinality**.

Direct Passage substrate targeting now uses purpose and current Job Episode/lifecycle evidence rather than assuming that one live Commitment is therefore the semantic target.

A separate limitation remains: the generic Commitment application boundary may fail closed when more than one retained context exists even though a Passage target is semantically identifiable. Phase 13 must decide whether that cardinality limitation is a supported-runtime defect or an acceptable fail-closed boundary.

## D-0217 Passage-Leg lifecycle correction

Phase-13 Reality exposed that pairwise Cooperative Passage admission had been incorrectly coupled to whole-pair execution persistence.

Accepted runtime now represents two participant-scoped `COOPERATIVE_PASSAGE_LEG` obligations under one parent Resolution/Commitment. A leg may become terminal by:

- `SATISFACTION` -> `HANDED_BACK`; or
- `BASIS_CESSATION` -> `VACATED`.

The surviving leg continues existing choreography under Survivor Invariance. The Bubble/parent dissolves at **Last-Leg Dissolution**. Raw Control contradiction is not semantic lifecycle authority.

PR #54 and later `0.3.0.17` smoke evidence validate the normal participant-handback path; the PR #54 targeted fixture separately validated live-leg Job termination / vacatur.

## D-0218 Causal Obstruction

Issue #33 showed that a provenance-first completed-worker model was the wrong abstraction for generic obstruction.

The accepted Situation concept is **Causal Obstruction**: a current positive relationship where a physical blocker prevents an active supported beneficiary from continuing supported work.

```text
current Reality
   ↓
positive physical/continuation conflict
   ↓
Causal Obstruction
   ↓
classify blocker from current authority state
   ├─ active qualifying GIANTS AI -> active spatial negotiation
   ├─ non-active Player Claimed -> hands off
   └─ non-active unclaimed -> eligible for otherwise-supported relocation
```

Historical Job Episode provenance, `terminalEpisodeId`, prior OuttaMyWay observation and vehicle ownership are not generic admission prerequisites.

Current source placement after PR #59:

- `CurrentPhysicalAssemblySource.lua` — current mission Physical Assembly acquisition and positive Field World witnessing.
- `CurrentPhysicalConflictRepresentation.lua` — positive current conflict primitives for witnessed physical assemblies; incomplete coverage, no negative-clearance authority.
- `CurrentPhysicalPoseSource.lua` — factual current physical reference pose for relocation planning; no semantic authority.
- `CausalObstructionAssessment.lua` — Situation-level causal relationship and current blocker classification.
- `SituationAssessment.lua` — publishes Causal Obstruction knowledge and current relevant context.
- `ObstructionRelocationCandidateSupport.lua` — aggregates pairwise obstruction by `(Local Operation, blocker Physical Assembly)` and proposes one bounded first-courtesy relocation only when current evidence supports it.
- `ObstructionRelocationResponsibilityTransition.lua` — establishes current Resolution responsibility before physical dispatch.
- `AuthorityRegistry.lua` / commitment boundary — use truthful `OBSTRUCTION_RELOCATION_ACTUATION` exclusivity rather than historical post-job identity.
- `ObstructionRelocationControl.lua` — reuses proven low-level non-job movement mechanics, with Player Claim and GIANTS reactivation supersession.
- `ObstructionRelocationRuntimeIntegration.lua` — connects Control outcome evidence back to fresh semantic settlement.

The generic cold-blocker path deliberately authorises only the first centroid-bearing courtesy, bounded to the existing 60 m mechanical donor limit. Current physical representation has positive/incomplete authority and cannot truthfully support D-0147's second boundary-away negative-clearance claim.

Issue #33 is **FULL PASS and closed**. Reality now supports the intended positive, negative and claim-boundary cases, including independent relocation of more than one cold non-active blocker when each becomes causally relevant. Issue #60 separately records the `0.3.0.17` normal smoke PASS and is closed.

## Settlement discovery

The first generic relocation Reality run exposed **Post-Manoeuvre Settlement Gap**. The implementation cause was **Control Outcome Envelope Kind != Outcome Evidence Kind**: completion evidence overwrote the outer Observation envelope identity and therefore could not reach fresh Situation reassessment.

The corrected boundary preserves `OBSTRUCTION_RELOCATION_CONTROL_OBSERVATION` as the envelope and carries the narrower completion classification separately. Semantic success is still not inferred from physical manoeuvre completion; fresh obstruction cessation plus positive beneficiary continuation must be observed before `OBJECTIVE_SATISFIED` terminal settlement.

# Phase 13 Closure Audit

## Discovery — Candidate Evidence != Constraint Verdict

The closure audit found that seven nominal mandatory Constraint evaluators did not evaluate an independent question: they re-labelled Candidate-authored PASS/FAIL/UNRESOLVED packets as `ConstraintVerdict`. `.18` removes that duplicate verdict authority while preserving useful planning evidence.

The independently owned current Constraint questions are `REPRESENTATION_FITNESS`, `RESPONSIBILITY_COMPATIBILITY`, `COMMITMENT_PRECONDITIONS`, and `EFFECTIVE_ACTUATION_COMPOSITION`. Candidate support may still produce transitional planning packets, but the canonical `CandidateAction` boundary strips verdict/applicability fields and forbids `constraintEvidence` from entering Candidate data.

The seven pass-through evaluator modules are retired rather than preserved as empty architecture shells.

**Generic multi-context application cardinality** is classified as an acceptable fail-closed current limit; it should be revisited only for a concrete supported consumer such as Issue #45.

After `.18` validation, the remaining Phase-13 audit is narrowly `Candidate enumeration -> Decision selection`, testing the separate discovery **Preselection != Candidate Enumeration**.


## Discovery — Issue Completion != Phase Completion

Issue #33 completion removes the principal Reality-driven detour. Phase 13 now returns to its original Candidate/Constraint/Decision ownership question.

No further runtime change should be proposed until the current production chain is audited at its actual abstraction boundaries.

## Audit question 1 — Candidate-Embedded Verdict Authority

For each stage:

```text
Situation Assessment
        ↓
Candidate construction/planning
        ↓
Constraint evaluation
        ↓
Decision/policy selection
        ↓
Responsibility Transition
```

ask:

> What genuinely new information, feasibility result, policy choice or authority is introduced here?

Expected distinctions to protect unless source evidence disproves them:

- Situation Assessment owns factual interpreted knowledge.
- Candidate owns feasible option construction/planning, not semantic lifecycle authority.
- Constraint owns rejection/narrowing against accepted invariants where that is genuinely distinct.
- Decision owns selection among feasible alternatives and least-intervention policy where a choice genuinely exists.
- Responsibility Transition owns semantic establishment/revalidation/replacement/termination.

A Candidate field is a simplification target only if it already decides a downstream verdict or semantic transition that is then repeated later. Naming overlap or implementation verbosity is not sufficient evidence.

## Audit question 2 — Generic multi-context application cardinality

PR #52 left one known boundary intentionally unresolved: a semantically targetable retained context may still be unusable because generic application assumes a single live context.

The audit must classify that limitation as one of:

1. **SUPPORTED REQUIREMENT** — current supported runtime can legitimately require multiple independent retained contexts and the generic application boundary must become addressable;
2. **ACCEPTABLE FAIL-CLOSED LIMIT** — the condition is outside the supported requirement envelope or already has a truthful safe refusal; or
3. **MISSING CONCEPT** — repeated addressing pressure reveals an architectural concept not yet represented.

Do not generalise generic Commitment application simply to make it more elegant.

## Phase 13 completion condition

Phase 13 is complete when every remaining Candidate/Constraint/Decision concern has either:

- a distinct truthful responsibility and therefore no justified simplification; or
- a proved duplication that has been removed through one bounded seam and independently validated.

If the closure audit finds no remaining architecture-to-runtime mismatch, record Phase 13 **COMPLETE** and move to Phase 14 without manufacturing extra implementation work.

If one mismatch remains, create one bounded Phase-13 Engineering Increment for that mismatch, validate it, then repeat the closure audit.

# Separate Non-Blocking Work

- [Issue #37](https://github.com/bisdat/FS25_OuttaMyWay/issues/37) — Category-2 Forward Intersection Reality-validation debt. It does not block Phase-13 closure unless contrary Reality invalidates an assumption used here.
- [Issue #45](https://github.com/bisdat/FS25_OuttaMyWay/issues/45) — Bubble Bullet Time. Accepted but unimplemented; separate from Phase-13 Candidate/Constraint/Decision simplification.

# Immediate Programme Step

Perform the Phase 13 Closure Audit on accepted `main` before changing runtime behaviour.

The audit output must either:

1. identify one concrete duplicated verdict/authority boundary or supported multi-context requirement and define a bounded correction; or
2. conclude that current Candidate, Constraint and Decision responsibilities are materially distinct enough to retain, classify the multi-context limitation, and recommend **Phase 13 COMPLETE**.

Only after that decision should Phase 14 begin.
