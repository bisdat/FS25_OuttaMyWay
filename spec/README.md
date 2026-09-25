# Specification surface

## Purpose

`/spec` is OuttaMyWay's implementation-facing contract surface.

Architecture under `/architecture` defines **what the system should achieve and why its responsibilities exist**. A primary Specification defines **what an implementation of one declared Specification Jurisdiction must preserve, expose, reject, sequence or report in order to realise that Architecture**. Source under `/scripts` defines the current mechanism that attempts to satisfy that contract. Tests and Reality provide evidence about the contract; they do not own it.

```text
/architecture
Architecture — what / why
        ⇅
/spec
Specification — implementation-facing contract
        ⇅
/scripts
Implementation — current mechanism

/tests and Reality
Validation evidence that challenges the contracts and implementation
```

Normative Specification authoring, ownership, traceability and conformance rules are owned by [`docs/DOCUMENT_STANDARDS.md`](../docs/DOCUMENT_STANDARDS.md), including the Authority Triad rule:

> **Touch One; Validate Three.**

This README is the entrance and navigation surface for `/spec`; it is not a second standards authority.

> **Specification Operationalises Architecture; It Does Not Paraphrase It.**

## Current primary Specifications

The currently migrated primary Specifications are:

| Specification Jurisdiction | Primary Specification |
| --- | --- |
| **Operation Lifecycle** | [`OPERATION_LIFECYCLE.md`](OPERATION_LIFECYCLE.md) |
| **Observation** | [`OBSERVATION.md`](OBSERVATION.md) |
| **Situation Assessment** | [`SITUATION_ASSESSMENT.md`](SITUATION_ASSESSMENT.md) |
| **Responsibility Transition** | [`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) |
| **Regulation** | [`REGULATION.md`](REGULATION.md) |
| **Resolution Lifecycle** | [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md) |
| **Obstruction Relocation** | [`OBSTRUCTION_RELOCATION.md`](OBSTRUCTION_RELOCATION.md) |
| **Blocked Worker Recovery** | [`BLOCKED_WORKER_RECOVERY.md`](BLOCKED_WORKER_RECOVERY.md) |
| **Cooperative Passage** | [`COOPERATIVE_PASSAGE.md`](COOPERATIVE_PASSAGE.md) |
| **Physical Identity Resolution** | [`PHYSICAL_IDENTITY_RESOLUTION.md`](PHYSICAL_IDENTITY_RESOLUTION.md) |
| **Assessment Representation** | [`ASSESSMENT_REPRESENTATION.md`](ASSESSMENT_REPRESENTATION.md) |
| **Candidate Support** | [`CANDIDATE_SUPPORT.md`](CANDIDATE_SUPPORT.md) |
| **Constraint Evaluation** | [`CONSTRAINT_EVALUATION.md`](CONSTRAINT_EVALUATION.md) |
| **Decision** | [`DECISION.md`](DECISION.md) |
| **Bounded Authority** | [`BOUNDED_AUTHORITY.md`](BOUNDED_AUTHORITY.md) |
| **Control** | [`CONTROL.md`](CONTROL.md) |
| **Log Publication** | [`LOG_PUBLICATION.md`](LOG_PUBLICATION.md) |
| **Configuration** | [`CONFIGURATION.md`](CONFIGURATION.md) |

All currently implemented Specification Jurisdictions declared by accepted Architecture have primary Specifications. **Blocked Worker Recovery** is a mature `NOT_IMPLEMENTED` Jurisdiction with no production participants yet. **Configuration** has both its mature primary Specification and production implementation participants.

A genuine Jurisdiction whose implementation-facing contract is mature before production source exists may have a primary Specification carrying the exact declaration `**Implementation Status:** \`NOT_IMPLEMENTED\``. That state is distinct from a Deferred Responsibility: the contract is already normative, but no production mechanism yet realises it. Such a Specification has no production participant rows until implementation is accepted.

This table is navigation, not a second Jurisdiction catalogue. Architecture remains authoritative for the complete Jurisdiction inventory and ownership relationships.

## Reading a Specification

Primary Specifications intentionally need not use one rigid heading template. A reader should expect to find the contract information required by `DOCUMENT_STANDARDS.md`, including:

- Jurisdiction identity and primary Architecture authority;
- implementation-facing responsibility and ownership boundary;
- boundary contracts and durable invariants;
- failure and uncertainty semantics;
- implementation traceability; and
- validation route.

Lifecycle, ordered-flow, semantic-data or cross-Jurisdiction material appears when the contract actually owns those semantics.

The Specification should remain meaningful if its internal implementation mechanism changes substantially, unless Reality or architectural change proves that the contract itself was wrong.

## Navigating downward into source

An implemented primary Specification provides the route into the production source that materially participates in its contract. An unimplemented primary Specification explicitly declares `NOT_IMPLEMENTED` and has no production participants until the first implementation increment. That route or explicit absence is implementation traceability, not contract ownership by source topology.

> **Primary Specification != Primary Source Module.**

Once the correct source module is reached, production source documentation owns the local explanation needed to descend through runtime/public operations, internal semantic operations and non-obvious local mechanisms. The normative source-documentation rules are in [`docs/DOCUMENT_STANDARDS.md`](../docs/DOCUMENT_STANDARDS.md).

## Validation

Specifications route to the evidence appropriate to their contracts. Tests are evidence surfaces, not Specification authority.

> **Tests Are Contract Evidence, Not Contract Authority.**

Rolling pass/fail history, CI chronology and scenario history remain in their responsible validation or historical surfaces rather than this README.
