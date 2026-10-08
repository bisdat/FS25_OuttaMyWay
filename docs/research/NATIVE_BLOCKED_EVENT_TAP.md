# Native Blocked Event Tap — Source-Level Candidate and Reality Plan

**Status:** TEST 0.5.0.5 experimental, **not yet GIANTS-validated**. This diagnostic is temporary research equipment for [Blocked Progress Qualification #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440), not production Observation or Recovery. Accepted control-free baseline remains TEST 0.5.0.4 until separate merge.

## Research question

Can OuttaMyWay receive GIANTS native blocked/unblocked **edges** promptly, without 500 ms fleet-wide polling, without replacing the field-course collision callback, and without changing GIANTS' continuation behaviour?

## Source evidence and candidate mechanism

In [GIANTS scripting v1.20 AICollisionTriggerHandler](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=3&class=146&version=script), `updateBlockedCallback` invokes the installed `isBlockedCallback` when its own `isBlocked` value changes. [AIDriveStrategyFieldCourse](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=3&class=151&version=script) installs that *single* callback and on the server creates `AIVehicleIsBlockedEvent.new(self.vehicle, isBlocked)`, then broadcasts the event. [Community event source](https://umbraprior.github.io/FS25-Community-LUADOC/script/Events/AIVehicleIsBlockedEvent/) shows constructor arguments `(vehicle, boolean)`.

The **Native Blocked Event Tap** experimentally wraps the *outgoing event constructor*, not GIANTS' collision-handler setter, `updateBlockedCallback`, `broadcastEvent`, or receiver `run`. It first delegates to the exact original constructor, then performs its own best-effort logging under `pcall`, and returns the unmodified native event object. No events are created beyond those GIANTS constructs. The test hook installs only on the authoritative server, only when OuttaMyWay is enabled and DEBUG or engineering DIAGNOSTIC publication is selected. It attempts removal at disable, Debug-off and map exit; if another mod replaced the hook, the experiment becomes inert instead of overwriting that mod's function.

**Limit:** method interception is still a global Lua hook, not a documented subscription API. A non-throwing observer and source-level delegation do not prove safety or ordering in game v1.24.0.0. A pre-existing or later mod wrapper may alter delivery. The event constructor can also be used for non-field navigation; this experiment filters to vehicles with `spec_aiFieldWorker` but labels scope only *field-worker-capable*, not actively verified field-course jobs.

## Log evidence contract

- `[DEBUG][NATIVE_BLOCKED_EVENT_TAP][NATIVE_BLOCKED_TAP_INSTALLED]` — installed native-event constructor observer.
- `[DEBUG][NATIVE_BLOCKED_EVENT_TAP][NATIVE_BLOCKED_EVENT_CONSTRUCTED]` — vehicle root node/name, raw boolean, `g_time` in milliseconds where available, and source; no invented Job Episode or causal blocker.
- `NATIVE_BLOCKED_TAP_UNAVAILABLE` / `...CHAIN_UNVERIFIED` / `...RELEASE_DEFERRED` — explicit instrumentation limits.

Only native constructor events are logged. This probe does **not** establish all changes in `spec_aiFieldWorker.isBlocked`, a completed blocked interval, a one-second gate, proximity, progress, causal interaction, intervention permission, or pair selection. No timer or worker scans are implemented. All emitted lines are DEBUG class; NORMAL performs no instrumentation.

## Initial GIANTS Reality — TEST 0.5.0.5, 8 October 2026

**Result: PARTIAL PASS — positive event-construction observation.** Owner supplied `log(4).txt` from FS25 **1.24.0.0**, Build-Id **b41780**, revision **83220**. The game declared OuttaMyWay **0.5.0.5**, and shell startup at **16:13:07.350** logged `aiControl=false enabled=true`.

- **16:13:27.380:** the diagnostic registered `NATIVE_BLOCKED_TAP_INSTALLED` once.
- **16:15:44.949:** `NATIVE_BLOCKED_EVENT_CONSTRUCTED nativeBlocked=true` for **Condor Endurance II**, `vehicleNode=396258`, `engineTimeMs=144551.86264371872`.
- **16:15:45.246:** a separate `nativeBlocked=true` event for **Patriot 4450**, `vehicleNode=399829`, `engineTimeMs=144849.3655424118`. Approximate event separation: **297.5 ms** of engine time.
- **16:15:51.263:** `quit savegame`; engine soft-restarted. The log includes **no nativeBlocked=false** event before exit, and no OMW Lua exception. The four logged `FieldManager` map/farmland-boundary errors predate the observed events and are not attributable to this experiment.
- The session does **not** exercise Debug-off, mod-disable, or explicit teardown comparison; the initial `aiControl=false` declaration does not independently prove that GIANTS' trajectory was unchanged.

**New supported fact:** in this particular GIANTS v1.24 runtime, the guarded constructor wrapper installed successfully and was invoked for two distinct field-worker-capable vehicles producing **positive blocked** events. These are two event creations separated by less than 500 ms, **not** a demonstrated sub-500 ms blocked/unblocked pulse.

**Still unproven:** unblocked/false edge path, end-to-end completeness versus all GIANTS blocked-state changes, native HUD event timing, whether one-second continuous native blockage occurred, whether GIANTS was behaviourally unaffected, and safe coexistence with other callback/event hooks. No OMW Blocked Progress Qualification or native intervention evidence was generated. **Do not merge as a fully validated event subscriber based on this log alone.**

## Follow-up GIANTS Reality — TEST 0.5.0.5, log(5).txt, 8 October 2026

**Result: PASS for both directions of native event-construction observation (narrowly scoped); broader non-interference still pending.** Runtime again FS25 **1.24.0.0**, Build-Id **b41780**, Build-Revision **83220**; shell declared `aiControl=false enabled=true version=0.5.0.5` at **16:20:55.830** and installed the observer once at **16:21:15.518**.

At **16:23:32.055**, Condor Endurance II (`vehicleNode=396380`) constructed a `nativeBlocked=true` event. No matching Condor false event was observed before savegame exit at **16:23:56.814**; it is an *open interval*, not evidence of certified persistent state across mission lifecycle or evidence of effective intervention.

Patriot 4450 (`vehicleNode=398649`) constructed four complete blocked-event intervals:

| Blocked true | Blocked false | Native engine-time duration | Threshold ≥1 s |
| --- | --- | ---: | --- |
| 16:23:32.374 | 16:23:37.717 | **5.343 s** | Yes, if independently qualified as one continuous active Job Episode |
| 16:23:40.417 | 16:23:41.265 | **0.848 s** | No |
| 16:23:44.238 | 16:23:44.412 | **0.174 s** | No |
| 16:23:45.022 | 16:23:45.848 | **0.825 s** | No |

Durations are from the event payload's `engineTimeMs` rather than rounded wall-clock stamps. The observed native false edges demonstrate GIANTS event-constructor access on *unblocking*. The **174 ms** complete true/false sequence establishes visibility into a blockage pulse shorter than the former **500 ms** periodic sampler; the old sampler might miss it. **This does not prove complete coverage of every internal native state transition.**

**Newly named distinction: Native Blockage Episode** — a worker-scoped interval between observed true and false edges, bounded by a specific active Job Episode in any future formal Observation contract. A missing false edge requires lifecycle disambiguation; it must not silently imply indefinite obstruction, useful lack of progress or a causal neighbour.

**Implication for prospective 1-second Native Blockage Persistence Gate:** elapsed time is measured *per Native Blockage Episode*, and a false event ends that episode; retry episodes must not be summed to reach 1 s. A worker blocked for 5.343 seconds passes only this *time prerequisite* for further assessment. No causal pair, proximity, realised progress or OMW authority follows from passing. The selected future implementation could maintain a targeted deadline per active true episode instead of scanning all workers every 500 ms. This gate is **not implemented in TEST 0.5.0.5**.

**Other observation:** no OMW Lua error was logged. The same four map `FieldManager` warnings/errors were emitted before gameplay events; their presence is not evidence of OMW malfunction. There is no controlled demonstration that the observer never perturbs GIANTS' AI, nor Debug-off/Enabled-off teardown evidence in this run. No assertion about the visual course continuation is supported without player observation.

**Disposition:** event construction is now Reality-demonstrated in both directions for Patriot, and positive direction for Condor, on this game build. Retain the test-only experiment while closing remaining non-interference/lifecycle questions; no new operational worker authority or control code is warranted by this diagnostic alone.

## Reality validation — falsifiable TS015 protocol

Test on **FS25 1.24.0.0** (record actual Game-Version, Build-Id, Build-Revision) using 0.5.0.5 TEST with OuttaMyWay Enabled and **Debug ON**:

1. Verify exactly one installation message on mission load; with Debug OFF or mod disabled, no tap installation and no edge log. Validate toggling Debug OFF and Enabled OFF removes the hook; re-enable reinstalls only when requested.
2. Run Condor and Patriot in a normal field job; deliberately observe a genuine GIANTS native blocked/unblocked transition and correlate event timestamp and worker identity with native UI/behaviour. Record whether any expected edge is missing, duplicated or late.
3. Exercise adjacent A8 transit, moving-blocker retries and an obvious persistent obstruction; compare real transitions including brief intervals shorter than the previous 500 ms sampling cadence.
4. Confirm that a GIANTS job can start, stop, and (where naturally applicable) restart with the same behaviour as the control-free 0.5.0.4 plateau. Verify no job-control commands, worker movement by OMW, errors or abnormal events. Repeat with disabled mod or Debug OFF as comparison.
5. Verify client/server operation separately if multiplayer claims are later required; present experiment only asserts server-side construction.

**Acceptance/disproof:** a constructor tap is viable only if it delivers timely, correctly identified native transitions without altering GIANTS continuation and cleans up safely. If transitions are absent, incorrect or the interception changes behaviour, **retire it and update engine knowledge**. A successful result supports a future input contract; it does not automatically approve Blocked Progress Qualification implementation.

## Authority-triad disposition

Architecture: current Project Vision and control-free Rewrite Shell remain unchanged; #440 holds prospective semantic decisions. Specification: no new production Observation jurisdiction or actuation contract is established. Source: one opt-in diagnostic module, isolated from worker control. Tests: offline constructor-delegation and lifecycle checks only; in-game Reality is required.