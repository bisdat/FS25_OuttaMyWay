## 2026-08-13 — post-job authority and GIANTS AI settings observations

- **Post-Job Actuation Authority supported:** after canonical Job Episode termination, disposable v4.7.110 directly moved Condor 5 m at a 3 km/h cap and stopped cleanly while the authoritative original episode remained `ENDED` and no replacement AI job appeared.
- **Player Claim direct witness supported:** `vehicle:getIsEntered()` changed to true during the R4 movement proof; direct drive-call count was 204 at claim and 204 at probe termination, establishing zero further OuttaMyWay driving calls after player entry.
- **Probe-plumbing failures retained as process evidence:** earlier revisions incorrectly attempted a second transient GIANTS completion proof, then compared architectural Assembly ID with physical reference key. The corrected probes consumed canonical `JobEpisodeAdmission` status and repository `IdentityRegistry` conventions.
- **Declared Productive Phase Set:** when GIANTS materialises `FieldCourseSettings`, `workHeadlands=false` means the productive plan excludes headland work; `true` includes a headland productive phase. This does not imply the headland/Turning Rank area is spatially unused because manoeuvring demand may remain.
- **Declared Work-Phase Order:** when headland work is enabled, `headlandsFirst` directly exposes headland-first versus up/down-first ordering.
- **Settings availability is opportunistic:** opening/changing the AI settings screen caused the object to become readable and stable, but a normal default-start job produced `settingsAvailable=false`/`SETTINGS_NIL` while field work was definitely active. Do not infer default values from absence and do not require player interaction to make OuttaMyWay safe.

## 2026-08-10 — D-0141 aligned follower-protection findings

- **Complementary follower counterexamples:** v4.7.69 proved the historical manoeuvre-envelope implementation can grant follower authority remotely; v4.7.70 proved that removing follower authority entirely allows a genuine current line-astern boundary encounter to consume the leader's Action Space and block both workers. The concept is supported; the old representation is not.
- **Current Adjacent Following is current topology Knowledge:** historical native manoeuvre geometry cannot manufacture a present follower relationship. The aligned assessment uses positive Productive/Settled continuation, coherent heading, leader/follower ordering and current productive-corridor overlap.
- **Provisional Boundary Demand remains provisional:** observed GIANTS working width may seed coarse spatial demand while a bounded duration literal seeds time. These support a test of demand ordering, not exact turns, routes or Assembly footprint.
- **Immediate native command may supply rate, not route:** D-0138 `aiDriveParams.maxSpeed` can represent the current unrestricted follower rate before OuttaMyWay Regulation. Its target remains no continuation horizon. Zero command is not a zero-speed policy signal.
- **Sticky Purpose / Elastic Magnitude restored:** the follower protection purpose and its numeric cap have independent lifecycles. Temporary uncertainty preserves admitted purpose; current evidence may raise or lower the cap.
- **Clearance calibration remains bounded implementation evidence:** v4.7.73 restores the empirically useful 0.90 factor only after D-0141 already has a restrictive unscaled cap; it supplies no admission authority. The minimum-ever cap ratchet remains excluded.

## 2026-08-10 — D-0140 authority-alignment discoveries

- **Architectural Authority Dispersion:** experimental probes/bridges can accumulate correct local mechanisms while collectively bypassing the intended Knowledge → Decision → Commitment → Control ownership chain. Location in a diagnostic/prototype module grants no semantic authority.
- **Layer Responsibility Leakage:** live validation found Diagnostics causally upstream of Runtime/Control and Productive semantic Knowledge flowing directly from a diagnostic probe into Candidate generation. These are implementation shortcuts, not architectural concepts.
- **Boundary-Manoeuvre Demonstration Overreach:** a GIANTS-native Transitional/reposition manoeuvre can reverse heading near a boundary after tens of seconds/hundreds of metres. Native provenance and heading reversal do not establish Representation Fitness as ordinary boundary-return demand. The aligned native-manoeuvre source therefore publishes boundary-demand fitness `UNRESOLVED`.
- **Authority Reset:** useful raw/post-canonical evidence is retained while follower/committed-transition actuation is removed until Situation-level Representation Fitness and central Decision/Commitment integration exist. This is not a source-code revert.
- D-0130's architectural record remains **persistent purpose, elastic Control magnitude**; the tighten-only experimental implementation is not promoted.

