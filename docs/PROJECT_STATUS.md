# Current status — v0.1.6.0 Native Base Transit Geometry CANONICAL CANDIDATE

**Authoritative baseline:** owner-declared canonical v0.1.5.0 (`4ac4438a0ab89dc903d5f4d0fde799a141b666d6d49ccbb916aba98411f5148f`; 317 files) until explicit owner declaration of this exact candidate fingerprint.

**Candidate implementation:** v0.1.5.3 behaviour, with no additional traffic algorithm. Cooperative Passage prefers Representation-owned Native Base Transit Geometry built from discovered member `vehicle.base.size` rectangles. DISC/current physical evidence remains separate conservative occupancy/sweep support; legacy configuration selection remains available for Control/fallback.

**Field result:** TS010S PASS, TS015 PASS, TS016 PASS. TS009 FAIL with a small physical contact before Passage resumed. TS009 used `geometry=TRANSIT_BASE` but logged only `assemblyMembers=2` for the physical tractor + front mower + rear mower combination, with `coverageComplete=false` and `underApproximationRisk=true`.

**Current architectural finding:** **Transit Geometry Completeness requires Physical Assembly Completeness.** Complete base-size evidence for every member OuttaMyWay happened to discover is insufficient negative-clearance authority if assembly discovery itself may be incomplete. This is the first problem for the next tranche.

**Do not change yet:** do not add Entry-distance margin, revive post-compaction replanning, resurrect Native Deployment Pair inference, or remove legacy configuration-selection code. TS009's inherited optional compaction probe (`probe-requires-fully-deployed-start`) is separate evidence and should not be repaired in the same experiment as assembly membership.

**Next-chat start:** inspect TS009 Physical Assembly membership/discovery against the actual tractor/front/rear attachment structure; establish the missing-member/ownership mechanism without guessing which member is absent; then design the smallest completeness gate and re-run TS009 before broader regression.

---

# Current status — v0.1.5.3 Native Base Transit Passage Geometry TEST

**Baseline:** owner-declared canonical v0.1.5.0 (`4ac4438a0ab89dc903d5f4d0fde799a141b666d6d49ccbb916aba98411f5148f`; 317 files).

**Active hypothesis:** because Cooperative Passage policy always requests Transit, Passage geometry should come from one Representation-owned Transit footprint rather than live configuration optimisation. v0.1.5.3 builds that footprint from complete member GIANTS `vehicle.base.size` rectangles using authored offsets and runtime member transforms.

**Safety boundary:** Transit base geometry is purpose-specific, directional Passage geometry, not collision closure. Current DISC/physical evidence remains available for conservative occupancy and third-party checks. Incomplete Transit base geometry falls back to v0.1.5.0 planning. Legacy configuration selection is retained in this test only to preserve `COMPACT_REQUIRED`/`RETAIN_CURRENT` Control behaviour.

**Validation order:** TS010S, TS009, TS015, TS016, then random TS010 if useful. Confirm `geometry=TRANSIT_BASE`, Passage shape/timing, no contact, and no regression in required/optional compaction behaviour.

---

# Current status — v0.1.5.0 Minimal Transit Passage CANONICAL CANDIDATE

**Authoritative baseline:** owner-declared canonical v0.1.4.0 (`681573c2edd6256b092ab00d5955af72bbc5f231903ef81b3fc6d625929f437e`; Git `77695913f0af72960194f8f9ad13397d59e2dadb`; 317 files).

**Candidate state:** v0.1.4.8 behaviour, no new traffic algorithm. Passage retains v0.1.4.0 timing/guide execution, always attempts Transit at the existing configuration point, keeps required compaction strict, keeps inert optional Transit non-blocking, and validates the nominal 1.00 m Crossing-Window target against a 0.95 m policy floor with hard represented non-contact. Passive v0.1.4.6 clearance telemetry remains available.

**Field regression:** TS009 PASS (visual start-position caveat), controlled TS010S PASS, random-start TS010 PASS, TS015 PASS, TS016 PASS (visual start-position caveat).

**Next engineering question after canonicalisation:** Zero-Development Entry Compression — determine whether straight/zero-deficit Passage needs an independent longitudinal settlement/approach reserve rather than borrowing that reserve incidentally from lateral Development.

**Still open:** TS009 complex-assembly coverage/membership authority; inherited invalid `allowUnfoldingByAI` XML-path validation errors; final Passage agronomic debt/restoration and Restoration Alignment; inherited 8 km/h guide speed; other parked literal/provenance work.

**Withdrawn implementation experiments:** v0.1.4.1-v0.1.4.3 post-compaction replanning; v0.1.4.5 exhaustive inter-sample backfill.

---

# Current status — v0.1.4.8 Opportunistic Transit Non-Veto TEST

**Field evidence:** v0.1.4.7 passed TS010S, TS015 and TS009. TS016 failed after a supported `COMPACT_REQUIRED/RETAIN_CURRENT` Passage because an accepted-but-inert S416 opportunistic Transit request acquired mandatory completion authority and held `CONFIGURING` until watchdog failure.

**Experiment:** required compaction remains strict. Opportunistic `RETAIN_CURRENT` compaction waits only while Reality reports actual transition motion; a physically inert optional request cannot veto Passage.

**Primary validation:** TS016 first. Then regress TS010S, TS015 and TS009. The separate TS009/TS016 concern that Passage Entry/start appears too close remains parked.

---

# Current status — v0.1.4.7 Nominal Passage Clearance Policy Band TEST

**Evidence:** v0.1.4.6 telemetry supports millimetre-scale threshold sensitivity in TS010S rather than a meaningful narrow physical Passage opportunity.

**Experiment:** retain 1.00 m construction target; accept Crossing-Window clearance down to 0.95 m while preserving hard represented non-contact and all v0.1.4.4 timing/execution behaviour. Telemetry remains passive.

**Primary validation:** controlled TS010S active-worker save, then TS015.

---

# Current status — v0.1.4.6 Passage Clearance Telemetry TEST

Behaviour remains v0.1.4.4. The active question is whether the TS010S `NO -> YES -> NO` Passage-arrangement transition is a generic nominal-clearance threshold instability or an asymmetric-geometry sensitivity. v0.1.4.6 adds no extra geometric work; it logs clearance evidence already computed by normal Candidate assessment inside the final 40 m.

Primary field comparison: controlled TS010S active-worker save, then TS015.

---

# Current status — v0.1.4.4 Minimal Transit Compaction Reset TEST

**Authoritative baseline:** owner-declared canonical v0.1.4.0 (`681573c2edd6256b092ab00d5955af72bbc5f231903ef81b3fc6d625929f437e`; Git `77695913f0af72960194f8f9ad13397d59e2dadb`; 317 files).

**Selected experiment:** v0.1.4.0 is the behavioural control. Passage geometry/timing is unchanged; Control additionally attempts Transit compaction for every participant at the existing configuration point.

**Discarded branch:** v0.1.4.1-v0.1.4.3 post-compaction replanning is not carried forward. Its Entry/tolerance changes were outside the intended experiment.

**Field target:** rerun TS009, TS010 and TS015. Compare Entry/compaction point, Passage start/end and second-whistle behaviour directly against v0.1.4.0. Any difference other than additional successful compaction is a regression unless separately evidenced.

**Still separate:** TS009 Physical Assembly membership/coverage, inherited representation errors, Restoration Alignment, agronomic restoration and Passage speed.

---

# Current status — v0.1.4.0 Cooperative Passage checkpoint CANONICAL CANDIDATE

**Authoritative baseline:** owner-declared canonical v0.1.3.0 (`818507fc054484c2fe1a92bd4f6147cc849516f892642c0169f9055788d41de9`; Git `6e39cb443dd2cb313beac3ddf367f6521317947a`; 317 files).

**Candidate purpose:** consolidate the cumulative v0.1.3.1-v0.1.3.7 Passage work without new behaviour and carry the unresolved safety evidence cleanly into the next chat.

**Positive field evidence:** Resolution-Space → Passage handoff restored; productive Passage Approach; Execution-Origin Capture; Hold-Witness settlement correction; Crossing-Window-scoped clearance; close Condor/Patriot directional Passage; four-successful-passage TS016 run; generic unilateral allocations; successful small-excursion TS010 passages with materially reduced agronomic debt.

**Critical open issue:** TS009 S416 versus MF 7S.210 + SaMASZ front/rear mower was planned as straight retained-current Passage with claimed positive reserve, then physically collided/tangled. Runtime reported `assemblyMembers=2` for the physical tractor/front/rear mower combination. Root cause is not yet established.

**Selected next engineering objective:** investigate complete Physical Assembly membership/coverage for the TS009 mower combination, then implement/test **Transit-First, Reality-Verified Passage** as the simplified configuration policy. Defer the offset-plough challenge until this authority boundary is understood.

**Other parked items:** Restoration Alignment/finishing orientation, agronomic straight-reverse restoration, 8 km/h Passage guide speed, configuration/burden optimisation, TS010 <=60 m locality literal, D-0147 parked debt and broader literal audit.

---

# Current status — v0.1.3.7 Crossing-Window Clearance alignment TEST

v0.1.3.6 positively validated generic directional multi-member Passage in TS010 and substantially reduced agronomic debt, but rejection telemetry exposed **Global Clearance Residue**: fresh Candidate search could reject the same geometry that an already-committed Passage successfully executed because the old pair-sweep invariant demanded the full nominal 1 m clearance during Development and Recovery as well as the Crossing Window. v0.1.3.7 corrects only that authority mismatch.

**Current field target:** new larger-field mixed-assembly scenario, followed by the planned offset-implement challenge if Passage remains credible.

---

# Current status — v0.1.3.6 Mechanical Foldability Leakage correction TEST

