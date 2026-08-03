# Changelog

## v4.6.50 — Architecture Recovery Candidate

- Begins from exact owner-declared canonical v4.6.43, SHA-256 `c312d74eedb20d800253247b784a992073a4cf44c0413588fa7f382b801cba4c`, Git commit `7dfb9f466566bbae1d47a2a54d66c08177fbae5b`.
- Makes no intentional runtime behavioural change from v4.6.43; code edits are limited to coherent version identity and candidate description.
- Does not promote temporary v4.6.44–v4.6.49 controller implementations.
- Incorporates the Architecture Compliance Audit of the active temporary TS015/TS016 path and records **Prototype Boundary Leakage**, **Assessment–Decision–Control Collapse**, **Architectural Constraint Enforcement Gap** and **Fragmented Commitment Ownership**.
- Incorporates the Canonical Knowledge and Constraint Recovery, preserving 36 recovered knowledge entries, 28 constraint entries, 23 temporary-discovery reconciliations and the 79-entry Hardcoded Authority Register as research evidence.
- Preserves experimental discoveries and validated capabilities while separating them from their temporary controller ownership.
- Retires the underdefined legacy terms **Relevance Envelope**, **Decision-Relevant World**, **Decision-Relevant Constraints** as a standalone Situation Assessment output, **Decision Readiness** and **Option Horizon** as a standalone object.
- Reaffirms that Situation Assessment remains aware of the complete bounded Field World and publishes Knowledge through the Operational Picture; Decision determines what available Knowledge is material to each candidate action or continuing Commitment.
- Strengthens constraint enforcement: every applicable architectural, environmental, representational and control constraint must support a candidate before authority is granted; Control cannot waive or bypass that conclusion.
- Refines **Sufficiency over Completeness** and promotes **Option Preservation**, **Earliest Sufficient Action**, **Minimum Effective Augmentation** and **Option-Preserving Augmentation** as Decision principles rather than new subsystems.
- Records that continued unchanged operation or passive observation is itself a Decision and must be assessed against its effect on the remaining Action Space.
- Establishes the next implementation boundary as a passive shadow architecture and authority-trace path before any further vehicle control migration.
- Proposed for owner review and Canonicalisation; this package does not declare itself canonical.

## v4.6.43 — Cooperative Passage Evidence Consolidation Candidate

- Begins from exact temporary v4.6.42, SHA-256 `205bb2f435c54bca5e280bffa64d3f1174b9ce4f77d31da23b1f35897d31f64e`; owner-declared canonical authority remains v4.6.36 until explicit Canonicalisation.
- Makes no intentional behavioural change from v4.6.42; implementation edits are limited to coherent version identity.
- Records successful v4.6.42 TS015 correction: `REJOIN_ORIENTING` completed in 7.10 s after 6.42 m travel, direct rejoin completed, Condor unfolded, GIANTS handback occurred and the encounter ended successfully before rearming.
- Confirms the earlier Forward-Only Rejoin Singularity is resolved for the tested right-side refuge geometry.
- Consolidates v4.6.39–v4.6.42 runtime support for calculated Yield role, calculated refuge side and movement, Patriot and Condor as Yield, both physical lateral refuge directions, TS016 manoeuvre-aware admission and successful same-pair encounter rearming.
- Records the later TS015 collision as the existing **Headland Turn Overlap / Dual-Manoeuvre Admission Gap**, not a newly introduced rejoin failure. Earlier left-side 15 km/h TS015 evidence had already exposed an unresolved later headland convergence.
- Records the separate TS016 **Completion-Transition Control Gap**: after Condor completed and became a relevant static obstacle, active-worker admission ended and Patriot received no obstacle-navigation Control.
- Distinguishes the fact that faster egress/ingress increases separation from the unproven hypothesis that the 5 km/h orientation phase caused the later TS015 collision.
- Establishes the next discovery sequence: address the active-active TS015 dual-manoeuvre encounter first; preserve completed-obstacle navigation as a separate architectural problem.
- Proposed for owner review and Canonicalisation; this package does not declare itself canonical.

## v4.6.42 — Temporary Rejoin Orientation Build

- Begins from temporary non-canonical v4.6.41, SHA-256 `82cf4c6dfb049bbe20574a412d71336339c40145d3263a164595b7f823be9b40`; owner-declared canonical authority remains v4.6.36.
- Records successful v4.6.41 TS016 continuation through two independent active-worker head-on encounters: encounter 1 rearmed and encounter 2 was admitted and escaped, validating the encounter-scoped lifecycle.
- Records the later Completion-Transition Control Gap separately: after Condor completed and became a static relevant obstacle, the active-worker pair ended and Patriot was not given obstacle-navigation Control.
- Records the v4.6.41 TS015 regression: Condor reached a calculated right-side refuge and confirmed passage, but the rejoin target lay almost exactly 180 degrees behind the vehicle. The forward-only command supplied no usable turn bias; target distance increased from approximately 31.50 m to 213.94 m before the 45 s timeout.
- Names the defect **Forward-Only Rejoin Singularity** and confirms GIANTS handback was never reached; the neighbouring-field excursion remained under OuttaMyWay movement authority.
- Adds a bounded `REJOIN_ORIENTING` phase only when the final rejoin target is outside the vehicle's forward hemisphere. It commands a low-speed deterministic turn, preferring the shortest target-bearing turn and using the inward centreline direction only at the near-180-degree singularity.
- Transitions to normal direct rejoin as soon as the target enters the forward hemisphere. Previously successful forward-target rejoins skip the new phase.
- Adds orientation time/travel limits and a direct-rejoin progress watchdog. Divergence or sustained absence of target-distance improvement stops and holds the vehicle rather than allowing a long uncontrolled departure.
- Preserves TS016 admission, straight-head-on admission, encounter rearming, calculated role/side/distance authority, passage evidence and GIANTS handback behaviour otherwise unchanged.
- Remains temporary and non-canonical pending repeatable TS015 runtime validation.

## v4.6.41 — Temporary Encounter Rearming Build

- Begins from temporary non-canonical v4.6.40, SHA-256 `db286ff876b825c23f93719ab62ebdd5995ba6316273032053d97851a2ee79aa`; owner-declared canonical authority remains v4.6.36.
- Records two successful first TS016 encounters with Patriot selected as Yield from live state, calculated right-hand refuges, successful passage and GIANTS handback.
- Records the continuation failure after the second successful first encounter: at approximately 91.99 m separation, `tCPA=6.61 s`, `dCPA=6.38 m` and 177.4 degrees opposition, both workers formed a later independent straight head-on while the controller was idle but Automatic Encounter Admission remained `LATCHED`; neither worker was selected and collision followed at approximately 10.39 m.
- Names the defect **Pair-Latch Suppression**: a successful commitment was latched to the entity pair rather than the completed encounter, contradicting **Encounter Identity Is Not Entity-Pair Identity**.
- Replaces the permanent pair latch with an encounter-scoped lifecycle: `COMMITTED -> REARMING -> REARMED` after successful Control completion.
- Rearms only after the pair remains at least the established 35 m passage-clear distance apart and outside the predicted conflict envelope for three continuous seconds; successful completion may also rearm after the pair is absent for the existing five-second episode-reset interval.
- Numbers successive pair encounters and propagates the encounter ID through admission, Control start, failure, completion, heartbeat and status logs.
- Keeps failed or unresolved encounters latched until explicit recovery; absence alone cannot silently rearm them.
- Preserves the validated TS016 admission path, straight-head-on confirmation, calculated role/side/lateral/rearward authority and confirmed-stop target recalculation unchanged.
- Remains temporary and non-canonical pending a full TS016 continuation run demonstrating encounter 1 rearming and encounter 2 intervention.

## v4.6.40 — Temporary TS016 Manoeuvre-Aware Admission Build

- Begins from temporary non-canonical v4.6.39, SHA-256 `55eb69b2a0334817aa7c40b30f20f88ab8bb147e3b950fe5900e38f402f5de4a`; owner-declared canonical authority remains v4.6.36.
- Records successful v4.6.39 calculated-refuge operation in the established straight head-on fixture: confirmed-stop Control used Condor Yield, a recalculated world-space side, 29.65 m lateral and 6.80 m rearward movement, with `failure=nil`, `fenceViolation=false`, `passageConfirmed=true` and 28.96 m minimum pair separation.
- Records repeatable TS016 failure after altered start positions: Condor crossed Patriot's lane during a headland manoeuvre, the original straight-working admission committed only at 26.90 m and `tCPA=1.98 s`, and contact occurred before a refuge could begin.
- Adds a TS016 manoeuvre-aware admission path for exactly one straight-working worker and one manoeuvring worker when headings are at least 150 degrees opposed, closure is positive, `tCPA` is 0–12 s and `dCPA` is at most 14 m.
- Treats lane crossing as warning evidence only. The TS016 path commits immediately only after live kinematics already predict the converging head-on conflict.
- Assigns the straight-working worker as the early Yield role for this bounded path; the choice is based on runtime state, not Condor/Patriot identity.
- Preserves confirmed-stop recalculation as authority for refuge side, lateral distance, rearward distance and target. No fixed role, side, 28 m or 12 m fallback is reintroduced.
- Adds a 6.0 s minimum `tCPA` commitment floor to both straight and TS016 admission paths so an already-expired intervention window is not accepted.
- Makes `FAILED_HELD` terminal reporting one-shot while preserving the stopped, compact, operator-cancelled failure state.
- Remains temporary and non-canonical pending repeatable TS016 runtime evidence.

## v4.6.39 — Temporary Calculated Refuge Authority Build

