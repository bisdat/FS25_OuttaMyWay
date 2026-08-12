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
