## D-0166 — Checkpoint the Passage tranche and simplify the next configuration policy

**Decision:** prepare v0.1.4.0 as a canonical checkpoint consolidating v0.1.3.1-v0.1.3.7 without new behavioural algorithm changes. Outstanding Passage defects are retained explicitly rather than solved speculatively during canonicalisation.

**Accepted next direction:** **Transit-First, Reality-Verified Passage.** At physical Passage Entry, attempt a plausible Transit configuration unless positive configuration evidence excludes that mechanism; verify the actual resulting state before using Transit geometry. Missing `allowUnfoldingByAI` or equivalent metadata is not sufficient negative evidence. If Transit cannot be achieved, replan from verified current/conservative geometry. Do not reintroduce vehicle-specific IF/THEN configuration exceptions.

**Evidence:** late Passage Entry, directional clearance and generic unilateral allocations materially improved gameplay and reduced agronomic debt in TS010/TS015/TS016. However TS009 front/rear SaMASZ mower + S416 was incorrectly authorised as a straight retained-current Passage and physically collided/tangled. The same run reported only two assembly members for an apparently three-member physical combination. This negative evidence lowers confidence in current generic complex-assembly negative-clearance authority.

**Non-decisions:** do not yet choose the cause of the TS009 membership anomaly; do not implement fold-vs-don't-fold optimisation; do not alter the ~1 m policy margin; do not add articulation sweep allowance; do not implement agronomic reverse restoration or exact finishing alignment in this checkpoint.

---

## D-0165 — Nominal Passage Clearance is scoped to the Crossing Window

**Decision:** correct D-0146 pair-sweep validation so Development and Recovery require represented non-contact but do not require the full nominal Passage clearance. Full nominal clearance remains mandatory from Crossing Window Entry through Crossing Window Exit.

**Evidence:** v0.1.3.6 TS010 committed passages completed successfully while concurrent fresh Candidate assessment rejected all arrangements under the obsolete global nominal-clearance rule.

**Non-decisions:** do not change the 1 m policy value, directional-envelope representation, Passage speed, configuration selection, orientation recovery or agronomic restoration in this tranche.

## D-0164 — Restore configuration reachability abstraction in directional Passage geometry

**Decision:** correct v0.1.3.5 Mechanical Foldability Leakage. Do not use raw `spec_foldable` as sufficient reason to suppress directional member evidence. Explicit GIANTS AI-unreachable fold metadata may establish that a mechanical accessory is not a Passage configuration alternative. Preserve existing native-profile configuration selection and all Passage policy. Add bounded rejection telemetry before changing any remaining suspected constraints.

## D-0163 — Test generic directional member-union Passage geometry

**Decision:** accepted for v0.1.3.5 TEST. Generalise the successful single-member GIANTS base-size Passage envelope by unioning member directional rectangles at their actual configured poses. Preserve one-sided left/right and front/rear extents. A member lacking applicable directional metadata falls back individually to conservative represented-DISC extent; the assembly falls back wholly to the previous DISC path only when no directional member evidence exists.

**Reason:** mixed S416 Passage field evidence showed that whole-assembly sphere-conditioned reserve can be substantially less credible than the successful Condor/Patriot directional model. The repository already owns member discovery, diagnostic oriented rectangles and one-sided Facing Clearance Extent; the experiment tests whether those existing concepts generalise cheaply before adding articulation sweep allowances.

**Not decided:** no change to 1 m nominal clearance, no swept-volume model, no per-vehicle rules, no configuration optimisation, and no agronomic reverse restoration.

---


## D-0162 — Retire causal Hold witness from Passage settlement

**Decision:** accepted for v0.1.3.4 TEST. `CooperativePassageControl` must advance from `SETTLING` when Passage Hold authority is active for both participants and both are physically stationary at the existing threshold. PermissionGate call count is not a settlement invariant.

**Evidence:** TS016 v0.1.3.3 Condor–S416 entered Passage at close range after GIANTS had already set Condor blocked/zero-command. Both participants stopped, but Condor's PermissionGate count remained zero because the wrapper correctly preserves GIANTS' prior refusal; configuration never began and Condor remained unfolded. The same `_allStopped()` causal-proof requirement predates the Passage Excursion work and is therefore a latent defect exposed by later Passage Entry.

**Boundary:** no suppression/override of GIANTS `isBlocked`; no Entry change; no configuration special case; no geometry or directional-envelope change.

---

## D-0161 — Test GIANTS base-size metadata as a directional Passage envelope

**Decision:** accepted for v0.1.3.3 TEST. Preserve the nominal 1 m Passage clearance and the v0.1.3.2 Passage execution. Where a single-member selected Passage configuration is stably folded (or non-foldable) and GIANTS `vehicle.base.size` can be read at bootstrap, use its coarse width/length for Passage pair contact, Crossing Window and pair-sweep planning. Fall back to the existing configuration-conditioned DISC geometry otherwise.

**Evidence:** TS015 v0.1.3.2 physically succeeded but planned `contact≈9.22 m` / `required≈10.22 m`; supplied GIANTS XML declares Condor 3.5 x 11.1 m and Patriot 3.9 x 9.0 m. Lowering the 1 m policy margin would hide a representation problem rather than solve it.

**Boundary:** no global replacement of DISC interaction evidence; no attached-assembly envelope synthesis; no change to folding policy, Development, speed, Reacquisition or agronomic restoration.

---

## D-0160 — Restore immediate Resolution-to-Passage succession; delay execution, not Commitment

**Decision:** accepted for v0.1.3.2 TEST. Positive Cooperative Passage Selection immediately supersedes D-0155 as it did in canonical v0.1.3.0. A later Passage Entry is represented by `PASSAGE_APPROACH` inside the Passage Commitment. After settling/configuration, absolute participant guide origins are captured from Reality before the first short Development target is issued.

**Why:** TS010 v0.1.3.1 showed two independent defects: retaining 1 km/h Resolution-Space regulation after Passage Selection produced gross approach asymmetry; then stopping overshoot placed MT665 beyond its first short forward-only waypoint. Increasing Development would hide the second defect and retaining D-0155 contradicts the already-validated authority handoff.

**Out of scope:** no reverse Agronomic Restoration, no selective folding/configuration candidate optimisation, no burden-allocation redesign, no Passage speed change.

---

## D-0159 — Test delayed Passage Entry and a physical Passage Excursion Envelope (v0.1.3.1 TEST)

**Evidence:** TS010 Passage succeeds physically but begins control far too early, carries a large/long lateral offset, and leaves conspicuous missed mower work. Audit showed the current guide is already a crude trapezoid: the P23 donor `12 m` Development, separation-derived long plateau, `+8 m` post-centre margin and `12 m` reacquisition. The `12 m` donor was originally evidence that a 6 m sprayer sidestep needed a shallow forward-only approach; it is not evidence that a ~1 m participant excursion needs 12 m.

**Decision:** keep existing Passage admission/evidence, D-0155 succession, configuration-first selection, burden ordering, 8 km/h guide speed and Native Reacquisition unchanged. Separate **Passage Selection** from **Passage Entry**. Before Entry, retain the already-validated Resolution-Space action. At Entry, execute a bounded **Passage Excursion Envelope**: derive non-negative Clearance Deficit; Development creates only that required lateral relationship; maintain it through a **Crossing Window** derived from represented longitudinal extents; Recovery returns lateral displacement toward zero/native axis.

**Clearance semantics:** nominal ~1 m remains calibration, not a geometric destination. If current selected-configuration geometry already supplies sufficient natural clearance, lateral excursion is zero. Do not move inward to manufacture exactly 1 m.

**Entry mechanics for this TEST:** derive an Entry Boundary from represented front extents + twice derived Development + provisional 3 m control allowance, using **longitudinal projected pair separation**. The 3 m allowance is test calibration only and is not braking/stopping-distance authority. Development retains the P23 shallow `2 m forward : 1 m lateral` donor with a small 4 m minimum floor for the first experiment; these are implementation mechanics subject to Reality.

**Crossing completion:** represented front/rear longitudinal extents replace the inherited fixed `+8 m` traversal margin. Control logs a second-whistle marker after the pair-dependent guide has crossed and recovered. Existing configuration restore / Native Reacquisition remain after that marker for this experiment; participant-independent settlement is not yet implemented.

**Explicitly out of scope:** reverse Agronomic Restoration; exact debt recovery; selective folding/configuration economy; one-vs-both/asymmetric burden redesign; Passage speed; admission/current-motion semantics; D-0155; D-0147; the parked `<=60 m` locality issue.

**Validation claim sought:** materially shorter productive interruption, a visibly shallower or zero lateral excursion where geometry permits, full displacement only through physical crossing, return toward native lateral axes, no contact, and preservation of the validated TS010 Resolution-Space -> Passage succession. Remaining missed work is evidence for the next Agronomic Restoration decision, not a failure to have solved it in this build.

---

## D-0158 — Promote validated Resolution-Space Progression Envelope to v0.1.3.0 canonical candidate

**Decision:** consolidate the cumulative v0.1.2.1/v0.1.2.2 D-0155 implementation without additional behavioural change. Retain 75% Resolution Contingency Reserve, integer Supportable Progression, Reverse-Created Resolution Reserve protection, Magnitude Rebase on Role Migration, continuous Commitment-lifetime magnitude updates and the 1 km/h Intent-Revelation Creep endpoint.

**Evidence:** TS010 successfully transitioned from conservation through 1 km/h creep into existing Cooperative Passage and normal MT665 completion; TS015 completed fully; TS016 validated the relevant traffic behaviour. The TS016 final terminal move was intentionally unavailable after genuine post-completion Player Claim. Magnitude Freeze did not recur.

**Separation of concerns:** no Passage change, no `<=60 m` locality fix, no D-0147 Player-Claim timeout/reset, no Recovery change and no pacing optimisation are included. Those observations remain separate.

**Next:** review Cooperative Passage in extenso and examine its literals against the actual architectural problems of conflict clearance, protected transit, productive reacquisition and agronomic continuity.

---

## D-0157 — Correct Magnitude Freeze and test 1 km/h Intent-Revelation Creep (v0.1.2.2 TEST)

**Evidence:** TS010 v0.1.2.1 showed the D-0155 envelope behaving constructively during approach, then freezing at 15 km/h while `currentClosing` became unresolved during the mower's native reverse/forward manoeuvre. The sticky D-0146 Commitment survived. Later, zero-cap Hold removed MT665 current motion and the encounter deadlocked before existing Passage maturation succeeded.

**Decision 1 — Magnitude Freeze is an implementation/alignment defect:** Candidate publication is not required to keep re-authorising magnitude once the D-0146 Commitment exists. Control must continue updating the active envelope until positive Situation release/supersession. When motion-derived closing separation is unavailable, Control may use the pair's current reference-pose separation already present in `OperationalPicture.currentSpace`. This does not create Situation knowledge or release authority.

**Decision 2 — Intent-Revelation Creep is experimental policy, not settled Passage architecture:** retain **1 km/h** Regulation when the raw envelope reaches zero while the same intent-revelation obligation remains unresolved. This deliberately trades a small amount of contingency distance for continued motion evidence and resolution opportunity. Genuine Hold remains available to other responsibilities; D-0146 Passage itself is unchanged.

**Unproven interpretation retained as uncertainty:** Passage may require current opposed motion partly to exclude stationary obstacles, but repository evidence does not presently prove that design intent. Do not weaken Passage evidence semantics on this hypothesis. First test whether minimal positive motion allows the existing contract to mature.

**Unchanged:** provisional 75% contingency reserve; Reverse-Created Resolution Reserve; Magnitude Rebase on Role Migration; Situation admission/relevance; Safe Release; Pre-Productive Intent Relevance; Cooperative Passage mechanics/succession; D-0154 Recovery; 80 m locality; D-0147.

---

## D-0156 — Implement D-0155 with Control-owned magnitude and a provisional 75% contingency reserve (v0.1.2.1 TEST)

**Decision:** implement the smallest Resolution-Space Progression Envelope against owner-declared canonical v0.1.2.0. Use a provisional 75% Resolution Contingency Reserve for this TEST tranche; retain the 80 m Situation locality ceiling separately.

**Authority-Layer discovery — Magnitude Leakage:** the prior implementation let Situation Assessment select `requestedCapKmh=8` and decide candidate support partly from that magnitude. This conflated “does the Resolution-Space obligation exist?” with “what current Control magnitude expresses it?”. Situation now owns obligation/relevance and regulated/protected role selection only; Control owns elastic progression magnitude.

**Control expression:** establish `D0` from current usable pair separation, withhold `C=0.75*D0`, set ordinary allowance `S0=D0-C`, and seed the policy trajectory from current constrained-participant progression `u`. For remaining ordinary allowance `r`, derive `v_raw=u*sqrt(r/S0)` (equivalent to the D-0155 zero-terminal policy form) and floor to a whole integer km/h. Zero is Hold within the same envelope; it is not a separate escalation state and does not require proof that a previous cap was physically realised.

**Reverse-Created Resolution Reserve:** during the same unresolved Situation, conservative authorised separation may tighten but cannot grow. Positive physical space gained by the protected/uncertain participant reversing is bonus reserve and is consumed again before ordinary progression authority can increase.

**Magnitude Rebase on Role Migration:** role migration retains the same Commitment and absolute contingency reserve, preserves already-consumed ordinary capacity, samples the newly regulated participant's current progression and reconstructs only the remaining policy trajectory. Role change does not manufacture new Resolution Space.

**Retired implementation semantics:** generic fixed 8 km/h authority; Situation suppression because current native progression is <=8; `cap realised + still closing => Hold`; and transient non-closing as an automatic restoration to the old fixed cap. Positive Safe Release / Intent Supersession remains Situation-owned.

**Scope boundary:** no Resolution-Space Recovery implementation; no change to Operational Membership, Pre-Productive Intent Relevance, Cooperative Passage mechanics/succession, Safe Release, 80 m locality or D-0147. Validate TS010 first, then TS015/TS016.

**Bench evidence:** 254/254 Lua behavioural, 96/96 Python structural and 25/25 RRS tests pass before live field validation.

---

## D-0155 — Replace fixed Resolution-Space speed authority with a Progression Envelope

**Decision:** the future generic D-0146 Resolution-Space Control magnitude must not be a fixed speed such as 8 km/h. While the obligation remains live, use a coarse **Resolution-Space Progression Envelope** whose terminal condition is zero ordinary progression before a deliberately withheld Resolution Contingency Reserve.

**Reasoning:** TS010 showed that a fixed cap can be physically realised only after substantial Resolution Space has already been consumed. Precise GIANTS braking-response modelling would add false precision. A state-derived policy envelope preserves the objective — buy time/opportunity while maximising Productive Continuation — without claiming to model vehicle physics.

**Candidate form:** from constrained-participant current progression `u` and ordinary authorised distance `S0`, derive `a_p = -u^2/(2*S0)` with terminal progression zero. Remaining ordinary authorised space `r` yields raw Supportable Progression `sqrt(2*abs(a_p)*r)`. `a_p` is a policy trajectory parameter, not physical deceleration. Control uses a conservative integer-km/h cap; zero means Hold.

**Resolution Contingency Reserve:** withhold an explicit percentage of established usable Resolution Space before constructing ordinary progression allowance. The concept is accepted; exact percentage is unresolved calibration. Do not automatically inherit historical 0.90.

**Persistence:** Situation/Commitment owns purpose. Temporary reverse/forward manoeuvring does not release/recreate the obligation. Positive separation produced by the protected/uncertain participant becomes Reverse-Created Resolution Reserve rather than immediate progression authority. Positive changed Reality may release, supersede into Passage/native continuation, or rebase.

**Passage boundary:** Resolution Space is not Passage Space. The envelope buys Intent-Revelation Opportunity. Once Cooperative Passage is positively supportable, normal Passage authority supersedes the uncertainty envelope.

**Implementation status:** architecture only in v0.1.2.0. The inherited 8 km/h runtime remains unchanged until a separate implementation/test tranche.

---

## D-0154 — Treat Resolution-Space Recovery as a Policeman Reposition tool

**Decision:** Resolution-Space Conservation and Resolution-Space Recovery are distinct responsibilities. Regulation/Hold preserve option space prospectively. If usable option space has already been lost, the Policeman may eventually select `REPOSITION` to recover it rather than holding a permanent deadlock.

**Candidate physical expression:** **Back-Out Recovery** may retrace a bounded participant toward recently demonstrated clear space, subject to current conflict/relevance checks, rather than inventing a route into unknown space. This is especially relevant to nose-to-nose and future static-blockage cases.

**`isBlocked` boundary:** GIANTS `isBlocked=true` may support the statement that native productive continuation is unavailable. It is not physical-obstruction proof and does not independently authorise reverse or Passage abort.

**Implementation status:** concept recorded only. Do not mix Recovery implementation into the Resolution-Space Progression Envelope tranche unless live evidence shows prevention is already too late.

---

## D-0153 — Cut v0.1.1.0 candidate at the D-0146 small-field alignment plateau

**Decision:** prepare v0.1.1.0 as a release/provenance-only canonical candidate from the exact tested v0.1.0.14 runtime. Do not add another behavioural correction during candidate preparation. Owner-declared v0.1.0.0 remains canonical until the exact v0.1.1.0 fingerprint is explicitly accepted.

**Why now:** the v0.1.0.4–v0.1.0.14 tranche produced a coherent set of generic architecture/code corrections and retained known-good TS015/TS016 passage behaviour. The remaining TS010 failure has crossed an abstraction boundary: it now challenges the empirical 8 km/h Regulation literal and the timing/response authority behind supportable progression, rather than revealing another settled passage/membership/release mismatch.

**Captured knowledge:** Pair-Specific Passage Clearance, Configuration-Released-Space authority, removal of the 50 m development surrogate, Resolution-Space role attribution/migration, reversible Regulate↔Hold, Pre-Productive Intent Relevance, and ADR-0006 Safe Release conformance remain current implementation knowledge.

**Next after canonical review:** resume the Literal Provenance Audit at the 8 km/h D-0146 Regulation family. Architecture leads: recover the requirement for response-adjusted supportable progression before choosing implementation. Do not substitute another speed literal simply because the present cap failed.

---

## D-0152 — Remove Transitional-only eligibility from D-0146 Hold escalation (v0.1.0.14 TEST)

**Evidence:** TS010 v0.1.0.13 produced a settled-vs-settled Established Opposed Corridor Conflict. Role Migration correctly assigned Regulation to the materially closing mower; the mower positively complied with the 8 km/h cap; positive closure nevertheless continued into mutual blockage. Hold never escalated because the v0.1.0.9 gate required the protected participant to remain Transitional.

**Decision:** Regulation Sufficiency is determined by the effect of realised Regulation on the current pair, not by the continuation class of the protected participant. Under a live D-0146 Resolution-Space obligation, realised bounded Regulation plus continuing positive closure may escalate the regulated participant to Hold whether the protected participant is Transitional or Settled.

**Why:** the Transitional prerequisite was prototype/context leakage from the scenario that first motivated Hold. Settled-vs-settled conflicts can consume Resolution Space just as decisively. No new literal or encounter class is introduced.

**Retained:** Hold remains reversible on positive resolved non-closing evidence; Role Migration, Pre-Productive Intent Relevance, Safe Release vetoes and Cooperative Passage are unchanged. The 8 km/h first-stage cap remains empirical and under literal review.

## D-0151 — Enforce ADR-0006 Safe Release on D-0146 relationship dissolution (v0.1.0.13 TEST)

**Decision:** an active D-0146 Resolution-Space relationship cannot be declared positively dissolved solely from a current non-opposed/settled trajectory classification when contradictory positive Safe Release evidence remains. `blocked=true` for either participant or a positive relevant Field-Bounded Future-Space intersection vetoes positive dissolution. The Commitment remains live and may revise its current Control expression.

**Why:** TS010 demonstrated both false-release forms on the 0.99 ha field. Capability effectiveness and current conflict cessation did not establish operational resolution. This is direct conformance with ADR-0006, not new fixture architecture.

**Generic boundary:** blockage does not invalidate productive intent; it invalidates blockage as release evidence. Future-Space positive evidence is used only as a veto to a positive release claim, not as negative-clearance authority.

## D-0150 — Separate Pre-Productive Intent Relevance from Cooperative Operation Membership (v0.1.0.12 TEST)

**Evidence:** v0.1.0.11 prevented pre-productive Cooperative Passage but also made the pre-productive MT665 invisible to D-0146 traffic authority, producing an immediate head-on collision despite positive physical interaction evidence.

**Decision:** retain Job-Episode productive commencement as the positive latch for cooperative Operation membership. Independently admit a same-Field-World active GIANTS field-work worker with productive commencement pending as Situation-relevant for D-0146 Resolution-Space Conservation only. The known Operation member may be Regulated/Held; the pending worker remains GIANTS-owned and cannot be folded/repositioned/Passaged. Completed or inactive workers are excluded from this class.

**Reason:** Operational Membership and Situation Relevance are distinct architectural layers. The correction lets the Policeman preserve evidence-gathering / native intent revelation without replacing GIANTS' unrevealed job-entry manoeuvre.

**Validation obligation:** TS010 must show early Regulation/Hold rather than either premature Cooperative Passage or traffic invisibility. Prior TS015/16 and completed-worker semantics remain regression constraints.

# v0.1.0.11 implementation decision — Productive commencement gates participation; Resolution-Space roles may migrate

**Evidence:** TS010 v0.1.0.10 Runs 1–3 repeatedly admitted Cooperative Passage while MT665 had never emitted a positive productive-work sample and subsequently developed constant circling. Run 6 productively commenced and passed, then a later active Resolution-Space Commitment retained Regulation on MT665 after Situation had positively reassigned the regulated role to the much faster-closing mower, ending in deadlock.

**Decision 1 — Productive Commencement Latch:** cooperative Operation participation requires one positive productive field-work commencement witness for the current Job Episode. This is latched, not continuously required: later normal turns remain participating. A new/replacement Job Episode must establish its own commencement. Before commencement the worker remains observable but cannot enter D-0146 cooperative participation merely because GIANTS lists an active job vehicle.

**Decision 2 — Resolution-Space Role Migration:** regulated/protected identities are mutable Control expression under a persistent purpose. When current Situation Assessment changes them for the same D-0146 governing requirement, retain the Commitment and obligation, acquire/apply the new role's bounded authority first, then release the old role. Do not create a new conflict or settle/recreate purpose solely to change roles.

**Retained decision:** v0.1.0.10 reversible Hold remains. Role migration resets the newly selected participant to the current bounded Regulation expression; subsequent positive sufficiency evidence may escalate/de-escalate normally.

**Regression principle:** evaluate both corrections against prior scenarios. Retained TS015/16 logs show productive commencement before their successful passages and no Action-Space leases, so their known-good paths are not exercised by the new mechanisms.

# v0.1.0.10 implementation decision — Resolution-Space Hold must be reversible

**Decision:** an active D-0146 Resolution-Space obligation may express Regulation or Hold according to current positive Situation evidence. A Hold is not latched for the lifetime of the Commitment. When Situation positively establishes resolved non-closing, Control reapplies the prior bounded Regulation cap while retaining the obligation and authority. Renewed positive closure may re-escalate.

**Reason:** TS010 v0.1.0.9 showed one-way Hold persistence can turn the regulated participant into a stationary obstruction after the immediate closure threat has ended. Obligation persistence remains correct; sticky physical Hold does not.

**Evidence contract:** de-escalation requires Situation-owned `currentNonClosingPositive=true` backed by resolved current closing evidence. Absence of positive closure, unavailable motion, or transient classification alone is insufficient.

**Regression/generality:** prior TS015/16 logs were checked before implementation; their successful Cooperative Passages never entered D-0146 Action-Space Regulation/Hold. The change is owner-scoped to `D0146_ACTION_SPACE_CONSERVATION`; Cooperative Passage and D-0147 Holds remain untouched.

**Not decided here:** the 8 km/h calibration remains under review; Guide Development Non-Convergence and D-0147 Courtesy Exhaustion remain separate.

# v0.1.0.9 implementation decision — Regulation must prove sufficient or escalate to Hold

**Evidence:** TS010 v0.1.0.8 Run #4 positively applied the 8 km/h Resolution-Space cap to the correct participant, yet separation continued to collapse while the protected participant remained Transitional and no supported Passage expression emerged.

**Decision:** retain Regulation as the least initial intervention, but do not equate cap application with Resolution-Space conservation. Under the same D-0146 purpose, zero-speed Hold is authorised only after Control-execution evidence confirms the regulated participant has reached the admitted cap and Situation still positively reports closure with the protected participant Transitional.

**Non-decision:** 8 km/h is not promoted to policy and is not replaced in this tranche. Variable/calculated regulation speed remains a separate literal/history review question. No new distance/time trigger is introduced.

**Abstraction boundary:** Hold conserves Resolution Space; it does not resolve the opposed spatial relationship. Cooperative Passage remains the preferred spatial resolution when a supported expression exists.

# v0.1.0.8 implementation decision — Closure contribution is pair-relative, not gear-relative

**Observation:** after a successful TS010 v0.1.0.7 Cooperative Passage and normal handoff, GIANTS created a new conflict by reversing the MT665 toward the mower. Both participants could be reversing while the pair closed rapidly. The Established-conflict Resolution-Space selector nevertheless reported no usable native forward rate because `moveForwards=false` was excluded.

**Decision:** do not special-case reverse and do not reconnect the new conflict to the completed passage. For Established opposed conflicts, Situation computes each participant's current **native closure contribution** by projecting its GIANTS native command direction onto the instantaneous pair axis. Reverse is represented by the sign of `moveForwards`; it is neither forbidden nor privileged.

**Role rule:** preserve the existing Settled-vs-Transitional preference where applicable. When continuation classes are equivalent, defer the participant with the greater positive pair-closing contribution. A command moving laterally or away from the peer cannot become the regulated role merely because its speed magnitude is high.

**Control consequence:** Regulation still changes only the speed ceiling and preserves GIANTS route, steering and forward/reverse choice. No Hold escalation is introduced in v0.1.0.8; runtime TS010 first tests whether correct attribution is sufficient.

**Architecture status:** implementation correction against existing Resolution-Space Conservation / Conflict Serialization. No new top-level architecture concept is created.

# v0.1.0.7 implementation decision — Native blocked is observation, not standalone Passage Support Loss

TS015 v0.1.0.6 disproved the assumption that GIANTS `isBlocked=true` positively proves physical obstruction during an OuttaMyWay Cooperative Passage. The signal remains valid observation evidence and is not removed globally. D-0146 Control no longer lets that signal independently fail a Candidate-proven guide.

A D-0146 guide failure now preserves the current configuration while both participants are held. Failure restoration must not enlarge an assembly inside the unresolved conflict. This is an implementation correction to fail-safe behaviour, not a new passage architecture.

# v0.1.0.6 implementation decision — Configuration-Released Space before lateral displacement

**Observation:** v0.1.0.5 passage succeeded while the deployed offset mower became positively blocked during Candidate-owned traversal.

**Decision:** restore configuration reduction as a first-class D-0146 planning expression, but only from **AI-Reachable Productive Configuration** evidence. Mechanical foldability alone is insufficient. A configuration profile must have been passively observed natively in the same Job Episode, outside OuttaMyWay configuration authority, and must positively release conflict-side Facing Clearance Extent. OuttaMyWay-created configuration observations cannot bootstrap future selection authority.

**Control consequence:** Candidate owns the expected compact profile; Control may actuate the existing fold donor only for `COMPACT_REQUIRED`, waits for exact live profile realisation, and treats fresh native blockage during guide motion as support loss rather than force-through permission.

---

# v0.1.0.5 implementation decision — Resolution-Space Conservation admission and 50 m surrogate retirement

**No new architectural decision.** D-0146 already defines Potential/Established Opposed Corridor Conflict, Resolution-Space Conservation, Conflict Serialization, Passage Presumption and Progressive Passage Search. v0.1.0.4 TS010 evidence exposed two code mismatches.

**Implementation discovery — Resolution-Space Conservation Admission Gap:** the live Regulation Candidate could be created only while `currentExcursion=true`. An Established opposed conflict with no supported Step-2 Passage could therefore consume resolution space at unrestricted native speeds even though the governing architecture already required conservation. The initiating Current Excursion remains one valid early witness, not a prerequisite for all later admission. v0.1.0.5 adds Situation-owned Established-conflict Regulation support; Candidate still gives a supported Passage expression precedence.

**Implementation correction — Development-Space Surrogate retired:** the fixed 50 m minimum entry separation has no architectural authority and pre-empted the existing concrete passage-support tests. v0.1.0.5 removes it entirely rather than replacing it with another arbitrary distance. The retained 80 m maximum remains only the current locality/action-space calibration pending separate evidence.

**Role expression:** preserve a positively Transitional participant's GIANTS-native revelation by regulating the positively Settled participant. Where continuation class does not distinguish the pair, defer the participant with the greater current native forward-rate contribution to closure; equal-rate ties are deterministic. The 8 km/h cap remains bounded empirical calibration, not architecture.

**Preserved:** Pair-Specific Passage Clearance + provisional 1 m nominal margin, current configuration, same-Commitment Regulation→Passage succession, positive relationship dissolution, 80 m locality ceiling, guide-shape and burden calibrations, Boundary Encroachment status and D-0147.

---

# v0.1.0.4 implementation decision — retire D-0146 12/6 geometry surrogate

**Status:** authorised TEST correction over owner-declared canonical v0.1.0.0; no new D-0146 architecture required.

**Decision:** remove the inherited 12 m centreline target, the second 12 m compact minimum and the derived 6 m participant reserve from generic D-0146 authority. Implement Pair-Specific Passage Clearance as Physical Contact Threshold = opposing conflict-facing extents, then add the provisional 1.0 m Nominal Inter-Assembly Clearance policy calibration. Evaluate the two possible passage sides separately.

**Named implementation discovery — Passage-Side Clearance Asymmetry:** for an offset/asymmetric assembly, the required separation can differ materially depending on which side of the shared lateral axis the opposing assembly passes. Reusing the current-side facing extents for both candidate sides would silently reintroduce symmetric-width reasoning. Candidate therefore carries side-specific contact threshold and required separation.

**Configuration decision for this tranche:** emit `RETAIN_CURRENT` for both participants. Do not infer `COMPACT_REQUIRED` from width. Configuration-Released Space remains architecture, but the FW212 evidence demonstrates that Mechanical Foldability alone is not passage configuration authority.

**Preserved for later evidence:** 50/80 m Development-Space calibration, fixed guide geometry, burden fractions, Boundary Encroachment, Blocked Conflict Persistence and all D-0147 work.

**Evidence boundary:** participating represented primitives are used as bounded TEST evidence only. `coverageComplete=false` and `negativeClearanceAuthority=false` remain explicit. No generic Coverage Closure decision is changed.

---

# v0.1.0.0 decision — adopt deliberate pre-1.0 versioning epoch

**Status:** accepted by owner after explicit canonical declaration of v4.7.128.

**Decision:** retire the historical ad-hoc 4.7.x numbering prospectively and reset release identity to `0.1.0.0` without changing behaviour. Do not renumber historical artifacts, changelog entries, decisions, test evidence or implementation-provenance references.

**Scheme:** `0.MINOR.PATCH.BUILD` while pre-publication. canonical releases use `BUILD=0`. TEST iterations increment BUILD. Accepted compatible corrections advance PATCH and reset BUILD. Significant architecture/capability milestones advance MINOR and reset PATCH/BUILD. first public release is `1.0.0.0`.

**Baseline:** owner-declared canonical v4.7.128, SHA-256 `3933bd60ef7dc5e603647835a2959de34cd8e79f44a7436ba7bf122021b262f1`, Git `d90057eb3adafa7204517eaa0ded0c696a13fd1b`, 315 files.

**Boundary:** version identity/provenance/documentation/tests only. No behaviour change.

---

# v4.7.128 canonical-candidate preparation — accepted review boundary

**Status:** Candidate preparation authorised by owner after successful v4.7.127 live validation.

**Decision:** Carry v4.7.127 behaviour unchanged into v4.7.128 canonical review. Candidate preparation may change release/version identity, provenance and validation/review records only. Do not combine the separately agreed pre-1.0 versioning transition with this candidate.

**Canonical authority:** v4.7.121 remains canonical until the owner explicitly accepts the exact v4.7.128 fingerprint.

---

# v4.7.127 decision — resolve Courtesy Evidence Gap by explicit D-0147 special-case exception

**Observation:** architecture/code audit of live-validated v4.7.126 found that `TerminalEgressCandidateSupport` labelled `FIELD_WORLD_CONTAINMENT` and `TRANSITION_CLEARANCE` PASS although the crude one-shot-centroid retreat does not predict the complete swept assembly or third-party clearance. TS016/three-vehicle success is empirical support, not predictive clearance authority.

