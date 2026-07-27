# Decision Log

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
