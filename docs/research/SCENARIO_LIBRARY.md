# Scenario Library

## Responsibility

**Describe repeatable in-game starting Reality fixtures, why they exist, what questions they are fit to answer, and the limits of conclusions drawn from them.**

A **Repeatable Reality Fixture** is a saved in-game state selected or constructed so that a materially equivalent starting condition can be rerun across implementation iterations. A Scenario is a reproducible starting Reality; a Test is a question asked of Reality using that Scenario. One fixture may therefore support several tests.

Fixture identity follows starting Reality. Materially changing the starting state should normally create a variant or new TS identifier. Repeatability strengthens attribution between builds; it does not broaden a fixture-specific claim. Exact save files and complete setup instructions are not stored in this repository, so the descriptions below preserve only recorded conditions and do not claim full independent reproducibility.

## TS001 — Head-on convergence and continuation

- **Starting Reality:** Natural multi-worker conflict fixture; also used with a folded start for representation work.
- **Suitable uses:** Conflict emergence/confidence, option preservation, bounded intent expiry and Field World observation.
- **Limits:** Manual stop/restart changes later routing, so those variants are distinct supporting evidence rather than equivalent controls.

## TS002 — Pre-existing completed vehicle relevance

- **Starting Reality:** Condor is already completed and parked at load while Patriot remains active and approaches the same finishing area.
- **Suitable uses:** Save-load discovery of a non-operational assembly and later physical relevance/obstruction.
- **Limits:** It contains no live operational-membership transition.

## TS003 — Live completion transition

- **Starting Reality:** Condor and Patriot begin active; Condor completes while Patriot remains active without player repositioning.
- **Suitable uses:** Live Job Episode completion, membership removal, preserved identity and post-completion relevance.
- **Limits:** Conclusions are bounded to this known deployed Condor/Patriot fixture.

## TS004 — Attached-implement representation contrast

- **Starting Reality:** Valtra S 416 with Horsch Tiger 8 MT, and John Deere 8RX 410 with Väderstad TopDown 600.
- **Selection basis:** The assemblies contrast multi-component wing articulation with collision-bearing folded descendants inside one physics component.
- **Suitable uses:** Attached-assembly discovery, member-local representation and representation fallback questions.
- **Limits:** Supplied GIANTS assets are not redistributed; recorded material is insufficient to recreate an exact save independently.

## TS005 — Reference positive cultivation

- **Starting Reality:** Riverbend Springs, Field 4, approximately 0.99 ha, flat and ploughed; DEUTZ-FAHR 6135 C RVshift with KNOCHE ECO-CULTIVATOR 300; native GIANTS AI cultivation.
- **Selection basis:** Map, field, assemblies and crop were selected semi-randomly. The combination was plausible and deliberately different from earlier scenarios.
- **Repeatability:** The initial game state was saved principally so later fix/build/test cycles could begin from materially equivalent Reality.
- **Suitable uses:** Ordinary positive cultivation and controlled comparison across iterations.
- **Limits:** Its value is controlled repeatability, not representativeness of all cultivation or all supported combinations.

## TS006 — Combine/header and straw generation

- **Starting Reality:** Field 4 with harvest-ready wheat; CLAAS EVION 450 with VARIO 620; straw swath enabled.
- **Suitable uses:** Independent combine/header assembly admission and generation of the downstream TS007 straw state.
- **Limits:** No multi-combine or combine-to-trailer offloading claim.

## TS007 — Native baler admission rejection

- **Starting Reality:** TS006 straw state with DEUTZ-FAHR 6135 C RVshift and base-game KUHN VB 3190.
- **Suitable uses:** Native GIANTS AI admission rejection and material-chain boundary characterisation.
- **Limits:** Manual straw collection does not establish autonomous-worker support.

## TS008 — Condor agronomic-state contrast

- **Starting Reality:** Condor Endurance II against an incompatible harvest-ready state (TS008-N), then wheat changed to green/big with fertiliser required (TS008-P).
- **Suitable uses:** Agronomic-state admission contrast and dynamic deployed extent through work, manoeuvring and completion.
- **Limits:** Observer sampling did not independently capture the brief negative lifecycle in TS008-N.

## TS009 — Olive crop-system rejection

- **Starting Reality:** Field 4 with three painted north–south olive rows, approximately 5 m headroom and growing olives; Landini REX 4 GT with AGRISEM DISC-O-Vigne V.
- **Suitable uses:** Native crop-system admission rejection.
- **Limits:** GIANTS refused native AI work; the fixture cannot test autonomous route behaviour for this crop system.

## TS010 — Right-offset mower and work-envelope routing

