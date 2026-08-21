## v0.1.2.0 CANONICAL CANDIDATE handover — Resolution-Space Conservation

Baseline: owner-declared canonical v0.1.1.0 (`10ad10c0eb5956fbd32f3e82408201513dec6073e72b758db4b6bf394e8316b3`; Git `5cd2ae0c768a1a771b817b5ed5879ca02745f9de`; 316 files). Candidate scope is documentation/architecture plus version identity; no traffic behavioural implementation.

**Do not mistake documentation for runtime:** the fixed 8 km/h D-0146 Resolution-Space Regulation remains live in this candidate. The next selected implementation is to replace that generic authority with the architecture below, not to tune 8 km/h.

### Accepted architecture

- **Supportable Progression:** greatest present conflict-consuming progression that preserves the required next resolution opportunity while the current Resolution-Space obligation remains unresolved.
- **Resolution-Space Progression Envelope:** coarse zero-terminal-progression policy curve over the ordinary authorised portion of established Resolution Space. It is not a GIANTS vehicle-dynamics model.
- **Resolution Contingency Reserve:** deliberately withheld percentage of established usable Resolution Space that ordinary progression has no authority to consume. Exact percentage remains explicit calibration.
- **Reverse-Created Resolution Reserve:** positive space created by the protected/uncertain participant reversing; hold it as bonus reserve rather than immediately relaxing the constrained participant's envelope.
- **Intent-Revelation Opportunity:** one purpose of Resolution-Space Conservation is to buy enough opportunity for Reality to reveal whether native continuation, Cooperative Passage or another supported resolution actually applies.
- **Resolution-Space Recovery:** separate `REPOSITION` family for buying space back after conservation has already failed; Back-Out Recovery toward recently demonstrated clear space is a candidate physical expression. No implementation in this tranche.

### Candidate maths

`D0` = established usable Resolution Space before contingency policy.

`C = reserveFraction * D0`

`S0 = D0 - C`

`u` = constrained participant's current progression when the envelope is established.

`a_p = -u^2 / (2*S0)`

For remaining ordinary authorised space `r`:

`v_raw = sqrt(2*abs(a_p)*r)`

Control cap = conservative whole-integer km/h floor of `v_raw`; 0 => Hold. This trajectory consumes the authorised allowance toward zero progression before the Contingency Reserve is reached. `a_p` is a policy parameter derived from current state, not a prediction that GIANTS will physically decelerate at that rate.

### Persistence / release

The Resolution-Space purpose remains sticky through mower reverse/forward corner shuffling. Temporary negative closure may create bonus reserve and alter current geometry but does not itself establish Safe Release. Positive Situation evidence may release, supersede into ordinary Passage/native continuation, or authorise rebase. Do not recreate the historical minimum-ever speed ratchet.

### Prior-scenario implications

- TS015 Condor long reverse is a positive benchmark: Patriot should remain appropriately regulated and the gained space should not be immediately spent before Passage establishes.
- TS010 small-field mower/MT665 should naturally tighten much sooner because usable Resolution Space is small, not because the field is 0.99 ha.
- A 500 m encounter naturally offers abundant intent-revelation opportunity; normal Situation maturation should usually supersede the envelope long before the contingency boundary matters.

### Mandatory process before implementation

Run an Authority-Layer Impact Review. The envelope must not change Operational Membership, Situation Relevance, Passage eligibility or player/GIANTS ownership merely because it changes Control magnitude. Bench the newly affected populations and prior successful TS015/TS016 paths before live testing.

---

## v0.1.1.0 CANONICAL CANDIDATE handover — small-field D-0146 plateau

Authoritative baseline remains owner-declared canonical v0.1.0.0 until explicit acceptance. v0.1.1.0 carries the exact v0.1.0.14 runtime behaviour and changes only release identity/provenance/canonical-review records.

**Do not continue fixing inside this candidate.** The recent D-0146 tranche has isolated the next problem to literal authority: the fixed empirical 8 km/h Resolution-Space cap can be physically reached too late because braking consumes the Resolution Space that the Policeman is trying to conserve. Hold mechanics themselves now operate generically; the next discussion should recover response-adjusted supportable progression from architecture/history before implementation.

**Regression plateau retained:** TS015 full completion after the passage-support correction; TS016 initial passage smoke regression; TS010 successful Pair-Specific / Configuration-First / Pre-Productive Intent Relevance passages. Remaining final TS010 collision is explicitly known and does not block capturing the generic corrections as a candidate plateau.

**Parked:** Guide Development Non-Convergence after genuine productive commencement; D-0147 `<=60 m` Courtesy Exhaustion; 80 m locality; guide/burden literals; Boundary Encroachment; remaining Literal Audit items.

If the owner accepts this candidate, record the exact ZIP SHA-256, local Git commit/provenance, file count and clean repository state, then treat that declaration as the next authoritative baseline.

---

## v0.1.0.14 TEST handover — Generic Regulation Sufficiency Hold

Authoritative baseline remains owner-declared canonical v0.1.0.0. v0.1.0.14 is cumulative over v0.1.0.13.

TS010 v0.1.0.13 demonstrated a settled-vs-settled opposed conflict where Role Migration and Safe Release conformance worked but the 8 km/h regulated mower still marched into collision. Hold did not escalate solely because the v0.1.0.9 gate required the protected participant to remain Transitional.

v0.1.0.14 removes that accidental coupling. After Regulation is positively realised, continuing material positive closure may escalate the regulated participant to Hold under the same Resolution-Space Commitment for either Transitional or Settled protected continuation. Positive resolved non-closing still de-escalates Hold to the prior Regulation cap.

Do not infer that 8 km/h is validated policy; it remains under the literal audit. Do not mix D-0147 `<=60 m` Courtesy Exhaustion or guide/burden calibration changes into this runtime test.

