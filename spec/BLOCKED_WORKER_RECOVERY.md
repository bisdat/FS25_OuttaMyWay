# Blocked Worker Recovery Specification

## Identity and authority

**Specification Jurisdiction:** Blocked Worker Recovery  
**Jurisdiction ID:** `BLOCKED_WORKER_RECOVERY`  
**Parent Jurisdiction:** [`Resolution Lifecycle`](RESOLUTION_LIFECYCLE.md)  
**Primary Architecture Authority:** [`architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#specification-jurisdiction--blocked-worker-recovery)

This Specification owns the implementation-facing contract for the single-subject **Resolution Commitment** that performs one two-phase Recovery cycle for a still-active GIANTS worker after current Situation evidence has established a **Blocked Progress Stall**: bounded physical retreat into a Recovery Return Region supported by the Recovery Approach / Recovery Anchor, followed by deliberate GIANTS-native replanning through FIELDWORK Job replacement.

Blocked Worker Recovery does **not** own raw native blockage observation, generic Situation interpretation, obstacle identification, environmental map modelling, productive routing, arbitrary path planning, generic Bounded Authority or generic Control mechanics.

It inherits the persistence, obligation and terminal rules of [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md).

> **Native Blocked Assertion != Blocked Worker Recovery Responsibility.**

> **Recovery Need Does Not Require Blockage Cause.**

## Boundary contract

### Admission inputs

A new Blocked Worker Recovery Resolution MUST be grounded in one coherent current evidence/selection context containing, directly or through its upstream products:

- one exact active supported Physical Assembly and qualifying GIANTS Job Episode;
- a current positive **Blocked Progress Stall** established from a Blocked Progress Contradiction;
- the recent **Recovery Approach**, one fit **Recovery Anchor**, and one bounded **Recovery Return Region** derived from the Stall-to-Anchor domain for that same assembly/Job Episode;
- purpose-fit current representation and physical-reference evidence;
- recent Demonstrated Traversability sufficient to support the bounded local return domain being considered;
- no current OuttaMyWay-owned physical effect that explains the quiescence or already governs the subject incompatibly;
- no current supported active-traffic responsibility or other incompatible Current Responsibility that already owns the subject's condition;
- no higher-authority Player Claim or lifecycle condition that prevents autonomous recovery;
- any current positive spatial contradiction relevant to the proposed local release movement; and
- the current responsibility/commitment context needed to distinguish fresh establishment from maintenance of the same Recovery Resolution.

Raw `spec_aiFieldWorker.isBlocked` MUST NOT independently satisfy admission.

### Recovery Bubble and protected decision horizon

Blocked Worker Recovery is a single-subject Resolution for movement ownership, but once it becomes current it creates one temporary **Recovery Bubble** over the Local Operation's prospective decision horizon.

The Bubble MUST protect the recovering assembly without predicting another worker's future route. The recovering assembly remains the only BWR movement subject.

Where the current Operational Picture contains exactly one positive Causal Obstruction relation whose beneficiary is the recovering assembly, and that blocker is also a current active member of the same Local Operation, Bubble formation MUST apply a purpose-bound **0 km/h blocker hold** to that blocker.

Any remaining active Operation participant that is neither the recovering assembly nor the positively identified held blocker MUST receive the purpose-bound **1 km/h Bubble Bullet Time** Supporting Speed Ceiling.

If no active blocker identity is positively supported, BWR MUST NOT invent one. Non-active/static blockers require no active-worker hold, and all other active Operation participants receive Bubble Bullet Time.

The blocker hold and Bullet-Time effects are supporting temporal effects under the current BWR Resolution. They MUST NOT create separate Regulation responsibilities, Candidates or Decisions; MUST NOT acquire another participant's movement objective, route, steering or target; and MAY compose with an already-current compatible speed ceiling by least-permissive magnitude.

While the Recovery Bubble is current, Observation and Situation Assessment continue to publish fresh Reality, but prospective creation of new independent traffic or Resolution responsibilities for the same Local Operation is deferred. An already-current compatible responsibility is not implicitly terminated merely because BWR starts.

When BWR reaches an authoritative terminal state, the Recovery Bubble MUST dissolve sharply and all Recovery-Bubble Supporting Speed Ceilings MUST be released. Fresh Candidate / Constraint / Decision processing then reassesses the Local Operation from current Reality.

> **Recovery Bubble Protection != Traffic Prediction.**

> **Recovery First; Reassess After Release.**

### Blocked Progress Contradiction

The upstream Blocked Progress Stall basis MUST preserve enough provenance to establish all of the following:

- the same qualifying Job Episode was active before and during the suspected stall;
- recent native progression was positively realised physically, not merely commanded;
- GIANTS positively asserted native blockage;
- fresh post-assertion observations establish collapse or cessation of realised progression;
- current OuttaMyWay actuation does not explain that lack of progression; and
- no lifecycle discontinuity invalidates the comparison.

Elapsed time MAY be required to obtain a usable motion observation interval. Timeout expiry MUST NOT be interpreted as proof of blockage, obstacle class or Recovery eligibility.

> **Observation Interval != Stall Timeout.**

Once the Stall basis is positively established, raw `isBlocked=false` alone MUST NOT be treated as proof that the Stall was semantically false. Positive native progression, lifecycle supersession or an authoritative responsibility transition supplies the relevant contrary evidence.

### Recovery Approach Trail, Recovery Anchor and Recovery Return Region

The **Recovery Approach** is the uninterrupted recent GIANTS-native progression episode leading into the Blocked Progress Stall.

Assessment MUST retain a bounded **Recovery Approach Trail** for the exact Physical Assembly + active Job Episode while that uninterrupted Approach remains current.

Each retained witness MUST be small and purpose-specific. It MAY preserve only the evidence needed for this recovery question, such as:

- observation identity / timestamp;
- realised pose;
- realised travel direction and forward/reverse relation;
- exact Physical Assembly / Job Episode identity or stable references to them; and
- current configuration-profile identity / other bounded continuity provenance already supplied by accepted evidence.

The Trail MUST NOT retain whole ObservationSnapshots, OperationalPictures, copied DISC sets, copied Field World geometry, productive route/history, or other historical world state merely for future convenience.

The initial production sampling calibration is one candidate witness per completed live runtime observation cycle while positively realised GIANTS-native progression is present. The current live runtime cadence is **250 ms**.

> **Trail Sampling Cadence != Trail Retention Horizon.**

The 250 ms cadence is implementation calibration, not architectural policy. Trail age/count/distance capacity MUST remain finite and purpose-bounded, but its exact retention horizon is a separate implementation/validation calibration and MUST NOT be inferred from the sampling cadence.

A Job replacement/restart, Player Claim, incompatible OuttaMyWay actuation, native direction-transition discontinuity or material assembly/configuration discontinuity MUST invalidate the prior Trail as evidence for any later recovery question when it breaks Recovery Approach continuity. The intentionally caused Phase-2 Job replacement does not retroactively invalidate the already-admitted Recovery Resolution.

The **Recovery Anchor** MUST identify the first/oldest retained compatible positively realised Trail state in that uninterrupted Approach once the retained Trail demonstrates sufficient cumulative useful span for a bounded recovery attempt. Anchor fitness MUST preserve:

- Physical Assembly identity;
- Job Episode identity;
- movement-direction continuity relevant to the failed native excursion;
- ownership continuity;
- material configuration/articulation relevance;
- representation relevance; and
- absence of a positive known blockage-associated spatial contradiction already implicating that candidate Anchor state.

A Job replacement/restart, Player Claim, incompatible OuttaMyWay actuation, native direction-transition discontinuity or material assembly/configuration discontinuity MUST invalidate the prior Anchor as admission evidence for any later Recovery cycle when it breaks that continuity. The current Recovery may retain the selected Anchor as provenance after its Phase-1 movement has completed.

The minimum useful Trail-span requirement qualifies whether the retained Recovery Approach Trail is sufficient to support one bounded recovery attempt; it MUST NOT determine how far the physical Recovery must travel. Once the retained compatible Trail qualifies, Assessment MUST select its first/oldest retained compatible witness as the Recovery Anchor. Assessment MUST NOT widen retention or reconstruct older history merely because the bounded Trail is insufficient.

> **Insufficient Anchor Span != Permission to Retain Productive History.**

> **Anchor Span != Recovery Travel Requirement.**

Anchor age alone MUST NOT establish or destroy fitness.

> **Last Unblocked Pose != Recovery Anchor.**

> **Recovery Anchor != Known Safe Pose.**

The Anchor bounds return provenance and the maximum positively demonstrated retreat domain. It MAY be used as a subordinate steering/look-through reference for the authorised retreat, but exact Anchor reproduction is not the Physical Recovery completion condition.

The **Recovery Return Region** is the bounded portion of the demonstrated Stall-to-Anchor return domain in which further OuttaMyWay retreat is unnecessary before fresh GIANTS-native replanning. It MUST remain no farther from the Stall than the selected Anchor permits.

For the first implementation calibration, Candidate Support projects a target retreat separation of **20 m from the Blocked Progress Stall toward the Recovery Anchor**. If the Anchor bound is closer than 20 m, the Anchor caps the supported excursion rather than permitting invented additional retreat. The 20 m value is a validation calibration, not universal architectural policy.

> **Recovery Retreats From the Stall; It Does Not Return To the Anchor.**

> **Recovery Anchor Bounds Retreat; Recovery Return Region Ends It.**

> **Approximate In Geometry; Precise In Provenance.**

## Recovery Excursion contract

### One generic bounded release attempt

The initial Blocked Worker Recovery capability owns one generic bounded **Recovery Excursion** under one Recovery Resolution.

The excursion MUST:

- retreat from the Stall toward the selected Recovery Anchor only as far as required to enter the Recovery Return Region;
- treat the Anchor as the maximum positively demonstrated retreat bound rather than an exact destination;
- remain local to the Recovery Approach / Recovery Anchor domain;
- avoid inventing productive routing or general obstacle-bypass navigation;
- return to fresh Reality as movement progresses; and
- stop, narrow or refuse physical progression when fresh positive contradiction invalidates current permission.

The first capability MUST NOT branch by inferred obstacle class. Tree, pylon, hedge, parked object, Field World boundary and unknown environmental causes MUST NOT create separate recovery algorithms merely from their labels.

A broader repositioning or obstacle-bypass responsibility requires separate architectural authority.

### Demonstrated Traversability and claim limits

Recent **Demonstrated Traversability** MAY positively support the local return domain because the same Physical Assembly recently occupied or traversed that space under materially relevant conditions.

That support MUST remain subject-, configuration-, environment-, direction- and domain-bounded. It MUST NOT be interpreted as universal proof that reverse travel, current traffic state, scenery clearance or arbitrary manoeuvre geometry is safe.

Absence of a current represented conflict MUST NOT create Recovery authority by itself.

> **Absence of Known Conflict != Recovery Authority.**

Fresh positive current contradiction outranks historical traversal evidence. A represented worker or other positively known condition occupying the proposed release domain may therefore veto or suspend current movement permission even though the subject recently traversed that domain.

### Supplementary spatial evidence

Recovery MAY consume supplementary positive spatial evidence when available, including:

- positive interaction with another represented Physical Assembly;
- positive DISC-to-Field-World boundary intersection;
- reduction or discharge of a previously positive represented spatial condition; or
- another purpose-fit positive spatial witness accepted by the governing Architecture.

Supplementary evidence MAY strengthen current movement permission. It MUST NOT invent a different Recovery Return Region or expand the Anchor-bounded retreat domain and MUST NOT be required merely to prove an obstacle identity.

A Field World boundary intersection proves represented occupancy across the agricultural boundary. It MUST NOT be relabelled as proof of hedge, tree, pylon, terrain or other environmental collision.

> **Field Boundary Intersection != Environmental Collision.**

> **Obstacle Identification != Spatial Release Evidence.**

### Mandatory Transit request

Once the Recovery Resolution is current and the Recovery Excursion has positive Bounded Authority for its configuration step, Control MUST **request Transit before recovery movement**.

The implementation MUST NOT perform a separate strategic or expensive `shouldTransit?` investigation merely to decide whether compaction is worthwhile.

The Transit request is choreography. The physical configuration mechanism determines the realised outcome for the actual assembly and MUST establish a settled result before recovery movement proceeds.

The result may involve fold/raise/compact actuation, retention of an already suitable configuration, or fail-closed inability to establish a coherent Transit state according to the mechanism's supported contract.

> **Transit Request Is Recovery Choreography, Not Recovery Admission.**

A requested or settled Transit state MUST NOT itself be treated as proof of movement clearance. Movement uses fresh realised representation and current Bounded Authority.

### Recovery Bubble temporal protection

Recovery Bubble formation is part of BWR establishment, not a separate strategic traffic decision.

BWR consumes blocker identity only from a positive Situation-owned Causal Obstruction relation for the recovering assembly. It does not infer blocker intent inside Bounded Authority or Control.

For a positively identified blocker that is a current active member of the same Local Operation, BWR MUST establish a **0 km/h Supporting Speed Ceiling** before the Recovery Excursion begins.

For every other active Operation participant that is neither the recovering assembly nor the held blocker, BWR MUST establish exact **1 km/h Bubble Bullet Time** before the Recovery Excursion begins. No Forward Intersection, follower relation, opposed-corridor relation, theatre-overlap prediction or other participant-intent predicate is required for this uninvolved-participant protection.

Under the supported three-worker Operation envelope the intended three-participant case is therefore:

```text
recovering C -> BWR movement objective
blocker B   -> 0 km/h blocker hold
remaining A -> 1 km/h Bubble Bullet Time
```

If no active blocker is positively identified, no blocker hold is manufactured; remaining active peers receive Bubble Bullet Time.

Each supporting lease:

- owns magnitude only and MUST NOT acquire movement direction, target, steering or productive routing;
- is subordinate to the current BWR Resolution and carries no independent Regulation lifecycle;
- MUST remain active while its participant remains an active member of the protected Local Operation and BWR remains current;
- MUST release promptly if that participant leaves the Local Operation; and
- MUST release no later than authoritative BWR termination.

The required leases are fail-closed protection for autonomous Recovery. If the runtime cannot establish all required Recovery-Bubble supporting ceilings, Recovery Control MUST NOT begin the bounded retreat.

Existing compatible supporting ceilings compose through the normal least-permissive magnitude rule.

The 1 km/h mechanism is the same shared **Bubble Bullet Time** authority used by Cooperative Passage. BWR does not own a parallel Bullet-Time implementation.

> **Bubble Bullet Time Is Resolution-Bubble Infrastructure, Not Passage-Specific Control.**

> **Recovery Bubble Temporal Protection Protects Time; BWR Owns The Retreat.**

### Anchor-bounded retreat with fixed Reverse Steering Horizon

The initial capability performs one direct bounded retreat along the Stall-to-Anchor Recovery Return direction and ends the manoeuvre when the Recovery Return Region is reached.

For BWR reverse steering, Control MUST use a universal **40 m Reverse Steering Horizon** measured from the Stall along that Recovery Return direction. This steering target is intentionally independent of Anchor distance and MAY lie beyond a short Recovery Anchor.

The 40 m point is subordinate GIANTS steering geometry only. It MUST NOT:
- extend physical Bounded Authority beyond the Anchor-supported Recovery Return Region;
- enlarge `requiredRetreatM` or `maximumSupportedRetreatM`;
- become Recovery completion evidence;
- claim that the point itself is inside supported Recovery space or clear of obstacles; or
- cause Control to continue reverse movement after Return Region completion.

Physical Recovery completion remains exclusively owned by fresh Return Region progress. Steering-target arrival MUST NOT manufacture Recovery success.

The capability MUST NOT reconstruct the complete historical GIANTS path, synthesize a turning centre, steer around a guessed obstacle, invent a second release direction, or extend authorised retreat merely to satisfy the steering horizon.

> **Recovery Anchor != Reverse Steering Target.**

> **Recovery Return Region != Reverse Steering Horizon.**

> **Movement Completion Region != Reverse Steering Target.**

The granted movement envelope MUST remain no broader than the currently supported local release purpose.

## Two-phase Recovery lifecycle

### Recovery obligations

One Blocked Worker Recovery Resolution owns two terminal-dependent obligations for the same Physical Assembly:

1. **Physical Recovery** — the assembly enters the bounded Recovery Return Region after the mandatory Transit request has settled sufficiently for the authorised movement; and
2. **Native Replanning** — the intended replacement GIANTS FIELDWORK Job is positively admitted as the successor Job Episode for that same Physical Assembly.

The originating Job Episode remains provenance for admission of the Stall, Recovery Approach and Recovery Anchor. It MUST NOT remain the persistence identity of the whole Recovery after OuttaMyWay deliberately replaces that Job.

> **Recovery Admission Basis != Recovery Persistence Basis.**

The first obligation may be satisfied while the second remains open. This MUST preserve the same Recovery Resolution under the parent Resolution Lifecycle.

> **Phase Completion != Resolution Completion.**

### Phase 1 — Physical Recovery

For the initial capability, the authorised excursion ends when current Control evidence establishes entry into the Recovery Return Region. It does not continue merely to reproduce the historical Anchor pose and it does not substitute an obstacle-specific endpoint.

On entering the Recovery Return Region:

- Recovery Control MUST stop further OMW-owned recovery movement;
- the Physical Recovery obligation is positively satisfied;
- the assembly remains in the Recovery-created Transit posture;
- OuttaMyWay MUST NOT restore the pre-Recovery working posture as normal successful choreography; and
- Native Replanning proceeds inside the same Recovery Resolution.

Entering the Return Region does not itself hand the known-failed Job back to GIANTS.

> **Known-Failed Native Authority != Safe Handback Authority.**

### Phase 2 — Native Replanning

Native Replanning is subordinate choreography of **Blocked Worker Recovery Control**, not a new Candidate, Decision, Current Responsibility or Resolution type.

Recovery Control MUST prepare the replacement before intentionally terminating the failed Job. For the current supported GIANTS FIELDWORK lifecycle, preparation consists of:

- require the current native Job to be FIELDWORK;
- identify the applicable farm;
- create a fresh FIELDWORK Job;
- seed it from the recovered vehicle pose with direct-start semantics;
- apply the replacement Job's normal values;
- validate the replacement; and
- only after successful preparation, perform the Job Replacement Commitment.

Preparation MUST NOT clone the failed Job object as productive routing authority.

The **Job Replacement Commitment Point** occurs when OuttaMyWay deliberately stops the failed Job. The stop and immediate start calls are one synchronous Recovery choreography from OuttaMyWay's perspective. Observation and Operation Lifecycle MUST nevertheless continue to report the old Job Episode ending and the successor Job Episode starting truthfully.

> **Replacement Preparation != Replacement Commitment.**

> **Expected Job Replacement != Responsibility Supersession.**

The stop/start lifecycle mutation is authorised by the accepted Blocked Worker Recovery Resolution. It is not a REPOSITION target and MUST NOT broaden physical Bounded Authority.

> **Lifecycle Permission != Physical Bounded Authority.**

### Player intent preservation

Recovery MUST NOT deliberately rewrite vehicle-scoped GIANTS AI-mode/user settings merely to perform the Job replacement.

The current preservation strategy is **Player Intent Preservation by Non-Mutation**:

- discard the failed Job identity and its native execution/course state;
- retain the vehicle and its existing GIANTS AI-mode/user settings unchanged;
- direct-start the replacement from the recovered pose; and
- let GIANTS construct the new field-work execution from its normal vehicle-side state.

> **Native Replanning != Player Intent Replacement.**

Exact preservation of non-default player FIELDWORK parameters remains an in-game validation obligation. Until validated, implementation MUST NOT manufacture replacement defaults or copy guessed parameters.

### Physical release after replacement start

After the replacement Job has been successfully started, Recovery Control MUST immediately:

- clear the OMW Recovery movement objective;
- relinquish OMW Transit-configuration bookkeeping **without restoring the old working posture**; and
- allow the fresh GIANTS Job to own all subsequent configuration and movement.

Recovery Control MUST NOT wait for fold/raise settlement, a first movement witness, productive progress or route success before physically releasing the worker.

Any independently owned traffic constraint remains independent. For example, a Passage-owned 1 km/h Supporting Speed Ceiling is not removed merely because Recovery releases its movement objective.

> **Physical Release != Semantic Completion.**

### Intended successor evidence and success

The API return from the replacement `startJob()` call is mechanism evidence only. Recovery semantic completion requires positive Observation/Job Episode evidence that the **intended replacement Job** has been admitted as the successor Job Episode for the same Physical Assembly.

The implementation MUST correlate the intended successor to the replacement it actually requested, using the native replacement Job identity/token when available. Appearance of an unrelated Job MUST NOT satisfy Recovery.

> **Requested Replacement != Observed Successor.**

While waiting for that positive admission evidence:

- Recovery may remain semantically current;
- no Recovery movement objective or configuration mutation may remain merely for the wait;
- GIANTS is free to configure and move the worker; and
- no timeout may manufacture success.

On positive intended-successor admission, the Native Replanning obligation is satisfied. All terminal-dependent Recovery obligations are then settled and **RC-1 SUCCESS MUST release any remaining Recovery authority, bookkeeping and Current Responsibility stickiness immediately**.

> **Resolution Completion = Immediate Recovery Release.**

Recovery completion does not require subsequent native speed, productive progress or proof that the environmental obstruction has permanently ceased.

> **Recovery Completion Belongs to OuttaMyWay; Subsequent Native Success Belongs to Reality.**

### Fresh later blockage and Correlated Recovery Recurrence

A subsequent positive Blocked Progress Stall under the replacement Job Episode is fresh Reality. It is not an automatic retry of the previous Recovery.

A new Recovery cycle may be considered only when the successor Job Episode independently establishes:

- recent positive native progression;
- a new positive Blocked Progress Stall;
- a fresh bounded Recovery Approach Trail; and
- a fit Recovery Anchor from that new Trail.

The previous Trail and Anchor MUST NOT be reused as permission for the new cycle.

> **Cycle Repetition != Retry.**

Before admitting another Blocked Worker Recovery cycle, the implementation MUST correlate that fresh Stall against passive outcome/lineage memory from the immediately preceding successful Recovery for the same Physical Assembly.

That passive memory MAY include **Successful Recovery Excursion Evidence** recorded with the positively completed physical Recovery, including the actually achieved retreat magnitude and the maximum supported retreat magnitude derived from the Recovery Approach that bounded the completed excursion. These are scalar provenance only. They MUST NOT preserve the previous Recovery Trail, Anchor or movement direction as current permission, and they MUST NOT claim current reverse clearance.

A **Correlated Recovery Recurrence** exists only when all of the following are true:

- the current Stall was independently established by the normal Blocked Progress contract;
- the current Physical Assembly matches the preceding successful Recovery subject;
- the current Job Episode is the intended successor Job Episode produced by that Recovery;
- planar Stall-to-Stall separation is **<= 5.0 m**; and
- Stall-to-Stall elapsed time is **<= 60.0 s**.

The temporal origin is the prior Stall timestamp, not Recovery completion or successor admission. The spatial comparison is prior Stall pose to fresh Stall pose.

The 5 m and 60 s values are correlation bounds. They MUST NOT be used to establish Stall truth, obstacle identity, Recovery failure, environmental clearance or success-by-absence.

> **Time Bounds Correlation; It Does Not Establish Failure.**

> **Spatial Proximity Correlates Stalls; It Does Not Identify the Obstacle.**

The first fresh correlated successor Stall is sufficient to establish **Recovery Strategy Exhausted** for this simple one-cycle Recovery strategy. The preceding Recovery remains semantically successful; recurrence is a later Reality conclusion that replaying the same strategy is no longer justified.

When Recovery Strategy Exhausted is established:

- another Blocked Worker Recovery Candidate MUST NOT be admitted for that correlated Stall;
- no automatic Recovery retry/replacement loop may be started;
- passive recurrence state MUST NOT acquire Current Responsibility, Bounded Authority or Control authority;
- independently supported traffic or other Resolution responsibilities remain independently assessable;
- the separate [`BOUNDED_BYPASS`](BOUNDED_BYPASS.md) Jurisdiction may be assessed from fresh current evidence; Recovery Strategy Exhausted is its strategy-succession gate and MAY expose retained Successful Recovery Excursion Evidence scalar magnitudes, but MUST NOT establish the current local continuation frame, reverse axis, Transit support, Dogleg side or movement authority; and
- if no supported autonomous continuation remains, normal escalation may require Player Intervention.

Outside the 5 m / 60 s bounds, or without exact intended-successor lineage, the later Stall is not a Correlated Recovery Recurrence and may independently support a new Recovery cycle if all ordinary admission requirements are satisfied.

Correlation memory MAY be retired lazily when its successor lineage is no longer current/relevant or the temporal bound is exceeded. Expiry is correlation cleanup only; it MUST NOT manufacture success, failure or obstacle-clearance meaning.

### Failure before and after Job Replacement Commitment

If replacement preparation or validation fails **before** the Job Replacement Commitment Point, Control MUST NOT expose the already-known failed native Job merely as a fallback. Recovery remains unresolved at the bounded Recovery state and Player Intervention is legitimate.

If OuttaMyWay has passed the Job Replacement Commitment Point but cannot establish a usable replacement, the result is **Unresolved Native Reacquisition**. OuttaMyWay MUST NOT invent a wider movement, an obstacle-specific bypass or an unbounded Job-restart loop.

Existing player authority remains sufficient. A manual player stop of a still-existing GIANTS Job is authoritative lifecycle evidence and Recovery releases through its normal supersession path; no Recovery-specific player-intervention protocol is required.

## Durable invariants

### Productive work remains GIANTS-owned

Blocked Worker Recovery may deliberately replace one failed GIANTS FIELDWORK Job with a fresh GIANTS FIELDWORK Job for native replanning. OuttaMyWay does not acquire productive routing, course generation or ordinary post-restart navigation ownership.

### Obstacle identity is optional

A positive Blocked Progress Stall plus fit recovery evidence can justify one bounded Physical Recovery phase without identifying the blocking object. Unknown cause MUST remain unknown rather than being guessed from persistence, boundary proximity or scenery expectations.

### Fresh evidence may support another Recovery cycle unless the strategy is exhausted

One Recovery Resolution does not recursively retry itself. After RC success, a later supported Stall under a fresh Job Episode may admit a new independent two-phase Recovery cycle from fresh Trail/Anchor evidence **unless** it satisfies the Correlated Recovery Recurrence contract against the immediately preceding successful Recovery, in which case Recovery Strategy Exhausted vetoes replay of the same Recovery strategy for that Stall.

### Responsibility continuity and physical permission remain distinct

The Recovery Resolution MAY remain current after OMW physical release while intended-successor admission evidence is pending. Semantic persistence does not grant a new physical effect.

### No negative-clearance promotion

DISC geometry, Demonstrated Traversability, Field World geometry and absence of a represented conflict MUST retain their existing claim limits. This Jurisdiction does not promote generic negative-clearance authority.

## Publication contract

Blocked Worker Recovery follows the shared Log Publication support-escalation contract. Publication is observability, not semantic authority, and MUST NOT alter Stall admission, Candidate selection, Recovery persistence, Bounded Authority or Control.

### NORMAL — sparse lifecycle/intervention journal

Responsibility Transition owns the purpose-specific operational lifecycle events:

- `BLOCKED_WORKER_RECOVERY_STARTED` when Recovery Current Responsibility is positively established; and
- `BLOCKED_WORKER_RECOVERY_ENDED` when that Current Responsibility is authoritatively terminated after settlement, supersession, failure or escalation.

The NORMAL payload SHOULD include the authoritative Operation identity when available, the Recovery responsibility/commitment identities, the recovering assembly and a stable reason/outcome.

Fresh later Stall admission is not a periodic NORMAL heartbeat. If a supported failure condition establishes that autonomous continuation is exhausted and player action is required, the owning lifecycle publishes the existing NORMAL `PLAYER_INTERVENTION_REQUIRED` event.

### DEBUG — bounded causal narrative

DEBUG may publish transition/change evidence sufficient to explain why Recovery was or was not attempted, including positive Blocked Progress Stall establishment, Recovery Anchor selection/invalidation, Candidate rejection/selection, Bounded Authority refusal/revocation, Transit settlement, Recovery Return Region establishment, Job Replacement Commitment, intended-successor admission and final Recovery settlement.

DEBUG MUST remain change/transition-driven. It MUST NOT emit the same unchanged Stall, Anchor, residual or control phase every runtime cycle merely because Recovery remains current.

### DIAGNOSTIC — targeted engineering evidence

DIAGNOSTIC may expose detailed motion samples, observation-interval displacement, represented geometry, anchor fitness components, movement/residual calculations and other intermediate evidence needed to investigate a specific unresolved Recovery question.

Such evidence is produced only by an independently justified diagnostic instrument or already-existing evidence source. DIAGNOSTIC publication eligibility does not authorise continuous expensive measurement, and suppressed publication MUST avoid publication-only projection work.

> **Recovery Observability != Recovery Authority.**

## Failure and uncertainty semantics

- **Raw `isBlocked` with continuing realised progress** — no Blocked Progress Stall; no Recovery admission.
- **Blocked assertion plus insufficient motion evidence** — remain unresolved; do not use timeout as proof.
- **Blocked Progress Stall but no fit Recovery Anchor / Recovery Return Region projection** — no autonomous Recovery cycle.
- **Recovery Anchor / Return Region fit but current movement permission contradicted** — preserve the Resolution only while its obligation remains legitimate; do not move without current Bounded Authority.
- **Transit unsettled/unrealizable** — fail closed; do not move in an assumed compact state.
- **Recovery Return Region reached** — satisfy Physical Recovery; do not restore the old working posture or hand the failed Job back as successful completion.
- **Replacement preparation/validation fails before Commitment** — preserve unresolved Recovery and do not expose the known-failed Job merely as fallback.
- **Replacement start succeeds** — physically release OMW movement/configuration control immediately; await only semantic intended-successor admission.
- **Intended successor Job Episode admitted** — satisfy Native Replanning and end RC immediately through normal terminal settlement.
- **Fresh later Stall under the successor** — assess from fresh evidence first, then correlate against the immediately preceding successful Recovery; a 5 m / 60 s exact-successor recurrence establishes Recovery Strategy Exhausted and vetoes another Recovery cycle for that Stall.
- **No supported autonomous continuation remains** — parent-consistent failure/escalation may require Player Intervention.

## Cross-Jurisdiction dependencies

### Observation

Observation supplies current native blockage, motion, Job Episode, pose, native field-work, representation and other Reality evidence without assigning recovery meaning.

### Situation Assessment

Situation Assessment owns Blocked Progress Contradiction / Blocked Progress Stall interpretation and the current meaning of any supplementary spatial evidence. This specialised Resolution consumes that meaning; it MUST NOT reinterpret raw `isBlocked` itself.

### Physical Representation

Assessment Representation supplies purpose-fit current Physical Assembly evidence and preserves the claim limits of DISC geometry, Demonstrated Traversability, configuration footprints and Field World relationships. Blocked Worker Recovery does not enlarge those permissions.

### Candidate Support, Constraint Evaluation and Decision

Before BWR establishment, prospective support and mandatory constraints remain upstream of Responsibility Transition. A Blocked Progress Stall does not automatically outrank an independently supported active-traffic, Causal Obstruction or other purpose-specific Candidate. Decision selects among current supported alternatives before Responsibility Transition. This Specification does not make `isBlocked`, Stall classification or Control availability equivalent to Candidate selection.

After BWR establishment, its Recovery Bubble temporarily owns the Local Operation's prospective decision horizon. Fresh Observation and Situation knowledge continue, but new independent Candidate / Decision creation is deferred until BWR terminates and the Bubble releases. This is bounded serialization for Recovery, not persistent pair history or future-route ownership.

### Bounded Bypass

[`BOUNDED_BYPASS.md`](BOUNDED_BYPASS.md) is a separate Resolution Jurisdiction. It is not a third phase of Blocked Worker Recovery and does not weaken the recurrence veto against replaying BWR.

Only after the Recovery Bubble has terminated may the fresh correlated successor Stall participate in ordinary prospective Candidate selection. Recovery Strategy Exhausted is the separate Bounded Bypass strategy-succession gate; Bypass still requires its current local continuation frame, Transit support, supported Fixed Bypass Dogleg and ordinary authority path. It does not require a positive Causal Obstruction or a non-active blocker-stability model. Current Causal Obstruction may instead contribute only the identity of an active same-Operation GIANTS participant that requires temporary Bubble protection. BWR recurrence memory contributes the `Recovery Strategy Exhausted` fact and no movement authority.

### Responsibility Transition

Responsibility Transition establishes and ends the Blocked Worker Recovery Current Responsibility. Entering the Recovery Return Region does not itself mutate Current Responsibility without that authoritative lifecycle transition.

### Resolution Lifecycle

This Jurisdiction specialises `RESOLUTION_LIFECYCLE`. Its Physical Recovery and Native Replanning obligations, persistence and terminal dispositions MUST remain parent-consistent.

### Bounded Authority

Every positive Transit/configuration and Recovery-movement effect requires current purpose-specific Bounded Authority. The GIANTS Job stop/start choreography is lifecycle permission of the accepted Recovery Resolution, not a physical Bounded Authority target.

### Control

Control executes the granted Transit/configuration and Recovery movement, then the Resolution-authorised native FIELDWORK Job replacement and immediate OMW physical relinquishment. Control does not decide Blocked Progress Stall admission, productive routing or later fresh-Stall meaning.

## Current implementation — Recovery Bubble decision horizon

Production `Runtime:processLiveObservation()` treats a current Blocked Worker Recovery as a protected Recovery Bubble. While that Resolution is current, prospective support for new independent responsibilities is replaced by passive decision support; fresh Observation and Situation knowledge still update for reassessment after release.

Production `BubbleBulletTime` is the shared Resolution-Bubble supporting-speed mechanism. For BWR, Runtime supplies a purpose-specific participant plan: a positively identified active causal blocker receives a 0 km/h hold, while any remaining uninvolved active participant receives the shared 1 km/h Bubble Bullet Time. If no active blocker is positively identified, no hold is invented. All leases carry `SUPPORTING_SPEED_CEILING` authority only and are released when BWR terminates or their protected participant leaves the Local Operation.

Fresh independent Commitment creation may still occur beside unrelated retained responsibilities **before** BWR establishment where ordinary admission allows it. Once the Recovery Bubble is current, no new competing responsibility is selected until Recovery ends.

Production Observation also currently publishes `jobEpisodeEvidence.outtaMyWayHold=false` unconditionally. That placeholder MUST NOT be used as positive evidence that OuttaMyWay did not cause quiescence. Recovery admission must use truthful current semantic/actuation ownership until Observation owns a truthful equivalent field.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/assessment/BlockedWorkerRecoveryRecurrenceAssessment.lua`](../scripts/assessment/BlockedWorkerRecoveryRecurrenceAssessment.lua) | `REALISES` |
| [`scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua`](../scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua) | `REALISES` |
| [`scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua`](../scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua) | `REALISES` |
| [`scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua`](../scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua) | `REALISES` |
| [`scripts/control/BlockedWorkerRecoveryControl.lua`](../scripts/control/BlockedWorkerRecoveryControl.lua) | `REALISES` |
| [`scripts/authority/BubbleBulletTime.lua`](../scripts/authority/BubbleBulletTime.lua) | `REALISES` |
| [`scripts/responsibility/ResponsibilityTransitionAuthority.lua`](../scripts/responsibility/ResponsibilityTransitionAuthority.lua) | `SUPPORTS` |
| [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) | `SUPPORTS` |

