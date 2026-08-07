# v4.7.30 Candidate — Encounter Maturation / Action-Space Compression

Current architecture now distinguishes geometric encounter shape from resolution difficulty. **Action-Space Compression** names the derived physical loss of supportable resolution options when Field World boundaries, Physical Assembly geometry, participant demand and evolving manoeuvres constrain the available rearrangement space. TS016 is therefore difficult because its headland/field-edge setting compresses options, not because crossing or turning is inherently a special encounter type.

**Encounter Maturation** is accepted as a Traffic-Policeman Decision pattern. When an admitted ambiguous interaction remains supportable, bounded GIANTS-native progression may be preserved so Reality can dissolve the interaction or reveal a simpler authoritative state. Maturation is controlled by the existing Bounded Observation Contract and must cease to be preferred when waiting consumes the Action Space needed for resolution. Early admission may therefore produce `CONTINUE_OBSERVATION` or purpose-bound `REGULATE_SPEED` rather than immediate Hold/reposition.

Action-Space Compression is related to existing Preference-Band Exhaustion but does not replace it: compression is the physical loss of options; exhaustion is Decision discovering that preferred supportable candidates have disappeared. No numeric compression score or encounter-shape decision table is authorised. A head-on is one useful mature state, not the objective; mid-field interactions with adequate slack must not be forced to mature into head-on for implementation convenience.

v4.7.30 remains documentation-only apart from release/version metadata and conformance tests. Production Decision remains passive, no live Commitment is applied, production Control remains disabled, and no Traffic Policeman/Encounter-Maturation actuator is introduced.

# Project Status

> **Current canonical:** v4.7.29 Staged Refuge Recovery / Purpose-Bound Traffic Protection Consolidation  
> **Canonical baseline:** v4.7.29 (`4b0fb07945ed6a1bf2911fd91c4101e788e5ccd7973cb0f577ffd064f95882b0`, Git `693075b9d9b9fcfa596170f2c38ca440ae139ab9`; 261 files)  
> **Current candidate:** v4.7.30 Encounter Maturation / Action-Space Compression Consolidation  
> **Control authority:** production Control disabled

## Established Reality

Owner-declared canonical v4.7.29 retains the live-validated v4.7.24 passive runtime foundation: native Local Intent → field-bounded Future Space → positive Encounter admission, current physical interaction as positive Encounter evidence, incomplete-membership evidence precedence, authoritative Job Episode termination/restart identity, passive Decision, no live Commitment and disabled production Control. It additionally canonicalises Bounded Native Intent Revelation, Traffic Policeman, Demonstrated Traversability, Revelation Oscillation and Encounter-relative Continuation Safety Horizon architecture while retaining the v4.7.26 evidence record; the superseded fixed-horizon TCPA/DCPA future predictor remains absent from active runtime and diagnostics.

The non-canonical v4.7.25 prerequisite probe remains evidence only. It confirmed that represented primitive completeness does not prove Coverage Closure and its attempted `getActiveSegmentData()`/`fieldCourse.segments` index association was invalid; raw tuple slots must preserve nil positions.

## v4.7.26 live evidence — PASS

The Single-Worker Transit Intent probe isolated one capability composition with Condor Endurance II on field 77 under FS25 1.21.1.0:

```text
same Job Episode
→ HOLD
→ compact/transit configuration
→ bounded GIANTS-native movement
→ native intent/progress observation
→ HOLD
→ restore OuttaMyWay-owned configuration mutations
→ verify restoration
→ full GIANTS handover
→ independent native continuation
```

The Job Episode remained `giants-ai-job-id:0`. Full compact configuration was confirmed before movement. GIANTS progressed at approximately 1.01–1.06 km/h under the experimental 1 km/h ceiling while native course progress advanced. The probe re-Held after an experimental 2 m proving movement (approximately 2.04 m actual), restored deployment/work state with zero verification mismatches, then observed independent same-Job native continuation. Candidate SHA-256: `43e0fc93fcd7810d8460d11e683ad05adef50ada545c8190a3394f015b260ec0`.

## v4.7.30 architecture consolidation

