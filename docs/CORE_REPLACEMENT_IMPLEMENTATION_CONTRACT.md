# FS25_OuttaMyWay Core Replacement Implementation Contract

> **Authority source:** owner-declared canonical v4.6.78, as explicitly extended by accepted ADR-0021  
> **Canonical ZIP SHA-256:** `bf7ec80f5cfc7c2690cf0f599fd3acf82fd3df6b197acb1dd7a5950f7b6da9e5`  
> **Canonical Git commit:** `a99834bba898a876fcb8315aeb5741833b099d85`  
> **Repository files:** 174  
> **Contract status:** accepted implementation contract; v4.7.0 bootstrap implementation  
> **Architecture authority:** current `docs/ARCHITECTURE.md`, ADR-0019, ADR-0021 and their normative companion contracts

## 1. Purpose

This contract defines how the accepted replacement-core architecture will be implemented without allowing the legacy runtime to redefine, weaken or supplement it. Canonical v4.6.78 remains the foundation; ADR-0021 is a bounded evidence-driven amendment to Field World identity authority.

The replacement programme is governed by:

> **Greenfield architecture kernel, brownfield empirical mechanisms.**

The reasoning and lifecycle core will be written afresh from canonical contracts. Existing code may supply only verified observations, GIANTS integration techniques, physical-control mechanisms, diagnostic infrastructure and failure evidence.

The existing procedural core is not:

- the behavioural specification;
- the new module topology;
- a fallback authority;
- a source of lifecycle meaning;
- a template to be incrementally surrounded by replacement logic.

## 2. Closed architecture rule

The accepted replacement-core architecture is closed for implementation. Canonical v4.6.78 remains its foundation, with only explicit owner-accepted ADR amendments permitted; as of canonical v4.7.14, ADR-0021 is the sole such amendment and is implemented and live-validated for the accepted Field World cases.

Implementation must not introduce:

- a fourth non-terminal Commitment state;
- another terminal disposition;
- another obligation settlement mode;
- another internal obligation-owner class;
- a second progress-actuation owner;
- a new route-ownership or route-substitution responsibility;
- a fixture-specific exception to a mandatory constraint;
- an implicit completion, expiry or cleanup path;
- a new architectural concept inferred from legacy behaviour.

Implementation may discover only how to realise already-canonical responsibilities through data structures, GIANTS adapters, physical capabilities, thresholds and evidence collection.

### Stop condition

When implementation evidence appears incompatible with the current accepted architecture:

1. do not add a special case;
2. do not infer a new rule from old code;
3. do not weaken a mandatory verdict;
4. preserve the evidence;
5. classify the issue as an apparent architecture contradiction;
6. stop the affected implementation path for explicit owner review.

## 3. Source inspection result

### 3.1 Existing repository shape

The active script loader currently imports a broad chain containing:

- observation and geometry probes;
- predictive and encounter interpretation;
- several Decision implementations;
- multiple Control controllers;
- legacy recovery, reservation and handover logic;
- a 3,125-line `scripts/core/Runtime.lua` orchestrator.

The current execution path therefore mixes observation, interpretation, Decision, lifecycle, authority and physical actuation.

This confirms that the replacement kernel must not be inserted into the old orchestration as another layer.

### 3.2 Reusable empirical areas

The repository contains expensive empirical knowledge in:

- `scripts/observer/NativeAI.lua`
- `scripts/observer/WorkerState.lua`
- `scripts/observer/Observer.lua`
- `scripts/geometry/FieldBoundary.lua`
- `scripts/geometry/PhysicalEnvelopeEvidence.lua`
- `scripts/geometry/FacingExtentProvider.lua`
- `scripts/geometry/ShadowClearanceCalculator.lua`
- collision catalogues and physical-assembly probes
- `scripts/control/TrafficPermissionGate.lua`
- physical sections of `scripts/control/UnilateralSidestepController.lua`
- physical state and GIANTS handback functions in `scripts/core/Runtime.lua`
- `scripts/diagnostics/Logger.lua`
- retained prototype evidence and historical logs.

