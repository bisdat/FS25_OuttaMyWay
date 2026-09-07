# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are presently realised in source and identifies material architecture-to-code placement or vocabulary lag. It does not preserve implementation chronology; Git history, pull requests, issues and the Engineering Journal own that evidence.

```text
Architecture       -> what responsibilities should exist
Implementation Map -> where those responsibilities currently appear
Source             -> exactly how they are implemented
```

Architectural meaning remains owned by the [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation Model](architecture/SPATIAL_NEGOTIATION_MODEL.md), [Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md), [Candidate Support Projection Architecture](architecture/CANDIDATE_SUPPORT_PROJECTION.md), [Configuration architecture](CONFIGURATION.md) and [Naming Conventions](NAMING_CONVENTIONS.md).

# Programme Status

| Phase | Boundary | Status |
|---|---|---|
| 1–8 | Initial strangler seams, explicit Resolution/Regulation representation and programme groundwork | COMPLETE / accepted for programme progression |
| 9 | Current Responsibility reconciliation and Regulation-to-Passage succession | COMPLETE |
| 10 | Bounded Authority reconciliation | COMPLETE |
| 11 | Reduce `LiveControlDispatcher` to authorised routing/execution | COMPLETE |
| 12 | Retire superseded generic Commitment/orchestration only where unsupported | COMPLETE |
| 13 | Simplify Candidate/Constraint/Decision only where evidence proves duplication | **COMPLETE** |
| 14 | Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming | **IN PROGRESS — 14.4 NON-JOB ACTUATION MECHANISM GRADUATION** |
| 15 | Whole-system validation and architecture-to-runtime review | NOT STARTED |

Accepted Repository State for this map is `main` after PR #75 merge, commit `5b13bcc6251d6b482402e6ba1d37e740dd050d8a`. Canonical authority remains `v0.3.0.0`. Last accepted non-canonical playable identity is **`0.3.0.23 TEST — LIVE INTERACTION OBSERVATION GRADUATION`**.

Read [Phase 13 Closure Audit](architecture/PHASE_13_CLOSURE_AUDIT.md) for the final Candidate/Constraint/Decision responsibility audit.

# Principal Responsibility Placement

