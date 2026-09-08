# Architecture documentation

Architecture describes **what the system should achieve**: its current responsibilities, concepts, boundaries and intended behaviour. It is distinct from implementation placement, engineering chronology and validation evidence.

A future engineer should be able to reconstruct the present architecture directly from this live tree. Phase/tranche migration history belongs in Git, pull requests, the Engineering Journal and other authorised evidence/history surfaces; it must not be replayed as a sequence of live architecture deltas.

## Current architecture breadcrumb

Start with the [Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) for the end-to-end lifecycle, authority and Control model.

Follow its responsibility routes to:

- [Spatial Negotiation Model](SPATIAL_NEGOTIATION_MODEL.md) — active spatial-coordination policy, Regulation, Cooperative Passage, Passage Legs, Bubble lifecycle and third-worker protection;
- [Physical Representation Architecture](PHYSICAL_REPRESENTATION_ARCHITECTURE.md) — representation portfolios, validity and evidence quality;
- [Candidate Support Projection Architecture](CANDIDATE_SUPPORT_PROJECTION.md) — fresh prospective Candidate-support projection and the current Candidate/Decision boundary.

The retained [Phase 13 Closure Audit](PHASE_13_CLOSURE_AUDIT.md) remains a live direct child pending a separate responsibility review. It is historical closure evidence, not the primary owner of current runtime architecture.

Current implementation placement and strangler drift are owned by [`../IMPLEMENTATION_MAP.md`](../IMPLEMENTATION_MAP.md). The active engineering boundary is owned by [`../CONTINUATION_STATE.md`](../CONTINUATION_STATE.md).

Architecture may describe intended behaviour that is not yet implemented. Read it as the system's current responsibility model, not as an implementation chronology.