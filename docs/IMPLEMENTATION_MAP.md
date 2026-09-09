# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are presently realised in source and identifies material architecture-to-code placement or vocabulary lag. It does not preserve implementation chronology; Git history, pull requests, issues and the Engineering Journal own that evidence.

```text
Architecture       -> what responsibilities should exist
Implementation Map -> where those responsibilities currently appear
Source             -> exactly how they are implemented
```

Architectural meaning remains owned by the [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation Model](architecture/SPATIAL_NEGOTIATION_MODEL.md), [Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md), [Candidate Support Projection Architecture](architecture/CANDIDATE_SUPPORT_PROJECTION.md), [Configuration architecture](CONFIGURATION.md) and [Naming Conventions](NAMING_CONVENTIONS.md).

## Repository state

- Accepted Repository State baseline for this increment: `main` after PR #92 merge, commit `e31791ec510465020da7a0815a901186db3b558e`.
- Canonical authority remains **v0.3.0.0**.
- Current branch executable identity is **`0.3.0.33 TEST — FORWARD INTERSECTION EVIDENCE CONTINUITY`**; acceptance and canonical authority are unchanged until review/merge/Reality evidence says otherwise.
- Strangler Phase 14 remains active. Phase 14.6B is accepted; the planned Phase 14.6C vocabulary/ownership reconciliation resumes after this bounded Issue #37 Reality correction.
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

### Forward Intersection evidence continuity — Issue #37

`.32` Category-2 Condor/Patriot Reality exposed that production correctly
published `relationshipStatus=UNRESOLVED` / `FORWARD_CONTINUATION_UNRESOLVED`,
but `CurrentResponsibilityAssessment` converted that uncertainty into
`TERMINATE`. Runtime then released the fixed 1 km/h lease and the generic
Action-Space settlement helper labelled the purpose positively dissolved.

`.33` keeps ownership at the existing boundaries:

- `SpatialConstraintAssessment` continues to own POSITIVE / UNRESOLVED / NEGATIVE Forward Intersection knowledge and is unchanged;
- `CurrentResponsibilityAssessment` maps temporary Forward Intersection uncertainty to `WAITING_FOR_EVIDENCE` + `PERSIST`;
- existing `RegulationBoundedAuthority` keeps the already-admitted fixed 1 km/h lease active without a new Control path;
- Runtime requires explicit positive dissolution or positive supersession evidence before physical release;
- `LiveTrafficCommitmentLifecycle` independently rejects Forward Intersection settlement that does not satisfy that evidence contract.

No timeout literal, turn-path prediction, Candidate redesign, Passage geometry
change or Control redesign is introduced. Prolonged unresolved evidence remains a
separate bounded fail-safe question if Reality demonstrates that normal fresh
assessment does not resolve it.

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

- Issue #37 — Category-2 Forward Intersection evidence-continuity correction and remaining Reality validation.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.
- Issue #65 — Behaviour Regression Contract != Build Identity Contract.

Do not mix those concerns into the current Phase-14 placement/vocabulary correction without an explicit engineering reason.

## Immediate implementation boundary

Issue #37 is the active bounded correction before planned Phase 14.6C resumes.

`0.3.0.33 TEST — FORWARD INTERSECTION EVIDENCE CONTINUITY` must preserve:

- existing Forward Intersection geometry, temporal allocation and exact 1 km/h policy;
- GIANTS ownership of jobs, route, steering, turning and ordinary navigation;
- Candidate / Constraint / Decision / Responsibility Transition boundaries;
- the existing Regulation physical executor and Bounded Authority path;
- established follower precedence, Cooperative Passage and other Action-Space Regulation semantics.

The intended behavioural delta is only:

```text
established Forward Intersection
    + temporary continuation ambiguity / missing current relation
        -> same Regulation responsibility persists
        -> WAITING_FOR_EVIDENCE
        -> existing yielder remains at 1 km/h

fresh supported NEGATIVE relationship
        -> positive dissolution
        -> release

fresh established successor relationship
        -> positive supersession
        -> release / successor assessment
```

Validation boundary:

1. blocking Structural + Lua CI on exact `.33` head;
2. repeat the Condor/Patriot Category-2 Reality fixture;
3. confirm Patriot remains at 1 km/h through Condor's turn/reverse/square-off ambiguity;
4. confirm fresh negative/successor evidence releases promptly without a sticky timeout;
5. only then reassess the downstream boundary-constrained Passage observation;
6. after owner acceptance, resume Phase 14.6C under Issue #90's existing roadmap.
