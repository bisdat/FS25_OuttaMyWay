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

## Disposition

Until the in-game comparison is complete, these signals are **candidate native evidence**, not recovery admission, worker-selection, task management, transport readiness, clearance or native Blocking Region support. Record positive and negative Reality evidence before proposing any authority upgrade.
