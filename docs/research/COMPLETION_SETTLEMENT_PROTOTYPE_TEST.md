# TEST 0.5.5.7 — Three-Leg Completion Settlement Prototype

**Status:** implemented for independent offline CI and subsequent GIANTS Reality; **no in-game steering outcome validated yet**. Parent: [Issue #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476), draft [PR #482](https://github.com/bisdat/FS25_OuttaMyWay/pull/482).

## Accepted premise and why this prototype exists

GIANTS Reality on Mindenerwald Field 77 / south edge 9 in TEST 0.5.5.6 returned a **two-member** frozen-assembly continuous nominal polygon-only straight sweep of **204.55 m**, with no represented registered-field intersection along that sampled tangent. The requested experiment treats that selected edge as driveable, rather than repeating physical terrain/collision-margin studies performed in TEST 0.5.5.3. **No previous log contained an executed parking manoeuvre.**

The falsifiable hypothesis is that GIANTS-native forward steering can use a reached infield staging point, shallow outward crossing and long tangent run-out to stop a complete articulated assembly outside the source polygon. Failed GIANTS steering, overshooting, jackknifing, a blocked verge or attached members remaining in the source field would disprove the proposed mechanism or its assumed route.

## Distinct authority and limits

TEST 0.5.5.7 keeps production Completion Transit request-only unless a **separate experimental consent** is set. Add `settlementPrototype="true"` to the existing `modSettings/FS25_OuttaMyWay/diagnostics.xml` root, alongside `enabled="true"`. Example:

```xml
<outtaMyWayDiagnostics enabled="true" settlementPrototype="true" />
```

Without **both** true values, no terminal movement is eligible. The spatialFarmlandId selector, if any, must be absent for the Field 77 survey fixture. Unlike ordinary DIAGNOSTIC logging, this option **can physically drive a completed vehicle**. Do not enable it on valuable unsaved work or without active in-game supervision. The flag is read on game load; disable the mod in its Settings page to request immediate Control relinquishment. The code never turns an AI job cancellation or manual stop into completion egress.

This prototype only accepts **registered Field 77 / native edge 9**, with matched measured endpoints and a real completed root inside the source field. It requires a successful native FIELDWORK completion and independently accepted completion-TRANSIT request. An active BWR commitment or new native AI job supersedes the manoeuvre. It is not generalised to Riverbend or arbitrary field boundaries in this TEST.

## Proposed three-leg Reality observation

1. `INFIELD_APPROACH`: forward steering to an interior root waypoint about 16 m before the chosen sweep seed station at 6 m infield depth.
2. `SHALLOW_CROSSING`: from that point, steer 24 m longitudinally towards a root waypoint 8 m beyond the seed station and at its sampled shallow exterior depth. With +2 m exterior depth, the nominal chord is about 18.4° from the tangent.
3. `FORWARD_RUNOUT`: continue parallel to the field edge towards the sweep-endpoint horizon minus 3 m; observe steering and attachment alignment, with no numerical run-out guarantee.

Native `AIVehicleUtil.driveToPoint` is reused through a distinct static-driver instance. Speed is capped at 8 km/h, each arrival requires actual root proximity within 2.5 m, and the prototype stops after a finite 240 s total lease or 180 s per leg. Native motor, cruise and physics influence must neutralise on expiry, new job, other BWR authority, disable or driving error.

After the last leg, a *new live snapshot* of root + attachments must show **all nominal member rectangle corners outside Field 77**, with unchanged member count. A root crossing is not full completion. The experiment does not detect every hedge, traffic lane, slope, collision shape or dynamic-worker conflict.

## Evidence to capture

Retain the complete GIANTS log including `COMPLETED_WORKER_TRANSIT_REQUESTED`, `COMPLETION_SETTLEMENT_ADMITTED`, each `COMPLETION_SETTLEMENT_LEG_STARTED` and `LEG_FINISHED`, and final `COMPLETION_SETTLEMENT_FINISHED` or `INTERRUPTED` with reason. Observe visually whether the implement swings across a neighbouring field, the tractor turns sharply while approaching the infield station, the crossing is shallow after physical steering transients, and all articulated members actually clear. Note any pause, reversal, motor intervention, jackknife, overshoot, player takeover and the precise in-game time.

One normal-completion run is the first decisive test. A second deliberate mod-disable test while an approach leg is active challenges relinquishment. Do not call an offline CI PASS a successful GIANTS parking result.

## GIANTS Reality — TS018, 12 October 2026

**Evidence:** supplied archive `0.5.5.7_TS018.zip`, containing a complete 2,928-line GIANTS log and a 352.875-second (2560×1440, 60 fps) in-game video, Mindenerwald Field 77.

**Observed native completion/Control sequence** (log clock):

| Time | Runtime evidence |
| --- | --- |
| 05:22:19.808 | `AIMessageSuccessFinishedJob` for root `398874`, job 0 |
| 05:22:19.808 | `COMPLETED_WORKER_TRANSIT_REQUESTED` |
| 05:22:20.195 | Prototype admitted: edge 9, `memberCount=1`, selected `202.83 m` **polygon-only** sweep (different from the earlier 204.55 m two-member fixture) |
| 05:22:20.195 | `INFIELD_APPROACH` starts, target (220.21, −247.88), initial root distance 21.08 m, requested cap 8 km/h |
| 05:23:09.307 | Approach marked complete; `SHALLOW_CROSSING` starts, target (197.73, −236.27), root distance 23.93 m |
| 05:23:34.825 | Crossing marked complete; `FORWARD_RUNOUT` starts, target (8.20, −206.70), root distance 194.31 m |
| 05:25:12.779–12.783 | Final leg and `WHOLE_NOMINAL_ASSEMBLY_OUTSIDE_REGISTERED_FIELDS` both reported as success |

**Video contradiction:** The completed sprayer visibly remains stationary for considerable intervals after the first steering objective is armed. The player reports that it moved only with manual steering input. The video shows irregular motion and manual manoeuvring around the first turn; the log records only position-based leg completion, not actual independent steering or who moved it. It cannot prove a native steering call was *rejected*. Crucially, at approximately **05:25:17** (roughly five seconds *after* `COMPLETION_SETTLEMENT_FINISHED`), the speedometer reads approximately **30 km/h** while the machine is still in motion; a subsequent frame around **05:25:22** reads **0 km/h**, after the player's reported manual stop. This is **positive evidence of an incomplete terminal stopping/relinquishment contract**, despite successful geometric occupancy.

**Discovery — Waypoint Orientation Blindness:** The three-leg planner selects an infield *point* only 21.08 m away from the end-of-job pose without requiring an entry heading or physically realised turn curvature. Passing that point, even with manual input, is not evidence of a stable edge-aligned approach. A forward **J-shaped heading acquisition** before shallow entry is a plausible engineering hypothesis, not proven by the existing steering logs.

**Discovery — Player-Control/Native-Steering Conflict:** The native direct drive mechanism checks new AI activity but not current player selection/physical Control. Existing [GIANTS Runtime Knowledge](../engine/GIANTS_RUNTIME_KNOWLEDGE.md#selected-assembly-motion-suppression--tab-context-can-claim-physical-actuation) documents an earlier independent TS018 in which hundreds of successful native drive calls moved a selected Condor by only 0.0022 m until the player tabbed away. `Drivable:updateVehiclePhysics` may rewrite `rotatedTime` for a controlled vehicle. This makes a GIANTS steering-writer conflict a **strong, previously supported explanation**, not independently instrumented proof for this specific sprayer. Neither current completion mechanism explicitly interlocks `vehicle:getIsControlled()` nor `g_currentMission.controlledVehicle`.

**Discovery — Release Is Not Physical Stop:** `NativeStaticAssemblyDriveMechanism.release` issues one zero-acceleration `driveToPoint` call, restores prior cruise settings and ends the lease; it does not measure subsequent velocity, require sustained braking, or verify stationarity. When the engine was already running at arm time, release does not request `stopMotor`. `CompletionSettlementRuntime` calls `verifyTerminal` immediately after the final point-within-2.5m leg completes, so its “FINISHED” means nominal **occupancy**, not confirmed **stopped settlement**. The 30 km/h post-success video falsifies the compound “parked safely” interpretation.

**Assembly scope:** The vehicle in this TS018 run reports `memberCount=1` (a self-propelled sprayer in video), so articulated attachment behaviour is still untested. The chosen sweep was **202.83 m**, not the earlier two-member **204.55 m** figure. Preserve both run-scoped observations; no fixed literal is embedded in the route planner.

**Speed decision:** The 8 km/h artificial prototype cap is **unnecessary**, per the test assessment, and should be removed in a subsequent executable TEST increment. Native motor and cruise capabilities should remain governing bounds. Lifting that cap in isolation **before reliable terminal stopping** would increase the consequences of the observed release defect; do not retest unattended.

**Dispositions:**

1. Treat **autonomous steering unvalidated** and **safe terminal stop disproven**. TEST `0.5.5.7` is a **qualified failure**, not an accepted field-validated plateau.
2. Before changing the turn geometry, explicitly address the player-Control/native-drive writer conflict; an occupied/selected vehicle should not silently remain under competing physical writers.
3. Replace orientation-blind approach-point admission with a forward, heading-aware **J-Entry** hypothesis; validate actual infield heading acquisition separately from the later shallow crossing.
4. Make *Stopped Terminal Settlement* a positive end condition: continue native neutral/braking responsibility until the whole assembly is outside and physical speed has settled, then relinquish; report failure/inability to stop rather than nominal `FINISHED`.
5. Remove the prototype's artificial 8 km/h speed cap while retaining native limits and safety termination. Make each change independently falsifiable.
6. Keep draft PR #482 unmerged; separate observation/discussion from the next controlled executable revision.

**Authority Triad disposition:** existing Architecture's intended full-assembly **stopped** terminal outcome remains correct; the currently implemented Specification/Source interpretation is demonstrably insufficient. A follow-on contract revision must distinguish **position arrival** from **heading realised**, **player Control** and **physical stop**, with independent GIANTS validation.


## FS25 native source cross-check — two concrete Control defects

After correlating TS018 video/log, inspect the native [GIANTS FS25 `AIVehicleUtil.driveToPoint`](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=91&class=881&version=script) source, documented for FS25 script v1.20 and consistent with the project's supplied 1.24 source knowledge. **The current source behaviour on this exact running 1.24 machine is not instrumented, but the API contract supplies a stronger explanation than the earlier “steering rejected” hypothesis.**

**Discovery — Local Target Distance Destruction:** `NativeStaticAssemblyDriveMechanism:movementStatus` constructs `lx,lz=worldToLocal(steeringNode,worldTarget)`, correctly a **local position**, then calls `AIVehicleUtil.driveToPoint(..., lx/length, lz/length, ...)`. The native `driveToPoint` computes geometric turning *curvature* from **the actual local point coordinates**: they are not merely a unit direction. Scaling a 20+ metre waypoint to length 1 metre raises requested curvature approximately in proportion to the removed scale, potentially saturating steering. The native helper additionally applies sharp speed reduction and can set `acceleration=0` when target steering change would reduce forward speed below 1 km/h. This gives a **source-supported causal hypothesis** for the initial prolonged stationary interval under steering demand, compounded by the already documented player-controlled vehicle steering-writer conflict. **Correction:** pass actual local `lx,lz` as a position in the completion-settlement path; do not silently alter the previously field-tested Hold & Relocate driver path in the same increment. Distinguish actual heading/steer/yaw/progress in next diagnostic evidence.

**Discovery — Cruise State Restoration Omission:** The native `driveToPoint` explicitly calls `setCruiseControlState(ACTIVE)` during allowed drive. The current release function sends one `driveToPoint(acceleration=0,allowed=false,maxSpeed=0)`, restores `setCruiseControlMaxSpeed` and ends its lease **without restoring `getCruiseControlState()` or guaranteeing an inactive cruise state**. A call with `allowed=false` does not by itself undo an earlier activation. This can leave native cruise ACTIVE at the reinstated previous speed (visually about 30 km/h after termination). The TS018 video **directly falsifies successful final physical stop**. The particular engine state remains unmeasured, but this source-backed omission is a concrete corrective target. A normal terminal success must include actual stopped-speed evidence, not just restoring cruise limits.

**Next controlled experiment ordering:** fix the completion-only local-point contract; establish scoped cruise-state acquisition/neutralisation and speed-confirmed stop on terminal or failure; add player selection/Control attribution and heading/steering telemetry; then test whether a forward **J-shaped entry** is still required. Remove the blanket 8 km/h cap per the accepted TS018 decision, using native motor/cruise limits. Do **not** release or test an unguarded faster build before correcting the demonstrated stop defect. No executable change is contained in this evidence record.

## TEST 0.5.5.8 corrective hypothesis and GIANTS validation protocol

**Change under test:** correct the completion-only native steering target from unit `(lx/length,lz/length)` to full local point `(lx,lz)`; remove the artificial 8 km/h cap; explicitly turn cruise OFF and maintain native neutral braking until low speed (≤0.12 m/s) and less than 0.20 m of root travel persist for ≥1,200 ms at each waypoint; refuse current player-controlled selection; sample steering request, heading, root progress, cruise, native speed, Control context at 1 s intervals when DIAGNOSTIC is enabled. TEST `0.5.5.7` TS018 remains a failure and is not retroactively upgraded.

**Preserved:** the same three waypoint route/fixture, no invented J-turn path yet, no change to the previously accepted Hold & Relocate unit-vector driver; completion TRANSIT request still has no fold-readiness wait. Native speed limits prevail; the unchanged overall 240-second attempt and per-leg 180-second failsafes bound the experiment. This is a supervised prototype; higher native speed increases risk despite the added stop requirement.

**Target tests:** initial motor + accepted steering should create forward displacement **without any manual steering** when the completed sprayer is *not selected*; verify that actual local target distance starts at the physical tens-of-metres range rather than 1 m. Approach, crossing, run-out and STOPPING stages should all log independently. Confirm a stationary engine/cruise-OFF vehicle for at least 1,200 ms **before** `COMPLETION_SETTLEMENT_FINISHED`; watch the vehicle for several seconds afterwards to disprove recurring cruise acceleration. Separately, test a player tab-selection mid-route: it must explicitly interrupt rather than silently accept manual movement. With an articulated assembly, verify the whole physical footprint and turn behaviour separately.

**Evidence needed:** the complete GIANTS log, actual video through and *after* terminal stop, positive or negative `COMPLETION_SETTLEMENT_MOTION_SAMPLE` evidence, failure/interruption reasons and any mismatch between observed physics and status. CI validates offline wiring, exact native API inputs, cruise-OFF/low-speed release and inherited BWR assumptions; CI **cannot** prove road clearance, curvature, player-control timing or GIANTS physical stop.

**Validation status:** PENDING GIANTS Reality for TEST 0.5.5.8. Do not treat passing an offline contract as a successful terminal parking result.


## TEST 0.5.5.8 — 12 October 2026, early admission refusal

**Evidence:** supplied `log(20261012-051854).txt`, 2,920 lines, GIANTS FS25 1.24.0.0; mod identity `0.5.5.8` (line 701, startup line 943). **Reported behaviour:** no driving at all.

At **06:17:36.137**, the log records on the **same timestamp**:
- `[NATIVE_FIELDWORK_JOB_STOPPED]` with `jobId=0`, `rootNode=398433`, `message=AIMessageSuccessFinishedJob`.
- `[COMPLETED_WORKER_TRANSIT_REQUESTED]` for the same job and root.
- `[COMPLETION_SETTLEMENT_NOT_ADMITTED] reason=NATIVE_PLAYER_CONTROL_ACTIVE`.

No `COMPLETION_SETTLEMENT_ADMITTED`, `COMPLETION_SETTLEMENT_LEG_STARTED`, `COMPLETION_SETTLEMENT_MOTION_SAMPLE`, `COMPLETION_SETTLEMENT_STOPPING` or terminal result is recorded for this attempt. No OuttaMyWay error is recorded. The new selection interlock in `CompletionSettlementRuntime:onNativeCompletion` consults `vehicle:getIsControlled()` **before** nominal route planning or physical drive admission, and rejects immediately. Therefore **the steering-target correction, native-speed command and stopping Control in TEST 0.5.5.8 were not executed or tested**.

**Discovery — Synchronous Completion / Control-Handover Ambiguity.** The guard evaluated `getIsControlled()==true` at the *exact same millisecond* as GIANTS' native AI job termination notification. The log does **not** record `g_currentMission.controlledVehicle`, player seat/tab context, explicit steering input or a later `getIsControlled()` sample; therefore this single positive witness cannot distinguish a genuinely player-selected vehicle from a possible transient handover state at job termination. The printed reason says `NATIVE_PLAYER_CONTROL_ACTIVE`, but **player intention and physical steering competition are not established**.

This newly added policy **prevents the planned GIANTS actuation experiment** under that witness; it should not be labelled an engine steering refusal or a disproven drive correction. The earlier observation that tab-selection can suppress non-job motion is independent and remains valid, but selection alone is not evidence of a manually commanded steering or throttle input. Whether selected vehicles must be eligible for unattended settlement is an architectural decision, not a reason to silently force competing writers.

**Immediate discriminating validation (unchanged TEST 0.5.5.8):** before the worker finishes the job, switch the player's controlled vehicle to a different vehicle or remain on foot, and do not take control of the completed worker during the attempted approach. Switching after the stopped-job event cannot restart this attempt because completion admission is event-triggered. If the same `NATIVE_PLAYER_CONTROL_ACTIVE` reason persists while the worker is definitely not selected, the synchronously sampled GIANTS handover flag is a strong new hypothesis requiring post-stop observation before admission. If the guard clears, the actual `COMPLETION_SETTLEMENT_LEG_STARTED` and `COMPLETION_SETTLEMENT_MOTION_SAMPLE` events are the first meaningful steering/stop test. No executable change is justified by this log alone.

**Disposition:** TEST 0.5.5.8 physical Control **not exercised**, neither PASS nor an actual steering FAIL; failure is **admission-policy gating**. Keep PR #482 draft, main unchanged, and do not invent a new driving algorithm from this negative observation.


## TEST 0.5.5.8 — Second GIANTS run, autonomous driving diverged (12 October 2026)

**Evidence:** `log(20261012-052505).txt`, 2,942 lines; Mindenerwald Field 77, root `400110`. Observed in-game outcome: drove essentially straight ahead off the field. This is a **distinct failure** from the preceding synchronous `NATIVE_PLAYER_CONTROL_ACTIVE` refusal: the second run had `playerClaim=NO_POSITIVE_CLAIM`, was admitted and actuated, and therefore tests the changed driving command.

| Log time | Evidence |
| --- | --- |
| 06:24:16.824 | Native successful FIELDWORK completion and independent accepted TRANSIT request |
| 06:24:17.189 | `COMPLETION_SETTLEMENT_ADMITTED`, edge 9, `memberCount=1`, nominal 202.83 m sweep |
| 06:24:17.191 | `INFIELD_APPROACH` to **(6.02, −214.46)**, **199.50 m** from current root, native requested maximum **60 km/h**, `localTargetContract=POSITION` |
| 06:24:18.133 | Root at (201.478, −256.684); root heading forward (0.987846, −0.155355), speed ~0; no native command yet in first sample |
| 06:24:19.137 | Native drive calls running (`commanded=134`), cruise state **ACTIVE**, 2.23 m/s; first logged local target distance 200.62 m |
| 06:24:24.148 | Root (231.906, −260.997), already beyond registered Field 77 maximum X **228.15 m**, approach still MOVING |
| 06:24:38.203 | Root (291.683, −255.820), 9.60 m/s (~34.6 km/h), `commanded=2566`, `regionProgressM=-88.44`, local target distance **288.10 m** |
| 06:24:38.226 | `COMPLETION_SETTLEMENT_INTERRUPTED`, `leg=1`, `SETTLEMENT_LEG_TRAJECTORY_DIVERGED` |

**Discovery — Unreachable Forward Entry Pose.** Relative to the initial root, the target vector is approximately (−195.46,+42.22) m. The measured current **root** forward heading is (+0.98785,−0.15535); its dot product with the unit vector to the target is approximately **−0.9984**: target bearing **176.7° behind**, with about **200 m negative longitudinal projection**. Steering-node orientation was not separately logged, but the physical root heading and forward displacement are unambiguous. Rather than approach the interior staging point, the vehicle advanced **~90.2 m east** to increasing X. The heading only changed from approximately (+0.988,−0.155) to (+0.989,+0.151), never acquiring the required westward entry heading.

**Discovery — Nominal Corridor Selection Is Not Maneuver Entry.** `CompletionSettlementRoute.plan` ranks candidates **only by polygon-only straight sweep `lowerBoundM`**. It passes the current root heading into `SettlementCorridorAssessment` but does not ensure the selected start station or three consecutive waypoint headings are dynamically reachable by a forward-moving assembly. The selected first waypoint was near the **opposite end of the field**; driving to it from the job-completion pose would require an explicit headland turn before any shallow boundary crossing. Even selecting a nearer start point does not by itself establish heading continuity across approach→crossing→run-out. This refutes the **three point targets alone** hypothesis; it does not refute the tested 202.83 m straight polygon run-out or demonstrate that a J-entry is dynamically feasible.

**Discovery — Negative Progress Without Early Abort.** `NativeStaticAssemblyDriveMechanism:movementStatus` computes signed `progressM`, and published `regionProgressM` declined steadily from **−0.46 m to −88.44 m**, but neither Control nor the route checks that an INFIELD_APPROACH is progressing towards its target. Only lateral divergence greater than **20 m** and generic lease deadlines can stop this particular failure; no phase-specific field-boundary guard exists. The vehicle had crossed the source-field maximum-X bounding line about **14 seconds before** interruption. A safe experimental contract requires positive movement/progress attribution and an independent approach-phase boundary invariant, not only lateral separation after a substantial runaway.

**Native steering interpretation:** The full-scale local target and new native speed were indeed exercised, with cruise ACTIVE and thousands of native calls. The observed result is small turning response while a destination remains behind; successful native function invocation is not proof of useful steering. The retained `0.5.5.8` player-Control interlock allowed this run. The 1.2-second physical stopping phase was **not** reached; cancellation on divergence ran, but the log does not independently confirm vehicle speed zero following revocation.

**Architecture candidate — Forward Entry Reachability.** Before actuator admission, a route must include a **reachable pose** (position **and heading**) and continuous forward manoeuvre from current heading to approach alignment; an infield J-shaped heading-acquisition manoeuvre is a candidate, not yet accepted geometry. A putative edge corridor should distinguish (1) end selection, (2) heading acquisition, (3) shallow crossing and (4) tangent run-out. Plan validity cannot be established solely by 200 m of polygon-compatible terminal sweep. Also consider explicit *Monotonic Route Progress* and *Approach Containment* safety contracts; neither is implemented or authorised by this entry. Avoid modifying existing BWR semantics.

**Engineering authority correction:** The `0.5.5.8` player-Control interlock was introduced **without explicit project authorisation**. It might ultimately be valid, but introducing it inside a steering/stopping corrective tranche obscured consent and invalidated the first test. The project decision is to **leave it in place temporarily**, not to retroactively authorise or establish it as accepted architecture. Future behavioural interlocks and route strategies require explicit discussion and approval before executable changes. Existing source remains unchanged.

**Disposition:** Second `0.5.5.8` run **FAIL**, with actual native forward propulsion **validated** and autonomous entry steering/route selection **disproven**. Do not accept the build; keep PR #482 draft and unmerged. No executable revision in this evidence commit.


## Proposed next experiment — Progressive Steering rather than distant point acquisition

**Source-backed discovery — Long-Lookahead Curvature Collapse:** native FS25 `AIVehicleUtil.driveToPoint` computes a circle/curvature to the supplied local-space point; it does **not** generate a multi-point route or a 180-degree turn. See GIANTS [AIVehicleUtil scripting source](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=91&class=881&version=script), `driveToPoint` lines 26–96. For the 0.5.5.8 TS018 approach's first diagnostic root pose (201.478, −256.684), heading (0.987846, −0.155355), and planned target (6.02, −214.46), the target lies approximately **199.64 m behind, 11.35 m to one side**, i.e. **176.75° behind**. For a point-chasing curvature law, `abs(curvature) ≈ 2*abs(lateral)/(range²) ≈ 0.000567/m`, an implied **~1,762 m turn radius**. This is compatible with the logged near-straight +X traversal; the steering API need not be “rejecting” the target. The full-distance input fix in 0.5.5.8 made the geometry real, but revealed its mismatch to the forward-turn requirement.

**Proposed architecture — Progressive Steering:** keep selected edge-9 corridor as the terminal geometric reference, but represent the manoeuvre from the post-job pose as a **continuous sequence of forward-reachable short guidance targets** along a feasible J-shaped heading-acquisition path, then shallow edge crossing and tangent run-out. Shortening the *same straight line* from current root to the point behind would not fix the unreachable initial bearing. A short target immediately abeam can also demand steering beyond the assembly's turning capability. Local targets must remain forward-directed and curvature-feasible for the actual assembly; a tentative guidance lookahead on the order of 10–15 m is an **implementation hypothesis, not a fixed architecture constant**.

**Important distinction — guidance target vs physical leg:** the current `CompletionSettlementRuntime` enters a cruise-OFF, 1.2-second STOPPING phase after *every* three waypoint arrivals. Progressive steering should update/look ahead to a new target **without stopping between subtargets**, maintaining one physical movement lease through the turn. Physical stopping is a separately verified event after major manoeuvre termination (or interrupted safe handback). The exact lookahead, actual feasible curvature and stopping/braking evidence require GIANTS validation.

**Observability:** progress must be assessed along the **local forward guidance manoeuvre**, not merely as monotonic decreasing Euclidean distance to the distant final edge endpoint: during a valid J-entry the final terminal distance may temporarily increase. Measure actual heading change, attained curvature, local target bearing/range and field containment. The earlier terminal polygon-only sweep remains a *corridor* premise rather than an autonomous path certificate.

**Governance:** this is a proposed response to the field-test suggestion “make smaller legs that GIANTS can achieve”, **not executable approval** to add new interlocks or to refactor Hold & Relocate. The previously unauthorised player-Control interlock remains in the experimental source per explicit instruction, but is not retroactively accepted as architectural policy. Proposed next TEST is a constrained steering-guidance experiment after architectural agreement.


## TS018 annotated field view — two manoeuvre families from the real completion pose (12 October 2026)

**Evidence:** player-supplied overhead screenshot `Screenshot_20261012_063537.png` of Mindenerwald Field 77, the completed self-propelled sprayer beside the field's southern margin and a nearby ditch/adjacent field. The user has drawn two blue candidate paths, describing them as **either a forward J-turn or reverse**. The screenshot is useful for topology, but **does not measure precise path radius, soil/ditch clearance, true yaw, registered polygon coordinates, or articulated swept space**.

**Observed topology:** the sprayer is parked infield near the acute field-corner area, with its *front* (white nose at lower-left in the screenshot) directed towards the short corner and its rear directed approximately along the extending field boundary towards the upper-right. The hand-drawn **left** path depicts a forward sweeping J/loop around the corner towards the margin; the **right** path depicts reversing approximately along the preferred edge direction and then merging smoothly onto its outside/margin alignment. These are *qualitative candidate paths*, not independently proven safe corridors.

**Discovery — Direction-Aware Entry Maneuver:** An edge/corridor is a **terminal geometry**; the usable arrival path depends on the assembly's current *pose and available drive directions*. The same completion pose may offer a tight forward 180° reversal with short-corner/ditch exposure, or a much smaller reverse heading change. A planner that always assumes **forward travel to a distant staging point** discards available reverse reachability and can create the exactly backward 199.5 m leg that TEST 0.5.5.8 failed. Choosing small guidance legs is necessary but not sufficient: each target must be reachable in the *selected direction* without asking GIANTS to make a huge turn.

**Two candidate entry families (not selected as executable policy):**
- **Forward J-entry:** short native forward guidance targets that acquire heading before shallow crossing, provided the full physical sweep stays inside a viable manoeuvre envelope around the corner. The screenshot shows a ditch/boundary close to the turning region. Neither turning radius nor tyre/tool swept envelope is validated.
- **Reverse entry:** native reverse-specific steering/reverser node, gentle curve or short progressive reverse targets towards edge-parallel alignment; for the pictured self-propelled sprayer it is *plausibly* the lower-curvature entry. Native reverse capability must be tested in GIANTS, with the drive convention and continuous end heading recorded. For articulated assemblies, reverse is **not assumed stable** and cannot be selected solely on visual ease: articulation/jackknife and implement clearance remain distinct feasibility constraints.

**Proposed architectural separation:** (1) **Terminal Corridor** — where the assembly may park; (2) **Entry Manoeuvre** — forward J or reverse, chosen from current heading, attainable curvature, available physical space and assembly characteristics; (3) **Local Guidance** — short reachable point targets, not direct 200 m point acquisition; (4) **Stopped Terminal** — positive physical stop after successful run-out. A chosen reverse approach must explicitly state whether the entire run-out is reverse or reverse is only a short reposition before a new forward heading; the image and statement alone do not determine this for all assemblies.

**Status:** architectural observation/proposal only. No new executable route selection, driving permission, interlock, speed change or build was authorised by the screenshot. TEST `0.5.5.8` remains FAIL; PR #482 stays draft. Preserve the player-Control interlock as instructed, without retroactive architectural acceptance.

## TEST 0.5.5.9 — discriminating protocol (pending GIANTS)

The owner confirmed short reverse→forward when feasible, replan for each completion pose, and success anywhere along an edge between fields. Experiment `0.5.5.9` implements **only a bounded Field 77 edge 9 fixture** with shortest-nearby *nominal* terminal choice; old far-end traversal is removed. The path consists of 5 m candidate steering points for a reverse positioning segment and two forward steering arcs (or forward heading-acquisition J), with nominal rigid-member candidate collision screening against registered field polygons. This is not continuous physical/road/hedge or dynamic worker clearance.

**Key falsifiable evidence:** 0.5.5.8 first target was 199.5 m/176.7° behind; in the next run the **first target** should be approximately a short 5 m local move in the selected travel direction, not another far back point. The engine must show actual reverse or forward motion, steering and target transitions, a positive stop at the first direction change, continuous forward driving through intermediate guidance targets, and terminal full-member location *wherever* valid along the edge. The final drive must remain cruise OFF and physically stopped after the success event. If it instead runs out of progress, leaves the exterior edge envelope or cannot stop, record the failed phase and do not promote the build.

**Control and speed:** retained 0.5.5.8 player-Control veto is unchanged per explicit owner instruction; it is not retroactive approval. The original unbounded 60 km/h command from the long-point trial is replaced by an **experimental target-horizon stopping-speed profile**, not a fixed 8 km/h cap; observed physics may invalidate the nominal 1.5 m/s² deceleration assumption. Unattended selection veto may prevent admission, as in earlier runs. `DIAGNOSTIC` one-second evidence and NORMAL phase events must be captured.

**Evidence status:** GIANTS TS018 test **PENDING**; route viability, native reverse steering and stop safety are unproven. Offline checks are preconditions only. Any discrepancy requires revisiting the architecture, not adding hidden special cases.

### Steering and stopping-reserve follow-up

The first terminal pose that clears both registered field polygons is not automatically a safe target at low native speed: the assembly can continue forward during STOPPING. The planner therefore requires the same nominal full-member terminal predicate **five metres farther along the planned tangent** before accepting a target. This is a bounded *stopping-envelope hypothesis* accompanying the physically observed 1.2-second stop contract, not a measurement of actual braking distance. A nominal station whose succeeding five metres conflicts with a field/corner is not a safe target; later stations along the chosen tangent may qualify. All TEST motion DIAGNOSTIC samples also identify the active guidance index and world-space target, so short waypoint advancement can be reconstructed from GIANTS logs.

**Safety boundary explicitly introduced for the first GIANTS run:** refuse `foot.memberCount ~= 1` as `ARTICULATED_ENTRY_REALITY_UNVALIDATED`. The current geometry estimator freezes member yaw and cannot validate changing hitch angles during the proposed reverse+forward entry. Only the TS018 one-member self-propelled sprayer is physically admitted. This is a temporary TEST boundary, not a claim that articulated machines cannot be settled under the architecture.


## TEST 0.5.5.9 — GIANTS TS018 FAIL: synchronous soft-lock and neutralisation ordering (12 October 2026)

**Primary evidence:** user-supplied `0.5.5.9_TS018.zip`, containing `log.txt` (2,930 lines) and `2026-10-12 07-17-24.mp4` (~192.4 s, 2560×1440/60 fps). Owner verdict: **overall FAIL**, with a brief soft-lock at **07:19:56**. The log identifies the loaded experimental build as `0.5.5.9` (line 701 / shell-start line 943). This is direct user GIANTS Reality, not a CI inference.

### Discovery — Synchronous Route Planning Stall

- **07:19:55.706**: `NATIVE_FIELDWORK_JOB_STOPPED`, `AIMessageSuccessFinishedJob`, root `398837`, job 0; immediately followed by accepted `COMPLETED_WORKER_TRANSIT_REQUESTED`.
- **07:20:06.680**: the first `COMPLETION_SETTLEMENT_ADMITTED` appears, **10.974 seconds** later: Field 77, edge 9, nominal `REVERSE_FORWARD`, 24.0 m reverse, 64.82 m total, 15 short guidance points, trial radius 18 m.
- The video independently confirms that the game image and in-game HUD stop updating for approximately **07:19:57–07:20:06**, while the separate video timestamp advances. Scene resumes around the recorded route-admission time. The AVI/MP4 video and game log thus corroborate the owner's reported freeze.
- Source: `CompletionSettlementRuntime:onNativeCompletion` synchronously invokes `CompletionSettlementRoute.plan` before publishing admission. Planner examines up to **150** candidate combinations (two along-edge directions × five reverse distances × three trial radii × five arc angles × two strategies). Each candidate may repeatedly test complete-member nominal rectangles against **84** registered neighbouring field polygons. There is no frame budget, preselection of nearby slots or incremental scheduling. The large synchronous geometry search is the **strongly supported cause of the stall**. Timestamps alone do not benchmark the exact CPU distribution; engine profile traces were not supplied.
- **Architectural discovery: Bounded Search ≠ Bounded Frame Work.** Limiting candidate counts makes termination finite but does not make the event handler frame-safe. Physical movement must not be admitted before a budgeted route decision, but route selection must not monopolise the main game thread. Reduce candidates before full geometry evaluation and/or execute explicit fixed-budget planning slices across game updates, preserving authority and cancellation. Do **not** solve this by simply increasing the supported timeout.

### Discovery — Cruise-State Ordering Conflict (source-determined)

- **07:20:06.681**: `REVERSE_POSITIONING` leg 1 starts, first target `(196.28, -255.87)` ~4.8 m away, native reverse.
- One-second samples show actual reverse motion and progression: at **07:20:08.638**, speed 1.93 m/s, root `(200.57,-256.54)`; at **07:20:12.657**, speed **4.65 m/s (~16.8 km/h)**, root `(183.96,-253.93)`. Guidance progressed through successive reverse points, with no positive player-control claim. These observations validate native reverse propulsion and point handover, *not* forward J/S entry or parking.
- **07:20:13.568**: `COMPLETION_SETTLEMENT_STOPPING`, reason `DIRECTION_CHANGE_REQUIRES_STOP`, after the last reverse guidance point.
- **07:20:13.575**: `COMPLETION_SETTLEMENT_INTERRUPTED`, `leg=5`, `SETTLEMENT_NEUTRAL_REQUEST_UNCONFIRMED`. Only **7 milliseconds** elapsed between stop entry and failure. The requirement of 1.2 seconds observed stationary motion was never reached; no forward leg or final terminal geometry validation occurred. No separate `NEUTRALIZE_UNCONFIRMED` warning is logged, which does **not** prove the assembly stopped.
- In `NativeStaticAssemblyDriveMechanism:settlementStopStatus`, the code calls `vehicle:setCruiseControlState(OFF)` **before** `AIVehicleUtil.driveToPoint(vehicle,dt,0,false,false,0,1,0,false)` and then requires `getCruiseControlState()==OFF`. The authoritative FS25 GIANTS `AIVehicleUtil.driveToPoint` script **sets cruise to ACTIVE even when allowedToDrive=false**, before applying the zero-acceleration physics command. Thus the ensuing state read is incompatible with the immediately preceding native call: this is a **deterministic implementation ordering defect**, independent of whether steering is good. See GIANTS documentation: https://gdn.giants-software.com/documentation_scripting_fs25.php?category=91&class=881&version=script, `driveToPoint` lines 26–96.
- **Second uncertainty — Stopping distance:** at 4.65 m/s, the assumed 1.5 m/s² deceleration would need at least ~7.2 m without reaction time. The observed speed is not positive evidence that a reverse→forward transition can stop within the current 2.5 m point-arrival tolerance. Real GIANTS neutral braking and overshoot require a separate observed test. **Do not** claim parking success from lease release or a single cruise flag.

### Observations, inferences, and disposition

**Observed:** 10.974-second log gap; game/HUD frozen over the same approximate period; genuine short-point reverse driving; attempted direction-change stop; immediate `SETTLEMENT_NEUTRAL_REQUEST_UNCONFIRMED`; no forward entry or terminal success. No primary game error stack trace is present for this event.

**Strongly supported interpretation:** excessive synchronous nominal planning caused the soft-lock. **Source-proven error:** cruise-state check cannot succeed in the present stop-command ordering, because native `driveToPoint` reactivates cruise.

**Unvalidated:** safe physical stopping after emergency cancellation, actual articulated reversing, field-margin collision clearance, and forward manoeuvre execution.

**Disposition:** **TEST `0.5.5.9` overall FAIL**. Do not promote or re-run unattended. Keep main production behaviour and previously field-validated Hold & Relocate unchanged; no executable patch approved by this record. Correct the main-thread planning work boundary and the cruise-control neutralisation ordering as separate, explicit implementation hypotheses; then validate native stopping before resuming manoeuvre complexity. The 0.5.5.8 player-Control veto remains unchanged as owner instructed.

## TEST 0.5.5.10 — narrowly scoped validation plan (pending in-game)

**Implementation response to prior TS018 0.5.5.9 FAIL:**
1. The native completion event now queues a route search, rather than calculating any of the potentially expensive 150 poses synchronously. The same route choices are assessed over update frames using weighted cost checkpoints and world-axis-aligned bounds rejection for distant neighbours. Admission logs `planningUpdates` and `weightedGeometryChecks`, useful for quantifying the work distribution. Assert no motor lease during pending planning; cover disable and supersession.
2. Native neutral `driveToPoint` is invoked **before** cruise OFF and cruise verification. This reverses the erroneous 0.5.5.9 STOPPING order, while retaining speed and measured 1.2 s stillness as independent evidence.
3. Existing guidance speed model now also reduces native speed as continuous same-direction distance to the next physical stop shrinks. This is intended to avoid arriving at the reverse→forward transition at 4.65 m/s (0.5.5.9 sample); stopping dynamics at 1.5 m/s² remain a *hypothesis*, not a guarantee.

**Next experiment:** one-member TS018 Field 77, engineering opt-in and DIAGNOSTIC enabled; complete log plus video spanning job completion, planning, reverse, direction-change STOPPING, forward and physical parking. Treat any game-frame pause, uncontrolled inertia, repeated uncontrolled cruise activation or failure to reach a valid parking region as FAIL. No implementation change to player-Control interlock, production TRANSIT or previously field-validated Hold & Relocate.


## TEST 0.5.5.10 — GIANTS TS018 refusal: coroutine admission capability unavailable (12 October 2026)

**Evidence:** user-supplied `log(20261012-064712).txt`; FS25 1.24.0.0, experimental mod `0.5.5.10` confirmed by mod list (line 701) and `OUTTAMYWAY_SHELL_STARTED` (line 943). Owner observation: **no soft-lock, but no movement either**.

**07:46:13.176** (same timestamp): `NATIVE_FIELDWORK_JOB_STOPPED` success, job 0/root `400107`; `COMPLETED_WORKER_TRANSIT_REQUESTED` (request only); `COMPLETION_SETTLEMENT_NOT_ADMITTED reason=COROUTINE_UNAVAILABLE`. No `COMPLETION_SETTLEMENT_PLANNING_STARTED`, `COMPLETION_SETTLEMENT_ADMITTED`, guidance movement, stopping or terminal result. The attempt exited before route generation.

**Source-backed finding — Coroutine-Dependent Planning Admission:** `CompletionSettlementRoute.beginPlan` returns `COROUTINE_UNAVAILABLE` when any of `type(coroutine)=="table"`, `type(coroutine.create)=="function"`, or `type(coroutine.yield)=="function"` is false. GIANTS returned that outcome through the normal control path; the log does **not** specify which individual facility is absent/blocked nor whether a native Lua thread primitive could exist under another API. Offline LuaJIT passed because it provides the global coroutine API: the tests checked a different execution environment than GIANTS.

**Interpretation:** this is a **capability/admission failure**, not evidence for or against pose-dependent route feasibility, reverse steering, the revised cruise-neutral order, anticipatory braking, terminal occupation or measured soft-lock avoidance. The absence of another freeze is expected when the new planner **did not execute**. It is incorrect to call the 0.5.5.10 frame-budget approach GIANTS-validated.

**Corrective hypothesis — Explicit Incremental Assessment:** keep the `PLANNING` state first class but implement resumable route search as a plain data structure holding candidate indices, partial manoeuvre points, stage, neighbour-polygon index and accumulated best solution. On each `update`, perform bounded iteration and persist all continuation state explicitly, with *no* requirement for `coroutine.create/yield/resume/status`. Finish admission only after every required candidate is assessed or explicitly pruned; do not admit movement from partially validated geometry. Keep the same Field 77 one-member TEST envelope, player-Control interlock unchanged by owner instruction, deterministic candidate ranking and explicit disable/new-job supersession. Importantly, a fixed number of high-cost geometry calls does not itself bound milliseconds: count calls, sample frame timing where GIANTS supports it, and use conservative per-update work slices.

**Engineering governance:** The coroutine dependency was an unsupported engine capability assumption introduced in TEST `0.5.5.10`. Future engine-dependent implementation contracts need a positive GIANTS capability witness or a design that does not depend on the unverified facility. Recommend testing the plain-state planner in LuaJIT with the global `coroutine` deliberately unavailable, then validating in GIANTS. No executable change was requested by this log review; do not promote or merge the untested build.

**Disposition:** TEST `0.5.5.10` **FAIL (not admitted)**. It exercises neither driving nor actual frame-budgeted route planning. PR #482 remains draft/unmerged; production main unchanged.

## TEST 0.5.5.11 — explicit assessment scheduling hypothesis (pending GIANTS)

The `0.5.5.10` log at 07:46:13.176 proves a *pre-planning admission veto*: `COROUTINE_UNAVAILABLE`. The game did not freeze because our planner never attempted any geometric work. The proposed correction replaces only coroutine suspension/resumption with explicitly stored continuation state: candidate indices; partial forward/reverse arc guidance point; source and registered neighbouring field check stages; and the best complete terminal-region candidate. Each game update advances at most the existing **320 weighted operation units** while rejecting incomplete candidate plans as driving authority.

**Offline falsification:** globally set `coroutine=nil` and run the actual Field 77 fixture and two distinct completion poses through `Route.beginPlan/advancePlan`. Compare all selected method/direction/reverse/radius/terminal/guidance-point fields to the unchanged `Route.plan` reference. Assert no external motor call before `DONE`, no callback-time geometry, and bounded weighted checks per update. Errors or mismatches disprove the replacement scheduler.

**GIANTS validation target:** verify `COMPLETION_SETTLEMENT_PLANNING_STARTED`, then `COMPLETION_SETTLEMENT_ADMITTED` with `planningUpdates` and `weightedGeometryChecks` but **no** `COROUTINE_UNAVAILABLE`, **no** visible game freeze, and short reverse guidance starting subsequently. Only then can the distinct 0.5.5.10 neutral-order and braking changes receive their first true in-game test. The interlock, route geometry, physical Control and production defaults are unchanged. Keep PR #482 draft and unmerged.

## TEST 0.5.5.11 — field-validated TS018 PASS (12 October 2026)

**Evidence and verdict:** owner supplied `0.5.5.11_TS018.zip` (GIANTS `log.txt`, 2,947 lines, and `2026-10-12 08-06-09.mp4`, 198.08 s, 2560×1440 60 fps). The owner's assessment is explicitly **"0.5.5.11 PASS"**. Review of the log and accompanying in-game recording independently supports successful execution of the complete experimental settlement lifecycle. This supersedes the prior `PENDING` validation label **for this specific theatre/assembly only**.

### Observed sequence

| Local time | Observed GIANTS/OuttaMyWay event |
| --- | --- |
| 08:06:33.023 | `OUTTAMYWAY_SHELL_STARTED` confirms version `0.5.5.11`, enabled |
| 08:08:40.097 | Native AI job `0` / root `399970` completes successfully; completion TRANSIT request and `COMPLETION_SETTLEMENT_PLANNING_STARTED` in same millisecond |
| 08:08:48.334 | `COMPLETION_SETTLEMENT_ADMITTED`: planning takes **8.237 s and 1,051 updates**, **335,978 weighted geometry checks**, Field 77 edge 9, `memberCount=1`, `REVERSE_FORWARD`, **24.00 m planned reverse**, **64.793 m planned travel**, 15 guidance points, nominal radius 18 m |
| 08:08:50–56 | `COMPLETION_SETTLEMENT_MOTION_SAMPLE` proves actual reverse propulsion and successive short-target retargets; initial heading approximately (+0.988, −0.157), native speed rises to ~4.66 m/s and then declines to ~0.69 m/s before the reverse stop |
| 08:08:56.504 | `COMPLETION_SETTLEMENT_STOPPING`, direction change requires physical stop |
| 08:08:57.809 | Reverse leg complete at **0.0000323 m/s**, **1,206.6 ms** measured stable, cruise OFF |
| 08:08:57.811 | `FORWARD_GUIDANCE` starts; native player claim remains absent |
| 08:08:59–08:09:09 | Root position, heading and native steering `rotatedTime` all change during forward short-target guidance (sampled heading rotates through the S-turn, not straight-line motion) |
| 08:09:10.184 | Final `COMPLETION_SETTLEMENT_STOPPING`, `PARKING_REGION_REQUIRES_STOP` |
| 08:09:11.587 | Final physical stop complete at **0.0000362 m/s**, **1,204.3 ms** stable, cruise OFF |
| 08:09:11.588 | **`COMPLETION_SETTLEMENT_FINISHED`**, `WHOLE_NOMINAL_ASSEMBLY_IN_INTERFIELD_PARKING_REGION`, root approximately **(210.432, −237.204)** |
| 08:09:20.387 | User exits savegame; no further settlement warning/error or renewed acceleration logged in intervening ~8.8 seconds |

### Independent video corroboration and limits

The scene visibly continues updating during the planning interval, consistent with the owner's report that the former soft-lock is absent. The self-propelled sprayer reverses near the southern edge, performs its forward curved manoeuvre and remains stationary at its parking position for several seconds after the final event. Video later switches to the map/menu and exits, so the observation horizon ends with the recording; this is **not** an indefinite stationarity proof.

**Success claims supported:** actual GIANTS runtime availability without a coroutine API; budgeted multi-update planning; genuine independent reverse driving and native steering targets; repeatable short guidance target handover; verified stop before reverse→forward gear transition; forward heading-acquisition path; final cruise OFF / sustained native low speed; nominal single-member physical footprint outside registered fields in the selected inter-field corridor; and owner acceptance of TS018 parking location.

**Limits not waived:** this is one single-member sprayer on native Field 77 edge 9 with the experiment explicitly opted in; no articulated reverse/jackknife, other completing poses in GIANTS, other source fields, roads/hedges/ditches beyond the nominal fixture, multiplayer, or a complete world-geometry clearance certificate. The ~8.24 s **responsive planning latency** is a measurable UX consideration: the user previously required intentional waits to be explained in HUD; the current log's `PLANNING_STARTED` is not yet a full player-facing waiting message. Avoid adding unrelated HUD behaviour during this acceptance record.

**Consequence:** the explicit state-machine scheduling hypothesis and the corrected native neutral-order are now **GIANTS-supported** for this fixture. Promote the architectural knowledge, not untested generality. Do **not** interpret owner PASS as authorisation to merge draft PR #482, declare a canonical PATCH, remove the single-member limit, change player-Control interlock policy or alter the previously field-validated Hold & Relocate. No executable change in this research update.

## TEST 0.5.5.11 — TS019 two completed workers, divergent outcomes (12 October 2026)

**Evidence:** owner-supplied `0.5.5.11_TS019.zip`, containing `log.txt` (3,027 lines) and 120-second overhead `TS_004.mp4`, 2560×1440 at 60 fps. Owner observation: **"One worker finished but did not move, the second did."** Loaded mod identity `0.5.5.11`, default enabling confirmed. This is a *new completion-pose test* and does not revoke the separate single-worker TS018 PASS.

### Native completion and settlement outcomes

| Observation | First completing worker | Second completing worker |
| --- | --- | --- |
| GIANTS completion | **17:53:14.699**, job 2, root `396315`, `AIMessageSuccessFinishedJob` | **17:54:09.349**, job 3, root `400002`, `AIMessageSuccessFinishedJob` |
| Default TRANSIT request | Same instant, `REQUEST_ONLY_NOT_VERIFIED` | Same instant, `REQUEST_ONLY_NOT_VERIFIED` |
| Incremental planning | Started 17:53:14.699; **refused 17:53:22.477**, ~**7.78 seconds** | Started 17:54:09.349; **admitted 17:54:17.377**, ~**8.03 seconds**, **1,117 updates**, **356,976 weighted checks** |
| Route evidence | `NO_POSE_REACHABLE_PARKING_REGION` | Field 77 **fixed edge 9**, `REVERSE_FORWARD`, 12 m nominal reverse, **52.798 m** planned travel, 13 short targets, 18 m trial radius, one member |
| Actual physical motion | **None from Completion Settlement**, because no candidate was admitted | Native reverse/forward movement and progressive steering confirmed in log and overhead video |
| Direction-change stop | Not reached | **17:54:24.236**, **0.0000184 m/s**, ~**1,201 ms** sustained, cruise OFF |
| Terminal stopping | Not reached | **17:54:37.889**, **0.0000321 m/s**, ~**1,206 ms** sustained, cruise OFF |
| Final terminal decision | Not admitted / no movement | **`COMPLETION_SETTLEMENT_INTERRUPTED`**, reason **`WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION`**, **not** `FINISHED` |

Video correlation: the first completed sprayer remains near the **upper/right field boundary**, away from the experimental *southern* edge 9. The still-active other worker progresses toward the south margin, finishes, and then visibly executes a short reverse and curved forward approach; it remains stationary near that margin afterwards. The recording confirms the user's two-worker differentiation and does not show a new main-thread freeze. It cannot establish registered-field membership more precisely than the runtime polygon predicate. Two Hold & Relocate encounters with job restarts had occurred earlier in the same run, but they must not be conflated with completion-settlement authority.

### Discovery — Fixed Preferred Edge Is Not a Universal Destination

The prototype continues to restrict route planning to **Field 77 native edge 9** and enumerates a bounded set of local 0/12/18/24/30 m reverse manoeuvres, 12/18/24 m nominal turn radii and at most ~35 m final forward runout. The first worker's completion pose is near another boundary. `NO_POSE_REACHABLE_PARKING_REGION` proves only that **none of the fixture-limited candidates reached the fixed edge-9 terminal predicate**; it does *not* prove that the assembly has no reachable safe parking region elsewhere on the field boundary. A pose-conditioned route must be able to evaluate the **relevant field edges / viable inter-field margins** from each completing assembly pose. The user's previously confirmed *anywhere along the edge* outcome and *independent route per worker* imply this architectural generalisation; candidate-edge discovery and clearance may still fail legitimately.

### Discovery — Guidance Arrival Does Not Establish Terminal Occupancy

The second worker reached the **final target's 2.5-m acceptance region** and physically stopped, but the independent final member/polygon recapture **rejected** the actual pose. Last planned guidance point was approximately **(217.565, −238.146)**. The root at the last stationary sample was approximately **(215.155, −237.973)**, **2.416 m** from that nominal point—inside the permitted **2.5 m guidance arrival radius** in `NativeStaticAssemblyDriveMechanism:movementStatus`. The stopped root's recorded forward vector was approximately **(0.9997, 0.0250)**. The source `CompletionSettlementRoute.verifyTerminal` requires actual complete-member footprint outside the source polygon and all registered neighbours and fully inside the exterior edge band. The log only reports the **combined failure code**, not whether source-field overlap, neighbour overlap, lateral/depth band or station/corner threshold specifically failed. Do **not** attribute failure to one exact boundary from the root point alone.

**Architectural consequence — Terminal Confirmation and Local Correction:** nominal terminal feasibility at a planned point cannot substitute for measured full-assembly terminal success at the reached pose, particularly when the guidance target's arrival tolerance can accept more than 2 m of position error. Stopping worked; occupancy did not. Before declaring a settled worker, independently evaluate the whole actual assembly; if the result is inadequate, a future concept may permit a **bounded, physically feasible correction**, with new geometry evidence, rather than counting the original guidance target as terminal. Any correction must obey stopping/Control leases and neighbouring-field safety; it is a design proposal, not approved executable behaviour.

**Planning UX:** ~7.78 and ~8.03 seconds of responsive search for these workers, consistent with TS018's ~8.24 s. Future operational/HUD messages should explain this deliberate waiting, without adding HUD changes inside the current evidence-only review.

**Disposition:** TS019 **mixed drive evidence, incomplete terminal settlement for both**. Reverse/forward native movement and physical neutralisation for the second are GIANTS-validated; the first was correctly refused under the existing restricted candidate policy. This does not invalidate TS018, nor demonstrate generalisation. Retain TEST `0.5.5.11`, draft/unmerged PR #482, unchanged player-Control interlock and single-member constraint. No executable changes authorised here.

## TS019 — owner screenshot corrects first route feasibility and second physical PASS (12 October 2026)

**Subsequent owner evidence:** annotated aerial screenshot `Screenshot_20261012_180542.png` and direct clarification: **"The second one was successful. It is the same worker as TS018. There is a route to edge 9, just lengthy."** This correction **supersedes the prior assistant interpretation that neither worker achieved useful terminal parking**. The original TS019 log analysis remains an accurate account of the software events; it was **not** a complete account of the user's physical assessment of the scene.

### Worker one — candidate search scope versus actual approach reachability

- Owner's long blue curve begins at the completed worker in the **upper/right area** of the field and traverses the field towards the **southern margin / preferred edge 9**, bending around the field's western side before reaching the edge. The screenshot supplies a **plausible, spatially coherent approach concept** to edge 9 despite the long distance. It is *not an executed GIANTS route*, nor a measurement of swept obstacle clearance or turn radii.
- The current plan search evaluates only **local entry manoeuvre families** around the completion pose: finite reverse distances, arcs of selected radii/angles and short terminal runout. It does not search for an **Extended Infield Approach** connecting a distant completion pose to the same preferred parking edge. Thus `NO_POSE_REACHABLE_PARKING_REGION` means **"not found within local candidates for edge 9"**, rather than "edge 9 cannot be reached."
- **New architectural distinction — Local Entry versus Extended Infield Approach.** Edge 9 may remain the preferred target; the planner should not infer another edge is mandatory merely because the short-entry search fails. A useful hierarchy is *nearby safe entry if one exists → feasible longer intra-field approach to the preferred parking strip → alternative field-edge regions where justified → player intervention if no safe route is proven*. That is a **proposed conceptual order**, not a new approved implementation algorithm, and user priority between different edges and long paths remains to be decided.
- The full polygon of Field 77 gives geometric context but alone does not certify that a long approach is drivable. Guidance, source-field containment, remaining active workers' productive demand, obstacles and actual manoeuvring limits matter. The blue line is **positive evidence of an intended approach**, not a proven safe corridor.

### Worker two — physical PASS versus formal terminal predicate

- Owner reports the second worker **successfully parked**; it is the **same worker as validated TS018**. The screenshot shows the completed red sprayer stationary in the **southern grass strip**, approximately parallel to the adjoining field edge. This is a **player-observed physical parking PASS**, not a software `COMPLETION_SETTLEMENT_FINISHED`.
- The TS019 log still indisputably records a cruise-OFF, sustained low-speed stop followed by `WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION`. This is now a **Terminal Verification Discrepancy**: user-observed satisfactory parked outcome versus strict nominal geometry rejection. A *false negative is plausible*, but **not independently proven**, since the screenshot does not expose exact GIANTS registered polygons, per-member corners, measured edge-band clearance or neighbour intersections.
- The previous ~2.416 m shortfall from the last guidance point remains a fact, **not a demonstrated root cause**. Whether stopping tolerance, the 0.15 m full-corner depth minimum, terminal station window, heading tolerance, source/neighbor overlap or another test caused the rejection is **unknown**.
- Next diagnostic need: publish **the first failed terminal predicate and actual measured geometrical margin** (station bounds, root and four actual member-corner normal depths, source polygon intersection, registered-neighbour intersection, heading alignment). Preserve physical stop before checks and avoid weakening the safety predicate solely to force a PASS. Assess any genuine required local correction **only after** the exact deficit is known.

### Updated TS019 assessment and scope

**Worker one:** completion successfully observed; **NO MOVE / local route coverage FAIL** to preferred edge 9, although the owner demonstrates a plausible *long* approach that the planner never considers. **Worker two:** **PHYSICAL PARKING PASS per owner** with reverse/forward motion and stationary placement; **software terminal verification FAIL/discrepancy**, unresolved until geometric failure attribution. **TS018 remains PASS**, and the same worker repeating physical placement strengthens the observed single-assembly manoeuvre result. The two outcomes are not equivalent to a double physical failure.

The next discussion should protect **parking objective vs route availability vs formal evidence**, with no executed long-route or verified false-negative claim. This is an **evidence/architecture correction only**: no change to TEST `0.5.5.11`, player-Control interlock, exact field-edge candidate enumerator, or stop/geometry verifier. Draft PR #482 remains unmerged.

## TS019 runtime outcome clarification — terminal warning is post-release (12 October 2026)

**Owner question:** what actually follows `WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION`? The owner considers the second worker physically successful and has not requested a further corrective drive. Inspection of the exact experimental `0.5.5.11` sources establishes:

1. `CompletionSettlementRuntime:update` observes `status.isStopped` after native cruise-OFF and stable low speed, then invokes `self.drive:stopMovement(vehicle)` first.
2. On successful release, `s.driveArmed=false`, `COMPLETION_SETTLEMENT_LEG_FINISHED` is emitted, and `s.legIndex` increments. No further route leg exists, so `Runtime:startLeg` calls `CompletionSettlementRoute.verifyTerminal`.
3. When the strict terminal predicate returns `false, "WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION"`, `Runtime:finish("COMPLETION_SETTLEMENT_INTERRUPTED",reason)` clears `self.active` and `self.pending` and publishes a **NORMAL/WARNING** outcome. Because `state.driveArmed==false`, `finish` does **not** call `cancelMovement` and issues **no additional physical command**.
4. The per-vehicle `self.attempted[vehicle]` flag set on initial completion admission is not cleared by this terminal outcome; an ordinary later update cannot restart the episode.

**Named distinction — Post-Release Terminal Verification Advisory.** A completed, physically stopped, released worker can generate a strict formal terminal-verification FAIL **without any consequent relocation, retry or control lease**. This is the actual current implementation, not a proposed policy change. The term `INTERRUPTED` is a log status, not evidence that motor Control remains held. If lease release itself had failed, it would follow a different interruption path; in TS019 the successful stop and cruise-OFF evidence and subsequent geometry rejection identify the post-release case.

**TS019 accepted physical result:** the second worker is a **physical parking PASS per owner**, despite the software geometry-warning discrepancy. The exact polygon predicate remains unresolved; instrumenting it later may improve evidence but does not justify *automatic correction* of an acceptable parked assembly. No experimental executable behaviour is changed.

### Agreed next architecture inquiry — Extended Infield Approach to edge 9

The owner agrees to investigate **a longer approach** to the existing preferred edge rather than presuming the distant worker needs another edge. Separate:
- **Target region:** any suitable lengthwise station on preferred Field 77 edge 9, with full-member parked inter-field clearance.
- **Extended Infield Approach:** a feasible route from the worker's *actual completed pose* through the source field to a reachable local manoeuvre entry pose near that edge. The sketched blue TS019 route is a spatial hypothesis, not certified travel.
- **Local Entry:** the existing short reverse→forward or forward J guidance, only after a suitable arrival pose is established.
- **Stopped Terminal:** native cruise-OFF and actual stationary assembly, then the existing non-correcting terminal verification publication.

An extended approach is **not** achieved by raising `MAX_POINTS`, increasing the 35 m run-out literal or substituting one 200 m `driveToPoint` command. It requires a traversable sequence of short attainable guidance targets with heading continuity and measured containment, and must consider still-active workers and conflict zones: in TS019 worker one completed while worker two remained at work. Extended travel across the field cannot assume that productive space is empty or free of right-of-way commitments.

**Evidence and implementation status:** no trajectory across Field 77 was actually driven by worker one in TS019; long-route feasibility is not yet validated. This research note **does not authorise** an automated long route or new collision-control policy. Executable `0.5.5.11` unchanged, existing player-Control veto unchanged, and PR #482 remains draft/unmerged.


## Extended Infield Approach — initial architecture investigation after TS019 agreement (12 October 2026)

**Authority:** the owner agreed to investigate longer infield routing to preferred Field 77 edge 9. This agreement is **architectural investigation**, not permission for a new physical-Control algorithm or an automatic corrective drive. TEST `0.5.5.11` remains the validated single-member, locally reachable prototype.

### Source inspection and specific TS019 evidence

- `CompletionSettlementRoute.plan` fixes source Field 77 polygon edge 9 and enumerates **local** candidate strategies: five nominal reverse distances (0/12/18/24/30 m), three trial turn radii (12/18/24 m), five trial turn angles (35–75°), two edge directions and two local entry families. Candidate tracks include only local short guidance points and ≤35 m of extra tangent runout. The method does **not** build a connecting route from a remote completion pose to another part of the source field.
- The accepted short planner already defines both terminal **position and approximate parallel heading**, but does not publish **all valid local entry poses** as a set that a separate extended-route planner could target. This missing boundary is best named **Approach Entry Region**: the set of feasible full-assembly poses (X/Z and yaw, not X/Z alone) from which a validated local parking manoeuvre can begin.
- The registered Field 77 polygon, connected native edge identities, inward/outward normals and registered-neighbour polygons are available through `FarmEdgeGeometry`. The existing `FarmSpatialContextProbe`, `PhysicalMarginConstraintProbe` and `SettlementCorridorAssessment` offer **read-only observations**, not a proven drivable longitudinal corridor or long-route solution. The available GIANTS `driveToPoint` helper is a local steering actuator, **not** a route planner.
- TS019 log: root `396315` completed at **17:53:14.699**, but `NO_POSE_REACHABLE_PARKING_REGION` resulted at **17:53:22.477** without a steering command. Root `400002` completed at **17:54:09.349**—**54.650 seconds after the first**—and subsequently drove its accepted local route. Thus a long cross-field approach attempted immediately by worker one would coexist with a still-unfinished second job. The data do **not** prove exactly where that active worker would be at each future approach stage.
- **Evidence gap:** the normal logs do not publish the *first worker's world X/Z and heading at the completion event*, nor a sequence of full-assembly candidate poses and cross-field clearance results. The user's blue screenshot establishes a **plausible topology** for a long path to the western end of edge 9 but supplies no measured metre-scale route, yaw profile, swept footprint or future-worker trajectories. A numerical safe-route or runtime estimate cannot currently be supported.

### Hypothesis — Extended Approach targets an Entry Pose Set, not a waypoint

A future **Extended Infield Approach** responsibility should seek a continuous source-field-contained path from the completed assembly's actual pose to **any reachable member of the Approach Entry Region** along preferred edge 9. The accepted local parking guidance owns the next phase and its terminal-region verification; the extended approach has **no independent parking-success condition** and must not force a particular edge endpoint. This separation avoids reproducing the long-target steering failure in TEST 0.5.5.8.

Candidate-feasibility questions, **not implemented as settled rules**:
1. **Topology/containment:** is there a connected infield corridor from the completion pose to at least one local entry region, accounting for nominal full-assembly footprint, neighbouring fields, edge/corner geometry and static world constraints? A visual path is not an occupancy certificate.
2. **Kinematic continuity:** can an actual assembly acquire/maintain appropriate heading through a sequence of GIANTS-reachable short targets, without unvalidated reversing or jackknifing? A sequence of line-segment centres does not prove swept clearance.
3. **Concurrent demand:** can the completed worker traverse the proposed corridor while other AI workers continue productive fieldwork, subject to the existing pairwise Interaction Bubble / Regulation responsibilities? A long path may intersect future active-worker demand, and a static snapshot is not enough to promise clearance throughout.
4. **Evidence handoff:** does the completing worker actually arrive at a qualified entry pose, within an acceptable physical heading/position and current occupancy envelope, before the local parking manoeuvre may acquire its separate Control lease? An approach's final waypoint is not proof that an entry is feasible *at arrival time*.
5. **Performance and revocation:** can the route assess geometry under incremental bounded frame work, with a clear no-route or WAITING_FOR_EVIDENCE outcome and revocation if the source field's occupancy changes? Do not regress to synchronous search or an unsupported global Lua coroutine dependency.

**Proposed lowest-cost next validation:** a **strictly non-actuating, bounded read-only Extended Approach Feasibility Probe** on the same TS019 theatre, capturing actual root pose/heading at completion and the other active worker's presence; report multiple potential edge-9 entry poses and the reason a connecting infield corridor is supported or unknown. It should not alter current TRANSIT, local settlement steering, terminal verification, player-Control interlock, or legitimate player intervention. A subsequent supervised single-assembly movement TEST would require explicit route admission and owner authorisation. This is a proposed experiment only, not an approved feature or next build.

**Authority Triad disposition for this research:** architecture retains the existing Attempt/Approach/Terminal responsibility boundaries; `spec/COMPLETION_SETTLEMENT_CONTROL.md` correctly describes the current restricted TEST route and does **not** yet promise long-range navigation; `scripts/coordination/CompletionSettlementRoute.lua` and runtime remain unchanged. Current tests do not establish extended-route connectivity or interaction safety. The source failure and the owner's visual long-route hypothesis are both preserved as evidence, without reclassifying them as a proven drivable path.
