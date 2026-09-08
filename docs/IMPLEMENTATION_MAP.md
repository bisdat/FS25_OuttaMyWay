# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are presently realised in source and identifies material architecture-to-code placement or vocabulary lag. It does not preserve implementation chronology; Git history, pull requests, issues and the Engineering Journal own that evidence.

```text
Architecture       -> what responsibilities should exist
Implementation Map -> where those responsibilities currently appear
Source             -> exactly how they are implemented
```

Architectural meaning remains owned by the [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation Model](architecture/SPATIAL_NEGOTIATION_MODEL.md), [Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md), [Candidate Support Projection Architecture](architecture/CANDIDATE_SUPPORT_PROJECTION.md), [Configuration architecture](CONFIGURATION.md) and [Naming Conventions](NAMING_CONVENTIONS.md).

## Repository state

- Accepted Repository State baseline for this map: `main` after PR #88 merge, commit `304908d55ce84fa75ec60cece0a37a7ee364c5c9`.
- Canonical authority remains **v0.3.0.0**.
- Current branch executable identity is **`0.3.0.32 TEST — RELOCATION SERIALIZATION RESIDUAL VOCABULARY RECONCILIATION`**; acceptance and canonical authority are unchanged until review/merge/Reality evidence says otherwise.
- Strangler Phase 14 is active. The remaining work is current placement/vocabulary reconciliation, not replay of the earlier Phase-14 tranches.
- Phase 15 whole-system validation and architecture-to-runtime review has not started.

## Principal current responsibility placement