## v4.7.69 implementation discovery — Resolution Dependency Inversion

- v4.7.68 demonstrated that the follower-compression cap itself was not the primary defect. A cap that is acceptable while workers genuinely occupy leader/follower roles became counterproductive after the leader had been relocated and Held at Refuge.
- **Resolution Dependency Inversion:** Control retained from an earlier resolution stage can delay the state transition required by the later stage.
- **Refuge Passage Purpose Succession:** P22's explicit compact-Refuge-hold state is a positive implementation surface for the change of governing purpose. It is used only to retire/suppress the old follower-compression lease for the matching pair, not to command Progress speed.
- Lease ownership is the important isolation mechanism: clearing the follower-compression owner leaves independent Regulation leases intact.

## v4.7.68 implementation discoveries — Immediate Native Drive Command Surface and Settlement Future-Space Representation Mismatch

- v4.7.67 live evidence supports `spec_aiFieldWorker.aiDriveParams` as the **Immediate Native Drive Command Surface**. It varies coherently across Productive work, native turns, reverse and blocked states. This validates the observation surface, not a route model.
- **Zero Command Ambiguity:** `(tX,tZ)=(0,0)` / `maxSpeed=0` can accompany a blocked field-course state as predicted by the SDK, but zero command also occurs without independent blockage evidence. The command alone cannot classify blockage.
- **Immediate Command != Continuation Horizon:** at the second Refuge evaluation the successful and recurring-bad fixture targets were almost equally related to the current command target, with the bad fixture marginally closer. The current drive command therefore does not describe enough future native demand to qualify Refuge Resulting Situation.
- **Settlement Future-Space Representation Mismatch:** the v4.7.67 D-0136 settlement reassessment found the active peer (`track.active`, `compared=1`) yet produced `WORKER_NOT_ACTIVE` because persistent `LiveObservationSource` tracks were passed to `FieldBoundedFutureSpace`, whose input contract is an observation worker carrying `activeObserved`.
- v4.7.68 repairs that implementation seam with an explicit transient adapter. The persistence representation and observation representation remain separate; no architectural Future-Space semantics are changed.

## v4.7.67 implementation discovery — Native Drive Signal Surface Gap

- v4.7.66 live evidence falsified the interpretation of native `vehicle.aiDriveDirection` / `vehicle.aiDriveTarget`: both workers retained `(0,1)` / `(0,0)` through materially different Productive, Transitional, turning and blocked states.
- Exact supplied FS25 1.21.1.0 SDK inspection explains the invariance. `AIDriveStrategyFieldCourse:setAIVehicle()` initializes those fields; they are not the dynamic field-worker drive command observed in native course execution.
- `AIFieldWorker:updateAIFieldWorker()` instead collects native strategy `getDriveData()` output, applies stopping/speed/cruise constraints, writes the immediate command to `spec_aiFieldWorker.aiDriveParams`, transforms its world target through the steering/reverser node, then calls `AIVehicleUtil.driveToPoint()`.
- This is an implementation discovery, not architectural promotion. D-0138 tests `aiDriveParams` passively; a successful live correlation would still require an explicit Representation Fitness argument before supporting Future Space or Decision Knowledge.

## v4.7.39 TS015 live evidence — Native Continuation Restoration and guarded-recovery failure

- **Approximate restoration succeeded for both sprayers:** Condor and Patriot were returned toward the recorded pre-egress continuation context and then handed back under the same GIANTS Job Episode. Bird's-eye evidence showed both apparently reacquiring the interrupted lane despite materially imperfect heading at release. Current evidence therefore does not justify exact position/heading reconstruction.
- **Supplementary agronomic continuity evidence:** with Precision Farming loaded solely for one Patriot experiment, the nitrogen/application view showed no obvious material untreated gap attributable to the OuttaMyWay diversion/rejoin. Local variation or a small miss during GIANTS' final sweep remains possible and is not claimed away. Precision Farming is an observation aid only; standard OuttaMyWay tests remain DLC-free.
- **Restoration and recovery timing are distinct:** in the later Patriot case, restoration itself succeeded, but Condor entered a substantial native diagonal transition while Patriot was returning. Condor's developing demand consumed Patriot's recovery space and both assemblies became blocked. This is evidence against a fixed refuge dwell or physical passage as sufficient recovery authority; it does not contradict Native Continuation Restoration.
- **Guarded Recovery:** the evidence supports allowing recovery while uncertainty remains affordable, provided Traffic Policeman continues observing the other participant and retains sufficient Regulation/Hold capability to protect the committed recovery if native intent becomes adverse.
- **Protected Progress Alternation:** the complex case demonstrates that temporary movement priority can legitimately alternate inside one continuing traffic Commitment. A participant that originally held Progress priority may later need Regulation/Hold while the displaced worker completes an intervention-created recovery obligation.
- **Expedient Manoeuvre Execution:** slow egress/ingress materially increases exposure to changing traffic Reality. Once movement authority is justified, the manoeuvre should proceed at maximum supportable speed; no experimental speed literal has production authority.

