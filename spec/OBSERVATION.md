# Observation Specification

## Identity and authority

**Specification Jurisdiction:** Observation  
**Primary Architecture Authority:** [`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#4-specification-jurisdiction--observation)

This Specification owns the implementation-facing contract by which current evidence from Reality is acquired, identified, bounded, preserved and published for downstream interpretation.

Observation does **not** own Situation meaning, active-participation classification, Candidate support, Constraint verdicts, Decision, Current Responsibility, Bounded Authority or Control. It may expose evidence needed by those responsibilities, but it MUST NOT perform their semantic work while producing Observation.

> **Observation publishes evidence; it does not publish conclusions that belong downstream.**

Related architectural context includes Operation Lifecycle, Situation Assessment and Physical Representation. Those contracts are dependencies or consumers; they are not redefined here.

## Boundary contract

### Inputs

Observation consumes current Reality evidence from supported GIANTS/runtime sources and from already-authorised Control outcomes returning through Reality.

An Observation implementation MAY use several source modules or adapters. Regardless of topology, every evidence contribution used downstream MUST retain enough context to establish, where applicable:

- the observed subject or external reference;
- source/provenance;
- observation time or freshness relationship;
- whether the source was available;
- the value or bounded raw relationship actually observed; and
- any explicit limitation needed to prevent downstream overclaim.

A source that cannot currently answer its question MUST NOT manufacture a negative answer. Unavailability, unsupported access or incomplete evidence MUST remain distinguishable from positive contradiction.

### Published Observation

One published Observation Snapshot is the coherent evidence product for one observation cycle.

The Snapshot MUST have:

- a unique Observation identity;
- an ordered observation epoch or equivalent sequencing identity;
- a timestamp or equivalent observation-time marker;
- overall provenance for the publication event; and
- explicit representation of source unavailability where materially relevant.

The Snapshot MAY contain several evidence domains, including Field World evidence, Physical Assembly observations, physical geometry/motion evidence, AI/runtime-state evidence, player-control evidence, Job Episode evidence, Operation-membership evidence, physical-representation evidence and Control outcomes.

Those domains are not semantic classifications merely because they are grouped in one Snapshot. Their names describe evidence subject matter, not downstream authority.

Diagnostic projections MAY accompany Observation when they remain clearly non-authoritative. Diagnostic convenience MUST NOT alter the raw evidence contract or silently become Situation meaning.

### Identity and reference rules

External/runtime reference keys are correlation inputs unless another authority has established semantic identity.

Observation MAY resolve supported reference keys through the repository identity mechanism when publishing a stable downstream subject identity. It MUST preserve the distinction between:

- the external/runtime reference used to locate evidence; and
- the semantic identity issued or resolved by the responsible identity authority.

A pair key, object reference, node handle, Job token, field reference or similar runtime locator MUST NOT silently become architectural identity merely because it is stable enough for one source.

### Downstream contract

Situation Assessment and other authorised consumers may interpret published evidence only within the provenance, freshness and limits carried by Observation.

Observation MUST NOT strip evidence limitations merely because a downstream consumer expects a simpler answer.

Control outcomes MUST re-enter through Reality and Observation before they can support semantic success, failure, persistence or settlement conclusions. Control MUST NOT self-certify those conclusions by writing them directly into downstream semantic state.

## Semantic data contract

The contractually significant properties of a published Observation Snapshot are:

- **Observation identity** — identity of this published Snapshot, not the identity of any observed subject;
- **epoch / sequence** — ordering support for freshness and exact-cycle reasoning;
- **timestamp** — observed publication time, without claiming universal wall-clock authority;
- **provenance** — where the Snapshot/publication originated;
- **subject evidence** — raw or bounded source evidence grouped by relevant subject domain;
- **unavailable sources** — explicit evidence that a source/question could not currently be observed; and
- **diagnostics**, where present — non-authoritative explanatory material that MUST remain distinguishable from evidence used as semantic authority.

The current Lua record layout is an implementation representation of this contract, not the normative field inventory. An implementation MAY reorganise the internal object shape while preserving these semantics and downstream traceability.

## Durable invariants

### Evidence is not downstream semantic authority

A published Observation MUST NOT contain fields or products whose meaning establishes downstream responsibility merely for implementation convenience.

In particular, Observation MUST NOT independently establish Candidate preference, selected Candidate, commitment state, terminal disposition, admissibility, strategy, Job Episode termination, Operation participation, Situation relevance, obstacle relevance, Representation Fitness, selected representation or responsibility relation.

The exact implementation guard may evolve; the semantic prohibition does not.

### Missing evidence is not negative evidence

Absence, source failure or unsupported access MUST remain unresolved/unavailable unless the source contract positively supports a negative conclusion.

### Provenance survives publication

Evidence that requires provenance, source or freshness limits for truthful interpretation MUST retain them through publication. A downstream consumer MUST NOT be forced to reconstruct provenance from source topology or call order.

### Publication does not mutate Reality

Observation acquisition and publication MUST NOT perform Control, alter GIANTS progression, acquire responsibility or change the observed world in order to make evidence easier to classify.

### One publication identity names one coherent Snapshot

One Observation identity/epoch MUST NOT be reused for materially conflicting Snapshot contents. If fresh observation produces a materially new evidence set, publish a fresh Snapshot identity/epoch rather than retroactively rewriting the accepted meaning of the previous one.

### Diagnostic convenience remains subordinate

Diagnostics MAY explain or project evidence but MUST NOT become the only carrier of evidence required by downstream semantic contracts.

## Failure and uncertainty semantics

Observation is expected to encounter incomplete, contradictory and unavailable evidence.

- **Positive support** — publish the observed fact with its relevant provenance and limits.
- **Positive contradiction** — publish the contradictory evidence rather than silently reconciling it into a preferred semantic outcome.
- **Unavailable / unsupported source** — represent unavailability explicitly where material; do not publish a fabricated negative value.
- **Malformed publication input** — reject publication fail-closed when required publication identity/provenance/subject integrity cannot be established.
- **Duplicate or internally incoherent subject mapping** — reject or isolate the invalid publication rather than silently merging incompatible evidence.
- **Conflicting evidence** — preserve the conflict for the responsible downstream Jurisdiction unless the source contract itself has authority to resolve that specific evidence question.

Observation failure does not grant Situation Assessment, Responsibility Transition or Control permission. It narrows what can be known.

Fresh observation is the normal retry path. A prior unavailable source does not remain unavailable by historical memory when Reality later provides evidence.

## Cross-Jurisdiction dependencies

### Identity services

Observation may use identity services to resolve or issue stable subject/Snapshot identities. Identity issuance does not give Observation authority to reinterpret the observed subject.

### Operation Lifecycle

Observation publishes Job Episode and Operation-relevant evidence. Operation Lifecycle owns admission, participation and termination meaning.

### Physical Representation

Observation may publish physical source evidence and representation-related measurements. Physical Identity Resolution and Assessment Representation own what those measurements may prove spatially.

### Situation Assessment

Situation Assessment consumes Observation and assigns current semantic meaning. Observation MUST remain usable without carrying Situation classifications itself.

### Control

Control may produce physical outcomes. Those outcomes become evidence only by returning through Reality and Observation.

## Implementation traceability

The following mapping is **non-normative source traceability**. It describes the present mechanism; it does not define the contract.

Primary current implementation routes include:

- [`scripts/contracts/ObservationSnapshot.lua`](../scripts/contracts/ObservationSnapshot.lua) — current sealed Snapshot value contract and guard against downstream semantic fields;
- [`scripts/observation/RuntimeObservationAdapter.lua`](../scripts/observation/RuntimeObservationAdapter.lua) — current publication boundary that assigns Observation identity/epoch and converts raw source evidence into the Snapshot;
- [`scripts/observation/LiveObservationSource.lua`](../scripts/observation/LiveObservationSource.lua) — current live source composition;
- bounded evidence sources under [`scripts/observation/`](../scripts/observation/), including Job, physical assembly/pose, native field-work and interaction evidence; and
- runtime orchestration that publishes/consumes sealed Observation Snapshots.

No one source file is the Observation Jurisdiction. Source topology may change while this contract remains stable.

> **Primary Specification != Primary Source Module**

## Validation route

### Structural/source-contract validation

Current structural evidence includes:

- [`tests/test_live_interaction_observation_structure.py`](../tests/test_live_interaction_observation_structure.py), which protects Observation ownership and diagnostic/evidence separation; and
- broader structural contracts in [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py), which protect active Observation placement and separation from later responsibilities.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises sealed Observation and downstream contracts in the offline runtime harness.

Offline validation can show that publication and consumers respect the asserted evidence contract under the harness. It cannot prove that GIANTS supplies equivalent evidence or timing in-game.

### Targeted in-game Reality validation

Claims about GIANTS source availability, Job lifecycle evidence, physical-node evidence, runtime timing or player-control signals require appropriately scoped in-game Reality evidence.

### Outside this Specification's validation claim

A correct Observation Snapshot does not prove that Situation Assessment interprets it correctly, that a Candidate is supportable, that Responsibility Transition is justified or that Control succeeds physically.

Those are downstream contracts.