- Begins from temporary non-canonical v4.6.38, SHA-256 `47884281a377f340586db9d846c34958345403d09af1d329a338d1698d47b44f`; owner-declared canonical authority remains v4.6.36.
- Transfers Yield-role authority from the fixed Condor fixture role to the least-cost geometry-solved role/refuge candidate calculated from both role assignments and both lateral sides.
- Recalculates both refuge sides for the selected Yield worker from the confirmed stopped position before any egress target is issued.
- Replaces the fixed 28 m lateral command with calculated separation: Progress working-width extent + predicted compact Yield assembly facing extent + the existing clearance-margin budget, corrected for current offset and rearward side contribution.
- Replaces the fixed 12 m rearward command with calculated capture distance: complete compact-assembly forward extent + geometry/tracking margin, corrected for any forward component of lateral movement.
- Uses the larger available compact-model, metadata-body or longitudinal complete-envelope operand so vehicle-body length is not omitted from the rearward calculation.
- Retains the validated hold, fold, egress, passage confirmation, rejoin, deploy and GIANTS handback sequence.
- Removes normal-Control fallback to fixed Condor Yield, physical-right, 28 m lateral or 12 m rearward values. If calculation fails at admission or confirmed stop, the intervention is withheld or held safely rather than substituting fixture constants.
- Keeps the exact Condor/Patriot pair as the current admission fixture; runtime validation is required before this temporary build can be considered for Canonicalisation.

## v4.6.38 — Temporary Prototype 19 Evidence-Correction Batch

- Begins from temporary non-canonical v4.6.37, SHA-256 `747cc6b9a495faba4af52a4a511955ff6934b8a191c986925aca34912e5b46bc`; canonical implementation authority remains owner-declared v4.6.36.
- Records the first Prototype 19 runtime run under FS25 1.21.1.0 build b40785 revision 81824: one Assessment Epoch, four role/refuge candidates, unchanged fixed actuator and successful passage with `failure=nil`, `fenceViolation=false`, `passageConfirmed=true` and 27.38 m minimum pair separation.
- Records near-symmetric Condor-yields shadow travel of 29.66 m and 29.56 m, while both Patriot-yields candidates correctly lacked a compact Yield extent but incorrectly displayed the fixed 28 m actuator seed as apparent candidate movement.
- Names **Assessment Epoch Clock-Domain Drift** after Prototype 19 logged 132.1 s while Prototype 18 logged the same event at Observer-relative 107.4 s.
- Names **Fixture-Distance Leakage** after the fixed 28 m actuator value escaped an internal solver seed into unresolved candidate targets and costs.
- Aligns Prototype 19 with the Observer-relative clock while retaining a separate raw-time epoch identifier.
- Removes the fixed 28 m solver seed. Candidate iteration now begins from a geometry-derived Progress-extent-plus-policy estimate; missing required geometry emits `n/a` for target, proposed separation and every movement/cost field.
- Adds a generic, explicitly low-confidence **Conservative Working-Width Upper Bound**: when compact Yield geometry is unavailable but a live AI working marker exists, its half-width may supply a conservative numerical operand without claiming compact geometry or Control authority.
- Extends candidate logs with solution status, reason, coverage and extent-kind evidence, plus solved/unavailable matrix counts for direct same-fixture validation.
- Preserves the live Condor Yield / Patriot GIANTS Progress / physical-right / 28 m lateral / 12 m rearward actuator unchanged; every Prototype 19 result remains `authority=false`, `action=none`.
- Remains a temporary non-canonical evidence build. Runtime repetition is required before Authority Migration begins.
- Carries forward the deferred Publication Readiness Review item **Mod Description Drift**.

## v4.6.37 — Temporary Prototype 19 Shadow Refuge Candidate Comparison

- Begins from owner-declared canonical v4.6.36, SHA-256 `5ec12f0e16d817f5193264a7003a228ce7ef75b05963f24e05e4968404b7b781`, Git commit `9f9ff7bdbe59945ea8b6ebf789f374262cf0d8e8`.
- Implements one observer-only Assessment Epoch with four role/refuge candidates: both lateral sides for both fixture Yield-role propositions.
- Records independent `CLEAR`, `BLOCKED` and `UNKNOWN` evidence, aggregates to `VIABLE`, `REJECTED` or `UNRESOLVED`, and permits cost comparison only among `VIABLE` candidates.
- Preserves the live Condor Yield / Patriot GIANTS Progress / physical-right / 28 m lateral / 12 m rearward actuator unchanged.
- Declares Prototype 19 an evidence bridge to later Authority Migration and keeps v4.6.37 temporary and non-canonical.

## v4.6.36 — Clearance-First Refuge Selection Correction

- Begins from owner-declared canonical v4.6.35, SHA-256 `d178145a5953fe5d46b86b04502e635e5ad221dded6b34e6433338862b5d9c04`, Git commit `ca983514ba18b104a185fc13534992a10ff8ae62`.
- Records that equal-width coincident-centreline and unequal-width offset-centreline examples disprove the v4.6.35 outboard-only refuge restriction.
- Names the discovery **Preferred Refuge Is Not Required Refuge**.
- Establishes the governing rule: **Refuge selection is clearance-first and cost-second. Both lateral sides may be candidates. The preferred refuge is the least disruptive reachable refuge, but the opposite side remains valid when it is the only clear option.**
- Restores both world-space lateral sides as possible refuge candidates for each proposed Yield Entity; human left/right labels remain diagnostic conveniences rather than spatial authority.
- Separates validity from preference: path and refuge clearance determine whether a candidate survives; displacement and interruption cost compare only surviving candidates.
- Rejects Approach-Side Provenance as a required side-selection authority. Relative assembly geometry and environmental feasibility must assess both sides directly.
- Keeps Prototype 19 observer-only: no candidate may select a role, refuge, movement or Control action.
- Changes runtime code only for version metadata; automatic admission, the episode latch, fixed roles, fixed physical-right fixture movement, clearance authority and actuator behaviour remain unchanged.
- Carries forward the deferred Publication Readiness Review item **Mod Description Drift**.


## v4.6.35 — Outboard Refuge Drift Correction

- Begins from owner-declared canonical v4.6.34, SHA-256 `808eb15a388586feabe69a49ec81756300e042af133b070fbc4752c40016dacc`, Git commit `2ef9da18dc06df263e5705fa3d28b43c241fa0b8`.
- Corrects **Outboard Refuge Drift** introduced by the v4.6.34 continuation wording, which incorrectly reopened two symmetric refuge directions for each proposed Yield Entity.
- Reaffirms the accepted Retreating Unilateral Sidestep architecture: each proposed Yield Entity has one applicable **Outboard Refuge Region**, away from the Protected Progress Corridor and chosen to avoid later cross-lane recovery.
- Defines the first Shadow Candidate Comparison space as two Yield-role alternatives only: Condor yields into Condor's Outboard Refuge Region, or Patriot yields into Patriot's Outboard Refuge Region.
- States that an inboard or cross-lane refuge is not a peer alternative within Unilateral Sidestep; it would be a different intervention concept requiring separate architecture and evidence.
- Requires an unavailable outboard refuge to leave that Yield-role candidate `INVALIDATED` or `UNRESOLVED`; the system must not silently substitute a cross-lane manoeuvre.
- Preserves world-space direction authority: human left/right labels and vehicle-local axes remain test-harness conveniences, not refuge-selection semantics.
- Changes runtime code only for version metadata; automatic admission, the episode latch, fixed roles, fixed physical-right fixture movement, clearance authority and actuator behaviour remain unchanged.
- Carries forward the deferred Publication Readiness Review item **Mod Description Drift**.

## v4.6.34 — Automatic Admission Runtime Evidence Consolidation

- Begins from owner-declared canonical v4.6.33, SHA-256 `87b24a0865929cdeffa44b7c035a90586ba537f6823e0959cacea1e3e85e74b2`, Git commit `e3ca9d1bce58edaf4d245c609d03409d26fe1a22`.
- Records the successful TS018 runtime validation under FS25 1.21.1.0 build b40785 revision 81824.
- Confirms that no OuttaMyWay console command was entered or required: one `ADMISSION_CANDIDATE` appeared at 316.78 m, one `COMMITMENT_POINT` followed after 3.09 s of sustained evidence at 277.92 m, and the run started with `trigger=automatic-encounter-admission`.
- Confirms unchanged protected behaviour: Condor remained fixed Yield, Patriot remained `GIANTS_UNMODIFIED`, the physical-right fixture side remained fixed, and the actuator remained 28 m lateral / 12 m rearward.
- Records successful passage, rejoin and full 20-second GIANTS handback observation with `failure=nil`, `fenceViolation=false`, `passageConfirmed=true` and 27.40 m minimum pair separation.
- Confirms the Encounter Episode Latch remained `LATCHED` through the later known Split-Start Pass Recovery and prevented a second automatic activation.
- Reconfirms separate observer-only clearance evidence at closest approach: +2.03 m physical reserve and -1.72 m policy reserve, both `authority=false`.
- Closes Prototype 18's fixture-bounded admission hypothesis as supported without promoting it to general encounter identity, recurring commitment, role selection, side selection or movement authority.
- Sets the next architectural activity to define observer-only Shadow Candidate Comparison before any candidate may influence Control.
- Changes runtime code only for version metadata; no admission thresholds, role, side, movement, clearance authority or actuator behaviour changes.
- Carries forward the deferred Publication Readiness Review item **Mod Description Drift**.

## v4.6.33 — Fixture-Bounded Automatic Encounter Admission

- Begins from owner-declared canonical v4.6.32, SHA-256 `37cfd18d959cdbec43818265c7bcda789b2f3c7ce6df16210daec469b80206c7`.
- Records the v4.6.32 runtime repeat as a pass: physical threshold 25.37 m, physical reserve +2.01 m, policy budget 3.75 m, policy requirement 29.12 m, policy reserve -1.74 m, unchanged passage and `failure=nil`.
- Adds Prototype 18 / Automatic Encounter Admission as a Decision-side boundary between Situation Assessment evidence and the existing fixed Unilateral Sidestep actuator.
- Requires exactly two active workers resolving uniquely to Condor Yield and Patriot Progress, straight productive motion, no turn or blockage, opposed headings, positive closing, `tCPA` within 30 s and `dCPA` within 14 m for three continuous seconds.
- Adds an Encounter Episode Latch allowing one automatic commitment per continuous fixture episode.
- Disables and unregisters `otmTS015Arm`; normal validation requires no OuttaMyWay console command. `otmTS015Status` and `otmTS015Cancel` remain.
- Preserves the validated physical-right fixture side, fixed 28 m lateral / 12 m rearward actuator, Patriot `GIANTS_UNMODIFIED` and all Shadow Clearance output as `authority=false`.
- Treats later Split-Start Pass Recovery as established coverage behaviour and explicitly prevents it from re-arming the same continuous episode.
- Carries forward the deferred Publication Readiness Review item **Mod Description Drift**.

