# Resolution Lifecycle Specification

## Identity and authority

**Specification Jurisdiction:** Resolution Lifecycle  
**Primary Architecture Authority:** [`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#specification-jurisdiction--resolution-lifecycle)

This Specification owns the implementation-facing contract for the generic persistence, obligation and terminal semantics of a **Resolution Commitment** after that semantic responsibility has been established.

Resolution Lifecycle does **not** own Situation recognition, Candidate construction, Decision, Responsibility Transition, concrete Resolution choreography, purpose-specific geometry, Bounded Authority or Control mechanics. Specialised Resolution Jurisdictions define their concrete obligations and evidence contracts while inheriting this parent persistence contract.

> **Resolution Lifecycle != Commitment Substrate Lifecycle**

The current implementation uses a generic internal Commitment substrate for several traffic purposes. That substrate is not itself the architectural Resolution Lifecycle and its internal state names are not automatically Resolution contract states.

## Boundary contract

### Inputs

Resolution Lifecycle consumes an already-established Resolution Commitment whose semantic product identifies, directly or through its governing specialisation:

- one current responsibility identity;
- its Resolution purpose and governing basis;
- the beneficiary and controlled-subject roles required by that Resolution;
- the open obligations whose discharge or basis cessation governs persistence;
- provenance sufficient to relate the responsibility to the accepted upstream evidence; and
- fresh evidence relevant to obligation settlement, basis continuation, contradiction or terminal disposition.

The parent lifecycle MUST NOT reconstruct a missing Situation, select a strategy, invent a new obligation purpose or create physical permission merely to keep a Resolution alive.

### Persistence

A Resolution Commitment persists while at least one legitimate terminal-dependent Resolution obligation remains open and its governing basis has not been authoritatively terminated in a way that settles those obligations.

Persistence is obligation-based, not prediction-based. Stale admission geometry, stale Candidate assumptions, retained actuator state, a surviving internal commitment record or prior physical progress MUST NOT independently justify semantic Resolution persistence.

Execution MAY adapt to fresh Reality while the same accepted Resolution obligations remain legitimate. Adaptation that preserves the same obligations is maintenance, not a new Resolution responsibility.

### Obligation contract

Every obligation that participates in Resolution terminality MUST preserve enough semantic information to determine:

- which Resolution Commitment owns it;
- the purpose/basis that made the obligation legitimate;
- the required outcome;
- the evidence contract by which that outcome may be established or its basis may cease;
- any required authority class needed to discharge it; and
- whether it remains terminal-dependent.

A concrete Resolution MAY contain more than one participant-scoped, subject-scoped or shared obligation.

Settlement of one obligation MUST NOT settle unrelated obligations merely because they share a parent Resolution.

> **Partial Basis Cessation != Responsibility Termination.**

### Obligation settlement

An obligation reaches a settled disposition only from positive evidence supporting one of two semantic outcomes:

- **satisfaction** — the required outcome was positively achieved; or
- **basis cessation** — authoritative fresh evidence establishes that the obligation's governing basis no longer legitimately exists.

Mere absence, timeout expiry, implementation inactivity or inability to observe the required evidence MUST NOT be relabelled as satisfaction or basis cessation.

A specialised Resolution MAY define more precise terminal labels for its obligations. Those labels MUST map back to one of the parent settlement meanings without redefining parent persistence.

### Terminal semantics

The parent Architecture recognises generic Resolution terminal reasons including:

- completion;
- failure;
- supersession;
- governing-basis cessation; and
- escalation.

A Resolution becomes semantically terminal only when its governing terminal disposition is supported **and** every terminal-dependent obligation has been settled consistently with that disposition.

Terminal eligibility does not itself perform Current Responsibility termination. [`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) remains the authority for ending or replacing the semantic Current Responsibility instance.

A terminal Resolution MUST NOT retain Bounded Authority solely because an implementation lease, token or internal commitment record still exists.

## Ordered lifecycle

The generic Resolution flow is:

```text
Responsibility Transition establishes Resolution Commitment
        |
        v
purpose-specific obligations are open
        |
        +-- fresh evidence preserves obligation basis
        |       -> Resolution persists
        |
        +-- one obligation satisfied / basis ceases
        |       -> settle only that obligation
        |       -> other legitimate obligations remain live
        |
        +-- fresh supported execution adaptation
        |       -> same Resolution persists
        |
        `-- supported terminal disposition emerges
                |
                v
        settle every terminal-dependent obligation
                |
                v
        Resolution terminality supported
                |
                v
        Responsibility Transition ends/replaces Current Responsibility