## v4.7.38 TS015 live evidence — Native Recovery Variability

- Both corrected autonomous direct-refuge runs preserved the selected worker's GIANTS Job Episode through Hold, approximately 30 m-class refuge displacement, restoration and handback.
- **Condor direct-refuge recovery:** GIANTS resumed native authority but visually skipped the remaining interrupted lane, selected a different pass and recreated a head-on with Patriot. Same-Job native movement therefore did not imply preservation of the interrupted work sequence or durable traffic resolution.
- **Patriot direct-refuge recovery:** under materially similar intervention, bird's-eye evidence showed Patriot apparently returning to its interrupted lane before continuing northward. Current instrumentation has no persistent semantic lane identity, so this lane-reacquisition claim is visual evidence rather than a log-derived identity fact.
- **Native Recovery Variability:** GIANTS recovery from an arbitrary refuge handback cannot currently be assumed to continue, defer, repeat or abandon a particular interrupted strip. The differing outcomes may reflect hidden native state rather than randomness; OuttaMyWay does not yet know the cause.
- The paired evidence motivates a restoration-first comparison: returning the worker toward the positively observed pre-egress continuation state may reduce the disturbance OuttaMyWay introduces into GIANTS' hidden coverage state.

## v4.7.33 live evidence reconciliation — speed ordering, evidence asymmetry and reversible working geometry

- **Productive-Line Cross-Assembly Replication expanded:** John Deere 8RX 410 + cultivator produced line `ACTIVE` / implement lowered on productive passes at a 15 km/h work limit and line `INACTIVE` / raised on native transition segments containing both forward and reverse movement. Valtra S 416 + reversible plough produced the same productive/transition line-state pattern with an approximately 12.2 km/h productive limit.
- **Native Speed-Ordering Variability:** the reversible plough's native transition reached approximately 15 km/h while productive work remained limited to approximately 12.2 km/h. Transitional movement is therefore not inherently slower than productive movement; neither absolute speed nor relative speed ordering has semantic authority.
- **Productive-State Evidence Asymmetry:** brief `turn=false`, line `INACTIVE`, implement-raised samples occurred at the boundary between a completed transition and establishment of the next productive line. Consequently `line=ACTIVE` plus coherent work state is positive Productive evidence, but `line=INACTIVE` alone is only absence of productive-line authority; positive Transitional Continuation requires corroborating Job-Episode continuity/native-transition evidence or remains `UNRESOLVED`.
- **Alternating Working-Side Configuration:** the reversible plough visibly moved from one working side to the other at the end of each pass while the same Job Episode continued. Passive Physical Representation also emitted changing configuration/profile identifiers and different realised footprint bounds during this process.
- **Configuration Footprint Authority:** the observed numeric configuration/profile identifiers are implementation/provenance tokens and may change across versions/assets/runs. They are not semantic authority for left/right or other named states. Situation/Physical Representation reasoning must use the realised component footprint and relevant configuration-transition sweep.
- The side-change transition itself carries spatial demand. A participant classified Transitional remains physically relevant even while productive-line state is inactive, and a safe Hold/Yield point must not be assumed in the middle of a footprint-changing transition.

## v4.7.32 live evidence reconciliation — productive continuation and transitional course behaviour

