# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are presently realised in source and identifies material architecture-to-code placement or vocabulary lag. It does not preserve implementation chronology; Git history, pull requests, issues and the Engineering Journal own that evidence.

```text
Architecture       -> what responsibilities should exist
Implementation Map -> where those responsibilities currently appear
Source             -> exactly how they are implemented
```

Architectural meaning remains owned by the [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation Model](architecture/SPATIAL_NEGOTIATION_MODEL.md), [Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md), [Candidate Support Projection Architecture](architecture/CANDIDATE_SUPPORT_PROJECTION.md), [Configuration architecture](CONFIGURATION.md) and [Naming Conventions](NAMING_CONVENTIONS.md).

## Repository state

- Accepted Repository State baseline for this map: `main` after PR #84 merge, commit `57f65c0dccdf39764bca6cfea4bfe082a93852f0`.
- Canonical authority remains **v0.3.0.0**.
- Accepted non-canonical playable identity remains **`0.3.0.28 TEST — FOLLOWER HUD GLYPH COMPATIBILITY`**.
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
| Regulation physical-authority state | `scripts/authority/RegulationBoundedAuthority.lua`, `ResolutionSpaceProgressionEnvelope.lua` | PRESERVE semantics; Protected Yield vocabulary still carries D-0147 provenance |
| Mechanical actuation exclusivity | `scripts/authority/AuthorityRegistry.lua` | PRESERVE; exclusivity is not semantic permission |
| Effective actuation composition | `scripts/authority/EffectiveActuationComposition.lua` | PRESERVE |
| Typed Control boundary | `scripts/contracts/ControlRequest.lua`, `ControlOutcome.lua` | PRESERVE |
| Control routing | `scripts/control/LiveControlDispatcher.lua` | PRESERVE authorised routing only; current reposition routing still exposes trigger-specific target kinds |
| Regulation physical Control | `scripts/control/RegulationControl.lua` using `scripts/control/mechanisms/NativeDriveMechanism.lua` | PRESENT production `REGULATE_SPEED` executor |
| Cooperative Passage physical Control | `scripts/control/CooperativePassageControl.lua` | PRESERVE validated mechanics |
| Completed-obstruction physical movement | `scripts/control/TerminalEgressControl.lua` | CURRENT implementation; candidate generic Terminal Egress executor |
| Current-obstruction physical movement | `scripts/control/ObstructionRelocationControl.lua` | CURRENT duplicate execution seam under review; trigger semantics remain upstream |
| Shared non-job physical actuation | `scripts/control/mechanisms/NonJobActuationMechanism.lua` | PRESENT shared mechanism; mechanical failure vocabulary still contains post-job residue |
| Hold mechanism | `scripts/control/mechanisms/FieldWorkHoldMechanism.lua` | PRESENT production mechanism |
| Native drive mechanism | `scripts/control/mechanisms/NativeDriveMechanism.lua` | PRESENT production mechanism shared by Regulation and Passage |
| Transit configuration mechanism | `scripts/control/mechanisms/TransitConfigurationMechanism.lua` | PRESENT production mechanism with caller-owned state lifetime |
| Guarded Recovery | `scripts/control/GuardedRecoveryCompatibility.lua` routed through production `RegulationControl` | RETAIN explicit compatibility path |
| Prototype22 manual harness | `scripts/prototypes/Prototype22CapabilityGate.lua` plus `main.lua` registration and `PROTOTYPE_22_*` constants | NO DURABLE PRODUCTION RESPONSIBILITY IDENTIFIED; targeted for retirement after exact dependency validation |

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

### Terminal Egress execution duplication

Completed Obstruction and current Causal Obstruction remain distinct upstream triggers. The current source nevertheless routes them through separate physical Controls: `TerminalEgressControl` and `ObstructionRelocationControl`.

The active implementation hypothesis is **Trigger Provenance != Terminal Egress Execution**: once Bounded Authority has authorised a movement objective, physical execution should depend on that objective and current physical subject rather than D-0147/D-0218 provenance. The duplicate Control is therefore a bounded consolidation target, not yet an accepted implementation result.

### Protected Yield vocabulary

`RegulationBoundedAuthority` exposes the beneficiary hold used by both obstruction paths through `d0147ProtectedYield...` names and `D0147_PROTECTED_YIELD` owner vocabulary. The mechanism is already shared; the names still claim the trigger that first introduced it.

### Prototype22 residue

The Prototype22 runtime harness, command/HUD/event registration and `PROTOTYPE_22_*` constants remain after the physical mechanisms graduated to production. No current production responsibility has been identified for the prototype itself. Retirement requires an exact dependency scan before executable deletion.

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

The next executable Phase-14 increment should be behaviour-preserving and narrow:

1. establish one provenance-neutral Terminal Egress execution contract while preserving completed-obstruction and current Causal Obstruction trigger semantics upstream;
2. absorb `ObstructionRelocationControl` physical execution only where the dependency audit supports equivalence;
3. graduate Protected Yield execution vocabulary away from D-0147 provenance;
4. use current-physical subject addressability at Control where validated;
5. retire Prototype22 only after exact dependency validation; and
6. preserve Regulation, Cooperative Passage, Player Claim/source-AI supersession, configuration/compaction, beneficiary protection and existing settlement policy.

The first materially changed executable revision after `.28` requires a fresh TEST build identity before push.