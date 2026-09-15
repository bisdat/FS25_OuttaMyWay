# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #216 Resolution-Margin Demand

Issue #216 remains the active concern after accepted build **0.3.0.78** positively validated Bubble Bullet Time and later exposed a separate two-worker collision while S 416 remained in GIANTS-owned turning motion.

PR #217 established the implementation-facing Situation Assessment contract for **Resolution-Margin Demand Evidence**. Accepted `main` at the start of this increment is merge `d7ab92a5fbcd7a51aaeeeb04c20fbff63d5726cd`. Build identity before executable work was `0.3.0.78`.

The accepted discoveries are:

> **Current Excursion != Resolution-Margin Demand.**

> **Reference-Point Separation != Usable Resolution Space.**

The `.78` collision trace showed represented Current-Space progression demand several seconds before the narrower Current-Excursion proxy admitted Action-Space Regulation, and the demand remained after that proxy moved outside its current `ahead` condition. The existing authority-owned progression envelope was initialised from reference-pose separation rather than the nearer represented spatial witness.

## `.79` semantic-production hypothesis

Build **0.3.0.79** is deliberately narrower than a collision correction.

It makes Resolution-Margin Demand a real production Situation product while leaving Candidate Support, Decision, Responsibility Transition, Bounded Authority and Control unchanged.

The production flow is:

```text
current sealed Observation / Operation evidence
        |
        v
baseline Situation Assessment
        |
        v
Resolution-Margin Demand Assessment
        |
        v
same Operational Picture identity / epoch
+ resolutionMarginDemandKnowledge
        |
        v
existing downstream pipeline unchanged
```

`ResolutionMarginDemandAssessment` uses current Situation-owned evidence and the existing neutral `ProgressionGeometry.rayCapsuleEntry()` maths. It does **not** import or promote `ProgressionPreservationProbe`; that probe remains diagnostic-only.

`ResolutionMarginSituationAssessment` is a Situation-layer decorator composed at the runtime bootstrap. It enriches the delegate Operational Picture before publication while preserving the same picture identity and epoch. The runtime still exposes one final `situationAssessment` product to the rest of the pipeline.

Positive Resolution-Margin records are intentionally one-sided. They retain:

- current Operation scope;
- the progressing subject and settled supported native progression basis;
- bounded Field-World local intent horizon;
- represented Current Space / Committed Demand / Potential Demand claim identity;
- known witness-entry distance;
- subject and target representation-fitness records and claim permissions;
- evidence/intent validity identities and provenance; and
- explicit claim limits denying negative-clearance, safe-clearance, stopping-distance, speed and route-prediction authority.

No positive witness is published when the progressing subject lacks settled supported continuation, when usable representation fitness is unavailable, when a positive represented intersection is absent, or when the witness lies beyond the supported local horizon.

## Disproved shortcut

The #216 code walk disproved the tempting implementation shortcut of feeding `knownWitnessEntryM` directly into the existing `ResolutionSpaceProgressionEnvelope`.

The merged Specification states that a witness-entry distance is positive one-sided evidence: a represented claim is known **no farther than** that point. It is not proof that all earlier space is clear and is not a braking/stopping allowance.

The existing authority envelope, by contrast, is defined around positively established usable Resolution Space.

> **Positive Witness Distance != Permitted Progression Distance.**

Therefore `.79` creates no speed target and no new authority policy. The remaining physical-response question must be answered separately after the semantic product is validated.

## Authority Triad

- **Architecture — unchanged.** Existing Spatial Negotiation and Runtime Responsibility architecture already own Resolution-Margin meaning and Regulation responsibility boundaries.
- **Specification — accepted in PR #217.** Situation Assessment owns the one-sided semantic evidence contract.
- **Source — `.79` implements only the Situation semantic bridge.** Downstream physical consumers remain intentionally absent.

The primary Situation Assessment Spec now classifies the two new production assessment modules and records the `.79` no-consumer boundary.

## Touch One; Validate Three — `.79`

**Touch One:** production Situation meaning only — a settled active worker's supported native progression positively consuming another current represented spatial claim inside the same Resolution-Space scope.

**Validate Three:** 

1. **Target positive — #216 world shape.** A settled worker progresses toward Current Space occupied by a manoeuvring/turning worker. Positive Resolution-Margin Demand must be published from the represented claim without requiring Current Excursion input.
2. **Negative neighbour.** A nearby/turning worker whose represented Current Space does not positively intersect the subject's supported progression must not manufacture positive demand from proximity, turn state or shared Operation membership.
3. **Established behaviour.** Existing Candidate, Decision, Current-Excursion/opposed-corridor Regulation, follower, Forward Intersection, Bubble and Passage behaviour must remain unchanged because `.79` introduces no downstream consumer. Structural validation explicitly rejects any `.79` Candidate/Decision/Responsibility/Authority/Control consumption of `resolutionMarginDemandKnowledge`.

A further fail-closed focused check requires usable representation fitness for both subject and represented target before positive demand is published.

## Validation boundary

The focused offline witness is `tests/replacement_core/resolution_margin_demand.lua`. It challenges positive current-space evidence, the negative neighbour, representation-fitness failure, and preservation of Operational Picture identity/epoch through Situation-layer composition.

`tests/test_resolution_margin_demand_structure.py` protects source ordering, Jurisdiction ownership, one-sided claim limits, diagnostic independence and the deliberate absence of downstream consumption.

The new focused Lua witness runs inside the existing main Lua validation collector. The Issue #67 two-outcome CI contract is not changed.

Offline validation can prove deterministic semantic behaviour and conformance. It cannot prove that live GIANTS evidence is physically complete or timely.

## Next bounded engineering step

First validate the `.79` semantic increment independently. Do not interpret a green `.79` as a collision fix.

If `.79` is accepted, the next activity returns to **Discuss / Hypothesise** for the unresolved authority question:

> Given positive Resolution-Margin Demand Evidence that deliberately lacks negative-clearance authority, what temporal magnitude may Bounded Authority legitimately permit, and from what additional positive evidence can that permission be derived without treating witness distance as safe traversable distance?

Only after that authority/evidence contract is agreed should Candidate or Regulation behaviour consume Resolution-Margin Demand.

Issues #170, #174 and #176 remain parked standards-work conformance concerns. Issue #210 remains a parked generated-source-reference improvement. Issues #45 and #172 are completed and closed.