TS016 validated the generic directional member-union Passage envelope and 0.1.3.4 settlement correction. TS010 on v0.1.3.5 failed before Passage Selection. Source inspection showed FW212 exposes a player-only/AI-disabled fold mechanism, while v0.1.3.5 Representation used raw `spec_foldable` to suppress its useful directional base-size evidence. v0.1.3.6 corrects that abstraction bypass and adds bounded rejected-candidate telemetry. No other Passage hypothesis is changed.

# Current status — v0.1.3.5 Generic directional assembly envelope TEST

**Canonical:** v0.1.3.0 (`818507fc054484c2fe1a92bd4f6147cc849516f892642c0169f9055788d41de9`; Git `6e39cb443dd2cb313beac3ddf367f6521317947a`; 317 files).

**Selected experiment:** retain validated v0.1.3.4 behaviour and extend Passage-specific GIANTS directional geometry from single-member vehicles to arbitrary assembly membership by unioning member rectangles at their actual poses. Missing member metadata falls back per member to represented DISCs.

**Why:** Condor/Patriot directional geometry produced credible ~1 m Passage; mixed S416 passages remained on the inflated/uncertain multi-member fallback. This test asks whether the existing representation primitives can generalise before introducing any sweep margin or new policy literal.

**Next evidence:** TS016 first, then TS010, then an offset plough if credible. Watch Passage envelope basis, physical contact threshold, policy-required separation, side-specific offsets and actual visible clearance.

---


# Current status — v0.1.3.4 Hold-Witness settlement correction TEST

**Canonical:** canonical v0.1.3.0 (`818507fc054484c2fe1a92bd4f6147cc849516f892642c0169f9055788d41de9`; Git `6e39cb443dd2cb313beac3ddf367f6521317947a`; 317 files).

**Selected correction:** retain v0.1.3.3 Passage behaviour and remove one inherited settling invariant. Passage now accepts owned Hold + physical stationary state even when GIANTS itself refused movement before OuttaMyWay's PermissionGate could record a veto call.

**Why:** TS016 Condor–S416 reached Entry and both stopped, but stayed permanently in `SETTLING`; `CONFIGURATION_START` never occurred and Condor remained unfolded. The failure is independent of the directional-envelope experiment.

**Next evidence:** rerun TS016 Condor–S416. Expected discriminator: after Entry and physical settlement, `CONFIGURATION_START` should occur even if a participant's PermissionGate call count remains zero.

---

# Current status — v0.1.3.3 Directional Passage Envelope TEST

**Canonical:** v0.1.3.0 (`818507fc054484c2fe1a92bd4f6147cc849516f892642c0169f9055788d41de9`; Git `6e39cb443dd2cb313beac3ddf367f6521317947a`; 317 files).

**Selected experiment:** retain v0.1.3.2 behaviour and replace only Passage's directional size source where strong GIANTS metadata exists. Single-member compact/non-foldable profiles may use bootstrap-cached `vehicle.base.size` width/length. Component DISCs remain fallback and retain conservative interaction authority.

**Why:** TS015 showed `contact≈9.22 m` from component spheres while source XML gives Condor 3.5 m width / 11.1 m length and Patriot 3.9 m / 9.0 m. The nominal 1 m policy margin was being dominated by representation inflation.

**Next evidence:** TS015 first. If the loaded XML is reachable, expect `envelopeBasis=GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPES`, `contact≈3.70`, `required≈4.70`. Do not tune the 1 m margin or Development slope before this result.

---

# Current status — v0.1.3.2 Passage Approach / Execution-Origin TEST

**Canonical:** v0.1.3.0 (`818507fc054484c2fe1a92bd4f6147cc849516f892642c0169f9055788d41de9`; Git `6e39cb443dd2cb313beac3ddf367f6521317947a`; 317 files).

**Selected correction:** restore the proven immediate Resolution-to-Passage authority handoff. Passage Selection now creates/revises the Cooperative Passage Commitment even when physical Entry is later. `PASSAGE_APPROACH` owns the interval to Entry and currently leaves both participants on native productive progression. After Entry settling/configuration, **Execution-Origin Capture** rebases the short excursion guide from current Reality.

**Retained experiment:** non-negative Clearance Deficit, physical-envelope Crossing Window and Recovery geometry from v0.1.3.1. Existing folding policy, 8 km/h guide speed, restore/Reacquisition, D-0155 and D-0147 are otherwise unchanged. No Agronomic Restoration reverse is implemented yet.

**Next evidence:** TS010 first. Only if the approach and first guide leg behave correctly do we judge the trapezoid itself.

---

# Current status — v0.1.3.1 Passage Excursion Envelope TEST

**Canonical authority:** owner-declared v0.1.3.0 (`818507fc054484c2fe1a92bd4f6147cc849516f892642c0169f9055788d41de9`; Git `6e39cb443dd2cb313beac3ddf367f6521317947a`; 317 files). v0.1.3.1 is a behavioural TEST only.

**Selected experiment:** delay physical Passage Entry after Passage Selection and replace the inherited long offset guide with non-negative Clearance Deficit -> derived Development -> represented-envelope Crossing Window -> Recovery toward the native lateral axis. Passage admission, D-0155 1 km/h Intent-Revelation Creep, configuration-first policy, burden selection, 8 km/h Passage speed, existing restoration/Native Reacquisition and D-0147 are intentionally unchanged.

**Player-visible objective:** materially reduce the missed agronomic work caused by early folding/control and excessive longitudinal Passage choreography while preserving safe no-contact crossing. This TEST does not yet reverse to repay residual agronomic debt.

**New implementation evidence to obtain:** whether the derived Entry Boundary starts Passage late enough but not too late; whether current represented longitudinal extents give a sufficient Crossing Window; whether small Clearance Deficits produce the intended shallow manoeuvre under GIANTS forward-only point pursuit; whether recovery returns participants closely enough to their native axes for the inherited handoff to work.

**First live sequence:** TS010 first. If promising, TS015/TS016 regressions. Do not tune single/both displacement, selective folding or agronomic reverse restoration until the actual v0.1.3.1 track shows which problem remains.

---

# Current status — v0.1.3.0 Resolution-Space canonical candidate

Owner-declared canonical v0.1.2.0 (`1d861caca5f6d06656c0fcd41b1c278c01ac7cda223af1fdf101203fe6e0e583`; Git `f841717285fb9a02d4dc8c0c469adbecd56cb38c`; 316 files) remains the authority until explicit promotion. v0.1.3.0 is a **canonical candidate** consolidating the validated D-0155 Resolution-Space Progression Envelope from the 0.1.2.1/0.1.2.2 TEST line; it intentionally introduces no new behavioural change beyond that validated line.

**Validation state:** TS010 successfully used the elastic envelope, reached 1 km/h Intent-Revelation Creep, matured unchanged Cooperative Passage and continued to normal MT665 completion. TS015 completed perfectly. TS016 succeeded through the traffic interaction; its final terminal move was suppressed by genuine Player Claim after the player briefly entered the completed vehicles. Magnitude Freeze was not reproduced.

**Parked:** TS010's later `<=60 m` final blockage remains a separate locality/projection-literal issue. Possible expiry/reset semantics for a post-completion Player Claim remain unselected. The observed ~18-second pacing stutter has no OuttaMyWay log cadence correlate and is not currently treated as an OMW defect.

**Selected next work after canonicalisation:** Cooperative Passage in-extenso architecture review and passage-specific Literal Provenance analysis. Do not begin by replacing numbers; first identify the problems Passage is meant to solve and the evidence each existing literal is standing in for.

---

# Current status — v0.1.2.2 Intent-Revelation Creep + Magnitude Freeze TEST

**Canonical baseline:** owner-declared canonical v0.1.2.0 (`1d861caca5f6d06656c0fcd41b1c278c01ac7cda223af1fdf101203fe6e0e583`; Git `f841717285fb9a02d4dc8c0c469adbecd56cb38c`; 316 files). Canonical authority has not moved.

**Observed v0.1.2.1 field result:** approach regulation was promising, but the first TS010 run ended in deadlock. The envelope tightened correctly until temporary loss of resolved current travel vectors caused **Magnitude Freeze**; later the zero-speed endpoint removed MT665 current-motion evidence while existing Passage did not mature.

**Implementation correction:** active D-0146 envelope magnitude now survives temporary closing-vector uncertainty by using current reference-pose separation from `currentSpace`. Purpose remains sticky and magnitude remains elastic for the lifetime of the unresolved Commitment.

**Selected TEST hypothesis:** replace only the D-0146 envelope's unresolved zero endpoint with **1 km/h Intent-Revelation Creep**. This is less intervention than Hold and is intended to preserve resolution opportunity/current-motion evidence. It may consume contingency reserve slowly and is not yet accepted as generic policy.

**Passage remains untouched:** the conjecture that its current-motion gate exists to reject stationary obstacles is unproven. v0.1.2.2 tests the existing Passage contract rather than redefining it.

**Bench state:** 255/255 Lua behavioural and 96/96 Python structural tests pass before RRS. Mandatory next evidence is TS010, then TS015/TS016 if TS010 supports the hypothesis.

**Explicitly parked/unchanged:** D-0154 Recovery; 80 m locality; Passage-in-extenso; guide/burden literals; D-0147 Courtesy Quantum/Exhaustion; other parked work.

---

# Current status — v0.1.2.1 Resolution-Space Progression Envelope TEST

**Canonical baseline:** owner-declared v0.1.2.0 (`1d861caca5f6d06656c0fcd41b1c278c01ac7cda223af1fdf101203fe6e0e583`; Git `f841717285fb9a02d4dc8c0c469adbecd56cb38c`; 316 files). v0.1.2.1 is a behavioural TEST candidate only; canonical authority has not moved.