- **Starting Reality:** Field 4 grass ready to cut; DEUTZ-FAHR 6135 C RVshift with SaMASZ XT 390 offset to the tractor's right.
- **Suitable uses:** Asymmetric working envelope and observed work-envelope-anchored spiral routing.
- **Limits:** Observation stopped at the recorded Essential Evidence Horizon before full completion.

## TS011 — Controlled Condor/Patriot head-on baseline

- **Starting Reality:** Clivio's Mindenerwald same-lane spraying under FS25 1.21.1.0 build b40785. TS011-A starts Condor first; TS011-B starts Patriot first; the second worker begins after about 18 seconds.
- **Suitable uses:** Start-order comparison, head-on blockage and the intervention window before blockage.
- **Limits:** Results establish behaviour only for the exact fixture; post-collision predictor clearance is not physical conflict resolution.

## TS012 — Single-worker information-gaining delay

- **Starting Reality:** The Condor/Patriot fixture with Condor held while its GIANTS job remains active and Patriot continues. TS012-B observes opposite headland turns claiming the same next pass.
- **Suitable uses:** Hold permission, static-obstacle conversion, opposed next-pass claims and single-worker continuation controls.
- **Limits:** Holding after both workers enter the contested pass does not create route avoidance. Coverage sequence is start-state dependent.

## TS013 — Unilateral sidestep route-reassertion

- **Starting Reality:** One active Condor and one manually chosen clear side; hold, compact, bounded departure, rejoin, redeploy and GIANTS handback.
- **Suitable uses:** Whether GIANTS continues, returns to the departure/switch point, stops or otherwise reasserts its route after bounded deviation. See [Prototype 15](prototypes/PROTOTYPE_15_UNILATERAL_SIDESTEP.md).
- **Limits:** Not a two-worker passage or clearance test.

## TS014 — Retreating sidestep pace and folding overlap

- **Starting Reality:** Condor active, Patriot inactive; historical baseline FS25 1.21.1.0 build b40785 revision 81824; manual left/right arm after stable straight work.
- **Suitable uses:** Stop reference, rearward/outward egress, configuration/movement overlap, target capture and forward-route reacquisition.
- **Limits:** No physical passage-clearance or two-worker claim.

## TS015 — Two-worker passage and rejoin

- **Starting Reality:** Condor is the fixed yielding assembly; Patriot remains GIANTS-owned progress. TS015-A commands a 22 m lateral refuge; TS015-B commands 28 m lateral and 12 m rearward.
- **Suitable uses:** Complete-assembly passage, configuration, rejoin, handback, later independent interaction and right-side rejoin regression.
- **Recorded contrast:** TS015-A blocked at about 22.33 m centre separation. TS015-B achieved about 27.38 m lateral displacement and passed with both original jobs active through handoff.
- **Limits:** These are fixture calibration points, not universal clearance distances. Video remains the authority for observed real-assembly clearance. See [Prototype 16](prototypes/PROTOTYPE_16_TWO_WORKER_PASSAGE.md).

## TS016 — Repeatable turn-exit head-on

- **Starting Reality:** Condor and Patriot begin from altered locations; Patriot proceeds straight while Condor exits a headland manoeuvre, crosses the working lane and later settles head-on.
- **Suitable uses:** Manoeuvre-to-straight intent transition, repeated independent interactions, rearming and post-completion obstruction.
- **Limits:** Lane crossing alone does not establish final intent. Later dual-manoeuvre and completed-obstruction episodes are distinct questions.

## TS017-B — Facing-extent provider

- **Starting Reality:** Repeats TS015-B with fixed roles and 28 m lateral/12 m rearward control while observing physical identities and facing extents.
- **Suitable uses:** Representation-provider evidence and comparison of predicted contact thresholds against TS015-A/B outcomes.
- **Limits:** Bounds were usable for 0/13 resolved Condor identities; fallback dimensions and all provider results remained non-authoritative. See [Prototype 17](prototypes/PROTOTYPE_17_SHADOW_CLEARANCE_CALCULATION.md).

## TS018 — Fixture-bounded automatic admission

- **Starting Reality:** TS015-B actuation and TS017-B clearance evidence, but no manual arming; one Condor and one Patriot must remain straight, working, moving, unblocked, opposed and conflict-relevant for three seconds.
- **Suitable uses:** Automatic fixture-bounded admission, passage, rejoin, handback and later-interaction latch behaviour.
- **Limits:** The result supports only this fixture and fixed role/side arrangement. See [Prototype 18](prototypes/PROTOTYPE_18_AUTOMATIC_ENCOUNTER_ADMISSION.md).

## Retention and use

These descriptions preserve durable fixture evidence, not release chronology or superseded architecture. A saved scenario is an engineering instrument and need not remain forever. Retain one while it serves current discovery or regression value; retire it when no validation obligation requires the saved state. Durable findings remain in their responsible architecture, decisions, Research records, tests, Journal or Git history.
