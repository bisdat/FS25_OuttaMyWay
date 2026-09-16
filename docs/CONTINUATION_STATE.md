# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #224 Category-1 Evacuation Protection

Issue #224 owns the current spatial-negotiation lifecycle question: an established Category-1 Forward-Intersection Regulation can lose its protected temporal allocation before the protected worker has completed the GIANTS corner manoeuvre that the Regulation exists to make possible.

Accepted `main` remains on executable build identity **0.3.0.82**. The rejected `.83` / `.84` experiment was never merged; PR #226 is closed unmerged. This Engineering Increment is Architecture / Specification / Continuation documentation only and does not consume a TEST build identity.

## Established Reality evidence

The primary comparison fixture is the naturally evolved **Condor / Patriot** Category-1 corner in the current `.82 A` run.

Approximate player-visible lifecycle:

```text
14:04:33  Category-1 Forward Intersection identified
           -> Patriot regulated to exact 1 km/h
           -> Condor protected

14:05:07  Condor enters the corner and GIANTS begins TURNING
           -> Patriot should remain regulated

14:05:09  Condor reverses / repositions toward the boundary
           -> Patriot should remain regulated

14:05:17  Condor completes the corner manoeuvre and resumes productive work
           -> Category-1 protection may discharge
           -> Patriot may be released

14:05:35  later Cooperative Passage develops from fresh Reality
```

The detailed `.82 A` log provides the decisive semantic boundary:

- Category-1 FI correctly admits the allocation with Patriot as yielder and Condor as protected worker;
- the allocation correctly survives the first FI `UNRESOLVED` interval while Condor manoeuvres;
- Condor remains `TURNING`, `productive=false` through approximately `14:05:16.166`;
- FI becomes geometrically negative around `14:05:16.397` and the old Regulation releases around `14:05:16.415`;
- only about 3 ms later, around `14:05:16.418`, GIANTS positively publishes Condor as `SETTLED_CONTINUATION`, `productive=true`, `NON_TURN_LINE_ACTIVE`, `turning=false`;
- fresh open-field FI then develops later and may legitimately reassess temporal roles; and
- the eventual Condor / Patriot Cooperative Passage succeeds.

The visible outcome is therefore close to correct, but the accepted code releases on the wrong semantic event: **Forward-Intersection topology change occurs immediately before the stronger GIANTS evidence that the protected corner manoeuvre has actually ended.**

## Disproven `.84` hypothesis

PR #226 / build `.84` tested a narrower dissolution-fitness hypothesis:

> current realised progression that positively contradicts the new FI projection vetoes incumbent dissolution; absence of such contradiction permits release.

GIANTS Reality falsified that sufficiency rule. In the `.84` run an established Condor / S416 Category-1 Regulation could still release when realised travel evidence was unavailable rather than contradictory, while broader current spatial demand remained material. The later Passage failure is currently treated as downstream evidence because missing earlier Regulation allowed Resolution Space to be consumed before Passage commitment; Issue #227 remains deferred until equivalent recovery failure is reproduced from a correctly regulated approach.

> **No Positive Contradiction != Positive Dissolution Evidence**

The useful part of PR #225 remains: Representation Fitness is question-relative and prospective Forward-Intersection fitness is not automatically incumbent-dissolution fitness. The disproven part is the assumption that removal/absence of physical contradiction is sufficient positive Category-1 discharge evidence.

## Accepted Category-1 architectural discovery

Category-1 admission and initial yielder/protected selection are **not** being redesigned. Existing Forward-Intersection timing/allocation has demonstrated the correct provisional choice in the clean Condor / Patriot fixture.

The missing concept is the lifecycle of that already-established Category-1 Regulation after its protected worker begins the GIANTS corner manoeuvre.

### Category-1 approach allocation

Before the protected worker enters the manoeuvre, the Category-1 allocation remains prospective. Existing current evidence may continue to support it, positively dissolve it or positively supersede it under the ordinary Regulation lifecycle.

### Protected Manoeuvre Entry

While that same Category-1 allocation is still current, fresh Reality showing the already-protected worker cross from **A8-positive productive progression** into GIANTS `TURNING` establishes **Protected Manoeuvre Entry**.

This is responsibility-local lifecycle evidence, not persistent generic pair history and not a new Regulation type.

