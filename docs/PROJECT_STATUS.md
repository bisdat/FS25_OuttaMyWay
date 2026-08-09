# v4.7.49 CERTIFICATION CANDIDATE — Refuge-Gated Guarded Recovery / Live Commitment Catch-up

**Canonical authority:** owner-declared v4.7.41 remains canonical until explicit owner canonicalisation of this exact candidate. v4.7.49 consolidates the non-canonical v4.7.42-v4.7.48 implementation/test lineage with no intended behavioural delta from the live-PASS v4.7.48 runtime.

**Owner live result:** PASS. In the v4.7.48 evidence run, autonomous REPOSITION created `CM-00001`; Condor reached refuge; positive proposed-recovery convergence produced `WAIT_AT_REFUGE` while Patriot remained GIANTS-owned; after Patriot passed, positive clearance produced `RECOVERY_ADMISSION_PASS`; a later convergence during already-authorised recovery invoked D-0123 Regulation; same-Job GIANTS reacquisition settled only the recovery obligation and left the Commitment `WAITING_FOR_EVIDENCE` with Durable Separation outstanding.

**Implementation status:** D-0122/D-0123 continuity is now exercised across Decision → Commitment → refuge waiting → event-driven recovery admission → Guarded Recovery → conditional Regulation → native reacquisition. This does not claim production-complete Refuge qualification, speed policy, Durable Separation, reverse support, Encounter Maturation, or later sliding-puzzle handling.

**Literal authority:** 15/5/1 km/h values remain temporary implementation/test-mechanism values. The successful live test validates sequencing/integration only. Timeouts are watchdog/forensic bounds and no fixed dwell authorises recovery.

**Certification status:** RRS candidate preparation authorised after owner live PASS. `CONTROL_AUTHORITY_ENABLED=false` remains the general Control boundary.

# Historical — v4.7.48 TEST BUILD — Commitment / Event-Driven Recovery Admission

**Build-time authority state:** owner-declared v4.7.41 remained canonical. v4.7.42-v4.7.48 were non-canonical implementation/probe lineage; v4.7.48 still required owner live behavioural validation at this point in the history.

**Current implementation objective:** catch the code up to already-settled D-0099/D-0119/D-0122/D-0123 continuity without solving the known-too-early initial Commitment Point or general sliding-puzzle encounter. The autonomous initial REPOSITION now creates a real Commitment with separate recovery and Durable-Separation obligations.

**Recovery admission:** the 20-second refuge dwell is retired. At compact Refuge occupancy, proposed recovery is assessed event-by-event. Positive convergence means Yield waits safely at refuge while Progress passes under GIANTS; negative convergence authorises Guarded Recovery; unresolved evidence waits. Regulation is reserved for convergence that develops only after recovery has begun.

**Literal authority:** 15/5/1 km/h values remain temporary live-test mechanism values, not architecture. Mechanical timeouts are watchdogs only; forensic observation windows are diagnostics only. No fixed time or speed authorises recovery, release or Durable Separation.

**Known open boundaries:** production Refuge Region qualification/transition clearance; production speed choice; reverse projection; Durable Separation evidence; Encounter Maturation timing; later complex cross-field/sliding-puzzle resolution. `CONTROL_AUTHORITY_ENABLED=false`.

# v4.7.46 TEST BUILD — D-0123 Guarded-Recovery Regulation Behaviour Test

**Canonical authority:** owner-declared v4.7.41 remains canonical. v4.7.42-v4.7.46 are non-canonical implementation/probe lineage. v4.7.46 starts from canonical v4.7.41 and deliberately reapplies the live-tested experimental deltas before adding this one behavioural bridge.

**Evidence refinement:** repeated v4.7.45 shadow runs support a simpler D-0123 interpretation. `turn=true` is not the trigger. The trigger is presently revealed native continuation directed into remaining Guarded-Recovery demand. `VS_COMMITTED_RECOVERY_UNION` is therefore the selected test Vulnerable-Space representation; `CP_CURRENT_HEADING` is the selected test Convergent Projection, conditioned on positive same-Job continuing-native-intent evidence. Observed travel remains diagnostic corroboration because it disappears when speed is reduced or blockage occurs even though native intent may persist. The current-heading test is behavioural only when raw GIANTS `lastMovingDirection` positively reports forward; reverse/unresolved direction remains `UNRESOLVED`.