**Decision:** classify D-0147 as an explicit player-consented special case. Its Bounded Infield Retreat is excluded from the generic predictive Field World Containment and Transition Clearance mandatory proof obligations. Candidate records those constraints as not applicable with `D0147_COURTESY_CONSTRAINT_EXCEPTION` provenance. Do not weaken PASS semantics globally and do not add swept-path planning merely to satisfy a paper contract.

**Boundaries retained:** consent, positive obstruction, Pending Player Reclamation, authority ownership, Protected Yield, Player Claim/source supersession, one bounded retreat, Continuation Renewal, Courtesy Exhaustion and Actuation Neutralisation remain mandatory.

**Validation record:** v4.7.126 is the first fully completed three-vehicle OuttaMyWay test: Patriot and Condor both yielded decisively and S416 completed. Treat this as strong validation of the current courtesy mechanism for that theatre/configuration, not universal proof.

**Audit implementation decision:** correct proven native `#` traversal of sealed ValueRecord collections found in Candidate/Commitment/D-0146 paths. This is implementation-contract housekeeping with no intended traffic/control behavioural change.

**Versioning:** explicitly deferred. Complete audit alignment/canonicalisation first; only then perform the separately agreed pre-1.0 versioning transition.

---

# v4.7.126 decision refinement — enlarge the courtesy quantum and remove the D-0147 speed cap

**Evidence:** v4.7.125 showed that the repeat lifecycle works, but 30 m simply allowed S416 to resume and later encounter Patriot again. Increasing speed alone would reach the same 30 m endpoint sooner and therefore would not buy additional spatial separation.

**Decision:** for the next narrow D-0147 test, increase one Bounded Infield Retreat from 30 m to **60 m of realised progress toward the fixed initial centroid bearing** and let the completed vehicle translate at its own native maximum forward speed. The productive worker remains held for the Protected Yield Interval.

**Why:** D-0147 is optional, deliberately crude courtesy behaviour. A larger literal is acceptable because it bounds player-consented movement rather than claiming a universal clearance requirement. Native maximum speed shortens the intervention; the 60 m quantum, not speed, is what increases bought separation/time.

**Preserved:** one-shot bearing/no course correction, Continuation Renewal plus later attributed native block, Courtesy Exhaustion, Player Claim, Actuation Neutralisation, and no planner/exclusion/settlement machinery.

# v4.7.125 decision refinement — replace Conflict Renewal with Continuation Renewal for D-0147

**Evidence:** v4.7.124 held S416 correctly, Patriot completed one bounded 30 m retreat, S416 resumed and travelled materially before later blocking on Patriot again. The first retreat therefore achieved the D-0147 objective of buying time even though the conservative represented conflict did not provide the clean disappearance witness required by v4.7.122 Conflict Renewal.

**Decision:** D-0147 repetition is now gated by **Continuation Renewal**. After retreat completion, record the authorising productive assembly/assemblies. Require positive post-release physical progression while active and unblocked. Only after that witness may a later positively attributed native `blocked=true` admit a fresh retreat.

**Why:** this follows observed productive reality, prevents immediate chained retreats, and avoids tuning the 30 m quantum to one TS016 geometry.

**Preserved:** one-shot centre bearing, forward-only 8 km/h actuation, 30 m inward-progress quantum, Protected Yield Interval, Courtesy Exhaustion, no planner/exclusion map.

# v4.7.124 decision refinement — reaffirm ValueRecord traversal contract

**Evidence:** v4.7.123 logs contained no protected-hold application and later reported `released=0`. Inspection found native `#`/`ipairs` applied to sealed `protectedDemandAssemblies`.

**Decision:** retain Protected Yield Interval unchanged. Correct traversal to `ValueRecord.length/ipairs`, and treat native `pairs`/`ipairs`/`#` on possibly sealed architecture values as a mandatory implementation-review and regression-test check.

# v4.7.123 decision refinement — D-0147 Protected Yield Interval

**Evidence:** v4.7.122 validated the fixed one-shot Infield Alignment and forward arc but produced a genuine collision when S416 continued at productive speed through Patriot's retreat. Speed changes could avoid this specific rendezvous but are not general.

**Decision:** preserve 8 km/h and the 30 m Bounded Infield Retreat unchanged. When INFIELD translation begins, temporarily hold every productive assembly whose positive conflict authorised the retreat. Implement the hold as an existing composable 0 km/h Regulation lease under the same D-0147 Commitment; release it after terminal neutralisation on every exit. Do not hold during compaction.

**Rejected for this tranche:** speed tuning, stopping-distance prediction, trajectory intersection calculation, future-demand exclusion zones, route planning.

# v4.7.122 decision refinement — D-0147 Bounded Infield Retreat / Courtesy Exhaustion

**Context:** TS016 showed that External Yield cannot be treated as the preferred simple solution. A long completed assembly may require an unknown conservative GIANTS AI clearance envelope while simultaneously remaining wholly outside adjacent Field Worlds and avoiding hedges/trees/ditches at the margin. Closing all three proof obligations is sufficiently difficult that D-0147 now investigates infield courtesy movement as the current best-case option.

**Decision — optional courtesy, not precision settlement:** D-0147 exists only to buy time before manual Player Reclamation. Literals are acceptable when they bound courtesy authority rather than claiming physical/agronomic truth. Do not introduce future-demand exclusion zones or parking optimisation merely to make the courtesy move precise.

**Decision — one-shot Infield Alignment:** after compaction, sample the immutable source Field World centroid once. Derive one fixed world direction from current terminal position to that centroid and hold it through forward-only `driveInDirection()`. Do **not** continuously pursue the centroid or issue mid-course corrections. The resulting large arc is GIANTS' kinematic realisation of a fixed heading, not an explicitly scripted 90/180-degree turn.

**Decision — Bounded Infield Retreat calibration:** first implementation uses 30 m of realised progress toward the centroid at the existing 8 km/h. The centroid is a bearing reference, not a destination. A retreat completes its current Commitment; it does not permanently settle the terminal Job Episode.

**Decision — Conflict Renewal / Courtesy Exhaustion:** after one retreat, the authorising positive conflict must disappear before a later positive conflict can admit another retreat. If the assembly is already within one retreat allowance of the centre when another retreat would be admitted, courtesy authority is exhausted and responsibility escalates to the player. No overall move-count literal is introduced.

**Working scope hypothesis:** current D-0147 reasoning may use three materially relevant assemblies as the analytical envelope. This reflects the likely small number of complementary concurrent agronomic operations, but it is not a hard system maximum. A future agronomic capability/concurrency matrix and broader assembly testing may disprove it.

---

# v4.7.121 decision refinement — D-0147 Terminal Yield / Pending Player Reclamation

**Observation:** v4.7.120 successfully realised the intended external egress mechanics and positively settled Patriot outside Field 77. About 107 seconds later, during a later S 416 turn, GIANTS changed S 416 to `blocked=true`. Patriot and S 416 remained physically separated in OuttaMyWay representation, and a subsequent debug-physics-overlay reconstruction also showed substantial body clearance. Moving Patriot farther outward would increasingly occupy the neighbouring Field World.

**Discovery — Clearance Authority Conflict:** positive physical/Field-World clearance and GIANTS native runtime clearance are different predicates. GIANTS may conservatively refuse continuation before physical overlap. Native blocked state is authoritative evidence that productive continuation has failed, but not unconditional authority for OuttaMyWay to consume arbitrary external space.

**Discovery — Pending Player Reclamation / Continuity, Not Settlement:** the player normally returns to tidy completed workers. OuttaMyWay's purpose is therefore temporary continuity: buy time for player reclamation while allowing remaining active workers to continue. It does not own permanent parking.

**Decision:** refine D-0147 from universal Terminal Egress settlement into **Reactive Terminal Yield**. Automatic movement requires **Terminal Yield Consent**. A harmless completed worker remains untouched. A positive current Terminal Occupancy conflict may admit one bounded yield. When current productive continuation is positively restored, stop and return the completed worker to passive Pending Player Reclamation. A later positive conflict may admit another yield. There is **No Final Settlement Requirement** and no arbitrary timeout/move count.

**Spatial decision:** preserve external egress as one supported yield expression, subject to **Egress Externality Constraint**. Do not move farther outward merely to satisfy a conservative GIANTS envelope when doing so exports the problem into another Field World. Architecturally permit **Conflict-Relative Infield Yield** when external egress is inappropriate: move away from the demonstrated current conflict within the source Field World, with other assemblies as constraints. Reject field centre as a destination and reject true randomness as primary authority; deterministic dispersion may break genuinely symmetric choices.

**Escalation:** if no legitimate bounded yield exists or repeated autonomous motion would become parking/search/thrashing, escalate to the player. This is normal gameplay and an explicit architecture boundary. Player Claim remains absolute/sticky.

**Implementation/canonicalisation decision:** v4.7.121 is architecture/provenance/identity only over the live-tested v4.7.120 implementation. Do not implement infield/repeated yield in this candidate. Keep `AUTOMATIC_TERMINAL_EGRESS=true` for testing as requested; retain that legacy variable name until the broader Terminal Yield implementation is designed. Eventual player-facing automatic Terminal Yield is explicit opt-in/default-off.

---

# v4.7.120 implementation discovery — Exit Vector / Exit Heading Mismatch

**Observation:** TS016 v4.7.119 validated Vehicle Activity Context and physical steering, but Patriot's tyre tracks and logged heading showed approximately 86 degrees of realised rotation. The Candidate's `exitOutwardDot≈0.707` described the intended displacement vector, not the realised crossing orientation. Positive Field-Exit Settlement correctly remained false when the fixed target was reached because the compact footprint was not wholly outside.

**Discovery — Exit Vector / Exit Heading Mismatch:** a fixed endpoint specifies where the assembly should go, but a pursuit controller is free to keep increasing turn while chasing it. For Terminal Egress, the architectural object is **Exit Alignment**: acquire the least necessary outward heading and then continue on that heading until the entire represented compact footprint has positively left the Field World.

**Decision:** retire fixed-point Oblique Boundary Egress pursuit and endpoint-based exhaustion. Candidate supplies the existing deterministic Exit Alignment (`RETAIN_OUTWARD_HEADING` or heading/outward bisector) as a world direction. Control holds that direction continuously through GIANTS `AIVehicleUtil.driveInDirection()` and terminates only on Positive Field-Exit Settlement, higher authority, mechanical failure or the existing one-manoeuvre watchdog.

**Mechanical donor:** AutoDrive demonstrates non-job use of `driveInDirection()` and documents the helper's legacy `motor` / `cruiseControl` expectation. v4.7.120 supplies those fields only for the duration of each call and restores prior values immediately. This does not import AutoDrive routing or create AI-job identity.

**Preserved:** v4.7.119 Vehicle Activity Context; 8 km/h; sticky Terminal Resolution Commitment; mandatory supported compaction; one selected outer boundary; Player Claim/source reactivation priority; Actuation Neutralisation; no retry/search/parking/reverse rescue.

# v4.7.119 implementation discovery — Wheel-Physics Activity Gate / Terminal Egress Vehicle Activity Context

**Observation:** v4.7.118 retained non-zero `vehicle.rotatedTime` across updates and retained CrabSteering AI mode, while all steerable `WheelPhysics.steeringAngle` values remained zero.

**SDK fact:** `WheelPhysics:serverUpdate()` gates both `updatePhysics()` and `updateSteeringAngle()` behind `vehicle.isActive`. `Vehicle:getIsActive()` returns true when `forceIsActive` is asserted; `AIJobVehicle:getIsActive()` also returns true for active AI.

**External implementation evidence:** Courseplay keeps its own routing inside an active AI-worker lifecycle. AutoDrive runs outside a GIANTS AI job but asserts `forceIsActive=true` while it owns driving. This supports separating physical Vehicle Activity Context from productive Job Episode identity.

**Decision:** v4.7.119 tests exactly one new mechanical condition: D-0147 EGRESS temporarily asserts `forceIsActive` while Post-Job Actuation Authority is owned. It does not make `getIsAIActive()` true, create/restart a Job Episode, change Oblique Boundary Egress, change curvature, or adopt AutoDrive's `driveInDirection()`.

**Release order:** on owned success/failure/exhaustion, Actuation Neutralisation occurs first while the activity context is still asserted; the captured prior `forceIsActive` is then restored. On Player Claim/source reactivation, no later OuttaMyWay drive/stop actuation is allowed, but the temporary activity context is relinquished.

**Validation criterion:** wheel steering angles moving away from zero with corresponding yaw supports Vehicle Activity Context as the missing post-job steering-realisation condition. Failure must be interpreted at the next observed gate rather than by altering Candidate geometry.

---

# v4.7.118 implementation discovery — Deferred Steering Realisation / Steering-State Handoff

**Observation:** v4.7.117 delivered explicit non-zero curvature to GIANTS after genuine Job Episode completion, yet realised heading remained straight.

**SDK finding:** `AIVehicleUtil.driveToPoint()` and `driveAlongCurvature()` write `vehicle.rotatedTime`; `WheelPhysics:updateSteeringAngle()` later consumes that demand and applies vehicle-specific steering logic. `Drivable:updateVehiclePhysics()` only rewrites `rotatedTime` from player input when the vehicle is controlled. CrabSteering supplies a custom wheel-angle function and selects its AI mode at worker start, but the SDK does not show an automatic CrabSteering mode restoration at worker end.

**Courseplay comparison:** Courseplay owns routing/turn geometry but keeps a genuine active AI worker/task lifecycle and ultimately feeds world targets through `getAISteeringNode()` to GIANTS `AIVehicleUtil.driveToPoint()`. It therefore does not demonstrate a separate lower-level steering actuator.

**Decision:** do not introduce another steering mechanism in v4.7.118. Observe the steering-state handoff directly. Add positive actuation neutralisation because v4.7.117 proved post-job propulsion can remain physically latched after Control exhausts.

**Authority boundary:** Player Claim and source reactivation remain higher authority; no neutralisation/drive call may be issued after either has become positive.

---

# v4.7.117 implementation discovery — Post-Job Steering Realisation Gap

**Live fact:** TS016 v4.7.116 passed the complete local target position to `AIVehicleUtil.driveToPoint()`, yet the completed Patriot and Condor retained essentially unchanged headings. Candidate continued to publish the intended Oblique Boundary Egress targets. This disproves the assumption that preserving the target position alone establishes post-job steering.

**Refined discovery:** **Post-Job Translational Authority is validated; Post-Job Steering Authority remains unvalidated.** The original disposable R3 evidence proved straight bounded movement only.

**GIANTS mechanical evidence:** FS25 `AIVehicleUtil.driveAlongCurvature()` derives steering rotation from an explicit curvature, assigns `rotatedTime` directly, then updates wheel physics. v4.7.117 uses that existing GIANTS primitive as the mechanical realisation of the already-selected Oblique Boundary Egress target.

**Implementation decision:** keep one fixed Candidate world target. On each Control update, transform that target into steering-node local space, derive the circular curvature through the target, and issue one `driveAlongCurvature()` actuation. This is mechanical implementation of one existing D-0147 manoeuvre, not another manoeuvre phase or route leg.

**Boundaries preserved:** Player Claim and source reactivation are checked before every call; `AUTOMATIC_TERMINAL_EGRESS=true`; 8 km/h; Positive Field-Exit Settlement; one target/no retry; no alternate boundary/angle, path search or parking behaviour. If the fixed target is no longer forward-reachable without positive field exit, exhaust.

**Retained live success:** v4.7.116 Positive Field-Exit Settlement successfully stopped Patriot after actual Field World exit and is intentionally unchanged.

---

# v4.7.116 implementation discovery — Post-Job Steering Authority / Field-Exit Boundary Transfer

**Live fact:** TS016 v4.7.115 generated materially different Oblique Boundary Egress targets but the completed assemblies retained essentially their v4.7.114 headings. Candidate geometry was therefore not the limiting layer.

**Discovery — Post-Job Steering Authority Gap:** disposable R3 established straight post-job actuation, not arbitrary post-job steering. Production v4.7.115 transformed the world target into steering-node local space and then normalized `(lx,lz)` to unit length. Repository GIANTS evidence already records `AIVehicleUtil.driveToPoint()` as consuming a local-space **position**, not a normalized direction. The normalization preserved the straight proof case while discarding target-distance information needed for steering.

**Implementation decision:** v4.7.116 passes the full `worldToLocal()` target position to `AIVehicleUtil.driveToPoint()`. This is an implementation correction under the existing Oblique Boundary Egress architecture; no new route, angle or manoeuvre concept is added.

**Discovery — Field-Exit Boundary Transfer Failure:** TS016 again showed Patriot's entire represented AABB beyond the Field World AABB without settlement. D-0147 copied/traversed sealed Field World boundary values using ordinary Lua iteration/length in places, contrary to the repository's established `ValueRecord` traversal contract.

**Implementation decision:** Candidate and Control use `ValueRecord.length/ipairs` consistently for D-0147 outer-boundary transfer and traversal. Positive Field-Exit Settlement itself is unchanged.

**Preserved:** all v4.7.115 D-0147 architecture, 8 km/h calibration, Player Claim, one-manoeuvre complexity boundary and exhaustion semantics.

---

# v4.7.115 decision refinement — D-0147 Oblique Boundary Egress

**Fact:** TS016 v4.7.114 showed that a completed wheeled assembly may be approximately parallel to its nearest field edge. Supplying the geometric boundary-normal target directly to `AIVehicleUtil.driveToPoint` can therefore demand an approximately 90-degree steering change. Patriot physically left the Field World but settlement failed to recognise it; Condor attempted the lateral objective through a large forward arc and was constrained by the treeline.

**Decision — Outward Reference / Exit Alignment separation:** retire **Boundary-Normal Egress** as the manoeuvre concept. The outer boundary normal remains only the outward reference. Candidate derives one deterministic **Oblique Boundary Egress** from the realised compact pose/heading and that local outward reference. The intended trajectory is the least intervention that supplies a decisive outward component while respecting wheeled forward kinematics. A near-parallel start may naturally produce an approximately 45-degree crossing, but 45 degrees is not canonical policy. If current heading is already materially outward-facing, retaining it is permitted.

**Decision — no new search authority:** the oblique expression is one manoeuvre, not a route family. Failure does not authorise another angle, another boundary, a gap search, reverse rescue, multi-leg relocation, margin mapping or post-exit alignment. Terminal Egress Exhaustion remains the endpoint.

**Decision — Positive Field-Exit Settlement witness:** once `COMPACTION_COMPLETE` has positively opened EGRESS, Control need not re-prove fold state on every sample. A represented assembly footprint wholly beyond Field World bounds is sufficient positive evidence of field exit; otherwise the existing represented-disc/polygon relation may establish exit.

**Preserved:** GIANTS Completion Acceptance, Terminal Resolution Commitment, mandatory supported compaction, Player Claim, POST_JOB_ACTUATION authority, 8 km/h test calibration, Automatic Terminal Egress switch, and Independent Terminal Egress.

---

# v4.7.114 decision refinement — D-0147 Terminal Resolution Commitment and Positive Field-Exit Settlement

**Live evidence:** TS015 and TS016 used the same v4.7.113 production implementation. TS015 completed compaction and egress successfully because positive obstruction evidence happened to persist through the fold. TS016 admitted Terminal Occupancy and started Patriot compaction at 15:29:21.555, but transient loss of the currently represented obstruction caused `OBJECTIVE_SATISFIED` at 15:29:23.310, before compact configuration existed (~15:29:36.853). S416 then passed behind Patriot, later turned back through the same completion position and collided. Bench-testing the proposed "persist only until compaction completes" correction showed it would still be vulnerable because S416's then-revealed straight continuation was clear at compaction completion while later manoeuvring demand was not yet visible.

**Decision — Terminal Resolution Commitment:** positive Terminal Occupancy admission is the Commitment Point for the whole bounded D-0147 resolution. Once admitted, transient disappearance of the initiating obstruction cannot settle the obligation during or after compaction. Supported compaction remains mandatory preparation, but compaction-only settlement is withdrawn under the current evidence model.

**Decision — Positive Field-Exit Settlement:** after compaction, the one nearest-outer-boundary manoeuvre is decisive. Success requires positive current evidence that the compact represented assembly is fully clear of the Field World. The Candidate guidance target is not success authority. If that one target is reached without positive represented Field World exit, Terminal Egress Exhaustion applies; no target extension, second direction, alternate boundary or retry is authorised.

**Implementation calibration:** v4.7.114 TEST uses 8 km/h for Terminal Egress, reusing the project's already exercised low-speed bounded manoeuvring value rather than retaining v4.7.113's 3 km/h. This is implementation evidence/calibration, not a universal architectural speed.

**Preserved:** GIANTS Completion Acceptance remains default before positive Terminal Occupancy admission; `AUTOMATIC_TERMINAL_EGRESS=true` remains the development/test default; Player Claim remains absolute/sticky; no parking, Refuge/King search, margin routing, global completed-worker relocation or repeated rescue manoeuvre is introduced.

---

# v4.7.113 implementation record — D-0147 production realisation; no new architectural decision

D-0147 from canonical v4.7.112 remains the governing contract. v4.7.113 attempts to realise it directly in production rather than introducing another probe/discovery lineage.

**Implementation mapping:** completed source termination remains a Job Episode/Lifecycle fact while physical observation persists for Terminal Occupancy; Situation owns positive terminal obstruction; Candidate owns supported compaction and exactly one nearest-outer-boundary objective; Commitment/Authority use a distinct `POST_JOB_ACTUATION` class; Control executes configuration compaction and direct bounded post-job drive primitives only. Compaction is followed by a fresh Situation assessment before translation can be admitted.

**Player authority:** the existing active-Job Player Takeover witness remains separate from D-0147 Player Claim. Post-completion Player Claim uses only `vehicle:getIsEntered()`, is sticky for the terminal episode, and is rechecked before every direct drive/stop call.

**Configuration:** `AUTOMATIC_TERMINAL_EGRESS` is production-wired in `config.lua`; the development/test default is `true`. This does not decide the eventual product/UI default.

**Complexity boundary preserved:** outer boundary only; no island-boundary egress, alternate candidate, route search, retry, parking, or global completed-worker coordination. Unsupported or exhausted one-manoeuvre capability ends in Player Escalation.

**Maintenance boundary:** `Prototype22ConfigurationAuthority` remains as an existing mechanical donor for this tranche to avoid unrelated behaviour change. Its naming/provenance and similar baggage are reserved for a later dedicated cleanup audit.

---

## D-0147 — Bounded Terminal Egress for obstructive completed assemblies (2026-08-13)

**Status:** Accepted and carried by owner-declared canonical v4.7.112.  
**Baseline:** owner-declared canonical v4.7.109 (`ea0b399e2f73759fa29982fc1b85d5bf446f6fd90eb324dec2902b333c7c6a74`; Git `cd9085ee40343d542a66b84948c27f7dd91a40c7`; 310 files).

**Decision:**

> **2026-08-18 live-evidence refinement:** item 3's compaction-only settlement and item 4's conditional translation are superseded by the v4.7.114 **Terminal Resolution Commitment** / **Positive Field-Exit Settlement** decision recorded above. The remaining D-0147 complexity and authority boundaries are preserved.

1. Preserve **GIANTS Completion Acceptance** as the default. Job completion alone never causes OuttaMyWay relocation.
2. When a completed, unclaimed assembly's realised **Terminal Occupancy** positively obstructs continuing active demand, an enabled **Automatic Terminal Egress** may create a narrow post-job clearance obligation.
3. Before translation, compact the completed assembly into its minimum positively supported transit configuration where a meaningful reduction exists. If compaction alone clears the obstruction, stop.
4. If translation remains necessary, use a **Boundary-Normal Egress Objective**: sufficient outward displacement toward the locally nearest Field Boundary. The objective is not restricted to the vehicle's forward axis.
5. Permit at most one **simple, continuous, bounded outward manoeuvre**. Do not search for a best region, parking position, alternate boundary, field-centre destination or multi-leg route.
6. If the simple manoeuvre is unsupported or exhausted, transfer responsibility to the player. Failure does not authorise a more sophisticated solver.
7. Treat multiple completed assemblies as independent Terminal Occupancy obligations, not a global relocation problem.
8. **Player Claim** is absolute: positive player entry immediately ends OuttaMyWay post-job actuation and responsibility remains with the player for that Terminal Occupancy episode even if the player later exits.
9. Expose Automatic Terminal Egress as a user-configurable switch. `Off` preserves historical behaviour; the eventual default is not decided here.
10. Preserve **Zero-Configuration Compatibility**. Optional GIANTS `FieldCourseSettings` (`workHeadlands`, `headlandsFirst`) may strengthen declared productive-demand knowledge when positively available, but absent settings mean unknown and can never be required for safe operation.
11. Do not implement D-0147 in v4.7.112. Disposable post-job actuation/player-claim and AI-settings probes are evidence only and must not be promoted wholesale into production.

**Evidence:** the final v4.7.109 scenario exposed completed sprayers as deterministic obstacles to a still-active worker. Disposable v4.7.110 proved clean post-job physical actuation without AI-job restart and proved immediate player-entry pre-emption with zero subsequent OuttaMyWay drive calls. Disposable v4.7.111 proved that work-phase settings are authoritative when materialised but absent in the ordinary default-start path.

**Why:** a general Terminal Clearance Region/parking search would recreate the complexity and performance failure mode of the retired King/continuous Refuge direction. A bounded outward exception can solve the common boundary-adjacent completion obstruction while making player escalation a legitimate, explicit endpoint.

**Implementation consequence:** the next implementation activity, if selected after canonicalisation, must discover the smallest supportable mechanics for compaction plus one outward boundary-relative manoeuvre. Any pressure to add alternate destinations, repeated attempts, global parking coordination or exhaustive margin modelling is evidence that the capability should remain unimplemented or player-owned.

---

# v4.7.109 release record — close fixing cycle at validated stability plateau

**Fact:** v4.7.108 live evidence supports the final Settled Relationship Dissolution correction and the broader three-worker D-0146 implementation. Five Cooperative Passages settled successfully with no Passage Reassessment/escalation or OuttaMyWay error stack.

**Decision:** stop planned corrective work and produce v4.7.109 as a fresh canonical candidate. No new architecture is introduced and no traffic/planning/Control behavioural algorithm is changed from the tested v4.7.108 payload. Optional enhancements are deferred until after canonicalisation.

---

# v4.7.108 implementation record — Settled Relationship Dissolution; no new architectural decision

D-0146, Trajectory Persistence, Resolution-Space Conservation and Productive/Transitional context already provide the governing architecture. v4.7.107 live evidence disproved one implementation implication: `currentExcursion=false` plus newly non-opposed Established Trajectories does **not** mean the underlying relationship is positively settled while GIANTS still reports a turn transition.

**Implementation discovery — Settled Relationship Dissolution:** trajectory acceptance and relationship settlement are different facts. An admitted Resolution-Space obligation may be released through the non-opposed-trajectory path only when both participants positively demonstrate settled continuation: valid GIANTS `SETTLED_CONTINUATION` local intent and positive `NON_TURN_LINE_ACTIVE` continuation. TURN_SEGMENT/TURNING, unresolved intent, or non-productive transition leaves dissolution unresolved and the obligation persists.

Physical post-passage ordering remains independent positive dissolution. No timer, hysteresis, headland heuristic, route prediction, or new Control interpretation is authorised. Situation owns the semantic witness; Control remains limited to consuming `positiveDissolution`.

This is the last planned corrective implementation before a canonical plateau; optional refinements remain separate post-canonical work.

---

# v4.7.107 implementation record — Resolution-Space Obligation Persistence; no new architectural decision

D-0146 and Resolution-Space Conservation already require ordinary progression not to consume the last locally admissible means of resolution. v4.7.106 correctly made that obligation executable but incorrectly tied its lifetime to the Current Excursion witness that first justified admission.

**Implementation discovery — Resolution-Space Obligation Persistence:** evidence that creates an obligation does not necessarily define its lifetime. Once bounded Action-Space Conservation is admitted, loss of instantaneous closure, temporary reverse motion, stationary motion, or disappearance of `Current Excursion` is not by itself positive evidence that the underlying Potential Opposed Corridor Conflict has dissolved.

v4.7.107 therefore keeps the obligation until Situation supplies **positive relationship invalidation**, the pair leaves the active Operation, or Established conflict succeeds into Step 2 under the same governing requirement. Positive invalidation currently includes actual post-passage ordering and stable non-opposed Established Trajectories after Current Excursion has ended. No headland heuristic or route prediction is added.

The existing 8 km/h cap remains bounded empirical calibration, not architectural policy.

---

# v4.7.106 implementation record — Potential Conflict Action-Space Conservation; no new architectural decision

D-0146 already states that Potential Opposed Corridor Conflict is observed and may be regulated where Action Space is being consumed, and Resolution-Space Conservation already prohibits ordinary progression from consuming the last locally admissible means of resolution. v4.7.105 live evidence showed that these accepted rules were not yet executable during Current Excursion.

v4.7.106 therefore does **not** shorten Trajectory Persistence or grant Current Excursion Established-Trajectory authority. It adds a bounded positive witness for Potential conflict from one Current Excursion, one stable approaching participant, positive current physical corridor support, positive closure and the existing Local Passage envelope. Traffic Policeman may regulate only the stable participant to conserve passage-development space; the excursion remains GIANTS-native.

The Regulation and later Established-conflict Cooperative Passage share one D-0146 governing requirement and may therefore be purpose succession within one Commitment. Dissolution of the Current Excursion purpose causes immediate Regulation release and obligation settlement. The 8 km/h value is an empirical test calibration scoped to this conservation purpose, not architectural speed policy.

**Unilateral Passage Execution** remains architecturally permitted under Pairwise Passage Economy, but is deliberately not introduced in this correction because the current S 416 passages succeeded without requiring a new native/controlled authority composition.

---

# v4.7.105 implementation record — Optional Configuration Reduction; no new architectural decision

D-0146 already permits **optional configuration reduction**. The v4.7.103 live Patriot/S 416 stall disproved the implementation assumption that GIANTS fold-interface presence implies a meaningful Compact Configuration and exposed that the generic Step-2 controller had inherited a sprayer-specific mandatory compact-both sequence.

v4.7.105 restores the accepted authority boundary: Candidate expresses per-participant passage configuration demand from current positive represented envelope; Control revalidates/actuates only `COMPACT_REQUIRED` participants and selectively restores only changed configuration. `RETAIN_CURRENT` participants receive no fold actuation. The current 6 m per-participant reserve is bounded implementation calibration and does not amend D-0146 clearance architecture.

---

# v4.7.100 implementation record — no new architectural decision

D-0146 remains the governing architectural decision. v4.7.100 adds a passive Situation-owned implementation of its Step-1 Established Trajectory / Current Excursion / Potential-to-Established Opposed Corridor Conflict semantics. The numeric filters are explicitly empirical implementation calibration and do not amend D-0146. Candidate/Decision/Commitment/Control behaviour is deliberately unchanged pending live evidence.

---

## D-0146 — Trajectory-Based Opposed Corridor Conflict / Local Cooperative Passage (2026-08-12)

**Status:** Accepted for v4.7.99 canonical candidate; owner canonicalisation remains separate.  
**Baseline:** owner-declared canonical v4.7.98 (`105462f44b902312e5dc63c6176d44f848f15c1466d942a4bee70635ced6cd69`; Git `982992b926839c854f6d4d7979fe24885e267eae`; 307 files).

**Decision:**

1. Separate Cooperative Passage into **Step 1: categorise the opposed corridor conflict** and **Step 2: determine/perform a supported passage**.
2. Base Step 1 primarily on observed physical trajectory and spatial demand: Established Trajectory, Current Motion, Current Excursion and Trajectory Persistence.
3. Treat Productive/Transitional/TURN_SEGMENT and Turning Rank as contextual confidence/spatial evidence, not binary opposed-conflict or route-prediction authority.
4. Distinguish Potential from Established Opposed Corridor Conflict. Established requires substantially opposed, closing, sufficiently persistent/stable motion plus positive Supported Corridor Overlap.
5. Supported Corridor Overlap is categorical: any positively supported overlap is overlap. Magnitude is descriptive for Step 2, not a Step-1 admission threshold. Uncertainty-only overlap cannot manufacture an Established conflict.
6. Near-collinear is relational corridor competition, not exact centre-line coincidence, exact 180-degree heading or a universal lateral threshold.
7. Adopt **Passage Presumption**: once conflict is Established, passage is presumed possible until Local Spatial Constraint disproves it.
8. Permit asymmetric/unilateral burden, optional configuration reduction and temporary productive-lane departure.
9. Permit **Boundary Encroachment** into the immediate field margin while some of the complete assembly remains in-field; wholly extra-field relocation is outside Cooperative Passage.
10. Select Passage Arrangements by **Pairwise Passage Economy**; neither Established Trajectory has inherent privilege. Existing commitments/priority may break ties.
11. Use **Passage Sufficiency / Progressive Passage Search** rather than global optimisation. Stop when a sufficient supported local arrangement is found.
12. Protect **Nominal Inter-Assembly Clearance** through development, traversal and reacquisition while accounting for Manoeuvre Swept Occupancy. No universal clearance metre/percentage is architecture.
13. Represent execution shape architecturally as a **Passage Guide** of bounded spatial targets/gates, not a fixed three-leg sidestep.
14. Adopt **Passage Support Loss / Passage Reassessment**: when positive support for the current expression is lost, reassess current Reality; continue, re-express the same Commitment, or safely abandon/escalate.
15. Preserve player escalation as legitimate last resort when Local Passage Space is exhausted or no supported continuation remains.
16. Do not implement/generalise these concepts in v4.7.99. The current bounded v4.7.98 TS015 implementation remains the live behaviour and evidence donor.

