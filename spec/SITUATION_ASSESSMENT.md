# Situation Assessment Specification

## Identity and authority

**Specification Jurisdiction:** Situation Assessment  
**Primary Architecture Authority:** [`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#5-specification-jurisdiction--situation-assessment)

This Specification owns the implementation-facing contract for interpreting current evidence into current **Situation meaning** for each active Local Operation, including current participation meaning, physical relevance, current relationships, uncertainty, obstruction causality, representation fitness for the current question, and semantic justification for whether an existing responsibility remains supported or a different lifecycle outcome should be considered.

Situation Assessment does **not** own raw evidence acquisition, Field World/Job/Operation lifecycle authority, representation truth construction, Candidate construction, mandatory Constraint verdicts, Decision, Responsibility Transition, Bounded Authority or Control.

> **Situation Assessment Interprets Reality; It Does Not Acquire Responsibility.**

> **Semantic Interpretation != Lifecycle Authority.**

Operation Lifecycle publishes participation facts. Situation Assessment may use them, but it MUST NOT recreate, delay or override positive Job Episode or Local Operation lifecycle transitions.

## Boundary contract

### Inputs

Situation Assessment consumes one coherent set of upstream products for the same observation cycle:

- one sealed [`Observation Snapshot`](OBSERVATION.md);
- the corresponding Job Episode lifecycle result;
- the corresponding Local Operation lifecycle result;
- current representation products and their claim permissions;
- current open responsibility/commitment/obligation context where needed to assess persistence or discharge; and
- current physical/semantic evidence required by specialised Situation questions.

The implementation MUST preserve the identity/provenance relationship among these inputs. It MUST NOT combine lifecycle facts from one Observation with raw evidence from another and call the result current.

### Operational Picture publication

One Situation Assessment cycle publishes one **Operational Picture** representing the current semantic interpretation of the accepted evidence universe.

The Operational Picture MUST have:

- its own semantic identity/epoch;
- the exact Observation Snapshot identity from which it was assessed;
- current active Job Episode and Local Operation identities supplied by Operation Lifecycle;
- current Situation records scoped to active Local Operations;
- current semantic relationships and uncertainty;
- representation-fitness conclusions needed for downstream questions;
- current responsibility/obligation context where relevant to persistence assessment; and
- provenance sufficient to audit the interpretation boundary.

Situation Assessment MUST NOT preselect Candidate Support, publish mandatory Constraint verdicts, choose a Decision or create Current Responsibility.

### Current Situation scope

A Situation is current semantic meaning for one active Local Operation, not a historical Encounter or persistent pair object.

Situation identity MAY remain stable while the same Local Operation remains the current context, but the meaning published for each Operational Picture MUST be derived from current evidence and accepted retained semantic state only where Architecture explicitly permits persistence.

Historical positive relationship evidence MUST NOT be republished as current merely because it was true previously.

### Active participation

Situation Assessment consumes active Operation membership rather than inventing it.

An **active participant** is a supported Physical Assembly with a current qualifying Job Episode participating in the Local Operation under [`OPERATION_LIFECYCLE.md`](OPERATION_LIFECYCLE.md).

Situation Assessment MUST NOT classify an assembly as an active Operation participant solely from speed, proximity, field location, historical participation or physical relevance.

When Operation membership is uncertain, Situation Assessment MAY publish explicit membership uncertainty but MUST NOT silently convert that uncertainty into positive member removal or positive member continuation beyond the authority supplied by Operation Lifecycle.

### Physical relevance

A physical entity may be relevant to active work without being an active Operation participant.

Situation Assessment MAY include a nonparticipant physical subject when current Reality supports material relevance to the current Operation. This does not grant Job participation, traffic cooperation status or actuation authority.

> **Operational Membership != Spatial Relevance.**

Past Job Episode history, prior OuttaMyWay participation, vehicle ownership or completed-worker provenance are not prerequisites for current physical relevance.

### Resolution-space participation before productive commencement

A current active GIANTS field-work worker whose Job Episode is in the same resolved Field World but whose productive-commencement witness is not yet positive is not yet an Operation participant.

Situation Assessment MAY nevertheless classify that worker as a current physical/intent-revelation constraint on a productive member when current evidence supports that relevance. Such a classification MUST retain the distinction:

- `operationMember = false`; and
- current Situation relevance / Resolution-Space eligibility may be true.

This permits preservation of scarce option space without moving the membership boundary upstream.

## Relationship interpretation

### Current Pair Assessment Scope

For each active Local Operation, pairwise Situation questions are scoped from the exact current Operation members and their exact active Job Episodes.

A Current Pair Assessment Scope is ephemeral assessment scope. It MUST NOT create:

- persistent pair history;
- cooldown or recent-interaction memory;
- responsibility identity;
- right-of-way ownership; or
- future-route ownership.

When positive interaction evidence disappears and no authorised representation owns a negative conclusion, the current pair relationship is `UNRESOLVED`, not silently safe or dissolved.

> **Absence Is Not Separation.**

> **Evidence Continuity != Evidence Freshness.**

### Motion and productive-continuation meaning

Situation Assessment may interpret current movement, local intent and native field-work evidence into bounded current knowledge such as productive continuation, follower relationships, forward intersections or opposed-corridor relationships.

Those conclusions MUST remain scoped to their evidence horizon. Transient turning/manoeuvring vectors MUST NOT become unsupported future-route authority.

Where productive continuation is positively established, downstream spatial specialisations MAY consume the resulting bounded certainty according to Spatial Negotiation Architecture. When that evidence ceases, Situation Assessment MUST publish the current unresolved/changed meaning rather than preserve stale continuation as current Reality.

### Representation Fitness

Assessment Representation publishes geometry, validity, uncertainty and claim permissions. Situation Assessment is the **Representation-Fitness Arbiter for the current question**.

Situation Assessment MAY conclude that a representation is currently fit, unfit or unresolved for a particular Situation question/horizon. It MUST NOT:

- manufacture missing representation coverage;
- enlarge claim permissions;
- convert purpose-specific geometry into generic authority; or
- alter the underlying representation product merely to obtain a desired Situation conclusion.

> **Representation Product != Fitness Verdict.**

Fitness is question-relative. A representation rejected for one conclusion may remain valid for another supported purpose.

### Causal Obstruction

A **Causal Obstruction** is a current positive Situation relationship in which one physical subject is established as the cause preventing an active supported beneficiary from continuing supported work.

The assessment MUST identify, where supported:

- beneficiary active participant;
- blocker physical subject;
- current positive causal basis;
- blocker active/non-active classification evidence; and
- Player Claim evidence relevant to whether downstream relocation may even be considered.

A stationary, completed, player-owned or otherwise non-active vehicle does not create a Causal Obstruction merely by existing.

Conversely, a positively causal blocker MUST NOT be ignored because it lacks historical OuttaMyWay provenance.

> **Obstruction Is the Predicate.**

> **Physical Relevance != Historical Provenance.**

Causal Obstruction is Situation meaning only. Obstruction Relocation, Bounded Authority and Control remain downstream.

### Player Claim and non-active classification

For a non-active blocker, current player presence/entry may establish a **Player Claim** requiring OuttaMyWay to remain hands-off or relinquish physical authority.

Vehicle ownership metadata MUST NOT substitute for current claim evidence.

While the exact qualifying GIANTS Job Episode remains active, player presence alone MUST NOT reclassify that active participant as a non-active blocker.

### Spatial Situation specialisations

Spatial Negotiation Architecture specialises Situation Assessment for:

- current pair scope;
- Productive Forward-Line Certainty;
- TURNING uncertainty;
- Spatial Constraint Overlay;
- Passage foreseeability;
- follower/Forward Intersection relationships; and
- current option-space / Resolution-Margin meaning.

This Specification does not duplicate those spatial policies. The implementation MUST route those conclusions through Situation Assessment semantics rather than Candidate Support or Control.

## Current responsibility interpretation

Situation Assessment may interpret whether the current evidence continues to support an already-established Regulation or Resolution basis, including whether evidence is positively supported, positively dissolved/superseded, or temporarily unresolved.

That interpretation MUST remain distinct from lifecycle mutation:

```text
current evidence
    |
Situation Assessment
    |-- same responsibility still supported / unresolved within contract
    |-- positive dissolution / supersession / basis cessation
    v
Responsibility Transition or specialised lifecycle owner
```

Situation Assessment MUST NOT terminate, establish or replace Current Responsibility directly.

Where Architecture permits `WAITING_FOR_EVIDENCE`, that is an evidence-state interpretation within an already-admitted responsibility. It is not a generic new Current Responsibility type and MUST NOT be created merely because evidence is inconvenient.

## Operational Picture semantic contract

The Operational Picture MUST preserve enough meaning for Candidate Support, Constraint Evaluation, Decision, responsibility maintenance and diagnostics without requiring those consumers to reconstruct Situation semantics from raw source modules.

Contractually significant classes of content include, as applicable:

- current Situation(s) and Local Operation identity;
- current active participants and exact lifecycle identities;
- physically/relevantly observed assemblies distinct from participants;
- current/current-future-space semantic knowledge;
- demand classes such as Committed Demand, Potential Demand and Temporary Slack;
- current pair scope and current relationship classifications;
- motion/productive-continuation knowledge;
- follower / trajectory / opposed-corridor / spatial-constraint knowledge;
- Causal Obstruction knowledge;
- representation fitness and uncertainty;
- current responsibility/commitment/open-obligation context needed by assessment consumers;
- current Control-outcome evidence as interpreted only through Observation; and
- provenance/diagnostics that remain non-authoritative where marked as such.

The current Lua `OperationalPicture` layout is one implementation representation, not the normative exhaustive field list.

## Durable invariants

### One Operational Picture belongs to one Observation interpretation cycle

An Operational Picture MUST remain traceable to the exact Observation Snapshot and lifecycle products from which it was assessed.

### Semantic meaning does not rewrite lifecycle facts

Situation Assessment may interpret participation, relevance and uncertainty but MUST NOT resurrect an ended Job Episode, delay positive member-specific termination, or create Local Operation membership absent lifecycle authority.

### Current meaning outranks historical positive inference

A previous relationship may inform retained responsibility only where that responsibility contract explicitly permits persistence. It MUST NOT be republished as current Situation evidence without current support.

### Missing evidence remains unresolved

Unavailable or incomplete evidence MUST NOT become safe separation, negative obstruction, positive clearance, positive lifecycle termination or another stronger conclusion unless the responsible evidence contract explicitly supports it.

### Purpose-local interpretation preserves purpose scope

A purpose-specific representation or relationship conclusion MUST NOT silently acquire authority for unrelated Situation questions.

### Candidate Support begins after Situation meaning

Situation Assessment MAY expose the complete semantic evidence needed by later Candidate builders. It MUST NOT enumerate/select prospective Candidates, create Candidate-support groups or apply Decision preference.

### Diagnostics do not create semantic truth

Diagnostics MAY expose contradictions, counters and pipeline state. A diagnostic field MUST NOT become the only owner of a semantic fact required by downstream contracts.

## Failure and uncertainty semantics

- **Input identity/provenance mismatch** — reject/fail closed; do not combine incompatible cycles.
- **Operation membership incomplete** — preserve explicit uncertainty; consume Operation Lifecycle's authoritative current membership without inventing removal.
- **Positive lifecycle termination already established** — honour the lifecycle fact; do not preserve active-participant meaning merely because other evidence is incomplete.
- **Representation unavailable/unfit** — publish uncertainty or the strongest supported weaker claim; do not manufacture clearance or conflict.
- **Pair evidence absent without negative authority** — relationship remains unresolved.
- **Source unavailable** — retain explicit uncertainty derived from Observation; no fabricated semantic negative.
- **Conflicting current evidence** — publish contradiction/unresolved meaning or fail closed according to the responsible sub-contract; do not silently choose the interpretation that enables intervention.
- **Causal obstruction not positively supported** — no Causal Obstruction relationship.
- **Current responsibility basis temporarily unresolved where its contract permits waiting** — publish the appropriate evidence-state interpretation; do not terminalise solely from timeout/absence.
- **Current responsibility positively dissolved/superseded** — publish the positive semantic justification; lifecycle owner performs the transition.

Fresh Observation and reassessment are the normal recovery route from unresolved Situation knowledge.

## Cross-Jurisdiction dependencies

### Observation

[`OBSERVATION.md`](OBSERVATION.md) owns current evidence acquisition and provenance. Situation Assessment owns semantic interpretation.

### Operation Lifecycle

[`OPERATION_LIFECYCLE.md`](OPERATION_LIFECYCLE.md) owns Job Episode and Local Operation lifecycle facts. Situation Assessment consumes them and may distinguish active participation from wider physical relevance.

### Assessment Representation

[`ASSESSMENT_REPRESENTATION.md`](ASSESSMENT_REPRESENTATION.md) owns claim-bearing representation products. Situation Assessment decides fitness for the current question without enlarging representation authority.

### Candidate Support

[`CANDIDATE_SUPPORT.md`](CANDIDATE_SUPPORT.md) consumes the Operational Picture and asks what prospective purposes are supportable. It MUST NOT force Situation Assessment to preselect a Candidate.

### Responsibility Transition

[`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) owns authoritative establishment/termination/replacement of Current Responsibility. Situation Assessment supplies current semantic justification only.

