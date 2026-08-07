# FS25_OuttaMyWay v4.6.77 — Holistic Architecture Compliance Audit

**Audit date:** 2026-08-05  
**Implementation under audit:** temporary non-canonical v4.6.77  
**Canonical repository authority:** v4.6.71  
**Audit purpose:** determine why the architecture-first implementation has failed to progress reliably through TS015 Encounter 1, assess compliance against accepted architecture, and define a holistic realignment programme without further spot fixes.

## 1. Executive judgement

v4.6.77 is **not architecture-compliant as an executable system**, although it is substantially better structured than v4.6.49.

The architecture itself is now broadly sufficient for the current milestone. The repeated failures from v4.6.72–v4.6.77 are no longer primarily evidence of missing top-level concepts. They are evidence that accepted architectural rules are represented in documentation and module names but are not enforced as executable contracts at system boundaries.

The central unresolved finding from the v4.6.49 audit remains:

> **Architectural Constraint Enforcement Gap:** architectural invariants exist, but they are not mandatory gates that every action and lifecycle transition must pass.

v4.6.77 has one active `Observation → Situation Assessment → Operational Picture → Decision → Commitment → Control` route. However:

- `SituationAssessment` already selects and labels preferred action candidates;
- `DecisionEngineActive` is a 1,074-line procedural fallback ladder rather than an explicit Action Space evaluator;
- `CommitmentLedger` records lifecycle decisions but does not enforce lifecycle invariants;
- `ControlCapabilities` is comparatively well bounded, but it receives authority produced by the weak boundaries above;
- tests validate module vocabulary and isolated branches, not the complete architecture composition;
- the legacy Prototype 16 controller still carries a broad physical passage state machine and fixture-derived representation support.

The project has therefore moved from **controller-local procedural decisions** to **architecture-shaped procedural decisions**. Responsibility names changed; enforcement did not fully change.

No further active behavioural build should be made until the architecture kernel is made deterministic, replayable and self-policing.

## 2. Evidence that v4.6.77 violates accepted architecture

The accepted architecture states:

- capability completion is not Commitment completion;
- persistent intent ends only at Safe Release, cancellation or explicit failure;
- Safe Release is the only normal Commitment-completion gate;
- Intent Expiry requires reassessment; it does not itself prove operational resolution;
- Decision must apply all mandatory constraints;
- Control cannot waive admissibility.

In the v4.6.77 TS015 run:

1. `CM-00001` completed Native Reposition and Native Handover successfully.
2. Situation Assessment still reported Condor as Leader, Patriot as Follower, and closure responsibility on Patriot.
3. At architecture time `t=209.3s`, Decision emitted `lifecycle=COMPLETE` while `safeRelease=false`.
4. The Ledger archived `CM-00001` without independently rejecting the illegal transition.
5. At `t=209.6s`, a fresh `EN-00002 / CM-00002` was created for the same unresolved recovery relationship and Condor was repositioned again.

This failure is directly traceable to two code boundaries:

- `scripts/architecture/DecisionEngineActive.lua:895–900` treats changed `intentToken` as a reason to complete the post-handover Commitment.
- `scripts/architecture/CommitmentLedger.lua:173–180` accepts `COMPLETE` or `CANCEL` without requiring Safe Release, cancellation authority or a legal transition proof.

The runtime behaviour is therefore not an ambiguous predictor issue. It is a direct contradiction between accepted architecture and executable lifecycle semantics.

## 3. Compliance status by architectural responsibility

