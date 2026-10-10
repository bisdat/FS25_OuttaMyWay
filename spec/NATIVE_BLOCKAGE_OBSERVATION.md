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

## One-shot Blockage Encounter Snapshot — issue #465

The new **Blockage Encounter Snapshot** captures physical evidence at the **first observed** `isBlocked=true` sample after a false/unknown native edge (or fresh job/strategy). It is not an actual GIANTS collision callback; `observedAtMs` is **not** a proven impact timestamp. One capture is allowed per native blocked pulse. There are **no shape hierarchy scans, collision-overlap computations, polygon searches or continuous extra physical census passes**.

When native world-pose/facing APIs and `mission.vehicleSystem.vehicles` are available, record:
- blocked beneficiary's current root X/Z and current forward vector from its GIANTS AI steering node (root fallback, or unresolved);
- for current distinct physical assembly roots, one world X/Z / facing sample and, where observed, `getIsAIActive`, player-controlled state and speed;
- for a bounded set of at most **three** nearest physical roots, relative forward/cross offsets and heading-alignment dot product against the blocked worker's facing. Three is an **evidence-size bound**, not a new causal radius or admission rule;
- observation time, physical inventory completeness and explicit unavailable fields.

The data is carried through the **existing ≥1 second single-native-pulse nomination**, as `encounterSnapshot`. A DEBUG `NATIVE_BLOCKAGE_ENCOUNTER_SNAPSHOT` line is emitted only for a qualified native single-worker concern where a physical population was available, never for every frame or every subsecond pulse. For each retained candidate it publishes the already-captured X/Z, forward vector, facing source and reported speed in m/s (or `unknown`), alongside relative geometry, `aiActive` and player-control evidence. This is formatting of the retained snapshot, not a fresh GIANTS observation; one instantaneous reported speed is not proof of sustained stationarity. This does **not** identify a blocker, replace the current authority decision, or trigger relocation. Original pairwise and solo recovery timing and Control are unchanged. A new pulse, GIANTS job or strategy yields a new snapshot; map teardown, disabled state and actual native unblock discard the old sample.

This evidence is meant to answer: *what did GIANTS show about the worker's and possible static subject's pose/facing as the blockage began?* It does not yet answer *which exact object caused it* or *whether forward or reverse motion is safe*. Those later positive decisions are [#465](https://github.com/bisdat/FS25_OuttaMyWay/issues/465) work, not prerequisites invented by Observation.

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
| [`scripts/observation/StaticBlockageEncounterObservation.lua`](../scripts/observation/StaticBlockageEncounterObservation.lua) | `REALISES` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/native_blockage_observation.lua`](../tests/shell/native_blockage_observation.lua) | `CHALLENGES` |
| [`tests/shell/static_blockage_encounter.lua`](../tests/shell/static_blockage_encounter.lua) | `CHALLENGES` |

## Implementation traceability / validation scope

[`scripts/main.lua`](../scripts/main.lua) constructs one observer with current Configuration and registers it ahead of the separate live Control runtime. The existing [Spatial Pair Inference](../scripts/assessment/SpatialPairInference.lua) is a downstream pure evaluator, not another Native Blockage Observation participant.

Offline tests verify observation gate, false-pulse reset, job/strategy turnover, root ranking, reciprocal-pair unification and release, disabled/client state and absence of vehicle commands. Only an in-game Reality test can confirm correct GIANTS source timing, no interference and representative Condor/Patriot candidate observation. This Specification establishes neither multi-pulse episode continuity nor GIANTS Control authority **for the Observer**; current production Control is a separate `HOLD_RELOCATE` responsibility.
