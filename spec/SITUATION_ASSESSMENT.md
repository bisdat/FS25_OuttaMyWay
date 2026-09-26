# Situation Assessment Specification

## Identity and authority

**Specification Jurisdiction:** Situation Assessment  
**Jurisdiction ID:** `SITUATION_ASSESSMENT`

**Primary Architecture Authority:** [`architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#5-specification-jurisdiction--situation-assessment)

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

### Operation membership and dynamic work state

Situation Assessment consumes Local Operation membership as an authoritative lifecycle product. It MUST NOT recreate or narrow that membership from current productive, turning, reversing, stationary, blocked or intent-revelation state.

A current Operation member whose GIANTS-native continuation is transitional or unresolved remains an Operation member. Situation Assessment may classify that dynamic state and use it to constrain current traffic conclusions.

> **Operation Membership != Productive State.**

> **Operation Membership != Passage Readiness.**

In particular, Operation membership alone MUST NOT turn a manoeuvring or otherwise transitional participant into a Passage-ready participant.

**Passage Evaluation Readiness** is established when Situation Assessment positively establishes an **Established Opposed Corridor Conflict** between exactly two current Operation members. That pairwise Situation conclusion is sufficient to ask Cooperative Passage Candidate Support whether a Passage-Capable Theatre exists. It does not itself establish a Passage Candidate, commitment, geometry or actuation authority.

Settled-continuation / native-intent evidence remains valid Situation evidence for interpreting transitional motion and selecting Regulation roles, but it MUST NOT independently veto Passage evaluation after the opposed-corridor conflict has already been positively established.

> **Passage Evaluation Readiness != Passage Candidate Support.**

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

### Blocked Progress and Recovery Approach knowledge

Situation Assessment owns the upstream interpretation required to distinguish a raw native blockage assertion from a positively established **Blocked Progress Stall**.

The assessment consumes authoritative current Local Operation membership / Job Episode identity, position-derived realised motion, raw GIANTS blockage assertion, current configuration-profile continuity and current OuttaMyWay progress-actuation ownership. It MUST NOT add a second productive-commencement membership gate, and it MUST NOT use the Observation placeholder `outtaMyWayHold=false` as proof that OuttaMyWay did not cause quiescence.

For the initial implementation, Situation Assessment retains a bounded **Recovery Approach Trail** only for an exact active Operation member / Job Episode while positively realised GIANTS-native progression remains coherent. Operation Lifecycle's cold-start-invariant membership is consumed as given; productive/turning state affects Recovery evidence but not Operation participation.

Implementation calibration:

- one candidate witness per completed live runtime observation cycle while positive realised native progress is present;
- current live runtime sampling cadence: **250 ms**;
- maximum retained Trail capacity: **40 witnesses**;
- minimum continuously observed post-assertion collapsed-progress span: **1.0 s**; and
- minimum useful Recovery Anchor span: **5.0 m backward along the retained realised Approach Trail**.

These literals are implementation/Reality calibration, not general Architecture.

> **Trail Sampling Cadence != Trail Retention Horizon.**

> **Collapse Observation Interval != Stall Timeout.**

The Trail MUST retain only small physical/provenance witnesses required for this question. Whole Observation Snapshots, Operational Pictures, copied physical-geometry sets, Field World geometry and productive-route history MUST NOT be retained as Recovery Approach state.

A raw `isBlocked=true` assertion MAY latch a Blocked Assertion Witness when a coherent Recovery Approach exists, but MUST NOT itself establish Stall. Stall requires fresh post-assertion evidence showing continuously collapsed position-derived physical progression for the calibrated observation span while the same Episode/Approach/configuration remains coherent and no OuttaMyWay progress-actuation owner explains the quiescence.

Positive realised native progression disproves the pending collapse and positively clears an established Stall. Raw `isBlocked=false` alone MUST NOT clear an established Stall.

Positive Job Episode succession/termination, native forward/reverse direction transition, material configuration-profile change or OuttaMyWay progress-actuation ownership invalidates the prior Recovery Approach for this question. Missing evidence MUST fail closed rather than manufacture a discontinuity or positive Stall.

At Stall establishment, Situation Assessment selects the most recent retained witness that remains fit and provides at least the calibrated useful span along the retained realised Approach. If none exists, the Stall MAY remain positively established while Recovery Anchor remains unavailable.

> **Blocked Progress Stall != Recovery Anchor Availability.**

> **Insufficient Anchor Span != Permission to Retain Productive History.**

The resulting Blocked Progress knowledge is Situation meaning only. It MUST NOT create a Recovery Candidate, acquire Current Responsibility, grant Bounded Authority or issue Control.

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
- Structural Field Shape, Headland Regime and Corner Feature interpretation;
- Corner Atlas, Headland Association, Corner Arrival Evidence, Corner Approach Demand, current Corner Occupancy, Corner Incumbency, Corner Admission, Corner Engagement and Positive Corner Departure;
- Passage foreseeability;
- follower/Forward Intersection relationships; and
- current option-space / Resolution-Margin meaning.

This Specification does not duplicate those spatial policies. The implementation MUST route those conclusions through Situation Assessment semantics rather than Candidate Support or Control.

### Resolution-Margin Demand Evidence

Spatial Negotiation Architecture establishes that time consumes options and that Situation Assessment owns current option-space / Resolution-Margin meaning. **Resolution-Margin Demand Evidence** is the implementation-facing Situation product for the bounded question:

> Does a subject's currently supported native progression positively consume represented Current Space or another spatial-demand claim within the subject's current bounded progression horizon?

Resolution-Margin Demand Evidence is Situation meaning only. It is not Candidate Support, Current Responsibility, a speed target, negative-clearance proof or Control permission.

A positive Resolution-Margin Demand Evidence record MUST identify, where supported:

- the progressing subject and its current lifecycle/Operation scope;
- the current progression basis, including the bounded local intent or continuation horizon that makes projection legitimate;
- the represented claim being consumed, including subject/owner identity and claim class such as Current Space, Committed Demand or Potential Demand;
- a positive known witness-entry distance along the subject's supported progression;
- the representation provenance, fitness and claim permissions supporting that witness;
- the current evidence/intent identity or equivalent validity basis needed to know when the conclusion must be reassessed; and
- explicit uncertainty/claim limits sufficient to prevent downstream consumers from treating the witness as safe clearance.

The witness-entry distance is deliberately one-sided evidence. It means a positively represented claim is known to occur **no farther than** that point along the supported progression horizon. It MUST NOT be interpreted to mean that every earlier point is clear, that the distance is a stopping/braking allowance, or that a particular speed is safe.

> **Positive Witness Distance != Safe Clearance.**

A reference-pose or assembly-origin separation MAY remain valid evidence for another spatial question, but it MUST NOT substitute for usable Resolution Margin when a nearer positive represented witness answers the current option-space question.

> **Reference-Point Separation != Usable Resolution Space.**

A Current Excursion, opposed-corridor relationship, follower relationship, Forward Intersection or other recognised spatial relationship MAY contribute evidence about why temporal coordination is valuable. None is the definition of Resolution-Margin Demand Evidence. In particular, a Current Excursion moving from "ahead" to "not ahead" does not positively dissolve a still-supported represented progression witness.

> **Current Excursion != Resolution-Margin Demand.**

Resolution-Margin Demand Evidence MUST remain current-evidence based. It MUST NOT require reconstructed Productive History, persistent pair history or a remembered encounter baseline merely to establish current demand. A short-lived evidence identity may support current-cycle continuity where already authorised, but history cannot manufacture a positive witness after its current representation or intent basis is gone.

A target's current represented occupancy may participate while that target is `TURNING`; doing so does not authorise extrapolation of the target's turn path. The progressing subject's projection likewise ends at the current supported local horizon. Situation Assessment MUST NOT convert current-space demand evidence into a predicted future route for either participant.

When current evidence positively supports Resolution-Margin Demand, Candidate Support MAY use that Situation meaning when constructing a prospective Regulation Candidate. Situation Assessment MUST NOT thereby choose the Candidate, regulated physical subject or permitted magnitude. Decision and Responsibility Transition remain downstream, and Bounded Authority independently owns what temporal effect is physically permitted now.

When a previously positive witness becomes unavailable or unfit and no authorised negative conclusion exists, the Resolution-Margin question becomes `UNRESOLVED`; it MUST NOT become positive clearance or positive purpose dissolution merely because one proxy relationship or diagnostic signal disappeared.

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

For an established Forward-Intersection Regulation, a current geometric negative is not by itself positive incumbent-purpose dissolution evidence. Situation Assessment MUST assess whether the evidence basis that produced the negative is fit for the dissolution question. Positive contradiction may make that evidence unfit; absence of such contradiction does not by itself establish that the temporal purpose has discharged.

For **Category-1 Corner space**, Situation Assessment MUST distinguish persistent Field World knowledge from prospective arrival evidence, current/local demand, arrival/incumbency, engagement and responsibility state:

1. **Corner Feature interpretation is Field-scoped.** The exact Field World polygon remains authoritative for containment, identity and boundary evidence, while Situation Assessment MAY derive Structural Field Shape / Headland Regime meaning so literal sampled vertices are not automatically treated as semantic Corners. A Corner Feature is a bounded structural transition between persistent Headland Regimes. Pairwise Forward Intersection MAY contribute positive evidence but MUST NOT be the sole admission path or the definition of Corner existence.
2. Once positively established, the **Corner Atlas** entry remains valid for the same immutable Field World independently of the pair or assembly that exposed it. The entry MUST retain sufficient Field World provenance and structural Corner topology/region to identify the same feature. It MUST NOT retain a historical yielder, pair right-of-way, Regulation identity or one discovering assembly's operational envelope as Corner identity.
3. **Headland Association** MAY provide positive evidence that an assembly is productively associated with a boundary/headland regime relevant to the Corner and MAY increase awareness or inform later temporal allocation. A supported Field-World-bounded A8 whose exact terminating boundary edge has one or more accepted Structural Corner endpoints MAY establish feature-relative Headland Association only when the terminal contact selects one structural Corner endpoint unambiguously from current topology. Where two structural Corner endpoints are materially equidistant, the association remains unresolved. Worker width, a universal Corner radius and continuation beyond the bounded A8 MUST NOT be used to manufacture the association. Negative or unresolved Headland Association MUST NOT negate Corner existence or independently positive Corner Approach Demand.
4. **Corner Arrival Evidence is prospective temporal evidence, not current local demand.** Situation Assessment MAY publish supported native/unrestricted time-to-Corner for a known Corner Feature before the assembly has current/local Corner Approach Demand. Positive feature-relative Headland Association MAY support Corner Arrival from the current bounded A8 to its terminating edge; the arrival distance/time remains bounded by that currently supported continuation and MUST NOT be extended along a guessed future Headland route. Representative-point intersection is therefore not required where current structural topology already associates the terminating edge with the Corner Feature. Arrival evidence MUST identify its current evidence basis and MUST NOT by itself manufacture Corner Approach Demand, Corner Occupancy or Corner Incumbency.
5. **Corner Approach Demand** is positive only when the assembly's currently supported bounded spatial demand is progressing into a known Corner Feature. Proximity, indefinite continuation extension and reconstructed future routes MUST NOT manufacture the conclusion. Feature-relative Arrival alone remains prospective until the existing assembly-specific local-demand evidence becomes positive.
6. **Current Corner Occupancy is positive present demand.** When current positive Physical-Assembly evidence establishes that an assembly already consumes a known Corner Feature, Situation Assessment MUST publish that occupancy independently of route prediction. Missing occupancy evidence has no negative-clearance authority.
7. **Corner Incumbency is established arrival retained until positive departure.** When positive current evidence establishes that an engaged assembly has arrived in the Corner decision domain, Situation Assessment MUST publish that assembly as incumbent for the current traversal. Once established, incumbency MUST persist while the same Corner Engagement remains current until Positive Corner Departure or another explicit supported terminal outcome. `TURNING`, reverse movement, transient heading, Forward-Intersection churn, representative-point separation, loss of current Approach Demand, loss of current time-to-Corner or absence of a fresh occupancy witness MUST NOT independently revoke incumbency.
8. **Corner Admission is unilateral.** Positive Corner Existence plus either positive Corner Approach Demand or positive current Corner Occupancy is sufficient for that assembly. No second participant, pairwise Forward Intersection, shared sampled vertex, `TURNING` state or reverse manoeuvre is required. Admission establishes retained Corner Engagement for the assembly-plus-Corner Situation.
9. **Corner Engagement owns the in-Corner decision domain until Positive Corner Departure.** During current engagement, Headland Association evidence becomes decision-dormant for that assembly. Positive/negative headland churn, `TURNING`, reverse movement, transient heading, Forward-Intersection topology, Current Excursion classification, Passage admission or Responsibility Transition MUST NOT by themselves revoke, recreate, switch or discharge the Corner state. Engagement establishment time is lifecycle provenance and MUST NOT be treated as Corner Incumbency or right-of-way priority.
10. **Corner Demand is assembly-specific.** Situation Assessment MUST distinguish the field-scoped Corner Feature from the operational demand an admitted assembly places around it. Productive width MAY support pre-Corner Headland Association; physical width, overall length, articulation and supported current representation MAY materially determine manoeuvring demand. The implementation MUST NOT reduce this to one universal width, length multiplier, radius or predicted articulated turn path.
11. **Shared Corner Situation does not require shared discovery.** Another assembly may become relevant through its own positive Corner Arrival Evidence, Corner Approach Demand or current Corner Occupancy according to the current evidence contract. Situation Assessment MUST publish the current participants plus Corner Incumbency, current positive occupancy where available, and current supported **time-to-Corner under native/unrestricted progression opportunity** where available. It MUST NOT choose the yielder, use Engagement age as priority, or let an existing Regulation's reduced realised speed feed back into the arrival ordering.
12. **Positive Corner Departure requires positive A8 spatial crossing.** A8 is the positive evidence of productive work; without the required A8 crossing an incumbent assembly remains in the Corner for decision purposes. For continuous productive traversal, current authoritative A8 must positively cross the field-scoped outgoing Corner boundary. For a manoeuvring traversal that supplies valid forward/reverse transitions, Situation Assessment MAY retain the last such transition position as the stronger assembly-specific departure-boundary anchor; fresh productive A8 must be reacquired and positively cross that boundary before engagement/incumbency retires.
13. A traversal with no reversal MUST NOT depend on a direction-transition anchor. Absence of renewed pair intersection, elapsed time, travelled distance, assembly-length/working-width multipliers, headland reclassification, a narrower current assembly, temporary movement beyond a guessed envelope or responsibility replacement MUST NOT manufacture Positive Corner Departure.

Corner Atlas knowledge is not persistent generic pair history and does not preserve a past yielder or right-of-way. Corner Engagement does not create a new Regulation type or Control permission. Situation Assessment owns current Corner meaning; Candidate Support, Decision, Responsibility Transition and Bounded Authority retain their existing jurisdictions.

This contract is Category-1-specific. It makes no equivalent claim for Category 2 or open-field Forward Intersection and does not predict GIANTS turn paths.

## Operational Picture semantic contract

The Operational Picture MUST preserve enough meaning for Candidate Support, Constraint Evaluation, Decision, responsibility maintenance and diagnostics without requiring those consumers to reconstruct Situation semantics from raw source modules.

Contractually significant classes of content include, as applicable:

- current Situation(s) and Local Operation identity;
- current active participants and exact lifecycle identities;
- physically/relevantly observed assemblies distinct from participants;
- current/current-future-space semantic knowledge;
- demand classes such as Committed Demand, Potential Demand and Temporary Slack;
- Resolution-Margin Demand Evidence and its current claim limits;
- current pair scope and current relationship classifications;
- motion/productive-continuation knowledge;
- follower / trajectory / opposed-corridor / spatial-constraint knowledge;
- Corner Atlas/Corner Feature knowledge, Headland Association, Corner Arrival Evidence, Corner Approach Demand/Admission, current Corner Occupancy, Corner Incumbency, current Corner Engagement, assembly-specific Corner Demand and A8-crossing Positive Corner Departure meaning where applicable;
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

### Positive Resolution-Margin evidence remains one-sided

A positive represented witness may establish current spatial demand while still lacking negative-clearance authority. Situation Assessment MUST preserve that asymmetry rather than promoting a witness-entry distance into safe traversable distance or a physical timing target.

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
- **Resolution-Margin witness positive** — publish the current positive demand evidence with its subject, represented claim, bounded horizon, provenance and one-sided claim limits; do not derive a speed or safe-clearance conclusion.
- **Resolution-Margin witness unavailable/unfit without negative authority** — publish `UNRESOLVED`; do not convert witness loss, Current-Excursion role change or reference-point separation into positive clearance/dissolution.
- **Known Category-1 Corner Feature, no current Corner evidence** — retain the Corner Atlas entry as Field World knowledge; do not manufacture current constrained-space occupation or Regulation merely from the known Corner's existence.
- **Supported prospective Corner Arrival Evidence without local Approach Demand** — publish the native/unrestricted arrival evidence with its limits; do not manufacture local demand, occupancy or incumbency from that fact alone.
- **Positive Corner Approach Demand into a known Corner Feature** — Corner Admission may be positive unilaterally; no pairwise quorum or Headland Association gate is required.
- **Positive current Corner Occupancy without prior Approach Admission** — publish current occupancy, admit retained Corner Engagement and establish Corner Incumbency; Reality has already entered the constrained feature.
- **Engaged assembly positively arrives in the Corner decision domain** — publish Corner Incumbency for that traversal. Incumbency persists until Positive Corner Departure or another explicit supported terminal outcome.
- **Shared Corner competing demand** — publish incumbent status, current occupancy where available and supported native/unrestricted time-to-Corner for each participant where available; do not assign priority in Situation Assessment and do not use Engagement establishment age as a temporal ordering signal.
- **Corner Engagement current** — preserve the assembly-plus-Corner fact across Forward-Intersection, Current-Excursion, Passage and Responsibility changes. Headland positives/negatives observed inside the engagement are decision-dormant and MUST NOT manufacture admission, release or right-of-way change.
- **Incumbent engaged assembly has no qualifying A8 spatial crossing** — remain incumbent and in the Corner for decision purposes; `TURNING`, reverse/run-out, elapsed time, missing approach timing, representative-point separation and temporary geometry do not establish departure.
- **Continuous authoritative A8 crosses the field-scoped outgoing Corner boundary** — publish Positive Corner Departure for continuous traversal and retire incumbency for that traversal.
- **Manoeuvring traversal supplies a last valid direction-transition anchor and fresh A8 later crosses that anchored departure boundary** — publish Positive Corner Departure for that assembly and retire incumbency for that traversal.
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

[`ASSESSMENT_REPRESENTATION.md`](ASSESSMENT_REPRESENTATION.md) owns claim-bearing representation products. Situation Assessment decides fitness for the current question without enlarging representation authority. Resolution-Margin Demand Evidence may use positive-conflict-supporting representation only within those existing claim permissions; it does not create negative-clearance authority.

### Candidate Support

[`CANDIDATE_SUPPORT.md`](CANDIDATE_SUPPORT.md) consumes the Operational Picture and asks what prospective purposes are supportable. It MAY consume Resolution-Margin Demand Evidence when projecting Regulation support, but MUST NOT force Situation Assessment to preselect a Candidate or physical target.

### Regulation

[`REGULATION.md`](REGULATION.md) owns the semantic temporal-coordination responsibility after Responsibility Transition establishes it. Resolution-Margin Demand Evidence may justify prospective or continuing temporal coordination, but it does not itself establish Regulation identity, choose a physical lease or reserve a successor.

### Bounded Authority

[`BOUNDED_AUTHORITY.md`](BOUNDED_AUTHORITY.md) owns which physical subject may be temporally constrained now, the permitted magnitude/envelope and whether actuation may be current or quiescent. A Resolution-Margin witness is admissible Situation evidence, not an authorised Control target.

### Responsibility Transition

[`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) owns authoritative establishment/termination/replacement of Current Responsibility. Situation Assessment supplies current semantic justification only.

