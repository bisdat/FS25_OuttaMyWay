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

**Status:** Accepted baseline policy; Post-Job Configuration Normalisation Deferred

**Decision:** Wherever and however GIANTS ends an original AI job is accepted. OuttaMyWay does not choose a parking position, move the vehicle off-field or continue driving it. The completed assembly loses active membership and motion expectation but remains represented in its actual final pose as a non-member obstacle. Final relocation remains the player's responsibility.

**Deferred:** Safe in-place raising or folding may later be investigated only after control availability, sequence, sweep clearance and actual footprint reduction are proven.

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
