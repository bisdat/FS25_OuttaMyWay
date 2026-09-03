# Canonical Knowledge and Constraint Recovery Matrix

**Status:** Consolidated recovery evidence for the v4.6.50 Architecture Recovery Candidate  
**Recovery date:** 2026-08-03  
**Canonical source:** owner-declared v4.6.43 package, SHA-256 `c312d74eedb20d800253247b784a992073a4cf44c0413588fa7f382b801cba4c`  
**Temporary evidence source:** v4.6.49 package, SHA-256 `3bebcaf52cd9ccfc65ccce5a895d65c1df1aee8f6e1427a1a77ce86756d23a4d`  
**Companion evidence:** v4.6.49 Architecture Compliance Audit and Hardcoded Authority Register

## Purpose

This document recovers what the project had already established before proposing any new Operational Picture or Commitment contract. It distinguishes canonical concepts, named-but-underdefined contract terms, implementation capabilities, enforcement failures and genuinely unresolved questions.

The governing presumption is: **existing architectural knowledge remains valid until evidence challenges it; recent executable code does not supersede canonical architecture merely because it is newer.**

## Final resolution of the five underdefined terms

The later term-by-term review concluded that none of the five labels requires first-class architectural status.

| Legacy term | Final disposition | Enduring concern retained through |
| --- | --- | --- |
| Relevance Envelope | Retired | Field World, Operational Picture, Situation Relevance, Future Space |
| Decision-Relevant World | Retired | Decision evaluation of available Knowledge relative to candidate action and Commitment |
| Decision-Relevant Constraints | Retired as standalone output | explicit constraint knowledge, mandatory applicability and Runtime Control Admissibility |
| Decision Readiness | Retired | Sufficiency over Completeness for each conclusion or action |
| Option Horizon | Retired as standalone object | Option Preservation and action-specific expiry inside Action Space |

The review rejected any implication that Situation Assessment observes only a selective subset of the Field World. Situation Assessment remains aware of the complete bounded operational area; relevance and materiality change, awareness does not.

The review also refined the enduring Decision principles:

- **Sufficiency over Completeness:** complete Knowledge is unnecessary, but the available Knowledge must support the particular conclusion or action.
- **Option Preservation:** continued evolution may remove safer or less disruptive actions.
- **Earliest Sufficient Action:** do not choose unchanged continuation merely to gain certainty when a proportionate supported action is likely to preserve options.
- **Minimum Effective Augmentation:** use the least disruptive augmentation reasonably expected to preserve or improve safe Action Space.
- **Option-Preserving Augmentation:** a small, proportionate and preferably reversible intervention whose purpose is to preserve or enlarge Action Space rather than resolve the whole encounter immediately.

Frequent reassessment may be normal. Frequent intervention is not automatically justified.

## Principal recovery findings

1. **The core knowledge architecture already exists.** Reality, Observation, Knowledge, Current Situation/Operational Picture, Future Space, Action Space, Situation Assessment, Commitment, relevance dimensions, representation fitness, constraints and Outcome Observation are all present in canonical v4.6.43.
2. **Most v4.6.44–v4.6.49 discoveries are refinements, capability evidence or enforcement failures—not missing root concepts.** Observation Ownership maps to Situation Relevance; Post-Passage Continuation maps to Continuation Safety Horizon; Refuge Viability implements pre-existing Viability Before Preference; Commitment Viability Decay exposes failure to enforce continuous commitment evaluation.
3. **The active problem is contract operationalisation.** Canonical knowledge is distributed across ADRs, architecture, scope, representation, concepts and prototype records, while the experimental controllers keep private interpretations and commitments.
4. **Five canonical v4.3.8 labels were named but not durably defined:** the later term review retired all five as independent concepts while preserving their valid concerns through established architecture.
5. **The next implementation activity is consolidation, not invention:** express already-known Knowledge through a shared Operational Picture and trace one continuing Commitment in passive shadow form before migrating Control.

## Classification vocabulary

