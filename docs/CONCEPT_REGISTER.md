# Architectural Concept Register

Review status: reviewed for canonical release v4.6.3.

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
