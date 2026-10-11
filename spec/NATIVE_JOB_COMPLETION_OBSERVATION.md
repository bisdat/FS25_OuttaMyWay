# Native Job Completion Observation Specification

## Identity and authority

**Specification Jurisdiction:** Native Job Completion Observation  
**Jurisdiction ID:** `NATIVE_JOB_COMPLETION_OBSERVATION`

**Primary Architecture Authority:** [Completion-Triggered Terminal Egress — Investigation Boundary](../architecture/COMPLETION_TRIGGERED_TERMINAL_EGRESS.md#specification-jurisdiction--native-job-completion-observation)

This is a DIAGNOSTIC, read-only GIANTS FIELDWORK termination-reason experiment. Its output is not an actionable Terminal Egress request. It does not audit completed agronomy, adopt job termination as physical Control authority, or modify existing Hold & Relocate / Reactive Static Blocker Recovery.

## Candidate native signal

GIANTS source documents `AISystem:stopJobInternal(job, aiMessage)` forwarding the original `aiMessage` through `g_messageCenter:publish(MessageType.AI_JOB_STOPPED, job, aiMessage)`, after `job:stop` and removal. Subscribe to that message using GIANTS' message-center contract on the authoritative server; do not intercept, wrap or replace GIANTS job, vehicle or field-worker methods.

Filter only positively identified `AIJobFieldWork` instances using the GIANTS class hierarchy `isa` interface. Classify `AIMessageSuccessFinishedJob` with the same class hierarchy test, retaining non-success and unknown identities in diagnostic evidence; do not infer success from `onAIJobFinished`, job absence, generic OK message type or text formatting.

Capture native job identity, available vehicle root identity, observed reason identity, positive success-class boolean and build. Emit at most one diagnostic stop report per observed job object. Emit no reports when Configuration is disabled or unresolved, or on a non-server runtime. Subscribe on map load, unsubscribe on map teardown, and clear retained identity state. An unavailable message, unknown job class, lost event or late subscription does not license inferred completion.

## Validation

The probe is a **source-supported hypothesis**, not in-game confirmation of FS25 1.24 behaviour. GitHub Actions checks structural and offline witness behaviour. In-game validation must compare:
1. natural FIELDWORK completion (prefer TS003);
2. deliberate manual FIELDWORK stop;
3. OMW-induced native job replacement / blocked-worker recovery handback;
4. native FIELDWORK failure or interruption.

For each, inspect actual stop-message class, timing and job/vehicle association. In particular validate whether the success class is ever delivered for a manual stop or an OMW replacement. Any such counterexample invalidates the candidate positive-admission rule; preserve that result as evidence.

The experiment MUST NOT issue TRANSIT, stop/start/replace AI jobs, run relocation, register navigation agents or modify Control/Regulation. Existing paired, solo and static relocation mechanics remain unchanged.

## Implementation traceability

- **Primary source:** `scripts/observation/NativeJobCompletionProbe.lua`
- **Integration:** `scripts/main.lua` loads and registers the passive mod listener.
- **Native reference:** GIANTS `AISystem.stopJobInternal` and `AIJobFieldWork.stop` source documentation.
- **Relevant tests:** offline source and callback contract tests, followed by GIANTS Reality evidence recorded against #476.
