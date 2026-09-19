# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, accepted understanding needed to continue it, unresolved question, and next bounded engineering step.

It is **not** a repository-status dashboard. Git owns exact accepted chronology; executable-version owners own build identity; GitHub Issues and pull requests own their discussion state; canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative.

## Current engineering boundary — PR #239 final Corner / Passage closure

PR #239 now contains the complete implementation candidate for the Structural Field Shape Corner lifecycle discovered through Issue #234, the subsequent Corner Arrival Priority corrections, the Cooperative Passage execution corrections through TEST `0.3.0.105`, and the two remaining Corner lifecycle defects recorded in Issue #240.

The latest executable candidate is TEST **0.3.0.106**. It is not yet an accepted repository state and requires independent CI plus GIANTS Reality validation before PR #239 may be treated as merge-ready.

## Current understanding

### Structural Corner knowledge and current demand

Field-scoped Structural Field Shape establishes persistent Corner Features independently of traffic. Current assembly demand remains separate:

- **Corner Occupancy** is positive present Physical-Assembly evidence and independently admits Corner Engagement when Reality already consumes the feature.
- **Corner Approach Demand** requires current productive A8 plus assembly-specific current physical reach into the structural Corner. A full Field-World-bounded continuation to a distant boundary is topology, not present Corner demand.
- no universal Corner radius, distance tail, timer or predicted GIANTS turn route is introduced.

This restores the valid locality insight first explored in `.99` without regressing the `.100/.105` discovery that an already-present Corner occupant must be protected independently of approach prediction.

> **Field-Bounded Continuation To A Corner != Current Corner Approach Demand**

### Corner lifecycle and repeated traversal

Positive Corner Departure settles one traversal's retained Engagement. It does not permanently exclude the same assembly from the same structural Corner for the rest of the GIANTS Job Episode.

Fresh later Corner Approach Demand or current Corner Occupancy supersedes the historical departure record and establishes a new Engagement.

> **Positive Corner Departure != Permanent Same-Job Corner Exclusion**

### Corner allocation

Shared Corner Decision remains current-evidence based:

1. positive current constrained Corner Occupancy is arrival now and receives temporary right-of-way over a non-occupant;
2. otherwise compare supported native/unrestricted time-to-Corner;
3. protect the earlier arrival and regulate the later at the fixed 1 km/h Intent-Revelation Creep;
4. Corner Engagement age is lifecycle provenance, not priority evidence.

### Cooperative Passage state retained

The `.101-.105` corrections remain part of the same PR:

- execution-origin rebase does not preserve stale Passage arrangement authority;
- realised Transit configuration geometry is consumed at the execution boundary;
- fixed Forward-Intersection Regulation role migration does not depend on Resolution-Space envelopes;
- same-pair Forward Intersection Regulation may be atomically succeeded by Cooperative Passage despite different conflict identities;
- current positive closing progression may require Passage capture before the literal Entry Boundary, using the 1.0 s Control-response Capture Acquisition Horizon while preserving the separate 3 m Entry Control Allowance.

TEST `0.3.0.105` is a GIANTS Reality PASS for those Passage/Corner-allocation paths. TEST `0.3.0.106` changes only the Issue #240 Corner demand/re-entry semantics plus documentation.

## Authority Triad state

- **Architecture — reconciled.** `architecture/SPATIAL_NEGOTIATION_MODEL.md` owns Structural Corner semantics, current demand/occupancy, Corner Arrival Priority, traversal-scoped Positive Departure and same-Job re-admission.
- **Specification — reconciled.** `spec/SITUATION_ASSESSMENT.md` operationalises local current Corner Approach Demand, independent Occupancy admission, traversal-scoped departure and fresh re-entry.
- **Source — implementation candidate reconciled.** `scripts/assessment/SpatialConstraintAssessment.lua` now bounds Approach Demand by assembly-specific current physical reach and permits fresh demand/occupancy to replace a prior departure record. Acceptance still depends on CI and GIANTS Reality.
- **Tests — evidence, not authority.** Focused Corner fixtures distinguish distant bounded continuation from local current demand and challenge same-Job Occupancy re-entry after Positive Departure.

## Next bounded engineering step

Validate TEST `0.3.0.106` without broadening PR #239:

1. GitHub Actions must pass the repository Structural and Lua offline behavioural contracts.
2. GIANTS Reality must preserve the validated `.105` first Condor/Patriot Corner, S416/Condor Corner, all three Cooperative Passages and final Corner allocation.
3. The log must no longer show Corner Engagement being established hundreds of metres away solely because A8's Field-World-bounded continuation eventually contacts that Corner.
4. A later same-Job return to a positively departed structural Corner must be able to establish a new Engagement from fresh local demand or current Occupancy.

If those checks pass, close Issue #240 with PR #239, perform the final documentation/merge-gate review, and merge only on explicit repository-owner instruction.

Issue #227 remains separate Cooperative Passage recovery/handback work.
