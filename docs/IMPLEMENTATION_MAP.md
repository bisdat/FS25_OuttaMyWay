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

- Accepted Repository State: `main` at
  `53c0b9c094e0bebfed65b92bab1b8c955f20ea15`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity remains
  **`0.3.0.65`**.
- Issue #87 remains active through Root Surface Closure. The working Diagnostic
  HUD Ownership increment uses `0.3.0.66 TEST — DIAGNOSTIC HUD OWNERSHIP`;
  independent CI validation and owner review remain pending.
- Phase 14 strangler is **CLOSED**.
- Phase 15 whole-system architecture <-> code audit is **COMPLETE**.

## Principal current responsibility placement

| Architectural responsibility | Principal current source placement | Current disposition |
|---|---|---|
| Root system/build identity | `scripts/config.lua`, `modDesc.xml`; consumers in `Runtime.lua` and `VersionHud.lua` | Only `MOD_NAME` and `VERSION` remain root identities under [Configuration architecture](CONFIGURATION.md#configuration-and-other-value-responsibilities). Startup/HUD use `VERSION`; Runtime state/status and initialization trace carry no mode or architecture-version identity. ReplayRunner provenance retains its source without architecture-version decoration. |
| Runtime composition | `scripts/main.lua`, `scripts/runtime/Runtime.lua`, `LiveRuntimeCoordinator.lua` | PRESERVE explicit production composition |
| Job Episode identity | `scripts/identity/JobEpisodeAdmission.lua` | PRESERVE Lifecycle Evidence Asymmetry |
| Local Operation identity/membership | `scripts/identity/OperationAdmission.lua` | PRESERVE lifecycle context; not traffic controller |
| Field World snapshots/equivalence | `FieldWorldSnapshotRegistry.lua`, `FieldWorldEquivalenceEvaluator.lua`, `FieldWorldEquivalenceAuthority.lua`, `LiveObservationSource.lua` | PRESERVE — `.58` localises Snapshot/fingerprint production values to the Registry, interpretation thresholds to the Evaluator, and evidence-history retention bounds to the Authority; retained tracks keep immutable Snapshot assignment semantics |
| Current Physical Assembly acquisition | `scripts/observation/CurrentPhysicalAssemblySource.lua` | PRESERVE mission-root addressability; no semantic authority |
| Current pose / live Observation | `CurrentPhysicalPoseSource.lua`, `LiveObservationSource.lua`, `LiveInteractionObservation.lua` | PRESERVE factual/provenance boundary |
| Physical representation cache | `scripts/representation/AssemblyRepresentationCache.lua` | PRESERVE — member-discovery truncation revokes Transit complete-assembly authority at representation construction (#99 / PR #106); `.55` localises the 32-member bound and `.56` owns its per-member hierarchy-discovery and Job-scoped membership-revalidation bounds locally |
| Transit settlement derivation / defensive fallback | `AssemblyRepresentationCache.lua`; `TransitConfigurationMechanism.lua` | Cache owns bootstrap capability timeout derivation; Mechanism consumes it and separately owns its missing-timeout Control fail-safe under [Configuration architecture](CONFIGURATION.md#transit-fold-settlement-ownership). CooperativePassageControl consumes cached capability / settlement results. Equal fallback literals do not establish shared policy. |
| Entity-Local Shape Evidence | `scripts/representation/EntityLocalShapeEvidence.lua` | `.57` shared Resolution evidence predicate only — owns geometry/world coherence and descendant/root-alias discrimination; no discovery, coverage or product authority |
| Generic current physical conflict | `CurrentPhysicalConflictRepresentation.lua` | PRESERVE positive-only / no generic negative-clearance authority; `.56` owns its whole-current-assembly candidate scan budget and candidate-discovery refresh horizon locally |
| Local Passage construction policy / calibration | `scripts/candidates/LocalPassagePlanner.lua` | Owns ten fixed independent values for construction policy, excursion/entry, guide gates and sweep evidence under [Configuration architecture](CONFIGURATION.md#local-passage-planner-policy-and-calibration-ownership). Supplies nominal clearance to PairSpecificPassageClearance. Shared Owner != Shared Concept; no settings object or runtime policy override. |
| Passage-specific geometry | `AssemblyRepresentationCache.lua`, `PairSpecificPassageClearance.lua`, `LocalPassagePlanner.lua` | PRESERVE directional Transit Passage contract for non-truncated complete assemblies |
| Situation Assessment | `scripts/assessment/SituationAssessment.lua` and focused assessment collaborators | PRESERVE current interpreted relationship ownership except listed drift |
| Current Pair Assessment Scope | `scripts/assessment/CurrentPairAssessmentScope.lua` plus `SituationAssessment.lua` | PRESERVE — accepted by #100 / PR #113; ephemeral current Operation/exact-Job-Episode pair scope with no generic pair lifecycle or last-positive truth |
| Follower Boundary evidence | `scripts/assessment/FollowerBoundaryDemandAssessment.lua` | PRESERVE admissible magnitude evidence/envelope; `.62` makes the evaluator explicit owner of its six alignment/retention/clearance/temporal-seed calibrations; no requested Control target (#98 / PR #108) |
| Forward Intersection / Action-Space evidence | `SpatialConstraintAssessment.lua`, `TrajectoryConflictAssessment.lua` | PRESERVE current positive/unresolved/negative semantics; `.61` makes Trajectory Conflict Assessment the explicit owner of its ten sampling/persistence/opposed-current calibrations while Passage Action-Space separation remains external context |
| Causal Obstruction | `CausalObstructionAssessment.lua` | PRESERVE: current GIANTS inactivity observation and ENDED Job Episode are two evidence routes into the same non-active classification; no provenance-specific downstream responsibility |
| Candidate construction / planning | `scripts/candidates/` | PRESERVE feasible option/support/planning ownership; `.63` removes per-capability Follower/Passage rollout vetoes so Candidate support is governed by current evidence and responsibility architecture |
| Prospective Candidate portfolio | `ProspectiveDecisionPortfolioSupport.lua` | PRESERVE complete fresh group enumeration on one Decision picture |
| Constraint evaluation | `scripts/constraints/ConstraintEngine.lua` plus four canonical evaluators | PRESERVE independently owned mandatory verdicts; `.43` retires only the production-unreachable historical Follower Owns Closure prohibition |
| Decision / policy | `DecisionSelector.lua`, `TrafficPolicemanDecisionPolicy.lua`, `ProspectivePortfolioDecisionPolicy.lua` | PRESERVE supported choice / compatibility policy |
| Responsibility Transition | `ResponsibilityTransitionAuthority.lua` plus purpose-specific transition modules | PRESERVE semantic establishment/replacement/termination; #112 `.44` renames only the shared obstruction-relocation RTA seam to current responsibility vocabulary |
| Generic retained Commitment / obligations | `scripts/commitment/` | RETAIN subordinate substrate; not Current Responsibility authority |
| Regulation semantic responsibility | `scripts/contracts/Regulation.lua` and transition modules | PRESERVE one Regulation responsibility with purpose-specific evidence |
| Resolution semantic responsibility | `ResolutionCommitment.lua`, `ResolutionCommitmentAdapter.lua`, purpose-specific transition/lifecycle modules | PRESERVE obligation-backed strong persistence |
| Passage Leg lifecycle | `LiveTrafficCommitmentLifecycle.lua`, Passage obligations and Control callbacks | PRESERVE Survivor Invariance / participant handback-vacatur / Last-Leg Dissolution |
| Bounded Authority | `scripts/authority/BoundedAuthority.lua` | PRESERVE semantic permission distinct from `AU-*` exclusivity |
| Regulation Bounded Authority | `RegulationBoundedAuthority.lua`, `ResolutionSpaceProgressionEnvelope.lua`, `FollowerBoundaryMagnitudePolicy.lua` | ResolutionSpaceProgressionEnvelope owns fixed reserve/creep policy; RegulationBoundedAuthority materialises it through the two-evidence-argument establish contract under [Configuration architecture](CONFIGURATION.md#resolution-space-regulation-magnitude-policy-ownership). Forward Intersection retains its separate direct fixed cap. PRESERVE authority-owned final follower speed permission from accepted admissible evidence (#98 / PR #108) |
| Effective actuation composition | `EffectiveActuationComposition.lua` | PRESERVE |
| Mechanical exclusivity | `AuthorityRegistry.lua` | PRESERVE; exclusivity is not permission |
| Control routing | `LiveControlDispatcher.lua` | PRESERVE authorised typed routing; `.63` makes this topology, downstream of Bounded Authority, the actual capability boundary rather than Control pseudo-state booleans |
| Regulation Control | `RegulationControl.lua`, `NativeDriveMechanism.lua` | PRESERVE production speed executor |
| Cooperative Passage Control | `CooperativePassageControl.lua` plus shared mechanisms | Owns seven module-local execution/settlement/alignment/watchdog/heartbeat calibrations, including independent axis-travel station completion tolerance under [Configuration architecture](CONFIGURATION.md#cooperative-passage-control-implementation-ownership). Validated mechanics, participant-specific handback and lifecycle/safety/feasibility boundaries remain unchanged; Candidate guide radii still reach setReposition; Control station tolerance reaches setAxisTravel. |
| Obstruction Relocation Control | `ObstructionRelocationControl.lua`, `NonJobActuationMechanism.lua` | PRESERVE one provenance-neutral physical executor beneath one Causal Obstruction / Obstruction Relocation responsibility; `.51` retires the already-uninstantiated D-0147 donor topology around it |
| Relocation Serialization | `RegulationBoundedAuthority.lua` supporting Obstruction Relocation movement | PRESERVE current beneficiary protection |
| Guarded Recovery compatibility | no current production placement | **RETIRED / ACCEPTED #101 / PR #115** — dependency-proven orphan generation removed in `.42`; current Passage recovery/restoration remains elsewhere |
| Diagnostics / probes | `scripts/diagnostics/` and passive observation probes | PRESERVE downstream-only diagnostic directionality; `.59` retires the expired follower-maturation shadow and `.60` localises five live instruments' enablement/publication controls without moving semantic authority |
| Clearance trace publication | `scripts/candidates/LiveTrafficCandidateSupport.lua` | Owns the local 40.0 m window for rejected/selected already-computed clearance telemetry under [Configuration architecture](CONFIGURATION.md#clearance-trace-diagnostic-publication-ownership). Diagnostic publication does not own Passage search or construction policy; the local Action-Space / entry bound remains unresolved. |
| Diagnostic HUD presentation | `scripts/diagnostics/FutureSpaceHud.lua`, `VersionHud.lua`, `FollowerPacingHud.lua` | Each instrument owns its enablement/layout literals locally under [Configuration architecture](CONFIGURATION.md#diagnostic-hud-implementation-ownership). FutureSpaceHud remains constructed, observed and drawn by PassiveLiveValidator; VersionHud reads root `VERSION`. Dead lifecycle/transition gates are deleted without replacement; future player HUD visibility remains separate and unimplemented. |
| Mixed runtime constants | `scripts/config.lua` | **ACTIVE #87** — `.52`-.62 resolve prior ownership/retirement families; `.63` retires the remaining core-capability/control pseudo-state gates. Root identity retirement leaves only `MOD_NAME` and `VERSION`; diagnostic HUD values are now module-local or retired; Cooperative Passage Control owns its seven internal calibrations. Resolution-Space reserve/creep policy is module-owned by ResolutionSpaceProgressionEnvelope. Transit settlement derivation and defensive fallback have separate module owners. LocalPassagePlanner owns its ten fixed construction/sweep values. Spatial Gate Radius != Axis Station Tolerance: the two 1.0 m calibrations have independent Planner and Control owners under [Configuration architecture](CONFIGURATION.md#cooperative-passage-control-implementation-ownership). Exactly two non-identity roots remain: the 80 m local Action-Space / entry bound and Forward Intersection 1 km/h policy. Their deeper ownership remains unresolved. |
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
| #87 | mixed runtime constants / Root Surface Closure | **Two Root Identities; Everything Else Must Earn an Owner** remains the direction for value ownership/retirement. Production and validation vocabulary closure are in the accepted baseline. Diagnostic HUD ownership removes this presentation family from the mixed root while preserving accepted literals and behaviour. Player Configuration is split to #139 and HUD/player communication remains #89. |

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

The working Diagnostic HUD Ownership increment localises the three instruments'
presentation values and deletes the two unconsumed legacy gates. Structural
contracts protect exact accepted local literals, absence of root HUD dependencies
and the indirect FutureSpaceHud lifecycle through PassiveLiveValidator.

Independent CI validation and owner review remain pending. This increment does
not implement player Configuration or change HUD text, visuals, traffic semantics,
policy or calibration. Continuation-State workflow reconciliation remains separate
under #141; this placement update does not redesign that workflow.