## v4.6.32 — Physical and Policy Clearance Evidence Separation

- Begins from exact canonical v4.6.31, SHA-256 `2f54f3a01aaf41bd6f9fd798ce672e1631dbb9e6c9e811ac4ce6acb0b676c25b`.
- Refactors observer-only Shadow Clearance Calculation to expose `physicalContactThreshold`, `physicalClearanceReserve`, `policyMarginBudget`, `policyRequiredSeparation` and `policyReserve` as distinct Knowledge fields.
- Defines physical contact threshold solely as the sum of opposing Facing Clearance Extents; no uncertainty, tracking, motion or policy margin is included in physical contact.
- Defines policy margin budget as the explicit 0.75 m geometry, 1.00 m tracking, 0.50 m motion and 1.50 m policy components, then adds that 3.75 m budget to the physical threshold.
- Replaces ambiguous combined `requiredSeparation`/`reserve` output in stage logs, continuous samples, console status and final summary with explicit physical and policy values.
- Preserves fixed Condor Yield and Patriot GIANTS Progress roles, manual arming, forced test side, known inverted console labels and the fixed 28 m lateral / 12 m rearward actuator.
- Keeps every derived field `authority=false`; no automatic trigger, role selection, side selection, movement derivation or Progress control is introduced.
- Requires repetition of the established manual Condor-yields run before the separated output is treated as empirically validated.
- Carries forward the deferred Publication Readiness Review item **Mod Description Drift**: `modDesc.xml` still describes the active prototype rather than the stable mod purpose.

## v4.6.31 — Unilateral Sidestep and Clearance Evidence Consolidation

- Begins from exact canonical v4.6.23, SHA-256 `87d3548463c2f77b81e26098ecd9faa7dd88b498e628f24b13582738e4766db3`, and consolidates the cumulative noncanonical Prototype 14–17 engineering increment.
- Preserves the empirically tested v4.6.30 runtime behaviour; Lua changes are version metadata only.
- Consolidates TS012 evidence that a native permission-gate hold preserves the GIANTS job but an in-lane hold causes Static Obstacle Conversion.
- Consolidates TS013 and TS014 as successful Retreating Unilateral Sidestep capability evidence, including Forward Route Reacquisition, the Condor Native Motion Envelope and Folding and Retreat Overlap.
- Consolidates TS015-A as a 21.44 m actual lateral clearance failure and TS015-B as a 27.38 m actual lateral complete-passage success with Patriot unmodified and both original GIANTS jobs preserved.
- Confirms Encounter Identity Is Not Entity-Pair Identity and Perspective Is Not Role Authority.
- Records TS017-A as correct unavailable-evidence handling and TS017-B as successful Clearance Calculation Closure for the exact Condor/Patriot fixture.
- Records that all 13 catalogued current Condor physical identities and origins resolved while none exposed usable runtime bounds through the tested APIs: **Origin Coverage Is Not Bound Coverage**.
- Consolidates the live compact Condor Facing Clearance Extent as 7.37 m from 4.87 m origin projection plus the explicit 2.50 m unresolved physical allowance.
- Separates the 25.37 m physical contact threshold from the 29.12 m provisional policy target: the successful run had approximately +2.01 m physical reserve but -1.74 m policy reserve.
- Records **Physical Clearance Is Not Policy Clearance** and accepts a separate physical/policy clearance evidence model before any derived movement or Decision authority.
- Leaves the 2.50 m allowance, 3.75 m policy-margin budget, fixed 28 m movement, role assignment, side selection and manual trigger as fixture-bounded hypotheses or test-harness constraints.
- Sets the next isolated increment to separate physical threshold/reserve from policy target/reserve in runtime output without changing the validated actuator or granting authority.

## v4.6.30 — TS017-B Facing Extent Provider

- Begins from exact canonical v4.6.23, SHA-256 `87d3548463c2f77b81e26098ecd9faa7dd88b498e628f24b13582738e4766db3`, through the cumulative noncanonical Prototype 14–17 release plan.
- Preserves the validated TS015-B actuator unchanged: Condor remains fixed Yield, Patriot remains fixed GIANTS Progress, manual arming and the 28 m lateral / 12 m rearward movement remain authoritative.
- Records TS017-A as an actuator regression pass and a safe calculation non-result: Patriot's 18 m facing extent resolved, while Condor's compact extent remained unavailable and the calculator correctly returned `n/a`.
- Adds `scripts/geometry/FacingExtentProvider.lua` as an observer-only representation adapter between physical evidence and Shadow Clearance Calculation.
- For the exact 36 m Condor fixture, resolves the 13 catalogued current physical collision identities and prefers live GIANTS runtime bounds projected from the AI steering-node reference.
- Falls back explicitly to live catalogued node origins plus a separately logged 2.50 m unresolved physical allowance when runtime bounds are incomplete.
- Adds a pre-manoeuvre fixture model based on repeated Prototype 08 folded-origin evidence (`x=-1.42..1.42 m`, `z=-5.21..-1.61 m`) plus the same explicit allowance.
- Logs coverage, expected/resolved/bounded/origin counts, bound APIs, origin extent, allowance, pose source and confidence at every shadow stage.
- Keeps every derived value `authority=false`; no automatic trigger, role selection, side selection or geometry-derived movement is introduced.

## v4.6.29 — TS017-A Shadow Clearance Calculation

- Retains exact canonical v4.6.23 as implementation authority and preserves the successful noncanonical TS015-B actuator unchanged.
- Records TS015-B as a complete fixture pass: approximately 27.38 m lateral and 11.56 m rearward Condor displacement, uninterrupted Patriot passage, Condor rejoin, GIANTS handback and both-job survival.
- Records **Encounter Identity Is Not Entity-Pair Identity**: the later headland convergence was a new conflict formed by new GIANTS intentions, not failure or recurrence of the resolved working-pass encounter.
- Records **Perspective Is Not Role Authority** after a Patriot-viewpoint repetition still correctly selected the hard-coded Condor Yield role.
- Adds Prototype 17 / TS017-A in observer-only Shadow Clearance Calculation mode.
- Keeps Condor as fixed Yield, Patriot as fixed unheld Progress, manual console arming, known inverted test-side labels and the actual 28 m Control target.
- Adds `scripts/geometry/ShadowClearanceCalculator.lua` to derive Progress Facing Clearance Extent, predicted/live compact Yield Facing Clearance Extent, explicit margin components, required reference separation and reserve.
- Logs pre-manoeuvre estimate, live refuge calculation, closest-approach snapshot, passage-confirmed snapshot and final shadow summary.
- Uses live discovered envelope evidence when available, then AI working-marker width and size-metadata pose models as explicitly labelled fallbacks.
- Gives shadow results no role, side, distance, trigger or Control authority. Automatic decision selection remains deferred until the calculation is empirically compared with the validated 28 m run.

## v4.6.28 — TS015-B Lateral Clearance Calibration

- Retains exact canonical v4.6.23 as implementation authority and carries forward the validated noncanonical Prototype 16 controller.
- Records TS015-A as a partial success: Condor completed the hold, folding/retreat overlap and refuge arrival while Patriot remained under GIANTS control, but the complete assemblies could not pass.
- Records **Vehicle-Centre Passage Is Not Assembly Passage**: Patriot's centre moved approximately 5.17 m beyond Condor's stop anchor while its deployed boom remained obstructed.
- Records **Clearance Budget Underrun**: the commanded 22 m lateral refuge produced approximately 21.44 m actual displacement and was insufficient for the deployed Patriot plus compact Condor assemblies.
- Distinguishes the result from an egress-time failure: Condor reached refuge with approximately 164 m pair separation and became fully compact while Patriot was still about 159 m away.
- Changes only the fixture-calibrated lateral target from 22 m to **28 m**; rearward offset, speeds, fold threshold, passage evidence, Progress authority and fail-closed behaviour remain unchanged.
- Keeps Patriot unheld so TS015-B tests one variable: whether six additional metres of lateral refuge creates complete physical passage.
- Retains the known inverted console-side labels as a documented test-harness defect.
- Leaves full-assembly clearance authority, automatic side choice, general displacement calculation and Egress Protection Hold unresolved.

## v4.6.27 — Unprotected Two-Worker Passage Probe

- Retains exact canonical v4.6.23 as implementation authority while extending the validated noncanonical TS014 movement evidence.
- Records TS014 as successful: 15 km/h retreat/rejoin, Folding and Retreat Overlap, Configuration-Latency Hiding, Forward Route Reacquisition and complete 20-second handoff observation.
- Records the known test-command Side-Semantic Inversion without changing the validated movement mapping.
- Adds Prototype 16 / TS015-A with fixed fixture roles: Condor yields and Patriot progresses.
- Leaves Patriot fully under GIANTS control; no Egress Protection Hold, steering or implement command is issued to the Progress Entity.
- Preserves the TS014 Condor waypoints, speeds, fold threshold and centreline fence unchanged.
- Replaces the fixed refuge dwell with positive passage evidence: Patriot must be behind the Condor stop anchor, at least 35 m separated, diverging, moving and unblocked for 1.5 seconds.
- Adds pair instrumentation for separation, longitudinal relation, divergence, blocked state, passage candidate/confirmation and minimum separation.
- Adds non-authoritative diagnostic complete-Entity envelope clearance while retaining uninterrupted video as the full-assembly evidence authority.
- Adds fail-closed handling for Progress blockage, worker loss, unexpected third workers, passage timeout and centreline-fence violation.
- Replaces TS014 console controls with `otmTS015Arm left|right`, `otmTS015Status` and `otmTS015Cancel`.
- Keeps the known inverted test labels for this run so introducing Patriot is the only behavioural change. Production side selection remains world-space and automatic.

## v4.6.26 — Retreating Sidestep Pace and Folding-Overlap Probe

