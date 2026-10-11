# Native Blockage, Situation Assessment and Hold & Relocate

## Purpose and authority boundary

OuttaMyWay responds to current GIANTS-native field-worker blockage in order to preserve autonomous continuity through the least disruptive justified intervention. GIANTS retains native blocked-state detection, productive route planning and FIELDWORK execution. OuttaMyWay may infer a relevant local situation and commit bounded physical assistance, but neither proximity nor a successful actuator request creates physical clearance or continuation evidence.

This document defines current responsibilities, their relationships and their limits. Implementation contracts belong to the corresponding [Specifications](../spec/README.md); observed GIANTS semantics belong to [Engine Knowledge](../docs/engine/README.md); investigation and validation provenance belongs to [Blocked Recovery Research](../docs/research/BLOCKED_RECOVERY_INVESTIGATIONS.md) and its linked evidence.

## Responsibility and evidence model

1. **Native Blockage Observation** captures the GIANTS field-course blocked assertion for an identifiable current worker and Job Episode. A native blocked assertion establishes the affected worker, not the obstruction's causal identity, inevitable native failure or permission to move another assembly.
2. **Candidate Support and Spatial Pair Inference** use bounded, current physical references to nominate possible nearby active workers. Approximate root proximity does not establish collision, physical clearance or which worker should yield. With no eligible active-worker pair, a separate solo or non-active physical blocker situation remains possible.
3. **Situation Assessment** distinguishes supported current worker-pair, solo and non-active-blocker responses, insufficient evidence and cases outside supported responsibility. Observation and Assessment do not take GIANTS physical Control.
4. **Independent commitment** positively revalidates the current GIANTS FIELDWORK job, physical references, spatial jurisdiction and any situation-specific admission conditions before actuation. One occurrence may authorise one bounded movement; a subsequent occurrence requires fresh GIANTS evidence.
5. **Hold & Relocate** selects and coordinates one physical subject, protects the attempted egress through separately bounded Regulation where applicable, executes an authorised movement through subordinate Control, then returns productive responsibility to GIANTS where applicable. The actual outcome must be observed rather than inferred from a request or target.

Uncertainty is not an affirmative decision to intervene. Missing, stale, contradictory or superseded evidence means no new physical commitment. Temporary physical effects must be released or safely neutralised within their independently governed lifecycles.

## Specification Jurisdiction — Native Blockage Observation

**Jurisdiction ID:** `NATIVE_BLOCKAGE_OBSERVATION`  
**Primary Specification:** [Native Blockage Observation](../spec/NATIVE_BLOCKAGE_OBSERVATION.md)

**Responsibility:** observe native GIANTS field-course `isBlocked` without replacing GIANTS collision callbacks, generating synthetic collisions, intercepting historical event constructors or mutating worker behaviour. Preserve the observation's native worker, job/strategy and time provenance.

**Evidence rules:** A positive native blocked sample is evidence at its observed time; missed intermediate transitions are not known. Known false intervals contribute no blocked duration. A continuous positively supported native blocked pulse of at least one second may nominate candidates; it is not an obstruction proof or physical authority. Separate pulses may conceptually belong to one unresolved encounter, but multi-pulse continuity is **not** established by the present Observation contract and must not be invented by summing an entire Job Episode.

A **Blockage Encounter Snapshot** may retain one bounded first-edge root population and pose observation for later static-subject consideration. A snapshot is not an impact-time witness, a causal collision detector or a current actuation authority. Reciprocal native blocked reports from the same two active workers may be represented as one unordered pair occurrence; this unifies observations, not physical fates.

## Specification Jurisdiction — Spatial Pair Inference

**Jurisdiction ID:** `SPATIAL_PAIR_INFERENCE`  
**Primary Specification:** [Spatial Pair Inference](../spec/SPATIAL_PAIR_INFERENCE.md)

**Responsibility:** given externally qualified native blocked-time evidence and eligible current assembly-root positions, nominate the nearest other eligible active worker within the accepted **30 m horizontal root-to-root radius**. The radius is a pragmatic candidate-locality rule, not a physical extent, clearance threshold or causal attribution. Simultaneous blocked assertions from both workers are not required.

