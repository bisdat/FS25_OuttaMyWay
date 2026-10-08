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

## Current 0.5 rewrite boundary

**Active product:** the 0.5 product shell alone: persistent player Configuration, Log Publication, a labelled status indicator, and the disabled-startup reminder. It does not observe, hold, regulate, reposition, stop, restart or otherwise control any GIANTS worker. Enabled Configuration is shell consent, **not** a claim that AI coordination is operational.

**Accepted redesign direction:** react to positive native GIANTS worker-blocked evidence rather than proactively predicting worker collisions. Explore one bounded stop / local relocation / native FIELDWORK restart intervention that allows GIANTS to replan and continue; do not require OMW axis return. The TS015 no-mod player experiment supports investigating this pattern but does not prove automatic participant choice, clearance, agronomic completion or all vehicle classes. GIANTS' native recovery and the API proposals in Issue #420 remain unvalidated for this replacement.

The detailed 0.4 Spatial Negotiation, Regulation, Passage, Candidate and Control architecture below is retained as engineering knowledge during discovery, **not as an implemented or approved new 0.5 runtime control pipeline**. Its future responsibilities will be reassessed rather than re-enabled merely because source exists.

## Current architecture breadcrumb

Start with the
[Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md)
for the former 0.4 end-to-end lifecycle and Control model (currently dormant).

Follow its responsibility routes to:

- [Spatial Negotiation Architecture](SPATIAL_NEGOTIATION_MODEL.md) — active
  spatial-coordination policy, Regulation, Cooperative Passage, Bounded Bypass,
  Passage Legs, Bubble lifecycle and third-worker protection;
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
- [GUI Architecture](GUI.md) — player-facing interface architecture; the General Settings Configuration Section is reconciled while remaining communication responsibilities are still open.

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
