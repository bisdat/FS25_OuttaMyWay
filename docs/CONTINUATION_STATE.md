# Continuation State

Continuation State is the compact, replace-in-place description of the
project's present engineering boundary. Git history preserves prior states; this
is not a changelog, release ledger, or canonical-release record.

## Current engineering concern

Begin the first implementation tranche of the accepted strangler transition:
**Cooperative Passage Responsibility Transition extraction**.

This documentation increment records the transition map. Once accepted, the
next activity is the bounded implementation tranche.

## Established

- The accepted [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) exists.
- Systematic live-runtime review is complete, and Option B architectural extraction / strangler recomposition is selected.
- Trusted upstream Reality acquisition, Observation, Field World and Representation evidence and downstream physical Control capability are to be preserved while the semantic and orchestration path is reconciled.
- [Naming Conventions](NAMING_CONVENTIONS.md) are authoritative.
- The [Configuration architecture](CONFIGURATION.md) is authoritative; [`scripts/config.lua`](../scripts/config.lua) remains a Mixed Runtime Constants Surface to be reconciled incrementally, not by mass cleanup.
- The [Strangler Transition Map](IMPLEMENTATION_MAP.md#detailed-strangler-transition-map), including its human-readable programme dashboard, is recorded.
- **Responsibility Acquisition at the Control Edge** is observed: `LiveControlDispatcher` currently invokes semantic lifecycle work immediately before physical Control.
- **Regulation Responsibility ≠ Regulation Actuation**: use of a Regulation actuator does not by itself identify the Current Responsibility.
- **Same-Commitment Responsibility Fusion** is observed where Regulation may be succeeded by Cooperative Passage through revision of one generic Commitment.
- **Dual Transition Authority** is the principal migration hazard; each migrated semantic responsibility must have exactly one authoritative owner.
- The first planned seam is Cooperative Passage Responsibility Transition extraction.
- No runtime behaviour changed in this documentation tranche.

## Current boundary

Architecture and migration intent are sufficiently established to begin bounded
runtime strangling. The next work is implementation, not another architecture
prerequisite. Implementation remains evidence-led: if the first extraction
exposes an architectural contradiction, update architecture deliberately rather
than forcing implementation into it.

## Next boundary

The first code tranche should, at a high level:

- trace and retain current Cooperative Passage candidate and decision inputs;
- establish Cooperative Passage responsibility before Control dispatch;
- initially reuse current Commitment, Obligation and Authority machinery;
- make the new upstream transition path the sole transition authority for Cooperative Passage;
- make the dispatcher consume already-established responsibility for that migrated path;
- preserve every non-migrated purpose on its existing path;
- preserve physical Passage mechanics and policy;
- validate behavioural equivalence; and
- record findings before selecting the next tranche.

Exact code edits remain for investigation within that implementation tranche.

## Not currently active

- Generic Commitment redesign or removal.
- Standalone Regulation redesign.
- Bounded Authority kernel redesign.
- Candidate/Constraint/Decision simplification.
- Mass `config.lua` redistribution.
- Prototype22 renaming or migration.
- Diagnostic or probe pruning.
- GUI/HUD implementation.
- Release preparation, packaging, publication or canonicalisation.