**Selected hypothesis implemented:** replace the inherited fixed 8 km/h D-0146 Control magnitude with the smallest D-0155 **Resolution-Space Progression Envelope**, using a provisional 75% Resolution Contingency Reserve. The policy curve is state-derived and zero-terminal; caps are whole integer km/h and zero is Hold.

**Discovery — Magnitude Leakage:** prior code allowed Situation Assessment to choose `requestedCapKmh=8` and to suppress a Resolution-Space candidate when current native progression was already <=8. The Authority-Layer Impact Review classified this as Control magnitude leaking into Situation/Candidate eligibility. v0.1.2.1 removes that magnitude dependency; Situation continues to decide obligation and roles.

**Persistence:** conservative separation can decrease but not increase within the same unresolved Situation. Additional physical separation is Reverse-Created Resolution Reserve and cannot immediately relax the envelope. Positive Situation change still owns release/supersession.

**Role migration:** Magnitude Rebase on Role Migration preserves the existing absolute contingency reserve and already-consumed ordinary allowance, then samples the newly regulated participant's current progression and rebases over remaining ordinary allowance under the same Commitment.

**Bench state:** 254/254 Lua behavioural, 96/96 Python structural and 25/25 RRS tests pass in the working TEST tree. Live validation remains outstanding. TS010 is first; TS015/TS016 are mandatory regressions, especially Condor's long reverse and normal Passage succession.

**Explicitly parked/unchanged:** D-0154 Resolution-Space Recovery; 80 m locality; Passage-in-extenso; guide/burden literals; D-0147 Courtesy Quantum/Exhaustion and other parked work.

---

# Current status — v0.1.2.0 CANONICAL CANDIDATE

**Canonical baseline:** owner-declared v0.1.1.0 (`10ad10c0eb5956fbd32f3e82408201513dec6073e72b758db4b6bf394e8316b3`; Git `5cd2ae0c768a1a771b817b5ed5879ca02745f9de`; 316 files). v0.1.2.0 is architecture/documentation consolidation plus release identity only; runtime traffic behaviour is intentionally unchanged.

**Current architectural result:** the fixed 8 km/h D-0146 Resolution-Space Regulation cap is rejected as future generic sufficiency authority. The selected replacement direction is a **Resolution-Space Progression Envelope**: preserve a percentage Resolution Contingency Reserve, derive a zero-terminal-progression policy curve from the constrained participant's current progression and ordinary authorised Resolution Space, reassess against remaining conservative space, floor the cap to whole km/h, and Hold at zero. The curve is policy geometry, not a model of GIANTS braking physics.

**Purpose/magnitude:** Resolution-Space purpose remains sticky through uncertain reverse/forward manoeuvres; Control magnitude is elastic. Temporary gained separation is Reverse-Created Resolution Reserve and is not automatically spendable. Positive changed Reality may release, supersede into Passage/native continuation, or authorise a rebase.

**Architecture/code gap:** v0.1.2.0 does **not** implement this envelope. Live code still uses `D0146_RESOLUTION_SPACE_REGULATION_KMH = 8.0` and the existing Regulate/Hold machinery. This gap is explicit and selected for the next implementation tranche after canonical review.

**Recovery direction:** Resolution-Space Recovery is accepted as a possible Policeman `REPOSITION` tool after prevention fails. Back-Out toward recently demonstrated clear space is a candidate expression; static blockage is a future application. No recovery code is added.

**Passage boundary:** Resolution Space is not Passage Space. Conservation buys Intent-Revelation Opportunity; once Passage becomes positively supportable it supersedes the uncertainty envelope. Passage-in-extenso remains deliberately later work.

**Open calibration/validation:** exact contingency-reserve percentage remains undecided; constrained-participant low-speed-at-admission is a validation edge case rather than a pre-emptive design branch. TS010 is the primary small-space validation theatre; TS015/TS016 are mandatory prior-scenario regressions.

---

# Current status — v0.1.1.0 CANONICAL CANDIDATE

**Canonical remains v0.1.0.0 until explicit owner declaration.** v0.1.1.0 is a release/provenance-only successor to the tested v0.1.0.14 runtime; there is no intentional behavioural algorithm delta in candidate preparation.

**Plateau captured:** D-0146 small-field work has brought Pair-Specific Passage Clearance, Configuration-First Passage, Resolution-Space role attribution/migration, Regulate↔Hold, Pre-Productive Intent Relevance and ADR-0006 Safe Release materially closer to canonical architecture while preserving known-good TS015/TS016 passage behaviour.

**Known unresolved authority:** the empirical 8 km/h first-stage Resolution-Space cap is not generic sufficiency authority. v0.1.0.14 showed that waiting for physical cap realisation can consume the remaining Resolution Space before Hold becomes effective. The next engineering activity is literal/provenance review of response-adjusted supportable progression, not another guessed speed patch.

**Parked separately:** Guide Development Non-Convergence if reproduced after genuine productive commencement; D-0147 `<=60 m` Courtesy Exhaustion / broadly-centre coupling; 80 m locality; guide-shape/burden literals; Boundary Encroachment and remaining audit items.

---

# Current status — v0.1.0.14 Generic Regulation Sufficiency Hold TEST

**Canonical remains v0.1.0.0.** v0.1.0.14 is cumulative TEST evidence over v0.1.0.13.

**Current focus:** D-0146 Resolution-Space Regulation Sufficiency. TS010 demonstrated that an active settled-vs-settled opposed conflict can continue consuming Resolution Space after the selected participant has physically complied with the 8 km/h cap. The prior Hold gate incorrectly required the protected participant to remain Transitional. v0.1.0.14 removes only that fixture-derived eligibility coupling.

**Hypothesis:** if bounded Regulation is positively realised and material pair closure continues while the same Resolution-Space obligation remains active, Regulation is insufficient regardless of continuation class; the regulated participant may therefore be Held. Positive resolved non-closing may still de-escalate Hold back to Regulation under the same Commitment.

**Regression boundary:** TS015/TS016 known-good passage paths do not exercise Action-Space leases. Pre-Productive Intent Relevance, role migration, Safe Release vetoes and Cooperative Passage remain unchanged. The 8 km/h cap remains empirical and under literal review.

---

# Current status — v0.1.0.13 Safe Release Conformance TEST

**Canonical remains v0.1.0.0.** v0.1.0.13 is cumulative TEST evidence over v0.1.0.12.

Current focus: D-0146 Resolution-Space Safe Release. TS010 showed that relationship-label dissolution could release a live obligation while positive Field-Bounded Future-Space intersection or participant blockage contradicted Safe Release. v0.1.0.13 keeps the obligation live under either contradiction and otherwise leaves the 0.1.0.12 architecture/code path unchanged.

# Current status — v0.1.0.12 Pre-Productive Intent Relevance TEST

**Canonical remains v0.1.0.0.** v0.1.0.12 is cumulative TEST evidence over v0.1.0.11.

**Current hypothesis:** productive commencement is the gate for cooperative Operation membership, not for Situation Relevance. A same-Field-World active GIANTS field-work Job Episode whose productive intent is still unrevealed remains eligible for D-0146 Resolution-Space Conservation against a known productive Operation member, but is not eligible for Cooperative Passage or OuttaMyWay configuration/reposition authority.

**Expected TS010 behaviour:** before MT665 first productive work, OuttaMyWay should leave MT665 wholly GIANTS-driven, while the productive mower may be Regulated and, if Regulation is proven insufficient, Held. If MT665 later commences productive work while the relationship remains relevant, the same pair identity persists and normal D-0146 passage eligibility may emerge.

**Regression boundary:** completed/non-active workers are not granted this pre-productive active-job authority; TS015/TS016 productive pairs remain on the existing path. Resolution-Space Role Migration and reversible Hold remain active and unchanged.

---

# Current status — v0.1.0.11 Productive Commencement + Role Migration TEST

**Canonical:** owner-declared v0.1.0.0 remains authoritative.

**Current evidence:** TS010 v0.1.0.10 Runs 1–3 repeatedly circled only while MT665 had not yet positively commenced productive work. Run 6 started MT665 first, productively commenced, passed successfully, then deadlocked when Situation reassigned an active Resolution-Space role from MT665 to the mower but the physical lease did not migrate.

**v0.1.0.11 hypothesis:** (1) Job-Episode-latched productive commencement restores the canonical boundary between job-entry/native revelation and cooperative Operation participation; (2) the same live Resolution-Space Commitment can preserve its obligation while its regulated/protected Control roles migrate with current Situation Assessment.

**Prior-scenario bench:** retained v0.1.0.7 TS015/16 successful passage participants had already productively commenced, and neither scenario exercised Action-Space Regulation/Hold. Their known-good passage path should therefore be unchanged by these corrections.

**Retained:** v0.1.0.10 reversible Regulate↔Hold; 8 km/h remains empirical and under review.

**Parked:** Guide Development Non-Convergence if it still reproduces after productive admission is corrected; D-0147 `<=60 m` Courtesy Exhaustion coupling; remaining literal-audit items.

# Current status — v0.1.0.10 Reversible Resolution-Space Hold TEST

**Canonical:** owner-declared v0.1.0.0 remains authoritative.

**Validated plateau:** v0.1.0.7 restored TS015 full completion; v0.1.0.8 corrected reverse-aware Established-conflict role attribution; v0.1.0.9 validated Regulate→Hold escalation in TS010.

**Current evidence:** v0.1.0.9 Hold escalation prevented immediate closure, but one-way Hold persistence then kept MT665 stationary after Situation positively established non-closing. The final encounter deadlocked when the protected mower later returned to the still-held MT665.

**v0.1.0.10 hypothesis:** retain the Resolution-Space obligation, but de-escalate its physical expression Hold→prior Regulation only from positive resolved non-closing evidence. Missing/unresolved motion retains Hold. If closure returns, the same obligation may re-escalate.

