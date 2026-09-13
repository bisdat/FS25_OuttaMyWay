# Control Specification

## Identity and authority

**Specification Jurisdiction:** Control  
**Primary Architecture Authority:** [`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#11-specification-jurisdiction--control)

This Specification owns the implementation-facing contract for **physical realisation of an already-authorised request through supported GIANTS/runtime mechanisms**, including physical feasibility checks, bounded execution, safe refusal/stop/cleanup and reporting of physical outcomes.

Control does **not** own strategic purpose, Situation meaning, Candidate/Decision policy, Responsibility Transition, Bounded Authority creation, Regulation magnitude policy, Resolution settlement semantics or alternative-strategy invention.

> **Control may discover physical feasibility; it may not invent strategic purpose.**

## Boundary contract

### Inputs

Positive Control execution consumes an already-authorised request whose semantic purpose and physical permission were established upstream.

A positive request MUST identify, as applicable:

- request identity;
- governing commitment / responsibility context;
- controlled assembly/subject;
- physical capability;
- bounded target / magnitude / objective;
- current authority token or equivalent actuation substrate where required;
- current Bounded Authority grant for positive physical actuation;
- evidence / Operational Picture freshness binding;
- effective actuation composition;
- preconditions and invalidation conditions; and
- purpose-specific execution context needed by the selected executor.

Control MUST NOT repair a missing strategic decision, missing responsibility or missing positive Bounded Authority by inferring intent from the requested mechanism.

### Dispatch

Dispatch is routing, not semantic choice.

A dispatcher MAY choose the executor capable of realising an already-authorised request based on capability and bounded target kind. It MUST NOT:

- select a new Candidate;
- reinterpret Situation evidence;
- create Bounded Authority;
- change the request into a different strategic action;
- broaden target/magnitude; or
- decide semantic responsibility persistence.

If no supported executor exists, dispatch fails closed.

### Positive execution

An executor MUST validate that the request is still suitable for its physical boundary before creating a positive physical effect.

This includes current Bounded Authority for positive actuation plus any executor-specific current conditions required for safe/meaningful execution, such as:

- current controlled object/vehicle availability;
- current Job Episode or non-active status required by the specialised Control contract;
- current Player Claim / higher-priority ownership boundaries;
- current physical pose/representation needed to execute the target;
- configuration/mechanism availability; and
- continued compatibility with the bounded request.

Control MAY refuse or defer even when Bounded Authority was valid at materialisation time if current physical Reality makes execution unsupported.

> **Permission To Attempt != Proof Of Feasibility.**

### Execution choreography

A specialised Control contract MAY contain multiple mechanical phases when those phases are already within the authorised strategic target and governing specialised Specification.

Examples include:

- applying or clearing a Regulation lease;
- Cooperative Passage Hold/configuration/guide/recovery/handback choreography; or
- one bounded Obstruction Relocation actuation plus owned cleanup.

Internal execution phases MUST NOT create new strategic targets or enlarge the authorised purpose. If fresh physical evidence invalidates the current execution path, Control may stop/refuse/fail safe and report evidence rather than inventing a replacement strategy.

### Control outcomes

Control MUST report physical execution evidence without claiming semantic success outside its Jurisdiction.

Contractually significant outcome properties include:

- request identity;
- physical execution status;
- observed physical effect;
- physical progress where applicable;
- provenance;
- observation time;
- completion evidence where the executor can positively establish its own mechanical completion; and
- failure evidence where execution was rejected, interrupted or failed.

The current `ControlOutcome` record is one representation of this contract. Current status labels are implementation-facing vocabulary; they MUST preserve the distinction between accepted/rejected/in-progress/completed/failed physical execution and semantic responsibility settlement.

Control outcome evidence returns through Reality and Observation before it can become Situation/Resolution truth.

> **Physical Completion != Semantic Resolution Completion.**

## Ordered execution flow

A typical positive Control flow is:

```text
Current Responsibility
        |
        v
Bounded Authority grant
        |
        v
Control request materialised within grant
        |
        v
Dispatcher selects compatible executor
        |
        +-- no executor -> reject
        |
        v
Executor validates current authority + physical boundary
        |
        +-- stale / unsafe / unavailable -> refuse / stop / fail safe
        |
        v
bounded physical mechanism/choreography
        |
        v
physical outcome / execution observation
        |
        v
Reality -> Observation -> Situation / lifecycle reassessment
```

The exact module call graph is not normative. The authority ordering is.

## Downstream Authority Monotonicity

Control MUST be authority-monotonic.

Given a Bounded Authority grant, Control may:

- perform the granted effect;
- perform a narrower effect where the capability contract permits it;
- refuse to act;
- stop already-owned actuation;
- neutralise or relinquish already-owned actuation; or
- fail safe when current physical support disappears.

Control MUST NOT:

- choose a stronger magnitude;
- change controlled subject;
- choose an alternate route/target not authorised upstream;
- preserve actuation after its positive permission is invalid solely because the mechanical lease remains available; or
- manufacture semantic success/failure to obtain a different physical action.

> **Downstream Authority Monotonicity**

## Positive actuation versus cleanup

### Positive actuation

Every new or tightened physical effect MUST be backed by current positive Bounded Authority.

An executor MUST fail closed when positive actuation lacks that permission. A novel target/owner tag/mechanism name is not an implicit exception.

### Cleanup and relinquishment

Control may need to remove an already-owned physical effect after the positive permission that created it is no longer current.

Fail-safe cleanup MAY therefore clear, neutralise, stop or release an owned effect without acquiring a new positive actuation grant, provided the cleanup can only reduce OuttaMyWay's physical intervention.

Examples include:

- clearing a Regulation lease;
- releasing Hold;
- clearing owned drive/configuration state;
- neutralising owned non-job actuation; or
- relinquishing a participant's Control effect before authority release.

Cleanup MUST NOT use a release path to tighten, redirect or create a physical effect.

> **Relinquishment Is Authority-Narrowing, Not Authority Creation.**

## Purpose-specific physical boundaries

### Regulation Control

Regulation Control realises an already-authorised timing effect. It owns physical lease application/release and raw execution observation, not the Situation reason, Regulation responsibility identity or magnitude policy.

A physical speed lease is implementation state, not semantic Regulation identity.

### Cooperative Passage Control

Cooperative Passage Control realises the already-accepted Passage Arrangement/Guide and specialised lifecycle contract.

It may:

- Hold/configure participants as authorised by the Passage contract;
- instantiate/rebase execution origins within the accepted guide semantics;
- revalidate current physical support at execution boundaries;
- execute bounded guide/recovery/handback phases; and
- stop/hold/fail safely when support is contradicted.

It MUST NOT invent substitute Passage geometry or a new spatial strategy merely because the accepted guide becomes physically unsupported.

### Obstruction Relocation Control

Obstruction Relocation Control realises one already-authorised bounded relocation objective for the current non-active unclaimed blocker.

At its physical boundary it must respect higher-priority current Reality such as Player Claim, source-AI reactivation and current physical-object availability. Such contradiction may stop/supersede execution but does not let Control invent a new relocation purpose.

## Core capability availability

A supported core Control capability is structural runtime topology, not an independent per-capability product switch beneath master OuttaMyWay enablement.

Once current semantic responsibility and Bounded Authority support an action, the supported executor/mechanism path is either available or physically unavailable; a separate feature-enable boolean MUST NOT become semantic authority.

> **Core Capability Has No Enable State.**

> **Master Enablement != Per-Capability Enablement.**

A negative authority annotation on evidence limits what that evidence may prove. It is not a mutable capability-disable state.

## Durable invariants

### Control consumes authority; it does not create it

Positive execution requires already-established semantic responsibility and Bounded Authority.

### Executor routing is not Decision

Choosing the implementation capable of executing a request MUST NOT be confused with strategic Candidate selection.

### Physical mechanism is not policy authority

Drive, Hold, configuration and non-job actuation mechanisms may expose mechanical operations/state. They MUST NOT own Candidate support, Decision, Responsibility Transition or Bounded Authority.

### Fresh physical contradiction may narrow execution

Control may refuse/stop when current Reality contradicts physical feasibility or a higher-priority claim. That refusal is not authority to choose another strategic action.

### Outcome evidence is not semantic self-certification

Control may establish mechanical facts about its own execution. Semantic continuation, responsibility persistence, obstruction discharge or Resolution settlement belongs upstream after evidence returns through Observation.

### Cleanup cannot broaden authority

Any control path permitted without a new positive grant MUST be strictly authority-reducing.

### Owned effects must be relinquishable

An implementation MUST provide a fail-safe path to release/neutralise physical effects it owns when authority ends or execution cannot safely continue.

## Failure and uncertainty semantics

- **Request missing/malformed** — reject; no physical effect.
- **Unsupported capability/target** — reject; do not substitute another executor/strategy.
- **Positive Bounded Authority absent/stale** — reject positive actuation.
- **Commitment/responsibility/token/composition stale** — reject or stop as required by the request contract.
- **Physical subject unavailable** — reject/stop and report evidence.
- **Player Claim / higher-priority source authority appears** — stop/relinquish according to the specialised Control contract.
- **Mechanism unavailable** — reject/fail safe; do not invent semantic prohibition or alternate purpose.
- **Execution support contradicted in flight** — stop/hold/neutralise as safely required and report failure/contradiction.
- **Watchdog/physical timeout** — report execution failure or escalate according to the specialised contract; timeout MUST NOT be treated as semantic success or proof of safety.
- **Cleanup failure** — report the owned physical effect as unresolved; do not claim successful handback/settlement.

Control failure is evidence for reassessment. It is not, by itself, a Responsibility Transition.

## Cross-Jurisdiction dependencies

### Bounded Authority

Bounded Authority owns positive physical permission. Control validates/consumes it and may only narrow/refuse/stop.

### Regulation

Regulation owns semantic temporal-coordination persistence. Control owns physical Regulation lease mechanics only.

### Resolution Lifecycle / specialised Resolutions

Resolution contracts own obligations, strategic choreography and settlement meaning. Specialised Control executes within those contracts and reports physical outcomes.

### Observation / Situation Assessment

Raw physical Control outcomes and execution observations re-enter through Reality/Observation. Situation Assessment owns their semantic meaning.

### Responsibility Transition

Control may be required to neutralise predecessor physical effects around a transition, but it does not make the semantic transition authoritative.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Primary current implementation routes include:

- [`scripts/contracts/ControlRequest.lua`](../scripts/contracts/ControlRequest.lua) and [`scripts/contracts/ControlOutcome.lua`](../scripts/contracts/ControlOutcome.lua) — current request/outcome value representations;
- [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua) — current capability/target routing boundary;
- [`scripts/control/RegulationControl.lua`](../scripts/control/RegulationControl.lua) — Regulation lease execution/cleanup and raw execution observation;
- [`scripts/control/CooperativePassageControl.lua`](../scripts/control/CooperativePassageControl.lua) — specialised Passage execution choreography;
- [`scripts/control/ObstructionRelocationControl.lua`](../scripts/control/ObstructionRelocationControl.lua) — specialised non-active blocker relocation execution; and
- [`scripts/control/mechanisms/`](../scripts/control/mechanisms/) plus `NonJobActuationMechanism` — current physical mechanism implementations.

The dispatcher is not the whole Control Jurisdiction, and physical mechanism modules do not acquire semantic authority merely because they call GIANTS APIs.

> **Primary Specification != Primary Source Module**

## Validation route

### Structural/source-contract validation

Current structural evidence includes:

- [`tests/test_regulation_control_structure.py`](../tests/test_regulation_control_structure.py), protecting Regulation Control ownership and separation from policy;
- [`tests/test_physical_control_mechanisms_structure.py`](../tests/test_physical_control_mechanisms_structure.py), protecting physical mechanisms from semantic-pipeline ownership;
- [`tests/test_obstruction_relocation_structure.py`](../tests/test_obstruction_relocation_structure.py) and [`tests/test_non_job_actuation_mechanism_structure.py`](../tests/test_non_job_actuation_mechanism_structure.py), protecting the current relocation execution boundary; and
- [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py), protecting dispatcher, Passage and Bounded Authority integration.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises request rejection/acceptance, Regulation lease execution, Passage execution/failure handling, obstruction relocation and physical cleanup in the offline harness.

Offline validation can challenge authority ordering and executor behavior under stubs. It cannot prove real GIANTS steering, folding, physical contact, Job continuation or player-control timing.

### Targeted in-game Reality validation

In-game validation is required for claims about actual GIANTS actuation, steering, Hold, folding/configuration settlement, speed regulation, non-job movement, handback and physical cleanup.

### Outside this Specification's validation claim

Correct Control execution does not prove that the selected strategy was semantically correct, that the responsibility should persist, or that a Resolution has semantically succeeded. Those conclusions require their owning upstream contracts and fresh Reality evidence.
