# ADR-0023 — Traffic Policeman and Encounter-Relative Movement Priority

## Status

Accepted architectural concept and refinements; canonical through v4.7.33 and further consolidated by the v4.7.34 Traffic Policeman Decision Ordering candidate. Production Decision/Commitment/Control implementation remains absent.

## Context

ADR-0022 established Bounded Native Intent Revelation (BNIR): while a Commitment remains responsible, OuttaMyWay may, when independently admissible, grant bounded GIANTS-native motion so Reality can reveal a held participant's actual Local Intent. Subsequent discussion exposed a missing Decision responsibility. BNIR itself cannot decide which participant may consume contested space, whether a slow revelation participant is becoming an obstacle, whether temporary Yield/Progress roles should transfer, or whether repeated role transfer is genuine resolution progress.

The same discussion also exposed two over-broad readings that would make Safe Release impractical:

- `SETTLED_CONTINUATION` cannot mean spatial safety by itself; it is a native lifecycle/evidence state.
- Continuation Safety Horizon cannot be an indefinitely rolling requirement to witness every future manoeuvre of every still-active participant. It must remain bounded to unresolved continuation consequences materially belonging to the governing Encounter and its interventions.

## Decision

Accept **Traffic Policeman** as the Decision-level responsibility that assigns, preserves and revises temporary movement priority between participants of one Encounter.

Traffic Policeman does **not** route, steer, choose GIANTS work order or replace native AI. It determines which participant currently has movement priority and which participant must Yield so that Decision can authorise only bounded capabilities compatible with the current Operational Picture.

Conceptually:

```text
Situation Assessment
        ↓
current Local Intent / Current Space / Future Space / uncertainty
        ↓
Traffic Policeman (Decision responsibility)
        ├── PROGRESS — current movement priority
        └── YIELD    — must preserve Progress demand
                ↓
        bounded capability authority
                ↓
GIANTS retains native route and steering
```

### Temporary traffic roles

`PROGRESS` and `YIELD` are temporary Encounter roles, not permanent vehicle identities. They are recalculated from current Reality and may transfer within one Commitment when the transfer demonstrably reduces unresolved obligations or creates a more admissible path to settlement.

Movement priority is not ownership of the field or a route. A Progress participant may still be constrained by Field World, Physical Assembly, Representation Fitness, other Commitments and Safe Release obligations.

### Settled continuation is a lifecycle gate, not clearance

An authoritative `SETTLED_CONTINUATION` means that the participant again provides a stable native Local Intent that Situation Assessment can represent. It does not mean that the participant is spatially safe relative to another assembly.

For a participant to act as a stable Progress reference for BNIR or another bounded Yield action, Decision additionally requires supported spatial compatibility: the Progress participant's current supported continuation corridor must not materially intersect the Yield participant's current occupancy or the proposed bounded Action Space.

If the Progress participant enters `TURNING`, its supported corridor changes, or other evidence becomes unresolved, authority derived from the prior settled reference expires and the Yield participant must return to or remain under a safe bounded state such as Hold. No timer or arbitrary grace period substitutes for this evidence change.

### BNIR participants remain physical obstacles

A participant under BNIR is not exempt from ordinary Physical Assembly relevance. Low speed bounds rate of motion; it does not confer priority, guarantee spatial safety or teach GIANTS to route around it.

Therefore BNIR may continue only while its bounded Action Space preserves the Progress participant's supported demand. If revelation motion would consume that corridor, BNIR authority expires and Decision must re-Hold/reassess rather than waiting for GIANTS to become blocked.

### Bounded Native Intent Revelation completes on evidence, not travel literal

The v4.7.26 1 km/h ceiling and 2 m proving movement remain experimental fixture parameters. Production BNIR should terminate or transition when its evidence contract obtains fresh authoritative native Local Intent, or when admissibility/evidence fails. It is not a fixed-distance creep manoeuvre.

### Demonstrated Traversability

Accept **Demonstrated Traversability** as a bounded positive-evidence source for spatial admissibility. Actual successful occupation or traversal by the real Physical Assembly is evidence that all physically effective parts of that assembly fitted within that local space under the configuration and movement conditions actually experienced, even if synthetic inventory/coverage knowledge is incomplete.

This evidence is applicable only while its material basis remains valid, including:

- materially equivalent Physical Assembly configuration;
- materially unchanged local Field World;
- no new dynamic participant occupying or claiming the relevant corridor;
- proposed Action Space remaining within the demonstrated local domain;
- no materially different articulation, configuration sweep or kinematic demand.

