# Active Log Publication producer census

## Purpose and evidence boundary

Bounded static census of the modules explicitly sourced by `scripts/main.lua`, reconciled with the current Log Publication Architecture and Specification. Each row describes one emitted event code, its trigger, its previous and proposed publication Descriptor, payload significance and producing cadence. This is an engineering audit, not a second publication policy or a chronology of releases. Source and GIANTS Reality can disprove the proposed classifications.

`N`, `D`, `G` in the table denote NORMAL, DEBUG and DIAGNOSTIC. `I`, `W`, `E` denote INFO, WARNING and ERROR; the two axes are independent. `—` means not applicable. Before/after reflect active source at the audit baseline and the proposed producer implementation.

## Event-by-event census

### Product shell — `scripts/main.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `OUTTAMYWAY_SHELL_STARTED` | Resolved shell activation | N/I → N/I | version, enabled, aiControl | — | Once per successful startup; sole routine version record |
| `CONFIGURATION_STORAGE_FAILED` | Startup configuration cannot resolve | N/E → N/E | version, reason | — | Startup alternative; version provenance justified for failed shell |
| `OUTTAMYWAY_SHELL_ENABLED` | Durably enabled | N/I → N/I | aiControl | — | One durable change; removed repeated version |
| `OUTTAMYWAY_SHELL_DISABLED` | Durably disabled | N/I → N/I | aiControl | — | One durable change; removed repeated version |

### Hold & Relocate — `scripts/coordination/LiveHoldRelocateRuntime.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `HOLD_RELOCATE_RUNTIME_ACTIVE` | Server listener begins | N/I → D/I | — | listener status | Once per map; not a fieldwork transition |
| `HOLD_RELOCATE_ADMISSION_REJECTED` | Candidate does not acquire responsibility | N/W → D/I | — | candidate kind, pair, rejection reason, blocked duration | Once per native blocked occurrence; no Control attempted |
| `HOLD_RELOCATE_STARTED` | Coordinator accepts intervention | N/I → N/I | commitment, kind, pair identity | — | Once per admitted attempt; only minimal identity |
| `HOLD_RELOCATE_ADMISSION_EVIDENCE` | Accepted attempt causal details | — → D/I | — | plan choice, steering, geometry, demand | Once per admitted attempt; projected only after DEBUG eligibility |
| `HOLD_RELOCATE_EGRESS_STARTED` | Physical egress movement begins | D/I → D/I | — | direction, space, speeds and constraints | One per motion start; lazy text |
| `HOLD_RELOCATE_STEERING_SELECTION` | Steering alternative selected | D/I → D/I | — | selected vs geometry preference and evidence counts | One per selected steering start; lazy text |
| `HOLD_RELOCATE_STEERING_CANDIDATES` | Engineering shortlist examined | G/I → G/I | — | ranked candidate geometry and demand | Finite shortlisted candidates after explicit DIAGNOSTIC gate |
| `HOLD_RELOCATE_STATIC_ACTUATION_EVIDENCE` | Static-blocker Control result | D/I → D/I | — | native calls, movement, status | Once per evidence object; lazy text |
| `HOLD_RELOCATE_INITIAL_REVERSE_VECTOR` | First reverse vector captured | D/I → D/I | — | relative angle evidence | Once per evidence object; lazy text |
| `HOLD_RELOCATE_EGRESS_REGULATION_EVIDENCE` | Nonmover regulation result | D/I → D/I | — | intercepts, displacement, actual speeds | Once per result; lazy text |
| `PAIR_TRANSIT_SETTLEMENT_EXHAUSTED` | Transit readiness window ends but egress assessment continues | N/W → D/I | — | elapsed time, fold status, continuation action | Once per result; expected continuation is not an operational failure |
| `HOLD_RELOCATE_OUTCOME` | Coordinator reports final result and handback | N/I or N/W → N/I or N/W | status, reason | — | Once per attempt; successful native restart/static move INFO, other outcomes WARNING |
| `HOLD_RELOCATE_UNRESOLVED` | Native cleanup/relinquishment unconfirmed | N/W → N/W | reason | — | Only on genuine failed cleanup or active unresolved Control |
| `HOLD_RELOCATE_NOT_STARTED` | Commitment did not start physical intervention | N/W → N/W | reason | — | Once per unsuccessful committed attempt |

