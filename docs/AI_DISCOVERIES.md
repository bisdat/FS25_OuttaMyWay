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
