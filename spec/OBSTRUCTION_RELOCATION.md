# Obstruction Relocation — 0.5 Specification

**Jurisdiction ID:** `OBSTRUCTION_RELOCATION`

**Primary Architecture Authority:** [Causal Obstruction and Obstruction Relocation](../architecture/OBSTRUCTION_RELOCATION.md)

**Restoration status:** TEST `0.5.1.4` now connects the archived physical donor to a narrow **native blocked + one non-active vehicle in the current immediate forward physical corridor** admission. This path is source-implemented and offline-challenged but **not yet GIANTS field-validated**. The broader archived Causal Obstruction/Resolution lifecycle is not claimed as implemented.

**Archived donor:** [0.4.11.0 Obstruction Relocation Specification](https://github.com/bisdat/FS25_OuttaMyWay/blob/archive/0.4.11.0/spec/OBSTRUCTION_RELOCATION.md), where `OBSTRUCTION_RELOCATION` is an admitted non-active Causal Obstruction Resolution rather than a `TERMINAL_EGRESS` job-completion courtesy. The archived spec is source material, not independently live authority after a 0.5 replacement-core simplification.

## Admission and identity contract

A relocation decision MUST have current positive evidence for **all** of:

1. An eligible active GIANTS FIELDWORK **beneficiary** and a supported local continuation demand currently obstructed.
2. One exact physically represented non-active **blocker**, which is positively connected to that obstruction by current evidence and not merely within a convenient radius.
3. The blocker has no currently active GIANTS Job Episode, and is not currently controlled under higher-priority GIANTS/player authority.
4. A current location/direction reference and bounded inward actuation objective are available. Derive the authorising field from the **beneficiary's own** native current Field Course / Operation evidence; never infer it from the nearest adjacent field.
5. The non-job actuator can be acquired without conflicting with an existing active-worker / non-job control lease, and the supported Situation has not changed during admission.

Historical GIANTS Job completion MAY provide diagnostic provenance, but MUST NOT be required as the admission condition. Current GIANTS `isBlocked` alone does not identify a particular physical blocker. A non-active vehicle is not a fictitious second GIANTS AI worker; it does not use pair commitment or native FIELDWORK restart.

## First live admission contract — TEST 0.5.1.4

Use only an existing ≥1 second native single-worker blocked occurrence and a **unique** physical non-active, unclaimed blocker from the current GIANTS vehicle population. A positive causal candidate requires the blocker root to lie in the worker's immediate forward steering-aligned body envelope, established from both physical vehicle `size.width` and `size.length`, observed poses and heading. Completion history, speculative turn sweep, arbitrary closest-vehicle selection and nearest-field identity are not substitutes. Unresolved geometry or multiple matching blockers means no non-job admission; the accepted solo BWR remains available.

Upon admission, use the archived native non-job actuator for **one bounded forward inward movement toward the beneficiary's own GIANTS active-course field centroid**, capped at 60 m or the nearer centre (archived calibration). Never start/stop a GIANTS AI job for the non-active blocker. Native unblock stops ongoing relocation. Neutralise physical movement and release owned contexts; do not treat movement completion as successful beneficiary continuation. Report `MANOEUVRE_COMPLETE_PENDING_CONTINUATION` and separately report later positive native unblock. No additional Hold timer, completion-triggered parking, repeated courtesy, broad future-space scanner or unrelated safety gate is introduced.

This is a **limited and falsifiable implementation hypothesis**, not proof of physical clearance. Extended implements, third-party route clearance and positive subsequent useful agronomy require GIANTS Reality evidence.

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
| `CurrentPhysicalAssemblySource.lua`, `CurrentPhysicalPoseSource.lua` | Donor identified; **not directly lifted** | Reconstruct current inventory / position evidence without archived ValueRecord dependency |
| `CausalObstructionAssessment.lua` | Donor identified; **not directly lifted** | `NonActiveObstructionAssessment.lua` uses the current native blocked pulse + unique forward real vehicle envelope, without the archived generic picture |
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
| [`scripts/assessment/NonActiveObstructionAssessment.lua`](../scripts/assessment/NonActiveObstructionAssessment.lua) | `REALISES` |
| [`scripts/control/NonActiveRelocationControl.lua`](../scripts/control/NonActiveRelocationControl.lua) | `REALISES` |
| [`scripts/coordination/LiveHoldRelocateRuntime.lua`](../scripts/coordination/LiveHoldRelocateRuntime.lua) | `SUPPORTS` |

**Partial implementation distinction:** The non-job mechanical contract is realised by a ported physical primitive. The *whole* Obstruction Relocation responsibility is not wired, admitted or exercised in live GIANTS Reality yet. Adding a source participant does not imply automatic non-active movement is enabled.

## Repository validation participants

| Validation surface | Participation |
| --- | --- |
| [`tests/shell/non_job_actuation.lua`](../tests/shell/non_job_actuation.lua) | `CHALLENGES` |
| [`tests/shell/non_active_obstruction.lua`](../tests/shell/non_active_obstruction.lua) | `CHALLENGES` |