Runtime target: reproduce a settled-vs-settled TS010 approach. Expected sequence is Regulation → cap realised → continued positive closure → `D0146_ACTION_SPACE_HOLD_ESCALATION ... reason=REGULATION_REALISED_BUT_POSITIVE_CLOSURE_CONTINUES`, before physical blockage.

## v0.1.0.13 TEST handover

- Canonical baseline remains v0.1.0.0.
- v0.1.0.13 corrects only D-0146 Safe Release conformance.
- Expected runtime diagnostic on the prior false-release sequence: `resolutionSpaceRelationship.status=POSITIVE_DISSOLUTION_VETOED` with reason `D0146_POSITIVE_FUTURE_SPACE_VETOES_POSITIVE_RELATIONSHIP_DISSOLUTION` or `D0146_BLOCKED_PARTICIPANT_VETOES_POSITIVE_RELATIONSHIP_DISSOLUTION`; the current Resolution-Space Commitment must remain live.
- Regulate↔Hold, role migration, pre-productive relevance and passage behaviour are unchanged.
- Separate parked issues remain: 8 km/h literal review, Guide Development Non-Convergence, and D-0147 <=60 m Courtesy Exhaustion coupling.

## v0.1.0.12 TEST handover

Canonical remains v0.1.0.0. Runtime target: TS010 with MT665 started after the mower. Before MT665 first productive work, expect `participation=.../ACTIVE_JOB_INTENT_REVELATION_PENDING`, `passageEligible=false`, and Resolution-Space Regulation/Hold applied only to the productive mower when supported. After productive commencement, the same pair identity may become passage-eligible. TS015/16 remain regression targets.

# v0.1.0.11 TEST handover — Productive Commencement + Resolution-Space Role Migration

Authoritative baseline remains owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files). v0.1.0.11 is cumulative over v0.1.0.10.

**Why this build exists:** TS010 v0.1.0.10 isolated two code mismatches. Pre-productive MT665 job-entry motion was being admitted into Cooperative Passage before any productive field-work commencement. Separately, an existing Resolution-Space Commitment failed to move its physical Regulation lease when Situation later reassigned the regulated/protected roles.

**Implementation:** Live Observation latches positive productive commencement per source Job token; Operation membership uses that latch rather than current productivity, so later turns remain members. D-0146 Candidate marks role assignment mutable. Live Control migrates an active Resolution-Space lease under the same Commitment by applying the newly selected role before releasing the old one. Reversible Hold from v0.1.0.10 is retained.

**Prior-scenario bench:** retained v0.1.0.7 TS015 contained 3 successful passages and TS016 1 successful initial passage; all passage participants had positive productive evidence before admission, and neither log used Action-Space Regulation/Hold. These recorded paths therefore predict no behavioural change.

**Runtime targets:** TS010 starts where MT665 has not yet commenced work should leave it outside cooperative Operation participation until productive commencement. A Run-6-like later conflict should log `D0146_ACTION_SPACE_ROLE_MIGRATION` when Situation changes roles, with the same Commitment ID and authority moving to the new regulated participant. Then regression TS015/16 as normal.

Do not mix the parked D-0147 `<=60 m` correction, 8 km/h review, or guide-shape literal work into this tranche.

# v0.1.0.10 TEST handover — Reversible Resolution-Space Hold

Authoritative baseline remains owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files). v0.1.0.10 is cumulative over v0.1.0.9.

TS010 v0.1.0.9 validated reverse-aware role assignment and Regulate→Hold escalation, then exposed One-Way Hold Persistence: Hold remained at zero after positive non-closing evidence and eventually became an obstruction. v0.1.0.10 retains the same Commitment but de-escalates Hold to the prior Regulation cap only from positive resolved Situation non-closing evidence. Re-escalation is permitted if closure returns.

**Bench regression before implementation:** retained v0.1.0.7 TS015 log contained 3 successful passages and TS016 contained 1 successful initial passage; neither log contained `D0146_ACTION_SPACE_APPLY` or Hold events. Cooperative Passage Holds and D-0147 Protected Yield are not modified.

**Runtime target:** TS010 through reverse/conflict-rich encounters. Expected diagnostic cycle is `D0146_ACTION_SPACE_APPLY` → optional `D0146_ACTION_SPACE_HOLD_ESCALATION` → `D0146_ACTION_SPACE_HOLD_DEESCALATION` when Situation proves non-closing, with the same Commitment active. If closure renews, re-escalation is legitimate.

Do not mix the parked Guide Development Non-Convergence or D-0147 centre-exhaustion correction into validation of this tranche.

---

# v0.1.0.9 TEST handover — Regulation Sufficiency / Hold Escalation

Authoritative baseline remains owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files). v0.1.0.9 is a cumulative TEST branch over v0.1.0.8.

TS010 v0.1.0.8 demonstrated that correctly assigned and realised 8 km/h Resolution-Space Regulation can still fail to conserve enough action space. v0.1.0.9 retains that cap as empirical first intervention, then tightens the same D-0146 lease to 0 km/h Hold only when: no supported same-conflict Passage has superseded it; the protected participant remains Transitional; Situation reports positive closure; and raw Control evidence shows the regulated participant has actually reached the cap.

**Runtime target:** reproduce TS010 conflict-rich starts. Expected sequence is `D0146_ACTION_SPACE_APPLY ... cap=8.00` followed, if closure persists after cap compliance, by `D0146_ACTION_SPACE_HOLD_ESCALATION ... priorCap=8.00 ...`. If Passage becomes supported first, it should supersede the lease without Hold.

Do not tune 8 km/h in this tranche. Record whether Hold conserves enough space for native revelation and later Passage/dissolution. Separately record any recurrence of Guide Development Non-Convergence or D-0147 `<=60 m` Courtesy Exhaustion.

---

# v0.1.0.8 TEST handover — Reverse-Aware Resolution-Space Role Assignment

Authoritative baseline remains owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files). v0.1.0.8 is a cumulative TEST branch over v0.1.0.7.

