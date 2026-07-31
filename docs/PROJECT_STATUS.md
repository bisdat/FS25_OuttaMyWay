# Project Status

Version: 4.6.32
Canonical implementation authority: v4.6.31, SHA-256 `2f54f3a01aaf41bd6f9fd798ce672e1631dbb9e6c9e811ac4ce6acb0b676c25b`
Authority state: Candidate — observer-only physical/policy clearance evidence separation implemented; runtime validation and repository-owner Canonicalisation pending
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless the test record states otherwise

## Current engineering increment

v4.6.32 begins from the exact owner-declared v4.6.31 canonical package. It changes Shadow Clearance calculation and diagnostics only.

The calculator now exposes separate Knowledge fields:

```text
physicalContactThreshold
physicalClearanceReserve
policyMarginBudget
policyRequiredSeparation
policyReserve
```

Physical contact threshold is the sum of opposing Facing Clearance Extents. Policy margin budget is the explicit sum of geometry uncertainty, tracking tolerance, motion allowance and policy margin. Policy required separation adds that budget to the physical threshold. The previous ambiguous combined `requiredSeparation` and `reserve` fields are removed from runtime output.

## Protected actuator invariants

- Condor remains fixed Yield.
- Patriot remains fixed, unmodified GIANTS Progress.
- Arming remains manual and the test side remains forced.
- Known inverted console labels remain unchanged.
- The actuator remains fixed at 28 m lateral and 12 m rearward.
- Every derived geometry and clearance field remains `authority=false`.

## Expected repeated-run evidence

For the established TS017-B fixture, increasing confidence requires the separated output to reproduce approximately:

- physical contact threshold: 25.37 m;
- live reference separation: 27.38 m;
- physical clearance reserve: +2.01 m;
- policy margin budget: 3.75 m;
- policy required separation: 29.12 m;
- policy reserve: -1.74 m;
- complete passage, rejoin, GIANTS handback and 20-second observation with `failure=nil`.

These are expected comparisons, not new v4.6.32 empirical results.

## Exact continuation point

Repeat the established manually armed Condor-yields run. Compare `PRE_ESTIMATE`, `REFUGE_LIVE`, `CLOSEST_APPROACH`, `PASSAGE_CONFIRMED`, continuous samples, console status and `SHADOW_SUMMARY`. Confirm that physical and policy values remain distinct while the validated actuator and visible passage behaviour remain unchanged.

Only after that evidence is recorded should automatic encounter triggering and shadow candidate comparison for Yield/Progress and escape side be discussed. Geometry-derived Control remains prohibited.

## Current limits

The provider remains fixture-bounded. Runtime shape bounds remain unavailable. The 2.50 m physical allowance, 3.75 m policy-margin budget and 28 m movement are not production constants. Full assembly swept paths, field/margin refuge feasibility, obstacles, autonomous role/side selection, multiple simultaneous encounters and generalisation beyond Condor/Patriot remain unresolved.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently acts as a prototype/release summary. Before publication readiness, restore it to a stable description of the mod and keep increment-specific reporting in the changelog and engineering documents.