## Implementation traceability

Production implements one bounded Recovery cycle plus passive correlated-recurrence exhaustion:

- [`BlockedProgressAssessment.lua`](../scripts/assessment/BlockedProgressAssessment.lua) remains `SITUATION_ASSESSMENT` authority for fresh Stall, Recovery Approach Trail and Recovery Anchor meaning;
- [`BlockedWorkerRecoveryRecurrenceAssessment.lua`](../scripts/assessment/BlockedWorkerRecoveryRecurrenceAssessment.lua) retains the immediately preceding successful Recovery's prior-Stall + intended-successor lineage provenance and, when positively available, bounded Successful Recovery Excursion outcome evidence such as achieved retreat magnitude; it correlates a later independently established Stall without acquiring Recovery authority;
- [`BlockedWorkerRecoveryCandidateSupport.lua`](../scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua) projects one current Stall+Anchor into one Recovery Candidate only when Correlated Recovery Recurrence has not established Recovery Strategy Exhausted;
- [`BlockedWorkerRecoveryCommitmentLifecycle.lua`](../scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua) owns specialised Recovery commitment settlement;
- [`BlockedWorkerRecoveryResponsibilityTransition.lua`](../scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua) establishes the single-subject Current Responsibility;
- [`BlockedWorkerRecoveryControl.lua`](../scripts/control/BlockedWorkerRecoveryControl.lua) requests Transit, retreats into the Recovery Return Region using the selected Anchor as subordinate steering reference, reports the positively achieved physical excursion as completed-outcome evidence, prepares and commits a fresh direct-start GIANTS FIELDWORK Job, relinquishes OMW physical/configuration control, and waits only for intended-successor Job Episode admission;
- [`BubbleBulletTime.lua`](../scripts/authority/BubbleBulletTime.lua) provides shared Resolution-Bubble supporting-speed mechanics; for BWR it applies the 0 km/h active-blocker hold and 1 km/h uninvolved-participant Bullet Time without acquiring either participant's movement objective; and
- Runtime defers new prospective responsibility selection while BWR is current, releases the Recovery Bubble at terminal settlement, and records passive recurrence/outcome provenance only after semantic Recovery success.