### Resolution Lifecycle / specialised responsibilities

Resolution contracts own persistence/obligation terminality. Situation Assessment interprets the current evidence those contracts consume; it does not invent or settle obligations outside those contracts.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/assessment/SituationAssessment.lua`](../scripts/assessment/SituationAssessment.lua) | `REALISES` |
| [`scripts/assessment/ResolutionMarginSituationAssessment.lua`](../scripts/assessment/ResolutionMarginSituationAssessment.lua) | `REALISES` |
| [`scripts/assessment/ResolutionMarginDemandAssessment.lua`](../scripts/assessment/ResolutionMarginDemandAssessment.lua) | `REALISES` |
| [`scripts/assessment/CurrentPairAssessmentScope.lua`](../scripts/assessment/CurrentPairAssessmentScope.lua) | `REALISES` |
| [`scripts/assessment/TrajectoryConflictAssessment.lua`](../scripts/assessment/TrajectoryConflictAssessment.lua) | `REALISES` |
| [`scripts/assessment/FollowerBoundaryDemandAssessment.lua`](../scripts/assessment/FollowerBoundaryDemandAssessment.lua) | `REALISES` |
| [`scripts/assessment/StructuralFieldShapeAssessment.lua`](../scripts/assessment/StructuralFieldShapeAssessment.lua) | `REALISES` |
| [`scripts/assessment/SpatialConstraintAssessment.lua`](../scripts/assessment/SpatialConstraintAssessment.lua) | `REALISES` |
| [`scripts/assessment/CausalObstructionAssessment.lua`](../scripts/assessment/CausalObstructionAssessment.lua) | `REALISES` |
| [`scripts/assessment/BlockedProgressAssessment.lua`](../scripts/assessment/BlockedProgressAssessment.lua) | `REALISES` |
| [`scripts/assessment/RepresentationFitness.lua`](../scripts/assessment/RepresentationFitness.lua) | `REALISES` |
| [`scripts/assessment/PassageCapabilityAssessment.lua`](../scripts/assessment/PassageCapabilityAssessment.lua) | `REALISES` |
| [`scripts/assessment/CurrentResponsibilityAssessment.lua`](../scripts/assessment/CurrentResponsibilityAssessment.lua) | `REALISES` |
| [`scripts/contracts/OperationalPicture.lua`](../scripts/contracts/OperationalPicture.lua) | `REALISES` |
| [`scripts/assessment/ProgressionGeometry.lua`](../scripts/assessment/ProgressionGeometry.lua) | `SUPPORTS` |
| [`scripts/assessment/CurrentResponsibilityContextSituationAssessment.lua`](../scripts/assessment/CurrentResponsibilityContextSituationAssessment.lua) | `SUPPORTS` |

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/assessment/SituationAssessment.lua`](../scripts/assessment/SituationAssessment.lua) — baseline Operational Picture composition and semantic handoff;
- [`scripts/assessment/ResolutionMarginDemandAssessment.lua`](../scripts/assessment/ResolutionMarginDemandAssessment.lua) — current one-sided positive progression-to-Current-Space/Demand witness interpretation using neutral progression geometry;
- [`scripts/assessment/ResolutionMarginSituationAssessment.lua`](../scripts/assessment/ResolutionMarginSituationAssessment.lua) — Situation-layer composition that enriches the baseline picture with `resolutionMarginDemandKnowledge` while preserving the same picture identity/epoch;
- [`scripts/assessment/CurrentPairAssessmentScope.lua`](../scripts/assessment/CurrentPairAssessmentScope.lua) — current ephemeral exact-member pair scope;
- [`scripts/assessment/StructuralFieldShapeAssessment.lua`](../scripts/assessment/StructuralFieldShapeAssessment.lua) — conservative Field-scoped Structural Field Shape / positive Corner Feature interpretation from immutable canonical Field World geometry;
- [`scripts/assessment/TrajectoryConflictAssessment.lua`](../scripts/assessment/TrajectoryConflictAssessment.lua), [`FollowerBoundaryDemandAssessment.lua`](../scripts/assessment/FollowerBoundaryDemandAssessment.lua) and [`SpatialConstraintAssessment.lua`](../scripts/assessment/SpatialConstraintAssessment.lua) — current spatial relationship/constraint interpretation;
- [`scripts/assessment/CausalObstructionAssessment.lua`](../scripts/assessment/CausalObstructionAssessment.lua) — current positive obstruction-cause interpretation;
- [`scripts/assessment/BlockedProgressAssessment.lua`](../scripts/assessment/BlockedProgressAssessment.lua) — bounded Recovery Approach Trail retention, Blocked Progress Stall interpretation and Recovery Anchor selection from current Operation/lifecycle/motion/ownership evidence;
- [`scripts/assessment/RepresentationFitness.lua`](../scripts/assessment/RepresentationFitness.lua) and [`PassageCapabilityAssessment.lua`](../scripts/assessment/PassageCapabilityAssessment.lua) — current question-scoped representation-fitness interpretation;
- [`scripts/assessment/CurrentResponsibilityAssessment.lua`](../scripts/assessment/CurrentResponsibilityAssessment.lua) — current specialised semantic persistence/dissolution interpretation for established Regulation purposes; and
- [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) plus [`scripts/main.lua`](../scripts/main.lua) — current orchestration/composition placing the final Situation Assessment product after Observation and Operation lifecycle, before Candidate/Constraint/Decision.

