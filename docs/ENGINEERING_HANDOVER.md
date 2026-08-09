# v4.7.49 CERTIFICATION CANDIDATE handover

Owner-declared canonical remains **v4.7.41** until explicit canonicalisation. v4.7.49 consolidates the successfully live-tested v4.7.48 behaviour without intended substantive runtime change.

**Validated sequence:** `REPOSITION` → real Commitment → Condor refuge → proposed recovery incompatible / `WAIT_AT_REFUGE` → Patriot passes under unrestricted GIANTS → positive recovery clearance → Guarded Recovery → later D-0123 convergence → bounded Regulation → Native Continuation Restoration → same-Job GIANTS reacquisition → recovery obligation settled → Commitment `WAITING_FOR_EVIDENCE` with Durable Separation outstanding.

**Live evidence:** v4.7.48 TEST BUILD SHA-256 `ae9b84ed4e6066cf12fb08557e328b6c4a3db2b7202a09c88c755c7305e571a7`; log `log(20260809-102132).txt` SHA-256 `b211fd6edc930e071f0feb3d21520cf5accdf6b5496b2aaf63da08f68fef60bc`; video `2026-08-09 11-17-41.mp4` SHA-256 `988d4168c294409aed47b7e1cc1ff3c356e533d681b3d7b8359c42f7d8164eb9`.

**Do not promote by implication:** 15 km/h egress/rejoin, 5 km/h orientation and 1 km/h Regulation remain temporary implementation/test values; P22 10/30 m refuge geometry remains fixture-only; Durable Separation, reverse support, production Refuge qualification, Encounter Maturation timing and later sliding-puzzle handling remain open.

**Certification rule:** any substantive runtime edit discovered during candidate preparation invalidates this live PASS and requires a new test-build cycle. Only coherent release identity/status metadata and evidence/governance documentation may differ from v4.7.48.

# Historical v4.7.48 TEST BUILD handover

Owner-declared canonical remains **v4.7.41**. v4.7.48 is a non-canonical implementation test build. The v4.7.46 live result is treated as D-0123 success plus recovery-admission sequencing non-conformance: Patriot Regulation protected Condor's active recovery, but because recovery had been started while Patriot's revealed continuation already occupied the proposed ingress, Condor correctly resumed into the same lane.

The implementation now follows existing D-0122: at the Refuge Region fixture, known positive convergence prevents recovery admission. Condor stays compact/Held while Patriot remains fully GIANTS-owned. Only positive clearance begins Guarded Recovery. If convergence later develops after recovery is committed, the existing D-0123 Regulation bridge remains available. There is no fixed refuge dwell.

The autonomous initial REPOSITION Decision now creates a real replacement-core Commitment. Positive native reacquisition settles Native Continuation Restoration only; Durable Separation remains an open continuity obligation and the Commitment moves to `WAITING_FOR_EVIDENCE`. Do not interpret GIANTS handback as traffic settlement.

All fixed numeric speeds retained by this test lineage are explicitly temporary mechanism values until the next successful live test. Timeout literals are failure/watchdog bounds only. Production speed selection, Refuge qualification, Durable Separation authority, early Encounter Maturation and the later sliding-puzzle encounter remain outside this build.

**Next evidence:** reproduce the Patriot-first/Condor-second phase-shift run. Desired sequence is `Condor refuge → Patriot passes → recovery admission becomes clear → Condor recovery → positive GIANTS reacquisition`, with D-0123 Regulation only if a new convergence develops after ingress starts.

---

# v4.7.46 TEST BUILD handover

Owner-declared canonical remains **v4.7.41**. v4.7.46 is a behavioural test descendant, not a certification candidate. It deliberately retains the v4.7.44/v4.7.45 early initial Reposition and P22 refuge/rejoin fixture because those conditions expose Guarded-Recovery convergence repeatably.