**Behavioural objective:** while the existing P22 TS015 recovery fixture is active, a positive selected D-0123 intersection exhausts Observe for this test and applies the proven P22 Regulation mechanism to the fixture Progress worker at 1 km/h. This is Protected Progress Alternation under test-fixture authority: GIANTS retains route/steering/direction; the speed literal has no production meaning.

**Fail-closed release:** after Regulation is established, `UNRESOLVED` evidence maintains the cap. Release requires positively supported current-heading clearance, positive GIANTS reacquisition ending the heightened vulnerability window, or explicit Job/context invalidation. Initial intervention timing, P22 refuge geometry/clearance, production Commitment creation, production Regulation-speed choice and later sliding-puzzle resolution remain unchanged.

**Validation gate:** no RRS/certification package before owner live behaviour. Primary comparison is the phase-shifted Patriot-first setup that previously progressed from positive D-0123 shadow evidence into mutual blockage/current-space conflict.

# v4.7.45 TEST/PROBE — Guarded-Recovery Convergence Shadow Validation

**Canonical authority:** owner-declared v4.7.41 remains canonical. v4.7.42-v4.7.45 remain non-canonical implementation/probe lineage. v4.7.45 evolves the live-validated v4.7.44 test behaviour only to add zero-authority diagnostics; no RRS/certification package is appropriate before live validation.

**v4.7.44 live result:** Autonomous Initial Encounter Resolution passed its intended behavioural milestone without `resolveheadon`. The real Candidate/Decision path selected Condor as Yield and dispatched the proven P22 TS015 relocation/rejoin/restoration sequence. The intervention occurred materially earlier than necessary; this remains a known defect but is temporarily retained because it creates a long, repeatable Guarded-Recovery observation window.

**New evidence target:** while Condor was recovering/resuming, Patriot reached its headland turn and encroached on the vicinity of Condor's recovery path. This is the simpler D-0123 vulnerability case now under study. Architecture already says Convergent Projection intersection with Vulnerable Space exhausts Observe and makes Regulation the next preferred band; the missing piece is the representation/evidence construction, not the Decision ordering.

**v4.7.45 objective:** passively compare several candidate representations rather than choose one prematurely. `GuardedRecoveryConvergenceProbe` observes only the existing P22 recovery lifecycle. It opens when rejoin/restore begins, survives mechanical handback, and closes on the already-proven `NATIVE_CONTINUATION_FIRST` positive reacquisition evidence. It logs three Vulnerable-Space hypotheses crossed against three coarse Convergent-Projection hypotheses with no fixed horizon/TCPA/DCPA/range gate and no actuation.

**Behaviour freeze:** autonomous head-on role selection, P22 refuge/rejoin literals, early Commitment timing, release behaviour and later complex-cross-field behaviour are intentionally unchanged from v4.7.44. `CONTROL_AUTHORITY_ENABLED=false`. Any shadow positive is evidence for discussion only and must not be interpreted as a Regulation command or settled production geometry.

# v4.7.44 TEST BUILD — Autonomous Initial Head-On Role Selection

**Canonical baseline:** owner-declared v4.7.41 (`a15b5f3534545d4cbefd1cfc291f254d0921472dc35c09f900935e9f59cddb15`; Git `1eb64d6fcf328fb566b4aa27d83fe5fdb7ab2911`; 269 files). v4.7.44 is a live implementation test build only. It is not a certification candidate.

**Observed v4.7.43 result:** owner live tests successfully exercised the initial TS015 head-on with both explicit role assignments. `resolveheadon Patriot` and `resolveheadon Condor` each caused the genuine live Decision path to select `REPOSITION`, followed by successful Hold/compact/refuge/rejoin/restoration/handoff through the existing P22 TS015 harness. The reciprocal result removes an accidental vehicle-specific execution concern.

**Repository correction:** D-0113 already defines Productive/Productive as a preference tie, while D-0118 explicitly permits materially equivalent admissible alternatives to remain architecturally indifferent and be resolved by a deterministic implementation tie-break with no policy meaning. No new arbitration concept is required.

