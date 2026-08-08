# Engineering Handover

> **Canonical baseline:** v4.7.34 (`4b8be7f93fe92e1236c2a50d46622ab3bc688e60fbc4ff3fa56b44b7f36bb5c7`, Git `40b70d2adb6811dd1fdf455ae5bb0f6e76cdf372`; 263 files)  
> **Candidate:** v4.7.40 Guarded Recovery Architecture Consolidation  
> **Control authority:** production Decision/Control disabled; temporary manual P22/TS015 evidence actuator only

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