A correlated successor Stall does not become a failed prior Recovery and does not start another Control lifecycle. Candidate replay is vetoed and the runtime remains fail-closed with existing player authority available for intervention.

## Validation route

### Structural/source-contract validation

Structural validation must prove that declared Recovery production participants acknowledge this Jurisdiction reciprocally, that Physical Recovery remains bounded by the selected Anchor/Return Region contract, that recurrence memory remains passive and can only veto Candidate replay, and that Recovery does not recreate operation-global Resolution exclusivity.

### Offline behavioural/conformance validation

Current offline validation should challenge at least:

- raw blocked spam while realised progression continues does not admit Recovery;
- a positive Blocked Progress Contradiction can admit one Recovery Resolution;
- OMW-caused quiescence does not recursively admit Recovery;
- bounded Recovery Approach Trail sampling/retention remains purpose-specific and does not become Productive History;
- Recovery Anchor invalidation on identity/lifecycle/direction/configuration discontinuity;
- once Trail qualification is satisfied, Anchor selection uses the first/oldest retained compatible witness rather than the newest sample;
- absence of known conflict does not become negative-clearance authority;
- mandatory Transit request occurs before recovery movement;
- current positive spatial contradiction can veto/narrow movement;
- entering the Recovery Return Region settles Physical Recovery without terminalising the Resolution;
- replacement preparation precedes the synchronous stop/start Job Replacement Commitment;
- successful replacement start immediately relinquishes OMW movement and Transit-configuration bookkeeping without restoring the former working posture;
- API start success alone does not settle Native Replanning;
- only positive admission of the intended successor Job Episode for the same Physical Assembly completes Recovery;
- Recovery Bubble formation holds a positively identified active causal blocker at 0 km/h and applies 1 km/h Bubble Bullet Time to any remaining active participant without requiring a future-route predicate;
- Recovery movement does not start unless all required Bubble ceilings are established;
- no new prospective traffic/Resolution responsibility is selected while the Recovery Bubble remains current;
- Bubble ceilings release on participant departure or authoritative BWR termination, after which fresh assessment resumes;
- a later fresh Stall requires its own fresh Trail/Anchor evidence before recurrence correlation;
- exact intended-successor lineage + <=5 m + <=60 s establishes Correlated Recovery Recurrence and vetoes Recovery Candidate replay; and
- different lineage or a Stall outside either correlation bound does not manufacture Recovery Strategy Exhausted.