| Architectural responsibility | Principal current source placement | Disposition |
|---|---|---|
| Runtime entry and sequencing | `modDesc.xml` -> `scripts/main.lua`; `scripts/runtime/Runtime.lua`; `scripts/runtime/LiveRuntimeCoordinator.lua`; runtime integration seams | PRESERVE; Phase 14 may reconcile placement/naming, not silently change behaviour |
| Job Episode / Operation / Field World identity | `scripts/identity/JobEpisodeAdmission.lua`, `OperationAdmission.lua`, `FieldWorldSnapshotRegistry.lua`, `FieldWorldEquivalenceAuthority.lua`, `FieldWorldEquivalenceEvaluator.lua` | PRESERVE |
| Current Physical Assembly acquisition | `scripts/observation/CurrentPhysicalAssemblySource.lua` | PRESERVE |
| Current physical pose observation | `scripts/observation/CurrentPhysicalPoseSource.lua` | PRESERVE factual positive evidence only |
| Live Observation composition | `scripts/observation/LiveObservationSource.lua` | PRESERVE; later decompose only where responsibility becomes clearer |
| Live interaction Observation calculation | `scripts/observation/LiveInteractionObservation.lua` | **PHASE 14.3** — graduated from diagnostic placement; calculations/evidence meaning preserved |
| Physical representation | `scripts/representation/AssemblyRepresentationCache.lua`, `PlanViewFootprint.lua`, `PairSpecificPassageClearance.lua`, `CurrentPhysicalConflictRepresentation.lua` | PRESERVE explicit positive/incomplete authority |
| Situation Assessment | `scripts/assessment/SituationAssessment.lua` plus focused assessment collaborators | PRESERVE interpreted current relationship knowledge |
| Causal Obstruction assessment | `scripts/assessment/CausalObstructionAssessment.lua` | PRESERVE D-0218 Situation authority |
| Current Responsibility reassessment | `scripts/assessment/CurrentResponsibilityAssessment.lua` | PRESERVE evidence/reassessment only, not lifecycle authority |
| Prospective spatial constraints | `scripts/assessment/SpatialConstraintAssessment.lua` | PRESERVE pending separate Issue #37 Reality debt |
| Passage capability | `scripts/assessment/PassageCapabilityAssessment.lua` | PRESERVE |
| Candidate construction / planning | `scripts/candidates/` including `CandidateSpace.lua`, `LiveTrafficCandidateSupport.lua`, `LocalPassagePlanner.lua`, `TerminalEgressCandidateSupport.lua`, `ObstructionRelocationCandidateSupport.lua`, `PassiveLiveCandidateSupport.lua` | **PHASE 13 CLOSED** — feasible option/support/planning ownership retained |
| Fresh Candidate support projection / portfolio composition | `scripts/candidates/ProspectiveDecisionPortfolioSupport.lua` plus projected group-builder seams in existing Candidate supports | PRESERVE — enumerates fresh support groups without inter-group selection; one target Decision picture |
| Constraint evaluation | `scripts/constraints/ConstraintEngine.lua` plus four independently owned evaluators | **PHASE 13 CLOSED** — independent mandatory verdict ownership |
| Policy / Decision selection | `scripts/decision/DecisionSelector.lua`, `TrafficPolicemanDecisionPolicy.lua`, `ProspectivePortfolioDecisionPolicy.lua` | **PHASE 13 CLOSED** — owns constrained alternative selection and compatibility policy |
| Portfolio dispatch-boundary projection | `scripts/runtime/ProspectiveDecisionPortfolioIntegration.lua` | PRESERVE compatibility seam; projects only selected group's original local support boundary to existing dispatcher checks |
| Responsibility Transition Authority | `scripts/responsibility/ResponsibilityTransitionAuthority.lua` and purpose-specific transition modules | PRESERVE semantic establishment/replacement/termination authority |
| Follower Regulation transition | `scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua` | PRESERVE |
| Action-Space / Forward Intersection Regulation transition | `scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua` | PRESERVE |
| Cooperative Passage transition | `scripts/responsibility/CooperativePassageResponsibilityTransition.lua` | PRESERVE |
| Completed warm obstruction transition | `scripts/responsibility/CompletedObstructionResponsibilityTransition.lua` | PRESERVE D-0147 warm-path semantics |
| Generic current obstruction relocation transition | `scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua` | PRESERVE current `(Operation, blocker Physical Assembly)` responsibility |
| Generic retained Commitment / obligations | `scripts/commitment/`, including `CommitmentAdmission.lua`, `DecisionCommitmentBoundary.lua`, `ObligationLedger.lua`, purpose-specific lifecycle modules | RETAIN as substrate; not semantic transition authority |
| Cooperative Passage participant lifecycle | `COOPERATIVE_PASSAGE_LEG` obligations plus Passage lifecycle/settlement modules | PRESERVE D-0217 Survivor Invariance / Last-Leg Dissolution |
| Resolution semantic representation | `scripts/contracts/ResolutionCommitment.lua`, `scripts/responsibility/ResolutionCommitmentAdapter.lua` | PRESERVE |
| Regulation semantic representation | `scripts/contracts/Regulation.lua` | PRESERVE |
| Bounded Authority | `scripts/contracts/BoundedAuthorityGrant.lua`, `scripts/authority/BoundedAuthority.lua` | PRESERVE |
| Regulation physical-authority state | `scripts/authority/RegulationBoundedAuthority.lua`, `ResolutionSpaceProgressionEnvelope.lua` | PRESERVE |
| Mechanical actuation exclusivity | `scripts/authority/AuthorityRegistry.lua` | PRESERVE; exclusivity is not semantic permission |
| Effective actuation composition | `scripts/authority/EffectiveActuationComposition.lua` | PRESERVE |
| Typed Control boundary | `scripts/contracts/ControlRequest.lua`, `ControlOutcome.lua` | PRESERVE |
| Control routing | `scripts/control/LiveControlDispatcher.lua` | PRESERVE authorised routing/execution only |
| Regulation physical Control | `scripts/control/RegulationControl.lua` using `scripts/control/mechanisms/NativeDriveMechanism.lua` | **PHASE 14.1** — production `REGULATE_SPEED` execution/observation/cleanup separated from the manual P22 harness; physical mechanism graduation remains 14.2 |
| Cooperative Passage physical Control | `scripts/control/CooperativePassageControl.lua` | PRESERVE validated mechanics |
| Warm terminal-egress physical Control | `scripts/control/TerminalEgressControl.lua` | PRESERVE validated D-0147 mechanics |
| Generic obstruction relocation Control | `scripts/control/ObstructionRelocationControl.lua` | PRESERVE bounded D-0218 cold-blocker actuation |
| Shared non-job physical actuation mechanism | `scripts/control/mechanisms/NonJobActuationMechanism.lua` | **PHASE 14.4** — shared mechanics for warm D-0147 and cold D-0218; semantic authority classes remain purpose-specific |
| Generic obstruction relocation runtime integration | `scripts/runtime/ObstructionRelocationRuntimeIntegration.lua` | PRESERVE explicit sequencing/settlement integration |
| Guarded Recovery | `scripts/control/GuardedRecoveryCompatibility.lua` routed through production `RegulationControl` | RETAIN as explicit compatibility; P22 request vocabulary removed in 14.1 |

# Phase 13 Closed Responsibility Boundaries

