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

- Accepted Repository State baseline: `main` after PR #108 merge, commit
  `b7e236955fd63b06d2b054bd25e8faaebbd78107`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.39 TEST — FOLLOWER MAGNITUDE AUTHORITY`**.
- Phase 14 strangler is **CLOSED**.
- Phase 15 whole-system architecture <-> code audit is **COMPLETE**.
- No new TEST identity exists merely for audit closure.

## Principal current responsibility placement

| Architectural responsibility | Principal current source placement | Current disposition |
|---|---|---|
| Runtime composition | `scripts/main.lua`, `scripts/runtime/Runtime.lua`, `LiveRuntimeCoordinator.lua` | PRESERVE explicit production composition |
| Job Episode identity | `scripts/identity/JobEpisodeAdmission.lua` | PRESERVE Lifecycle Evidence Asymmetry |
| Local Operation identity/membership | `scripts/identity/OperationAdmission.lua` | PRESERVE lifecycle context; not traffic controller |
| Field World snapshots/equivalence | `FieldWorldSnapshotRegistry.lua`, `FieldWorldEquivalenceEvaluator.lua`, `FieldWorldEquivalenceAuthority.lua`, `LiveObservationSource.lua` | PRESERVE — retained tracks resolve their existing immutable Snapshot assignment, which refreshes Field World relevance without stale geometry re-evaluation |
| Current Physical Assembly acquisition | `scripts/observation/CurrentPhysicalAssemblySource.lua` | PRESERVE mission-root addressability; no semantic authority |
| Current pose / live Observation | `CurrentPhysicalPoseSource.lua`, `LiveObservationSource.lua`, `LiveInteractionObservation.lua` | PRESERVE factual/provenance boundary |
| Physical representation cache | `scripts/representation/AssemblyRepresentationCache.lua` | PRESERVE — member-discovery truncation revokes Transit complete-assembly authority at representation construction (#99 / PR #106) |
| Generic current physical conflict | `CurrentPhysicalConflictRepresentation.lua` | PRESERVE positive-only / no generic negative-clearance authority |
| Passage-specific geometry | `AssemblyRepresentationCache.lua`, `PairSpecificPassageClearance.lua`, `LocalPassagePlanner.lua` | PRESERVE directional Transit Passage contract for non-truncated complete assemblies |
| Situation Assessment | `scripts/assessment/SituationAssessment.lua` and focused assessment collaborators | PRESERVE current interpreted relationship ownership except listed drift |
| Encounter continuity | `scripts/assessment/EncounterRegistry.lua` plus `SituationAssessment.lua` | **DRIFT #100** — persistent pair-history implementation concept rejected by current architecture |
| Follower Boundary evidence | `scripts/assessment/FollowerBoundaryDemandAssessment.lua` | PRESERVE admissible magnitude evidence/envelope; no requested Control target (#98 / PR #108) |
| Forward Intersection / Action-Space evidence | `SpatialConstraintAssessment.lua`, `TrajectoryConflictAssessment.lua` | PRESERVE current positive/unresolved/negative semantics |
| Causal Obstruction | `CausalObstructionAssessment.lua` | PRESERVE positive current obstruction semantics |
| Candidate construction / planning | `scripts/candidates/` | PRESERVE feasible option/support/planning ownership |
| Prospective Candidate portfolio | `ProspectiveDecisionPortfolioSupport.lua` | PRESERVE complete fresh group enumeration on one Decision picture |
| Constraint evaluation | `scripts/constraints/ConstraintEngine.lua` plus four canonical evaluators | PRESERVE independently owned mandatory verdicts; stranded legacy rule tracked by #101 |
| Decision / policy | `DecisionSelector.lua`, `TrafficPolicemanDecisionPolicy.lua`, `ProspectivePortfolioDecisionPolicy.lua` | PRESERVE supported choice / compatibility policy |
| Responsibility Transition | `ResponsibilityTransitionAuthority.lua` plus purpose-specific transition modules | PRESERVE semantic establishment/replacement/termination; naming residue tracked by #101 |
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
| Terminal Egress Control | `TerminalEgressControl.lua`, `NonJobActuationMechanism.lua` | PRESERVE shared provenance-neutral executor for warm/cold obstruction movement |
| Relocation Serialization | `RegulationBoundedAuthority.lua` supporting D-0147/D-0218 movement | PRESERVE current beneficiary protection |
| Guarded Recovery compatibility | `GuardedRecoveryCompatibility.lua` plus synthetic test topology | **RETIRE/PROVE #101** — no demonstrated live production ingress |
| Diagnostics / probes | `scripts/diagnostics/` and passive observation probes | PRESERVE downstream-only diagnostic directionality |
| Mixed runtime constants | `scripts/config.lua` | **SEPARATE #87** — ownership decomposition / player-developer-internal boundary |
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

### Terminal / obstruction Resolution

Current D-0147, D-0218 and Cooperative Passage settlement semantics are
purpose-specific and should not be flattened into one generic completion rule.

- D-0147 courtesy completion can discharge the current courtesy obligation.
- D-0218 movement completion requires fresh Situation evidence before semantic
  obstruction success.
- Passage `HANDED_BACK` can discharge one already-authorised participant leg.

> **Execution Settlement != Strategic Reassessment**

Physical Bounded Authority is released independently of semantic Resolution
persistence.

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
| #100 | confirmed concept mismatch | rejected persistent pair-history concept remains as `EncounterRegistry` |
| #101 | behaviour-preserving retirement/naming debt | orphaned Guarded Recovery, stale Control consumer, stranded Constraint semantics, defensive naming |

## Separate accepted work / explicit limits

- **#45** — Bubble Bullet Time remains accepted but unimplemented.
- **#87** — decompose the remaining live `scripts/config.lua` Mixed Runtime
  Constants Surface.
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

Begin **#100 — Encounter reconciliation** with architecture/design before
implementation. Account for every legitimate service of `EncounterRegistry`
before changing or removing the implementation concept.

The correction must preserve unresolved-evidence safety while establishing that
last-positive evidence is not fresh current Reality and missing positive evidence
does not manufacture safe separation.

After #100, unless new Reality changes the order:

1. #101 — dependency-proven retirement/naming cleanup.

Issue #97 is not current drift: PR #103 validation exposed that accepted `main`
already refreshes retained Field World relevance through existing-Snapshot
`resolve()` semantics. Preserve that implementation unless new Reality
contradicts it.

Do not combine these independent responsibilities into one executable tranche.
