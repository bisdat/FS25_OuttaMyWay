# Continuation State

Continuation State is the compact, replace-in-place description of the project's
present engineering boundary. Git history, pull requests, Issues and the
Engineering Journal preserve chronology.

## Repository authority

- Accepted Repository State baseline: `main` after PR #92 merge, commit `e31791ec510465020da7a0815a901186db3b558e`.
- Canonical authority remains **v0.3.0.0**.
- Current Engineering Increment identity: **`0.3.0.33 TEST — FORWARD INTERSECTION EVIDENCE CONTINUITY`**.
- Protected `main` requires both `Structural contracts` and `Lua offline behavioural contracts`.
- Phase 14 remains **ACTIVE**. Phase 14.6B is accepted. Planned Phase 14.6C resumes after this bounded Issue #37 Reality correction; no new Phase-14 subphase is created.
- Issue #90 continues to own the roadmap through Phase 14 closure and the later Phase-15 architecture <-> code audit.

## Current Reality concern — Issue #37

The `.32` Condor/Patriot Category-2 run exposed a semantic continuity defect.

At `20:03:33.307`, the established Forward Intersection became
`UNRESOLVED` with reason `FORWARD_CONTINUATION_UNRESOLVED`. Production released
Patriot's existing 1 km/h allocation immediately. GIANTS then began Condor's
corner manoeuvre about 83 ms later; the turn/reverse/square-off sequence lasted
about 12 seconds while Patriot accelerated natively and consumed roughly 79 m of
Resolution Space before a later Forward Intersection formed.

The named discovery is:

> **Forward Intersection Unresolved != Forward Intersection Dissolved**

The relationship was not positively disproved; the evidence needed to determine
its continuation was temporarily unavailable during the protected participant's
own intent-revealing manoeuvre.

## Current ownership understanding

The code walk on accepted `main` established:

- `SpatialConstraintAssessment` already distinguishes Forward Intersection
  `POSITIVE`, `UNRESOLVED` and `NEGATIVE` correctly.
- Forward Intersection Candidate/Obligation contracts already require positive
  dissolution rather than mere evidence loss.
- `CurrentResponsibilityAssessment` is the primary defect: it currently maps any
  non-actionable Forward Intersection, including `UNRESOLVED`, to `TERMINATE`.
- Runtime then neutralises the physical lease and the generic Action-Space
  settlement helper can relabel that termination as successful positive
  dissolution.
- Existing `RegulationBoundedAuthority` already preserves an admitted Forward
  Intersection fixed-creep lease when semantic assessment says `PERSIST`; no
  Control redesign is required.

This is **Evidence Loss Is Not Purpose Expiry** at the Current Responsibility
continuation boundary.

## `.33` bounded hypothesis

`WAITING_FOR_EVIDENCE` is an assessment status of the same Regulation
responsibility. It is not a new generic Commitment state or Current
Responsibility kind.

Expected semantics:

```text
current supported Forward Intersection
    -> PERSIST

temporary UNRESOLVED / current relationship unavailable
    -> PERSIST
    -> WAITING_FOR_EVIDENCE
    -> preserve existing yielder allocation at exactly 1 km/h

fresh supported NEGATIVE Forward Intersection
    -> positive dissolution
    -> TERMINATE / release

fresh established valid successor relationship
    -> positive supersession
    -> TERMINATE / successor assessment
```

Runtime and settlement must independently refuse to call unresolved evidence
successful dissolution.

No route prediction, `TURNING` special case, timeout literal, Passage geometry
change, Candidate redesign or Regulation-Control change is authorised.

## Fail-safe boundary

Prolonged `WAITING_FOR_EVIDENCE` cannot be allowed to hold indefinitely, but
`.33` deliberately does not invent a watchdog duration. The normal live
reassessment cadence should first be tested against Reality. If evidence fails to
recover or become positively negative/superseded, that observation will define a
separate bounded fail-safe problem.

A timeout may force reassessment or escalation; timeout expiry must never
manufacture evidence that the relationship is safe or dissolved.

## Validation boundary

Implementation-local work performs syntax/static/XML/diff checks only. GitHub
Actions owns the repository Structural and Lua behavioural suites.

The decisive GIANTS Reality test repeats the same Condor/Patriot Category-2
fixture and asks:

1. Does Patriot remain at 1 km/h through Condor's temporary
   `FORWARD_CONTINUATION_UNRESOLVED` turn/reverse/square-off interval?
2. Does fresh supported negative or successor evidence release Regulation
   promptly?
3. Is no turn path predicted and no new timeout required for the normal case?
4. After temporal continuity is corrected, does the later boundary-constrained
   Passage observation remain, change, or disappear?

Contrary Reality returns the project to Observe -> Discuss -> Hypothesise rather
than being hidden by special cases.