**Prior-scenario bench:** retained v0.1.0.7 TS015 = 3 successful passages, TS016 = 1 successful initial passage, with zero Action-Space Regulation/Hold events in either log. Cooperative Passage/D-0147 Hold paths are outside this change.

**Under review / parked:** 8 km/h regulation literal; Guide Development Non-Convergence; D-0147 `<=60 m` Courtesy Exhaustion coupling; 80 m locality calibration; guide-shape literals; burden fractions; Boundary Encroachment; generic Blocked Conflict Persistence; remaining literal-audit items.

# Current status — v0.1.0.9 Regulation Sufficiency / Hold Escalation TEST

**Canonical:** owner-declared v0.1.0.0 remains authoritative.

**Validated plateau:** v0.1.0.7 restored TS015; v0.1.0.8 retained successful TS010 passages and corrected reverse-aware Established-conflict role attribution.

**Current evidence:** TS010 v0.1.0.8 Run #4 correctly regulated MT665 to 8 km/h while preserving a Transitional mower, but the pair continued closing from about 53 m to about 13 m and deadlocked before a supported Passage emerged. Regulation was correctly assigned and realised, but insufficient.

**v0.1.0.9 hypothesis:** once Regulation has physically taken effect, continued positive closure while the protected participant remains Transitional disproves Regulation Sufficiency for that Situation. Tightening the same purpose-bound lease to zero-speed Hold should conserve the remaining Resolution Space without inventing another speed literal.

**Under review:** the historical/empirical 8 km/h regulation calibration, including the user's recollection that earlier versions may have used calculated variable regulation speeds. This tranche does not restore or redesign that mechanism.

**Parked:** Run #3 Guide Development Non-Convergence; D-0147 `<=60 m` Courtesy Exhaustion / broadly-centre coupling; 80 m locality calibration; guide-shape literals; burden fractions; Boundary Encroachment; generic Blocked Conflict Persistence; remaining literal-audit items.

# Current status — v0.1.0.8 Reverse-Aware Resolution-Space Role TEST

**Canonical:** owner-declared v0.1.0.0 remains authoritative.

**Validated plateau:** v0.1.0.7 restored TS015 full completion; TS016 initial S416 passage and TS010 passage also succeeded. Cooperative Passage is provisionally back on track.

**Current failure under test:** TS010's post-handoff GIANTS reverse creates a new Established opposed conflict. The existing selector ignored reverse native commands and could therefore fail to regulate the participant actually consuming the most pair separation.

**v0.1.0.8 hypothesis:** pair-axis native closure contribution, independent of forward/reverse gear, will assign Resolution-Space Regulation to the materially closing participant. No Regulate→Hold escalation is included so the hypothesis remains isolated.

**Parked:** D-0147 `<=60 m` Courtesy Exhaustion / broadly-centre coupling; 80 m locality calibration; guide-shape literals; burden fractions; Boundary Encroachment; generic Blocked Conflict Persistence; remaining literal-audit items.

# Current status — v0.1.0.7 Passage Support / Failure-Configuration TEST

TS015 regression of v0.1.0.6 exposed a false passage abort: native GIANTS `isBlocked=true` appeared while folded sprayers remained physically separated. v0.1.0.7 removes only that D-0146 standalone abort authority and preserves compact configuration on held failure. TS015 runtime regression is the next validation. Canonical remains owner-declared v0.1.0.0.

# Current status — v0.1.0.6 Configuration-First Cooperative Passage TEST

**Canonical:** v0.1.0.0 remains authoritative.

**Validated prior evidence:** v0.1.0.5 removed the TS010 deadlock but exposed an unsatisfactory deployed-mower passage with fresh positive native blocked evidence during guide traversal.

**Current TEST hypothesis:** if a same-episode compact mower profile has been observed natively, D-0146 should select it only when it releases conflict-side space, compact while both participants are held, recompute pair-specific clearance, and drive only the residual lateral burden. FW212 should remain current because its crane is not an AI-reachable productive configuration. Positive native blockage during guide motion now fails held.

**Still parked:** 80 m locality calibration; guide 12/8/12 +4 geometry; burden fractions; Boundary Encroachment; generic Blocked Conflict Persistence; D-0147 parked issues; remaining literal audit items.

---

# Current status — v0.1.0.5 Resolution-Space Conservation / Progressive Passage TEST

**Authoritative baseline:** owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files).

**Observe:** v0.1.0.4 removed the 12/6 geometry surrogate. TS010 then produced one deadlock and one successful passage. The deadlock established that passage geometry can still be temporarily unsupported while MT665 completes a native turn, yet no Regulation is admitted once the Current Excursion witness has disappeared. The pair consequently consumed Resolution Space and then encountered the unjustified fixed 50 m Step-2 floor.

**Interpretation:** these are implementation mismatches against existing D-0146 architecture, not new architectural blockers. Resolution-Space Conservation already forbids ordinary progression from consuming the last locally admissible means of resolution, and Progressive Passage Search already requires actual local support to decide feasibility.

**Implementation:** v0.1.0.5 (1) admits bounded Resolution-Space Regulation for an Established opposed conflict when Step-2 has no supported passage expression and (2) removes the 50 m minimum-entry gate completely. The 80 m upper locality ceiling remains. Regulation preserves a Transitional participant when one is present; otherwise it defers the greater native closure contribution. Passage still supersedes Regulation under the same D-0146 governing requirement as soon as a supported guide exists.

**Validation target:** repeat the v0.1.0.4 deadlock start pattern first. Expected sequence is Established conflict → `D0146_ACTION_SPACE_REGULATION_SUPPORTED ... admission=ESTABLISHED_CONFLICT` → Regulation APPLY → later `D0146_PASSAGE_SUPPORTED` potentially below 50 m → same-Commitment Cooperative Passage succession. Record any remaining rejection reason rather than tuning guide-shape/burden literals pre-emptively.

**Parked:** 80 m upper locality calibration; 12/8/12+4 guide geometry; burden fractions; Configuration-Released Space actuation; Boundary Encroachment; Blocked Conflict Persistence; Candidate/Control field-target proof mismatch unless reproduced; D-0147 work.

---

# Current status — v0.1.0.4 Pair-Specific Passage Clearance TEST

**Authoritative baseline:** owner-declared canonical v0.1.0.0 (`7298efe929d2739a9cb2c9d8b6ef1d3d5ea1caa872d4d8c2fa3659eec4bacb19`; Git `1b970e2075031cd96143776d49cc625cb48f82f8`; 315 files).

**Observe:** the TS010 evidence set contains two deadlocks and one successful passage on the same 0.1.0.3 production passage implementation. The successful third run changed native AI-worker start geometry; it did not change D-0146. The literal audit and controlled pair/configuration diagnostics showed the inherited 12/6 m model demanded materially more lateral movement than the represented pair required.

**Hypothesis:** replacing the 12 m/6 m geometry surrogate with Pair-Specific Passage Clearance plus the agreed 1.0 m Nominal Inter-Assembly Clearance will allow the small-field pair to develop only the clearance it actually needs. Because passage-relevant configuration authority is not yet implemented, v0.1.0.4 retains current configuration rather than manufacturing False Compaction Demand.

**Implementation state:** TEST. Clearance is computed independently for each passage side from conflict-facing one-sided extents; guide and third-party support no longer derive authority from 6 m. The 50/80 m entry window and remaining guide/burden literals are intentionally unchanged.

**Evidence limitation:** current participating represented primitives remain `coverageComplete=false` / `negativeClearanceAuthority=false`; translated current DISC sweep is a bounded implementation hypothesis, not a generic Coverage Closure claim.

**Next validation:** rerun TS010 using (1) the two start patterns that previously deadlocked and (2) the successful third-run start order as a regression/control. If 12/6 removal exposes the 50 m Development-Space Surrogate or the Candidate/Control field-target mismatch as the next failure, treat that as new evidence rather than changing both in advance.

---

# Current status — v0.1.0.0 pre-1.0 versioning canonical candidate

**Authoritative baseline:** owner-declared canonical v4.7.128 (`3933bd60ef7dc5e603647835a2959de34cd8e79f44a7436ba7bf122021b262f1`; Git `d90057eb3adafa7204517eaa0ded0c696a13fd1b`; 315 files).

**Candidate purpose:** release-identity transition only. Canonical v4.7.128 behaviour is frozen unchanged.

**Versioning policy:** `0.MINOR.PATCH.BUILD`; canonical `BUILD=0`, TEST uses BUILD, compatible canonical correction advances PATCH, significant capability/architecture milestone advances MINOR, public release is `1.0.0.0`. Historical 4.7.x records remain immutable.

**Next gate:** owner review of the exact v0.1.0.0 candidate fingerprint and explicit canonical declaration or rejection.

---

# v4.7.128 CANONICAL CANDIDATE status — audited three-assembly courtesy-continuation plateau

**Authority:** owner-declared v4.7.121 remains canonical until explicit owner canonicalisation. v4.7.128 is the fresh canonical candidate.

**Candidate lineage:** v4.7.126 completed the full Patriot + Condor + S416 theatre; v4.7.127 repeated full completion after the architecture/code audit corrections. The current D-0147 implementation is therefore live-supported for this tested theatre and explicitly not universalised to untested assembly classes/configurations.

**Candidate delta from tested v4.7.127:** release/version identity, provenance and canonical-review records only. D-0147 movement, 60 m calibration, native-max speed, one-shot centroid bearing, Protected Yield, Continuation Renewal, Courtesy Exhaustion, Player Claim/source supersession, Courtesy Constraint Exception and Actuation Neutralisation are unchanged.

