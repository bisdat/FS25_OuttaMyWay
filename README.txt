FS25_OuttaMyWay v4.7.101 TEST BUILD — D-0146 STEP-2 ACTIVE COOPERATIVE PASSAGE

BASELINE
Owner-declared canonical v4.7.99 (`c3f1f6493fd0e44c8447637827989117daa77a20ba80816cf34270484e5eea8d`; 307 files). v4.7.100 supplied the first live validation of D-0146 Step-1 Situation Knowledge.

PURPOSE
Implement the already-agreed D-0146 Step 2 as one coherent active path: Established Opposed Corridor Conflict -> Candidate-owned Local Passage Space / Progressive Passage Search -> sufficient Passage Arrangement -> multi-gate Passage Guide -> normal Decision / Commitment / Authority -> central Control execution.

IMPLEMENTATION BOUNDARY
- Step-1 `trajectoryKnowledge` / `opposedCorridorKnowledge` remains Situation-owned.
- `PassageCapabilityAssessment` publishes purpose-specific mechanical Representation Fitness. Current executable mechanics are deliberately bounded to the demonstrated P23 Condor Endurance II / Patriot 4450 compact/hold/reposition/restore profile; no general-vehicle or generic negative-clearance authority is claimed.
- `LocalPassagePlanner` owns the Step-2 search. It satisfices over symmetric, asymmetric and unilateral burden splits and emits an explicit five-gate Passage Guide.
- Candidate/Constraint/Decision/Commitment use the normal production chain. Control executes only the supplied Guide; it does not invent Local Passage Space or replacement geometry.
- Candidate search samples the complete centreline guide against the immutable current Field World and samples simultaneous pair centre separation against the bounded P23 empirical profile. Boundary Encroachment remains architecturally legitimate but is not required or newly claimed by this bounded expression.
- Passage Support Loss at a Control gate causes safe halt/restore/hold and an explicit Passage Reassessment outcome; Control does not silently broaden the plan.
- v4.7.100 Diagnostic Churn is corrected by excluding continuously changing trajectory/conflict measurements from transition signatures while retaining those measurements in emitted evidence.
- Historical D-0143 TS015 Candidate/Control code remains only as a regression/mechanical donor when the D-0146 Step-2 flag is explicitly disabled.

VALIDATION STATUS
Offline before packaging: Lua behavioural suite 204/204 PASS; Python structural/conformance suite 104/104 PASS. Live GIANTS validation is required for the active Passage Guide.

LIVE EVIDENCE TO WATCH
`D0146_PASSAGE_SUPPORTED` -> normal Constraint/Decision/Commitment creation -> `COOPERATIVE_ACCEPTED architecture=D0146_STEP2` -> `START architecture=D0146_STEP2` -> ordered `GUIDE_START` / `GUIDE_REACHED` gates -> RESTORE -> HANDOFF. Any support failure should produce `PASSAGE_REASSESSMENT ... outcome=SAFE_ABANDON_ESCALATE`.
