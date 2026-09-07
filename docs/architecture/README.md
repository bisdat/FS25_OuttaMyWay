# Architecture documentation

Architecture describes **what the system should achieve**: its responsibilities,
concepts, boundaries, and intended behaviour. It is distinct from both the code
that currently realises those responsibilities and the validation evidence that
tests assumptions against runtime reality.

## Current architecture breadcrumb

Start with the
[Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md)
for the end-to-end lifecycle and responsibility model. Follow its breadcrumb to
the [Spatial Negotiation Model](SPATIAL_NEGOTIATION_MODEL.md) for active
spatial-coordination policy, or to the
[Physical Representation Architecture](PHYSICAL_REPRESENTATION_ARCHITECTURE.md)
for representation detail.

For the Phase-13 Candidate/Decision boundary, including the Reality-driven
correction to fresh multi-purpose Candidate enumeration, read the
[Candidate Support Projection Architecture](CANDIDATE_SUPPORT_PROJECTION.md).

For the final post-`.20` responsibility audit and the decision that Phase 13 is
complete, read the [Phase 13 Closure Audit](PHASE_13_CLOSURE_AUDIT.md).

For the Phase-14 architecture-to-runtime placement audit covering production
mechanics still named or located as Prototype/Diagnostic/legacy integration,
read the [Phase 14 Production Placement Audit](PHASE_14_PLACEMENT_AUDIT.md).

For the first Phase-14 engineering boundary, separating production
Regulation Control from the Prototype22 manual harness while preserving the
existing physical drive mechanism, read the
[Phase 14.1 Production Regulation Control Boundary](PHASE_14_REGULATION_CONTROL_BOUNDARY.md).

For the second Phase-14 engineering boundary, graduating the proven Hold,
Drive and Configuration mechanisms from Prototype placement and making `main.lua`
the production composition root, read the
[Phase 14.2 Physical Capability Graduation](PHASE_14_PHYSICAL_CAPABILITY_GRADUATION.md).

For the third Phase-14 engineering boundary, graduating production live
interaction evidence from Diagnostic to Observation placement without changing
its calculations or evidence meaning, read the
[Phase 14.3 Live Interaction Observation Graduation](PHASE_14_LIVE_INTERACTION_OBSERVATION_GRADUATION.md).

For the fourth Phase-14 engineering boundary, graduating the shared warm/cold
non-job physical actuation donor from misleading post-job Authority placement
while preserving both semantic authority classes, read the
[Phase 14.4 Non-Job Actuation Mechanism Graduation](PHASE_14_NON_JOB_ACTUATION_MECHANISM_GRADUATION.md).

Architecture may describe intended behaviour that is not yet implemented. Read
it as the system's direction and responsibility model, not as a complete account
of current runtime capability.