Demonstrated Traversability proves local spatial accommodation, not arbitrary reverse feasibility, arbitrary future manoeuvres, permanent release of space or current availability against another worker. It does not abolish the Known-Coverage Trap outside its demonstrated domain.

Two currently relevant examples are:

1. **Interrupted settled continuation:** if OuttaMyWay temporarily Holds/configures a worker during an otherwise authoritative settled continuation and no material environmental/operational discontinuity occurs, the previously admissible continuation supplies local continuity evidence until GIANTS reveals a materially different intent.
2. **Refuge return domain:** when the actual compact Physical Assembly successfully traversed into a refuge, that traversal positively demonstrates the spatial corridor used by that real assembly/configuration. A later return may reuse that evidence only while the corridor remains available and the proposed kinematics remain materially compatible.

### Revelation Oscillation is not progress

Define **Revelation Oscillation** as a failure mode in which successive Control transfers repeatedly invalidate the currently authoritative Local Intent used to reveal the other participant, causing unresolved intent to alternate between participants without reducing the governing Encounter's obligations.

A legitimate Traffic Policeman role transfer must therefore produce architectural progress: it must reduce, settle or make independently supportable at least one unresolved obligation or materially improve admissible resolution capability. Merely swapping which worker is held/unknown is not progress.

### Encounter-relative Continuation Safety Horizon

Refine Continuation Safety Horizon as **Encounter-relative**. Its purpose is to cover unresolved continuation consequences materially belonging to the governing Encounter and to OuttaMyWay interventions used to resolve it. It does not advance indefinitely through every subsequent manoeuvre of every participant merely because the workers remain active on the field.

A new Local Intent epoch remains inside the same Encounter while it is materially coupled to unresolved interaction or intervention obligations. Once the current Commitment reaches Safe Release, a later materially new convergence may form a fresh Encounter under ADR-0012.

For the current cooperative Hold-release pattern this can include:

```text
original convergence
    ↓
Yield Hold / refuge
    ↓
Progress continuation → material manoeuvre → subsequent settlement
    ↓
BNIR resolves Yield participant's post-intervention intent uncertainty
    ↓
joint reassessment
    ↓
remaining restoration / handover / Safe Release obligations
```

The Yield participant is not required to travel to an unrelated future field boundary and demonstrate every later manoeuvre before the current Encounter may settle.

### Encounter Maturation

Accept **Encounter Maturation** as a Traffic-Policeman Decision pattern for ambiguous interactions whose native evolution can safely produce better evidence or a simpler resolution state. Instead of inventing a complex manoeuvre before GIANTS reveals its own continuation, Decision may preserve bounded native progression while Reality is expected to do one of three things:

1. dissolve the material interaction naturally;
2. reveal a simpler authoritative interaction state that existing resolution policy can handle; or
3. demonstrate that continued maturation is exhausting useful Action Space and stronger intervention is now required.

Encounter Maturation is not a rule that complex encounters must become head-on. A head-on is only one currently well-understood mature state. Where current Action Space already supports a simpler resolution, especially in less constrained mid-field situations, Decision must not delay solely to reach a familiar implementation case.

Maturation is governed by the existing Bounded Observation Contract. Decision must identify the Knowledge gap, expected Reality evolution, useful option preserved while waiting, exhaustion condition, reassessment boundary and Progress participant capable of generating the evidence. `CONTINUE_OBSERVATION` or purpose-bound `REGULATE_SPEED` may preserve maturation margin; passive delay is inadmissible.

### Productive Continuation Preference

Accept **Productive Continuation Preference** as a Traffic-Policeman preference for otherwise-roomy non-headland encounters. When current Knowledge positively supports one participant as executing Productive Continuation and another as executing Transitional Continuation, Traffic Policeman should first prefer the productive participant for `PROGRESS` and the transitional participant as the `YIELD` candidate. The purpose is to preserve useful GIANTS productive work while resolving a cheaper transitional conflict; the preference does not reassign native work order or route ownership.

The preference is subordinate to current Action-Space viability and Commitment obligations. It does not govern when yielding the transitional participant would strand it, materially compress Action Space, invalidate a necessary native manoeuvre or otherwise make resolution harder. In those circumstances ordinary Encounter Maturation / Preference-Band Exhaustion reasoning may preserve the transitional participant as `PROGRESS`, including the established TS016 headland pattern.