Production Situation Assessment publishes Resolution-Margin Demand Evidence directly from current sealed evidence. The retained `ProgressionPreservationProbe` remains non-authoritative diagnostic instrumentation and is not imported into the semantic production path. Current Bounded Authority may consume only the existence and exact pair identity of a positive Resolution-Margin witness to prevent quiescence of an already-active Regulation effect; it does not consume witness distance as clearance or magnitude authority.

No single assessment helper owns the whole Situation Assessment Jurisdiction.

## Validation route

### Structural/source-contract validation

Current structural evidence includes:

- [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py), which protects the separation of Situation Assessment from Candidate/Decision/Control;
- [`tests/test_live_interaction_observation_structure.py`](../tests/test_live_interaction_observation_structure.py), which challenges Observation-to-Situation evidence ownership;
- [`tests/test_follower_boundary_assessment_value_ownership_structure.py`](../tests/test_follower_boundary_assessment_value_ownership_structure.py) and [`tests/test_trajectory_assessment_value_ownership_structure.py`](../tests/test_trajectory_assessment_value_ownership_structure.py), which protect Situation-owned relationship interpretation;
- [`tests/test_resolution_margin_demand_structure.py`](../tests/test_resolution_margin_demand_structure.py), which protects one-sided Resolution-Margin evidence ownership and rejects downstream runtime consumption in the `.79` semantic increment; and
- [`tests/test_obstruction_relocation_structure.py`](../tests/test_obstruction_relocation_structure.py), which protects the distinction between Causal Obstruction recognition and downstream relocation mechanics; and
- [`tests/test_blocked_progress_assessment_structure.py`](../tests/test_blocked_progress_assessment_structure.py), which protects bounded Blocked Progress Situation ownership, production wiring, calibration locality, authoritative Operation-membership consumption and the continued absence of Recovery Candidate/Control authority.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises sealed Observation → Operation Lifecycle → Operational Picture flows, relationship interpretation, uncertainty, representation fitness and downstream use. [`tests/replacement_core/resolution_margin_demand.lua`](../tests/replacement_core/resolution_margin_demand.lua) directly challenges the Resolution-Margin semantic product and its Situation-layer composition. [`tests/replacement_core/BlockedProgressAssessment.lua`](../tests/replacement_core/BlockedProgressAssessment.lua) directly challenges bounded Approach-Trail retention, moving blocked assertions, the calibrated Collapse Observation Interval, Stall persistence/clearance, useful Anchor selection and Job/direction/configuration/OMW-ownership discontinuities.