**Next gate:** owner review of the exact packaged v4.7.128 fingerprint and explicit canonical declaration or rejection. Do not mix the separately agreed pre-1.0 versioning transition into this candidate.

---

# v4.7.127 TEST BUILD status — architecture/code audit alignment after first full three-vehicle completion

**Authoritative baseline:** owner-declared v4.7.121 canonical. v4.7.127 is non-canonical and preserves v4.7.126 control behaviour.

**Live milestone:** v4.7.126 completed the full Patriot + Condor + S416 theatre. Both completed sprayers made decisive protected 60 m native-max Bounded Infield Retreats; S416 then completed. This is the first fully completed three-vehicle OuttaMyWay test.

**Audit finding resolved:** D-0147's crude retreat had empirical support but overstated `FIELD_WORLD_CONTAINMENT` and `TRANSITION_CLEARANCE` as positive proof. Architecture now explicitly classifies D-0147 as a special player-consented courtesy case and exempts those two generic predictive proof obligations. Code records them not-applicable rather than fabricating PASS evidence.

**Audit housekeeping:** proven sealed ValueRecord native-length defects in active Candidate/Commitment/Passage paths are corrected. Governing overview documents are updated; historical entries remain intact.

**No behavioural changes:** 60 m retreat, native max speed, one-shot centroid bearing, Protected Yield, Continuation Renewal, Courtesy Exhaustion, Player Claim and Actuation Neutralisation are unchanged.

**Next gate:** validate this audit-alignment build, then prepare/review the canonical candidate. The separately agreed versioning reset is later and must not be mixed into this audit/canonicalisation step.

---

# v4.7.126 TEST BUILD status — D-0147 60 m Native-Max Retreat

**Authoritative baseline:** owner-declared v4.7.121 canonical. v4.7.126 is non-canonical.

**Latest evidence:** v4.7.125 confirmed Protected Yield and Continuation Renewal, but the 30 m retreat can leave Patriot on a later S416 pass. Speed-only change was rejected because it would reach the same stopping geometry sooner.

**v4.7.126 objective:** test a more decisive but still deliberately crude courtesy quantum: 60 m realised progress toward the fixed one-shot Field World centroid bearing at the completed vehicle's native maximum forward speed. S416 remains held throughout translation. All repetition/exhaustion/authority rules are unchanged.

# v4.7.125 TEST BUILD status — D-0147 Continuation Renewal

**Authoritative baseline:** owner-declared v4.7.121 canonical. v4.7.125 is non-canonical.

**v4.7.124 evidence:** Protected Yield is live-supported. S416 was held while Patriot executed one 30 m Bounded Infield Retreat, then resumed useful native progression for about 70 m before a later attributed block. The courtesy move therefore succeeded locally in time. The remaining defect was lifecycle: Conflict Renewal required represented conflict disappearance and could suppress a legitimate repeat even after productive continuation had demonstrably resumed.

**v4.7.125 objective:** test **Continuation Renewal**. After one retreat, the authorising productive assembly/assemblies must positively resume physical GIANTS-owned motion before D-0147 can re-arm. Re-arming does not trigger movement by itself; another retreat requires a later native `blocked=true` state that remains positively attributed to the same completed assembly. This allows repeatable crude courtesy moves without immediate chained 30 m retreats.

**Preserved:** Pending Player Reclamation; Terminal Yield Consent; Bounded Infield Retreat; one-shot fixed Infield Alignment; 8 km/h; 30 m inward-progress allowance; Protected Yield Interval; Actuation Neutralisation; Player Claim; Courtesy Exhaustion near the field centre; no productive exclusion map, parking/refuge search, route planning or external-yield fallback.

**Live target:** repeat TS016. Expected sequence is `HOLD S416 → Patriot retreat → RELEASE S416 → positive S416 physical progression → later S416 blocked by Patriot → second Protected Yield + second Patriot retreat`.

---

# v4.7.124 TEST BUILD status — D-0147 Protected Yield traversal correction

**Authoritative baseline:** owner-declared v4.7.121 canonical. v4.7.124 is non-canonical.

**v4.7.123 evidence:** Protected Yield architecture was not exercised because sealed `protectedDemandAssemblies` was traversed with native Lua collection operators. The 0 km/h hold never applied; behaviour therefore repeated v4.7.122.

**v4.7.124 objective:** exercise the already-agreed Protected Yield Interval with canonical ValueRecord traversal. No behavioural calibration changes.

# v4.7.123 TEST BUILD status — D-0147 Protected Bounded Infield Retreat

**Authoritative baseline:** owner-declared v4.7.121 canonical (`86fbdcdea4a7967c4987eee5ca22101ead136b56`, canonical ZIP SHA-256 `f003ad7d23d80372f3dc8892aa1c1fd683d5c2dacab34f1809ee97cad08ff327`). v4.7.123 is non-canonical.

**Validated by v4.7.122 evidence:** fixed one-shot centroid bearing, forward-only large arcing turn, steering unwind, 30 m realised inward translation and clean neutralisation for Patriot.

**Current hypothesis under test:** prevent the observed genuine collision by adding a Protected Yield Interval. The authorising productive assembly/assemblies are held at a 0 km/h Regulation cap only during `INFIELD` translation, then released after terminal neutralisation. No speed calibration or planning change is made.

# v4.7.122 TEST BUILD status — D-0147 Bounded Infield Retreat

**Authoritative baseline:** owner-declared v4.7.121 canonical (`86fbdcdea4a7967c4987eee5ca22101ead136b56`, canonical ZIP SHA-256 `f003ad7d23d80372f3dc8892aa1c1fd683d5c2dacab34f1809ee97cad08ff327`). v4.7.122 is a test implementation over that baseline and is not canonical unless the owner explicitly promotes it.

**Objective:** implement the deliberately simple optional D-0147 courtesy behaviour agreed after TS016: buy player-reclamation time with a crude infield move rather than attempting near-impossible proof of safe External Yield.

**Implementation hypothesis:** after positive Terminal Occupancy admission and supported compaction, Candidate samples the immutable Field World centroid exactly once and supplies one fixed **Infield Alignment**. `TerminalEgressControl` (legacy name retained) reuses validated Vehicle Activity Context and forward-only `driveInDirection()` at 8 km/h. It never recomputes a centre bearing during the manoeuvre. One retreat completes after 30 m of realised progress toward the centroid; 30 m is a courtesy calibration, not a clearance claim.

**Repeatability:** retreat completion settles the current Commitment immediately but does not permanently settle the completed Job Episode. `TerminalOccupancyAssessment` then requires **Conflict Renewal**: the prior obstruction must disappear before a later positive obstruction can admit another retreat. If the assembly begins an admitted retreat within one retreat allowance of the centroid, D-0147 records **Courtesy Exhaustion** and escalates to the player.

**Explicitly absent:** Positive Field-Exit Settlement, boundary egress geometry, continuous centre pursuit, demand/exclusion-zone prediction, parking/refuge search, deterministic dispersion, route planning, reverse rescue, external-yield fallback and arbitrary overall move counts.

**Validation target:** TS016 first. Observe whether Patriot/Condor realise the large forward arc toward the fixed initial centre bearing without reverse, whether 30 m inward progress is a useful courtesy quantum, whether actuation neutralises cleanly, and whether the conflict-renewal latch prevents immediate repeat chaining. Reality decides the next refinement.

---

# v4.7.121 CANONICAL CANDIDATE status — Terminal Yield / Pending Player Reclamation

**Canonical baseline:** owner-declared v4.7.112 — SHA-256 `f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`, Git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`, 310 files. v4.7.113–v4.7.120 are non-canonical implementation/live-evidence lineage.

**v4.7.120 live result:** Terminal Egress mechanics are now live-supported: Vehicle Activity Context realised steering, the fixed Exit Alignment produced a bounded turn followed by substantially straight travel, Positive Field-Exit Settlement succeeded, and Actuation Neutralisation stopped cleanly. Later native S 416 turning nevertheless became `blocked=true` about 107 seconds after Patriot's exit. Physical/debug-overlay evidence indicates GIANTS' runtime collision policy can demand materially more clearance than body non-overlap, while further outward relocation can impinge on an adjacent Field World.

**Governing architectural correction:** D-0147 is now **Terminal Yield while Pending Player Reclamation**. The player is expected eventually to return to/tidy each completed worker. OuttaMyWay buys time for that return; it does not discover permanent parking. **Continuity, Not Settlement** means the current obligation succeeds when admitted productive continuation is restored without creating a worse external conflict. **Reactive Terminal Yield** may recur only on a later positive current conflict; there is **No Final Settlement Requirement** while active demand remains.

**Consent / escalation:** automatic completed-worker movement requires **Terminal Yield Consent**. The current implementation switch remains named `AUTOMATIC_TERMINAL_EGRESS` and remains `true` for development testing by owner request. It is deliberately not renamed in this architecture-only candidate. Eventual player-facing automatic yield is explicit opt-in/default-off. Player Claim is absolute/sticky for the occupancy episode; unsupported or unreasonable autonomous yield escalates to the player as legitimate normal gameplay.

**Spatial policy:** external egress remains valid when it resolves the conflict without unacceptable externality. **Egress Externality Constraint** prevents unbounded outward clearance that merely exports occupancy into another Field World. **Conflict-Relative Infield Yield** is architecturally permitted where external egress is inappropriate: move away from the demonstrated current conflict within the source Field World, treat other assemblies as constraints, stop when productive continuation is restored, and repeat only if a later real conflict emerges. Field centre and randomness are not governing targets/policies; deterministic dispersion may resolve genuinely symmetric alternatives.

**Implementation state:** the v4.7.120 implementation remains the current production expression and is unchanged in traffic behaviour. It implements only one external-egress form of Terminal Yield. Repeated yield, infield yield, externality-aware Candidate selection and the eventual config rename are **not implemented** in this candidate and are the next architecture→implementation gap to discuss after canonicalisation.

**Next objective after owner canonicalisation:** define the smallest supportable Candidate/Commitment contract for one evidence-driven Reactive Terminal Yield without turning the feature into parking/search AI. Do not code a random field-centre move.

---

# v4.7.120 TEST BUILD status — Exit Alignment continuation

**Canonical baseline:** owner-declared v4.7.112 — SHA-256 `f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`, Git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`, 310 files. v4.7.119 remains non-canonical live evidence.