- Retains exact canonical v4.6.23 as the implementation authority while extending the noncanonical v4.6.25 Prototype 15 candidate.
- Records TS013 as a successful single-worker Unilateral Sidestep capability result under FS25 1.21.1.0 build b40785 revision 81824.
- Records **Forward Route Reacquisition**: after rejoin and handback, Giants accepted the forward route position, made only a small lane correction and resumed useful work instead of returning to the intervention point.
- Formalises **Retreating Unilateral Sidestep** as the preferred first manoeuvre: the Yield Entity moves outward and rearward relative to its confirmed stopped pose, then rejoins slightly forward on the original centreline.
- Rebuilds the fixture waypoints from the confirmed stop pose rather than the earlier arming pose.
- Raises Condor egress and ingress cruise limits from the proving value of 6 km/h to its observed native 15 km/h repositioning pace, retaining a 6 km/h precision approach near each target.
- Separates Full Compact Configuration from an **Egress-Ready Candidate** and tests **Folding and Retreat Overlap** after `foldAnimTime >= 0.15`.
- Treats the 0.15 threshold as fixture-specific timing evidence only; it grants no complete Behavioural Assembly clearance authority.
- Enables Prototype 08 during TS014 so live Condor collision-node origin spans are recorded while folding and retreat overlap.
- Adds explicit timing marks and a final phase-duration summary for hold request, confirmed stop, first fold motion, egress-ready candidate, full compact, egress, rejoin, deployment and handback.
- Replaces TS013 console controls with `otmTS014Arm left|right`, `otmTS014Status` and `otmTS014Cancel`.
- Keeps TS014 exactly-one-worker and manually armed. It does not yet introduce a live Progress Entity, Egress Protection Hold, automatic side selection or full swept-envelope clearance.

## v4.6.25 — Unilateral Sidestep Route-Reassertion Probe

- Begins from exact canonical v4.6.23, SHA-256 `87d3548463c2f77b81e26098ecd9faa7dd88b498e628f24b13582738e4766db3`; noncanonical v4.6.24 remains experimental evidence, not a baseline authority.
- Consolidates TS012-A/B results: the permission gate successfully holds one Giants worker without ending its job, but an in-lane hold produces Static Obstacle Conversion and delayed stable blockage.
- Records Opposed Next-Pass Claim, Spatial Commitment Precedes Collision Urgency, Waiting-Position Closure, Start-State-Dependent Coverage and Coverage-Strategy Agnosticism.
- Records that the Patriot-only continuation immediately consumed Condor's parked location, while the Condor-only continuation reached Patriot after Split-Start Pass Recovery and a cross-field transition; the route mechanisms are not assumed symmetric.
- Establishes Minimum Necessary Authority, Bounded Route Deviation, Compact Transit Configuration, Protected Progress Corridor and Minimum Sufficient Displacement as the architectural basis for a forceful but bounded intervention.
- Selects **Unilateral Sidestep** as the first route-deviation hypothesis: one Progress Entity remains under Giants while one Yield Entity folds, moves outward without crossing the protected side boundary, rejoins and returns to Giants.
- Adds Prototype 15 / TS013 as a manually armed, exactly-one-worker route-reassertion probe.
- Adds console commands `otmTS013Arm left|right`, `otmTS013Status` and `otmTS013Cancel`.
- Uses a fixture-calibrated 22 m lateral offset, 12 m forward egress and 32 m forward rejoin; these values are experimental and not a general clearance algorithm.
- Adds a provisional original-lane centre-point fence and fails closed if the vehicle centre moves to the unselected side. Full Behavioural Assembly swept-envelope compliance remains unproven.
- Holds, stops work, raises and folds before movement; drives outward and rejoins under a narrow `AIVehicleUtil.driveToPoint` interception; unfolds, restores work state and requests Giants AI continuation.
- Observes post-handoff Route Reassertion for 20 seconds while retaining Giants ownership of the original job.
- Disables Prototype 14 execution and gives Prototype 15 an exclusive runtime boundary; retained legacy Traffic Manager, recovery, reservation and Decision paths remain dormant.
- Adds fail-closed `FAILED_HELD` behaviour and safe operator cancellation through configuration restoration before handback.

## v4.6.24 — Single-Worker Information-Gaining Delay

- Begins from exact canonical v4.6.23, SHA-256 `87d3548463c2f77b81e26098ecd9faa7dd88b498e628f24b13582738e4766db3`.
- Records TS011-A and TS011-B as a repeatable Start-Order-Independent Conflict under FS25 1.21.1.0 build b40785.
- Establishes an Evidence-Bounded Intervention Window: current `CRITICAL` prediction preceded first blockage by approximately seven seconds in both reversed-order runs.
- Establishes Conflict Cessation Is Not Conflict Resolution after predictor `CLEAR` followed collision and stable blockage in both runs.
- Adds Prototype 14 — Single-Worker Information-Gaining Delay and the TS012 evidence contract.
- Selects the later-admitted worker as the only hold subject after Prototype 02 reaches `ESTABLISHED` confidence in a settled head-on relationship.
- Reuses the native field-worker permission gate so the held worker remains under its Giants AI job rather than being stopped or restarted.
- Adds an exclusive Prototype 14 execution boundary; retained legacy Traffic Manager, recovery, reservation and Decision paths remain dormant.
- Disables passive Prototype 03 and Prototype 04 during the active experiment because their original evidence contracts assumed a wholly passive system.
- Forbids release on predictor `CLEAR`; Safe Release Candidates are logged only after positive continuation, turn-completion and divergence evidence, and do not execute release.
- Retains the hold on blocked or unresolved-timeout outcomes for player observation; automatic release remains a separate unproven claim.
- Updates package descriptions, scenario records, decisions, concepts, handover, roadmap and release validation for the active TS012 candidate.

## v4.6.23 — Scope Overlay Test-Role Calibration Consolidation

- Begins from exact canonical v4.6.22, SHA-256 `b636bafdd59afcedba133b2dac65a19286f3dc980734eac63b612c0aaf3a941f`.
- Adds `docs/SCOPE_OVERLAY_TEST_CALIBRATION.md` as the authoritative record for the bounded TS005–TS010 calibration.
- Defines Complete Test Configuration, State Sufficiency, Essential Evidence Horizon, Coverage Compression and Fixture-Generation Evidence.
- Records exact positive evidence for the reference tractor-cultivator, combine-header specialist assembly, dynamic 36 m Condor assembly and right-offset mower assembly.
- Records configuration-level and crop-system admission rejection through TS007 and TS009 without expanding support status.
- Establishes the Material-Chain Control Boundary from the TS006/TS007 pair and the Agronomic State Gate from TS008-N.
- Renames TR-03 to Non-Tractor Operational Assembly and TR-04 to Material-Chain Boundary.
- Retires the mandatory Distinct Spatial-Regime Positive role after Native Crop-System Exclusion prevented olive-row admission.
- Retires Persistent/Regrowing Lifecycle as Agronomic Proxy Drift and replaces it with the architecturally relevant Asymmetric Working Envelope role.
- Establishes Offset Working Envelope, Trajectory–Work Displacement and Work-Envelope-Anchored Routing from TS010.
- Preserves Valid Boundary Straddling as a provisional containment-review obligation rather than silently changing Full-Envelope Field Containment.
- Tags TS005–TS009 to FS25 1.21.0.0 and TS010 to the undocumented FS25 1.21.1.0 build b40785 Silent Baseline Transition.
- Adds Runtime Baseline Governance, Patch Impact Watch, Patch Sentinel Set and the Current/Version-bound/Revalidation candidate/Invalidated evidence states.
- Closes Scope Overlay Test-Role Calibration while leaving implementation, multi-worker conflict, intervention, performance and targeted revalidation work open.
- Removes the inherited stale repository-policy entry for absent active `docs/ENGINEERING_CONTRACT.md`; archived compatibility history remains unchanged.
- Changes no gameplay, Situation Assessment, Decision, Commitment or Control behaviour; Lua modifications are version metadata only.

## v4.6.22 — Scope Overlay Architecture Consolidation

- Begins from exact canonical v4.6.21, SHA-256 `a905d5b419f6f3e75c46224aa7b218d453b7ffb8c3409844a85260a964d12361`.
- Adds the dedicated `docs/SCOPE_OVERLAY_ARCHITECTURE.md` ownership document and integrates it into repository navigation and policy.
- Preserves the complete Stage 2C base-game Semantic Catalogue while establishing Catalogue Membership–Support Eligibility Separation.
- Defines the Player Responsibility Boundary, Base-Game AI Capability Envelope and External Capability Non-Expansion.
- Selects the Giants AI job configuration as the capability subject and separates Job Admission, Job Configuration Viability and the Capability Confirmation Point.
- Defines Control Eligibility Profile, Runtime Control Admissibility, Control Exclusion Constraint and Observe Broadly, Control Narrowly.
- Establishes Independent Test Admission and Bounded Negative Test Candidates without expanding support status.
- Defines Presence–Participation Separation, Operational Influence, Participation Transition and Participation–Obstacle Separation.
- Defines Membership–Relevance Separation, Behavioural Assembly, Dynamic Assembly Relevance and player-mediated detachment reassessment.
- Defines contextual and directional Obstacle Relevance, Occupancy–Obstacle Separation, Future-Space Inclusion and Entity–Environment Separation.
- Adds Local Resolution–Operational Resolution Separation, Persistent Spatial Constraint, Denied Work Space, Recurring Commitment Loop and Completion Blocker.
- Defers machine-readable overlay states, evidence sources, assignment tables, fixture selection, player-message policy and Prototype 13B implementation.
- Changes no gameplay, Situation Assessment, Decision, Commitment or Control behaviour; Lua modifications are version metadata only.

## v4.6.21 — Base-Game Vehicle Semantic Catalogue Consolidation