These are donors, not automatically reusable modules.

### 3.3 Superseded governing areas

The following active structures must not govern the replacement core:

- `scripts/decision/DecisionEngine.lua`
- `scripts/control/TrafficDecisionEngineV2.lua`
- `scripts/control/TrafficManagerV2.lua`
- `scripts/control/TrafficExecutorV2.lua`
- `scripts/control/EncounterController.lua`
- lifecycle and action-selection portions of `AutomaticEncounterAdmission.lua`
- role, strategy and lifecycle portions of `SingleWorkerDelayController.lua`
- role, phase and completion semantics in `UnilateralSidestepController.lua`
- branch-local handover semantics in `RecoveryHandoff.lua`
- legacy reservation ownership
- the Decision/recovery/conflict orchestration in `Runtime.lua`.

Their behaviour remains historical evidence only.

## 4. Replacement-core topology

The following topology is an implementation decomposition of the canonical responsibility map. It adds no architectural responsibility.

```text
scripts/
├── main.lua
├── config.lua
├── runtime/
│   └── Runtime.lua
├── contracts/
│   ├── ObservationSnapshot.lua
│   ├── OperationalPicture.lua
│   ├── CandidateAction.lua
│   ├── ConstraintVerdict.lua
│   ├── DecisionRecord.lua
│   ├── CommitmentRecord.lua
│   ├── ObligationRecord.lua
│   ├── ControlRequest.lua
│   └── ControlOutcome.lua
├── identity/
│   ├── IdentityRegistry.lua
│   └── JobEpisodeAdmission.lua
├── observation/
│   └── RuntimeObservationAdapter.lua
├── assessment/
│   └── SituationAssessment.lua
├── candidates/
│   ├── CandidateSpace.lua
│   └── generators/
├── constraints/
│   ├── ConstraintEngine.lua
│   └── evaluators/
├── decision/
│   └── DecisionSelector.lua
├── commitment/
│   ├── CommitmentRegistry.lua
│   ├── CommitmentStateMachine.lua
│   ├── ObligationLedger.lua
│   ├── GoverningBasisEvaluator.lua
│   └── TerminalSettlementEvaluator.lua
├── authority/
│   ├── AuthorityRegistry.lua
│   └── EffectiveActuationComposition.lua
├── control/
│   ├── ControlAdmission.lua
│   ├── CapabilityRegistry.lua
│   └── capabilities/
├── replay/
│   ├── ReplayRunner.lua
│   └── ConformanceAssertions.lua
└── diagnostics/
    └── ArchitectureTrace.lua
```

These active implementation names are settled. The exact canonical v4.6.78 script tree is preserved under `scripts/archive/v4_6_78/` and is non-executable. Active code must never source or call the archive.

## 5. Authoritative data contracts

All published records are value records. Once published for an epoch, they must not be mutated. Revised knowledge creates a new record and epoch.

### 5.1 Observation Snapshot

**Owner:** Observation  
**Input:** raw GIANTS/runtime facts  
**Output:** immutable `ObservationSnapshot`

Required content:

- observation epoch and timestamp;
- source provenance;
- Field World observations;
- assembly identities and component membership;
- raw position, orientation, motion and configuration facts;
- raw GIANTS AI flags and references;
- player-control facts;
- raw Job Episode evidence;
- raw Operation-membership evidence;
- raw physical-representation evidence;
- Control Outcomes observed since the previous epoch;
- missing, stale or unavailable sources.

It must not contain:

- selected Yield or Progress roles;
- candidate preference;
- Commitment state;
- terminal cause;
- admissibility;
- interpretation that a blocked worker's Job Episode ended.

### 5.2 Operational Picture

**Owner:** Situation Assessment  
**Input:** one Observation Snapshot plus prior canonical identity context  
**Output:** immutable `OperationalPicture`

Required content:

- Situation and Encounter relationships;
- admitted assembly, Job Episode and Operation identities;
- Current Space and bounded Future Space;
- Committed Demand, Potential Demand and Temporary Slack;
- responsibility relations;
- uncertainty;
- Representation Fitness and provenance;
- Control-outcome interpretation evidence;
- candidate-support evidence;
- current Commitment context as supplied facts, not mutated lifecycle.

Situation Assessment must not:

- choose an action;
- choose one refuge candidate;
- transition a Commitment;
- grant actuation authority.

### 5.3 Candidate Action

The implementation must reproduce every field in `docs/CANDIDATE_ACTION_CONTRACT.md`:

- identity;
- purpose;
- subject;
- capability;
- expected effect;
- evidence basis;
- Representation Fitness;
- preconditions;
- invalidation conditions;
- reversibility;
- obligations created;
- release implications;
- uncertainty;
- comparison cost.

Candidate generators publish all currently supportable alternatives. They do not select.

### 5.4 Constraint Verdict

Every applicable mandatory constraint produces exactly one:

- `PASS`
- `FAIL`
- `UNRESOLVED`

Each verdict carries:

- constraint identity;
- owning evaluator;
- candidate identity;
- evidence and provenance;
- validity epoch;
- reason;
- revalidation trigger.

A `FAIL` or `UNRESOLVED` mandatory verdict cannot be overridden by Decision, a fallback branch, Control or elapsed time.

### 5.5 Decision Record

A Decision Record contains:

- Decision identity and epoch;
- Operational Picture identity;
- complete candidate inventory identity;
- complete mandatory verdict-set identity;
- viable candidate identities;
- selected candidate identity, or explicit non-intervention;
- comparison basis used only after mandatory admissibility;
- current Commitment action: create, maintain, revise, wait or settle;
- explanation and provenance.

Decision must be deterministic for identical sealed inputs.

### 5.6 Commitment Record

The record must contain the canonical fields:

- identity;
- objective;
- Governing Basis;
- lifecycle state;
- strategy;
- Situation dependencies;
- Obligation Set;
- progress-actuation ownership;
- capability reservations;
- validated Effective Actuation Composition;
- evidence contracts;
- intended terminal disposition;
- terminal cause;
- terminal-settlement evidence.

Only the Commitment state machine may perform lifecycle transitions.

### 5.7 Obligation Record

Required fields:

- stable identity;
- origin;
- basis;
- exactly one owning Commitment;
- required outcome;
- required authority;
- evidence contract;
- ownership class;
- transfer policy;
- terminal dependency;
- settlement disposition;
- ownership history.

Settlement modes are exclusively:

- satisfaction;
- evidenced basis cessation;
- atomic accepted transfer.

### 5.8 Control Request and Outcome

A Control Request carries:

- request identity;
- issuing Commitment identity;
- assembly identity;
- capability;
- target;
- authority token;
- Operational Picture and evidence epochs;
- validated composition identity;
- preconditions and invalidation conditions.

A Control Outcome carries physical facts only:

- request identity;
- accepted/rejected/deferred status;
- observed physical effect;
- progress;
- completion evidence;
- failure evidence;
- source and timestamp provenance.

Control does not declare Commitment success or select a subsequent strategy.

## 6. Canonical requirement-to-module enforcement map

