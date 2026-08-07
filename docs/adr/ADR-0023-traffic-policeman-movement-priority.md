# ADR-0023 — Traffic Policeman and Encounter-Relative Movement Priority

## Status

Accepted architectural concept and refinements; documentation-only consolidation in v4.7.28 candidate. Production Decision/Commitment/Control implementation remains absent.

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

## Static-object boundary

Static-object recovery/avoidance is deliberately parked for separate architectural analysis. BNIR and Traffic Policeman must not silently generalise into an assumption that GIANTS can avoid stationary obstacles or that OuttaMyWay can always automate a safe bypass. Future analysis may conclude that some or all such cases require additional architecture or player intervention.

## Relationship to existing architecture

- **ADR-0001:** preserved. GIANTS retains route and steering ownership.
- **ADR-0006:** refined. Safe Release remains positive; Continuation Safety Horizon is Encounter-relative rather than indefinitely rolling.
- **ADR-0012:** refined. Yield/Progress roles remain dynamic and later convergence after true Safe Release receives fresh Encounter identity.
- **ADR-0019:** preserved. Traffic Policeman is a Decision responsibility inside one governing Commitment; multi-stage capability changes do not create new Commitments by convenience.
- **ADR-0022:** refined. BNIR is authorised by Decision under traffic priority, remains a physical obstacle, completes on evidence rather than a fixed travel literal, and may rely on Demonstrated Traversability when its bounded applicability is positively supported.

## Consequences

- Decision now has an explicit architectural home for right-of-way without becoming a route planner.
- `SETTLED_CONTINUATION` is protected from accidental redefinition as clearance.
- BNIR can be stopped before becoming a slow obstacle to the Progress participant.
- Temporary role transfer is allowed, but repeated uncertainty-swapping is explicitly non-progress.
- Recent real traversal can provide stronger local physical-admissibility evidence than incomplete synthetic geometry, within a tightly bounded unchanged domain.
- Safe Release remains distinct from capability release, BNIR completion and native handover.
- No production Decision, Commitment or Control implementation is authorised by this ADR.