- Begins from exact canonical v4.6.20, SHA-256 `08000f111892e076fe68972ae08a129e652dacea77a8a2428b3739c212847a52`.
- Consolidates a 606-definition base-game vehicle and implement evidence catalogue without including proprietary GIANTS assets.
- Records the Effective Definition Boundary: Raw Definition Evidence plus Selected-Field Inheritance Projection rather than an unverified complete parent-file merge.
- Records Readable-Source Exhaustion and Runtime Localisation Authority after all 567 required keys resolved through the observed English GIANTS runtime.
- Preserves the missing-key diagnostic result and corrects the temporary probe's Negative-Control Classification Gap during consolidation.
- Establishes Semantic Profile, Not Category; Role–Capability Separation; Purchase Category as Context, Not Contract; and Catalogue–Structure Separation.
- Consolidates 147 function cohorts into 170 review units and records Function Cohort Is an Anchor, Not a Decision plus Group Decision–Asset Exception.
- Records complete human review: 166 units approved unchanged, two amended and two resolved through the new roles `LIQUID_TANK_TRAILER` and `FUEL_TRAILER`.
- Propagates reviewed decisions to all 606 definitions and adds a deterministic self-contained research catalogue under `research/vehicle_semantics/`.
- Establishes Approval Inheritance, Minimum Sufficient Semantic Resolution, Scope-Driven Review Depth and Semantic Classification–Scope Separation.
- Defers the exact Scope Overlay, paid DLC, modded vehicles, targeted Structural Challenge Profiles and Prototype 13B fixture selection.
- Changes no gameplay, assessment, Decision, Commitment or Control behaviour; Lua modifications are version metadata only.

## v4.6.20 — Prototype 13A Resolution Knowledge Consolidation Completion Patch

- Declared exact canonical v4.6.18 as the implementation baseline and recorded its deterministic local reproduction.
- Replaces the discarded noncanonical v4.6.19 candidate after review found stale currency markers in two substantively reviewed documents.
- Advances `docs/README.md` and `docs/CONCEPT_REGISTER.md` review markers to v4.6.20; older markers remain unchanged where no substantive review occurred.
- Consolidated the strict Resolution Contract, Resolution Claim Set, mandatory evidence floor and claim-specific confidence model.
- Replaced ambiguous architectural `route` terminology with **Resolution Path** while retaining historical implementation labels for traceability.
- Separated Resolution from the best currently defensible Assessment Representation Portfolio.
- Added Representation Passport, self-describing layers, conclusion-relative sufficiency, claim permissions and multidimensional cost profiles.
- Established Situation Assessment as representation-fitness and refresh-need arbiter while preserving its Knowledge-only boundary.
- Added dependency-scoped invalidation, assessment-relative staleness and smallest-scope refresh.
- Recorded that Tiger and TopDown disprove implement-class structural homogeneity; class remains context, not structural authority.
- Accepted GIANTS' final job disposition, retained completed workers as persistent non-member obstacles and deferred Post-Job Configuration Normalisation.
- Parked Assessment Deadline Escalation for a future Decision Engine session without selecting a failsafe.
- Updated handover, roadmap, status, concepts, decisions, glossary, architecture and journal for future representation-diverse fixture selection.
- Introduced no runtime resolver, footprint, assessment, Commitment or Control behaviour beyond version metadata.

## v4.6.18 — Prototype 13A Evidence Consolidation and Animation-State Correction

- Consolidates successful Prototype 13A runtime evidence from Condor, Tiger 8 MT and TopDown 600: ten declared source shapes resolved through A/B route convergence and all ten deliberately invalid C controls were rejected.
- Preserves Route–Authority Separation: the successful route classes remain corroborating lookup mechanisms, not authority rankings or proof of complete physical inventory.
- Replaces Prototype 13A's generic `foldState` inference with neutral animation evidence: raw `foldAnimTime`, endpoint/interior region and observed changing/stable motion.
- Records Stable Interior Animation State after TopDown held `foldAnimTime=0.1250` while extended and raised for manoeuvring.
- Records Compound Animation Timeline and Operational Phase–Physical State Separation; one animation may encode deployment and vertical configuration, while GIANTS `WORKING` may begin before the implement reaches its stable lowered pose.
- Records Extended Manoeuvring State and the AI Work Engagement Cycle for TS004 TopDown: extended-raised repositioning followed by lowering for direct-soil-contact work.
- Separates deployment, vertical configuration, terrain contact, functional engagement and operational phase as independent architectural dimensions.
- Records Raise/Lower Semantic Diversity, Configuration–Function Separation, Contact-Dependent Functional Engagement and Commanded State–Realised Contact Separation.
- Preserves the Player Obstacle Boundary: player-controlled assemblies are relevant only as possible obstacles to AI workers, not as cooperative workers or behavioural models.
- Introduces no route discovery, footprint construction, Coverage Closure, sweep, conflict assessment, Decision, Commitment or Control behaviour.

## v4.6.17 — Prototype 13A: Declared Route Evaluation

- Adds passive Prototype 13A to test resolution-route diversity before any complete footprint construction.
- Introduces isolated fixture declarations for Condor, Tiger 8 MT and TopDown 600; declarations identify where to look but do not assert correctness.
- Tests direct mapping, physics-component descendant and mapped-ancestor descendant routes through one common evaluator.
- Preserves Candidate A/B/C records, route convergence, route disagreement and deliberately invalid controls.
- Distinguishes resolved runtime nodes from proven Entity-local physical geometry through `NODE_RESOLVED_GEOMETRY_UNPROVEN`.
- Rejects route priority: resolution-route type remains separate from physical authority.
- Tests four Condor boom controls, Tiger left/right wing `colPart` shapes and TopDown left/right folding-arm collision descendants.
- Adds motion-derived corroboration through folded, transition and extended states without making motion mandatory for rigid shapes.
- Adds cross-source handle-reuse detection and member-root alias rejection.
- Defers automated route discovery, complete physical inventory, footprint construction, Coverage Closure, sweep, conflict assessment, Decision, Commitment and Control.

## v4.6.16 — Physical Representation Architecture Consolidation

- Separates authoritative runtime collision-shape identity from usable physical occupancy; unresolved exact identity no longer forbids explicitly qualified conservative fallback.
- Accepts a Physical Representation Portfolio containing Component Footprint Sets, a Convex Planar Envelope, member rectangles, assembly rectangles and explicit unknown occupancy.
- Accepts the Convex Planar Envelope as an intermediate conservative fallback and defers Envelope Anchor Selection pending comparative evidence.
- Defines the Representation Contract as Spatial Core, Validity Context and Evidence Quality, including provenance, completeness, conservatism and purpose-specific Fitness Profile.
- Establishes the Job-Scoped Representation Catalogue, Job-Bounded Catalogue Lifetime, Representation Templates, Pose Realisation and Stable Structure–Dynamic Pose Separation.
- Accepts Component Families, Family Strategy–Member Parameter Separation and defensive Localised–Common-Mode Failure distinction.
- Accepts Heterogeneous Footprint Composition, Smallest-Scope Fallback, Coverage-First Composition, Localised Uncertainty, Precision–Coverage Separation and Layer-Preserving Composition.
- Establishes Planar Collision Semantics, Planar Rigidity and the Planar Relevance Test; height is excluded as a current clearance dimension because GIANTS AI does not exploit vertical underpass clearance.
- Defines folded and working as principal stable occupancy states and separates Stationary Configuration Motion through a Deployment Clearance Envelope and Deployment Commitment Point.
- Records Endpoint–Sweep Distinction and separates Deployment Sweep from Manoeuvre Sweep.
- Records Steering-Mode Sweep Dependency and rejects naïve midpoint-pivot turning assumptions pending observed kinematic evidence.
- Defines Inventory Closure, Coverage Closure, Enumerative Closure, Enclosing Closure, Hybrid Closure, Structural Coverage Closure, Realised Coverage Closure, Closure Composition and the Coverage Ledger.
- Names the Known-Coverage Trap and permits continued partial assessment through Clearance Unresolved and Scope-Local Non-Exclusion.
- Records TS004 static contrast evidence for Valtra S 416 + Tiger 8 MT and John Deere 8RX 410 + TopDown 600, including Internal Articulation Representation Diversity, Direct-Mapping Coverage Variability and State-Scoped Dimensional Evidence.
- Adds `docs/PHYSICAL_REPRESENTATION_ARCHITECTURE.md` as the authoritative home for this model.
- Adds repository `.gitattributes`, normalises `.gitignore`, `rrs/__init__.py`, `rrs/__main__.py` and `rrs/requirements-dev.txt` from CRLF to LF, and establishes Repository-Native Line-Ending Authority.
- Preserves observer-only implementation; no Prototype 13, Physical Occupancy Envelope, containment, sweep prediction, Decision, Commitment or Control behaviour is introduced.

## v4.6.15 — Prototype 12 Validation Consolidation

- Records Prototype 12 Physical Assembly Discovery as strongly supported across one integrated and two attached base-game fixtures.
- Condor resolved as an `INTEGRATED_SINGLE_MEMBER` assembly with one asset and one runtime root.
- Valtra S 416 plus Horsch Tiger 8 MT and John Deere 8RX 410 plus Väderstad TopDown 600 each resolved as `ATTACHED_MULTI_MEMBER` assemblies with two assets, two runtime roots and one explicit attachment edge.
- Names the Physical Assembly Search Boundary: geometry discovery begins with the operational worker, expands to the current assembly, and then proceeds independently inside each member-local asset/runtime hierarchy.
- Names Attached-Assembly Replication after the same structural result transferred across different manufacturers, mapping vocabularies, component counts and hierarchy sizes.
- Names Working-State Motion Divergence after the S 416 remained logically active and reported `WORKING` while measured movement stayed effectively zero for at least fifteen seconds.
- Records that the S 416 plus Tiger 8 MT could cultivate manually, disproving simple equipment incapability while leaving the GIANTS AI progression cause unresolved.
- Separates assembly discovery from AI work progression: assembly identity remained coherent in both the stalled and normally progressing attached fixtures.
- Retains the three dismissed raw HUD texture warnings as unrelated performance noise and records no OuttaMyWay runtime errors or control intervention.
- Disables completed Prototype 12 after validation while retaining its passive implementation and evidence contract.
- Establishes Member-Local Physical Resolution as the next discussion gate before Prototype 13 implementation.
- Preserves observer-only execution; no collision membership inference, Physical Occupancy Envelope, containment, sweep, Decision, Commitment or Control is introduced.

## v4.6.14 — Prototype 12: Physical Assembly Discovery