**v4.7.44 objective:** retire the initial-head-on role console command. Positive `NON_TURN_LINE_ACTIVE` evidence from the already-validated Productive Continuation probe is promoted as positive Productive Continuation evidence only. When one active Encounter has positive field-bounded Future-Space interaction, both Local Intents are `SETTLED_CONTINUATION`, both participants are positively Productive, headings are opposed, and positive current physical interaction has not begun, the live Candidate boundary publishes both admissible Yield-role `REPOSITION` candidates. D-0115 supplies same-picture Observe/Regulate/in-path-Hold exhaustion; D-0118 resolves material equivalence deterministically without semantic priority.

**Actuation boundary:** the selected autonomous Decision still dispatches the already-live-tested P22 TS015 relocation harness. Production Refuge Region qualification, complete transition-clearance authority, Commitment/Guarded-Recovery production orchestration, Safe Release, Vulnerable Space construction and Convergent Projection construction are not claimed by this test build. `CONTROL_AUTHORITY_ENABLED=false` remains unchanged.

**Live validation gate:** start the normal TS015 workers and issue no head-on console command. The expected result is automatic publication of two role candidates, one deterministic `REPOSITION` selection, and automatic dispatch of the selected Yield worker before physical contact. The same Encounter is single-dispatch latched; a later independent Encounter remains eligible. The P22 refuge dwell HUD now states that the fixture dwell has no release authority rather than displaying a misleading countdown.

# v4.7.41 Canonical — Guarded Recovery Observe-Exhaustion Contract

v4.7.41 was constructed from owner-declared canonical v4.7.40 (`32980f980f80ff8a9f30aa8b11a1097196e6fddf1264f26b810835bc547648cd`; 269 files). Runtime behaviour is unchanged apart from coherent version identity: the temporary P22/TS015 evidence harness remains explicit-command only, production Decision remains passive and `CONTROL_AUTHORITY_ENABLED=false`.

**Accepted architecture:** D-0123 closes the Guarded-Recovery Situation Assessment contract left open by D-0122. While OuttaMyWay still owns recovery responsibility, the recovering participant has temporary Vulnerable Space. The other Encounter participant's presently revealed native continuation is represented coarsely as Convergent Projection. Intersection positively establishes that unrestricted continuation is consuming protected recovery Action Space and therefore exhausts Observe. Decision still prefers Regulation while supportable non-zero native progression can preserve recovery, then Hold only when that band is exhausted and current occupancy is a valid waiting state.

**Vulnerability boundary:** heightened recovery sensitivity expires when positive existing Native Handover/restoration evidence establishes that GIANTS has fully reacquired native authority over the recovering worker. This does not settle the Encounter/Commitment. Ordinary cooperative tolerances resume, including normal adjacent-lane passage, and Protected Progress Alternation may subsequently reverse temporary roles as Reality evolves.

**Implementation boundary:** Vulnerable Space and Convergent Projection are semantic evidence representations, not literal dome/circle/cone geometry. Their conservative construction from existing Reality evidence remains open. No fixed range/horizon, TCPA/DCPA, route reconstruction, speed threshold or production traffic-control trigger is implemented in v4.7.41.

**Next objective:** discover and passively validate a representation/evidence method for Vulnerable Space and Convergent Projection before connecting the agreed Observe-exhaustion contract to production Decision/Control.

# v4.7.40candidate — Guarded Recovery Architecture Consolidation

v4.7.40candidate begins from owner-declared canonical v4.7.34 and carries forward the temporary P22/TS015 runtime harness unchanged from v4.7.39. Its purpose is to record the architectural knowledge discovered from the v4.7.38 direct-refuge and v4.7.39 restoration-first evidence before starting the next implementation discussion. Production Decision remains passive and `CONTROL_AUTHORITY_ENABLED=false`.

**Current evidence:** direct release from refuge produced Native Recovery Variability. Approximate restoration toward the pre-egress continuation context then allowed both Condor and Patriot to visually reacquire the interrupted lane despite materially imperfect heading. A supplementary Patriot Precision Farming nitrogen/application view showed no obvious material untreated gap attributable to the intervention, but Precision Farming was loaded only for that experiment; the standard test environment remains DLC-free. A later Patriot recovery deadlocked when Condor's native diagonal transition entered the recovery space while Patriot was returning, separating a successful restoration mechanism from an inadequate recovery-protection decision.

