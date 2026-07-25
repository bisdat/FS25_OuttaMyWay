# Glossary

## Reality
The world as it exists independently of OuttaMyWay's observations or interpretation.

## Observation
A sampled fact about Reality available to the system. Observations may be incomplete, delayed or uncertain.

## Knowledge
The system's evolving estimate of Reality reconstructed from observations.

## Situation Space
The structured set of possible situations relevant to autonomous work, including entities, states and relationships.

## Current Situation
The system's present estimated point within Situation Space. It is Knowledge, not Reality itself.

## Situation Assessment
The transformation that interprets observations and maintains the most plausible Current Situation.

## Future Space
The set of plausible future situations currently under consideration.

## Action Space
The set of actions currently available to an entity or system.

## Entity
A provisional general label for something that participates in Situation Space. The label remains under review.

## Conflict Zone
A derived spatial-temporal region in which intended motion cannot safely coexist without coordination.

## Field World
The bounded physical world defined by one field boundary polygon for one Operation. It is not the entire map.

## Field World Membership
The classification that physical geometry intersects the Field World. Membership does not imply active participation or current relevance.

## Operational Membership
Active participation in one Operation. Membership is dynamic and may end while the Entity remains physically present inside the Field World.

## Situation Relevance
The dynamic relationship by which a Field World Member can affect an Operation member or a plausible future.

## Geometry Domain Separation
The separation of GIANTS Collision Geometry, Physical Occupancy Envelope, Working Footprint, Configuration Transition Sweep and Projected Motion Sweep.

## GIANTS Collision Geometry
Physics geometry attached to model components in the GIANTS modelling environment and game runtime. It is evidence of physical contact and is not synonymous with visible width or agricultural working width.

## Physical Occupancy Envelope
The conservative ground-plane area currently occupied by the complete vehicle–implement Entity.

## Working Footprint
The ground area receiving agricultural work. It may differ from physical occupancy.

## No Silent Under-Approximation
The invariant that uncertain or incomplete geometry remains explicit rather than being represented as exact or smaller than the available evidence supports.

## Geometry Family
The purchased/configured model variant that selects the applicable collision-node, animation and working-width family. It does not describe current fold pose.

## Physical Pose
The current spatial arrangement of an Entity's physical components, including folded, transitional, deployed and articulated states.

## Model-Derived Collision Catalogue
Source-fingerprinted static knowledge of physical collision-node identity, hierarchy, configuration membership, filters and, when available, local mesh extents.

## Collision Mesh Extraction Gap
The current inability to extract trustworthy local collision-mesh bounds from the binary `.i3d.shapes` asset in the available environment.


## Operational Collision Envelope
The complete collision geometry of the vehicle plus every attached or towed implement, including configuration-dependent maximum extent and projected swept geometry.

## Full-Envelope Field Containment
The invariant that the complete Operational Collision Envelope remains wholly inside the field polygon at all times.

## Conflict Relevance Transition
A provisional change in the Current Situation whereby an Entity or object becomes a participant in a plausible conflict rather than merely being present nearby. The concept remains Deferred pending prototype evidence.

## Conflict Emergence Point
The provisional earliest observed point at which previously independent plausible trajectories form a shared Conflict Zone. Prototype 01 tests whether this point can be identified before immediate physical conflict.

## Trajectory Settlement
A provisional condition in which observed motion remains sufficiently consistent for a near-future trajectory to be treated as stable knowledge rather than a temporary manoeuvre projection.

## Conflict Confidence
A provisional relationship-level assessment that a projected Conflict Zone is persistent rather than a transient result of manoeuvring or observation variability.

## Conflict Formation Window
The provisional interval in which changing trajectories are forming a possible conflict but have not yet produced stable conflict knowledge.

## Sequential Manoeuvre Conflict
An encounter in which one Entity's manoeuvre establishes one future trajectory and another Entity's later or overlapping manoeuvre completes the shared conflict trajectory. The first TS001 evidence is consistent with this interpretation but does not assign fault.

## Passive Boundary Ordering Gap
An implementation condition in which a control consumer executes before an observer-only runtime guard, so passivity is declared but not structurally guaranteed. Discovered and corrected during Prototype 01 preparation.

## Commitment Point
The point at which preserving the existing course becomes more disruptive or risky than committing to a coordinated response.