**Why:** the earlier Rook/file and Productive/TURN_SEGMENT distinctions captured useful persistence/transition observations but were solution-shaped by unilateral Refuge thinking. Cooperative Passage permits direct reasoning from physical trajectory and local space, reduces required prediction and better expresses asymmetric real-world passage.

**Implementation consequence:** next work must explicitly close the architecture/implementation gap in small increments, starting with Step-1 trajectory knowledge/classification before general Step-2 passage construction.

---

### D-0145 numbering note

The D-0145 label remains reserved for the previously named **Live Clearance Cost** performance discovery from the retired King lineage: repeated actual transit-footprint placement/swept-clearance work was linked to the characteristic regression. It is historical performance evidence, not current governing passage architecture, and is not repurposed here.

---

## D-0144 — Progressive Situational Sufficiency / Chessboard Simplification (2026-08-12)

**Status:** Accepted for v4.7.98 canonical candidate; owner canonicalisation remains separate.  
**Baseline:** owner-declared canonical v4.7.95 (`1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`; Git `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`; 305 files).

**Triggering evidence:** v4.7.97 live production evidence completed two automatic TS015 Cooperative Passages through the normal Situation Assessment → Candidate → Constraints → Decision → Commitment → Control chain while preserving the same GIANTS Job Episodes and imposing no post-handoff cooldown. The same run also exercised D-0141 follower Regulation before a later opposed conflict; Cooperative Passage superseded the existing follower purpose instead of requiring a separate scenario solver. The final convergence looked physically close to the demonstrated near-collinear geometry but remained Productive/Transitional because one participant was still `TURN_SEGMENT`, so the Candidate was correctly withheld. None of the successful production passages depended on Rook/Successor-Rook reasoning, chessboard colouring, continuous Productive History, King Reserve, Refuge search or a headland-U-turn scenario class.

**Decision:**

1. Adopt **Progressive Situational Sufficiency**: Situation Assessment should acquire only enough positively supported current Knowledge to justify the next least-authority action. It need not construct a detailed model of future GIANTS behaviour when Observe or Regulation can preserve Action Space until Reality reveals more.
2. Retain current **Productive / Transitional** classification as first-class Situation Knowledge. Transitional remains meaningful and must not be coerced into Productive merely to admit Cooperative Passage.
3. Retain **Turning Rank** only as spatial Situation Knowledge that may support earlier observation/Regulation near a region where native transition can consume space. It is not a turn-direction, U-turn or successor-route predictor. v4.7.98 adds no new Turning Rank geometry calculation.
4. Retire **Rook as a required governing productive-space structure** and retire **Successor Rook Set** from current production architecture. Historical Rook terminology remains evidence provenance only.
5. Retire chessboard productive-history colouring and **continuous Productive History reasoning** as runtime/governing obligations. Current productive state is supported from current positive evidence; no continuous raster of demonstrated work is required for TS015 cooperation.
6. Re-express transition-relevant spatial concern through current positive motion/configuration/demand evidence when needed. Do not replace Successor Rook with another speculative route model.
7. Preserve **D-0141 follower observation/Regulation** because live evidence shows it remains operationally useful for preserving Action Space while a leader's native behaviour is unresolved. Regulation still cannot create passing space for an established opposed blockage.
8. Preserve **D-0143 bounded Cooperative Passage** as the current production Reposition strategy for the demonstrated TS015 Condor/Patriot near-collinear Productive/Productive class.
9. Reaffirm retirement of King Reserve, continuous Refuge discovery/qualification and headland-U-turn-specific solving.
10. Remove live runtime sourcing/scheduling of `DemonstratedProductiveCoverageProbe.lua`, `ProductiveCoverageResidualProbe.lua` and `RefugeQualificationShadowProbe.lua`. Preserve those files as historical evidence donors rather than deleting empirical work.
11. Introduce no replacement shape work. Cooperative Passage continues to consume bootstrap-cached physical/configuration evidence already present in Situation Assessment; no new footprint discovery, polygon decomposition, sweep generation or continuous clearance calculation is authorised.
12. Make **Cooperative Passage Scope Boundary** explicit in current documentation: bounded production capability is demonstrated, but general Cooperative Passage is incomplete.

**Known incomplete authority:** Productive/Transitional near-collinear opposed encounters; arbitrary asymmetric encounters; other assembly combinations; generic negative-clearance authority; and broader regression-scenario coverage. Current TS015 movement/admission literals remain calibration, not architecture.

**Rationale:** The successful system did not need to understand GIANTS' next route in detail. It needed enough current Knowledge to preserve options while uncertainty existed, then enough mature conflict Knowledge to choose a supported resolution. Keeping predictive/chessboard machinery as normative simply because it was previously written would preserve complexity without an observed responsibility.

**Implementation impact in v4.7.98:** reapply the live-successful v4.7.97 bounded production implementation over exact canonical v4.7.95; unsource only the three retired continuous coverage/refuge diagnostic pipelines; update architecture/documentation/provenance. No Cooperative Passage physical geometry, D-0141 Regulation policy, admission calibration or Control sequence is intentionally changed.


## D-0143 — Cooperative Passage Production Direction / King Retirement (2026-08-12)

**Status:** Accepted for v4.7.95 canonical candidate; owner canonicalisation remains separate.  
**Baseline:** owner-declared canonical v4.7.77 (`0964ba2583122088077e5e465fffb24820d07380f533d1f44ed7d1ad24355153`; Git `1742c197c21a1fb127932dcc15303dbd58515d6d`; 305 files).

**Triggering evidence:** Post-canonical King-space implementation work demonstrated a severe live performance cost when actual TRANSIT-footprint placement/swept-clearance was maintained continuously. Removing exact polygon decomposition and per-frame Knowledge-copy amplification did not remove the characteristic stutter; older circle-style clearance improved performance but lacked the required geometric authority. Subsequent certificate/re-proof reductions did not recover FPS proportionately. Continuing to optimise the current King fixture therefore has decreasing architectural value and no production justification for the immediate TS015 objective.

P23 then tested an alternative physical hypothesis: instead of moving one worker into an externally discovered Refuge, compact both opposed sprayers and use the lateral capacity released inside their existing productive corridor. v4.7.91 exposed **Forward-Only Waypoint Orbit** in a too-short/high-lateral point-pursuit leg. v4.7.92 corrected only that Control geometry and completed Cooperative Passage. v4.7.93 repeated the manoeuvre twice in one uninterrupted working session with closely matching phase budgets and approximately 12 m closest centre separation while both original Job Episodes survived and native Productive motion resumed. v4.7.94 removed human trigger timing through persistent arming and automatically completed repeated near-collinear passages. Its final asymmetric opposed encounter was also admitted, but the fixed lateral split produced insufficient clearance and stalled; that is explicit authority-boundary evidence rather than permission to widen the PoC.

**Decision:**

1. Retire **King Reserve Availability** from governing production Knowledge.
2. Retire continuous local Refuge discovery/qualification as an ordinary runtime obligation.
3. Retire the provisional ordinary `A→R→A` King lifecycle as the expected head-on resolution path.
4. Preserve `Refuge` only as a generic/historical spatial possibility; later Refuge use requires fresh positive architectural justification and carries no standing discovery obligation.
5. Accept **Configuration-Released Space** as the observed physical concept that configuration reduction may create usable local resolution capacity.
6. Accept **Cooperative Passage** as a Candidate Reposition strategy: multiple assemblies may jointly compact, occupy separated local passage paths, pass concurrently, return toward productive alignment, restore and hand back to GIANTS.
7. Scope the first production authority narrowly to the demonstrated **TS015 Condor Endurance II / Patriot 4450 near-collinear opposed-working class**. The final v4.7.94 asymmetric encounter is outside this first authority envelope.
8. Preserve the normal architecture chain. Situation Assessment establishes applicability; Candidate generation enumerates the joint action; Mandatory Constraints gate it; Traffic Policeman/Decision selects it; Commitment owns purpose/obligations; Bounded Authority limits each physical phase; Control executes only selected physical work.
9. Treat P23 literals and state sequencing as evidence/implementation donors, not architectural constants or a parallel production solver.
10. Separate passive post-handoff observation from Commitment/Control ownership. Observation creates no cooldown and may be superseded by a new necessary Commitment.
11. Freeze further prototype/generalisation work until a production TS015 integration has been live validated. Do not resume King optimisation, arbitrary asymmetric solving or broad vehicle generalisation ahead of that objective.

**Rationale:** The immediate project risk is no longer absence of a plausible head-on manoeuvre. A repeatable physical capability now exists for the target TS015 fixture. The engineering objective is to make that capability flow through the existing production architecture with the least new machinery. Preserving an unworkable continuous King fixture merely because it was previously architectural would violate the project's evidence-first and least-intervention principles.

**Implementation impact in v4.7.95:** Architecture/documentation, provenance and release/version identity only. Runtime behaviour remains canonical v4.7.77. P23 v4.7.91-v4.7.94 remains non-canonical evidence lineage.


## D-0142 — Field World / Chessboard Architecture Consolidation (2026-08-11)

**Status:** Accepted in owner-declared canonical v4.7.77. D-0143 supersedes items 6-7 and the King/continuous-Refuge consequences where they conflict.

**Context:** After v4.7.76 live closure, repeated architecture/code reconciliation kept attempting to relocate responsibilities from prototype/scenario mechanisms whose concepts had already been superseded. Field World/chessboard exploration provided a smaller architecture that explains P22, head-on, follower, multi-worker and constrained-topology evidence without preserving those mechanisms as permanent solvers.

**Decision:**

1. Make shared Field World + worker-relative Productive Regime/Rook structures the governing spatial/productive architecture.
2. Separate Field Boundary, productive Headland working band and Turning Rank.
3. Record only positively demonstrated active work as worker productive history; traversal is not colouring.
4. Represent productive succession through Successor Rook Set and bounded Transitional Demand rather than exact GIANTS path prediction.
5. Use Configuration-Dependent Assembly Footprint according to manoeuvre phase.
6. Adopt Native Reacquisition Anchor A and provisionally adopt the ordinary local Refuge lifecycle `A→R→A`.
7. Maintain King Reserve Availability as non-owning Knowledge (`SOME` / `NONE`, with implementation `UNKNOWN` permitted for incomplete evidence).
8. Require positive cooperative spatial relevance; same-field presence/proximity is insufficient.
9. Adopt Resolution-Space Conservation and Conflict Serialization; use upstream admission control where entry into constrained topology would destroy resolvability.
10. Define Committed Demand as post-Decision Commitment-derived spatial demand. Active Job Episode membership does not itself create Committed Demand.
11. Apply a Preserve / Re-express / Retire Supersession Filter before mapping old code to new ownership.
12. Retire P22 as architecture, HEAD_ON as governing solver, exactly-two-worker assumptions and bespoke multi-worker solving. Preserve only proven physical/evidence donors.
13. Re-express leader/follower and old Future-Space mechanisms through the new Knowledge model.
14. Treat Guarded Recovery as provisional compatibility evidence. Preserve its proven protection requirement while validating whether generic Committed-Demand protection fully subsumes it.
15. First implementation build is Operational Picture Knowledge Foundation: one decisive production-intent Knowledge implementation with temporary non-authoritative validation logging and no behavioural authority.

**Rationale:** Complexity should be reduced by admission control and serialization upstream, not absorbed into increasingly sophisticated Control manoeuvres downstream. Existing code receives no presumption of architectural legitimacy merely because it exists. Architecture follows Reality; implementation convenience does not define concepts.

**Implementation impact in v4.7.77:** Documentation/architecture only. v4.7.76 runtime behaviour is intentionally retained.


## 2026-08-10 — v4.7.76 canonical-candidate closure

**Type:** implementation/governance decision; no new architecture.

The owner accepted the successful v4.7.75 TS015 result as the closure point for the current implementation tranche and requested a canonical candidate. The candidate version advances to v4.7.76 while functional v4.7.75 behaviour is frozen. Remaining implementation issues are explicitly parked rather than repaired before canonicalisation.

The live result includes one declared qualification: after Patriot completed its work, the owner manually moved the completed Patriot assembly so Condor could access the final few metres. This remains a terminal/post-completion occupancy limitation for future work.

## D-0141 implementation repair addendum — v4.7.73 (2026-08-10)

Owner live evidence from v4.7.72 showed D-0141 releasing its existing follower purpose at the clean co-directional → opposed transition, 251 ms before the next head-on Reposition began. With D-0131 shadow-only and no sealed Progress horizon, Patriot accelerated during Condor egress. The implementation is corrected without a new decision concept: the accepted 0.90 clearance factor is restored to already-restrictive D-0141 calculations, and clean opposed continuation preserves the existing purpose until the already-defined Progress Passage retirement event.

## D-0141 live implementation repair addendum — v4.7.72 (2026-08-10)

**Status:** implementation correction only; no new architectural decision. Owner-declared v4.7.49 remains canonical.

The v4.7.71 live run exercised D-0141 Control and exposed implementation defects rather than a need to reopen the decision: (1) an already-admitted follower purpose was retired on millimetric current-corridor threshold noise; (2) Runtime/Control still reassessed at the 1 s passive cadence; (3) the existing lease remained at the last Productive cap while positive GIANTS pre-turn/turn rate evidence changed much faster.

v4.7.72 keeps D-0141 semantics and repairs those mechanics: strict new admission is unchanged; established-purpose retention uses a bounded 1.0 m lateral and 0.95 heading band; active Runtime/Control runs at 250 ms; positive native/physical leader transition rate updates the elastic cap; positive native reverse may stop forward follower progression; zero/default native command remains unresolved. The historical 0.90 multiplier remains legacy-shadow only.

## D-0141 — Aligned Follower Boundary-Demand Regulation (2026-08-10)

**Status:** accepted for offline implementation alignment and one bounded live validation. Owner-declared v4.7.49 remains canonical; v4.7.71 is not promoted by this decision.

**Triggering evidence:** D-0140/v4.7.70 intentionally withdrew follower actuation and then reproduced the genuine adjacent-following failure at the second encounter. Condor and Patriot were positively co-directional and line-astern; unrestricted Patriot progression consumed the Action Space required for Condor's boundary transition and both workers blocked. This complements the v4.7.69 negative counterexample where the old historical-sweep model manufactured follower authority between remote workers.

**Decision — separate the responsibilities:** active follower protection is rebuilt as three distinct concerns: **current Adjacent Following Knowledge**, **Provisional Boundary Demand Knowledge**, and **elastic Control magnitude**. They must not be collapsed into a historical manoeuvre envelope or diagnostic controller.

**Current Adjacent Following:** Situation Assessment may positively support the ordered relationship only from current positive Productive/Settled continuations, coherent co-directional headings, leader-before-follower ordering and overlap of the current productive working corridors. No maximum following-distance rule is introduced. Historical native manoeuvre geometry has no authority to manufacture current adjacency.

**Provisional Boundary Demand:** until production boundary-demand Representation Fitness is discovered, use the already-accepted D-0124 Provisional Demand Seed. GIANTS working width may seed coarse spatial demand; a bounded 13 s temporal literal is implementation/test mechanics only. The seed is `USABLE_WITH_UNCERTAINTY`, not Assembly footprint, turn recognition or route prediction. Historical `NativeManoeuvreObservationSource` evidence remains boundary-demand `UNRESOLVED`.

**Regulation magnitude:** D-0138 `spec_aiFieldWorker.aiDriveParams.maxSpeed` may supply the current unrestricted follower rate because live evidence established it as the immediate native field-worker command surface before OuttaMyWay's P22 wrapper. It is rate Observation only, not continuation geometry. Zero command is `UNRESOLVED`, never authority for a zero cap. The cap is recomputed from the current demand-ordering picture and is elastic; the historical 0.90 test factor and tighten-only/minimum-ever ratchet are excluded from the aligned path.

**Purpose lifecycle:** once admitted, `PRESERVE_BOUNDARY_TRANSITION_ORDERING` is sticky through temporary uncertainty. Positive current inverse evidence retires it. D-0139 **Progress Passage** is explicit positive purpose-succession evidence and retires the matching follower lease when Yield is established compact and Held at Refuge. Independent Regulation purposes remain composable under lease ownership.

**Authority:** follower Regulation must travel Situation → Candidate → mandatory Constraints → Traffic Policeman Decision → Commitment/Obligation → `LiveControlDispatcher` → bounded P22 capability. Diagnostics, raw Observation and Assessment cannot actuate. The legacy follower controller remains shadow-only. D-0131/D-0133 remains shadow.

**Validation contract:** the implementation must simultaneously satisfy six cases: (1) v4.7.70 genuine adjacent-following positive admission; (2) v4.7.69 remote opposite-corners negative admission; (3) Refuge/Progress-Passage retirement; (4) no promotion of long-form native Transitional manoeuvres into follower demand; (5) sticky purpose with upward/downward elastic cap and no ratchet; (6) central authority path only.

## D-0140 — Architecture Authority Alignment / Authority Reset (2026-08-10)

**Status:** accepted for offline implementation alignment and subsequent bounded live validation. Owner-declared v4.7.49 remains canonical; no test lineage is promoted by this decision.

**Triggering evidence:** v4.7.69 fixed D-0139 Refuge Passage purpose succession but exposed a latent remote follower Regulation. A long native GIANTS Transitional/reposition manoeuvre had matured into demonstrated boundary-demand geometry and manufactured a far-away follower relationship. Review showed the same authority pattern pre-dated v4.7.69 and that post-canonical probes/bridges had accumulated cross-layer responsibility.

**Discoveries:** **Architectural Authority Dispersion**, **Layer Responsibility Leakage**, and **Boundary-Manoeuvre Demonstration Overreach**. Native provenance does not establish Representation Fitness for a semantic demand. A diagnostic/prototype implementation location does not grant Decision or Control authority.

**Decision — Authority Reset:** retain useful post-canonical Observation/evidence mechanisms, but withdraw D-0124–D-0133 follower/committed-transition actuation until it is represented as Situation Knowledge with explicit Representation Fitness and travels through Candidate → Constraints → Decision → Commitment → Control. Diagnostics are downstream only.

**Canonical live-chain alignment:** a Runtime-owned coordinator owns live capture/process/dispatch; Productive Continuation is Situation-owned Knowledge; Candidate generation consumes sealed Operational Picture Knowledge; `LiveControlDispatcher` is the only automatic live bridge into bounded P22 capability. P22 executes typed authorised requests and publishes raw execution outcomes; it does not define traffic semantics.

**D-0123 preservation:** Guarded Recovery remains bounded active behaviour because the architecture already establishes Observe → Regulate when positive convergence threatens admitted recovery demand. Its old direct bridge is removed from active loading and the behaviour is rebuilt through Situation threat Knowledge → Candidate → Decision(MAINTAIN) → existing Commitment/supporting Progress authority → central Control.

**Representation decision:** `NativeManoeuvreObservationSource` records native manoeuvre evidence with boundary-demand Representation Fitness `UNRESOLVED`. `turn=true`, heading reversal, duration, distance or boundary proximity alone do not authorise promotion. No fixed maximum-distance/headland heuristic is introduced.

**D-0130 correction of record:** retain the architecture of persistent governing purpose with **elastic Control magnitude**. The post-canonical tighten-only follower implementation is not architectural authority and is disabled by the reset rather than locally patched.

**D-0139 disposition:** retain Progress Passage / purpose-succession as architectural Knowledge. Remove reliance on P22 fixture phase as semantic authority; any future active follower implementation must express succession centrally through current purpose/obligation fitness.

**Validation:** offline conformance must prove no physical-authority acquisition in Diagnostics/Observation/Assessment/Candidates and must exercise D-0123 end-to-end through the aligned chain before one integrated live build is produced.

## D-0139 — Refuge Passage Purpose Succession (2026-08-10)

**Status:** accepted for bounded live validation in v4.7.69; owner-declared v4.7.49 remains canonical.

**Observation:** in v4.7.68, follower-compression Regulation was legitimate while Condor led Patriot toward a boundary transition, but its approximately 10.32 km/h cap persisted after Condor had been deliberately relocated, compacted and Held at Refuge. Recovery admission simultaneously required Patriot to pass before Condor could leave Refuge.

**Discovery — Resolution Dependency Inversion:** the earlier `PRESERVE_BOUNDARY_TRANSITION_CLEARANCE` Control delayed the later event required to complete the resolution. This is a purpose-lifecycle fault, not evidence that approximately 10 km/h is intrinsically wrong during a genuine moving leader/follower relationship.

**Decision:** establishing the matching Yield participant in `TS015_COMPACT_REFUGE_HOLD` positively supersedes that pair's old follower-compression purpose with **Progress Passage**. Retire only the follower-compression Regulation lease and suppress its re-admission for the matching pair while that Refuge hold remains active. This is **Refuge Passage Purpose Succession**.

**Authority:** Progress Passage grants no positive speed command. GIANTS retains Progress route, steering, forward/reverse choice and native speed. Existing Regulation lease composition is preserved, so any independent current obligation may still constrain Progress. When Refuge hold ends, later Regulation requires fresh evidence under its own purpose; the old lease is not resurrected merely because it existed earlier.

**Non-decision:** do not globally relax D-0130's cap, do not create a Refuge-specific numeric speed, do not force cruise speed, and do not weaken Guarded Recovery Regulation.

**Validation:** live evidence must show old-purpose lease retirement at Refuge establishment, native Progress thereafter absent another lease, no same-pair follower-compression re-admission during the hold, and normal independent-lease composition.

## D-0136 / D-0138 live addendum — Repair settlement Future-Space representation input (2026-08-10)

**Status:** implementation repair accepted for passive validation in v4.7.68; owner-declared v4.7.49 remains canonical. No new architectural Decision authority is created.

**Observation:** v4.7.67 live evidence supports D-0138 as an immediate GIANTS field-worker drive-command surface, including explicit reverse and SDK-predicted zero-command blocked states. It does not support treating the current command target as a continuation horizon or Refuge ranking signal.

**D-0136 evidence:** the prior peer-visibility correction was exercised successfully (`compared=1`). Both subsequent Future-Space results nevertheless reported `WORKER_NOT_ACTIVE` even though the persistent tracks were active.

**Cause:** D-0136 iterates persistent `LiveObservationSource` tracks, where current membership is represented by `track.active`. `FieldBoundedFutureSpace.build()` deliberately accepts the observation-worker representation, where current membership is `activeObserved`. Passing the persistent track directly crossed a representation boundary and caused a false unresolved reason.

**Implementation decision:** adapt each persistent track into a transient observation-compatible Future-Space input carrying `activeObserved`, `localIntent`, `fieldWorldSnapshot`, `pose` and `shadowRepresentation`. Do not mutate the track and do not broaden `FieldBoundedFutureSpace` to persistence-layer fields.

**Falsification / validation:** a natural D-0136 settlement must no longer report `WORKER_NOT_ACTIVE` for a currently active persistent track. A settling worker that has entered `TURNING` may legitimately report `MANOEUVRE_SWEEP_NOT_YET_REPRESENTED`; that would confirm the repair is exposing the real architectural limitation rather than masking it.

**Authority boundary:** passive reassessment only. No settlement criterion, Encounter admission, Refuge selection, Regulation, Hold, Reposition, negative-clearance or Control authority changes.

## D-0138 — Probe the GIANTS Native Field-Worker Drive Command surface (2026-08-10)

**Status:** accepted for passive evidence probe in v4.7.67; owner-declared v4.7.49 remains canonical.

**Observation:** D-0137 was falsified by live evidence: `vehicle.aiDriveDirection` / `vehicle.aiDriveTarget` remained invariant across Productive, turning and blocked states. Inspection of the exact supplied FS25 1.21.1.0 SDK explains why. `AIDriveStrategyFieldCourse:setAIVehicle()` initializes those fields to `{0,1}` and `{0,0}`; native field-worker continuation is instead obtained from drive strategies inside `AIFieldWorker:updateAIFieldWorker()`.

**Implementation discovery:** **Native Drive Signal Surface Gap** names the gap between the vehicle-level fields previously observed and the actual dynamic native drive-command surface. The SDK identifies a stronger candidate surface: after strategy evaluation and GIANTS speed/stopping constraints, `AIFieldWorker` writes `moveForwards`, world `tX/tY/tZ`, `maxSpeed` and `valid` into `spec_aiFieldWorker.aiDriveParams`, then transforms that target to steering/reverser-node local space for `AIVehicleUtil.driveToPoint()`.

**Probe decision:** read the already-populated `aiDriveParams` only. Do not call `getDriveData()` from the observer and do not introduce another actuation wrapper. Correlate it with existing Productive/Local-Intent/motion/blocked evidence and existing passive Refuge/Residual events.

**Falsification:** reject this surface if it remains stale/invariant across materially different native states, especially ordinary course execution versus the SDK-predicted blocked zero-target/zero-speed command. Do not rescue it by adding interpretation heuristics.

**Authority boundary:** `aiDriveParams` is provisionally an immediate native field-worker drive command, not a route, destination, Future Space, negative-clearance, Refuge-selection, Decision or Control authority.

## D-0137 — Probe GIANTS Native AI Drive Signal before inventing more prospective geometry (2026-08-10)

**Status:** falsified by v4.7.66 live evidence and exact FS25 1.21.1.0 SDK inspection; superseded for observation by D-0138. Owner-declared v4.7.49 remains canonical.

**Result:** across materially different native states the fields remained `aiDriveDirection=(0,1)` / `aiDriveTarget=(0,0)`. Exact SDK source shows `AIDriveStrategyFieldCourse:setAIVehicle()` initializes those values and does not establish them as the live field-worker command. Derived longitudinal/lateral Candidate values were therefore world-origin artefacts and have no authority.

**Observation:** D-0134 live evidence distinguished a successful Refuge from the recurring bad Refuge only in the eventual Resulting Situation; Demonstrated Productive Coverage and boundary-depth evidence alone would have preferred the wrong side, while `progressFuture` remained unresolved. External research of Courseplay FS25 found that Courseplay supplies `vehicle.aiDriveDirection` and `vehicle.aiDriveTarget` for GIANTS collision handling. That is an external implementation clue, not OuttaMyWay authority, and no Courseplay code is copied.

**Hypothesis:** native GIANTS AI workers may already expose a coherent immediate drive signal that can improve Situation Knowledge without OuttaMyWay predicting or replacing the native route.

**Probe:** v4.7.66 passively records the raw fields, storage form and availability; relates the direction to observed heading/travel, Productive Continuation, Local Intent, reverse/turn/blocked state; and adds descriptive longitudinal/lateral Candidate relationships at D-0134 Refuge evaluation. D-0136 intent settlement also snapshots the native drive signal for the settling worker and same-Field-World active peers.

**Passive plumbing correction:** v4.7.65 `RESIDUAL_SETTLEMENT_SUMMARY compared=0` was caused by checking `otherTrack.activeObserved`; persistent `LiveObservationSource` tracks expose activity as `track.active`. v4.7.66 corrects that probe-only visibility mismatch.

**Authority boundary:** the native fields are not a route, destination, Future Space, negative-clearance, Refuge-selection, Regulation, Hold, Reposition or Control authority. Candidate relation values are descriptive only.

**Falsification:** the hypothesis weakens if native fields are unavailable, stale across materially different native behaviours, incoherent with observed motion, or repeatedly fail to distinguish known good/bad Resulting Situations. One successful correlation is insufficient for promotion.

## D-0136 — Measure Productive Residual settlement by native intent, not geometric absolutes (2026-08-10)

**Status:** accepted for passive evidence probe in v4.7.65; owner-declared v4.7.49 remains canonical.

**Observation:** v4.7.64 correctly represented Condor's split-start unfinished tail as worker-specific Potential Demand and later observed real productive consumption of it. In a manually perturbed but spatially informative run, Condor productively returned to its original starting region and GIANTS then transitioned to a new turn/reposition while only 136/185 projected residual cells were painted. The remaining cells were plausibly approximately the headland-width region. This disproves `100% coarse residual cells painted` as settlement authority; the exact omitted width is not promoted to architecture.

**Decision:** retain the coarse residual as Potential Demand evidence, but measure settlement from the native intent lifecycle. A residual may become *apparently satisfied* only after ordered positive evidence that the worker productively re-entered the residual, continued productive consumption while progressing toward the originating productive region, reacquired that origin at the current productive-working-footprint Representation Fitness, and then positively changed from Productive Continuation to GIANTS `TURN_SEGMENT`. Geometric fill ratio remains diagnostic/supporting evidence only.

**Traffic significance:** the Productive→Transitional change after origin reacquisition identifies the point at which the previously supported return-purpose no longer explains the worker's next movement. At that point the existing coarse Future-Space machinery may shadow-check whether another active worker already creates a potentially conflicting supported relationship. Positive intersection warrants only Traffic Policeman reassessment in the probe.

**Authority boundary:** no D-0136 witness directly Regulates, Holds, Repositions, selects a Refuge, predicts an exact GIANTS route or actuates Control. Absence of the witness cannot prove absence of future demand. The chessboard/grid is evidence representation, not behavioural policy.

**Falsification:** D-0136 weakens if natural runs fail to show the ordered witness around visually evident split-start completion, if origin reacquisition repeatedly fires on unrelated productive work, or if the Productive→turn transition occurs without meaningfully retiring the residual-supported purpose.

## D-0135 — Test Productive Coverage Residual and Residual Settlement as an earlier reassessment signal (2026-08-10)

**Status:** accepted for passive evidence probe in v4.7.64; owner-declared v4.7.49 remains canonical.

**Subsequent result:** the geometric `100% residual cells painted` settlement criterion was disproved by v4.7.64 live evidence and is superseded for testing by D-0136. The residual-as-Potential-Demand portion remains supported.

**Observation:** D-0134 established that Demonstrated Productive Coverage is useful historical Knowledge but is not standalone Refuge authority. The user identified the complementary pattern: when a worker begins Productive work materially inside the field, coherent unpainted cells behind that first productive corridor may represent work it plausibly still needs to satisfy.

**Architectural interpretation under test:** an unpainted cell is never demand by absence alone. A coherent unpainted continuation of positively demonstrated productive geometry may support existing `Potential Demand`. Later native movement toward it can increase confidence without predicting the exact GIANTS route. When positively Productive work fills that residual, **Residual Settlement** provisionally names retirement of that particular Potential-Demand basis; the worker's next native purpose remains unresolved.

**Probe decision:** v4.7.64 passively opens only a first-Productive backward-corridor residual, observes convergence and settlement, then asks existing field-bounded Future Space whether another active worker in the same Field World already forms a positive coarse intersection at settlement. Positive evidence would justify Traffic Policeman reassessment only.

**Authority boundary:** no D-0135 evidence may directly Regulate, Hold, Reposition, choose a Refuge or actuate Control. Existing v4.7.63 behaviour is unchanged.

**Falsification:** failure to identify the known Condor residual, failure of later native motion/productive work to converge and settle it, or absence of a positive coarse intersection at settlement would show that the proposed early intervention point is not yet supported by current Knowledge.

## D-0134 — Test whether positive productive history improves Refuge resulting-situation qualification (2026-08-10)

**Status:** accepted for passive evidence probe in v4.7.63; owner-declared v4.7.49 remains canonical.

**Observation:** the v4.7.62 Regulation/egress-protection chain behaved as intended, but Condor's chosen second Refuge became a stationary obstruction to Patriot. Both literal fixture Refuges were boundary-adjacent; earlier success of one appears contingent rather than evidence of generally good Refuge quality. The operator's human preference is to move Yield infield, especially into space the Progress worker has already productively vacated.

**Hypothesis:** existing architecture may already contain enough Knowledge to explain that preference without a permanent headland no-go zone. In addition to current Future Space and demonstrated boundary manoeuvre demand, Situation can potentially use a positive history of where a Job Episode was actually witnessed performing Productive work.

**Bounded evidence term:** **Demonstrated Productive Coverage** denotes Job-Episode-scoped positive history built by OuttaMyWay from observed productive Working-Footprint sweeps. It is not an authoritative agronomic application map, not negative evidence for unpainted space, and not proof that Transitional Demand has retired. The chessboard/rook metaphor is explanatory only, not canonical spatial vocabulary.

