# ADR-0016 — Settled-Pose Transition Frame Closure

**Status:** Accepted architectural refinement; supported by v4.6.69 runtime evidence; implementation inactive in v4.6.71.

## Context

ADR-0015 caused the final v4.6.68 Condor movement to settle before reassessment. Decision then selected one executable second leg. Control inherited the original stop-centreline anchor while adopting the replacement side vector. The unchanged stationary pose therefore measured `-1.32 m` across the new fence and failed 96 ms after authorisation.

The endpoint, path and time budget were viable. The missing precondition was closure between the settled starting pose and the complete replacement Control frame.

## Decision

Every refuge manoeuvre leg owns a leg-local Control frame anchored to the assembly's verified actual pose when that leg begins. The original encounter stop anchor remains separate evidence for passage, return and Native Handover.

A replacement candidate shall publish:

- exact transition start coordinates;
- frame mode `CURRENT_POSE_ANCHORED`;
- endpoint, path, field-containment, Progress-preservation and time evidence.

Decision may authorise the leg only when those values are resolved. Control shall re-read the actual pose, reject stale start evidence, and atomically commit target, side vector and leg-local anchor. Until that succeeds, the existing refuge and frame remain authoritative.

## Consequences

- The starting pose has zero lateral displacement in the new leg frame by construction.
- Rotation of the Progress frame cannot invalidate a settled pose merely because an older anchor is retained.
- Cross-side and same-side movements still require complete transition viability; this ADR does not relax path or temporal gates.
- A stale Decision-to-Control transition is rejected without failing the existing Native Reposition run.
- Situation Assessment remains continuous and manoeuvre-leg commitment remains authoritative.

## Validation

The packaged regression test reproduces the inherited-frame negative lateral value, commits the same replacement using an exact settled-pose anchor, verifies no immediate fence failure, and rejects a stale start-pose authority. Runtime validation must establish visible execution of the final second refuge leg.