| Responsibility | v4.6.77 status | Audit judgement |
|---|---|---|
| Single active authority path | **Aligned** | `main.lua` loads one architecture path; `Runtime` returns after `ArchitectureCoordinator`. The v4.6.49 active Decision bypass is resolved. |
| Observation ownership | **Mostly aligned** | Observation adapters centralise worker facts, but several geometry and controller services still query live state internally. |
| Situation Assessment produces Knowledge only | **Partially aligned** | It does not actuate, but it selects speed subjects, Hold candidates and one preferred refuge. Candidate generation and preference are mixed with Knowledge production. |
| Operational Picture publication | **Aligned but thin** | A shared picture exists, but it mostly republishes already-selected pair fields rather than an explicit, inspectable set of alternatives and constraint verdicts. |
| Decision owns action selection | **Partially aligned** | Decision owns final verbs, but receives one preferred refuge and pre-resolved capability flags. It cannot compare the complete Action Space on equal terms. |
| Explicit Action Space | **Not aligned** | `choosePhysical()` is an ordered `if` ladder. Action alternatives, admissibility, uncertainty, consequences and rejection reasons are not represented as first-class objects. |
| Admissibility before optimisation | **Locally aligned** | Refuge viability precedes its internal cost comparator. This is not yet universal across all action classes and lifecycle transitions. |
| One persistent Commitment owner | **Partially aligned** | One Ledger exists, but it is a mutable record store, not an enforcing state machine. It trusts Decision even when Decision violates Safe Release. |
| Capability completion separated from Commitment completion | **Documented; violated** | Native Handover is separated from Commitment completion, but Intent Expiry can then complete the Commitment with `safeRelease=false`. |
| Safe Release as only normal completion gate | **Violated** | Confirmed by code and runtime trace. |
| Intent Expiry semantics | **Violated** | Intent change is used as Encounter closure instead of invalidating assumptions within the still-relevant Situation. |
| Persistent Situation Relevance | **Partially aligned** | Situation identity persists, but fresh Encounter creation can bypass unresolved obligations from the previous Commitment. |
| Follower Owns Closure | **Knowledge aligned; authority violated** | The correct Leader/Follower relationship is published, but generic fallback can still reposition the Leader. Responsibility is advisory rather than an Action Space constraint. |
| Full-envelope containment and transition sweep | **Partially aligned/local** | Refuge target/path checks exist, but no universal transition contract governs every configuration, orientation, rejoin and handover action. |
| Representation fitness controls authority | **Not fully aligned** | Working widths, metadata, catalogue models and conservative fallbacks can support active conclusions without one central fitness-to-authority policy. |
| Control narrowness | **Improved but incomplete** | `ControlCapabilities` reports physical outcomes, but `UnilateralSidestepController` remains a 1,689-line prototype-derived passage controller. |
| Validation against architecture | **Not aligned** | Tests are mainly static ownership checks and synthetic branch smoke tests; end-to-end composition and historical replay are absent. |

## 4. Status of the v4.6.49 audit findings

### 4.1 Prototype Boundary Leakage — **partially open**

The active reasoning path is no longer explicitly Condor/Patriot-specific, but the physical passage controller and representation stack retain Prototype 16 lineage, fixture catalogue support and a very broad state machine. The prototype has been hidden beneath generic authority rather than fully decomposed into reusable capabilities.

### 4.2 Assessment–Decision–Control Collapse — **structurally improved, semantically partial**

Actuation is no longer performed by Situation Assessment or Decision. That is meaningful progress. However, Situation Assessment pre-selects candidate actions, and Decision implements lifecycle policy through one large procedural branch tree. The collapse has narrowed but not disappeared.

### 4.3 Architectural Constraint Enforcement Gap — **open and central**

This is the primary cause of the current failure. Safe Release, closure responsibility and representation fitness are fields, not compulsory gates enforced by the natural owner.

### 4.4 Fragmented Commitment Ownership — **partially resolved**

One Ledger now exists. Yet it does not own legal transition semantics, obligation satisfaction or completion authority. It records what Decision says instead of protecting the architecture from an invalid Decision.

### 4.5 Representation Authority Escalation — **open**

Representation provenance is logged, but there is no universal rule defining which fitness class may support which action. Conservative does not automatically mean authoritative.

### 4.6 Fixed values with mixed authority — **open**

Many thresholds remain. The problem is not the existence of literals; it is that diagnostic cadence, empirical policy, safety limits, geometry uncertainty and actuator limits are not strongly typed by ownership and scope.

### 4.7 Native reposition motion ownership — **improved but incomplete**

Purpose-derived motion is better than fixed phase speeds, but the passage controller still owns a large amount of steering, orientation, timing and transition policy.

