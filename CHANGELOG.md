# Changelog

## v4.6.3 — Prototype 02: Conflict Confidence

- Added passive Prototype 02 instrumentation for Trajectory Settlement and conflict-persistence evidence.
- Named Conflict Formation Window and Sequential Manoeuvre Conflict from the first TS001 evidence without assigning fault to either worker.
- Added per-Entity heading/speed change rates, stable-motion duration and provisional settlement interpretation.
- Added pair-level conflict-positive persistence, dCPA spread, projected Conflict Zone drift and tCPA countdown-consistency evidence.
- Added provisional `CLEAR`, `FORMING`, `ESTABLISHED`, `DECAYING` and `CLEARED` diagnostic states with every threshold exposed in the log.
- Retained Prototype 01 and published only its side-effect-free kinematic helpers for diagnostic reuse.
- Added the Prototype 02 hypothesis, evidence contract, unchanged TS001 procedure and validation questions.
- Traffic Manager v2 remains disabled; no Decision, Commitment or vehicle-control behaviour is introduced.
- The unchanged TS001 run kept the earlier harmless head-on pass `CLEAR`, produced a meaningful `FORMING` interval, and reached `ESTABLISHED` at approximately 266.5 m separation, about 18.5 s before both workers became blocked.
- The player observed no further direction change after settlement and confirmed the final outcome remained a head-on collision.
- Disproved the provisional assumption that loss of future-trajectory evidence means resolution: after collision the probe reported `DECAYING` then `CLEARED` while both workers remained physically blocked.
- The repository owner reviewed and tested the exact v4.6.3 candidate and explicitly declared v4.6.3 canonical.

## v4.6.2 — Prototype 01: Conflict Emergence Point

- Added passive Prototype 01 instrumentation for the unchanged TS001 two-worker head-on encounter.
- Recorded position, heading, speed, separation, closing rate, closest-approach time/distance, projected conflict location and provisional stage transitions.
- Deferred Conflict Relevance Transition and Conflict Emergence Point pending in-game evidence.
- Discovered and corrected the Passive Boundary Ordering Gap: observer-only mode now returns before Traffic Manager v2 can decide or execute.
- Disabled Traffic Manager v2 explicitly and added a runtime passive-configuration check for the probe.
- Added the evidence contract, TS001 procedure, validation questions and searchable log prefixes.
- No avoidance response, Commitment change or positive vehicle-control action is introduced.
- First TS001 evidence distinguished harmless head-on proximity from an emerging projected conflict and recorded the Conflict Emergence Point at 318.38 m separation with 29.66 s projected time to closest approach.
- The repository owner reviewed and tested the exact v4.6.2 candidate and explicitly declared v4.6.2 canonical.

## v4.6.1 — Repository Release System Consolidation Candidate

- Accepted D-RRS-24 (Engineering Intent Boundary), D-RRS-25 (Fingerprint-Bound Engineering Intent) and D-RRS-26 (Candidate Determinism and Evidence Provenance).
- Promoted Engineering Intent, Canonical Repository Snapshot, Repository Transformation and Candidate Determinism into authoritative architecture and vocabulary.
- Recorded the first complete local RRS evolution, fingerprint-block, regenerated-handoff, owner-review, Canonicalisation and Git-synchronisation cycle.
- Disproved the assumption that fixed timestamps and permissions alone guaranteed cross-platform package determinism; named the Artifact Determinism Gap.
- Implemented one relative POSIX-path ordering rule for inventory, manifest and package generation, explicit ZIP origin/permission metadata, and stored entries independent of host compression libraries.
- Added focused regression tests for mixed-case path ordering, creation-order independence and ZIP metadata.
- Documented post-Canonicalisation Git alignment and clarified that Git working state is distinct from repository authority state.
- Clarified that documents use the ordering natural to their human-reading purpose; no global sorting rule applies.
- Recorded dirty-working-tree awareness and the remaining RRS assurance boundaries as deferred follow-up.
- No intentional vehicle-control behaviour changes.

## v4.6.0 — Repository Release System Recovery

- Recorded D-RRS-01 through D-RRS-23 as the accepted Repository Release System decision set.
- Promoted the RRS lifecycle, authority states, roles, gates, transformations and evidence responsibilities into authoritative repository knowledge homes.
- Registered the RRS architecture and operational documentation in repository policy and navigation.
- Documented the recovered candidate-production implementation boundary and its deferred Authority Transformation work.
- No intentional vehicle-control behaviour changes.

## v4.5.9
- Seminar Series 4 repository mining.
- Decision Engine refined as continuous commitment evaluator.
- Adopted Least Intervention and Grace as architectural quality attributes.
- Introduced Architectural Prototyping as next project phase.

- Repository mining from Seminar 06.
- Refined Operational Picture as coherent operational understanding.
- Clarified Continuous Operation vs Temporary Augmentation.
- Decision Engine identified as consumer of Operational Picture.
- Recorded architectural governance that ADRs may be refined/superseded by evidence.
- Removed previous failing /tools folder and contents

## v4.5.6 — Seminar Knowledge Distribution Release