- Consolidates the strongly supported Prototype 11 result: runtime Entity identity, not source asset `shapeId`, selected geometry in every tested shape-bound invocation.
- Names Second-Argument Non-Authority for the tested API/Entity combinations while retaining the argument's wider engine semantics as unknown.
- Records Mapping-Key Locality: Condor mapping keys such as `colPart` are asset-local vocabulary, not FS25-wide collision semantics.
- Records the base-game Valtra S 416 plus Horsch Tiger 8 MT contrast reconnaissance.
- Names Operational Entity–Physical Assembly Separation: the AI worker identity may own a multi-object powered/attached physical assembly.
- Names Fixture-Absence Warning Noise after the Condor-specific probe repeatedly warned during an intentionally non-Condor run.
- Adds passive Prototype 12 Physical Assembly Discovery.
- Enumerates active workers from both mission vehicle collections and recursively follows protected runtime attachment evidence.
- Records each assembly member's asset identity, runtime root, components, mapping availability, hierarchy summary and attachment relationship.
- Adds continuous worker motion samples so declared AI state can be compared with demonstrated movement.
- Disables completed Condor-specific Prototypes 08, 09 and 11 during the generic assembly experiment while retaining their code and evidence.
- Defers collision-node resolution until the current assembly search boundaries are established.
- Preserves observer-only execution; no collision inference, Physical Occupancy Envelope, containment, sweep, Decision, Commitment or Control is introduced.

## v4.6.13 — Prototype 11: Runtime Geometry Selector Semantics

- Begins from the exact v4.6.10 canonical baseline and consolidates accepted evidence from noncanonical v4.6.11 and v4.6.12 candidates.
- Retains Prototype 09's strongly supported component-local sphere evidence and corrected successful-call error reporting.
- Refines the Component-Local Sphere Bridge: source collision identity is joined to a correctly resolved runtime collision node; source asset `shapeId` remains provenance metadata until selector semantics are established.
- Records Prototype 10 as a productive disproval: all 29 physical source IDs and one nonphysical control paired with `vehicle.rootNode` returned the same root-Entity sphere.
- Names Root-Entity Sphere Aliasing, Self-Coherence Blind Spot and Source-to-Runtime Shape Resolution.
- Retains the complete 29-shape source collision catalogue as identity and membership knowledge while refusing to claim runtime coverage.
- Does not carry the disproved `PhysicalShapeCoverageProbe` forward as active implementation.
- Adds passive Prototype 11 selector testing across all eight resolved active boom collision nodes.
- Compares zero, own-source, sibling-source and deliberately invalid second arguments and performs a known-ID vehicle-root control.
- Separates internal local/world coherence from cross-invocation and cross-Entity identity evidence.
- Rechecks representative selector behaviour through folded, transition and deployed states.
- Preserves observer-only execution; no Physical Occupancy Envelope, containment, transition sweep, projected motion sweep, Decision, Commitment or Control is introduced.

## v4.6.12 — Prototype 10: Physical Shape Coverage — noncanonical evidence candidate

- Expanded the source catalogue to all 29 physical Condor `compoundChild` identities and classified eight active boom shapes, five permanent physical shapes and sixteen inactive alternatives.
- Tested the proposed `vehicle.rootNode + source asset shapeId` descendant-selection route and selected one geometry-bearing nonphysical control.
- TS001 disproved the selector hypothesis: every physical ID and the control returned the same root-local centre `0.000000,2.253981,1.032253` and radius `4.363019 m`.
- The resulting `8.726038 m` cube remained unchanged through `FOLDED -> TRANSITION -> DEPLOYED`, so the apparent `29/29` coverage was false.
- Named Root-Entity Sphere Aliasing and Self-Coherence Blind Spot.
- Established Source-to-Runtime Shape Resolution as the remaining coverage gap.
- Corrected Prototype 09 Successful-Call Error Residue.
- This candidate was not declared canonical and its disproved runtime coverage probe is not carried forward as active code.

## v4.6.11 — Prototype 09: Runtime Shape-Bound Evidence

- Retains v4.6.10 as the canonical implementation baseline and introduces a passive validation candidate only.
- Names the Shape-Bound Capability Blind Spot: Prototype 07 disproved the tested box-oriented route but did not test the documented two-argument shape-sphere API family.
- Names the possible Shape-ID Geometry Bridge between Prototype 08B asset `shapeId` identity and Prototype 08A resolved runtime collision nodes.
- Names Extent Truth–Utility Separation: a trustworthy conservative sphere may still be too coarse for operational containment.
- Adds `scripts/prototypes/ShapeBoundProbe.lua`, consuming Prototype 08 state without independently rediscovering vehicle or collision identity.
- Tests four protected identity/frame routes for each of Condor's eight active physical boom collision shapes.
- Requires valid geometry, general-shape and world spheres plus local-to-world centre/radius coherence before selecting an identity route.
- Records geometry-local stability, general shape-bound stability, `usesGeometry`, world coherence and geometry-versus-shape differences throughout the fold lifecycle.
- Keeps unavailable APIs, invalid values, missing routes and partial evidence explicit under No Silent Under-Approximation.
- Records that permanent chassis and deliberately nonphysical render controls are not present in the canonical runtime catalogue rather than fabricating source identities.
- Adds the Prototype 09 hypothesis, validation fixture, result classifications and searchable log contract.
- Preserves observer-only execution; no Physical Occupancy Envelope, containment, transition sweep, projected sweep, Decision, Commitment or Control is introduced.

## v4.6.10 — Prototype 08: Collision Node Pose and Model-Derived Catalogue

- Supersedes archival noncanonical v4.6.9, whose TS001 run exposed a Diagnostic Enumeration Blind Spot: the probe inspected only an empty `g_currentMission.vehicles` collection.
- Enumerates both `g_currentMission.vehicles` and `g_currentMission.vehicleSystem.vehicles`, deduplicates by root Entity, logs source counts and emits an explicit no-match warning.

- Named Configuration–Pose Separation, Save-State Geometry Bridge and Collision Mesh Extraction Gap.
- Split geometry reconstruction into Prototype 08A live collision-node pose observation and Prototype 08B offline model-derived catalogue extraction.
- Added an asset-fingerprinted extractor for vehicle XML, I3D hierarchy, collision filters, configuration membership and fold-animation endpoint prediction without distributing GIANTS assets.
- Generated a Condor 36 m catalogue containing 29 physical compound-child shapes, the eight active boom collision nodes, all eight I3D mapping paths and explicit unresolved mesh extents.
- Added a runtime Condor pose probe that resolves the eight named collision nodes, records root-local origins and axes, follows `foldAnimTime`, and compares live poses with offline folded/deployed predictions.
- Uses TS001 and TS003 as a controlled same-Entity folded/deployed pair; TS001 is the primary live transition fixture.
- Disables the expensive completed Prototype 07 hierarchy-bound scan while retaining its canonical negative evidence.
- Preserves No Silent Under-Approximation: collision-node origins are not collision-mesh bounds, working width is never substituted, and no Physical Occupancy Envelope is claimed.
- Traffic Manager v2 remains disabled; no containment, projected sweep, Decision, Commitment, hold, release or vehicle-control behaviour is introduced.
- Candidate implementation completed in observer-only mode; accepted validation evidence follows.
- Corrected enumeration observed `missionVehicles=0`, `vehicleSystemVehicles=54`, `uniqueRoots=53` and `condorCandidates=1`; Condor attached once and no no-match warning occurred.
- All eight configured 36 m boom collision nodes resolved once through I3D mappings and retained one Entity identity throughout the run.
- TS001 produced one complete `FOLDED -> TRANSITION -> DEPLOYED` lifecycle: `foldAnimTime=1.0000` at `t=0.1s`, transition from `t=8.3s`, and stable deployment at `foldAnimTime=0.0000` from `t=25.4s`.
- The live collision-node origin span changed continuously from approximately 2.8237 m folded to 30.2403 m deployed, strongly supporting runtime collision-node pose reconstruction.
- Prototype 08B correctly predicted the folded and deployed lateral origin spans and retained exact collision identity/configuration membership, but complete per-node endpoint reconstruction remained approximate: the folded `Col04` longitudinal prediction was materially wrong and stable deployed RMS error remained approximately 0.55 m.
- The accepted reconstruction boundary is therefore static catalogue identity and future local mesh extents plus authoritative live runtime node transforms; offline animation pose is diagnostic, not authoritative.
- Condor's four boom segments per side appear progressively thinner toward the tips, supporting Segmented Tapered Occupancy for this model. This observation must not be generalised: other foldable implements may use different segmentation, proportions, activation or articulation.
- Binary `.i3d.shapes` collision-mesh extents remain unresolved, so no Physical Occupancy Envelope, containment, projected sweep or Control claim is made.
- The repository owner reviewed and tested the exact v4.6.10 candidate and explicitly declared v4.6.10 canonical.

## v4.6.8 — Prototype 07: Physical Occupancy Evidence

