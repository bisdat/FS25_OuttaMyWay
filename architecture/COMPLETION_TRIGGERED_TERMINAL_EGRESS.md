# Completion-Triggered Terminal Egress — Investigation Boundary

## Purpose

Completion-Triggered Terminal Egress is a proposed post-Job Episode responsibility tracked by [Issue #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476). It may eventually place a finished Physical Assembly in TRANSIT and settle the complete assembly safely outside its original field. No movement policy or admission of that physical responsibility is established by the present investigation.

GIANTS retains native FIELDWORK termination and agronomic authority. OuttaMyWay must not independently audit whether agronomy is complete. A manually stopped, cancelled, replaced or otherwise non-successfully terminated job must not initiate completion-triggered relocation.

## Specification Jurisdiction — Native Job Completion Observation

**Jurisdiction ID:** `NATIVE_JOB_COMPLETION_OBSERVATION`  
**Primary Specification:** [Native Job Completion Observation](../spec/NATIVE_JOB_COMPLETION_OBSERVATION.md)

**Responsibility:** passively observe GIANTS' native FIELDWORK job-stop reason, preserving the native job and vehicle identity and distinguishing an `AIMessageSuccessFinishedJob` class from other or unresolved reasons. The stop-reason observation remains DIAGNOSTIC; an independently admitted Completion Transit consumer now requests only transport configuration on native successful FIELDWORK termination.

The native `MessageType.AI_JOB_STOPPED` message is a candidate observation boundary: GIANTS `AISystem:stopJobInternal` publishes the terminated job and its original `aiMessage` after native `job:stop`. Unlike vehicle `onAIJobFinished`, this boundary carries the termination reason.

**Success-class witness != proof of field agronomy completeness.** A positive class observation is a candidate semantic signal, not yet a validated completion admission contract. In particular, source-derived class identity alone must not be used to actuate a vehicle until natural completion, manual stop, OMW job replacement and native failure have been discriminated by GIANTS Reality.

## Non-regression and future decisions

This investigation must not alter active-worker paired or solo Hold & Relocate, Reactive Static Blocker Recovery, existing Control and handback, or Configuration. Physical movement, parking allocation and off-field settlement remain separate #476 decisions. Completion TRANSIT may request existing native transport commands without entering BWR Control.

A future physical responsibility needs its own positive and supersedable authority, original field identity, kinematic feasibility, complete-assembly settlement, and interruption contract. Diagnostic publication neither reserves parking nor implies authority.

## Specification Jurisdiction — Completion Transit

**Jurisdiction ID:** `COMPLETION_TRANSIT`  
**Primary Specification:** [Completion Transit](../spec/COMPLETION_TRANSIT.md)

An independently admitted and request-only capability consumes positive `AIMessageSuccessFinishedJob` evidence after GIANTS FIELDWORK stops. It uses an isolated instance of the current native TRANSIT mechanism and the existing native plan builder. It never moves an assembly or asserts readiness merely because commands were sent. Missing native capability is a reported failure, not an implicit success. Product disabling relinquishes request state without restoring WORKING configuration to finished equipment.

Completion TRANSIT was validated by CI and TS019 at TEST `0.5.4.2`, accepted in merged PR #480 and promoted to PATCH `0.5.5.0`. It currently uses the global product-enabled setting. A dedicated persisted player choice remains an open Issue #476 requirement for subsequent capability work, but is not a prerequisite to preserving the request-only TRANSIT baseline. Completion transit and blocked-first Hold & Relocate must never share control ownership or request caches. Later physical parking/relocation requires fresh architectural admission.