| Architectural responsibility | Principal current source placement | Current disposition |
|---|---|---|
| Runtime entry and production composition | `modDesc.xml` -> `scripts/main.lua`; `scripts/runtime/Runtime.lua`; `scripts/runtime/LiveRuntimeCoordinator.lua` | PRESERVE explicit composition; former Phase-13/14 runtime integration wrappers are retired |
| Job Episode / Operation / Field World identity | `scripts/identity/JobEpisodeAdmission.lua`, `OperationAdmission.lua`, `FieldWorldSnapshotRegistry.lua`, `FieldWorldEquivalenceAuthority.lua`, `FieldWorldEquivalenceEvaluator.lua` | PRESERVE |
| Current Physical Assembly acquisition / addressability | `scripts/observation/CurrentPhysicalAssemblySource.lua` | PRESERVE current mission-root addressability; no semantic authority |
| Current physical pose observation | `scripts/observation/CurrentPhysicalPoseSource.lua` | PRESERVE factual positive evidence only |
| Live Observation composition | `scripts/observation/LiveObservationSource.lua` | PRESERVE |
| Live interaction Observation calculation | `scripts/observation/LiveInteractionObservation.lua` | PRESENT production Observation responsibility; no longer Diagnostic placement |
| Physical representation | `scripts/representation/AssemblyRepresentationCache.lua`, `PlanViewFootprint.lua`, `PairSpecificPassageClearance.lua`, `CurrentPhysicalConflictRepresentation.lua` | PRESERVE explicit positive/incomplete authority |
| Situation Assessment | `scripts/assessment/SituationAssessment.lua` plus focused assessment collaborators | PRESERVE interpreted current relationship knowledge |
| Causal Obstruction assessment | `scripts/assessment/CausalObstructionAssessment.lua` | PRESERVE current positive causal-obstruction semantics |
| Current Responsibility reassessment | `scripts/assessment/CurrentResponsibilityAssessment.lua` | PRESERVE evidence/reassessment only, not lifecycle authority |
| Prospective spatial constraints | `scripts/assessment/SpatialConstraintAssessment.lua` | PRESERVE pending separate Issue #37 Reality debt |
| Passage capability | `scripts/assessment/PassageCapabilityAssessment.lua` | PRESERVE |
| Candidate construction / planning | `scripts/candidates/` including `CandidateSpace.lua`, `LiveTrafficCandidateSupport.lua`, `LocalPassagePlanner.lua`, `TerminalEgressCandidateSupport.lua`, `ObstructionRelocationCandidateSupport.lua`, `PassiveLiveCandidateSupport.lua` | PRESERVE feasible option/support/planning ownership |
| Fresh Candidate support projection / portfolio composition | `scripts/candidates/ProspectiveDecisionPortfolioSupport.lua` plus projected group-builder seams in existing Candidate supports | PRESERVE one target Decision picture and no inter-group selection |
| Constraint evaluation | `scripts/constraints/ConstraintEngine.lua` plus four independently owned evaluators | PRESERVE independent mandatory verdict ownership |
| Policy / Decision selection | `scripts/decision/DecisionSelector.lua`, `TrafficPolicemanDecisionPolicy.lua`, `ProspectivePortfolioDecisionPolicy.lua` | PRESERVE supported choice / compatibility policy |
| Responsibility Transition Authority | `scripts/responsibility/ResponsibilityTransitionAuthority.lua` and purpose-specific transition modules | PRESERVE semantic establishment/replacement/termination authority |
| Follower Regulation transition | `scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua` | PRESERVE |
| Action-Space / Forward Intersection Regulation transition | `scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua` | PRESERVE |
| Cooperative Passage transition | `scripts/responsibility/CooperativePassageResponsibilityTransition.lua` | PRESERVE |
| Completed-obstruction transition | `scripts/responsibility/CompletedObstructionResponsibilityTransition.lua` | PRESERVE completed-obstruction trigger semantics |
| Current Causal Obstruction relocation transition | `scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua` | PRESERVE current `(Operation, blocker Physical Assembly)` responsibility |
| Generic retained Commitment / obligations | `scripts/commitment/`, including `CommitmentAdmission.lua`, `DecisionCommitmentBoundary.lua`, `ObligationLedger.lua` and purpose-specific lifecycle modules | RETAIN as substrate; not semantic transition authority |
| Cooperative Passage participant lifecycle | `COOPERATIVE_PASSAGE_LEG` obligations plus Passage lifecycle/settlement modules | PRESERVE Survivor Invariance / Last-Leg Dissolution |
| Resolution semantic representation | `scripts/contracts/ResolutionCommitment.lua`, `scripts/responsibility/ResolutionCommitmentAdapter.lua` | PRESERVE |
| Regulation semantic representation | `scripts/contracts/Regulation.lua` | PRESERVE |
| Bounded Authority | `scripts/contracts/BoundedAuthorityGrant.lua`, `scripts/authority/BoundedAuthority.lua` | PRESERVE |
| Regulation physical-authority state | `scripts/authority/RegulationBoundedAuthority.lua`, `ResolutionSpaceProgressionEnvelope.lua` | CURRENT Relocation Serialization vocabulary is graduated; `.31` Reality demonstrated material beneficiary serialization, supporting RETAIN; `.32` reconciles two residual production vocabulary surfaces |
| Mechanical actuation exclusivity | `scripts/authority/AuthorityRegistry.lua` | PRESERVE; exclusivity is not semantic permission |
| Effective actuation composition | `scripts/authority/EffectiveActuationComposition.lua` | PRESERVE |
| Typed Control boundary | `scripts/contracts/ControlRequest.lua`, `ControlOutcome.lua` | PRESERVE |
| Control routing | `scripts/control/LiveControlDispatcher.lua` | CURRENT branch routes authorised single-assembly Terminal Egress through one `TERMINAL_EGRESS` target; Cooperative Passage remains joint routing |
| Regulation physical Control | `scripts/control/RegulationControl.lua` using `scripts/control/mechanisms/NativeDriveMechanism.lua` | PRESENT production `REGULATE_SPEED` executor |
| Cooperative Passage physical Control | `scripts/control/CooperativePassageControl.lua` | PRESERVE validated mechanics |
| Terminal Egress physical movement | `scripts/control/TerminalEgressControl.lua` | ACCEPTED shared provenance-neutral executor for Completed Obstruction and current Causal Obstruction movement; trigger semantics remain upstream |
| Shared non-job physical actuation | `scripts/control/mechanisms/NonJobActuationMechanism.lua` | PRESENT shared mechanism with provenance-neutral `NON_JOB_*` mechanical failure vocabulary |
| Hold mechanism | `scripts/control/mechanisms/FieldWorkHoldMechanism.lua` | PRESENT production mechanism |
| Native drive mechanism | `scripts/control/mechanisms/NativeDriveMechanism.lua` | PRESENT production mechanism shared by Regulation and Passage |
| Transit configuration mechanism | `scripts/control/mechanisms/TransitConfigurationMechanism.lua` | PRESENT production mechanism with caller-owned state lifetime |
| Guarded Recovery | `scripts/control/GuardedRecoveryCompatibility.lua` routed through production `RegulationControl` | RETAIN explicit compatibility path |
| Prototype22 manual harness | retired from executable source on this branch | NO DURABLE PRODUCTION RESPONSIBILITY; production mechanisms remain independently composed |

## Candidate / Constraint / Decision boundary

The current production chain remains intentionally separated because each layer contributes distinct work:

### Candidate

Candidate owns feasible option construction, purpose-local planning, support provenance and representation requirements. It does not own final selection, canonical Constraint verdicts, Responsibility Transition or Control authority.

Fresh independently supportable purposes are exposed through Candidate Support Projection over one target Decision picture. Support Projection does not create intermediate Operational Pictures or delete unrelated Situation knowledge.

### Constraint

Canonical mandatory Constraint verdict ownership remains limited to independently evaluated questions:

- `REPRESENTATION_FITNESS`;
- `RESPONSIBILITY_COMPATIBILITY`;
- `COMMITMENT_PRECONDITIONS`;
- `EFFECTIVE_ACTUATION_COMPOSITION`.

Candidate planning evidence is not a canonical Constraint verdict source.

### Decision

Decision owns supported choice and compatibility policy, including prospective purpose ordering, local Traffic Policeman preference and supported Passage conflict selection.

### Responsibility Transition