When both participants are Productive, both are Transitional, or the relevant productive state is unresolved, this preference supplies no role decision. Absolute speed, vehicle class, implement width, arrival order and similar fixture heuristics are not authorised tie-breakers.

Prototype 21 supplies the current empirical seam rather than architectural API coupling: Condor productive work remained line `ACTIVE` under both normal and deliberately low cruise limits, and Valtra S 416 + lime-spreader productive passes reproduced line `ACTIVE` across a different native working envelope. Both assemblies exposed line `INACTIVE` during GIANTS transition segments. `turn=true` also covered diagonal and reversing reposition behaviour, so it must not be equated with a literal geometric/headland turn. Situation Assessment should use coherent positive GIANTS-native evidence and publish `UNRESOLVED` when that evidence is not fit.

A Transitional participant retains full Physical Assembly and Future Space relevance. GIANTS may increase separation and later reverse into recently vacated space while the same Job Episode continues (**Apparent Departure Reversal**). Therefore Yield preference is not reduced spatial authority, and apparent departure cannot establish Safe Release.

### Productive-state evidence is asymmetric and speed ordering is non-authoritative

Prototype 21 now spans Condor, Valtra/lime spreader, John Deere 8RX/cultivator and Valtra/reversible plough. Coherent active GIANTS work-line state is demonstrated positive evidence for Productive Continuation across these fixtures. However, short non-turn inactive-line boundary states occur before a new productive line establishes, so inactive line state alone is not positive Transitional authority. Decision consumes Situation Knowledge only after Situation Assessment has corroborated the continuing native transition or returned `UNRESOLVED`.

**Native Speed-Ordering Variability** further prohibits speed-based priority. The reversible plough worked at ~12.2 km/h while its transition reached ~15 km/h. Neither “slower yields”, “faster progresses” nor any comparison of productive/transitional speed envelopes is an authorised role rule.

A footprint-changing Transitional participant may be the first Yield candidate under Productive Continuation Preference, but Traffic Policeman must still confirm that the current transition contains a supportable interruption state. **Alternating Working-Side Configuration** means line inactivity can coincide with a material configuration sweep whose Action Space must be preserved.

### Action-Space Compression

Name **Action-Space Compression** as the physical reduction of currently supportable resolution options caused by Field World constraints, Physical Assembly geometry, participant Committed/Potential Demand and evolving native manoeuvres. It is a derived phenomenon, not a new root space, encounter taxonomy, actuator or numeric score.

Encounter shape alone therefore does not define complexity. The TS016 headland-cross case is difficult because field-edge geometry and interacting demands constrain the available rearrangement space; an equivalent crossing in open mid-field may retain substantially more Temporary Slack and more admissible alternatives.

Action-Space Compression relates to, but is distinct from, **Preference-Band Exhaustion**:

- Action-Space Compression describes the physical evolution of available options;
- Preference-Band Exhaustion describes Decision progressively losing preferred supportable candidates and moving to lower-preference survivors.

Traffic Policeman should prefer actions that preserve or expand supported Action Space. Bounded native progression is attractive when it is expected to relieve compression; it becomes inadmissible when waiting is instead consuming the remaining options needed for safe resolution.

## Static-object boundary

Static-object recovery/avoidance is deliberately parked for separate architectural analysis. BNIR and Traffic Policeman must not silently generalise into an assumption that GIANTS can avoid stationary obstacles or that OuttaMyWay can always automate a safe bypass. Future analysis may conclude that some or all such cases require additional architecture or player intervention.

## Relationship to existing architecture

- **ADR-0001:** preserved. GIANTS retains route and steering ownership.
- **ADR-0006:** refined. Safe Release remains positive; Continuation Safety Horizon is Encounter-relative rather than indefinitely rolling.
- **ADR-0012:** refined. Yield/Progress roles remain dynamic and later convergence after true Safe Release receives fresh Encounter identity.
- **ADR-0019:** preserved. Traffic Policeman is a Decision responsibility that may participate in the selection which creates a Commitment; once a Commitment governs, traffic purposes/capabilities remain subordinate to its Objective and Obligations. Multi-stage capability changes do not create new Commitments by convenience.
- **ADR-0022:** refined. BNIR is authorised by Decision under traffic priority, remains a physical obstacle, completes on evidence rather than a fixed travel literal, and may rely on Demonstrated Traversability when its bounded applicability is positively supported.