- `ALREADY_ESTABLISHED` — canonical architecture already contains the concept or rule.
- `EXISTING_CONCEPT_REFINED` — recent evidence sharpens a canonical concept without replacing it.
- `IMPLEMENTATION_CAPABILITY` — useful mechanism beneath the architecture.
- `IMPLEMENTATION_DEFECT` / `ENFORCEMENT_GAP` — code did not honour an existing responsibility or constraint.
- `CANONICAL_DEFINITION_RECOVERY_GAP` — the canonical repository names the concept but does not currently preserve a sufficient definition.
- `POTENTIAL_SPECIALISATION` — possibly useful named subtype, not yet evidence for a new root concept.

## Canonical knowledge inventory

| ID | Knowledge | Status | Natural owner | Consumer | Reconciliation |
| --- | --- | --- | --- | --- | --- |
| K-01 | Reality | Accepted | External reality; sampled by Observer | Observer / Situation Assessment | ALREADY_ESTABLISHED |
| K-02 | Observation | Accepted | Observer and evidence providers | Situation Assessment only | ALREADY_ESTABLISHED / IMPLEMENTATION_DEPARTURE |
| K-03 | Knowledge | Accepted | Situation Assessment | Decision Engine and other knowledge consumers | ALREADY_ESTABLISHED / ENFORCEMENT_GAP |
| K-04 | Current Situation / Operational Picture | Accepted concept; terminology relationship deferred | Situation Assessment | Decision Engine | ALREADY_ESTABLISHED / IMPLEMENTATION_GAP |
| K-05 | Situation Space | Accepted | Architecture / Situation Assessment | Situation Assessment and Decision | ALREADY_ESTABLISHED |
| K-06 | Future Space | Accepted | Situation Assessment | Decision Engine | EXISTING_CONCEPT_REFINED |
| K-07 | Action Space | Accepted | Situation Assessment supplies permitted space; Decision selects | Decision Engine | EXISTING_CONCEPT_REFINED |
| K-08 | Situation Assessment | Accepted | Situation Assessment | Decision Engine | ALREADY_ESTABLISHED / CRITICAL_CONFORMANCE_GAP |
| K-09 | Decision Readiness | Named canonical discovery; definition not recovered | Situation Assessment | Decision Engine | CANONICAL_DEFINITION_RECOVERY_GAP |
| K-10 | Decision-Relevant World | Named canonical discovery; definition not recovered | Situation Assessment | Decision Engine | CANONICAL_DEFINITION_RECOVERY_GAP |
| K-11 | Decision-Relevant Constraints | Named canonical discovery; partial meaning elsewhere | Situation Assessment | Decision Engine | EXISTING_CONCEPT / CONSOLIDATION_GAP |
| K-12 | Relevance Envelope | Named canonical discovery; definition not recovered | Situation Assessment | Observation retention and Decision | CANONICAL_DEFINITION_RECOVERY_GAP |
| K-13 | Option Horizon | Named canonical discovery; definition not recovered | Situation Assessment | Decision Engine | CANONICAL_DEFINITION_RECOVERY_GAP |
| K-14 | Outcome Observation | Accepted | Control reports; Situation Assessment interprets | Situation Assessment, then Decision | ALREADY_ESTABLISHED / STRONGLY_VALIDATED |
| K-15 | Intervention Capability Model | Accepted | Situation Assessment maintains from feedback; Control demonstrates | Decision Engine | ALREADY_ESTABLISHED / CAPABILITY_EVIDENCE_ADDED |
| K-16 | Commitment | Accepted first-class concept | Decision/Commitment owner | Control capabilities; Situation Assessment evaluates evidence | ALREADY_ESTABLISHED / IMPLEMENTATION_GAP |
| K-17 | Conflict Zone | Accepted derived concept | Situation Assessment | Decision Engine | ALREADY_ESTABLISHED / REFINED_EVIDENCE |
| K-18 | Trajectory Settlement and Conflict Confidence | Deferred concepts with strong passive evidence | Situation Assessment | Decision Engine | EXISTING_CONCEPT / IMPLEMENTATION_BYPASS |
| K-19 | Situation Relevance | Accepted | Situation Assessment | Operational Picture and Decision | ALREADY_ESTABLISHED / REFINED |
| K-20 | Field World Membership | Accepted | Situation Assessment | Operational Picture | ALREADY_ESTABLISHED / ENFORCEMENT_GAP |
| K-21 | Operational Membership / Operation Participation | Accepted | Situation Assessment | Operational Picture and Decision | ALREADY_ESTABLISHED / VALIDATED |
| K-22 | Operational Influence | Accepted | Situation Assessment | Decision Engine | ALREADY_ESTABLISHED / UNDERUSED |
| K-23 | Assembly Relevance / Behavioural Assembly | Accepted | Situation Assessment and representation services | Operational Picture and Decision | ALREADY_ESTABLISHED / IMPLEMENTATION_NARROWING |
| K-24 | Obstacle Relevance | Accepted | Situation Assessment | Decision Engine | ALREADY_ESTABLISHED / CONSUMPTION_GAP |
| K-25 | Control Eligibility Profile | Accepted | Scope Overlay / Situation Assessment knowledge | Test selection and downstream admissibility | ALREADY_ESTABLISHED / IMPLEMENTATION_BYPASS |
| K-26 | Runtime Control Admissibility | Accepted downstream contextual conclusion | Decision Engine using Situation Assessment knowledge | Control | ALREADY_ESTABLISHED / ENFORCEMENT_GAP |
| K-27 | Control Exclusion Constraint | Accepted | Situation Assessment / Scope Overlay | Decision Engine | ALREADY_ESTABLISHED / PATTERN_REUSED |
| K-28 | Physical Representation Portfolio | Accepted | Representation providers; Situation Assessment judges fitness | Situation Assessment | ALREADY_ESTABLISHED / AUTHORITY_ESCALATION_RISK |
| K-29 | Representation Contract / Passport | Accepted | Representation provider | Situation Assessment | ALREADY_ESTABLISHED / PARTIAL_IMPLEMENTATION |
| K-30 | Situation Assessment as Representation-Fitness Arbiter | Accepted | Situation Assessment | Decision Engine | ALREADY_ESTABLISHED / CRITICAL_IMPLEMENTATION_GAP |
| K-31 | Coverage Closure and Coverage Ledger | Accepted | Representation services; Situation Assessment | Situation Assessment | ALREADY_ESTABLISHED / IMPLEMENTATION_LIMIT |
| K-32 | Conflict Excluded / Supported / Possible / Clearance Unresolved | Accepted | Situation Assessment | Decision Engine | ALREADY_ESTABLISHED / LOCALLY_REAPPLIED |
| K-33 | Orthogonal Physical State Dimensions | Accepted | Situation Assessment / representation services | Decision and Control capability selection | ALREADY_ESTABLISHED / IMPLEMENTATION_CONFLICT |
| K-34 | Deployment Sweep and Manoeuvre Sweep | Accepted concepts; construction deferred | Situation Assessment / geometry services | Decision Engine | ALREADY_ESTABLISHED / MAJOR_IMPLEMENTATION_GAP |
| K-35 | Native Motion Envelope | Accepted from prototype evidence | Situation Assessment capability knowledge / Control capability | Decision and Control | ALREADY_ESTABLISHED / IMPLEMENTATION_POLICY_GAP |
| K-36 | Local Intent Horizon, Intent Expiry, Encounter Chain, Safe Release Point and Continuation Safety Horizon | Deferred but explicitly recorded | Situation Assessment | Decision Engine / Commitment lifecycle | EXISTING_DEFERRED_CONCEPTS_STRONGLY_REINFORCED |

