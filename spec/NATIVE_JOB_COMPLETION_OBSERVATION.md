# Native Job Completion Observation Specification

## Identity and authority

**Specification Jurisdiction:** Native Job Completion Observation  
**Jurisdiction ID:** `NATIVE_JOB_COMPLETION_OBSERVATION`

**Primary Architecture Authority:** [Completion-Triggered Terminal Egress — Investigation Boundary](../architecture/COMPLETION_TRIGGERED_TERMINAL_EGRESS.md#specification-jurisdiction--native-job-completion-observation)

This is a DIAGNOSTIC, read-only GIANTS FIELDWORK termination-reason experiment. Its output is not itself an actionable Terminal Egress request; only a positive class witness may be forwarded to the separately specified request-only Completion Transit consumer. It does not audit completed agronomy, adopt job termination as physical Control authority, or modify existing Hold & Relocate / Reactive Static Blocker Recovery.

## Candidate native signal

GIANTS source documents `AISystem:stopJobInternal(job, aiMessage)` forwarding the original `aiMessage` through `g_messageCenter:publish(MessageType.AI_JOB_STOPPED, job, aiMessage)`, after `job:stop` and removal. Subscribe to that message using GIANTS' message-center contract on the authoritative server; do not intercept, wrap or replace GIANTS job, vehicle or field-worker methods.

Filter only positively identified `AIJobFieldWork` instances using the GIANTS class hierarchy `isa` interface. Classify `AIMessageSuccessFinishedJob` with the same class hierarchy test, retaining non-success and unknown identities in diagnostic evidence; do not infer success from `onAIJobFinished`, job absence, generic OK message type or text formatting.

Capture native job identity, available vehicle root identity, observed reason identity, positive success-class boolean and build. Emit at most one diagnostic stop report per observed job object. Emit no reports when Configuration is disabled or unresolved, or on a non-server runtime. Subscribe on map load, unsubscribe on map teardown, and clear retained identity state. An unavailable message, unknown job class, lost event or late subscription does not license inferred completion.

## Read-only active Source Field association experiment

Positive FIELDWORK completion identifies a native job and vehicle, **not** its
registered Source Field. The GIANTS v1.20 field-course strategy constructs
`fieldDetectionX/Z` when it commissions native field-course generation.
That detection position is an evidence *candidate*, not a documented
positive field identity or a licence for post-job Control.

When DIAGNOSTIC publication is explicitly enabled, the completion observer
may perform a bounded, read-only 1-second sampling of the native
`aiSystem.activeJobVehicles` registry. For each actively working
`AIJobFieldWork` object, a live FieldCourse strategy with an existing
`aiFieldCourse` and finite `fieldDetectionX/Z` supplies a candidate seed.
The seed must be contained in exactly one registered field polygon, associated
with the same native job reference while it is active. Missing registry,
active strategy, seed, polygon or unambiguous registered-field identity is
**no candidate**, not fallback to the vehicle's post-stop root position or
a displayed farmland label. A missing seed after native course reconstruction
is a legitimate unknown until empirically qualified.

Retain the candidate against that native job for the natural success callback,
publish **one** `NATIVE_COMPLETION_SOURCE_FIELD_CANDIDATE` DIAGNOSTIC
observation (or explicit `NOT_OBSERVED`) and offer the candidate as optional
read-only completion metadata. It MUST NOT affect the existing
Completion Transit request, parking admission, destination allocation,
movement or handback; those retain the accepted Field 77 restriction.
Non-success stops never publish a candidate-completion event.
Ordinary NORMAL/DEBUG gameplay MUST NOT commission the source-field census.
The experiment does not inspect native job data by mutating AI callbacks.

**GIANTS falsification:** TS019 must produce a candidate native Field 77
for both successful jobs without changing their physical parking. Riverbend
displayed Farmland 2 must produce registered Field 29 if its native
FIELDWORK course detection seed is inside the correct field. If native
course detection has nil, outside-field, ambiguous or stale coordinates,
record the actual result and do **not** promote this candidate rule to
authoritative Job Episode Source Field identity. Repeat on native job
interruption/supersession; a candidate tied to the wrong job is invalid.

## Validation

The candidate native event was validated within a bounded FS25 `1.24.0.0` test envelope: TS019 distinguished manual stop from successful FIELDWORK completion; TS003 observed a Hold & Relocate stop/restart without false success classification. Other native failure and replacement variants remain unvalidated. GitHub Actions checks structural and offline witness behaviour. In-game validation must compare:
1. natural FIELDWORK completion (prefer TS003);
2. deliberate manual FIELDWORK stop;
3. OMW-induced native job replacement / blocked-worker recovery handback;
4. native FIELDWORK failure or interruption.

For further validation, inspect actual stop-message class, timing and job/vehicle association. In particular validate whether the success class is ever delivered for a manual stop or an OMW replacement. Any such counterexample invalidates the candidate positive-admission rule; preserve that result as evidence.

The Observer itself MUST NOT issue TRANSIT, stop/start/replace AI jobs, run relocation, register navigation agents or modify Control/Regulation. A separately governed Completion Transit consumer may respond to positive evidence with transport-configuration requests only. Existing paired, solo and static relocation mechanics remain unchanged.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/observation/NativeJobCompletionProbe.lua`](../scripts/observation/NativeJobCompletionProbe.lua) | `REALISES` |
| [`scripts/observation/CompletionSourceFieldObservation.lua`](../scripts/observation/CompletionSourceFieldObservation.lua) | `SUPPORTS` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/native_job_completion_probe.lua`](../tests/shell/native_job_completion_probe.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |

## Implementation traceability

- **Primary source:** `scripts/observation/NativeJobCompletionProbe.lua`
- **Integration:** `scripts/main.lua` loads and registers the passive mod listener.
- **Native reference:** GIANTS `AISystem.stopJobInternal` and `AIJobFieldWork.stop` source documentation.
- **Relevant tests:** offline source and callback contract tests, followed by GIANTS Reality evidence recorded against #476.
