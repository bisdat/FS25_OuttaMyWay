# Hold & Relocate Specification

## Identity and authority

**Specification Jurisdiction:** Hold & Relocate  
**Jurisdiction ID:** `HOLD_RELOCATE`

**Primary Architecture Authority:** [Hold & Relocate](../architecture/BLOCKED_PROGRESS_QUALIFICATION.md#specification-jurisdiction--hold--relocate)

This Specification operationalises the bounded native-blockage intervention defined by Architecture. Native Blockage Observation and Spatial Pair Inference nominate candidates only. Independent commitment authority revalidates current GIANTS FIELDWORK jobs, strategies, physical references, field jurisdiction and situation-specific eligibility before physical Control. GIANTS retains productive routing and blocked-state authority.

## Supported intervention situations

### Active worker pair

An observed native FIELDWORK worker must have a continuously supported positive `isBlocked` pulse lasting at least **1,000 ms**. Its possible partner need not be blocked. Both assemblies require distinct valid current root positions, eligible native FIELDWORK jobs and field-course strategies, horizontal root separation at most **30 m**, and the **same current GIANTS field polygon** with a valid centroid. Missing geometry or job evidence denies Control. Reciprocal nominations form one unordered pair occurrence, not two physical commitments.

### Solo active worker

With a qualified blocked worker and no eligible active-worker pair, a solo commitment may use the existing physical adapter. Its root may be inside or outside the current field polygon; a solo worker must not be refused for lacking pairwise common-field membership. Prefer inward movement toward the worker's **own native active course field**, never an adjacent registered field. Solo requests TRANSIT and native oblique reverse toward a **40 m projected Return Region**, then GIANTS native FIELDWORK handback immediately upon region entry. No fictional second worker, peer Regulation or relocated-worker Hold is permitted.

### Non-active static physical blocker

When no eligible active worker pair exists, retain a one-time **Blockage Encounter Snapshot** captured at the first positive native blocked edge, including at most three nearby physical roots. After the native one-second gate, an inactive approximately stationary assembly may be inferred as a candidate static blocker. The candidate must be distinct, presently AI-inactive, in the blocked worker's **own current GIANTS field-course polygon**, within **30 m** root separation, and have reported snapshot speed at most **0.25 m/s**. Current subject identity and state are independently checked at commitment. This is bounded inference, not proof of contact.

Player tab-selection/`playerControlled` does not by itself prove deliberate driving or authorise a static admission veto. Active-worker pair precedence remains first. Only one of static relocation and solo recovery may be committed for the same native occurrence; failure to infer a suitable static subject leaves independently supported solo recovery available.

## Asymmetric Cooperative Egress — pair planning

Evaluate available spatial regions for **both possible movers** before assigning physical Control. Use current root/nominal member geometry, same-field polygon, represented occupancy, available native reverse bearings and feasible forward alternatives. Centroid proximity is a preference, not a mandatory mover selection. Do not require a single candidate ray to be predominantly lateral relative to both perpendicular longitudinal assembly axes; this disproven condition could reject all TS001 candidates.

The full relocation objective is the **remaining worker's captured WORKING width + 5 m** of projected progress along the selected world-space movement direction. Bounded partial staging may be admitted when a full route is unavailable and there is real supported useful space; it is one complete independent movement, not a promise to execute a second stage. Do not select a movement solely because its endpoint lies outside an occupied corridor. Field-polygon and nominal straight-region checks are only geometrical candidate support, not physical wheelpath or articulated stability guarantees. When no supported region exists, refuse before issuing any physical Control.

## Paired native Control and independent releases

1. The pair commitment selects **one mover** and **one remaining worker**. Prepare TRANSIT requests for the mover only; the other worker remains in WORKING with its own GIANTS FIELDWORK job. Neither needs folding/raising state gates for movement to begin.
2. In one synchronous coordination step, request the mover's TRANSIT and start the selected native directional movement while configuration progresses. Regulate the remaining worker through its current GIANTS drive stream at a **1 km/h maximum**, preserving native steering, direction, acceleration and drive permission.
3. The current **paired nonmover Regulation window is 8,000 ms** from egress admission and expires independently from the mover's physical movement. Its native job/strategy turnover separately terminates its own lease. If a very fast mover reaches handback before the deadline, release any remaining Regulation during final cleanup; do not orphan a speed cap.
4. On positively measured vehicle-root Return Region progress, stop the mover's directional override. Independently Hold only the mover for **7,000 ms**, then invoke only its native FIELDWORK handback. Do not make the remaining worker's job restart, configuration or Control release a prerequisite.
5. Finish the current commitment once each actor's commanded effects have been released. Do not retain a sticky pair, group completion veto, automatic second movement, reserved route or cooldown suppressing new GIANTS-native blockage.

Pair admission validates both workers. During an already-selected mover's actuation, maintain the mover's own current native job/strategy and physical references. The nonmover's own lifecycle may supersede its speed lease without cancelling the mover merely because the other job changed.

### Paired movement continuation and interruption

Once paired movement starts, its authority is conditional, separate from admission:
1. The **primary** guard samples realised mover root position at most every **250 ms**, retaining five observations (normally **1,000 ms** between first and last) and computing the actual distance travelled, projected Return Region progress and signed perpendicular corridor departure. Samples separated by more than **500 ms** reset the incomplete window. This production evidence must not depend on DIAGNOSTIC publication or tool-joint instrumentation.
2. Provisional **Command-to-Corridor Divergence** classification requires at least **1 m** observed physical travel over a full window. **Strong divergence** is projected progress regression of at least **0.25 m**, accompanied by at least **1 m** increase in absolute lateral deviation. **Suspected divergence** is projected progress no greater than **25%** of observed travel with at least **1.5 m** increase in lateral deviation; require two consecutive overlapping suspect windows. Overlap is persistence, not independent statistical corroboration. These thresholds are an implementation hypothesis requiring TS004/TS001/TS015 field validation, not evidence of a universal safe articulation angle.
3. An absolute **20,000 ms** deadline begins with the accepted paired movement command and cannot be extended by progress, configuration changes or sampling resets.
4. The mover root must remain inside the **captured GIANTS field-course polygon** authorised for this paired egress; a boundary breach interrupts Control. This root-only bound does not claim that an attached implement remains within the polygon. The field-confined rule does not apply indiscriminately to solo, static or future intentionally off-field relocation.
5. Any guard breach pre-empts normal Return Region success on that update. The outcome is **EGRESS_INTERRUPTED** with a specific cause. Cancel only the mover's OMW directional override and own TRANSIT request/restore actions, with independently scoped Regulation cleanup as required. Do **not** issue success-only relocated Hold, stop/restart the current native job, automatically choose another mover or suppress genuinely fresh native blocked evidence. GIANTS' *existing* FIELDWORK job may continue and resolve or reassert blockage. If Control release fails, report **CONTROL_INTERRUPTED** rather than claiming clean handback.

This is a movement-continuation fail-safe, not a corrected steering controller or proof of collision-free physical settlement. Incomplete root evidence terminates an active paired movement conservatively.

## Reactive static Control and release

After exclusive static commitment, request TRANSIT once for the non-active subject, then issue supported direct GIANTS `driveToPoint` commands under a scoped motor, physics and native cruise lease; completed/non-job machines do not independently issue periodic AI drive commands. Regulate the **blocked active beneficiary at 1 km/h for 5,000 ms**, retaining its existing GIANTS job and WORKING configuration. This is not a translation STOP or a FIELDWORK job replacement.

Select supported forward or reverse oblique departure from the static root's facing and beneficiary's native course axis. Size the nominal requested move from beneficiary WORKING width **+ 5 m**. Completion requires **real signed cross-track root displacement** into the admitted region after native drive was issued, not mere axial travel or a commanded target. Current field-interior preference does not guarantee final interior settlement or physical envelope clearance.

The **25,000 ms static movement deadline** bounds the current non-job actuation. When movement succeeds or is interrupted, neutralise the active drive and restore temporary motor/cruise/physics effects. Keep the non-active relocated subject's requested TRANSIT state; do not send synthetic WORKING pose inverses. Native AI reactivation or disappearance of the subject requires its own Control cessation. The blocked beneficiary's independent Regulation timer must expire or be cleaned up without being made dependent on static motion completion.

## GIANTS mechanisms and handback

Use the native forward steering frame for forward movements and the vehicle native AI reverser frame for reverse. When GIANTS exposes a tool reverser-direction node, preserve its tool-relative target transform before passing **vehicle reverser-local** coordinates to `AIVehicleUtil.driveToPoint(moveForwards=false,...)`. Preserve native optional `doNotSteer` arguments and unrelated `driveToPoint` calls when interposing. Actual directional motor and cruise maxima bound requested native movement speed; no arbitrary universal OMW speed cap is conferred.

The **40 m look-through** beyond the Return Region is a reverse steering reference, not the movement-completion region or evidence of a feasible curved articulated path. Returning `NATIVE_RESTART_ACCEPTED`, reaching projected vehicle-root travel, reporting a running motor or accepting `driveToPoint` is not evidence of safe physical assembly clearance. GIANTS tool-direction-node yaw is not automatically a measured mechanical drawbar joint angle. **Kinematic Egress Feasibility** remains unresolved in [#470](https://github.com/bisdat/FS25_OuttaMyWay/issues/470); the existing route planner supplies nominal geometry and may still yield an unstable actual local steering demand.

For active-worker mover handback, prepare and validate a native replacement FIELDWORK job from the current job and farm, then stop the original and immediately start the replacement. The successful native call restores GIANTS productive authority without manufacturing actual agronomic progress evidence. No retained per-worker stop/restart attempt history, after-start identity polling gate or collective pair clearance claim is admitted.

Native Regulation, movement and translation-only Hold use distinct scoped control effects. Translation Hold must preserve GIANTS configuration/continuation permission rather than blocking the native worker's setup. Layered native drive wrappers must remain composable and must not intercept unrelated vehicles or lose existing native arguments.

## Uncertainty, interruption and failure

- Missing, stale or conflicting native admission facts deny action rather than defaulting a field, counterpart, width, direction or permission.
- Disablement, map deletion, Job Episode/strategy turnover, subject loss, failed Control calls and any invalid actuation state require prompt actor-scoped neutralisation/release of existing effects. No command may continue against a destroyed physical entity.
- Failure to release a current supporting Regulation or movement lease is a Control interruption, not successful handback. Safe relinquishment is not necessarily physical resolution.
- One completed occurrence does not authorise replay. Any new blocked occurrence after handback is independently observed and assessed.
- Return Region attainment and actuator acceptance do not certify complete-assembly separation, stable reversing, or continued productive coverage. Offline validation challenges contracts; physical behaviour requires GIANTS Reality.


## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/coordination/HoldRelocateCoordinator.lua`](../scripts/coordination/HoldRelocateCoordinator.lua) | `REALISES` |
| [`scripts/coordination/PairTransitRegion.lua`](../scripts/coordination/PairTransitRegion.lua) | `SUPPORTS` |
| [`scripts/coordination/ProjectedEgressRegion.lua`](../scripts/coordination/ProjectedEgressRegion.lua) | `SUPPORTS` |
| [`scripts/control/mechanisms/NativeReverseMechanism.lua`](../scripts/control/mechanisms/NativeReverseMechanism.lua) | `SUPPORTS` |
| [`scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua`](../scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua) | `SUPPORTS` |
| [`scripts/control/mechanisms/NativeTranslationHoldMechanism.lua`](../scripts/control/mechanisms/NativeTranslationHoldMechanism.lua) | `SUPPORTS` |
| [`scripts/control/mechanisms/NativeTransitRequestMechanism.lua`](../scripts/control/mechanisms/NativeTransitRequestMechanism.lua) | `SUPPORTS` |
| [`scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua`](../scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua) | `SUPPORTS` |
| [`scripts/coordination/NativePairCommitmentAuthority.lua`](../scripts/coordination/NativePairCommitmentAuthority.lua) | `SUPPORTS` |
| [`scripts/control/HoldRelocatePhysicalControl.lua`](../scripts/control/HoldRelocatePhysicalControl.lua) | `SUPPORTS` |
| [`scripts/coordination/LiveHoldRelocateRuntime.lua`](../scripts/coordination/LiveHoldRelocateRuntime.lua) | `SUPPORTS` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/hold_relocate.lua`](../tests/shell/hold_relocate.lua) | `CHALLENGES` |
| [`tests/shell/pair_native_drive_interposition.lua`](../tests/shell/pair_native_drive_interposition.lua) | `CHALLENGES` |
| [`tests/shell/pair_transit_region.lua`](../tests/shell/pair_transit_region.lua) | `CHALLENGES` |
| [`tests/shell/pair_transit_settlement.lua`](../tests/shell/pair_transit_settlement.lua) | `CHALLENGES` |
| [`tests/shell/native_reverse_mechanism.lua`](../tests/shell/native_reverse_mechanism.lua) | `CHALLENGES` |
| [`tests/shell/native_translation_hold_mechanism.lua`](../tests/shell/native_translation_hold_mechanism.lua) | `CHALLENGES` |
| [`tests/shell/native_transit_request_mechanism.lua`](../tests/shell/native_transit_request_mechanism.lua) | `CHALLENGES` |
| [`tests/shell/native_fieldwork_job_replacement.lua`](../tests/shell/native_fieldwork_job_replacement.lua) | `CHALLENGES` |
| [`tests/shell/live_hold_relocate.lua`](../tests/shell/live_hold_relocate.lua) | `CHALLENGES` |
| [`tests/shell/static_blocker_relocation.lua`](../tests/shell/static_blocker_relocation.lua) | `CHALLENGES` |

## Implementation traceability and validation scope

The listed production participants realise coordinating, native commitment, physical Control and mechanism responsibilities. Native Blockage Observation and Spatial Pair Inference remain separate upstream Specification Jurisdictions. Current runtime enables the supported paired, solo and non-active static recovery paths; these are not dormant prototypes or non-actuating shell plans.

Validation participants challenge admitted evidence, actor-scoped release, native interposition and mechanism behaviour. [Blocked Recovery Research](../docs/research/BLOCKED_RECOVERY_INVESTIGATIONS.md) and its linked evidence preserve historical test branches, disproven hypotheses and GIANTS scenario verdicts. Field evidence is necessary for actual wheelpaths, configuration progression, physical clearance and subsequent GIANTS continuation.
