# Log Publication Specification

## Identity and authority

**Specification Jurisdiction:** Log Publication  
**Jurisdiction ID:** `LOG_PUBLICATION`

**Primary Architecture Authority:** [`architecture/LOG_PUBLICATION.md`](../architecture/LOG_PUBLICATION.md#specification-jurisdiction--log-publication)


This Specification owns the implementation-facing contract for deciding publication eligibility from a cheap producer-supplied Descriptor, deferring avoidable Payload work until admission, rendering admitted events consistently, and delivering them to the GIANTS log without acquiring semantic authority.

It does not own semantic event meaning, lifecycle transition, diagnostic activation/evidence production, Configuration persistence/public naming, HUD/player messaging, or Runtime identity.

## Boundary contract

### Accepted inputs

A publication attempt consumes four conceptual inputs:

1. a valid **Publication Descriptor** supplied by the semantic or diagnostic origin;
2. a deferred means of constructing the **Publication Payload** if publication is admitted;
3. the resolved runtime **Publication Policy**; and
4. the available GIANTS logging facility.

The implementation MAY represent these inputs using any mechanism that preserves the contract. This Specification does not require one Lua table shape, callback name or module decomposition.

### Produced outcome

A publication attempt produces either suppression or one admitted event delivered as at most one GIANTS log line.

These are publication outcomes, not Runtime knowledge. Publication does not create retained semantic records, identities or epochs.

## Publication Descriptor contract

The Descriptor MUST contain enough cheap classification for publication eligibility to be decided before avoidable Payload construction.

| Field | Required meaning |
| --- | --- |
| event code | stable human-readable semantic classification |
| publication class | `NORMAL`, `DEBUG` or `DIAGNOSTIC` |
| severity | `INFO`, `WARNING` or `ERROR` |
| origin | stable semantic/engineering provenance that owns the classification |

Descriptor construction MUST NOT require expensive work whose only purpose is preparing a potentially suppressed message.

### Event-code contract

Event codes MUST:

- use upper-case ASCII words separated by underscores;
- describe the semantic event rather than its source location;
- remain stable while the same event classification remains current;
- be human-readable without a separate numeric catalogue; and
- identify an event class, not a unique event instance.

Suitable forms include `REGULATION_STARTED`, `JOB_EPISODE_ENDED` and `PLAYER_INTERVENTION_REQUIRED`.

Opaque numeric catalogue identities such as `L001` MUST NOT be used as the primary event code.

Message wording MAY evolve without changing the event code when semantic meaning is unchanged.

### Origin contract

Origin MUST identify stable semantic or engineering provenance, not a Lua module/function address.

Where a Specification Jurisdiction owns the fact, its stable jurisdiction identity is an appropriate origin vocabulary. Diagnostic producers MAY use an appropriate stable engineering identity without claiming runtime semantic authority.

Log Publication MUST NOT infer origin from source path, stack location or arbitrary message text.

### Descriptor validity

An incomplete or unknown classification MUST NOT be repaired by Log Publication.

Unknown publication classes, unsupported severities or malformed event classifications MUST be rejected/suppressed without changing semantic behaviour.

## Publication eligibility

Publication classes are cumulative:

| Resolved policy | NORMAL event | DEBUG event | DIAGNOSTIC event |
| --- | --- | --- | --- |
| NORMAL | publish | suppress | suppress |
| DEBUG | publish | publish | suppress |
| DIAGNOSTIC | publish | publish | publish |

Severity MUST NOT widen publication eligibility.

A DIAGNOSTIC WARNING therefore remains suppressed under NORMAL and DEBUG. If a condition is operationally important enough for ordinary support evidence, its semantic owner must classify it as a NORMAL warning/error.

No independent severity-threshold mechanism is required by this contract.

## Deferred Publication Payload

The Payload MUST NOT be constructed when its Descriptor is suppressed.

When publication is admitted, the Payload MAY contain:

- already-established Job Episode, Operation, Responsibility, Resolution or other semantic identities;
- player-readable locators such as resolved field number where available;
- role-specific subjects;
- producer-owned reason/outcome data;
- diagnostic evidence already produced by an independently justified instrument; and
- presentation detail necessary for the admitted line.

Payload construction MUST NOT establish new Situation meaning, run a fresh Decision merely for logging, create/terminate Current Responsibility, grant/revoke Bounded Authority, issue Control, activate a diagnostic instrument, issue Runtime identity, or advance semantic epoch/time.

> **Observability Cannot Advance Semantic State**

If an expensive diagnostic measurement would not otherwise exist, the decision to produce that evidence belongs to the diagnostic instrument/activation contract upstream of Log Publication.

## Context contract

### Operation-scoped publication

A NORMAL event that belongs to an established Local Operation MUST carry the authoritative Operation identity.

A player-readable field locator SHOULD accompany it when that locator is already resolved and available. The field locator MUST NOT replace Operation identity.

### Pre-Operation lifecycle publication

A legitimate event that occurs before Local Operation establishment MUST omit unavailable Operation context rather than fabricate it.

Job Episode admission is the principal current example.

### Semantic role vocabulary

Payload roles MUST preserve the vocabulary of the owning semantic contract.

Examples include regulated/protected for Regulation, participants for Cooperative Passage, blocker/beneficiary for Obstruction Relocation, and worker/Job Episode for Job lifecycle.

Log Publication MUST NOT force all producers into anonymous entity slots when doing so would erase semantic meaning.

## NORMAL publication contract

NORMAL is transition-driven. It MUST NOT emit periodic "still running" publication merely to prove liveness.

The initial NORMAL contract requires support for these semantic publication families when their owning authority establishes the corresponding fact:

| Publication family | Owning semantic boundary | Minimum useful context |
| --- | --- | --- |
| product startup / activation state | product startup after Configuration resolution | version and resolved enabled state |
| Job Episode start/end | Operation Lifecycle | Job Episode identity and subject; Operation only if already established |
| Local Operation start/end | Operation Lifecycle | Operation identity and field locator when available |
| Regulation start/end | Responsibility Transition | Operation, responsibility identity, roles/reason/outcome |
| Cooperative Passage start/end | Responsibility Transition plus governing Passage/Resolution terminal meaning | Operation, responsibility/resolution context, pair roles/outcome |
| Obstruction Relocation start/end | Responsibility Transition plus governing Relocation/Resolution terminal meaning | Operation where applicable, responsibility/resolution context, blocker/beneficiary/outcome |
| player intervention required | lifecycle that positively establishes escalation | relevant semantic context and reason |
| operational warning/error | authority owning the abnormal semantic/system fact | stable event code, relevant context and reason |

The event code for each implemented publication MUST follow the Event-code contract. This initial contract does not freeze a complete catalogue of every future DEBUG/DIAGNOSTIC code.

Repeated observation of unchanged state MUST NOT generate a NORMAL lifecycle transition.

Physical Control effects MUST NOT substitute for their owning semantic lifecycle boundary.

## DEBUG publication contract

DEBUG publication MUST remain bounded enough to request from a normal player during support investigation.

For an affected interaction it SHOULD provide sufficient causal narrative to determine, where applicable:

- which Job Episodes, Operation and subjects were involved;
- the semantic state/transition being considered;
- the selected/rejected/superseded purpose or Candidate and principal reason;
- requested Control and relevant outcome;
- responsibility transition/release; and
- where the causal chain visibly diverged from expected behaviour.

DEBUG MUST NOT automatically publish every per-cycle geometry value, every Candidate verdict, complete footprints or continuous evidence streams merely because those values exist.

## DIAGNOSTIC publication contract

DIAGNOSTIC publication MAY contain high-detail engineering evidence for a bounded investigation.

DIAGNOSTIC policy MUST NOT automatically activate every diagnostic instrument. Instrument activation, evidence-production cadence, signature-change detection and heartbeat behaviour remain upstream responsibilities.

A diagnostic warning remains DIAGNOSTIC unless the owner separately establishes an operational warning.

## Rendering contract

For each admitted Publication Event, Log Publication MUST:

- render the stable event code visibly;
- apply one consistent OuttaMyWay publication envelope;
- render supplied common context deterministically;
- preserve producer-owned semantic role names;
- route through the severity-appropriate GIANTS logging facility; and
- emit at most one log line for that Publication Event.

A multi-line diagnostic dump MUST therefore be represented as several independently classified Publication Events rather than one event that emits an unbounded multi-line block.

The contract deliberately does not freeze punctuation, bracket style or exact field ordering beyond deterministic common-context rendering.

## Product-disabled startup contract

Log Publication availability MUST NOT depend on OuttaMyWay intervention being enabled.

After Configuration has resolved product state, the global startup/activation publication must be possible even when normal spatial coordination remains disabled.

This contract does not define the public Configuration setting name, default, persistence or whether later runtime enable/disable transitions are supported.

## Suppression and performance contract

A suppressed Descriptor MUST terminate publication before any avoidable publication-only Payload work.

A suppressed event therefore MUST NOT perform work solely to prepare the absent line, including avoidable context projection, diagnostic traversal, sorting, evidence summarisation, string conversion, formatting or GIANTS logging calls.

This requirement does not suppress semantic Runtime work or independently justified diagnostic evidence production.

## Failure contract

Publication failure MUST NOT become semantic Runtime failure.

Failure while validating a Descriptor, constructing an admitted Payload, rendering a line or invoking the logging destination MUST NOT undo an established semantic transition, alter Current Responsibility, alter Bounded Authority, alter Control, or advance semantic state.

The implementation MUST prevent publication-failure reporting from recursively using the same failed publication path.

A minimal non-recursive fallback or returned implementation outcome MAY be used, but its exact mechanism is implementation detail.

## No generic deduplication or rate-limiting authority

Log Publication MUST NOT infer semantic duplicate transitions from message similarity or payload text.

Semantic owners are responsible for emitting genuine transition events rather than repeated observations.

Diagnostic instruments remain responsible for their own cadence/change/heartbeat policy.

A generic publication rate limiter or deduplication policy requires separate evidence and is not part of this contract.

## Configuration and HUD boundaries

[Configuration Architecture](../architecture/CONFIGURATION.md) owns supported player choices, defaults, persistence and mapping into resolved runtime policy. Configuration names MUST NOT be derived from Log Publication module/function addresses.

[GUI Architecture](../architecture/GUI.md) owns player-facing messaging/HUD behaviour. Log Publication MUST NOT become a destination router for HUD messages.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/publication/LogPublication.lua`](../scripts/publication/LogPublication.lua) | `REALISES` |

## Implementation traceability

The current implementation deliberately has one narrow publication boundary:

- [`scripts/publication/LogPublication.lua`](../scripts/publication/LogPublication.lua) owns Descriptor validation, cumulative eligibility, deferred Payload invocation, deterministic one-line rendering, severity routing and non-recursive publication-failure isolation;
- [`scripts/main.lua`](../scripts/main.lua) composes the product-level publisher, publishes the startup-state event and currently supplies `DIAGNOSTIC_LOGGING=true` only when no earlier Configuration value exists. This is a migration compatibility input, not an accepted player default;
- Issue #139 owns eventual supported player names, defaults, persistence/change semantics and the Configuration-to-publication/diagnostic-activation mapping;
- semantic owners and diagnostic instruments call the publication contract while retaining ownership of event meaning, code, class, severity and role vocabulary.

No production module outside `LogPublication.lua` directly addresses the GIANTS logging destination. Existing semantic producers therefore call the contract rather than becoming Log Publication contract participants merely because they publish events.

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/replacement_core/log_publication.lua`](../tests/replacement_core/log_publication.lua) | `CHALLENGES` |
| [`tests/replacement_core/operation_lifecycle.lua`](../tests/replacement_core/operation_lifecycle.lua) | `CHALLENGES` |
| [`tests/test_log_publication_structure.py`](../tests/test_log_publication_structure.py) | `CHALLENGES` |

## Validation route

Current offline contract evidence challenges:

- NORMAL/DEBUG/DIAGNOSTIC cumulative eligibility;
- severity not widening class eligibility;
- suppressed Payload construction never being invoked;
- admitted Payload construction occurring once per event;
- one event producing at most one GIANTS logging call;
- stable readable event-code validation;
- Operation identity remaining distinct from field locator;
- unavailable optional context not being fabricated;
- publication not consuming Runtime identity/epoch or mutating semantic state;
- publication/payload failure not propagating into semantic behaviour;
- DIAGNOSTIC publication not activating diagnostic instruments; and
- startup-state publication remaining possible while product operation is disabled.

These are offline contract claims. They do not prove GIANTS runtime logging performance, file-I/O cost or frame pacing; those require appropriate Runtime/Reality evidence.