**Encounter Maturation** is accepted as a bounded Traffic-Policeman Decision pattern for ambiguous interactions. Native GIANTS progression may be preserved while Reality is expected to dissolve the interaction or reveal a simpler authoritative state, but only under the Bounded Observation Contract and only while supported resolution options remain available.

**Action-Space Compression** names the physical loss of supportable resolution options caused by Field World constraints, participant demand, assembly geometry and evolving manoeuvres. It explains why TS016's headland/field-edge crossing behaves like a sliding puzzle while similar mid-field geometry may retain more alternatives. The concept is derived and non-numeric.

Action-Space Compression complements **Preference-Band Exhaustion**: compression is physical evolution; exhaustion is Decision losing preferred supportable candidates. Early Encounter admission therefore does not require early aggressive Control. Observation or purpose-bound speed regulation may preserve maturation margin, but waiting becomes inadmissible once it consumes the options needed for resolution. A head-on is not a mandatory maturation target.

v4.7.30 is documentation-only apart from release/version metadata. Production Decision remains passive, no live Commitment is applied, production Control remains disabled, and no Encounter-Maturation actuator is introduced.

## v4.7.28 architecture consolidation

**Traffic Policeman** is accepted as the Decision-level responsibility for temporary movement priority inside an Encounter. It assigns/revises `PROGRESS` and `YIELD` roles without routing or steering; GIANTS retains native path/steering ownership. A settled Progress participant is a stable traffic reference only when its supported corridor is positively compatible with the Yield participant's occupancy/Action Space.

BNIR is refined accordingly: the revelation participant remains a real obstacle, low speed grants no priority, and BNIR authority expires when it would consume Progress demand or when the traffic reference becomes unresolved. BNIR completion is evidence-driven, not fixed to the v4.7.26 1 km/h / 2 m fixture.

**Demonstrated Traversability** is accepted as bounded positive local spatial-admissibility evidence from actual successful traversal by the real Physical Assembly. It remains applicable only within a materially unchanged demonstrated domain and does not create universal Coverage Closure.

**Revelation Oscillation** names non-progressive role swapping that alternates which participant is held/unknown without reducing unresolved Encounter obligations. Legitimate role transfer must measurably reduce/settle obligations or materially improve admissible resolution capability.

Continuation Safety Horizon is refined as **Encounter-relative** rather than indefinitely rolling. It covers unresolved continuation consequences materially belonging to the governing Encounter/interventions; later materially new convergence after true Safe Release may form a fresh Encounter.

Static-object recovery/avoidance is deliberately parked for future dedicated analysis. No current architecture assumes GIANTS can avoid a stationary obstacle or guarantees OuttaMyWay automation.

v4.7.28 is documentation-only apart from release/version metadata. Production Decision remains passive, no live Commitment is applied, production Control remains disabled, and no BNIR/Traffic Policeman actuator is introduced.

## v4.7.27 architecture consolidation

**Bounded Native Intent Revelation** is now accepted architecture. It permits a retained Commitment, when admissible, to grant GIANTS tightly bounded native motion sufficient to reveal actual post-intervention Local Intent rather than reconstructing the GIANTS route. A proven transit configuration may be used to reduce physical occupancy before evidence-gathering motion; OuttaMyWay remains responsible for its own configuration mutations and for reassessment.

This does **not** mean Hold release is Safe Release. The sequence remains:

```text
bounded native intent revelation
→ renewed Operational Picture
→ joint Future-Space / obligation reassessment
→ further capability, continued observation or Safe Release only when positively justified
```

The v4.7.26 speed and distance are proving literals only. Capability support must be established per Physical Assembly; Coverage Closure and manoeuvre-sweep representation remain unresolved.

## Parked boundary

Static-object recovery/avoidance remains deliberately parked for separate future architectural analysis. BNIR/Traffic Policeman must not be used as evidence that GIANTS can route around a stationary obstacle or that OuttaMyWay can always automate a bypass.

## Implementation boundary

v4.7.30 carries no live Traffic Policeman, Encounter-Maturation detector, BNIR actuator, purpose-bound speed lease or other physical Control path into the active replacement core. Runtime behaviour remains the passive canonical lineage apart from version metadata. The next architecture activity is to pressure-test Traffic Policeman Decision ordering across contrasting abundant-slack, compressed-TS016 and too-late/exhausted cases before implementation evidence is sought.