**Probe decision:** v4.7.63 remains passive. It paints coarse cells only between consecutive live work-marker segments while Productive Continuation is positive, then shadow-evaluates the unchanged fixture Refuge candidates and additional infield candidates against Field World fit, Progress Future Space, demonstrated boundary-manoeuvre entry band and productive-history coverage. Existing TS015 Refuge selection is untouched.

**Disproof condition:** if the evidence vector cannot distinguish the operator-preferred infield occupancy from the boundary candidates, do not encode `headland = forbidden` or `toward centroid = preferred`; identify the missing Knowledge instead.

## D-0133 — Pre-Handoff Progress Horizon Retention

**Status:** Accepted for bounded live test implementation in v4.7.62; owner-declared v4.7.49 remains canonical.

**Evidence:** v4.7.61 improved the physical setup through D-0130: Patriot retained materially better separation and Condor's compressed Refuge was almost clean. D-0131 still did not apply. Immediately before the second Reposition admission Patriot had positive Productive Continuation, the same tracked Local Intent epoch, and roughly 142 m of valid field-bounded continuation. At admission, D-0132 queried the live horizon again and received `FIELD_BOUNDED_PROGRESS_HORIZON_UNAVAILABLE_AT_ADMISSION`; shortly afterwards D-0131 saw egress entry around 9.89 m but had no sealed fallback. The implementation therefore attempted to **discover** evidence at the handoff instead of retaining evidence already positively known before it.

**Decision:** this remains evidence-continuity implementation debt, not new traffic architecture. While the existing follower/maturation observation has positive Productive Continuation, positive `SETTLED_CONTINUATION`, a stable Job Episode / tracked Local Intent epoch, and a positive field-bounded continuation, the D-0131 test bridge may retain that latest field-bound endpoint. Reposition admission still prefers live field-bounded evidence; only when that live sample is transiently unavailable may it seal the retained pre-handoff endpoint.

**Validity / anti-self-satisfaction:** retained evidence is keyed by Progress reference, Job Episode and tracked Local Intent epoch. Admission requires the same still-positive Productive / settled basis. The retained field-bound endpoint is fixed in world space; remaining horizon is recomputed from the current Progress pose, so Progress movement only consumes the retained horizon. Job/intent/productive invalidation or endpoint exhaustion removes fallback support.

**Authority boundary:** D-0131's egress-sweep intersection/timing rule, D-0130 maturation Regulation, and the existing temporary 1 km/h test mechanism remain unchanged. Retention creates no new negative-clearance authority, speed policy, route prediction, or intervention by itself.

**Parked:** Refuge-role selection, first-Refuge timing, speed/distance calibration and comfort, brute-force actuator remediation, and Productive/Transitional crossing resolution remain unchanged.

## D-0132 — Progress Horizon Handoff Evidence Continuity

**Status:** Accepted for bounded live test implementation in v4.7.61; owner-declared v4.7.49 remains canonical.

**Evidence:** v4.7.60 preserved the D-0130 maturation lease at about 18.3 km/h, but D-0131 never exercised. At the compressed second Refuge the bridge already had a close egress-sweep entry witness (`9.34 m`) yet returned `FIELD_BOUNDED_PROGRESS_HORIZON_UNAVAILABLE` during the strategy→egress handoff. Before that seam, Progress had a valid field-bounded continuation; after the seam became representable again, the positive egress-sweep intersection had disappeared.

**Decision:** this is evidence-continuity implementation debt, not a new traffic concept. At committed Reposition admission the bounded test bridge may seal the latest positively supported Progress field-bounded continuation horizon. Live field-bounded evidence always takes precedence. The sealed horizon may bridge a temporary live-horizon gap only while the Progress Job Episode is unchanged, the replacement-core tracked Local Intent epoch is unchanged and still positively `SETTLED_CONTINUATION`, and Productive Continuation with forward GIANTS movement remains positive. Remaining sealed horizon is recomputed from the current Progress pose to the originally sealed field-bound endpoint, so the seal cannot become a moving baseline.

**Invalidation / authority boundary:** Job Episode change, Local Intent epoch change/loss, loss of positive Productive Continuation, or exhaustion of the sealed horizon removes fallback support. No unavailable evidence is converted into danger, no negative-clearance authority is created, and D-0131's geometry/timing rule plus existing temporary 1 km/h test literal remain unchanged.

**Parked:** Refuge-role selection, first-Refuge timing, calibration/comfort literals, brute-force actuator remediation, and Productive/Transitional crossing resolution remain unchanged.

## D-0131 — Committed Transition Protection Implementation Catch-up

**Status:** Accepted for bounded live test implementation in v4.7.60; owner-declared v4.7.49 remains canonical.

**Evidence:** v4.7.59 validated D-0130's purpose-preserving maturation Regulation: Patriot remained at the retained 18.60 km/h cap through the second clean head-on. However, after Condor's second Refuge was admitted and egress began, no stronger supporting Regulation was created. D-0129 simultaneously showed Patriot's positively represented progression entering Condor's Committed Demand while the retained maturation lease remained unchanged.

**Decision:** no new architectural concept is introduced. Implement the already-settled D-0077/D-0118/D-0115 requirement that admitted transition demand may independently justify supporting Regulation. The bounded TS015 test bridge represents the known outbound egress sweep from the current Yield pose to the admitted fixture target and compares it with the Progress worker's positively Productive, field-bounded native continuation. A stronger lease is admitted only when positive geometry and timing evidence show that Progress would enter the represented egress sweep **no later than the ideal max-speed completion lower bound** for the remaining egress. This is a positive threat witness, not a safety prediction.

**Authority boundary:** the bridge reuses the existing D-0123 1 km/h temporary implementation literal; v4.7.60 introduces no new speed, distance, reaction-time, or heading policy. Absence of the positive witness carries no negative-clearance authority and cannot retire an already-active transition-protection lease. The lease retires when the committed egress completes or its governing Job/context invalidates, revealing any still-live D-0130 maturation lease underneath it.

**Parked:** Refuge-role selection, far-too-early first Refuge timing, numeric calibration/comfort tuning, brute-force actuator remediation, and productive/transitional crossing resolution remain unchanged.

## D-0130 — Purpose-Preserving Regulation Implementation Catch-up

**Status:** Accepted for bounded live test implementation in v4.7.59; owner-declared v4.7.49 remains canonical.

**Evidence:** v4.7.58 D-0129 observed a stable progression-preservation witness while the existing D-0126 follower cap was repeatedly re-derived from the worker's advanced current position. The protected witness headroom was consumed even as the cap relaxed. The same lineage also released follower Regulation on opposed strategy succession, after which D-0123 recovery protection had to reacquire a separate single-owner drive state.

**Decision:** no new architectural concept is introduced. Implement the already-settled sticky-Purpose / elastic-cap rule as follows: while the same named Regulation purpose persists, a freshly derived cap may **tighten or maintain** the active cap but may not relax it solely because current geometry has advanced. Relaxation still requires positive purpose retirement or a separately justified new purpose. A clean opposed continuation may supersede the primary Resolution Strategy but does not by itself positively retire an independently justified supporting Regulation.

**Effective actuation composition:** the bounded P22 drive authority now permits multiple independently justified Regulation leases on one participant. Physical speed authority is the least-permissive active lease. Each owner may release only its own lease. This allows the existing D-0123 Guarded-Recovery 1 km/h test lease to temporarily tighten an already-retained maturation Regulation and, on positive recovery-clear evidence, return control to the still-live maturation cap rather than erasing it. This is implementation catch-up for established Effective Actuation Composition, not production Control architecture.

**Non-decisions / parked:** no new speed, distance, reaction-time or heading literal; no Refuge candidate/role-selection change; no early-first-Refuge timing change; no brute-force actuator repair; no productive/transitional crossing playbook; no general negative-clearance authority. D-0129 remains passive and cannot authorize a speed.

## D-0129 — Purpose-Bound Progression Preservation Shadow Probe

**Status:** Accepted for passive bounded implementation probe in v4.7.58; owner-declared v4.7.49 remains canonical.

**Evidence basis:** v4.7.57 finally exercised Condor-leader / Patriot-follower Regulation, but the geometry-derived cap rose as Condor approached its boundary manoeuvre and the Regulation was then released when opposed continuation became authoritative. Patriot therefore consumed much of the Action Space that the earlier Regulation had created, and the succeeding Refuge transition became physically contested. Returning to canonical D-0111/D-0115/D-0123 showed that the missing implementation capability is not a surprise-head-on rule or another speed literal: Regulation already exists to preserve Maturation margin / purpose-bound Action Space while bounded GIANTS-native progression remains supportable. Observation already measures realised motion; Situation Assessment did not promote that evidence generally, and the immutable Commitment context exposed obligation IDs without sufficient open-obligation meaning for Candidate reasoning.

**Decision:** v4.7.58 adds a **passive shadow probe only**. Live Observation publishes realised progression evidence (actual travel direction/rate plus Local Intent epoch/validity); Situation Assessment promotes that motion Knowledge, configuration-filtered positive Physical Assembly primitives, and immutable open-obligation meaning into the Operational Picture. The probe projects only the presently positively supported native continuation and compares known represented primitives against Current Space, field-bounded Committed/Potential Demand where representable, and a coarse uncontaminated demonstrated boundary-maturation witness. It records a stable per-purpose/per-intent witness baseline and how much known witness headroom has subsequently been consumed.

**Authority boundary:** the probe has **no Decision, speed, clearance, or Control authority**. Existing Physical Assembly/Future Space representations still lack general negative-clearance authority; therefore `knownWitnessEntryM` is a positive represented-demand witness / upper bound, not a claim that all earlier progression is safe. Response opportunity / Response Margin remains unmodelled, so response-adjusted supportable progression is explicitly `UNRESOLVED`. No fixed reaction time, braking model, new speed cap, Hold threshold, route prediction, or reverse command is introduced.

**Anti-self-satisfaction rule:** a witness baseline is sticky for its named evidence basis and Local Intent epoch. The baseline is not silently reset as the subject advances or as a different footprint primitive becomes nearest. Material intent/evidence change invalidates the witness and begins a new basis. This directly tests the canonical Temporal-Separation-Reserve warning against regulated-headway self-satisfaction.

**Test isolation:** v4.7.57 behaviour is retained unchanged, including D-0126's 0.90 test factor, current Regulation lifecycle, D-0128 head-on gate, P22 Refuge mechanics, and all parked literals. Refuge-role selection, Condor's far-too-early first Refuge, speed/distance calibration, pacing oscillation, and Refuge brute-force remediation remain deliberately parked until the current scenario and the forthcoming sliding-puzzle evidence are exhausted.

## D-0128 — Positive Head-On Re-admission Evidence

**Status:** Accepted for bounded implementation test in v4.7.57; v4.7.49 remains canonical.

**Evidence:** In the v4.7.56 live run, the first Refuge reached positive GIANTS native reacquisition at 18:48:34.579. About 148 ms later the bounded capability bridge logged `HEADON_RESOLUTION_SUCCESSION` and dispatched another Refuge. The current pair evidence at that moment was not a clean pure head-on: observed `headingDot` was approximately -0.38. Inspection showed two permissive implementation conditions: `firstNativeAt` allowed the prior Refuge diagnostic monitor to be superseded before current head-on support was checked, and `LiveTrafficCandidateSupport` classified every negative heading dot as opposed despite declaring its scope as `PURE_ESTABLISHED_OPPOSED_BOTH_PRODUCTIVE_HEAD_ON`.

**Decision:** Positive native reacquisition settles mechanical recovery evidence only; it does not itself establish a new traffic requirement or authorise another Resolution Strategy. A prior completed Refuge diagnostic monitor may be superseded only after the current Operational Picture independently supports a fresh bounded head-on Candidate. The bounded test Candidate must represent genuinely clean opposed continuation rather than merely an obtuse/crossing relation. v4.7.57 therefore uses `headingDot <= -0.99` as a temporary test-fit gate. The literal has no production policy authority and is subject to later Representation Fitness work.

**Test isolation:** D-0127 deferred native-sweep closure and the D-0126 0.90 Transition-Clearance pacing factor remain unchanged. The newly observed Patriot speed oscillation is recorded but deliberately not modified in v4.7.57. No cooldown, elapsed-time lockout, new Encounter identity, Provisional Demand Seed, cross-field strategy, or general Control authority is introduced.

## D-0127 — Deferred Native-Sweep Evidence Closure

**Status:** Accepted for bounded implementation test in v4.7.56; v4.7.49 remains canonical.

**Evidence:** v4.7.54 accepted Condor's native heading-reversing boundary sweep. v4.7.55 observed a near-identical Condor sweep (about 12.2 s and ~177° reversal) but closed it as `TURN_EVIDENCE_ENDED_UNRESOLVED`; positive `NON_TURN_LINE_ACTIVE` / settled-continuation evidence appeared roughly one probe interval later. Because the follower test requires a demonstrated leader demand, the intended Condor-leader / Patriot-follower relation was never evaluated and D-0126 Regulation was never applied. Direct package comparison found the headland evidence code unchanged between v4.7.54 and v4.7.55.

**Decision:** A completed coherent native manoeuvre must not lose potential demonstration authority solely because settled-continuation evidence is absent at the first non-TURNING sample. The measurement is frozen when turn evidence ends and enters `WAITING_FOR_EVIDENCE`. Only subsequent positive settled continuation validates it. Waiting time and post-turn travel do not extend the frozen demand measurement. Job Episode change, active-job disappearance, a new turn before settlement, or OMW Control contamination prevents positive native-demonstration authority. No timeout creates success.

**Test isolation:** v4.7.56 leaves the D-0126 0.90 Transition-Clearance factor unchanged. The next live run asks first whether Condor's demonstration survives the sampling boundary and therefore admits the intended Condor-leader / Patriot-follower pacing; only then can the Transition-Clearance hypothesis be evaluated.

## D-0126 — Boundary pacing preserves Transition Clearance through intent revelation (2026-08-09)

**Status:** Accepted for bounded implementation test in v4.7.55; v4.7.49 remains canonical.

- v4.7.54 showed that near-zero leader-first/follower-second timing can be geometrically correct yet leave insufficient Action Space for a succeeding known Resolution Strategy.
- The leader/follower Regulation playbook therefore preserves **Transition Clearance**, not merely manoeuvre-completion ordering.
- Regulation remains the least-restrictive supported progression control; it should be conservative enough that native boundary intent can reveal a compatible continuation or mature into another known traffic requirement while useful Action Space remains.
- This does not create a standalone temporal reserve or require predicting turn direction. Existing Time, Future Space, Action Space and Transition Clearance remain the architectural vocabulary.
- v4.7.55 uses a temporary 0.90 factor on the raw geometry-derived follower maximum solely to test adequacy. The factor is not policy and should not be optimised for precision.
- HUD housekeeping is separate: obsolete OTM/P22 on-screen test remnants are retired and current build/pacing information is consolidated on the right-hand OuttaMyWay HUD surface.

## D-0125 — Resolution Strategy succession remains one Traffic Policeman responsibility (2026-08-09)

**Status:** Accepted for bounded implementation test in v4.7.54; v4.7.49 remains canonical.

- Traffic Policeman competence is represented by the existing Candidate Action Space and multi-stage Resolution Strategy architecture, not by an Encounter-lifetime if/then latch.
- A proven head-on Refuge resolution must not be permanently consumed merely because it was used earlier in the same Encounter.
- Duplicate dispatch is prohibited while that refuge resolution is currently active or its GIANTS handoff remains unresolved.
- After positive native reacquisition, later Reality may support another head-on Resolution Strategy; if the governing traffic responsibility is still live, Decision **REVISES the same Commitment** rather than creating a second Commitment.
- A later material displacement creates a fresh Native Continuation Restoration obligation. The continuing Durable Separation obligation is not duplicated.
- v4.7.54 tests only succession of the two already-supported strategies: boundary leader/follower Regulation may mature into a clean head-on, then the established Refuge strategy may resolve that head-on.
- No cross-field strategy, Provisional Demand Seed, reaction margin, or production Refuge qualification is introduced.

## D-0124 — Preserve follower boundary Action Space through demand sequencing


**Status:** Accepted architecture/evidence consolidation after non-canonical v4.7.50-v4.7.52 follower-maturation probes. Owner-declared v4.7.49 remains canonical.

**Evidence:** v4.7.50 and v4.7.51 established repeatable native boundary-turn demand and strongly supported follower Action-Space Compression as positive Regulation evidence. v4.7.52, rebuilt from exact canonical v4.7.49, actively applied a Situation-derived follower speed cap while GIANTS retained route/steering/direction. The live run demonstrated real speed Regulation but repeatedly alternated `REGULATION_APPLY` and `REGULATION_RELEASE` (62 of each, zero `REGULATION_MAINTAIN`) and ultimately reproduced mutual boundary blockage. The failure therefore disproves the test Regulation lifecycle, not the underlying demand geometry; reaction margin remains unresolved. OMW-Control-influenced manoeuvres remain invalid as native demand evidence.

**Decision — boundary demand without turn prediction:** a line-astern leader/follower pair progressing toward the same field boundary may require Traffic-Policeman Regulation before GIANTS reveals either worker's boundary continuation. OuttaMyWay need not know whether the leader or follower will turn left or right. `turn=true`, literal U-turn recognition, route prediction and semantic turn classification have no authority for this decision. The relevant fact is that straight continuation terminates at the Field World boundary and each worker must retain sufficient field-bounded Action Space for GIANTS to continue.

**Decision — coarse demand envelope:** spatial demand `x` and temporal demand `t` are evidence mechanics for estimating how long the leader may continue to require follower-relevant boundary space. They are not a precision model of the native manoeuvre and do not create a new Space ontology. Adequacy is the goal: refine the envelope only when Reality shows it is under-protective or materially over-conservative for Productive Continuation/player experience.

**Decision — Provisional Demand Seed:** when no uncontaminated native boundary demonstration is yet available, Situation Assessment may use a conservative **Provisional Demand Seed** so an otherwise-supportable leader/follower Situation is not unprotectable at startup. Working width may seed `x` only as a coarse demand estimate; it is not Physical Assembly extent or footprint authority. A provisional `t` may be a deliberately conservative implementation/test value until Reality supplies better fitness evidence. No fixed seed value gains architectural authority.

**Decision — temporal ordering:** follower Regulation preserves ordering of access to relevant Future Space: the follower must not require boundary Action Space before the leader has vacated the portion still relevant to the follower. A distant follower normally requires no Control because natural progression already preserves that ordering. Regulation becomes necessary at the earliest Decision epoch where unrestricted follower progression would cease to preserve it. Beginning then permits the least restrictive speed reduction and best protects the intended near-invisible player experience.

**Decision — persistent purpose, elastic cap:** once admitted, the protection obligation persists while the leader's relevant demand remains positively unresolved. The numeric cap may rise, fall, or reach the worker's natural GIANTS speed as Reality changes; successful Regulation making the instantaneous geometry supportable does not retire the protection purpose. The speed calculation answers how much Control is currently required, not whether the governing purpose still exists.

**Decision — symmetric positive retirement:** the same spatial-temporal relationship that admits protection retires it when positive current evidence establishes that the leader's realised/plausible demand no longer constrains the follower's relevant field-bounded Future Space or will vacate it before the follower requires it. Turning away may therefore retire the relevant demand before the leader's complete manoeuvre finishes; turning through follower-relevant space preserves the obligation until the relationship is positively compatible. Evidence absence, a temporary positive reserve, a natural-speed cap, `turn=true`, elapsed `t`, or manoeuvre-start detection alone cannot establish retirement.

