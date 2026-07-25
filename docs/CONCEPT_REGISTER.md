# Architectural Concept Register

Review status: reviewed for canonical release v4.6.10.

## Accepted Concepts

### Situation Space

The structured set of possible situations relevant to autonomous work. It contains entities, states and relationships rather than merely an inventory of nearby objects. Environmental influences such as weather belong within Situation Space rather than requiring a separate Conditions concept.

### Current Situation

The system's present estimated point within Situation Space. It is knowledge reconstructed from observations, not Reality itself. The existing term `Operational Picture` remains in use while the vocabulary relationship is reviewed.

### Future Space

The set of plausible future situations currently under consideration. It deliberately preserves multiple possibilities rather than treating one prediction as certain.

### Action Space

The set of actions currently available to an entity or system. Anticipation is valuable because it preserves Action Space before options collapse.

### Situation Assessment

The transformation that interprets observations and maintains the most plausible Current Situation. It represents evolving risk, uncertainty, constraints and permitted responses; it does not issue control commands.

### Commitment

A persistent intention to perform an action. Commitment owns creation, maintenance, completion and cancellation. Situation Assessment may provide evidence that a commitment remains valid or should end, but does not continuously replace it with each new observation.

### Conflict Zone

A derived operational concept: a spatial-temporal region in which intended motion cannot safely coexist without coordination. It remains useful for describing elevated interaction risk, but is no longer treated as a root architectural primitive.

### Field World

The bounded physical world defined by one field boundary polygon for one Operation. It includes physical geometry within the polygon but does not expand to the whole map.

### Field World Membership

The classification that physical geometry intersects the bounded Field World. Membership does not imply active participation, agency or current relevance. Prototype 05 strongly validated vehicle membership independently of active AI state, and Prototype 06 retained the same Condor Field World identity through a live completion transition in TS003.

### Operational Membership

The dynamic subset of Entities actively participating in one Operation. Prototype 05 validated that a completed vehicle may remain a Field World Member while excluded from Operational Membership. Prototype 06 strongly validated that a live `OPERATION_MEMBER -> NON_OPERATION_VEHICLE` transition can be latched exactly once while Field World identity is retained.

### Situation Relevance

The dynamic relationship by which a Field World Member can affect an Operation member or a plausible future. Prototype 05 strongly validated changing geometric relevance. Prototype 06 additionally validated role-aware relationship reclassification when a participant leaves Operational Membership, even when the relevant/not-relevant result itself does not change. Relevance is not inferred from membership alone.

### Geometry Domain Separation

The accepted separation between GIANTS Collision Geometry, the derived Physical Occupancy Envelope, the agronomic Working Footprint, Configuration Transition Sweep and Projected Motion Sweep. None may silently substitute for another.

### GIANTS Collision Geometry

Physics evidence attached to GIANTS model components. It is an implementation evidence source for physical contact, not the same as visible model width or agricultural working width.

### Physical Occupancy Envelope

A conservative ground-plane representation of the complete Entity's current physical extent, aggregated across the vehicle and every attached or towed implement. Prototype 08 validated configuration-aware live collision-node identity and pose for Condor, but local collision-mesh extents remain unresolved; no authoritative envelope yet exists.

### Working Footprint

The area currently affected agronomically. It may be wider, equal to or narrower than the Physical Occupancy Envelope and shall not be used as a substitute for collision geometry.

### No Silent Under-Approximation

The invariant that unknown, partial or low-confidence geometry remains explicit. Situation Assessment may not present an Entity as physically smaller than the discovered evidence supports.

### Runtime Geometry Access Gap

The accepted implementation finding that GIANTS' internal collision geometry is not necessarily exposed as usable bounds through the mod Lua runtime. Prototype 07 found rigid-body type but no tested shape/local/world bounding functions or collision-mask query, and therefore produced no complete-Entity Physical Occupancy Envelope.

### Operational Collision Envelope

The complete collision geometry of the vehicle and every attached or towed implement, including configuration-dependent maximum extent and the projected swept geometry of the intended movement.

### Full-Envelope Field Containment

The invariant that every AI worker's complete Operational Collision Envelope remains wholly inside the field polygon at all times. External geometry should not require obstacle handling because the worker envelope must never reach beyond the boundary. Prototype 05 promoted the invariant but did not validate exact envelope geometry, projected sweep or active containment.

### Configuration–Pose Separation

The purchased Geometry Family, current Physical Pose and Operational State are independent dimensions. Configuration selects the applicable collision-node family; live transforms establish current pose. Prototype 08A strongly validated this separation for the 36 m Condor through one complete folded-to-deployed lifecycle.

### Save-State Geometry Bridge