### Completion TRANSIT — `scripts/control/CompletionTransitRuntime.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `COMPLETED_WORKER_TRANSIT_REQUESTED` | GIANTS accepted native TRANSIT request | N/I → N/I | worker root, job ID, request-only caveat | — | Once per successfully completed native job; not proof of final transit pose |
| `COMPLETED_WORKER_TRANSIT_UNAVAILABLE` | Native TRANSIT request unavailable | N/W → N/W | worker root, job ID, reason | — | Once per completion attempt |

### Completion Parking — `scripts/control/CompletionSettlementRuntime.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `COMPLETION_SETTLEMENT_PLANNING_STARTED` | Finite route planning begins | N/I → D/I | — | worker root and budget | Once per initial planning episode |
| `COMPLETION_SETTLEMENT_LOCAL_HANDOFF_PLANNING` | Stopped extended approach enters local planning | N/I → D/I | — | worker root and handoff state | Once per handoff |
| `COMPLETION_SETTLEMENT_ALLOCATING_REGION` | Fallback parking-region search begins | N/I → D/I | — | worker root and causal reason | One per allocation search |
| `COMPLETION_SETTLEMENT_REGION_CLAIMED` | Candidate region reserved | N/I → D/I | — | station, pose, peer evidence, cost | Once per claimed region; lazy payload |
| `COMPLETION_SETTLEMENT_ALREADY_AT_QUALIFIED_ENTRY` | Long approach requires no extra leg | N/I → D/I | — | worker root | Once per zero-leg handoff |
| `COMPLETION_SETTLEMENT_QUEUED` | Serial parking request waits | N/I → D/I | — | root, ordinal | Once on queue admission; no new Control |
| `COMPLETION_SETTLEMENT_ALTERNATIVE_QUEUED` | Stopped retry yields to another completion | N/I → D/I | — | root, cause | Once per allowed alternative |
| `COMPLETION_SETTLEMENT_DEFERRED_FOR_PARKING_SPACE` | Stopped handoff yields temporarily | N/I → D/I | — | root, cause, queue position | Once per stopped-entry deferral |
| `COMPLETION_SETTLEMENT_QUEUED_REJECTED` | Queued worker superseded or player claimed | N/W → D/I | — | root, cause | Once per invalidated pending request; expected refusal |
| `COMPLETION_SETTLEMENT_SCENE_ADMISSION_FAILED` | Scene evidence cannot support candidate | N/W → D/I | — | cause, scan counters, failed root | Once per finite failed candidate; later final result remains NORMAL |
| `COMPLETION_SETTLEMENT_LOCAL_ENTRY_REJECTED` | Actual pose does not satisfy local-entry nominal test | N/W → G/I | — | actual/qualified pose, stations, sorted rejections | Once per refused handoff; expensive sorting only when eligible |
| `COMPLETION_SETTLEMENT_NOT_ADMITTED` | Final no-route/no-claim result; or player supersession | N/W → N/W or D/I | root and reason on operational failure | player-claim explanation | Once per failed admission; expected player claim is DEBUG INFO |
| `COMPLETION_SETTLEMENT_ADMITTED` | Physical parking route admitted, not completed | N/I → N/I | root, field, edge, stage, method, verification caveat | — | Once before first movement; does not claim physical terminal success |
| `COMPLETION_SETTLEMENT_ADMISSION_EVIDENCE` | Admission decision details | — → D/I | — | planning counts, peer evidence, estimated route geometry | Once with admission; payload built only when DEBUG eligible |
| `COMPLETION_SETTLEMENT_LEG_STARTED` | Movement leg starts | N/I → D/I | — | leg, vector, pose target, commanded speed | One per actual leg; formatted only when DEBUG eligible |
| `COMPLETION_SETTLEMENT_STOPPING` | Planned direction change or terminal stop begins | N/I → D/I | — | leg and reason | Once per commanded stop |
| `COMPLETION_SETTLEMENT_LEG_FINISHED` | Movement leg physically stops | N/I → D/I | — | speed, steady time, cruise state | One per completed stop/leg |
| `COMPLETION_SETTLEMENT_ALTERNATIVE_STOPPING` | Safe stop begins for re-evaluation | N/W → D/I | — | root and invalidated route reason | Once per attempted alternative; safe correction is not an error |
| `COMPLETION_SETTLEMENT_ALTERNATIVE_STOPPED` | Safe stop confirmed before replan | N/I → D/I | — | steady time, cruise | Once per alternative |
| `COMPLETION_SETTLEMENT_NEUTRALIZE_UNCONFIRMED` | Native stop cannot be confirmed | N/W → N/W | root and native reason | — | Once per affected termination; do not claim safe release |
| `COMPLETION_SETTLEMENT_CLAIM_RETAINED` | Claim cannot be released after uncertain stop | N/W → N/W | root and reason | — | Once per retained claim; safety consequence is material |
| `COMPLETION_SETTLEMENT_FINISHED` | Nominal terminal verification succeeds | N/I → N/I | root, phase, leg, reason | — | Once on verified nominal finish; GIANTS Reality still decides physical validity |
| `COMPLETION_SETTLEMENT_INTERRUPTED` | Active procedure terminates before nominal success | N/W → N/W or N/I | root, phase, leg, reason | — | Once per interruption; deliberate disable/relinquish INFO, other interruptions WARNING |
| `COMPLETION_SETTLEMENT_MOTION_SAMPLE` | Diagnostic movement sampling | G/I → G/I | — | pose, heading, actual speed, target, phase | At most 1 Hz during active motion; pre-gated before pose sampling |

