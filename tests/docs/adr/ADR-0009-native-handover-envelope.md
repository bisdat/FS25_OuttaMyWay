# ADR-0009 — Native Handover Envelope and Control-to-Awareness Reversion

**Status:** Accepted architectural responsibility boundary; experimental implementations are inactive in v4.6.71

**Date:** 2026-08-04

## Context

The v4.6.57–v4.6.59 evidence repeatedly moved the failure boundary into restoration and handback machinery:

- v4.6.57 bundled OuttaMyWay deployment, permission release and native continuation and froze near deployment completion;
- v4.6.58 returned configuration authority while retaining the Traffic Permission Gate, but GIANTS never progressed its native configuration state;
- v4.6.59 replaced the gate with a zero-speed lease, but the selected-speed actuator did not establish a stationary translation capability and the game froze earlier.

These failures exposed **Exact Rejoin Overreach**: OuttaMyWay was attempting to reconstruct the pre-intervention pose, working configuration and AI continuation even though its cooperative obligation is only to clear the conflict and return the displaced worker to a viable native continuation state.

A possible CPU/physics-call contribution remains unproven. Farming Simulator is commonly observed to be CPU-bound, but the repository evidence does not establish call volume as the freeze cause. This amendment reduces physics/control calls and concentrated engine-state mutation without claiming a root-cause diagnosis.

## Decision

Adopt the **Native Handover Envelope**:

> A bounded position-and-heading region from which the original GIANTS worker can plausibly reacquire and continue its existing job without further OuttaMyWay route or configuration control.

The active Native Reposition lifecycle becomes:

```text
conflict clearance
→ refuge entry
→ positive passage evidence
→ approximate native return
→ Native Handover Envelope
→ unrestricted GIANTS handover
→ normal Situation Assessment
```

The envelope requires current evidence that:

- the Progress participant has safely passed;
- relevant separation remains clear;
- the displaced assembly is inside the known field boundary;
- its position is within a bounded radius of the approximate return centre;
- its heading is broadly compatible with the interrupted working direction;
- it is not currently blocked.

The envelope does not require the exact interrupted coordinates, exact lane centre, exact heading or restored working configuration.

## Responsibility boundary

**OuttaMyWay owns:**

- conflict clearance;
- refuge selection and displacement;
- safe refuge waiting;
- approximate return;
- handover-envelope admissibility;
- relinquishment of temporary movement, configuration and job-progression authority;
- subsequent normal Situation Assessment.

**GIANTS owns after handover:**

- exact route reacquisition;
- lane alignment;
- unfolding, lowering and working-state restoration;
- job-state recovery;
- continuation of the original task.

OuttaMyWay performs no deployment command, no delegated-restoration controller, no translation lease, no `aiContinue` or continuation-event restart burst, no handback retry and no native movement nudge in this path.

## Control-to-Awareness Reversion

Native Reposition capability completion means that the handover envelope was achieved and temporary authority was relinquished. It does not mean that the governing Commitment is complete.

After handover, OuttaMyWay immediately returns to **normal Situation Assessment**. The existing Commitment remains observable until Safe Release is established. GIANTS success, blockage, non-continuation or a newly developing conflict are interpreted through the ordinary Operational Picture rather than a private restoration micro-state.

## Purpose-Derived Motion

Phase names do not own fixed speeds. The active controller uses one transit ceiling and derives any lower command from:

- remaining stopping distance;
- target-capture tolerance;
- steering curvature;
- bounded lateral acceleration.

The former `15 → 6 → 4` phase sequence is rejected as unjustified implementation inheritance. A turn is admissible only when it serves conflict clearance, refuge entry or minimum orientation toward the Native Handover Envelope. The return-orientation step is conditional rather than mandatory.

## Consequences

- Exact rejoin is no longer a Control completion obligation.
- ADR-0007 and ADR-0008 remain decision history, but their constrained native-restoration implementation paths are superseded.
- **Constraint Semantics Mismatch** and **Zero-Speed Authority Fallacy** remain accepted discoveries.
- Capability completion and Commitment completion remain separate under ADR-0006.
- Safe Release remains the normal Commitment-completion gate.
- TS015 is the first validation fixture; no fixture-specific Decision policy is introduced.
- The architecture of the other passing vehicle, including its later manoeuvring, is explicitly reserved for the next discussion and is not changed by v4.6.62.

## Validation obligations

The v4.6.62 runtime test must establish whether:

1. refuge entry and passage remain valid;
2. return motion contains only purpose-bearing turns and purpose-derived speed changes;
3. handover occurs inside the Native Handover Envelope before any OuttaMyWay deployment action;
4. all temporary authority is relinquished without a translation lease or dedicated Restore phase;
5. the game remains responsive at handover;
6. GIANTS independently resolves exact positioning and configuration;
7. normal Situation Assessment observes the resulting Reality and Safe Release remains separate.

## v4.6.62 implementation clarification — execution-path restoration

Authority relinquishment requires more than removing active commands and hold records. Any vehicle-specific interception acquired by Control must be released symmetrically so the receiving GIANTS worker again owns its pre-intervention execution path. The permission interception therefore retains the exact original method and restores that exact identity at handover, cancellation, external job termination and controller/runtime clear. Restoration is identity-safe and must not overwrite a later replacement.

This clarification does not change the Native Handover Envelope or assign exact route/configuration recovery to OuttaMyWay. It makes interception teardown a Commitment precondition for claiming temporary authority relinquished.

## v4.7.29 amendment — BNIR evidence lifetime across restoration

BNIR may supply useful stage evidence before operational configuration is restored, but that Local Intent is not presumed to survive a later re-Hold or material configuration mutation. Intent Expiry applies. After restoration is verified, the Native Handover Envelope is the point at which GIANTS demonstrates fresh operational Local Intent and independent continuation in the configuration that will actually continue work. The governing Commitment and Traffic Policeman remain responsible until Safe Release; Native Handover is not itself Encounter termination.