**Why this build exists:** TS015 fully completed on v0.1.0.7; TS016 reached a successful initial S416 passage; TS010 completed passage and then GIANTS created a new reverse conflict. That conflict is intentionally treated as new Situation Assessment, not continuation of Cooperative Passage.

**Correction:** Established-conflict role assignment now derives positive native closure contribution from `nativeDriveCommand.maxSpeedKmh`, chassis heading, `moveForwards` forward/reverse sign, and the current pair axis. Reverse commands therefore participate normally in Resolution-Space role assignment. The 8 km/h Regulation actuator already preserves GIANTS forward/reverse choice.

**Primary runtime test:** reproduce TS010 through the unusual MT665 reverse. At the new Established conflict, logs should show `D0146_ACTION_SPACE_REGULATION_SUPPORTED ... closureContribution=... moveForwards=false` when a reversing participant is selected, followed by `D0146_ACTION_SPACE_APPLY` for the participant with the greater positive closure contribution when continuation classes are equivalent.

**Discriminator:** if correct reverse-aware Regulation prevents contact, the forward-only surrogate was the failure. If physical interaction still occurs, do not retune this projection immediately; examine whether Regulation was insufficient and whether existing Regulate→Hold escalation needs implementation.

**Regression:** TS015/TS016 need only smoke regression after TS010 unless the role correction affects them unexpectedly. D-0147 `<=60 m` Courtesy Exhaustion remains parked.

# v0.1.0.7 TEST handover — Passage Support / failure configuration

Authoritative baseline remains owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files). v0.1.0.7 is a cumulative TEST branch over v0.1.0.6.

Runtime target: rerun TS015. Expected difference: folded sprayers must continue the Candidate-proven guide despite GIANTS native `isBlocked=true` unless an actual passage-support check fails; any genuine D-0146 failure must remain held without automatic unfolding.

# v0.1.0.6 TEST handover — Configuration-First Cooperative Passage

Authoritative baseline remains owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files). v0.1.0.6 is a cumulative TEST branch over the successful v0.1.0.5 small-field corrections.

**Evidence:** v0.1.0.5 resolved the deadlock but retained the mower deployed. The selected guide demanded a large sidestep and GIANTS emitted fresh positive blocked evidence during traversal while OuttaMyWay continued motion. Success therefore disproved the assumption that current-configuration passage was an acceptable least-intervention expression.

**Implementation:** configuration profiles are now provenance-labelled by the Job Episode cache. Candidate may use a stable folded profile only after native observation outside OuttaMyWay authority and only when its conflict-side projection releases space. Candidate recomputes pair clearance and residual burden under that profile. Control owns the fold/restore mechanics but must realise the exact expected profile before guide motion. Native blocked evidence during a guide is Support Loss and fails held.

**Expected TS010:** mower should compact; FW212 should remain current because its player-only crane lacks AI-reachable productive configuration evidence; lateral burden should be reduced relative to v0.1.0.5. If the mower has no natively observed compact profile in that Job Episode, Candidate must retain current rather than infer one.

---

# v0.1.0.5 TEST handover — Resolution-Space Conservation / Progressive Passage

Authoritative baseline remains owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files). v0.1.0.5 is a cumulative TEST candidate retaining the v0.1.0.4 Pair-Specific Passage Clearance correction.

Two v0.1.0.4 TS010 runs supplied the evidence. One passed. In the deadlock, the pair reached Established Opposed Corridor Conflict while MT665 still reported GIANTS `TURN_SEGMENT`; no Current Excursion remained, so the Potential-only Action-Space admission produced neither Regulation nor Hold. The pair then closed through the inherited 50 m Step-2 minimum.

v0.1.0.5 corrects both code mismatches. Established conflict may now create the same pair-scoped Resolution-Space Regulation obligation when no supported Passage Candidate exists. Where one participant remains Transitional, preserve it and regulate the positively Settled participant; otherwise regulate the greater native closure contribution. The fixed 50 m Step-2 minimum is deleted with no replacement literal. Concrete guide support now decides Passage Development Feasibility below 50 m.

**TS010 test:** reproduce the former v0.1.0.4 deadlock start pattern. Look for `D0146_ACTION_SPACE_REGULATION_SUPPORTED` with `classification=ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT admission=ESTABLISHED_CONFLICT`, then `D0146_ACTION_SPACE_APPLY`. If geometry subsequently becomes supportable, `D0146_PASSAGE_SUPPORTED` may occur below 50 m and should supersede the Regulation under the same Commitment. Repeat the previously successful start order as regression/control.

Do not alter the 80 m upper locality bound, guide-shape literals, burden fractions, 1 m nominal clearance, or D-0147 during this validation unless new Runtime evidence directly identifies them.

---

# v0.1.0.4 TEST handover — Pair-Specific Passage Clearance

Authoritative baseline is owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files). v0.1.0.4 is rebuilt directly from that baseline; v0.1.0.1-.3 remain evidence only.

The 12 m centreline target and derived 6 m participant reserve are removed from live D-0146 generic passage authority. Candidate now computes **side-specific** required separation from opposing Facing Clearance Extents plus the agreed provisional 1.0 m Nominal Inter-Assembly Clearance. Current configuration is retained for both participants to eliminate False Compaction Demand without yet granting passage authority to generic fold states.

**TS010 test:** reproduce both former deadlock start patterns, then the successful third-run start-order control. Record video plus log. Key markers are `D0146_PASSAGE_SUPPORTED` and `[D0146-CONTROL] START`, especially `contact`, `nominal`, `required`, `currentLateral`, `reserve`, offsets and `minimumRepresentedClearance`. If the pair now reaches the fixed 50 m floor before a supported guide is found, that is evidence about the parked Development-Space Surrogate. If Candidate accepts but Control reports `PASSAGE_SUPPORT_LOSS_FIELD_TARGET`, retain it as the separate Candidate/Control spatial-proof mismatch.