### Native blocked Observation — `scripts/observation/NativeBlockageObservation.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `NATIVE_BLOCKAGE_PAIR_CANDIDATE` | One qualifying pair pulse | D/I → D/I | — | root identities, pair, separation, duration | Once per blocked occurrence; reciprocal observations coalesced |
| `NATIVE_BLOCKAGE_NO_LOCAL_WORKER` | Qualifying solo pulse | D/I → D/I | — | root, duration, no local peer | Once per blocked occurrence |
| `NATIVE_BLOCKAGE_ENCOUNTER_SNAPSHOT` | Solo encounter snapshot available | D/I → D/I | — | bounded scene description | Once per solo pulse; expensive description deferred |

### Native completion Observation — `scripts/observation/NativeJobCompletionProbe.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `NATIVE_FIELDWORK_JOB_STOPPED` | Native fieldwork job stop captured | G/I → G/I | — | job ID, root, GIANTS message class, success witness | One per native job identity; independent of completion Control |

### Native continuation witness — `scripts/diagnostics/NativeContinuationWitness.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `NATIVE_CONTINUATION_WITNESS` | Post-interruption native sample | G/I → G/I | — | native job/strategy/drive, Control attribution and proximity | Finite scheduled samples only while explicitly eligible |
| `NATIVE_CONTINUATION_WITNESS_ENDED` | Witness ends | G/I → G/I | — | terminal witness summary | Once on instrument termination |

### Pair clearance witness — `scripts/diagnostics/PairClearanceWitness.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `PAIR_CLEARANCE_OBSERVATION` | Egress/handback observation milestone | G/I → G/I | — | nominal gaps, pose, headings, derivative | Finite milestone/offset samples; geometry suppressed at source |

### Reverse kinematics probe — `scripts/diagnostics/ReverseKinematicsProbe.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `REVERSE_KINEMATICS_START` | Reverse sensor window opens | G/I → G/I | — | root, steering region, tool frames | Only eligible reverse starts |
| `REVERSE_KINEMATICS_SAMPLE` | Bounded reverse sensor sample | G/I → G/I | — | pose, transform operands, counterfactual bearings | At most 11 samples/5 seconds, after explicit DIAGNOSTIC gate |
| `REVERSE_KINEMATICS_END` | Reverse window closes | G/I → G/I | — | elapsed, reason, final progress | Once per instrument termination |

### Configuration GUI — `scripts/gui/ConfigurationSettingsExtension.lua`

