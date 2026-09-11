# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are
> presently realised in source and identifies material architecture-to-code
> placement or vocabulary lag. It does not preserve implementation chronology;
> Git history, pull requests, Issues and the Engineering Journal own that evidence.

```text
Architecture       -> what responsibilities should exist
Implementation Map -> where those responsibilities currently appear / materially drift
Source             -> exactly how they are implemented
```

Architectural meaning remains owned by the
[Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md),
[Spatial Negotiation Model](architecture/SPATIAL_NEGOTIATION_MODEL.md),
[Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md),
[Candidate Support Projection Architecture](architecture/CANDIDATE_SUPPORT_PROJECTION.md),
[Configuration architecture](CONFIGURATION.md) and
[Naming Conventions](NAMING_CONVENTIONS.md).

## Repository state

- Accepted Repository State: `main` after PR #135 merge,
  `b04cc98cb4d66aeccb77fd146205903d89b35d09`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.61 TEST — TRAJECTORY ASSESSMENT VALUE OWNERSHIP`**.
- Post-merge Offline Validation run #334 passed on the exact merge commit.
- Issue #87 remains active through the `.62` Follower Boundary assessment value-ownership tranche.
- Phase 14 strangler is **CLOSED**.
- Phase 15 whole-system architecture <-> code audit is **COMPLETE**.

## Principal current responsibility placement

| Architectural responsibility | Principal current source placement | Current disposition |
|---|---|---|
| Runtime composition | `scripts/main.lua`, `scripts/runtime/Runtime.lua`, `LiveRuntimeCoordinator.lua` | PRESERVE explicit production composition |
| Job Episode identity | `scripts/identity/JobEpisodeAdmission.lua` | PRESERVE Lifecycle Evidence Asymmetry |
| Local Operation identity/membership | `scripts/identity/OperationAdmission.lua` | PRESERVE lifecycle context; not traffic controller |
| Field World snapshots/equivalence | `FieldWorldSnapshotRegistry.lua`, `FieldWorldEquivalenceEvaluator.lua`, `FieldWorldEquivalenceAuthority.lua`, `LiveObservationSource.lua` | PRESERVE — `.58` localises Snapshot/fingerprint production values to the Registry, interpretation thresholds to the Evaluator, and evidence-history retention bounds to the Authority; retained tracks keep immutable Snapshot assignment semantics |
| Current Physical Assembly acquisition | `scripts/observation/CurrentPhysicalAssemblySource.lua` | PRESERVE mission-root addressability; no semantic authority |
| Current pose / live Observation | `CurrentPhysicalPoseSource.lua`, `LiveObservationSource.lua`, `LiveInteractionObservation.lua` | PRESERVE factual/provenance boundary |
| Physical representation cache | `scripts/representation/AssemblyRepresentationCache.lua` | PRESERVE — member-discovery truncation revokes Transit complete-assembly authority at representation construction (#99 / PR #106); `.55` localises the 32-member bound and `.56` owns its per-member hierarchy-discovery and Job-scoped membership-revalidation bounds locally |
| Entity-Local Shape Evidence | `scripts/representation/EntityLocalShapeEvidence.lua` | `.57` shared Resolution evidence predicate only — owns geometry/world coherence and descendant/root-alias discrimination; no discovery, coverage or product authority |
| Generic current physical conflict | `CurrentPhysicalConflictRepresentation.lua` | PRESERVE positive-only / no generic negative-clearance authority; `.56` owns its whole-current-assembly candidate scan budget and candidate-discovery refresh horizon locally |
| Passage-specific geometry | `AssemblyRepresentationCache.lua`, `PairSpecificPassageClearance.lua`, `LocalPassagePlanner.lua` | PRESERVE directional Transit Passage contract for non-truncated complete assemblies |
| Situation Assessment | `scripts/assessment/SituationAssessment.lua` and focused assessment collaborators | PRESERVE current interpreted relationship ownership except listed drift |
| Current Pair Assessment Scope | `scripts/assessment/CurrentPairAssessmentScope.lua` plus `SituationAssessment.lua` | PRESERVE — accepted by #100 / PR #113; ephemeral current Operation/exact-Job-Episode pair scope with no generic pair lifecycle or last-positive truth |
| Follower Boundary evidence | `scripts/assessment/FollowerBoundaryDemandAssessment.lua` | PRESERVE admissible magnitude evidence/envelope; `.62` makes the evaluator explicit owner of its six alignment/retention/clearance/temporal-seed calibrations; no requested Control target (#98 / PR #108) |
| Forward Intersection / Action-Space evidence | `SpatialConstraintAssessment.lua`, `TrajectoryConflictAssessment.lua` | PRESERVE current positive/unresolved/negative semantics; `.61` makes Trajectory Conflict Assessment the explicit owner of its ten sampling/persistence/opposed-current calibrations while Passage Action-Space separation remains external context |
| Causal Obstruction | `CausalObstructionAssessment.lua` | PRESERVE: current GIANTS inactivity observation and ENDED Job Episode are two evidence routes into the same non-active classification; no provenance-specific downstream responsibility |
| Candidate construction / planning | `scripts/candidates/` | PRESERVE feasible option/support/planning ownership |
| Prospective Candidate portfolio | `ProspectiveDecisionPortfolioSupport.lua` | PRESERVE complete fresh group enumeration on one Decision picture |
| Constraint evaluation | `scripts/constraints/ConstraintEngine.lua` plus four canonical evaluators | PRESERVE independently owned mandatory verdicts; `.43` retires only the production-unreachable historical Follower Owns Closure prohibition |
| Decision / policy | `DecisionSelector.lua`, `TrafficPolicemanDecisionPolicy.lua`, `ProspectivePortfolioDecisionPolicy.lua` | PRESERVE supported choice / compatibility policy |
| Responsibility Transition | `ResponsibilityTransitionAuthority.lua` plus purpose-specific transition modules | PRESERVE semantic establishment/replacement/termination; #112 `.44` renames only the shared obstruction-relocation RTA seam to current responsibility vocabulary |
| Generic retained Commitment / obligations | `scripts/commitment/` | RETAIN subordinate substrate; not Current Responsibility authority |
| Regulation semantic responsibility | `scripts/contracts/Regulation.lua` and transition modules | PRESERVE one Regulation responsibility with purpose-specific evidence |
| Resolution semantic responsibility | `ResolutionCommitment.lua`, `ResolutionCommitmentAdapter.lua`, purpose-specific transition/lifecycle modules | PRESERVE obligation-backed strong persistence |
| Passage Leg lifecycle | `LiveTrafficCommitmentLifecycle.lua`, Passage obligations and Control callbacks | PRESERVE Survivor Invariance / participant handback-vacatur / Last-Leg Dissolution |
| Bounded Authority | `scripts/authority/BoundedAuthority.lua` | PRESERVE semantic permission distinct from `AU-*` exclusivity |
| Regulation Bounded Authority | `RegulationBoundedAuthority.lua`, `ResolutionSpaceProgressionEnvelope.lua`, `FollowerBoundaryMagnitudePolicy.lua` | PRESERVE authority-owned final follower speed permission from accepted admissible evidence (#98 / PR #108) |
| Effective actuation composition | `EffectiveActuationComposition.lua` | PRESERVE |
| Mechanical exclusivity | `AuthorityRegistry.lua` | PRESERVE; exclusivity is not permission |
| Control routing | `LiveControlDispatcher.lua` | PRESERVE authorised typed routing |
| Regulation Control | `RegulationControl.lua`, `NativeDriveMechanism.lua` | PRESERVE production speed executor |
| Cooperative Passage Control | `CooperativePassageControl.lua` plus shared mechanisms | PRESERVE validated mechanics and participant-specific handback |
| Obstruction Relocation Control | `ObstructionRelocationControl.lua`, `NonJobActuationMechanism.lua` | PRESERVE one provenance-neutral physical executor beneath one Causal Obstruction / Obstruction Relocation responsibility; `.51` retires the already-uninstantiated D-0147 donor topology around it |
| Relocation Serialization | `RegulationBoundedAuthority.lua` supporting Obstruction Relocation movement | PRESERVE current beneficiary protection |
| Guarded Recovery compatibility | no current production placement | **RETIRED / ACCEPTED #101 / PR #115** — dependency-proven orphan generation removed in `.42`; current Passage recovery/restoration remains elsewhere |
| Diagnostics / probes | `scripts/diagnostics/` and passive observation probes | PRESERVE downstream-only diagnostic directionality; `.59` retires the expired follower-maturation shadow and `.60` localises five live instruments' enablement/publication controls without moving semantic authority |
| Mixed runtime constants | `scripts/config.lua` | **ACTIVE #87** — `.52`-.61 resolve prior ownership/retirement families; `.62` removes six Follower Boundary assessment calibrations while preserving the distinct Candidate-expression enable gate |
| Bubble Bullet Time | not implemented | **SEPARATE #45** — accepted architecture, missing implementation |

## Boundary findings worth protecting

### Candidate / Constraint / Decision

The Phase-13 ownership split remains valid:

- Candidate owns feasible option construction, purpose-local planning and support
  provenance;
- Constraint owns the four canonical mandatory verdict classes;
- Decision owns supported cross-purpose/local policy choice;
- Responsibility Transition owns semantic lifecycle change.

Multiple cold blockers are correctly enumerated into Decision. No blocker-specific
preference should be invented merely to avoid a deterministic tie-break where
architecture defines no preference.

### Regulation maintenance

Unresolved follower/Forward-Intersection evidence must not manufacture positive
dissolution. Current physical authority may quiesce while the same `RS-*`
Regulation remains semantically live.

> **Responsibility Continuity Allows Authority Discontinuity**

The generic multi-context Commitment application boundary remains an accepted
fail-closed current limit. Revisit it only for a concrete supported consumer,
not merely because a quiescent purpose exists.

### Commitment terminal settlement / Obstruction Relocation

`TerminalSettlementEvaluator` and terminal Commitment states remain truthful
generic lifecycle vocabulary. **Terminal Commitment State != Terminal Worker
Vocabulary**: the retired D-0147 completed-worker responsibility must not be
recreated merely to preserve its historical names.

Current Obstruction Relocation releases physical Bounded Authority after each
actuation and returns to fresh Situation Assessment. `MANOEUVRE_COMPLETE` does
not itself establish semantic obstruction success.

> **Execution Settlement != Strategic Reassessment**

> **Resolution Persistence After Actuation != Authority Persistence**

### Representation

Generic current physical-conflict primitives remain positive-only. Purpose-specific
Transit Passage geometry may establish narrower Passage conclusions, but complete-
assembly authority still inherits Physical Assembly membership completeness.

PR #106 closes the discovered budget-truncation gap: truncated assembly
inventory cannot materialise complete-assembly Transit Passage authority.

## Current material drift

| Issue | Classification | Material mismatch |
|---|---|---|
| #87 | mixed runtime constants / Configuration ownership | `.62` localises six Follower Boundary assessment calibrations and removes `SituationAssessment` as their parameter courier. The similarly named aligned-Regulation enable gate remains a separate Candidate-expression responsibility pending later classification. Remaining #87 work concerns that gate, HUD/#89 boundaries, Cooperative Passage/Resolution Space, identity/validation values, and the required Player / Developer-Debug / Internal presentation boundary. |

Issue #112 is closed completed. Issue #116 and #123 remain separate.

## Separate accepted work / explicit limits

- **#45** — Bubble Bullet Time remains accepted but unimplemented.
- **#87** — ACTIVE: decompose the remaining live `scripts/config.lua` Mixed Runtime
  Constants Surface ownership-family by ownership-family.
- Generic multi-context Commitment application remains an acceptable fail-closed
  limit until a concrete supported consumer requires broader cardinality.
- The maximum-three-active-AI-worker rule is a supported claim/validation
  envelope, not current authority to invent a fourth-worker rejection policy.
- GUI architecture remains deferred; diagnostic HUDs are not product GUI.

## Documentation responsibility after the strangler

This file remains the durable current **placement / material-drift map**.

It is not a roadmap. Forward sequencing is owned by Issues. Git/PR/Journal own
history. Phase-shaped closure narratives do not belong here.

The historical `docs/architecture/PHASE_13_CLOSURE_AUDIT.md` has no remaining
present-tense architecture responsibility and is removed from the working tree;
Git and PR #71 preserve its evidence.

## Immediate engineering boundary

Implement and validate **#87 `.62 — FOLLOWER BOUNDARY ASSESSMENT VALUE OWNERSHIP`**
from accepted `main` at `b04cc98cb4d66aeccb77fd146205903d89b35d09`.

Localise exactly six Follower Boundary assessment calibrations to
`FollowerBoundaryDemandAssessment`: clearance factor, current alignment,
established lateral retention, established alignment retention, opposed-succession
retention and provisional temporal-seed duration. Preserve every literal and all
current assessment semantics exactly.

Production `SituationAssessment` continues to supply evidence and commitment /
operation context, but no longer couriers evaluator-private calibration. Direct
options/values remain supported as focused-test override seams.

`FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED = true` remains untouched in
`scripts/config.lua` and remains consumed by `LiveTrafficCandidateSupport` as a
separate Candidate-expression gate.

Reconcile only historical tests that froze the former root placement. Preserve
their aligned-production meaning and the independent Lua D-0141 behavioural
fixtures.

Enable-gate ownership, speed retuning, HUD/#89, Passage/Resolution-Space policy,
#123, #116 and #45 are outside this increment.
