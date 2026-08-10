# Prototype 23 — Native Headland Manoeuvre Sweep

## Purpose

Measure the space and elapsed time actually consumed by a GIANTS-native headland turn so later Traffic Policeman work can test whether follower Regulation may be derived from preserved Future Space / Maturation Margin rather than arbitrary separation literals.

## Authority boundary

Passive evidence only. The prototype does not predict turn direction, regulate speed, select a Candidate, create a Commitment or grant Control authority. `CONTROL_AUTHORITY_ENABLED=false` remains required.

## Evidence source

- `LocalIntentObservation`: native `TURNING` / `SETTLED_CONTINUATION` transition.
- `FieldBoundedFutureSpace.forwardBoundaryDistance`: forward boundary distance at turn entry when the immutable Field World snapshot is available.
- `AssemblyRepresentationCache`: represented current Physical Assembly primitives throughout the manoeuvre.
- actual vehicle root pose and speed for diagnostics only.

## Measurements

At `TURNING` onset the probe freezes an entry frame. Every diagnostic sample transforms represented physical discs into this frame and accumulates longitudinal/lateral extrema. On the first subsequent settled continuation it records elapsed turn-segment time and exit pose. Stored samples are then compared retrospectively with the eventual exit-line centre to show when the turning assembly first/last occupied that line.

The exit-line-centre result is not a lane-clearance contract. It is a compact empirical marker for comparing repeated turns and later follower experiments.

## First live test

1. Load v4.7.50 with Condor available under normal GIANTS AI.
2. Prefer Condor alone for the first evidence run.
3. Give it sufficient headland room for ordinary sweeping turns.
4. Allow several consecutive turns if practical.
5. Capture game log and video.
6. Review each `[HEADLAND-SWEEP] START`/`END` pair for repeatability of turn-entry boundary distance, sweep extrema, duration and exit geometry.

## Hypothesis

If repeated native turns produce sufficiently coherent sweep/time evidence, a later passive follower calculation can ask whether the follower's unrestricted progression would enter the leader's required manoeuvre space before the leader has completed enough of that manoeuvre to restore a supportable successor Situation. If the evidence is not coherent, do not substitute a fixed-distance controller; revisit the representation.
