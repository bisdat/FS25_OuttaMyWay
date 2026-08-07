# FS25_OuttaMyWay Roadmap

## Current gate — Future Space implementation conformance

Canonical v4.7.18 remains the baseline. Repository archaeology confirmed that ADR-0006/ADR-0012 already specify the relevant Future Space, Local Intent and Option Preservation architecture. v4.7.21 tests whether the replacement-core producer conforms to it:

1. observe native GIANTS FieldCourse `isTurn` without behavioural thresholds;
2. publish settled straight Local Intent to the forward Job-Seeded Field World boundary;
3. expire that straight intent while GIANTS reports a turn;
4. leave the manoeuvre sweep unresolved rather than guessing it;
5. advance the Local Intent epoch when GIANTS settles onto the next segment;
6. publish positive field-bounded continuation intersections as Situation Knowledge only;
7. retain no negative-clearance authority from non-intersection;
8. keep Decision, Commitment application and Control passive.

> **Current canonical baseline:** v4.7.18  
> **Current candidate:** v4.7.21  
> **Control authority:** disabled

## Immediate sequence

1. Live-observe a straight/turn/settled headland sequence using the Future Space HUD and log.
2. Verify that field-bounded Future Space appears materially before the legacy ten-second Encounter probe where the local intent supports it.
3. Validate Local Intent epoch expiry/revelation against native GIANTS turn state.
4. Record any unrepresented manoeuvre sweep as unresolved; do not fill it with a literal or guessed route.
5. Only after Situation Assessment conformance is proven should Decision's already-defined Option Preservation behavior be activated or tested.
6. Resolve the separate Encounter termination-precedence defect independently.

## Build-economy rule

One passive run should capture the complete `settled → turning → settled` evidence sequence. No collision is required.

# FS25_OuttaMyWay Roadmap

## Historical gate — configuration-specific footprint participation

Canonical v4.7.15 closed the Encounter-diagnostic question: the active pair path failed at physical representation because both TS015 sprayers lacked scalar dimensions and radii.

The non-canonical v4.7.16 diagnostic candidate proved the recovered cache and plan-view transformation path, then exposed a configuration-selection defect: inactive alternative Condor shop geometry entered every profile and inflated the tested 36 m machine to approximately 54 m.

v4.7.17 corrects that implementation in passive shadow:

1. retain the complete Job Episode geometry inventory;
2. distinguish purchased configuration evidence from available asset geometry;
3. select current physical participation through runtime compound-child evidence;
4. keep inactive and unresolved primitives explicit;
5. cache each configuration profile after first observation;
6. transform only participating primitives into the current footprint;
7. preserve positive-conflict-only shadow authority and unresolved negative clearance;
8. preserve existing Encounter predicates and zero Control authority.

> **Historical canonical baseline:** v4.7.15  
> **Historical representation candidate:** v4.7.17  
> **Control authority:** disabled

## v4.7.x implementation sequence

1. Bootstrap kernel — v4.7.0 canonical.
2. Observation and identity — v4.7.1 canonical.
3. Knowledge boundary — v4.7.2 canonical.
4. Deterministic Decision boundary — v4.7.3 canonical.
5. Replay conformance — v4.7.4 canonical.
6. Passive live evidence and targeted GIANTS discovery — v4.7.5–v4.7.10.
7. Job-Seeded Field World evidence and authority — v4.7.11–v4.7.14 canonical.
8. Bounded interaction diagnostics — v4.7.15 canonical.
9. Passive plan-view representation foundation — v4.7.16 diagnostic candidate; cache path proved, configuration selection disproved.
10. Configuration-filtered plan-view representation — v4.7.17 canonical.
11. Promote positive representation evidence into live Situation Assessment only after the configuration gate passes.
12. Validate Encounter admission passively before any Decision or Control work.
13. First exclusive vertical Control slice only after passive Encounter evidence is trustworthy.

## Build-economy rule

One diagnostic build should expose all reasonable silent gates. Offline tests remain mandatory. Live cycles answer only questions that GIANTS Reality must resolve.

## Standing prohibitions

- no architectural addition inferred from a diagnostic label;
- no two-worker scope limit inferred from pairwise assessment;
- no broad reflection;
- no guessed physical clearance from incomplete metadata;
- no threshold adjustment from one unexplained run;
- no Decision-to-Commitment application;
- no Control authority during passive validation.