- Classified Seminar 01–06 outputs across the Concept Register, Decision Log, Glossary, Project Status and Handover.
- Accepted Situation Space, Current Situation, Future Space and Action Space; clarified Situation Assessment as a transformation.
- Distinguished Reality from Knowledge and recorded Time as the architectural evolution dimension.
- Retained Conflict Zone as a derived operational concept, explicitly rejected Conditions, and deferred Entity and Operational Picture terminology.
- Recorded the process discovery that seminar mining must distribute knowledge by ownership and lifecycle.
- No intentional vehicle-control behaviour changes.

## v4.5.4 — Governance Recovery and Architectural Seminar Release

- Reconstructed the release from the last verified v4.5.3 canonical baseline and preserved Chat 04 governance findings plus the complete Chat 05 seminar series.
- Added Repository Review, Repository Completion Patch, independent packaged-release Repository Identity Check and evidence-based recovery rules.
- Expanded Engineering Continuity into Navigation, Prediction and Overall Assessment.
- Recorded deferred repository numbering and Operational Picture/Current Situation review, rejected Conditions, and preserved the evolution from Conflict Zone through Future Space, Action Space, Situation Space, Reality/Knowledge and Time.
- No intentional vehicle-control behaviour changes.

## v4.5.3 — Repository Identity and Compatibility Cleanup

- Restored one canonical v4.5.3 identity across runtime metadata, package entry points, current-state documents and tooling examples.
- Distinguished current release identity from historical version records so changelogs, decisions and archived lifecycle statements retain their original versions.
- Removed expired root-level compatibility signposts and retained the superseded documents solely under `docs/archive/compatibility/`.
- Populated `DOCUMENTATION_STANDARD.md` and enforced the canonical `OuttaMyWay` name and project-free document titles.
- Strengthened release preparation and verification so stale current-version examples and compatibility signposts fail validation.
- No intentional vehicle-control behaviour changes.

## 4.5.1 — Repository Governance Release

- Added explicit document authority, currency and lifecycle governance.
- Added `PROJECT_CONTINUITY.md` and the Engineering Continuity Test.
- Added the rule that every repository modification begins from a supplied current canonical baseline.
- Completed the documentation map and breadcrumb journey.
- Renamed `Engineering_Handbook.md` to `ENGINEERING_HANDBOOK.md` and replaced stale version metadata with currency metadata.
- Archived superseded engineering documents under `docs/archive/compatibility/` while retaining old-path signposts.
- Extended repository verification to check documentation coverage, filename casing, compatibility/archive placement and stale version declarations.
- No intentional vehicle-control behaviour changes.

## v4.5.0

- Established the development repository as an explicit engineering knowledge system optimised first for seamless continuation across chats and sessions, and second for future contributor comprehension.
- Added `ENGINEERING_ARCHITECTURE.md`, `CONCEPT_REGISTER.md`, `DECISION_LOG.md`, `ENGINEERING_JOURNAL.md` and `tools/README.md`.
- Made current status, continuation guidance, concept governance, decisions, discoveries, history and tooling separate repository responsibilities.
- Added `verify_repository.py` and integrated repository-coherence checks into the release pipeline.
- Reviewed the architectural concept registers: Conflict Zone, Situation Assessment and Commitment remain Accepted; Opportunity remains Deferred; no concepts are Rejected.
- Consolidated overlapping engineering method and workflow authority under `ENGINEERING_ARCHITECTURE.md` while retaining compatibility pointers.
- No intentional vehicle-control behaviour changes.

## v4.4.1

- Accepted Commitment as a first-class architectural concept with creation, maintenance, completion and cancellation lifecycle semantics.
- Deferred Opportunity pending evidence of an independent lifecycle or responsibility.
- Added recurring review of Accepted, Deferred and Rejected concept registers at each canonical repository update.
- Strengthened the release pipeline so both changelogs must contain the target release heading before packaging.
- Reconciled all embedded version records after the incomplete v4.4.0 packaging attempt.
- No intentional vehicle-control behaviour changes.

## v4.3.9

- Established Situation Assessment as the sole interpreter of observations and the single source of operational truth.
- Routed Control and Recovery outcomes back as Outcome Observations through Situation Assessment before further decisions.
- Added Project Vision, Autonomous Continuity and the Trust Test.
- Added the Architectural Discovery Method and Ownership Test.
- Preserved the unnamed Decision output as an open architectural hypothesis; Remedy and Variance remain candidates.
- Added automated release preparation, version audit and manifest generation tooling.
- No intentional vehicle-control behaviour changes.

## v4.3.8

- Completed Situation Assessment architecture.
- Added Decision Readiness.
- Added Decision-Relevant World.
- Added Decision-Relevant Constraints.
- Added Relevance Envelope.
- Added Option Horizon.
- Clarified the Situation Assessment ↔ Decision Engine boundary.

# Changelog

## v4.3.6
- Reconciled all embedded project version records to 4.3.6.
- Added the canonical Engineering Handover and expanded Project Status.
- Recorded Situation Assessment contract definition as the next evidence-driven task.
- Regenerated the complete SHA-256 release manifest.
- No intentional vehicle-control behaviour changes.

## v4.3.5
- Adopted repository-first engineering workflow.
- Added Engineering Workflow document.
- Recorded engineering handover methodology.
- Established mandatory knowledge mining before starting new chats.