**Accepted architecture:** Native Continuation Restoration is accepted in principle; the Rejoin Anchor is a recovery reference, not an exact-pose obligation. Guarded Recovery permits recovery under affordable uncertainty while retaining Traffic Policeman protection. Once authorised, recovery Action Space is Committed Demand. The other participant is observed and may be Regulated or Held if revealed demand threatens the committed recovery. Protected Progress Alternation permits temporary priority to switch within one continuing Commitment without implying one-worker-at-a-time control. Expedient Manoeuvre Execution requires an authorised bounded manoeuvre to proceed at maximum supportable speed; no fixture literal becomes production speed policy. Mechanical handback is not traffic resolution; observation continues until Durable Separation is supported.

**Next architectural objective:** define the Situation Assessment evidence contract that makes uncertainty unaffordable during Guarded Recovery — specifically, what evidence of another participant's developing Current/Future/Potential Demand exhausts Observe and justifies Regulation/Hold while a recovery remains committed. Do not implement production Control until this contract is agreed.

# v4.7.39candidate — TS015 Native Continuation Restoration Comparison

v4.7.39candidate began from owner-declared canonical v4.7.34 and carried forward the temporary P22/TS015 evidence harness. v4.7.38 had produced two valid same-Job direct-refuge handbacks with materially different GIANTS recovery behaviour: Condor skipped the interrupted lane remainder and selected another pass that recreated a head-on, while Patriot visually appeared to reacquire the interrupted lane. The evidence was classified **Native Recovery Variability**; direct refuge handback could not be assumed to preserve GIANTS' productive continuation context.

v4.7.39 therefore retained the settled pre-egress position/heading as a probe Rejoin Anchor and replaced direct refuge handback with compact ingress toward that continuation context before configuration restoration and same-Job GIANTS release. Its runtime behaviour remains the evidence harness carried forward unchanged in v4.7.40.

# v4.7.37candidate — TS015 Autonomous Native-Recovery Characterisation Harness

v4.7.37candidate began from owner-declared canonical v4.7.34. It added explicit `otmP22 relocate <Condor|Patriot>` orchestration for fixture-only Hold → compact → refuge → restore → timed release → native-recovery observation, carrying forward the validated P22 capability mechanisms and the continuation-aware Refuge/Return/Durable-Separation architecture recorded in D-0118/D-0119.

The first live v4.7.37 run is not native-recovery evidence because the harness retained Hold after its watchdog defect.

# v4.7.36candidate — Prototype 22 Spatial Reposition / Configuration Evidence Correction

v4.7.36candidate begins from owner-declared canonical v4.7.34 and carries the temporary P22 gate forward with the correction demanded by live Reality. v4.7.35 proved Regulation and stable-state Hold/release for Condor and Patriot and proved one-leg forward target actuation for both, but the booms remained deployed; P22-C therefore did not yet prove spatial Reposition.

The corrected P22-C sequence is `Hold → compact/configure → fold-motion evidence → forward Manoeuvre Leg while folding continues → target Hold → full compact + positive represented span reduction → restoration while Held → same-Job GIANTS handback`. This explicitly preserves useful folding/movement overlap while refusing to use fold-progress numbers as spatial clearance authority.

A transition-only P22 HUD and final summary records make live testing operator-readable. Production Decision remains passive, no live Commitment is applied and `CONTROL_AUTHORITY_ENABLED=false`. Reverse Reposition remains architecturally valid but active OuttaMyWay-directed reverse remains `UNRESOLVED`.

Live validation protocol: `docs/prototypes/PROTOTYPE_22_TRAFFIC_POLICEMAN_CAPABILITY_GATE.md`.

---

# v4.7.35candidate — Prototype 22 Traffic Policeman Capability Gate

v4.7.35candidate begins from owner-declared canonical v4.7.34 (`4b8be7f93fe92e1236c2a50d46622ab3bc688e60fbc4ff3fa56b44b7f36bb5c7`, Git `40b70d2adb6811dd1fdf455ae5bb0f6e76cdf372`; 263 files). Canonical Traffic Policeman architecture is unchanged.

