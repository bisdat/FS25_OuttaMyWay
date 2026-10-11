# System Architecture

System Architecture describes what OuttaMyWay should achieve, why its responsibilities exist, and the boundaries of its authority. It is organised by current responsibility rather than release, implementation tranche or validation history.

OuttaMyWay aims to preserve autonomous GIANTS fieldwork through the least disruptive justified intervention. GIANTS retains native productive routing and job execution. Native observations provide evidence for Situation Assessment; they do not independently authorise OuttaMyWay physical Control. The governing responsibilities and their limits are described in the documents below.

## Current architectural responsibilities

- [Project Vision](PROJECT_VISION.md) — mission, autonomous continuity, Trust Test and scope.
- [Blocked-First Situation Assessment and Hold & Relocate](BLOCKED_PROGRESS_QUALIFICATION.md) — native blockage evidence, qualification, candidate relationships, intervention responsibility, bounded egress and GIANTS handback.
- [Configuration](CONFIGURATION.md) — supported player choices, consent, persistence and change semantics.
- [Log Publication](LOG_PUBLICATION.md) — eligibility, classification and delivery of runtime and engineering log events without acquiring semantic authority.
- [GUI](GUI.md) — player-facing product status, configuration presentation, operational communication and Help/Reference boundaries.

## Related engineering surfaces

[Specification](../spec/README.md) defines implementation-facing contracts for the architectural responsibilities. [Production source](../scripts/main.lua) realises current mechanisms; neither source structure nor successful tests redefine Architecture. [Engineering documentation](../docs/README.md) provides standards, engine knowledge, validation methodology and evidence history. Substantial unresolved questions are tracked in GitHub Issues rather than maintained as a rolling status narrative here.
