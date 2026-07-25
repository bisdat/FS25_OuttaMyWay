# Engineering Journal

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