**Presentation consequence:** diagnostic/player-facing HUD should explain current Traffic-Policeman intervention in human terms (for example, that a follower is pacing for another worker's boundary clearance) while detailed geometry and cap derivation remain forensic log evidence. Explanation does not relax the requirement that normal intervention be minimally perceptible.

**Open implementation/evidence questions:** reaction/safety margin; exact provisional seed values; the coarsest fit representation for `x/t`; noise handling without purpose oscillation; and the smallest evidence contract that positively proves demand retirement. These are implementation/test questions under this decision, not authority for new route prediction.

## 2026-08-09 — v4.7.49 certification note: v4.7.48 live PASS, no new architectural decision

**Status:** implementation validation / knowledge promotion only.

The v4.7.48 owner live run validates the already-settled D-0122/D-0123 sequence: proposed recovery that is already incompatible remains uncommitted while Yield waits at refuge and Progress passes under GIANTS; once recovery becomes positively supportable it may be committed; if new convergence develops after that point, D-0123 Regulation may protect the committed recovery. Positive same-Job GIANTS reacquisition settles the recovery obligation only and does not establish Durable Separation.

The successful live test does **not** decide production numeric speed policy. The active 15/5/1 km/h mechanism values remain temporary implementation/test literals. No time-based refuge-release authority is restored.

No new root architectural concept is introduced by v4.7.49.

## 2026-08-09 — v4.7.48 implementation conformance note

No architectural decision changed. Live v4.7.47 evidence exposed a Candidate–Commitment Authority Contract Gap: physical actuation ownership declared implicitly by Effective Actuation Composition was not copied into the explicit Commitment-admission ownership field. v4.7.48 repairs the implementation and adds exact-set conformance validation. Traffic-role Progress remains GIANTS-owned while selected Yield owns OTM REPOSITION actuation.

## D-0123 — Exhaust Guarded-Recovery Observation on Vulnerable-Space Convergence

**Status:** Accepted architecture for v4.7.41candidate; production Decision/Control remains disabled

**Context/evidence:** the v4.7.40 carry-forward review confirmed that D-0122 deliberately left one contract open: when Situation Assessment has enough evidence that continued Observation during Guarded Recovery is consuming rather than preserving Action Space. Bird's-eye review of TS015 made the practical boundary visible before exact Future-Space conflict: once Condor turned generally toward recovering Patriot, further unrestricted continuation was no longer a useful way to buy certainty. The same wide workers can nevertheless pass normally in adjacent lanes after recovery vulnerability has ended, so a permanent enlarged clearance envelope would be incorrect.

**v4.7.45 live evidence refinement:** repeated shadow runs narrowed the implementation interpretation without changing the decision above. The traffic-relevant event is not `turn=true`; it is the point at which presently revealed native continuation is directed into remaining protected recovery demand — the explanatory “headlights light the dome” condition. In the stronger phase-shifted run Patriot had already completed its headland turn and was Productive on the return pass when Guarded Recovery began; the selected shadow family was positive at long separation and the pair later progressed through Condor blocked, Patriot blocked and positive Current-Space interaction. Observed travel disappeared once the worker stopped, so instantaneous motion cannot be the sole continuation authority. Current heading combined with positive same-Job continuing-native-intent evidence therefore has increasing support as the coarse projection basis. `VS_COMMITTED_RECOVERY_UNION` has increasing support because it derives vulnerability from remaining recovery demand rather than an invented permanent buffer. These are evidence-supported implementation hypotheses, not yet a certified universal geometric construction.

**Decision — Vulnerable Space:** while Guarded Recovery remains under OuttaMyWay recovery responsibility, the recovering participant has temporary **Vulnerable Space** representing the recovery Action Space whose preservation currently has reduced tolerance for another participant's unrestricted native development. It is a derived Situation Assessment representation, not a new root Space ontology, permanent clearance buffer or claim that the participant physically occupies the whole region. The dome/circle analogy is explanatory only; exact construction is an implementation/evidence question.

**Decision — Convergent Projection:** Situation Assessment may represent the other Encounter participant's presently revealed native continuation as a coarse **Convergent Projection**. It answers whether current native development is directed toward the vulnerable recovery strongly enough to become traffic-relevant without claiming the participant will follow an exact predicted route. The headlight-cone analogy is explanatory only. No fixed-distance horizon, TCPA/DCPA metric, exact GIANTS route reconstruction or literal ray-cast implementation gains authority. Guarded Recovery already exists inside a local Encounter/refuge context, so no independent map-wide range gate is required by architecture.

**Decision — Observe exhaustion:** when the Convergent Projection intersects Vulnerable Space, Situation Assessment has positive evidence that unrestricted continuation is consuming Action Space Traffic Policeman must preserve for the active recovery. `CONTINUE_OBSERVATION` is exhausted at that point; waiting for exact conflict would be procrastination rather than bounded evidence acquisition. Intersection does not itself command Hold. Decision must still prefer `REGULATE_SPEED` while a positively supportable non-zero GIANTS-owned progression can preserve the recovery, and may use `HOLD_AT_SAFE_POINT` only when such progression is exhausted and the current occupancy is itself a supportable waiting state.

**Decision — vulnerability expiry:** the heightened Guarded-Recovery tolerance ends when positive evidence under the already-established Native Handover/restoration contract shows that GIANTS has fully reacquired native authority over the recovering worker. This is not traffic settlement: Encounter, Commitment and Traffic Policeman responsibility may continue until their existing completion conditions are satisfied. Once the heightened vulnerability expires, ordinary cooperative tolerances resume and Protected Progress Alternation may legitimately reverse the temporary roles if the formerly recovering worker's later GIANTS-native movement begins consuming the other participant's Action Space.

**Boundary:** no permanent exclusion zone, one-worker-at-a-time rule, exact geometric shape, numerical buffer, prediction distance, speed threshold or production actuator is introduced. The next implementation/evidence objective is to discover a conservative representation of Vulnerable Space and Convergent Projection from existing Reality evidence and validate that representation passively before connecting it to production Decision/Control.

## D-0122 — Restore Native Continuation and Protect Recovery Dynamically

**Status:** Accepted architecture/evidence consolidation; owner-declared canonical in v4.7.40; production Decision/Control remains disabled

**Evidence:** v4.7.38 direct-refuge handback preserved the same GIANTS Job Episode but produced materially different native recovery: Condor skipped the interrupted lane remainder and selected another pass that recreated a head-on, while Patriot visually appeared to reacquire its interrupted lane. v4.7.39 then returned each displaced sprayer approximately toward its pre-egress continuation context before handback. Both Condor and Patriot visually reacquired the interrupted lane despite materially imperfect rejoin heading. A supplementary Patriot run with Precision Farming enabled as an observation instrument showed no obvious material untreated gap in the fertiliser lane attributable to the diversion/rejoin. In a separate complex continuation, Patriot's restoration itself succeeded but Condor's later native diagonal transition entered Patriot's recovery space and the pair deadlocked.

**Decision — Native Continuation Restoration:** when OuttaMyWay materially displaces a worker, responsible recovery should restore a supportable state derived from the positively observed pre-intervention continuation context before unrestricted GIANTS handback, where that restoration remains compatible with current traffic obligations. OuttaMyWay owns reversal of its own disturbance; it does not own reconstruction of GIANTS' exact route. The retained **Rejoin Anchor** is a recovery reference, not an exact-position/heading mandate. Current evidence does not justify additional Control solely to reproduce the original pose more precisely.

**Decision — Guarded Recovery:** recovery may begin while another participant's continuing native intent remains uncertain only where the recovery Action Space is presently supportable and the remaining uncertainty is affordable because Traffic Policeman retains sufficient means to protect the recovery. Once authorised, the active recovery Action Space is Committed Demand. Traffic Policeman remains active/ready and reevaluates the other participant as Reality develops: continue Observation while compatible; use bounded Regulation when revealed demand begins to threaten the committed recovery; use Hold when no positive native progression can preserve it. A fixed dwell, physical passage or present recession is not sufficient recovery authority.

**Decision — Protected Progress Alternation:** temporary movement priority may alternate between participants within one continuing Commitment as the currently protected demand changes. Initial `PROGRESS` status is not a permanent right. A former Progress participant may be Regulated or Held while an intervention-created Yield recovery obligation completes; later priority may change again as native intent evolves. This is not a one-worker-at-a-time rule: concurrent movement remains preferred whenever positively supportable. Repeated alternation without reduction of obligations remains Revelation Oscillation and is invalid.

**Decision — Expedient Manoeuvre Execution:** once a bounded OuttaMyWay egress or recovery Manoeuvre Leg is justified, Control should execute it at the greatest speed positively supportable by current geometry, configuration, transition sweep and proven capability. Minimum Necessary Authority limits *what* OuttaMyWay owns; it does not require timid execution after authority has been granted. No numeric fixture speed becomes production policy.

**Decision — continuation after handback:** successful same-Job GIANTS movement confirms mechanical handback, not traffic resolution. The Traffic Policeman/Commitment remains observationally responsible until Durable Separation is positively supported relative to the remaining obligations and credible Return/Encounter Recurrence Potential.

**Testing boundary:** Precision Farming is not part of the standard OuttaMyWay test environment. It was intentionally enabled only for the supplementary Patriot agronomic-view experiment. Standard validation remains DLC-free; no runtime dependency or test requirement on Precision Farming is introduced.

**Next objective:** define the Situation Assessment evidence contract that exposes when another participant's developing Current/Future/Potential Demand is beginning to threaten committed recovery, such that Observe is exhausted and Regulation/Hold becomes justified. No production implementation is authorised by this decision.

## D-0121 — Probe Native Continuation Restoration Before Arbitrary Refuge Handback

**Status:** Accepted evidence hypothesis for v4.7.39candidate; production architecture remains under test

**Evidence:** v4.7.38 produced two valid same-Job direct-refuge handbacks after materially similar TS015 intervention. Condor resumed native authority but skipped the remainder of its interrupted lane, selected another pass and recreated a head-on with Patriot. Patriot visually appeared to return to its interrupted lane. The difference is **Native Recovery Variability**: same-Job GIANTS handback does not establish a predictable coverage-recovery trajectory. Archived TS015 implementation evidence separately shows a proven forward-only rejoin/orientation mechanism and successful GIANTS continuation after the displaced worker was returned near its pre-egress continuation state.

**Hypothesis:** when OuttaMyWay materially displaces a worker, responsible recovery may include **Native Continuation Restoration**: return toward a supportable state derived from the positively observed pre-intervention continuation context before unrestricted GIANTS handback. This is distinct from reconstructing GIANTS' route; it is undoing OuttaMyWay's own spatial disturbance.

**Test decision:** v4.7.39 records the settled pre-egress position/heading as a probe Rejoin Anchor, keeps the worker compact through refuge Hold and ingress, reuses only the archived empirically successful forward-only orientation mechanism when the rejoin reference begins behind the worker, settles near a short forward reference from the anchor, restores the original configuration while Held, then releases the same Job Episode and observes GIANTS hands-off for 120 seconds.

**Boundary:** the Rejoin Anchor, forward offset, orientation speed/steer values, refuge dwell and movement speed are test literals/mechanisms only. This does not yet establish a production Rejoin Anchor primitive, exact-pose restoration obligation, GIANTS coverage ownership, Safe Release rule or speed policy. `CONTROL_AUTHORITY_ENABLED=false` remains mandatory.

## D-0120 — Correct TS015 Fixture Pace and Separate Configuration Watchdog Scope

**Status:** Test-harness correction for v4.7.38candidate; no production traffic-speed policy decision

**Evidence:** the first v4.7.37 Condor relocation reached its approximately 30 m lateral refuge target with full compact configuration, but the harness then reported `full-compact-timeout` and retained Hold. The timeout had started at the original fold request and continued across the long relocation, so it expired even though compact configuration had already been positively observed. Subsequent explicit `cancel`/`release` allowed the same GIANTS Job Episode to continue, proving the initial non-resume was a harness failure rather than native-recovery evidence. Live video also showed that the 5 km/h relocation ceiling made the bounded refuge manoeuvre unrealistically slow for this characterisation and materially changed the traffic timing being observed.

**Decision — watchdog scope:** the fold-motion watchdog governs only whether actual configuration motion begins before the Manoeuvre Leg. Positive full-compaction evidence during movement retires the initial compaction wait. If full compact configuration remains unresolved after target arrival, endpoint compact waiting is measured from that Settled Movement Boundary rather than from the original fold request. Travel time is not configuration-proof time.

**Decision — test pace:** change the autonomous TS015 fixture ceiling to 15 km/h for the next evidence build. This is a test literal chosen to avoid the known 5 km/h distortion; it is **not** a production speed threshold, preferred Reposition speed or architectural rule. Production speed authority remains open for later architectural discussion and must not inherit this number.

**Boundary:** geometry, timed release, role selection and production Control policy are unchanged. `CONTROL_AUTHORITY_ENABLED=false` remains mandatory.

## D-0119 — Characterise Native Recovery and Make Traffic Resolution Continuation-Aware

**Status:** Accepted architectural refinement plus temporary v4.7.37 evidence harness; production Decision/Control remains disabled

**Evidence and problem:** historical TS015 showed that a physically receding Progress worker near a headland can turn and return to materially the same local traffic space before a displaced Condor has restored and resumed meaningful work. Revised P22-C now proves same-Job spatial displacement/restoration capability, but GIANTS may recover the productive strip after refuge displacement in several ways: immediately, later, not obviously at all, or by repeating a larger pass. Stable Handover must not assume one recovery trajectory.

**Decision — Return Potential:** Situation Assessment may publish positive relational evidence that a presently departing participant's continuing native intent can return its demand to relevant Situation Space before outstanding traffic obligations are discharged. Present recession is not resolution.

**Decision — Encounter Recurrence Potential:** role/action comparison may consider whether a proposed resolution is positively supported as likely to recreate materially the same traffic Situation before durable separation is established. Productive Continuation and arrival order are preferences/evidence only; they cannot force a role assignment that creates a materially poorer successor Situation.

**Decision — Durable Separation:** passage, immediate separation and durable separation are distinct. Durable Separation is sufficient supported separation, relative to outstanding recovery obligations, for the current intervention to unwind without materially recreating the governed conflict. No fixed metres or seconds establish it.

**Decision — decisiveness:** once a supportable Reposition strategy crosses its Commitment Point, reassessment at Settled Movement Boundaries tests continued validity; it does not reopen unrestricted optimisation. A newly marginally better Refuge Region is insufficient reason to switch. Material invalidation, failure of expected Reachability Progress or material Governing-Basis/Reality change may replace the strategy. Conduct principle: **do not be indecisive; do not procrastinate; do not be stubborn.**

**Evidence harness:** v4.7.37 adds explicit-command `otmP22 relocate <Condor|Patriot>` to perform one fixture relocation/restoration/timed handback and observe GIANTS for 120 seconds. The 10 m/30 m/5 km/h/8 s/20 s/120 s literals are characterisation fixtures only and carry no production Safe Release or Durable Separation authority.

## D-0118 — Separate Refuge Region Qualification, Action Admissibility and Multi-Leg Reachability

**Status:** Accepted architectural refinement; recorded with v4.7.37candidate

**Decision — Refuge Region Qualification:** Situation Assessment does not publish arbitrary empty-looking world-space. It qualifies bounded **Refuge Regions** as Knowledge and may publish Field World relationship, stationary physical usability, assembly/Refuge-Configuration fit, demand relationships and Representation Fitness. An intrinsically unusable area (for example a lake) never becomes a Refuge Region. Situation Assessment describes relationships; it does not choose Yield, a Refuge Pose or a Reposition action.

**Decision — downstream action:** Candidate generation binds Subject + Purpose + Refuge Pose + supportable Manoeuvre Leg(s). Region availability and reachability remain distinct: FIT means the proposed complete assembly/configuration can occupy the region, not that Control can reach it through an admissible transition sweep. Traffic Policeman compares refined admissible Candidate Actions rather than raw geometry.

**Decision — no fixed leg maximum:** Reposition may require multiple bounded Manoeuvre Legs. Every leg ends at a Settled Movement Boundary and any additional leg requires expected **Reachability Progress** or another unresolved Commitment obligation. Reachability Progress need not reduce Euclidean distance to the Refuge Region; a U-shaped Field World may require initial movement away from it. A settled leg that fails to improve the supported relationship triggers reassessment rather than blind leg proliferation.

**Decision — comparison:** after mandatory admissibility, remove dominated actions and compare Governing Purpose, Resulting Situation quality and only then Minimum Necessary Authority. Resulting Situation quality includes continuation, obligation burden, release support, retained Action Space, robustness and near-term recurrence. Clearance Reserve is a robustness consideration, not an objective to maximise. Materially equivalent alternatives may remain architecturally indifferent; deterministic implementation tie-breaks carry no policy meaning.

## D-0117 — Require Spatially Meaningful Configuration Evidence in Prototype 22 Reposition

**Status:** Implementation/validation correction for v4.7.36candidate; canonical v4.7.34 architecture unchanged

**Evidence:** the first v4.7.35 P22 cycle produced strong same-Job Regulation and Hold evidence for both Condor Endurance II and Patriot 4450. Its forward Reposition actuator also reached the operator-selected target for both workers and returned the same Job Episode to GIANTS. Visual evidence, however, showed that neither 36 m boom folded. The run therefore proved bounded target actuation but did not prove the spatial Reposition capability required by Traffic Policeman. The raw console was also impractical to follow live, repeating the known Diagnostic Signal Saturation problem.

**Decision:** revise P22-C rather than advancing to production Traffic Policeman. A wide foldable participant must be positively compacted/configured as part of the Reposition capability probe. P22-C now requires Hold, configuration mutation, one bounded forward Manoeuvre Leg, compact Hold at target, restoration and same-Job GIANTS handback. Spatial PASS requires positive represented plan-view span reduction as well as compact configuration; fold-animation values alone cannot claim spatial clearance.

**Configuration-latency decision:** do not require the complete approximately 15-second Condor/Patriot fold before movement. After translational Hold and a fold request, the forward Manoeuvre Leg may begin once actual fold motion is observed, allowing folding to continue during movement. This validates useful overlap without treating a numerical fold-progress threshold as clearance authority. Full compact configuration and positive represented-span reduction are still required at the target before P22-C spatial PASS.

**Diagnostics:** add transition-only P22 HUD signalling and one-shot summary records. Detailed sample logging remains forensic evidence but is no longer the operator's live test interface.

**Boundary:** this correction grants no refuge-selection, target-clearance, role-selection, reverse or Safe Release authority. `CONTROL_AUTHORITY_ENABLED=false` remains mandatory.

## D-0116 — Gate Traffic Policeman Implementation Behind Prototype 22 Capability Evidence

**Status:** Implementation/validation decision for v4.7.35candidate; canonical v4.7.34 architecture unchanged

**Context:** D-0115 now fixes Traffic Policeman's strict `Observe → Regulate → Hold → Reposition` Decision ordering. Before that policy receives live authority, the replacement core still requires current GIANTS integration evidence that Regulation, Hold/release and forward Reposition can be applied to either relevant worker while preserving Job Episode ownership. Reverse Reposition is architecturally available but remains unvalidated for OuttaMyWay-directed actuation.

**Decision:** implement Prototype 22 as a manual-only capability gate. It may actuate only after an explicit console command, only one selected subject at a time, and only in a fixture with at least two active GIANTS AI field workers. Production `CONTROL_AUTHORITY_ENABLED` remains false and no Situation Assessment, Candidate, Decision or Commitment path can arm P22.

**Integration evidence reused:** archived code may supply only previously proven GIANTS integration facts/mechanisms. P22 therefore uses the same-job `getCanAIFieldWorkerContinueWork` permission overwrite for Hold and a scoped `AIVehicleUtil.driveToPoint` wrapper. During Regulation the wrapper changes only `maxSpeed`; during the manual Reposition probe it owns exactly one bounded forward Manoeuvre Leg. No historical Traffic Manager priority, thresholds, refuge policy or role assumptions are reintroduced.

**Isolation:** P22 does not fold/raise implements, select refuges, establish target clearance, assign `PROGRESS`/`YIELD`, evaluate preference-band exhaustion, apply a live Commitment or claim Safe Release. The operator supplies an obviously clear roomy target for Reposition capability testing.

**Reverse boundary:** negative forward displacement is refused and logged `REVERSE_REPOSITION_UNRESOLVED`. This is not a prohibition in architecture. GIANTS-native reverse remains valid under Regulation; OuttaMyWay-directed reverse remains a future capability-validation activity.

**Validation consequence:** a full P22 live PASS is necessary evidence for the first active Traffic Policeman vertical slice, but is not itself evidence that Traffic Policeman Decision policy is correct. A failure is classified before any architecture is reopened.

## D-0115 — Consolidate Traffic Policeman Sequential Decision Ordering

**Status:** Accepted architecture; documentation-only consolidation in v4.7.34 candidate; no production Decision implementation

**Context:** v4.7.33 already contains Traffic Policeman, Productive Continuation Preference, Encounter Maturation, Action-Space Compression, Preference-Band Exhaustion, Hold/Reposition, Representation Fitness and reverse-as-possible-capability architecture, but their composition leaves room for two unsafe readings: Traffic Policeman could be implemented as an Encounter-long manager rather than temporary traffic authority, and the four action classes could be treated either as optional jumps or as a procedural try/fail ladder. Pressure-testing roomy crossings, early/late TS016, pure TS015, reversing Transitional workers and passing-place/give-way analogies resolves that ambiguity without introducing a new root concept.

**Decision — bounded lifetime:** Traffic Policeman is an omnipresent but normally dormant Decision responsibility. It becomes active only while current Reality requires decisive temporary movement ordering to protect supported demand/Action Space. It becomes dormant as soon as unrestricted cooperative movement is again supportable. Encounter/Commitment restoration, Native Handover or settlement may continue after Traffic Policeman becomes dormant, and later renewed traffic coupling may reactivate the responsibility.

**Decision — Purpose provenance:** Candidate `Purpose` remains the operational result that candidate seeks. It is not Situation Knowledge and has no independent objective-setting authority. Before a Commitment exists, Purpose must be traceable to current admitted native intent, the Operational Picture and accepted Decision policy. Under an existing Commitment it must remain compatible with the governing Objective and unresolved Obligations unless an explicit lifecycle revision/supersession occurs. Candidate generators populate/represent Purpose; they do not own policy or invent the governing objective.

**Decision — strict preference sequence:** after mandatory admissibility/Representation Fitness gates, Traffic Policeman applies `CONTINUE_OBSERVATION → REGULATE_SPEED → HOLD_AT_SAFE_POINT → NATIVE_REPOSITION` as a strict primary Decision preference. A later band may receive primary resolution authority only after every earlier band is explicitly exhausted against the same current governing traffic requirement in the same Decision epoch. Exhaustion may be proved from Knowledge without physical trial. Any material Reality or Control Outcome produces a fresh Decision epoch and reevaluation from the least-disruptive end; this is not a persistent four-state controller. Independently justified supporting capabilities from an earlier band may coexist with a stronger primary Commitment.

**Decision — Observe:** Observe remains preferred only while a material Knowledge question can usefully mature under GIANTS ownership and enough supportable Action Space remains to wait for that evidence. Observe exhausts when either the evidence is sufficient for decisive direction or uncertainty remains but waiting would consume a necessary resolution option. No probability threshold or compression score is introduced.

**Decision — Regulate:** Regulation means bounded GIANTS-owned progression. Traffic Policeman may permit a participant to proceed or creep while GIANTS retains native route, steering and forward/reverse choice. Regulation may preserve Action Space, reveal native intent, let a transition clear or protect Committed Demand. It exhausts when no positively supportable non-zero native progression can satisfy/preserve the current traffic purpose; a pure established head-on is the reference case where creep cannot resolve the spatial incompatibility.

**Decision — Hold:** `HOLD_AT_SAFE_POINT` means the current realised Physical Assembly occupancy itself can become and remain a sufficient stationary waiting state. Hold contains no hidden displacement to a newly selected point. It exhausts where stopping here would occupy another participant's required Current/Future/Committed Demand, strand an unsupported transition, remove all useful progress/evidence or merely create Static Obstacle Conversion.

**Decision — Reposition and exhaustion:** Reposition is spatial displacement required because the current occupancy is not a sufficient Hold. It is direction-agnostic: forward, reverse or composed bounded Manoeuvre Legs may be candidates where evidence/capability support them. Reposition normally creates a new settled occupancy that can then become Hold. Failure of the initially preferred Yield participant does not exhaust Reposition; Decision must consider the complete currently supportable spatial Candidate Action Space under both admissible role assignments. Only when no participant has a sufficient supported Reposition candidate is autonomous traffic resolution exhausted and explicit escalation/player intervention justified.

**Reverse boundary:** reverse is architecturally valid but OuttaMyWay-directed reverse actuation remains implementation/evidence work. An unsupported reverse candidate is `UNRESOLVED`, not silently forbidden and not active authority.

**Implementation boundary:** v4.7.34 changes documentation/version metadata only. Production Decision remains passive, no live Commitment is applied and Control remains disabled.

## D-0114 — Ground Productive/Transitional Knowledge Asymmetrically and Treat Configuration by Footprint

**Status:** Accepted architecture; documentation/knowledge consolidation in v4.7.33 candidate; no production Decision implementation

**Evidence:** Prototype 21 TS004 evidence extended the productive-line pattern to John Deere 8RX 410 + cultivator and Valtra S 416 + reversible plough. The 8RX worked at a 15 km/h productive limit; the reversible plough worked at ~12.2 km/h while transition reached ~15 km/h. Both exposed productive line `ACTIVE` / lowered and transitional line `INACTIVE` / raised. Short `turn=false`, line `INACTIVE` boundary samples also occurred before productive-line establishment. The reversible plough visibly changed working side after each pass while the same Job Episode continued, with passive representation producing changing configuration/profile tokens and materially changing footprint bounds.

**Decision — speed:** accept **Native Speed-Ordering Variability**. Neither absolute speed nor the relative faster/slower ordering between participants may classify productive state or manufacture Traffic-Policeman priority.

**Decision — evidence:** accept **Productive-State Evidence Asymmetry**. Coherent active work-line evidence may positively support Productive Continuation. Inactive line state alone is not positive Transitional authority; positive Transitional Continuation requires corroborating Job-Episode continuity and native-transition evidence. Otherwise Situation Assessment publishes `UNRESOLVED`.

**Decision — configuration:** accept **Configuration Footprint Authority** and **Alternating Working-Side Configuration**. Runtime configuration/profile numbers are diagnostic provenance only and must not become semantic state identity. Spatial reasoning uses current realised footprint plus the relevant configuration-transition sweep. Demonstrated Traversability, clearance and similar positive evidence are bounded to materially equivalent footprint/configuration domains and do not automatically transfer across a working-side reversal.

**Traffic-Policeman consequence:** Productive Continuation Preference remains an initial otherwise-roomy non-headland preference only. A Transitional/Yield participant must still have a supportable interruption state; a footprint-changing transition may make yielding it inadmissible even though productive-line state is inactive. Headland/Encounter-Maturation treatment is unchanged.

**Implementation boundary:** no classifier, role assignment, configuration-label mapping or Control behaviour is activated by v4.7.33. Prototype 21 remains passive; production Decision remains passive and Control disabled.

## D-0113 — Accept Productive Continuation Preference with Positive Native Evidence

**Status:** Accepted architecture; documentation/knowledge consolidation in v4.7.32 candidate; no production Decision implementation

**Evidence:** Prototype 21 falsified absolute speed as productive-state authority. Condor remained `turn=false`, work-line `ACTIVE`, implement lowered and work-limit 25 km/h while manual cruise restricted actual productive speed to ~10 km/h. Later Condor diagonal/reverse transitions exposed `turn=true`, work-line `INACTIVE`, implement raised. Valtra S 416 + lime-spreader replicated productive line `ACTIVE` / lowered at an ~18 km/h work limit and transition line `INACTIVE` / raised across multiple forward/reverse repositions.

**Decision:** accept **Productive Continuation Preference** for otherwise-roomy non-headland encounters. Where current Situation Knowledge positively supports one participant as Productive Continuation and another as Transitional Continuation, Traffic Policeman should first prefer Productive for `PROGRESS` and Transitional as the `YIELD` candidate. The preference exists to preserve useful productive native intent while resolving a cheaper transitional conflict.

**Override:** the preference is subordinate to Action-Space viability, current Commitment obligations and Encounter Maturation. If yielding the transitional participant would strand it, materially compress supported options, invalidate necessary native progression or otherwise worsen resolution, the preference does not govern; the transitional participant may legitimately receive `PROGRESS`. Existing headland/TS016 reasoning is unchanged.

**Tie/unresolved rule:** Productive/Productive, Transitional/Transitional or materially unresolved productive state is a tie for this preference. No absolute speed, vehicle class, implement width, first-arrival or similar heuristic is authorised to manufacture a winner. Situation Assessment must publish positive coherent evidence or `UNRESOLVED`.

**Evidence boundary:** current GIANTS implement-line state is demonstrated evidence across two materially different assemblies, not a universal one-bit API contract. `isTurn=true` is broader than a literal turn and `lastContinueWorkState=true` is not sufficient productive authority.

**Safe-release consequence:** Transitional/Yield status does not diminish Future-Space authority. Apparent Departure Reversal demonstrates that increasing separation can be followed by native reverse return; separation/negative closing/apparent departure remains insufficient release authority.

## D-0112 — Probe Productive Continuation from GIANTS-Native Evidence Before Using It for Traffic Priority

**Status:** Accepted evidence-discovery step; implemented by v4.7.31 candidate

**Context:** For roomy non-headland encounters, a Productive Continuation Preference may offer a more GIANTS-native priority input than vehicle speed: preserve a worker that is actively performing productive field work and treat a transitional/repositioning worker as the first Yield candidate where Action Space makes that cheap. Absolute speed cannot establish that state because implement working limits, GIANTS motion demand, player cruise-control settings and other constraints can all cap the same productive worker.

**Decision:** before adding any Productive/Transitional classification or Traffic Policeman rule, run Prototype 21 as passive evidence discovery. Observe GIANTS active-segment state, implement-line state, strategy continuation/direction state, cruise/speed limits and actual speed. Include a deliberately low-cruise productive-work falsification case. Observed speed has corroborating value only; no 25/15/10 km/h literal receives semantic authority.

**Boundary:** this decision does not alter the established headland/Encounter-Maturation treatment, does not define Productive Continuation yet, does not assign `PROGRESS`/`YIELD`, and grants no Control authority. A disproved hypothesis is a successful result if it prevents an unsafe Decision assumption.

## D-0111 — Accept Encounter Maturation and Action-Space Compression

**Status:** Accepted architecture; documentation-only consolidation in v4.7.30 candidate

**Context:** Repository archaeology of the earlier TS016 working-but-flawed controller confirmed a useful physical policy: the manoeuvring Condor retained Progress while the straight-working Patriot yielded, allowing GIANTS to clear the developing crossing. Current discussion clarified that the crossing/turning shape is not itself the source of complexity. TS016 occurs at the headland/field edge, where boundaries, assembly geometry and competing demand compress the available resolution space; equivalent mid-field interactions may retain many more options.

**Decision:** accept **Encounter Maturation** as a Traffic-Policeman Decision pattern. When an ambiguous interaction remains supportable, Decision may deliberately preserve bounded GIANTS-native progression so Reality can dissolve the interaction or reveal a simpler authoritative state before OuttaMyWay commits to a more invasive manoeuvre. A head-on is one possible mature state, not a required target.

**Action-Space Compression:** name the derived physical reduction of supportable resolution options caused by Field World constraints, Physical Assembly geometry, participant demand and evolving manoeuvres. It is not a new root space, encounter taxonomy, actuator or numeric score. Action-Space Compression explains the physical side of existing Preference-Band Exhaustion; exhaustion is the Decision consequence when preferred supportable candidates disappear.

**Observation contract:** maturation is valid only under the existing Bounded Observation Contract. Early Encounter admission may legitimately choose `CONTINUE_OBSERVATION` or purpose-bound `REGULATE_SPEED` to preserve maturation margin, but must identify the Knowledge gap, expected Reality evolution, preserved option, exhaustion condition, reassessment boundary and Progress participant capable of generating evidence. Passive waiting is inadmissible.

**Implementation-convenience boundary:** where sufficient Action Space already exists, especially mid-field, OuttaMyWay must not wait for an encounter to become a familiar head-on solely because head-on resolution is currently better understood. Stronger intervention becomes appropriate when continued maturation is consuming rather than preserving supported options.

**Implementation boundary:** v4.7.30 introduces no production Traffic Policeman, maturation detector, live Commitment, speed lease or physical Control path.

## D-0110 — Accept Staged Refuge Recovery and Purpose-Bound Traffic Protection

**Status:** Accepted architecture; documentation-only consolidation in v4.7.29 candidate

**Context:** Pressure-testing ADR-0023 against a successful Condor–Patriot pure head-on exposed two gaps in the recorded contract. First, Progress right-of-way could be misread as exclusive movement authority or unrestricted speed. Second, a completed refuge ingress does not necessarily retire all recovery demand: Condor may require approximately 15 seconds to unfold, and unrestricted Progress motion can consume the separation needed for restoration before work-capable native handover.

**Decision:** `PROGRESS` is preservation priority, not exclusive permission to move. A `YIELD` participant may receive bounded admitted recovery authority while remaining subordinate to Progress demand. Once Decision admits a recovery Action Space, its active ingress/restoration requirement is Committed Demand that Traffic Policeman must keep compatible with Progress demand until that stage completes, is superseded or is revoked.

**Supporting speed:** Progress may remain `PROGRESS` while a purpose-bound `REGULATE_SPEED` lease protects the admitted Yield recovery. The lease carries a named current purpose and expires as soon as unrestricted Progress continuation is compatible with the remaining admitted recovery demand. No fixed post-passage speed, distance or duration is architectural. The observed Condor ~15 s unfolding duration remains evidence only: protect the recovery obligation, not the clock.

**BNIR / handover:** intent revealed during compact/transit BNIR is stage evidence. Re-Hold or material configuration restoration may expire it; after restoration, fresh operational Local Intent and independent GIANTS continuation must be acquired through the Native Handover Envelope before Safe Release.

**Progress / release:** Commitment progress is demonstrated by reduction or retirement of named unresolved obligations, not a numeric distance/time score. Safe Release requires all applicable intervention/restoration obligations settled, independent GIANTS authority observed, fresh authoritative operational Local Intent, positive current/Encounter-relative Future-Space decoupling, and no unresolved obligation belonging to the governing Encounter. A later materially new convergence after Safe Release forms a fresh Encounter.

**Implementation boundary:** no production Traffic Policeman, live Commitment, BNIR actuator, speed lease or physical Control authority is introduced by v4.7.29.

## D-0109 — Accept Traffic Policeman and Encounter-Relative Movement-Priority Refinements

**Status:** Accepted architecture; documentation-only consolidation in v4.7.28 candidate

**Context:** canonical v4.7.27 accepts BNIR but does not yet define which participant may consume contested space while evidence is acquired. Discussion of two-worker Hold release showed that `SETTLED_CONTINUATION` alone is not clearance, a slow BNIR participant can still obstruct the Progress participant, and unconstrained role swapping can merely transfer uncertainty. The same discussion identified recent actual traversal by the real assembly as positive local spatial-admissibility evidence and exposed an over-broad reading of Continuation Safety Horizon as an indefinitely rolling requirement.

**Decision:** accept **Traffic Policeman** as the Decision-level responsibility that assigns/revises temporary `PROGRESS` and `YIELD` movement priority within one Encounter. It does not route or steer. A settled Progress participant can be a stable reference only when its supported continuation corridor is positively compatible with the Yield participant's occupancy and proposed bounded Action Space. BNIR remains physically relevant and loses authority before it consumes Progress demand.

**Role transfer:** temporary movement priority may transfer within one Commitment when the transfer reduces/settles unresolved obligations or materially improves admissible resolution capability. Define **Revelation Oscillation** as repeated intent-invalidating role transfer that merely alternates which participant is unknown without reducing Encounter obligations; it is not progress.

**Demonstrated Traversability:** actual successful occupation/traversal by the real Physical Assembly may supply positive local admissibility evidence within a materially unchanged demonstrated domain. This evidence does not create universal Coverage Closure or prove arbitrary kinematics, configuration sweeps, permanent release or dynamic availability.

**Continuation Safety Horizon refinement:** scope the Horizon to unresolved continuation consequences materially belonging to the current Encounter and its interventions. It does not advance indefinitely through unrelated later manoeuvres. New intent remains part of the current Encounter while materially coupled to unresolved obligations; later materially new convergence after Safe Release may form a fresh Encounter.

**Static-object boundary:** park static-object recovery/avoidance for separate future analysis. Do not infer from BNIR or Traffic Policeman that GIANTS can avoid stationary obstacles or that OuttaMyWay can always automate a bypass.

**Implementation boundary:** no production Decision, live Commitment, BNIR actuator or Control authority is added by v4.7.28.

## D-0108 — Accept Bounded Native Intent Revelation as an Architectural Evidence-Acquisition Pattern

**Status:** Accepted architecture; live-supported by non-canonical v4.7.26 Single-Worker Transit Intent evidence; canonicalised by owner-declared v4.7.27

**Context:** Same-Job-Episode Safe Release exposed a circular evidence problem. A held worker cannot demonstrate its actual post-Hold native continuation while fully inhibited, the GIANTS traversal route has no demonstrated authoritative Lua cursor, and Hold-induced physical calm cannot establish post-Hold safety. The v4.7.25 route-index probe also failed to establish a native traversal binding. Historical v4.6.63/v4.6.64 evidence separately showed compact native movement and later work restoration/native handover.

**Decision:** accept **Bounded Native Intent Revelation**. While a Commitment remains responsible, Decision may authorise a bounded evidence-acquisition composition that preserves the GIANTS Job Episode, uses a proven controllable transit/configuration state where required, grants GIANTS only the bounded motion authority needed to reveal actual native continuation, observes the resulting Local Intent, and retains the ability to re-Hold/reassess before unrestricted continuation. OuttaMyWay must restore only its own configuration mutations before ordinary work handover when restoration is required.

**Live evidence:** v4.7.26 Candidate SHA-256 `43e0fc93fcd7810d8460d11e683ad05adef50ada545c8190a3394f015b260ec0` on FS25 1.21.1.0, field 77, Condor Endurance II. Job identity remained `giants-ai-job-id:0`; full compact configuration was confirmed; GIANTS progressed under a 1 km/h experimental ceiling while `SETTLED_CONTINUATION` progress advanced; the probe re-Held after an experimental 2 m movement, restored and verified configuration with zero mismatches, returned the unmodified drive path, and observed same-Job independent continuation. The experimental speed and distance are not architecture.

**Relationship to Safe Release:** Bounded Native Intent Revelation is not the Safe Release Point and does not complete the governing Commitment. It supplies Reality-generated evidence for reassessment. Capability release, native intent revelation and Commitment completion remain separate events.

**Counterfactual Hold Release amendment:** the durable rule from ADR-0017 remains that the calm state created by Hold is not release evidence. Synthetic route or speed projection is not mandatory. Where admissible, actual GIANTS continuation may be revealed under bounded authority instead.

**Boundary:** the pattern is capability- and assembly-dependent. It does not assume arbitrary assemblies can move safely in transit state, does not establish Coverage Closure, does not grant clearance during an unresolved manoeuvre sweep, and does not authorise a fixed proving speed or distance. Production Control remains disabled.

**Wider implications:** post-intervention route reacquisition remains a possible future application. Static-object recovery/avoidance is now explicitly parked by D-0109 / ADR-0023 for separate architectural analysis and must not be inferred from BNIR. GIANTS is still not assumed to route around a stationary obstacle.

## D-0107 — Retire Superseded Fixed-Horizon Future Predictor After Admission Validation

**Status:** Accepted implementation cleanup; implemented by v4.7.24 candidate

**Context:** D-0106 intentionally retained the historical ten-second predictor only long enough to compare it against Future-Space-driven Encounter admission. The v4.7.23 live gate proved `FIELD_BOUNDED_FUTURE_SPACE_POSITIVE` created the first Encounter while that predictor was still negative, so its validation purpose is complete.

**Decision:** remove the fixed-horizon future predictor and its active comparison plumbing/messages rather than retaining obsolete shadow code. Preserve only independent present-state observations: distance, relative motion/closing rate, scalar current overlap and configuration-filtered current footprint overlap. Historical archived implementations remain evidence records.

**Reason:** validated superseded code should not become permanent runtime/diagnostic debt, and future interaction authority is already established as field-bounded Future Space.

**Boundary:** this is not Safe Release or negative-clearance authority. It does not change Encounter lifecycle semantics, Decision policy, Commitment or Control.

## D-0106 — Field-Bounded Future Space Governs Positive Encounter Admission

**Status:** Accepted implementation-conformance step; implemented by v4.7.23 candidate

**Context:** canonical v4.7.21 live-validates field-bounded Future Space. The v4.7.22 live run showed this Knowledge becoming positive materially before the historical ten-second scalar/component future predictor admitted the Encounter; the HUD changed in the same sample as Encounter creation, disproving a display-latency explanation.

**Decision:** admit an Encounter from positive Current Space interaction or a supported field-bounded Future Space intersection. The historical ten-second future-convergence predictor loses Encounter-admission authority and remains temporarily as shadow comparison evidence only. Its non-positive or positive future result cannot suppress or create an Encounter.

**Reason:** Encounter identity belongs to a convergence of Future Spaces. Keeping the fixed-horizon predictor as admission authority would continue an implementation non-conformance already exposed by live evidence.

**Boundary:** no negative-clearance authority, same-Episode Safe Release, responsibility selection, Decision policy, live Commitment mutation or Control is introduced. Positive Current Space evidence remains legitimate immediate admission evidence. The legacy shadow code/messages are temporary validation instrumentation and should be removed after this path is live-validated.

## D-0105 — Validate Apparent Architectural Novelty Against the Repository

**Status:** Accepted standing governance rule

**Decision:** Treat the architecture as largely defined, errors and omissions excepted. Before naming a live observation as a new architectural discovery, search the canonical architecture, ADRs, decision log, glossary, concept register and relevant archived evidence. Classify the result as existing architecture confirmed, implementation non-conformance, architectural refinement or genuinely new discovery before introducing new terminology or architecture.

**Reason:** repeated implementation and live-test observations can rediscover concepts already established during earlier seminars/prototypes. Repository validation prevents duplicated terminology and implementation convenience from silently redefining architecture.

**Boundary:** archived code may provide empirical facts, proven GIANTS integration mechanisms and failure evidence; it is not architectural authority. Reality may still disprove or refine canonical architecture.

## D-0104 — Incomplete Operation-Membership Evidence Has No Removal Authority

**Status:** Accepted implementation-conformance correction; implemented by v4.7.22 candidate

**Context:** the v4.7.20 stop/restart live gate showed `MEMBERSHIP_INVALIDATED` terminating an Encounter one sample before authoritative Job Episode-end evidence. Code review found that `operationMembershipEvidenceComplete=false` prevented only whole-Operation zero-member termination; individual previously admitted members were still removed during partial updates.

**Decision:** when Operation-membership evidence is incomplete, preserve all previously admitted members and union any positively observed members into the active Operation record. Only complete membership evidence may remove an existing member. This is an evidence-authority rule, not a grace period.

**Reason:** incomplete evidence cannot prove non-participation. Preserving membership through the unresolved stop sample allows the already-defined Job Episode terminal evidence to determine Encounter exit when it becomes authoritative.

**Boundary:** no timer, sample-count threshold, Decision policy, Commitment mutation, Safe Release authority or Control is introduced. Explicit membership invalidation remains a valid Encounter exit when supported by complete evidence.

## D-0041 — Recover Existing Future Space Architecture in the Passive Live Producer

**Status:** Accepted implementation-conformance correction; live-validated and canonical in v4.7.21

**Context:** the v4.7.20 live HUD demonstrated that the replacement-core positive Encounter probe becomes actionable only when its ten-second constant-velocity horizon is reached. Repository review showed that this is not an architectural discovery: ADR-0006 already defines bounded Local Intent/Future Space, and ADR-0012 already defines Intent Expiry and Option Preservation. Archived FieldBoundary and FieldCourse probes contain proven mechanisms but not architectural authority.

**Decision:** do not increase or replace the ten-second literal with another behavioural time/distance literal. Add a separate passive Future Space producer that observes native GIANTS active-segment `isTurn`, bounds settled straight Local Intent by the current Job-Seeded Field World boundary, expires that straight intent during native turning, leaves the unrepresented manoeuvre sweep unresolved, and advances the local-intent epoch when the native course settles again. Publish positive field-bounded intersections to Situation Assessment as Knowledge only. Retain the historical ten-second predictor solely as the isolated legacy positive Encounter probe until separately superseded.

**Reason:** this restores implementation conformance to existing architecture while preserving the already live-validated Encounter-entry path and preventing implementation convenience from redefining architectural Future Space.

**Authority boundary:** no Decision selection, live Commitment mutation, negative-clearance authority or Control is added.

## D-0040 — Add Transition HUD and Shape-Type Gate for the Encounter Exit Live Gate

**Status:** Accepted diagnostic implementation correction; implemented by v4.7.20 candidate

**Context:** the first v4.7.19 live attempt stopped and restarted a worker before the first Encounter had been created. Continuous console output made the required action transition impractical to identify. The same run showed GIANTS error stacks because shape-bound APIs were invoked on named collision transform groups that were not Shape entities.

**Decision:** preserve the Encounter Exit Contract unchanged, but add temporary transition-driven HUD instructions and one concise `[OTM TEST GATE]` console line per state change. Throttle routine pair console output to material state changes and heartbeat while retaining complete sealed trace evidence. Require `getHasClassId(entity, ClassIds.SHAPE)` to return true before any shape-bound API call.

**Reason:** live validation needs an observable human action boundary, and invalid API calls must be prevented by type evidence rather than caught after GIANTS has already emitted an error.

**Boundary:** the HUD is disposable test instrumentation. The Shape-Type Gate changes call eligibility, not physical representation authority. No Decision policy, live Commitment application, same-Episode clearance or Control is added.

## D-0039 — Encounter Exit Contract

**Status:** Accepted implementation step; implemented by v4.7.19 candidate

**Context:** canonical v4.7.18 proved positive Encounter entry, but a later sample without positive evidence could not distinguish temporary evidence absence from legitimate Encounter termination. Because non-positive footprint evidence remains `CLEARANCE_UNRESOLVED`, disappearance of a current positive is not proof of separation.

**Decision:** maintain Encounter identity in a first-class registry. Bind each active Encounter to its Operation, interaction reference and participating Job Episode identities. Retain it while those lifecycle bases remain valid, even when the current assessment has no positive interaction evidence. Terminate it only from explicit lifecycle evidence: Job Episode end, Operation end, membership invalidation or intent supersession. A restarted or replacement job creates a new Job Episode; renewed positive evidence must create a new Encounter identity.

**Reason:** Encounter Knowledge must not disappear because evidence becomes temporarily unavailable, and terminal history must not be resurrected by reused vehicle objects or pair references.

**Boundary:** this decision does not define same-Job-Episode physical clearance, Safe Release, responsibility selection, Decision policy, live Commitment application or Control authority.

## D-0038 — Admit Configuration-Filtered Footprint Positives as Encounter Evidence

**Status:** Accepted implementation step; implemented by v4.7.18 candidate

**Decision:** Compose the unchanged scalar interaction predicate with the configuration-filtered component-footprint evaluator at the interaction-evidence boundary. Either source may establish only positive current interaction or positive bounded future convergence. A non-positive footprint result remains unresolved and cannot erase scalar evidence or establish negative clearance.

**Reason:** canonical v4.7.17 live-validated the purchased 36 m Condor representation and showed stable positive future convergence approximately 9.7 seconds before predicted contact while the scalar path still terminated at missing radius. The positive component evidence is now sufficiently grounded to enter Situation Assessment.

**Boundary:** evidence admission creates Encounter Knowledge only. It does not select responsibility, generate a physical strategy, create or revise a live Commitment, or enable Control. Coverage Closure remains absent and all negative-clearance claims remain prohibited.

## D-0037 — Separate Geometry Inventory from Configuration Participation

**Status:** Accepted implementation correction; implemented by v4.7.17 candidate

**Decision:** Retain the complete physical geometry inventory for each Job Episode, but construct each material configuration profile from only the primitives currently participating in physics. Use runtime compound-child state as principal evidence. Use source-donor membership only as a bounded fallback when the selected purchased configuration matches and runtime participation evidence is unavailable.

**Reason:** the v4.7.16 live run proved the cache and transformation mechanism but represented a purchased 36 m Condor with an approximately 54 m span. Code review showed that generic collision-name discovery admitted inactive alternative shop geometry and every cached primitive was transformed into every profile.

**Boundary:** this is an implementation-conformance correction, not a new architectural feature. Inactive and unresolved primitives remain visible in diagnostic inventory. Partial participating geometry may support only positive shadow conflict. It grants no negative-clearance, Encounter, Decision, Commitment or Control authority.

## D-0036 — Recover Job-Scoped Plan-View Representation in Passive Shadow

**Status:** Accepted implementation decision; implemented by v4.7.16 candidate

**Decision:** Recover the proven assembly-discovery, runtime-Entity, component-bound and compound plan-view composition mechanisms as clean replacement-core services. Cache assembly membership and component-local geometry for the lifetime of one Job Episode. Cache materially encountered configuration profiles. Recompute only current world poses and derived plan-view composition per passive sample. Evaluate the new component-aware representation in shadow without changing the live interaction predicate.

**Reason:** canonical v4.7.15 proved that the existing scalar predictor short-circuited because both TS015 sprayers had no width, length or radius evidence. Earlier prototypes had already established plan-view composition, attached-member offsets, authoritative live component transforms and conservative component-local spheres. Repeating that discovery every sample would waste evidence and runtime cost.

**Boundary:** the primary representation is a layered member/component footprint set. Derived hulls and rectangles are question-specific views. Partial represented geometry may support only potential positive conflict; it grants no negative-clearance authority. Unexpected assembly-membership drift invalidates the Job Episode representation. No Encounter, Decision, Commitment or Control authority is added.

## D-0035 — Add Bounded Interaction Diagnostics Without Changing Behaviour

**Status:** Accepted diagnostic implementation decision; implemented and live-validated by canonical v4.7.15

**Decision:** Instrument the complete existing path from active-job acquisition to Encounter construction. Record pose acquisition, physical-representation inputs, position-derived motion, every unique unordered relationship, pair-prediction outcomes, interaction-evidence handoff, Encounter lifecycle and contradiction warnings. Diagnostic log-line limits are independent from operational pair evaluation.

**Reason:** canonical v4.7.14 correctly retained one Field World and one Operation during TS015, but no Encounter was created before or after physical contact. The current evidence proves only that qualifying interaction evidence did not reach Encounter construction; it does not yet identify the rejecting branch.

**Boundary:** this is not an architectural addition. The labels are diagnostic descriptions of existing implementation branches. No predicate, threshold, admission rule, Decision, Commitment or Control path changes. `control=false` remains enforced.

## D-0034 — Implement Field World Equivalence as Pure Evaluation plus Class-Wide Authority

**Status:** Accepted implementation decision; implemented by canonical v4.7.14

**Decision:** Separate immutable Snapshot capture, pairwise spatial evaluation and authoritative Field World assignment. `FieldWorldEquivalenceEvaluator` produces `SAME_FIELD_WORLD`, `DIFFERENT_FIELD_WORLD` or `UNRESOLVED` from compound evidence. `FieldWorldEquivalenceAuthority` compares each candidate with every Snapshot in each currently relevant class, joins exactly one coherent class, establishes a new class only when positively different from all classes, and otherwise leaves the Snapshot unresolved. Operation admission consumes only resolved Field World identity.

**Calibration:** non-exact SAME requires compatible topology plus all accepted area, perimeter, centroid, bounds, boundary-distance and sampled-overlap limits. Failure of that envelope does not imply DIFFERENT. The initial DIFFERENT path requires positive occupied-region separation. These values are implementation calibration, not architecture.

**Consequence:** Snapshot references, exact polygon references and resolved Field World references are distinct. Operations retain all member Snapshot and polygon provenance. Classes retire when no associated Job Episode remains relevant. Pairwise tolerance chaining is structurally prohibited. Control remains disabled. The Field World live gate subsequently passed in canonical v4.7.14.

## D-0033 — Field World Equivalence Authority Governs Field World and Operation Identity

**Status:** Accepted architecture; recorded by v4.7.13 candidate

**Decision:** Field World identity is governed by coherent, positive spatial equivalence between immutable Job-Seeded Field World Snapshots. Exact fingerprints identify and preserve exact representations but do not independently govern Field World or Operation identity. Resolution produces `SAME_FIELD_WORLD`, `DIFFERENT_FIELD_WORLD` or `UNRESOLVED`. Unresolved evidence grants no Operation admission or Control authority. Equivalence must remain coherent across the complete accepted Field World evidence; pairwise tolerance chaining is prohibited.

**Evidence:** Four captures in the merged 68–69–70 workspace had different exact fingerprints but identical bounds and topology, no islands and near-identical spatial measures. The two disconnected portions retaining locator 77 had materially different areas and bounds, large separation and zero sampled overlap.

**Consequence:** D-0030's exact-fingerprint authority is superseded. At v4.7.13 the runtime grouping remained a documented provisional implementation limitation; canonical v4.7.14 implements and live-validates the separately agreed authority.

## D-0032 — Separate Exact Boundary Representation from Spatial Field World Equivalence

**Status:** Accepted evidence boundary; authority resolved by D-0033

**Decision:** Preserve exact geometry fingerprints, but no longer treat exact equality as a proven complete model of Field World identity. Record bounded spatial-equivalence evidence without granting it Operation identity authority.

**Evidence:** the completed v4.7.12 closure produced four different exact fingerprints across serial seeds in merged areas 68, 69 and 70. All four retained the same 14 unique boundary points after closed-ring normalisation, identical bounds, identical topology and near-identical spatial comparison measures.

**Known limitation:** Operations remain grouped by exact fingerprint in this closure candidate. Spatial equivalence is diagnostic only.

## D-0030 — Geometry Fingerprint Governs Field World and Operation Identity

**Status:** Superseded by D-0033; retained as the provisional v4.7.11 implementation decision

**Decision:** Capture the GIANTS-generated contiguous agronomic polygon once at Job Episode creation. Canonicalise its representation and use its stable geometry fingerprint as Field World identity. Group Operations by that identity. Preserve source/farmland-derived field numbers only as player-facing locators.

**Evidence:** starts in merged areas 68, 69 and 70 generated the same polygon; starts in two disconnected parts of field 77 generated different polygons despite retaining label 77.

## D-0031 — Do Not Reconcile Mid-Episode Field Mutation

**Status:** Accepted supported-world boundary

**Decision:** The captured Field World Snapshot remains fixed for the Job Episode. External actors changing field polygons during active work are outside the reasonable-player contract. A restarted or replacement Job Episode captures fresh geometry.
## D-0028 — Separate Source Field, Farmland and Derived Field World Identity

**Status:** Accepted for passive live validation

**Decision:** Exact source-field polygon containment establishes only the retained source field label. Farmland is contextual containment and cannot establish field identity. The experienced contiguous Field World is a separate derived identity and may contain multiple source labels. GIANTS field-course boundary generation is the current passive evidence source for that derived identity.

**Consequence:** v4.7.10 uses provisional source-field Operation grouping only for passive validation. Derived Field World evidence must be validated before it governs Operation identity or Control.

## D-0029 — End Job Episodes on Positive Source Intent Termination Evidence

**Status:** Accepted implementation correction

**Decision:** A previously active job may end when the same source token is retained as `lastJob`, is absent from the authoritative active job slot and mission active jobs, and GIANTS AI state is inactive. This proves source intent termination without guessing whether the subtype was player stop, abort or fault. Generic inactivity remains non-terminal.

# D-0103 — Preserve immutability through explicit GIANTS-compatible ValueRecord traversal

**Date:** 2026-08-06  
**Status:** Accepted implementation correction for v4.7.9 live validation

**Decision:** Keep architecture value records sealed and immutable. Consumers traverse sealed collections only through `ValueRecord.pairs`, `ValueRecord.ipairs`, and `ValueRecord.length`. Field identity may use exact containment against `FieldManager.fields` polygons when farmland mapping is unavailable; zero or multiple matches remain unresolved.

**Reason:** v4.7.8 published valid active-job evidence, but the GIANTS runtime did not expose proxy collection entries through the implicit traversal used by downstream layers. Weakening immutability would remove an architectural safeguard to accommodate an implementation-runtime mismatch. The same run also disproved the assumed farmland-service lookup path.

**Consequence:** v4.7.9 can admit live Job Episodes without changing record ownership or mutability. Field uncertainty cannot become a guessed Operation identity or false candidate-space exhaustion. Live Commitment mutation and Control remain prohibited.

# D-0102 — Admit live Job Episodes from GIANTS active-job identity

**Date:** 2026-08-06  
**Status:** Accepted implementation hypothesis for v4.7.8 live validation

**Decision:** Use membership in `AISystem.activeJobVehicles` as positive native AI ownership evidence and the current GIANTS job ID as the live Job Episode source token. Preserve the same episode through blockage. Resolve candidate field identity through current/job positions and farmland-to-field mapping only when evidence agrees.

**Reason:** v4.7.7 directly observed these values changing across idle, active and stopped phases while remaining stable through blockage. Earlier guessed activity properties failed because the passive source did not bind itself to the AI system's active-job collection.

**Consequence:** v4.7.8 may admit Job Episodes and Operations passively, but inactivity without a distinguished terminal cause remains unresolved. No live Commitment mutation or Control is authorised.

# D-0101 — Split deterministic reasoning at the Knowledge boundary

**Date:** 2026-08-06  
**Status:** Accepted implementation sequencing; implemented by v4.7.2 candidate

**Decision:** Implement admitted Operation identity and Situation Assessment → Operational Picture as an offline gate before Candidate Action generation, mandatory Constraint Verdicts or Decision selection.

**Reason:** The canonical architecture assigns Knowledge construction to Situation Assessment and prohibits action choice there. Separating this boundary gives direct executable evidence that uncertainty, Representation Fitness and responsibility relations remain Knowledge rather than hidden Decision authority.

**Consequence:** v4.7.2 has no Candidate, Decision or Control implementation. The next increment may consume only sealed Operational Pictures. This changes implementation order only and introduces no architectural concept.

# D-0100 — Begin the v4.7.x replacement-core implementation series

**Date:** 2026-08-06  
**Status:** Accepted; implemented by v4.7.0 candidate

**Decision:** Begin v4.7.0 from canonical v4.6.78 as a behaviourally inert replacement-core bootstrap. Preserve the complete v4.6.78 Lua tree byte-exactly under `scripts/archive/v4_6_78/`, prohibit active imports from that archive, and make active `scripts/` represent the canonical architecture directly.

**Reason:** Incremental overlays around the legacy procedural core repeatedly preserved non-enforcing Decision, lifecycle and authority assumptions. A clean filesystem and loader boundary prevents that implementation history from regaining architectural authority.

**Consequence:** v4.7.0 intentionally has no gameplay functionality. Subsequent v4.7.x increments add only canonical responsibilities after offline validation.

# D-0024 — Preserve v4.6.72–v4.6.77 as failed evidence and build v4.6.78 from canonical v4.6.71

**Status:** Accepted for v4.6.78 owner review.

**Decision:** v4.6.72–v4.6.77 remain temporary non-canonical runtime-validation evidence. v4.6.78 is documentation-only and derives from exact owner-declared canonical v4.6.71. No active branch logic from the failed line is promoted automatically.

**Reason:** v4.6.77 completed a Commitment with `safeRelease=false`, admitted a new Commitment against unresolved responsibility and demonstrated that architecture-shaped procedural code did not enforce the accepted architecture.

**Consequence:** future implementation starts with an offline enforcing Architecture Kernel and deterministic replay, using experimental mechanisms only as bounded donors.

## D-0099 — Adopt the replacement-core Commitment lifecycle and Obligation Continuity

**Date:** 2026-08-05  
**Status:** Accepted; owner-declared canonical in v4.6.78

**Decision:** Adopt ADR-0019. Commitments use `ACTIVE`, `WAITING_FOR_EVIDENCE` and `SETTLING`, followed by one of five terminal dispositions. Every Commitment records a Governing Basis and owns an explicit Obligation Set. An Obligation settles only through satisfaction, evidenced basis cessation or atomic accepted transfer to an eligible Commitment.

Only one Commitment may own objective-progress actuation for an assembly at a time. Decision and Control validate the complete Effective Actuation Composition, including existing commands, capability reservations, residual predecessor effects and concurrent relevant-assembly actions.

`SUPERSEDED_BY_NEW_INTENT` is a first-class terminal disposition. Player takeover changes physical agency but does not transfer internal Obligation objects to the player. Terminal Occupancy, Operation termination and Intent Supersession use the same settlement model.

**Reason:** Paper validation showed that separate cancellation, handoff and remnant mechanisms would duplicate responsibility and permit ownerless obligations. The unified model reached valid continuing or terminal states across twelve representative scenarios.

**Consequences:** The replacement architecture is complete enough for documentation Canonicalisation. Runtime implementation remains separate and must begin with passive contracts, lifecycle tests and composition tracing.

## D-0021 — Consolidate architecture and reset experimental implementation

**Date:** 2026-08-04  
**Status:** Accepted for v4.6.71 owner review; canonical only after explicit owner declaration.

**Decision:** Build v4.6.71 from exact canonical v4.6.56 runtime bytes. Integrate durable v4.6.57–v4.6.70 architecture, decision history and evidence fingerprints as documentation. Do not activate later controller modules, candidate-only tests or experimental thresholds.

**Reason:** The cycle materially improved architectural understanding but did not produce a stable complete runtime path. Promoting v4.6.70 would convert a known permanent-Hold failure into canonical implementation authority. Discarding the cycle would lose validated discoveries and disproven hypotheses.

**Consequence:** v4.6.71 is a clean architectural checkpoint. The next implementation is a new hypothesis from the canonical runtime baseline, not an implicit continuation of the latest donor.

## D-0022 — Reject v4.6.70 continuation-speed and universal non-closing release assumptions

**Date:** 2026-08-04  
**Status:** Accepted evidence conclusion.

**Decision:** A cruise-control ceiling is not a Native Continuation Speed Estimate. Closing motion is an input to bounded conflict assessment, not an automatic veto on release. Safe Release requires conflict-excluded continuation under an evidence-supported native behaviour estimate.

## D-0022 — Bound leg orientation and evaluate Hold release counterfactually

**Status:** Accepted for v4.6.70 runtime validation.

**Decision:** A refuge manoeuvre leg shall receive a bounded orientation envelope before monotonic side progress is enforced. A Hold shall remain one coherent lease until projected post-release native continuation is sustainably admissible. Terminal failed-held reposition prohibits Hold or repeated reposition authority on the remaining mover.

**Reason:** v4.6.69 correctly closed the replacement frame but treated 0.77 m of steering acquisition as side abandonment. Its failure then produced 117 Hold decisions and 112 restores because the Hold's own stopping effect was mistaken for release safety.

## D-0098 — Revalidate provisional refuge and bind supporting speed to purpose

**Status:** Accepted implementation amendment; validation active in temporary v4.6.66.

**Evidence:** v4.6.65 created and completed repeated Encounters and avoided the previous Patriot-return deadlock. In EN-00009 Condor reached an initially viable field-contained refuge, but Patriot's later headland intent rotated its continuation corridor through that refuge. Fresh candidate assessments changed while the active Commitment did not. Supporting speed also alternated request/restore on adjacent samples.

**Decision:** A refuge remains provisional until passage and Safe Release. Intent change invalidates cached assessment. Decision may revise the active same-role refuge using a current-pose candidate, and Control updates the existing Native Reposition target without restarting the run or recapturing configuration. Supporting speed remains active until passage or sustained clear/improving evidence.

**Reconciliation:** This applies Commitment Viability Decay, Passage Corridor Is Not Continuation Corridor, Intent Expiry and Option Preservation Window. It introduces no duplicate named discovery.

## D-0097 — Compose repeated Encounters through Intent Expiry and Option Preservation

**Status:** Accepted implementation composition; validation active in temporary v4.6.65.

**Evidence:** v4.6.64 passed the complete primary TS015 refuge and handover, then admitted a later convergence at approximately 27 m and 3 s to closest approach. Useful Action Space had already collapsed. The earlier headland turn was the existing Option Preservation Window.

**Decision:** Preserve one Situation identity while assigning fresh Encounter and Commitment identities after material intent change and Safe Release. Represent one active turn as `TURNING`, renew intent after settlement, publish a generic distance/time Option Preservation plan, and allow a bounded supporting speed lease on the non-repositioning participant. Reassess roles and refuge candidates for every Encounter.

**Implementation correction:** Preserve the complete Native Reposition release outcome from controller to Decision, including configuration restoration, work capability, handover time and authority relinquishment. Physical completion without outcome projection cannot complete the Commitment.

**Discovery reconciliation:** `Option Creation Window` is an alias of the established **Option Preservation Window** and is retired. This decision composes existing architecture rather than declaring a new discovery stack.

**Scope:** Generic local A/B assemblies only. No fixture identity, route reconstruction, multiple-combine coordination, combine unloading or cross-field coordination is authorised.

## D-0096 — Restore owned dynamic mutations and guard post-handover authority

**Status:** Accepted implementation amendment; validation active in temporary v4.6.64.

**Decision:** Temporary Control captures mutable configuration immediately before mutation and retains restoration responsibility until the pre-intervention work-capable state is observed. Persistent Situation relevance authorises observation only after handover. A new physical capability requires fresh current closing-conflict evidence and revalidated Commitment Preconditions.

**Rationale:** v4.6.63 removed the freeze but Condor remained compact and Patriot remained held without current conflict. Motion recovery and work recovery are distinct; persistent relevance and persistent Control authority are distinct.

**Scope:** Central TS015 only. Approximate return, purpose-derived motion and GIANTS route ownership remain. Later Patriot manoeuvring is reserved.

## D-0095 — Separate engine identity references from architectural value snapshots

**Status:** Accepted implementation correction; validation active in temporary v4.6.63.

**Decision:** Live GIANTS objects are identity references, never recursively copied values. Decision and Commitment may copy only explicitly defined scalar value schemas. Hold evidence excludes vehicle references; Yield and Progress identities are carried separately. Stable dimensions remain immutable job-start Knowledge captured once.

**Evidence:** v4.6.49 and v4.6.55 completed active-job intervention under FS25 1.21.1. v4.6.57 introduced generic recursive copying while the physical controller remained materially unchanged, matching the first repeatable hard-freeze boundary.

**Consequence:** Remove generic recursive copy utilities, add schema-specific snapshot functions and test the actual Hold revision path with cyclic identity objects. Physical Control and ADR-0009 remain unchanged.

## D-0094 — Make permission interception ephemeral and identity-safe

**Status:** Accepted implementation correction; validation active in temporary v4.6.62.

**Decision:** A vehicle-specific `getCanAIFieldWorkerContinueWork` interception is a bounded Control lease, not a permanent transparent wrapper. OuttaMyWay shall retain the exact pre-intervention method, install one owned wrapper, remove the hold, and restore the exact original identity at every authority-release boundary. Restoration occurs only when the current method is still OuttaMyWay’s exact wrapper; a later replacement is never overwritten. External AI-job termination also clears OuttaMyWay configuration bookkeeping without configuration actuation.

**Evidence:** Manual stop, displacement and GIANTS restart succeeded with OuttaMyWay absent and with v4.6.61 loaded when no encounter was admitted. Increased logging and dormant wrappers are therefore excluded as sufficient causes. Failure requires an activated intervention.

**Consequence:** ADR-0009, refuge geometry, purpose-derived motion and the Native Handover Envelope remain unchanged. TS015 now tests whether execution-path restoration removes the freeze.

## D-0048 — Diagnostics shall not own lifecycle progression

**Status:** Accepted implementation correction; architecture unchanged.

Control state transitions shall be committed from evidence independently of diagnostic emission. Failure to format or emit a diagnostic must not veto `COMPACTING → EGRESS`, native handover, or fail-safe state entry.

# Decision Log

## D-0093 — Replace Exact Rejoin with a Native Handover Envelope

**Status:** Accepted implementation amendment; validation active in temporary v4.6.61

**Decision:** OuttaMyWay shall clear the conflict, wait for positive passage, return the displaced assembly to a bounded approximate position-and-heading envelope, then relinquish all temporary authority to GIANTS. Exact route reacquisition, lane alignment, working-configuration restoration and job continuation remain GIANTS responsibilities. Native Reposition completion reverts Control to normal Situation Assessment; Safe Release remains the Commitment-completion gate.

**Rationale:** v4.6.57–v4.6.59 repeatedly froze while attempting increasingly elaborate restoration and constrained handback sequences. Those implementations exceeded the cooperative obligation. Removing Exact Rejoin Overreach is a discovered architecture correction, not a fixture fix.

**Implementation consequence:** Remove phase-owned 4/6 km/h speed literals, mandatory exact-return turns, OuttaMyWay deployment, delegated native restoration, translation leasing, retries and nudges. Derive motion from stopping distance and curvature. Reserve the other passing vehicle’s later manoeuvring for subsequent architecture discussion.

## D-0092 — Separate translation authority from field-worker progression

**Status:** Accepted implementation amendment; validation active in temporary v4.6.59

**Context:** v4.6.58 returned configuration authority to GIANTS but retained the Traffic Permission Gate. GIANTS never began unfolding. The gate denies `getCanAIFieldWorkerContinueWork`, so Reality showed that it suppresses the field-worker state machine rather than translation alone. The timeout failure then entered a repeated toggle-based compact path and coincided with the game freeze.

**Decision:** Name **Constraint Semantics Mismatch**. During delegated native restoration, acquire a reversible zero-speed translation lease first, return configuration authority, release the Traffic Permission Gate, request GIANTS continuation once, observe stable configuration under the translation lease, then restore normal translation authority on a later update. Terminal failure is inert and issues no repeated configuration or continuation commands.

**Reserved question:** This decision neither adopts nor rejects a future unrestricted return-to-GIANTS architecture.



## v4.6.59 translation-authority amendment

Reality disproved the assumption that the Traffic Permission Gate constrains translation only. ADR-0008 separates configuration authority, translation authority and field-worker progression authority. Delegated restoration now enables GIANTS field-worker progression under a separate reversible zero-speed translation lease. Terminal restoration failure is inert. A future unrestricted return-to-GIANTS architecture remains explicitly undecided.

## D-0091 — Separate restoration obligation from restoration actuation

**Status:** Accepted architecture amendment; implemented in temporary v4.6.58 candidate

**Context:** Two v4.6.57 TS015 runs froze repeatably as Condor was almost fully unfolded. The controller reacted to the first deployed sample by restoring configuration state, releasing the movement hold and calling `aiContinue` synchronously. One subsequent motion sample was incorrectly sufficient for Control `SUCCESS`.

**Decision:** Treat restored working configuration as a Commitment postcondition rather than an unconditional OuttaMyWay actuation. End Native Reposition at positional completion under the retained movement constraint. Revise the same Commitment to Restore, return configuration authority to GIANTS without issuing fold/lower/work commands, request native continuation under the hold, observe stable native configuration, release movement on a later update without another same-tick `aiContinue`, and require sustained movement plus material travel before Restore completion. Safe Release remains separate.

**Consequences:** This amends the generic Control lifecycle rather than adding a TS015 rule. If GIANTS cannot restore configuration under the retained hold, the hypothesis is disproved and the Situation remains explicitly held/relevant.

## D-0090 — Implement ADR-0006 through one generic active vertical slice

**Status:** Implemented in temporary v4.6.57 candidate; runtime validation pending

**Context:** Canonical v4.6.56 established that current kinematic clearance, relationship labels and capability completion cannot govern Situation or Commitment completion. Further fixture-level repairs were prohibited.

**Decision:** Implement bounded local Future Space, Persistent Situation Relevance, Intent Epoch, Bounded Observation Contract enforcement, operational-sufficiency evaluation, explicit Hold and Restore capabilities, persistent Commitment lifecycle and Safe Release gating in the sole active runtime path. Require field-boundary evidence before moving continuation is classified as bounded. Disable the donor Native Reposition controller's private post-passage speed guard.

**Scope:** The implementation is generic and local. TS015 is the first validation fixture only. It does not authorise route planning, cross-field coordination, multiple-combine coordination or combine unloading.

**Consequence:** Runtime evidence must now test whether the implementation fulfils ADR-0006. A failure must identify the first incorrect responsibility, Knowledge claim, admissibility conclusion, capability outcome or release obligation; it must not produce another fixture-shaped rule.

## D-0089 — Govern continuation and Commitment completion through Future Space

**Status:** Accepted and canonical in v4.6.56

**Context:** Temporary v4.6.55 completed one TS015 Commitment when the workers were separating at approximately 80 m and constant-velocity conflict was excluded. Condor's next GIANTS headland manoeuvre then entered Patriot's path. A later speed capability remained mechanically `EFFECTIVE` while separation and time reserve collapsed until both workers were blocked.

**Decision:** Accept ADR-0006. Future Space must cover each relevant participant's next material local manoeuvre and subsequent trajectory settlement; Situation identity persists across relationship changes; Intent Expiry is explicit; Commitment Preconditions govern every material transition; `CONTINUE_OBSERVATION` requires a Bounded Observation Contract; Control effectiveness is separate from operational sufficiency; Control capability completion is separate from Commitment completion; Safe Release Point is the normal completion gate; failed or blocked Reality remains augmentation-relevant.

**Scope:** The contract is local and event-bounded. It does not authorise general route planning, cross-field coordination, multiple-combine coordination or combine unloading.

**Consequence:** No further TS015-specific correction is justified. The next active implementation must enforce the generic contract and then use TS015, TS015b, TS016 and TS016b as validation fixtures rather than policy definitions.

## D-0088 — Establish v4.6.50 as an Architecture Recovery Candidate

**Status:** Accepted for v4.6.50 candidate; canonical authority pending owner declaration

**Decision:** Build v4.6.50 from exact canonical v4.6.43, preserve v4.6.43 runtime behaviour and incorporate the v4.6.44–v4.6.49 discoveries as architectural and experimental knowledge. Do not promote temporary controller implementations.

**Rationale:** The Architecture Compliance Audit found valuable capabilities alongside Prototype Boundary Leakage, Assessment–Decision–Control Collapse, Architectural Constraint Enforcement Gap and Fragmented Commitment Ownership. Continuing behavioural patches would deepen implementation-led architecture. Reverting without recording discoveries would discard evidence.

**Consequence:** The next code increment, after Canonicalisation, is a passive shadow authority-trace path with no vehicle Control.

## D-0087 — Retire five underdefined v4.3.8 labels

**Status:** Accepted for v4.6.50 candidate

**Decision:** Retire Relevance Envelope, Decision-Relevant World, Decision-Relevant Constraints as a standalone Situation Assessment output, Decision Readiness and Option Horizon as a standalone object.

**Rationale:** Term-by-term review recovered no independent architectural distinction for the labels. Their valid concerns are already represented by Field World, Operational Picture, Situation Relevance, Future Space, Action Space, constraint applicability, Runtime Control Admissibility and evidence sufficiency.

**Consequence:** Historical mentions remain provenance. No implementation may use the retired labels to create selective awareness, a second world, a global readiness gate or a universal encounter deadline.

## D-0086 — Preserve options through sufficient, proportionate Decision

**Status:** Accepted for v4.6.50 candidate

**Decision:** Refine Sufficiency over Completeness and adopt Option Preservation, Earliest Sufficient Action, Minimum Effective Augmentation and Option-Preserving Augmentation as Decision principles.

**Rationale:** Waiting for greater certainty can remove safer, less disruptive or more reversible actions. However, frequent reassessment must not become habitual interference. A small augmentation requires a named purpose, sufficient evidence, expected effect and release conditions.

**Consequence:** Continued unchanged operation and passive observation are Decisions whose effect on Action Space must be assessed. Frequent reassessment may maintain an existing Commitment without issuing new Control commands.

## D-0085 — Restore mandatory architectural ownership and constraint enforcement

**Status:** Accepted for v4.6.50 candidate

**Decision:** Reaffirm the closed loop `Observation → Situation Assessment → Operational Picture → Decision → Commitment → Control → Outcome Observation → Situation Assessment`. Architecture and policy define invariants; Situation Assessment publishes current constraint Knowledge; Decision applies every applicable constraint; Control cannot waive admissibility.

**Rationale:** v4.6.48 Condor field departure and the later Refuge Occupancy Conflict were not absence of boundary or Future-Space concepts. They exposed local Control authority operating without universal constraint gates and without continuous Commitment revalidation.

**Consequence:** The Field World boundary is automatically material to physical repositioning. A changing Progress Future Space must update the Operational Picture and can invalidate a continuing refuge Commitment.

## D-0084 — Consolidate two remaining encounter classes separately

**Status:** Accepted for v4.6.43 candidate

**Decision:** Preserve the validated v4.6.42 passage and rejoin implementation unchanged. Treat the later TS015 active-active collision as Headland Turn Overlap / Dual-Manoeuvre Admission Gap, and treat the TS016 completed-Condor obstruction as Completion-Transition Control Gap. Address the TS015 active-active problem first; do not combine it with completed-obstacle navigation.

**Rationale:** The v4.6.42 primary TS015 sequence reached successful GIANTS handback and rearming. Earlier 15 km/h left-side TS015 evidence already left a later headland encounter unresolved, so the later collision is not uniquely caused by the new 5 km/h orientation phase. TS016 loses active-worker membership at completion and therefore requires a different control lifecycle.

**Consequence:** v4.6.43 is an evidence-consolidation candidate with no intentional runtime change. The next increment begins with observation and architectural discussion of dual-manoeuvre admission. Speed tuning and static-obstacle navigation remain separate hypotheses.

## D-0083 — Orient before translating to a rearward rejoin target

**Status:** Accepted for temporary v4.6.42 runtime-validation build

**Context:** The v4.6.41 TS015 regression completed refuge and passage, but the final rejoin target lay almost exactly behind Condor. The controller always requested forward movement. With local target direction near `(0,-1)`, steering had no stable left/right choice; Condor retained heading, drove away and timed out before GIANTS handback. This is **Forward-Only Rejoin Singularity**.

**Decision:** Preserve direct rejoin when the target is already forward-reachable. Otherwise enter a bounded low-speed `REJOIN_ORIENTING` phase. Prefer the shortest target-bearing turn; at the near-180-degree singularity resolve direction toward the stopped centreline, then original working direction. Start direct rejoin once the target enters the forward hemisphere. Add orientation time/travel limits and a direct-rejoin target-progress watchdog.

**Consequences:** Right-side and other rearward refuge poses no longer depend on an undefined forward-only steering direction. A failed orientation or diverging rejoin stops and remains held instead of travelling until the existing 45-second timeout. This decision does not address static-obstacle navigation, field-containment authority or any admission/refuge formula.

## D-0082 — Rearm successful encounters without releasing failed encounters

**Status:** Accepted for temporary v4.6.41 runtime-validation build

**Context:** v4.6.40 passed the initial TS016 refuge twice. In the full continuation, the same workers later formed a new straight head-on at approximately 91.99 m separation with `tCPA=6.61 s` and `dCPA=6.38 m`. Control was idle, but admission remained latched from the successful first encounter and no second commitment was considered. This is **Pair-Latch Suppression** and contradicts the accepted rule that Encounter identity is not entity-pair identity.

**Decision:** Scope the latch to one encounter. A successful controller outcome moves the pair record from `COMMITTED` to `REARMING`. Rearm only after separation is at least the existing 35 m passage-clear threshold and conflict-relevant prediction remains absent for three continuous seconds, or after a successfully completed pair is absent for the existing five-second reset interval. Number successive encounters and propagate the ID through admission and Control logs. A failed or unresolved outcome remains latched until explicit recovery.

**Consequences:** The same workers may receive a later independent commitment without reopening the completed encounter. The build changes no TS016 or straight-head-on admission threshold, refuge formula, role/side selection, movement calculation or passage controller behaviour. Runtime validation must show encounter 1 completion, explicit rearming and encounter 2 admission.

## D-0081 — Admit repeatable TS016 before straight-working settlement

**Status:** Accepted for temporary v4.6.40 runtime-validation build

**Context:** v4.6.39 proved calculated refuge Control in the established straight fixture. In repeatable TS016, conflict became relevant while Condor was manoeuvring across Patriot's lane, but the straight-only admission path waited until both workers were straight and committed at `tCPA=1.98 s`. Contact occurred before refuge movement.

**Decision:** Add a bounded TS016 admission mode for exactly one straight-working worker and one manoeuvring worker. Lane crossing alone is not sufficient; require live opposed headings, positive closure and predicted closest approach inside the configured `tCPA`/`dCPA` envelope. Once satisfied, admit immediately and use the straight-working worker as the early Yield role. Preserve confirmed-stop side/distance recalculation and all calculated-refuge authority. Apply a 6.0 s minimum commitment `tCPA` to both admission modes. Log `FAILED_HELD` once.

**Consequences:** TS016 can intervene before the manoeuvring worker finishes its final head-on alignment without claiming intent from lane crossing alone. No fixed vehicle identity, side, 28 m or 12 m authority returns. Runtime validation is mandatory.

## D-0080 — Transfer fixture movement authority to calculated refuge Control

**Status:** Accepted for temporary v4.6.39 runtime-validation build

**Context:** Prototype 19 v4.6.38 successfully calculated both role assignments and both lateral refuge sides, but live Control still ignored those results and forced Condor/right/28 m/12 m. The repository already contained sufficient geometry operands to calculate a refuge target.

**Decision:** Select the least-cost geometry-solved Yield role at admission. Recalculate both sides for that selected Yield role from the confirmed stop position. Calculate lateral movement from Progress working extent + compact Yield facing extent + clearance margins. Calculate rearward movement from complete compact-assembly forward extent + geometry/tracking margin. Remove all normal-Control fallback to fixed Condor Yield, fixed side, 28 m or 12 m.

**Consequences:** The exact Condor/Patriot pair remains the current admission fixture, but role, side and movement authority are no longer fixture constants. Calculation failure withholds intervention or enters the existing safe held failure state. Runtime validation is mandatory before Canonicalisation.

## D-0079 — Correct Prototype 19 evidence before Authority Migration

**Status:** Accepted for temporary v4.6.38 runtime-evidence build

**Context:** The first v4.6.37 run generated one epoch and four candidates without influencing Control. Condor-yields geometry was calculated on both sides, while Patriot-yields compact geometry remained unavailable. Two implementation defects were exposed: Prototype 19 used raw mission time rather than the Observer-relative clock, and its fixed 28 m actuator seed escaped as an apparent target and cost when geometry was unavailable.

**Decision:** Correct all four issues in one build before packaging again. Use the Observer-relative clock; remove the fixture distance from candidate solving; emit no target, separation or movement values when required geometry remains unavailable; and supply both role propositions with the best honest generic evidence already present in the representation system.

**Generic evidence boundary:** Where compact Yield geometry is unavailable but a live AI working marker exists, its half-width may be retained as an explicitly low-confidence conservative upper-bound operand. This provides a numerical comparison input without asserting that compact geometry is known. Source, coverage, confidence and extent kind must be logged. It cannot become Decision or Control authority.

**Solver boundary:** The iterative estimate begins from Progress extent plus the declared policy margin, adjusted by current signed offset. It must never seed from the live 28 m actuator. If either facing extent remains unavailable, `proposedSeparation`, target coordinates, lateral travel, rearward travel and total travel remain `n/a`.

**Implementation boundary:** The live actuator remains fixed Condor Yield, Patriot GIANTS Progress, physical-right refuge, 28 m lateral and 12 m rearward. Every Prototype 19 result remains `authority=false`, `action=none`; comparison failure remains isolated from Control.

**Validation gate:** Repeat the same Condor/Patriot fixture. Require one Observer-relative epoch, four candidate records, both role propositions numerically solved where working-marker evidence exists, no unresolved-value leakage, and unchanged successful actuator behaviour before beginning Authority Migration.

## D-0078 — Implement Prototype 19 as a temporary observer-only evidence bridge

**Status:** Accepted for temporary v4.6.37 runtime-evidence build

**Context:** Canonical v4.6.36 established clearance-first, cost-second refuge selection and allowed two world-space lateral candidates for each proposed Yield Entity. The agreed next step is to observe all four role/refuge alternatives before any fixture constant is removed.

**Decision:** Implement Prototype 19 / Shadow Refuge Candidate Comparison at the Automatic Encounter Admission Assessment Epoch. Construct two role propositions multiplied by two Progress-corridor lateral normals, record independent `CLEAR`, `BLOCKED` or `UNKNOWN` evidence, aggregate to `VIABLE`, `REJECTED` or `UNRESOLVED`, and apply cost only among `VIABLE` candidates.

**Implementation boundary:** The live actuator remains fixed Condor Yield, Patriot GIANTS Progress, physical-right refuge, 28 m lateral and 12 m rearward. Every Prototype 19 result is `authority=false`, `action=none`. The comparison is isolated so failure cannot block the validated actuator.

**Temporary-release boundary:** v4.6.37 is not presumed to be the next Canonicalisation target. It exists to collect runtime evidence that will be consolidated into a later owner-selected incremental version.

**Mandatory continuation:** After Prototype 19 validation, begin **Authority Migration**. Remove fixed role, side, lateral and rearward authority in separate evidence-led increments rather than retaining the fixture constants indefinitely.

## D-0077 — Select refuges clearance-first and cost-second

**Status:** Accepted for candidate v4.6.36

**Context:** The outboard-only correction in v4.6.35 was tested against two concrete geometries. Equal-width workers approaching on a coincident centre line may have two equivalent clear lateral refuges. With unequal widths and offset centre lines, one refuge may require less movement, while the opposite, longer path remains necessary when the preferred side is unavailable.

**Decision:** Adopt the governing rule: **Refuge selection is clearance-first and cost-second. Both lateral sides may be candidates. The preferred refuge is the least disruptive reachable refuge, but the opposite side remains valid when it is the only clear option.** Name the discovery **Preferred Refuge Is Not Required Refuge**.

**Candidate scope:** For each proposed Yield Entity, Situation Assessment may construct two world-space lateral Refuge Candidates. Candidate validity depends on evidence that the transition path and refuge pose are clear and preserve the Progress Entity's required Future Space. Only surviving candidates may later be compared by displacement, interruption or other operational cost.

**Direction boundary:** Human left/right labels, vehicle-local axes and Approach-Side Provenance do not grant selection authority. Relative assembly geometry and environmental feasibility must assess both lateral sides. A longer opposite-side path is not invalid merely because it crosses the original lane; it is invalid only when evidence shows conflict, containment, obstacle or other declared constraint failure.

**Consequences:** D-0076 is superseded but retained as decision history. Prototype 19 may observe up to four role/refuge alternatives, remains `authority=false`, and may not select or execute any candidate. v4.6.36 changes no runtime behaviour beyond version metadata.


## D-0076 — Restore outboard-only refuge semantics before candidate comparison

**Status:** Superseded by D-0077; retained as decision history

**Context:** The accepted Unilateral Sidestep decisions require the Yield Entity to move outward without crossing the protected-side boundary, specifically avoiding a later cross-lane recovery. The v4.6.34 continuation wording nevertheless described four alternatives formed from two Yield Entities and two refuge directions. That wording reopened a choice already closed by D-0067 and D-0068.

**Decision:** Name the documentation defect **Outboard Refuge Drift** and correct it before implementation. For Retreating Unilateral Sidestep, each proposed Yield Entity contributes exactly one applicable Outboard Refuge Region. The first Shadow Candidate Comparison therefore contains two Yield-role candidates: Condor yields outboard, or Patriot yields outboard.

**Boundary:** Outboard must ultimately be derived in world space from the Protected Progress Corridor and the proposed Yield Entity's working situation. Human left/right labels do not own direction authority. An inboard or cross-lane refuge is not a fallback side; it is a different intervention concept and remains outside the current candidate family.

**Consequences:** If a proposed Yield Entity has no evidenced outboard refuge, that role candidate remains `INVALIDATED` or `UNRESOLVED`. The Decision layer may consider the other Yield-role candidate, but must not silently convert Unilateral Sidestep into a cross-lane manoeuvre. v4.6.35 changes no runtime behaviour beyond version metadata.

## D-0075 — Accept fixture-bounded automatic admission evidence before candidate comparison

**Status:** Accepted for candidate v4.6.34

**Context:** TS018 produced one automatic Admission Candidate and one Commitment Point without console input. The fixed actuator completed passage, rejoin and the 20-second handback observation with `failure=nil`. The Encounter Episode Latch remained active through later known Split-Start Pass Recovery and no second intervention occurred.

**Decision:** Accept Fixture-Bounded Automatic Encounter Admission as empirically supported for the exact Condor/Patriot fixture. Preserve its current role, side, movement, threshold and one-shot boundaries unchanged while the evidence is consolidated. Begin the next activity with architecture for observer-only Shadow Candidate Comparison, not selection or Control.

**Boundary:** This acceptance does not define general Encounter identity, recurring commitments, automatic Yield/Progress selection, escape-side selection, geometry-derived movement, field/margin feasibility, obstacle clearance or multi-worker arbitration. All candidate comparison evidence must initially remain `authority=false`.

**Consequences:** v4.6.34 changes runtime files only for version metadata. A later candidate-comparison prototype must expose alternatives and exclusions without altering the validated actuator.

## D-0074 — Admit the fixed fixture automatically before generalising Decision authority

**Status:** Accepted in owner-declared canonical v4.6.33

**Context:** v4.6.32 validated that physical-contact and policy-clearance evidence can remain distinct without changing the successful Condor/Patriot actuator. The next operational dependency was the manual `otmTS015Arm right` command, which supplied encounter admission while roles, side and movement were already fixed by the fixture.

**Decision:** Introduce Fixture-Bounded Automatic Encounter Admission. Admit exactly one commitment when the exclusive Condor/Patriot pair remains straight, working, moving, unblocked, opposed and conflict-relevant for three seconds. Preserve Condor as Yield, Patriot as unmodified GIANTS Progress, the physical-right side and the 28 m lateral / 12 m rearward actuator. Add one Encounter Episode Latch per continuous worker episode. Remove the manual arm command.

**Boundary:** Admission may consume observer state and constant-velocity projection, but it does not own role selection, side selection, movement derivation, clearance policy or Progress control. Shadow Clearance remains `authority=false`.

**Consequences:** The runtime test began with no OuttaMyWay console command and produced exactly one candidate, one commitment and one successful actuator run. The latch prevented later re-admission. General encounter identity and recurring production commitments remain deferred.

**Outcome:** TS018 admitted after 3.09 seconds of sustained evidence, completed with `failure=nil` and 27.40 m minimum pair separation, and remained latched through Split-Start Pass Recovery.

## D-0073 — Separate physical clearance evidence from policy clearance before authority

**Status:** Accepted in canonical v4.6.31; implemented and empirically validated in owner-declared canonical v4.6.32

**Context:** TS017-B produced a successful physical passage at approximately 27.38 m reference separation. The fixture-bounded physical contact threshold was 25.37 m, giving approximately +2.01 m physical reserve. The existing combined calculation added 3.75 m of provisional margins and reported a 29.12 m requirement with approximately -1.74 m reserve. One combined `required`/`reserve` pair therefore obscured the difference between observed physical clearance and an unmet provisional policy target.

**Decision:** Shadow Clearance Calculation shall expose separate Knowledge fields:

```text
physicalContactThreshold
physicalClearanceReserve
policyMarginBudget
policyRequiredSeparation
policyReserve
```

The physical threshold is the sum of opposing Facing Clearance Extents. Policy required separation adds explicit margin components. Neither result grants Decision or Control authority. The validated 28 m actuator remains unchanged until the separated evidence is empirically validated.

**Consequences:** Physical representation assumptions can be tested independently from safety-policy choices. A positive physical reserve with a negative policy reserve is valid evidence, not a contradiction. Automatic role selection, side selection and geometry-derived movement remain deferred.

**Outcome:** v4.6.32 removed the ambiguous combined fields and empirically reproduced +2.01 m physical reserve alongside -1.74 m policy reserve while the passage actuator completed unchanged with `failure=nil`.

## D-0072 — Introduce a fixture-bounded Facing Extent Provider before granting clearance authority

**Status:** Accepted in v4.6.30 and empirically validated in canonical v4.6.31

**Decision:** Preserve the fixed 28 m TS015-B actuator and add an observer-only provider that converts exact Condor collision-catalogue identity plus live runtime bounds or origins into a one-sided compact Facing Clearance Extent. Prefer complete runtime bounds for all 13 current physical identities. When bounds are incomplete, use live origins plus a separately logged 2.50 m unresolved physical allowance. Use repeated folded-origin evidence for the pre-estimate. Grant no Decision or Control authority.

**Rationale:** TS017-A closed Patriot's operand but correctly returned `n/a` for Condor. The missing concept is a representation adapter, not another hard-coded movement distance. Explicit coverage and allowance keep uncertainty visible while allowing the formula to be evaluated against the known failure/pass boundary.

**Outcome:** TS017-B resolved all 13 identities and origins but no usable runtime bounds. The fallback produced a 7.37 m live compact extent and closed the fixture calculation. Its 25.37 m physical threshold distinguished the failed 21.44 m and successful 27.38 m observations. The provider remains fixture-bounded and observer-only.

## D-0071 — Validate clearance derivation in shadow mode before automation

**Status:** Accepted for candidate v4.6.29

**Decision:** Preserve the successful TS015-B Condor-yields actuator, manual trigger, forced side and fixed 28 m movement. Add an observer-only Shadow Clearance Calculation that derives Progress and compact Yield Facing Clearance Extents plus explicit margin components. Log the result before movement, at refuge, at closest approach and at passage confirmation. Do not allow the derived result to select roles, sides, distance, triggering or Control.

**Rationale:** Automatic selection would combine unvalidated representation, geometry, policy and actuation. Comparing a derived requirement against the known failed 21.44 m and successful 27.38 m actual fixture separations isolates the calculation before authority is granted.

## D-0070 — Calibrate lateral refuge before adding Progress control

**Status:** Accepted for candidate v4.6.28

**Decision:** Classify TS015-A as actuator success with a Clearance Budget Underrun. Preserve Patriot under unmodified GIANTS control and preserve all validated Condor manoeuvre parameters except increasing the commanded lateral refuge from 22 m to 28 m for TS015-B. Do not add Egress Protection Hold because the observed failure occurred after ample egress time and was caused by insufficient lateral assembly clearance.

**Rationale:** Changing one parameter protects the experiment's abstraction boundary. The next run tests whether lateral depth alone resolves the physical passage failure.

## D-0069 — Introduce Patriot without a Progress hold

**Status:** Accepted for candidate v4.6.27

**Decision:** Preserve the validated TS014 Condor manoeuvre and introduce exactly one new behavioural variable: Patriot remains fully under GIANTS control while Condor performs the Retreating Unilateral Sidestep. Replace the fixed refuge dwell with sustained positive passage evidence before Condor rejoins. Do not add Egress Protection Hold in the same experiment. Retain the known test-command side inversion for this candidate.

**Reason:** A first cooperative run must distinguish whether the existing sidestep creates physical passage from whether a second control action is required. Changing direction mapping, movement geometry and Progress control simultaneously would obscure causality. Production side selection remains a world-space Decision-to-Motion Direction Integrity requirement.

## D-0068 — Prefer Retreating Unilateral Sidestep and test fold/egress overlap

**Status:** Accepted for candidate v4.6.26

**Decision:** Formalise the successful TS013 geometry as Retreating Unilateral Sidestep. Construct egress and rejoin targets from the confirmed stopped pose, move outward and rearward first, then rejoin slightly forward. For the Condor-only TS014 probe, permit movement up to the observed native 15 km/h repositioning pace and begin egress after a fixture-specific `foldAnimTime=0.15` candidate while folding continues. Require Full Compact Configuration before rejoin.

**Reason:** Rearward movement increases longitudinal separation and produced a smooth Giants handback. Treating the complete fold duration as mandatory stationary latency is an untested serialisation assumption. The early threshold is isolated timing evidence, not complete-assembly clearance authority.

## D-0067 — Authorise the Unilateral Sidestep probe

**Status:** Accepted for candidate v4.6.25

**Decision:** Implement exactly one manually armed, single-worker Bounded Route Deviation. Hold, turn work off, raise and fold, move to the selected outward side, pause, rejoin ahead, restore configuration and return the original job to Giants. Keep all legacy control paths dormant. Treat fixed distances and the vehicle-centre fence as fixture-specific prototype mechanisms, not architectural clearance proof.

**Reason:** A live two-worker crossover would combine unresolved control, configuration, geometry and Route Reassertion assumptions. One worker isolates whether the intervention itself is compatible with continued Giants job ownership.

## D-0066 — Replace passive post-commitment waiting with Minimum Necessary Authority

**Status:** Accepted for candidate v4.6.25

**Decision:** Passive holding is insufficient once two workers have made opposed commitments to the same corridor. OuttaMyWay may apply firm but bounded intervention—"just enough" authority—to one Yield Entity while preserving Giants ownership of the job and one unchanged Progress Entity. Prefer Unilateral Sidestep over bilateral deviation for the first investigation.

**Reason:** TS012 proved the hold actuator but disproved hold placement through Static Obstacle Conversion. Altering geometry is necessary to create passage.

## D-0065 — Separate conflict cessation from encounter resolution

**Status:** Accepted for candidate v4.6.24

**Decision:** Predictor `CLEAR`, non-closing motion or disappearance of future collision is never sufficient release authority. TS011-A and TS011-B both returned clear prediction after collision because both workers stopped closing while remaining blocked. Release requires positive continuation and separation evidence owned by a separate Safe Release assessment.

**Why:** A prediction system describes future convergence, not the realised physical and operational state. Collapsing those responsibilities would release a worker precisely when a collision had made relative motion disappear.

## D-0064 — Authorise one exclusive Single-Worker Information-Gaining Delay experiment

**Status:** Accepted for candidate v4.6.24

**Decision:** Implement Prototype 14 for TS012. After Prototype 02 establishes a settled head-on conflict, hold exactly the later-admitted worker through the native field-worker permission gate and allow the earlier-admitted worker to continue. Permit only one hold, keep legacy control paths dormant, and do not implement automatic release. Candidate release evidence may be logged but the hold remains until inactivity, map unload or player-ended observation.

**Why:** TS011-A and TS011-B demonstrate a start-order-independent collision and a repeatable evidence window before blockage. One isolated Commitment is now justified; priority policy, release and recovery remain separate hypotheses.

## D-0063 — Govern empirical evidence by runtime baseline and patch impact

**Status:** Accepted in canonical v4.6.23

**Decision:** Every empirical result is tagged with FS25 version/build/revision where available, OuttaMyWay version, date, fixture and exact configuration. Later patches do not automatically erase earlier evidence. Results are classified as Current, Version-bound, Revalidation candidate or Invalidated. Patch Impact Watch and a small Patch Sentinel Set trigger targeted revalidation when a release intersects an architectural claim.

**Consequence:** TS005–TS009 remain evidence for FS25 1.21.0.0; TS010 is evidence for FS25 1.21.1.0 build b40785. The undocumented transition is recorded as Silent Baseline Transition rather than assumed equivalent or automatically breaking.

## D-0062 — Accept asymmetric working envelopes as an in-scope requirement

**Status:** Accepted in canonical v4.6.23

**Decision:** Replace the rejected Persistent/Regrowing Lifecycle test obligation with Asymmetric Working Envelope. A powered-vehicle trajectory, working-envelope trajectory and Physical Assembly envelope may be materially different. Directional left/right extents are required architectural knowledge; centred half-width assumptions are invalid.

**Evidence:** TS010 admitted the DEUTZ-FAHR 6135 C RVshift with SaMASZ XT 390, sustained right-offset mowing and used a spiral route that kept the mower at the field edge.

**Boundary:** Left-offset, mirrored and reversible asymmetry remain unproven. Valid Boundary Straddling is provisional and does not yet revise Full-Envelope Field Containment.

## D-0061 — Accept material-chain and admission boundaries from exact configurations

**Status:** Accepted in canonical v4.6.23

**Decision:** TS006 and TS007 form a Material-Chain Boundary Pair: native Giants AI can harvest wheat and create straw, while the downstream base-game baler configuration remains manually viable but cannot admit a native baling job. TS009 adds Native Crop-System Exclusion for grapes and olives. Continuity of agricultural purpose or material does not imply continuity of Giants AI Control Eligibility.

**Consequence:** A downstream or unsupported assembly may remain represented, player-controlled, Assembly Relevant or Obstacle Relevant without becoming an Operation participant or valid control target.

## D-0060 — Calibrate and close the Scope Overlay test-role portfolio

**Status:** Accepted in canonical v4.6.23

**Decision:** Treat the eight original test roles as hypotheses, not mandatory permanent categories. Accept TR-01, TR-02, TR-03, TR-04, TR-06 and TR-07 as satisfied; retain TR-08 as strongly supported with a declared observer-sampling limitation; retire TR-05 after its strongest positive candidate was excluded at admission. Rename TR-03 Non-Tractor Operational Assembly and TR-04 Material-Chain Boundary.

**Reason:** Preserving a disproved or irrelevant role for numerical completeness would allow the test plan to dictate architecture.

## D-0059 — Adopt Complete Test Configuration and Essential Evidence Horizon

**Status:** Accepted in canonical v4.6.23

**Decision:** Test conclusions belong to the complete declared configuration and its runtime baseline. Candidate selection proceeds from Test-Role Obligation to Agronomic Role Candidate to Configuration Candidate to Verified Test Configuration. Negative evidence requires State Sufficiency. Testing ends at the Essential Evidence Horizon unless the declared claim requires completion or another late lifecycle event.

**Consequence:** Full-field completion is evidence-driven rather than habitual. Coverage Compression and Fixture-Generation Evidence may reduce test cost without broadening conclusions.

## D-0058 — Escalate persistent spatial constraints before indefinite repetition

**Status:** Accepted for candidate v4.6.22

**Decision:** Separate Local Resolution from Operational Resolution. Situation Assessment may identify Persistent Spatial Constraint, Denied Work Space, recurring materially equivalent situations and a possible Completion Blocker. The Decision Engine must not treat repeated local diversion as proof of progress and may escalate to the player when completion requires an external physical change beyond OuttaMyWay authority.

**Consequence:** A blocking Entity remains represented. Player escalation replaces neither the obstacle model nor the original Giants job; it prevents an ineffective Recurring Commitment Loop from masquerading as successful cooperation.

## D-0057 — Define Obstacle Relevance as contextual and assessed-against

**Status:** Accepted for candidate v4.6.22

**Decision:** Physical occupancy alone does not establish Obstacle Relevance. Relevance is a temporal and directional relationship between current or plausible future space and another Entity's viable behaviour or Operation demand. Participation and Control Eligibility do not determine it.

**Boundary:** Environmental obstacles remain part of wider Situation Assessment without semantic catalogue membership. Situation Assessment establishes spatial knowledge; the Decision Engine selects any intervention.

## D-0056 — Adopt Behavioural Assembly and Membership–Relevance Separation

**Status:** Accepted for candidate v4.6.22

**Decision:** OuttaMyWay reasons about a Behavioural Assembly: connected runtime Entities and components whose combined state determines relevant behaviour, occupancy, future movement or control response. Assembly membership does not automatically establish relevance, and relevance does not depend on independent controllability.

**Clarification:** Under the current base-game capability baseline, implement detachment is player-mediated. Detachment ends the former assembly relationship, triggers reassessment and leaves the detached implement independently represented and potentially obstacle-relevant.

## D-0055 — Define Operation Participation as a functional temporal relationship

**Status:** Accepted for candidate v4.6.22

**Decision:** Presence inside the Field World and Operational Influence do not by themselves establish Operation Participation. Runtime participation requires a recognised functional relationship between a particular Entity and a particular Operation and changes with current work state.

**Consequence:** A completed, unrelated or unsupported Entity may cease or never begin participation while remaining represented, operationally influential and obstacle-relevant.

## D-0054 — Permit Independent Test Admission

**Status:** Accepted for candidate v4.6.22

**Decision:** Control ineligibility does not imply test ineligibility. Scope Overlay test selection may include Positive Test Candidates and explicitly bounded negative candidates selected to validate control exclusion, persistent representation, obstacle assessment, downstream refusal and player communication.

**Boundary:** Test admission does not change eligibility, extend the supported operational envelope or imply general category, DLC or mod compatibility.

## D-0053 — Separate Control Eligibility Profile from Runtime Control Admissibility

**Status:** Accepted for candidate v4.6.22

**Decision:** Control Eligibility Profile remains inside Scope Overlay for support and candidate selection. Runtime Control Admissibility is a downstream contextual conclusion about whether a proposed intervention may target a particular Entity now. Known ineligibility becomes a Control Exclusion Constraint in the Operational Picture.

**Principle:** Observe Broadly, Control Narrowly. Control exclusion must never remove a physically or operationally relevant Entity from Situation Assessment.

## D-0052 — Assess Giants capability at complete job-configuration viability

**Status:** Accepted for candidate v4.6.22

**Decision:** The capability subject is the Giants AI job configuration as a whole, including powered vehicle, attached working assembly, selected job and required working behaviour. Successful Job Admission, engine start or brief active state is insufficient. Viability evidence requires the Capability Confirmation Point where Giants successfully controls the required working behaviour.

## D-0051 — Adopt the Base-Game AI Capability Envelope

**Status:** Accepted for candidate v4.6.22

**Decision:** The present supported investigation baseline is the unmodified Giants base game. Mods, paid DLC or specialization changes do not automatically extend OuttaMyWay's supported operational envelope or semantic catalogue. A future external experiment must be explicitly bounded to its declared configuration.

## D-0050 — Establish the Player Responsibility Boundary

**Status:** Accepted for candidate v4.6.22

**Decision:** OuttaMyWay assumes operationally reasonable player deployment and does not promise to coordinate every physically possible but nonsensical arrangement permitted by the game. Unsupported presence remains representable and may remain obstacle-relevant or operationally influential.

## D-0049 — Adopt the independent contextual Scope Overlay

**Status:** Accepted for candidate v4.6.22

**Decision:** The Scope Overlay is not a scalar asset property. It maintains independent contextual claims for Control Eligibility Profile, Operation Participation, Assembly Relevance and Obstacle Relevance. The claims may have different subjects, evidence and lifetimes, and none may silently determine another.

**Consequence:** Catalogue membership remains semantic evidence only. Runtime representation is broader than control support, and structural challenge remains a later asset-specific question.

## D-0048 — Freeze the reviewed base-game Semantic Catalogue as evidence, not scope

**Status:** Accepted for candidate v4.6.21

**Decision:** Preserve one human-reviewed Semantic Profile for each of the 606 base-game definitions as the current semantic evidence baseline. The catalogue records family, primary role, secondary roles, capabilities and provenance. It does not assign OuttaMyWay control, Operation participation, assembly relevance, obstacle relevance or structural representation.

**Boundary:** Paid DLC and modded definitions remain parked. Reviewer notes that mention likely scope are evidence inputs for the next discussion, not pre-approved scope decisions.

## D-0047 — Adopt Minimum Sufficient Semantic Resolution and Scope-Driven Review Depth

**Status:** Accepted for candidate v4.6.21

**Decision:** Semantic review depth is determined by the architectural conclusion it must support. Likely in-scope and boundary cases receive full review; excluded but representation-relevant cases receive enough resolution to support exclusion and physical relevance; clearly irrelevant cases may use coarse exclusion. Material identity errors are always corrected. Refinements that cannot change a control, participation, assembly or obstacle conclusion may be parked.

**Reason:** Completion means complete decision coverage, not exhaustive taxonomy.

## D-0046 — Separate semantic classification, scope and structural challenge

**Status:** Accepted for candidate v4.6.21

**Decision:** Semantic family, role and capability describe what an asset is and does. Scope determines how OuttaMyWay may treat it. Structural Challenge describes how difficult its physical representation may be. No layer may silently stand in for another.

**Consequences:** Active-control exclusion does not automatically remove attached-assembly or obstacle relevance. Purchase category, declared type and function remain evidence; they do not establish physical structure.

## D-0045 — Use Semantic Profiles with cohort review and Approval Inheritance

**Status:** Accepted for candidate v4.6.21

**Decision:** Replace flat category normalisation with a Semantic Profile containing primary family, primary role, secondary roles and orthogonal capabilities. Declared-function cohorts reduce review effort but remain anchors rather than decisions; evidence may split a cohort or require an asset exception.

**Review rule:** `APPROVED` accepts the complete suggested profile unchanged, including intentional blanks. `AMENDED` supplies the complete replacement profile. Vocabulary gaps are named and resolved explicitly rather than forced into an inaccurate existing term.

## D-0044 — Make Situation Assessment the Representation-Fitness Arbiter

**Status:** Accepted for candidate v4.6.20

**Decision:** Representations report scope, evidence, dependencies, age, changes, coverage, cost and permitted conclusions. Situation Assessment decides whether they remain fit for the current question, plausible futures and horizon, and may emit `CURRENTLY_FIT`, `FIT_FOR_LIMITED_HORIZON`, `USABLE_WITH_UNCERTAINTY`, `REFRESH_REQUIRED` or `STRUCTURALLY_INVALID`. Stale evidence is retained with restricted authority rather than discarded automatically.

**Boundary:** Situation Assessment produces Knowledge and does not execute vehicle Control. Routine observation/representation refresh remains maintenance of the Operational Picture. Any active response when decision time expires belongs to a later Decision Engine decision.

## D-0043 — Adopt the Resolution Contract and self-describing assessment portfolio

**Status:** Accepted for candidate v4.6.20

**Decision:** `RESOLVED` requires candidate existence, assembly and structural coherence, Entity-local geometry authority, observable current pose and no unresolved contradictory identity. Resolution emits a claim set with explicit limits and does not imply Inventory Closure, Coverage Closure or footprint correctness. Situation Assessment receives a minimum sufficient defensible portfolio whose layers carry Representation Passports, cost profiles and permitted conclusions. Admissibility precedes optimisation.

**Evidence rule:** Resolution Path convergence, negative controls, motion-derived distinctness, symmetry and repeated observation corroborate claim-specific confidence but are not universal gates. A decisive mandatory contradiction prevents resolution.

## D-0042 — Treat implement class as context, not structural authority

**Status:** Accepted for candidate v4.6.20

**Decision:** Gameplay class may guide operational questions and expected semantics but cannot establish physics-component structure, hierarchy, mapping coverage, articulation or a privileged Resolution Path. Physical authority remains source metadata, current assembly, runtime Entity geometry and observed pose.

**Evidence:** Tiger 8 MT and TopDown 600 are both cultivators yet expose materially different structures and successful Resolution Paths. Prototype 13A decreased confidence in class homogeneity and increased confidence in a class-independent Resolution Contract.

## D-0041 — Accept GIANTS job completion disposition and retain the obstacle

**Status:** Accepted baseline policy; refined by D-0147 for positively obstructive Terminal Occupancy

**Decision:** Wherever and however GIANTS ends an original AI job is accepted. Job completion alone does not authorise OuttaMyWay to choose a parking position or relocate the completed assembly. The assembly loses active membership and motion expectation but remains represented in its realised final pose as a non-member obstacle.

**D-0147 refinement:** if that realised occupancy later positively obstructs continuing active demand, and Automatic Terminal Egress is enabled, the completed unclaimed assembly may be compacted and given one simple bounded boundary-relative outward clearance manoeuvre. This is obstruction resolution, not parking or productive-job continuation. Unsupported/exhausted cases remain the player's responsibility.

## D-0040 — Park Assessment Deadline Escalation

**Status:** Deferred

**Decision:** When useful representation cannot be refreshed before assessment time expires, Situation Assessment reports the unresolved knowledge. A later Decision Engine session may consider selective hold, emergency freeze or another failsafe. No all-stop or timeout policy is selected by Prototype 13A consolidation.

## D-0039 — Reserve route for navigation and use Resolution Path

**Status:** Accepted for candidate v4.6.20

**Decision:** Architectural prose uses **Resolution Path** for a method that proposes a runtime candidate from source and assembly relationships. The unqualified word **route** remains available for a worker's navigable field path. Historical Prototype 13A filenames, Lua identifiers and log outcomes retain `route` vocabulary for evidence traceability.

## D-0038 — Adopt Repository-Native Line-Ending Authority

**Status:** Accepted for candidate v4.6.16

**Decision:** Repository text is stored and checked out as LF under `.gitattributes`. The four inherited CRLF files are normalised during the v4.6.16 Engineering Transformation. Release manifests and canonical packages preserve repository-declared bytes rather than contributor-platform defaults.

**Reason:** Native Linux Git and deterministic packaging exposed historical Git-blob/release-byte divergence. Repository policy should remove that anomaly for future releases.

## D-0037 — Continue assessment through Clearance Unresolved

**Status:** Accepted architectural decision

**Decision:** Incomplete relevant Realised Coverage Closure does not halt Situation Assessment and does not manufacture conflict. It removes authority to claim all-clear only in the affected scope; the knowledge state becomes `CLEARANCE_UNRESOLVED`. Decision and Commitment remain responsible for any caution or intervention.

## D-0036 — Adopt Coverage Closure and the Coverage Ledger

**Status:** Accepted architectural decision

**Decision:** Inventory Closure and Coverage Closure are distinct. Coverage Closure may be enumerative, enclosing or hybrid and is divided into Structural and Realised Closure. Every closure claim records scope, basis, contributors, unresolved regions, underestimation risk and pose status in a Coverage Ledger.

## D-0035 — Separate stable occupancy, deployment and manoeuvre sweep

**Status:** Accepted architectural decision

**Decision:** Folded and working are the principal stable occupancy states. GIANTS implement deployment is Stationary Configuration Motion assessed through a Deployment Clearance Envelope before its Commitment Point. Deployment Sweep and steering-dependent Manoeuvre Sweep remain separate; midpoint-pivot prediction is rejected as an unsupported assumption.

## D-0034 — Permit heterogeneous, family-based footprint composition

**Status:** Accepted architectural decision

**Decision:** Homologous components share a family representation strategy while retaining member-specific parameters. Exact, derived and fallback representations may coexist. Fallback is introduced at the smallest safe scope, uncertainty remains local and coverage takes priority over uniform precision.

## D-0033 — Use a Job-Scoped Representation Catalogue

**Status:** Accepted architectural decision

**Decision:** Construct stable Representation Templates once at AI job start and expire the catalogue at job end. During the job, Situation Assessment selects physical state and performs Pose Realisation from current plan-view transforms. Equipment or configuration changes belong to a new job and new catalogue.

## D-0032 — Accept the Planar Representation Portfolio and Convex Planar Envelope

**Status:** Accepted architectural decision

**Decision:** Physical Representation uses Planar Collision Semantics and may preserve Component Footprint Sets, a Convex Planar Envelope, member rectangles, assembly rectangles and explicit unknown occupancy. Convex Planar Envelope is accepted as an intermediate fallback; Envelope Anchor Selection is Deferred.

## D-0031 — Separate exact physical identity from occupancy fallback

**Status:** Accepted architectural decision

**Decision:** The complete source/configuration/member/runtime evidence chain is required before claiming exact collision-shape identity. Failure to complete that chain does not forbid clearly qualified conservative occupancy fallback. Fallback geometry must never be presented as resolved collision geometry.

This log records Accepted, Deferred, Rejected and Superseded project choices that do not require a full Architecture Decision Record. Newer decisions appear first.

## D-0030 — Adopt the Physical Assembly Search Boundary

**Status:** Strongly supported by Prototype 12 runtime evidence and accepted in candidate v4.6.15

**Decision:** physical geometry discovery shall begin from the operational worker, enumerate its current Physical Assembly, and then perform source-to-runtime physical identity resolution independently inside each member's own asset and runtime root.

**Validation:** Condor produced one integrated member. S 416 + Tiger 8 MT and 8RX 410 + TopDown 600 each produced two distinct assets, two distinct runtime roots and one coherent attachment edge. The second attached fixture replicated the structure across different manufacturers and hierarchies.

**Boundary:** attachment establishes assembly ownership only. Collision metadata and configuration remain the authorities for physical membership and current inclusion. No compound occupancy is authorised until member-local resolution is complete.

## D-0029 — Separate declared AI working state from demonstrated motion

**Status:** Accepted observational distinction in candidate v4.6.15

**Decision:** GIANTS `WORKING` state and measured physical progression shall remain separate observations. A stationary active worker may not be classified as progressing solely from the declared state.

**Evidence:** the S 416 + Tiger 8 MT remained active and reported `WORKING` while movement stayed effectively zero for at least fifteen seconds. Manual cultivation disproved simple equipment incapability. The 8RX 410 + TopDown 600 later sustained normal AI work.

**Boundary:** no cause, fault classification or control response is inferred from this evidence alone.

## D-0028 — Discover physical assembly ownership before collision-node generalisation

**Status:** Strongly supported by Prototype 12 evidence; superseded in ordering detail by D-0030

**Decision:** Prototype 12 shall discover the active operational worker and its current attached runtime object graph before attempting general source-to-runtime collision-node resolution. Each member shall retain its own asset identity and runtime root.

**Evidence basis:** Condor is integrated into one asset, while a Valtra S 416 plus Horsch Tiger 8 MT presented one operational worker with a separately attached implement asset. The worker identity therefore cannot serve as the universal physical hierarchy root.

**Validation:** one integrated and two attached base-game fixtures satisfied the member-identity and relationship criteria.

**Boundary:** attachment establishes assembly structure only. It does not establish collision membership, component extent or complete occupancy.

## D-0027 — Accept Runtime Entity Geometry Authority and reject mapping-key generalisation

**Status:** Strongly supported by Prototype 11 TS001 evidence

**Decision:** runtime Entity identity is the demonstrated geometry selector for the tested shape-bound APIs. Source asset `shapeId` is retained as provenance but not used as a descendant selector. Asset mapping keys are local vocabulary and shall not become universal collision-node naming conventions.

**Validation:** all eight resolved boom nodes were invariant across zero, own, sibling and invalid second arguments while remaining differentiated across runtime Entities; vehicle-root calls remained root aliases through the full fold lifecycle.

## Repository Release System Decisions

- **D-RRS-26 — Candidate Determinism and Evidence Provenance:** given the same exact Canonical Repository Snapshot and fingerprint-bound Engineering Intent, Candidate Production must emit a byte-identical candidate repository package across supported execution platforms. Evidence packages may contain execution-specific provenance and need not be byte-identical, but must identify the same candidate and agree on all substantive repository findings.
- **D-RRS-25 — Fingerprint-Bound Engineering Intent:** Engineering Intent is bound to one exact Canonical Repository Snapshot by integrity fingerprint. Any change to that baseline invalidates the handoff and requires regeneration before repository evolution may proceed.
- **D-RRS-24 — Engineering Intent Boundary:** repository evolution is expressed as declarative Engineering Intent rather than direct repository modification by the consolidation author. The local Repository Release System is the authoritative mechanism that transforms accepted intent into candidate repository state.
- **D-RRS-23 — Engineering Increment Boundary:** an increment closes when its declared engineering purpose reaches a coherent breakpoint; time, chat boundaries and version numbering do not define completion.
- **D-RRS-22 — Knowledge Promotion Completeness:** working artefacts may be retired only after durable architectural, implementation and operational knowledge has been promoted into authoritative repository homes.
- **D-RRS-21 — Evidence-Driven Confidence:** the RRS produces evidence sufficient for review to focus on engineering judgement rather than re-verifying unchanged content.
- **D-RRS-20 — Authority Transformation Purity:** candidate-to-canonical transformation must not alter approved substantive engineering content.
- **D-RRS-19 — Ordered State Transitions:** authority states may be entered only through their defined gates.
- **D-RRS-18 — Canonical Baseline Gate:** Candidate Production begins only from the exact established canonical repository.
- **D-RRS-17 — Authority Transformation:** authority state changes only after completed transformation, validation, accepted review and explicit Canonicalisation.
- **D-RRS-16 — Engineering Transformation:** substantive repository change occurs only during Candidate Production from the exact canonical baseline.
- **D-RRS-15 — Candidate and Canonical Are Separate Transformations.**
- **D-RRS-14 — Repository Authority States:** Working, Release Candidate and Canonical are distinct from version identity.
- **D-RRS-13 — Controlled Repository Transformation.**
- **D-RRS-12 — Review and Canonicalisation Are Separate Decisions.**
- **D-RRS-11 — Authorship Does Not Confer Approval.**
- **D-RRS-10 — Explicit Release Roles.**
- **D-RRS-09 — Canonicalisation Authority:** only the repository owner may declare the exact reviewed candidate canonical.
- **D-RRS-08 — Consolidation Review.**
- **D-RRS-07 — Human-Governed Consolidation.**
- **D-RRS-06 — Knowledge Promotion.**
- **D-RRS-05 — Release Initiation.**
- **D-RRS-04 — Engineering Closure Is External.**
- **D-RRS-03 — Release Findings.**
- **D-RRS-02 — Dual Validation.**
- **D-RRS-01 — Release Candidate:** the governed unit includes repository, provenance, declared transformation, findings and evidence.

**Recovery finding:** failure to promote the executable RRS implementation caused avoidable capability loss. Repository-owned implementation is now required.


## D-0026 — Test runtime geometry selector semantics before further coverage work

**Status:** Strongly supported by repeated TS001 runtime evidence from noncanonical candidate v4.6.13

**Decision:** Prototype 11 shall determine whether the first shape-bound API argument owns geometry selection by comparing zero, own, sibling and invalid second arguments on all eight already-resolved Condor boom collision nodes and known-ID variants on the vehicle root.

**Evidence basis:** Prototype 09 produced distinct stable component bounds from distinct resolved runtime nodes. Prototype 10 returned one repeated root-Entity sphere for every source asset ID, disproving vehicle-root descendant selection and exposing the Self-Coherence Blind Spot.

**Validation requirement:** identity evidence must compare results across invocations and across runtime Entities. Local/world self-coherence alone is insufficient. The invalid high ID is diagnostic and is not required for support.

**Reason:** geometry extraction is available; selector semantics and Source-to-Runtime Shape Resolution are now the limiting architectural questions.

**Validation result:** all eight resolved nodes were invariant across zero, own, sibling and invalid-high second arguments, while seven local and eight world signatures preserved cross-Entity differentiation. Vehicle-root known-ID calls remained aliased. Runtime Entity Geometry Authority is accepted for the tested APIs and Entity types.

**Boundary:** no remaining physical nodes are resolved, no complete physical coverage or occupancy aggregation is claimed, and no containment, sweep, Decision, Commitment or Control is authorised.

## D-0025 — Test complete physical-shape coverage before occupancy design

**Status:** Hypothesis disproved by TS001 runtime evidence from noncanonical v4.6.12

**Decision tested:** Prototype 10 tested the proposed root-scoped shape-bound route across all 29 source-catalogued Condor physical `compoundChild` shapes while preserving current configuration membership and a nonphysical geometry control.

**Hypothesis boundary:** geometry-bound availability does not establish physical membership. The source collision catalogue owns physical meaning; configuration classification owns current inclusion; runtime sphere APIs own conservative extent evidence.

**Validation:** every physical ID and the nonphysical control returned the same root-local centre and radius. The aggregate remained an unchanged `8.726038 m` cube through the fold lifecycle. The route is rejected as Root-Entity Sphere Aliasing.

**Discovery:** local/world coherence validated the returned root bound internally but did not validate intended descendant identity. This is the Self-Coherence Blind Spot.

**Retained knowledge:** source collision metadata and configuration membership remain valid; complete runtime coverage still requires Source-to-Runtime Shape Resolution.

**Boundary:** diagnostic sphere unions are not an authoritative Physical Occupancy Envelope. No containment, transition sweep, projected motion sweep, Decision, Commitment or Control is authorised.

## D-0024 — Test the documented per-shape sphere bridge before binary mesh extraction

**Status:** Strongly supported by TS001 runtime evidence; consolidated in candidate v4.6.13

**Decision:** Prototype 09 shall test whether documented runtime shape-sphere APIs can expose trustworthy conservative component-local physical extents from Prototype 08A resolved live collision nodes while retaining Prototype 08B source collision provenance.

**Hypothesis boundary:** the experiment tests runtime availability, identity semantics, physical provenance, local stability and local-to-world coherence. It does not derive compound occupancy or establish that spheres are precise enough for containment.

**Implementation:** consumed Prototype 08 state, tested a protected identity/frame matrix and sampled selected routes through the full fold lifecycle. All eight intended physical boom shapes selected coherent resolved-node routes. Prototype 10 later showed that source asset `shapeId` is not an independent vehicle-root descendant selector.

**Validation:** all eight shapes returned stable finite component-local geometry spheres with `usesGeometry=true` and effectively exact local-to-world centre coherence. The hypothesis is strongly supported at bounding-sphere resolution. Exact mesh geometry and representation utility remain unresolved.

**Reason:** this is the highest-value low-cost experiment before reverse-engineering or exporting binary `.i3d.shapes` geometry. A positive result could establish direct conservative extent evidence; a negative result would decisively redirect the next cycle.

**Boundary:** No Physical Occupancy Envelope, field containment, Configuration Transition Sweep, Projected Motion Sweep, Decision, Commitment or Control is authorised.

## D-0023 — Separate collision-node pose from collision-mesh extent

**Status:** Accepted in canonical v4.6.10; archival v4.6.9 superseded

**Decision:** Model-derived physical geometry remains split into 08A authoritative live collision-node pose and 08B offline collision identity, hierarchy, configuration membership and future local mesh extent. Collision-node origins and transforms shall not be represented as collision-mesh bounds.

**Validation:** Corrected TS001 enumeration found Condor through `g_currentMission.vehicleSystem.vehicles`, attached one Entity and resolved all eight configured 36 m boom collision nodes exactly once. The live origin span moved continuously from approximately 2.8237 m folded to 30.2403 m deployed through one `FOLDED -> TRANSITION -> DEPLOYED` lifecycle with preserved identity.

**08B result:** The catalogue correctly established 29 physical compound-child shapes, eight active 36 m nodes, mappings and principal lateral endpoint spans. Full offline pose reconstruction is non-authoritative: the folded `Col04` longitudinal prediction was materially wrong and the deployed endpoint retained approximately 0.55 m RMS error. Runtime transforms therefore own pose truth.

**Geometry caution:** Condor's four sections per side appear tapered toward the tips, but this is model-specific supporting evidence. Other foldable implements may have different segmentation, dimensions, activation and articulation and shall not inherit a Condor-shaped template.

**Boundary:** `.i3d.shapes` local mesh extents remain unresolved. Working width, AI collision-trigger width and collision-node origin span shall not substitute for a Physical Occupancy Envelope. No containment, projected sweep or Control is included.

## D-0022 — Separate physical geometry from agronomic working width and test evidence discovery

**Status:** Accepted in canonical v4.6.8

**Decision:** Situation Assessment shall distinguish GIANTS Collision Geometry, the derived Physical Occupancy Envelope and the agronomic Working Footprint. Physical occupancy remains a complete-Entity requirement, while working width and size metadata are diagnostic comparisons only and shall never substitute for unknown physical geometry.

**Validation:** Prototype 07 found `getRigidBodyType=true`, but the tested shape, local and world bounding functions and collision-mask query were unavailable. Condor and Patriot each scanned 800 hierarchy nodes with zero bounded evidence, `coverage=NONE` and `confidence=UNKNOWN`. No physical envelope or pair clearance was produced during the approximately 337 s TS003 run. No Silent Under-Approximation passed because the 36 m working-marker widths remained separate.

**Finding:** the tested Direct Geometry Retrieval route is unsupported. This is the Runtime Geometry Access Gap: GIANTS' internal collision geometry is not necessarily exposed as queryable complete-Entity bounds through the mod Lua runtime.

**Consequence:** retain the Physical Occupancy Envelope architecture and investigate one alternative evidence route at a time. Increasing hierarchy scan depth alone is not justified while no usable bound API exists.

**Boundary:** no field containment, projected motion sweep, configuration-transition sweep, safety padding, static-object identity or Control behaviour is included.

## D-0021 — Test Field World observation passively

**Status:** Accepted in canonical v4.6.6

**Decision:** Prototype 05 shall observe mission vehicles inside the field polygon independently of active GIANTS AI membership and shall record Field World Membership, Operational Membership and Situation Relevance separately. It shall remain passive.

**Validation focus:** parked Patriot after AI detachment and completed Condor at the shared GIANTS finishing position are the first positive cases. Moving player-controlled vehicles are naturally included. Static evidence is limited to GIANTS field islands and native static-collision signals until exact object identity is available.

**Boundary:** The prototype may use conservative current-envelope geometry for evidence but shall not claim exact maximum collision geometry, projected sweep, active containment, safe release or Information-Gaining Delay.

**Validation:** The vehicle observation hypothesis is strongly supported. TS002 discovered completed Condor at save load as `NON_OPERATION_VEHICLE`, kept Patriot as the sole `OPERATION_MEMBER`, changed the relation from `NOT_RELEVANT` to `RELEVANT` as Patriot approached and ended with Patriot blocked in the observed collision. Supporting TS001 runs retained stopped/player-controlled Patriot and completed Condor. Prototype 06 in canonical v4.6.7 resolved the vehicle membership-event latching and live relationship-reclassification defects: TS002 produced no false transitions, while TS003 produced exactly one live membership transition and one identity-preserving reclassification when Condor completed. Exact containment geometry and complete static-object identity remain unresolved. No Control behaviour exists in the canonical implementation.

## D-0020 — Define the Field World and require Full-Envelope Field Containment

**Status:** Accepted in canonical v4.6.6 as recovered architectural knowledge

**Decision:** One field boundary polygon defines the bounded Field World for one Operation. Every AI worker's complete vehicle–implement collision envelope, including configuration-dependent maximum extent and projected swept geometry, must remain wholly inside that polygon at all times.

**Reason:** A vehicle root node or centreline can remain inside while a boom or implement sweeps into hedges, trees, ditches or other external geometry. TS001 required hedges to be deleted only because containment behaviour is missing; this workaround must not become a product requirement.

**Consequence:** External objects just beyond the polygon are outside normal obstacle scope. Physical objects wholly inside the Field World remain observable independently of Operational Membership, and their Situation Relevance is assessed dynamically.

## D-0019 — Test continuation intent and safe release passively

**Status:** Accepted in canonical v4.6.5

**Decision:** Prototype 04 shall distinguish locally revealed intent from route continuation, expire local intent when the Progress Entity begins a new manoeuvre, and assess an observed release retrospectively through the next repositioning event. It shall remain passive and may use a player-performed stop/restart only as test stimulus.

**Boundary:** The next observed manoeuvre and subsequent local settlement define the provisional Continuation Safety Horizon. The prototype shall not infer a complete GIANTS route, authorise release or issue Control.

**Rationale:** Prototype 03 established temporal margin but the manual continuation test produced a later crossing conflict after the original head-on encounter disappeared. Current-lane intent was useful locally but insufficient as safe-release evidence.

**Instrumentation correction:** The same declared increment may remove Prototype 03 startup contamination, expire stale `ACTIONABLE` evidence and latch repeated exhaustion logging because these defects directly obstruct the new evidence contract.

**Validation:** The limited TS001 run strongly supported bounded local intent and Intent Expiry. Condor's settled paths produced local epochs that expired at each new manoeuvre. Patriot's manual stop removed it from active-worker observation; Condor later repositioned toward the physically parked Patriot and became blocked until the player moved Patriot. The original wait position was therefore unsafe through a later continuation, but the probe could not classify that physical encounter because the parked vehicle was no longer an observed worker. A later clear result followed manual relocation and does not establish a Safe Release Point. Completed Condor later remained physically relevant at the shared finishing position after leaving active observation, where Patriot became blocked. No hold, release, Decision, Commitment or Control behaviour exists in the canonical implementation.

## D-0018 — Test the Candidate Option Preservation Window passively

**Status:** Accepted in canonical v4.6.4

**Decision:** Prototype 03 shall reuse the unchanged TS001 encounter to test whether manoeuvre ordering, a unique Progress Entity, an Intent Revelation Point and remaining Response Margin expose a Candidate Option Preservation Window before conflict establishment. It shall remain passive and may produce knowledge only.

**Invariant:** An Information-Gaining Delay may never hold all relevant moving participants. At least one Progress Entity must remain able to generate the evidence required for reassessment. This scope does not prohibit a future Emergency Arrest Commitment with an independent release mechanism.

**Rationale:** The accepted Prototype 02 run showed Condor and Patriot entering overlapping turns before either could adapt to the other's revealed lane. The player's observation suggested a brief wait might preserve alternatives, but passive evidence was required to establish whether a useful window actually existed.

**Validation:** The unchanged TS001 run strongly supported an observable `CANDIDATE_OPEN → ACTIONABLE → EXHAUSTED` sequence. Condor's intent was revealed while Patriot remained about 56% through its manoeuvre, with approximately 12 s before conflict establishment and about 7.42 s of conservative temporal margin. The Progress Preservation Invariant held for the pair. A manual stop/restart follow-up disproved current-lane intent as sufficient safe-release evidence because Condor later repositioned across Patriot's resumed path; that run is qualified by Job Restart Perturbation. No hold, Decision, Commitment or Control action exists in the canonical implementation.

## D-0017 — Test Conflict Confidence through passive trajectory evidence

**Status:** Accepted in canonical v4.6.3

**Decision:** Prototype 02 shall reuse the unchanged TS001 encounter to test whether Trajectory Settlement and prediction persistence can distinguish a transient projected intersection from an established plausible conflict. It remains passive and may produce knowledge only; Decision, Commitment and Control are excluded.

**Reason:** Prototype 01 detected conflict early but showed that closest-approach estimates changed drastically while the workers manoeuvred. Treating the first projected intersection as stable knowledge would collapse uncertainty prematurely.

**Validation:** The unchanged TS001 run strongly supported the `FORMING → ESTABLISHED` distinction and the separate explanatory value of per-Entity Trajectory Settlement and relationship-level Conflict Confidence. The post-collision `DECAYING → CLEARED` interpretation was disproved because both workers remained physically blocked after the future projection disappeared. Thresholds and state labels remain diagnostic.

## D-0016 — Use unchanged TS001 as a passive Conflict Emergence prototype

**Status:** Accepted in canonical v4.6.2

**Decision:** Prototype 01 shall observe the existing TS001 two-worker head-on convergence without changing routes or controlling either vehicle. It shall record sufficient motion and closest-approach evidence to distinguish independent, converging, conflict-relevant and immediate-conflict phases.

**Reason:** A naturally occurring GIANTS AI encounter tests the Situation Assessment hypothesis without constructing a scenario around implementation thresholds. Passive observation isolates interpretation from Decision, Commitment and Control.

**Validation:** The first unchanged TS001 run supported early conflict detection while also distinguishing an earlier harmless head-on pass. Thresholds and provisional stage labels remain diagnostic and may change; the passive and single-hypothesis boundaries do not.

## D-0014 — Reject Conditions and demote Conflict Zone from root primitive

**Status:** Accepted in v4.5.7

**Decision:** Conditions is rejected as a separate concept because environmental influences already belong within Situation Space. Conflict Zone remains useful operational language but is treated as derived rather than a root architectural primitive.

**Reason:** Both conclusions emerged from attempts to explain the observed world with fewer independent concepts and fewer special cases.

## D-0013 — Defer Entity and Operational Picture terminology

**Status:** Deferred in v4.5.7

**Decision:** Retain `Entity` as a provisional label and retain both `Operational Picture` and `Current Situation` until evidence establishes stable boundaries or equivalence.

**Reason:** Confidence in the underlying concepts is higher than confidence in their names. Vocabulary must not force premature architecture.

## D-0012 — Distinguish Reality, Knowledge and Current Situation

**Status:** Accepted in v4.5.7

**Decision:** Reality exists independently; observations sample Reality; Situation Assessment transforms observations into Knowledge; Current Situation is the present estimated point within Situation Space. Time is the dimension in which each evolves.

**Reason:** The distinction explains uncertainty, hidden hazards and delayed understanding without adding special-case mechanisms.

## D-0011 — Accept the Spaces architectural family

**Status:** Accepted in v4.5.7

**Decision:** Accept Situation Space, Future Space and Action Space as architectural concepts. Treat Situation Assessment as a transformation between observations and maintained Knowledge rather than as another Space.

**Reason:** The three Spaces describe different sets: possible situations, plausible futures and available actions. Their distinctions survived repeated attempts at simplification and clarified observed expert behaviour.

## D-0010 — Require independent packaged-release identity verification

**Status:** Accepted in v4.5.4

**Decision:** Generation and verification are separate activities. A release is not canonical until the packaged ZIP itself passes an independent Repository Identity Check.

**Reason:** A package filename and a successful build claim did not prove that the archive contained the intended canonical baseline.

## D-0009 — Reconstruct questioned history from evidence

**Status:** Accepted in v4.5.4

**Decision:** If canonical status is questioned, rebuild from the last verified canonical baseline and preserved mining summaries, review records or transcripts rather than recollection.

## D-0008 — Defer repository folder numbering

**Status:** Deferred in v4.5.4

**Decision:** Retain the existing `00_`, `10_` … `50_` numbering until evidence identifies the engineering problem that a numbering change would solve.

**Reason:** The question is not whether numbering is aesthetically preferable, but whether it solves an observed continuity or navigation problem. No such evidence currently exists.

## D-0004 — Optimise the development repository for continuity first

**Status:** Accepted in v4.5.0

**Decision:** The development repository's primary audience is the continuing engineering collaboration across new chats and sessions. It must preserve enough explicit current knowledge that conversational memory is unnecessary. A secondary audience is future intelligent contributors.

**Reason:** Seamless continuation is the immediate operational risk. The same explicit knowledge that protects continuity also improves contributor comprehension.

**Consequence:** Internal handovers, discoveries, decision rationale and release tooling remain in the development repository even if a future public repository is editorially reduced.

**Review:** Revisit when public GitHub publication begins.

## D-0003 — Treat the repository as the source of project knowledge

**Status:** Accepted in v4.5.0

**Decision:** Reality remains authoritative. The repository records current project knowledge and must be corrected when evidence disproves it.

**Reason:** Calling the repository the source of truth could encourage defending recorded assumptions against contrary evidence.

## D-0002 — Defer Opportunity

**Status:** Accepted in v4.4.0; reviewed unchanged in v4.5.0

**Decision:** Do not create an Opportunity architectural layer yet.

**Reason:** The term is useful, but no independent lifecycle, ownership or responsibility has been observed.

## D-0001 — Accept Commitment

**Status:** Accepted in v4.4.0; reviewed unchanged in v4.5.0

**Decision:** Commitment is a first-class architectural concept between Situation Assessment and execution.

**Reason:** Repeated oscillation and premature action changes are decision-persistence problems rather than steering problems. Commitment provides explicit lifecycle ownership.

## D-005 — Govern document authority, currency and lifecycle

**Status:** Accepted in v4.5.2

**Decision:** Every first-class document must have an intentional authority, currency model, lifecycle and discoverable route. Archive preserves superseded knowledge; compatibility preserves an old route. They are separate responsibilities.

**Reason:** Review of v4.5.0 found stale version declarations, inconsistent casing, ambiguous legacy authority and orphaned documents.

## D-006 — Require a supplied canonical baseline before modification

**Status:** Accepted in v4.5.2

**Decision:** Any modification to the repository shall begin with the current canonical repository being supplied as the implementation baseline.

**Reason:** Uploaded-file availability and conversational state are transient and cannot be treated as engineering dependencies.

## D-007 — Engineering Continuity is a canonical release gate

**Status:** Accepted in v4.5.2

**Decision:** A canonical release must contain sufficient knowledge for a competent engineer to continue correctly using only that repository.

**Reason:** Preserving code without preserving decision quality, failed hypotheses and continuation context is insufficient.

## D-0015 — Adopt Architectural Prototyping

**Status:** Accepted in v4.5.9

The project transitions from architecture-only seminars to architecture–prototype cycles. Each prototype shall validate one architectural hypothesis.

## D-0015 — Prototype 13A uses declared routes before automated discovery

**Decision:** Test explicit fixture-declared routes for Condor, Tiger 8 MT and TopDown 600 through a common candidate evaluator before implementing automated route discovery. Preserve every candidate, convergence/disagreement and negative control. Route type does not grant physical authority.

**Reason:** A first-success lookup would allow implementation order to determine physical identity. Explicit routes isolate hypotheses while the common evaluator discovers which evidence patterns are trustworthy.

**Status:** Accepted for v4.6.17 evidence candidate.


## D-0016 — Separate physical state dimensions and stop inferring fold semantics from raw animation progress

**Decision:** Treat deployment, vertical configuration, terrain contact, functional engagement and GIANTS operational phase as separate architectural dimensions. Prototype diagnostics may record raw animation values and observed motion but must not infer universal semantic state from endpoint distance alone. Player-controlled assemblies remain outside cooperative-worker behaviour and are represented only as possible obstacles to AI workers.

**Reason:** TS004 TopDown held a stable interior `foldAnimTime=0.1250` while extended and raised for manoeuvring, then lowered toward `0.0000` for work. `WORKING` phase began before the stable low pose. Direct-soil-contact implements and non-contact sprayer booms also give raise/lower different functional meanings.

**Status:** Accepted for v4.6.18 correction candidate.


## D-0019 — Require executable and atomic refuge replacement

**Status:** Accepted for v4.6.67 runtime validation.

**Decision:** A replacement refuge shall not become authoritative from endpoint viability alone. Decision must prove candidate-bound transition executability from current Reality, and Control must accept target and side-frame mutation atomically. Unsafe or unresolved replacements preserve the current refuge.

**Reason:** v4.6.66 committed a 58.20 m opposite-side replacement with only 5.52 s to closest approach. Partial side-frame mutation converted a safe occupied refuge into an immediate centreline-fence failure and later all-hold state.


## D-0020 — Commit one manoeuvre leg before ordinary refuge redirection

**Status:** Accepted for v4.6.68 runtime validation.

**Decision:** Continuous reassessment may record a preferred replacement refuge while a movement is active, but ordinary target authority shall not change until the current manoeuvre leg reaches a settled boundary. Early interruption requires separate evidence that continuing is no longer admissible.

**Reason:** v4.6.67 accepted five individually executable target revisions during one movement. Local executability did not provide coherent Control; repeated side changes produced indecision and final failure.


## D-0021 — Anchor each refuge manoeuvre leg at its verified start pose

**Status:** Accepted for v4.6.69 runtime validation.

**Decision:** A replacement refuge leg shall carry exact current-pose start evidence through Decision and Commitment. Control shall verify that evidence remains fresh and atomically install a leg-local anchor with the replacement target and side. The original encounter stop anchor shall not be reused as the fence origin for later legs.

**Reason:** v4.6.68 selected one valid second leg after settlement, but the rotated replacement side was applied to the first encounter's stop anchor. The stationary Condor immediately appeared 1.32 m across the fence and failed before movement.


## D-0021 — v4.7.1 Observation and Job Episode Identity Gate

**Status:** Accepted implementation sequencing under canonical v4.6.78 architecture.

**Decision:** v4.7.1 implements only stable assembly/component identity, immutable raw Observation publication and canonical Job Episode admission/termination evidence. It does not combine the subsequent Knowledge/Decision stage for implementation convenience.

**Reason:** the accepted v4.7.x sequence protects the Observation → Knowledge abstraction boundary and allows all episode rules to be disproved offline before Situation Assessment exists.

**Consequence:** no live GIANTS hook, Operational Picture, Candidate Action, Decision or Control path is introduced in v4.7.1.


## D-0022 — v4.7.3 Deterministic Decision Boundary Gate

**Status:** Accepted implementation sequencing under canonical v4.6.78 architecture.

**Decision:** v4.7.3 implements only the complete supportable Candidate Action inventory, explicit mandatory Constraint Verdict Sets and deterministic Decision Records from sealed Operational Pictures. Decision may describe but shall not execute Commitment action.

**Reason:** this preserves Candidate generation, constraint enforcement, Decision, Commitment and Control as separate responsibilities and allows mandatory-gate failures to be disproved offline before replay or live integration.

**Consequence:** no live GIANTS hook, replay authority, Commitment mutation, Control admission or physical capability is introduced in v4.7.3.
