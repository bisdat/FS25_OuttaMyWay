# Blocked Worker Recovery Specification

## Identity and authority

**Specification Jurisdiction:** Blocked Worker Recovery  
**Jurisdiction ID:** `BLOCKED_WORKER_RECOVERY`  
**Implementation Status:** `NOT_IMPLEMENTED`

**Parent Jurisdiction:** [`Resolution Lifecycle`](RESOLUTION_LIFECYCLE.md)  
**Primary Architecture Authority:** [`architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#specification-jurisdiction--blocked-worker-recovery)

This Specification owns the implementation-facing contract for the single-subject **Resolution Commitment** that performs one bounded physical recovery excursion for a still-active GIANTS worker after current Situation evidence has established a **Blocked Progress Stall**.

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

A Job replacement/restart, Player Claim, incompatible OuttaMyWay actuation, native direction-transition discontinuity or material assembly/configuration discontinuity MUST invalidate the prior Trail for the current recovery question when it breaks Recovery Approach continuity.

The **Recovery Anchor** MUST identify the most recent positively realised Trail state in that Approach that remains fit and spatially useful as a bounded return reference. Anchor fitness MUST preserve:

- Physical Assembly identity;
- Job Episode identity;
- movement-direction continuity relevant to the failed native excursion;
- ownership continuity;
- material configuration/articulation relevance;
- representation relevance; and
- absence of a positive known blockage-associated spatial contradiction already implicating that candidate Anchor state.

A Job replacement/restart, Player Claim, incompatible OuttaMyWay actuation, native direction-transition discontinuity or material assembly/configuration discontinuity MUST invalidate the prior Anchor for the current recovery question when it breaks that continuity.

Anchor selection MUST NOT simply choose the latest retained sample if it is already positively implicated in the blockage-associated spatial condition or is not spatially useful for a coherent bounded excursion. Assessment may walk backward within the bounded Trail to the most recent fit witness; it MUST NOT widen retention or reconstruct older history merely because no useful Anchor exists.

> **Insufficient Anchor Span != Permission to Retain Productive History.**

Anchor age alone MUST NOT establish or destroy fitness.

> **Last Unblocked Pose != Recovery Anchor.**

> **Recovery Anchor != Known Safe Pose.**

The Anchor bounds return provenance and direction. It MUST NOT be promoted into generic negative-clearance authority, arbitrary reverse-feasibility authority or an exact historical waypoint that Control must point-seek.

## Recovery Excursion contract

### One generic bounded release attempt

The initial Blocked Worker Recovery capability owns one generic bounded **Recovery Excursion** under one Recovery Resolution.

The excursion MUST:

- remain local to the Recovery Approach / Recovery Anchor domain;
- use a supported local release direction back toward recently demonstrated traversal;
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

Supplementary evidence MAY strengthen the release direction or establish an earlier Recovery Point. It MUST NOT be required merely to prove an obstacle identity.

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

### Release direction and movement envelope

The Recovery Excursion MUST use the Recovery Anchor / recent realised approach to establish which local direction represents retreat from the failed native progression.

The initial capability MUST NOT reconstruct the complete historical GIANTS path, synthesize a turning centre, steer around a guessed obstacle or point-seek an arbitrary world-space destination.

Where the failed approach was curved or turning, the Recovery Anchor bounds the return domain while current local realised approach direction MAY provide the immediate release axis. Detailed manoeuvre-sweep reconstruction remains outside this contract.

The granted movement envelope MUST remain no broader than the currently supported local release purpose.

## Recovery Point, settlement and handback

### Recovery Point

The **Recovery Point** is the bounded physical endpoint at which the specialised Resolution's one Recovery Excursion obligation has been discharged.

Where a positive blockage-associated spatial condition exists, fresh Reality MAY establish the Recovery Point earlier when that known condition is positively released or sufficiently reduced under the purpose-specific contract.

Where blockage cause remains unresolved, the Recovery Anchor bounds the available return domain and the authorised excursion MUST NOT extend beyond it merely to seek a better location.

The exact implementation movement calibration within that bounded domain is not architectural policy unless later evidence promotes a literal into the contract.

### Positive Resolution satisfaction

Blocked Worker Recovery's terminal-dependent obligation is **not** to prove permanent GIANTS productive success.

The obligation is positively satisfied when current evidence establishes that:

- the authorised Recovery Excursion reached its supported Recovery Point;
- owned recovery movement has stopped;
- intervention-created configuration debt has been restored or otherwise discharged according to the accepted mechanism contract;
- OuttaMyWay-owned physical effects for the Recovery Resolution have been relinquished; and
- control has been handed back to GIANTS for the still-current qualifying Job Episode.

These are positive settlement facts and satisfy the parent Resolution Lifecycle's positive-settlement requirement.

> **Recovery Completion Belongs to OuttaMyWay; Subsequent Native Success Belongs to Reality.**

The Resolution MUST NOT retain Control merely to wait for a positive GIANTS speed, course-progress or productive-continuation witness after handback.

### Failure before Recovery Point

If Transit cannot establish a coherent settled configuration, current Bounded Authority cannot support movement, Control cannot realise the granted movement, the Recovery Anchor becomes invalid, a higher-authority claim intervenes, or no supported local release remains, the implementation MUST fail closed.

Such failure MUST NOT cause Control to invent:

- another obstacle-specific route;
- a wider relocation target;
- an unbounded reverse/forward search;
- a second independent autonomous Recovery Excursion; or
- environmental object semantics unsupported by current evidence.

A parent-consistent failure or escalation route, including Player Intervention where appropriate, may then become eligible from fresh evidence.

## Post-handback Recovery Recurrence

### Passive recurrence observation

After positive recovery settlement and handback, a bounded passive **Recovery Recurrence** watch MAY retain only the evidence necessary to classify whether the simple recovery hypothesis is subsequently disproved.

The recurrence watch:

- is not a Current Responsibility;
- owns no Bounded Authority;
- MUST NOT delay GIANTS handback;
- MUST NOT preserve the completed Recovery Resolution;
- MUST NOT authorise a second Recovery Excursion; and
- MUST remain bounded in evidence lifetime and scope rather than becoming Productive History.

> **Bounded Witness Retention != Productive History.**

### Recurrence classification

A subsequent Blocked Progress Stall MAY be classified as a **Recovery Recurrence** only when current evidence establishes at least:

- the same Physical Assembly;
- the same qualifying Job Episode;
- a new positive Blocked Progress Stall;
- occurrence within a bounded post-handback recurrence interval; and
- occurrence within a bounded spatial neighbourhood of the prior blockage / Recovery context.

Supplementary matching evidence MAY strengthen the classification but is not mandatory.

The exact recurrence duration and spatial radius are implementation/validation calibration values, not architectural policy.

If the bounded watch expires without Recovery Recurrence, the recovery attempt is classified successful for this capability and the watch expires quietly. This success classification is retrospective and MUST NOT be used as a pre-handback Control gate.

If Recovery Recurrence is positively established:

> **Recovery Excursion Completed != Native Path Problem Resolved.**

The simple one-excursion recovery hypothesis is disproved for that encounter. The recurrence MUST NOT automatically loop back into another autonomous Recovery Excursion. Fresh Situation/Decision evidence must select any later supported response; absent broader accepted capability, Player Intervention remains legitimate.

## Durable invariants

### GIANTS retains productive-job ownership

Blocked Worker Recovery temporarily acquires bounded physical responsibility for release from a native stall. It MUST NOT terminate/restart the GIANTS Job Episode merely to obtain player-like control and MUST NOT take ownership of productive routing or normal navigation.

### Obstacle identity is optional

A positive Blocked Progress Stall plus fit recovery evidence can justify one bounded Recovery Excursion without identifying the blocking object. Unknown cause MUST remain unknown rather than being guessed from persistence, boundary proximity or scenery expectations.

### One Recovery Resolution does not become a recovery loop

The first supported capability is one bounded excursion followed by restore and handback. Recurrent blockage is new evidence that the simple hypothesis failed, not implicit permission to repeat the same intervention indefinitely.

### Responsibility continuity and physical permission remain distinct

The Recovery Resolution MAY remain current while current Bounded Authority is temporarily unavailable. Fresh positive contradiction can quiesce or revoke movement permission without inventing a new strategic purpose.

### No negative-clearance promotion

DISC geometry, Demonstrated Traversability, Field World geometry and absence of a represented conflict MUST retain their existing claim limits. This Jurisdiction does not promote generic negative-clearance authority.

## Publication contract

Blocked Worker Recovery follows the shared Log Publication support-escalation contract. Publication is observability, not semantic authority, and MUST NOT alter Stall admission, Candidate selection, Recovery persistence, Bounded Authority or Control.

### NORMAL — sparse lifecycle/intervention journal

Responsibility Transition owns the purpose-specific operational lifecycle events:

- `BLOCKED_WORKER_RECOVERY_STARTED` when Recovery Current Responsibility is positively established; and
- `BLOCKED_WORKER_RECOVERY_ENDED` when that Current Responsibility is authoritatively terminated after settlement, supersession, failure or escalation.

The NORMAL payload SHOULD include the authoritative Operation identity when available, the Recovery responsibility/commitment identities, the recovering assembly and a stable reason/outcome.

Recovery Recurrence classification by itself is not a periodic NORMAL heartbeat. If recurrence or another terminal condition positively establishes that autonomous continuation is exhausted and player action is required, the owning lifecycle publishes the existing NORMAL `PLAYER_INTERVENTION_REQUIRED` event.

### DEBUG — bounded causal narrative

DEBUG may publish transition/change evidence sufficient to explain why Recovery was or was not attempted, including positive Blocked Progress Stall establishment, Recovery Anchor selection/invalidation, Candidate rejection/selection, Bounded Authority refusal/revocation, Transit settlement, Recovery Point establishment, handback settlement and Recovery Recurrence establishment.

DEBUG MUST remain change/transition-driven. It MUST NOT emit the same unchanged Stall, Anchor, residual or control phase every runtime cycle merely because Recovery remains current.

### DIAGNOSTIC — targeted engineering evidence

DIAGNOSTIC may expose detailed motion samples, observation-interval displacement, represented geometry, anchor fitness components, release-axis/residual calculations and other intermediate evidence needed to investigate a specific unresolved Recovery question.

Such evidence is produced only by an independently justified diagnostic instrument or already-existing evidence source. DIAGNOSTIC publication eligibility does not authorise continuous expensive measurement, and suppressed publication MUST avoid publication-only projection work.

> **Recovery Observability != Recovery Authority.**

## Failure and uncertainty semantics

- **Raw `isBlocked` with continuing realised progress** — no Blocked Progress Stall; no Recovery admission.
- **Blocked assertion plus insufficient motion evidence** — remain unresolved; do not use timeout as proof.
- **Blocked Progress Stall but no fit Recovery Anchor** — no autonomous Recovery Excursion.
- **Recovery Anchor fit but current movement permission contradicted** — preserve the Resolution only while its obligation remains legitimate; do not move without current Bounded Authority.
- **Transit unsettled/unrealizable** — fail closed; do not move in an assumed compact state.
- **Recovery Point reached and restore/handback positively completed** — settle the Recovery obligation and end the Resolution through Responsibility Transition.
- **No Recovery Recurrence through the bounded passive watch** — classify the attempt successful for this capability; expire the watch.
- **Recovery Recurrence** — simple recovery hypothesis disproved; do not automatically repeat.
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

This Jurisdiction specialises `RESOLUTION_LIFECYCLE`. Its bounded excursion/restore/handback obligation, persistence and terminal dispositions MUST remain parent-consistent.

### Bounded Authority

Every positive Transit/configuration and release-movement effect requires current purpose-specific Bounded Authority. A retained Recovery Resolution or Recovery Anchor is not physical permission.

### Control

Control executes only the granted Transit/configuration, movement, restoration and relinquishment effects. Control outcomes return through Reality and Observation; Control does not decide Blocked Progress Stall admission or Recovery Recurrence.

## Current implementation gap — purpose-specific decision horizon

Production `Runtime:processLiveObservation()` currently detects any active Resolution through one generic boolean and changes the prospective support path on that basis. That implementation shape is too coarse for Blocked Worker Recovery because Recovery must preserve its single-subject Resolution while independent traffic negotiation remains live.

The implementation increment MUST replace generic Resolution-existence inference with purpose-compatible continuation/selection semantics. It MUST NOT add Recovery-specific traffic rules, and it MUST preserve Cooperative Passage's accepted Bubble decision horizon.

Production Observation also currently publishes `jobEpisodeEvidence.outtaMyWayHold=false` unconditionally. That placeholder MUST NOT be used as positive evidence that OuttaMyWay did not cause quiescence. Recovery admission must use truthful current semantic/actuation ownership until Observation owns a truthful equivalent field.

## Contract participants

| Production source | Participation |
| --- | --- |

No production source currently participates. This Specification is authoritative but `NOT_IMPLEMENTED`.

## Implementation traceability

There is intentionally no production implementation trace yet.

Existing mechanisms such as Transit configuration and native drive actuation are potential subordinate implementation assets only. Their existence does not make this Jurisdiction implemented, and future implementation MUST classify only source that materially participates in the accepted contract.

## Validation route

### Structural/source-contract validation

Before implementation is accepted, structural validation must prove that the Jurisdiction identity, specialisation, primary Specification route and `NOT_IMPLEMENTED` state remain coherent and that no production source falsely acknowledges `BLOCKED_WORKER_RECOVERY`.

When implementation begins, the same increment must remove `NOT_IMPLEMENTED`, declare truthful production participants and add reciprocal source Jurisdiction acknowledgements.

### Offline behavioural/conformance validation

Future offline validation should challenge at least:

- raw blocked spam while realised progression continues does not admit Recovery;
- a positive Blocked Progress Contradiction can admit one Recovery Resolution;
- OMW-caused quiescence does not recursively admit Recovery;
- bounded Recovery Approach Trail sampling/retention remains purpose-specific and does not become Productive History;
- Recovery Anchor invalidation on identity/lifecycle/direction/configuration discontinuity;
- Anchor selection may choose the most recent spatially useful fit Trail witness rather than the newest sample;
- absence of known conflict does not become negative-clearance authority;
- mandatory Transit request occurs before recovery movement;
- current positive spatial contradiction can veto/narrow movement;
- Recovery Point/restore/handback positively settles the Resolution without waiting for later GIANTS success;
- recurrence observation is passive and cannot acquire Control; and
- Recovery Recurrence does not automatically admit another Recovery Excursion.

### Targeted in-game Reality validation

In-game validation is required for the live GIANTS assumptions on which this capability depends.

Initial Reality validation should include:

1. transient/native blocked signalling while the worker continues or resumes without intervention;
2. the demonstrated Condor boundary-associated stall, including DISC/Field World supplementary evidence where available;
3. an unknown-cause environmental blockage where obstacle identity is not available to OuttaMyWay;
4. forward and reverse blocked-entry cases;
5. a current represented traffic party entering the proposed release domain and correctly preventing unsafe autonomous movement;
6. Transit request and settlement on materially different assemblies;
7. successful one-excursion handback with no recurrence;
8. same-locus recurrence within the bounded recurrence context, proving that the simple recovery hypothesis can be disproved without autonomous retry; and
9. existing Cooperative Passage / Regulation blockage cases, proving they remain owned by their governing responsibilities rather than being misclassified as Blocked Worker Recovery.

### Outside this Specification's validation claim

A successful Recovery Excursion does not prove that arbitrary scenery is navigable, that the underlying GIANTS route is permanently corrected, that every environmental obstacle can be identified, or that a broader obstacle-bypass/repositioning capability exists.