Offline validation can challenge identity/provenance, deterministic Situation semantics and fail-closed behavior. It cannot prove that the GIANTS/runtime evidence being interpreted is physically complete or timely.

Focused Resolution-Margin validation MUST challenge at least these three boundaries:

1. **Positive target:** supported native progression has a positive represented Current-Space/Demand witness within its bounded horizon before, during or after a Current-Excursion classification window; the Situation evidence follows the represented demand rather than requiring that proxy relationship.
2. **Negative neighbour:** a nearby or `TURNING` worker with no positive represented witness on the subject's supported progression does not create positive Resolution-Margin Demand merely from proximity, turn state or shared Local Operation membership.
3. **Established regression:** existing Current-Excursion/opposed-corridor Action-Space semantics retain their accepted relationship, role-allocation and Regulation lifecycle meaning when equivalent evidence is supplied. Downstream consumption is limited to the Bounded-Authority quiescence boundary: a positive exact-pair witness may keep an already-active Regulation effect from becoming quiescent, while witness distance remains prohibited as speed, stopping-distance or safe-clearance authority.

### Targeted in-game Reality validation

In-game validation remains required for live GIANTS intent, productive continuation, blocking causality, physical relevance, timing, player claim and any other Situation conclusion whose source evidence depends on engine/runtime Reality.

For Resolution-Margin Demand, a targeted Reality challenge must distinguish the Situation-evidence claim from downstream actuation: demonstrate that the relevant positive represented demand exists in the live encounter, that an unrelated nearby turn does not manufacture demand, and that any later Regulation/Bounded-Authority implementation preserves GIANTS routing while changing only supported temporal coordination.

For Category-1 Corner semantics, targeted Reality validation MUST separately challenge: prospective native/unrestricted Corner Arrival Evidence without premature local Approach Demand; unilateral Corner Approach Demand/Admission without pairwise discovery; positive arrival establishing Corner Incumbency; incumbency surviving `TURNING`, reverse movement and temporary loss of approach timing until Positive Corner Departure; a remote prospective arrival not displacing an incumbent; a previously validated pairwise Corner regression; articulated manoeuvring with one or more forward/reverse transitions and A8 crossing of the final transition-anchored departure boundary; continuous productive traversal of a rounded Corner with no reversal; and in-Corner headland positive/negative churn remaining decision-dormant until Positive Corner Departure.

### Outside this Specification's validation claim

A correct Operational Picture does not prove that Candidate Support is complete, mandatory Constraints are correct, Decision chooses appropriately, Responsibility Transition succeeds, or Control physically achieves the selected purpose.