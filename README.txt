FS25_OuttaMyWay v4.7.121 CANONICAL CANDIDATE — D-0147 TERMINAL YIELD / PENDING PLAYER RECLAMATION

BASELINE
Owner-declared canonical v4.7.112 (`f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`; git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`; 310 files). v4.7.120 is the immediate non-canonical live-tested implementation baseline.

ARCHITECTURAL CORRECTION
The player is expected eventually to return to/tidy completed workers. D-0147 therefore buys time rather than parks vehicles. A completed worker is Pending Player Reclamation. Automatic movement requires Terminal Yield Consent and exists to restore current useful active continuation (Continuity, Not Settlement). A later positive conflict may admit another Reactive Terminal Yield; there is No Final Settlement Requirement. External egress remains a valid expression but must respect Egress Externality Constraint. Conflict-Relative Infield Yield is architecturally permitted when outward movement would merely export the problem. Field centre/random wandering are not policy. Player escalation is legitimate normal gameplay.

IMPLEMENTATION
v4.7.121 changes architecture/provenance/identity only. v4.7.120 external-egress mechanics remain behaviourally unchanged: supported compaction, Vehicle Activity Context, fixed Exit Alignment via driveInDirection, 8 km/h, Positive Field-Exit Settlement, Player Claim and Actuation Neutralisation. Repeated/infield yield and externality-aware selection are not implemented yet.

CONFIG
Legacy `AUTOMATIC_TERMINAL_EGRESS=true` remains ON for testing by owner request. The name is intentionally retained until the broader implementation changes. Eventual player-facing automatic Terminal Yield is explicit opt-in/default-off.

---

FS25_OuttaMyWay v4.7.120 TEST BUILD — D-0147 EXIT ALIGNMENT CONTINUATION (E&OE)

Owner-declared v4.7.112 remains canonical. v4.7.119 live evidence validated the bounded Vehicle Activity Context: `isActive=true`, non-zero `rotatedTime`, non-zero physical wheel steering angles and realised yaw all appeared after genuine Job Episode completion. The remaining failure was geometric/control, not steering authority.

TS016 v4.7.119 showed Patriot following an approximately 86-degree realised arc while Candidate intended only the heading/outward bisector. The fixed outside point encoded displacement but not crossing heading; Positive Field-Exit Settlement then correctly refused success because the compact footprint was not yet wholly clear. This is recorded as **Exit Vector / Exit Heading Mismatch**.

v4.7.120 retires fixed-point pursuit. Candidate supplies one deterministic world Exit Alignment direction only. TerminalEgressControl holds that direction through GIANTS `AIVehicleUtil.driveInDirection()` while the validated Vehicle Activity Context is owned; steering demand should naturally decay as the vehicle aligns, then continue substantially straight. The manoeuvre ends only on Positive Field-Exit Settlement, Player Claim/source reactivation, mechanical failure or the existing one-manoeuvre watchdog. There is no nominal endpoint, target-radius settlement, target extension, second route or retry.

AutoDrive is used only as a mechanical donor for non-job `driveInDirection()` compatibility: temporary legacy `motor` / `cruiseControl` fields exist for the duration of each helper call and are restored immediately. No AutoDrive dependency, GIANTS AI job or `getIsAIActive()` override is introduced.

LIVE TEST: repeat TS016. The decisive visual result is a bounded turn toward the intended Exit Alignment followed by straight outward continuation until the whole compact footprint is clear. Log markers are `EXIT_ALIGNMENT_ACTUATION`, steering telemetry, Positive Field-Exit Settlement, `ACTUATION_NEUTRALIZED`, then Vehicle Activity Context release.

---

FS25_OuttaMyWay v4.7.119 TEST BUILD — D-0147 TERMINAL EGRESS VEHICLE ACTIVITY CONTEXT (E&OE)

Owner-declared v4.7.112 remains canonical. v4.7.119 carries forward v4.7.118 geometry, curvature actuation, steering telemetry, Positive Field-Exit Settlement and Actuation Neutralisation unchanged.

v4.7.118 live evidence isolated the steering break: `vehicle.rotatedTime` remained materially non-zero, CrabSteering remained in its AI mode, but every steerable wheel physics steering angle remained zero. The supplied FS25 SDK shows `WheelPhysics:serverUpdate()` only realises steering while `vehicle.isActive` is true. Courseplay preserves active AI context; AutoDrive independently demonstrates non-job autonomous driving while `forceIsActive=true`.

v4.7.119 therefore adds one bounded physical context only. On D-0147 EGRESS admission, OuttaMyWay captures the prior `vehicle.forceIsActive`, temporarily asserts it, and restores the captured value on every EGRESS exit. No GIANTS AI job is created or restarted and `getIsAIActive()` is not overridden. Owned success/failure/exhaustion still neutralises actuation before activity restoration; Player Claim/source reactivation receive no later drive/stop command but immediately relinquish the temporary activity context.

LIVE TEST: one TS016 Terminal Egress is sufficient initially. Look for `VEHICLE_ACTIVITY_CONTEXT_ACQUIRED`, then `STEERING_NEXT_UPDATE` / `STEERING_HEARTBEAT` with `isActive=true`. The decisive evidence is whether steerable-wheel `a=` values leave zero and realised heading/yaw follows.

---

FS25_OuttaMyWay v4.7.118 TEST BUILD — D-0147 STEERING-STATE HANDOFF DIAGNOSTIC + ACTUATION NEUTRALISATION (E&OE)

Owner-declared v4.7.112 remains canonical. This production diagnostic carries forward v4.7.117 unchanged mechanically: the same Oblique Boundary Egress target and bounded-curvature command remain in force. No third steering hypothesis is introduced.

v4.7.117 live evidence proved that a non-zero `driveAlongCurvature()` command still produced essentially straight travel after genuine Job Episode completion. SDK review then established that GIANTS driving helpers write steering demand (`vehicle.rotatedTime`) while actual wheel steering is realised later by `WheelPhysics:updateSteeringAngle()`. Courseplay likewise routes through normal active-AI lifecycle and the same GIANTS drive helper rather than replacing wheel steering.

v4.7.118 therefore records the steering handoff at four points: baseline before actuation, immediately after the first curvature command, the next Control update, and one-second heartbeats. Evidence includes `rotatedTime`, `minRotTime` / `maxRotTime`, player-controlled state, CrabSteering state / AI mode index, and actual steerable-wheel physics angles / steering ranges.

Safety correction: once OuttaMyWay has issued post-job egress propulsion, every owned success/failure/exhaustion exit positively neutralises steering demand and GIANTS wheel propulsion/braking before D-0147 releases Control. Player Claim and source-intent reactivation remain higher authority and forbid any subsequent OuttaMyWay actuation.

LIVE TEST: one TS016 Terminal Egress is sufficient. Compare `STEERING_COMMAND_STATE` with `STEERING_NEXT_UPDATE` / `STEERING_HEARTBEAT`. The result should tell us whether steering demand is overwritten before wheel-physics realisation, survives but is ignored by wheel steering, or reaches actual wheel angles without yaw.

---

FS25_OuttaMyWay v4.7.117 TEST BUILD — D-0147 BOUNDED-CURVATURE STEERING REALISATION (E&OE)

Owner-declared v4.7.112 remains canonical. This production test carries forward v4.7.116's successful Positive Field-Exit Settlement correction and unchanged Oblique Boundary Egress Candidate/lifecycle.

TS016 v4.7.116 showed that full local target preservation did not make a genuinely completed assembly steer: Patriot and Condor remained essentially on their pre-egress headings. v4.7.117 therefore changes only the post-job mechanical steering surface. The fixed Candidate world target is transformed into current steering-node local space and converted to one circular target curvature for `AIVehicleUtil.driveAlongCurvature()` on each egress update. Straight-out is the zero-curvature case.

No route search, alternate target, alternate boundary, retry, post-exit alignment or parking logic is added. Player Claim remains immediate. Terminal egress stays at 8 km/h and the development default remains `AUTOMATIC_TERMINAL_EGRESS=true`.

LIVE TEST: repeat TS015/TS016. Look for `D0147-CONTROL CURVATURE_ACTUATION` followed by a visible heading change. Positive Field-Exit Settlement should still stop an assembly promptly after its compact represented footprint has cleared the Field World.

---

FS25_OuttaMyWay v4.7.116 TEST BUILD — D-0147 POST-JOB STEERING CORRECTION (E&OE)

TS016 v4.7.115 confirmed that Candidate produced materially oblique exit targets but the completed vehicles still followed essentially the v4.7.114 trajectories. The production actuator was converting the world target to local space and then normalizing it, although repository GIANTS evidence already establishes that `AIVehicleUtil.driveToPoint()` expects a local-space position. v4.7.116 preserves the full local target position through `worldToLocal()`. It also corrects sealed Field World boundary transfer/traversal so Positive Field-Exit Settlement can consume the live boundary witness.

ARCHITECTURE
No D-0147 architectural change from v4.7.115. Terminal Resolution Commitment remains sticky after positive Terminal Occupancy admission; supported compaction precedes one deterministic Oblique Boundary Egress; success requires positive represented Field World exit; failure exhausts without another angle, boundary, route, retry or parking action.

BASELINE
Owner-declared canonical v4.7.112 (`f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`; git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`; 310 files). v4.7.115 is the immediately preceding non-canonical production TEST evidence lineage.