The v4.7.45 shadow evidence refined D-0123: turning is contextual evidence, not the trigger. The operative question is whether the other participant's presently revealed native continuation is directed into the recovering participant's remaining protected recovery demand. For this test only, `VS_COMMITTED_RECOVERY_UNION × CP_CURRENT_HEADING` is connected to the already-proven P22 Regulation actuator. Positive same-Job continuing-native-intent evidence is required, and the current-heading behavioural bridge additionally requires raw GIANTS movement-direction evidence `FORWARD`; reverse/unresolved direction is deliberately not represented by this test. The cap is the existing 1 km/h fixture literal and carries no production speed-policy authority.

A new `GuardedRecoveryRegulationTestBridge` owns only its tagged Regulation state. It maintains that state through temporary `UNRESOLVED` evidence and releases on positive clear projection, positive GIANTS reacquisition ending the vulnerability window, or explicit Job/context invalidation. The diagnostic shadow module remains actuation-free.

Preferred live test: Patriot-first phase-shifted TS015, no console commands. Compare against the v4.7.45 run that deadlocked. Look for `[D0123-REGULATION-TEST] APPLY`, subsequent `SAMPLE` records showing GIANTS input max speed and 1 km/h capped output, absence/presence of Condor blockage, and `RELEASE` reason. Do not interpret success as production Commitment/Refuge/Safe-Release completion.

# v4.7.45 TEST/PROBE handover

Owner-declared canonical remains **v4.7.41**. The current non-canonical live lineage is v4.7.45, built from the owner-live-validated v4.7.44 behaviour with only a passive D-0123 diagnostic addition. Do not request RRS/canonicalisation before live evidence is reviewed.

The v4.7.44 autonomous first-Encounter milestone passed, but it commits Reposition too early. Keep that behaviour for the present probe cycle because it reliably causes Patriot to reach its headland turn while Condor is still in the P22 recovery/resume interval. This exposes the simpler Guarded-Recovery vulnerability case before the later sliding-puzzle cross-field family.

`GuardedRecoveryConvergenceProbe` logs under `[D0123-SHADOW]`. It opens at P22 rejoin/restore, compares 3x3 parallel shadow hypotheses, survives mechanical handback, and closes only on existing positive `NATIVE_CONTINUATION_FIRST` GIANTS-reacquisition evidence. It cannot actuate and its results must not be called production Vulnerable Space/Convergent Projection until repeated video/log evidence supports one construction.

Next discussion should compare first-positive/negative transitions against the visible Patriot headland turn and Condor recovery path. Prefer disproving weak representations over tuning them. Only after the representation is settled should implementation promote continuing Commitment/Committed Demand and Regulation.

# Engineering Handover

## v4.7.44 implementation-test continuation point

> **Canonical baseline:** v4.7.41 (`a15b5f3534545d4cbefd1cfc291f254d0921472dc35c09f900935e9f59cddb15`; Git `1eb64d6fcf328fb566b4aa27d83fe5fdb7ab2911`; 269 files)  
> **Current build:** v4.7.44 TEST BUILD — Autonomous Initial Head-On Role Selection  
> **Certification:** not requested; owner live validation first  
> **General production Control:** disabled; selected initial-head-on Decision may dispatch the bounded P22 TS015 test actuator

The owner live-validated v4.7.43 in both reciprocal roles: Patriot Yield succeeded, then Condor Yield succeeded. Repository review then confirmed that D-0113/D-0118 already settle the Productive/Productive role-selection semantics: Productive Continuation Preference is tied; refined admissible Candidate Actions are compared downstream; materially equivalent alternatives may use a deterministic non-semantic implementation tie-break.

v4.7.44 therefore requires no `resolveheadon` command. The live Productive Continuation probe supplies positive Productive authority only for the already-validated `NON_TURN_LINE_ACTIVE` condition on the same Job Episode. A bounded initial-head-on gate then requires positive Future-Space interaction, an active Encounter, both `SETTLED_CONTINUATION`, both Productive, opposed headings and no positive current physical interaction. Both Yield assignments are published where admissible, with equal semantic comparison cost, and the genuine D-0115/D-0118 Decision path selects one.