Prototype 22 is the minimum live GIANTS capability gate agreed after D-0115. It is manual-only and validates:

1. bounded GIANTS-owned Regulation apply/release on either selected worker;
2. same-Job Hold/release at an operator-confirmed stable state; and
3. participant-complete one-leg forward Reposition ending in Hold.

Production Decision remains passive, no live Commitment is applied and `CONTROL_AUTHORITY_ENABLED=false`. The P22 actuator is not reachable from Situation Assessment/Decision and requires explicit `otmP22` console arming in a fixture with at least two active GIANTS AI field workers. Only one P22 subject may be controlled at once.

P22 Regulation preserves GIANTS route/steering/forward-reverse ownership and changes only the drive-call speed ceiling. Hold uses the empirically proven same-job native permission gate. Reposition retains that Hold while a scoped final-drive interceptor owns exactly one operator-requested `moveForwards=true` Manoeuvre Leg, then removes its drive authority and leaves the worker Held at the new occupancy until manual release. No refuge selection, target-clearance authority, folding policy, role selection or Safe Release inference is present.

Reverse remains architecturally valid but OuttaMyWay-directed reverse is intentionally `UNRESOLVED`; negative forward offsets are refused. GIANTS-native reverse during Regulation remains permitted because route/direction ownership stays with GIANTS.

Live validation protocol: `docs/prototypes/PROTOTYPE_22_TRAFFIC_POLICEMAN_CAPABILITY_GATE.md`.

---

# v4.7.34 Canonical — Traffic Policeman Decision Ordering Consolidation

v4.7.34 begins from owner-declared canonical v4.7.33 and changes documentation/version metadata only. It composes the already-accepted Traffic Policeman, Productive Continuation Preference, Encounter Maturation, Action-Space Compression, Preference-Band Exhaustion, Hold/Reposition and Representation Fitness architecture into an explicit sequential Decision contract.

Traffic Policeman is now recorded as omnipresent but normally dormant: ordinary compatible GIANTS traffic leaves it invisible; decisive temporary movement ordering activates it; independent compatibility makes it dormant again even if restoration, Native Handover or terminal-settlement obligations continue.

The primary traffic preference is strict in Decision: `CONTINUE_OBSERVATION → REGULATE_SPEED → HOLD_AT_SAFE_POINT → NATIVE_REPOSITION`. Later bands require explicit earlier-band exhaustion in the same Decision epoch but rejected candidates need not be physically tried. Observe ends when Reality is clear enough to direct or uncertainty is becoming unaffordable under shrinking Action Space. Regulation means bounded GIANTS-owned progression; Hold means the current occupancy itself is the waiting place; Reposition creates a waiting place and is direction-agnostic, including reverse where evidence supports it.

Reposition exhaustion is participant-complete. Failure of the initially preferred Yield worker does not justify escalation until supportable spatial candidates under the alternate admissible role assignment are also exhausted. Reverse remains architecturally valid while OuttaMyWay-directed reverse actuation remains an implementation/evidence question.

Candidate Purpose is explicitly provenance-bound to current admitted intent/Operational Picture and, where present, the governing Commitment Objective/Obligations; Candidate generators represent rather than invent that authority.

Production Decision remains passive, no live Commitment is applied and Control authority remains disabled.

# Historical Project Status snapshot — v4.7.41 release construction

> **Then-current canonical:** v4.7.40 Guarded Recovery Architecture Consolidation  
> **Then-canonical baseline:** v4.7.40 (`32980f980f80ff8a9f30aa8b11a1097196e6fddf1264f26b810835bc547648cd`; 269 files)  
> **Then-current candidate:** v4.7.41 Guarded Recovery Observe-Exhaustion Contract  
> **Control authority:** production Control disabled

## Established Reality

Owner-declared canonical v4.7.40 retains the live-validated passive replacement-core foundation and the consolidated Traffic Policeman Decision Ordering: native Local Intent → field-bounded Future Space → positive Encounter admission, current physical interaction as positive Encounter evidence, incomplete-membership evidence precedence, authoritative Job Episode termination/restart identity, passive Decision, no live Commitment and disabled production Control. It additionally records Native Continuation Restoration, Rejoin Anchor, Guarded Recovery, Protected Progress Alternation and Expedient Manoeuvre Execution from the v4.7.38–v4.7.40 evidence cycle. The superseded fixed-horizon TCPA/DCPA future predictor remains absent from active runtime and diagnostics.