| Canonical requirement | Enforcing module boundary | Required executable evidence |
|---|---|---|
| One Observation → Assessment → Picture → Decision → Commitment → Control path | `runtime/Runtime.lua` and dependency audit | no dispatch route bypasses the kernel |
| Observation contains raw facts only | `RuntimeObservationAdapter`, `ObservationSnapshot` validator | negative tests reject semantic/Decision fields |
| Situation Assessment produces Knowledge only | `SituationAssessment`, `OperationalPicture` validator | snapshot-to-picture deterministic tests |
| Complete supportable Candidate Action Space | `CandidateSpace` and generators | candidate inventory assertions for every fixture |
| Mandatory verdicts | `ConstraintEngine` and evaluators | every candidate has every applicable verdict |
| Failed/unresolved candidate exclusion | `DecisionSelector` | negative tests prove selection is impossible |
| Deterministic Decision | `DecisionSelector` | identical sealed inputs produce identical result |
| Governing Basis | `GoverningBasisEvaluator` | blockage, stop, takeover, restart and supersession fixtures |
| Three-state lifecycle | `CommitmentStateMachine` | legal table plus illegal-transition rejection |
| Exactly one obligation owner | `ObligationLedger` | assertion after every mutation/transfer |
| No terminal state with open obligations | `TerminalSettlementEvaluator` | terminal transition rejection tests |
| First authoritative invalidation fixes terminal cause | `GoverningBasisEvaluator`, state machine | event-order fixtures |
| One progress owner per assembly | `AuthorityRegistry` | lease conflict rejection |
| Effective Actuation Composition | `EffectiveActuationComposition`, `ControlAdmission` | residual and concurrent-effect tests |
| Stale authority rejection | `ControlAdmission` | old picture/basis/composition epoch tests |
| Representation Fitness limits authority | action-specific constraint evaluator | insufficient fitness cannot reach Control |
| Control reports physical outcome only | capability adapters and outcome validator | outcome cannot encode lifecycle transition |
| Player is not an Obligation owner | `ObligationLedger` owner validator | external-player owner rejected |
| Operation termination preserves origin-bound obligations | state machine and obligation ledger | zero-membership settlement fixture |
| Terminal Occupancy | canonical candidate/obligation generation | demand-basis creation and cessation tests |
| Continuing Intent Priority | Governing Basis and constraint evaluator | blocked/Held/inactive episodes remain admitted |
| Preference exhaustion is not candidate exhaustion | Candidate Space and Decision tests | lower preference candidates remain visible |
| Replay before live authority | `ReplayRunner`, gate script | mandatory suite clean before active mode |

## 7. Mandatory constraint evaluator set

Canonical v4.6.78 requires explicit evaluators for at least:

1. Field World containment;
2. complete-envelope clearance and transition sweep;
3. Representation Fitness;
4. Control capability availability;
5. Continuing Intent Priority;
6. progress preservation and `never hold all`;
7. responsibility relations, including Follower Owns Closure;
8. current Obligation compatibility;
9. Commitment Preconditions;
10. authority conflicts;
11. Effective Actuation Composition;
12. Safe Release and Safe Handover implications.

The Constraint Engine may orchestrate these evaluators. It may not merge them into an opaque aggregate boolean.

## 8. Commitment-state implementation contract

### `ACTIVE`

Permitted:

- reassessment;
- strategy revision;
- candidate evaluation;
- validated objective-progress Control;
- immediate safety;
- obligation creation, satisfaction and eligible transfer;
- transition to `WAITING_FOR_EVIDENCE` or `SETTLING`.

### `WAITING_FOR_EVIDENCE`

Permitted:

- observation;
- evidence acquisition;
- bounded safety;
- preservation of only necessary existing effects;
- return to `ACTIVE` after evidence and candidate revalidation;
- transition to `SETTLING`.

Prohibited:

- speculative progress;
- success inferred from time, inactivity or silence.

### `SETTLING`

Permitted:

- observation;
- reconciliation of issued Control;
- evidence acquisition;
- authority release;
- obligation satisfaction, basis cessation or accepted transfer;
- bounded safety.

Prohibited:

- new objective-progress Control;
- strategy revival;
- return to progress on the ended objective;
- terminal entry with an open obligation.

### Terminal dispositions

Only:

- `SUCCEEDED`
- `FAILED`
- `SUPERSEDED_BY_NEW_INTENT`
- `CANCELLED_BY_SOURCE_INTENT_TERMINATION`
- `CANCELLED_BY_OPERATION_TERMINATION`

## 9. Legacy module disposition policy

Each legacy file/function receives one disposition:

### `RETAIN_INFRASTRUCTURE`

Generic infrastructure with no architectural Decision authority. It may be retained with dependency review.

### `RETAIN_MECHANISM_DONOR`