The detailed CSV inventory used during the recovery exercise preserved
definitions, inputs, outputs, source locations, implementation state and
reconciliation notes. That exact historical evidence remains recoverable
through Git history rather than as a current working-tree responsibility.

## Canonical constraint inventory

| ID | Constraint | v4.6.49 status | Recovery implication |
| --- | --- | --- | --- |
| C-01 | Situation Assessment is sole interpreter | BYPASSED | Architecture recovery must restore this route. |
| C-02 | Decision consumes understanding, not raw observations | BYPASSED | No behavioural migration until shadow trace proves conformance. |
| C-03 | All new information returns through Operational Picture | PARTIAL | Preserve outcome telemetry as reusable capability feedback. |
| C-04 | Responsibilities belong with natural owner | VIOLATED | Primary recovery rule. |
| C-05 | Architecture speaks about workers; implementation must not narrow silently | NOT_GENERALISED | Retain fixtures as tests, not authority. |
| C-06 | Full-Envelope Field Containment | LOCAL_ONLY | System-wide admissibility gate required. |
| C-07 | Geometry Domain Separation | PARTIAL_CONTRADICTION | Representation fitness must gate claim permission centrally. |
| C-08 | No Silent Under-Approximation | PARTIAL | Apply per action and horizon. |
| C-09 | Admissibility Before Optimisation | COMPLIANT_LOCALLY | Preserve and generalise. |
| C-10 | Situation Assessment judges representation fitness | BYPASSED | Central assessment conclusion required. |
| C-11 | Uncertainty prevents clearance; it does not manufacture collision | COMPLIANT_LOCALLY | Decision policy for unresolved states remains separate. |
| C-12 | Observe broadly; control narrowly | PROTOTYPE_BOUNDED | Expand observation model before general control. |
| C-13 | Presence is not participation; occupancy is not obstacle relevance | PARTIAL | Operational Picture should publish independent dimensions. |
| C-14 | Job completion ends cooperation, not physical relevance | OBSERVED_NOT_CONTROLLED | Shared awareness service should cover active-active and active-static. |
| C-15 | Never create observation deadlock / preserve a Progress Entity | LOCALLY_PRESERVED | Do not fix latest failure by holding both. |
| C-16 | Viability/clearance first, cost second | COMPLIANT_IN_v4.6.49 | This was pre-existing architecture finally enforced locally. |
| C-17 | Protected Progress Corridor | INCOMPLETE | Future Space and commitment revalidation must update corridor knowledge. |
| C-18 | Minimum Sufficient Displacement | PARTIAL | Do not solve by arbitrary extra metres. |
| C-19 | Decision continuously evaluates current Commitment | LOCAL_PRIVATE_ONLY | One commitment owner/trace required. |
| C-20 | Least disruptive justified intervention | PARTIAL | Least intervention is not least architectural control. |
| C-21 | Conflict cessation is not resolution | SUPPORTED | Release requires positive continuation evidence. |
| C-22 | Local Resolution is not Operational Resolution | NOT_ESTABLISHED | TS015/016 remain benchmarks, not proof of system completion. |
| C-23 | Deployment Commitment Point precedes motion; endpoints do not prove sweep | NOT_GENERALLY_ENFORCED | Recover as mandatory action precondition. |
| C-24 | Operational phase is not physical pose authority | PARTIAL | Use live representation and explicit state evidence. |
| C-25 | Movement behaviour derives from Native Motion Envelope | DOCUMENTED_ONLY | Define Control motion intents before tuning. |
| C-26 | UNRESOLVED candidate cannot win preference | COMPLIANT_IN_v4.6.49 | Generalise to all actions, not only refuge candidates. |
| C-27 | A decision remains provisional until intended effect is confirmed | STRONGLY_SUPPORTED_FOR_SPEED | Use same validation pattern for hold, reposition, clearance and handback. |
| C-28 | Authority/currency must be explicit | PARTIAL_DRIFT | Resolve canonical definition recovery before new architecture. |