This evaluator neither observes GIANTS itself nor determines encounter persistence, worker right-of-way, egress feasibility or Control. A returned candidate must be independently revalidated before a responsibility transition. A worker outside the radius is not nominated merely because it is the nearest available.

## Specification Jurisdiction — Hold & Relocate

**Jurisdiction ID:** `HOLD_RELOCATE`  
**Primary Specification:** [Hold & Relocate](../spec/HOLD_RELOCATE.md)

**Responsibility:** coordinate independently admitted, bounded physical assistance for one supported native-blockage situation, while GIANTS retains the productive route. The intervention has three distinct forms.

### Solo blocked worker

A positively blocked active GIANTS FIELDWORK worker without an eligible active-worker pair may receive a separate solo relocation. Its native blockage can occur inside or outside a registered field polygon; pairwise common-polygon membership is not a solo admission rule. When inward direction is relevant, use the worker's **own active GIANTS course field**, not the nearest unrelated field. No invented counterpart, peer Regulation or paired relocated-mover Hold is introduced. A solo movement returns to GIANTS through native FIELDWORK handback after the supported relocation region is reached.

### Active-worker pair — Asymmetric Cooperative Egress

An independently admitted pair consists of two current eligible GIANTS field workers within the same current GIANTS field jurisdiction. Egress selection considers the feasible space available to **both possible movers** before assigning a role; centroid proximity is a preference, not proof that a manoeuvre is available. Region and corridor assessment must account for present field limits and nearby represented occupancy without claiming knowledge of GIANTS' full future course.

One pair occurrence selects **one mover and one remaining worker**. Only the mover requests TRANSIT and physically relocates; the remaining worker retains WORKING and its existing GIANTS job under a temporary **1 km/h Regulation** lease. A TRANSIT command is a request, not evidence that folding has completed; movement and configuration progress may overlap.

**Independent actor release:** the remaining worker's Regulation ends under its own bound or lifecycle supersession; the mover separately completes its Return Region, relocated Hold and its own GIANTS FIELDWORK handback. No shared pair-success predicate, jointly gated release, automatic second stage, retained pair reservation or post-handback suppression of genuinely fresh blockage is authorised. At terminal handback, any still-outstanding supporting Regulation must be cleaned up rather than orphaned.

### Non-active physical blocker — Reactive Static Blocker Recovery

A current native blocked FIELDWORK worker may be affected by a nearby inactive, approximately stationary physical assembly. A bounded first-edge snapshot supports inference of such a **possible** static blocker after active-worker pair precedence. Root proximity and native inactivity do not prove exact collision identity.

A non-active relocation subject must be within the **blocked worker's own current GIANTS field jurisdiction**; the blocked active worker itself need not be inside the polygon for separate solo recovery. One inferred static subject may be moved under dedicated non-job physical Control while the blocked beneficiary retains its GIANTS job under temporary Regulation. Physical movement and its signed cross-track outcome require actual motion evidence. Native command acceptance, vehicle tab-selection state or a request for TRANSIT is not proof of motion, collision clearance or consent to unrelated actuation. A relocated inactive assembly may remain in TRANSIT after release; that is not a reason to reconfigure the unaffected beneficiary.

## Egress concepts and evidence limits