CONFIGURATION
`AUTOMATIC_TERMINAL_EGRESS=true` remains the development/test default. Terminal egress remains 8 km/h.

VALIDATION
Offline structural/behavioural/release validation is recorded in the accompanying build record. Live TS015/TS016 evidence remains final authority.

DEFERRED
Configuration UI/final product default and the separate baggage/literal audit, including `Prototype22ConfigurationAuthority`.

---

FS25_OuttaMyWay v4.7.115 TEST BUILD — D-0147 OBLIQUE TERMINAL EGRESS (E&OE)

TS016 v4.7.114 reality refinement: a geometrically nearest boundary-normal target can demand an approximately 90-degree steering change that GIANTS AIVehicleUtil.driveToPoint may not realise cleanly. v4.7.115 retains sticky Terminal Resolution Commitment and 8 km/h actuation, but derives one deterministic Oblique Boundary Egress from compact heading plus the nearest local outward reference. The driven path may initially continue forward while gaining an outward component; no fixed 45-degree architectural literal, alternate route, margin search or retry is introduced. Positive Field-Exit Settlement is also hardened so a represented footprint wholly beyond the Field World bounds is sufficient positive exit evidence without requiring a second fold-state qualification after COMPACTION_COMPLETE.

BASELINE
Owner-declared canonical v4.7.112 (`f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`; git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`; 310 files). v4.7.113 is the immediately preceding production TEST evidence lineage.

CHARACTER
TS015/TS016 live evidence refines D-0147 responsibility persistence. Once positive Terminal Occupancy admits the capability, supported compaction cannot settle it merely because the currently revealed obstruction disappears. The same Commitment proceeds to one nearest-outer-boundary egress. `AUTOMATIC_TERMINAL_EGRESS=true` remains the development/test default; egress speed is 8 km/h. Success requires positive current represented compact Field World exit. Reaching the one guidance target without that witness exhausts; no extension, alternate boundary or retry is authorised. Player Claim remains immediate and sticky.

VALIDATION
Offline structural/behavioural/release validation is recorded in the accompanying build record. Live GIANTS TS015 and TS016 reruns remain final authority.

DEFERRED
Configuration UI/final default and the separate baggage/literal audit, including `Prototype22ConfigurationAuthority`.

---

FS25_OuttaMyWay v4.7.113 TEST BUILD — D-0147 BOUNDED TERMINAL EGRESS PRODUCTION ATTEMPT (E&OE)

BASELINE
Owner-declared canonical v4.7.112 (`f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`; git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`; 310 files).

