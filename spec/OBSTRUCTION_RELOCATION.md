# Obstruction Relocation — 0.5 Specification

**Jurisdiction ID:** `OBSTRUCTION_RELOCATION`

**Primary Architecture:** [Causal Obstruction and Obstruction Relocation](../architecture/OBSTRUCTION_RELOCATION.md).

**Restoration status:** [Issue #463](https://github.com/bisdat/FS25_OuttaMyWay/issues/463) is in progress. The current 0.5.1.3 live product contains active-worker Hold & Relocate, *not* completed-worker Obstruction Relocation. The first stage ports archived non-job physical actuation; no active control route is established by merely loading that subordinate mechanism. This is a future implementation contract, not a false assertion of field-tested behaviour.

**Archived donor:** [0.4.11.0 Obstruction Relocation Specification](https://github.com/bisdat/FS25_OuttaMyWay/blob/archive/0.4.11.0/spec/OBSTRUCTION_RELOCATION.md), where `OBSTRUCTION_RELOCATION` is an admitted non-active Causal Obstruction Resolution rather than a `TERMINAL_EGRESS` job-completion courtesy. The archived spec is source material, not independently live authority after a 0.5 replacement-core simplification.

## Admission and identity contract

A relocation decision MUST have current positive evidence for **all** of:

1. An eligible active GIANTS FIELDWORK **beneficiary** and a supported local continuation demand currently obstructed.
2. One exact physically represented non-active **blocker**, which is positively connected to that obstruction by current evidence and not merely within a convenient radius.
3. The blocker has no currently active GIANTS Job Episode, and is not currently controlled under higher-priority GIANTS/player authority.
4. A current location/direction reference and bounded inward actuation objective are available. Derive the authorising field from the **beneficiary's own** native current Field Course / Operation evidence; never infer it from the nearest adjacent field.
5. The non-job actuator can be acquired without conflicting with an existing active-worker / non-job control lease, and the supported Situation has not changed during admission.

Historical GIANTS Job completion MAY provide diagnostic provenance, but MUST NOT be required as the admission condition. Current GIANTS `isBlocked` alone does not identify a particular physical blocker. A non-active vehicle is not a fictitious second GIANTS AI worker; it does not use pair commitment or native FIELDWORK restart.

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
| `CausalObstructionAssessment.lua` | Donor identified; **not directly lifted** | Reconnect genuine current causal relation to accepted 0.5 evidence, preserve negative controls |
| `ObstructionRelocationCandidateSupport.lua` and `ObstructionRelocationCommitmentLifecycle.lua` | Donors identified; **not directly lifted** | Admission, bounded direction and positive post-manoeuvre settlement |
| `ObstructionRelocationControl.lua` | Donor identified; **not directly lifted** | Current 0.5 physical coordinator over imported non-job mechanism, tests and GIANTS Reality |

The donor's old `ValueRecord`, `OperationalPicture`, `ResolutionCommitment` and `AuthorityRegistry` entire dependency graph is **not** a valid reason to reinstall the old 0.4 runtime. Any adaptation MUST preserve its semantic contracts while integrating with current 0.5 explicit authority.

## Validation contract

**Offline first:** The imported non-job mechanism must exhibit original GIANTS `driveInDirection` convention, temporary compatibility-field restoration, current player/source-AI interlock, propulsion start/stop and retained/non-retained motor-state restoration as applicable, physical neutralisation and activity-context release. Retain/compare archive mechanism tests as evidence. This is not a GIANTS in-game result.

**Before live restoration:** prove positive and negative Causal Obstruction cases, current non-active inventory including cold start, no synthetic GIANTS Job, deliberate beneficiary concurrency choice, and fresh positive continuation.

**GIANTS acceptance:** reproduce supported completed-worker obstruction, show physical movement of the *non-active* vehicle and useful continuation; replay irrelevant completed/parked vehicles as negative controls; replay source reactivation/player claim and third-party occupancy; rerun TS015 and TS003 for pairwise/single-worker non-regression.
