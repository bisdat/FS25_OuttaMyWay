# Native Blocked-State Evidence Probe — 0.5 Rewrite

## Question

Can OuttaMyWay observe ordinary GIANTS field-worker blocked assertions, native collision classifications and native release without changing GIANTS AI behaviour? This study narrows [issue #420](https://github.com/bisdat/FS25_OuttaMyWay/issues/420) and is **not** an automatic Recovery design.

## Existing evidence

- OuttaMyWay 0.4 passively read the field-worker specialization's blocked flag. That flag alone was never sufficient to authorize Blocked Worker Recovery.
- [GIANTS field-course source](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=3&class=151&version=script) shows separate field-course collision-handler blocked and static-collision states. That published source is labelled scripting v1.20 and has not yet been verified against the installed FS25 1.24 executable.
- GIANTS has an internal static-collision recovery path. A blocked notification does not prove intervention is already needed.

**Native Blocked Assertion ≠ Recovery Necessity.**

## 0.5.0.2 experiment contract

The shell loads one isolated, non-actuating instrument (scripts/diagnostics/NativeBlockedProbe.lua). Sampling is dormant under NORMAL logging and while disabled. It runs only with enabled Configuration and Debug or DIAGNOSTIC policy, on a **500 ms** timer over the GIANTS-maintained active-job vehicle registry.

For each positively identified active field worker, the instrument reads native field-worker blocked state, and—where the current strategy is recognizable—field-course blocked and static-collision state. A missing field or strategy is reported as **unavailable**, never false. The raw native static-collision timer is diagnostic context, not evidence that a skip or other GIANTS recovery action actually occurred.

DEBUG events are emitted on the first observed state and subsequent changes. Positive blocked/static state receives at most one reminder every **five seconds**. A job leaving the registry is silently forgotten rather than reclassified as cleared. Missing registry availability is reported once until it returns. Mission exit and disabled/non-debug state discard retained records.

No OMW actuation, GIANTS collision callback installation, job replacement, field-course mutation, AI update, or vehicle interception is permitted. No old 0.4 Observation/Assessment/Decision/Control graph is loaded.

## Required TS015 GIANTS Reality test

1. With TEST 0.5.0.2 and Debug enabled, start a GIANTS field worker. Check for a first sample identifying the correct vehicle and either the field-course strategy or an explicit unavailable indication.
2. Reproduce the normal blocked worker message; align in-game/display time with the logged native state transition. Compare the field-worker and strategy flags without assuming equivalence.
3. Let GIANTS attempt any native recovery before manual intervention. Record persistence and release. The timer alone cannot prove a native subsegment skip.
4. Stop–relocate–restart manually and record whether a new active job and fresh blocked-state observations appear. Loss of registry membership is not clearance.
5. Re-run Debug off to confirm no sampling publication; check performance separately. The 500 ms sample can miss brief transitions—this is a probe, not a guaranteed event delivery mechanism.

**Falsification criteria:** absent active-job registry, strategy never visible on known native field-course workers, native flags disagree unexpectedly, sample cadence misses material blocked messages, or noticeable frame-time regression.

## TS015 0.5.0.2 GIANTS Reality observation — 8 October 2026

Source: user-supplied game `log(1).txt`, FS25 **1.24.0.0**, Build-Id **b41780**, revision **83220**. The engine logs OuttaMyWay `0.5.0.2` as `aiControl=false enabled=true` at **12:14:02.878**; probe samples are DEBUG and require opt-in Configuration. This observation is from the **0.5.0.2** executable, not the later version-only HUD correction.

**Initial positive applicability:** Condor (12:14:40.237), Patriot (12:14:41.256) and S416 (12:14:50.365) each expose a reachable field-course strategy after an initial first sample with `courseBlocked=unavailable`. Both native blocked flags are false, with `staticCollision=false` on those samples.

**First opposed block:** at **12:16:40.410**, Condor and Patriot both have `fieldBlocked=true` and `courseBlocked=true`, while `staticCollision=false` and `staticTimerMs=0`. Patriot remains blocked at **12:16:45.451**, is reported false at **12:16:47.964**, then toggles true at **12:16:52.490** and false at **12:16:52.994**. Condor is next sampled at **12:16:57.023** with `fieldBlocked=false` but strategy `unavailable`, returning to a visible strategy with both flags false at **12:16:57.527**. The absence of periodic Condor samples in between cannot prove it remained a member of the active-job registry, or why the transition occurred.

**Second opposed block:** Condor at **12:18:04.641** and S416 at **12:18:06.654** both show `fieldBlocked=true`, `courseBlocked=true`, `staticCollision=false`, `staticTimerMs=0`. Condor is still reported blocked at **12:18:09.679**; the player exits the save at **12:18:09.868**, so neither worker has an observed native release in the supplied trace.

**Supported findings:** the field-course state was accessible in three different active workers, and both blocked flags agreed at all captured positive samples. Every available static-collision reading was false, so this test does not exercise the native static-obstacle recovery path.

**Not established:** the in-game blocked HUD messages are not independently timestamped in the log, the exact blocker or cause is unknown, a native subsegment skip is not observed, and the clearing of a blocked flag is not proof of physical or agronomic recovery. Changes involving manual player actions are not independently labelled in this log.

**Disposition:** partial in-game PASS for passive field-course blocked-state visibility and native-flag correlation; do not promote to an automatic Recovery admission rule. The absence of independent state-transition provenance and movement outcome remains open.

## TS015 v0.5.0.3 field observation — 8 October 2026

Source: owner-provided `log(2).txt`, GIANTS FS25 1.24.0.0, OMW 0.5.0.3. Owner confirms persistent HUD is now the normal version string (PASS). Startup reports `aiControl=false`; there are no OuttaMyWay Lua errors in this run.

- 12:33:01.915 Condor blocked; 12:33:02.415 Patriot blocked. Both native blocked flags true, with staticCollision false.
- Patriot becomes unblocked at 12:33:05.953 and alternates blocked/unblocked three further times before 12:33:12.008. A single blocked assertion is not proof of enduring obstruction.
- Condor appears with the same vehicleNode 396377 but a different jobRef at 12:33:16.544; the field-course strategy is briefly unavailable, then recovers visibility. The log does not say who or what changed the job.
- At 12:33:39.231 S416 has `staticCollision=true` while `fieldBlocked=false` and `courseBlocked=false`; at 12:33:40.739 staticCollision is false again with blocked flags still false. Static timer is zero in both samples.

**Finding — Native Static Collision Detection is not Native Blocked Assertion.** Separate native signals must not be conflated. No physical contact, native recovery, or intervention need is proven by these diagnostic samples. The probe remains read-only.
## Disposition

Until the in-game comparison is complete, these signals are **candidate native evidence**, not recovery admission, worker-selection, task management, transport readiness, clearance or native Blocking Region support. Record positive and negative Reality evidence before proposing any authority upgrade.