```

The implementation MAY realise this through additional internal phases. Those phases are mechanism, not additional architectural lifecycle states unless Architecture explicitly adopts them.

## Pre-semantic contradiction contract

Raw Control or runtime evidence can contradict continued execution before the governing lifecycle evidence has established what happened semantically.

Such evidence MUST be preserved and MAY stop or suspend unsupported new physical progression where safety requires it. It MUST NOT, by itself:

- manufacture Resolution failure;
- settle an obligation;
- terminate the Resolution;
- select a replacement purpose; or
- establish a new Current Responsibility.

Once Observation, Operation Lifecycle or another authoritative upstream owner resolves the contradiction into semantic evidence, the specialised Resolution applies its normal settlement contract and Responsibility Transition applies any resulting lifecycle change.

> **Pre-Semantic Contradiction != Resolution Failure**

## Durable invariants

### Obligations justify persistence

An accepted Resolution persists because legitimate obligations remain open, not because its original Candidate, prediction or geometry once existed.

### Obligation settlement is scoped

Settlement affects only the obligation whose satisfaction or basis cessation was positively established unless the evidence independently settles additional obligations.

### Open terminal-dependent obligations block terminality

An implementation MUST NOT declare a Resolution terminal while any terminal-dependent obligation remains legitimately open.

### Terminal cause is evidence-bound

The first authoritative terminal cause MUST NOT be silently replaced by a later implementation convenience merely to obtain a preferred terminal disposition.

### Internal commitment state is non-authoritative

A generic substrate state, record revision, actuator lease or retained commitment ID MUST NOT independently create semantic Resolution persistence, termination or failure.

### Resolution authority is downstream-monotone

As Reality changes, the Resolution or its downstream authority may narrow, refuse or terminate action. It MUST NOT invent a new strategic purpose beyond the accepted Resolution contract.

## Failure and uncertainty semantics

- **Obligation positively satisfied** — settle that obligation as satisfaction.
- **Obligation basis positively ceases** — settle that obligation as basis cessation.
- **Some obligations settle, others remain legitimate** — preserve the same Resolution Commitment and remaining obligations.
- **Required evidence is temporarily unavailable or unresolved** — preserve uncertainty; do not manufacture settlement or terminality.
- **Fresh evidence contradicts an execution assumption but not yet the semantic basis** — fail closed for unsupported progression while semantic evidence catches up; do not invent terminal meaning.
- **Supported Resolution failure** — settle/terminalise only under the specialised failure contract and parent obligation requirements.
- **Supported supersession or governing-basis cessation** — settle affected obligations according to evidence, then expose terminal eligibility for authoritative Responsibility Transition.
- **No supported autonomous continuation remains** — escalation may become a terminal route only when positively justified by the governing Resolution contract; timeout alone is not proof.

## Cross-Jurisdiction dependencies

### Responsibility Transition

Responsibility Transition establishes and ends the semantic Resolution Commitment. Resolution Lifecycle owns persistence and terminal meaning while that responsibility is current.

### Specialised Resolution Jurisdictions

Concrete Resolution Specifications, including [`COOPERATIVE_PASSAGE.md`](COOPERATIVE_PASSAGE.md), own purpose-specific obligations, evidence contracts and choreography. They MUST inherit this parent persistence/terminal contract rather than restate or fork it.

### Observation and Situation Assessment

Fresh semantic evidence arrives through the upstream evidence and interpretation chain. Resolution Lifecycle does not reinterpret raw Reality independently.

### Bounded Authority and Control

Bounded Authority and Control may narrow/refuse physical action and report outcomes. They do not settle Resolution obligations or declare semantic success solely from actuator completion.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/contracts/ResolutionCommitment.lua`](../scripts/contracts/ResolutionCommitment.lua) — current semantic value representation for an established Resolution Commitment;
- [`scripts/commitment/ObligationLedger.lua`](../scripts/commitment/ObligationLedger.lua) — current open-obligation ownership, scoped settlement and terminal-dependency substrate;
- [`scripts/commitment/GoverningBasisEvaluator.lua`](../scripts/commitment/GoverningBasisEvaluator.lua) — current evidence-to-terminal-disposition evaluation substrate;
- [`scripts/commitment/TerminalSettlementEvaluator.lua`](../scripts/commitment/TerminalSettlementEvaluator.lua) — current terminal-settlement sequencing and authority-release integration;
- [`scripts/commitment/CommitmentStateMachine.lua`](../scripts/commitment/CommitmentStateMachine.lua) and [`scripts/contracts/CommitmentRecord.lua`](../scripts/contracts/CommitmentRecord.lua) — shared generic Commitment substrate used by more than Resolution Lifecycle; their concrete state names are implementation facts, not this Specification's semantic lifecycle; and
- [`scripts/responsibility/ResponsibilityTransitionAuthority.lua`](../scripts/responsibility/ResponsibilityTransitionAuthority.lua) — current semantic responsibility termination/replacement authority invoked when the Resolution becomes terminal.

> **Primary Specification != Primary Source Module**

> **Resolution Lifecycle != Commitment Substrate Lifecycle**

## Validation route

### Structural/source-contract validation

[`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py) protects commitment/obligation ownership, terminal ordering, responsibility cleanup and authority-release boundaries.

Structural validation MUST distinguish generic Commitment implementation mechanics from semantic Resolution requirements.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises obligation creation/settlement, partial settlement, terminal gating, supersession and specialised Resolution lifecycles.

Offline evidence can validate semantic ordering and obligation persistence. It cannot prove GIANTS runtime lifecycle evidence or physical success.

### Targeted in-game Reality validation

Reality validation is required where obligation satisfaction, basis cessation, failure or participant loss depends on GIANTS runtime state, physical configuration, movement, obstruction or player intervention.

### Outside this Specification's validation claim

A correct generic Resolution lifecycle does not prove that a concrete Resolution was the right strategic choice, that its geometry is valid, or that its Control choreography can succeed physically. Those claims belong to the specialised Resolution, upstream selection and downstream physical contracts.