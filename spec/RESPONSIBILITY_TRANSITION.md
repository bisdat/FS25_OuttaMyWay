# Responsibility Transition Specification

## Identity and authority

**Specification Jurisdiction:** Responsibility Transition  
**Jurisdiction ID:** `RESPONSIBILITY_TRANSITION`

**Primary Architecture Authority:** [`architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#6-specification-jurisdiction--responsibility-transition)

This Specification owns the implementation-facing contract for authoritative establishment, termination and atomic replacement of **Current Responsibility**, including responsibility-instance identity.

Responsibility Transition does **not** own Situation interpretation, Candidate support, mandatory Constraint meaning, Decision policy, Regulation policy, Resolution-obligation persistence, Bounded Authority or Control execution. It consumes already-justified transition intent and makes only the semantic lifecycle change authoritative.

> **Decision Selection != Responsibility Establishment.**

> **Maintenance Is Not Transition.**

## Boundary contract

### Inputs

A transition attempt MUST be grounded in current, coherent upstream justification for the exact responsibility boundary being changed.

Depending on the path, that justification may include:

- current Situation Assessment and governing basis;
- a selected, supported and constraint-admissible Decision;
- exact current Job Episode or subject identity where the successor contract depends on it;
- the currently authoritative predecessor responsibility, where one exists;
- successor-specific readiness/preconditions supplied by the responsible neighbouring contract; and
- any subordinate physical neutralisation or retained-substrate preflight needed to ensure that semantic replacement can be committed safely.

Responsibility Transition MUST NOT reconstruct missing Candidate support, reinterpret Situation evidence or waive a failed mandatory constraint merely to obtain a successor.

### Authoritative outcomes

Responsibility Transition has four semantic outcomes:

```text
no current OuttaMyWay responsibility -> establish new responsibility
current responsibility               -> same responsibility persists
current responsibility               -> terminate to no OuttaMyWay responsibility
current responsibility               -> atomically replace with different responsibility
```

The second outcome is **maintenance**, not a transition. It MUST preserve responsibility-instance identity.

Establishment or replacement MUST create a fresh responsibility identity for a genuinely new semantic responsibility instance.

Termination MUST end the predecessor identity. A later re-establishment is a new responsibility instance even if it concerns the same subjects or reuses some implementation substrate.

### Atomic replacement

Replacement MUST be semantically atomic.

The system MUST NOT expose a state in which:

- the predecessor has been semantically ended;
- the successor is not yet authoritative; and
- uncontrolled or ambiguously authorised physical behaviour is allowed merely because implementation steps occur sequentially.

Likewise, the successor MUST NOT become authoritative while predecessor cleanup, neutralisation or required substrate succession has failed in a way that would leave both responsibilities semantically current.

Implementation MAY require several subordinate operations. Those operations are preparation for one semantic commit point, not several Current Responsibility transitions.

> **Implementation Sequence != Semantic Transition Count.**

### Maintenance

Fresh assessment may change evidence, Bounded Authority, Control magnitude, controlled role, obligation view or other subordinate implementation details while the same Current Responsibility remains justified.

Such maintenance MUST retain the same responsibility identity and MUST NOT manufacture a transition merely because a backing record, actuator allocation or retained commitment changes internally.

### Termination and downstream authority

When a Current Responsibility terminates, any Bounded Authority whose permission depends on that responsibility MUST not outlive it.

Responsibility Transition may invoke or require downstream release/neutralisation collaboration, but it does not thereby acquire Control ownership. The semantic outcome is that no grant remains valid solely because the terminated responsibility once existed.

## Responsibility identity contract

Responsibility identity belongs to the semantic responsibility instance, not to its implementation substrate.

A responsibility identity MUST remain stable while that responsibility persists through ordinary maintenance.

The following do **not** by themselves justify identity churn:

- updated Situation evidence that still supports the same responsibility;
- new Bounded Authority magnitude;
- authority quiescence and later reactivation;
- controlled-role migration that remains within the same responsibility contract;
- refreshed obligation lists for the same Resolution Commitment responsibility;
- retained commitment/substrate revision; or
- replacement of a helper object or internal adapter.

A fresh identity is required when a genuinely new Current Responsibility is established after absence or when one Current Responsibility is replaced by a semantically different one.

The current identity format is implementation detail. The contract requires uniqueness and semantic continuity, not a particular string prefix.

## Successor product contract

Responsibility Transition MUST publish or install a Current Responsibility product that satisfies the successor Jurisdiction's own semantic contract.

For the currently implemented responsibility kinds, this includes at least:

- **Regulation** — responsibility identity, Regulation kind, governing basis and provenance sufficient to establish why this Regulation instance exists; and
- **Resolution Commitment** — responsibility identity plus the purpose, governing basis, participant/beneficiary or controlled-subject roles, open obligation identity and provenance required by the governing Resolution contract.

Responsibility Transition does not own the substantive meaning of Regulation purpose, Resolution obligations or specialised Resolution choreography. It MUST preserve those neighbouring contracts when making the successor authoritative.

A source record layout MAY change without changing this Specification if the same semantic product remains available.

## Ordered lifecycle

A typical transition path is:

```text
fresh Situation / supported Decision
        |
        v
identify intended lifecycle change
        |
        v
validate predecessor + successor context
        |
        v
preflight successor and required subordinate cleanup
        |
        +-- unsupported / stale / inconsistent -> no semantic transition
        |
        v
perform subordinate preparation needed for atomic commit
        |
        +-- preparation fails -> no successor exposure
        |
        v
semantic commit point
        |
        +-- establish / terminate / replace
        |
        v
publish Current Responsibility with correct identity
        |
        v
Bounded Authority / Control may act only under current responsibility
```

The exact helper sequence is not normative. The ordering constraints are.

A replacement path MUST NOT use a temporary GIANTS-AI responsibility merely to simplify implementation if Architecture supports direct atomic replacement.

Where a selected Cooperative Passage supersedes a current tactical Regulation whose retained Commitment is not a valid substrate for the new pairwise Resolution, Responsibility Transition MUST perform a cross-context replacement rather than suppress the successor. The predecessor physical effect must be neutralised, its authority relinquished, a fresh successor Commitment established, and the predecessor terminalised as superseded within the same runtime transition cycle before successor physical dispatch.

## Durable invariants

### Exclusive lifecycle authority

Only Responsibility Transition makes establishment, termination or replacement of Current Responsibility authoritative.

Situation Assessment may justify change. Decision may select a supported alternative. A retained commitment or Control mechanism may prepare it. None may silently perform the semantic transition themselves.

### Identity continuity follows semantic continuity

The same responsibility keeps the same identity through maintenance. A different responsibility receives a different identity.

### Preflight is non-authoritative

A successful preflight, readiness check or successor construction attempt MUST NOT itself establish Current Responsibility.

A failed preflight MUST leave the current semantic responsibility unchanged unless a separate independently justified termination contract applies.

Where establishment/replacement requires creation of retained Resolution substrate (Commitment, Obligations or actuation-authority tokens), every successor-semantic check that can be evaluated from the selected Candidate and intended Current Responsibility contract MUST run **before** that retained admission. In particular, required participant/subject identity, responsibility identity and compatible open-obligation outcome kinds MUST be validated before admission when those facts are already present upstream.

If such semantic preflight fails:

- no new retained Commitment may remain solely from the failed transition attempt;
- no new actuation-authority ownership may remain;
- no Bounded Authority request may be materialised; and
- Control must not be dispatched.

> **Successor Semantic Preflight Must Precede Retained Admission.**

> **Failed Responsibility Transition Must Not Leak Actuation Ownership.**

This rule does not turn Responsibility Transition into a rollback owner for arbitrary internal corruption. It requires predictable semantic incompatibility to be discovered before the retained-mutation boundary.

### Implementation substrate does not own responsibility continuity

A commitment ID, actuator lease, retained record, correlation key or mechanical handle may support implementation continuity. It MUST NOT independently prove Current Responsibility continuity or succession.

### Atomic replacement has one semantic commit point

Intermediate implementation steps MUST NOT be observable as two simultaneously authoritative conflicting responsibilities or as an unowned physical interval.

### Downstream authority cannot outlive the responsibility it derives from

Termination or replacement MUST ensure stale Bounded Authority is released, invalidated or otherwise unable to authorise further action under the ended predecessor.

## Failure and uncertainty semantics

Responsibility Transition is fail-closed at the semantic boundary.

- **Supported establishment** — all required current justification and successor contract conditions hold; issue a fresh responsibility identity and establish the successor.
- **Supported maintenance** — the same responsibility remains justified; preserve identity and do not transition.
- **Supported termination** — positive lifecycle/governing-basis evidence justifies ending the current responsibility; terminate it and invalidate dependent authority.
- **Supported replacement** — predecessor and successor are both identified and all atomic replacement preconditions hold; commit one predecessor-to-successor transition.
- **Stale or mismatched context** — reject the attempted transition; do not restamp stale evidence.
- **Missing predecessor where replacement requires one** — reject replacement.
- **Unsupported successor readiness** — reject establishment/replacement.
- **Subordinate neutralisation/cleanup failure before commit** — do not expose the successor as authoritative.
- **Unresolved upstream evidence** — Responsibility Transition MUST NOT invent a lifecycle event to resolve uncertainty.

An implementation error after semantic commit is not permission to pretend the predecessor remained current. Recovery must respect the actual committed semantic state and the governing failure contracts of neighbouring Jurisdictions.

## Cross-Jurisdiction dependencies

### Situation Assessment

Situation Assessment owns whether current evidence justifies persistence or change. Responsibility Transition consumes that justification but does not reinterpret it.

### Candidate Support / Constraint Evaluation / Decision

Where strategic selection is required, the prospective-selection chain owns support, admissibility and choice. Responsibility Transition consumes the selected supported result and does not repair it.

### Regulation and Resolution Lifecycle

These Jurisdictions define the semantic content and persistence rules of the responsibilities that may be established. Responsibility Transition owns lifecycle change between Current Responsibility instances, not their internal policy or obligation semantics.

### Bounded Authority

Bounded Authority may grant physical permission only under a current responsibility. Responsibility Transition must prevent grants derived solely from an ended predecessor from remaining live.

### Control

Control realises already-authorised action. It does not establish or replace semantic responsibility even when physical neutralisation is a prerequisite for atomic replacement.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/responsibility/ResponsibilityTransitionAuthority.lua`](../scripts/responsibility/ResponsibilityTransitionAuthority.lua) | `REALISES` |
| [`scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua`](../scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua) | `REALISES` |
| [`scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua`](../scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua) | `REALISES` |
| [`scripts/responsibility/CooperativePassageResponsibilityTransition.lua`](../scripts/responsibility/CooperativePassageResponsibilityTransition.lua) | `REALISES` |
| [`scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua`](../scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua) | `REALISES` |
| [`scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua`](../scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua) | `REALISES` |
| [`scripts/responsibility/ResolutionCommitmentAdapter.lua`](../scripts/responsibility/ResolutionCommitmentAdapter.lua) | `SUPPORTS` |

