# Operation Lifecycle Specification

## Identity and authority

**Specification Jurisdiction:** Operation Lifecycle  
**Primary Architecture Authority:** [`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#2-specification-jurisdiction--operation-lifecycle)

This Specification owns the implementation-facing contract for establishing, maintaining and closing **Job Episodes** and field-bounded **Local Operation** participation from authoritative GIANTS lifecycle evidence, including Field World identity/equivalence, membership evidence asymmetry and natural closure.

Operation Lifecycle does **not** own general Observation semantics, Situation interpretation, traffic strategy, Candidate construction, Current Responsibility, representation fitness, Bounded Authority or Control.

> **Participation Authority != Intervention Capability.**

A worker can be an authoritative Local Operation participant while later traffic, representation or Control capability remains unresolved.

## Boundary contract

### Inputs

Operation Lifecycle consumes one sealed Observation Snapshot and the bounded lifecycle evidence carried by it, including as applicable:

- current GIANTS Job presence and AI-control evidence;
- exact source Job token or another supported Job Episode identity witness;
- positive restart, replacement, source-job-end or runtime-removal evidence;
- positively observed productive field-work commencement;
- immutable Job-seeded Field World Snapshot evidence;
- Field World equivalence conclusions;
- Field World / polygon provenance; and
- Operation-membership evidence plus its completeness status.

Observation supplies these facts and their limits. Operation Lifecycle assigns lifecycle meaning to them; Observation MUST NOT predeclare admission, participation or termination.

### Job Episode identity and admission

One **Job Episode** represents one current qualifying GIANTS AI work episode for one Physical Assembly.

A Job Episode implementation MUST preserve a stable semantic identity from admission until positive termination. A restart or replacement GIANTS Job is a new Job Episode even when it uses the same Physical Assembly.

Admission requires positive evidence that a qualifying GIANTS Job is present and AI-controlled, together with a supported source Job identity/token. Where source Job identity is temporarily unavailable but the Observation contract supplies a supported observational episode identity, that identity remains explicitly bounded by its provenance.

Job Episode admission alone does **not** establish Local Operation membership. Membership additionally requires the field-work and Field World conditions below.

### Job Episode Bootstrap

Job Episode Bootstrap is the lifecycle opportunity to discover/cache expensive stable knowledge needed repeatedly during the active episode.

Bootstrap MAY establish or cache, where supported:

- Physical Assembly identity/membership;
- stable job-scoped representation structure;
- supported configuration/footprint knowledge; and
- other expensive stable episode-scoped capability facts.

Bootstrap MUST NOT freeze dynamic pose, articulation, configuration state, heading, productive direction or future GIANTS intent.

Job-scoped cache authority expires with the Job Episode unless another contract independently preserves a still-valid physical fact. Historical episode cache is not a prerequisite for later recognition of a non-active physical blocker.

### Job Episode termination and succession

An active Job Episode terminates only from positive governing lifecycle evidence, including supported source-job completion/end, supported restart/replacement/succession, or positive runtime-subject removal where the lifecycle contract recognises it.

Mere absence, incomplete observation, temporary inactivity, zero speed or player presence MUST NOT independently terminate an active Job Episode.

When a successor/replacement is positively established, the predecessor MUST terminate before the successor becomes the active episode for that assembly. The two semantic episode identities MUST NOT be conflated.

> **Job Termination Owns Active-Participant Loss.**

Positive termination of the exact Job Episode is an authoritative lifecycle fact for downstream participation and Job-founded responsibility reconciliation.

### Field World Snapshot contract

A Job Episode may capture one immutable **Job-Seeded Field World Snapshot** representing the contiguous agronomic workspace experienced at bootstrap/admission.

The implementation MUST preserve the distinction between:

- immutable Snapshot identity/provenance; and
- resolved Field World identity established by equivalence authority.

Once a Job Episode has captured its Snapshot identity, polygon provenance and geometry fingerprint, those facts MUST NOT silently change for that episode. A restarted/replacement Job Episode captures and resolves independently.

Player-facing field IDs, farmland IDs, seed positions, fingerprints or one scalar metric are locators/provenance unless Field World Equivalence Authority grants stronger meaning.

### Field World Equivalence contract

Field World Equivalence Authority classifies one Snapshot against current Field World evidence as exactly one of:

- **SAME_FIELD_WORLD** — coherent positive evidence supports membership in one existing Field World;
- **DIFFERENT_FIELD_WORLD** — positive separation/incompatibility supports a distinct Field World; or
- **UNRESOLVED** — available evidence cannot establish one coherent assignment.

`UNRESOLVED` grants no Local Operation admission or extension of cooperative authority.

Failure to prove SAME MUST NOT manufacture DIFFERENT. Failure to prove DIFFERENT MUST NOT manufacture SAME.

Joining an existing Field World requires class-wide coherent evidence. Pairwise tolerance chaining MUST NOT manufacture an incoherent equivalence class.

Evaluator thresholds, sampling budgets and history-retention limits remain implementation/validation calibration unless separately promoted by accepted contract.

### Local Operation establishment

A **Local Operation** is one ephemeral cooperative lifecycle associated with exactly one resolved Field World.

A Physical Assembly becomes a Local Operation participant only when current positive evidence establishes all of:

1. a current qualifying Job Episode for that assembly;
2. positively witnessed supported productive field work for that episode; and
3. a resolved Field World relationship coherent with the Local Operation.

The first qualifying participant establishes a new Local Operation when no active Operation exists for that Field World. Later qualifying episodes join the existing Operation.

Job Episode existence, worker proximity, physical conflict or representation completeness alone MUST NOT establish participation.

A Local Operation MAY exist with one participant and requires no active Regulation or Resolution Commitment.

Within the supported envelope, at most three supported GIANTS AI worker assemblies are simultaneously active participants. Player-controlled vehicles do not count toward that three-AI envelope.

### Productive commencement witness

Operation membership begins only after the Job Episode has positively demonstrated actual supported productive field work.

Once positively witnessed, productive commencement MAY remain latched for the same exact Job Episode through ordinary headland turns or other later non-productive samples. The latch MUST NOT transfer to a replacement/restarted Job Episode.

This prevents ordinary Job-entry/turn revelation from being mistaken for established cooperative participation while avoiding repeated membership churn after genuine productive work has begun.

### Dynamic membership

A Local Operation may gain and lose independently starting/finishing Job Episodes while preserving the same Operation identity for the Field World.

Membership updates MUST preserve exact assembly-to-Job-Episode correspondence. An assembly classified as an active Operation participant MUST have a current qualifying active Job Episode under this contract.

Successive Local Operations in the same Field World are distinct lifecycle instances; closure followed by later new work MUST establish a new Operation identity.

## Lifecycle Evidence Asymmetry

Lifecycle uncertainty is asymmetric:

> **Positive or complete lifecycle evidence may establish admission, succession, completion or membership removal. Absence under incomplete observation does not.**

When Operation-membership evidence is incomplete:

- positively observed new members MAY be added;
- previously admitted members MUST NOT be removed merely because they are absent from that incomplete sample; and
- uncertainty MUST remain explicit for downstream interpretation.

However, incompleteness of the wider membership sample MUST NOT erase or defer a separately positive lifecycle fact for an exact member.

> **Lifecycle Certainty and Observation Completeness Are Orthogonal.**

> **Positive Termination != Missing-Membership Evidence.**

If an admitted member's exact Job Episode has positively terminated, that assembly no longer satisfies active-participant membership even when another member's lifecycle/membership evidence remains unresolved. The implementation MUST reconcile the positively terminated member independently from uncertainty about other members.

A timeout, grace period or observation gap MUST NOT manufacture positive completion or safe removal.

## Natural closure

A Local Operation closes naturally when no active qualifying participant remains after authoritative membership reconciliation.

Closure MUST NOT create:

- a settlement phase;
- parking/tidying duty;
- terminal-egress responsibility;
- automatic relocation; or
- residual Operation cleanup choreography.

Completed physical assemblies remain Reality and may later become physically relevant to Situation Assessment. Their continued existence does not keep the Local Operation open and does not itself create another responsibility.

## Operation product contract

The lifecycle products published for downstream use MUST preserve enough semantic information to distinguish current participation from history and uncertainty.

As applicable, the contract includes:

### Job Episode product

- semantic Job Episode identity;
- Physical Assembly identity;
- supported source Job identity/token and provenance;
- admitted epoch/evidence;
- ACTIVE or ENDED status;
- immutable captured Field World Snapshot/polygon provenance when available;
- resolved Field World identity/equivalence status when established;
- positive terminal epoch/cause/evidence when ended; and
- revision or equivalent monotonic change identity.

### Local Operation product

- semantic Local Operation identity;
- resolved Field World identity;
- ACTIVE or ENDED status;
- current member Assembly identities;
- current member Job Episode identities;
- Field World Snapshot/polygon provenance for admitted members;
- evidence/provenance for the current membership revision;
- explicit membership-evidence completeness state; and
- positive terminal evidence when naturally closed.

The current Lua record layouts are implementation representations of these semantic contracts, not normative exhaustive field inventories.

## Durable invariants

### One active Job Episode per assembly lifecycle slot

An assembly MUST NOT simultaneously have two active semantic Job Episodes. Positive succession ends the predecessor and admits a distinct successor.

### Snapshot identity is not Field World identity

Equivalent Snapshots remain distinct immutable evidence records even when they resolve to one Field World.

### One active Local Operation per resolved Field World

The implementation MUST NOT create parallel active Local Operations for the same resolved Field World merely because membership changes.

### Operation identity survives ordinary membership churn

Adding/removing participants within one active Field World lifecycle changes membership revision, not Operation identity.

### Participation requires active Job identity

A Local Operation participant MUST correspond to a currently active qualifying Job Episode. Retained physical relevance after Job completion is not active participation.

### Incomplete evidence preserves uncertainty, not stale certainty

Incomplete samples protect against removal-by-absence only. They MUST NOT override positive termination, positive replacement or other authoritative member-specific lifecycle evidence.

### Lifecycle authority does not create traffic responsibility

Job Episode/Operation admission does not create Regulation, Resolution Commitment, Bounded Authority or Control permission.

## Failure and uncertainty semantics

- **Current GIANTS Job identity unavailable/unsupported** — no unsupported strong Job identity claim; preserve bounded observational provenance or leave admission unresolved according to Observation contract.
- **Job Episode termination unavailable** — preserve the active episode under Lifecycle Evidence Asymmetry; do not terminate by absence.
- **Conflicting authoritative succession causes** — reject/fail closed rather than selecting one arbitrarily.
- **Field World Snapshot unavailable** — Job Episode may remain known, but Local Operation participation requiring resolved Field World remains unsupported.
- **Field World equivalence UNRESOLVED** — no admission to an existing/new cooperative Field World context from that unresolved assignment.
- **Productive commencement not positively witnessed** — do not admit the episode as an Operation participant; its physical/current GIANTS presence may still be relevant elsewhere.
- **Membership evidence incomplete** — add positive members, preserve unresolved prior members against removal-by-absence, independently honour positive member-specific termination.
- **Zero members with complete authoritative membership evidence** — close the Local Operation naturally.

Failure or uncertainty in Operation Lifecycle narrows participation knowledge. It MUST NOT manufacture Situation relationships or physical authority.

## Cross-Jurisdiction dependencies

### Observation

[`OBSERVATION.md`](OBSERVATION.md) owns acquisition/provenance of Job, Field World and membership evidence. Operation Lifecycle owns admission and termination meaning.

### Physical Identity Resolution / Assessment Representation

Physical representation may be bootstrapped/cached during a Job Episode, but representation completeness does not define participation. The Physical Representation contracts own what geometry/identity claims are valid.

### Situation Assessment

[`SITUATION_ASSESSMENT.md`](SITUATION_ASSESSMENT.md) consumes authoritative lifecycle products to interpret current Situation meaning. It MUST NOT recreate, delay or override positive lifecycle transitions.

### Responsibility Transition / Resolution Lifecycle

Job-founded Current Responsibilities may lose governing basis when exact Job Episodes terminate. Those Jurisdictions own responsibility reconciliation; Operation Lifecycle supplies the lifecycle fact.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/identity/JobEpisodeAdmission.lua`](../scripts/identity/JobEpisodeAdmission.lua) — current Job Episode admission, succession, positive termination and immutable Field World binding;
- [`scripts/identity/OperationAdmission.lua`](../scripts/identity/OperationAdmission.lua) — current Local Operation establishment, dynamic membership, incomplete-membership preservation and natural closure;
- [`scripts/identity/FieldWorldSnapshotRegistry.lua`](../scripts/identity/FieldWorldSnapshotRegistry.lua) — current immutable Job-seeded Field World Snapshot capture/registry mechanism;
- [`scripts/identity/FieldWorldEquivalenceEvaluator.lua`](../scripts/identity/FieldWorldEquivalenceEvaluator.lua) and [`scripts/identity/FieldWorldEquivalenceAuthority.lua`](../scripts/identity/FieldWorldEquivalenceAuthority.lua) — current equivalence evidence and coherent Field World assignment;
- [`scripts/observation/LiveObservationSource.lua`](../scripts/observation/LiveObservationSource.lua) — current live Job/productive-commencement/Field World/member evidence source; and
- [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) — current ordered sealed-observation handoff: Observation publication → Job Episode admission → Operation admission → Situation Assessment.

No one source module is the Operation Lifecycle Jurisdiction.

## Validation route

### Structural/source-contract validation

Current structural evidence includes:

- [`tests/test_field_world_value_ownership_structure.py`](../tests/test_field_world_value_ownership_structure.py), which protects Field World value/equivalence ownership boundaries; and
- [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py), which protects active Job/Operation admission placement and separation from Situation/Decision/Control.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises Job Episode admission, replacement/restart, Field World equivalence, Operation membership and lifecycle handoffs in the replacement-core harness.

Offline fixtures are the appropriate first validation surface for mixed lifecycle-evidence cases because exact membership completeness and terminal evidence can be controlled independently.

### Targeted in-game Reality validation

In-game validation remains required for the truth and timing of GIANTS active-job membership, source-job end evidence, productive commencement, runtime removal and Field World capture/equivalence evidence.

### Outside this Specification's validation claim

A correct Operation lifecycle does not prove Situation relationships, Candidate support, Current Responsibility correctness or successful physical Control. Those are downstream contracts.
