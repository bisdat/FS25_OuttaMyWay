# ADR-0017 — Manoeuvre-Leg Orientation and Counterfactual Hold Release

**Status:** Split evidence outcome: bounded orientation accepted; v4.6.70 continuation-speed and Hold-release implementation rejected; all experimental code inactive in v4.6.71.

## Context

v4.6.69 closed the inherited-frame defect. The second refuge leg began from the correct settled pose, but normal steering acquisition briefly moved 0.77 m opposite the selected side and triggered the monotonic centreline fence. After the reposition entered `FAILED_HELD`, Decision repeatedly held and restored the remaining mover because the Hold-created stationary state appeared safe.

## Decision

A manoeuvre leg may begin with a bounded orientation envelope. The authorised target does not change. Directional side progress is not enforced until the assembly establishes positive movement toward the selected refuge. The envelope has explicit time, travel and reverse-lateral exhaustion limits.

A Hold is a coherent lease. Situation Assessment shall publish a counterfactual native-continuation projection using the held assembly's retained GIANTS operating speed. Decision may release only when that projected continuation is conflict-excluded and non-closing, current continuation Knowledge is clear, and the evidence remains stable for the required confirmation interval. The physical calm produced by the Hold is not release evidence.

The global authority invariant remains: OuttaMyWay shall never hold all participants simultaneously. A terminal `FAILED_HELD` reposition prohibits Hold or repeated reposition authority on the remaining mover; only an admissible bounded temporal capability or explicit unresolved escalation may follow.

## Consequences

- Steering acquisition is distinguished from abandonment of the selected refuge side.
- A refuge leg remains one decisive movement under one target.
- Orientation cannot continue indefinitely or conceal field/path loss.
- Hold/Restore oscillation cannot be driven by the intervention's own effect.
- Failed capability outcome remains operationally relevant without creating an all-held deadlock.

## Validation

Packaged tests reproduce safe negative acquisition displacement, arm the fence after positive progress, fail an exhausted envelope, retain a Hold under unsafe post-release projection, release after sustained admissible projection, and prohibit Hold after terminal failed-held reposition. Runtime validation must prove the complete chained TS015 passage.

## v4.6.70 runtime disposition

The bounded orientation part is supported by runtime evidence. The Hold remained coherent and no longer oscillated. The release implementation is rejected: it used the 60 km/h cruise-control ceiling as native continuation speed and required non-closing motion universally, retaining Patriot until map-clear. Future implementation must use evidence-supported native behaviour and bounded conflict exclusion; closing is evidence, not an automatic veto.