## Consequences

- Decision now has an explicit architectural home for right-of-way without becoming a route planner.
- `SETTLED_CONTINUATION` is protected from accidental redefinition as clearance.
- BNIR can be stopped before becoming a slow obstacle to the Progress participant.
- Temporary role transfer is allowed, but repeated uncertainty-swapping is explicitly non-progress.
- Recent real traversal can provide stronger local physical-admissibility evidence than incomplete synthetic geometry, within a tightly bounded unchanged domain.
- Safe Release remains distinct from capability release, BNIR completion and native handover.
- No production Decision, Commitment or Control implementation is authorised by this ADR.

## v4.7.29 amendment — staged refuge recovery and purpose-bound protection

### Progress priority is not exclusive movement authority

`PROGRESS` preserves the participant whose useful authoritative native demand currently provides the stable traffic reference. It does not mean that only Progress may move and it does not entitle Progress to unrestricted speed. A `YIELD` participant may receive bounded admitted movement, including refuge ingress/restoration or BNIR, while remaining subordinate to Progress demand.

### Pure head-on requires a positively available recovery corridor

For the classic two-worker pure head-on, successful egress must lead to a genuinely available return/ingress opportunity. Passage of the original conflict point is insufficient by itself because the Progress participant's next material manoeuvre may still consume the recovery corridor. Yield remains protected until current Progress occupancy and supported settled demand positively permit the proposed ingress Action Space.

### Admitted recovery creates demand that must be preserved

Once Decision admits a bounded recovery Action Space, the space required by the current ingress/restoration stage is Committed Demand. Traffic Policeman must preserve compatibility between that admitted recovery demand and Progress demand until the stage completes, is superseded or is revoked as no longer admissible. This does not grant Yield equal or permanent traffic priority.

### Progress may be speed-regulated without becoming Yield

If unrestricted Progress motion would consume an already admitted Yield recovery opportunity, Decision may use `REGULATE_SPEED` as a purpose-bound supporting capability while Progress retains right-of-way. The authority is tied to a named current purpose, not a fixed post-passage distance, speed or duration. It ends as soon as unrestricted Progress continuation is compatible with the remaining admitted recovery demand unless another independently justified current obligation requires regulation.

Ingress completion may retire ingress demand while restoration/unfolding demand remains active. Condor's observed full boom unfolding time of approximately 15 seconds is evidence only; it must never become an architectural timeout or default lease duration. **Protect the recovery obligation, not the clock.**

### BNIR and Native Handover are separate evidence stages

BNIR intent acquired while compact/transit may guide the next stage but is not presumed authoritative through re-Hold or material configuration restoration. Native Handover must reacquire fresh operational Local Intent and independent GIANTS continuation after restoration. Only after current obligations are settled and the supported A/B operational demands are positively decoupled may the governing Commitment reach Safe Release.

### Obligation retirement defines progress

The reference head-on sequence demonstrates architectural progress by retiring named obligations in order: shared-corridor obstruction, passage uncertainty, Progress manoeuvre consequence, ingress availability, Yield recovery, counterfactual intent, work restoration, independent continuation and final traffic coupling. No numeric progress score is required. Capability churn or role swapping that does not reduce this obligation set remains Revelation Oscillation/non-progress.


## v4.7.34 amendment — bounded lifetime, Purpose provenance and sequential authority

### Normally dormant traffic authority

Traffic Policeman is an omnipresent Decision responsibility but is normally dormant. Ordinary compatible GIANTS traffic does not require temporary `PROGRESS`/`YIELD` direction. The responsibility becomes active only while current Reality requires decisive temporary movement ordering to protect supported demand or remaining Action Space, and becomes dormant as soon as unrestricted cooperative continuation is again supportable. This lifetime is narrower than Encounter or Commitment lifetime: restoration, Native Handover, evidence and terminal-settlement obligations may continue after the whistle is figuratively put away.

### Candidate Purpose derives authority; it does not create it

Candidate `Purpose` is the action-level operational result sought by the candidate. It is not Situation Knowledge and does not independently create a governing objective. Before a Commitment exists it must be traceable to current admitted native intent, the Operational Picture and accepted Decision policy. Once a Commitment governs, candidate Purpose must remain compatible with its Objective and unresolved Obligations unless an explicit lifecycle decision changes that basis. Candidate generators publish the field; they do not own objective policy.