- **Speed is not productive-state authority.** Condor remained on a productive GIANTS work line (`turn=false`, line `ACTIVE`, implement lowered, work limit 25 km/h) when a manual cruise cap reduced actual speed to approximately 10 km/h. The same cruise cap also constrained turn/transition speed, so absolute speed cannot distinguish productive from transitional motion.
- **Productive-Line Cross-Assembly Replication:** productive Condor passes and productive Valtra S 416 + lime-spreader passes both exposed line `ACTIVE` with the working implement lowered despite materially different native working limits (~25 vs ~18 km/h). Native transitions on both assemblies exposed line `INACTIVE` with the implement raised.
- **GIANTS Turn-Segment Breadth:** `getActiveSegmentData().isTurn=true` is broader than a literal geometric/headland turn. Condor used it for a long diagonal reposition and substantial reverse motion; Valtra transition segments retained it across forward/reverse changes.
- `lastContinueWorkState=true` remained present during transition samples and therefore does not by itself mean “currently productively working”.
- **Apparent Departure Reversal:** a worker may increase separation during Transitional Continuation and then reverse back into recently vacated space to recover missed work. Apparent departure, separation growth or negative closing rate is therefore not release authority.
- The evidence supports a Situation-level distinction between positively supported **Productive Continuation** and **Transitional Continuation** without requiring OuttaMyWay to classify every native reposition/turn subtype. The demonstrated work-line signal is evidence for that distinction, not a universal one-bit API contract.

## v4.7.30 architecture reconciliation — encounter maturation and action-space compression

- TS016 archaeology confirms the earlier working-but-flawed controller let the manoeuvring Condor retain Progress while the straight-working Patriot yielded; the useful physical policy evidence survives even though fixture-specific admission/role logic remains rejected implementation architecture.
- A crossing or turning interaction is not inherently complex. Difficulty rises when Field World boundaries, participant demand and Physical Assembly geometry compress the set of supportable actions; the field-edge/headland placement of TS016 is therefore materially relevant.
- In compressed situations, bounded GIANTS-native progression may simplify Reality by dissolving the interaction or maturing it into a better-supported state. OuttaMyWay need not predict the complete native turn when GIANTS can reveal it while adequate resolution options remain.
- Encounter Maturation is not passive delay. It remains admissible only under the existing Bounded Observation Contract and only while useful Action Space is preserved. A purpose-bound speed constraint may buy maturation margin without choosing a complex alternative route.
- Mid-field slack changes the problem: where abundant Action Space already supports simpler intervention or natural separation, OuttaMyWay must not wait for a head-on merely because that case is familiar.
- Action-Space Compression is the physical explanation for shrinking resolution choice; Preference-Band Exhaustion is the Decision consequence when preferred supportable candidates disappear.

## v4.7.29 architecture reconciliation — staged recovery and traffic protection

- The pure Condor–Patriot head-on is now a reference architecture case: successful refuge resolution must produce a positively available return/ingress corridor, not merely let Progress pass the original conflict point.
- `PROGRESS` is movement-priority preservation, not exclusive permission to move and not entitlement to unrestricted speed. A `YIELD` participant may execute bounded admitted recovery while remaining subordinate to Progress demand.
- Once Decision admits a recovery Action Space, its current ingress/restoration requirement becomes Committed Demand. Traffic Policeman must preserve compatibility with that admitted demand until the stage completes, is superseded or is revoked.
- A purpose-bound supporting speed lease on Progress may preserve the Yield recovery opportunity without transferring Progress/Yield roles. The restriction must disappear as soon as its named purpose ceases to exist; the observed ~15 s Condor unfolding duration is evidence, not an architectural timer.
- BNIR intent acquired in compact/transit configuration is stage evidence. Re-Hold or material configuration restoration can expire its current authority, so fresh operational Local Intent must be reacquired through Native Handover before Safe Release.
- Genuine Commitment progress is evidenced by reduction/retirement of named unresolved obligations. Repeated Control transfers that merely move the same uncertainty between participants remain Revelation Oscillation.

## v4.7.28 architecture reconciliation — traffic priority and empirical local admissibility

- `SETTLED_CONTINUATION` is retained as authoritative native lifecycle/Local Intent evidence, not redefined as pairwise clearance.
- v4.7.26 proves bounded GIANTS-native progression can reveal intent while a Condor remains compact; v4.7.28 records that such a revelation participant remains a physical obstacle and receives no priority from low speed alone.
- Recent actual traversal by the real assembly may serve as bounded positive local spatial-admissibility evidence (**Demonstrated Traversability**) when configuration, local Field World, dynamic occupancy, corridor and relevant kinematics remain materially applicable.
- Static-object recovery/avoidance remains deliberately unresolved and is not inferred from these observations.