Phase 13 was an evidence-led simplification pass, not a mandate to delete Candidate, Constraint or Decision.

## Candidate

Current Candidate work is constructive:

- consume already-assessed Situation knowledge;
- build feasible option specifications;
- perform purpose-local planning such as one-conflict Passage arrangement search;
- retain support provenance and representation requirements;
- enumerate fresh support groups through Candidate Support Projection.

`CandidateAction` rejects downstream selection, admissibility, Commitment-operation, Control-request and canonical Constraint-verdict authority.

Historical support modules may still build transitional packets named `constraintEvidence`; `CandidateSpace` strips verdict/applicability semantics and preserves only useful planning evidence before canonical `CandidateAction` construction. This is vocabulary/mechanical debt, not duplicate canonical Constraint authority.

## Constraint

Current mandatory Constraint verdict ownership is limited to independently evaluated questions:

- `REPRESENTATION_FITNESS`;
- `RESPONSIBILITY_COMPATIBILITY`;
- `COMMITMENT_PRECONDITIONS`;
- `EFFECTIVE_ACTUATION_COMPOSITION`.

Seven historical pass-through evaluators are retired. Candidate evidence is not a verdict source.

## Decision

Fresh prospective ordering now lives at Decision:

- cold Causal Obstruction vs warm D-0147 vs live traffic;
- fresh warm terminal episode choice;
- follower / Forward Intersection / Passage / Action-Space compatibility;
- nearest supported Passage conflict;
- same-class fail-closed handling under accepted policy;
- Traffic Policeman sequential preference inside the selected governing requirement.

`ProspectivePortfolioDecisionPolicy` selects the governing support group. `DecisionSelector` then applies the group's local policy after mandatory Constraint evaluation.

## Responsibility Transition

Semantic lifecycle authority remains downstream. Decision's `CREATE`, `MAINTAIN`, `REVISE`, `WAIT` and `SETTLE` values are Commitment-substrate operation intent, not semantic Regulation/Resolution establishment.

`ResponsibilityTransitionAuthority` and purpose-specific transition modules own semantic establishment, preservation, replacement and termination.

# Reality-Driven Candidate Support Projection Correction

The first `.19` Portfolio implementation failed Reality because support isolation created new Operational Pictures and deleted unrelated Situation knowledge. Valid same-Reality Traffic Policeman evidence became stale before Decision.

Accepted discoveries:

- **Support Projection != New Operational Picture**;
- **Support Scope != Evidence Deletion**.

Current `.20` placement:

- projected group builders operate over the full parent picture;
- one target Candidate-support-enriched Operational Picture identity is reserved for the complete fresh Portfolio;
- same-picture support evidence is generated for that target identity directly;
- only one Portfolio-supported Operational Picture is materialised;
- strict `STALE_OPERATIONAL_PICTURE` validation remains intact;
- no Passage, D-0147 or D-0218 physical Control change was required.

Owner GIANTS Reality validated two ordinary Passages, warm D-0147 settlement, Player Claim exclusion, and sequential Decision/Responsibility/Control handling of two simultaneously eligible cold blockers.

# Explicit Current Limits / Separate Work

## Generic multi-context application cardinality

Semantic targeting may be unambiguous while generic Commitment application still fails closed if more than one retained context exists. Current source reports this explicitly rather than confusing application cardinality with semantic targetability.

Disposition: **ACCEPTABLE FAIL-CLOSED LIMIT for current implemented production behaviour**. Revisit for a concrete supported consumer such as Issue #45.

## Issue #37

Category-2 Forward Intersection Reality-validation debt remains separate. It may challenge the underlying Forward Intersection model if contrary Reality appears, but it is not evidence of Candidate/Constraint/Decision ownership duplication.

## Issue #45

Bubble Bullet Time remains accepted but unimplemented architecture. It may require revisiting multi-context application cardinality and external-traffic regulation scope when it becomes the active consumer.

## Issues #65 and #67

Test-architecture / validation debt remains open:

- Behaviour Regression Contract != Build Identity Contract;
- Workflow Success != Observation Success / Lua observation harness reconciliation.

Do not mix those corrections into Phase-14 production mechanics without a deliberate validation-architecture tranche.

# Phase 14 Entry Boundary

Phase 14 is now the active programme boundary:

> **Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming.**

Begin with observation and classification, not code changes.

For each suspect production surface ask:

1. Is the underlying responsibility still valid production architecture?
2. Is only its name/provenance/test vocabulary stale?
3. Is diagnostic or compatibility machinery still executing in the production path without a current responsibility?
4. Is runtime integration placed at the wrong abstraction level?
5. Would changing it alter behaviour, or only make accepted responsibility placement truthful?

Only demonstrated mismatches should become Engineering Increments. Do not use Phase 14 as a general refactoring licence.