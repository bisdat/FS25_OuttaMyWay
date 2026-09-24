# Log Publication Architecture

## Purpose and architectural boundary

**Log Publication** is the controlled projection of already-established runtime or engineering facts into the GIANTS log.

It exists so semantic owners and diagnostic instruments can expose useful evidence without each independently owning publication thresholds, common presentation or the GIANTS logging destination.

> **Publication Authority != Semantic Authority**

Nothing becomes true because it was logged. Log Publication does not establish Reality, Situation meaning, Current Responsibility, Resolution state, Bounded Authority, Control outcome or diagnostic evidence. It receives already-classified publication requests from the responsibility that owns the fact.

Log Publication is separate from [Configuration](CONFIGURATION.md), which owns supported player choices, and from [GUI/HUD architecture](GUI.md), which owns player-facing communication. A HUD message is not another log destination, and engineering logging is not player communication.

## Specification Jurisdiction — Log Publication

**Owns:** publication classes, publication eligibility, the suppression boundary, the common OuttaMyWay log envelope, severity routing after eligibility, and delivery of eligible events to the GIANTS log.

**Does not own:** semantic event meaning, lifecycle transitions, diagnostic instrument activation, evidence production, semantic deduplication, diagnostic cadence, Configuration persistence/defaults/public names, HUD/player messaging, or GIANTS/runtime facts.

**Jurisdiction ID:** `LOG_PUBLICATION`  
**Primary Specification:** [`spec/LOG_PUBLICATION.md`](../spec/LOG_PUBLICATION.md)

## 1. Position in the system

~~~text
Semantic owner / Diagnostic instrument
        |
        | establishes and classifies meaning
        v
Publication Descriptor
        |
        v
Log Publication Policy
        |
        +-- suppressed -----------------> stop
        |
        \-- eligible
              |
              v
        Publication Payload
              |
              v
        common one-line rendering
              |
              v
           GIANTS log
~~~

The producer decides what happened. Log Publication decides whether that already-classified event is publishable under the resolved runtime policy and, if so, publishes it consistently.

> **Message Origin != Publication Authority**

> **Classification Happens Before Publication Policy**

## 2. Publication Event, Descriptor and Payload

A **Publication Event** is an ephemeral request to publish an already-established fact. It is not retained Runtime knowledge, does not receive Runtime identity and does not advance semantic time.

> **Publication Event != Runtime Entity**

A Publication Event has two conceptual parts.

### Publication Descriptor

The **Publication Descriptor** is the cheap classification required before any avoidable publication work:

- stable human-readable event code;
- publication class;
- severity; and
- semantic origin.

The Descriptor must be available without expensive publication-only projection, sorting, traversal or formatting.

### Publication Payload

The **Publication Payload** contains context and semantic detail required to render an admitted event. It is constructed only after the Descriptor has passed publication eligibility.

Payload material may include already-established Operation, Job Episode, Responsibility or Resolution identities; a human-readable field locator; role-specific subjects; reason/outcome data; and detailed diagnostic evidence already produced by its owning instrument.

Payload construction does not gain authority to discover new semantic facts merely because a log line is desired.

> **Publication Classification != Publication Payload Construction**

> **Publication Eligibility Precedes Presentation Construction**

## 3. Publication classes and support escalation

Log Publication has three cumulative publication classes:

~~~text
NORMAL
  ⊂ DEBUG
      ⊂ DIAGNOSTIC
~~~

### NORMAL — lifecycle and intervention journal

NORMAL is a sparse, transition-driven operational journal. It records product/lifecycle boundaries and externally meaningful OuttaMyWay interventions: product activation state, Job Episode and Local Operation lifecycle, Regulation, Cooperative Passage, Obstruction Relocation, player-intervention escalation, and genuinely operational warnings/errors.

NORMAL does not describe continuous internal reasoning. Silence between meaningful transitions is desirable. A periodic "still running" heartbeat is not a NORMAL requirement.

### DEBUG — support-grade causal narrative

DEBUG explains why OuttaMyWay acted as it did well enough to isolate likely responsibility when a player reports a problem.

DEBUG should expose bounded causal information such as important selection/rejection reasons, involved subjects, responsibility transitions, requested Control and outcomes. It should not become an automatic per-cycle dump of geometry, every Candidate verdict or every intermediate evidence value.

### DIAGNOSTIC — targeted engineering evidence

DIAGNOSTIC is detailed engineering instrumentation used after NORMAL and DEBUG have narrowed an unresolved question. It may expose detailed geometry, projections, intermediate assessments and instrument-specific evidence.

DIAGNOSTIC publication does not mean every diagnostic instrument is active.

> **Support Debugging != Engineering Diagnostics**

> **Bug Isolation != Evidence Saturation**

The support escalation path is:

~~~text
NORMAL
  -> establish what OuttaMyWay did

DEBUG
  -> explain why and narrow likely responsibility

bench reproduction / tests
  -> reproduce or explain where possible

targeted DIAGNOSTIC
  -> expose detailed evidence for the unresolved responsibility
~~~

## 4. Severity is orthogonal to publication class

Severity and publication class answer different questions.

Publication class answers how broadly information should be visible. Severity answers how serious the already-classified event is within that class.

The severity vocabulary is `INFO`, `WARNING` and `ERROR`.

A DIAGNOSTIC WARNING remains DIAGNOSTIC. Severity does not promote it into NORMAL or DEBUG.

An operational ERROR that must be visible in ordinary support evidence must be classified by its semantic owner as a NORMAL event with ERROR severity.

> **Publication Class Gates First; Severity Renders Second**

No independent severity-threshold architecture is currently justified.

## 5. Producer ownership and stable event codes

The producer that owns the fact also owns:

- the event's semantic meaning;
- its publication class;
- its severity;
- its stable event code;
- its semantic role vocabulary; and
- its reason/outcome meaning.

Log Publication does not parse module names, arbitrary prose or payload fields to reconstruct those decisions.

Event codes are stable, human-readable semantic identifiers using upper-case ASCII words separated by underscores, for example `REGULATION_STARTED`, `COOPERATIVE_PASSAGE_ENDED`, `JOB_EPISODE_STARTED` and `PLAYER_INTERVENTION_REQUIRED`.

An event code is a semantic classification, not a unique event-instance identity and not message prose.

> **Event Code != Message Text**

Opaque catalogue keys such as `L001` are not the event identity model. A log should remain intelligible and searchable without consulting a separate numeric catalogue.

The semantic origin is likewise stable provenance, not a source-module or function address.

## 6. Context is supplied, not discovered

The producer supplies the semantic context appropriate to its event.

For an Operation-scoped event, Operation identity is the authoritative lifecycle context. A player-facing field number or other locator may accompany it when resolved, but that locator does not replace Operation identity.

This distinction is required because several Local Operations may exist concurrently in different Field Worlds.

> **Publication Context Is Supplied, Not Discovered**

Log Publication may render supplied Operation/field context consistently. It must not query Runtime and infer which Operation a message "probably" belongs to.

Unavailable context remains absent. A Job Episode may be admitted before Local Operation participation is established, so its start publication must not invent an Operation identity.

> **Job Episode Admission != Operation Participation**

Role-specific semantic vocabulary also remains with the producer. Regulation may use regulated/protected roles; Passage has participants; Obstruction Relocation has blocker/beneficiary roles.

> **Common Publication Envelope != Common Semantic Vocabulary**

> **Context Normalisation != Semantic Interpretation**

## 7. NORMAL event ownership follows semantic authority

NORMAL lifecycle lines must be emitted from the authority that establishes the lifecycle fact, not from a lower physical mechanism that happens to observe an effect.

| NORMAL fact | Semantic authority |
| --- | --- |
| Product startup / resolved enabled state / enable-disable transition | product shell after Configuration resolution; Responsibility Transition supplies any resulting responsibility-exit facts |
| Job Episode start/end | Operation Lifecycle |
| Local Operation start/end | Operation Lifecycle |
| Regulation start/end | Responsibility Transition |
| Cooperative Passage start/end | Responsibility Transition, with terminal meaning supplied by the governing Resolution/Passage lifecycle |
| Obstruction Relocation start/end | Responsibility Transition, with terminal meaning supplied by the governing Resolution/Relocation lifecycle |
| Player Claim affecting autonomous actuation | Situation Assessment owns Player Claim; Responsibility Transition owns any resulting responsibility exit |
| Player intervention required | lifecycle that positively establishes autonomous escalation |
| Operational warning/error | jurisdiction or system component that owns the abnormal semantic/system fact |

A Control mechanism physically slowing a worker does not own Regulation start. Physical completion of one relocation manoeuvre does not by itself own Obstruction Relocation end.

> **Normal Event Ownership Follows Semantic Authority**

> **Physical Effect != Operational Lifecycle Boundary**

> **State Transition != State Observation**

## 8. Product activation is not Job Bootstrap

The global product-state publication answers whether the product shell loaded and whether OuttaMyWay Runtime operation is enabled. NORMAL publication must also expose later master enable/disable transitions so ordinary support evidence records when autonomous coordination became available or was withdrawn.

That is distinct from Runtime / per-Job Episode Bootstrap, which discovers current Reality and stable job-scoped knowledge.

> **Product Shell != Runtime Bootstrap**

> **Mod Activation != Job Bootstrap**

Log Publication must therefore remain available after Configuration has resolved product state even when normal OuttaMyWay Runtime intervention is disabled. An `enabled=false` startup may legitimately publish the disabled product state without bootstrapping Job Episodes, Local Operations or traffic coordination.

Exact event-code wording belongs to the product-state semantic owner rather than Log Publication. The exact player Configuration names, defaults, persistence and storage mechanism remain Configuration responsibility.

## 9. Diagnostic production and publication are separate

A publication level controls what may be emitted. It does not automatically control whether upstream semantic or diagnostic work exists.

> **Evidence Production != Evidence Publication**

> **Publication Level != Instrument Activation**

Turning logging down must not alter Observation, Situation Assessment, Decision, Responsibility Transition, Bounded Authority or Control. Likewise, enabling DIAGNOSTIC publication must not automatically activate every instrument.

However, work that exists solely to prepare a suppressed log message should not run.

> **Log Suppression Must Precede Avoidable Publication Work**

Diagnostic instruments continue to own their evidence-production cadence, signature/change detection and heartbeat rules. No generic semantic deduplication or publication rate limiter is currently justified inside Log Publication.

## 10. Failure isolation

Logging is observability infrastructure, not semantic authority.

Failure to construct or deliver a publication must not roll back or invalidate the semantic fact that generated it.

> **Publication Failure Cannot Become Runtime Failure**

Any publication-failure reporting mechanism must avoid recursion through the same failed path.

## 11. Neighbouring authorities

[Configuration Architecture](CONFIGURATION.md) owns supported player choices and eventually maps those choices into a resolved runtime publication policy. It does not dictate Log Publication's internal module topology.

[GUI Architecture](GUI.md) owns player-facing operational communication. Log Publication does not provide a second HUD/message channel.

[Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation Architecture](SPATIAL_NEGOTIATION_MODEL.md) and their Specifications own the semantic events that NORMAL and DEBUG may publish.

Diagnostic instruments own the engineering questions and evidence they produce. Log Publication owns only whether and how eligible evidence reaches the GIANTS log.

The implementation-facing contract is owned by the [Log Publication Specification](../spec/LOG_PUBLICATION.md).