### 4.8 Phase-specific awareness replacing generic relevance — **open**

Post-handover guard, follower responsibility, settled-leg reassessment and refuge outcome logic have been added as branches. They are valid discoveries, but repeated branch addition indicates the core Situation/Commitment semantics are still not carrying them generically.

### 4.9 Documentation Authority Drift — **improved, but executable drift remains**

The documentation is now rich and current. The new problem is stronger: code can contradict the documented architecture while tests assert only that the relevant terms exist.

### 4.10 Active Decision Engine bypass — **resolved**

This is the clearest successful architectural correction since v4.6.49.

## 5. Systemic failure mechanisms

### 5.1 Action Space is a ladder, not a model

`DecisionEngineActive.choosePhysical()` tries actions in procedural order:

1. option-preserving speed;
2. opposed reposition;
3. speed;
4. follower Hold;
5. generic Hold;
6. generic reposition;
7. speed fallback.

This means a new principle is usually implemented by inserting another branch. When its exact condition is false, execution falls into older generic behaviour. That is why Leader/Follower Knowledge can coexist with Leader reposition.

A real Action Space must contain every candidate action with:

- purpose;
- subject;
- expected effect;
- evidence basis;
- applicable constraints;
- constraint verdicts;
- representation fitness;
- reversibility;
- uncertainty;
- invalidation conditions;
- release obligations;
- admissibility state;
- comparison cost.

Decision should compare only candidates that survive all mandatory gates. It should not “fall through” to an action whose assumptions contradict current Knowledge.

### 5.2 The Ledger is a journal, not a governor

The Ledger should be the final architectural boundary before Control authority. Instead, it copies fields and applies `CREATE`, `REVISE`, `COMPLETE`, `CANCEL` and `FAIL` as requested.

It must reject illegal transitions. Examples:

- `COMPLETE` without Safe Release, authorised cancellation or terminal failure resolution;
- replacing a still-relevant Commitment without recording obligation transfer;
- issuing a second spatial Commitment against the same unresolved post-handover recovery;
- changing subject or capability without fresh admissibility evidence;
- dispatching Control from stale Operational Picture or intent epochs.

### 5.3 Candidate selection leaks out of Decision

`RefugeCandidateAssessment` compares four role/side candidates and returns one selected candidate. Situation Assessment caches it as `pair.repositionCandidate`. Decision then sees only `repositionReady=true/false` and applies it.

This contradicts the intended ownership: Situation Assessment should publish candidate Knowledge and fitness; Decision should select among the complete surviving alternatives and other action classes.

### 5.4 Tests validate vocabulary and branches, not composition

Examples:

- ownership tests assert that strings such as `safeReleaseGate`, `Follower Owns Closure` and `Intent Expiry closed...` exist;
- follower tests inject `followerClosureResponsibility=true` directly into Decision;
- responsibility-continuity tests call the classifier directly with synthetic Commitment/outcome tables;
- post-handover tests construct a simplified pair and do not exercise real intent-epoch changes, Ledger completion or next-cycle admission.

The tests therefore prove isolated mechanisms, not that the architecture behaves coherently through a complete Encounter.

This is the **Composition Validation Gap**:

> Module-local correctness and architectural vocabulary do not establish correct system composition.

### 5.5 The active vertical slice was too broad to validate incrementally

The v4.6.72–v4.6.77 line combined:

- native continuation estimation;
- Future Space;
- Situation identity;
- option preservation;
- speed authority;
- Hold authority;
- refuge calculation;
- lifecycle management;
- Native Handover;
- Safe Release;
- repeated Encounters;
- manoeuvre legs;
- responsibility relations.

Each was locally tested, but the combined state space was never deterministically replayed before live Control authority. Runtime became the first composition test, at a 30–40 minute cost per iteration.

## 6. Is the architecture sufficiently discovered?

**Current judgement: yes, at the highest useful level for TS015 active-active cooperation.**

The project already has the necessary primary concepts:

- Observation;
- Situation Assessment;
- Operational Picture;
- Future Space;
- Action Space;
- Commitment and Preconditions;
- Control capabilities;
- Capability effectiveness versus operational sufficiency;
- Native Handover;
- Persistent Situation Relevance;
- Intent Expiry;
- Manoeuvre Leg Commitment;
- Safe Release;
- Option Preservation;
- Leader/Follower responsibility.

Further runtime discoveries may refine operands, fitness and exceptions. They should not require a new top-level subsystem for every failed trace.

The current problem is that implementation does not faithfully embody these concepts. Continuing to discover more architecture while the existing rules are unenforced will increase terminology without improving behaviour.

## 7. Recommended holistic realignment

### Decision A — freeze active development at v4.6.77 evidence

- v4.6.77 remains failed and non-canonical.
- v4.6.71 remains canonical repository authority.
- v4.6.49 remains a frozen behavioural oracle and capability corpus, not architecture authority.
- No v4.6.78 behavioural candidate should be produced from the current branch logic.

### Decision B — build an executable Architecture Kernel before another live build

The kernel should be independent of GIANTS actuation and deterministic from recorded inputs.

Minimum first-class records:

1. **Observation Snapshot** — raw facts with source and timestamp.
2. **Knowledge / Operational Picture** — interpreted relationships, Future Spaces, uncertainty and representation fitness.
3. **Candidate Action** — one complete proposed action, not a selected flag.
4. **Constraint Verdict Set** — every mandatory constraint with `PASS`, `FAIL` or `UNRESOLVED`, evidence and owner.
5. **Decision** — selected candidate or explicit non-intervention, with comparison rationale.
6. **Commitment** — formal lifecycle state, assumptions, obligations, intent epochs, capability leases and release conditions.
7. **Control Outcome** — physical facts only.

### Decision C — make the Commitment Ledger an enforcing state machine

Define legal states and transitions, for example:

```text
PROPOSED
→ ACTIVE
→ CONTROL_IN_PROGRESS
→ RECOVERY_OBSERVATION
→ SAFE_RELEASED

Alternative terminal paths:
→ CANCELLED
→ FAILED_RELEVANT
→ ESCALATED
```

The Ledger, not Decision, must enforce:

- Safe Release before normal completion;
- explicit cancellation authority;
- obligation transfer on revision/replacement;
- no stale-intent dispatch;
- one active spatial authority per assembly;
- no contradictory simultaneous commitments;
- failure remains relevant;
- Encounter identity cannot be renewed merely to bypass existing obligations.

### Decision D — represent Action Space declaratively

Remove `choosePhysical()`-style fallthrough as the governing model.

Candidate generators may produce:

- `CONTINUE_UNCHANGED`;
- `CONTINUE_OBSERVATION`;
- `REGULATE_SPEED` for either participant;
- `HOLD` for either participant;
- each viable `REPOSITION` candidate;
- `RESTORE`;
- `ESCALATE`.

Constraint evaluators then annotate each candidate. Examples:

- Field World containment;
- complete-envelope clearance;
- transition executability;
- representation fitness;
- control capability availability;
- Progress preservation;
- follower closure responsibility;
- post-handover recovery protection;
- Commitment preconditions;
- current obligation compatibility;
- Safe Release implications.

Decision compares only admissible candidates using accepted policy:

1. preserve mandatory safety and lifecycle invariants;
2. preserve or improve Action Space;
3. use earliest sufficient action;
4. minimise effective augmentation;
5. minimise cost only among operationally equivalent actions.

### Decision E — separate candidate generation from selection

Situation Assessment may publish all four refuge candidates and their evidence. It must not decide which role/side becomes authoritative.

Likewise, Hold and speed candidates should be represented uniformly rather than selected into privileged pair fields before Decision.

### Decision F — decompose Control into narrow capabilities

Retain demonstrated mechanisms, but reduce the broad Prototype 16 controller into purpose-specific capabilities:

- acquire/release field-worker progression lease;
- apply/restore speed lease;
- Hold/release assembly;
- configure for bounded transit;
- execute one committed manoeuvre leg;
- restore configuration authority;
- hand movement authority to GIANTS;
- report outcome.

A capability may reject an impossible command and report physical progress. It must not reinterpret the Encounter or select the next action.