## Temporary discovery reconciliation

| ID | Discovery | Version | Classification | Canonical home / precursor |
| --- | --- | --- | --- | --- |
| R-01 | Speed-Cap Authority Gap | v4.6.44 | IMPLEMENTATION_DEFECT / CAPABILITY_GAP | Outcome Observation; Intervention Capability Model. |
| R-02 | Declared Cap Is Not Applied Cap | v4.6.44 | EXISTING_ARCHITECTURE_STRONGLY_VALIDATED | Closed-Loop Operational Truth; Outcome Observation. |
| R-03 | Persistent Speed Authority | v4.6.45 | IMPLEMENTATION_CAPABILITY_DISCOVERY | Intervention Capability Model; Native Motion/Control capability. |
| R-04 | Regulated-Headway Self-Satisfaction | v4.6.45 | CONTROL_LOOP_DEFECT | Response Margin; positive release evidence; Outcome Observation. |
| R-05 | Temporal Separation Reserve | v4.6.44-45 | EXISTING_CONCEPT_REFINED / NEW_METRIC | Response Margin; Action Space; Option Horizon (named). |
| R-06 | Manoeuvre Clearance Reserve | v4.6.44-45 | EXISTING_CONCEPT_REFINED | Action Space; Protected Progress Corridor; Minimum Sufficient Displacement. |
| R-07 | Encounter Continuity Across Geometry Change | v4.6.45 | EXISTING_DEFERRED_CONCEPTS_REINFORCED | Encounter Chain; Situation Relevance; Intent Expiry; Future Space. |
| R-08 | Post-Passage Continuation Guard | v4.6.46 | IMPLEMENTATION_MECHANISM_FOR_EXISTING_KNOWLEDGE | Continuation Safety Horizon; Conflict Cessation Is Not Resolution; Situation Relevance. |
| R-09 | Protected Controller Handoff | v4.6.47 | IMPLEMENTATION_CAPABILITY / OWNERSHIP_EVIDENCE | Commitment lifecycle; Outcome Observation; control authority continuity. |
| R-10 | Future Corridor Frame | v4.6.47 | SPECIALISED_KNOWLEDGE_REPRESENTATION | Future Space; Local Intent Horizon; Protected Progress Corridor. |
| R-11 | Threshold-Gated Encounter Discontinuity | v4.6.47 | IMPLEMENTATION_DEFECT | Situation Relevance; Relevance Envelope (named); conflict/policy separation. |
| R-12 | Observation Ownership | v4.6.48 | EXISTING_RESPONSIBILITY_REFINED | Situation Relevance; persistent context lifecycle; Operational Picture ownership. |
| R-13 | Refuge Reachability Gap | v4.6.48 | ENFORCEMENT_GAP_EXPOSED | Full-Envelope Field Containment; viability-before-preference; field/environment model. |
| R-14 | Unknown Is Not Reachable | v4.6.48-49 | ALREADY_PRESENT_PRINCIPLE_RESTATED | Clearance Unresolved; uncertainty prevents clearance; Viability Before Preference. |
| R-15 | Refuge Viability Gate | v4.6.49 | LOCAL_IMPLEMENTATION_OF_EXISTING_ARCHITECTURE | D-0077; Viability Before Preference; Runtime Control Admissibility. |
| R-16 | Refuge Occupancy Conflict | v4.6.49 runtime | NEW_EVIDENCE / EXISTING_CONCEPTS_INSUFFICIENTLY_CONSUMED | Future Space; Obstacle Relevance Future-Space Inclusion; Continuation Safety Horizon. |
| R-17 | Passage Corridor Is Not Continuation Corridor | v4.6.49 runtime | EXISTING_CONCEPT_REFINED | Future Space; Local Intent Horizon; Safe Release Point; Continuation Safety Horizon. |
| R-18 | Commitment Viability Decay | v4.6.49 runtime | EXISTING_ARCHITECTURE_NOT_ENFORCED | Continuous commitment evaluation; Dependency-Scoped Invalidation; Intent Expiry. |
| R-19 | Mutual Continuation Clearance | post-v4.6.49 interpretation | POTENTIAL_SPECIALISATION / NOT_NEW_ROOT_YET | Safe Release Point; Continuation Safety Horizon; Operational Resolution. |
| R-20 | Cooperative Passage Commitment | post-v4.6.49 interpretation | POTENTIAL_COMMITMENT_SPECIALISATION | Commitment; Progress Preservation; Protected Progress Corridor. |
| R-21 | Native Repositioning Motion | audit interpretation | CAPABILITY_ABSTRACTION | Native Motion Envelope; Intervention Capability Model. |
| R-22 | Persistent Situation Relevance | audit interpretation | EXISTING_CONCEPT_CONSOLIDATION | Situation Relevance; Relevance Envelope; Encounter Chain; completed obstacle. |
| R-23 | Commitment Preconditions | audit interpretation | EXISTING_CONTRACT_CONSOLIDATION | Decision-Relevant Constraints; Deployment Commitment Point; continuous commitment evaluation. |