Do not tune 50/80 m, guide-shape literals, burden fractions or D-0147 during this validation.

---

# v0.1.0.0 handover — pre-1.0 version identity transition

**Baseline:** owner-declared canonical v4.7.128 (`3933bd60ef7dc5e603647835a2959de34cd8e79f44a7436ba7bf122021b262f1`; Git `d90057eb3adafa7204517eaa0ded0c696a13fd1b`; 315 files).

**Scope:** version/provenance/documentation/test assertions only. Runtime behaviour is intentionally unchanged.

**Policy:** `0.MINOR.PATCH.BUILD`; canonical BUILD=0, TEST uses BUILD, PATCH for accepted compatible corrections, MINOR for significant capability/architecture milestones, `1.0.0.0` for first public release.

**Review boundary:** verify exact package/hash and absence of behavioural delta, then owner canonicalises or rejects.

---

# v4.7.128 CANONICAL CANDIDATE handover — audited three-assembly plateau

Owner-declared v4.7.121 remains authoritative until explicit canonicalisation. v4.7.128 is a release/provenance-only candidate over live-validated v4.7.127 behaviour.

**Evidence carried:** v4.7.126 first fully completed Patriot + Condor + S416; v4.7.127 completed fully again after audit alignment. The candidate intentionally changes no D-0147 control behaviour.

**Review boundary:** verify the exact package/hash, candidate provenance, repository checks and version identity. If accepted, the owner canonicalises/synchronises locally. The pre-1.0 versioning reset is a subsequent separate increment.

---

# v4.7.127 TEST handover — audit closure / Courtesy Constraint Exception

Owner-declared v4.7.121 remains canonical. Start from validated v4.7.126 behaviour: Patriot and Condor both performed decisive protected 60 m native-max Bounded Infield Retreats and S416 completed the three-vehicle test.

v4.7.127 intentionally changes **no D-0147 control behaviour**. It closes the architecture/code audit:

1. D-0147 is an explicit player-consented special case. Generic predictive `FIELD_WORLD_CONTAINMENT` and complete-envelope `TRANSITION_CLEARANCE` are not applicable to its crude Bounded Infield Retreat; Candidate carries `D0147_COURTESY_CONSTRAINT_EXCEPTION` instead of fake clearance PASS evidence.
2. Consent, positive obstruction, authority ownership, Protected Yield, boundedness, Continuation Renewal, Courtesy Exhaustion, Player Claim/source supersession and Actuation Neutralisation remain mandatory.
3. Proven native `#` use on sealed ValueRecord collections found by the audit is replaced with `ValueRecord.length()`. The standing order remains: presume architecture collections sealed until plain-table provenance is explicit.
4. Current-state documentation now reflects Bounded Infield Retreat rather than the stale v4.7.121 external-egress implementation gap.

**Next:** validate 4.7.127, then canonical-candidate preparation. Do not perform the planned pre-1.0 versioning transition until this audit/canonicalisation sequence is complete.

---

# v4.7.126 TEST handover — D-0147 60 m Native-Max Retreat

Owner-declared v4.7.121 remains canonical. v4.7.126 changes only D-0147 courtesy calibration over v4.7.125.

One admitted INFIELD retreat still captures the Field World centroid bearing once and never re-aims. The movement allowance is now **60 m of realised inward progress** and `TerminalEgressControl` samples the completed vehicle motor's native maximum forward speed at admission instead of applying the old 8 km/h D-0147 cap. Protected Yield holds the authorising productive worker throughout translation. Continuation Renewal, later attributed native-block repeat admission, Courtesy Exhaustion, Player Claim and neutralisation are unchanged.

**TS016 evidence target:** observe whether the larger/faster retreat moves Patriot decisively far enough infield to buy materially more continuation after S416 is released, without changing the already validated natural forward arc.

# v4.7.125 TEST handover — D-0147 Continuation Renewal

Owner-declared v4.7.121 remains canonical. v4.7.125 changes only the repeat lifecycle over the live-supported v4.7.124 Protected Bounded Infield Retreat.

After `MANOEUVRE_COMPLETE`, Dispatcher records the productive assembly ids that were protected during the retreat and releases their 0 km/h leases. `TerminalOccupancyAssessment` then waits for positive physical motion from those active, unblocked assemblies. This establishes **Continuation Renewal**. No new movement is admitted at that point. If a later snapshot shows a native `blocked=true` state and Terminal Occupancy still positively attributes the obstruction to the same completed assembly, the renewal latch clears and one fresh D-0147 Commitment may be created.

TS016 target: first retreat → S416 resumes → later S416 blocks on Patriot → second retreat. If that sequence occurs, repeated crude courtesy yielding is supported without changing the 8 km/h / 30 m calibration.

# v4.7.124 TEST handover — D-0147 Protected Yield ValueRecord fix

Owner-declared v4.7.121 remains canonical. v4.7.124 changes only the v4.7.123 Protected Yield collection traversal: sealed `protectedDemandAssemblies` now uses `ValueRecord.length()` and `ValueRecord.ipairs()`.

Standing order: any collection originating from Candidate/Evidence/Commitment/Observation ValueRecords must be presumed sealed until proven plain. Never use native Lua `pairs`, `ipairs`, or `#` on such a collection. Local implementation-owned plain tables may continue to use native traversal.

TS016 validation target is unchanged: S416 must receive the 0 km/h protected hold before Patriot's INFIELD translation, remain held through the retreat, and be released after terminal neutralisation.

# v4.7.123 TEST handover — D-0147 Protected Yield Interval

Owner-declared v4.7.121 remains canonical. v4.7.123 retains v4.7.122's fixed one-shot centre bearing, forward-only 8 km/h actuation, 30 m inward-progress quantum, Conflict Renewal and Courtesy Exhaustion.