The non-canonical v4.7.25 prerequisite probe remains evidence only. It confirmed that represented primitive completeness does not prove Coverage Closure and its attempted `getActiveSegmentData()`/`fieldCourse.segments` index association was invalid; raw tuple slots must preserve nil positions.

## v4.7.26 live evidence — PASS

The Single-Worker Transit Intent probe isolated one capability composition with Condor Endurance II on field 77 under FS25 1.21.1.0:

```text
same Job Episode
→ HOLD
→ compact/transit configuration
→ bounded GIANTS-native movement
→ native intent/progress observation
→ HOLD
→ restore OuttaMyWay-owned configuration mutations
→ verify restoration
→ full GIANTS handover
→ independent native continuation
```

The Job Episode remained `giants-ai-job-id:0`. Full compact configuration was confirmed before movement. GIANTS progressed at approximately 1.01–1.06 km/h under the experimental 1 km/h ceiling while native course progress advanced. The probe re-Held after an experimental 2 m proving movement (approximately 2.04 m actual), restored deployment/work state with zero verification mismatches, then observed independent same-Job native continuation. Candidate SHA-256: `43e0fc93fcd7810d8460d11e683ad05adef50ada545c8190a3394f015b260ec0`.

## v4.7.33 TS004 evidence expansion

The v4.7.31 passive probe was run concurrently on John Deere 8RX 410 + cultivator and, on a separate Field World, Valtra S 416 + reversible plough. 8RX productive passes exposed line `ACTIVE` / lowered at a 15 km/h work limit; transition segments were line `INACTIVE` / raised and changed between forward/reverse. The reversible plough productive passes exposed line `ACTIVE` / lowered at ~12.2 km/h while transition reached ~15 km/h, establishing Native Speed-Ordering Variability.

Both assemblies also produced short non-turn line-inactive boundary states before productive-line establishment. v4.7.33 therefore records Productive-State Evidence Asymmetry rather than treating inactive line as a binary Transitional classifier.

The reversible plough visibly alternated working side after each pass. Passive Physical Representation observed multiple changing configuration/profile tokens and changing footprint bounds within the same Job Episode. The token numbers are explicitly non-authoritative. **Configuration Footprint Authority** requires spatial reasoning to follow the realised footprint and applicable transition sweep instead.

No production Control/Decision path changes in v4.7.33.

## v4.7.32 live evidence and architecture consolidation

Prototype 21 live validation now supports the Productive/Transitional distinction independently of absolute speed. Condor remained line `ACTIVE` / lowered during productive work even when manual cruise capped actual speed at ~10 km/h against its 25 km/h work limit. Condor diagonal and reverse repositions were line `INACTIVE` / raised and `turn=true`. Valtra S 416 + lime-spreader work in field 68 reproduced line `ACTIVE` / lowered productive passes at an ~18 km/h work limit and line `INACTIVE` / raised transitions across multiple forward/reverse repositions.

The resulting **Productive Continuation Preference** applies only as an initial Traffic-Policeman preference in otherwise-roomy non-headland encounters. It is overridden when yielding the transitional participant would strand it, consume supported Action Space or conflict with current Commitment obligations. Productive/Productive, Transitional/Transitional and unresolved cases are ties for this preference.

**GIANTS Turn-Segment Breadth** records that `turn=true` includes more than literal turns. **Apparent Departure Reversal** records that a transitional worker may appear to leave and later reverse into recently vacated space; transitional/Yield status therefore never means reduced Future-Space relevance or Safe Release.

v4.7.32 adds no production Traffic Policeman implementation. Prototype 21 remains passive, Decision remains passive, no live Commitment is applied and Control remains disabled.

## v4.7.30 architecture consolidation

**Encounter Maturation** is accepted as a bounded Traffic-Policeman Decision pattern for ambiguous interactions. Native GIANTS progression may be preserved while Reality is expected to dissolve the interaction or reveal a simpler authoritative state, but only under the Bounded Observation Contract and only while supported resolution options remain available.

