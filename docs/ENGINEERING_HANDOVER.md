# Engineering Handover

## Authority

Canonical implementation authority is the owner-declared v4.6.31 package with SHA-256 `2f54f3a01aaf41bd6f9fd798ce672e1631dbb9e6c9e811ac4ce6acb0b676c25b`.

v4.6.32 is the next candidate. It implements observer-only evidence separation and has not yet been validated in FS25 or Canonicalised by the repository owner.

## Implemented change

Shadow Clearance Calculation now reports two different questions explicitly:

```text
physicalContactThreshold
= Progress Facing Clearance Extent
+ compact Yield Facing Clearance Extent

physicalClearanceReserve
= live reference separation
- physicalContactThreshold

policyMarginBudget
= geometry uncertainty
+ tracking tolerance
+ motion allowance
+ policy margin

policyRequiredSeparation
= physicalContactThreshold
+ policyMarginBudget

policyReserve
= live reference separation
- policyRequiredSeparation
```

The ambiguous combined `requiredSeparation` and `reserve` fields were removed from the calculator and all prototype diagnostics. Stage logs, continuous samples, console status and final summary now identify physical and policy values separately.

## Protected invariants

- Condor remains fixed Yield and Patriot remains fixed GIANTS Progress.
- Patriot receives no hold, steering, speed or implement command.
- Arming remains manual; the side is still forced and the known console-label inversion is preserved.
- Control remains fixed at 28 m lateral and 12 m rearward.
- Every calculated field remains `authority=false`.
- Automatic trigger, role assignment, side selection and geometry-derived movement remain absent.

## Expected comparison

The established fixture evidence was:

```text
physical contact threshold = 25.37 m
observed reference separation = 27.38 m
physical clearance reserve = +2.01 m
policy margin budget = 3.75 m
policy required separation = 29.12 m
policy reserve = -1.74 m
```

v4.6.32 must reproduce these as distinct runtime values while passage, rejoin, handback and the complete 20-second observation remain successful. The values above are comparison targets from canonical evidence, not a claim that the new output has already passed.

## Exact continuation point

1. Install the exact v4.6.32 candidate.
2. Recreate the established Condor/Patriot head-on fixture.
3. Arm the same manual Condor-yields side using the existing command and remember the labels remain inverted.
4. Capture the complete game log and uninterrupted visible passage evidence.
5. Verify the five separated fields at `PRE_ESTIMATE`, `REFUGE_LIVE`, `CLOSEST_APPROACH`, `PASSAGE_CONFIRMED` and `SHADOW_SUMMARY`.
6. Verify `HOLD_CONFIRMED` still reports 28.0 m lateral and 12.0 m rearward, Patriot remains GIANTS-controlled, and every shadow record states `authority=false`.
7. Record what was learned before discussing automatic trigger, role transfer or side choice.

## Deferred after evidence separation

The intended production flow remains:

```text
Situation Assessment detects a conflict
→ Decision generates role/side Refuge Pose candidates
→ feasibility and clearance are assessed
→ one bounded Commitment is selected
→ Control executes it
```

Automatic role transfer, escape-side choice, field/margin availability, obstacle checks, complete swept-envelope protection and geometry-derived movement remain unimplemented.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently summarises the active prototype/release. Before publication, return it to a stable mod description and keep release summaries in the changelog and engineering documents.
