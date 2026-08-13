# 2026-08-13 — D-0147 Bounded Terminal Egress architecture closure

**Observe:** canonical v4.7.109 closed the three-worker Cooperative Passage fixing cycle, but end-of-job evidence showed a different residual problem: GIANTS may finish a worker in a position that is perfectly acceptable for that worker yet deterministically obstructs another still-active worker. In the two-sprayer TS015 case the first finisher can block the other's final metres; with S 416, Condor and Patriot may both finish harmlessly until S 416's remaining work later reaches one of them.

**Discuss:** a general answer to “where should the completed worker park?” immediately recreates Refuge/King-style region search, future-demand modelling and route planning. The project instead separated ordinary GIANTS completion acceptance from the exceptional case of positively obstructive Terminal Occupancy.

**Capability proof:** disposable v4.7.110 demonstrated clean post-job movement after the original Job Episode was authoritatively `ENDED`: 5 m at 3 km/h completed without AI-job restart. A later Player Claim test using `vehicle:getIsEntered()` recorded 204 direct drive calls at claim and 204 at termination, proving zero further OuttaMyWay drive calls after player entry. Earlier disposable revisions failed only in probe plumbing (transient completion re-proof and Assembly-ID/reference-key mismatch), not in the actuation hypothesis.

**AI-intent observation:** disposable v4.7.111 showed materialised `FieldCourseSettings` directly expose `workHeadlands` and `headlandsFirst`; however a normally started default job can leave the settings object nil throughout observation. These settings are therefore opportunistic positive evidence only. Absence means unknown. This establishes Zero-Configuration Compatibility as a requirement.

**Decision — D-0147:** retain GIANTS completion disposition unless realised Terminal Occupancy positively obstructs continuing demand. If the user enables Automatic Terminal Egress, compact the completed unclaimed assembly to its minimum supported transit footprint; if still obstructive, allow one simple continuous bounded outward manoeuvre toward the locally nearest Field Boundary. The direction is boundary-relative, not always forward. Failure/exhaustion transfers responsibility to the player and must not open a broader destination/search problem.

**Rejected direction:** Terminal Clearance Region optimisation, field-centre parking, alternate-boundary search, repeated manoeuvre escalation and global relocation of several completed assemblies. These would recreate the retired King/continuous Refuge problem at a different lifecycle point.

**Record:** v4.7.112 is architecture/documentation only. Disposable probe code is not production lineage. Reality remains the gate before any implementation is promoted.

---

# 2026-08-13 — v4.7.108 clean live validation closes corrective cycle

**Observation:** final three-worker validation produced five D-0146 Cooperative Passage settlements at `SUCCEEDED`, 25/25 Passage Guide gates reached, zero Passage Reassessment, zero safe-abandon escalation and no OuttaMyWay Lua error stack.

**Interpretation:** Settled Relationship Dissolution removed the aggressive transitional release defect without destabilising existing Condor/Patriot/S 416 passage behaviour.

**Decision:** preserve the tested behaviour and move to a release/provenance-only v4.7.109 canonical candidate.

---

# 2026-08-13 — v4.7.107 live discovery: Settled Relationship Dissolution

**Observation:** v4.7.107 produced an excellent three-worker run: five D-0146 passages settled successfully and both Condor and Patriot completed their Job Episodes. Resolution-Space Conservation worked, but four Regulation releases used `D0146_POSITIVE_STABLE_TRAJECTORY_RELATIONSHIP_DISSOLUTION` while the manoeuvring participant was still reported by GIANTS as `TURN_SEGMENT`, `TURNING`, `intentValid=false`. Several releases were followed quickly by reacquisition of essentially the same obligation.

**Discovery — Settled Relationship Dissolution.** The trajectory model may legitimately accept a new direction before the native manoeuvre has settled. Therefore accepted non-opposed trajectory state is not by itself positive relationship invalidation.

**Implementation correction:** preserve the Regulation until Situation sees positive settled continuation from both participants (`SETTLED_CONTINUATION`, valid intent, `NON_TURN_LINE_ACTIVE` productive evidence), or until a stronger independent dissolution witness such as actual post-passage ordering exists. Control remains ignorant of turn/productive internals.

**Stopping discipline:** this correction is intentionally the final planned fixing build. A clean live result should be canonicalised before optional enhancements are considered.

---

# 2026-08-13 — v4.7.106 live discovery: Resolution-Space Obligation Persistence

**Observation:** v4.7.106 successfully regulated Patriot while Condor's Current Excursion initially consumed passage-development space. At 07:15:13.558 the lease was released when Condor temporarily reversed/non-closed during its boundary manoeuvre. Patriot returned to native working speed; Regulation had to be reacquired later at materially smaller separation. A later release also occurred while the pair still remained Potential with strongly opposed Established Trajectories and positive supported corridor overlap.

**Discovery — Resolution-Space Obligation Persistence.** The Current Excursion is evidence that can create the Resolution-Space Conservation obligation; it is not the obligation's lifetime. Once admitted, temporary reverse/non-closing or loss of the initiating witness does not positively prove the Passage problem has disappeared.

**Implementation hypothesis:** Situation should publish positive relationship invalidation. Control should maintain the existing Regulation while dissolution is unresolved, and release only when that positive semantic evidence exists or Step 2 succeeds it. This protects abstraction levels: no headland prediction and no Current Motion interpretation in Control.

**Repository pre-flight:** the existing structural contract explicitly forbids `currentExcursion` interpretation in `LiveControlDispatcher`. The first implementation sketch violated that boundary; pre-flight caught it before packaging. The correction moves transient-vs-positive-dissolution interpretation into `TrajectoryConflictAssessment` and leaves Control consuming sealed Situation semantics.

---

# 2026-08-13 — v4.7.105 live discovery: Excursion-to-Conflict Action-Space Loss

**Observation:** the v4.7.105 three-worker run produced no false open-field follower Regulations, two successful S 416/sprayer passages and one successful Condor/Patriot passage. The final Condor/Patriot encounter nevertheless ended head-on. At 06:17:35.872 Condor was already in Current Excursion while the pair still had roughly the Local Passage entry reserve. At 06:17:44.373 Condor's current physical motion was almost exactly opposite its persisted Established Trajectory. Trajectory supersession occurred at 06:17:45.879 only after about 4.2 m of sustained contradictory motion, at which point `ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT` appeared with positive corridor overlap and 10.84 m/s closing, but usable passage-development space had largely gone.

**Discovery — Excursion-to-Conflict Action-Space Loss.** Trajectory Persistence is correct and should not be weakened merely to force earlier conflict establishment. The missing executable part of D-0146 is its existing Potential-conflict rule: Observe, and Regulate where Action Space is being consumed.

**Hypothesis:** while one Current Excursion remains unresolved, positive current physical corridor support and closing against a stable approaching participant can justify bounded Resolution-Space Conservation Regulation of the stable participant inside the existing Local Passage envelope. The excursion participant remains GIANTS-native so the relationship can either dissolve or mature naturally.

**Implementation:** v4.7.106 makes that Potential witness executable through the normal Candidate → Representation Fitness → Constraints → Decision → Commitment → Authority → Control chain, using the same D-0146 governing requirement as later Step 2. Same-Commitment passage succession and immediate purpose-dissolution release are regression-tested.

**Repository pre-flight finding:** the first offline integrated Candidate test correctly failed because the physical Regulation Candidate lacked purpose-specific Representation Fitness. The repository's existing D-0141 pattern supplied the correct contract; the Candidate was fixed rather than weakening the Constraint evaluator. This is the intended repository-first discipline following the preventable v4.7.104 sealed-collection traversal error.

**Parked refinement — Unilateral Passage Execution:** D-0146 permits only one participant to compact/move. v4.7.105 S 416 evidence showed nearly zero lateral burden can be sufficient after sprayer compaction. The current successful joint Guide execution is retained for now; no additional authority-composition complexity is introduced without a failure requiring it.

---

# v4.7.105 live discovery — Sealed Candidate Collection Traversal

**Observation:** v4.7.104 Step 1 and Local Passage Planning succeeded for Patriot/S416. At 05:57:03.579 the planner published `D0146_PASSAGE_SUPPORTED` at 79.81 m; Candidate constraints passed and Commitment CM-00001 was created. Control immediately rejected it with `D0146_PASSAGE_CONFIGURATION_PARTICIPANT_MISSING:AS-00002`, then repeated the rejection on fresh Commitments.

**Discovery — Sealed Candidate Collection Traversal:** Candidate-owned Step-2 nested collections are immutable ValueRecord proxies by the time they reach Control. GIANTS does not reliably traverse these proxies with native Lua `ipairs`; the repository contract requires `ValueRecord.ipairs`. The v4.7.104 optional-configuration implementation violated that existing implementation contract at the Candidate → Control bridge.

**Decision:** implementation correction only. Use the GIANTS-safe ValueRecord traversal accessor for all Control array traversal so both sealed Candidate collections and ordinary Control-owned arrays have one traversal discipline.

# v4.7.105 live discovery — Optional Configuration Reduction

**Observation:** in the v4.7.103 three-worker run, Patriot 4450 / S 416 was admitted into D-0146 Step 2 and both participants were held in `COMPACTING`. Runtime fold evidence for S 416 reported a foldable surface but no meaningful reducible passage configuration.

**Disproved hypothesis:** exposing GIANTS fold mechanics is sufficient evidence that an assembly can and should enter Compact Configuration.

**Discovery — Fold Interface ≠ Compact Configuration.** Configuration reduction is a passage-expression choice, not a universal precondition. D-0146 already defines it as optional; v4.7.103 had allowed a proven sprayer implementation sequence to overrule that architecture.

**Implementation response:** Candidate expresses `COMPACT_REQUIRED` or `RETAIN_CURRENT` per participant from current positive represented lateral reserve. Control executes and selectively restores only required changes. This introduces no vehicle-name exception and no new architectural decision.

**Validation hypothesis:** Patriot/S 416 should progress as compact Patriot / retain S 416; Condor/Patriot should preserve the proven compact-both expression.

---

# 2026-08-13 — Three-worker Reality closes remaining Step-2 specialisations