- **Conflict Zone:** the local physical contention motivating bounded assistance, not automatically the full field or every future GIANTS route.
- **Egress Region:** candidate space whose current geometric eligibility is assessed for a selected subject.
- **Egress Corridor:** the nominal, bounded path or region by which that subject might depart the contention. A clear endpoint does not certify its intervening swept physical space.
- **Egress Optionality:** the available supported alternatives for the possible movers; it informs selection before Control.
- **Return Region:** an actuation-completion criterion evaluated against realised progress. Reaching it is not by itself a collision-free assembly settlement or successful productive continuation.
- **Kinematic Egress Feasibility:** the distinct question of whether the actual assembly, configuration and native steering mechanism can safely realise a geometrically available corridor. In articulated reverse, a world-space ray can produce a materially different GIANTS tool-relative steering demand and realised trajectory. Nominal spatial eligibility must not be described as its proof.
- **Clearance Sufficiency:** a necessary distinction between (a) **spatial clearance** of the actual assembly footprints from the contested space and (b) **temporal clearance**, meaning usable separation persists as both workers continue moving. An intended WORKING-width-plus-margin travel is a *planning proxy*, not a measure of either. Realized root travel, geometrically represented member separation, relative closing trend, and native handback are distinct evidence; no single one certifies safe physical clearance. For investigation, a bounded passive witness may track these quantities at egress, Hold and handback milestones without acquiring Control. Nominal GIANTS base-size rectangles are not complete collision geometry and a straight-line closing trend is not a prediction of GIANTS' future path. The unresolved admission/completion policy belongs to later Reality-tested design; no new pair-wide Hold, stopping rule or larger reverse distance follows solely from naming this concept.
- **Movement Continuation Authority:** a separately bounded permission to maintain an admitted physical relocation. During paired movement, observed Command-to-Corridor Divergence, exhausted execution time, or departure from the authorised GIANTS course field withdraws the mover's OMW movement authority. Return Region attainment is eligible for success only while those bounds remain valid.
- **Command-to-Corridor Divergence:** a discrepancy between realised root trajectory and the admitted movement direction, identified from measured lateral departure and inadequate projected progress. It is not an inferred hitch angle, proof of physical contact, or a complete articulated swept-path safety model.

**Observed motion != requested motion.** Fold configuration, tool articulation, current root trajectory and GIANTS execution context may make an available nominal region physically difficult or temporarily unachievable. The validity of a later native blockage and the safety of any newly selected manoeuvre are separate questions.

## Boundaries, lifecycle and failure

- Admission requires current native job, physical identity and eligible situation evidence; passive Observation alone never acquires Control.
- A bounded intervention's actuator leases belong to the affected actor. Nonmover Regulation, mover relocation, relocated Hold and native handback have separate release and failure semantics.
- Worker/job or strategy turnover, map teardown, disabling, subject loss, missing native actuation capability and failed Control release must not leave an orphaned GIANTS override. A safe relinquishment is not necessarily a physical resolution.
- A paired movement interruption neutralises only OMW's scoped physical effects and returns the mover to its *existing* GIANTS FIELDWORK job, without the success-only relocated Hold or a synthetic stop/start. The other worker's job and Regulation lifecycle remain independently governed. A successful Control release is not a claim of clearance or productive recovery. A finite post-interruption native witness may distinguish a still-blocked GIANTS job, a consumed current blocked occurrence and outstanding OMW Control; this Observation has no authority to retry or declare native recovery.
- A new GIANTS blocked occurrence after native handback or movement interruption is assessed afresh. Prior Return Region entry or unsuccessful OMW assistance does not prove that the original obstruction is permanently absent.
- Unsupported geometry or insufficient current evidence may legitimately produce no automatic manoeuvre. The system must not manufacture clearance, causality or continuation, or mask such uncertainty through an unlimited replay sequence.
- Situation Assessment and physical Control remain distinct from diagnostic publication and player-facing explanation.

## Related responsibilities and validation

[Configuration](CONFIGURATION.md) supplies player consent and enablement, [Log Publication](LOG_PUBLICATION.md) publishes established runtime facts, and [GUI](GUI.md) owns player-visible explanation where an intervention, wait or request for assistance might otherwise appear stuck. Those surfaces do not independently justify a recovery.

GIANTS Reality is required to validate movement, physical clearance, job handback and articulated stability; offline checks establish only their asserted source contracts. The [Scenario Library](../docs/research/SCENARIO_LIBRARY.md), [Blocked Recovery Research](../docs/research/BLOCKED_RECOVERY_INVESTIGATIONS.md) and [current Kinematic Egress Feasibility investigation](https://github.com/bisdat/FS25_OuttaMyWay/issues/470) provide the evidence route without turning Architecture into a rolling test log.
