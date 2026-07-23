# Decision Log

This log records Accepted, Deferred, Rejected and Superseded project choices that do not require a full Architecture Decision Record. Newer decisions appear first.

## D-0014 — Reject Conditions and demote Conflict Zone from root primitive

**Status:** Accepted in v4.5.7

**Decision:** Conditions is rejected as a separate concept because environmental influences already belong within Situation Space. Conflict Zone remains useful operational language but is treated as derived rather than a root architectural primitive.

**Reason:** Both conclusions emerged from attempts to explain the observed world with fewer independent concepts and fewer special cases.

## D-0013 — Defer Entity and Operational Picture terminology

**Status:** Deferred in v4.5.7

**Decision:** Retain `Entity` as a provisional label and retain both `Operational Picture` and `Current Situation` until evidence establishes stable boundaries or equivalence.

**Reason:** Confidence in the underlying concepts is higher than confidence in their names. Vocabulary must not force premature architecture.

## D-0012 — Distinguish Reality, Knowledge and Current Situation

**Status:** Accepted in v4.5.7

**Decision:** Reality exists independently; observations sample Reality; Situation Assessment transforms observations into Knowledge; Current Situation is the present estimated point within Situation Space. Time is the dimension in which each evolves.

**Reason:** The distinction explains uncertainty, hidden hazards and delayed understanding without adding special-case mechanisms.

## D-0011 — Accept the Spaces architectural family

**Status:** Accepted in v4.5.7

**Decision:** Accept Situation Space, Future Space and Action Space as architectural concepts. Treat Situation Assessment as a transformation between observations and maintained Knowledge rather than as another Space.

**Reason:** The three Spaces describe different sets: possible situations, plausible futures and available actions. Their distinctions survived repeated attempts at simplification and clarified observed expert behaviour.

## D-0010 — Require independent packaged-release identity verification

**Status:** Accepted in v4.5.4

**Decision:** Generation and verification are separate activities. A release is not canonical until the packaged ZIP itself passes an independent Repository Identity Check.

**Reason:** A package filename and a successful build claim did not prove that the archive contained the intended canonical baseline.

## D-0009 — Reconstruct questioned history from evidence

**Status:** Accepted in v4.5.4

**Decision:** If canonical status is questioned, rebuild from the last verified canonical baseline and preserved mining summaries, review records or transcripts rather than recollection.

## D-0008 — Defer repository folder numbering

**Status:** Deferred in v4.5.4

**Decision:** Retain the existing `00_`, `10_` … `50_` numbering until evidence identifies the engineering problem that a numbering change would solve.

**Reason:** The question is not whether numbering is aesthetically preferable, but whether it solves an observed continuity or navigation problem. No such evidence currently exists.

## D-0004 — Optimise the development repository for continuity first

**Status:** Accepted in v4.5.0

**Decision:** The development repository's primary audience is the continuing engineering collaboration across new chats and sessions. It must preserve enough explicit current knowledge that conversational memory is unnecessary. A secondary audience is future intelligent contributors.

**Reason:** Seamless continuation is the immediate operational risk. The same explicit knowledge that protects continuity also improves contributor comprehension.

**Consequence:** Internal handovers, discoveries, decision rationale and release tooling remain in the development repository even if a future public repository is editorially reduced.

**Review:** Revisit when public GitHub publication begins.

## D-0003 — Treat the repository as the source of project knowledge

**Status:** Accepted in v4.5.0

**Decision:** Reality remains authoritative. The repository records current project knowledge and must be corrected when evidence disproves it.

**Reason:** Calling the repository the source of truth could encourage defending recorded assumptions against contrary evidence.

## D-0002 — Defer Opportunity

**Status:** Accepted in v4.4.0; reviewed unchanged in v4.5.0

**Decision:** Do not create an Opportunity architectural layer yet.

**Reason:** The term is useful, but no independent lifecycle, ownership or responsibility has been observed.

## D-0001 — Accept Commitment

**Status:** Accepted in v4.4.0; reviewed unchanged in v4.5.0

**Decision:** Commitment is a first-class architectural concept between Situation Assessment and execution.

**Reason:** Repeated oscillation and premature action changes are decision-persistence problems rather than steering problems. Commitment provides explicit lifecycle ownership.

## D-005 — Govern document authority, currency and lifecycle

**Status:** Accepted in v4.5.2

**Decision:** Every first-class document must have an intentional authority, currency model, lifecycle and discoverable route. Archive preserves superseded knowledge; compatibility preserves an old route. They are separate responsibilities.

**Reason:** Review of v4.5.0 found stale version declarations, inconsistent casing, ambiguous legacy authority and orphaned documents.

## D-006 — Require a supplied canonical baseline before modification

**Status:** Accepted in v4.5.2

**Decision:** Any modification to the repository shall begin with the current canonical repository being supplied as the implementation baseline.

**Reason:** Uploaded-file availability and conversational state are transient and cannot be treated as engineering dependencies.

## D-007 — Engineering Continuity is a canonical release gate

**Status:** Accepted in v4.5.2

**Decision:** A canonical release must contain sufficient knowledge for a competent engineer to continue correctly using only that repository.

**Reason:** Preserving code without preserving decision quality, failed hypotheses and continuation context is insufficient.

## D-0015 — Adopt Architectural Prototyping

**Status:** Accepted in v4.5.9

The project transitions from architecture-only seminars to architecture–prototype cycles. Each prototype shall validate one architectural hypothesis.