The sole behavioural hypothesis added is **Protected Yield Interval**: the active assembly/assemblies whose positive conflict admitted the terminal retreat are authority-owned by the same D-0147 Commitment and receive a composable 0 km/h Regulation lease immediately before `INFIELD` translation. Release occurs after terminal actuation neutralisation on every terminal-control exit. The GIANTS productive job is never restarted, rerouted or terminated.

For TS016, verify first that S416 actually settles/holds before Patriot begins its arc, remains held throughout Patriot's 30 m retreat, and resumes after the hold is released. Then verify the previously validated Patriot arc is unchanged.

# v4.7.122 TEST handover — D-0147 Bounded Infield Retreat

Owner-declared v4.7.121 is canonical. v4.7.122 implements the first deliberately crude infield-courtesy hypothesis: one fixed centroid bearing sampled after compaction, forward-only `driveInDirection`, 30 m realised inward progress, immediate Commitment settlement, Conflict Renewal before any later retreat, and Courtesy Exhaustion near the centre. Positive Field-Exit Settlement and external-boundary Candidate geometry are not part of the live v4.7.122 test path.

**Next evidence target:** TS016 with Patriot/Condor/S416. Validate the realised large forward arc, boundary-side sweep, 30 m calibration, neutralisation, and renewal gating before adding any planning or exclusion concepts.

---

# v4.7.121 CANONICAL CANDIDATE handover — D-0147 Terminal Yield / Pending Player Reclamation

**Canonical authority:** v4.7.112 remains owner-declared canonical until explicit promotion.
**Immediate implementation evidence:** v4.7.120 external egress is live-supported mechanically and retained unchanged in behaviour.

## Continue from this architectural question

Do not ask where a completed worker can be parked permanently. The governing problem is: **given a completed passive assembly Pending Player Reclamation and a positive current conflict, what is the least bounded Terminal Yield that restores useful active continuation without creating a worse externality?**

Current architecture permits External Yield when legitimate and Conflict-Relative Infield Yield when external movement would export the problem. Do not implement a random move toward field centre. Other physical assemblies are constraints; deterministic identity may break a true symmetry only after support is established. A later positive conflict may justify another yield; absence of current conflict must remain passive.

The player is expected to return to tidy completed workers. Automatic yield exists to buy time, not replace that gameplay. Player Escalation is therefore an acceptable outcome whenever bounded autonomous yielding cannot preserve continuation cleanly.

For development testing keep legacy `AUTOMATIC_TERMINAL_EGRESS=true`. Do not rename the variable until the broader Terminal Yield implementation is agreed; eventual player-facing automatic yield is explicit opt-in/default-off.

## Implementation gap to protect

The retained v4.7.120 Control still treats Positive Field Exit as its successful objective and has no repeated/infield/externality-aware Candidate policy. This mismatch is deliberately documented. Architecture must drive the next implementation, not vice versa.

---

# v4.7.112 CANONICAL CANDIDATE handover — D-0147 Bounded Terminal Egress

**Canonical baseline:** owner-declared v4.7.109, SHA-256 `ea0b399e2f73759fa29982fc1b85d5bf446f6fd90eb324dec2902b333c7c6a74`, Git `cd9085ee40343d542a66b84948c27f7dd91a40c7`, 310 files.

## Candidate purpose

Canonicalise the post-v4.7.109 architectural discussion before implementation. D-0147 narrowly refines the historical GIANTS Completion Acceptance Boundary for positively obstructive Terminal Occupancy. Production runtime behaviour remains canonical v4.7.109 aside from release/version identity.

## Governing boundary

Automatic Terminal Egress is optional. A harmless completed assembly is untouched. An obstructive unclaimed completed assembly may compact; only if still necessary may it receive one simple continuous bounded outward manoeuvre toward the nearest local Field Boundary. Player Claim ends authority immediately and permanently for that Terminal Occupancy episode. Unsupported/exhausted egress belongs to the player.

Do not turn this into parking, Region Fit, King/Refuge search, field-centre relocation, alternate-boundary routing or global completed-worker coordination.

## Evidence retained, code discarded

Disposable v4.7.110 proved post-job actuation and Player Claim pre-emption. Disposable v4.7.111 established opportunistic `workHeadlands` / `headlandsFirst` visibility and the default-start settings gap. These are empirical records only; no disposable module is production lineage.

## Continuation

If the exact v4.7.112 candidate is canonicalised, implementation discovery begins from the canonical architecture—not from disposable probe code—and should be abandoned/escalated to player responsibility if a simple bounded expression cannot be supported.

---

# v4.7.109 CANONICAL CANDIDATE handover — three-worker stability plateau

**Canonical baseline:** owner-declared v4.7.102, SHA-256 `f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`, Git `cf51498316714c568b75ee6e65dab544ccbe7af3`, 310 files.

## Candidate purpose

Promote the live-validated v4.7.103–v4.7.108 implementation increment into one fresh candidate identity. v4.7.109 changes release/version/provenance records only relative to tested v4.7.108; do not infer an additional behavioural change.

## Final live evidence

The v4.7.108 three-worker run recorded five accepted D-0146 Step-2 Cooperative Passages, all 25 guide gates reached, five `SUCCEEDED` settlements, zero Passage Reassessment, zero safe-abandon escalation and no OuttaMyWay error stack.

## Canonicalisation boundary

Review and canonicalise only the exact v4.7.109 candidate fingerprint produced with its evidence package. After canonicalisation, optional enhancements are a new engineering increment.

---

# v4.7.106 test continuity — D-0146 Potential Action-Space Conservation

**Baseline:** owner-declared canonical v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files).

**Live evidence carried forward:** v4.7.105 removed false follower Regulations and successfully completed two S 416/sprayer passages plus one Condor/Patriot passage. Final Condor/Patriot head-on occurred after Current Excursion persistence consumed the Step-2 Local Passage entry reserve before Established conflict matured.