# AI discoveries

1. `getNextSegmentData()` does not expose a useful future traversal cursor in TS001.
2. `getActiveSegmentData()` reliably exposes turn state, progress and segment length.
3. GIANTS steering targets are short-horizon control signals, not a complete route plan.
4. The native blocked state arrives too late for predictive traffic management.
5. Speed must be treated as observed runtime intent. Cruise control, terrain, traction, implements and other mods may all alter it.
6. A low actual/requested speed ratio is meaningful only when combined with progress and target trends.
7. A settled working trajectory reveals only local intent; later GIANTS repositioning can cross another worker's resumed lane without being explained by a simple alternating-lane model.
8. An operational AI worker may own a multi-member Physical Assembly containing separate attached runtime assets and roots.
9. GIANTS `WORKING` state does not by itself prove sustained physical progression; declared state and measured motion are separate evidence.
10. GIANTS AI keeps the base vehicle stationary until an implement has unfolded or lowered into its working state; configuration motion can still occupy changing plan-view space.
11. Physics-component count is not a universal inventory of plan-view articulation: Tiger 8 MT uses separate wing components while TopDown 600 moves collision-bearing descendants inside one physics component.
12. Direct `i3dMapping` coverage varies by asset and cannot establish collision inventory or Coverage Closure.
13. Working width, base size and AI course offsets are state-scoped operational evidence, not automatic collision authority.
14. Two implements in the same gameplay class may expose materially different physics-component, hierarchy, mapping and articulation structures; class is not structural authority.
15. GIANTS job completion ends active worker membership but leaves the physical assembly in its final pose as a potentially significant obstacle.
16. GIANTS does not necessarily fold wide implements at job completion; OuttaMyWay currently accepts that final configuration and leaves relocation to the player.
17. Native job admission can reject an agriculturally valid configuration even when manual operation succeeds, as observed with the base-game VB 3190 baler.
18. GIANTS explicitly rejects grapes and olives for native AI work under the tested 1.21.0.0 baseline despite successful manual inter-row cultivation.
19. An otherwise Control-Eligible crop-care configuration can be admitted and then fail because the encountered agronomic state is incompatible.
20. GIANTS routes a right-offset mower by displacing the tractor path so the mower follows the field edge; powered-vehicle trajectory is not working-envelope trajectory.
21. A short-lived admitted job can begin and terminate between periodic observer samples, so absence from observer history is not proof that admission never occurred.
22. Condor Endurance II and Patriot 4450 produced the same stable head-on collision when worker start order was reversed; the tested conflict is not an artefact of one admission precedence.
23. Current `CRITICAL` prediction preceded first blockage by approximately seven seconds in both TS011 runs, supporting a bounded active-intervention opportunity.
24. Conflict prediction can return `CLEAR` after collision because closing ceases while both workers remain blocked; predictor clearance is not encounter resolution or release authority.
25. The native field-worker permission gate can hold Condor at zero speed without ending its Giants AI job.
26. Giants AI does not proactively route around a held field obstacle; stopping Condor inside Patriot's required pass converted the moving conflict into stable blockage.
27. The Condor/Patriot head-on originated when opposite headland turns selected the same next pass from opposite ends, not when the later settled head-on projection appeared.
28. A parked worker's ordinary pass-end location may be consumed by another worker's immediate or later route; initial route clearance is not permanent refuge evidence.
29. Condor starting part-way down a pass later completed the omitted remainder and returned to its start position before a cross-field transition, demonstrating start-state-dependent coverage sequencing.
30. For OuttaMyWay, Giants' complete coverage ordering is not required authority; local observable Future Space and repeated reassessment are the relevant evidence.
31. A held Condor can be folded, directly displaced, rejoined, redeployed and returned to Giants without ending its field-worker job.
32. After a forward rejoin, Giants accepted the new route position, made a small lateral correction and resumed useful work rather than returning to the intervention point: Forward Route Reacquisition.
33. The Condor fixture uses approximately 25 km/h while working and 15 km/h while repositioning; these values belong to its Native Motion Envelope rather than a universal speed rule.
34. Full Condor folding took approximately 15.5 seconds in TS013, but Full Compact Configuration and Egress Readiness are separate claims; stationary waiting for the entire fold remains an unvalidated serialisation assumption.

