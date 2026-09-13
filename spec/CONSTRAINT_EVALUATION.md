# Constraint Evaluation Specification

## Identity and authority

**Specification Jurisdiction:** Constraint Evaluation  
**Primary Architecture Authority:** [`docs/architecture/CANDIDATE_SUPPORT_PROJECTION.md`](../docs/architecture/CANDIDATE_SUPPORT_PROJECTION.md#3-specification-jurisdiction--constraint-evaluation)

This Specification owns the implementation-facing contract for applying **mandatory invariant verdicts** to prospective Candidates and Candidate combinations using the exact Candidate-support-enriched Decision Picture.

Constraint Evaluation does **not** own Candidate construction, Situation interpretation, cross-purpose compatibility, preference, winner selection, Responsibility Transition, Bounded Authority or Control.

> **Constraint Verdict != Preference.**

## Boundary contract

### Inputs

Constraint Evaluation consumes:

- one Candidate-support-enriched Operational Picture;
- one complete Candidate inventory bound to that exact picture; and
- the current set of mandatory Constraint evaluators required by the accepted architecture and contract.

The implementation MUST reject a Candidate inventory that belongs to a different Operational Picture.

Constraint Evaluation MUST NOT:

- reconstruct missing Candidate support;
- substitute evidence from another Operational Picture;
- import Decision preference into a mandatory verdict;
- treat Candidate planning evidence as if it were an already-authoritative Constraint result; or
- skip a mandatory evaluator merely because another verdict already rejects the Candidate.

### Mandatory Constraint verdict

For every required Candidate × mandatory Constraint pair, Constraint Evaluation MUST publish exactly one verdict with one of these semantic outcomes:

- **PASS** — the mandatory condition is positively satisfied for the Candidate on the current Decision Picture;
- **FAIL** — current evidence positively establishes violation of the mandatory condition; or
- **UNRESOLVED** — available evidence cannot establish either PASS or FAIL within the Constraint contract.

A verdict MUST remain bound to:

- the exact Candidate identity;
- the exact governing Constraint identity;
- the evidence/provenance used by the evaluator;
- any reason or contradiction needed to understand the result; and
- any revalidation trigger that makes the verdict explicitly freshness-sensitive.

`UNRESOLVED` is not PASS, FAIL, preference, timeout, or an instruction to choose another Candidate.

### Complete mandatory verdict set

Constraint Evaluation MUST publish a complete verdict set for the declared Candidate inventory and mandatory Constraint set.

Completeness means, for every Candidate in the inventory, all mandatory Constraints have one current verdict.

The verdict set MUST bind to:

- the exact Operational Picture identity;
- the exact Candidate inventory identity;
- the complete list/set of mandatory Constraint identities; and
- the complete set of produced verdict identities.

A partial verdict set MUST NOT be presented as complete.

The implementation MAY evaluate Constraints in any deterministic internal order, but evaluation order MUST NOT alter semantic ownership or allow short-circuiting to hide required verdicts from downstream review.

## Mandatory Constraint semantics

A mandatory Constraint expresses **admissibility**, not desirability.

A Candidate that receives any mandatory **FAIL** is not admissible. Decision MUST NOT restore it because it is convenient, cheap, otherwise preferred or the only active-looking option.

A Candidate with one or more mandatory **UNRESOLVED** verdicts is not established as admissible. Decision may represent explicit waiting/non-selection according to its own contract, but Constraint Evaluation MUST NOT convert uncertainty into a preference score.

A Candidate is established as admissible only when every mandatory Constraint required for that Candidate produces PASS on the current exact picture.

### Current mandatory Constraint families

Current source evaluates mandatory questions including representation fitness, responsibility compatibility, commitment preconditions and effective actuation composition.

Those source evaluator names are implementation traceability, not a permanent normative enumeration. The durable contract is that every architecturally mandatory admissibility question applicable to the Candidate is evaluated independently and completely.

If Architecture adds, removes or changes a mandatory invariant, the Constraint contract and its implementation must change deliberately. A source-only evaluator list cannot silently redefine Architecture.

## Durable invariants

### Mandatory verdicts are independent of preference

Constraint Evaluation MUST NOT rank Candidates, choose among several PASS Candidates, or encode cross-purpose precedence into PASS/FAIL/UNRESOLVED.

### Exact-picture identity is mandatory

A verdict produced for another Operational Picture or Candidate inventory is stale for this selection cycle, even when the source Reality appears temporally close.

### Planning evidence is not a verdict

Candidate-local planning data may be evidence consumed by an independently owned Constraint evaluator. It MUST NOT cross the Candidate boundary already labelled as PASS, FAIL, admissible or viable authority.

### Complete evaluation precedes Decision

Decision receives a complete mandatory verdict set. Missing verdicts are a Constraint Evaluation failure, not permission for Decision to assume PASS.

### Constraint rejection is monotonic downstream

Decision may narrow the set of PASS Candidates through compatibility/preference. It MUST NOT enlarge admissibility by reviving a FAIL or unresolved Candidate as though it passed.

## Failure and uncertainty semantics

- **Candidate inventory bound to another picture** — reject evaluation; do not restamp the inventory.
- **Unknown Candidate referenced by a verdict** — contract error; fail closed.
- **Required evaluator unavailable** — verdict-set completeness cannot be established; fail closed.
- **Required evidence positively contradicts the invariant** — emit FAIL with provenance/reason.
- **Required evidence is absent, stale, contradictory or insufficient** — emit UNRESOLVED where the Constraint contract cannot establish PASS or FAIL.
- **Evaluator attempts to express preference rather than a mandatory invariant** — ownership error; preference belongs to Decision.
- **Incomplete verdict set** — do not publish it as complete and do not permit downstream selection to assume omitted Constraints passed.

Constraint Evaluation failure does not itself choose an alternative or establish Current Responsibility.

## Cross-Jurisdiction dependencies

### Candidate Support

[`CANDIDATE_SUPPORT.md`](CANDIDATE_SUPPORT.md) owns the Candidate inventory, support provenance and exact Candidate-support-enriched Decision Picture. Constraint Evaluation consumes that product without rebuilding it.

### Assessment Representation

[`ASSESSMENT_REPRESENTATION.md`](ASSESSMENT_REPRESENTATION.md) owns representation claims and permissions. Constraint evaluators may test whether those claims satisfy a Candidate's mandatory needs; they do not acquire representation ownership.

### Decision

[`DECISION.md`](DECISION.md) consumes complete mandatory verdicts. It may choose among PASS Candidates according to compatibility/preference but MUST NOT reinterpret FAIL/UNRESOLVED as preference.

### Responsibility Transition

[`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) remains downstream. A PASS verdict never establishes responsibility.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/constraints/ConstraintEngine.lua`](../scripts/constraints/ConstraintEngine.lua) — binds one Candidate inventory to one Operational Picture, executes every current mandatory evaluator for every Candidate, and publishes the verdict set;
- [`scripts/constraints/evaluators/RepresentationFitness.lua`](../scripts/constraints/evaluators/RepresentationFitness.lua) — current representation-fitness mandatory question;
- [`scripts/constraints/evaluators/ResponsibilityCompatibility.lua`](../scripts/constraints/evaluators/ResponsibilityCompatibility.lua) — current responsibility-compatibility mandatory question;
- [`scripts/constraints/evaluators/CommitmentPreconditions.lua`](../scripts/constraints/evaluators/CommitmentPreconditions.lua) — current commitment-precondition mandatory question;
- [`scripts/constraints/evaluators/EffectiveActuationComposition.lua`](../scripts/constraints/evaluators/EffectiveActuationComposition.lua) — current effective-actuation-composition mandatory question; and
- [`scripts/contracts/ConstraintVerdict.lua`](../scripts/contracts/ConstraintVerdict.lua) plus [`scripts/contracts/ConstraintVerdictSet.lua`](../scripts/contracts/ConstraintVerdictSet.lua) — current semantic record forms.

The current evaluator list and module names are not normative Architecture. What is normative is complete, independent mandatory admissibility evaluation.

## Validation route

### Structural/source-contract validation

[`tests/test_constraint_verdict_ownership_structure.py`](../tests/test_constraint_verdict_ownership_structure.py) challenges the separation between Candidate planning evidence and independently owned Constraint verdicts.

[`tests/test_candidate_support_projection_structure.py`](../tests/test_candidate_support_projection_structure.py) provides neighbouring evidence for exact-picture Candidate support and non-authoritative Projection semantics.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises Candidate inventories, mandatory verdict production, PASS/FAIL/UNRESOLVED handling and downstream Decision behaviour in the replacement-core harness.

Offline evidence can challenge verdict completeness, identity binding and authority separation. It cannot prove that live GIANTS/physical evidence feeding a Constraint is itself correct.

### Targeted in-game Reality validation

In-game validation remains necessary where a mandatory Constraint depends on current GIANTS state, live physical representation or execution conditions unavailable to the offline harness.

### Outside this Specification's validation claim

A complete PASS verdict set proves only mandatory admissibility under the current Constraint contract. It does not prove that the Candidate is preferred, selected, committed or physically successful.