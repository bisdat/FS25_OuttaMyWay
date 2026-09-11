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

- Accepted Repository State: `main` after PR #127 merge,
  `df3493e1cdbb3770287ed1cfba88ec60b0ee7813`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.53 TEST — OBSTRUCTION RELOCATION BOUND OWNERSHIP`**.
- Protected post-merge Offline Validation run #314 passed on the exact merge
  commit.
- Issue #112 remains closed completed.
- Issue #87 is active: `.52` retired the obsolete Obstruction Relocation consent
  gate; `.53` localised its distance/watchdog bounds; remaining mixed constants
  continue family-by-family ownership review.
- Phase 14 strangler is **CLOSED**.
- Phase 15 whole-system architecture <-> code audit is **COMPLETE**.

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
| Current Pair Assessment Scope | `scripts/assessment/CurrentPairAssessmentScope.lua` plus `SituationAssessment.lua` | PRESERVE — accepted by #100 / PR #113; ephemeral current Operation/exact-Job-Episode pair scope with no generic pair lifecycle or last-positive truth |
| Follower Boundary evidence | `scripts/assessment/FollowerBoundaryDemandAssessment.lua` | PRESERVE admissible magnitude evidence/envelope; no requested Control target (#98 / PR #108) |
| Forward Intersection / Action-Space evidence | `SpatialConstraintAssessment.lua`, `TrajectoryConflictAssessment.lua` | PRESERVE current positive/unresolved/negative semantics |
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
| Diagnostics / probes | `scripts/diagnostics/` and passive observation probes | PRESERVE downstream-only diagnostic directionality; `.43` removes the dead Passage target field and reports current `conflictIdentity` in the verdict trace |
| Mixed runtime constants | `scripts/config.lua` | **ACTIVE #87** — `.52` retired obsolete Obstruction Relocation consent; `.53` localised relocation distance/watchdog bounds; `.54` localises Runtime cadence, diagnostic throttling and the Candidate reassessment horizon; broader owner-family decomposition remains incremental |
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
| #87 | mixed runtime constants / Configuration ownership | `scripts/config.lua` still centralises unrelated diagnostic, policy, calibration, watchdog and identity values. `.53` removed the Obstruction Relocation distance/watchdog pair from the root surface. The next bounded correction separates the 250 ms authoritative Runtime-cycle clock, passive diagnostic heartbeat/log limit, and the 1 s Bounded Observation reassessment horizon according to their three current owners. Remaining constants continue family-by-family review. |

Issue #112 is closed completed. Issue #116 independently owns the Cooperative
Passage crossing-window jam investigation. #123 owns deferred GIANTS Reality
validation for new Job / Player Claim during Obstruction Relocation.

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

Implement and validate **#87 `.54 — RUNTIME CADENCE OWNERSHIP`** from accepted
`main` at `df3493e1cdbb3770287ed1cfba88ec60b0ee7813`.

The first `.54` preflight disproved the hypothesis that
`PASSIVE_SAMPLE_INTERVAL_MS` was dead residue. It is consumed by
`PassiveLiveCandidateSupport` to construct the Bounded Observation Contract
`reassessmentDeadline`.

Current evidence therefore identifies three owners rather than one cadence
family:

- `LiveRuntimeCoordinator`: **250 ms** complete live Runtime-cycle cadence;
- `PassiveLiveValidator`: **10 s** diagnostic heartbeat and **8-line** pair-log
  publication limit;
- `PassiveLiveCandidateSupport`: **1 s** Bounded Observation reassessment horizon.

The increment preserves every numeric value exactly and changes placement/name
only. `NEXT_PASSIVE_SAMPLE` contract vocabulary remains untouched pending a
separate semantic review.

No scheduling redesign, cadence retune, Bounded Observation semantic change,
probe-specific interval work, Configuration redesign, broad config reordering,
#123 Reality challenge, #116 Passage work, #45 Bullet Time or #89 HUD work
belongs in this increment.

Protected CI remains the independent offline behavioural authority.
