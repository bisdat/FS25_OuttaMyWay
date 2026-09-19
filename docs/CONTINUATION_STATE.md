# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, accepted understanding needed to continue it, unresolved question, and next bounded engineering step.

It is **not** a repository-status dashboard. Git owns exact accepted chronology; executable-version owners own build identity; GitHub Issues and pull requests own their discussion state; canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative.

## Current engineering boundary — PR #239 pre-merge closure

PR #239's validated runtime candidate is TEST **0.3.0.105**.

TEST `.105` is a GIANTS Reality PASS for the intended PR scope:

- Structural Field Shape / Corner Feature discovery remains field-scoped;
- current Corner Occupancy and Corner Arrival Priority protect the worker already in constrained Corner space, otherwise the earlier native/unrestricted arrival;
- fixed Corner and Forward-Intersection Regulation use the exact 1 km/h Intent-Revelation Creep without Resolution-Space envelope dependence;
- fixed Forward-Intersection role migration is supported;
- same-pair Forward-Intersection Regulation can be atomically succeeded by Cooperative Passage despite different Situation identities;
- Cooperative Passage revalidates stale arrangements from fresh execution origins;
- realised Transit geometry is consumed at the execution boundary; and
- current positive closing may start Passage capture before the literal Entry Boundary so disposable approach margin is not consumed while Hold settles.

The later TEST `0.3.0.106` experiment is **not** part of the accepted candidate. It attempted to resolve Issue #240 inside PR #239 by making Corner Approach Demand physically local. Two GIANTS Reality runs disproved that implementation because it also removed the early native Corner-arrival evidence needed for correct S416 / Condor allocation. The branch has therefore returned to the `.105` runtime behavior.

## Issue #240 — deferred, still open

Issue #240 remains a real but separate Corner-model question:

- full Field-World-bounded A8 continuation can establish Corner demand earlier than is semantically desirable; and
- retained Positive Corner Departure may block later same-Job re-entry to the same structural Corner.

The failed `.106` experiment added a further discovery:

> **Corner Arrival Evidence != Current Corner Approach Demand**

The next #240 investigation must separate prospective/current-supported **Corner Arrival Evidence** from local **Corner Approach Demand / Occupancy** and retained **Corner Engagement**. It must not restore remote retained Corner demand merely to recover correct arrival ordering.

#240 is deliberately **not** a merge condition for PR #239. Its implementation remains for a later engineering increment from accepted `main`.

## Authority Triad disposition for PR #239

- **Architecture — validated for PR #239 scope.** Current Structural Corner, Corner Arrival Priority, Regulation and Cooperative Passage responsibilities remain the intended model.
- **Specification — validated for PR #239 scope.** The governing contracts remain the authority for current implementation and for the still-open #240 discrepancy.
- **Source — restored to the Reality-validated `.105` implementation.** The only post-`.105` source change retained is corrected module documentation in `CooperativePassageControl.lua`; it does not change runtime behavior.
- **Tests — evidence, not authority.** The `.106` experiment and its failure remain historical validation evidence and do not redefine the accepted contract.

## Next bounded engineering step

Complete the final PR #239 merge-gate review against the restored `.105` runtime and current documentation.

If the repository-side checks remain green, PR #239 may be merged only on explicit repository-owner instruction.

After PR #239 is accepted, Issue #240 can resume as a separate Observe -> Discuss -> Hypothesise increment from accepted `main`.

Issue #227 remains separate Cooperative Passage recovery/handback work.