A physically proven mechanism may be extracted behind a new capability contract. The old caller and lifecycle semantics are not retained.

### `REIMPLEMENT_CONCEPT`

The concept is canonical or empirically useful, but the current code mixes responsibilities. Reimplement from canonical inputs/outputs.

### `EVIDENCE_ONLY`

Preserve logs, calculations, fixtures or failure history. Do not execute as part of the new core.

### `DISCARD_GOVERNING_CORE`

The active logic embodies superseded Decision, lifecycle, authority or fallback semantics. It must not be called by the replacement core.

### `ADAPT_ENTRY_INFRASTRUCTURE`

Loader/configuration integration may be adapted only to load and gate the replacement core. It has no architectural authority.

The accompanying CSV records the initial file-level classification. Function-level extraction remains mandatory before any donor code is copied.

## 10. Physical capability donor boundary

### 10.1 Hold

Likely donor:

- `scripts/control/TrafficPermissionGate.lua`

Allowed extraction:

- installation of the GIANTS continuation permission interception;
- apply/release primitive;
- raw call and effect observations.

Forbidden inheritance:

- role selection;
- Hold purpose;
- release timing;
- encounter completion;
- fallback to reposition;
- any caller-owned lifecycle flag.

### 10.2 Movement/manoeuvre leg

Likely donors:

- `AIVehicleUtil.driveToPoint` interception in `UnilateralSidestepController.lua`;
- narrowly identified movement calculations and outcome observations.

Allowed extraction:

- one authorised leg;
- target and direction application;
- raw physical progress and failure outcome.

Forbidden inheritance:

- the existing phase machine;
- fixed fixture assumptions;
- refuge selection;
- Commitment completion;
- automatic selection of another leg.

### 10.3 Configuration

Likely donors:

- `setParkedWorkState`
- `setBackoutRaisedState`
- `setParkedFoldState`

Allowed extraction:

- physical command invocation;
- raw observed configuration outcome.

Forbidden inheritance:

- determining when configuration is required;
- declaring restoration sufficient;
- deciding terminal settlement.

### 10.4 Native handback

Likely donors:

- `requestAIFieldWorkerResume`;
- proven event/method invocation sequence;
- raw motion verification evidence.

Forbidden inheritance:

- automatic restart escalation as architectural policy;
- declaring handover operationally sufficient;
- ending a Commitment.

## 11. Passive validation boundary

Canonical `MIGRATION_PLAN.md` requires passive live shadow before active authority.

To avoid another parallel controller:

- only the replacement kernel may publish candidate, verdict, Decision, Commitment and Obligation traces;
- legacy Decision and Control paths must be disabled for the selected passive fixture;
- the replacement kernel has zero Control authority;
- the legacy runtime is not the answer oracle;
- comparison is against canonical invariant expectations and recorded Reality;
- mismatches are corrected offline before another live build.

Passive shadow therefore validates observation and reasoning composition. It is not a permanent second system.

## 12. Deterministic test contract

### 12.1 Contract validation tests

- records reject missing required fields;
- sealed records cannot be mutated;
- identities and epochs are stable;
- source provenance is mandatory;
- value records do not contain runtime object ownership outside declared references.

### 12.2 Candidate and constraint tests

- every supported candidate is published;
- each applicable mandatory evaluator returns one verdict;
- `FAIL` and `UNRESOLVED` candidates cannot be selected;
- preference order is applied only after admissibility;
- candidate absence is explicit;
- non-intervention is a Decision result, not a missing branch.

### 12.3 Commitment tests

- only legal transitions occur;
- `SETTLING → ACTIVE` is rejected;
- terminal entry with open obligation is rejected;
- capability completion alone cannot produce `SUCCEEDED`;
- first invalidation fixes terminal cause;
- multi-stage strategy preserves Commitment identity;
- evidence insufficiency produces `WAITING_FOR_EVIDENCE`, not completion.

### 12.4 Obligation tests

