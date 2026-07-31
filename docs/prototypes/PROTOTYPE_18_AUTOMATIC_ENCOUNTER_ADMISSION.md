# Prototype 18 — Fixture-Bounded Automatic Encounter Admission

Status: empirically supported in owner-declared canonical v4.6.33.

## Purpose

Remove the required manual `otmTS015Arm right` command without simultaneously generalising role selection, side choice, movement derivation or clearance authority.

## Architectural question

> Can sustained Situation Assessment evidence admit the already validated fixed Condor/Patriot Commitment at the useful intervention window without false or repeated activation?

## Separation of responsibilities

```text
Observer state + Prototype 01 kinematics
→ Automatic Encounter Admission
→ existing Prototype 16 actuator

Prototype 17 clearance evidence
→ Knowledge only (`authority=false`)
```

Admission determines only whether this exact fixture may begin its existing bounded Commitment. It does not determine what the commitment should be.

## Fixed fixture contract

- Yield Entity: Condor Endurance II.
- Progress Entity: Patriot 4450 under unmodified GIANTS control.
- Escape side: validated physical-right fixture side.
- Movement: 28 m lateral and 12 m rearward.
- Shadow Clearance: observer-only, no trigger or Control authority.
- Active pair: exactly two workers.

## Admission Candidate

A candidate exists only while all conditions hold:

- exactly one active Condor and one active Patriot;
- both report `WORKING`;
- neither is turning or blocked;
- both exceed the existing minimum working-speed thresholds;
- heading difference is at least 150 degrees;
- relative motion is closing by more than 0.10 m/s;
- `tCPA` is between 0 and 30 seconds;
- `dCPA` is no greater than 14 m.

Evidence must remain continuous for 3000 ms. Loss of any condition withdraws the candidate with no intervention.

## Commitment Point

After confirmation, Prototype 18 logs one `COMMITMENT_POINT` and invokes the existing hold/compact/egress/passage/rejoin/handoff actuator immediately. The former second stabilisation delay is not repeated because admission itself owns the sustained-evidence confirmation.

## Encounter Episode Latch

One commitment is permitted per continuous fixture episode. The latch prevents the same continuously active pair from re-triggering after handback or during the known Split-Start Pass Recovery sequence. It resets only after the pair is no longer continuously active for the configured absence interval.

This latch is a bounded test mechanism, not the production definition of Encounter identity.

## Console boundary

`otmTS015Arm` is removed and not registered. The normal run requires no OuttaMyWay command.

Retained commands:

```text
otmTS015Status
otmTS015Cancel
```

## Validation contract

Start the established Condor/Patriot fixture and record complete video and log without entering an OuttaMyWay command.

Pass requires:

1. exactly one `ADMISSION_CANDIDATE` after the pair becomes eligible;
2. exactly one `COMMITMENT_POINT` after approximately three seconds;
3. unchanged 28 m / 12 m actuator behaviour;
4. uninterrupted Patriot GIANTS control;
5. successful passage, rejoin and 20-second handback observation;
6. all Shadow Clearance fields remain `authority=false`;
7. no second activation during later Split-Start Pass Recovery.

A missed encounter, premature trigger, harmless-pass trigger, non-exclusive-fixture trigger or repeated activation disproves the admission hypothesis.

## Runtime result — TS018

The validation run required no OuttaMyWay console command.

```text
ADMISSION_CANDIDATE  distance=316.78 m  tCPA=29.94 s  dCPA=2.06 m
COMMITMENT_POINT     candidateFor=3.09 s  distance=277.92 m  tCPA=20.04 s  dCPA=0.03 m
RUN_START            trigger=automatic-encounter-admission
RUN_END              failure=nil  passageConfirmed=true  minPairSeparation=27.40 m
```

There was exactly one Admission Candidate, one Commitment Point and one actuator run. Passage, rejoin and the complete 20-second GIANTS handback observation succeeded. Condor remained fixed Yield, Patriot remained `GIANTS_UNMODIFIED`, and the physical-right 28 m / 12 m actuator was unchanged.

The Encounter Episode Latch remained `LATCHED` during the later known Split-Start Pass Recovery, so no second automatic intervention occurred. This supports the bounded one-shot guard but does not define production recurrence or Encounter identity.

Prototype 17 remained independent Knowledge: closest physical reserve was +2.03 m, closest policy reserve was -1.72 m and every record remained `authority=false`.

## Result

The architectural question is answered positively for the exact fixture: sustained Situation Assessment evidence can admit the already validated Commitment at a useful window without manual arming or repeated activation.

The result does not authorise general role, side, distance or recurring-encounter selection.

## Deferred

General Encounter identity, recurring commitments, automatic Yield/Progress selection, escape-side comparison, field-margin feasibility, obstacle checks, complete swept-envelope protection and geometry-derived movement remain separate future increments.
