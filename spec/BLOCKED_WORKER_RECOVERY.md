# Blocked Worker Recovery Specification

## Identity and authority

**Specification Jurisdiction:** Blocked Worker Recovery  
**Jurisdiction ID:** `BLOCKED_WORKER_RECOVERY`  
**Parent Jurisdiction:** [`Resolution Lifecycle`](RESOLUTION_LIFECYCLE.md)  
**Primary Architecture Authority:** [`architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#specification-jurisdiction--blocked-worker-recovery)

This Specification owns the implementation-facing contract for the single-subject **Resolution Commitment** that performs one two-phase Recovery cycle for a still-active GIANTS worker after current Situation evidence has established a **Blocked Progress Stall**: bounded physical return to a Recovery Anchor, followed by deliberate GIANTS-native replanning through FIELDWORK Job replacement.

Blocked Worker Recovery does **not** own raw native blockage observation, generic Situation interpretation, obstacle identification, environmental map modelling, productive routing, arbitrary path planning, generic Bounded Authority or generic Control mechanics.

It inherits the persistence, obligation and terminal rules of [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md).

> **Native Blocked Assertion != Blocked Worker Recovery Responsibility.**

> **Recovery Need Does Not Require Blockage Cause.**

## Boundary contract

### Admission inputs

A new Blocked Worker Recovery Resolution MUST be grounded in one coherent current evidence/selection context containing, directly or through its upstream products:

- one exact active supported Physical Assembly and qualifying GIANTS Job Episode;
- a current positive **Blocked Progress Stall** established from a Blocked Progress Contradiction;
- the recent **Recovery Approach** and one fit **Recovery Anchor** for that same assembly/Job Episode;
- purpose-fit current representation and physical-reference evidence;
- recent Demonstrated Traversability sufficient to support the bounded local return domain being considered;
- no current OuttaMyWay-owned physical effect that explains the quiescence or already governs the subject incompatibly;
- no current supported active-traffic responsibility or other incompatible Current Responsibility that already owns the subject's condition;
- no higher-authority Player Claim or lifecycle condition that prevents autonomous recovery;
- any current positive spatial contradiction relevant to the proposed local release movement; and
- the current responsibility/commitment context needed to distinguish fresh establishment from maintenance of the same Recovery Resolution.

Raw `spec_aiFieldWorker.isBlocked` MUST NOT independently satisfy admission.

### Decision horizon and compatible responsibilities

Blocked Worker Recovery is a single-subject Resolution. Its Current Responsibility owns the recovering assembly's bounded Recovery Excursion; it does not own the whole Local Operation's prospective Decision horizon.

> **Resolution Commitment != Exclusive Traffic Decision Horizon.**

An already-current compatible Regulation whose controlled subject is another assembly MUST NOT, by its existence alone, make Recovery inadmissible. Likewise, once Recovery is current, ordinary traffic Candidate support for other assemblies remains live.

Examples of accepted coexistence include:

- C under Recovery while B is tactically regulated to protect C's local movement domain;
- C under Recovery while A is follower-regulated behind C; and
- C under Recovery while A/B execute Cooperative Passage and Passage applies its independent 1 km/h Supporting Speed Ceiling to C.

These are independent Current Responsibilities, not one combined Recovery traffic mode.

A responsibility that would require an incompatible movement objective or incompatible actuation ownership on C remains inadmissible while Recovery owns C's movement objective. Fresh cross-purpose ambiguity or incompatibility MUST be handled by explicit Candidate / Constraint / Decision semantics; Recovery gains no implicit precedence from Stall status.

Selection of a compatible new responsibility MUST NOT automatically terminate or restart the current Recovery Resolution.

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

### Recovery Approach Trail and Recovery Anchor

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

The minimum useful Trail-span requirement qualifies whether the retained Recovery Approach Trail is sufficient to support one bounded recovery attempt; it MUST NOT select the Recovery Point. Once the retained compatible Trail qualifies, Assessment MUST select its first/oldest retained compatible witness as the Recovery Anchor. Assessment MUST NOT widen retention or reconstruct older history merely because the bounded Trail is insufficient.

> **Insufficient Anchor Span != Permission to Retain Productive History.**

Anchor age alone MUST NOT establish or destroy fitness.

> **Last Unblocked Pose != Recovery Anchor.**

> **Recovery Anchor != Known Safe Pose.**

The Anchor bounds return provenance. For the initial capability, the selected Recovery Anchor is also the **Recovery Point** and longitudinal return limit of the one authorised Recovery Excursion. It MUST NOT be promoted into generic negative-clearance authority, arbitrary reverse-feasibility authority, productive routing or generic waypoint authority.

The same qualifying settled-A8 Recovery Approach MUST provide a finite native travel direction sufficient to define the **Recovery Approach Axis**. The Axis uses the selected Recovery Anchor as station origin and the observed native Approach direction as its positive longitudinal direction toward the Stall.

The Anchor is not a reverse steering point.

> **Recovery Anchor != Reverse Steering Target.**

> **Settled A8 Approach Establishes the Initial Recovery Reverse Axis.**

## Recovery Excursion contract

### One generic bounded release attempt

The initial Blocked Worker Recovery capability owns one generic bounded **Recovery Excursion** under one Recovery Resolution.

The excursion MUST:

- move directly to the selected Recovery Anchor, which is the Recovery Point for the initial capability;
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

Supplementary evidence MAY strengthen current movement permission. It MUST NOT substitute a different Recovery Point or be required merely to prove an obstacle identity.

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

### Passage Bullet Time during Recovery

Blocked Worker Recovery does not create a special traffic class.

If an independent A/B Cooperative Passage Bubble forms while the recovering assembly is the Bubble's third active worker, the Recovery Resolution remains current and its Recovery Excursion continues under the Passage-owned **1 km/h Supporting Speed Ceiling**.

The Bullet-Time ceiling:

- narrows Recovery movement magnitude only;
- MUST NOT acquire or replace the Recovery movement objective;
- MUST NOT invalidate the Recovery Anchor merely because movement becomes slower;
- MUST NOT restart the Recovery Excursion when the ceiling is applied or removed; and
- MUST NOT be interpreted as Recovery failure merely because progress is slower while the cap is current.

When the Bubble dissolves, removing the ceiling changes only current permitted magnitude. Recovery continues under its own still-current Bounded Authority if its Recovery Point has not yet been reached.

Any Recovery progress-watchdog implementation MUST measure purpose-specific progress toward the current Recovery completion residual and MUST treat a current compatible speed ceiling as valid execution context rather than as evidence that the Recovery strategy has failed.

> **Bullet Time Constrains Recovery; It Does Not Suspend Recovery.**

### Direct Recovery Anchor movement

The initial capability performs one direct bounded manoeuvre to the selected Recovery Anchor by reversing on the fixed Recovery Approach Axis.

Control MUST use longitudinal axis travel rather than reverse world-point pursuit:

- the Recovery Anchor is station origin / target station zero;
- the retained native Recovery Approach direction is the positive axis toward the Stall;
- reverse motion follows the fixed opposite axis direction;
- completion is reaching the Anchor station within the accepted Recovery tolerance; and
- lateral displacement MUST NOT rotate the reverse steering demand toward the Anchor point.

Recovery MUST NOT move farther forward merely to straighten the assembly because the unresolved blockage lies ahead. The initial capability assumes its qualifying settled-A8 Approach is sufficiently straight for this bounded reverse. If that execution support is contradicted, Control fails closed rather than inventing a curved reverse correction or a forward Alignment Runout.

It MUST NOT reconstruct the complete historical GIANTS path, synthesize a turning centre, steer around a guessed obstacle, invent a second release direction, or derive a separate excursion-distance target.

> **Recovery Anchor = Initial Recovery Point.**

> **Straight Reverse Requires Axis Stability, Not Point Attraction.**

The granted movement envelope MUST remain no broader than the currently supported local release purpose.

## Two-phase Recovery lifecycle

### Recovery obligations

One Blocked Worker Recovery Resolution owns two terminal-dependent obligations for the same Physical Assembly:

1. **Physical Recovery** — the assembly reaches the selected Recovery Anchor after the mandatory Transit request has settled sufficiently for the authorised movement; and
2. **Native Replanning** — the intended replacement GIANTS FIELDWORK Job is positively admitted as the successor Job Episode for that same Physical Assembly.

The originating Job Episode remains provenance for admission of the Stall, Recovery Approach and Recovery Anchor. It MUST NOT remain the persistence identity of the whole Recovery after OuttaMyWay deliberately replaces that Job.

> **Recovery Admission Basis != Recovery Persistence Basis.**

The first obligation may be satisfied while the second remains open. This MUST preserve the same Recovery Resolution under the parent Resolution Lifecycle.

> **Phase Completion != Resolution Completion.**

### Phase 1 — Physical Recovery

For the initial capability, the selected Recovery Anchor **is** the Recovery Point. The authorised excursion ends at that Anchor; it does not continue to seek a better location or substitute an obstacle-specific endpoint.

On reaching the Recovery Point:

- Recovery Control MUST stop further OMW-owned recovery movement;
- the Physical Recovery obligation is positively satisfied;
- the assembly remains in the Recovery-created Transit posture;
- OuttaMyWay MUST NOT restore the pre-Recovery working posture as normal successful choreography; and
- Native Replanning proceeds inside the same Recovery Resolution.

Reaching the Anchor does not itself hand the known-failed Job back to GIANTS.

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

### Fresh later blockage

A subsequent positive Blocked Progress Stall under the replacement Job Episode is fresh Reality. It is not an automatic retry of the previous Recovery and does not require a recurrence suppression window.

A new Recovery cycle may be admitted only when the successor Job Episode independently establishes:

- recent positive native progression;
- a new positive Blocked Progress Stall;
- a fresh bounded Recovery Approach Trail; and
- a fit Recovery Anchor from that new Trail.

The previous Trail and Anchor MUST NOT be reused as permission for the new cycle.

> **Cycle Repetition != Retry.**

No post-success recurrence watch, retry counter or same-location veto is required by this capability. If repeated fresh Job Episodes later demonstrate pathological cycling, that is new evidence requiring a separately justified escalation policy.

### Failure before and after Job Replacement Commitment

If replacement preparation or validation fails **before** the Job Replacement Commitment Point, Control MUST NOT expose the already-known failed native Job merely as a fallback. Recovery remains unresolved at the bounded Recovery state and Player Intervention is legitimate.

If OuttaMyWay has passed the Job Replacement Commitment Point but cannot establish a usable replacement, the result is **Unresolved Native Reacquisition**. OuttaMyWay MUST NOT invent a wider movement, an obstacle-specific bypass or an unbounded Job-restart loop.

Existing player authority remains sufficient. A manual player stop of a still-existing GIANTS Job is authoritative lifecycle evidence and Recovery releases through its normal supersession path; no Recovery-specific player-intervention protocol is required.

## Durable invariants

### Productive work remains GIANTS-owned

Blocked Worker Recovery may deliberately replace one failed GIANTS FIELDWORK Job with a fresh GIANTS FIELDWORK Job for native replanning. OuttaMyWay does not acquire productive routing, course generation or ordinary post-restart navigation ownership.

### Obstacle identity is optional

A positive Blocked Progress Stall plus fit recovery evidence can justify one bounded Physical Recovery phase without identifying the blocking object. Unknown cause MUST remain unknown rather than being guessed from persistence, boundary proximity or scenery expectations.

### Fresh evidence may support another Recovery cycle

One Recovery Resolution does not recursively retry itself. After RC success, a later supported Stall under a fresh Job Episode may admit a new independent two-phase Recovery cycle from fresh Trail/Anchor evidence.

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

DEBUG may publish transition/change evidence sufficient to explain why Recovery was or was not attempted, including positive Blocked Progress Stall establishment, Recovery Anchor selection/invalidation, Candidate rejection/selection, Bounded Authority refusal/revocation, Transit settlement, Recovery Point establishment, Job Replacement Commitment, intended-successor admission and final Recovery settlement.

DEBUG MUST remain change/transition-driven. It MUST NOT emit the same unchanged Stall, Anchor, residual or control phase every runtime cycle merely because Recovery remains current.

### DIAGNOSTIC — targeted engineering evidence

DIAGNOSTIC may expose detailed motion samples, observation-interval displacement, represented geometry, anchor fitness components, movement/residual calculations and other intermediate evidence needed to investigate a specific unresolved Recovery question.

Such evidence is produced only by an independently justified diagnostic instrument or already-existing evidence source. DIAGNOSTIC publication eligibility does not authorise continuous expensive measurement, and suppressed publication MUST avoid publication-only projection work.

> **Recovery Observability != Recovery Authority.**

## Failure and uncertainty semantics

- **Raw `isBlocked` with continuing realised progress** — no Blocked Progress Stall; no Recovery admission.
- **Blocked assertion plus insufficient motion evidence** — remain unresolved; do not use timeout as proof.
- **Blocked Progress Stall but no fit Recovery Anchor** — no autonomous Recovery cycle.
- **Recovery Anchor fit but current movement permission contradicted** — preserve the Resolution only while its obligation remains legitimate; do not move without current Bounded Authority.
- **Transit unsettled/unrealizable** — fail closed; do not move in an assumed compact state.
- **Recovery Point reached** — satisfy Physical Recovery; do not restore the old working posture or hand the failed Job back as successful completion.
- **Replacement preparation/validation fails before Commitment** — preserve unresolved Recovery and do not expose the known-failed Job merely as fallback.
- **Replacement start succeeds** — physically release OMW movement/configuration control immediately; await only semantic intended-successor admission.
- **Intended successor Job Episode admitted** — satisfy Native Replanning and end RC immediately through normal terminal settlement.
- **Fresh later Stall under the successor** — assess from fresh evidence; a new Recovery cycle may be admitted if its own Trail/Anchor contract is satisfied.
- **No supported autonomous continuation remains** — parent-consistent failure/escalation may require Player Intervention.

## Cross-Jurisdiction dependencies

### Observation

Observation supplies current native blockage, motion, Job Episode, pose, native field-work, representation and other Reality evidence without assigning recovery meaning.

### Situation Assessment

Situation Assessment owns Blocked Progress Contradiction / Blocked Progress Stall interpretation and the current meaning of any supplementary spatial evidence. This specialised Resolution consumes that meaning; it MUST NOT reinterpret raw `isBlocked` itself.

### Physical Representation

Assessment Representation supplies purpose-fit current Physical Assembly evidence and preserves the claim limits of DISC geometry, Demonstrated Traversability, configuration footprints and Field World relationships. Blocked Worker Recovery does not enlarge those permissions.

### Candidate Support, Constraint Evaluation and Decision

Where strategic selection is required, prospective support and mandatory constraints remain upstream of Responsibility Transition. A Blocked Progress Stall does not automatically outrank an independently supported active-traffic, Causal Obstruction or other purpose-specific Candidate. Decision selects among current supported alternatives before Responsibility Transition. This Specification does not make `isBlocked`, Stall classification or Control availability equivalent to Candidate selection.

Decision scope is not operation-global merely because a Recovery Resolution is current. Compatible independent traffic support remains eligible while Recovery persists. Conversely, selection of such a compatible purpose does not by itself supersede Recovery.

### Responsibility Transition

Responsibility Transition establishes and ends the Blocked Worker Recovery Current Responsibility. Reaching the Recovery Point does not itself mutate Current Responsibility without that authoritative lifecycle transition.

### Resolution Lifecycle

This Jurisdiction specialises `RESOLUTION_LIFECYCLE`. Its Physical Recovery and Native Replanning obligations, persistence and terminal dispositions MUST remain parent-consistent.

### Bounded Authority

Every positive Transit/configuration and Recovery-movement effect requires current purpose-specific Bounded Authority. The GIANTS Job stop/start choreography is lifecycle permission of the accepted Recovery Resolution, not a physical Bounded Authority target.

### Control

Control executes the granted Transit/configuration and Recovery movement, then the Resolution-authorised native FIELDWORK Job replacement and immediate OMW physical relinquishment. Control does not decide Blocked Progress Stall admission, productive routing or later fresh-Stall meaning.

## Current implementation — purpose-specific decision horizon

Production `Runtime:processLiveObservation()` now treats current Blocked Worker Recovery as the explicit non-exclusive exception to the existing Resolution decision-horizon behavior. A current Recovery Resolution does not set the operation-global exclusivity flag, so compatible independent traffic Candidate support remains live.

Fresh independent Commitment creation is permitted beside an unrelated retained Recovery context. Existing responsibility-key and actuation-owner admission checks still fail closed on incompatible ownership.

Production Observation also currently publishes `jobEpisodeEvidence.outtaMyWayHold=false` unconditionally. That placeholder MUST NOT be used as positive evidence that OuttaMyWay did not cause quiescence. Recovery admission must use truthful current semantic/actuation ownership until Observation owns a truthful equivalent field.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua`](../scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua) | `REALISES` |
| [`scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua`](../scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua) | `REALISES` |
| [`scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua`](../scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua) | `REALISES` |
| [`scripts/control/BlockedWorkerRecoveryControl.lua`](../scripts/control/BlockedWorkerRecoveryControl.lua) | `REALISES` |
| [`scripts/responsibility/ResponsibilityTransitionAuthority.lua`](../scripts/responsibility/ResponsibilityTransitionAuthority.lua) | `SUPPORTS` |
| [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) | `SUPPORTS` |