**Validated from v4.7.119:** Vehicle Activity Context closes the post-job steering-realisation gap. With `forceIsActive=true`, the completed Patriot became physically active, wheel steering angles left zero and realised yaw occurred. Actuation Neutralisation also remained effective.

**New reality finding:** fixed-point pursuit over-rotated the assembly. Patriot's realised heading changed by about 86 degrees although the intended Exit Alignment was the heading/outward bisector. Reaching the point did not imply absolute field clearance. This is **Exit Vector / Exit Heading Mismatch**.

**Current production expression:** Candidate supplies one selected boundary and one world Exit Alignment direction. Control uses GIANTS `driveInDirection()` to acquire/hold that heading and continues until Positive Field-Exit Settlement. No target-distance settlement remains. The same Terminal Resolution Commitment, Vehicle Activity Context, 8 km/h, Player Claim/source reactivation handling and Actuation Neutralisation remain in force.

**Live target:** repeat TS016. Expected evidence is a bounded steering lead-in, declining steering demand as Exit Alignment is acquired, then substantially straight outward travel until the represented compact footprint is wholly outside and settlement succeeds.

# v4.7.119 TEST BUILD status — bounded Vehicle Activity Context

**Canonical baseline:** owner-declared v4.7.112 — SHA-256 `f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`, Git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`, 310 files. v4.7.118 remains non-canonical live evidence.

**Reality update:** v4.7.118 proved the post-job steering demand survives (`rotatedTime` remained materially non-zero), CrabSteering remained in its AI mode (`state=2`, `aiSteeringModeIndex=2`), but every steerable wheel physics angle remained exactly zero. The supplied SDK identifies the matching gate: `WheelPhysics:serverUpdate()` only calls `updateSteeringAngle()` while `vehicle.isActive` is true.

**Cross-check:** Courseplay preserves an active GIANTS AI-worker context. AutoDrive is not a GIANTS AI job, but while driving it deliberately asserts `forceIsActive=true`; this is sufficient evidence to test vehicle activity independently from productive Job Episode identity.

**Current production expression:** v4.7.119 changes one mechanical condition only. On EGRESS Control admission it captures the completed vehicle's prior `forceIsActive`, temporarily asserts `forceIsActive=true`, retains the existing v4.7.118 curvature/geometry/telemetry, then neutralises owned actuation and restores the captured activity value on every EGRESS exit. Player Claim/source reactivation receive no later OuttaMyWay drive/stop actuation, but the temporary activity context is still relinquished.

**Live target:** one TS016 egress. The decisive chain is `VEHICLE_ACTIVITY_CONTEXT_ACQUIRED` → next-update `isActive=true` → non-zero wheel `steeringAngle` → realised yaw. If `isActive` remains false, investigate wake/update scheduling before changing steering geometry or actuator.

---

# v4.7.118 TEST BUILD status — steering-state handoff diagnostic + actuation neutralisation

**Canonical baseline:** owner-declared v4.7.112 — SHA-256 `f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`, Git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`, 310 files. v4.7.117 is live test evidence, not canonical authority.

**Reality update:** v4.7.117 issued non-zero post-job curvature but Patriot and Condor still travelled straight. v4.7.116 Positive Field-Exit Settlement remains supported. v4.7.117 additionally exposed latched propulsion after exhaustion because Control released without positive physical neutralisation.

**SDK/Courseplay interpretation:** GIANTS drive helpers create steering demand in `vehicle.rotatedTime`; actual wheel steering is deferred to `WheelPhysics:updateSteeringAngle()`. Courseplay preserves the active AI-worker lifecycle around its own routing and ultimately uses `AIVehicleUtil.driveToPoint()`. The current unknown is therefore the command-to-wheel steering-state handoff after genuine Job Episode completion.

**Current production expression:** D-0147 Candidate, Oblique Boundary Egress geometry, 8 km/h calibration, sticky Terminal Resolution Commitment and Positive Field-Exit Settlement are unchanged. v4.7.118 adds only steering-state telemetry plus positive owned-exit actuation neutralisation.

**Live target:** one TS016 attempt. Compare `STEERING_COMMAND_STATE` → `STEERING_NEXT_UPDATE` / `STEERING_HEARTBEAT` and the actual wheel angles. No new steering mechanism should be inferred until that evidence is read.

---

# v4.7.116 TEST BUILD status — D-0147 post-job steering / field-exit plumbing correction

Owner-declared v4.7.112 remains canonical. TS016 v4.7.115 showed that Oblique Boundary Egress was correctly calculated by Candidate (`exitOutwardDot=0.707`) but not realised physically: both vehicles retained essentially their v4.7.114 headings/trajectories. The production post-job actuator normalized the steering-node local target before `AIVehicleUtil.driveToPoint()`, discarding target-distance information. The same run again showed Patriot wholly outside the Field World while settlement failed; D-0147 boundary transfer/traversal still used ordinary Lua collection access against sealed architecture values.

**v4.7.116 correction:** preserve the complete `worldToLocal()` position for direct post-job drive calls and use `ValueRecord.length/ipairs` for Field World boundary traversal/transfer. No D-0147 semantic or policy change is introduced.

**Preserved:** Oblique Boundary Egress, sticky Terminal Resolution Commitment, mandatory supported compaction, Positive Field-Exit Settlement, 8 km/h, `AUTOMATIC_TERMINAL_EGRESS=true`, Player Claim, one manoeuvre/no retry, and Terminal Egress Exhaustion.

**Live validation target:** repeat TS015 and TS016. Primary evidence is whether the vehicles now materially steer toward the logged oblique targets and whether Patriot/any assembly settles immediately after its represented compact footprint is positively outside the Field World.

---

# v4.7.115 TEST BUILD status — D-0147 Oblique Boundary Egress

Owner-declared v4.7.112 remains canonical. v4.7.115 is a production TEST refinement carrying forward v4.7.114 Terminal Resolution Commitment and 8 km/h egress. TS016 v4.7.114 disproved direct Boundary-Normal trajectory use and exposed a Positive Field-Exit Settlement implementation defect. v4.7.115 separates outward boundary reference from wheeled Exit Alignment, derives one deterministic Oblique Boundary Egress, and recognises a represented footprint wholly beyond Field World bounds as sufficient positive exit evidence. No route/angle search, alternate boundary, retry or parking behaviour is introduced.

Live validation target: repeat TS015 and TS016.

---

# v4.7.114 TEST BUILD status — decisive D-0147 Terminal Resolution Commitment

**Canonical baseline:** owner-declared v4.7.112 — SHA-256 `f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`, Git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`, 310 files. v4.7.113 remains test evidence, not canonical authority.

**Reality update:** TS015 demonstrated that v4.7.113 can complete fold -> egress when the obstruction witness remains present. TS016 exposed premature responsibility release during folding; further bench analysis showed that releasing immediately after compaction would still be unsound because later GIANTS manoeuvring demand can return through the same terminal position.

**Current production expression:** once a positive Terminal Occupancy conflict admits D-0147, the same Terminal Resolution Commitment persists through supported compaction and one nearest-outer-boundary egress regardless of transient loss of the initiating obstruction. Compaction-only settlement is removed. Egress runs at 8 km/h and succeeds only from positive current represented Field World exit; reaching the single guidance target without that witness exhausts instead of extending/retrying.

**Preserved boundaries:** `AUTOMATIC_TERMINAL_EGRESS=true` remains the development default; Player Claim pre-empts immediately and is sticky; no alternate boundary, target extension, route search, parking, King/Refuge revival or global completed-worker relocation. D-0146 behaviour is otherwise unchanged.

**Validation target:** repeat TS015 and TS016. The primary evidence is whether each admitted completed assembly folds, performs one decisive outward egress even if the current obstruction witness disappears, and settles only after its compact represented footprint is positively outside the Field World.

**Deferred:** Automatic Terminal Egress UI/final product default; baggage/literal cleanup including `Prototype22ConfigurationAuthority`; any broader external-margin model.

---

# v4.7.113 TEST BUILD status — first production D-0147 Bounded Terminal Egress attempt

**Canonical baseline:** owner-declared v4.7.112 — SHA-256 `f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`, Git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`, 310 files.

**Architecture status:** D-0147 remains settled and unchanged. This tranche is implementation only. GIANTS Completion Acceptance remains the default disposition; Terminal Egress is an optional bounded exception to a positive Terminal Occupancy obstruction.

**Current production expression:** `AUTOMATIC_TERMINAL_EGRESS=true` by development default; completed-worker observation persists beyond genuine completion; Situation owns Terminal Occupancy; Candidate owns mandatory supported compaction and the single nearest-outer-boundary objective; Commitment/Authority distinguish post-job from productive actuation; Control performs compaction, stops for fresh Situation reassessment, then at most one supplied outward manoeuvre. Player Claim (`vehicle:getIsEntered()`) pre-empts every direct drive call and is sticky. Exhaustion escalates without retry/search.

**Compatibility:** active-job Player Takeover remains the established Job Episode termination path and is deliberately kept separate from post-completion Player Claim. D-0146 Cooperative Passage ownership and behaviour are otherwise unchanged.

