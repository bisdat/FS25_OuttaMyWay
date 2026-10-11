# Completion-Triggered Terminal Egress — Investigation Boundary

## Purpose

Completion-Triggered Terminal Egress is a proposed post-Job Episode responsibility tracked by [Issue #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476). It may eventually place a finished Physical Assembly in TRANSIT and settle the complete assembly safely outside its original field. No movement policy or admission of that physical responsibility is established by the present investigation.

GIANTS retains native FIELDWORK termination and agronomic authority. OuttaMyWay must not independently audit whether agronomy is complete. A manually stopped, cancelled, replaced or otherwise non-successfully terminated job must not initiate completion-triggered relocation.

## Specification Jurisdiction — Native Job Completion Observation

**Jurisdiction ID:** `NATIVE_JOB_COMPLETION_OBSERVATION`  
**Primary Specification:** [Native Job Completion Observation](../spec/NATIVE_JOB_COMPLETION_OBSERVATION.md)

**Responsibility:** passively observe GIANTS' native FIELDWORK job-stop reason, preserving the native job and vehicle identity and distinguishing an `AIMessageSuccessFinishedJob` class from other or unresolved reasons. For the current increment the evidence is strictly DIAGNOSTIC, with no consumer able to admit, plan or execute Terminal Egress.

The native `MessageType.AI_JOB_STOPPED` message is a candidate observation boundary: GIANTS `AISystem:stopJobInternal` publishes the terminated job and its original `aiMessage` after native `job:stop`. Unlike vehicle `onAIJobFinished`, this boundary carries the termination reason.

**Success-class witness != proof of field agronomy completeness.** A positive class observation is a candidate semantic signal, not yet a validated completion admission contract. In particular, source-derived class identity alone must not be used to actuate a vehicle until natural completion, manual stop, OMW job replacement and native failure have been discriminated by GIANTS Reality.

## Non-regression and future decisions

This investigation must not alter active-worker paired or solo Hold & Relocate, Reactive Static Blocker Recovery, existing Control and handback, or Configuration. Physical movement, parking allocation, off-field settlement, transport configuration and new player-choice semantics remain separate #476 decisions.

A future physical responsibility needs its own positive and supersedable authority, original field identity, kinematic feasibility, complete-assembly settlement, and interruption contract. Diagnostic publication neither reserves parking nor implies authority.