Model assets provide collision identity, hierarchy and configuration membership, while save/runtime state provides persistent Entity identity, selected configuration, root pose, fold state and authoritative live node transforms. Prototype 08 showed that offline animation reconstruction is useful diagnostic evidence but must not replace live pose.

### Collision Mesh Extraction Gap

The I3D XML exposes physical collision-node identity and transforms, but trustworthy local mesh extents remain inside the binary `.i3d.shapes` asset until a validated extraction route exists. The gap must remain explicit.

### Live Collision Node Pose

The current runtime transform of a named physical collision node relative to its complete Entity root. Prototype 08A strongly validated that all eight configured Condor boom collision nodes can retain identity and move continuously through a full fold transition. Node pose is not node extent.

### Segmented Tapered Occupancy

A model-specific compound-geometry pattern in which articulated sections have distinct dimensions and may become progressively narrower toward an outer tip. Condor's four sections per side support this interpretation visually, but the concept does not prescribe a generic shape: every foldable implement must derive segmentation, dimensions, activation and articulation from its own evidence.

## Deferred Concepts

### Conflict Relevance Transition

A change in the Current Situation whereby an Entity or object moves from being merely present to participating in a plausible conflict. Prototype 01 seeks evidence that this transition can be observed consistently without treating proximity alone as conflict.

### Conflict Emergence Point

The earliest observed point at which previously independent plausible trajectories form a shared Conflict Zone. The first TS001 evidence supports detectability well before immediate physical conflict, but the concept remains Deferred until its stability and architectural lifecycle are established.

### Trajectory Settlement

A provisional condition in which an Entity's observed motion has remained sufficiently consistent that its near-future trajectory may be treated as stable knowledge rather than a temporary manoeuvre projection. Prototype 02 evidence supports an observable boundary and distinct per-Entity explanatory value, but the concept remains Deferred pending broader lifecycle evidence.

### Conflict Confidence

A provisional relationship-level assessment of whether a projected Conflict Zone represents a persistent plausible future rather than a transient projection. Prototype 02 evidence supports a distinct relationship-level responsibility, but the concept remains Deferred pending generalisation beyond the single TS001 encounter and correction of the realised-conflict lifecycle.

### Conflict Formation Window

The provisional interval during which manoeuvring Entities progressively reshape their trajectories but the resulting conflict has not yet become stable knowledge. Prototype 02 observed a meaningful `FORMING` interval before establishment, but the concept remains Deferred until its opening, closing and relation to remaining alternatives are tested directly.

### Candidate Option Preservation Window

A provisional interval in which overlapping unsettled manoeuvres may consume safe alternatives, while temporary restraint of one participant might allow a Progress Entity to reveal useful intent. Prototype 03 observed a meaningful window and an actionable temporal margin before conflict establishment, but the concept remains Deferred pending spatial hold safety, continuation intent and broader scenarios.

### Progress Entity

The participant left able to continue so Reality can generate the evidence required for reassessment. Prototype 03 identified Condor as a useful Progress Entity while Patriot retained temporal margin, but the concept remains Deferred pending continuation and multi-participant evidence.

### Intent Revelation Point

The provisional point at which a manoeuvring Entity's resulting trajectory becomes settled enough to provide useful knowledge to other participants. Prototype 03 observed a locally useful boundary, but the manual follow-up showed that current-lane revelation is not complete route intent or sufficient safe-release evidence. The concept remains Deferred.

### Response Margin

The provisional time and manoeuvre freedom remaining after intent revelation. Prototype 03 measured approximately 7.42 s of conservative temporal margin in TS001, but spatial hold safety and route continuation remained unproven. The concept remains Deferred and must not be reduced to one stopping formula.

### Alternate Exhaustion Point

A provisional boundary after which ordinary graceful alternatives appear to have been consumed. Prototype 03 used conflict establishment as a useful diagnostic proxy, but later encounter formation shows that exhaustion and resolution must be evaluated across continuing route interactions. The concept remains Deferred.

### Information-Gaining Delay

A possible temporary Commitment whose purpose would be to allow Reality to reveal useful intent before a stronger Commitment is made. Prototype 03 supports the availability of temporal margin, but the manual follow-up disproved local intent as sufficient release evidence. The concept remains Deferred and is not implemented.

### Progress Preservation Invariant

A provisional architectural invariant for Information-Gaining Delay: at least one relevant moving participant must remain able to generate the evidence required to complete the wait. Prototype 03 preserved one Progress Entity throughout the real window; the invariant remains Deferred pending active and multi-participant validation.

### Observation Deadlock

A state in which every relevant moving participant is held while the completion condition depends on one of them moving to reveal intent. The concept is scoped to observation-enabling delay and does not prohibit a separately governed Emergency Arrest Commitment.

### Mutual Commitment Trap