- Named Geometry Domain Separation and Physical–Agronomic Separation: GIANTS collision geometry, Physical Occupancy Envelope and Working Footprint are distinct evidence domains.
- Added the No Silent Under-Approximation invariant: unknown or partial geometry must remain explicit and may not masquerade as exact physical occupancy.
- Added a passive GIANTS geometry capability inventory covering shape/local/world bounds, rigid-body evidence, collision masks and hierarchy traversal.
- Isolated geometry discovery/derivation in `scripts/geometry/PhysicalEnvelopeEvidence.lua` and lifecycle/logging in `scripts/prototypes/PhysicalOccupancyProbe.lua`.
- Aggregates the root vehicle and every attached or towed implement as one complete Entity.
- Derives a conservative current compound ground-plane envelope only from discovered bounded evidence and records provenance, coverage, confidence and frame stability.
- Logs AI marker working width and vehicle size metadata separately; neither substitutes for physical geometry.
- Adds pair diagnostics for physical-envelope clearance during known encounters such as adjacent-lane Condor/Patriot passes.
- Detects configuration or evidence changes in Entity-local envelope signatures while treating ordinary translation separately.
- Separates infrequent hierarchy inventory from frequent bound sampling to reduce diagnostic performance distortion.
- Adds the Prototype 07 hypothesis, staged validation contract and planned configuration-change fixture.
- Traffic Manager v2 remains disabled; no containment, projected sweep, safety padding, Decision, Commitment, hold, release or vehicle-control behaviour is introduced.
- Candidate implementation completed in observer-only mode; accepted validation evidence follows.
- TS003 exposed the tested runtime capability boundary: `getRigidBodyType=true`, while `getShapeBoundingBox`, `getBoundingBox`, `getWorldBoundingBox` and `getCollisionMask` were unavailable.
- Condor and Patriot each scanned 800 hierarchy nodes with truncation but produced zero bounded nodes, zero physics-bound nodes, `coverage=NONE`, `confidence=UNKNOWN` and no compound envelope.
- Across approximately 337 s, every Prototype 07 heartbeat retained two Entities but reported zero discovered envelopes and zero Entities with physics-bound evidence; no `NODE_EVIDENCE`, `PAIR_GEOMETRY` or `ENVELOPE_CHANGED` event could be produced.
- The probe correctly retained `workingMarkerWidth=36.00` as separate agronomic evidence and never substituted it for unknown physical geometry, satisfying No Silent Under-Approximation.
- Named the Runtime Geometry Access Gap: GIANTS uses physical collision geometry internally, but the tested Lua runtime boundary did not expose usable bounds for complete-Entity occupancy derivation.
- The final sweeping manoeuvre, near miss and observed reverse deadlock retained the relevant parked Entity but left current clearance and swept occupancy unknown, exposing Retained Entity, Missing Spatial Truth.
- Prototype 07 therefore disproves the tested Direct Geometry Retrieval route while preserving Physical Occupancy Envelope as an architectural requirement; alternative evidence sources must be investigated before containment mathematics or Control.
- The repository owner reviewed and tested the exact v4.6.8 candidate and explicitly declared v4.6.8 canonical.

## v4.6.7 — Prototype 06: Membership Transition Reclassification

- Corrected the Lua false-to-nil latching defect that caused repeated `OPERATIONAL_MEMBERSHIP_CHANGED` events for an unchanged non-operational vehicle.
- Added per-Entity classification revisions that advance only on attach or real Operational Membership/control-class change.
- Added relationship signatures containing source and target role/classification revisions.
- Added explicit `PROTOTYPE06 MEMBERSHIP_TRANSITION`, `RELATIONSHIP_RECLASSIFIED` and `RELATIONSHIP_REMOVED` evidence.
- Preserves one Field World identity while participant roles change and reclassifies relationships independently of geometric relevance changes.
- Retains TS002 as the pre-existing non-operational regression fixture and defines a planned TS003 live-completion fixture.
- Regenerates the release manifest from the clean owner-supplied v4.6.6 baseline, excluding transient local environments and caches.
- Traffic Manager v2 remains disabled; no Decision, Commitment, hold, release, containment or vehicle-control behaviour is introduced.
- Candidate implementation completed in observer-only mode; accepted validation evidence follows.
- TS002 passed as the negative control: Condor remained `NON_OPERATION_VEHICLE` from save load, produced no `PROTOTYPE06 MEMBERSHIP_TRANSITION`, `RELATIONSHIP_RECLASSIFIED` or `RELATIONSHIP_REMOVED` events, and still became `RELEVANT` during Patriot's terminal approach before the observed collision.
- Added TS003 as the repeatable live Operational Completion fixture after substantial setup to control GIANTS restart repositioning.
- At approximately `t=225.5s` in TS003, Condor completed while Patriot remained active; the probe emitted exactly one latched membership transition from `OPERATION_MEMBER` to `NON_OPERATION_VEHICLE`, exactly one relationship reclassification with `identityPreserved=true`, and one explicit retirement of the obsolete reverse directional relation.
- Condor retained the same Field World identity, no unchanged membership event repeated, and no OuttaMyWay Lua runtime error or vehicle-control action occurred.
- Several transient relevance and GIANTS blocked episodes cleared without deadlock; a blocked warning remains an operational symptom rather than proof of realised collision or deadlock.
- Prototype 06 therefore strongly supports latched Operational Membership transitions and role-aware relationship reclassification independently of geometric relevance change.
- The repository owner reviewed and tested the exact v4.6.7 candidate and explicitly declared v4.6.7 canonical.

## v4.6.6 — Prototype 05: Field World Observation

- Recovered and promoted Full-Envelope Field Containment: the complete vehicle–implement collision envelope, including projected swept geometry, remains wholly inside the field polygon at all times.
- Defined the field polygon as the bounded Field World for one Operation.
- Separated Field World Membership, Operational Membership and dynamic Situation Relevance.
- Added passive Prototype 05 vehicle observation across active, inactive, completed and player-controlled mission vehicles.
- Retains physically present vehicles after active GIANTS AI membership ends and records dynamic closest-approach relevance to active workers.
- Preserves GIANTS field-island counts and native static-collision signals as limited static-world evidence.
- Uses conservative current-envelope rectangles for diagnostics only; exact maximum collision geometry, projected sweep and containment control remain unimplemented.
- Added the parked-Patriot and completed-Condor TS001 validation procedure.
- Traffic Manager v2 remains disabled; no hold, release, Decision, Commitment, containment or vehicle-control behaviour is introduced.
- Variable TS001 runs confirmed that stopped or player-controlled Patriot and completed Condor remained Field World vehicle members after leaving active Operational Membership; manual timing and movement prevented a clean terminal regression result.
- Added TS002 as a repeatable pre-existing non-operational vehicle relevance fixture: completed Condor is parked, Patriot remains active and approaches the same finishing area without player intervention.
- In TS002, Condor was discovered at `t=6.2s` as `NON_OPERATION_VEHICLE` while Patriot was the sole `OPERATION_MEMBER`; the relation began `NOT_RELEVANT`, became `RELEVANT` at `t=241.7s`, and Patriot became blocked at `t=290.7s` in the observed collision.
- Prototype 05 therefore strongly supports independent Field World Membership, Operational Membership and dynamic Situation Relevance for vehicle members.
- The test also exposed repeated Operational Membership event logging, incomplete relationship reclassification after a live worker completes, and noisy provisional containment candidates; exact static-object identity and exact full-envelope geometry remain unresolved.
- The repository owner reviewed and tested the exact v4.6.6 candidate and explicitly declared v4.6.6 canonical.

## v4.6.5 — Prototype 04: Continuation Intent and Safe Release

- Added passive Prototype 04 instrumentation for Local Intent Horizon, Intent Expiry and retrospective next-manoeuvre release safety.
- Correlates Prototype 03 Progress Entity/hold-candidate evidence across worker detachment and reattachment without issuing control.
- Records local intent epochs, explicit expiry at a new manoeuvre, observed release timing, continuation manoeuvres and later conflict-positive evidence.
- Adds retrospective `SAFE_THROUGH_NEXT_MANOEUVRE` and `UNSAFE_THROUGH_NEXT_MANOEUVRE` outcomes within a deliberately limited Continuation Safety Horizon.
- Names Local Intent Horizon, Intent Expiry, Encounter Chain, Safe Release Point and Continuation Safety Horizon as Deferred concepts under test.
- Corrects Prototype 03 Startup Manoeuvre Contamination by requiring meaningful motion from both participants before opening a window.
- Corrects stale Prototype 03 `ACTIONABLE` evidence by expiring local intent when the Progress Entity begins a new manoeuvre.
- Latches Prototype 03 Alternate Exhaustion evidence so it is emitted once per completed window.
- Adds the Prototype 04 hypothesis, evidence contract and limited player stop/restart TS001 procedure.
- Traffic Manager v2 remains disabled; no hold, release, Decision, Commitment or vehicle-control behaviour is introduced.
- The limited TS001 run confirmed bounded local intent epochs and immediate Intent Expiry when Condor began a new manoeuvre or left active observation.
- Patriot was manually stopped at the candidate wait position and left active AI-worker observation; Condor later repositioned toward the physically parked Patriot and became blocked until the player moved Patriot.
- The original stopped position was therefore unsafe through a later repositioning, while the probe could not classify the encounter automatically because the parked non-worker was outside its observation scope.
- A later restart after manual relocation remained clear through the measured continuation but does not validate a Safe Release Point for the original hold site.
- Completed Condor later occupied the normal GIANTS finishing position and Patriot became blocked when it attempted to use the same location, exposing physical relevance beyond active Operational Membership.
- The repository owner reviewed and tested the exact v4.6.5 candidate and explicitly declared v4.6.5 canonical.

## v4.6.4 — Prototype 03: Option Preservation Window

- Added passive Prototype 03 instrumentation for manoeuvre ordering, Intent Revelation and provisional Response Margin.
- Named Candidate Option Preservation Window, Progress Entity, Alternate Exhaustion Point, Information-Gaining Delay, Observation Deadlock, Mutual Commitment Trap and the Progress Preservation Invariant as Deferred concepts under test.
- Recorded the invariant that an observation-enabling delay must preserve at least one participant able to generate completion evidence; Prototype 03 never represents holding all participants as valid.
- Added `CANDIDATE_OPEN`, `OBSERVING`, `ACTIONABLE`, `EXHAUSTED` and `CLOSED_SAFE` diagnostic states.
- Added provisional stopping-time, stopping-distance, manoeuvre-progress and response-time-margin evidence with every assumption exposed in the log.
- Published read-only Prototype 02 motion/confidence accessors for passive diagnostic reuse.
- Added the Prototype 03 hypothesis, evidence contract and unchanged TS001 procedure.
- Traffic Manager v2 remains disabled; no Decision, Commitment, hold or vehicle-control behaviour is introduced.
- The unchanged TS001 run produced an `ACTIONABLE` window approximately 12 s before conflict establishment and about 7.42 s of conservative temporal margin after the diagnostic stopping allowance and safety buffer.
- The player independently observed that Patriot still had time to wait after Condor became established in the lane; the Prototype 03 hypothesis is strongly supported.
- A manual stop/restart follow-up avoided the original head-on encounter but later produced a crossing conflict when Condor repositioned across Patriot's resumed path, disproving current-lane intent as sufficient safe-release evidence and reducing confidence in the simple alternating-lane model.
- Recorded Job Restart Perturbation, Startup Manoeuvre Contamination and Exhaustion Event Repetition as evidence and diagnostic constraints requiring later declared work.
- The repository owner reviewed and tested the exact v4.6.4 candidate and explicitly declared v4.6.4 canonical.

## v4.6.3 — Prototype 02: Conflict Confidence