## Implementation traceability

Production now implements the first complete Blocked Worker Recovery vertical slice:

- [`BlockedWorkerRecoveryCandidateSupport.lua`](../scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua) projects one current Stall+Anchor into one Recovery Candidate;
- [`BlockedWorkerRecoveryCommitmentLifecycle.lua`](../scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua) owns specialised Recovery commitment settlement;
- [`BlockedWorkerRecoveryResponsibilityTransition.lua`](../scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua) establishes the single-subject Current Responsibility;
- [`BlockedWorkerRecoveryControl.lua`](../scripts/control/BlockedWorkerRecoveryControl.lua) requests Transit, moves directly to the selected Recovery Anchor, prepares and commits a fresh direct-start GIANTS FIELDWORK Job, relinquishes OMW physical/configuration control, and waits only for intended-successor Job Episode admission; and
- Runtime / Responsibility Transition integration preserves Recovery's non-exclusive traffic decision horizon while retaining Passage's Bubble horizon.

Upstream [`scripts/assessment/BlockedProgressAssessment.lua`](../scripts/assessment/BlockedProgressAssessment.lua) remains `SITUATION_ASSESSMENT` authority for Stall and Anchor meaning.

Fresh post-success blockage is handled by ordinary Blocked Progress assessment under the successor Job Episode; no post-success recurrence watch is retained.