- exactly one owner always exists;
- origin-bound transfer is rejected;
- transfer is atomic;
- player ownership is rejected;
- basis cessation requires evidence;
- Operation membership reaching zero does not erase origin-bound obligations.

### 12.5 Authority and composition tests

- second progress owner is rejected;
- safety veto is not recorded as progress ownership;
- stale authority token is rejected;
- residual predecessor effect blocks incompatible successor Control;
- individually valid actions with invalid composition are rejected;
- `never hold all` is enforced as part of composition.

### 12.6 Job Episode and Governing Basis tests

- blockage does not end an episode;
- OuttaMyWay Hold does not end an episode;
- temporary inactivity does not end an episode;
- player stop ends the episode;
- player takeover ends the episode;
- GIANTS abort/fault ends the episode;
- restart creates a new identity;
- incidental participant change does not invalidate an unrelated Governing Basis;
- replacement intent produces supersession only when the predecessor is still live.

### 12.7 Required replay fixtures

Use the exact fixture families named in canonical `REPLAY_VALIDATION_SPECIFICATION.md`:

- v4.6.49 local passage;
- v4.6.57 freeze-line evidence;
- v4.6.64 recovery/Native Handover;
- v4.6.70 Hold-release failure;
- v4.6.72–v4.6.77, especially v4.6.77 near architecture time `t=209.3s`;
- TS016 crossing/head-on;
- no-mod and no-encounter controls.

Replay validates architecture composition. It does not simulate physics or prove live success.

## 13. v4.7.0 bootstrap scope

The owner accepted a new v4.7.x implementation line. v4.7.0 contains only:

### Documentation and governance

- this Implementation Contract integrated into `docs/`;
- canonical status metadata updated from “candidate” to owner-declared v4.6.78 where still stale;
- file-level and function-level donor/removal register;
- exact release scope and acceptance tests.

### New non-actuating code

- immutable record constructors/validators;
- identity and epoch primitives;
- Commitment state-machine skeleton;
- Obligation Ledger skeleton;
- Authority Registry skeleton;
- no GIANTS observation connection;
- no legacy Decision import;
- no physical Control;
- deterministic architecture-conformance tests.

### Explicit exclusions

- no candidate geometry;
- no refuge Decision;
- no passive live build yet;
- no active Hold;
- no adaptation of legacy encounter lifecycle;
- no Control gateway connected to GIANTS;
- no attempt to reproduce old runtime behaviour.

## 14. v4.7.0 acceptance gate

The candidate is acceptable only when:

1. the v4.6.78 active script tree is preserved byte-exactly under `scripts/archive/v4_6_78/`;
2. the new kernel has no dependency on legacy Decision/control orchestration;
3. all record validators pass;
4. the three-state lifecycle legal table passes;
5. every illegal transition is rejected;
6. no terminal transition accepts an open obligation;
7. exactly-one-owner assertions pass;
8. second progress-owner acquisition is rejected;
9. deterministic repeats produce identical records;
10. RRS, manifest, link, version and load validation pass;
11. repository documentation states that the kernel is inert and has zero Control authority;
12. active code has no dependency on the archived script tree.

## 15. Build-economy rule

A game ZIP must not be requested merely to test pure contracts.

Before the first live-game build, complete:

- record tests;
- state-machine tests;
- obligation tests;
- authority tests;
- candidate/verdict tests;
- replay tests where source records are available;
- static dependency audit;
- RRS and load validation.

A live build is justified only by a proposition that requires GIANTS Reality.

## 16. Decision record

### Accepted implementation position

- replace the reasoning and lifecycle core;
- retain only proven empirical mechanisms behind new interfaces;
- treat old runtime behaviour as evidence, not specification;
- implement canonical v4.6.78 without architectural extension;
- use passive shadow only as the canonical zero-authority validation gate;
- grant live authority only to a bounded replacement slice with legacy authority disabled in that scope.

### Current completion

This contract completes implementation planning and repository forensics at the architectural boundary.

v4.7.0 implements the inert structural kernel and repository boundary described here. It grants no Observation or Control authority and does not reopen canonical architecture.