**Baseline:** owner-declared canonical v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`).

**Observation:** with Condor, Patriot and S 416 active, Step 1 positively established a Condor/S 416 opposed-corridor conflict roughly a minute before the eventual collision. Step 2 did not act because its purpose-specific mechanical fitness admitted only the named Condor/Patriot pair. Separate D-0141 follower leases remained active in open field after their original ordering purpose had become obsolete.

**Discovery — Vehicle-Name Mechanical Gate Exhausted.** Vehicle identity was a justified initial empirical boundary for the first Step-2 live expression, but it is not passage capability authority. D-0146 Passage Presumption requires incapability to be discovered from current Reality. v4.7.103 therefore removes vehicle-name admission while retaining Control mechanical preflight.

**Discovery — Third-Party Local Spatial Constraint.** Cooperative Passage remains a pairwise arrangement, but another active Operation assembly is part of Local Passage Space Reality. Its positive current physical occupancy constrains admissible pair arrangements and ongoing Passage Support. It does not become a hidden third participant in the pair Commitment.

**Discovery — Stale Follower Purpose.** Positive D-0146 relationship evidence is stronger than historical D-0130 lease retention. An existing D-0141 follower purpose is retired when the pair has positively succeeded into Established Opposed Corridor Conflict or when established trajectories positively show they have passed.

**Implementation decision:** targeted authority correction only. Keep proven Hold/compact/Reposition/restore mechanics and retain D-0143/TS015 as regression/mechanical donor; remove/demote pair-name policy, pair-isolated Local Passage Space, and stale follower-purpose persistence.

**Validation hypothesis for v4.7.103:** three-worker Reality should now either find a supported pair passage that respects the third assembly, or fail safely via Passage Reassessment; the Condor/S 416 conflict must not be rejected solely because of vehicle names, and obsolete D-0141 open-field regulation should retire promptly.

---

# 2026-08-12 — v4.7.102 Candidate Byte Identity Recovery

**Observation:** the repository owner calculated SHA-256 `5aa39f23e9601cbe3eaef856b70394950fab166e8438c3500f151d7b36008e13` for the supplied v4.7.101 test ZIP, while the producer runtime retained `64f7b4b67f1c7f308cf3241c79678f0a442d7fe7cc5c4e41e111e5c7d82f921`.

**Interpretation:** behavioural success does not cure an ambiguous candidate byte identity. RRS already names cross-platform/cross-producer candidate hash disagreement as a blocking Artifact Determinism Gap.

**Decision:** do not attempt to canonicalise v4.7.101. Produce v4.7.102 afresh from exact owner-declared canonical v4.7.99 through RRS, carrying the validated Step-1/Step-2 implementation unchanged in behaviour and issuing new candidate/evidence fingerprints.

**Record correction:** direct rerun of the Python structural/conformance suite contains 79 tests, all passing; earlier 104/104 reporting was bookkeeping error.

---

# 2026-08-12 — v4.7.101 Step-2 implementation: Semantic Generalisation / Mechanical Boundedness

**Observation:** v4.7.100 live evidence supported the complete Step-1 trajectory/conflict chain and showed that Established conflict became known materially before the old TS015 gate. It also exposed Diagnostic Churn caused by continuously changing numeric values inside transition signatures.

**Decision already architectural:** proceed directly to D-0146 Step 2 as one coherent active build; do not create another passive staircase.

**Implementation discovery — Semantic Generalisation / Mechanical Boundedness:** D-0146 semantic authority can move to Established Conflict -> Local Passage Search -> Passage Arrangement/Guide without pretending that the current physical Representation has generic vehicle/negative-clearance authority. The P23 Condor/Patriot mechanics therefore remain a purpose-specific actuator profile while the old TS015 solution-shaped admission is removed from the live path.

**Implementation:** added Candidate-owned Progressive Passage Search with symmetric/asymmetric/unilateral burden splits and a five-gate guide; wired it through normal Decision/Commitment/Authority; Control executes only supplied gates and treats support loss as explicit Passage Reassessment. Corrected Diagnostic Churn separately inside the same build.

**Validation:** 204/204 Lua behavioural tests and 79/79 structural/conformance tests pass before packaging. Live GIANTS evidence remains final authority.

---

# 2026-08-12 — v4.7.100 D-0146 Step-1 implementation record

**Fact:** D-0146 Step-1 architecture was already concluded before this build. This tranche is implementation and test work, not architectural discovery.

**Implementation:** persistent trajectory state is owned by Situation Assessment. It uses current physical travel vectors and accumulated travelled distance to form/reinforce an Established Trajectory. A materially disagreeing Current Excursion is retained separately and supersedes the trajectory only after sustained coherent contradictory travel.

**Implementation:** pair classification uses established trajectory relation, current mutual-facing geometry, current closing/stability and positive Supported Corridor Overlap derived from already-cached positive plan-view DISC primitives. It does not predict a future route. Productive/Transitional/TURN_SEGMENT is published only as context.

**Implementation boundary:** Step-1 Knowledge is passive. Candidate, the existing TS015 Cooperative Passage assessment, Decision, Commitment and Control do not consume it. This protects the live-proven behaviour while evidence is gathered.

**Test-discovered correction:** geometry helpers initially allowed absent corridor anchors/poses to fall back to `(0,0)`. That could manufacture support. The implementation now fails closed when those facts are unavailable. Sustained supersession also explicitly makes the new trajectory current rather than leaving it marked as an excursion.

**Validation:** direct tests cover trajectory formation, Current Excursion persistence, supersession, Potential/Established maturation, any-positive-overlap semantics, absence of positive overlap, and missing-anchor fail-closed behaviour. Offline result: 201 Lua PASS; 78 Python structural/conformance PASS.

**Next evidence:** live `TRAJECTORY` and `OPPOSED_CORRIDOR` transition logs. Calibration values should be adjusted only in response to observed false formation, false persistence, or missed/late maturation; such adjustment is implementation calibration, not architecture revision unless Reality contradicts the concepts themselves.

---

# 2026-08-12 — D-0146 trajectory/opposed-corridor and local-passage architecture

**Observation:** after successful bounded Cooperative Passage, the remaining hedge-adjacent encounter showed that GIANTS `TURN_SEGMENT` can describe a local detour while the broader spatial interaction remains intelligible. Earlier Regulation opportunities also existed while Condor reversed and then resumed northbound work.

**Discovery — Established Trajectory / Current Excursion:** useful motion history should persist through short-lived deviations without becoming route prediction. Sustained contradictory motion supersedes it.

**Discovery — Opposed Corridor Conflict:** Step 1 should classify substantially opposed, closing, persistent trajectory-demand overlap directly. Exact centre-lines and Productive-only admission are unnecessary abstractions. Any positive supported corridor overlap is overlap.

**Discovery — Passage Presumption:** Step 2 need not prove a vehicle class is passage-capable before looking. Assume local passage until terrain/spatial/kinematic constraint disproves it. Configuration reduction is optional and burden may be unilateral.

**Discovery — Boundary Encroachment:** immediate margin may participate in local passage while the complete assembly remains boundary-straddling; wholly extra-field relocation is a different responsibility.

**Discovery — Pairwise Passage Economy / Passage Sufficiency:** choose a sufficient locally supported arrangement with least combined necessary intervention; do not solve global optimum or impose symmetry.

**Discovery — Passage Development / Sweep:** long combinations and short nose-to-nose distance make transition sweep/development room part of passage validity. Nominal inter-assembly clearance must survive the manoeuvre, not just endpoint placement.

**Discovery — Passage Guide:** architecture should permit several virtual pins/gates and smooth development rather than prescribe a three-leg sidestep. Historical Forward-Only Waypoint Orbit remains a warning against arbitrary point targeting.

**Decision — Passage Reassessment:** a committed passage must retain positive support. Support loss triggers reassessment from current Reality, not blind continuation or automatic player escalation.

**Implementation status:** none of these generalisations are implemented in v4.7.99. Runtime remains the live-proven bounded v4.7.98 behaviour. This separation is intentional.

---

# 2026-08-12 — D-0144 Progressive Situational Sufficiency after first production Cooperative Passage success

**Observation:** v4.7.96 reached the intended TS015 approach but did not trigger because the new Candidate leaked an unrelated generic scalar Representation Fitness requirement. v4.7.97 repaired that coupling by consuming purpose-specific fitness from existing bootstrap-cached `physicalSpaceEvidence`; no new shape calculation was introduced.

**Live validation:** v4.7.97 then completed two automatic Cooperative Passages through the real production chain. The passages began at approximately 68.49 m and 69.93 m, all mandatory constraints passed, the same Job Episodes survived, and handoff released immediately with no cooldown. D-0141 follower Regulation was also active and later superseded by Cooperative Passage.

**Discovery — Progressive Situational Sufficiency:** TS015 success did not require detailed future-route modelling. The useful pattern was Observe while uncertainty is harmless; Regulate when following threatens to consume Action Space; reassess as GIANTS reveals current behaviour; Reposition cooperatively once an opposed conflict is positively supportable.

**Decision:** retain Productive/Transitional current state and optional Turning Rank awareness, but retire Rook/Successor-Rook governing prediction, chessboard colouring and continuous Productive History reasoning. King/Refuge/headland-U-turn-specific solving remain retired.

**Implementation alignment:** preserve v4.7.97 physical/traffic behaviour and unsource only the historical Demonstrated Productive Coverage, Productive Coverage Residual and Refuge Qualification Shadow live diagnostic pipelines. Keep their files as evidence donors.

**Unresolved, deliberately celebrated rather than hidden:** the final v4.7.97 convergence appeared physically close to the proven near-collinear geometry but one participant remained Transitional/`TURN_SEGMENT`, so Cooperative Passage was withheld. That is useful evidence for the current authority boundary. It is not a failed Cooperative Passage and is not permission to relabel Transitional as Productive.

**Health warning:** current success is bounded to TS015 Condor/Patriot near-collinear Productive/Productive. General passage, asymmetry, other assemblies, generic negative clearance and wider regression coverage remain incomplete.

# 2026-08-12 — v4.7.97 Generic Representation Gate Leakage repair

## Observation

The first v4.7.96 production TS015 run reached the expected near-collinear opposed Condor/Patriot geometry but Cooperative Passage did not dispatch. The live assembly diagnostics simultaneously showed populated configuration-filtered plan-view footprints from `AssemblyRepresentationCache` while the older scalar `live-representation:<worker>` records remained `STRUCTURALLY_INVALID`.

## Interpretation

The D-0143 Situation decision was being coupled to the wrong Representation Fitness question. The Candidate asked the generic scalar current-conflict representation to authorise a narrow empirically bounded Cooperative Passage action even though the replacement core already held the relevant current footprint/configuration evidence in Situation Assessment. This is implementation coupling drift, not a failure of D-0143 or of the physical Cooperative Passage capability.

## Implementation correction

Situation Assessment now reuses `physicalSpaceEvidence` already derived from the bootstrap/job-scoped `AssemblyRepresentationCache`. It performs no new shape calculation. For a supported TS015 encounter it publishes two purpose-specific fitness records scoped to `D0143_TS015_COOPERATIVE_PASSAGE_EMPIRICAL_ADMISSIBILITY`; the Candidate requires those records. Missing cached footprint evidence remains fail-closed. Generic scalar representation records are neither weakened nor relabelled.

## Validation objective

The next live run must show, in order, `COOPERATIVE_ASSESSMENT_SUPPORTED`, `COOPERATIVE_CANDIDATE_PUBLISHED`, a passing `COOPERATIVE_CONSTRAINT_VERDICT`, and then the existing `CONTROL-DISPATCH COOPERATIVE_ACCEPTED` marker. The physical manoeuvre itself is unchanged.

---

# 2026-08-12 — v4.7.96 first TS015 Cooperative Passage production vertical slice

## Observe

Canonical v4.7.95 / D-0143 established Cooperative Passage as the immediate production direction and retired King Reserve / continuous Refuge discovery. P23 had already demonstrated repeated Condor/Patriot near-collinear passage, same-Job restoration and immediate reuse, while the final asymmetric event established a scope boundary. The remaining task was production coupling, not further prototype discovery.

## Decision

Implement the smallest D-0143 vertical slice for TS015 only. Situation Assessment must own admissibility; Candidate/Decision/Commitment/Authority must remain real production owners; Control may reuse proven physical donors but may not select the manoeuvre. Unsupported geometry is withheld. No new architecture is introduced.

## Implement

- Added `CooperativePassageAssessment` and published its Knowledge through `OperationalPicture`.
- Reworked live candidate support so supported TS015 Knowledge creates one joint multi-assembly `REPOSITION`, rather than the old unilateral head-on/P22 Refuge bridge.
- Added same-picture preference-band exhaustion evidence for Observation, Regulation and in-path Hold.
- Extended Commitment lifecycle and dispatcher for one joint purpose, two progress authorities, same-Commitment D-0141 strategy succession, and immediate positive settlement after restoration/handoff.
- Added production `CooperativePassageControl`, sharing the existing P22 permission/drive/configuration donor surfaces. The proven physical sequence is retained under bounded TS015 calibration.
- Added one-time local field-containment preflight for scripted target centres. This is not continuous clearance proving and does not create generic negative-clearance authority.
- Disabled the old P22 TS015 unilateral relocation and Refuge qualification shadow probe for this objective. P23 is not sourced.
- Failure remains fail-closed: clear drive, Hold both, attempt restoration, no blind release.

## Validate

Offline validation before packaging:

- Python structural/conformance: **76/76 PASS**.
- Lua behavioural: **196/196 PASS**.
- active non-archive Lua syntax parse: **102/102 PASS**.

Live validation is intentionally still open. The next test must show that production Situation/Decision/Commitment/Control activates automatically for the supported TS015 encounter, executes Cooperative Passage, hands both workers back to GIANTS, and remains available for a later fresh encounter without P23 arming or a cooldown.

## Record

No new discovery is claimed. v4.7.96 is implementation of canonical D-0143. The current numeric gates remain bounded calibration and the asymmetric case remains outside scope.

---

## 2026-08-12 — P23 Cooperative Passage closure / D-0143 evidence

### Problem reset

After post-canonical King implementation work produced persistent live stutter, the head-on question was reset to the minimum physical requirement. A pure established head-on cannot be resolved by Regulation or in-path Hold alone: those actions change timing but do not create passing space. Reposition remains necessary. The new hypothesis was to treat both participants as capable of diversion rather than continuously discovering a Refuge for one.

### Configuration-Released Space

Comparable overhead screenshots of Condor Endurance II and Patriot 4450 showed that their deployed ~36 m sprayer configurations occupy a very large lateral working envelope while folded assemblies are much narrower laterally. This corrected an earlier over-conservative reading of maximum plan-view spans, which include substantial longitudinal extent. The hypothesis became: compact both workers and use the lateral capacity released inside the immediate productive corridor for a two-way passage.

Named discovery: **Configuration-Released Space** — configuration reduction can create usable local resolution capacity without searching surrounding Field World for an arbitrary waiting Refuge.

### P23 v4.7.91 — Forward-Only Waypoint Orbit

The first PoC held and fully compacted both workers but failed on the first `4 m forward + 6 m lateral` point-target leg. Both forward-only controllers orbited their nearby high-lateral-offset waypoint instead of capturing it. This was a Control failure before Cooperative Passage itself was tested.

Named implementation finding: **Forward-Only Waypoint Orbit**.

### P23 v4.7.92 — first successful Cooperative Passage

Changing only the entry/rejoin geometry to a shallower `12 m forward + 6 m lateral` leg allowed both compact sprayers to establish opposite lateral paths, pass concurrently forward, rejoin, restore and hand back to GIANTS. Both original Job Episodes survived and native productive continuation resumed.

Named architectural candidate: **Cooperative Passage**.

### P23 v4.7.93 — repeatability and observer lockout

Two passages completed in one uninterrupted working session with closely matching physical results. The run also exposed that the 120-second post-handoff native-observation fixture occupied the same run slot as active Control and blocked a later necessary passage. The observation duration had evidence value only; it was not a physical cooldown.

Named implementation finding: **Post-Handoff Observation Lockout**. Passive observation must not own Commitment/Control or reserve the Traffic Policeman.

### P23 v4.7.94 — armed closure run

Persistent arming removed human console timing. The first automatic passage started at 68.07 m with heading dot -1.0000. It completed to handoff in 63.403 s; maximum measured lateral displacement was about 6.02/6.01 m, closest centre separation was 12.02 m, both workers restored with the same Job Episodes, and native Productive motion resumed within 0.515 s.

The second automatic passage started at 69.64 m with heading dot -1.0000 and completed to handoff in 63.246 s. Maximum lateral displacement was about 6.03/6.01 m and closest centre separation was again 12.02 m. Native Productive motion resumed within 0.524 s.

Before the second post-handoff observation completed, a third necessary Commitment superseded it at 106.540 s with no authority retained by the observer. This validated that observation and Control lifecycles can be separated.

The final opposed encounter started automatically at 68.83 m with heading dot -0.9935. It was materially asymmetric. Hold, compaction and sidestep completed, but the fixed passage geometry reached only about 10.2 m centre separation and stalled from insufficient lateral clearance. This is negative boundary evidence for the first authority envelope, not a request to extend the PoC.

### Architectural disposition

- P23 is complete and remains evidence/physical-donor lineage only.
- King Reserve Availability, continuous Refuge discovery and the ordinary King `A→R→A` head-on lifecycle are retired from the governing production direction.
- Configuration-Released Space and Cooperative Passage are accepted for a narrow first production target.
- The next objective is production TS015 integration, not another prototype or broad generalisation.

Evidence sources: `Screenshot_20260812_090757.png`, `Screenshot_20260812_090852.png`, P23 v4.7.91-v4.7.94 test packages, `log(20260812-102055).txt`, `log(20260812-112003).txt`, and corresponding owner video observations.

---

## 2026-08-10 — v4.7.76 canonical-candidate closure after complete v4.7.75 TS015 working session

**Observe:** the v4.7.75 integrated run completed the repeated head-on/follower/refuge/recovery sequence and both GIANTS jobs ultimately ended after completing work. Three autonomous Refuge moves were initiated. The final role-reversed head-on exercised same-Commitment authority reuse (`reusedAuthorityTokens=1`) and no longer failed with `YIELD_PROGRESS_AUTHORITY_ALREADY_OWNED`.

**Qualification:** after Patriot completed, the owner manually moved the completed Patriot assembly so Condor could consume the final few metres. This is retained as terminal/post-completion physical-occupancy debt.

**Decision:** draw the implementation line. Freeze v4.7.75 behaviour, package it as v4.7.76 canonical candidate, and park remaining implementation issues rather than continuing the fix/test cycle. No new architectural concept is introduced.

**Candidate preparation:** build identity/documentation/provenance only; no traffic, Regulation, Refuge, Commitment or Control behavioural change.

## 2026-08-10 — v4.7.75: same-Commitment Yield authority succession repair

**Observe:** v4.7.74 completed the first and second encounters, but the final role-reversed head-on repeatedly selected REPOSITION and then failed with `YIELD_PROGRESS_AUTHORITY_ALREADY_OWNED`.

**Implement:** distinguish ownership by another Commitment from ownership already held by the same unresolved Commitment. Reuse the latter AuthorityToken for the selected Yield/Reposition assembly, clear only its D-0141 physical speed lease after the head-on revision, and settle the superseded follower obligation.

**Validate:** an end-to-end role-reversed Lua regression now exercises Regulation -> positive head-on REVISE -> same-token reuse -> follower lease clearance -> accepted REPOSITION. Live success is intended to close this implementation tranche and trigger canonical-candidate preparation.

## 2026-08-10 — v4.7.74: head-on succession Candidate-ordering repair

**Observation:** v4.7.73 improved Regulation but Condor never attempted the second Refuge.

**Evidence:** at the second opposed encounter Future-Space intersection and clean opposed headings were positive, while D-0141 reported `ESTABLISHED_PURPOSE_PRESERVED_THROUGH_OPPOSED_CONTINUATION`. Candidate support selected only the follower `CONTINUE_OBSERVATION` path, so head-on `REPOSITION` was never published.

**Implementation:** retain the existing speed lease, but evaluate a positive matching autonomous head-on before publishing follower PRESERVE. Positive follower retirement and Guarded Recovery remain higher-priority special lifecycle states.

**Validation intent:** regression test requires positive matching head-on to select REPOSITION/REVISE while lease-retention behaviour remains covered independently.

## 2026-08-10 — v4.7.73: second-encounter passage repair

Observed v4.7.72: D-0141 cap tracked Condor down to ~3.6 km/h, then released at `headingDot=-1`; head-on Reposition began 251 ms later and Patriot accelerated to ~24 km/h while Condor was still in outbound egress. Repair: reapply the existing 0.90 clearance margin only after Regulation is already required, and preserve the admitted lease through clean opposed strategy succession until Progress Passage.

## 2026-08-10 — v4.7.72: D-0141 follower implementation repair

**Observe:** v4.7.71 actively regulated Patriot, but an established lease retired when lateral measurements crossed the productive-corridor boundary by millimetres and later preserved a stale ~16.67 km/h cap while Condor's GIANTS native command dropped rapidly to 11.81 then 4 km/h before the turn. The active Runtime loop was still tied to the 1 s passive cadence.

**Implement:** keep strict admission unchanged; add bounded established-purpose retention only; decouple active Runtime/Control to 250 ms; clamp Productive follower magnitude by positive leader native rate; update an existing lease through GIANTS turning from current native/physical transition progress; keep zero/default command unresolved and keep the historical 0.90 factor out of active D-0141.

**Validate:** offline regression covers millimetric retention versus material separation, pre-turn 4 km/h native command, active turn progression, positive reverse, Progress Passage retirement, elastic cap updates, remote-negative admission and central authority boundaries. Next live run is the same natural second-encounter sequence.

## 2026-08-10 — v4.7.69: Refuge Passage Purpose Succession

**Observe:** v4.7.68 kept Patriot under the pre-Refuge follower-compression cap after Condor was compact and Held at Refuge. Recovery required Patriot to pass, so the old Control delayed the clearing event.

**Discuss:** approximately 10 km/h can remain acceptable inside a genuine moving leader/follower relationship. The fault is not primarily numeric; it is the authority lifecycle after Refuge establishment.

**Hypothesise:** once Yield is positively established in compact Refuge hold for a named Progress participant, the old boundary-transition clearance purpose has been superseded by Progress Passage.

**Implement:** v4.7.69 exposes a bounded Progress Passage context from P22 and wires it explicitly into follower-compression. The matching old-purpose lease is retired and re-admission suppressed while the hold persists. No replacement speed is commanded.

**Validate:** structural regression plus live target: purpose-succession and release logs at Refuge establishment; GIANTS-native Progress speed absent an independent lease; no same-pair re-admission until hold exit.

**Grouped housekeeping:** the standalone Lua harness still referenced the removed D-0137 probe. It now loads/tests D-0138, allowing the full offline Lua harness to execute again.

**Record:** name the failure **Resolution Dependency Inversion** and the correction **Refuge Passage Purpose Succession**.

## 2026-08-10 — v4.7.68: D-0138 command surface validated; D-0136 representation seam repaired

**Observe:** v4.7.67 showed `spec_aiFieldWorker.aiDriveParams` changing coherently through Productive, turning, reverse and blocked states. The same run exercised D-0136 peer visibility (`compared=1`) but both settlement Future-Space inputs returned `WORKER_NOT_ACTIVE`.

**Interpret:** D-0138 is supported only as an **Immediate Native Drive Command Surface**. The current target did not distinguish the successful second Refuge from the recurring bad fixture, so **Immediate Command != Continuation Horizon**. The D-0136 failure was separate implementation debt: persistent tracks express current activity as `track.active`, while `FieldBoundedFutureSpace` consumes observation workers using `activeObserved`.

**Implement:** v4.7.68 adds a transient adapter inside the passive D-0136 settlement reassessment. It maps current persistent-track activity and existing Local Intent / Field World / pose / Physical Representation into the existing Future-Space input contract. Neither representation is broadened or mutated.

**Validate:** the next natural D-0136 settlement must stop reporting `WORKER_NOT_ACTIVE` for an active track. A `TURNING` settling worker may correctly remain unresolved because manoeuvre sweep is not yet represented. No Refuge or Control policy changes are part of this increment.

## 2026-08-10 — v4.7.63: productive-history chessboard becomes a passive Refuge evidence probe

**Observation:** after v4.7.62 successfully protected Condor's compressed egress, the selected second Refuge itself became the blockage. Both fixture candidates were inside boundary-adjacent/headland space. The operator proposed preferring space the Progress worker had already productively vacated and described a chessboard model: productive workers progressively paint completed squares while their current continuation scans forward.

**Interpretation:** the useful architectural distinction is past positive Productive history versus current supported Future Space. A painted region can support the claim that productive demand has receded there, but does not prove the worker will not traverse it during a later transition.

**Implementation:** added `DemonstratedProductiveCoverageProbe` using live AI/work-area marker segments rather than tractor-centre position. Consecutive positive-Productive samples sweep a coarse 5 m grid; any transition/unresolved interval breaks continuity. Added `RefugeQualificationShadowProbe`, which leaves live selection untouched and reports fixture plus infield candidates against Field fit, Future Space, demonstrated boundary-entry demand and productive coverage.

**Validation objective:** determine whether already-established Knowledge plus this positive history explains the infield Refuge intuition. Treat failure to distinguish candidates as evidence of a missing representation, not a reason to invent a headland ban.

## 2026-08-10 — D-0131 Committed Transition Protection catch-up

**Observation:** v4.7.59 kept Patriot's maturation Regulation at 18.60 km/h through the second head-on, but Condor's admitted egress did not create a stronger protection lease. D-0129 showed the Progress worker already consuming represented Committed Demand during that transition.

**Interpretation:** lease composition worked; the missing piece was a purpose owner for the newly admitted transition. This is implementation debt against existing Committed Demand / Transition Clearance architecture, not a new playbook.

**Change:** v4.7.60 adds a bounded D-0131 transition-protection bridge. It does not trigger merely because the TS015 egress phase exists. It requires positive Productive Progress, a field-bounded intersection with the represented egress sweep, and a timing witness showing Progress would arrive no later than even ideal max-speed egress completion. The existing 1 km/h test literal is reused and composes with the retained maturation lease.

**Deliberate boundary:** no new numeric policy and no reopening of parked Refuge selection, early-Refuge timing, brute-force remediation, comfort tuning, or the productive/transitional crossing.

## 2026-08-09 — D-0130 Purpose-Preserving Regulation catch-up

**Observation:** D-0129 showed the live follower cap relaxing while a stable purpose-bound witness was being consumed. The surprise head-on then caused the follower Regulation to release solely because the Situation matured into opposed continuation.

**Interpretation:** this is implementation debt against existing sticky-Purpose / Effective Actuation Composition architecture, not evidence for a new traffic concept.

**Change:** v4.7.59 makes same-purpose Regulation tighten-only, preserves the supporting lease through opposed strategy succession, and lets independently justified P22 Regulation leases compose by least-permissive cap. D-0123 can therefore add/remove its existing guarded-recovery restriction without destroying the still-live maturation purpose.

**Deliberate boundary:** no new literals or parked traffic behaviours are addressed. Validate this catch-up before reopening Refuge selection, early first-Refuge timing, speed/distance calibration or the later productive/transitional crossing.

## 2026-08-09 — v4.7.49 certification consolidation after v4.7.48 live PASS

**Observation:** v4.7.48 completed the intended end-to-end refuge/pass/recovery sequence. `CM-00001` was created at the autonomous REPOSITION Decision; Condor physically reached refuge; positive proposed-recovery convergence held Condor while Patriot passed unrestricted; recovery began only after positive clearance; a later Patriot turn converged after recovery was committed and D-0123 Regulation protected the remaining recovery demand; positive same-Job GIANTS reacquisition settled only the recovery obligation.

**Validation:** this confirms the implementation relationship between D-0122 recovery admission and D-0123 Guarded-Recovery protection. It also validates the Candidate–Commitment Authority Contract repair from v4.7.48 in live execution.

**Non-discovery:** no new major architecture is claimed. The live result implements already-settled concepts. The remaining open defects are implementation/architecture boundaries already named: early Encounter Maturation/Commitment Point, production Refuge qualification, temporary speed policy, reverse support, Durable Separation, and later sliding-puzzle encounters.

**Certification decision:** prepare v4.7.49 as a behaviourally unchanged candidate. Numeric mechanism literals remain explicitly temporary; certification must not turn successful test constants into policy.

## 2026-08-09 — v4.7.48 Candidate–Commitment Authority Contract repair

**Observe:** v4.7.47 selected the correct autonomous REPOSITION Candidate but threw `physical selected Candidate requires explicit progress-actuation ownership` before P22 relocation began. Condor therefore never moved to refuge and the native head-on continued.

**Interpretation:** architecture was not disproved. The live Candidate encoded Yield-only movement in Effective Actuation Composition but omitted the separate Commitment-admission ownership declaration required by the enforcing boundary.

**Implement:** autonomous REPOSITION now declares its Yield assembly as sole physical-actuation owner. The Commitment boundary additionally cross-checks that declaration against every `progressActuation=true` assembly in Effective Actuation Composition before admission.

**Validate:** real autonomous Candidate → Decision → Commitment integration now proves an ACTIVE Commitment owns only Yield actuation and leaves Progress GIANTS-owned. A disagreement fixture is rejected before Commitment creation. Existing recovery sequencing and literal authority are unchanged.

**Record:** named implementation finding **Candidate–Commitment Authority Contract Gap**. This is an implementation contract defect, not a new architectural concept.

## 2026-08-09 — v4.7.47 recovery-admission sequencing and Commitment catch-up

**Observe:** v4.7.46 successfully slowed Patriot when D-0123 convergence threatened Condor's active recovery. Condor completed restoration, but the delay allowed it to re-enter the same opposed lane; after vulnerability expiry both workers accelerated into a renewed head-on.

**Discuss:** this does not weaken D-0123. Existing D-0122 already distinguishes *authorising* recovery from *protecting an authorised recovery*. If Patriot's presently revealed continuation already consumes proposed ingress while Condor is safely at refuge, regulating Patriot to make ingress possible is unnecessarily disruptive and produces a poor successor Situation. The lower-authority sequence is refuge wait → Patriot pass → recovery admission.

**Hypothesise:** using the already-validated `COMMITTED_RECOVERY_UNION × CURRENT_HEADING` representation before recovery begins should identify whether recovery is presently supportable. Positive convergence should retain Hold at refuge without regulating Progress; negative convergence should admit Guarded Recovery; unresolved evidence should wait.

**Implement:** v4.7.47 removes the fixed refuge dwell, adds event-driven recovery admission, creates a real Commitment from the autonomous initial REPOSITION Decision, and separates Native Continuation Restoration from the still-open Durable Separation obligation. D-0123 Regulation remains only for convergence arising after recovery begins.

**Literal audit:** egress/rejoin 15 km/h, orientation 5 km/h, and active-recovery Regulation 1 km/h remain temporary TEST MECHANISM values pending live validation. Timeouts are watchdog/failure detection only; the 120 s observation window is forensic only. No elapsed time or fixed speed grants traffic authority.

**Validate:** offline 152 Lua + 58 Python before package finalisation. Live validation remains required.

**Record:** implementation catch-up under existing D-0099/D-0119/D-0122/D-0123; no new root architectural concept introduced.

## 2026-08-09 — D-0123 shadow evidence promoted to bounded Regulation behaviour test

**Observe:** two v4.7.45 shadow runs showed that convergence is not fundamentally a headland-turn event. In the stronger phase-shifted run Patriot had already completed its headland turn and was Productive on the return pass when Condor's recovery began; `VS_COMMITTED_RECOVERY_UNION × CP_CURRENT_HEADING` was positive at long separation and the pair later developed Condor blocked → Patriot blocked → positive Current-Space interaction.

**Discuss:** the useful explanatory rule is “the headlights light the dome”: Traffic Policeman cares where currently revealed native continuation is directed, not whether GIANTS reports `turn=true`. The “dome” is better understood as remaining Guarded-Recovery Committed Demand rather than an invented permanent safety bubble. Observed travel alone is insufficient because it disappears under blockage/Regulation while native intent may remain.

**Hypothesise:** current heading plus positive same-Job continuing-native-intent evidence can support coarse Convergent Projection; remaining known P22 recovery legs plus realised spans can stand in for Vulnerable Space during this fixture. Once positive convergence is established, temporary evidence loss should maintain Regulation rather than create release oscillation.

**Implement:** v4.7.46 adds a separate `GuardedRecoveryRegulationTestBridge` that consumes only `COMMITTED_RECOVERY_UNION__CURRENT_HEADING` and applies the proven P22 speed-ceiling interceptor to the Progress worker at the existing 1 km/h test literal. Shadow diagnostics remain read-only. Production Control stays disabled.

**Validate next:** rerun the previously deadlocking Patriot-first TS015 phase shift. We need to see whether D-0123 APPLY precedes blockage, whether Patriot actually receives/obeys the capped GIANTS drive ceiling, whether Condor completes recovery, and whether release occurs from positive clearance or vulnerability expiry without oscillation.

# 2026-08-09 — v4.7.45 Guarded-Recovery Convergence Shadow Validation

**Observation:** v4.7.44 autonomously resolved the initial TS015 head-on, but did so very early. During the resulting long recovery interval Patriot reached a headland turn while Condor was still recovering/resuming; video showed a near miss before the later complex cross-field blockage.

**Interpretation:** the early intervention is a behavioural defect for eventual production timing but currently creates a useful repeatable experiment for D-0123. The immediate unknown is not whether Traffic Policeman should prefer Regulation after vulnerability convergence—that is already settled—but how Vulnerable Space and Convergent Projection should be represented from positive Reality evidence.

**Hypothesis:** Vulnerable Space may be derivable from OuttaMyWay-owned recovery geometry rather than an invented safety bubble. Three shadow representations are therefore compared: current recovery pose→rejoin target at current realised span; current pose→retained Rejoin Anchor at current span; and a union of remaining known recovery legs using current compact span plus the pre-intervention realised span for restoration near the anchor. Patriot's convergence is shadowed by current heading, observed travel direction, and the union of previous/current revealed headings during turning.

**Implementation:** added `GuardedRecoveryConvergenceProbe.lua` only. It is invoked read-only from P22, begins at rejoin/restore, remains alive across mechanical handback, and terminates on existing positive `NATIVE_CONTINUATION_FIRST` evidence. No Candidate, Decision, Commitment or Control path reads its output. No P22 mechanism is promoted.

**Validation intent:** repeat the same head-on/recovery run and compare `D0123-SHADOW` transition timestamps with video. A disproven shadow hypothesis is a useful result; avoid tuning geometry to force the desired answer.

## 2026-08-09 — Reciprocal head-on PASS and autonomous role-selection implementation

**Observe:** owner live tests of v4.7.43 successfully relocated Patriot as explicit Yield and then Condor as explicit Yield through the same genuine live `REPOSITION` Decision → P22 TS015 execution path. Both completed the tested refuge/rejoin/restoration sequence. The refuge HUD countdown was observed and correctly identified as a fixture dwell, not Safe Release authority.

**Discuss:** repository review corrected an implementation assumption. D-0113 already says Productive/Productive is a preference tie rather than a Decision deadlock. D-0118 already says materially equivalent admissible alternatives may remain architecturally indifferent and use deterministic implementation tie-breaks with no policy meaning. The console role pin was therefore an implementation bridge, not evidence of missing role-arbitration architecture.

**Hypothesis / implement:** v4.7.44 removes the initial-head-on operator pin from the live path. The Productive Continuation probe now exposes only one promoted semantic: `NON_TURN_LINE_ACTIVE` is positive Productive evidence for the same Job Episode; all other probe states remain non-positive and do not infer Transitional Continuation. The live head-on Candidate support requires one active same-Job Encounter, positive field-bounded Future-Space interaction, both `SETTLED_CONTINUATION`, both positively Productive, opposed headings and no already-positive current physical interaction. It publishes both admissible Yield `REPOSITION` candidates at equal comparison cost. D-0118 deterministic tie-breaking therefore carries no semantic priority.

**Actuation boundary:** selection automatically dispatches the previously live-validated P22 TS015 relocation harness. This is intentional implementation staging: role selection is now architectural; Refuge Region qualification and transition clearance remain fixture authority and are not silently promoted. The same Encounter is single-dispatch latched.

**Validate:** replacement-core Lua tests 144/144 PASS; Python structural/conformance tests 55/55 PASS before packaging. Owner live validation remains the authority for behaviour. No RRS/certification request is made.

**Record:** suppress the refuge dwell countdown wording in the temporary HUD; display `TEST FIXTURE DWELL — no release authority` instead. Guarded-Recovery Vulnerable Space / Convergent Projection construction remains unresolved and unchanged.

## 2026-08-09 — Implementation catch-up, Probe Debt and the initial head-on vertical slice

**Observe:** v4.7.42 implemented canonical D-0115 sequential Traffic Policeman Decision ordering inside the real `DecisionSelector`, but owner live testing showed no observable head-on change. The result was expected once the runtime path was inspected: live Candidate support still published only `CONTINUE_OBSERVATION`, so the new policy had no Regulation/Hold/Reposition alternative to select. A separate off-field Condor run was traced to the operator using GIANTS `Start Job` rather than the usual in-cab `Start Worker`; the normal-workflow rerun removed that confounder.

**Discuss:** the project has accumulated enough probes that continued passive discovery risks **Probe Debt**—validated Reality evidence that never reaches production behaviour. Architecture already settles the pure established head-on preference-band result: Regulation cannot create passing space and an in-path Hold becomes Static Obstacle Conversion, so Reposition is required. What remains unresolved is the Productive/Productive role tie and production Refuge Region qualification. Those unresolved parts must not be guessed merely to make code move.

**Hypothesis / implement:** v4.7.43 introduces a test-only vertical bridge. `otmP22 resolveheadon <vehicle>` explicitly pins the TS015 fixture participant, but physical actuation still waits for the real live Situation Assessment / Candidate / Constraint / Decision chain to support the same Job Episodes, active settled head-on Future-Space Encounter and select `REPOSITION` under D-0115 same-picture exhaustion evidence. Only then is the already-proven P22 TS015 relocation actuator dispatched. Production role/refuge/Safe-Release authority and `CONTROL_AUTHORITY_ENABLED` remain unchanged.

**Validate:** offline tests prove fail-closed boundaries and Decision composition only. Owner live testing is mandatory and precedes any RRS/certification request. The expected visible result is now a real behavioural difference: after explicit arming near the initial head-on, one fixture participant should execute the established TS015 egress/rejoin sequence instead of both continuing into collision.

**Record:** no new architecture is claimed. This is implementation catching up with D-0115 while deliberately keeping unresolved D-0123 representation work unresolved.

## 2026-08-08 — Guarded Recovery Observe exhaustion: Vulnerable Space and Convergent Projection

**Observe:** bird's-eye review of the Patriot recovery deadlock made the loss of Action Space visible before exact conflict. Once Condor turned generally toward recovering Patriot, it was already reasonable to expect that further unrestricted continuation could consume the recovery margin. The same Condor/Patriot pair can ordinarily pass in adjacent lanes, so a permanent enlarged exclusion region would be over-conservative.

**Discuss:** Guarded Recovery already supplies locality because both participants are in one unresolved Encounter after a Refuge Region manoeuvre. The useful evidence is therefore directional rather than a new fixed-range predictor. The recovering worker is unusually vulnerable only while OuttaMyWay still owns recovery responsibility; once GIANTS fully reacquires native authority, ordinary cooperative tolerance must return even though the wider traffic Commitment may remain open.

**Decision:** accept temporary Vulnerable Space and coarse Convergent Projection. When the other participant's Convergent Projection intersects Vulnerable Space, unrestricted continuation is positively consuming protected recovery Action Space and Observe is exhausted. Traffic Policeman then evaluates Regulation before Hold under the existing preference contract. The heightened vulnerability expires on positive existing Native Handover/restoration evidence of full GIANTS reacquisition; Protected Progress Alternation may later reverse the temporary roles.

**Implementation:** v4.7.41 changes architecture documentation and coherent version identity only. No literal dome/circle/cone, range horizon, TCPA/DCPA, production Situation Assessment trigger, Decision or Control implementation is added. Active stale release/header provenance is corrected to canonical v4.7.40 where appropriate.

**Validate:** RRS/repository/offline structural validation only. The next evidence step is passive representation discovery for Vulnerable Space and Convergent Projection.

**Record:** D-0123.

## 2026-08-08 — Native Continuation Restoration, Guarded Recovery and Protected Progress Alternation

**Observe:** v4.7.38 direct refuge handback preserved the same Job Episode but produced Native Recovery Variability. v4.7.39 restoration-first runs returned Condor and Patriot approximately toward their pre-egress continuation context; both visually reacquired the interrupted lane despite materially imperfect heading. A supplementary Patriot Precision Farming view showed no obvious material untreated gap attributable to the diversion/rejoin. In a later complex run, Condor entered a native diagonal transition during Patriot recovery and the pair deadlocked.

**Discuss:** exact pose/heading restoration would increase OuttaMyWay authority without current evidence of player benefit. The deadlock does not refute restoration; it shows that recovery itself becomes an intervention-created traffic obligation. Fixed dwell/physical passage is too weak, but indefinite conservative waiting is unnecessary if uncertainty remains affordable and the policeman can still protect the recovery.

**Decision:** accept Native Continuation Restoration in principle; retain Rejoin Anchor as approximate recovery reference; define Guarded Recovery and Protected Progress Alternation as compositions of existing Committed Demand, Return/Potential Demand and Traffic Policeman architecture; require authorised manoeuvres to execute at maximum supportable speed; retain traffic responsibility after GIANTS handback until Durable Separation is supported.

**Implementation:** v4.7.40 changes documentation/version metadata only relative to v4.7.39 runtime behaviour. Production Control remains disabled.

**Validate:** repository/offline/RRS conformance only for v4.7.40. Further live implementation waits for agreement on the Situation Assessment evidence contract that exhausts Observe during Guarded Recovery.

**Record:** D-0122. Precision Farming is recorded as supplementary observation tooling for one experiment only; standard tests remain DLC-free.

## 2026-08-08 — Prototype 22 spatial Reposition correction after live evidence

**Observe:** P22-A Regulation and P22-B stable-state Hold/release produced same-Job positive evidence for both Condor Endurance II and Patriot 4450. P22-C also reached operator-selected targets and returned both Job Episodes to GIANTS, but neither 36 m boom folded. Raw console output was impractical to follow during the runs.

**Interpret:** the forward actuator is supported, but spatial Reposition remains incomplete. A deployed 36 m assembly arriving at a roomy target cannot stand as evidence for the passing-place/refuge capability. The console issue repeats Diagnostic Signal Saturation rather than creating a new architectural problem.

**Hypothesis:** preserve the proven one-leg actuator, add test-only configuration ownership, and overlap folding with movement after actual fold motion begins. Require full compact plus positive represented plan-view span reduction at the target before spatial PASS.

**Implement:** v4.7.36candidate adds P22 configuration authority, compact/movement overlap, restoration before handback, represented hull-span comparison, transition-only HUD signalling and one-shot summary results. Production Traffic Policeman authority remains disabled.

**Validate:** offline conformance/RRS first; live validation must now answer whether both Condor and Patriot can complete the corrected spatial sequence.

**Record:** D-0117 records the probe correction; canonical v4.7.34 architecture remains unchanged.

## 2026-08-08 — Prototype 22 Traffic Policeman capability gate implementation

**Observe:** canonical v4.7.34 settles Traffic Policeman Decision ordering but deliberately carries no production actuator. The remaining implementation gate is current GIANTS evidence for two-worker Regulation apply/release, stable-state Hold/release and participant-complete forward Reposition.

**Discuss:** capability validation must not re-open Traffic Policeman architecture or allow legacy fixture logic to dictate Decision. Reverse remains a valid architectural option but need not block the first forward capability gate.

**Hypothesis:** a manual probe can isolate the required GIANTS integration using only previously proven hooks: a transparent same-job continuation-permission Hold and a scoped final-drive wrapper. Regulation can leave GIANTS route/steering/direction untouched by changing only `maxSpeed`; Reposition can temporarily own one explicitly requested forward leg while the Hold permission remains active.

**Implement:** v4.7.35candidate adds three isolated Prototype 22 modules and the `otmP22` manual console surface. No automatic Decision/Commitment path is connected. The probe requires two active workers, controls one subject at a time, monitors Job Episode identity, refuses reverse authority, and monitors independent same-Job continuation after release.

**Validate:** offline repository/RRS validation precedes packaging; live GIANTS validation remains required and is defined in `docs/prototypes/PROTOTYPE_22_TRAFFIC_POLICEMAN_CAPABILITY_GATE.md`.

**Record:** D-0116 records the implementation gate; no architecture change is claimed.

## 2026-08-08 — Traffic Policeman Decision Ordering consolidated

**Observe / discuss:** pressure-tested the canonical Traffic Policeman against roomy crossings, early and late TS016, classic TS015, reversing/footprint-changing Transitional workers and single-track-road / UK Give Way analogies. Repository validation confirmed that the underlying concepts were already canonical; the work therefore remained composition/refinement rather than rediscovery.

**Decision:** treat Traffic Policeman as an omnipresent but normally dormant Decision responsibility. Once decisive temporary movement ordering is required, apply the strict primary preference `CONTINUE_OBSERVATION → REGULATE_SPEED → HOLD_AT_SAFE_POINT → NATIVE_REPOSITION` after mandatory candidate gates. Later bands require explicit earlier-band exhaustion in the same Decision epoch, but rejected candidates need not be physically attempted. Material Reality/Control change restarts evaluation from the least-disruptive end.

**Refinement:** Observe ends when Reality is sufficiently clear to direct or uncertainty is becoming unaffordable because Action Space is shrinking. Regulation means bounded GIANTS-owned proceed/creep motion; Hold means the current occupancy itself is the waiting place; Reposition creates a waiting place and may use forward/reverse/composed movement where positively supported. Reposition exhaustion is participant-complete across admissible role assignments.

**Purpose boundary:** Candidate Purpose is action-level and provenance-bound to admitted intent/Operational Picture and, when present, Commitment Objective/Obligations. Candidate generators represent rather than invent the governing purpose.

**Implementation boundary:** v4.7.34 is documentation/version metadata only. Reverse remains architecturally valid but OuttaMyWay-directed reverse actuation remains an evidence activity. Production Decision remains passive and Control disabled.

## 2026-08-07 — Prototype 21 TS004 expansion: speed ordering and reversible footprint

**Observe:** John Deere 8RX/cultivator and Valtra/reversible-plough were run on separate fields with Prototype 21 passive diagnostics. Productive line evidence replicated. Reversible-plough productive speed (~12.2 km/h) was lower than native transition speed (~15 km/h). Short non-turn line-inactive boundaries appeared before productive-line establishment. The plough visibly switched working side after each pass; passive representation emitted changing profile/configuration tokens and footprint bounds.

**Discuss / hypothesis outcome:** speed ordering is disproved as semantic authority; inactive line is insufficient positive Transitional evidence; profile ordinals are implementation tokens rather than stable working-side identity.

**Record:** D-0114 accepts Native Speed-Ordering Variability, Productive-State Evidence Asymmetry, Alternating Working-Side Configuration and Configuration Footprint Authority. Spatial authority follows realised footprint and transition sweep. No production implementation change.

## 2026-08-07 — Prototype 21 promotes Productive Continuation Preference

**Observe — Condor speed falsification:** ordinary productive continuation at the Condor's ~25 km/h work limit and the same productive continuation under an intentionally retained 10 km/h manual cruise cap both remained `turn=false`, GIANTS work-line `ACTIVE`, implement lowered. The work limit remained 25 km/h while actual speed followed the 10 km/h cap. Absolute speed is therefore not productive-state authority.

**Observe — Condor native transitions:** after completing missed work, Condor performed a long diagonal reposition and several reverse transitions. GIANTS represented these as `turn=true`, work-line `INACTIVE`, implement raised. One long reverse existed because the working axis was slightly misaligned with the field edge and GIANTS returned to cover omitted material.

**Discovery — Apparent Departure Reversal:** a following worker could see Condor apparently moving away and then be surprised when GIANTS reverses it into recently vacated space. Apparent departure/separation cannot retire Future-Space relevance.

**Observe — Valtra cross-assembly run:** Valtra S 416 + lime spreader in field 68 completed multiple productive up/down passes and several forward/reverse repositions. Productive passes replicated `turn=false`, line `ACTIVE`, implement lowered at an ~18 km/h work limit. Transitions replicated `turn=true`, line `INACTIVE`, implement raised across direction changes.

**Discovery — Productive-Line Cross-Assembly Replication:** the useful work-line distinction survived materially different assembly geometry and native productive speeds.

**Discovery — GIANTS Turn-Segment Breadth:** `isTurn=true` cannot mean literal headland/geometric turn; GIANTS uses the state for long diagonal and reversing course transitions.

**Discuss / decide:** the original question “can we detect repositioning?” is unnecessarily narrow. Traffic Policeman needs positive Productive Continuation versus Transitional Continuation Knowledge. For roomy non-headland encounters, Productive Continuation becomes the preferred Progress candidate and a supported Transitional participant the first Yield candidate, unless that assignment worsens Action-Space Compression or current obligations. Headland Encounter Maturation remains unchanged.

**Repository response:** v4.7.32 records D-0113 and reconciles architecture, ADRs, glossary, concept register, discoveries, project status, flow and Prototype 21 evidence. Runtime behaviour remains passive; Prototype 21 remains diagnostic only; no Traffic Policeman role assignment, Commitment application or Control authority is introduced.

## 2026-08-07 — Productive Continuation Preference becomes an evidence question

**User observation:** in roomy non-headland encounters, equal-speed productive crossings are uncommon. GIANTS often moves between work continuations at a distinct native repositioning pace, including rare diagonal relocation, while each vehicle/implement has its own productive speed envelope. A player's previous cruise-control setting can also cap an otherwise ordinary AI worker far below that normal productive speed.

**Architectural hypothesis:** where Action Space is abundant, preserving Productive Continuation and treating a transitional/repositioning participant as the first Yield candidate may be a useful Traffic Policeman preference. This does not alter the established headland/Encounter-Maturation treatment and is subordinate to Action-Space viability.

**Evidence problem:** absolute speed is not semantic authority. The preferred implementation would consume a GIANTS-native productive/transitional signal if one exists. Repository/API review identifies active segment state and GIANTS implement-line state as promising seams, but their fitness is unproven.

**Decision:** build Prototype 21 as a passive probe before documenting or implementing Productive Continuation Preference as Decision policy. Include an intentionally low-cruise productive pass as a falsification case. A failed classifier hypothesis counts as useful evidence.

**Repository response:** v4.7.31 adds only passive diagnostic observation plus its test/evidence contract. No Traffic Policeman role assignment, Commitment or Control path is introduced.

## 2026-08-07 — Encounter Maturation and Action-Space Compression accepted

**Repository archaeology:** the earlier TS016 controller selected the straight-working Patriot as Yield and allowed manoeuvring Condor to remain under GIANTS as Progress. The first crossing phase could succeed, but the fixture-specific thresholds/controller-owned lifecycle were later rejected as implementation architecture. The physical policy evidence remains useful.

**User qualification:** “complex” in TS016 is substantially created by limited space: Patriot crosses along a headland at the field edge, making resolution akin to a sliding puzzle. Similar crossing geometry mid-field has more available options.

**Discovery — Action-Space Compression:** difficulty rises as Field World constraints, participant demand and Physical Assembly geometry remove supportable resolution actions. The concept is derived from existing Action Space/Committed Demand/Potential Demand/Temporary Slack rather than a new root space.

**Decision — Encounter Maturation:** when an ambiguous interaction can safely continue, Traffic Policeman may preserve bounded native GIANTS progression so Reality either dissolves the interaction or reveals a simpler authoritative state. Early admission can therefore lead to bounded observation or supporting speed regulation instead of immediate Hold/reposition.

**Constraint:** maturation is not “wait for head-on.” Where current Action Space already supports simpler resolution, particularly mid-field, implementation familiarity must not dictate architecture. The Bounded Observation Contract and Preference-Band Exhaustion govern when waiting remains legitimate; maturation stops being preferred when it consumes the options needed for resolution.

**Repository response:** v4.7.30 reconciles ADR-0023, ADR-0006 and ADR-0019 plus architecture/concept/glossary/decision/status records. Runtime remains passive and production Control disabled.

## 2026-08-07 — v4.7.29 staged refuge recovery / purpose-bound traffic protection consolidation

**Observation:** In the pure Condor–Patriot head-on, letting Progress pass the original conflict does not by itself ensure Yield can complete refuge ingress/restoration before Progress catches the recovering assembly again. Condor boom restoration is currently observed to take about 15 seconds.

**Discussion:** Treating `PROGRESS` as unrestricted motion would make an otherwise valid ingress opportunity self-defeating. Treating the ~15 s unfold as a fixed delay would make one implement timing into architecture.

**Decision:** preserve the admitted recovery obligation rather than a clock. Yield may hold bounded recovery Committed Demand while Progress retains priority; a purpose-bound speed lease may regulate Progress only while needed to preserve compatibility. BNIR revelation before configuration restoration is stage evidence and fresh operational intent is reacquired during Native Handover.

**Validation status:** paper pressure-test only. No runtime behavior changed. The next architecture pressure-test should use a less symmetrical encounter such as headland-cross → head-on before production implementation is designed.

## 2026-08-07 — Traffic Policeman discovered during two-worker BNIR/Safe Release reconciliation

**Observation:** after B completes its native manoeuvre and returns to authoritative settled continuation, A may still require BNIR to reveal post-Hold native intent. `SETTLED_CONTINUATION` alone does not establish spatial safety, and an A creeping under BNIR can itself become a slow physical obstacle to B.

**Discussion:** the missing responsibility is not another route predictor or actuator. Decision needs a traffic-level responsibility that decides which participant currently has permission to consume contested space while GIANTS retains route and steering ownership. Temporary Yield/Progress roles may need to change as Reality changes, but arbitrary swaps can simply transfer uncertainty.

**Discovery — Traffic Policeman:** accepted by the user as architecture. Traffic Policeman assigns/revises temporary movement priority inside one Encounter, protects the Progress participant's supported corridor, governs whether BNIR or another bounded Yield action remains admissible, and may transfer roles only when the transfer produces genuine resolution progress.

**Discovery — Revelation Oscillation:** repeated Control transfer that invalidates one participant's authoritative intent merely to reveal the other, then reverses again without reducing unresolved obligations, is not progress.

**Refinement — Demonstrated Traversability:** the real assembly's own recent successful occupation/traversal can provide positive local spatial-admissibility evidence in a materially unchanged bounded domain. This can support ordinary straight-continuation interruption or return through a recently traversed refuge corridor without pretending incomplete synthetic geometry is complete. It does not prove arbitrary reverse kinematics, configuration sweeps or current availability against dynamic workers.

**Refinement — Encounter-relative Continuation Safety Horizon:** the Horizon settles continuation consequences materially belonging to the current Encounter/interventions; it is not an indefinitely advancing requirement to witness every later manoeuvre of every active worker.

**Deferred problem:** static-object recovery/avoidance is intentionally parked for dedicated future analysis and may ultimately require player intervention if safe automation cannot be established.

**Repository response:** v4.7.28 records ADR-0023 and reconciles ADR-0006, ADR-0012 and ADR-0022 plus glossary/concept/decision/status/conformance records. Runtime behaviour remains passive; no production BNIR/Traffic Policeman Control implementation is introduced.

## 2026-08-07 — Bounded Native Intent Revelation accepted after v4.7.26 live PASS

**Problem:** Same-Job-Episode release required positive knowledge of what a held worker would do after Hold, but the complete GIANTS route/cursor is not exposed and the held state itself suppresses the evidence. Predicting the route would reintroduce a rejected architecture dependency.

**Discussion:** separate release of a Control capability from the Safe Release Point. Let the other worker complete its native manoeuvre and settle. Then, for the held worker, retain the Commitment but grant GIANTS tightly bounded motion authority so Reality can reveal actual post-Hold intent. For large extended implements, use a proven OuttaMyWay-controlled transit configuration where the assembly can move under GIANTS before restoring operational configuration for unrestricted handover.

**Historical reconciliation:** v4.6.63 had already shown Condor moving under GIANTS while compact; v4.6.64 separately showed OuttaMyWay-owned configuration restoration followed by native continuation. Those runs did not isolate the complete chain in one Job Episode.

**Live validation:** non-canonical v4.7.26 (`43e0fc93fcd7810d8460d11e683ad05adef50ada545c8190a3394f015b260ec0`) isolated the chain with one Condor on field 77 under FS25 1.21.1.0. Job identity stayed `giants-ai-job-id:0`. The probe Held, compacted, allowed GIANTS-native progression under an experimental 1 km/h ceiling, observed native `SETTLED_CONTINUATION` progress, re-Held at approximately 2.04 m actual travel, restored and verified the deployment/work mutation with zero mismatches, returned the original drive path and observed independent native continuation. The run ended `success=true reason=same-job-native-continuation-observed`.

**Discovery — Bounded Native Intent Revelation:** a retained Commitment can acquire authoritative post-intervention Local Intent by allowing controlled GIANTS-native movement rather than reconstructing GIANTS' route. The bounded movement may be performed in a proven transit configuration and followed by re-Hold, configuration restoration and full native handover.

**Architecture decision:** user explicitly accepted Bounded Native Intent Revelation as architecture. It is not Safe Release, not a new route model and not authority for the probe's 1 km/h or 2 m literals. ADR-0022 records the contract and amends ADR-0017's synthetic Counterfactual Hold Release implementation assumption.

**Potential implications:** cooperative Hold release is the immediate application. Static-obstacle recovery and post-intervention route reacquisition may also benefit, but those uses remain unvalidated hypotheses and must not imply GIANTS obstacle avoidance.

**Repository response:** v4.7.27 consolidates the discovery into architecture, ADR, glossary, concept, decision, prototype and status records while retaining v4.7.24 production behaviour and disabled Control.

## 2026-08-07 — v4.7.24 legacy fixed-horizon predictor cleanup

**Observation:** v4.7.23 live validation fulfilled the only remaining purpose of the ten-second predictor: direct comparison proved Future Space admitted `EN-00001` while the old predictor was still negative.

**Classification:** planned implementation cleanup under D-0106, not new architecture.

**Implementation:** removed the fixed future-horizon constant, TCPA/DCPA scalar future calculation, component-disc future projection, legacy comparison provenance and pair-log fields from the active replacement core. Retained independent present-state distance, relative motion/closing rate, scalar current overlap and configuration-filtered current footprint overlap. Replaced future-capable footprint evaluation with current-only `evaluateCurrentOverlap`.

**Boundary:** archived prototypes/history remain intact as evidence. Field-bounded Future Space remains future Encounter-admission authority; non-overlap remains unresolved. Decision, Commitment application and Control remain passive.

**Offline validation:** 132 Lua and 40 Python structure tests pass.

## 2026-08-07 — v4.7.23 Future-Space Encounter admission conformance

**Observation:** the v4.7.22 live run showed field-bounded Future Space positive at 08:44:10 while the first Encounter/HUD prompt did not appear until 08:44:24, when the historical ten-second future probe became positive. The HUD transition shared the Encounter creation sample, so display latency was disproved.

**Repository validation:** ADR-0006/ADR-0012 and D-0041 already define/validate field-bounded Future Space; D-0104 already defines the membership-evidence correction. This is implementation conformance, not new architecture.

**Implementation:** positive Current Space interaction or positive field-bounded Future Space may emit interaction evidence and admit an Encounter. Legacy ten-second scalar/component future convergence is renamed and retained as shadow comparison only. Pair diagnostics expose both authorities. The misleading representation-negative warning is removed because no negative result is used. The v4.7.22 precedence correction is carried forward unchanged.

**Lifecycle instrumentation:** the HUD now prompts on `FUTURE SPACE ENCOUNTER`, then guides stop, termination, restart and fresh Future-Space Encounter in one live cycle.

**Debt control:** once Future-Space Encounter admission is live-validated, the superseded legacy shadow predictor/messages should be removed rather than retained indefinitely.

**Offline validation:** 132 Lua and 40 Python structure tests pass. A dedicated fixture proves Future-Space admission while the legacy shadow remains negative; another proves legacy future convergence alone cannot admit an Encounter. Decision, Commitment application and Control remain passive.

## 2026-08-07 — v4.7.22 Encounter termination-precedence conformance

**Observation:** the v4.7.20 lifecycle run terminated the active Encounter as `MEMBERSHIP_INVALIDATED` one assessment before authoritative Job Episode-end evidence arrived.

**Repository/code validation:** this is not new lifecycle architecture. The Encounter Exit Contract already gives Job Episode end, Operation end, membership invalidation and intent supersession explicit terminal authority. `LiveObservationSource` correctly marks unresolved stop membership as incomplete, but `OperationAdmission` previously allowed individual member removal even when `membershipEvidenceComplete=false`.

**Classification:** implementation non-conformance in Operation-membership evidence authority.

**Implementation:** incomplete membership updates retain all prior members and add only positive new observations. Complete evidence retains normal update/removal authority. The lifecycle Transition HUD is restored for the live gate; Future Space evidence remains active and logged. No timer or behavioural distance/time literal is added.

**Offline validation:** 131 Lua and 64 Python tests pass. A dedicated fixture reproduces unresolved stop → incomplete membership → later authoritative stop and proves the Encounter remains active first, then terminates `JOB_EPISODE_ENDED` with terminal cause. Decision, Commitment application and Control remain passive.

**Governance:** record the standing rule that apparent new architecture must first be checked against the repository and archived evidence.

## 2026-08-07 — v4.7.21 Future Space conformance recovery

**Observation:** v4.7.20's HUD showed Encounter admission only about ten seconds before predicted closest approach. The user correctly challenged the resulting proposal to enlarge a time horizon and recalled that Future Space and Option Preservation had already been explored extensively.

**Repository validation:** ADR-0006 already defines bounded local Future Space through current motion, next material manoeuvre, manoeuvre sweep and subsequent settlement. ADR-0012 already composes Local Intent, Intent Expiry and Option Preservation. Archived refuge-era code contains useful FieldBoundary and FieldCourse active-segment mechanisms, but also fixture-era time/distance/TCPA literals that are not architectural authority.

**Classification:** implementation non-conformance, not new architecture. The replacement-core live producer had reduced canonical Future Space to a ten-second constant-velocity corridor.

**Implementation hypothesis:** use native GIANTS FieldCourse active-segment `isTurn` as the material manoeuvre observation; while settled, bound the current heading through the current Job-Seeded Field World polygon; while turning, expire straight intent and leave the manoeuvre sweep unresolved; on post-turn settlement, advance the intent epoch. Publish only positive pair intersection support into Situation Assessment and retain no negative-clearance authority.

**Offline validation:** 129 Lua and 63 Python tests pass. Decision remains passive and Control disabled. Live validation remains required.

## 2026-08-07 — Diagnostic Signal Saturation and Shape-Type Gate

**Observation:** the first v4.7.19 live run recognised a manual stop and restart, then later created and retained an Encounter. The stop occurred before Encounter creation, so the intended termination sequence was not exercised. The required console transition was buried in continuous diagnostics. GIANTS also printed shape-bound API errors for collision-named transform groups.

**Discovery — Diagnostic Signal Saturation:** complete diagnostic evidence can still be operationally unusable when the player must react to one transition among many lines.

**Implementation:** v4.7.20 adds a temporary transition-only HUD and one matching `[OTM TEST GATE]` line per state change. Pair console detail is throttled to material state changes or heartbeat; sealed traces remain complete. A Shape-Type Gate uses `getHasClassId(..., ClassIds.SHAPE)` before every shape-bound call.

**Validation:** 125 replacement-core Lua tests and 62 Python tests pass before release packaging. Dedicated fixtures prove non-shape rejection occurs before any shape API invocation and the HUD follows the complete lifecycle test sequence. Decision, Commitment application and Control remain passive.

## 2026-08-07 — Encounter Exit Contract implementation

**Observation:** canonical v4.7.18 proved Encounter entry, but current-sample disappearance still had only diagnostic `LOST` inference. Non-positive footprint evidence remained unresolved and therefore could not justify termination.

**Discovery — Evidence Absence Is Not Clearance:** an Encounter must survive temporary loss of positive evidence while its Operation and Job Episodes remain valid.

**Decision:** introduce a first-class Encounter Registry and bind active identity to Operation, interaction reference and participating Job Episode identities. End it only through explicit lifecycle evidence. Preserve terminal records and require renewed positive evidence after restart to create a fresh Encounter.

**Validation:** 123 replacement-core Lua tests pass, including temporary evidence-loss retention and manual-stop/restart non-resurrection fixtures. Python structural/RRS tests include the active registry and explicit `TERMINATED` lifecycle boundary. Decision, Commitment application and Control remain passive.

## 2026-08-07 — Positive Footprint Evidence Admission

**Observation:** canonical v4.7.17 produced a correct approximately 36 m Condor footprint and stable future-positive TS015 evidence while the scalar predictor remained unable to calculate CPA.

**Hypothesis:** the existing Situation Assessment path can consume the filtered component evidence without granting any negative-clearance or Control authority.

**Implementation:** v4.7.18 adds a pure one-way positive evidence composition and sends the resulting packet through the existing interaction-evidence handoff. Diagnostics distinguish scalar outcome, footprint outcome and admitted evidence source.

**Validation target:** one short live TS015 run proving emitted → received → Encounter before contact, with passive Decision and Control.

## 2026-08-06 — Configuration Participation Correction and v4.7.17

**Observation:** the v4.7.16 live run showed a stable approximately 54 m Condor footprint, while the tested purchased machine is the 36 m configuration. The footprint therefore represented available asset geometry rather than current physical occupancy.

**Code finding:** the donor listed 13 intended 36 m/permanent identities, but generic hierarchy discovery also accepted alternative collision nodes. Configuration profiles identified fold/lowered state but transformed every cached primitive without selecting current participants.

**Implementation response:** v4.7.17 retains a complete cached inventory and separately builds each profile's participation set. Runtime compound-child state is principal evidence; a matched donor configuration is fallback-only. The Condor donor records all 29 identities so 16 alternatives can be explicitly observed as inactive rather than silently omitted or admitted.

**Validation target:** TS015 must show the 36 m selector, inactive alternative exclusion, a corrected deployed span, independent Patriot participation and unchanged passive authority.

## 2026-08-06 — Representation Donor Recovery and v4.7.16

**Observation:** v4.7.15 isolated TS015 failure to missing physical representation. Both active sprayers reached pair evaluation with coherent motion evidence, but both width, length and radius were absent.

**Discussion:** earlier prototype work had already established overhead plan-view composition, compound vehicle-plus-implement membership, offset attached implements, runtime collision-Entity resolution, conservative local spheres and authoritative live transforms. The archive retained these as donor mechanisms rather than an active service.

**Decision:** implement a passive Job Episode–scoped representation foundation. Expensive assembly and local-geometry discovery occurs once. Configuration profiles are reused. Current poses are realised each sample. Layered footprints preserve T-shapes, offsets and articulation. A component-aware predictor runs only in shadow; incomplete coverage cannot establish negative clearance.

**Validation target:** one short TS015 run must show cache reuse, component discovery for Condor and Patriot, configuration-profile behaviour, coherent plan-view output and either shadow convergence or explicit unresolved evidence. Control remains disabled.

## 2026-08-06 — TS015 Encounter Admission Diagnostic Boundary and v4.7.15

**Facts:** v4.7.14 passed merged 68–70, split-77 and contiguous-77 Field World live validation. In the subsequent TS015 head-on run, both sprayers remained in one Field World and one Operation. The physical assemblies collided and became blocked, while the passive trace remained at zero Encounters.

**Observation:** Situation Assessment creates an Encounter when supplied interaction evidence asserts current-space intersection or future-space convergence. The live source emitted no such evidence in the run. The existing predictor depends on active pose, `sizeWidth`/`sizeLength`, a derived circular radius and constant-velocity closest approach.

**Implementation response:** v4.7.15 adds bounded diagnostics across active-worker acquisition, pose, representation inputs, observed motion, every unordered pair, prediction outcome, handoff, Encounter lifecycle and contradictions. It does not alter the predictor or architecture.

**Validation:** offline fixtures prove exhaustive outcome labels, position-derived motion classifications, all three unique relationships for three workers, missing-radius handoff, successful qualifying-pair Encounter construction, explicit pose failure and blocked-without-Encounter reporting. Control remains disabled.

## 2026-08-06 — Field World Equivalence Authority Implemented Passively in v4.7.14

**Objective:** realise ADR-0021 without allowing geometry thresholds, Operation admission or runtime convenience to redefine Field World identity.

**Implementation:** separated immutable Snapshot capture, exact polygon provenance, pure pairwise evaluation and stateful class-wide authority. Live grouping now consumes resolved Field World identity. Unresolved Snapshots remain observable but cannot establish or join an Operation. Operation records retain every member Snapshot and exact-polygon reference.

**Validation:** offline fixtures cover exact equality, four non-exact merged-workspace representations, positive disconnection, partial overlap, tolerance-chain rejection, class retirement, unresolved Operation exclusion and multi-representation Operation provenance. Existing replacement-core conformance remains green.

**Remaining Reality question:** whether concurrent live GIANTS captures in merged 68–69–70 resolve into one Field World and one Operation. Control remains disabled.

## 2026-08-06 — Field World Equivalence Authority Closed and v4.7.13

**Observation:** exact polygon representation and experienced Field World identity are not the same relation. The merged 68–69–70 closure produced four distinct fingerprints with near-identical spatial evidence; disconnected split 77 remained decisively separate.

**Decision:** Field World identity is governed by coherent, positive spatial equivalence between immutable Job-Seeded Field World Snapshots. Resolution is `SAME_FIELD_WORLD`, `DIFFERENT_FIELD_WORLD` or `UNRESOLVED`. Exact fingerprints remain provenance. Unresolved evidence grants no Operation or Control authority, and pairwise tolerance chaining is prohibited.

**Repository response:** ADR-0021 and D-0033 record the closed contract. v4.7.13 changes documentation and version metadata only; runtime exact-fingerprint Operation grouping remains the explicit implementation gap.

## 2026-08-06 — Seed-Dependent Boundary Representation

**Observation:** Exact fingerprint equality succeeded for seeds in merged areas 68 and 69, but failed for two separate seeds in old area 70. The second 70 seed was deliberately placed at the old field's geometric centre. Both 70 captures and the 68/69 captures reported 15 points and identical bounds.

**Disproved hypothesis:** the first 70 mismatch was caused by starting too close to a former internal boundary.

**Discovery:** the same experienced Field World can have seed-dependent exact boundary representation.

**Implementation response:** v4.7.12 records bounded spatial comparison evidence while preserving passive behaviour and explicitly refusing to promote uncertain equivalence into authority.

## 2026-08-06 — Merged/Split Field World Closure and v4.7.11

**Observation:** Three starts in merged areas 68, 69 and 70 produced identical 15-point geometry and bounds. Two starts in a split field 77 produced distinct 6-point and 11-point polygons while both retained locator 77.

**Discovery — Job-Seeded Field World:** the polygon containing the worker at confirmed field-work onset is the stable experienced workspace. Field labels are useful UI locators but cannot govern Operation identity.

**Implementation:** v4.7.11 captures and fingerprints the polygon once per Job Episode, binds it immutably, groups Operations by fingerprint and reports global Operation count for the agreed parallel validation.
## 2026-08-06 — v4.7.10 Source-Field Authority, Derived Field World Discovery and Source-Intent Termination

**Observation:** v4.7.9 achieved Live Replacement-Pipeline Closure. The numeric field results were correct, but farmland mapping was still treated as authority and a manually stopped Valtra episode remained open. The user also supplied direct evidence that source fields 68, 69 and 70 form one contiguous agronomic area while retaining individual map labels.

**Discovery — Source Field / Derived Field World Separation:** GIANTS source field labels and the experienced contiguous Field World are different identities. Farmland is a third, larger contextual area.

**Implementation:** source labels now require exact source-field polygon containment. Farmland is contextual only. GIANTS field-course generation passively discovers the derived boundary. A matching inactive `lastJob` transition provides positive source-intent termination evidence.

## 2026-08-06 — v4.7.9 GIANTS-Compatible Value Traversal and Polygon Field Identity

**Observation:** v4.7.8 logged valid active GIANTS jobs and stable source tokens, but the sealed snapshot reached downstream layers as zero active AI states and zero Job Episode evidence. The broad diagnostic stutter was gone.

**Discovery — GIANTS Sealed Value Traversal Compatibility:** immutable proxy collections remained directly readable, but ordinary proxy `pairs`/`ipairs` traversal was not portable to the GIANTS Lua runtime.

**Decision:** retain sealed immutable records and provide explicit ValueRecord traversal and length accessors. Migrate active architecture layers to those accessors rather than weakening immutability.

**Discovery — Polygon Field Identity:** the reliable fallback is the authoritative `FieldManager.fields` polygon collection. Field identity is accepted only for exactly one containing polygon; no match or multiple matches remain unresolved.

**Validation:** offline fixtures admit two active Job Episodes and one field-77 Operation when polygon evidence is unique. A complementary unresolved-field fixture preserves both Job Episodes, admits no Operation, selects bounded `CONTINUE_OBSERVATION`, and keeps Control disabled.

## 2026-08-06 — v4.7.8 Targeted Job Episode Admission and Field Identity

**Observation:** v4.7.7 found positive native AI ownership in `AISystem.activeJobVehicles`, stable job identity in `spec_aiJobVehicle.job` / `spec_aiFieldWorker.fieldJob`, and unchanged job identity through blockage. It also showed that cab occupancy can coexist with native AI ownership and that broad reflection causes regular sampling stalls.

**SDK corroboration:** the current GIANTS AI system maintains explicit active-job and active-job-vehicle collections. Field-work jobs retain a position parameter. FieldManager maintains a farmland-to-field mapping.

**Hypothesis:** target only active job vehicles, admit the Job Episode from stable GIANTS job identity, and resolve field identity from agreed current/job-position farmland mapping.

**Implementation:** v4.7.8 removes the broad reflection probe, adds `LiveAIJobEvidence`, uses active-job membership as the positive activity fact, preserves blockage, detects job replacement by token change, and adds a targeted field/job probe.

**Protection:** field disagreement is unresolved, inactivity without a distinguished cause remains unresolved, and live Commitment mutation and Control remain disabled.

## 2026-08-06 — v4.7.7 Live AI State Discovery Probe

**Observation:** v4.7.6 enumerated relevant assemblies but all configured AI activity signals remained false during native GIANTS work. Field attribution and Job Episode admission therefore never began.

**Interpretation:** the activity-onset architectural concept remains viable, but its implementation input is unknown. Another guessed property would only repeat the failed cycle.

**Decision:** add a diagnostic-only probe that records method results, AI-specialisation fields, mission AI-system state and field lookup results across idle, active and stopped phases.

**Protection:** probe evidence cannot enter admission, Decision, Commitment or Control. The build remains fully passive.

## 2026-08-06 — v4.7.5 Passive Live Validation

**Decision:** open the canonical passive-live gate without introducing Commitment mutation or Control.

**Implementation:** added a read-only field-grouped live source, explicit unavailable-source evidence, a complete non-actuating Candidate support boundary and change-driven canonical trace diagnostics.

**Protection:** metadata geometry is marked incomplete, archived code remains non-executable, and every live trace asserts `control=false`.

**Next evidence:** owner live test using no-worker/one-worker control and a two-worker same-field fixture.

## 2026-08-06 — v4.7.4 Replay Conformance

Implemented the canonical replay gate from owner-declared v4.7.3. The corpus uses only documented historical facts and explicitly labels each fixture as reconstruction rather than raw physics simulation.

The strongest negative case is v4.6.77: a completion request with `safeRelease=false` enters or remains `SETTLING`, cannot reach `SUCCEEDED` while the Safe Release obligation is open, and cannot admit a second Commitment for the same unresolved responsibility.

Other fixtures preserve the accepted evidence outcomes: v4.6.57 and v4.6.70 wait for missing evidence, v4.6.64 completes only after three settlement obligations close, TS016 enforces Follower Owns Closure, player takeover releases progress authority without transferring internal obligations, and Operation termination retains origin-bound responsibility.

No live listener or physical Control path was added.

## 2026-08-06 — v4.7.2 Operational Picture

Implemented the next offline canonical boundary from owner-declared canonical v4.7.1. Added admitted Operation identity, Situation Assessment, Operational Picture publication, the three canonical demand classes, relationship Knowledge, uncertainty and all five Representation Fitness states. No GIANTS hook, Candidate, Decision or Control path was added.

The tests celebrate two negative results as useful enforcement: incomplete Operation membership evidence does not end an Operation, and partial non-conservative representation cannot become all-clear Knowledge.

# v4.7.0 — Replacement-Core Bootstrap

Canonical v4.6.78 closed the architecture. v4.7.0 begins implementation from an inert active tree rather than another overlay. The former 48-file Lua tree is preserved byte-exactly as non-executable donor and failure evidence. The active kernel now enforces immutable records, the three-state Commitment lifecycle, explicit Obligation ownership, exclusive progress authority and structural Effective Actuation Composition.

No GIANTS Observation or Control was added. The deliberate absence of gameplay behaviour protects the architectural boundary and allows offline conformance before further build cycles.

# v4.6.78 — Replacement-Core Architecture Closure

The v4.6.72–v4.6.77 runtime-validation line was recovered before candidate production. Its final audit confirmed Architectural Constraint Enforcement and Composition Validation gaps. The line is retained as failed evidence; the documentation candidate derives from exact canonical v4.6.71 runtime bytes.

The architecture was then closed through the unified Obligation model, `SETTLING`, Intent Supersession, player takeover, Terminal Occupancy, Operation termination, Governing Basis, terminal-cause precedence and Effective Actuation Composition. Twelve paper walkthroughs exposed no lifecycle dead end or additional subsystem requirement.

## 2026-08-05 — Replacement-core lifecycle closure

**Baseline:** owner-declared canonical v4.6.71, ZIP SHA-256 `c675911413c7898b047252ccf764ee5154ecbcfeb3704b80af58f0b3370a0a4f`, Git `aa9a32846c082d41142558145000dd0971216d7a`.

**Observation:** Completed-worker relevance, Terminal Occupancy, evidence waiting, preference exhaustion, Representation Fitness and independent Job Episode admission were substantially understood, but terminal ownership remained fragmented across supersession, player takeover and Operation termination.

**Hypothesis:** One shared obligation and settlement model could close all lifecycle boundaries without a generic cleanup owner or special-case terminal states.

**Discoveries:**

- `SETTLING` is the shared non-terminal state after progress authority ends.
- Every open Obligation requires exactly one owning Commitment.
- Obligations settle through satisfaction, evidenced basis cessation or atomic accepted transfer.
- The player acquires physical agency but does not accept internal Obligation objects.
- A completed worker remains relevant only while occupancy or another open obligation materially affects active demand.
- Operation membership may reach zero while a Commitment remains in `SETTLING`.
- `SUPERSEDED_BY_NEW_INTENT` is a first-class terminal disposition.
- Predecessor and successor may coexist, but conflicting progress authority is forbidden.
- Every Commitment requires a Governing Basis.
- The first authoritative invalidation of that basis determines terminal cause.
- Isolated capability validity is insufficient; the complete Effective Actuation Composition must be validated.
- Only one Commitment may own objective-progress actuation for one assembly.

**Validation:** Twelve paper walkthroughs covered ordinary success, multi-stage resolution, evidence insufficiency, candidate exhaustion, Representation Fitness failure, Terminal Occupancy, player takeover, restart, GIANTS abort/fault, supersession, Operation termination and invalid action composition. No lifecycle dead end or ownerless Obligation was found.

**Result:** Architecture is sufficiently complete for a documentation-only candidate. Further conceptual expansion is paused unless documentation synthesis or implementation evidence exposes a contradiction.

## v4.6.71 — Architecture Consolidation and Experimental Reset

The v4.6.57–v4.6.70 loop repeatedly advanced the failure boundary. That is useful architectural work, but the accumulated implementation was not a stable release candidate. v4.6.71 therefore returns executable authority to v4.6.56 while promoting the learning itself.

The final v4.6.70 run was especially clarifying: the first encounter completed, the new Hold lease no longer oscillated, and Patriot then remained held because the release model treated a 60 km/h cruise ceiling as expected field-working continuation and required non-closing motion. The stable lease proved ownership; the failed release proved its Knowledge was wrong.

The cycle closes with a named discipline: **Experimental Reset** — retain discovered architecture and evidence while deliberately removing unvalidated implementation authority. This is not rollback of knowledge; it is restoration of a trustworthy baseline.

## v4.6.70 — Orientation Acquisition and Hold-Release Causality

**Observation:** v4.6.69 began the second refuge leg in the correct settled-pose frame. Condor moved 0.77 m opposite the selected side during steering acquisition and failed. Patriot then alternated Hold and Restore for nearly a minute.

**Interpretation:** A valid movement need not be monotonic from its first centimetre. Separately, Control-created improvement is not independent evidence that Control may be released.

**Decision:** Add a bounded leg-orientation envelope, counterfactual native-continuation projection, sustained Hold release confirmation and global no-all-held enforcement.

## 2026-08-04 — v4.6.65 final refuge exposed continuous-viability requirement

## v4.6.67 — Transition executability before replacement authority

v4.6.66 disproved the assumption that a fresh viable endpoint is enough to revise an occupied refuge. Condor's opposite-side replacement needed approximately 58.20 m while only 5.52 s remained to closest approach. The endpoint was plausible; the transition was not. The new implementation retains the existing refuge unless Decision and Control can prove and atomically accept the replacement path and time budget.

**Validated:** repeated Encounter identity, early option preservation, field containment, work restoration and GIANTS handover all operated through the chained TS015 run.

**Observed:** Condor's final refuge was viable against Patriot's current corridor but became obstructive after Patriot changed intent. Assessment calculated new geometry, yet the active target remained immutable. The supporting speed lease also chattered between request and restoration.

**Interpretation:** This is an instance of Commitment Viability Decay and Passage Corridor Is Not Continuation Corridor. The first refuge was lucky in earlier builds, not permanently correct.

**Implementation:** v4.6.66 revalidates on intent change, revises same-role movement from the current pose and retains supporting speed until sustained completion evidence.

## 2026-08-04 — Primary TS015 passed; repeated-Encounter architecture reactivated

**Validated:** v4.6.64 completed refuge, positive passage, work restoration, native handover and GIANTS continuation without a freeze.

**Observed:** The next deadlock was admitted at approximately 27 m and 3 s to closest approach. The useful intervention point was Patriot's preceding headland turn, where modest slowing or waiting could still create longitudinal option reserve.

**Reconciliation:** The architecture was already recorded as Option Preservation Window, Intent Expiry, Encounter Identity Is Not Entity-Pair Identity, Earliest Sufficient Action, Option-Preserving Augmentation and Commitment Viability Decay. `Option Creation Window` is retired as a duplicate alias.

**Implementation:** v4.6.65 gives each recovered repeated convergence a fresh Encounter identity, stabilises intent across a turn, publishes a distance/time return plan and permits a bounded supporting speed lease during an active refuge Commitment.

**Implementation discovery — Control Outcome Projection Gap:** the v4.6.64 controller produced work-restoration and handover evidence, but `ControlCapabilities` omitted those fields from its public outcome. Physical success therefore could not complete the governing Commitment. v4.6.65 projects the full release evidence without changing physical Control.

## 2026-08-04 — Freeze removed; bounded TS015 lifecycle defects exposed

**Validated:** The v4.6.63 run did not freeze and executed the formerly failing Hold Decision/Commitment path, strongly supporting the Live Reference Deep-Copy Trap.

**Observed:** Condor accelerated under GIANTS while compact. Patriot remained stationary under an OuttaMyWay Hold after current pair evidence disappeared.

**Discoveries:** Motion Recovery–Work Recovery Separation; Persistent Relevance Is Not Persistent Control Authority; Mutation Ownership Gap.

**Implementation:** v4.6.64 adds an Intervention Configuration Snapshot, bounded restoration phase, work-capable verification and a post-handover `NO_PHYSICAL_CONTROL` guard. No route reconstruction or exact rejoin is reintroduced.

## 2026-08-04 — Live Reference Deep-Copy Trap isolated

**Observation:** v4.6.49 passed under the current engine, and v4.6.55 remains the latest known-good evidence. v4.6.57 is the first repeatable freeze while the physical sidestep controller remained materially unchanged.

**Code difference:** v4.6.57 introduced generic recursive copies in Decision and the Commitment Ledger. Hold candidates contain live `subjectRef` and `progressSubjectRef` vehicle objects.

**Discovery — Live Reference Deep-Copy Trap:** value-copy logic can traverse an engine-owned cyclic identity graph and occupy the main Lua thread without a useful exception.

**Architecture correction — Identity Reference–Value Snapshot Separation:** engine objects remain exact references; only explicit architectural value schemas are copied. The prior agreement that dimensions are captured once at job start remains authoritative.

**Test:** v4.6.63 executes the actual Hold Decision and Commitment path with deliberately cyclic mock vehicles. Runtime TS015 must determine whether this was the freeze cause.

## 2026-08-04 — Intervention-Conditioned Failure and execution-path restoration

Two controls separated loaded state from activated intervention. Condor successfully completed manual stop, displacement and GIANTS restart with OuttaMyWay absent, and repeated that success with v4.6.61 loaded while no encounter was admitted. Normal OuttaMyWay diagnostics remained active in the latter run, excluding logging volume as causal.

Named discoveries:

- **Intervention-Conditioned Failure:** the freeze requires state or behaviour created by an admitted intervention.
- **Loaded Interception–Activated Interception Separation:** a wrapper may be harmless while dormant but unsafe after vehicle-specific state acquisition.
- **Command Release–Execution-Path Restoration Separation:** removing a hold record does not prove restoration of the pre-intervention GIANTS call path.

The first isolated hypothesis is the Condor-specific permission overwrite, because it is absent in both successful controls and present in every failing intervention. v4.6.62 makes that interception ephemeral and exact-identity-restoring.

## 2026-08-04 — Diagnostic Path Coupling found and isolated

**Observation:** v4.6.60 stopped after folding and never attempted egress.

**Evidence:** repeated nil-helper exceptions occurred while constructing the `EGRESS_READY_CANDIDATE` diagnostic. Lua argument evaluation aborted the update before `setPhase("EGRESS")`.

**Discovery — Diagnostic Path Coupling:** non-essential diagnostics were able to veto a safety-relevant Control transition.

**Decision:** preserve ADR-0009; commit lifecycle state before diagnostics, make affected diagnostics non-blocking, and add a branch-executing packaged-byte smoke test.

# Engineering Journal

## 2026-08-06 — Live Job Episode Admission Gap and Unresolved Evidence Loss

**Observation:** v4.7.5 safely enumerated one and two native AI assemblies and never intervened, but every live trace reported zero Job Episodes and zero Operations.

**Evidence:** GIANTS exposed active AI state without a usable current-job object. The missing admission evidence then collapsed to `COMPLETE_SUPPORTABLE_SPACE_EXHAUSTED` rather than bounded observation.

**Disproved hypotheses:** a current-job pointer would be available; unavailable admission evidence would automatically survive to Decision.

**Implementation response:** use positive native AI activity onset as an observational episode source identity, preserve undistinguished termination as unavailable evidence, and expose Candidate/verdict diagnostics. Architecture is unchanged.

## 2026-08-04 — Exact Rejoin Overreach removed

**Observation:** v4.6.57–v4.6.59 froze at restoration or authority-transition boundaries, while the longer refuge-driving phases generally completed.

**Interpretation:** OuttaMyWay was reconstructing exact pose, working configuration and native continuation even though its cooperative responsibility ended once the displaced worker could safely return to GIANTS.

**Discovery:** **Exact Rejoin Overreach**.

**Decision:** Introduce the **Native Handover Envelope** and **Control-to-Awareness Reversion**. Return approximately, relinquish all temporary authority, and observe GIANTS through normal Situation Assessment.

**Implementation hypothesis:** Reducing turns, phase-owned speeds, restoration states and engine-state mutations may also reduce CPU/physics stress, but the performance mechanism remains unproven.

**Reserved observation:** The other passing vehicle and its later manoeuvring will be considered after this handover hypothesis is tested.

## 2026-08-04 — Permission hold semantics disproved

**Observation:** v4.6.58 reached rejoin and returned configuration authority, but Condor remained fully compact for the complete 25-second restoration window. The game froze at the transition into restoration failure.

**Disproved hypothesis:** The Traffic Permission Gate can remain active while GIANTS progresses its native configuration state machine.

**Discovery:** **Constraint Semantics Mismatch** — the gate was described as a movement constraint, but its actual boundary includes field-worker progression.

**Implementation hypothesis:** A verified zero-speed cruise lease can constrain translation while the permission gate is released and GIANTS restores configuration. Failure must remain inert rather than repeatedly toggling configuration.

**Reserved architecture question:** unrestricted GIANTS handback remains deliberately undecided.



## v4.6.59 translation-authority amendment

Reality disproved the assumption that the Traffic Permission Gate constrains translation only. ADR-0008 separates configuration authority, translation authority and field-worker progression authority. Delegated restoration now enables GIANTS field-worker progression under a separate reversible zero-speed translation lease. Terminal restoration failure is inert. A future unrestricted return-to-GIANTS architecture remains explicitly undecided.

## 2026-08-04 — Bundled handback disproved; native restoration delegated

**Observation:** Two v4.6.57 runs froze at the same visible point: Condor was almost fully unfolded after rejoin. Logs showed the controller bundling final configuration actuation, permission release and `aiContinue` on the first deployed sample. Initial motion occurred, but stable continuation did not.

**Disproved hypothesis:** Native Reposition can safely own position, configuration restoration, authority release and handback as one synchronous completion boundary.

**Architecture amendment:** Accept **Restoration Obligation–Actuation Separation**. The Commitment owns the restored postcondition. GIANTS may own configuration actuation while OuttaMyWay retains movement authority and observes the result.

**Implementation hypothesis:** GIANTS will progress its working-configuration state machine while the permission gate prevents translation. Once terminal configuration is stable, movement can be released without another immediate resume request.

**Next evidence:** manually-started TS015. A failed test is useful: no configuration motion disproves restoration-under-hold; another freeze disproves the revised sequencing; successful stable deployment and continuation supports the delegation model.

## 2026-08-04 — ADR-0006 implemented as a generic active vertical slice

**Baseline:** owner-declared canonical v4.6.56 (`9e2ed98a89ba7ffb3babb7669abf26a8db52a5f04b97829900c1b0d4a44b8066`, Git `99ae108ca589a2930b562c19ae560d3ecf580426`).

**Implementation:** Activated one Observation → Future Space → Situation Assessment → Operational Picture → Decision → Commitment → bounded Control → Outcome Observation path. Added local manoeuvre sweeps, trajectory settlement, persistent Situation ID, Intent Epoch, Hold stopping-space assessment, Bounded Observation Contract enforcement, operational sufficiency, explicit Hold/Restore capabilities and Safe Release gating.

**Abstraction protection:** No Condor, Patriot, TS015 or TS016 identity appears in Future-Space or Decision policy. The recovered reposition controller is a bounded Control mechanism only, and its private TS015 post-passage speed guard is disabled.

**Implementation hypothesis:** Field-boundary evidence is required before moving continuation can be bounded. Future-Space geometry is deliberately conservative. Runtime validation may disprove its shape, horizon or admissibility consequences without invalidating ADR-0006 itself.

**Next evidence:** manually-started TS015, preserving complete log and direct visual observations. The run must show either coherent capability revision and Safe Release or a truthful unresolved failure.

## 2026-08-04 — Future-Space and Safe-Release contract recovered from v4.6.55

**Observation:** The first TS015 cooperative-passage Commitment completed through calculated refuge movement and observed GIANTS handback. Condor came to a confirmed stop as part of the reposition capability. A later speed Commitment completed at approximately 80 m because the pair was separating and constant-velocity conflict was excluded. Condor then entered its next GIANTS headland manoeuvre and turned into Patriot's path. A subsequent speed command was reported mechanically `EFFECTIVE` while distance and time-to-closest-approach continued to collapse until both workers were blocked.

**Disproved hypotheses:** Current kinematic clearance does not prove safe continuation. A mechanically effective Control capability does not prove that the governing Commitment purpose is being achieved. Completion of one capability does not complete persistent intent.

**Named discoveries:** **Transient Clearance**, **Capability Effectiveness–Operational Sufficiency Separation**, and **Capability Completion–Commitment Completion Separation**.

**Architecture recovery:** Promote Intent Expiry, Safe Release Point and Continuation Safety Horizon from Deferred to Accepted. Consolidate Persistent Situation Relevance and Commitment Preconditions as governing contracts. Define a Bounded Observation Contract so `CONTINUE_OBSERVATION` cannot become passive delay.

**Decision:** Stop the TS015 test/fix sequence. Record ADR-0006 before any more runtime change. The next implementation must be generic and must extend Future Space only through the next material local manoeuvre and trajectory settlement, preserving the permanent exclusion of general route planning.

**What was learned:** v4.6.53–v4.6.55 recovered useful mechanisms, but v4.6.55 shaped Decision around one fixture sequence. The failed run is valuable because it exposes the missing release contract rather than merely another late trigger.

## v4.6.50 — Architecture Recovery, not another behavioural patch

Temporary v4.6.44–v4.6.49 made considerable progress:

- persistent cruise authority physically regulated speed;
- temporal reserve and post-passage continuation preserved separation;
- observation ownership retained a relationship without immediate intervention;
- protected handoff preserved authority continuity;
- field-edge refuge viability rejected an unsafe lateral candidate.

The extended TS015 run then exposed a new collision: Condor reached a viable in-field refuge, but Patriot's subsequent GIANTS headland turn consumed that occupied refuge. This was not another request for a local threshold. It revealed that a reachable refuge can lose validity when the other assembly's Future Space changes.

The holistic audit found that the fixture-bounded controller had gradually become the place where observations were interpreted, actions chosen, commitments retained and commands executed. The repeated “one more fix” pattern was therefore named **Prototype Boundary Leakage** and **Assessment–Decision–Control Collapse**.

The project paused implementation and recovered the canonical architecture. Existing concepts already covered most of the observed needs:

- Situation Assessment awareness of the complete Field World;
- Operational Picture Knowledge;
- Situation Relevance;
- Future Space and Action Space;
- explicit constraints and representation fitness;
- continuing Commitment evaluation;
- Safe Release and continuation evidence.

Five named v4.3.8 labels lacked durable definitions. Each was challenged against necessity and ownership. All five were retired rather than preserved by invention.

The recovery also clarified that Option Preservation is not indecision. Decision always reaches a current conclusion. Continued unchanged operation or passive observation is one possible Decision, and its physical consequences must be evaluated. Small speed changes may become useful option-preserving augmentations, but only when purposeful, supported and proportionate.

v4.6.50 therefore returns to exact canonical v4.6.43 runtime behaviour while preserving all experimental evidence. This is a deliberate separation:

```text
discovery retained
implementation not promoted
```

The next implementation will be passive and traceable before it is behavioural.

## v4.6.43 — Two open conflicts, not one regression chain

The v4.6.42 TS015 run completed the entire primary cooperative sequence, including rearward-target orientation, rejoin, unfolding, GIANTS handback and successful encounter rearming. The previous Forward-Only Rejoin Singularity is resolved for the tested geometry.

The later collision is not evidence that the primary sequence failed. It repeats an already open class seen after earlier left-side 15 km/h TS015 work: both workers form a new headland encounter after the completed passage. The current admission model loses eligibility once both workers are manoeuvring. This is named **Headland Turn Overlap** and **Dual-Manoeuvre Admission Gap**.

The full TS016 continuation exposes a different boundary. Condor completes, remains physically relevant as a static obstacle, and Patriot blocks because the two-active-worker admission relationship ends. This is **Completion-Transition Control Gap** and belongs to single-worker obstacle navigation.

A useful distinction emerged: faster egress and ingress objectively increase separation, but a speed difference is not automatically the cause of a later encounter. Timing can change which encounter occurs without closing the architectural gap that allows it.

The candidate therefore closes the current evidence increment without pretending the operation-level success criterion has been reached. The next work begins with the active-active dual-manoeuvre encounter; the static-obstacle case remains separate.

## v4.6.42 — Forward-Only Rejoin Singularity

**Observation:** TS015 reached a calculated right-side refuge and confirmed passage. At rejoin start, the final target was approximately 31.50 m away and almost exactly 180 degrees behind Condor. The forward-only steering command preserved heading while target distance grew to approximately 213.94 m. OuttaMyWay timed out and held the vehicle; GIANTS handback had never occurred.

**Disproved hypothesis:** A direct world-space target is not sufficient input for a forward-only controller when that target lies in the rear singularity. Normalised local direction `(approximately 0,-1)` contains no stable turn choice.

**Discovery:** Name the defect **Forward-Only Rejoin Singularity**.

**Decision:** Add a separate Rejoin Orientation Phase only for rearward targets. Turn slowly and deterministically until the target enters the forward hemisphere, then use the established direct rejoin. Bound the orientation and add a target-progress watchdog so failed steering stops promptly.

**Protected scope:** Do not address the separate Completion-Transition Control Gap in this increment. Do not change admission, calculated refuge selection, passage confirmation or successful forward-target rejoin behaviour.

**Validation target:** Repeat TS015 unchanged and require orientation, decreasing target distance, rejoin completion, deployment and GIANTS handback.

## v4.6.41 — Pair-Latch Suppression and Encounter Rearming

**Observation:** The first encounter in the full TS016 continuation passed. More than three minutes later the predictor reported a new straight head-on at 91.99 m, `tCPA=6.61 s`, `dCPA=6.38 m` and 177.4 degrees opposition. The controller was idle, yet admission remained `LATCHED`; both workers continued to collision.

**Disproved hypothesis:** One commitment per continuously active entity pair is not a safe approximation of one commitment per encounter.

**Discovery:** Name the defect **Pair-Latch Suppression**. A persistent pair may create multiple independent Future-Space convergences during one Operation.

**Decision:** Introduce **Encounter Rearming** after successful passage and handback. Require sustained clear separation before removing the completed encounter record. Preserve a failed encounter latch until explicit recovery.

**Implementation:** Admission now assigns encounter numbers, receives the controller outcome, enters `REARMING` after success, confirms 35 m separation plus three seconds outside the conflict envelope, then accepts a later encounter from the same pair. The refuge and passage mechanism is unchanged.

**Validation target:** Repeat full TS016 continuation. Require encounter 1 success, `ENCOUNTER_REARMED`, then a later encounter 2 candidate/commitment before collision.

## v4.6.40 — TS016 turn-exit admission correction

**Observation:** The v4.6.39 straight fixture completed cleanly with calculated role, side and movement authority. The repeatable TS016 altered-start fixture failed because Condor was still manoeuvring when conflict became relevant. Straight-only admission waited until both workers settled and committed at only `tCPA=1.98 s`; contact preceded refuge movement.

**Implementation:** Add an immediate TS016 path only when one worker is straight-working, the other manoeuvring, headings are at least 150 degrees opposed, closure is positive, `tCPA` is within 12 s and `dCPA` within 14 m. Lane crossing alone remains insufficient. The straight-working worker is the early Yield role, after which confirmed-stop refuge recalculation remains authoritative. Add a 6.0 s commitment-time floor and one-shot `FAILED_HELD` reporting.

**Validation target:** Repeat TS016 and require early Patriot hold, calculated refuge completion before contact, successful passage/rejoin/handback and no repeated failure log.

## v4.6.39 — Calculated refuge becomes Control authority

The v4.6.38 runtime evidence showed that the calculated refuge was available while Control still used fixed fixture values. This increment removes that contradiction. Prototype 19 selects the role at admission, recalculates both sides from the confirmed stop, and supplies calculated lateral and rearward movement to the existing controller. Local formula tests showed dynamic role selection, fresh stop-position targets and no 28/12 fallback leakage. Runtime FS25 evidence remains pending.

## v4.6.38 — Prototype 19 evidence defects corrected in one batch

**Observation:** The first runtime run validated the four-candidate observation boundary and preserved the fixed actuator, but it exposed two evidence-integrity defects. Prototype 19 logged the admission event in a different clock domain from Prototype 18, and the 28 m fixture actuator seed appeared as candidate movement even when Patriot compact geometry was unavailable.

**Discoveries:** Name these defects **Assessment Epoch Clock-Domain Drift** and **Fixture-Distance Leakage**. Both are instrumentation defects: neither changed Control in the run, but either could corrupt later Authority Migration if left in place.

**Implementation:** Prototype 19 now logs Observer-relative time, derives its iterative starting estimate from Progress extent plus policy margin, and suppresses target and movement outputs when required geometry is unavailable. Candidate logs now expose `solution`, `solutionReason`, coverage, extent kind and solved/unavailable matrix counts.

**Generic evidence extension:** If compact Yield geometry is unavailable but a live AI working marker exists, the marker half-width is retained as a **Conservative Working-Width Upper Bound**. It is deliberately labelled `LOW_CONSERVATIVE`, `COMPACT_UNPROVEN_CURRENT_WORKING_UPPER_BOUND` and `CONSERVATIVE_UPPER_BOUND`. It is a numerical evidence operand, not compact-geometry proof.

**Protected boundary:** The live Condor/right/28 m/12 m actuator remains unchanged and isolated from Prototype 19. Runtime repetition is still required before Authority Migration.

## v4.6.37 — Prototype 19 as an evidence bridge to Authority Migration

**Observation:** The fixed actuator can now be admitted automatically, but its role, refuge side and movement remain fixture constants. Removing all four constants before observing the alternative candidate geometry would combine too many untested assumptions.

**Decision:** Build a temporary observer-only Prototype 19. At one admission epoch, calculate both lateral refuges for both possible Yield-role assignments and log viability before preference. Preserve missing field, obstacle and swept-path evidence as `UNKNOWN`.

**Implementation:** Added `ShadowRefugeCandidateComparison.lua`. It derives the proposed Progress corridor frame from live heading, calculates both signed lateral candidates, estimates side-facing extents, places a shadow refuge on the policy-required line, and records lateral/rearward/total travel. The live Condor/right/28 m/12 m actuator remains unchanged.

**Protected lesson:** A shadow calculation is valuable only when it cannot silently become authority. The module is isolated behind a protected call and explicitly emits `authority=false`, `action=none`.

**Mandatory next phase:** Once runtime evidence is understood, begin **Authority Migration** so fixed role, side and distances do not become permanent architecture.

## v4.6.36 — Preferred Refuge Is Not Required Refuge

**Observation:** In a symmetric 36 m / 36 m head-on encounter on one centre line, either lateral refuge can be viable when its path and pose are clear. In an offset 36 m / 5 m encounter, one side can require materially less movement, but the longer opposite-side route remains necessary when the preferred side is unavailable.

**Disproven hypothesis:** v4.6.35 treated one Outboard Refuge Region per proposed Yield Entity as mandatory and classified the opposite side as a different manoeuvre. The examples show that this restriction excludes valid solutions.

**Discovery:** Name the corrected relationship **Preferred Refuge Is Not Required Refuge**.

**Decision:** Refuge selection is clearance-first and cost-second. Both world-space lateral sides may be candidates. Clear transition and refuge evidence determine validity; movement and interruption cost compare only candidates that remain viable.

**Boundary protected:** Human left/right labels and Approach-Side Provenance do not select a side. Relative assembly geometry and environmental feasibility assess both. Prototype 19 remains observer-only and grants no Control authority.


## v4.6.35 — Outboard Refuge Drift corrected before implementation

**Observation:** The v4.6.34 continuation wording described four candidate alternatives by pairing two possible Yield Entities with two refuge directions. Earlier accepted decisions already required Unilateral Sidestep to move the Yield Entity outward without crossing the protected-side boundary, avoiding later cross-lane recovery.

**Discovery:** Name the inconsistency **Outboard Refuge Drift**. Later summary wording had restored false left/right symmetry after the architecture had selected outboard-only refuge semantics.

**Correction:** The first Shadow Candidate Comparison contains two role alternatives, not four side alternatives: Condor yields into Condor's Outboard Refuge Region, or Patriot yields into Patriot's Outboard Refuge Region. Each proposed Yield Entity owns one relevant outboard refuge family.

**Boundary protected:** An unavailable outboard refuge invalidates or leaves unresolved that Yield-role candidate. It does not authorise a cross-lane substitute. World-space derivation remains unresolved and must be defined before implementation.

**Implementation:** Documentation and version metadata only; no runtime behaviour changed.

## 2026-07-31 — v4.6.32 implements Evidence Separation

**Implementation:** Shadow Clearance Calculation now derives physical contact solely from opposing Facing Clearance Extents. The four explicit operational margins form a separate `policyMarginBudget`, which is then added to the physical threshold. Stage logs, continuous samples, console status and final summary no longer use the ambiguous combined `requiredSeparation` and `reserve` fields.

**Protected architecture:** Condor/Patriot fixture roles, manual trigger, forced side, known inverted labels, 28 m lateral / 12 m rearward actuator and `authority=false` remain unchanged.

**Validation state:** Static inspection supports an isolated Knowledge-output change. Runtime behaviour and expected 25.37 m / +2.01 m physical versus 29.12 m / -1.74 m policy evidence still require repetition in FS25.

**Deferred publication item:** Mod Description Drift remains for Publication Readiness Review; the prototype-specific `modDesc.xml` wording is deliberately not changed during this evidence increment.

## 2026-07-31 — TS017-B closes the fixture calculation and separates physical from policy clearance

**Observation:** The provider resolved all 13 current Condor physical identities and origins, but none yielded usable runtime bounds. Live compact origin projection was 4.87 m; adding the explicit 2.50 m unresolved allowance produced a 7.37 m Facing Clearance Extent. Patriot supplied 18.00 m from its live 36 m working marker.

**Validated result:** The resulting 25.37 m physical contact threshold predicts approximately 3.93 m overlap for the failed 21.44 m run and approximately 2.01 m clearance for the successful 27.38 m run. The pre-estimate threshold was 25.85 m, only 0.48 m above the live threshold. The actuator again completed passage, rejoin, handback and the full observation horizon.

**Discovery:** Origin Coverage Is Not Bound Coverage. Identity and origin completeness do not establish usable physical bounds or Coverage Closure.

**Discovery:** Physical Clearance Is Not Policy Clearance. Adding the provisional 3.75 m margin budget produced a 29.12 m policy target and negative policy reserve even though the assemblies visibly passed.

**Decision:** Preserve the tested actuator and provider. Before any automation, separate physical threshold/reserve from policy target/reserve in the calculation and logs. Treat both as observer-only Knowledge.

**What was disproved:** One combined `requiredReferenceSeparation` and `reserve` field is not sufficient to communicate both physical geometry evidence and safety-policy evidence.

## v4.6.30 — Clearance Calculation Closure investigation

TS017-A repeated the successful passage but produced no derived separation because Condor had no accepted compact extent. This disproved the assumption that generic physical-envelope or size metadata would close both operands. The calculator's refusal to fabricate a value passed.

The missing architectural concept is named **Facing Extent Provider**: a representation adapter that supplies a one-sided extent with source, coverage and confidence. TS017-B implements an exact-fixture provider using the retained Condor current-physical identity catalogue. Runtime bounds are preferred; live origins plus an explicit allowance remain a lower-confidence fallback. Control remains unchanged.

## 2026-07-31 — Forward Route Reacquisition and explicit retreat

**Observation:** TS013 completed hold, folding, direct displacement, rejoin, deployment and handback without ending the Condor job. Giants corrected slightly and continued forward instead of returning to the intervention point.

**Discovery:** Name this **Forward Route Reacquisition**. The realised rearward/outward egress followed by a slightly forward rejoin appeared smoother than returning to the original hold point.

**Decision:** Make the retreat explicit from the confirmed stopped pose. Test Condor's native 15 km/h repositioning pace and overlap folding with egress after a clearly labelled Egress-Ready Candidate. Enable live collision-node pose logging and separate all phase timings.

**Uncertainty preserved:** Full folding took about 15.5 seconds in TS013, but the time before safe egress is unknown. `foldAnimTime=0.15` is not accepted geometry authority.

## 2026-07-31 — From Static Obstacle Conversion to Unilateral Sidestep

**Observation:** Prototype 14 held Condor without ending its job, but Patriot did not route around it. Both workers blocked. Route-control videos then showed that ordinary waiting positions can be consumed by continuing Giants work, with the sequence dependent on legitimate AI start state.

**Disproved hypothesis:** Holding one worker after settled head-on confidence would preserve enough options for the other to pass and later support safe release.

**Discovery:** Spatial Commitment precedes collision urgency. After Opposed Next-Pass Claim, an in-lane hold can only create Static Obstacle Conversion.

**Architectural decision:** Permit Minimum Necessary Authority through Bounded Route Deviation. Investigate a single-worker Unilateral Sidestep before a live pair: compact, move outward without crossing the protected side, rejoin and return to Giants.

**Implementation:** Added Prototype 15, manual left/right arming, exclusive direct-drive boundary, fixture-calibrated dogleg, provisional centreline fence, fail-closed restoration and post-handoff Route Reassertion evidence.

**Uncertainty:** Full Behavioural Assembly swept-envelope compliance, general minimum clearance, automatic side choice and two-worker passage remain unproven.

## 2026-07-30 — Prototype 14 implementation: delay before resolution

**Decision:** Implement one exclusive Information-Gaining Delay rather than another layer of Scope architecture or a complete traffic policy.

**Implementation:** `SingleWorkerDelayController` consumes Prototype 02 `ESTABLISHED`, tracks worker admission order and applies a native permission-gate hold to the later-admitted worker. Runtime returns immediately after this controller so legacy control paths remain dormant. Automatic release is deliberately absent.

**Validation target:** TS012-A starts Patriot first and Condor second. The controller should hold Condor, preserve its Giants AI job and reveal whether Patriot can clear or turn without collision.

**Protected boundary:** `CLEAR` prediction is not release authority. Safe Release Candidate evidence is logged only after positive continuation, completed turn and sustained divergence; the hold remains.

## 2026-07-30 — TS011 reversed-order baseline

**Observation:** TS011-A (Condor first) and TS011-B (Patriot first) both ended in head-on collision and stable blockage under FS25 1.21.1.0 build b40785 and OuttaMyWay v4.6.23.

**Evidence:** Prototype 02 established the conflict before contact. The current `CRITICAL` predictor preceded first blockage by approximately 7.7 seconds in TS011-A and 7.2 seconds in TS011-B.

**Named discovery:** Start-Order-Independent Conflict.

**Named discovery:** Evidence-Bounded Intervention Window.

**Disproved assumption:** Predictor clearance is not encounter resolution. In both runs the predictor returned `CLEAR` after collision because closing ceased while both workers remained blocked.

**Consequence:** Additional passive repetition is not justified. The next test must change exactly one thing: hold one worker during the established evidence window.

## 2026-07-30 — Test roles become evidence questions, not a machine checklist

**Baseline:** exact canonical v4.6.22, SHA-256 `b636bafdd59afcedba133b2dac65a19286f3dc980734eac63b612c0aaf3a941f`.

**Initial concern:** eight proposed test roles appeared likely to require eight substantial field tests. The investigation instead showed that the roles were hypotheses about architectural coverage. Essential Evidence Horizon, Coverage Compression and fixture reuse reduced cost without reducing evidential discipline.

**TS005:** the DEUTZ-FAHR 6135 C RVshift with ECO-CULTIVATOR 300 completed the reference cultivation fixture and established the ordinary positive baseline.

**TS006 and TS007:** EVION 450 + VARIO 620 completed wheat harvesting and generated a straw fixture. The base-game VB 3190 baler then worked manually but could not admit a native AI job. This named Fixture-Generation Evidence, Admission-Rejection Boundary and Material-Chain Control Boundary.

**TS008:** the initial harvest-ready crop state produced a brief post-admission rejection before current instrumentation sampled the worker. Changing the state to `green big` allowed the 36 m Condor to unfold, work, manoeuvre and complete. The paired result separated Agronomic State Gate from Control Eligibility and exposed Transient Admission Visibility Gap. Field 4 also proved that a Reference Field Fixture is not a Universal Field Fixture.

**TR-04 review:** the original Material-Chain and Secondary-Activity wording risked combine/offloading scope bleed. It was narrowed to Material-Chain Boundary. TS006 + TS007 satisfy the role as a boundary pair without adding forage-wagon or AI-baler-mod scope.

**TR-03 review:** Specialist Agricultural Operation was too vague. It became Non-Tractor Operational Assembly, satisfied by the combine-header configuration and supported by the integrated self-propelled Condor.

**TS009:** the Landini REX 4 GT + DISC-O-Vigne V cultivated manually between three painted olive rows, but Giants refused AI work with `Grapes and olives not supported`. The positive permanent-row hypothesis was disproved before route reasoning began. Native Crop-System Exclusion retired TR-05 rather than forcing another exotic crop into the plan.

**Owner correction:** Persistent/Regrowing Lifecycle did not test an OuttaMyWay responsibility. This named Agronomic Proxy Drift. Grass remained useful only as a fixture for an uncovered geometry concept.

**TS010:** the DEUTZ-FAHR 6135 C RVshift + SaMASZ XT 390 worked with the mower offset to the tractor's right. Giants kept the mower at the field edge and used a spiral route. This established Offset Working Envelope, Trajectory–Work Displacement and Work-Envelope-Anchored Routing. Full completion was unnecessary once repeated work and manoeuvre cycles satisfied the claim.

**Containment challenge:** the coarse current envelope repeatedly reported non-containment during visually valid offset mowing. Valid Boundary Straddling is preserved as a provisional interpretation; the evidence decreases confidence in strict coarse-rectangle enforcement but does not yet replace Full-Envelope Field Containment.

**Baseline change:** TS005–TS009 ran under FS25 1.21.0.0. TS010 revealed an unnoticed update to 1.21.1.0 build b40785. No separate change description was available. The project now uses Runtime Baseline Governance, Patch Impact Watch, evidence currency states and a Patch Sentinel Set.

**Repository validation discovery:** independent policy-path validation exposed an inherited active-policy entry for absent `docs/ENGINEERING_CONTRACT.md`. The active documentation map already routes readers to current governance and archived compatibility history, so the stale policy entry was removed without altering the archive.

**Closure:** Scope Overlay Test-Role Calibration is complete. Future tests start from a named architecture or implementation claim. The project does not accumulate machine coverage for its own sake.

## 2026-07-28 — Scope Overlay becomes independent contextual knowledge

**Baseline:** exact canonical v4.6.21, SHA-256 `a905d5b419f6f3e75c46224aa7b218d453b7ffb8c3409844a85260a964d12361`.

**Observation:** the complete Stage 2C catalogue was intentionally retained even though only some Giants base-game job configurations are useful primary control candidates. Catalogue reduction would confuse semantic evidence with support selection.

**Discovery:** Catalogue Membership–Support Eligibility Separation. The Scope Overlay is not one static classification attached to every definition; its four claims can have different subjects, evidence and lifetimes.

**Capability evidence:** a Giants job can be admitted, start the tractor engine and then abort when the worker reaches an unsupported working unit. This disproved the assumption that job startup establishes controllability. The capability subject is the complete Giants AI job configuration, and the Capability Confirmation Point requires demonstrated working behaviour.

**Control boundary:** Control Eligibility Profile guides support and test selection. Runtime Control Admissibility remains downstream. Known ineligibility becomes a Control Exclusion Constraint while representation persists: Observe Broadly, Control Narrowly.

**Testing discovery:** Control ineligibility does not imply test ineligibility. Bounded Negative Test Candidates can prove exclusion, persistent representation, obstacle reasoning, downstream refusal and player communication without expanding support.

**Participation discovery:** physical presence and Operational Influence do not establish Operation Participation. Participation is a temporal functional relationship; a completed or unrelated Entity may remain obstacle-relevant without becoming an Operation member.

**Assembly discovery:** the useful architectural unit is the Behavioural Assembly, not a copied attachment or visual hierarchy. Membership and relevance are separate. Under the present baseline, implement detachment is player-mediated and triggers relationship reassessment.

**Obstacle discovery:** obstacle is not a permanent semantic type. Obstacle Relevance is contextual, directional and assessed against another Entity or Operation demand, including Future Space.

**Operation-level discovery:** repeatedly diverting around a detached implement can succeed locally while Giants repeatedly returns to the blocked unfinished work. This named Local Resolution–Operational Resolution Separation, Persistent Spatial Constraint, Denied Work Space, Recurring Commitment Loop and Completion Blocker. Player escalation may be necessary when the required physical change is outside OuttaMyWay authority.

**Decision:** consolidate the architecture only. Defer machine-readable states, assignment tables, runtime evidence sources, test matrix, UI policy and Prototype 13B implementation.

## 2026-07-26 — Physical representation becomes a portfolio with explicit closure

**Observation:** exact source-to-runtime collision identity is valuable but cannot be the sole gate for useful occupancy. Condor is naturally T-shaped in plan view; a full rectangle wastes large empty corners, while a Convex Planar Envelope offers an intermediate conservative fallback. Tractor–cultivator combinations also change plan-view shape through articulation.

**Owner challenge:** the word `only` initially risked excluding fallback when exact identity evidence was incomplete. The architecture was corrected to separate identity validity from occupancy continuity.

**Decisions:** accept Planar Collision Semantics, the Physical Representation Portfolio, Convex Planar Envelope, Job-Scoped Representation Catalogue, Pose Realisation, family-based heterogeneous composition, Coverage Closure and Clearance Unresolved. Defer Envelope Anchor Selection and sweep construction.

**Reality correction:** folded and working are the principal stable AI states; deployment is stationary configuration motion. Turning sweep cannot assume midpoint rotation because steering mode changes kinematics. Deployment and manoeuvre sweep remain distinct.

**TS004 evidence:** Tiger 8 MT uses multiple physics components for wing articulation; TopDown 600 uses internally animated collision-bearing descendants inside one physics component. Mapping and dimension evidence vary by asset. This prevents Condor-specific structure from becoming universal architecture.

**Release-process discovery:** native Linux packaging exposed four historical CRLF release files. v4.6.16 establishes repository-native LF through `.gitattributes` and normalises those files.

## 2026-07-25 — Prototype 12 establishes the Physical Assembly Search Boundary

**Observation:** Condor appeared as one integrated runtime member. S 416 + Tiger 8 MT and 8RX 410 + TopDown 600 each appeared as two distinct runtime objects with separate assets, roots and hierarchies connected by one attachment edge.

**Discovery:** Physical Assembly Search Boundary. The operational worker identifies the Operation participant; the current assembly identifies the member set; geometry identity must then be resolved independently inside each member.

**Replication:** the attached structure transferred across different manufacturers, mappings, component counts and hierarchy sizes. This is Attached-Assembly Replication, not proof that all vehicle classes use the same attachment APIs.

**Disproved hypothesis:** the first attached worker stall was not simple inability to pull the implement. The same S 416 + Tiger 8 MT combination cultivated manually.

**Discovery:** Working-State Motion Divergence. GIANTS reported active `WORKING` while measured motion remained effectively zero for at least fifteen seconds. The later 8RX + TopDown fixture sustained normal work, separating AI progression from assembly discovery.

**Decision:** record Prototype 12 as strongly supported, disable the completed diagnostic, and discuss Member-Local Physical Resolution before Prototype 13 implementation.

## 2026-07-25 — Physical assembly precedes collision identity

**Observation:** a base-game Valtra S 416 with Horsch Tiger 8 MT unfolded as a two-asset working combination while the tractor remained the AI worker identity.

**Discovery:** Operational Entity–Physical Assembly Separation. Condor's integrated hierarchy is not a universal ownership pattern.

**Diagnostic finding:** Fixture-Absence Warning Noise. A Condor-specific probe repeatedly warned during an intentionally different fixture. Completed fixture-specific probes should be inactive during generic contrast experiments.

**Decision:** implement passive Physical Assembly Discovery before general collision-node resolution. Record continuous movement because declared `WORKING` state alone did not demonstrate sustained progress in the contrast log.

**Implementation:** v4.6.14 adds recursive protected attachment discovery, per-member asset/runtime-root evidence, attachment edges, hierarchy summaries and motion samples.

## 2026-07-25 — Prototype 10 disproves root-scoped coverage; selector semantics become the next question

**Observation:** all 29 source-catalogued physical asset IDs and one nonphysical control returned the same vehicle-root sphere: centre `0.000000,2.253981,1.032253`, radius `4.363019 m`. The derived span remained an unchanged `8.726038 m` cube through folded, transition and deployed states.

**Disproved hypothesis:** `vehicle.rootNode + source asset shapeId` does not select arbitrary descendant geometry.

**Named discovery:** Root-Entity Sphere Aliasing.

**Named discovery:** Self-Coherence Blind Spot. Geometry-local, general and world bounds agreed perfectly while describing the wrong Entity; self-coherence is not intended-identity evidence.

**Named gap:** Source-to-Runtime Shape Resolution. Source collision identity and runtime geometry ownership require an explicit bridge.

**Preserved result:** Prototype 09 remains strongly supported because its distinct component spheres came from distinct resolved runtime collision nodes. The source asset `shapeId` remains provenance metadata until its selector role is understood.

**Next hypothesis:** Runtime Entity Geometry Authority. On a resolved runtime node, zero, own and sibling known shape IDs should be invariant while different runtime nodes return differentiated component geometry; vehicle-root known-ID calls should remain aliased.

**Implementation:** v4.6.13 removes the disproved Prototype 10 probe from active code and adds a passive selector matrix across all eight resolved boom nodes plus a root control, with representative lifecycle checks.

**Validation state:** candidate implementation prepared; no Prototype 11 runtime conclusion accepted yet.

## 2026-07-25 — Prototype 09 succeeds; coverage becomes the next question

**Observation:** all eight active Condor 36 m boom shapes returned finite geometry/general/world spheres through a complete fold lifecycle. Component-local centres and radii were stable at logged precision, `usesGeometry=true`, and transformed centres matched engine world centres.

**Disproved concern:** the shape-sphere family was not blocked by the Runtime Geometry Access Gap. Prototype 07's negative result remains valid only for its tested box-oriented route.

**Named discovery:** Component-Local Sphere Bridge. Source collision identity plus a correctly resolved runtime collision node and live pose produce trustworthy conservative component-local sphere extent. Prototype 10 later showed that the asset `shapeId` is not an independent vehicle-root descendant selector.

**Named limitation:** Sphere Precision Tax. The deployed eight-sphere union produced plausible cross-boom span but several metres of thickness around thin components. Truth and operational utility remain separate gates.

**Diagnostic finding:** Successful-Call Error Residue. Lua's `valid and nil or "invalid-return"` expression emitted false error text on successful calls. The correction is carried forward in v4.6.13.

**Historical next hypothesis:** complete physical-shape coverage was tested through the apparently coherent vehicle-root + asset-shape-ID route. Prototype 10 subsequently disproved that selector interpretation.

**Implementation:** Prototype 10 expands runtime data to all 29 physical compound-child identities, classifies eight active boom, five permanent controls and sixteen inactive alternatives, probes one nonphysical geometry control, and emits non-authoritative diagnostic sphere unions.

**Validation outcome:** the noncanonical v4.6.12 runtime run disproved the root-scoped descendant-selection route; see the newer entry above.

## 2026-07-25 — Prototype 09: test the bridge before decoding the mesh

**Observation:** the official FS25 Shape reference documents geometry-local, general shape-local and world bounding spheres addressed by `entityId + shapeId`. Prototype 07 did not test this sphere family; its negative result remains valid for the attempted route.

**Named discovery:** Shape-Bound Capability Blind Spot.

**Candidate concept:** Shape-ID Geometry Bridge. Prototype 08B already knows the physical asset `shapeId`; Prototype 08A already resolves the corresponding live collision node. A protected runtime experiment can test whether these identities jointly expose component-local extent.

**Architectural separation:** Extent Truth–Utility Separation. Even a correct sphere may be too coarse for a tapered boom and cannot be promoted directly into a final Physical Occupancy Envelope.

**Hypothesis:** all eight identified physical Condor boom shapes expose finite non-zero local geometry spheres that remain stable through `FOLDED -> TRANSITION -> DEPLOYED`, while transformed general shape-bound centres remain coherent with engine world bounds.

**Implementation:** Prototype 09 consumes 08 state, tests four identity/frame routes once, selects no route from partial evidence, then records local drift and world coherence throughout articulation. Permanent chassis and nonphysical render controls are not source-catalogued in the canonical runtime catalogue and are explicitly deferred rather than invented.

**Validation state:** candidate implementation prepared; no runtime conclusion accepted yet. No envelope, containment, sweep or Control exists.

## v4.6.10 — Model-Derived Geometry Investigation

**Archival candidate learning:** v4.6.9 loaded successfully but observed no Condor because Prototype 08A read only `g_currentMission.vehicles`; TS001 showed that the authoritative population was available through `g_currentMission.vehicleSystem.vehicles`. This is named the **Diagnostic Enumeration Blind Spot**. v4.6.10 was rebuilt from v4.6.8 canonical and made enumeration explicit evidence before node resolution.

Asset inspection narrowed Runtime Geometry Access Gap into Collision Mesh Extraction Gap. Condor contains 29 physical compound-child shapes, with eight explicit collision nodes activated by the purchased 36 m folding configuration. TS001 and TS003 provide the same persistent Entity at opposite fold endpoints. Prototype 08 separates live node pose from offline mesh extent and refuses to confuse collision-node origin span with physical occupancy.

### Accepted validation result

Corrected TS001 reported `missionVehicles=0`, `vehicleSystemVehicles=54`, `uniqueRoots=53` and `condorCandidates=1`. Condor attached once; all eight named collision nodes resolved through I3D mappings; no no-match or missing-node event occurred.

The probe observed one complete lifecycle: folded at `foldAnimTime=1.0000`, transition beginning at approximately `t=8.3s`, and stable deployed pose at `foldAnimTime=0.0000` from approximately `t=25.4s`. Sixty-two pose samples showed continuous origin movement. Lateral origin span changed from approximately 2.8237 m folded to 30.2403 m deployed while Entity identity remained stable.

**Result:** Prototype 08A is strongly supported. Runtime collision-node identity and live pose are available even though runtime collision-mesh bounds are not.

Prototype 08B correctly predicted the principal folded and deployed lateral spans and established physical collision identity, hierarchy and configuration membership. It did not reconstruct every live endpoint transform exactly: the two folded `Col04` longitudinal positions were materially wrong and the stable deployed endpoint retained approximately 0.55 m RMS difference. Offline pose is therefore diagnostic only; live transforms own pose truth.

**Owner observation:** Condor has four boom sections per side and visually tapers toward the outer tips. This is named **Segmented Tapered Occupancy** as a Condor-supported compound pattern, with an explicit caution that other foldable implements may use different geometry and must be independently discovered.

**Remaining gap:** local mesh extents inside `.i3d.shapes`. No Physical Occupancy Envelope, containment or Control claim is justified yet.

## 2026-07-25 — Prototype 07: physical extent is not working width

**Observation:** Condor and Patriot can pass safely in adjacent opposing lanes. Their physical boom extent, agricultural working width and active GIANTS collision geometry therefore cannot be assumed equal.

**Named discovery:** Geometry Domain Separation, with the narrower Physical–Agronomic Separation between physical occupancy and working effect.

**Hypothesis:** GIANTS-accessible component, rigid-body, collision-mask and bounding evidence can be aggregated across a complete vehicle–implement Entity into a conservative current Physical Occupancy Envelope with explicit provenance and confidence.

**Invariant:** No Silent Under-Approximation. Missing or partial evidence remains visible; working width is never promoted into physical geometry merely to obtain a convenient answer.

**Implementation boundary:** Prototype 07 inventories engine capabilities, refreshes model-hierarchy evidence infrequently, samples discovered bounds, records Entity-local compound-envelope changes and reports pair clearance separately from AI marker width. It remains observer-only and performs no containment or projected-sweep decision.

**Validation sequence:** begin with known Condor/Patriot fixtures to establish available runtime evidence and adjacent-lane clearance. Only then create a dedicated folded/unfolded or articulated fixture if the discovered sources justify it.

### Validation result

TS003 disproved the tested direct-bound retrieval route. The runtime exposed
`getRigidBodyType`, but not the attempted shape, local or world bounding functions or
collision-mask query. Condor and Patriot each scanned 800 nodes with truncation and
produced zero bounded nodes, zero physics-bound nodes, `coverage=NONE` and
`confidence=UNKNOWN`. Approximately 337 s of heartbeats retained two Entities but no
physical envelope, pair clearance or envelope-change event.

**Named discovery:** Runtime Geometry Access Gap. GIANTS' internal physics truth is not
necessarily disclosed as queryable complete-Entity bounds through the mod Lua
boundary.

**Invariant result:** No Silent Under-Approximation passed. The 36 m working-marker
widths remained separate agronomic evidence and were never promoted into physical
geometry.

**Secondary observation:** Patriot's final 76.99 s sweeping manoeuvre, near miss and
observed reverse deadlock against parked Condor showed that Field World identity and
Situation Relevance can be known while current clearance and swept occupancy remain
unknown. This is Retained Entity, Missing Spatial Truth.

**Result:** the tested Direct Geometry Retrieval route is unsupported. The Physical
Occupancy Envelope remains an architectural requirement; the next cycle must compare
alternative evidence sources rather than add fallbacks or containment mathematics.

## 2026-07-25 — Prototype 06: membership is a transition, not repeated state

**Observation:** Prototype 05 repeated membership-change evidence for an unchanged false state and did not explicitly reclassify an existing relationship when a participant changed operational role.

**Implementation discovery:** Lua `previous ~= nil and previous.operational or nil` cannot preserve `false`; it converts false to nil. The defect made every later false sample appear different from the previous state.

**Hypothesis:** preserving the actual prior Boolean and including participant classification revisions in relation identity will produce one membership transition and one explicit relationship reclassification without losing the retained Field World Entity.

### Validation result

TS002 passed as the negative control: Condor remained non-operational from save load,
no false membership or reclassification event appeared, and relevance to parked
Condor still emerged during Patriot's terminal approach.

TS003 supplied the repeatable live transition after substantial setup to control
GIANTS restart repositioning. At approximately `t=225.5s`, Condor completed while
Patriot remained active. Exactly one latched membership transition, one
identity-preserving relationship reclassification and one retirement of the obsolete
reverse directional relation were recorded. Condor was not removed and rediscovered,
and no unchanged event repeated.

Several near-miss relevance episodes and GIANTS blocked warnings cleared without
deadlock. The observation reinforces that blocked state is a symptom rather than an
architectural conclusion.

**Result:** Prototype 06 is strongly supported.

**Boundary:** this is an observation correction only. Exact geometry, static-object identity, containment and active hold/release remain separate work.

## 2026-07-24 — Prototype 05: the field polygon defines a bounded physical world

**Recovered architecture:** The maximum collision geometry of the complete vehicle–implement combination, including projected swept geometry, must remain wholly inside the field polygon. A boom must never sweep partially outside the boundary. External hedges, trees, ditches and pylons are therefore outside normal obstacle scope. The hedges removed from TS001 were a workaround for missing containment, not an acceptable requirement.

**Classification discovery:** Field World Membership, Operational Membership and Situation Relevance answer different questions. A vehicle can leave active AI participation without leaving the bounded Field World, and relevance may change while both membership states remain unchanged.

**Hypothesis:** Situation Assessment can retain vehicle Field World Members independently of active GIANTS AI membership and identify when inactive, completed or player-controlled vehicles become relevant to an active Operation member's plausible trajectory.

**Implementation:** Prototype 05 discovers the GIANTS field polygon in observer-only mode, enumerates all mission vehicles, groups attached implements with their root vehicle, applies a conservative current-envelope intersection test and records dynamic closest-approach relevance. It also retains field-island counts and native static-collision signals.

### Validation result

The vehicle hypothesis is strongly supported. Variable TS001 runs retained stopped/player-controlled Patriot and completed Condor after Operational Membership ended, but manual interventions changed the later encounters. TS002 was therefore created as a repeatable fixture with completed Condor already parked and Patriot still active.

At `t=6.2s`, TS002 discovered Condor as `NON_OPERATION_VEHICLE` and Patriot as the sole `OPERATION_MEMBER`. The relation began `NOT_RELEVANT`, became decisively `RELEVANT` at `t=241.7s` during Patriot's terminal approach and ended with Patriot becoming blocked at `t=290.7s` in the observed collision. The Field World retained both vehicles throughout.

### Learning

- Field World Membership is a physical observation boundary, not an AI-job list.
- Operational Membership and Situation Relevance are independent and dynamic.
- The finishing-position encounter is a general occupied-future-space case, not terminal-specific architecture.
- TS002 is a useful pre-existing non-operational vehicle regression fixture.
- Exact static-object identity and exact Full-Envelope Field Containment remain unvalidated.

### Instrumentation findings

Operational Membership change events repeated without a real state change. Existing relationships also require explicit reclassification when a live worker completes. Conservative rectangle containment candidates were noisy and must remain separate from exact collision-envelope knowledge.

**Boundary:** No hold, release, containment or vehicle-control behaviour was enabled. Active Information-Gaining Delay remains deferred.

## 2026-07-24 — Prototype 04: local intent expires; physical relevance does not

**Hypothesis:** Situation Assessment can represent locally revealed intent as a bounded epoch, expire it when a new manoeuvre begins, and classify an observed release retrospectively against the Progress Entity's next repositioning event.

### Validation result

The local-intent lifecycle is strongly supported. Condor's settled work segments produced bounded intent epochs. Each epoch expired immediately when Condor began another manoeuvre, and worker detachment also expired previously valid intent.

The test decisively disproved the stronger interpretation that a current settled lane establishes a safe release. Patriot was manually stopped at the candidate wait position and left active AI-worker observation. Condor later began a repositioning manoeuvre directly toward the physically parked Patriot and became blocked until the player moved Patriot.

### Instrumentation boundary exposed

Prototype 04 retained the trial while Patriot was absent, but could not observe Patriot's physical position after the AI job ended. It therefore saw Condor's continuation uncertainty and blocked state but could not identify the parked vehicle as the conflict participant or emit a valid unsafe-release classification.

After manual relocation, Patriot restarted and a later continuation remained clear. That result does not validate the original hold position because the world state had been changed by the player.

### Terminal evidence

Condor eventually completed and left active-worker observation. Patriot later became blocked when GIANTS attempted to use the same finishing position already occupied by completed Condor. Physical relevance therefore persisted after Operational Membership ended.

### Learning

- **Local Intent Horizon** is bounded immediate-path knowledge, not route knowledge.
- **Intent Expiry** at a new manoeuvre is supported.
- **Safe Release Point** remains unresolved.
- A continuation horizon is only meaningful when all physically relevant participants remain observable.
- The active-worker observer is insufficient for the next architectural question.

The agreed next substantive increment will recover Full-Envelope Field Containment and test Field World observation independently of Operational Membership. Those concepts are not implemented by v4.6.5.

## 2026-07-24 — Prototype 03: preserving options while intent emerges

**Observation:** Condor began manoeuvring first; Patriot began its own turn before Condor's resulting lane was fully revealed. Both then settled into opposite ends of the same lane and collided.

**Hypothesis:** Situation Assessment can identify a Candidate Option Preservation Window before conflict establishment by observing manoeuvre ordering, a Progress Entity, an Intent Revelation Point and remaining Response Margin.

**Discovery:** Waiting can be an Information-Gaining Delay rather than mere indecision. Its purpose is to preserve alternatives while Reality supplies better knowledge.

**Invariant:** Never hold all relevant moving participants for an Information-Gaining Delay. Doing so suppresses the evidence required to complete the wait and creates Observation Deadlock. At least one Progress Entity must remain able to move.

**Implementation boundary:** Prototype 03 records passive evidence only. It does not prove that a hold would prevent collision, select which Entity should wait, or implement Control.

### Validation result

The unchanged TS001 run strongly supported the hypothesis. The real candidate window opened when Patriot began manoeuvring before Condor's trajectory settled. Condor's intent reached the diagnostic revelation point while Patriot remained approximately 56% through its turn and travelling at about 15 km/h. Conflict establishment occurred approximately 12 s later. After the provisional stopping-time estimate and exposed safety buffer, approximately 7.42 s of conservative temporal margin remained.

The player independently observed that Patriot still had time to wait after Condor was established in the lane. This is evidence that the eventual head-on collision was not yet inevitable when useful local knowledge became available.

**Instrumentation discoveries:** stationary startup states produced an unrelated candidate window, and the exhaustion-candidate event repeated after exhaustion. These are named Startup Manoeuvre Contamination and Exhaustion Event Repetition. They are diagnostic defects, not evidence against the real window.

### Follow-up observation

The player manually stopped Patriot at the apparent wait position. This abandoned Patriot's GIANTS AI job. Condor initially completed the lane and moved away. After Patriot restarted and entered its lane, Condor performed another repositioning turn across Patriot's path and created a later crossing conflict.

### Disproved assumption

A revealed current lane is not sufficient evidence for safe release. The simple snake-like lane model did not predict Condor's continuation. The original conflict was deferred or transformed rather than conclusively resolved.

The result is qualified by **Job Restart Perturbation**, because abandoning and restarting GIANTS AI may change route state. Nevertheless, it establishes that local trajectory settlement must not be treated as complete route intent.

### Emerging boundary

The evidence suggests a **Local Intent Horizon** that expires when a new manoeuvre begins, and a later **Safe Release Point** that must account for the Progress Entity's foreseeable continuation. A sequence of linked conflicts may form an **Encounter Chain**. These names remain future hypotheses; none is accepted by this canonicalisation.

## v4.6.3 — Conflict Formation Window and Confidence Evidence

### Observation

Prototype 01 detected the eventual head-on conflict early and rejected an earlier harmless head-on pass. During the later encounter, projected closest separation changed sharply while Condor and Patriot performed overlapping manoeuvres, then remained near zero after the manoeuvres settled.

### Interpretation

The evidence is consistent with a **Sequential Manoeuvre Conflict** rather than a simple fault assignment: one manoeuvre established a future trajectory and the later overlapping manoeuvre completed the shared collision trajectory.

The interval of changing projections is named the **Conflict Formation Window**. A projected intersection inside this window is not automatically stable Current Situation knowledge.

### Hypothesis

Trajectory Settlement and relationship-level prediction persistence may allow Situation Assessment to distinguish a transient projection from an established plausible conflict.

### Implementation boundary

Prototype 02 records heading and speed stability, positive-conflict persistence, dCPA spread, Conflict Zone drift and tCPA countdown consistency. It adds no Decision, Commitment or Control behaviour. Every threshold and state label remains provisional and visible in the log.

### Validation intent

The unchanged TS001 encounter supplies a harmless control case, a forming interval, a stable projected conflict and—if allowed to finish—an encounter outcome. Success or failure will determine whether Trajectory Settlement and Conflict Confidence describe real architectural responsibilities.

### Validation result

The complete unchanged TS001 run strongly supported the hypothesis. The earlier harmless head-on pass remained `CLEAR`; the later encounter entered `FORMING` while a trajectory and the projected Conflict Zone were still unstable, then entered `ESTABLISHED` at approximately 266.5 m separation and about 18.5 s before both workers became blocked. The player observed no further material direction change after settlement and confirmed a head-on collision.

The run also disproved the provisional post-conflict lifecycle. Collision-induced stopping removed the future trajectory intersection, causing `ESTABLISHED → DECAYING → CLEARED` while both workers remained physically blocked.

**Projection Clearance Fallacy:** disappearance of a predicted future conflict does not prove that the real-world conflict has ended; it may instead have become present unresolved Reality.

The evidence suggests a missing **Conflict Realisation** boundary. This discovery must be consolidated through a later single-hypothesis increment rather than patched by renaming states or tuning thresholds. No new concept is accepted by this canonicalisation.

## v4.6.2 — Prototype 01 and the Passive Boundary Ordering Gap

### Observation

The existing TS001 save contains two native GIANTS AI workers whose routes ultimately converge head-on. This provides a natural observation fixture for testing whether Situation Assessment can identify conflict relevance before immediate physical conflict.

Review of the v4.6.1 runtime found that Traffic Manager v2 was updated before the `AI_EXPLORER_ONLY` return. The configuration described the build as observer-only, but the execution order did not make that boundary authoritative.

### Disproved hypothesis

Setting `AI_EXPLORER_ONLY = true` was not, by itself, sufficient to guarantee passive behaviour when a control-capable consumer executed before the guard.

### Discovery

**Passive Boundary Ordering Gap:** a declared passive mode is not an execution boundary unless every decision and control consumer lies beyond the guard. Architectural intent must be reflected by call ordering as well as configuration.

### Prototype hypothesis

Situation Assessment can detect a **Conflict Emergence Point** before immediate conflict by observing position, heading, speed, closing rate and predicted closest approach. `Conflict Relevance Transition` and `Conflict Emergence Point` remain Deferred until evidence shows a stable boundary.

### Implementation

Prototype 01 adds a read-only Observer consumer that records raw pair evidence, provisional stage transitions, closest-approach estimates and the thresholds used. Traffic Manager v2 is disabled, the observer-only return is moved before control consumers, and the probe disables itself if the passive configuration is not satisfied.

### Validation

The first unchanged TS001 run supported the hypothesis. The log reconstructed an earlier harmless head-on pass with approximately 72 m projected closest separation and a later projected conflict. The later `Conflict Emergence Point` was recorded at 318.38 m separation, 29.66 s projected time to closest approach and 1.98 m projected closest separation.

The player exited before collision, so final encounter outcome and the provisional immediate-conflict state were not captured. The run nevertheless answered Prototype 01's single question because conflict relevance was identified well before immediate physical conflict. Changing closest-approach estimates during manoeuvring remain evidence to consolidate before the next hypothesis; no new architectural concept is accepted by v4.6.2.

## v4.6.1 — Engineering Intent became the resilience boundary

### Observations

- Direct repository editing by the engineering assistant was unavailable and had become a repeated workflow dependency.
- A declarative JSON handoff and local `python -m rrs evolve` run produced the v4.6.0 candidate and evidence packages without assistant-side repository modification.
- After the canonical baseline was deliberately rebuilt to include committed RRS decisions, the previous handoff failed its fingerprint check rather than applying to the changed package.
- Regenerating the handoff against the observed baseline fingerprint produced a passing candidate. Independent owner review accepted that exact candidate as canonical.
- Synchronising the accepted contents into Git, committing and pushing ended with the branch aligned to its remote and the working tree clean.

### Discoveries

- **Engineering Intent Boundary:** declarative intent, not direct file manipulation, is the durable collaboration boundary between consolidation and local repository execution.
- **Fingerprint-Bound Engineering Intent:** a handoff is valid only for one exact Canonical Repository Snapshot; a changed baseline requires regenerated intent.
- **Git State Is Not Authority State:** uncommitted or locally edited files are not silently included when Candidate Production names a separate canonical ZIP baseline.
- **Post-Canonicalisation Synchronisation:** after the owner grants authority, the accepted package must be synchronised into Git so the engineering repository, remote and canonical package again describe the same content.
- A successful tool run supplies evidence but cannot replace independent review or the repository owner's Canonicalisation decision.

### Result

D-RRS-24 and D-RRS-25 formalise the two new boundaries. Engineering Intent, Canonical Repository Snapshot and Repository Transformation are promoted into the concept register and glossary. Dirty-working-tree awareness is recorded as a future usability improvement rather than a release blocker.

## v4.6.1 — Artifact Determinism Gap

### Observation

The first v4.6.1 handoff passed independently on Linux and Windows, but the candidate package SHA-256 values differed. File-by-file comparison showed the same 1,906 repository paths and identical extracted bytes for 1,905 files. `docs/RELEASE_MANIFEST_SHA256.txt` contained the same path/hash pairs in a different order, and ZIP metadata recorded different originating platforms.

### Disproved hypothesis

Fixed timestamps, permissions and file inclusion were not sufficient to make candidate packages byte-identical across platforms. Direct sorting of `Path` objects inherited platform-specific case ordering, and default ZIP metadata inherited the host platform. Deflated bytes also remained an unnecessary dependency on the host compression library.

### Discovery

**Artifact Determinism Gap:** repository payload equivalence can coexist with package-byte divergence. Semantic equivalence is valuable evidence but is weaker than Candidate Determinism when the package fingerprint is part of release identity.

### Decision and implementation

D-RRS-26 requires byte-identical candidate packages for the same exact snapshot and intent. Candidate Production now uses one relative POSIX-path ordering rule for inventory, manifest and packaging; sets ZIP origin and permissions explicitly; and stores entries without platform-dependent compression. Focused mixed-case, metadata and creation-order tests protect the invariant.

### Validation gate

The revised candidate must produce the same SHA-256 on Linux and Windows before v4.6.1 may be Canonicalised. Evidence packages may differ in run-specific provenance but must identify the same candidate and substantive findings.

### RRS Bootstrap Boundary

Implementation exposed one further constraint: the v4.6.0 RRS process cannot use `rrs.py` changes that exist only inside the v4.6.1 candidate it is currently packaging. The correction therefore runs from a separate fingerprinted RRS v1.2.0 bootstrap package while the canonical Git repository remains unchanged. The candidate contains the same implementation, and the evidence package copies the exact runner source used.

This is a discovered implementation boundary rather than a new authority state or approval path. It preserves the canonical baseline and still requires normal validation, independent review and explicit Canonicalisation.



## v4.5.8 — Seminar knowledge must be classified

Review of v4.5.4 showed that preserving a seminar transcript or summary is not sufficient repository mining. A seminar can produce accepted concepts, deferred vocabulary, rejected hypotheses, explicit decisions and glossary definitions simultaneously. Each output must be routed to the knowledge store that owns its lifecycle.

This discovery led to promotion of the Spaces family, explicit Reality/Knowledge and Time distinctions, demotion of Conflict Zone from root primitive to derived operational concept, and vocabulary updates. The seminar record remains the discovery history; it no longer carries the burden of being the only expression of the resulting architecture.

## v4.5.4 — Governance recovery and the architectural seminar series

The release was reconstructed from the last verified v4.5.3 baseline after a filename and embedded repository identity diverged. The incident exposed a missing separation between generation and verification. Repository Identity Check is now an independent post-package obligation.

The Governance Review demonstrated that continuity has two levels: engineers must not only navigate to knowledge, but predict where a class of knowledge belongs. The review also established that deferred decisions remain enduring engineering knowledge and that Repository Review feeds findings back into Architecture.

The complete seminar series began with Conflict Zone and progressed through Future Space, Action Space, Situation Space, Reality versus Knowledge and Time. The journal preserves decreasing confidence and rejected concepts as discoveries. Detailed evidence is recorded in `ARCHITECTURAL_SEMINARS.md`.

## v4.5.2 — Knowledge requires governance

A breadcrumb review of v4.5.0 disproved the hypothesis that clear document purposes alone make a self-sustaining knowledge system. The review found four classes of continuity risk: stale currency metadata, inconsistent naming, legacy documents with ambiguous authority, and first-class documents absent from navigation.

The resulting discovery is **Document Governance**: project knowledge must have explicit authority, currency, lifecycle and discoverability. A related discovery is **Engineering Continuity**: the repository must preserve enough understanding and reasoning for meaningful work to continue independently of previous conversations, participants or platforms.

Failures in repository review are treated as evidence. They improve the knowledge system rather than diminishing the release that exposed them.

This journal records durable engineering discoveries. It is not the current-status record and does not replace detailed test evidence or ADRs.

## v4.5.0 — The repository is a knowledge system

### Observations

- New chats create a real risk of losing reasoning that exists only in conversation.
- The repository contained overlapping engineering documents and a handover with two different baselines.
- Release tooling could verify embedded versions and changelog headings but could not verify repository coherence.
- Documentation aimed only at strangers would omit internal continuation knowledge; documentation aimed only at current collaborators would be difficult for contributors to interpret.

### Discoveries

- The development repository's primary operational responsibility is continuity across sessions.
- Continuity and contributor legibility are not opposing goals when knowledge has explicit ownership.
- Reality is the final architect; the repository is the source of project knowledge.
- Architecture should be the highest engineering document, not the largest.
- Current truth, evolving discoveries, decisions and history require distinct records.

### Result

v4.5.0 introduces an Engineering Architecture, Concept Register, Decision Log, Engineering Journal and repository verifier. Existing historical and driving-system documents remain available, but authority is now explicit.

## Earlier durable discoveries

- Facts must be separated from interpretations and decisions.
- A failed hypothesis is useful evidence.
- Repeated special cases may reveal a missing concept.
- Implementation examples can silently narrow generic architecture and must be challenged.
- Release consistency is an engineering property, not clerical polish.


## v4.5.8 Seminar Mining
- Continuous reasoning loop recognised.
- Election clarified as operational judgement.
- Plausibility filters possibilities before Probability.
- OuttaMyWay augments execution rather than replacing it.
- Ending augmentation is another judgement through the same reasoning loop.


# Seminar 06 Repository Mining (v4.5.8 Candidate)

Key discoveries:
- Continuous Operation vs Temporary Augmentation.
- Operational Picture matured into coherent operational understanding.
- Situation Assessment produces understanding, not decisions.
- Decision Engine consumes Operational Picture and determines whether augmentation is justified.
- Commitment Overlay remains a working hypothesis.

## v4.5.9 — Transition to Architectural Prototyping
The project reached sufficient architectural maturity to begin evidence-led prototyping. Prototypes exist to answer architectural questions rather than deliver production features.

## v4.6.17 — Prototype 13A implementation boundary

Discussion separated route discovery from identity authority. Prototype 13A therefore preserves explicit A/B/C candidates for three known fixture structures and asks the common evaluator to prove or disprove them. Diagnostic Lua fixture tables were selected over external configuration to avoid designing a schema before the required evidence is known.


## v4.6.18 — Prototype 13A evidence consolidation

Three manual fixture runs resolved all ten declared source shapes through A/B route convergence: four Condor boom shapes, two Tiger wing shapes and two TopDown folding-arm shapes, with the TS004 save exposing both cultivators in each run. All deliberately invalid C controls were rejected by the expected hierarchy-name or component-ownership evidence. No ambiguity, root alias, cross-source alias, geometry-unproven or unresolved result was observed. Handles remained stable through observed configuration motion.

A short AI-controlled TopDown run then disproved the diagnostic assumption that every interior `foldAnimTime` value means transition. GIANTS unfolded the TopDown, held it at `0.1250` while extended and raised for positioning, lowered toward `0.0000` for work, raised for repositioning, and lowered for the next pass. GIANTS `WORKING` phase began before the low endpoint was reached.

The resulting architecture separates deployment, vertical configuration, terrain contact, functional engagement and operational phase. Direct-soil-contact implements use realised terrain contact as part of functional capability; non-contact sprayer-boom height is a contrasting configuration dimension with no soil-contact requirement. Player-controlled behaviour was explicitly returned to scope: player assemblies matter only as possible obstacles to AI workers.

The v4.6.18 implementation changes Prototype 13A logging only. It records raw animation value, endpoint/interior region and observed changing/stable motion, with `semanticState=not-inferred`. No production resolver, footprint, closure, sweep, conflict or control behaviour is introduced.


## v4.6.20 — Prototype 13A Resolution Knowledge Consolidation Completion Patch

Prototype 13A ended with a clean evidence result: ten declared source shapes resolved through paired candidate convergence, ten invalid controls were rejected, runtime handles remained stable, and the v4.6.18 TopDown logger correction passed its focused AI cycle. The exact v4.6.18 candidate was declared canonical and reproduced twice from a clean Git commit with byte-identical SHA-256.

Consolidation exposed a terminology collision: `route` naturally means a worker's navigable field path. The architectural term is now **Resolution Path**. Legacy code and log labels remain unchanged for traceability.

The discussion separated a strict Resolution Contract from the best currently defensible Assessment Representation. Resolution establishes source/runtime identity, Entity-local geometry authority and current pose without implying complete inventory or coverage. Situation Assessment consumes a minimum sufficient defensible portfolio whose layers retain scope, provenance, validity, coverage, freshness, cost and permitted conclusions. Situation Assessment—not the representation itself—arbitrates fitness, assessment-relative staleness and refresh need.

Tiger and TopDown disproved implement-class structural homogeneity: both are cultivators but use materially different physics and hierarchy patterns. The failed universal hypothesis is retained as **Class as Context, Not Contract**.

Material change now has a dependency-scoped interpretation. Speed/heading changes invalidate future projection; articulation invalidates affected pose and footprint; attachment/configuration may invalidate the assembly catalogue; job completion invalidates role and motion expectation while preserving physical identity and obstacle relevance.

The repository also records the **GIANTS Completion Acceptance Boundary**. OuttaMyWay accepts the location and configuration in which GIANTS finishes, retains the completed assembly as a persistent non-member obstacle and leaves relocation to the player. Safe in-place folding is preserved as Deferred Post-Job Configuration Normalisation. Assessment Deadline Escalation is named and parked for a future Decision Engine session without selecting a failsafe.

Repository-owner review of the first consolidation package found that `docs/README.md` and `docs/CONCEPT_REGISTER.md` still claimed v4.6.16 review. That noncanonical v4.6.19 candidate was discarded rather than repaired in place. v4.6.20 was rebuilt from exact canonical v4.6.18, preserves the consolidation and advances only those two review markers because those documents were substantively reviewed. Older currency markers remain historical evidence rather than mechanical release counters.

No runtime resolution, footprint, assessment or control behaviour changed in v4.6.20. Future fixture selection may use data mining and should attempt to disprove the Resolution Contract across representation-diverse assets before Prototype 13B implementation.

## v4.6.21 — Base-Game Vehicle Semantic Catalogue Consolidation

The test-subject question expanded into a bounded evidence-mining exercise because the base-game vehicle directory is organised by manufacturer and GIANTS shop categories/types entangle purchase placement, implementation and capability.

Stage 1 reduced 17.61 GB and 10,695 files to a verified 1,365-file, 58.76 MB XML/I3D corpus. Stage 2A found 606 definitions, 41 inherited variants and three bundles. The inherited variants contained 516 arbitrary `<set>` and `<remove>` operations, disproving the assumption that a few projected fields constituted a complete effective definition. The result was renamed Raw Definition Evidence plus Selected-Field Inheritance Projection.

Readable localisation discovery found every required key only as a reference, not an authoritative definition. A disposable runtime probe resolved all 567 keys in English, but its negative control revealed that GIANTS returns a readable missing-key diagnostic. The probe's `RESOLVED` label for that control was wrong; independent consolidation preserved the real 567 results while naming the Negative-Control Classification Gap. The user corrected a separate probe packaging omission by adding the required root DDS icon and `iconFilename`.

Stage 2C rejected a flat replacement-category model. Semantic Profiles separated family, primary role, secondary roles and capabilities. The 147 function cohorts expanded to 170 review units, proving that Function Cohort Is an Anchor, Not a Decision.

The repository owner completed the human review despite the spreadsheet's high navigation cost. The review approved 166 units unchanged, amended two and exposed two missing roles. Consolidation added `LIQUID_TANK_TRAILER` and `FUEL_TRAILER`, propagated all decisions to 606 definitions and retained scope-related notes without converting them into scope decisions.

The experience produced a further process discovery: an exhaustive semantic taxonomy is not the architectural objective. Minimum Sufficient Semantic Resolution and Scope-Driven Review Depth preserve complete decision coverage while avoiding equal effort on assets that cannot change an OuttaMyWay conclusion.

No runtime behaviour changed. The next discussion is the Scope Overlay, followed by targeted rather than exhaustive structural challenge profiling.


## v4.6.28 — TS015-A clearance boundary and TS015-B calibration

**Observation:** Condor completed the validated retreating sidestep and reached refuge with approximately 164 m pair separation. Patriot continued under GIANTS control but became blocked when the vehicles were approximately 22.33 m centre-to-centre, despite its centre moving about 5.17 m beyond Condor's stop anchor.

**Disproved hypothesis:** A 22 m commanded lateral refuge is sufficient for complete Condor/Patriot assembly passage.

**Discovery:** Vehicle-Centre Passage Is Not Assembly Passage. Reference-point progress can occur while a wide attached or deployed assembly remains obstructed.

**Discovery:** Clearance Budget Underrun. The 22 m command produced approximately 21.44 m actual lateral displacement, leaving inadequate budget for Patriot's deployed half-width, Condor's compact width, alignment error and margin.

**Interpretation:** Egress time was not the limiting variable in this run. Condor reached refuge and compacted while Patriot remained far away; a temporary Patriot hold would not have created lateral clearance.

**Decision:** Preserve every validated TS015-A variable and test only a 28 m commanded lateral refuge in TS015-B.

**Uncertainty:** 28 m remains fixture calibration. Complete-assembly geometry authority and a general Minimum Sufficient Displacement calculation remain open.

## v4.6.27 — From solo sidestep to live passage

TS014 disproved the serial assumption that Condor must wait stationary for its complete 15.5-second fold. Useful egress began after roughly 3.2 seconds and continued while folding, reaching refuge at approximately Full Compact Configuration. This discovery is named Configuration-Latency Hiding.

The same evidence exposed Side-Semantic Inversion in the console harness. Rather than repair that label while adding Patriot, the experiment preserves the proven motion unchanged. Prototype 16 introduces exactly one new relationship: Patriot continues under GIANTS control while Condor yields.

The fixed three-second refuge dwell was no longer adequate once a second worker existed. It has been replaced with Positive Passage Evidence based on reference-relative position, separation, divergence and continued Progress movement. Diagnostic envelope clearance is logged, but video remains authoritative because Coverage Closure is unresolved.

A failed unprotected run is not wasted. It will quantify the boundary at which Egress Protection Hold becomes necessary.
## v4.6.29 — From fixture calibration to shadow-derived clearance

**Observation:** TS015-B succeeded with approximately 27.38 m actual lateral displacement where TS015-A failed at approximately 21.44 m. Patriot passed without blockage; Condor rejoined and both GIANTS jobs survived.

**Discovery:** The later headland convergence was a new conflict, not recurrence of the resolved working-pass encounter. Encounter Identity Is Not Entity-Pair Identity.

**Discovery:** Recording from Patriot's viewpoint did not change the fixed Condor Yield role. Perspective Is Not Role Authority.

**Architectural question:** Can required lateral separation be derived from opposing one-sided assembly extents and explicit margins rather than a hard-coded fixture distance?

**Decision:** Preserve the proven 28 m actuator and introduce observer-only Shadow Clearance Calculation. Log pre-estimate, live refuge, closest approach and passage-confirmed evidence before granting any automatic authority.

**Implementation:** Added a modular calculator using discovered envelope evidence when available, AI working-marker width and size-metadata pose models as labelled fallbacks. Margin components remain explicit hypotheses.

**Validation intent:** A failed calculation is valuable. It would identify a representation, pose or margin assumption that must change before role/side automation.



## v4.6.33 — From manual arming to Automatic Encounter Admission

**Observation:** The v4.6.32 repeat preserved the existing actuator while exposing +2.01 m physical reserve and -1.74 m policy reserve as separate, simultaneous facts. Passage, rejoin and handback completed with `failure=nil`.

**Correction retained:** Condor's later return toward its starting region was the already documented Split-Start Pass Recovery / Start-State-Dependent Coverage sequence, not a new discovery. Repository knowledge must be consulted before naming new concepts from an isolated log.

**Problem:** The validated fixture still depended on `otmTS015Arm right`. That command supplied encounter admission even though role, side and movement remained deliberately fixed.

**Named concepts:** Automatic Encounter Admission, Admission Candidate and Encounter Episode Latch.

**Decision:** Add a Decision-side gate requiring exactly two active workers, unique Condor/Patriot fixture identity, straight productive motion, no blockage or turn, opposed headings and sustained conflict-relevant constant-velocity projection. Confirm for three seconds, then admit one fixed commitment per continuous worker episode.

**Implementation boundary:** Remove and unregister `otmTS015Arm`. Preserve Condor Yield, Patriot `GIANTS_UNMODIFIED`, physical-right side, 28 m lateral / 12 m rearward movement and all Shadow Clearance output as `authority=false`.

**Validation hypothesis:** The established encounter should produce exactly one Admission Candidate and Commitment Point without console input, while harmless work, turns and later Split-Start recovery produce no activation. A failed gate is useful evidence about encounter admission, not a reason to alter the validated actuator.

## v4.6.34 — Automatic admission evidence accepted without generalising authority

**Observation:** TS018 required no OuttaMyWay console command. One Admission Candidate appeared at 316.78 m and one Commitment Point followed after 3.09 seconds at 277.92 m. The existing actuator completed passage, rejoin and the full handback observation with `failure=nil` and 27.40 m minimum pair separation.

**Observation:** The Encounter Episode Latch remained `LATCHED` during later known Split-Start Pass Recovery and no second automatic intervention occurred.

**Interpretation:** The manual command dependency has been removed for the exact fixture. The result supports Automatic Encounter Admission as a bounded Decision concept without supporting general Encounter identity or recurring commitments.

**Boundary protected:** Condor remained fixed Yield, Patriot remained `GIANTS_UNMODIFIED`, the physical-right side and 28 m / 12 m movement remained fixed, and all Shadow Clearance output remained `authority=false`. Closest physical reserve was +2.03 m while policy reserve was -1.72 m.

**Decision:** Consolidate this evidence in a no-behaviour-change release. Do not combine acceptance of automatic admission with role/side automation. The next activity is to define observer-only Shadow Candidate Comparison before implementation.

**Implementation:** Runtime files changed only for version metadata.


## v4.6.68 — Reassessment–Redirection Separation

**Observation:** The final v4.6.67 Condor refuge accepted five target revisions in about fourteen seconds, including four side changes. The vehicle visibly reversed direction three times.

**Interpretation:** Atomic transition viability solved partial mutation, but not Control coherence. The existing maxim that frequent reassessment does not justify frequent intervention lacked a physical movement boundary.

**Decision:** Represent refuge movement as bounded manoeuvre legs. Continue assessing during motion, defer ordinary replacement authority, settle, then reassess from current Reality. Failed hypotheses remain useful: longer hysteresis alone would suppress symptoms without defining when new movement authority is legitimate.


## v4.6.69 — Settled-Pose Frame Closure

**Observation:** v4.6.68 produced one decisive first refuge leg and one boundary-selected second leg. The second leg changed to `EGRESS`, then failed after 96 ms with `lateral=-1.32 m` before visible motion.

**Interpretation:** Decision had closed endpoint, path and time viability, but Control composed the replacement side with the original stop anchor. A complete replacement transition must include its starting frame, not only its endpoint.

**Decision:** Preserve the stable encounter anchor and add one leg-local Control anchor per movement. Candidate start coordinates are published as scalar evidence, Control rejects stale evidence, and target/side/anchor are committed together.

**Disproved hypothesis:** A settled movement boundary plus atomic target/side mutation was sufficient. The replacement frame's origin is also a Commitment Precondition.


## 2026-08-06 — v4.7.1 Observation and Job Episode Identity

**Decision applied:** preserve the canonical implementation sequence after v4.7.0 rather than combining Observation and Decision for convenience.

**Implementation:** added stable reference identity resolution, raw immutable Observation publication and canonical Job Episode admission/termination evidence handling.

**Validation:** offline fixtures prove that blockage, OuttaMyWay Hold, temporary inactivity and missing evidence preserve the admitted episode; player stop/takeover, GIANTS abort/fault, restart and replacement end it. Conflicting authoritative terminal evidence is rejected rather than resolved through an invented precedence rule.

**Behaviour:** no GIANTS listener and no Control authority.


## 2026-08-06 — v4.7.3 Deterministic Decision Boundary

**Implementation:** added complete sealed-fixture Candidate Action inventories, eleven mandatory Constraint Verdict families and deterministic Decision Records.

**Boundary protected:** Candidate generation cannot select; constraints cannot optimise; Decision cannot waive failed or unresolved verdicts, mutate Commitment lifecycle or issue Control.

**Validation:** negative fixtures reject incomplete Action Space evidence, Follower Owns Closure violations, inadequate Representation Fitness, incomplete Bounded Observation Contracts and invalid Effective Actuation Composition. Comparison cost is applied only after mandatory admissibility.

**Behaviour:** no GIANTS listener and no Control authority.
