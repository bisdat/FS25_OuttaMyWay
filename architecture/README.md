# System Architecture

Architecture describes **what the system should achieve**: its current
responsibilities, concepts, boundaries and intended behaviour. It is distinct
from implementation placement, engineering chronology and validation evidence.

`/architecture` is a first-class engineering surface alongside `/spec`, `/scripts` and `/tests`. Their repository addressability is peer-level; their authority is not: Architecture owns current system meaning, Specification owns implementation-facing contract, source owns current mechanism, and tests provide evidence.

> **First-Class Authority Deserves First-Class Addressability.**

A future engineer should be able to reconstruct the present architecture
directly from this live tree. Phase/tranche migration history belongs in Git,
pull requests, Issues, the Engineering Journal and other authorised
evidence/history surfaces; it must not be replayed as a sequence of live
architecture deltas.

## Current architecture breadcrumb

Start with the
[Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md)
for the end-to-end lifecycle, authority and Control model.

Follow its responsibility routes to:

- [Spatial Negotiation Architecture](SPATIAL_NEGOTIATION_MODEL.md) — active
  spatial-coordination policy, Regulation, Cooperative Passage, Passage Legs,
  Bubble lifecycle and third-worker protection;
- [Physical Representation Architecture](PHYSICAL_REPRESENTATION_ARCHITECTURE.md)
  — physical identity resolution, assessment representation, scoped geometry
  authority, coverage and evidence quality;
- [Candidate Support, Constraint and Decision Architecture](CANDIDATE_SUPPORT_PROJECTION.md)
  — fresh prospective Candidate support, mandatory Constraint Evaluation and
  Decision before Responsibility Transition.

Other direct live Architecture responsibilities are:

- [Project Vision](PROJECT_VISION.md) — mission, Trust Test, Autonomous Continuity,
  scope, and product-level direction;
- [Configuration Architecture](CONFIGURATION.md) — supported player-choice and
  consent surface, admission rules, defaults, persistence, and authority boundaries;
- [Log Publication Architecture](LOG_PUBLICATION.md) — controlled projection of
  already-established runtime/engineering facts into NORMAL, DEBUG and DIAGNOSTIC
  GIANTS-log publication without acquiring semantic authority;
- [GUI Architecture](GUI.md) — deferred player-facing interface and communication
  architecture responsibility.

Phase/tranche closure audits do not own current architecture after their durable
findings have been harvested. Historical Phase-13 closure evidence remains
available through Git history and PR #71 rather than as a live architecture
child.

Current implementation placement is reached through the governing primary
Specifications under [`/spec`](../spec/README.md) and their implementation
traceability into `/scripts`. Substantial unresolved engineering work is owned
by the responsible GitHub Issue where one exists; Issues provide work-item
context but do not become Architecture or accepted implementation authority.

Architecture may describe intended behaviour that is not yet implemented. Read
it as the system's current responsibility model, not as implementation chronology.