### Strict primary preference sequence

After mandatory candidate admissibility, Traffic Policeman applies the following primary preference strictly:

```text
CONTINUE_OBSERVATION
→ REGULATE_SPEED
→ HOLD_AT_SAFE_POINT
→ NATIVE_REPOSITION
```

This is sequential **Decision preference**, not procedural try/fail Control. A later band may receive primary resolution authority only after every preceding band is explicitly exhausted against the same current governing traffic requirement in the same Decision epoch. Current Knowledge may prove exhaustion without actuating the rejected candidate. A material Reality or Control Outcome invalidates the previous epoch's exhaustion proof and causes fresh evaluation from the least-disruptive end. An earlier-band capability may still support a stronger primary Commitment when a separate current obligation justifies it, such as purpose-bound Progress regulation protecting admitted Yield recovery demand.

### Observe — learn while room to wait remains

Traffic Policeman Observe consumes Situation Assessment Knowledge about whether the interaction is improving, dissolving or becoming more authoritative, and whether supported Action Space is stable/expanding or compressing. Observe remains admissible only while useful evidence is expected to emerge and sufficient Action Space remains to wait for it. Observe exhausts when either Reality is sufficiently coherent for decisive direction **or** uncertainty remains but waiting longer would consume a necessary option. No universal conflict-probability threshold or compression scalar is introduced.

### Regulate — bounded GIANTS-owned progression

`REGULATE_SPEED` is not merely generic slowing. It is bounded native progression: Traffic Policeman may permit a participant to proceed or creep while GIANTS retains native route, steering and forward/reverse choice. Regulation may preserve Action Space, expose native intent, let a transition clear or protect Committed Demand. BNIR is a specialised evidence-acquisition composition that proves the broader capability principle without becoming synonymous with ordinary Regulation.

Regulation remains preferred while some positively supportable non-zero GIANTS-native movement can satisfy or preserve the current traffic purpose. It exhausts when useful movement itself must cease, when slowing would prolong harmful occupancy, or when the incompatibility is inherently spatial and creep provides no useful evidence/resolution. A pure established head-on is the reference case: reducing speed may preserve margin before spatial commitment, but cannot create passing space once the shared-corridor incompatibility is authoritative.

### Hold — current occupancy is the waiting place

`HOLD_AT_SAFE_POINT` means **stop here**. The participant's current realised Physical Assembly occupancy must itself be a supportable stationary waiting state outside incompatible Current/Future/Committed Demand while useful progress or evidence remains available elsewhere. Stopping capability alone is not Hold admissibility; an in-path Hold that leaves the other GIANTS worker unable to route around it is Static Obstacle Conversion.

Movement required to create a new waiting occupancy is not hidden inside Hold. If bounded GIANTS progression can still reach a useful interruption condition, Regulation remains preferred. If OuttaMyWay must choose and authorise a spatial displacement to create a waiting occupancy, Hold is exhausted and Reposition is considered.

### Reposition — create a supportable waiting occupancy

`NATIVE_REPOSITION` is the spatial preference used when the current Reality contains no sufficient Hold for the current traffic requirement. It normally authorises one bounded Manoeuvre Leg to a Settled Movement Boundary, after which fresh Reality is reassessed and the resulting occupancy may become Hold.

Reposition is direction-agnostic. Forward, reverse and composed bounded movement are architecturally valid candidate properties where the Physical Assembly, complete movement/configuration sweep, Field World containment, capability evidence and Representation Fitness support them. Direction itself does not establish preference. Reverse Actuation Discovery remains implementation/evidence work; an unsupported reverse candidate is `UNRESOLVED`, not active authority and not an architectural prohibition.

Reposition exhaustion is participant-complete. Failure of the initially preferred Yield participant's spatial candidates does not establish band exhaustion. Traffic Policeman must consider supportable candidates under the alternate admissible role assignment before concluding that autonomous spatial resolution is unavailable. Role transfer remains a Decision and must satisfy the existing progress/Revelation-Oscillation rules; it is not an in-leg target change.

### Explicit escalation

Only after Observe, Regulate and Hold are exhausted and the complete currently supportable Reposition Candidate Action Space is exhausted across admissible role assignments may Traffic Policeman conclude that autonomous traffic resolution is unavailable. Explicit escalation/player intervention is then preferable to inventing unsupported movement authority. Player takeover remains external physical agency; internal Commitment obligations do not silently transfer to the player.