### Category-1 Evacuation Protection

After Protected Manoeuvre Entry:

- the same protected/yielder roles remain authoritative for that pair;
- the protected worker must remain free to turn, reverse and otherwise reposition under GIANTS ownership;
- the protected worker is not a valid regulation target for that same pair merely because projection topology changes;
- the existing yielder remains regulated under the accepted Category-1 temporal policy;
- Forward Intersection becoming `UNRESOLVED`, becoming geometrically negative or reappearing with reversed timing roles cannot by itself dissolve or reverse the incumbent allocation; and
- no corner radius, future turn path, timer, travelled-distance tail or successor relationship is invented.

> **Protected Manoeuvre Entry Freezes Roles; It Does Not Freeze Routes.**

### Positive Evacuation Discharge

A8 is **not** a generic corner-clear predicate because the protected worker is already A8-valid on approach.

The positive discharge witness is **fresh A8 reacquisition by the same protected worker after Protected Manoeuvre Entry**. That fresh productive working progression is GIANTS-owned evidence that the repositioning episode has ended and bounded productive certainty has resumed.

> **A8 Reacquisition = Positive Evacuation Discharge**

At that point the old Category-1 Regulation may terminate immediately. Fresh Situation Assessment then owns whatever follows: ordinary GIANTS work, a new Forward Intersection, Cooperative Passage or another supported relationship.

A later unrelated `TURNING` episode cannot activate stale protection; Protected Manoeuvre Entry must occur while the same Category-1 allocation remains current.

## Scope boundary

This discovery is deliberately **Category-1-specific**.

It does not currently change:

- Category-1 admission or initial FI timing/yielder selection;
- Category-2 headland/boundary semantics;
- open-field Forward Intersection;
- ordinary adjacent-lane behaviour;
- leader/follower Regulation;
- opposed/head-on Cooperative Passage;
- Passage geometry or Bubble lifetime;
- the exact 1 km/h Intent-Revelation Creep;
- GIANTS productive routing or native turning; or
- the supported three-AI-worker Operation envelope.

The early Condor / S416 corner is useful secondary robustness evidence because the same lifecycle predicts a better outcome: once S416 is the protected Category-1 worker and enters `TURNING`, Condor should remain regulated until S416 reacquires fresh A8, preserving more Resolution Space for whatever fresh Passage relationship develops afterward. The naturally evolved Condor / Patriot `.82 A` corner remains the primary A/B fixture because it avoids the additional test variable of introducing and manually starting S416.

## Authority Triad state

- **Architecture — advanced on this branch.** `architecture/SPATIAL_NEGOTIATION_MODEL.md` now defines Category-1 Evacuation Protection, Protected Manoeuvre Entry and fresh A8 reacquisition as positive discharge.
- **Specification — advanced on this branch.** `spec/SITUATION_ASSESSMENT.md` now requires responsibility-local interpretation of the Category-1 approach / protected-manoeuvre / discharge lifecycle while preserving Situation Assessment versus Responsibility Transition authority.
- **Code — intentionally behind Architecture / Specification.** Accepted production remains `.82`; no implementation for Category-1 Evacuation Protection exists yet.

> **Architecture Defines the Target; Implementation Comes Next.**

## Next bounded engineering step

Review and accept this documentation-only Architecture / Specification increment first.

After acceptance, whiteboard the smallest implementation mapping from existing production evidence into the accepted lifecycle before changing executable code. The implementation investigation should begin by locating:

1. where the existing Category-1 FI Regulation retains its protected and regulated assembly identities;
2. where current A8-positive productive-continuation evidence and GIANTS `TURNING` transitions are already available to Situation Assessment;
3. how the same Current Responsibility can retain a responsibility-local `Protected Manoeuvre Entry` witness without creating persistent pair history;
4. how Current Responsibility interpretation prevents FI topology from terminating/reversing that Category-1 allocation while Evacuation Protection is active; and
5. how fresh A8 reacquisition by the protected worker becomes positive basis cessation and immediate release.

The primary GIANTS Reality validation target for the later executable increment is the naturally occurring Condor / Patriot Category-1 corner represented by the `.82 A` baseline. S416 / Condor remains secondary robustness coverage.