| Event code | Trigger / established fact | Before → after | Minimum NORMAL payload | DEBUG / DIAGNOSTIC evidence | Cadence / rationale |
| --- | --- | --- | --- | --- | --- |
| `CONFIGURATION_CHANGE_PERSISTENCE_FAILED` | Durable setting write fails | N/W → N/W | setting and reason | — | On failure only; player choice not fabricated |
| `CONFIGURATION_SECTION_UNAVAILABLE` | Required General Settings section cannot attach | N/W → N/W | reason | — | Only on unavailable hook/layout; truthful WARNING |

## Loaded modules without emitted events

The following modules are explicitly sourced by `scripts/main.lua` but do not themselves originate runtime Publication events or address a GIANTS logging destination. They are semantic mechanisms, assessment, Configuration, visual presentation, or publication-policy sources; their absence from the journal is a positive census finding, not an omitted historical probe.

- `scripts/config.lua`
- `scripts/assessment/SpatialPairInference.lua`
- `scripts/coordination/HoldRelocateCoordinator.lua`
- `scripts/coordination/ProjectedEgressRegion.lua`
- `scripts/coordination/PairTransitRegion.lua`
- `scripts/coordination/PairSteeringDemand.lua`
- `scripts/coordination/NativePairCommitmentAuthority.lua`
- `scripts/control/HoldRelocatePhysicalControl.lua`
- `scripts/control/mechanisms/NativeReverseMechanism.lua`
- `scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua`
- `scripts/control/mechanisms/NativeTranslationHoldMechanism.lua`
- `scripts/control/mechanisms/NativeSpeedRegulationMechanism.lua`
- `scripts/control/mechanisms/NativeTransitRequestMechanism.lua`
- `scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua`
- `scripts/configuration/Configuration.lua`
- `scripts/diagnostics/DiagnosticPublicationPolicySource.lua`
- `scripts/observation/StaticBlockageEncounterObservation.lua`
- `scripts/observation/FarmEdgeGeometry.lua`
- `scripts/assessment/SettlementCorridorAssessment.lua`
- `scripts/coordination/SettlementPhysicalOccupancy.lua`
- `scripts/coordination/CompletionSettlementRoute.lua`
- `scripts/coordination/SettlementDestinationAssessment.lua`
- `scripts/coordination/ParkingRegionAllocation.lua`
- `scripts/coordination/ExtendedInfieldApproach.lua`
- `scripts/diagnostics/VersionHud.lua`
- `scripts/gui/DisabledStartupReminder.lua`

`scripts/publication/LogPublication.lua` is the sole GIANTS logging destination and carries no producer event codes; it also has a non-recursive publication-failure fallback. The main module is a producer but is a bootstrap entry point rather than a string-listed sourced module.

## Decision boundaries and validation evidence

- Current session build identity belongs to `OUTTAMYWAY_SHELL_STARTED`, with `CONFIGURATION_STORAGE_FAILED` retaining exceptional startup-failure provenance. All routine producer `version=` fields are removed. `VersionHud` is unchanged.
- Normal-only evidence must show admitted Completion Parking, end result and safety/Control uncertainty, not every plan, guide leg or queued candidate. The final `WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION` nominal screen is not proof of failed physical parking: the existing terminal interruption code and reason still record *unverified nominal completion*, with no added physical Control action.
- Debug On with engineering sidecar Off admits NORMAL plus DEBUG. Engineering sidecar On additionally admits targeted DIAGNOSTIC; the sidecar never gates parking or activates the instruments.
- Source-level producer contracts check classification and deferred payload boundaries; central Log Publication contracts still check cumulative policy, severity, rendering and failed payload isolation. The unchanged Architecture and Specification remain the binding authority. CI and GIANTS comparison are independent validation steps.

## Required GIANTS Reality comparison

Compare NORMAL-only event inventory on TS019 and a Hold & Relocate reproduction: start, admission, terminal outcomes, native handback and material warnings must remain observable, without leg-by-leg chatter. Repeat with Debug On and with engineering DIAGNOSTIC enabled; compare physical parking/Control outcomes with the accepted baseline. No frame-pacing claim follows from this static census.
