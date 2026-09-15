# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #45 Bubble Bullet Time

Issue #45 is the active concern after post-merge `.77` Reality validation of the completed #172 lifecycle correction exposed a supported-envelope three-worker traffic failure.

In the observed run, Condor and S 416 were executing Cooperative Passage `CM-00003` while Patriot remained an independent third active worker in the same Local Operation. Fresh Situation Assessment continued to observe Condor/Patriot spatial interaction, including Category-1 Forward Intersection evidence, but Patriot did not receive the Architecture-required Bubble Bullet Time protection and later collided head-on with Condor. A separate S 416/Patriot follower purpose repeatedly admitted and retired during the same Resolution Epoch.

The accepted Spatial Negotiation architecture already resolves the responsibility boundary:

- at Bubble Formation, the independent third active AI Traffic Party enters exactly **1 km/h Intent-Revelation Creep** for the Resolution Epoch;
- that worker remains physically and semantically independent and does not join the pairwise Resolution Commitment;
- Reality and pairwise relationships involving the third worker remain observed;
- ordinary relationships with either Bubble participant are **deferred rather than independently negotiated** while the Bubble owns the coupled Resolution decision horizon; and
- unexpected hard-safety evidence remains authoritative.

The Category-1 evidence is therefore relevant current Reality, but it does not itself justify an independently negotiated Forward Intersection responsibility during the active Bubble. The follower admit/retire loop is likewise inconsistent with the Bubble-owned decision horizon.

> **Active Pair Resolution Needs Stable Third-Party Protection.**

## Bounded `.78` implementation hypothesis

The current Engineering Increment implements Bubble Bullet Time as a **supporting physical Regulation effect of the existing Cooperative Passage Resolution responsibility**. It does not create a new Regulation responsibility, another Resolution, another Operation, a third Passage Leg or a new traffic hierarchy.

Current source already supplies the required lower-level primitives:

- `LiveTrafficCommitmentLifecycle` can acquire supporting progress authority and revise Effective Actuation Composition;
- generic Bounded Authority can grant `REGULATE_SPEED` under the current Passage Resolution responsibility;
- `NativeDriveMechanism` composes independently owned Regulation leases by applying the least-permissive active cap; and
- passive Candidate Support can preserve observation while issuing no independent physical Candidate.

The bounded implementation therefore:

1. identifies only the independent third worker already present at **Bubble Formation**;
2. prepares that worker's supporting authority/composition under the Passage commitment without adding it to the Passage pair;
3. after Responsibility Transition has exposed the Passage Resolution as current, activates a fixed **1 km/h** Bubble lease immediately before joint Passage Control begins;
4. while a Passage Leg remains live, projects ordinary live-traffic Candidate Support to passive observation so follower/Forward-Intersection relationships remain observed but deferred;
5. releases the Bubble physical effect when its current third-party basis ends and on Resolution-Epoch termination; and
6. leaves ordinary two-worker Passage behaviour unchanged.

Later arrival of a new third worker after Bubble Formation is deliberately outside this `.78` increment. That question remains unresolved rather than being silently invented through implementation convenience.

## Disproved implementation assumption

The first implementation sketch attempted to create positive Bubble Bounded Authority inside `CooperativePassageResponsibilityTransition`. Code walk disproved that ordering: `ResponsibilityTransitionAuthority` registers the Passage Resolution as current only after the specialised transition collaborator returns, and generic Bounded Authority correctly rejects permission before Current Responsibility exists.

The corrected ordering is:

```text
Bubble Formation
    -> prepare third-party supporting authority/composition
    -> Responsibility Transition exposes current Passage Resolution
    -> activate fixed 1 km/h Bounded Authority
    -> joint Passage Control begins
```

> **Supporting Composition Preparation != Positive Physical Permission.**

This preserves the accepted rule that positive physical actuation requires an already-current semantic responsibility.

## Validation boundary

The focused offline contract must challenge that:

- a formation-time third worker receives supporting 1 km/h protection without becoming a Passage participant;
- positive Bounded Authority is not created before the Passage Resolution is current;
- the two Passage requests and supporting third-party effect share one current Effective Actuation Composition;
- ordinary third-party follower/Forward-Intersection negotiation is deferred to passive observation while the Passage Resolution Epoch is live;
- physical Bubble protection releases when its basis or Resolution Epoch ends; and
- a two-worker Passage does not manufacture third-party Regulation.

GitHub Actions remains the execution authority for blocking structural and Lua behavioural contracts.

If offline validation passes and the increment is accepted, the next Reality challenge is the retained three-worker scenario that exposed #45: form a genuine two-worker Cooperative Passage with an independent third active worker already present and observe whether the third worker remains at the required 1 km/h throughout the active Resolution Epoch, ordinary pair relationships remain observed without follower-regulation oscillation, and the Passage completes without the prior head-on collision. A successful run challenges integrated behaviour; it does not prove the whole supported envelope.

## Executable baseline and parked concerns

This executable increment advances TEST build identity from `.77` to **`.78`**. `scripts/config.lua` and `modDesc.xml` remain the two build-identity owners and must agree exactly. No canonical-release identity changes.

Issues #170, #174 and #176 remain parked standards-work conformance concerns. Issue #210 remains a parked generated-source-reference improvement. Issue #172 is completed and closed.