**Validation:** 109/109 Python structure/conformance tests; 227/227 Lua replacement-core behavioural/conformance tests; repository-wide Lua parse pass. Live GIANTS evidence is still required before any canonicalisation decision.

**Deferred:** UI for Automatic Terminal Egress and the eventual user-facing default; baggage/literal cleanup including `Prototype22ConfigurationAuthority`; any broader external-margin model.

---

# v4.7.112 CANONICAL status — D-0147 Bounded Terminal Egress architecture

**Canonical baseline:** owner-declared v4.7.109 (`ea0b399e2f73759fa29982fc1b85d5bf446f6fd90eb324dec2902b333c7c6a74`; Git `cd9085ee40343d542a66b84948c27f7dd91a40c7`; 310 files).

**Canonical character:** architecture/documentation and release identity only. No Terminal Egress production code, no passage-planning change and no traffic/Control behavioural algorithm change is introduced relative to canonical v4.7.109. Disposable v4.7.110/v4.7.111 probes are evidence only.

**Accepted architecture:** D-0147 retains GIANTS Completion Acceptance by default and permits an optional bounded exception only when a completed unclaimed assembly positively obstructs continuing active demand: compact to the minimum supported transit footprint, then if still necessary attempt one simple continuous outward manoeuvre toward the locally nearest Field Boundary. Player Claim pre-empts immediately; exhausted/unsupported egress transfers responsibility to the player.

**Explicit complexity boundary:** no Terminal Clearance Region search, parking optimisation, field-centre relocation, alternate-boundary search, repeated manoeuvre escalation, global completed-worker relocation or King/continuous Refuge revival.

**Configuration boundary:** Automatic Terminal Egress must be user-configurable. `Off` preserves canonical v4.7.109 completion behaviour. Default On/Off is not selected by this candidate.

**Evidence boundary:** FieldCourseSettings (`workHeadlands`, `headlandsFirst`) are optional positive intent evidence when available; ordinary default-start jobs may expose no settings object, so absence remains unknown and the capability must satisfy Zero-Configuration Compatibility.

**Next activity after canonicalisation:** implementation discovery only if selected. Start with compaction plus one boundary-relative outward control expression and stop if Reality demands route search or proliferating scenario branches.

---

# v4.7.109 CANONICAL CANDIDATE status — three-worker stability plateau

**Canonical baseline:** v4.7.102 (`f85256dd...597b`; Git `cf514983...`; 310 files).

**Live validation carried forward from v4.7.108:** five Cooperative Passages settled `SUCCEEDED`, all 25 Passage Guide gates were reached, no Passage Reassessment or safe-abandon escalation occurred, and no OuttaMyWay Lua error stack was observed. The tested scenario includes Condor, Patriot and S 416 with Operation-aware pairwise passage, optional per-participant configuration reduction, third-party Passage Support, Resolution-Space Conservation and Settled Relationship Dissolution.

**Candidate delta from tested v4.7.108:** release/provenance/version only. No passage planner, Candidate, Decision, Commitment, authority, Regulation-admission or Cooperative Passage Control behavioural algorithm is intentionally changed.

**Canonicalisation boundary:** review only the exact v4.7.109 candidate fingerprint and evidence package. v4.7.102 remains canonical until the repository owner explicitly declares this candidate canonical.

---

# v4.7.108 FINAL CORRECTIVE TEST status — Settled Relationship Dissolution

**Canonical baseline:** v4.7.102 (`f85256dd...597b`; Git `cf514983...`; 310 files).

**Latest live evidence (v4.7.107):** the three-worker scenario is stable: five Cooperative Passages settled `SUCCEEDED`, both Condor and Patriot completed their jobs, and no return of stale open-field follower Regulation was observed. The remaining defect was Regulation release/reacquisition while the manoeuvring participant was still `TURN_SEGMENT` / `TURNING`.

**Current correction:** Situation may positively dissolve a non-opposed trajectory relationship only after both participants show valid Settled Continuation with positive non-turn productive-line evidence. Transitional continuation is retained as unresolved relationship change and cannot release the conserved Resolution Space. Actual post-passage ordering still dissolves immediately.

**Preserved unchanged:** Action-Space admission, 8 km/h bounded conservation cap, Trajectory Persistence, Step-2 passage planner, Optional Configuration Reduction, S 416 `RETAIN_CURRENT`, Operation-aware third-party Passage Support, sealed Candidate traversal, stale D-0141 retirement, and Cooperative Passage Control mechanics.

**Release discipline:** this is the last planned corrective build. Clean live evidence should lead directly to a fresh canonical candidate. One contingency corrective build is reserved only for a genuinely blocking defect. Nice-to-have enhancements are not part of this test.

---

# v4.7.107 TEST BUILD status — Resolution-Space Obligation Persistence

**Canonical baseline:** v4.7.102 (`f85256dd...597b`; Git `cf514983...`; 310 files).

**Live evidence:** v4.7.106 applied the desired early Patriot Regulation but released it during Condor's temporary reverse/non-closing boundary manoeuvre. Patriot accelerated and consumed the passage-development reserve; the final Condor/Patriot encounter was almost, but not fully, resolved.

**Current implementation:** Current Excursion remains an admission witness only. Once admitted, the Resolution-Space Conservation obligation persists until positive relationship invalidation or Step-2 succession. Situation owns the positive-dissolution semantic record; Control no longer equates disappearance of the initiating witness with purpose completion.

**Preserved:** v4.7.105/v4.7.106 S 416 passages, Optional Configuration Reduction, Operation-aware third-party Passage Support, stale follower-purpose correction, Trajectory Persistence and the 8 km/h bounded test cap.

**Live validation required:** confirm the Regulation survives the temporary boundary reverse and hands the same Commitment to Step 2 with sufficient passage space.

---

# v4.7.106 TEST BUILD status — D-0146 Current-Excursion Action-Space Conservation

**Canonical baseline:** owner-declared canonical v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files).

**Latest live evidence (v4.7.105):** two S 416/sprayer passages and one Condor/Patriot passage succeeded; no false open-field follower Regulation was observed. The final Condor/Patriot head-on exposed late Step-2 action after a Current Excursion consumed the existing Local Passage entry reserve.

**Current test implementation:** one Current Excursion may produce Potential Opposed Corridor Conflict and bounded Resolution-Space Conservation Regulation when positive current corridor/closure evidence shows a stable participant is consuming the 80 m Local Passage envelope. Trajectory Persistence remains unchanged. Regulation either releases on purpose dissolution or succeeds into the same D-0146 Commitment when Step 2 becomes supported.

**Preserved:** v4.7.105 sealed-value Control bridge, Optional Configuration Reduction, S 416 `RETAIN_CURRENT`, Operation-aware third-party Local Spatial Constraints/Passage Support, and prompt stale D-0141 follower-purpose retirement.

**Not in this build:** Unilateral Passage Execution refinement; final-few-metres single-worker `VALID_BLOCKED_ZERO_COMMAND` remains separate.

**Validation status:** offline behavioural/structural/RRS/package validation required before handoff; live GIANTS evidence remains final authority for whether earlier bounded Regulation actually preserves sufficient passage-development space.

---

# v4.7.105 TEST BUILD status — D-0146 Optional Configuration Reduction

**Canonical baseline:** v4.7.102 (`f85256dd...597b`; Git `cf514983...`; 310 files).

**Live evidence:** v4.7.103 disproved the implementation assumption that a GIANTS fold interface implies a meaningful Compact Configuration. Patriot/S 416 entered D-0146 Step 2, both were held, and the run remained in `COMPACTING`. S 416 has no passage configuration to reduce.

**Current implementation:** configuration reduction is now Candidate-planned per participant and optional. Control acts only on `COMPACT_REQUIRED`, leaves `RETAIN_CURRENT` untouched, and restores only configuration it changed. The v4.7.103 Operation-aware third-party passage support and stale follower-purpose corrections remain active.

**Validation status:** offline regression complete; live three-worker validation pending.

---

# v4.7.103 TEST BUILD status — D-0146 Step 2 Operation-aware implementation catch-up

**Canonical baseline:** v4.7.102 — SHA-256 `f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`, Git `cf51498316714c568b75ee6e65dab544ccbe7af3`, 310 files.

**Architecture:** D-0146 remains governing and unchanged. Step 1 is live validated. Step 2 is active and was live validated for three Condor/Patriot passages in v4.7.101/102 lineage. The 2026-08-13 three-worker run exposed implementation specialisations rather than an architectural gap.

**v4.7.103 implementation:**
- vehicle-name-independent Step-2 mechanical preflight; Control retains actual capability authority;
- Operation-aware Local Passage Space with other active assemblies as positive current spatial constraints;
- dynamic third-party Passage Support revalidation;
- D-0146 positive relationship succession retires stale D-0141 follower purpose before Candidate selection.

**Still bounded:** generic negative-clearance authority is not claimed; static-obstacle/boundary-margin support is no broader than existing D-0146 implementation; passage remains a pair Commitment, not a three-way route planner; final-few-metres single-worker blocked-zero-command remains separate.

**Next evidence:** rerun the three-worker scenario and inspect Condor/S 416 admission, third-party constraint/reassessment behaviour, and follower-regulation retirement.

---

# v4.7.102 canonical-candidate status — Step 2 live supported, byte identity reset

**Owner-declared canonical baseline:** v4.7.99 (`c3f1f6493fd0e44c8447637827989117daa77a20ba80816cf34270484e5eea8d`; 307 files).  
**Current candidate:** v4.7.102.