The selected candidate automatically invokes the existing P22 TS015 relocation harness. **Do not misread this as production Refuge authority.** Field-containment sampling, refuge location, transition clearance, fixture dwell and restoration orchestration remain test-harness mechanisms. The HUD dwell countdown has been replaced by an explicit no-release-authority message, but the internal dwell literal is unchanged.

The next live test is intentionally simple: start TS015 normally and do nothing else. Pass means the initial head-on resolves before contact without a console role command. After that, allow the continuation to expose the next complex cross-field/recovery Encounter. Promote settled architecture until the first genuinely unresolved Guarded-Recovery representation boundary is reached; do not fabricate Vulnerable Space or Convergent Projection results.

## v4.7.41 canonical architecture continuation point

D-0123 closes the Situation Assessment evidence contract left open by D-0122. During Guarded Recovery, the recovering participant has temporary Vulnerable Space while OuttaMyWay still owns recovery responsibility. The other Encounter participant's presently revealed native continuation is represented coarsely as Convergent Projection. Intersection is positive evidence that unrestricted continuation is consuming protected recovery Action Space; `CONTINUE_OBSERVATION` is exhausted and Decision proceeds to the existing Regulation-before-Hold preference.

The representation is deliberately non-predictive in the old fixed-horizon sense. Do not reconstruct GIANTS' exact route, add TCPA/DCPA, invent a range gate or implement the explanatory dome/headlight cone literally. Guarded Recovery is already local to the active Encounter/Refuge Region context.

The heightened vulnerability expires when positive existing Native Handover/restoration evidence establishes that GIANTS has fully reacquired native authority over the recovering worker. This does not complete the traffic Commitment. Ordinary cooperative tolerances return and Protected Progress Alternation may later reverse temporary roles if the formerly recovering worker's GIANTS-native continuation begins consuming the other participant's Action Space.

**Next substantive step:** discover and passively validate how existing Reality evidence can represent Vulnerable Space and Convergent Projection. Do not connect that evidence to production Decision/Control until the representation is validated.


**Historical v4.7.41 release-construction record:** derived from then-canonical v4.7.40 (`32980f980f80ff8a9f30aa8b11a1097196e6fddf1264f26b810835bc547648cd`; 269 files); production Decision/Control was disabled and the temporary manual P22/TS015 evidence actuator remained the only actuation surface.

## v4.7.40 continuation point

The v4.7.38/v4.7.39 evidence cycle has separated three concerns that must remain distinct. Direct refuge handback is mechanically possible but produces Native Recovery Variability. Approximate Native Continuation Restoration then allowed both Condor and Patriot to visually reacquire their interrupted lane under the same Job Episode despite materially imperfect heading. A supplementary Precision Farming Patriot run showed no obvious material untreated gap attributable to the diversion/rejoin, but standard testing remains DLC-free and no PF dependency exists.

The remaining failure is traffic protection during recovery. In the complex Patriot run, Condor entered a native diagonal transition while Patriot was returning from refuge; Condor's developing demand consumed Patriot's recovery space and both deadlocked. This does not disprove restoration. It establishes that a recovery authorised by OuttaMyWay must itself be protected as Committed Demand while uncertainty about the other participant remains.

D-0122 therefore accepts Native Continuation Restoration in principle, Guarded Recovery, Protected Progress Alternation and Expedient Manoeuvre Execution. Initial Progress priority is temporary. Concurrent movement remains preferred when compatible, but the policeman may Observe, then Regulate or Hold the other participant as its revealed intent begins to threaten committed recovery. Successful GIANTS handback does not discharge the Commitment until Durable Separation is positively supported.

