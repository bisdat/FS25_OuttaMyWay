# Decision Specification

## Identity and authority

**Specification Jurisdiction:** Decision  
**Primary Architecture Authority:** [`docs/architecture/CANDIDATE_SUPPORT_PROJECTION.md`](../docs/architecture/CANDIDATE_SUPPORT_PROJECTION.md#4-specification-jurisdiction--decision)

This Specification owns the implementation-facing contract for choosing among supported, mandatory-constraint-admissible prospective alternatives using accepted compatibility, precedence, preference and deterministic tie-break policy.

Decision does **not** own current Situation classification, Candidate construction, support provenance, mandatory Constraint meaning, Responsibility Transition, Bounded Authority or Control.

> **Decision Selection != Responsibility Establishment.**

> **Decision May Select Governing Scope; It May Not Rewrite Support.**

## Boundary contract

### Inputs

Decision consumes one coherent prospective-selection bundle:

- the exact Candidate-support-enriched Operational Picture;
- the complete Candidate inventory bound to that picture;
- the complete mandatory Constraint verdict set bound to that inventory; and
- accepted compatibility/preference policy applicable to the supported alternatives.

The implementation MUST reject or fail closed when those identities do not correspond.

Decision MUST NOT:

- invent a Candidate absent from the supported Candidate inventory;
- repair stale or incomplete Candidate support;
- weaken a mandatory FAIL or UNRESOLVED verdict into admissibility;
- reclassify the underlying Situation;
- restamp evidence to another picture/inventory identity; or
- make Current Responsibility authoritative.

### Admissible Candidate set

A Candidate reaches Decision as admissible only when every mandatory Constraint applicable to it has PASS on the exact current verdict set.

Candidates with FAIL are excluded. Candidates with UNRESOLVED mandatory verdicts are not silently treated as PASS.

Decision MAY preserve unresolved alternatives as evidence for an explicit WAIT/non-selection outcome where architecture permits waiting for evidence. That does not make them admissible.

### Cross-purpose compatibility and governing scope

Where a complete prospective portfolio contains several independently supported Candidate-support groups, Decision owns the compatibility/preference question among the **constraint-admissible alternatives** in those groups.

A governing support scope MUST therefore be selected with knowledge of mandatory admissibility. Decision MUST NOT select a support group solely from support metadata and then use that selection to suppress an otherwise admissible Candidate in another group unless Architecture explicitly defines a precedence rule that survives Candidate inadmissibility independently of preference.

The current prospective-selection Architecture does not grant a generic lower-precedence admissibility bypass.

That scope selection MUST NOT be represented as:

- Candidate Support having preselected the group;
- Constraint Evaluation rejecting otherwise supported groups on preference grounds;
- a mandatory FAIL/UNRESOLVED Candidate blocking another group's admissible Candidate merely through Decision ordering; or
- deletion of the unselected support groups from the evidence/provenance record.

The complete support universe remains true even when one governing scope is selected for this Decision.

> **Complete Support != Selected Support.**

> **Support Precedence != Admissibility Bypass.**

### Within-scope selection

Within a valid governing scope, Decision chooses among Candidates that remain admissible after all mandatory verdicts.

The implementation MAY use accepted comparison cost, preference bands, compatibility rules and deterministic tie-breaks where Architecture permits them.

A deterministic tie-break is allowed only where semantic preference is otherwise equivalent or Architecture explicitly permits deterministic ordering. It MUST NOT manufacture semantic preference where ambiguity is required to fail closed.

### Explicit non-selection

A Decision MUST produce an explicit semantic outcome even when no Candidate is selected.

Supported non-selection classes include, as applicable:

- **WAIT** — unresolved evidence or preference/exhaustion evidence prevents supported selection;
- **SETTLE / no further intervention** — the complete supportable/admissible space is positively exhausted for the relevant current responsibility path; or
- another explicit non-actuating outcome defined by the current contract.

The exact source token names are implementation detail. The durable rule is:

> **Non-Selection Is a Decision Outcome, Not Missing Decision.**

A Decision without a selected Candidate MUST say explicitly why no Candidate was selected and what downstream lifecycle action, if any, is being proposed.

## Decision product contract

The Decision product MUST preserve enough information for downstream Responsibility Transition to validate and apply the selected lifecycle intent without reconstructing Decision policy.

As applicable, the semantic product includes:

- Decision identity and provenance;
- exact Operational Picture identity;
- exact Candidate inventory identity;
- exact mandatory verdict-set identity;
- the set of mandatory-admissible Candidate identities;
- selected Candidate identity, when one exists;
- explicit non-intervention/non-selection classification when no Candidate is selected;
- comparison/compatibility basis sufficient to explain the choice;
- proposed commitment/lifecycle action; and
- human/audit explanation adequate to distinguish selection, waiting, maintenance and settlement intent.

The source representation may change. The contract requires those semantic relationships, not one concrete record layout.

A proposed commitment action is **Decision intent**, not an already-applied semantic transition.

## Prospective portfolio policy

Decision may contain more than one layer of policy without becoming more than one Jurisdiction.

A valid Decision flow is:

```text
complete supported portfolio
        |
        v
mandatory Constraint admissibility
        |
        v
admissible alternatives by group
        |
        v
cross-group compatibility / precedence
        |
        v
selected governing scope
        |
        v
within-group preference / tie-break
        |
        v
selected Candidate or explicit non-selection
        |
        v
Responsibility Transition
```

Cross-group compatibility and within-group preference are both Decision authority because both answer **which supported admissible alternative should be chosen now?**

They MUST remain separate from Candidate Support completeness and mandatory Constraint meaning even when current source implements them through several policy helpers.

A policy MAY intentionally choose non-selection over an admissible alternative only when the accepted Architecture or Decision contract positively defines that policy. An implementation-local ordering token or legacy precedence rule is not sufficient authority.

## Durable invariants

### Selection cannot create support

Decision selects only from Candidates supplied by Candidate Support. A missing preferred Candidate remains missing.

### Selection cannot enlarge admissibility

A mandatory FAIL or UNRESOLVED verdict cannot be waived by Decision preference, comparison cost, implementation convenience or absence of alternatives.

### Compatibility is not a mandatory Constraint

Cross-purpose precedence or compatibility belongs to Decision unless Architecture explicitly defines it as a mandatory invariant. Preference MUST NOT be disguised as PASS/FAIL merely to simplify implementation.

> **Compatibility Choice != Constraint Verdict.**

### Support precedence cannot bypass admissibility

A preferred support group whose Candidates fail or remain unresolved does not, by preference alone, erase another group's Candidate that passed every mandatory Constraint.

If Architecture needs such a stronger exclusion relationship, that relationship must be stated explicitly at the proper authority level rather than inferred from implementation ordering.

### Unselected support remains true support

Choosing one group/Candidate does not retroactively make independently supported alternatives unsupported. Decision records choice; it does not rewrite the support universe.

### Exact-picture lineage is preserved

The selected Candidate, its admissibility verdicts and the Decision record MUST remain traceable to the same exact Candidate-support-enriched Operational Picture.

### Selection is non-authoritative until transition

No Decision record, selected Candidate or commitment-action token independently establishes Current Responsibility or Bounded Authority.

## Failure and uncertainty semantics

- **Candidate inventory / verdict set identity mismatch** — reject/fail closed; do not restamp.
- **Incomplete mandatory verdict set** — no supported selection.
- **Candidate has unresolved mandatory evidence** — that Candidate is not admissible; it MAY contribute to an explicit WAIT outcome only where the accepted Decision policy makes waiting semantically appropriate.
- **Cross-group compatibility policy cannot identify a governing scope among admissible alternatives** — produce explicit non-selection rather than invent an ordering.
- **Preferred support group has no admissible Candidate while another group does** — do not suppress the admissible alternative merely because the preferred group's support existed; any stronger exclusion requires explicit architectural authority.
- **No admissible Candidate remains and complete supportable/admissible space is positively exhausted** — produce explicit settlement/non-intervention intent as appropriate; do not invent activity.
- **Equivalent admissible alternatives with no semantic preference** — MAY use an accepted deterministic tie-break.
- **Architecture requires ambiguity to fail closed** — do not use deterministic ordering to bypass that requirement.

Decision failure or non-selection does not itself release or establish Current Responsibility. Responsibility Transition and the incumbent responsibility's own lifecycle rules remain authoritative downstream.

## Cross-Jurisdiction dependencies

### Candidate Support

[`CANDIDATE_SUPPORT.md`](CANDIDATE_SUPPORT.md) owns complete support, Candidate materialisation and support provenance. Decision may choose among that universe but may not rewrite it.

### Constraint Evaluation

[`CONSTRAINT_EVALUATION.md`](CONSTRAINT_EVALUATION.md) owns mandatory PASS/FAIL/UNRESOLVED admissibility verdicts. Decision consumes them without reinterpretation.

### Responsibility Transition

[`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) makes establishment, maintenance, termination or replacement of Current Responsibility authoritative. Decision only supplies supported selected intent.

### Purpose-specific Jurisdictions

Purpose-specific contracts such as [`COOPERATIVE_PASSAGE.md`](COOPERATIVE_PASSAGE.md) define what their Candidates mean and what obligations selection would imply. Decision chooses among supported expressions; it does not redefine those purpose contracts.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/decision/DecisionSelector.lua`](../scripts/decision/DecisionSelector.lua) — current integration of mandatory-admissibility filtering, portfolio-scope selection, local policy, explicit non-selection and DecisionRecord publication;
- [`scripts/decision/ProspectivePortfolioDecisionPolicy.lua`](../scripts/decision/ProspectivePortfolioDecisionPolicy.lua) — current cross-group compatibility/precedence policy for prospective portfolios;
- [`scripts/decision/TrafficPolicemanDecisionPolicy.lua`](../scripts/decision/TrafficPolicemanDecisionPolicy.lua) — current within-group traffic preference/exhaustion policy; and
- [`scripts/contracts/DecisionRecord.lua`](../scripts/contracts/DecisionRecord.lua) — current semantic Decision product representation.

Current policy helper names and ordering are implementation topology. The Specification owns the semantic distinction between supported admissibility, compatibility/preference, explicit non-selection and downstream transition intent.

The current `ProspectivePortfolioDecisionPolicy` selects a support group from Candidate-inventory metadata without receiving the mandatory verdict set, after which `DecisionSelector` filters viable Candidates to that chosen group. That source ordering is a **conformance question**, not normative authority: it must not be used to weaken the architectural rule that Decision chooses among supported, constraint-admissible alternatives.

## Validation route

### Structural/source-contract validation

[`tests/test_candidate_support_projection_structure.py`](../tests/test_candidate_support_projection_structure.py) challenges that portfolio composition remains Candidate Support rather than Decision preselection.

[`tests/test_constraint_verdict_ownership_structure.py`](../tests/test_constraint_verdict_ownership_structure.py) challenges that mandatory verdict ownership remains outside Decision preference.

[`tests/test_prospective_decision_ownership_structure.py`](../tests/test_prospective_decision_ownership_structure.py) is direct evidence of the current portfolio-selection implementation, including its deliberate `lowerPrecedenceConstraintFallback=false` contract. That test is **evidence of current implementation behaviour, not authority that the behaviour matches Architecture**.

Additional replacement-core structural tests protect explicit non-intervention, exact identity binding and Responsibility Transition ordering where Decision products cross into lifecycle change.

A targeted conformance test is required for **Support Precedence != Admissibility Bypass**: when one supported group's Candidates fail mandatory Constraints while another supported group contains an admissible Candidate, Decision must follow the accepted admissibility-aware compatibility contract rather than suppressing the admissible Candidate through source ordering alone.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises Candidate filtering, unresolved evidence, portfolio compatibility, preference, explicit WAIT/SETTLE behaviour and selected Decision application in the replacement-core harness.

Offline validation can challenge deterministic selection semantics and authority separation. It cannot prove that live GIANTS/physical evidence underlying Candidate support or mandatory verdicts is correct.

### Targeted in-game Reality validation

In-game validation is required where choice depends on live relationships, physical competition, GIANTS intent or timing that cannot be reconstructed faithfully offline.

### Outside this Specification's validation claim

A correct Decision proves only that selection/non-selection followed the supported admissible policy. It does not prove that Responsibility Transition succeeded, that Bounded Authority was validly granted, or that Control physically achieved the selected purpose.