**v4.7.106 change:** preserve Trajectory Persistence; publish a bounded Potential-conflict Action-Space Conservation witness from current positive Reality; regulate only the stable approaching participant while the excursion remains GIANTS-native; release immediately on dissolution or `REVISE` the same D-0146 Commitment into Step 2 when Established conflict/passage becomes supported.

**Repository-first checks:** sealed `ValueRecord` traversal conventions re-audited. Integrated offline Candidate/Constraint/Decision/Commitment/Control test caught a missing purpose-specific Representation Fitness record before live packaging and the implementation was corrected using the repository's established pattern.

**Next evidence:** repeat the three-worker run. The decisive chronology is Potential + `D0146_ACTION_SPACE_REGULATION_SUPPORTED/APPLY` while useful separation remains, followed either by immediate `D0146_ACTION_SPACE_RELEASE` if the excursion dissolves or `D0146_PASSAGE_SUPPORTED` + same-Commitment passage succession if it matures.

---

# v4.7.105 test continuity — Optional Configuration Reduction

**Baseline:** owner-declared canonical v4.7.102; SHA-256 `f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files.

**Immediate discovery:** v4.7.103 Patriot/S 416 passage stalled in `COMPACTING`; S 416 has no meaningful compact passage configuration. The implementation had contradicted D-0146's already-accepted optional configuration reduction.

**v4.7.105 change:** per-participant Candidate configuration demand (`COMPACT_REQUIRED` / `RETAIN_CURRENT`), Control waits only for required reductions and restores only changed configurations. No vehicle-name special case. Retain v4.7.103 Operation-aware third-party support and stale follower-purpose fixes.

**Next evidence:** repeat the same three-worker run. Successful evidence is passage beyond configuration handling for Patriot/S 416 with S 416 retained current, while preserving Condor/Patriot and third-party/stale-regulation behaviour.

---

# v4.7.103 test continuity — three-worker implementation catch-up

Authoritative baseline is owner-declared canonical v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`). v4.7.103 does not reopen architecture. It removes the exhausted Condor/Patriot name gate, makes pairwise Local Passage Space aware of every other active Operation assembly's positive current occupancy, and lets stronger D-0146 relationship evidence retire stale D-0141 follower purpose.

Test the same three-worker scenario. Success means supported non-Condor/Patriot opposed pairs can enter Step 2; third-party occupancy either changes the selected arrangement or causes explicit Passage Reassessment; and stale follower regulation no longer persists after positive relationship succession.

---

# v4.7.102 CANONICAL CANDIDATE handover — D-0146 Step-2 validated / provenance reset

**Baseline:** owner-declared canonical v4.7.99, SHA-256 `c3f1f6493fd0e44c8447637827989117daa77a20ba80816cf34270484e5eea8d`, 307 files.

## Why this candidate exists

v4.7.101 supplied successful live Step-2 evidence but cannot enter Authority Transformation because producer and repository-owner candidate ZIP hashes disagreed. RRS defines that as a blocking candidate-determinism finding. Do not canonicalise either v4.7.101 byte identity.

v4.7.102 is a fresh candidate from exact v4.7.99 canonical baseline containing the completed Step-1 + Step-2 engineering increment. No passage-planning or Control algorithm was changed during the recovery; only release identity/provenance, documentation and version assertions changed.

## Live evidence carried forward as behavioural support

The 2026-08-12 Condor/Patriot TS015 run produced three D-0146 Step-2 activations, all five guide gates on each activation, and three `SUCCEEDED` settlements with no Passage Reassessment or safe-abandon escalation. The later final-few-metres condition occurred after Condor's Job Episode ended and while Patriot was the sole active worker; it is not attributed to Step 2.

## Canonicalisation boundary

Review and canonicalise only the exact v4.7.102 candidate fingerprint produced with its new evidence package. v4.7.101 is historical test evidence and must not be used as the authority artefact.

---

# v4.7.101 TEST BUILD handover — D-0146 Step-2 active Cooperative Passage

**Baseline:** owner-declared canonical v4.7.99, SHA-256 `c3f1f6493fd0e44c8447637827989117daa77a20ba80816cf34270484e5eea8d`, 307 files.  
**Step-1 evidence:** v4.7.100 live run supported Established Trajectory, Current Excursion/Trajectory Persistence and Potential -> Established Opposed Corridor Conflict. It also exposed Diagnostic Churn in logging, now corrected.

## Active implementation

Established Opposed Corridor Conflict is now actionable. Candidate responsibility owns Local Passage Space and Progressive Passage Search. The search constructs sufficient Passage Arrangements under Pairwise Passage Economy and emits a five-gate Passage Guide covering development, stable passage relationship, traversal and native reacquisition. The normal Constraint/Decision/Commitment/Authority chain remains authoritative. `CooperativePassageControl` consumes the chosen Guide and executes it using the proven Hold/compact/reposition/restore donors; Control does not decide conflict meaning or invent passage geometry.

## Mechanical authority boundary

The D-0146 traffic semantics are active, but current mechanical Representation Fitness remains bounded to the demonstrated P23 Condor Endurance II / Patriot 4450 profile. This is **Semantic Generalisation / Mechanical Boundedness**: the architecture is not reduced to TS015 geometry, while implementation refuses to manufacture generic vehicle/negative-clearance authority that Reality has not supplied. Progressive search may choose symmetric, asymmetric or unilateral burden distribution where the current Field World positively supports it. Boundary Encroachment remains architectural capability but this bounded expression does not require or claim a generic encroachment proof.

## Passage Support Loss

Control revalidates each Candidate-supplied gate. Loss of support does not trigger local route invention: the controller stops movement, restores where possible, keeps the pair held and records `PASSAGE_REASSESSMENT ... outcome=SAFE_ABANDON_ESCALATE`. A later implementation may re-express the Commitment only through current Situation/Candidate authority.

## Validation

204/204 Lua behavioural tests PASS; 79/79 Python structural/conformance tests PASS before packaging. Live GIANTS validation remains the authority for the active guide.

---

# v4.7.100 TEST BUILD handover — D-0146 Step-1 passive implementation

