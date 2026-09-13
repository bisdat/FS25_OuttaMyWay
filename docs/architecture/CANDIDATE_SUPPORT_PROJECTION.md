# Candidate Support, Constraint and Decision Architecture

## Purpose and architectural boundary

This document defines OuttaMyWay's prospective-selection boundary between current Situation meaning and Responsibility Transition.

It owns how fresh prospective actions are enumerated without preselection, how mandatory constraints reject unsupported options, and how Decision selects among the surviving supported alternatives without inventing support or acquiring responsibility.

This is current Architecture. It defines responsibilities, concepts, constraints, evidence rules and handoff boundaries; it does not define source modules, build history, failed-test chronology, implementation sequencing or validation evidence.

The [Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) owns Situation Assessment, Responsibility Transition, Bounded Authority and Control. The [Spatial Negotiation Architecture](SPATIAL_NEGOTIATION_MODEL.md) owns Cooperative Passage semantics and spatial Regulation policy. The [Physical Representation Architecture](PHYSICAL_REPRESENTATION_ARCHITECTURE.md) owns representation authority, coverage and claim permissions.

## Specification Jurisdictions

Candidate Support Projection is a Concept inside a broader prospective-selection architecture; it is not a Specification Jurisdiction of its own.

This architecture declares three peer Specification Jurisdictions:

| Specification Jurisdiction | Primary architectural responsibility |
| --- | --- |
| **Candidate Support** | Enumerate independently supportable fresh prospective purposes and construct their purpose-local planning/support statements without preselection. |
| **Constraint Evaluation** | Apply mandatory invariant verdicts to prospective Candidates independently of preference or convenience. |
| **Decision** | Select among supported, constraint-admissible alternatives using accepted compatibility and preference policy. |

These Jurisdictions are intentionally distinct.

Candidate Support must not preselect the winner. Constraint Evaluation must not become preference policy. Decision must not manufacture support, waive mandatory constraints or make Responsibility Transition authoritative.

Candidate Support Projection, Candidate-support group, Prospective Decision Portfolio, Candidate Space and the Candidate-support-enriched Decision Picture are Concepts or products at these boundaries. They do not create additional Jurisdictions merely by being separately named.

**Candidate Support** routes to [`../../spec/CANDIDATE_SUPPORT.md`](../../spec/CANDIDATE_SUPPORT.md), **Constraint Evaluation** to [`../../spec/CONSTRAINT_EVALUATION.md`](../../spec/CONSTRAINT_EVALUATION.md), and **Decision** to [`../../spec/DECISION.md`](../../spec/DECISION.md).

## 1. Cross-jurisdiction prospective-selection flow

For one current observation/assessment cycle, the architectural flow is:

```text
Observation Snapshot
        |
        v
Situation Assessment
        |
        v
current Operational Picture
        |
        v
Candidate Support
  |-- Projection A -> support group A
  |-- Projection B -> support group B
  `-- Projection C -> support group C
        |
        v
Prospective Decision Portfolio
        |
        v
Candidate-support-enriched
Operational Picture
        |
        v
Candidate Space
        |
        v
Constraint Evaluation
        |
        v
Decision
        |
        v
Responsibility Transition
        |
        v
