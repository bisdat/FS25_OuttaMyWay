# Obstruction Relocation — 0.5 Specification

**Jurisdiction ID:** `OBSTRUCTION_RELOCATION`

**Primary Architecture Authority:** [Causal Obstruction and Obstruction Relocation](../architecture/OBSTRUCTION_RELOCATION.md)

**Restoration status:** TEST `0.5.1.4` **failed GIANTS Reality** (no action until after collision; no blocker movement). TEST `0.5.1.5` replaces that disproven trigger with the archived positive current-physical and realised-motion Causal Obstruction kernels; the non-job physical executor is independently instrumented. This is not yet a GIANTS PASS. Archived prospective Future Space and the full 0.4 Resolution runtime are deliberately **not** imported.

**Archived donor:** [0.4.11.0 Obstruction Relocation Specification](https://github.com/bisdat/FS25_OuttaMyWay/blob/archive/0.4.11.0/spec/OBSTRUCTION_RELOCATION.md), where `OBSTRUCTION_RELOCATION` is an admitted non-active Causal Obstruction Resolution rather than a `TERMINAL_EGRESS` job-completion courtesy. The archived spec is source material, not independently live authority after a 0.5 replacement-core simplification.

## Admission and identity contract

A relocation decision MUST have current positive evidence for **all** of:

1. An eligible active GIANTS FIELDWORK **beneficiary** and a supported local continuation demand currently obstructed.
2. One exact physically represented non-active **blocker**, which is positively connected to that obstruction by current evidence and not merely within a convenient radius.
3. The blocker has no currently active GIANTS Job Episode, and is not currently controlled under higher-priority GIANTS/player authority.
4. A current location/direction reference and bounded inward actuation objective are available. Derive the authorising field from the **beneficiary's own** native current Field Course / Operation evidence; never infer it from the nearest adjacent field.
5. The non-job actuator can be acquired without conflicting with an existing active-worker / non-job control lease, and the supported Situation has not changed during admission.

Historical GIANTS Job completion MAY provide diagnostic provenance, but MUST NOT be required as the admission condition. Current GIANTS `isBlocked` alone does not identify a particular physical blocker. A non-active vehicle is not a fictitious second GIANTS AI worker; it does not use pair commitment or native FIELDWORK restart.

## Restored pre-stall admission — TEST 0.5.1.5

Admit a **single current non-active unclaimed Physical Assembly** only after positive Causal Obstruction is established from the archive's physical representation and Situation contracts. `CurrentPhysicalConflictRepresentation` supplies observed GIANTS world-shape `DISC` geometry (including current child vehicle membership); `PlanViewFootprint` supports current positive physical overlap; the archived `CausalObstructionAssessment` also evaluates current worker `REALISED_MOTION_DEMAND` sweeps derived from positively established aligned physical progression. Coherence and reach use the archived Trajectory/Realised Motion calibrations, with no independent turn promotion. This evidence can arise **before** GIANTS `isBlocked` and must not infer negative clearance, unrelated future turns or inactive-worker relocation merely because a completed worker is nearby. One candidate relation is required; ambiguity or unavailable shapes grants no non-job actuation. Native blocked-state remains the separate accepted reactive BWR authority.

Upon admission, use the archived native non-job actuator for one bounded inward actuation toward the beneficiary's own GIANTS active-course field centre; apply the original **40 m Offset Relocation Centre** when the centroid bearing is sufficiently aligned with the beneficiary's positively supported incoming approach (archived alignment threshold 0.8660). Cap any single actuation at **60 m** or the nearer relocation centre. The non-active blocker receives **no invented GIANTS AI Job**. Stop on positive native blockage recovery only when it was actually observed; do not terminate a preventive intervention immediately because GIANTS `isBlocked` is false. Distinguish motor readiness, native physical drive acceptance and actual displacement; all require GIANTS Reality. Retire non-job state without GIANTS physics on post-destruction mission deletion, following archived Control teardown. A manoeuvre outcome is not semantic beneficiary continuation.

This is a falsifiable archive-derived implementation, not proof of successful physical clearance. GIANTS positive completed-worker obstruction, harmless nearby completed-worker, turning false-positive, non-job propulsion, physical displacement and useful continuation remain required. The old native-blocked admission implementation is retained only as failed historical evidence.

## Bounded movement contract

When authorised, perform one inward movement toward a supported Relocation Centre, optionally offset laterally from a positively supported active approach direction. A bounded actuation is limited to the meaningful remaining distance to that Centre and the separately verified per-actuation cap. The archived control donor uses 60 m and optional 40 m offset; validate those constants before adoption, preserving the distinction from solo BWR's accepted **40 m reverse region**.

Apply only the necessary configuration, propulsion, vehicle-activity and movement effects. The non-job Physical Control donor is `AIVehicleUtil.driveInDirection`, **not** an invented GIANTS AI job. Request any supported compaction prior to movement without inferring success from request acceptance.

On finish, loss of current movement authority, disabling, or unexpected Job reactivation, stop issuing movement commands, neutralise owned physical effects where permitted and return leased propulsion/activity state without overriding newer GIANTS/player authority. Do not leave temporary `motor` / `cruiseControl` compatibility fields on the vehicle after any call.

Archived Relocation Serialization may be relevant when the beneficiary can move concurrently; decide this explicitly before adopting a zero-speed beneficiary Hold. Do not automatically reuse the current *pairwise* 1 km/h Regulation or the *single-worker* no-Hold rule for a different responsibility.

## Reassessment and completion

An ended physical manoeuvre is an **actuation outcome**, not semantic obstruction discharge. Reobserve the current blocker and beneficiary and require supported positive beneficiary continuation to settle success. If current Causal Obstruction persists but meaningful inward actuation remains, another independent bounded actuation may be considered only on fresh evidence. Do not install an arbitrary movement count, completed-worker courtesy budget, parking fallback, persistent historical retry veto or silent automatic failure policy.

If observed reactivation, player control, incomplete Reality or unsupported movement prevents another actuation, report the strongest evidenced unresolved/superseded outcome; do not silently assert `OBJECTIVE_SATISFIED`.

## Port classification / traceability

| Source from archive/0.4.11.0 | First 0.5 stage | Subsequent obligation |
| --- | --- | --- |
| `CurrentPlayerControlObservation.lua` | Physical current-control predicate port | Use in the non-active admission/Control boundary |
| `NonJobActuationMechanism.lua` | Subordinate GIANTS non-job physical actuation port | Invoke only through independently admitted non-active relocation Control |
| `CurrentPhysicalAssemblySource.lua`, `CurrentPhysicalPoseSource.lua` | Archived physical inventory donors | The 0.5 adapter enumerates fresh `mission.vehicleSystem.vehicles` / `activeJobVehicles` and retains the same current-only identity contract; positive world-shape geometry is **lifted intact** from the archived representation modules |
| `CausalObstructionAssessment.lua` | **Core positive kernels lifted** | Current/future/demand physical conflict with no archived `ValueRecord` / `OperationalPicture` dependency; realised motion supplies the current bounded support |
| `ObstructionRelocationCandidateSupport.lua` and `ObstructionRelocationCommitmentLifecycle.lua` | Donors identified; **not directly lifted** | Admission, bounded direction and positive post-manoeuvre settlement |
| `ObstructionRelocationControl.lua` | Donor identified; **not directly lifted** | `NonActiveRelocationControl.lua` performs one bounded forward inward actuation using the imported non-job mechanism; GIANTS Reality remains required |

The donor's old `ValueRecord`, `OperationalPicture`, `ResolutionCommitment` and `AuthorityRegistry` entire dependency graph is **not** a valid reason to reinstall the old 0.4 runtime. Any adaptation MUST preserve its semantic contracts while integrating with current 0.5 explicit authority.

## Validation contract

**Offline first:** The imported non-job mechanism must exhibit original GIANTS `driveInDirection` convention, temporary compatibility-field restoration, current player/source-AI interlock, propulsion start/stop and retained/non-retained motor-state restoration as applicable, physical neutralisation and activity-context release. Retain/compare archive mechanism tests as evidence. This is not a GIANTS in-game result.

**Before live restoration:** prove positive and negative Causal Obstruction cases, current non-active inventory including cold start, no synthetic GIANTS Job, deliberate beneficiary concurrency choice, and fresh positive continuation.

**GIANTS acceptance:** reproduce supported completed-worker obstruction, show physical movement of the *non-active* vehicle and useful continuation; replay irrelevant completed/parked vehicles as negative controls; replay source reactivation/player claim and third-party occupancy; rerun TS015 and TS003 for pairwise/single-worker non-regression.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/observation/CurrentPlayerControlObservation.lua`](../scripts/observation/CurrentPlayerControlObservation.lua) | `SUPPORTS` |
| [`scripts/control/mechanisms/NonJobActuationMechanism.lua`](../scripts/control/mechanisms/NonJobActuationMechanism.lua) | `REALISES` |
| [`scripts/representation/PlanViewFootprint.lua`](../scripts/representation/PlanViewFootprint.lua) | `REALISES` |
| [`scripts/representation/EntityLocalShapeEvidence.lua`](../scripts/representation/EntityLocalShapeEvidence.lua) | `REALISES` |
| [`scripts/representation/CurrentPhysicalConflictRepresentation.lua`](../scripts/representation/CurrentPhysicalConflictRepresentation.lua) | `REALISES` |
| [`scripts/assessment/CausalObstructionAssessment.lua`](../scripts/assessment/CausalObstructionAssessment.lua) | `REALISES` |
| [`scripts/assessment/NonActiveObstructionAssessment.lua`](../scripts/assessment/NonActiveObstructionAssessment.lua) | `REALISES` |
| [`scripts/control/NonActiveRelocationControl.lua`](../scripts/control/NonActiveRelocationControl.lua) | `REALISES` |
| [`scripts/coordination/LiveHoldRelocateRuntime.lua`](../scripts/coordination/LiveHoldRelocateRuntime.lua) | `SUPPORTS` |

**Implementation/Reality distinction:** The positive archived Causal Obstruction and bounded non-job Control **are now wired** in TEST `0.5.1.5`; this has **not** demonstrated successful pre-collision movement or productive GIANTS continuation. Offline CI is a source-contract check, not a physical PASS.

## Repository validation participants

| Validation surface | Participation |
| --- | --- |
| [`tests/shell/non_job_actuation.lua`](../tests/shell/non_job_actuation.lua) | `CHALLENGES` |
| [`tests/shell/non_active_obstruction.lua`](../tests/shell/non_active_obstruction.lua) | `CHALLENGES` |
| [`tests/shell/archived_physical_representation.lua`](../tests/shell/archived_physical_representation.lua) | `CHALLENGES` |