## Recovered information flow

```text
Reality
  -> Observation
      -> Situation Assessment
          -> Current Situation / Operational Picture
              - entities and Field World
              - membership, participation, influence and relevance
              - physical state and representation fitness
              - current occupancy and plausible Future Spaces
              - conflict / clearance knowledge and uncertainty
              - Decision-Relevant Constraints
              - intervention capability knowledge from Outcome Observations
          -> Decision Engine
              -> maintain, create, revise or cancel Commitment
          -> Control capability
              -> Outcome Observation
                  -> Situation Assessment
```

This flow is recovered from canonical sources; it is not a proposed replacement architecture.

## What canonical sources already say Situation Assessment publishes

At concept level, canonical v4.6.43 supports these knowledge families:

- a most-plausible Current Situation / Operational Picture, with uncertainty;
- plausible Future Spaces and available Action Space;
- Field World Membership, Operational Membership/Participation, Operational Influence and Situation/Obstacle Relevance;
- Behavioural Assembly membership and relevance;
- representation fitness, coverage closure and scoped occupancy conclusions;
- Control Eligibility and hard Control Exclusion Constraints;
- Runtime Control Admissibility inputs and Decision-Relevant Constraints;
- conflict confidence, local intent validity/expiry and continuation-safety evidence;
- Outcome Observations and updated intervention capability knowledge;
- evidence that the current Commitment remains valid, should be revised or should end.