Bounded Authority / Control
```

Situation Assessment owns current semantic relationships. Candidate Support asks what prospective purposes those current relationships can truthfully support. Constraint Evaluation applies mandatory admissibility. Decision chooses among admissible supported alternatives. Responsibility Transition alone makes the selected Current Responsibility authoritative.

> **Evidence Acquisition != Semantic Interpretation != Candidate Support != Constraint Verdict != Decision != Responsibility Transition**

---

## 2. Specification Jurisdiction — Candidate Support

**Owns:** fresh prospective purpose enumeration, purpose-local Candidate construction/planning, Candidate Support Projection, Candidate-support groups, support provenance, Representation Fitness additions needed by those groups, and composition of one truthful Candidate-support-enriched Decision Picture.

**Does not own:** current Situation classification, mandatory Constraint verdicts, cross-purpose preference, Responsibility Transition, Bounded Authority or Control.

**Primary Specification:** [`../../spec/CANDIDATE_SUPPORT.md`](../../spec/CANDIDATE_SUPPORT.md)

Candidate Support answers:

> **Which prospective purposes are independently supportable from this one current Situation, and what truthful support statement belongs to each?**

### Candidate Enumeration != Preselection

Candidate Support must be able to enumerate several independently supportable fresh purposes for one Decision without selecting one before Decision.

The existence of one strong Candidate must not erase another independently supported Candidate merely because only one can eventually be chosen.

Purpose-local Candidate planning may determine that one expression of the same governing relationship supersedes another where that precedence is part of the purpose contract. Cross-purpose or cross-relationship choice remains Decision authority.

### Candidate Support Projection

A **Candidate Support Projection** is a non-authoritative scope descriptor over one parent Operational Picture.

It answers only:

> **Which already-assessed Situation relationship or record is this support builder evaluating as a prospective governing purpose?**

A Projection may nominate, for example:

- one follower relationship;
- one Forward Intersection relationship;
- one opposed relationship for Cooperative Passage planning;
- that same opposed relationship for Action-Space Regulation support; or
- one fresh Causal Obstruction blocker group for Obstruction Relocation.

A Projection:

- references the parent Operational Picture rather than replacing it;
- carries no independent Operational Picture identity or evidence epoch;
- carries no Situation, Constraint, Decision, Responsibility or Control authority;
- must not mutate the sealed parent Operational Picture;
- must not suppress unrelated safety-relevant evidence from that parent picture;
- must not choose among competing Projections; and
- may narrow only the prospective governing relationship being evaluated.

> **Support Projection != New Operational Picture**

### Support Scope != Evidence Deletion

Projecting the governing support scope does not permit deleting the evidence universe used to decide whether that support is truthful.

A purpose-local support question may focus on one nominated relationship while still consuming the complete relevant parent evidence for Field World, active assemblies, current responsibilities, representation, third-party occupancy, demand and safety constraints.

A Projection therefore narrows the support question, not Reality.

> **Support Scope != Evidence Deletion**

### Candidate-support group contract

A **Candidate-support group** is the independently complete support statement for one prospective governing purpose.

A group contains, as applicable:

- Candidate specifications;
- its local support boundary;
- required Representation Fitness additions;
- exact-picture evidence required by the purpose contract; and
- support provenance linking the group to its parent Situation and target Decision Picture.

A support group does not:

- publish a competing Operational Picture;
- select among other groups;
- acquire responsibility;
- override mandatory constraints; or
- authorise or execute Control.

A single-purpose cycle is the degenerate case of the same contract with one support group. It does not create a different ownership model.

### Prospective Decision Portfolio

A **Prospective Decision Portfolio** is the complete set of independently supportable fresh Candidate-support groups admitted for one Decision Picture.

Portfolio composition owns no preference policy. Its responsibility is truthful completeness within its declared boundary.

If the complete declared Portfolio cannot be established truthfully, composition must fail closed. It must not publish a partial Candidate-support statement while claiming completeness.

> **Portfolio Composition != Decision**

### One Decision-picture identity

One prospective-selection cycle has one Candidate-support-enriched target Operational Picture identity for the complete Candidate-support statement on which Candidate Space, Constraint Evaluation and Decision operate.

Every support group that produces same-picture evidence must bind that evidence to the same target Decision-picture identity.

The target picture is materialised from:

- the complete parent Situation evidence;
- the complete fresh support groups within the declared Portfolio boundary;
- the union of truthful Representation Fitness evidence required by those groups; and
- provenance linking the result to the parent Operational Picture and Observation Snapshot.

No intermediate Projection may become another Operational Picture between the parent Situation picture and the final Candidate-support-enriched Decision Picture.

An implementation may reserve the target identity before support construction. An unused reserved identity after failed composition is harmless; identity reuse or retroactive evidence restamping is not.

### Exact-picture freshness

Evidence that claims same-picture exhaustion, fitness or support must name the exact Operational Picture on which Candidate Space, Constraint Evaluation and Decision operate.

Parent/child lineage, wall-clock proximity or common source Reality does not make different sealed picture identities equivalent for an exact-picture evidence contract.

Candidate Support must therefore generate exact-picture evidence for the target Decision Picture in the first place.

It must not:

- weaken exact-picture stale-evidence rejection;
- rewrite picture identity after support was built;
- copy evidence from one supported picture into another and call it current; or
- assign one identity to conflicting sealed contents.

> **Provenance Cannot Be Manufactured After the Support Question Was Answered**

### Relationship-specific support boundaries

#### Cooperative Passage

Candidate Support may nominate one current opposed relationship at a time for purpose-specific Passage planning.

Planning retains access to the full parent evidence universe for third-party, representation and safety constraints. Per-relationship arrangement construction belongs to Candidate Support; choosing among independently supported conflicts belongs to Decision.

Passage geometry, reserve, Bubble, Passage Leg, recovery and committed execution semantics remain owned by the [Cooperative Passage Jurisdiction](SPATIAL_NEGOTIATION_MODEL.md#5-specification-jurisdiction--cooperative-passage).

#### Action-Space Regulation

Action-Space Regulation support is evaluated for one nominated current relationship while retaining the complete parent evidence universe.

Where the same governing relationship has a supported Cooperative Passage expression and current architecture gives Passage precedence for that same relationship, Candidate Support may apply that purpose-local precedence. Passage support for a different relationship must not erase an independently supported Action-Space Candidate before Decision.

#### Follower and Forward Intersection

A Projection may nominate one already-assessed follower or Forward Intersection relationship.

Candidate Support does not reclassify that relationship and does not remove unrelated physical evidence from the parent picture.

Where no accepted comparator exists for same-class ambiguity, support remains fail-closed rather than inventing preference.

#### Obstruction Relocation

Candidate Support may enumerate fresh support for a current Causal Obstruction whose blocker is eligible for the parent Runtime architecture's **Obstruction Relocation** Jurisdiction.

Historical completed-worker or Terminal-Egress provenance does not create a parallel Candidate responsibility. Current Causal Obstruction, blocker classification and claim evidence remain authoritative.

---

## 3. Specification Jurisdiction — Constraint Evaluation

**Owns:** mandatory invariant verdicts over prospective Candidates and Candidate combinations.

**Does not own:** Candidate construction, Situation interpretation, preference, winner selection, Responsibility Transition, Bounded Authority or Control.

**Primary Specification:** [`../../spec/CONSTRAINT_EVALUATION.md`](../../spec/CONSTRAINT_EVALUATION.md)

Constraint Evaluation answers:

> **Which prospective alternatives remain admissible after mandatory architectural constraints are applied?**

Constraint verdicts are not preference scores.

A Candidate rejected by a mandatory constraint cannot be restored merely because Decision would prefer it, because another Candidate is inconvenient, or because implementation lacks an easier alternative.

Constraint Evaluation consumes the same Candidate-support-enriched Decision Picture and its exact-picture evidence. It must not silently substitute stale support from another picture or reconstruct Candidate support independently.

Constraint Evaluation may reject, narrow or admit. It does not select the winner among several admissible alternatives.

> **Constraint Verdict != Preference**

---

## 4. Specification Jurisdiction — Decision

**Owns:** supported cross-purpose and cross-conflict compatibility, preference and final selection among Candidates that reach Decision with truthful support and acceptable mandatory-constraint verdicts.

**Does not own:** current Situation classification, Candidate construction, support provenance, mandatory constraint meaning, Responsibility Transition, Bounded Authority or Control.

**Primary Specification:** [`../../spec/DECISION.md`](../../spec/DECISION.md)

Decision answers:

> **Given the current supported and constraint-admissible alternatives, which one should the system select now?**

Decision must not invent a Candidate merely because no preferred option survived.

Decision must not repair stale Candidate support, weaken mandatory constraints, restamp evidence or reinterpret the underlying Situation.

When architecture defines no semantic preference between otherwise equivalent admissible alternatives, Decision may use a deterministic tie-break. Where architecture requires ambiguity to fail closed, Decision must not manufacture an ordering merely to produce activity.

Choosing among independently supported conflicts is Decision policy. Purpose-local planning remains Candidate Support ownership.

Selection creates no Current Responsibility by itself. The selected result crosses into the parent Runtime architecture only through **Responsibility Transition**.

> **Decision Selection != Responsibility Establishment**

---

## 5. Cross-boundary invariants

The following invariants govern the whole Candidate Support / Constraint / Decision boundary.

### One current Situation, one prospective evidence universe

Several prospective support questions may be asked of one current Situation. Those questions must not manufacture several incompatible current Realities or Operational Pictures merely to isolate purpose.

### Fresh support remains fresh by identity, not by chronology

Evidence freshness is governed by the identity and contract of the picture being decided, not by how recently another picture was produced.

### Projection narrows purpose, not Reality

A Projection scopes the governing prospective relationship. It does not delete contradictory or safety-relevant evidence.

### Enumeration precedes preference

Candidate Support exposes independently supportable alternatives. Decision owns policy choice among those that survive Constraint Evaluation.

### Mandatory constraints cannot be bypassed by preference

Decision cannot restore an alternative rejected by a mandatory constraint.

### Downstream authority remains downstream

Candidate Support, Constraint Evaluation and Decision do not acquire physical authority. Responsibility Transition, Bounded Authority and Control remain separate.

---

## 6. Architectural boundaries

This architecture does not authorise:

- one Candidate Support Projection becoming a new Observation, Situation or evidence epoch;
- multiple conflicting sealed Operational Pictures sharing one identity;
- post-hoc support-evidence restamping;
- deletion of unrelated Situation evidence merely to isolate one Candidate purpose;
- Candidate Support preselecting among independently supported purposes;
- Decision inventing missing support;
- Decision weakening or bypassing mandatory Constraint verdicts;
- Constraint Evaluation becoming preference policy;
- Candidate/Decision logic acquiring Responsibility Transition authority;
- Candidate support changing Cooperative Passage execution geometry, Resolution lifecycle or Control semantics merely because prospective selection failed; or
- historical build/test provenance becoming current Candidate architecture.

Current implementation placement belongs outside this Architecture. Validation evidence and the investigations that established these ownership boundaries belong to their authorised engineering-history, testing and scenario surfaces.