### Decision G — create deterministic replay and architecture conformance tests

Before any live authority:

1. parse recorded Observation/trace sequences from v4.6.49 and v4.6.72–v4.6.77;
2. feed them through the Architecture Kernel cycle by cycle;
3. assert lifecycle and authority invariants;
4. compare decisions at every material epoch;
5. retain negative traces as permanent regression cases.

Mandatory replay assertions include:

- no `COMPLETE` with `safeRelease=false`;
- Intent Expiry revises assumptions but cannot erase unresolved obligations;
- v4.6.77 at `t=209.3s` retains `CM-00001`;
- the next cycle cannot create `CM-00002` while recovery obligations remain;
- Follower Owns Closure makes Leader reposition inadmissible unless explicit exception evidence exists;
- an improving speed/Hold action is maintained unless its own invalidation criteria are met;
- a settled refuge may authorise another leg only within the same unresolved Commitment;
- no candidate with unresolved mandatory fitness receives authority.

### Decision H — restore staged migration discipline

The next programme should have only three implementation gates:

#### Gate 1 — offline kernel

No game build. Replay historical evidence until architecture conformance passes.

#### Gate 2 — passive live shadow

One game build with no Control authority. Run TS015 and TS016 once each. Compare live decisions and lifecycle with replay expectations. Any mismatch is fixed offline before another game build.

#### Gate 3 — active vertical slice

One complete TS015 Encounter lifecycle receives authority. Do not activate repeated Encounter handling, TS016 completion obstacles or broader fixtures until Encounter 1 reaches Safe Release reliably from both viable refuge sides.

The active slice must be complete end-to-end, but narrow in scenario coverage. This differs from another spot fix: all architectural boundaries are present and enforced before authority is granted.

## 8. What should be preserved from v4.6.77

Preserve as implementation/evidence donors, not unquestioned authority:

- single active module path and Coordinator ordering;
- Observation adapters;
- Native continuation estimation;
- Future Space calculations and provenance;
- structured architecture traces;
- Control outcome separation;
- speed and Hold lease mechanisms;
- Native Handover mechanism;
- manoeuvre-leg execution mechanisms;
- refuge candidate evidence generation;
- all failed runtime logs and videos;
- ADRs as discovered knowledge, subject to reconciliation with accepted invariants.

Do not preserve automatically:

- `DecisionEngineActive` branch structure;
- current `CommitmentLedger.apply()` transition semantics;
- single selected refuge in Situation Assessment;
- generic fallback from unavailable Hold to Leader reposition;
- Intent Expiry as completion;
- synthetic smoke tests as evidence of integration correctness;
- Prototype 16 as the permanent unit of Control decomposition.

## 9. Recommended repository outcome before coding resumes

Produce one architecture-only repository increment, after owner agreement, containing:

1. this updated compliance audit;
2. a current conformance matrix;
3. a formal Commitment state machine and transition table;
4. the Candidate Action and Constraint Verdict schemas;
5. a responsibility map for candidate generation, constraint evaluation, selection, lifecycle and Control;
6. a replay test specification with named historical traces;
7. a migration plan and removal register for current branch logic;
8. explicit classification of v4.6.72–v4.6.77 as failed experimental evidence;
9. no active runtime behavioural change.

Only after those documents agree should implementation begin.

## 10. Final conclusion

v4.6.49 worked locally because its decisions were explicit, immediate and fixture-calibrated. It failed architectural generalisation.

v4.6.77 has the correct architectural nouns and a better module route, but the behaviour is still governed by procedural fallthrough, advisory constraints and non-enforcing lifecycle records. It therefore fails both the generic architecture goal and the proven fixture behaviour.

The required correction is not another TS015 rule. It is to turn the existing architecture into an executable contract:

> **Knowledge must generate a complete Action Space; mandatory constraints must remove inadmissible actions; Decision must select among the survivors; the Commitment Ledger must reject illegal lifecycle transitions; Control must execute only the authorised capability and return physical evidence.**

Once that chain is deterministic and replay-tested, TS015 becomes a validation fixture again rather than the place where architecture composition is discovered at runtime.