A provisional situation in which independently acting participants cross their respective Commitment Points before either can adapt to the other's revealed intention. Prototype 03 observed useful precursors and temporal margin before establishment, but the later crossing encounter showed that avoiding one trap may expose another. The concept remains Deferred.

### Local Intent Horizon

The provisional interval during which an Entity's settled trajectory remains useful knowledge of its immediate path. Prototype 04 observed stable bounded epochs and directly disproved their interpretation as complete route knowledge. The concept remains Deferred pending broader Entities, manoeuvres and Field World observation.

### Intent Expiry

The provisional transition by which previously useful local intent becomes stale. Prototype 04 strongly supported new manoeuvre and worker detachment as explicit expiry evidence. The concept remains Deferred pending generalisation beyond active GIANTS workers and the single TS001 fixture.

### Encounter Chain

A provisional sequence of linked conflicts in which an intervention changes the timing or form of an encounter without eliminating the underlying coordination problem. Prototype 04 observed an unsafe later repositioning toward parked Patriot and a final shared-position conflict after completed Condor left active observation. The concept remains Deferred and the manual intervention remains qualified by Job Restart Perturbation.

### Safe Release Point

A provisional boundary at which releasing a held Entity leaves its resumed path clear through a defined continuation horizon. Prototype 04 did not establish this boundary: the original parked position became unsafe, while the later clear continuation followed manual relocation and could not validate the original hold site. The concept remains Deferred and no release authority exists.

### Continuation Safety Horizon

The bounded future continuation that must remain clear before release can be considered safe. Prototype 04 supports the next manoeuvre as a useful limited horizon, but also shows that the horizon is incomplete when physically relevant non-workers disappear from observation. The concept remains Deferred and does not imply knowledge of a complete GIANTS route.

### Opportunity

Useful descriptive language for a possible pre-commitment course of action, but current evidence does not show an independent lifecycle or responsibility. Reconsider when observations reveal competing intentions that must persist or be governed before Commitment exists.

### Entity Naming

The architecture requires a general participant concept broader than a vehicle or worker. `Entity` is the current candidate label, but naming remains Deferred until the concept's boundary is demonstrated consistently.

### Repository Folder Numbering

The existing numbered structure is retained. Reconsider only when evidence identifies a navigation or continuity problem that a numbering change would solve.

### Operational Picture versus Current Situation

The two terms may describe the same maintained knowledge. Keep both under review until ownership, lifecycle or explanatory difference is demonstrated.

## Rejected Concepts

### Conditions

Rejected as a separate architectural concept because weather and comparable environmental influences already belong within Situation Space. Reconsider only if an independent lifecycle or responsibility is observed.

## Architectural Dimensions and Distinctions

### Reality and Knowledge

Reality exists independently of the system. Knowledge is the system's evolving estimate reconstructed from observations. This distinction is architectural knowledge rather than an independently owned component.

### Time

Time is the dimension in which Reality evolves, observations occur, Knowledge changes, Future Space is reconsidered and Action Space expands or collapses. It is not another processing component.

## Review Rule

At every canonical release, review all sections against current evidence. Promotion, deferral, rejection or demotion requires a recorded rationale in `DECISION_LOG.md` or an ADR. An unchanged review is still recorded in the release changelog.


## Repository Release Concepts

### Engineering Increment

The bounded unit of engineering purpose. It closes when its declared purpose reaches a coherent breakpoint; time, chat boundaries and version numbering do not define completion.

### Engineering Consolidation

The human-governed promotion of durable architectural, implementation and operational knowledge into authoritative repository homes, followed by review for completeness.

### Engineering Intent

The declarative description of the repository change that has been discussed, decided and approved for Candidate Production. It crosses the collaboration boundary without requiring the consolidation author to modify repository files directly.

### Canonical Repository Snapshot

The exact immutable package and integrity fingerprint established as the baseline for one Candidate Production run. It represents the canonical repository at a specific point and is distinct from an editable Git working tree.

### Repository Transformation

The controlled application of declared Engineering Intent to one exact Canonical Repository Snapshot, with observed delta, validation findings and evidence. It changes repository content; it does not itself confer authority.

### Candidate Determinism

The invariant that the same exact Canonical Repository Snapshot and fingerprint-bound Engineering Intent produce one byte-identical candidate package across supported execution platforms. Platform-neutral path ordering and platform-independent archive metadata are implementation obligations of Candidate Production.

### Repository Transition

The governed movement from the exact canonical baseline through Release Candidate, accepted review and explicit Canonicalisation to the next canonical repository.

### Repository Authority State

Working, Release Candidate and Canonical are distinct authority states independent of version identity and Git working state.

### Engineering Transformation

The declared substantive Repository Transformation performed during Candidate Production from the exact Canonical Repository Snapshot.

### Authority Transformation

The candidate-to-canonical authority change. It must not alter approved substantive engineering content.