## Implementation traceability

The following mapping is **non-normative source traceability**.

Primary current implementation routes include:

- [`scripts/responsibility/ResponsibilityTransitionAuthority.lua`](../scripts/responsibility/ResponsibilityTransitionAuthority.lua) — current central semantic responsibility authority, identity continuity, termination and atomic replacement boundary;
- purpose-specific transition collaborators under [`scripts/responsibility/`](../scripts/responsibility/), including follower, Action-Space Regulation, Cooperative Passage, Obstruction Relocation and Blocked Worker Recovery transitions;
- [`scripts/contracts/Regulation.lua`](../scripts/contracts/Regulation.lua) and [`scripts/contracts/ResolutionCommitment.lua`](../scripts/contracts/ResolutionCommitment.lua) — current value representations for implemented Current Responsibility kinds; and
- runtime orchestration that presents supported transition intent to the authority before downstream physical dispatch.

The central authority is a current implementation choice, not a requirement that all future transition logic remain in one file.

> **Primary Specification != Primary Source Module**

## Validation route

### Structural/source-contract validation

Current structural evidence is concentrated in [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py), including checks that semantic Responsibility Transition authority owns replacement, identity issuance/continuity and ordering before Control.

Purpose-specific structural tests also protect neighbouring ownership boundaries where transition adapters interact with Regulation, Resolution or obstruction handling.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises establishment, maintenance, replacement, terminal cleanup and identity behaviour in the offline replacement-core harness.

Offline evidence can challenge semantic ordering and record contracts. It cannot prove equivalent GIANTS runtime timing or physical neutralisation behaviour.

### Targeted in-game Reality validation

In-game validation is required where a transition depends on GIANTS Job Episode termination, runtime subject replacement/removal, player intervention, or physical neutralisation/handback effects that the offline harness cannot reproduce faithfully.

### Outside this Specification's validation claim

A correct transition does not prove that the predecessor/successor was semantically the right choice, that specialised Resolution choreography succeeds, or that Control can physically realise the successor's authorised action.

Those belong to the upstream selection and downstream responsibility/authority/control contracts.
