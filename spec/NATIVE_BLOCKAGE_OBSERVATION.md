# Native Blockage Observation Specification

## Identity and authority

**Specification Jurisdiction:** Native Blockage Observation  
**Jurisdiction ID:** `NATIVE_BLOCKAGE_OBSERVATION`

**Primary Architecture Authority:** [`architecture/BLOCKED_PROGRESS_QUALIFICATION.md`](../architecture/BLOCKED_PROGRESS_QUALIFICATION.md#specification-jurisdiction--native-blockage-observation)

This contract owns read-only delivery of the **GIANTS native field-course blocked state** to the already accepted [Spatial Pair Inference](SPATIAL_PAIR_INFERENCE.md) evaluator. It does not create blocked-state authority, reconstruct collision geometry, determine causal obstruction, acquire a pair responsibility, or operate a vehicle.

## Read-only native interface

Only the authoritative server may observe. Source consumes the **current GIANTS AI active-job registry** `g_currentMission.aiSystem.activeJobVehicles`, accepting current active field workers and reading an available `AIDriveStrategyFieldCourse.isBlocked` boolean from `spec_aiFieldWorker.driveStrategies`. This field is the native blocked state maintained by GIANTS' own collision callback.

**Do not** replace GIANTS' single `isBlockedCallback`, call `getDriveData()`, intercept global `AIVehicleIsBlockedEvent.new`, install a native event wrapper or create a new collision detector. The previous experimental event-constructor tap is retired.

The runtime may perform passive targeted samples during its ordinary update, rather than treating old experimental 500 ms diagnostic logging as an event contract. Sampling is an approximation: an unseen native change between consecutive samples is **not asserted to be captured**. Unknown/missing strategy, job, registry or clock evidence means **no candidate**, not an invented blocked interval.

## Confirmed blocked-duration boundary

For the initial implementation tranche, accumulate time only between **successive positive native strategy `isBlocked=true` samples** on the same worker, same native job reference and same strategy instance. A `false` reading ends the current **Native Blockage Pulse**; it contributes **zero** to confirmed blocked duration. Unavailable evidence or worker/job/strategy loss invalidates the interval.

This tranche is deliberately conservative: it can feed a **single observed ≥1 s blocked pulse** into the existing evaluator. The accepted broader concept—accumulating distinct blocked pulses *only when they belong to the same unresolved physical encounter*—is **not yet implemented**. Do not silently sum every true pulse in a whole job, and do not invent a reset timeout or native course-progress test.

For each qualifying observed pulse, evaluate once. **Reciprocal nominations of the same active, unordered worker pair are one candidate occurrence**, so only the first nomination emits the DEBUG pair-candidate record; a second qualifying worker must not create a competing pair record. This is **unification of observations, not an additional admission gate or Pair Commitment**. There is no recurring DEBUG heartbeat and no NORMAL line claiming Control.

## Candidate inputs and output

The blocked worker and neighbouring currently active field workers are converted to one current **assembly-root X/Z position record** per root, deduplicated. Root positions are passive GIANTS `getWorldTranslation(rootNode)` reads and are intentionally imprecise. The evaluator applies the accepted **≥1000 ms** gate and inclusive **30 m** nearest-eligible-worker radius. The other worker need not report blocked.

**Scope limit of this tranche:** candidate enumeration covers currently active GIANTS field workers; other physical obstacles and previously completed workers are not yet represented by an Operation membership model. An absence of a local worker means **no observed active-worker candidate**, not proof there is no other physical obstacle. Candidate publication is diagnostic evidence, **not** a causality/Control Decision.

**Passive candidate delivery:** `getCurrentPairCandidates()` returns copies of existing active pair-candidate references, the originating observed blocked duration and blocked worker to the separate live Pair Commitment authority. The read-only Observer does not validate independent commitment, field centroid, TRANSIT capability or any physical Control; its candidate is merely an input which downstream authority may reject. This supplements DEBUG publication without interpreting the DEBUG log as an actuation request.

**Unordered pair identity:** use the two assembly-root IDs independent of nomination direction. Keep only one active candidate occurrence per pair while at least one worker remains natively blocked, both native jobs/strategies remain unchanged, both workers remain present, and root-to-root separation remains within **30 m**. On both workers unblocked, missing member, changed job/strategy, loss of root evidence, separation beyond the existing radius, map exit or disablement, retire the occurrence. A later eligible encounter may create a new occurrence. There is no new obstacle-proof test, extra distance threshold or release timeout.

## Lifecycle and authority invariants

- Disabled or unresolved Configuration and non-server clients perform **no observation** and discard prior observations.
- Map load/delete and native Job Episode/strategy turnover discard stale pulses.
- Missing root coordinates/strategy/clock fail closed; no GIANTS field is ever mutated.
- A threshold reached with valid evidence may publish `NATIVE_BLOCKAGE_PAIR_CANDIDATE` or `NATIVE_BLOCKAGE_NO_LOCAL_WORKER` as **DEBUG**. An active pair publishes at most one candidate record even when each worker separately reaches the one-second gate. Non-pair blocked observations remain once per pulse.
- No worker Control, OMW-induced Hold, GIANTS continuation mutation or pair commitment **within Observation**; candidate evidence may be consumed by the independently gated live Hold & Relocate responsibility.
- Observed candidate records do not become durable responsibility or authority; later active membership/recovery behaviour needs separate Reality validation.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/observation/NativeBlockageObservation.lua`](../scripts/observation/NativeBlockageObservation.lua) | `REALISES` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/native_blockage_observation.lua`](../tests/shell/native_blockage_observation.lua) | `CHALLENGES` |

## Implementation traceability / validation scope

[`scripts/main.lua`](../scripts/main.lua) constructs one observer with current Configuration and registers it ahead of the separate live Control runtime. The existing [Spatial Pair Inference](../scripts/assessment/SpatialPairInference.lua) is a downstream pure evaluator, not another Native Blockage Observation participant.

Offline tests verify observation gate, false-pulse reset, job/strategy turnover, root ranking, reciprocal-pair unification and release, disabled/client state and absence of vehicle commands. Only an in-game Reality test can confirm correct GIANTS source timing, no interference and representative Condor/Patriot candidate observation. This Specification establishes neither multi-pulse episode continuity nor GIANTS Control authority **for the Observer**; current production Control is a separate `HOLD_RELOCATE` responsibility.
