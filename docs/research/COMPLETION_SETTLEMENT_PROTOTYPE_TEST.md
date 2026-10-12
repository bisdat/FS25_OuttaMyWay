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