- D-0146 Step 1: **IMPLEMENTED + LIVE SUPPORTED**.
- D-0146 Step 2: **IMPLEMENTED + LIVE SUPPORTED for the bounded Condor/Patriot mechanical profile**.
- Live TS015 evidence: three Step-2 activations, 15/15 Passage Guide gates reached, 3/3 Commitments settled `SUCCEEDED`, zero Passage Reassessments and zero safe-abandon escalations.
- v4.7.101 canonicalisation is blocked by Candidate Byte Identity Mismatch; its runtime evidence is retained as behavioural evidence, not exact-package authority evidence.
- v4.7.102 contains no Step-2 behavioural algorithm change relative to that tested implementation; it is the fresh RRS-produced candidate whose exact fingerprint must be reviewed/canonicalised.
- Python structural/conformance evidence count corrected to 79/79.
- Final-few-metres single-worker blocked-zero-command behaviour remains an explicit separate issue.

---

# v4.7.101 D-0146 Step-2 active implementation status

**Current test build:** v4.7.101 over owner-declared canonical v4.7.99.

- Step 1: **IMPLEMENTED + LIVE SUPPORTED** in v4.7.100.
- Step 2 semantic path: **IMPLEMENTED ACTIVE TEST** — Established Conflict -> Candidate-owned local passage search -> Passage Arrangement/Guide -> normal Decision/Commitment/Authority -> central Control.
- Mechanical Representation Fitness: **BOUNDED** to the P23 Condor/Patriot compact-guided profile; broader vehicle authority remains unclaimed.
- Passage arrangements: symmetric/asymmetric/unilateral burden split supported by the bounded search where positively supported by Field World.
- Passage Reassessment: safe-abandon/escalate behavior implemented for execution support loss; Control cannot silently broaden the guide.
- Diagnostic Churn from v4.7.100: **CORRECTED**.
- Offline tests: 204 Lua + 79 Python PASS before packaging.
- Next authority: live GIANTS execution evidence, not another preplanned passive implementation slice.

---

# v4.7.100 TEST BUILD status — D-0146 Step 1 implemented passively, awaiting live validation

**Canonical baseline:** owner-declared v4.7.99 (`c3f1f6493fd0e44c8447637827989117daa77a20ba80816cf34270484e5eea8d`; 307 files).  
**Build purpose:** implement the concluded Step-1 architecture without changing the proven traffic/control path.

## IMPLEMENTED IN THIS TEST BUILD

- Situation-owned Established Trajectory persistence from observed physical displacement.
- Current Excursion without immediate history destruction; sustained coherent contradictory travel can supersede the established trajectory.
- Potential / Established Opposed Corridor Conflict classification.
- Supported Corridor Overlap from existing positive cached assembly primitives; any positive overlap is sufficient conflict support.
- Passive Operational Picture publication and transition-only diagnostics.
- Map lifecycle reset of temporal trajectory Knowledge.

## PRESERVED / NOT CONSUMING STEP-1 KNOWLEDGE

- Existing bounded TS015 Cooperative Passage admission and execution.
- D-0141 follower Regulation.
- Candidate / Constraints / Decision / Commitment / Control chain.

## VALIDATION

Offline: 201/201 Lua behaviour tests PASS; 78/78 Python structural/conformance tests PASS. Live GIANTS validation has not yet been performed. The numeric persistence/filter values are provisional empirical calibration and have no architectural or action-selection authority.

## STILL OUTSIDE THIS BUILD

Generic Step-2 Local Passage Space discovery, Boundary Encroachment planning, arbitrary Passage Arrangement/Guide construction, nominal-clearance/swept-occupancy proof, Passage Reassessment, broad configuration support and wider live regression coverage remain outside this implementation slice.

# v4.7.99 candidate status — D-0146 architecture recorded, implementation intentionally unchanged

**Canonical baseline:** v4.7.98 (`105462f44b902312e5dc63c6176d44f848f15c1466d942a4bee70635ced6cd69`; Git `982992b926839c854f6d4d7979fe24885e267eae`; 307 files).  
**Candidate purpose:** canonicalise the Step-1/Step-2 Cooperative Passage architecture discovered after v4.7.98 before moving collaboration to a new chat.

## PROVEN / LIVE

- v4.7.98 bounded TS015 Condor/Patriot Cooperative Passage production path remains unchanged and is the only live-proven passage implementation.
- D-0141 follower Regulation remains live and may preserve Action Space while intent/trajectory matures.
- Candidate/Constraint/Decision/Commitment/Control ownership and immediate successful handoff settlement remain proven.

## ACCEPTED ARCHITECTURE, NOT YET IMPLEMENTED

- Established Trajectory + Current Motion + Current Excursion + Trajectory Persistence.
- Potential / Established Opposed Corridor Conflict and categorical Supported Corridor Overlap.
- Productive/Transitional/TURN_SEGMENT demoted from binary Step-1 gate to contextual evidence.
- Passage Presumption, Local Passage Space, Boundary Encroachment, asymmetric/unilateral burden and lane departure.
- Passage Arrangement, Pairwise Passage Economy, Passage Sufficiency / Progressive Passage Search.
- Nominal Inter-Assembly Clearance, Passage Development/Traversal/Reacquisition Distance and Manoeuvre Swept Occupancy.
- Passage Guide and Passage Reassessment.

## UNRESOLVED / NOT AUTHORISED

- numerical trajectory-persistence/filter calibration;
- exact implementation representation of trajectory corridors and uncertainty;
- generic local-space search and terrain/static-obstacle evidence surface;
- general nominal-clearance calibration;
- arbitrary assembly/configuration support;
- dynamic Passage Guide construction and GIANTS steering interface;
- support-loss detection/reassessment mechanics;
- broader regression suite.

**Health warning:** accepted D-0146 architecture is not evidence that these implementation capabilities exist.

---

# v4.7.98 CANONICAL CANDIDATE — Progressive Situational Sufficiency Consolidation

**Owner-declared canonical baseline:** v4.7.95  
**Canonical ZIP SHA-256:** `1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`  
**Canonical Git commit:** `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`  
**Canonical repository files:** 305  
**Candidate repository files:** 307 before packaging; the two additions are the production `CooperativePassageAssessment.lua` and `CooperativePassageControl.lua` introduced by the successful v4.7.97 lineage.

## Candidate character

v4.7.98 is a controlled canonicalisation/consolidation candidate. It starts from exact canonical v4.7.95, reapplies the live-successful v4.7.97 bounded TS015 implementation, and removes only live runtime sourcing for architectural machinery now explicitly retired by D-0144. It is not a general refactor.

The proven physical manoeuvre, current TS015 admission calibration, D-0141 follower Regulation, purpose-specific Representation Fitness, Candidate/Constraint/Decision/Commitment ownership, P22 physical donors and immediate GIANTS handoff are intentionally unchanged from v4.7.97.

## Live evidence carried forward

The v4.7.97 TS015 run automatically admitted and completed two production Cooperative Passages, at approximately 68.49 m and 69.93 m separation. In both cases Situation Assessment supported the bounded class, the joint Candidate was published, all mandatory constraints passed, Control started, both workers passed, and the same Job Episodes were handed back with no cooldown.

The same run also exercised D-0141 follower Regulation before the second passage. Cooperative Passage superseded the existing follower purpose/lease under the same traffic responsibility instead of being blocked by it.

The final convergence was physically close to the demonstrated near-collinear geometry but remained Productive/Transitional in Situation Assessment because one worker was still `TURN_SEGMENT`. Cooperative Passage was therefore withheld. That is a known authority-envelope boundary, not permission to weaken the classification gate.

## D-0144 current Situation model

Situation Assessment should acquire only enough positively supported Knowledge to justify the next least-authority action. The current production direction retains:

- Field World / Operation / Job Episode identity;
- assembly/configuration and bootstrap-cached physical representation;
- current Productive or Transitional state;
- current motion/heading and Encounter/cooperative relevance;
- current obligations / Committed Demand;
- Turning Rank as optional spatial awareness for early observation/Regulation, not turn-route prediction;
- D-0141 observation/Regulation and D-0143 bounded Cooperative Passage.

Retired from governing production architecture:

- Rook as a required governing productive-space structure;
- Successor Rook Set / successor-productivity prediction;
- chessboard colouring and continuous Productive History reasoning;
- King Reserve and continuous Refuge search/qualification;
- headland-U-turn as a dedicated scenario/solver class.

The historical productive-coverage/refuge-shadow diagnostic files remain evidence donors, but v4.7.98 no longer sources or schedules them in the live runtime. No new shape calculations replace them.

## Cooperative Passage Scope Boundary — health warning

**Current status: bounded Cooperative Passage production capability demonstrated; general Cooperative Passage incomplete.**

Known unfinished work:

1. Transitional/Productive opposed encounters remain unresolved. The final v4.7.97 encounter looked physically supportable but did not have the current positive semantic authority.
2. Asymmetric encounters are not generally supported. Earlier P23 evidence remains a valid negative boundary even though later intervention timing changed the geometry of a subsequent final encounter.
3. Other assembly combinations are unvalidated. Foldability or compact size alone does not imply Cooperative Passage capability.
4. The 50-70 m start window, 2 m lateral gate, +/-6 m split, 12 m shallow entry/rejoin, 8 m pass margin, 8 km/h cap and target radii are TS015 implementation calibration, not architecture.
5. General negative-clearance authority remains incomplete. The bounded TS015 path reuses purpose-specific fitness from bootstrap-cached `physicalSpaceEvidence`; it does not prove arbitrary compact assemblies can pass.
6. Wider historical regression scenarios still need to be engineered against the simplified architecture.

No candidate or future chat should interpret "Cooperative Passage works" as "Cooperative Passage is complete."

## Immediate next objective after canonicalisation

Do not broaden behaviour in this candidate. After owner review/canonicalisation, the next architectural question is narrow: whether a positively supportable **Transitional/Productive near-collinear opposed conflict** may enter Cooperative Passage without collapsing the Productive/Transitional distinction. Broader regression scenario engineering follows in due course.