**Baseline:** owner-declared canonical v4.7.99, SHA-256 `c3f1f6493fd0e44c8447637827989117daa77a20ba80816cf34270484e5eea8d`, 307 files.  
**Intent:** implement the concluded D-0146 Step-1 Knowledge while preserving the proven bounded traffic/control path.

## Implemented

`TrajectoryConflictAssessment` is Situation-owned persistent Knowledge. It forms and persists Established Trajectory from observed physical displacement, treats short contradictory motion as Current Excursion, and supersedes only after sustained coherent contradictory travel. It then classifies Potential / Established Opposed Corridor Conflict using established opposed relation, mutual facing, current opposed closing/stability and categorical positive Supported Corridor Overlap from existing cached physical primitives.

The new fields are published as `trajectoryKnowledge` and `opposedCorridorKnowledge`. `PassiveLiveValidator` emits transition-only `TRAJECTORY` and `OPPOSED_CORRIDOR` evidence. Missing geometry fails closed.

## Deliberate authority boundary

No Candidate, existing TS015 Cooperative Passage assessment, Decision, Commitment or Control consumer uses the new Knowledge. D-0141 Regulation and bounded TS015 behaviour are intentionally unchanged. Generic Step 2 is not implemented.

## Offline validation

201/201 Lua behavioural tests PASS; 78/78 Python structural/conformance tests PASS. Live GIANTS validation is required before promoting the implementation. Calibration values are provisional implementation mechanics, not architecture.

## Next engineering activity

Run natural field evidence and inspect trajectory formation/persistence/supersession plus Potential -> Established opposed-corridor transitions. Do not start generic Step-2 implementation until this passive classifier has been validated against Reality.

---

# v4.7.99 CANONICAL CANDIDATE handover — D-0146

**Canonical baseline:** v4.7.98 (`105462f44b902312e5dc63c6176d44f848f15c1466d942a4bee70635ced6cd69`; Git `982992b926839c854f6d4d7979fe24885e267eae`; 307 files).  
**Candidate intent:** record the newly agreed trajectory/opposed-corridor and local-passage architecture before changing chats. Runtime behaviour is intentionally unchanged from v4.7.98 apart from version/provenance identity.

## New governing architecture

**Step 1 — categorise opposed:** use Established Trajectory + Current Motion with Trajectory Persistence. A Current Excursion weakens immediate alignment without instantly erasing coherent history. Potential conflict may justify Observe/Regulate; Established Opposed Corridor Conflict requires substantially opposed, closing, persistent/stable motion and positive corridor overlap. Any positive supported overlap counts; uncertainty-only overlap does not become Established. Productive/Transitional/TURN_SEGMENT is contextual evidence, not a binary gate.

**Step 2 — passage:** presume passage, then discover Local Spatial Constraint. Allow asymmetric/unilateral movement, optional configuration reduction, lane departure and Boundary Encroachment while the assembly remains partly in-field. Choose a sufficient Passage Arrangement through Pairwise Passage Economy rather than symmetry/global optimisation. Protect Nominal Inter-Assembly Clearance throughout development/traversal/reacquisition and account for Manoeuvre Swept Occupancy. Use a Passage Guide of virtual targets/gates rather than a fixed three-leg sidestep. Reassess if support for the current expression is lost.

## Health warning

**General D-0146 Cooperative Passage is not implemented.** The only live-proven passage remains the bounded v4.7.98 TS015 Condor/Patriot implementation with its existing calibration and purpose-specific Representation Fitness. Do not infer arbitrary assembly, asymmetric, margin-search, dynamic-guide or reassessment capability from the architecture.

## Next chat / next engineering objective

Begin from this candidate only after owner canonical declaration. Keep architecture, implementation and testing separate. First implementation discussion should address **Step-1 Established Trajectory / Current Excursion representation and Potential→Established Opposed Corridor Conflict classification**, reusing existing observed physical motion and cached assembly occupancy. Do not jump directly to generic Step-2 motion planning.

---

# v4.7.98 CANONICAL CANDIDATE handover — D-0144

**Canonical baseline:** v4.7.95, SHA-256 `1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`, Git `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`, 305 files.  
**Candidate intent:** preserve the live-successful v4.7.97 bounded TS015 production path while canonicalising the simpler D-0144 Situation model.

## Proven before this candidate

- Two automatic production Cooperative Passages completed in one v4.7.97 TS015 run at about 68.49 m and 69.93 m admission separation.
- Both passed the normal Candidate/Constraint/Decision/Commitment chain and returned the same Job Episodes to GIANTS with no cooldown.
- D-0141 follower Regulation was active before the second passage and was superseded cleanly by Cooperative Passage.
- The final encounter remained Productive/Transitional and was withheld despite looking physically near-collinear.

## Candidate simplification

Retain current Productive/Transitional state, current motion/heading, cached physical representation, cooperative relevance/obligations, D-0141 Regulation, D-0143 Cooperative Passage and Turning Rank as optional non-predictive spatial context. Retire Rook/Successor-Rook governing prediction, chessboard colouring, continuous Productive History, King Reserve, continuous Refuge search and headland-U-turn-specific solving.

`DemonstratedProductiveCoverageProbe.lua`, `ProductiveCoverageResidualProbe.lua` and `RefugeQualificationShadowProbe.lua` remain repository evidence but are no longer sourced or registered in live runtime. No new geometry work replaces them.

## Health warning for a new chat

**Bounded Cooperative Passage production capability is demonstrated; general Cooperative Passage is incomplete.** Do not assume authority for Productive/Transitional opposed encounters, asymmetric encounters, other assembly pairs or generic compact-clearance. Do not treat TS015 calibration literals as architecture. Wider regression scenarios are still to be engineered.

## Next unresolved question

After canonicalisation, the next narrow architecture question is whether a Productive/Transitional near-collinear opposed situation can ever acquire positive Cooperative Passage authority without simply weakening `TURN_SEGMENT` semantics. Do not solve it inside this consolidation candidate.