### Resolution Lifecycle / specialised responsibilities

Resolution contracts own persistence/obligation terminality. Situation Assessment interprets the current evidence those contracts consume; it does not invent or settle obligations outside those contracts.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/assessment/SituationAssessment.lua`](../scripts/assessment/SituationAssessment.lua) — current Operational Picture composition and semantic handoff;
- [`scripts/assessment/CurrentPairAssessmentScope.lua`](../scripts/assessment/CurrentPairAssessmentScope.lua) — current ephemeral exact-member pair scope;
- [`scripts/assessment/TrajectoryConflictAssessment.lua`](../scripts/assessment/TrajectoryConflictAssessment.lua), [`FollowerBoundaryDemandAssessment.lua`](../scripts/assessment/FollowerBoundaryDemandAssessment.lua) and [`SpatialConstraintAssessment.lua`](../scripts/assessment/SpatialConstraintAssessment.lua) — current spatial relationship/constraint interpretation;
- [`scripts/assessment/CausalObstructionAssessment.lua`](../scripts/assessment/CausalObstructionAssessment.lua) — current positive obstruction-cause interpretation;
- [`scripts/assessment/RepresentationFitness.lua`](../scripts/assessment/RepresentationFitness.lua) and [`PassageCapabilityAssessment.lua`](../scripts/assessment/PassageCapabilityAssessment.lua) — current question-scoped representation-fitness interpretation;
- [`scripts/assessment/CurrentResponsibilityAssessment.lua`](../scripts/assessment/CurrentResponsibilityAssessment.lua) — current specialised semantic persistence/dissolution interpretation for established Regulation purposes; and
- [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) — current orchestration that places Situation Assessment after Observation and Operation lifecycle, before Candidate/Constraint/Decision.

No single assessment helper owns the whole Situation Assessment Jurisdiction.

## Validation route

### Structural/source-contract validation

Current structural evidence includes:

- [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py), which protects the separation of Situation Assessment from Candidate/Decision/Control;
- [`tests/test_live_interaction_observation_structure.py`](../tests/test_live_interaction_observation_structure.py), which challenges Observation-to-Situation evidence ownership;
- [`tests/test_follower_boundary_assessment_value_ownership_structure.py`](../tests/test_follower_boundary_assessment_value_ownership_structure.py) and [`tests/test_trajectory_assessment_value_ownership_structure.py`](../tests/test_trajectory_assessment_value_ownership_structure.py), which protect Situation-owned relationship interpretation; and
- [`tests/test_obstruction_relocation_structure.py`](../tests/test_obstruction_relocation_structure.py), which protects the distinction between Causal Obstruction recognition and downstream relocation mechanics.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises sealed Observation → Operation Lifecycle → Operational Picture flows, relationship interpretation, uncertainty, representation fitness and downstream use.

Offline validation can challenge identity/provenance, deterministic Situation semantics and fail-closed behavior. It cannot prove that the GIANTS/runtime evidence being interpreted is physically complete or timely.

### Targeted in-game Reality validation

In-game validation remains required for live GIANTS intent, productive continuation, blocking causality, physical relevance, timing, player claim and any other Situation conclusion whose source evidence depends on engine/runtime Reality.

### Outside this Specification's validation claim

A correct Operational Picture does not prove that Candidate Support is complete, mandatory Constraints are correct, Decision chooses appropriately, Responsibility Transition succeeds, or Control physically achieves the selected purpose.