CHARACTER
First production implementation attempt of settled D-0147. `AUTOMATIC_TERMINAL_EGRESS=true` is the development/test default. Terminal Occupancy is Situation-owned; supported compaction is mandatory where meaningful; Control stops for fresh reassessment before any translation; remaining obstruction may receive one nearest-outer-boundary Boundary-Normal Egress manoeuvre. Player Claim uses `vehicle:getIsEntered()` and immediately ends post-job authority. Unsupported/exhausted egress escalates to the player without search/retry.

VALIDATION
109/109 Python structure/conformance tests pass; 227/227 Lua replacement-core behavioural/conformance tests pass; all repository Lua parses successfully. Live GIANTS validation remains final authority.

DEFERRED
Configuration UI/final default and the separate baggage/literal audit, including `Prototype22ConfigurationAuthority`.

---

FS25_OuttaMyWay v4.7.112 CANONICAL — D-0147 BOUNDED TERMINAL EGRESS ARCHITECTURE

CANONICAL STATE
Owner-declared canonical v4.7.112 (`f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`; git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`; 310 files). Architecture/documentation only; no Terminal Egress production implementation.

D-0147
Keep GIANTS completion disposition by default. If a completed unclaimed assembly later positively obstructs continuing active demand and the capability is enabled: compact to the minimum supported transit footprint; if still necessary attempt one simple continuous bounded outward manoeuvre toward the local Field Boundary; immediately surrender on Player Claim; escalate to the player if unsupported or exhausted. No parking/Region search/King revival.

---

FS25_OuttaMyWay v4.7.109 CANONICAL CANDIDATE — D-0146 THREE-WORKER STABILITY PLATEAU

BASELINE
Owner-declared canonical v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files). v4.7.109 remains a candidate until explicit owner canonicalisation.

VALIDATION
The v4.7.108 live run produced five successful D-0146 Cooperative Passages, 25/25 guide gates, zero Passage Reassessment/escalation and no OuttaMyWay Lua error stack. v4.7.109 carries that tested behaviour unchanged; this release changes identity/provenance/version records only.

NEXT
Canonicalise the exact reviewed candidate if accepted. Discuss optional enhancements only after establishing the new canonical plateau.

---

FS25_OuttaMyWay v4.7.107 TEST BUILD — D-0146 RESOLUTION-SPACE OBLIGATION PERSISTENCE

BASELINE
Owner-declared canonical v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files). v4.7.107 is an implementation/test successor through the live-tested v4.7.106 lineage; v4.7.102 remains canonical.

LIVE EVIDENCE LEADING TO THIS BUILD
- v4.7.106 successfully applied bounded Resolution-Space Conservation Regulation before the final Condor/Patriot conflict.
- Regulation was released when Condor temporarily reversed/non-closed during its boundary manoeuvre; Patriot then accelerated back to native working speed and consumed the passage-development reserve.
- The eventual conflict was almost resolved, but Step 2 again lacked sufficient room.

IMPLEMENTATION
- No headland heuristic and no change to Trajectory Persistence.
- The Current Excursion is an admission witness, not the lifetime of the Resolution-Space obligation.
- Situation now publishes positive relationship-invalidation Knowledge. A transient reverse/non-closing phase does not positively dissolve an admitted obligation.
- Once Action-Space Regulation is admitted, it persists through transient/unresolved observations and through Potential conflict until either positive relationship dissolution, Job/Operation disappearance, or same-Commitment Step-2 succession.
- Positive release evidence includes actual post-passage ordering or stable Established Trajectories that are non-opposed after Current Excursion has ended.
- The successful v4.7.105/v4.7.106 S 416 passage mechanics, Optional Configuration Reduction, third-party Passage Support and stale follower-purpose correction are unchanged.
- Current test regulation cap remains 8 km/h, scoped only to this Resolution-Space Conservation purpose.

TEST OBJECTIVE
Repeat the three-worker scenario. Confirm Patriot remains regulated through Condor's temporary boundary reverse instead of accelerating when instantaneous closure disappears, then confirm the same Commitment succeeds into normal Step-2 passage when the opposed conflict establishes. Reconfirm no false open-field regulations and unchanged S 416 passages.
