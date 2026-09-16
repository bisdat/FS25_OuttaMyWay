# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, accepted understanding needed to continue it, unresolved question, and next bounded engineering step.

It is **not** a repository-status dashboard. Git owns exact accepted chronology; executable-version owners own build identity; GitHub Issues and pull requests own their discussion state; canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative.

## Current engineering boundary — Issue #224 Corner Atlas / Corner Engagement

Issue #224 began as premature dissolution of Category-1 Forward-Intersection Regulation. GIANTS Reality from TEST build **0.3.0.85** now shows that the deeper missing concept is persistent knowledge of the corner itself rather than longer persistence of one pairwise Regulation responsibility.

The executable baseline for this increment is accepted **0.3.0.82**. PR #230 / TEST build `.85` is closed without merge. Its Offline Validation was green, but Reality superseded its responsibility-local Category-1 ownership model. `.83` and `.84` remain rejected TEST builds.

The accepted Issue #224 experiment is **0.3.0.86 — Passive Corner Knowledge**. This increment implements Situation-owned knowledge and diagnostics while preserving the baseline's physical traffic semantics. It does not implement downstream Corner Engagement protection yet.

## Reality discoveries

### Condor / Patriot `.85`

`.85` correctly preserved Patriot as yielder while Condor remained in GIANTS `TURNING`, demonstrating that the A8 -> TURNING mechanism can protect the intended worker inside one responsibility. After fresh Condor A8, however, a new open-field Forward Intersection rapidly made Condor the yielder for several seconds. The event was a new responsibility rather than a role-migration leak.

Subsequent geometry review showed that fresh Condor A8 also carried positive topological departure evidence: the remembered corner lay behind Condor's new productive axis and the new bounded continuation terminated on a non-corner Field World edge. This supports A8 as a **departure gate**, not as discharge by itself.

### S416 / Condor `.85`

The S416 fixture exposed the stronger architectural problem. The corner is visibly material before the current FI overlay calls it Category 1; FI/Current-Excursion/Passage responsibilities then change while S416 remains in the corner and `TURNING`. Condor is correctly cautious during some episodes but is released during others before S416 reacquires fresh A8 around `17:25:08.965`.

The failure is therefore **protection continuity across ephemeral relationship/responsibility changes**, not simply wrong yielder selection. The same run independently reproduces Issue #227's post-crossing recovery target failure; #227 remains a separate Passage concern.

> **Responsibility Transition != Corner Departure**

## Accepted architectural direction

### Corner Discovery

Existing corner discovery remains valid. A Category-1 corner is positively discovered from pairwise Forward-Intersection geometry only where supported Field-World-bounded continuations terminate on distinct boundary edges that share the same Field World vertex. Middle-of-field intersections do not discover corners.

> **Corner Detection Can Be Pair-wise; Corner Knowledge Is Spatial.**

### Corner Atlas

Once positively discovered, the corner becomes retained Field World knowledge for the same immutable Field World. The **Corner Atlas** stores the corner vertex, incident boundary edges and a positively supported **Corner Envelope**. A later FI becoming open-field, negative, unresolved or superseded cannot erase a known corner.

The known envelope may expand when later positive evidence demonstrates wider constrained demand; it does not shrink because a subsequent worker or interaction is narrower. The envelope remains bounded by Field World.

> **Known Corner Extent Can Grow; It Does Not Oscillate.**

Corner Atlas knowledge is not pair history. It does not store an old yielder, right-of-way, Regulation identity or future turn route.

### Corner Engagement

**Corner Engagement** is current Situation meaning that a worker is entering, occupying, manoeuvring within or exiting a known Corner Envelope in a way that may materially affect another current worker whose supported demand intersects the same corner theatre.

While engagement remains current, preserve the engaged worker's native opportunity to reveal intent, turn, reverse, reposition and create space. Other relevant workers are the cheaper parties to make cautious where temporal coordination is justified. FI topology, Current Excursion, Passage admission and Responsibility Transition do not by themselves retire the engagement.

### Positive Corner Departure

Fresh A8 after manoeuvring uncertainty is the required gate for departure assessment, but A8 alone is not positive corner-clear evidence.

Positive Corner Departure additionally requires current Field World topology showing that the worker's fresh productive continuation no longer belongs to the stored corner. The normal witness is:

- the remembered corner vertex is behind the worker's fresh productive progression; and
- the bounded continuation terminates on a boundary edge that is not incident to the known corner.

> **A8 Reacquisition Is the Departure Gate; Positive Topological Departure Is the Discharge Witness.**

Timers, travelled-distance tails, arbitrary corner multipliers, temporary movement outside a guessed box, absence of renewed FI or responsibility replacement cannot manufacture departure.

## Scope boundary

This architectural correction is Category-1-specific. It does not redesign:

- existing positive corner discovery;
- initial Forward-Intersection timing/yielder selection;
- Category-2 headland/boundary semantics;
- ordinary open-field or adjacent-lane work;
- leader/follower Regulation;
- Cooperative Passage geometry/Bubble lifetime;
- the exact 1 km/h Intent-Revelation Creep;
- GIANTS productive routing/native turning; or
- the supported three-AI-worker Operation envelope.

## Authority Triad state

- **Architecture — preserved.** Spatial Negotiation owns Corner Atlas, Corner Envelope, Corner Engagement and Positive Corner Departure as spatial concepts rather than responsibility-local Category-1 history.
- **Specification — preserved.** Situation Assessment owns retained corner knowledge, current engagement and A8-gated positive topological departure.
- **Code — passive knowledge implemented; behavioural consumption deferred.** `SpatialConstraintAssessment` retains the Atlas and worker/job engagements and publishes detached values under `spatialConstraintKnowledge.cornerKnowledge`. `SituationAssessment` supplies authoritative current productive-continuation knowledge, physical evidence and Observation provenance. Candidate, Decision, Responsibility and Control paths remain unchanged.

> **Reality Updated the Architecture.**

## Next bounded engineering step

Review the passive experiment and challenge its Cross-Corridor Envelope in GIANTS Reality before allowing Regulation to consume Corner Engagement. Offline contracts are registered in the replacement-core harness; GitHub Actions owns their execution and the PR owns the resulting CI evidence. No in-game validation is claimed by this implementation.

The implementation uses the existing exact polygon geometry identity and quantisation basis, independently of Local Operation and equivalence-class turnover. Different fingerprints in an equivalent lifecycle Field World remain unresolved for Atlas reuse. Map/Situation reset clears retained knowledge.

The envelope hypothesis uses intervals along the incident-edge directions, intersected with Field World. Each extent learns the other corridor's positive working width monotonically, retaining its provisional demand claim. Positive current assembly overlap establishes engagement; non-overlap cannot discharge it. Fresh A8 must follow the remembered manoeuvring Observation and supply both departure witnesses. A still-current departure witness prevents trailing overlap from immediately recreating the retired engagement.

Primary Reality questions:

1. **Condor / Patriot:** does Condor positively engage the discovered corner, remain engaged through manoeuvring, and depart only on fresh A8 plus the accepted spatial witness?
2. **S416 / Condor:** does the cross-corridor 36 m / 10 m hypothesis establish S416 engagement before the old FI disappears, preserve it through bumps/reversals and FI/Current-Excursion/Passage changes, and explain departure from fresh topology around the previously observed `17:25:08.965`?
3. Do later wider positive witnesses enlarge the same envelope without narrower witnesses shrinking it?

Only after these questions are answered should a later increment connect Corner Engagement to existing Regulation. Issue #227 continues separately for Passage recovery containment.