### Targeted in-game Reality validation

In-game validation is required for the live GIANTS assumptions on which this capability depends.

Initial Reality validation should include:

1. transient/native blocked signalling while the worker continues or resumes without intervention;
2. the demonstrated Condor boundary-associated Stall and Anchor-bounded retreat into the Recovery Return Region;
3. Transit request and settlement on materially different assemblies;
4. successful direct-start FIELDWORK Job replacement from the recovered pose, including truthful old/new Job Episode succession;
5. immediate GIANTS ownership of post-restart configuration and movement with no OMW restore tail;
6. absence or presence of a player-visible manual-stop notification when Recovery uses the supported nil-message stop lifecycle;
7. preservation of deliberately distinctive player-selected FIELDWORK parameters across replacement in a dedicated scenario;
8. the demonstrated S416 successor recurrence, proving that the fresh correlated Stall is classified Recovery Strategy Exhausted and Recovery #2 is not admitted; plus a non-correlated successor Stall proving independent fresh Recovery remains supportable outside the accepted correlation bounds;
9. TS015-style live-worker blockage with a positively identified active blocker and a third participant, proving that the blocker is held at 0 km/h, the uninvolved participant receives 1 km/h Bubble Bullet Time, and fresh traffic assessment resumes only after BWR release; and
10. existing Cooperative Passage / Regulation cases, proving that ordinary Bubble and Regulation behavior remains unchanged outside BWR.

### Outside this Specification's validation claim

A successful Recovery cycle does not prove that arbitrary scenery is navigable, that every future GIANTS route will succeed, that every player FIELDWORK setting has already been validated as preserved, that every environmental obstacle can be identified, or that the separate Bounded Bypass contract is supportable in any particular situation.
