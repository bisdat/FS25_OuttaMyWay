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
- Current branch executable identity is **`0.3.0.34 TEST — PRODUCTION VOCABULARY OWNERSHIP RECONCILIATION`**; acceptance and canonical authority are unchanged until review/merge/validation.
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

The strangler has already moved principal production responsibilities to their
accepted architectural homes. Remaining drift is now primarily naming and
declarative ownership:

- Cooperative Passage current execution/configuration surfaces still expose
  `D0146` / `STEP2` development identity despite `CooperativePassageControl`,
  `LocalPassagePlanner` and the current Passage architecture being production.
- `RegulationBoundedAuthority` still exposes D-number owner tags and
  `d0146ActionSpace...` implementation identifiers although Follower Boundary,
  Action-Space Regulation and Forward Intersection are the current purposes.
- `GuardedRecoveryCompatibility` still exposes a D-number lease owner, a
  D-number creep constant and `_legacyRegulationRequest()` despite being an
  explicitly retained current compatibility path.
- Runtime Candidate composition still calls the accepted Completed Obstruction
  Candidate support `legacyTerminalEgressCandidateSupport`.
- `scripts/config.lua` still carries values for positively retired/unsourced
  diagnostics; Phase 14.6C removes that dead mixed-surface residue while Issue
  #87 retains ownership of later decomposition of the remaining live values.
- Issue #93 Reality demonstrated that generic current bounding-disc overlap and
  GIANTS `isBlocked` do not establish Passage contact. Cooperative Passage uses
  purpose-specific Transit geometry plus the empirical nominal-clearance policy.
  The Candidate contract must therefore not advertise generic
  `CURRENT_PHYSICAL_INTERACTION` as Passage invalidation authority.

Phase 14.6C does not tune values, redesign mechanics or create a new
Responsibility. Decision numbers remain legitimate provenance where they explain
a current constraint or historical evidence.

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

`0.3.0.34 TEST — PRODUCTION VOCABULARY OWNERSHIP RECONCILIATION` must:

- graduate primary live Cooperative Passage identifiers away from D-number /
  `STEP2` implementation provenance;
- graduate Follower Boundary, Action-Space Regulation and Guarded Recovery live
  ownership identifiers without changing their policy;
- name Completed Obstruction support truthfully inside Runtime composition;
- remove positively retired/unsourced historical constants from
  `scripts/config.lua` while leaving historical donor source outside production
  composition;
- reconcile the Cooperative Passage Candidate contract with purpose-specific
  Transit representation authority and remove generic
  `CURRENT_PHYSICAL_INTERACTION` from its invalidation list;
- preserve every numeric policy/calibration value and current physical behaviour;
  and
- update current-state documentation without creating another phase/tranche
  document.

Validation boundary:

1. implementation-local Lua syntax, XML parse, static token and diff checks only;
2. blocking Structural + Lua behavioural CI on the exact `.34` head;
3. owner review of the diff and CI;
4. causally appropriate in-game smoke only to disprove accidental behavioural
   change from incomplete vocabulary reconciliation; and
5. after acceptance, proceed directly to the Phase 14 closure review unless new
   evidence genuinely requires another bounded tranche.