- Added passive Prototype 02 instrumentation for Trajectory Settlement and conflict-persistence evidence.
- Named Conflict Formation Window and Sequential Manoeuvre Conflict from the first TS001 evidence without assigning fault to either worker.
- Added per-Entity heading/speed change rates, stable-motion duration and provisional settlement interpretation.
- Added pair-level conflict-positive persistence, dCPA spread, projected Conflict Zone drift and tCPA countdown-consistency evidence.
- Added provisional `CLEAR`, `FORMING`, `ESTABLISHED`, `DECAYING` and `CLEARED` diagnostic states with every threshold exposed in the log.
- Retained Prototype 01 and published only its side-effect-free kinematic helpers for diagnostic reuse.
- Added the Prototype 02 hypothesis, evidence contract, unchanged TS001 procedure and validation questions.
- Traffic Manager v2 remains disabled; no Decision, Commitment or vehicle-control behaviour is introduced.
- The unchanged TS001 run kept the earlier harmless head-on pass `CLEAR`, produced a meaningful `FORMING` interval, and reached `ESTABLISHED` at approximately 266.5 m separation, about 18.5 s before both workers became blocked.
- The player observed no further direction change after settlement and confirmed the final outcome remained a head-on collision.
- Disproved the provisional assumption that loss of future-trajectory evidence means resolution: after collision the probe reported `DECAYING` then `CLEARED` while both workers remained physically blocked.
- The repository owner reviewed and tested the exact v4.6.3 candidate and explicitly declared v4.6.3 canonical.

## v4.6.2 — Prototype 01: Conflict Emergence Point

- Added passive Prototype 01 instrumentation for the unchanged TS001 two-worker head-on encounter.
- Recorded position, heading, speed, separation, closing rate, closest-approach time/distance, projected conflict location and provisional stage transitions.
- Deferred Conflict Relevance Transition and Conflict Emergence Point pending in-game evidence.
- Discovered and corrected the Passive Boundary Ordering Gap: observer-only mode now returns before Traffic Manager v2 can decide or execute.
- Disabled Traffic Manager v2 explicitly and added a runtime passive-configuration check for the probe.
- Added the evidence contract, TS001 procedure, validation questions and searchable log prefixes.
- No avoidance response, Commitment change or positive vehicle-control action is introduced.
- First TS001 evidence distinguished harmless head-on proximity from an emerging projected conflict and recorded the Conflict Emergence Point at 318.38 m separation with 29.66 s projected time to closest approach.
- The repository owner reviewed and tested the exact v4.6.2 candidate and explicitly declared v4.6.2 canonical.

## v4.6.1 — Repository Release System Consolidation Candidate

- Accepted D-RRS-24 (Engineering Intent Boundary), D-RRS-25 (Fingerprint-Bound Engineering Intent) and D-RRS-26 (Candidate Determinism and Evidence Provenance).
- Promoted Engineering Intent, Canonical Repository Snapshot, Repository Transformation and Candidate Determinism into authoritative architecture and vocabulary.
- Recorded the first complete local RRS evolution, fingerprint-block, regenerated-handoff, owner-review, Canonicalisation and Git-synchronisation cycle.
- Disproved the assumption that fixed timestamps and permissions alone guaranteed cross-platform package determinism; named the Artifact Determinism Gap.
- Implemented one relative POSIX-path ordering rule for inventory, manifest and package generation, explicit ZIP origin/permission metadata, and stored entries independent of host compression libraries.
- Added focused regression tests for mixed-case path ordering, creation-order independence and ZIP metadata.
- Documented post-Canonicalisation Git alignment and clarified that Git working state is distinct from repository authority state.
- Clarified that documents use the ordering natural to their human-reading purpose; no global sorting rule applies.
- Recorded dirty-working-tree awareness and the remaining RRS assurance boundaries as deferred follow-up.
- No intentional vehicle-control behaviour changes.

## v4.6.0 — Repository Release System Recovery

- Recorded D-RRS-01 through D-RRS-23 as the accepted Repository Release System decision set.
- Promoted the RRS lifecycle, authority states, roles, gates, transformations and evidence responsibilities into authoritative repository knowledge homes.
- Registered the RRS architecture and operational documentation in repository policy and navigation.
- Documented the recovered candidate-production implementation boundary and its deferred Authority Transformation work.
- No intentional vehicle-control behaviour changes.

## v4.5.9
- Seminar Series 4 repository mining.
- Decision Engine refined as continuous commitment evaluator.
- Adopted Least Intervention and Grace as architectural quality attributes.
- Introduced Architectural Prototyping as next project phase.

- Repository mining from Seminar 06.
- Refined Operational Picture as coherent operational understanding.
- Clarified Continuous Operation vs Temporary Augmentation.
- Decision Engine identified as consumer of Operational Picture.
- Recorded architectural governance that ADRs may be refined/superseded by evidence.
- Removed previous failing /tools folder and contents

## v4.5.6 — Seminar Knowledge Distribution Release

- Classified Seminar 01–06 outputs across the Concept Register, Decision Log, Glossary, Project Status and Handover.
- Accepted Situation Space, Current Situation, Future Space and Action Space; clarified Situation Assessment as a transformation.
- Distinguished Reality from Knowledge and recorded Time as the architectural evolution dimension.
- Retained Conflict Zone as a derived operational concept, explicitly rejected Conditions, and deferred Entity and Operational Picture terminology.
- Recorded the process discovery that seminar mining must distribute knowledge by ownership and lifecycle.
- No intentional vehicle-control behaviour changes.

## v4.5.4 — Governance Recovery and Architectural Seminar Release

- Reconstructed the release from the last verified v4.5.3 canonical baseline and preserved Chat 04 governance findings plus the complete Chat 05 seminar series.
- Added Repository Review, Repository Completion Patch, independent packaged-release Repository Identity Check and evidence-based recovery rules.
- Expanded Engineering Continuity into Navigation, Prediction and Overall Assessment.
- Recorded deferred repository numbering and Operational Picture/Current Situation review, rejected Conditions, and preserved the evolution from Conflict Zone through Future Space, Action Space, Situation Space, Reality/Knowledge and Time.
- No intentional vehicle-control behaviour changes.

## v4.5.3 — Repository Identity and Compatibility Cleanup

- Restored one canonical v4.5.3 identity across runtime metadata, package entry points, current-state documents and tooling examples.
- Distinguished current release identity from historical version records so changelogs, decisions and archived lifecycle statements retain their original versions.
- Removed expired root-level compatibility signposts and retained the superseded documents solely under `docs/archive/compatibility/`.
- Populated `DOCUMENTATION_STANDARD.md` and enforced the canonical `OuttaMyWay` name and project-free document titles.
- Strengthened release preparation and verification so stale current-version examples and compatibility signposts fail validation.
- No intentional vehicle-control behaviour changes.

## 4.5.1 — Repository Governance Release

- Added explicit document authority, currency and lifecycle governance.
- Added `PROJECT_CONTINUITY.md` and the Engineering Continuity Test.
- Added the rule that every repository modification begins from a supplied current canonical baseline.
- Completed the documentation map and breadcrumb journey.
- Renamed `Engineering_Handbook.md` to `ENGINEERING_HANDBOOK.md` and replaced stale version metadata with currency metadata.
- Archived superseded engineering documents under `docs/archive/compatibility/` while retaining old-path signposts.
- Extended repository verification to check documentation coverage, filename casing, compatibility/archive placement and stale version declarations.
- No intentional vehicle-control behaviour changes.

## v4.5.0

- Established the development repository as an explicit engineering knowledge system optimised first for seamless continuation across chats and sessions, and second for future contributor comprehension.
- Added `ENGINEERING_ARCHITECTURE.md`, `CONCEPT_REGISTER.md`, `DECISION_LOG.md`, `ENGINEERING_JOURNAL.md` and `tools/README.md`.
- Made current status, continuation guidance, concept governance, decisions, discoveries, history and tooling separate repository responsibilities.
- Added `verify_repository.py` and integrated repository-coherence checks into the release pipeline.
- Reviewed the architectural concept registers: Conflict Zone, Situation Assessment and Commitment remain Accepted; Opportunity remains Deferred; no concepts are Rejected.
- Consolidated overlapping engineering method and workflow authority under `ENGINEERING_ARCHITECTURE.md` while retaining compatibility pointers.
- No intentional vehicle-control behaviour changes.

## v4.4.1

- Accepted Commitment as a first-class architectural concept with creation, maintenance, completion and cancellation lifecycle semantics.
- Deferred Opportunity pending evidence of an independent lifecycle or responsibility.
- Added recurring review of Accepted, Deferred and Rejected concept registers at each canonical repository update.
- Strengthened the release pipeline so both changelogs must contain the target release heading before packaging.
- Reconciled all embedded version records after the incomplete v4.4.0 packaging attempt.
- No intentional vehicle-control behaviour changes.

## v4.3.9

- Established Situation Assessment as the sole interpreter of observations and the single source of operational truth.
- Routed Control and Recovery outcomes back as Outcome Observations through Situation Assessment before further decisions.
- Added Project Vision, Autonomous Continuity and the Trust Test.
- Added the Architectural Discovery Method and Ownership Test.
- Preserved the unnamed Decision output as an open architectural hypothesis; Remedy and Variance remain candidates.
- Added automated release preparation, version audit and manifest generation tooling.
- No intentional vehicle-control behaviour changes.

## v4.3.8

- Completed Situation Assessment architecture.
- Added Decision Readiness.
- Added Decision-Relevant World.
- Added Decision-Relevant Constraints.
- Added Relevance Envelope.
- Added Option Horizon.
- Clarified the Situation Assessment ↔ Decision Engine boundary.

# Changelog

## v4.3.6
- Reconciled all embedded project version records to 4.3.6.
- Added the canonical Engineering Handover and expanded Project Status.
- Recorded Situation Assessment contract definition as the next evidence-driven task.
- Regenerated the complete SHA-256 release manifest.
- No intentional vehicle-control behaviour changes.

## v4.3.5
- Adopted repository-first engineering workflow.
- Added Engineering Workflow document.
- Recorded engineering handover methodology.
- Established mandatory knowledge mining before starting new chats.