**Action-Space Compression** names the physical loss of supportable resolution options caused by Field World constraints, participant demand, assembly geometry and evolving manoeuvres. It explains why TS016's headland/field-edge crossing behaves like a sliding puzzle while similar mid-field geometry may retain more alternatives. The concept is derived and non-numeric.

Action-Space Compression complements **Preference-Band Exhaustion**: compression is physical evolution; exhaustion is Decision losing preferred supportable candidates. Early Encounter admission therefore does not require early aggressive Control. Observation or purpose-bound speed regulation may preserve maturation margin, but waiting becomes inadmissible once it consumes the options needed for resolution. A head-on is not a mandatory maturation target.

v4.7.30 is documentation-only apart from release/version metadata. Production Decision remains passive, no live Commitment is applied, production Control remains disabled, and no Encounter-Maturation actuator is introduced.

## v4.7.28 architecture consolidation

**Traffic Policeman** is accepted as the Decision-level responsibility for temporary movement priority inside an Encounter. It assigns/revises `PROGRESS` and `YIELD` roles without routing or steering; GIANTS retains native path/steering ownership. A settled Progress participant is a stable traffic reference only when its supported corridor is positively compatible with the Yield participant's occupancy/Action Space.

BNIR is refined accordingly: the revelation participant remains a real obstacle, low speed grants no priority, and BNIR authority expires when it would consume Progress demand or when the traffic reference becomes unresolved. BNIR completion is evidence-driven, not fixed to the v4.7.26 1 km/h / 2 m fixture.

**Demonstrated Traversability** is accepted as bounded positive local spatial-admissibility evidence from actual successful traversal by the real Physical Assembly. It remains applicable only within a materially unchanged demonstrated domain and does not create universal Coverage Closure.

**Revelation Oscillation** names non-progressive role swapping that alternates which participant is held/unknown without reducing unresolved Encounter obligations. Legitimate role transfer must measurably reduce/settle obligations or materially improve admissible resolution capability.

Continuation Safety Horizon is refined as **Encounter-relative** rather than indefinitely rolling. It covers unresolved continuation consequences materially belonging to the governing Encounter/interventions; later materially new convergence after true Safe Release may form a fresh Encounter.

Static-object recovery/avoidance is deliberately parked for future dedicated analysis. No current architecture assumes GIANTS can avoid a stationary obstacle or guarantees OuttaMyWay automation.

v4.7.28 is documentation-only apart from release/version metadata. Production Decision remains passive, no live Commitment is applied, production Control remains disabled, and no BNIR/Traffic Policeman actuator is introduced.

## v4.7.27 architecture consolidation

**Bounded Native Intent Revelation** is now accepted architecture. It permits a retained Commitment, when admissible, to grant GIANTS tightly bounded native motion sufficient to reveal actual post-intervention Local Intent rather than reconstructing the GIANTS route. A proven transit configuration may be used to reduce physical occupancy before evidence-gathering motion; OuttaMyWay remains responsible for its own configuration mutations and for reassessment.

This does **not** mean Hold release is Safe Release. The sequence remains:

```text
bounded native intent revelation
→ renewed Operational Picture
→ joint Future-Space / obligation reassessment
→ further capability, continued observation or Safe Release only when positively justified
```

The v4.7.26 speed and distance are proving literals only. Capability support must be established per Physical Assembly; Coverage Closure and manoeuvre-sweep representation remain unresolved.

## Parked boundary

Static-object recovery/avoidance remains deliberately parked for separate future architectural analysis. BNIR/Traffic Policeman must not be used as evidence that GIANTS can route around a stationary obstacle or that OuttaMyWay can always automate a bypass.

## Implementation boundary

v4.7.34 carries no live Traffic Policeman, Encounter-Maturation detector, BNIR actuator, purpose-bound speed lease or other physical Control path into the active replacement core. Runtime script bytes remain unchanged from canonical v4.7.33 apart from version metadata outside `scripts/`. Traffic Policeman Decision ordering is now consolidated. The next activity is implementation preparation: define the minimum live GIANTS capability evidence for bounded two-worker Regulation, proven Hold/release states and participant-complete forward Reposition while retaining reverse Reposition as architecturally valid but `UNRESOLVED` until Reverse Actuation Discovery provides authority.