## Validation route

### Structural/source-contract validation

Structural validation must prove that declared Recovery production participants acknowledge this Jurisdiction reciprocally, that the Candidate/Responsibility/Control path remains bounded to one selected Recovery Anchor, and that Recovery does not recreate operation-global Resolution exclusivity.

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
- reaching the Anchor settles Physical Recovery without terminalising the Resolution;
- replacement preparation precedes the synchronous stop/start Job Replacement Commitment;
- successful replacement start immediately relinquishes OMW movement and Transit-configuration bookkeeping without restoring the former working posture;
- API start success alone does not settle Native Replanning;
- only positive admission of the intended successor Job Episode for the same Physical Assembly completes Recovery; and
- a later fresh Stall requires its own fresh Trail/Anchor evidence rather than reusing completed-Recovery history.

### Targeted in-game Reality validation

In-game validation is required for the live GIANTS assumptions on which this capability depends.

Initial Reality validation should include:

1. transient/native blocked signalling while the worker continues or resumes without intervention;
2. the demonstrated Condor boundary-associated Stall and direct return to the first/oldest retained compatible Anchor;
3. Transit request and settlement on materially different assemblies;
4. successful direct-start FIELDWORK Job replacement from the recovered pose, including truthful old/new Job Episode succession;
5. immediate GIANTS ownership of post-restart configuration and movement with no OMW restore tail;
6. absence or presence of a player-visible manual-stop notification when Recovery uses the supported nil-message stop lifecycle;
7. preservation of deliberately distinctive player-selected FIELDWORK parameters across replacement in a dedicated scenario;
8. a later independent obstruction under the successor Job Episode, proving that fresh Stall/Trail/Anchor evidence can admit a new Recovery cycle without historical retry permission; and
9. existing Cooperative Passage / Regulation cases, proving that independent traffic responsibilities and Supporting Speed Ceilings remain correctly scoped during Recovery.

### Outside this Specification's validation claim

A successful Recovery cycle does not prove that arbitrary scenery is navigable, that every future GIANTS route will succeed, that every player FIELDWORK setting has already been validated as preserved, that every environmental obstacle can be identified, or that a broader obstacle-bypass/repositioning capability exists.
