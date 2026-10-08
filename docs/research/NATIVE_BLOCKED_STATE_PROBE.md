# Native Blocked-State Evidence Probe — Completed Study

**Status:** CLOSED as an observation experiment after owner-validated TEST 0.5.0.2/.3 (8 October 2026). The `NativeBlockedProbe.lua` instrument and its runtime listener were retired in TEST 0.5.0.4. This document is **historical evidence**, not a Specification, running component or mandate to restore the probe.

## Research question

Can the GIANTS active field-worker blocked signal and separately available field-course blocked/static-collision states be observed without changing native AI behaviour? Do raw blocked assertions establish an OMW recovery need?

The separate question of **persistent useful-progress failure** is open under [Blocked Progress Qualification #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440); it is *not* answered here.

## Method and limits

A passive, explicit shell listener sampled GIANTS `mission.aiSystem.activeJobVehicles` at nominal 500 ms intervals when Debug/DIAGNOSTIC was requested. For active field workers it recorded `spec_aiFieldWorker.isBlocked`, an accessible `AIDriveStrategyFieldCourse.isBlocked`, and `hasStaticCollision`. Initial/change events and five-second positive-state reminders were published through standard DEBUG logging. Absent strategy values were labelled `unavailable`. A vehicle leaving the active registry was forgotten, not classified as cleared.

The test deliberately used no GIANTS job-stop/start, steering, collision update, recovery trigger, movement or Blocking Region actuation. The instrument's 500 ms sample could miss short transitions; an observed `false` could not prove safe physical clearance or useful productive continuation.

The [published GIANTS scripting source](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=3&class=151&version=script) is labelled v1.20. In-game confirmation below applies specifically to game **FS25 v1.24.0.0**, Build-Id **b41780**, revision **83220**. Reusable findings are harvested into [GIANTS Runtime Knowledge](../engine/GIANTS_RUNTIME_KNOWLEDGE.md) and [GIANTS API Surfaces](../engine/GIANTS_API_SURFACES.md).

## Evidence — TS015 TEST 0.5.0.2

Owner-supplied `log(1).txt` shows OMW `aiControl=false enabled=true` at **12:14:02.878**.

- First positive strategy visibility: Condor **12:14:40.237**, Patriot **12:14:41.256**, S416 **12:14:50.365**. Initial unavailable strategy readings did not prevent subsequent discovery.
- **12:16:40.410:** both Condor and Patriot independently reported `fieldBlocked=true` and `courseBlocked=true`, with `staticCollision=false` and `staticTimerMs=0`.
- Patriot: blocked at **12:16:45.451**, false by **12:16:47.964**; true again **12:16:52.490**, false **12:16:52.994**.
- Condor: `fieldBlocked=false` but strategy unavailable at **12:16:57.023**, strategy and course-blocked false again **12:16:57.527**. Neither the cause nor uninterrupted job continuity can be concluded.
- **12:18:04.641:** Condor blocked; **12:18:06.654:** S416 blocked. Game exited **12:18:09.868** with no positive clearance observed for the final pair.

**Supported:** the independent native flags are readable and agree in these captured positive blocked observations.

**Not established:** cause, physical contact, GIANTS static recovery, native subsegment skip, visible worker-blocked HUD-message timing, or agronomic completion.

## Evidence — TS015 TEST 0.5.0.3

Owner-supplied `log(2).txt` confirms normal version-only HUD **PASS** and `aiControl=false`, with no OMW Lua errors.

- **12:33:01.915 / 12:33:02.415:** Condor / Patriot both reported native field and course blocked true; static collision remained false.
- Patriot reported unblocked **12:33:05.953**, and repeatedly blocked/unblocked between **12:33:07.973** and **12:33:12.008**. GIANTS native blocked state is not a persistent-stall verdict.
- **12:33:16.544:** Condor appeared with unchanged `vehicleNode=396377` but a different native `jobRef`; the field-course strategy was temporarily unavailable before reappearing. Log provenance cannot identify why the job object changed.
- **12:33:39.231:** S416 `staticCollision=true` with `fieldBlocked=false`, `courseBlocked=false`. At **12:33:40.739** the static flag cleared while both blocked flags remained false. Timer zero is not proof a GIANTS recovery procedure ran.

**Disproved hypothesis:** static collision and native blocked assertions are equivalent. They are observably independent in this tested build.

## Owner field interpretation and remaining uncertainty

The owner reports that GIANTS attempts to resume when a moving blocker opens space, producing blocked/unblocked oscillation until meaningful coordination exists. GIANTS can also briefly report blocked when two opposing yet adjacent A8 assemblies pass normally. These observations warrant a **transient-false-positive filter for *intervention necessity***; they do not mean GIANTS' raw blocked message itself was fabricated.

This study establishes native signal accessibility and interpretation limits, **not** whether a worker needs OMW intervention. Useful realised progression, causal relationships, obstruction permanence and worker selection still require fresh evidence and an architectural contract under [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440).

## Retirement and provenance

The accepted proof-of-concept implementation existed in [PR #439](https://github.com/bisdat/FS25_OuttaMyWay/pull/439) (TEST .2/.3). The study is retained because its falsifying static-collision observation and timestamped evidence remain reusable, **not** because the completed instrument must run.

The probe was removed from the 0.5 working-tree runtime; the immutable [archive/0.4.11.0 Git branch](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0) separately preserves pre-rewrite code. No recovery implementation or probe activation is authorised by this document.
