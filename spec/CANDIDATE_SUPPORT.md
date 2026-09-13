# Candidate Support Specification

## Identity and authority

**Specification Jurisdiction:** Candidate Support  
**Primary Architecture Authority:** [`docs/architecture/CANDIDATE_SUPPORT_PROJECTION.md`](../docs/architecture/CANDIDATE_SUPPORT_PROJECTION.md#2-specification-jurisdiction--candidate-support)

This Specification owns the implementation-facing contract for enumerating independently supportable fresh prospective purposes from one current Situation, constructing purpose-local support statements, composing a complete prospective portfolio, and publishing the one Candidate-support-enriched Decision Picture from which Candidate Space is materialised.

Candidate Support does **not** own current Situation classification, mandatory Constraint verdicts, cross-purpose compatibility or preference, final selection, Responsibility Transition, Bounded Authority or Control.

> **Candidate Enumeration != Preselection.**

> **Support Projection != New Operational Picture.**

## Boundary contract

### Input authority

Candidate Support consumes one current **Operational Picture** whose Situation meaning is already owned by Situation Assessment.

The implementation MUST preserve the identity, provenance and evidence universe of that parent picture. Candidate Support MAY ask several prospective questions of the same Situation, but it MUST NOT:

- reinterpret the underlying Situation merely to make a Candidate supportable;
- delete unrelated safety-relevant or contradictory evidence from the parent picture;
- restamp stale evidence as current;
- manufacture a new Observation or Situation epoch for each prospective purpose; or
- treat source/helper ordering as strategic precedence.

### Candidate Support Projection

A **Candidate Support Projection** scopes one prospective governing relationship or purpose question over the parent Operational Picture.

A Projection MUST:

- reference the parent Operational Picture;
- identify the prospective relationship/purpose being evaluated;
- preserve access to the complete evidence universe required by that question; and
- remain non-authoritative outside the support question it scopes.

A Projection MUST NOT acquire a competing Operational Picture identity, mutate the parent picture, select among other Projections, issue Constraint verdicts, select a winner, establish Current Responsibility or authorise Control.

> **Support Scope != Evidence Deletion.**

### Candidate-support group

One prospective governing purpose is represented by one independently complete **Candidate-support group**.

A support group MUST preserve, as applicable:

- the nominated governing relationship/purpose;
- one or more Candidate specifications belonging to that purpose;
- the local support boundary and provenance;
- Representation Fitness additions required by the group;
- exact-picture evidence required by the purpose contract;
- uncertainty and invalidation conditions; and
- the semantic evidence needed by later Constraint Evaluation and Decision without rebuilding the support question.

A group MAY contain several expressions of the same purpose where the purpose contract itself requires alternatives. It MUST NOT select among independently supported cross-purpose or cross-conflict groups.

Purpose-local precedence MAY suppress another expression of the **same governing relationship** when that precedence is part of the owning purpose contract. It MUST NOT erase independently supported alternatives belonging to different relationships merely because Decision will eventually choose only one.

### Prospective Decision Portfolio

A **Prospective Decision Portfolio** is the complete set of independently supportable fresh Candidate-support groups admitted for one Decision Picture.

Portfolio composition owns completeness, not preference.

The portfolio MUST make its declared boundary explicit and MUST either:

- publish a truthful complete portfolio for that boundary; or
- fail closed without claiming completeness.

A partial set MUST NOT be labelled complete merely because the implementation cannot construct one of the required support groups.

> **Portfolio Composition != Decision.**

### Candidate-support-enriched Decision Picture

One prospective-selection cycle has one target Candidate-support-enriched Operational Picture.

The target picture MUST be derived from:

- the complete parent Situation evidence;
- the complete fresh support groups admitted for the declared portfolio boundary;
- the union of truthful Representation Fitness evidence required by those groups; and
- provenance that binds the result to its parent Operational Picture and Observation Snapshot.

Every same-picture support or fitness claim MUST bind to the exact target Decision-picture identity.

An implementation MAY reserve that target identity before all support construction finishes. A failed composition MAY leave an unused identity. It MUST NOT reuse that identity for different sealed contents or retroactively rewrite evidence identities after the support question was answered.

> **Provenance Cannot Be Manufactured After the Support Question Was Answered.**

## Candidate product contract

Candidate Support MUST publish enough semantic information for Candidate Space to materialise Candidates without inventing support or downstream authority.

For each Candidate specification, the contract includes, as applicable:

- purpose and subject;
- requested capability/effect;
- evidence basis and support provenance;
- relevant Representation Fitness;
- preconditions and invalidation conditions;
- reversibility;
- obligations that would arise if the Candidate were later selected and committed;
- release implications;
- uncertainty; and
- comparison information that Decision may consume after mandatory admissibility is established.

The exact source record layout is not normative. The semantic product MUST remain free of downstream authority such as selection, admissibility, commitment or Control permission.

A Candidate may describe consequences of possible selection. It MUST NOT claim those consequences are already authoritative.

### Candidate Space

Candidate Space is the materialised prospective Candidate inventory produced from the complete Candidate-support boundary. Within this Jurisdiction, it is an implementation-facing product, not a separate Specification Jurisdiction.

Candidate Space MUST:

- bind to the exact Candidate-support-enriched Operational Picture;
- materialise only Candidates supported by the complete declared support boundary;
- preserve Candidate support provenance and claim limits;
- reject duplicate or malformed Candidate identities/specifications; and
- publish a complete Candidate inventory for the declared support boundary.

Candidate Space MUST NOT import Constraint conclusions from planning packets or treat Candidate existence as admissibility.

## Relationship-specific boundaries

### Cooperative Passage

Candidate Support may build purpose-specific Passage support for one current opposed relationship at a time while retaining full relevant parent evidence for representation, third-party occupancy and safety.

The [`COOPERATIVE_PASSAGE.md`](COOPERATIVE_PASSAGE.md) Specification owns what makes a Passage Candidate semantically meaningful. Candidate Support owns construction of that supported prospective expression, not Passage commitment or execution.

### Regulation purposes

Follower, Forward Intersection and Action-Space Regulation support consume already-assessed relationships. Candidate Support MUST NOT reclassify those relationships or convert one purpose's support into another purpose's Situation authority.

Where same-class ambiguity has no accepted comparator, support MUST remain fail-closed rather than manufacturing a preference.

### Obstruction Relocation

Candidate Support may enumerate a current Causal Obstruction whose blocker is already classified as eligible for Obstruction Relocation by the parent Runtime architecture.

Historical completed-worker provenance or old Terminal-Egress concepts MUST NOT create an alternative support route independent of current Causal Obstruction evidence.

## Durable invariants

### Complete support precedes Decision

Decision receives the declared complete support universe. Candidate Support MUST NOT hide independently supported alternatives because one appears preferable.

> **Complete Support != Selected Support.**

### One Decision picture

All Candidate, support and same-picture evidence used by one selection cycle MUST bind to one Candidate-support-enriched Operational Picture identity.

### Projection narrows purpose, not Reality

A Projection changes the question being asked. It does not create a smaller Reality.

### Candidate semantics exclude downstream authority

A Candidate MUST NOT contain a semantic claim that it has already passed mandatory constraints, been selected, acquired responsibility or been authorised for Control.

### Support provenance survives materialisation

Candidate Space MUST preserve the support basis needed to audit and revalidate the Candidate. Discovery/helper topology is not semantic authority, but provenance cannot be discarded.

## Failure and uncertainty semantics

- **Parent Operational Picture unavailable or inconsistent** — do not construct prospective support.
- **Required purpose-local evidence unavailable** — omit/reject that unsupported group according to its declared support boundary; do not invent support.
- **Declared portfolio completeness cannot be established** — fail closed rather than publish a partial portfolio as complete.
- **Exact target-picture evidence cannot be produced** — fail closed; do not restamp parent/other-picture evidence.
- **Candidate specification malformed or semantically incomplete** — do not publish that Candidate as supported.
- **Same-class ambiguity without an accepted support comparator** — fail closed at support rather than make a Decision preference inside Candidate Support.
- **No prospective physical support groups** — an explicit passive/non-actuating support product MAY be produced where the architecture permits it; absence of a physical Candidate does not authorise an invented one.

Candidate Support failure does not establish that a competing purpose is safe, admissible or preferred. Those stronger conclusions require their own support and downstream contracts.

## Cross-Jurisdiction dependencies

### Situation Assessment

Situation Assessment owns the current semantic relationships and Operational Picture. Candidate Support consumes that meaning and asks prospective questions without reclassifying it.

### Assessment Representation

[`ASSESSMENT_REPRESENTATION.md`](ASSESSMENT_REPRESENTATION.md) owns representation products and claim permissions. Candidate Support may require purpose-local Representation Fitness additions but MUST preserve their provenance and limits.

### Constraint Evaluation

[`CONSTRAINT_EVALUATION.md`](CONSTRAINT_EVALUATION.md) owns mandatory admissibility. Candidate Support MUST NOT pre-populate PASS/FAIL/UNRESOLVED verdicts as Candidate authority.

### Decision

[`DECISION.md`](DECISION.md) owns cross-purpose compatibility, preference and final selection. Candidate Support publishes the complete prospective universe Decision is allowed to choose from.

### Responsibility Transition

[`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) alone makes a selected responsibility authoritative. Candidate Support remains prospective.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/candidates/ProspectiveDecisionPortfolioSupport.lua`](../scripts/candidates/ProspectiveDecisionPortfolioSupport.lua) — composition of fresh support groups into one target Decision Picture and complete prospective portfolio;
- [`scripts/candidates/LiveTrafficCandidateSupport.lua`](../scripts/candidates/LiveTrafficCandidateSupport.lua) — current live-traffic purpose-local support construction;
- [`scripts/candidates/ObstructionRelocationCandidateSupport.lua`](../scripts/candidates/ObstructionRelocationCandidateSupport.lua) — obstruction-relocation support construction;
- [`scripts/candidates/PassiveLiveCandidateSupport.lua`](../scripts/candidates/PassiveLiveCandidateSupport.lua) — explicit passive/fail-closed support paths;
- [`scripts/candidates/LocalPassagePlanner.lua`](../scripts/candidates/LocalPassagePlanner.lua) — current purpose-local Cooperative Passage planning support; and
- [`scripts/candidates/CandidateSpace.lua`](../scripts/candidates/CandidateSpace.lua) plus [`scripts/contracts/CandidateAction.lua`](../scripts/contracts/CandidateAction.lua) and [`scripts/contracts/CandidateInventory.lua`](../scripts/contracts/CandidateInventory.lua) — materialisation of the supported Candidate inventory.

No one source module is the Jurisdiction. Current module size or helper topology does not transfer Decision or Constraint authority into Candidate Support.

## Validation route

### Structural/source-contract validation

[`tests/test_candidate_support_projection_structure.py`](../tests/test_candidate_support_projection_structure.py) challenges Projection ownership, exact-picture support and separation from downstream authority.

[`tests/test_constraint_verdict_ownership_structure.py`](../tests/test_constraint_verdict_ownership_structure.py) provides neighbouring evidence that Candidate planning packets do not own mandatory Constraint verdicts.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises Candidate support, Candidate inventory construction and prospective selection flows in the replacement-core harness.

Offline validation can challenge identity, completeness, provenance and authority separation. It cannot prove GIANTS Reality or the physical validity of purpose-specific geometry used by a Candidate.

### Targeted in-game Reality validation

In-game validation remains necessary where a support group depends on live GIANTS intent, current physical representation, spatial relationships or purpose-specific Passage/obstruction evidence that the offline harness cannot reproduce faithfully.

### Outside this Specification's validation claim

Complete Candidate support does not prove that any Candidate is admissible, preferred, selected, committed or physically executable. Those claims belong downstream.