## Traffic Picture
Legacy descriptive term for the current understanding of nearby traffic. Prefer Current Situation or Operational Picture when referring to the maintained architectural knowledge.

## Operational Picture
The existing name for the single current interpretation of decision-relevant observations maintained by Situation Assessment. Its relationship to Current Situation remains under review.

## Candidate Option Preservation Window
A provisional observed interval in which waiting by one participant might preserve alternatives while a Progress Entity reveals intent.

## Progress Entity
The participant allowed to continue so Reality can generate the evidence required for reassessment.

## Intent Revelation Point
The provisional point at which an Entity's resulting trajectory becomes settled enough to provide useful knowledge to other participants.

## Response Margin
The remaining time and manoeuvre freedom after intent revelation. No single stopping estimate is accepted as its complete representation.

## Alternate Exhaustion Point
A provisional boundary after which ordinary graceful alternatives appear to have been consumed.

## Information-Gaining Delay
A possible temporary Commitment whose purpose is to gain useful evidence before a stronger Commitment is made.

## Progress Preservation Invariant
An Information-Gaining Delay must leave at least one relevant moving participant able to generate its completion evidence.

## Observation Deadlock
A soft lock produced when all relevant moving participants are held while the wait can complete only through movement that reveals intent.

## Mutual Commitment Trap
A provisional situation in which independently acting participants commit before either can adapt to the other's revealed intention.

## Local Intent Horizon
The interval during which a settled trajectory remains useful evidence of an Entity's immediate path, without implying knowledge of its complete route.

## Intent Expiry
The transition by which locally revealed intent becomes stale because the Entity begins another manoeuvre, detaches or is no longer observed reliably.

## Encounter Chain
A sequence of linked conflicts in which changing one encounter's timing or form does not remove the underlying coordination problem.

## Safe Release Point
A provisional retrospective boundary at which release remains clear through a defined continuation horizon.

## Continuation Safety Horizon
The bounded future continuation that must remain clear before release can be considered safe. Prototype 04 uses the next observed repositioning manoeuvre and subsequent settlement.

## Commitment
A persistent intention with explicit creation, maintenance, completion and cancellation lifecycle semantics.

## Outcome Observation
An authoritative report of what Control attempted, what effect was observed and what capability was demonstrated or disproved.

## Intervention Capability Model
Control's validated account of the influence currently available to the system.

## Realizable Response Space
The overlap between what Situation Assessment says the world permits and what Control can actually influence.

## Autonomous Continuity
The continued progress of autonomous work toward completion without unnecessary player attention.

## Player Trust
The player's confidence that autonomous workers can complete their work without supervision.

## Decision Output — Name Pending
The realizable, least-disruptive change selected by Decision when passivity is no longer justified. Remedy and Variance remain candidate names, not accepted terminology.


## Engineering Increment
A bounded unit of engineering purpose that closes at a coherent breakpoint rather than at a time, chat or version boundary.

## Engineering Consolidation
Human-governed promotion and review of durable knowledge into authoritative repository homes.

## Engineering Intent
The declarative description of the accepted repository change supplied to Candidate Production instead of direct repository editing by the consolidation author.

## Canonical Repository Snapshot
The exact immutable canonical package and fingerprint used as the baseline for one Candidate Production run. It is distinct from an editable Git working tree.

## Repository Transformation
The controlled application of declared Engineering Intent to one exact Canonical Repository Snapshot, producing observable change and validation evidence without conferring authority.

## Candidate Determinism
The requirement that the same exact Canonical Repository Snapshot and fingerprint-bound Engineering Intent produce a byte-identical candidate package across supported execution platforms.

## Repository Transition
The governed movement from exact canonical baseline through Release Candidate to explicit Canonicalisation.

## Release Candidate
The governed unit comprising the candidate repository, provenance, declared transformation, findings and evidence.

## Repository Authority State
The authority classification Working, Release Candidate or Canonical; it is distinct from version identity and Git working state.

## Engineering Transformation
Substantive repository change performed during Candidate Production from the exact canonical baseline.

## Authority Transformation
The substantively pure candidate-to-canonical transformation performed only after validation, accepted review and explicit Canonicalisation.

## Canonicalisation
The repository owner's explicit declaration that the exact reviewed candidate is canonical.