What is not yet recovered is a single canonical schema, exact outcome enum set, confidence encoding or complete lifecycle object. Those absences are implementation/contract gaps, not evidence that the knowledge concepts were never established.

## Important non-discoveries from the recent run

- v4.6.48 did **not** discover field containment; it exposed failure to enforce Full-Envelope Field Containment.
- v4.6.49 did **not** invent viability-before-preference; it implemented the already accepted rule locally.
- Observation Ownership is not yet evidence for a new root owner; it operationally reinforces Situation Relevance and the missing Relevance Envelope definition.
- Mutual Continuation Clearance is likely a useful specialisation of Safe Release Point and Continuation Safety Horizon, but should not be promoted before those deferred concepts are reviewed against the new evidence.
- Cooperative Passage Commitment is likely a scenario-specific Commitment schema, not a replacement for Commitment itself.

## Canonical definition recovery gaps

| Term | What the canonical package preserves | What remains missing |
| --- | --- | --- |
| Decision Readiness | Named in ADR-0003 and changelog | Definition, fields, state transitions and consumer contract |
| Decision-Relevant World | Named in ADR-0003 and changelog | Boundary relative to Situation Space, Field World and Relevance Envelope |
| Decision-Relevant Constraints | Named; many concrete constraints exist elsewhere | One consolidated output contract and mandatory-consumer semantics |
| Relevance Envelope | Named in ADR-0003 and changelog | Definition and lifecycle; likely highly relevant to Observation Ownership |
| Option Horizon | Named in ADR-0003 and changelog | Definition and relationship to Action Space, Response Margin and temporal reserve |

These gaps should be treated as recovery questions. The repository does not support silently assigning them new definitions.

## Recommended next discussion gate

Before any code or new architectural concept, review the five underdefined canonical terms and decide for each:

```text
recover an earlier intended definition
OR
confirm it is redundant with an existing accepted concept
OR
retire it explicitly
OR
amend it using the new evidence
```

After that, the recovered inventory can be consolidated into an **Operational Picture Knowledge Contract** without pretending to design it from scratch. The following activity would then recover the existing Commitment lifecycle and map the v4.6.49 private states onto it.

## Decision boundary

- v4.6.43 remains canonical.
- v4.6.49 remains temporary and non-canonical evidence.
- No repository or runtime code was changed by this recovery pass.
- No new root architectural concept is accepted by this draft.
