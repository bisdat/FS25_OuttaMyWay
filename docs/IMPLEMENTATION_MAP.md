# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are presently realised in source and identifies material architecture-to-code placement or vocabulary lag. It does not preserve implementation chronology; Git history, pull requests, issues and the Engineering Journal own that evidence.

```text
Architecture       -> what responsibilities should exist
Implementation Map -> where those responsibilities currently appear
Source             -> exactly how they are implemented
```

Architectural meaning remains owned by the [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation Model](architecture/SPATIAL_NEGOTIATION_MODEL.md), [Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md), [Candidate Support Projection Architecture](architecture/CANDIDATE_SUPPORT_PROJECTION.md), [Configuration architecture](CONFIGURATION.md) and [Naming Conventions](NAMING_CONVENTIONS.md).

## Repository state

- Accepted Repository State baseline: `main` after PR #94 merge, commit `48745375d259140117add5e0abf6047ec3667b17`.
- Canonical authority remains **v0.3.0.0**.
- Current branch executable identity is **`0.3.0.37 TEST — PRODUCTION VOCABULARY VALIDATION CLOSURE`**; acceptance and canonical authority are unchanged until review/merge/validation.
- Strangler Phase 14 remains active. Phase 14.6C is the current final planned vocabulary/ownership reconciliation tranche.
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
| Current Responsibility reassessment | `scripts/assessment/CurrentResponsibilityAssessment.lua` | `.33` corrects Forward Intersection continuation semantics: UNRESOLVED -> WAITING/PERSIST; only positive dissolution/supersession may terminate |
| Prospective spatial constraints | `scripts/assessment/SpatialConstraintAssessment.lua` | PRESERVE; Issue #37 Reality confirms geometry correctly distinguishes POSITIVE / UNRESOLVED / NEGATIVE |
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

### Phase 14.6C — production vocabulary / ownership reconciliation

The primary production-vocabulary graduation is present on the current branch.
PR #95 validation of `.36` exposed four remaining closure defects rather than a
new architectural responsibility:

- Cooperative Passage semantic identities were renamed, but two current
  recognition sites retained the old hard-coded prefix width, changing
  Action-Space terminal settlement, D-0200 dependency collapse and D-0217
  survivor-authority rebind behaviour.
- the whole-pair Passage restore entry point had been retired while its
  unreachable `RESTORING` lifecycle tail remained, making historical topology
  appear current beside the participant-scoped D-0217 lifecycle;
- `COOPERATIVE_PASSAGE_MOVE_SPEED_KMH` was accidentally reused even though that
  historical donor identifier is explicitly retired; the unchanged 8 km/h
  implementation calibration is now owned as Cooperative Passage actuation; and
- the new Phase-14.6C structural contract existed locally but was absent from
  the blocking Structural workflow inventory.

The current `0.3.0.37 TEST — PRODUCTION VOCABULARY VALIDATION CLOSURE` closes those gaps and the remaining lowercase
D-0146 execution/addressability residues found by the exact-head audit. It does
not tune numeric values, redesign Passage mechanics, change Regulation policy,
or create a new Responsibility. Uppercase stable forensic event names and
explicit D-number decision provenance remain legitimate.

### Resolved before Phase 14.6C

Issue #37 is accepted on `.33`: Forward Intersection `UNRESOLVED` now preserves
the existing Regulation as `WAITING_FOR_EVIDENCE`, while supported negative or
successor evidence owns release. Issue #93 is closed as a disproven
Passage-contact hypothesis after direct `.32`/`.33` video review.

## Current explicit limits / separate work

### Generic multi-context application cardinality

Semantic targeting may be unambiguous while generic Commitment application still fails closed if more than one retained context exists. This remains an acceptable fail-closed implementation limit until a concrete supported consumer requires broader cardinality, notably Issue #45.

### Separate Issues

- Issue #45 — Bubble Bullet Time, accepted but unimplemented.
- Issue #65 — Behaviour Regression Contract != Build Identity Contract.
- Issue #87 — decompose the remaining **live** `scripts/config.lua` mixed runtime constants surface by ownership and establish a clear player/developer/internal boundary.
- Issue #90 — roadmap owner through Phase 14 closure, Phase 15 audit and the post-strangler documentation decision.

## Immediate implementation boundary

Phase 14.6C is the current bounded Engineering Increment.

`0.3.0.37 TEST — PRODUCTION VOCABULARY VALIDATION CLOSURE` must:

- repair Cooperative Passage identity recognition using prefix-derived matching
  rather than copied numeric prefix widths;
- preserve current Action-Space terminal settlement, D-0200 Job-Episode
  dependency collapse and D-0217 survivor-authority rebind semantics;
- retire the unreachable whole-pair `RESTORING` tail while preserving the
  participant-scoped restoration / last-leg dissolution lifecycle;
- keep the historical `COOPERATIVE_PASSAGE_MOVE_SPEED_KMH` identifier retired
  and name the unchanged live calibration by current Passage actuation
  responsibility;
- close the remaining current lowercase D-0146 execution/addressability names;
- include the Phase-14.6C semantic contract in blocking Structural CI;
- reconcile current structural contracts to current production vocabulary; and
- preserve every numeric policy/calibration value and intended physical
  behaviour.

Validation boundary:

1. implementation-local Lua syntax, XML parse, static token and diff checks only;
2. blocking Structural + Lua behavioural CI on the exact `.37` head;
3. owner review of the diff and CI;
4. causally appropriate in-game smoke only to disprove accidental behavioural
   change from incomplete vocabulary reconciliation; and
5. after acceptance, proceed directly to the Phase 14 closure review unless new
   evidence genuinely requires another bounded tranche.