35. TS014 began useful Condor egress approximately 3.2 seconds after confirmed stop while full folding still required approximately 15.5 seconds; useful movement hid most of the configuration latency.
36. At 15 km/h, Condor reached refuge at approximately the same time it reached Full Compact Configuration, supporting Folding and Retreat Overlap for this fixture.
37. The test command labels were inverted relative to physical Condor motion in both single-worker runs; local-axis names are not world-space direction authority.
38. In TS015-A, Patriot's centre moved beyond Condor's stop anchor while the deployed Patriot assembly remained obstructed; vehicle-centre passage is not complete assembly passage.
39. A 22 m commanded Condor refuge produced approximately 21.44 m actual lateral displacement and was insufficient, even though Condor reached refuge long before Patriot arrived; the failure was clearance depth rather than egress timing.


40. TS015-B and TS017-B repeated the 28 m command as approximately 27.38 m actual lateral displacement and complete physical passage while Patriot remained under unmodified GIANTS control.
41. The TS017-B provider resolved all 13 catalogued current Condor physical identities and origins but obtained usable runtime bounds for none of them through the tested APIs: Origin Coverage Is Not Bound Coverage.
42. For the exact compact Condor refuge pose, 4.87 m one-sided origin projection plus the explicit 2.50 m unresolved physical allowance produced a 7.37 m Facing Clearance Extent.
43. The resulting 25.37 m physical contact threshold distinguishes the failed 21.44 m run (approximately 3.93 m overlap) from the successful 27.38 m run (approximately 2.01 m clearance).
44. The pre-manoeuvre physical threshold estimate was 25.85 m and the live threshold was 25.37 m, a 0.48 m difference; predicted and observed physical reserves differed by approximately 0.14 m.
45. Adding the provisional 3.75 m policy-margin budget produced a 29.12 m policy target and a negative policy reserve despite observed passage: Physical Clearance Is Not Policy Clearance.
46. TS017-B completed the 20-second handoff observation with both workers active, unblocked and working; the new provider did not disturb the validated actuator.

47. TS018 admitted the exact Condor/Patriot encounter automatically after 3.09 seconds of sustained evidence, without any OuttaMyWay console command, while preserving the fixed role, side and actuator.
48. The Prototype 18 Encounter Episode Latch remained `LATCHED` through later known Split-Start Pass Recovery and prevented a second activation; this supports bounded suppression but does not define general recurring Encounter identity.
49. The v4.7.26 single-worker probe kept Condor in one `giants-ai-job-id:0` through Hold, full compact, bounded GIANTS-native movement, re-Hold, OuttaMyWay-owned configuration restoration and independent native continuation.
50. While compact, GIANTS progressed Condor at approximately 1.01–1.06 km/h under an experimental 1 km/h ceiling and native active-segment progress advanced continuously; bounded non-zero movement can therefore expose useful native continuation evidence for this fixture without route reconstruction.
51. Raw `getActiveSegmentData()` slot preservation showed `r2=nil` and the fractional progress value in `r3`; the v4.7.25 compacting tuple collector had shifted values across nil slots and did not discover an authoritative segment-table index.


## Mapping and hierarchy evidence relevant to Prototype 13A

GIANTS vehicle loading uses components and `i3dMappings` as node-resolution inputs, while physically relevant descendants may remain unmapped and inherit changing world poses from mapped ancestors. Mappings are therefore useful anchors, not physical inventories or proof of Coverage Closure. Prototype 13A tests this interpretation at runtime.

## TS004 TopDown AI work-engagement observation

The AI-controlled 8RX 410 + TopDown 600 unfolded, retained an extended-raised pose while moving forward and reversing into its start position, lowered for a working pass, raised for repositioning, then lowered for the next pass. The same run showed GIANTS phase `WORKING` before the TopDown reached its stable low animation endpoint. AI operational phase is therefore not authoritative physical-pose evidence.

The stable `foldAnimTime=0.1250` manoeuvring plateau disproved the assumption that every interior animation value is a transition. Prototype 13A now records neutral animation region and motion rather than semantic fold state.
