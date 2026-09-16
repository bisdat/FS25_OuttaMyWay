# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #224 Forward-Intersection dissolution fitness

Issue #224 owns the Reality-disproved assumption that any current geometric Forward-Intersection `NEGATIVE` is automatically sufficient to positively discharge an already-established Forward-Intersection Regulation.

Accepted `main` at the start of this Engineering Increment is merge `deb8a522cb4611811be80240afd1a392f64bd1c9` from PR #225, with executable build identity **0.3.0.82**. PR #225 already made the architectural decision authoritative: prospective Forward-Intersection fitness and incumbent-purpose dissolution fitness are question-relative, and current realised progression that positively contradicts the continuation basis of a geometric negative makes incumbent dissolution `UNRESOLVED` rather than successful.

The current branch revision carries executable identity **0.3.0.84** for the bounded implementation of that decision.

## Established Reality observation

The clean `.82` Condor/Patriot Forward-Intersection witness establishes the defect at the manoeuvre-to-successor-continuation boundary:

- `06:45:34.577` — a positive Forward Intersection establishes Patriot as temporal yielder at exact **1 km/h** while Condor approaches a Category-1 corner;
- `06:46:01.003` — the Forward Intersection becomes `UNRESOLVED` during Condor's turn and the accepted #37 evidence-continuity rule correctly preserves Regulation;
- `06:46:13.558` — a newly represented successor continuation makes the Forward-Intersection geometry `NEGATIVE` with `INTERSECTION_NOT_FORWARD_OF_BOTH_PARTICIPANTS`;
- `06:46:13.584` — the incumbent Regulation releases and settles as successful;
- `06:46:13.589` — current physical evidence still shows Condor travelling opposite the newly represented continuation while Field-bounded Future Space already supports the successor intent;
- `06:46:14.104` — realised physical progression agrees with that continuation; and
- `06:46:14.465` — fresh Reality establishes a new Forward Intersection with reversed temporal roles.

The demonstrated error is therefore not delayed Forward-Intersection admission and not failure to preserve `UNRESOLVED`. It is **positive incumbent dissolution while the evidence basis producing the geometric negative is physically contradicted**.

Historical `.33` remains valid evidence for #37's `Forward Intersection Unresolved != Forward Intersection Dissolved` correction. Its preserved record does not independently prove realised-travel corroboration at its release boundary, so it is non-discriminating on #224's stronger question.

## Accepted architectural decision

PR #225 established the current authority contract:

> **A current Forward-Intersection negative may positively dissolve an incumbent Forward-Intersection Regulation only when the evidence basis that produced that negative is fit for incumbent-purpose dissolution.**

A bounded continuation may remain fit for prospective Forward-Intersection reasoning while being unfit for dissolution when current realised progression positively contradicts it.

This is not Regulation stickiness. Once the contradiction is absent and the supported negative remains current, Situation Assessment may positively dissolve the allocation immediately. No successor relationship, Passage reservation, delay literal, travelled-distance threshold or arbitrary hysteresis period is required.

Normal adjacent-corridor, `PARALLEL_OR_COLLINEAR`, opposed/head-on and Cooperative-Passage behaviour is outside this correction unless new Reality evidence demonstrates a separate defect.

## `.84` implementation hypothesis — Current Physical Contradiction Vetoes Dissolution

Production Observation already derives current realised travel direction from successive AI-steering-node positions and publishes that raw motion evidence into the Operational Picture. Spatial Constraint Assessment already owns the current Field-World-bounded continuation projection used by Forward Intersection.

The `.84` implementation therefore compares those two existing evidence products directly for the demonstrated geometric-negative reason:

```text
realised position-derived travel direction
                dot
exact current FI projection heading
                 |
                 +-- dot < 0
                 |      -> current physical contradiction
                 |      -> geometric FI remains NEGATIVE
                 |      -> incumbent dissolution evidence UNRESOLVED
                 |      -> existing Regulation WAITING_FOR_EVIDENCE
                 |
                 `-- no positive contradiction
                        -> preserve existing geometric-negative dissolution path
                        -> release immediately
```

The criterion is deliberately **opposition**, not general corroboration. Resolution-Margin Demand's separate `alignment < 0.5` rule answers a different projection-fitness question and is not reused here. A weak but still positive alignment is not positive contradiction and must not delay release merely to seek stronger corroboration.

The implementation does not consume diagnostic Native Drive command evidence, `targetTravelDot`, the `REVERSING_OR_OPPOSED_TRAVEL` diagnostic classification, or a timer. Missing realised-travel direction likewise does not manufacture stickiness; only current positive contradiction vetoes dissolution.

## Intended source boundary

- `scripts/assessment/SpatialConstraintAssessment.lua` remains owner of current Forward-Intersection Situation meaning. It preserves the geometric `NEGATIVE` and separately publishes incumbent-dissolution evidence fitness for `INTERSECTION_NOT_FORWARD_OF_BOTH_PARTICIPANTS`.
- `scripts/assessment/CurrentResponsibilityAssessment.lua` consumes that Situation meaning. `NEGATIVE + incumbent dissolution UNRESOLVED` maps to the existing `PERSIST / WAITING_FOR_EVIDENCE` lifecycle path; other accepted Forward-Intersection negatives retain the existing positive-dissolution path.
- Bounded Authority, Regulation Control, Passage, Future-Space acquisition and GIANTS routing are unchanged.

## Validation contract

The focused offline contract must establish all of the following:

1. opposite realised progression leaves the current Forward-Intersection geometry `NEGATIVE` while making incumbent dissolution `UNRESOLVED`;
2. the existing Forward-Intersection Regulation therefore persists as `WAITING_FOR_EVIDENCE`;
3. weak-but-positive realised alignment does **not** become a corroboration requirement and permits the existing immediate positive-dissolution path;
4. unavailable realised travel does not by itself manufacture Regulation persistence; and
5. existing fixed 1 km/h Forward-Intersection waiting authority, supersession and ordinary positive-dissolution contracts remain intact.

GitHub Actions owns ordinary execution of the structural and Lua offline contracts. Offline success can validate the deterministic evidence/lifecycle interpretation but cannot prove the GIANTS live timing or physical outcome.

## Required Reality validation

If `.84` passes offline review, targeted in-game validation should reproduce a constrained-space Forward-Intersection handoff and inspect the new dissolution diagnostics.

The target outcome is:

```text
established FI Regulation
    -> TURNING / existing #37 WAITING continuity
    -> successor FI geometry becomes NEGATIVE
    -> realised progression still opposes successor projection
    -> incumbent remains regulated at 1 km/h
    -> contradiction disappears
    -> incumbent releases promptly
    -> both workers return to ordinary GIANTS work
    -> any later Passage or Forward Intersection is rediscovered from fresh Reality
```

A result that preserves Regulation materially beyond physical contradiction removal is evidence against the `.84` implementation hypothesis, not justification for adding a timer.

## Next bounded engineering step

Interpret exact PR-head GitHub Actions evidence for `.84`, then perform the targeted in-game Reality challenge before accepting the runtime correction.

Issue #224 remains open until the implementation and required Reality evidence are complete.
