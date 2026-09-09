# Architecture documentation

Architecture describes **what the system should achieve**: its current
responsibilities, concepts, boundaries and intended behaviour. It is distinct
from implementation placement, engineering chronology and validation evidence.

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

- [Spatial Negotiation Model](SPATIAL_NEGOTIATION_MODEL.md) — active
  spatial-coordination policy, Regulation, Cooperative Passage, Passage Legs,
  Bubble lifecycle and third-worker protection;
- [Physical Representation Architecture](PHYSICAL_REPRESENTATION_ARCHITECTURE.md)
  — representation portfolios, validity and evidence quality;
- [Candidate Support Projection Architecture](CANDIDATE_SUPPORT_PROJECTION.md)
  — fresh prospective Candidate-support projection and the current
  Candidate/Decision boundary.

Phase/tranche closure audits do not own current architecture after their durable
findings have been harvested. Historical Phase-13 closure evidence remains
available through Git history and PR #71 rather than as a live architecture
child.

Current implementation placement and material architecture-to-code drift are
owned by [`../IMPLEMENTATION_MAP.md`](../IMPLEMENTATION_MAP.md). The active
engineering boundary is owned by
[`../CONTINUATION_STATE.md`](../CONTINUATION_STATE.md).

Architecture may describe intended behaviour that is not yet implemented. Read
it as the system's current responsibility model, not as implementation chronology.