`ResponsibilityTransitionAuthority` and purpose-specific transition modules own semantic establishment, preservation, replacement and termination. Commitment operation intent is not semantic Responsibility Transition authority.

## Resolved placement worth protecting

The following source placement now truthfully reflects current production responsibility and should not be reintroduced as Prototype/Diagnostic/integration-wrapper structure without new evidence:

- production Regulation execution is owned by `RegulationControl`;
- Hold, Drive and Transit Configuration are production Control mechanisms under `scripts/control/mechanisms/`;
- live interaction derivation is Observation, not Diagnostic output;
- shared non-job movement mechanics are `NonJobActuationMechanism`, not post-job semantic Authority;
- accepted Causal Obstruction / Prospective Portfolio responsibilities are composed directly through Runtime/Observation rather than load-order monkey-patching;
- current physical mission-root addressability is available independently of historical Job tracking.

Git and merged PRs preserve how those placements were reached. This map records only the present placement.

## Current architecture-to-code drift

### Relocation Serialization vocabulary — current Phase 14.6B tranche

PR #88 accepted **Trigger Provenance != Terminal Egress Execution** and the shared provenance-neutral `TerminalEgressControl`. Completed Obstruction and current Causal Obstruction remain distinct upstream responsibilities.

Phase 14.6B graduates the shared beneficiary-hold execution identity from D-0147 `Protected Yield` vocabulary to **Relocation Serialization** while preserving the exact existing `PROGRESS_ACTUATION` + Bounded Authority + `REGULATE_SPEED 0.0 km/h` mechanics.

**Relocation Serialization != Relocation Clearance.** Serialization prevents the active beneficiary from progressing concurrently with an authorised blocker relocation; it does not grant clearance through the beneficiary's current occupancy.

The `.31` GIANTS smoke established **Relocation Serialization Materially Active**: Patriot was progressing at about 25 km/h under a continuing GIANTS 25 km/h command when the zero-speed serialization lease applied, stopped Patriot while Condor translated, then released before Patriot resumed. Issue #91 therefore has direct current Reality evidence for **RETAIN**.

That same smoke/audit exposed two residual production terms: `beforeProtectedYield=true` in `CompletedObstructionResponsibilityTransition` and Runtime rollback reason `PROTECTED_YIELD_START_FAILED`. `.32` corrects only those vocabulary surfaces plus the mandatory TEST identity and executable contracts.

### Terminal Egress execution consolidation — accepted placement

`ObstructionRelocationControl` and Prototype22 are retired from executable source. Production Hold, Drive, Transit Configuration and shared non-job actuation mechanisms remain explicitly composed by their real consumers. One `TerminalEgressControl` executes already-authorised Completed Obstruction and current Causal Obstruction movement from current physical addressability.

### Production validation vocabulary

Current production source still contains primary identifiers such as D-number/TEST/Step/prototype names in Cooperative Passage, Regulation support and related Runtime/contracts. Decision numbers may remain as provenance, but current production identity should describe the current concept.

Renaming must follow ownership and must not become a blind repository-wide substitution.

### Mixed runtime constants

`scripts/config.lua` remains a Mixed Runtime Constants Surface. `TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M` and `TERMINAL_EGRESS_MOVE_TIMEOUT_MS` are plausible shared Terminal Egress execution-owned constants; do not clone them per trigger merely because two paths consume them.

`AUTOMATIC_TERMINAL_EGRESS` still spans development consent beyond the completed-obstruction player-configuration concept recorded in `CONFIGURATION.md`. Do not invent player-facing Configuration semantics while reconciling implementation scope.

## Current explicit limits / separate work

### Generic multi-context application cardinality

Semantic targeting may be unambiguous while generic Commitment application still fails closed if more than one retained context exists. This remains an acceptable fail-closed implementation limit until a concrete supported consumer requires broader cardinality, notably Issue #45.

### Separate Issues

- Issue #37 — Category-2 Forward Intersection Reality-validation debt.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.
- Issue #65 — Behaviour Regression Contract != Build Identity Contract.

Do not mix those concerns into the current Phase-14 placement/vocabulary correction without an explicit engineering reason.

## Immediate implementation boundary

Phase 14.6B remains intentionally limited to **Relocation Serialization vocabulary graduation**. `.32` is the residual-vocabulary reconciliation inside that same boundary, not a new subphase.

The correction changes only the two observed residual production terms plus mandatory TEST identity/current contracts. It does **not** change:

- the `0.0 km/h` hold magnitude;
- who is serialized;
- Bounded Authority or `PROGRESS_ACTUATION`;
- Completed Obstruction versus current Causal Obstruction semantics;
- Terminal Egress geometry/courtesy/configuration;
- Regulation, Passage, Player Claim/source-AI supersession or GIANTS job ownership.

Next evidence boundary:

1. blocking Structural + Lua CI on exact `.32` head;
2. minimal GIANTS log-vocabulary confirmation if required;
3. owner acceptance/merge if evidence remains positive;
4. close Issue #91 as RETAIN and continue to Phase 14.6C.
