# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, accepted understanding needed to continue it, unresolved question, and next bounded engineering step.

It is **not** a repository-status dashboard. Git owns exact accepted chronology; executable-version owners own build identity; GitHub Issues and pull requests own their discussion state; canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative.

## Current engineering boundary — Issue #234 Corner semantics implementation

Issue #234 began from the S416 / Condor case in which operationally significant corner demand remained `OPEN_FIELD` because Corner discovery depended on pairwise Forward-Intersection geometry. Investigation established that the pairwise/shared-vertex model was too narrow and that the architecture must separate **Field-scoped Corner knowledge**, **assembly-to-Corner demand**, and **temporary right-of-way**.

The current accepted Architecture and Situation Assessment contract now express that revised Corner model. Production source has not yet been reconciled to it; the next increment is implementation discovery rather than further architectural invention.

## Current understanding

### Corner Feature and Headland Regime

A **Corner Feature** is a bounded structural transition in the Field World between persistent headland-work regimes. It is field-scoped and does not depend on a pair, a Forward Intersection, one literal polygon vertex or a particular assembly width.

The exact Field World polygon remains authoritative geometry. Structural Corner interpretation must tolerate polygon sampling detail: **Boundary Sample != Boundary Feature** and **Sampling Topology != Field Shape Topology**.

A Headland Regime does not cease to exist inside a Corner. After Corner Admission it becomes decision-dormant until Positive Corner Departure because native manoeuvring can produce many misleading headland positives and negatives.

> **Semantic Persistence != Decision Relevance**

### Corner Approach Demand and Admission

**Corner Approach Demand** is assembly-to-Corner Situation meaning that the assembly's currently evidenced bounded spatial demand is progressing into a known Corner Feature. Proximity alone, indefinite trajectory extension and pairwise intersection are insufficient.

Corner Admission is unilateral. Positive Corner Existence plus positive Corner Approach Demand is sufficient; no second assembly or pairwise quorum is required. Positive Headland Association heightens awareness and may inform later allocation, but negative or unresolved association does not negate Corner existence or Corner Approach Demand.

> **Corner Existence does not require traffic. Shared Corner Situation does not require shared Corner discovery.**

### Assembly-specific Corner demand

The Corner Feature is field-scoped; the operational demand placed around it is assembly-specific. Productive width may help establish pre-Corner headland association, while physical width, overall length, articulation and native manoeuvring reach materially affect Corner demand once admitted. Working width alone is not Corner manoeuvring demand.

For S416-class articulated assemblies, the travelled native run-out/alignment distance can exceed the static assembly length. OuttaMyWay must not replace that Reality with a guessed length multiplier, universal radius or timer.

### Decision ownership while inside the Corner

Once admitted, Corner state owns the decision domain until Positive Corner Departure. Headland positives/negatives, Forward-Intersection changes, transient headings, reverse motion, Passage changes and Responsibility transitions do not discharge the Corner relationship.

Competing Corner Approach Demand is the primary Situation basis from which downstream Decision can choose which assembly receives temporary permission to consume the Corner and which assembly is regulated. Headland association, current occupancy/engagement, available alternatives and Resolution Margin may inform that choice; none is a permanent priority rule.

### Positive Corner Departure

A8 is the positive truth of productive work. Everything remains **still in the Corner** until A8 crosses the correct spatial departure boundary.

Two Reality-derived paths are recognised:

- **continuous productive traversal** — A8 remains authoritative through a rounded/smooth Corner and Positive Corner Departure occurs only when productive A8 crosses the field-scoped outgoing Corner boundary;
- **manoeuvring traversal** — TURNING/reverse/shuffle/run-out may continue without productive A8. When GIANTS provides forward/reverse transitions, retain the **last** such transition position as the stronger assembly-specific departure-boundary anchor. Fresh productive A8 must positively cross that boundary before discharge.

No elapsed time, guessed travel distance, assembly-length multiplier, headland reclassification, FI negative or Responsibility replacement may manufacture Corner Departure.

## Authority Triad state

- **Architecture — reconciled.** `architecture/SPATIAL_NEGOTIATION_MODEL.md` owns the Field-scoped Corner Feature, unilateral demand/admission, decision-dormant in-Corner headland evidence, assembly-specific Corner demand and A8-crossing departure model.
- **Specification — reconciled.** `spec/SITUATION_ASSESSMENT.md` operationalises those semantics and states the targeted Reality challenges required of an implementation.
- **Source — known implementation drift.** `scripts/assessment/SpatialConstraintAssessment.lua` still implements the earlier pairwise/shared-vertex discovery and vertex/topology departure mechanism. Its `SITUATION_ASSESSMENT` participation remains truthful, but its mechanism must now be reconciled to the accepted contract.

Tests remain evidence, not Authority-Triad ownership. The documentation/contract reconciliation makes no executable or in-game validation claim.

## Next bounded engineering step

Begin a separate implementation increment from accepted `main` to answer:

> What is the smallest production mechanism that can realise Field-scoped Corner Features, unilateral Corner Approach Demand/Admission, decision-dormant in-Corner headland evidence, assembly-specific Corner demand and A8-positive departure without route prediction or new universal distance literals?

The first implementation experiment should preserve current successful Corner behaviour, expose the S416 / Condor case to the new semantics, and be validated against prior Corner scenarios before any broader tuning.

Issue #233 remains separate Corner-envelope measurement chatter. Issue #227 remains separate Cooperative Passage recovery/handback work.