**Next architectural objective:** define the Situation Assessment evidence contract for that Observe-exhaustion boundary. Specifically: what positive/current evidence shows another participant's Current/Future/Potential Demand is beginning to threaten the committed recovery strongly enough that Regulation is justified, and when is Regulation exhausted in favour of Hold? Do not modify production Control until this contract is agreed.

## v4.7.36 current continuation point

Canonical v4.7.34 still governs Traffic Policeman Decision ordering. The first v4.7.35 P22 live cycle positively supported Regulation and stable-state Hold/release for both Condor and Patriot and proved the bounded forward target actuator for both workers, but neither 36 m boom folded. P22-C therefore remains incomplete as a **spatial** Reposition gate.

v4.7.36 corrects the probe rather than architecture. P22-C now owns a temporary test-only configuration sequence: Hold → work-off/raise/fold request → observe fold motion → begin one forward Manoeuvre Leg while folding continues → Hold at target → require full compact plus positive represented plan-view span reduction → restore original configuration while Held → same-Job GIANTS handback. A fold animation value is diagnostic only and cannot establish spatial clearance.

The approximately 15-second Condor/Patriot fold interval is not treated as dead time: movement may overlap folding after actual configuration motion begins. This is capability composition evidence only; production Action-Space/transition-sweep admissibility remains unimplemented.

A transition-only P22 HUD and one-shot summary records replace raw console following as the operator interface. Detailed samples remain forensic logs. Production `CONTROL_AUTHORITY_ENABLED=false`; no Situation Assessment/Decision/Commitment path can arm P22, and reverse remains architecturally valid but active OuttaMyWay reverse authority remains `UNRESOLVED`.

**Next substantive step:** live-run revised P22-C on Condor and Patriot in roomy space. P22-A and P22-B need only regression confirmation if convenient; do not advance to production Traffic Policeman until both sprayers establish the corrected spatial Reposition capability or the failure is explicitly classified.

## Standing architectural-governance rule

Architecture is treated as largely defined, errors and omissions excepted. If a live observation appears to imply a new architectural discovery, search the canonical repository and relevant archived evidence first. Classify the result as existing architecture confirmed, implementation non-conformance, architectural refinement or genuinely new discovery before introducing new terminology. Archived code may contribute proven mechanisms and failure evidence but is not architectural authority.

## Closed gates

- Field World and Operation identity: canonical v4.7.14.
- Exact TS015 non-admission diagnosis: canonical v4.7.15.
- Configuration-filtered approximately 36 m physical representation: canonical v4.7.17.
- Positive footprint evidence handoff and Encounter creation: canonical v4.7.18.
- Field-bounded Local Intent/Future Space implementation conformance: canonical v4.7.21.
- Future-Space-driven Encounter admission plus authoritative termination/restart identity: canonical v4.7.23.

## v4.7.20 corrections

The first v4.7.19 live attempt did not reach the required action order because the manual stop occurred before Encounter creation. This exposed **Diagnostic Signal Saturation**. The same run also exposed invalid shape-bound calls on transform groups.

v4.7.20 adds:

```text
WAITING FOR ENCOUNTER
→ ENCOUNTER ACTIVE: stop either AI worker
→ ENCOUNTER TERMINATED: restart stopped worker
→ NEW JOB EPISODE: re-establish approach
→ NEW ENCOUNTER CREATED: test complete
```

The HUD is temporary diagnostic instrumentation. A matching `[OTM TEST GATE]` line is emitted once per transition. Routine pair console output is state-change/heartbeat throttled, while trace records remain complete. `AssemblyRepresentationCache` now requires positive `ClassIds.SHAPE` evidence before invoking a shape-bound API.

## Live objective

Follow the HUD. Confirm the first Encounter is created and retained, terminates with `JOB_EPISODE_ENDED`, the restart admits a fresh Job Episode, and renewed convergence creates a different Encounter identity. Decision must remain passive, no Commitment may be applied and `control=false` throughout.

## Deferred boundary

Do not interpret absence of positive evidence as same-Episode safe separation. That remains the next distinct architecture and evidence problem.