---

> v4.7.97 repair note: v4.7.96 live evidence proved the supported TS015 approach reached the production gate but was blocked by Generic Representation Gate Leakage. This build reuses existing bootstrap-cached `physicalSpaceEvidence` in Situation Assessment; no new shape calculation is introduced.

# v4.7.97 TEST BUILD handover — D-0143 TS015 Representation Fitness repair

**Baseline:** owner-declared canonical v4.7.95, SHA-256 `1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`, Git `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`, 305 files.

## Build scope

First narrow production implementation of canonical D-0143 for the demonstrated TS015 Condor Endurance II / Patriot 4450 near-collinear opposed-working class. This is non-canonical test/evidence lineage. No new architecture is introduced.

## Implemented chain

Situation-owned Cooperative Passage Knowledge now flows through Operational Picture → one joint multi-assembly `REPOSITION` Candidate → mandatory Constraints → Traffic Policeman/Decision → one Commitment/composition → two typed ControlRequests → production Cooperative Passage Control → simultaneous GIANTS handoff.

P23 is not sourced. King Reserve / continuous Refuge discovery remain retired. The old P22 TS015 unilateral relocation harness is disabled as live behaviour; proven P22 physical mechanisms remain donors.

## Bounded live envelope

Exact Condor/Patriot pair; exactly two active Operation members; positive active Encounter; settled productive continuation; mutually facing opposed headings (`headingDot <= -0.99`); 50-70 m start separation; <=2 m initial lateral offset; no current physical intersection; both fully deployed/foldable; one-time positive field containment for scripted target centres. These values are TS015 calibration, not architecture.

## Failure and settlement

Control fails closed: clear drive, Hold both, attempt restoration, no blind release. Positive restoration/handoff terminally settles the Cooperative Passage Commitment immediately. There is no cooldown. A later convergence can create a fresh Commitment.

## Next evidence

Run TS015 naturally with no console command. Validate automatic admission, Candidate/Decision/Commitment ownership, physical sequence, GIANTS same-Job resumption and later repeatability. Unsupported asymmetric geometry should be rejected rather than adapted.

## Offline validation

76/76 Python structural/conformance tests PASS; 196/196 Lua behavioural tests PASS; 102/102 active non-archive Lua files parse.

---

# v4.7.95 CANONICAL CANDIDATE handover — D-0143

**Baseline:** owner-declared canonical v4.7.77, SHA-256 `0964ba2583122088077e5e465fffb24820d07380f533d1f44ed7d1ad24355153`, Git `1742c197c21a1fb127932dcc15303dbd58515d6d`, 305 files.

## Candidate scope

Architecture/documentation and release/provenance/version identity only. Runtime traffic/Control behaviour remains canonical v4.7.77. P23 v4.7.91-v4.7.94 is evidence only.

## Governing architecture

Use D-0143 in `docs/ARCHITECTURE.md` as normative precedence where it conflicts with D-0142. King Reserve Availability, continuous Refuge discovery and the ordinary `A→R→A` King lifecycle are retired. Configuration-Released Space and Cooperative Passage are accepted; the first production authority envelope is deliberately limited to the demonstrated TS015 Condor Endurance II / Patriot 4450 near-collinear opposed-working class.

Surviving D-0142 Field World/Rook/Successor/Transitional-Demand/footprint/relevance/Resolution-Space/Conflict-Serialization/layer-boundary architecture remains authoritative.

## Next implementation objective

**TS015 Cooperative Passage Production Integration.** Couple the demonstrated capability through Situation Assessment → Candidate → Constraints → Traffic Policeman / Decision → Commitment → Bounded Authority → Control. Reuse P23 only as a physical donor; do not source it as a parallel production controller.

## Explicit freeze

Do not create another prototype, resume King optimisation, generalise to arbitrary vehicle pairs or build an asymmetric solver before the TS015 production path has live evidence. Passive post-handoff observation owns no cooldown and must not block a new Commitment.


# v4.7.76 CANONICAL CANDIDATE handover

Historical v4.7.76 handover record: at that time owner-declared v4.7.49 remained canonical until explicit declaration of that candidate.

## What is frozen

Functional traffic/Commitment/Control behaviour is the live-tested v4.7.75 TEST BUILD. Candidate preparation does not alter the D-0140/D-0141 behavioural implementation. Build-label/runtime identity text, documentation, provenance and the release manifest are the only intended candidate-preparation differences.

## Closure evidence

The 2026-08-10 TS015 run completed the complete Condor/Patriot working session. Three autonomous Refuge relocations were initiated. The final role-reversed head-on positively exercised the v4.7.75 repair: `REVISE_HEAD_ON` reused one same-Commitment authority token, retired the obsolete follower-boundary purpose on the new Yield worker, and allowed REPOSITION to proceed. Both jobs ultimately terminated after completing work.

Owner qualification: Patriot was manually moved after its work completed so Condor could access the final few metres. Record this as terminal/post-completion physical occupancy debt, not as a reason to reopen the just-validated traffic sequence.

## Do not reopen during canonicalisation

Do not alter follower admission, the 0.90 factor, 250 ms cadence, Refuge selection, P22 motion, outbound-egress lease preservation, Progress Passage, D-0123, same-Commitment Yield succession, or passive/shadow dispositions. Remaining implementation issues are parked for a later increment.

Testing environment standing order remains unchanged: standard testing remains DLC-free unless a specific evidence run declares otherwise.

Guarded Recovery remains governed by the existing Situation Assessment evidence contract; candidate preparation does not move that responsibility into Control.

## After owner declaration

The owner should materialise this exact candidate in the authoritative local repository, record the candidate SHA-256 and local Git provenance, run the local canonicalisation procedure, and then provide the resulting canonical ZIP/hash/commit state back to the collaboration. GitHub synchronisation remains owner-controlled.
