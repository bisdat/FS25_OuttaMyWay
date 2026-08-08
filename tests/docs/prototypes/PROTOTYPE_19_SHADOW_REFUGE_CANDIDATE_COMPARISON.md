# Prototype 19 — Calculated Refuge Selection

## Purpose

Calculate the Yield role, world-space refuge side, lateral displacement and rearward displacement for the exact Condor/Patriot admission fixture, then pass the confirmed-stop result into the established sidestep controller.

## Candidate generation

At admission, four candidates are calculated:

```text
participant A yields × negative Progress-corridor normal
participant A yields × positive Progress-corridor normal
participant B yields × negative Progress-corridor normal
participant B yields × positive Progress-corridor normal
```

Human left/right labels are diagnostics only. Each candidate stores a world-space side vector.

## Calculated target

For each role/side candidate:

```text
physical separation = Progress facing extent + compact Yield facing extent
policy separation   = physical separation + clearance-margin budget

rearward capture    = compact Yield forward extent
                    + geometry/tracking margin
```

Current signed lateral offset and the cross-axis contribution of each displacement are included. The coupled lateral/rearward result is iterated until stable.

The target is:

```text
confirmed stop position
+ side vector × calculated lateral movement
- Yield forward vector × calculated rearward movement
```

The rearward calculation places the represented compact assembly behind the stop line so the subsequent GIANTS job resumption traverses the missed-work area.

## Selection

Admission selects the geometry-resolved candidate requiring least lateral movement, then least total movement. Stable role/side fields resolve an exact numerical tie deterministically.

At confirmed stop, the selected role is retained but both lateral sides are recalculated from the live stopped pose. The best recalculated side and movement become Control authority.

No normal-Control fallback exists for fixed Condor Yield, physical-right, 28 m lateral or 12 m rearward values.

## Failure behaviour

- Admission-time calculation unavailable: commitment is withheld and the episode is not latched.
- Confirmed-stop recalculation unavailable: the selected Yield remains in the existing safe held failure state.
- Former fixture constants are never substituted.

## Representation inputs

Preferred inputs are complete live discovered envelopes and the fixture-bounded Condor compact Facing Extent Provider. Generic size metadata may provide a predicted compact rectangle. Where neither compact source exists, a live working-marker half-width may be used only as an explicitly labelled conservative upper bound.

Every source, coverage and confidence label is logged so runtime evidence can distinguish measured, modelled and conservative operands.

## Control boundary

Prototype 19 now owns calculated role/side/distance selection for the temporary v4.6.39 test. The existing controller still owns hold, configuration change, motion, passage confirmation, rejoin, restoration and GIANTS handback.

The current admission boundary remains exactly two active workers matching the Condor/Patriot fixture. General vehicle-pair admission is outside this increment.

## Historical evidence

v4.6.37 first generated the four candidates but exposed clock-domain drift and fixture-distance leakage. v4.6.38 corrected both, solved all four candidates in the runtime fixture and preserved the former fixed actuator. That completed the observer-only evidence bridge.

v4.6.39 transfers the calculated result into Control and is temporary/non-canonical pending runtime validation.

## Runtime acceptance

Require one complete fixture encounter with:

- one admission epoch and four candidates;
- one calculated admission selection;
- one confirmed-stop recalculation for the selected role;
- logged calculated lateral and rearward movements that are not fixture fallbacks;
- no physical contact;
- positive passage confirmation;
- successful rejoin and GIANTS handback;
- no second commitment within the same Encounter Episode Latch.
