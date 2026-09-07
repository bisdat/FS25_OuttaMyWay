# Candidate Support Projection Architecture

## Purpose

Candidate support must be able to enumerate several independently supportable **fresh** purposes for one Decision without either:

- preselecting one purpose before Decision; or
- manufacturing multiple incompatible Operational Pictures from one current Situation.

This document corrects the failed `0.3.0.19 TEST — PROSPECTIVE DECISION OWNERSHIP` implementation while preserving the accepted Phase-13 finding **Preselection != Candidate Enumeration** and the accepted **Prospective Decision Portfolio** concept.

The correction is architectural, not a Passage, D-0147, D-0218 or Control redesign.

## Reality discovery

The first `.19` GIANTS Reality Passage test ended in physical collision.

The runtime had truthful D-0146 support before the collision:

- Cooperative Passage was found and became entry-ready;
- Decision repeatedly waited for preference-exhaustion evidence instead of admitting the Passage;
- after the Passage window was consumed, Action-Space Regulation was positively supported;
- that Regulation also did not reach bounded dispatch;
- current physical overlap then became positive while Decision remained passive.

Issue #68 records the detailed Reality evidence.

### Support Projection != New Operational Picture

The failed implementation isolated prospective purposes by constructing new `OperationalPicture` values with fresh `PICTURE` identities. Existing Candidate support then correctly stamped Traffic Policeman exhaustion evidence with those support-view picture identities. Portfolio composition subsequently materialised another `OperationalPicture` with another identity for Constraint and Decision.

The accepted Traffic Policeman policy correctly requires preference-exhaustion evidence to belong to the exact Operational Picture being decided. The extra support-view identities therefore made otherwise valid same-Reality evidence stale before Decision.

> A Candidate-support projection is a bounded way to ask a support question of one current Operational Picture. It is not a new Operational Picture, Observation, Situation or evidence epoch.

The stale-picture check is correct and must remain strict.

### Support Scope != Evidence Deletion

The failed implementation also isolated a purpose by replacing unrelated Situation-knowledge collections with empty collections.

That is not the required abstraction. Candidate support may need to evaluate one nominated prospective governing relationship while still observing the complete parent picture for Field World, demand, third-party occupancy, representation, active assemblies, current responsibilities and other safety-relevant evidence.

> Projecting the **governing support scope** does not permit deleting the **evidence universe** used to decide whether that support is truthful.

A projection therefore nominates the relationship or record whose Candidate support is being built; it does not manufacture a reduced Reality.

## Authoritative picture model

For one sealed observation cycle the intended flow is:

```text
Observation Snapshot
        |
        v
Situation Assessment
        |
        v
Operational Picture P1
(current Situation knowledge)
        |
        | reserve one Candidate-support-enriched Decision picture identity P2
        |
        +-- Candidate Support Projection: follower record F
        |       `-> support group F, evidence scoped to P2
        |
        +-- Candidate Support Projection: opposed conflict C1
        |       `-> Passage support group C1, evidence scoped to P2
        |
        +-- Candidate Support Projection: opposed conflict C2
        |       `-> Action-Space support group C2, evidence scoped to P2
        |
        +-- Candidate Support Projection: terminal record T
        |       `-> D-0147 support group T, evidence scoped to P2
        |
        `-- other independently supportable fresh groups
                |
                v
       Prospective Decision Portfolio
                |
                v
Operational Picture P2
(P1 Situation + complete Candidate support)
                |
                v
CandidateSpace -> Constraint -> Decision
                |
                v
selected group's retained local support boundary
                |
                v
Responsibility Transition / Bounded Authority / Control
```

`P1` and `P2` are distinct for the same reason accepted single-purpose Candidate support already produces a Candidate-support-enriched Operational Picture: `P2` contains the complete Candidate-support statement on which CandidateSpace, Constraint and Decision operate.

The correction is that **all** groups in one fresh Portfolio contribute to the **same** `P2`. No intermediate projection is allowed to become another `OperationalPicture` between `P1` and `P2`.

## Candidate Support Projection

A **Candidate Support Projection** is a non-authoritative scope descriptor over one parent Operational Picture.

It answers only:

> Which already-assessed Situation relationship or record is this support builder currently evaluating as a prospective governing purpose?

It may identify, for example:

- one fresh follower-boundary relationship;
- one Forward Intersection relationship;
- one opposed-corridor relationship for Passage planning;
- that same opposed relationship for Action-Space Regulation support;
- one fresh Terminal Occupancy record;
- one fresh Causal Obstruction blocker group.

A projection:

- references the parent Operational Picture rather than replacing it;
- carries no independent `PICTURE` identity or evidence epoch;
- carries no Situation, Constraint, Decision, Responsibility or Control authority;
- must not mutate the sealed parent Operational Picture;
- must not suppress unrelated safety-relevant evidence from the parent picture;
- must not choose among competing projections;
- may only narrow the **prospective governing relationship being evaluated**.

The implementation does not require a one-to-one class/module for this concept. A narrow explicit value or function argument is sufficient if it preserves these semantics.

## One target Decision-picture identity

Fresh Portfolio composition owns one Candidate-support-enriched target Operational Picture identity for the complete current Candidate-support statement.

Every Candidate-support group built for that Portfolio must bind same-picture evidence to that one target identity. This includes Traffic Policeman preference-exhaustion records whose contract requires exact Operational Picture identity equality at Decision.

The target picture must then be materialised atomically from:

- the complete parent Situation evidence;
- the complete set of independently supportable fresh Candidate groups within the declared Portfolio boundary;
- the union of truthful Representation Fitness evidence required by those groups; and
- Portfolio provenance linking the result back to the parent Operational Picture and Observation Snapshot.

If composition cannot truthfully establish the complete declared Portfolio, it must fail closed. It must not publish a partial picture while claiming `complete=true`.

An implementation may reserve the target identity before group construction. An unused reserved identity after a failed composition is harmless; reusing or retroactively re-stamping evidence is not.

## Candidate-support group contract

A **Candidate-support group** remains the independently complete support statement for one prospective governing purpose and retains its local support boundary.

For Portfolio construction, group production should be separable from Operational Picture materialisation:

```text
build support group
    inputs:
      parent Operational Picture P1
      Observation Snapshot
      Candidate Support Projection
      target Decision-picture identity P2

    output:
      Candidate specifications
      local support boundary
      Representation Fitness additions
      support provenance

    does NOT:
      publish another Operational Picture
      select among other prospective groups
      acquire responsibility
      authorize or execute Control
```

Existing single-purpose support paths may continue to materialise their own supported Operational Picture when no Portfolio is required. The new group-building seam exists so fresh Portfolio composition can reuse the same planning/support semantics without creating intermediate picture identities.

## Evidence freshness

The following accepted contract remains unchanged:

> Evidence that claims same-picture exhaustion, fitness or support must name the exact Operational Picture on which CandidateSpace, Constraint and Decision operate.

Therefore `.20` must **not** solve `.19` by:

- weakening `TrafficPolicemanDecisionPolicy` stale-picture rejection;
- accepting parent/child lineage as equivalent to exact same-picture evidence;
- rewriting `operationalPictureId` after Candidate support has already been built;
- copying Candidate evidence from one supported Operational Picture into another and calling it current;
- making evidence freshness depend only on wall-clock proximity.

The support builder must generate the evidence for the one target Decision picture in the first place.

## Relationship-specific preservation

### Cooperative Passage

Candidate support may nominate one Established Opposed Corridor Conflict at a time for `planConflict()` / equivalent per-conflict planning, but planning must retain access to the full parent Operational Picture for third-party and representation constraints.

Per-conflict arrangement search remains Candidate planning. Choosing among independently supported conflicts remains Decision policy.

No Passage geometry, clearance, Transit-First, restoration, Last-Leg Dissolution or physical Control policy changes are justified by the `.19` collision.

### D-0146 Action-Space Regulation

Action-Space support is evaluated for one nominated relationship while retaining the complete parent evidence universe.

If the same relationship has a supported Passage expression, existing same-relationship Passage precedence remains. Passage support for a different relationship must not erase this Candidate before Decision.

### Follower / Forward Intersection

A projection may nominate one already-assessed follower or Forward Intersection relationship. It does not reclassify the pair and does not remove other physical evidence from the parent picture.

Current same-class ambiguity remains fail closed where no accepted comparator exists.

### D-0147 Terminal Egress

Fresh Portfolio support may nominate one eligible Terminal Occupancy record at a time and build the existing D-0147 Candidate semantics for that record.

Incumbent D-0147 lifecycle gating remains exact and exclusive.

No change is permitted to warm Terminal Egress courtesy geometry, two-courtesy budget, Continuation Renewal, Player Claim/source-AI precedence, protected-beneficiary holding, settlement evidence or physical Control.

### D-0218 Causal Obstruction Relocation

Fresh cold obstruction support retains the accepted generic blocker classification and exclusion of Terminal-Occupancy-owned blockers.

No change is permitted to cold-relocation first-courtesy geometry, 60 m bound, authority partition, Player Claim/source-AI precedence, protected-beneficiary holding, continuation evidence or physical Control.

## Prospective Decision Portfolio remains accepted

The `.19` Reality failure disproves the first **implementation** of the Prospective Decision Portfolio; it does not disprove the architectural finding that fresh independently supportable purposes must reach Decision.

The corrected ownership remains:

- Situation Assessment owns current relationship knowledge;
- Candidate support owns truthful planning and support enumeration;
- Candidate Support Projection scopes which prospective relationship a group builder is evaluating without changing Reality;
- Constraint owns mandatory invariant verdicts;
- Decision owns cross-purpose and cross-conflict compatibility policy;
- Responsibility Transition establishes the selected lifecycle responsibility;
- Bounded Authority and Control remain downstream.

## Rejected correction shortcuts

The following are explicitly rejected:

1. **Disable stale-picture validation.** This would hide the failure rather than correct provenance.
2. **Re-stamp support evidence after aggregation.** Provenance cannot be manufactured after the support question was answered.
3. **Clone several different Operational Pictures under one shared identity.** One identity must not denote conflicting sealed contents.
4. **Hide unrelated Situation evidence to force one support result.** Projection selects the support question, not the evidence universe.
5. **Move policy back into Candidate support.** That would abandon the accepted Phase-13 ownership correction.
6. **Change Passage geometry or D-0147/D-0218 Control.** Reality evidence does not implicate those mechanics.

## `.20` implementation boundary

The next executable correction should use a fresh TEST identity because `.19` is fixed failed-test provenance:

**`0.3.0.20 TEST — CANDIDATE SUPPORT PROJECTION`**

Expected bounded implementation work:

- replace `.19` OperationalPicture-based support views with non-authoritative Candidate Support Projections;
- factor or expose support-group builders that can bind their evidence to one Portfolio target picture identity without publishing intermediate Operational Pictures;
- materialise exactly one fresh Portfolio-supported Operational Picture per observation/Decision cycle;
- preserve the `.19` Decision compatibility policy and selected-group dispatch boundary where they remain valid;
- preserve incumbent single-purpose paths;
- add structural contracts proving exact picture-identity coherence across group evidence, CandidateInventory and Decision;
- add contracts proving projections do not delete parent evidence or acquire policy authority;
- retain Issue #65 and Issue #67 as separate validation/test-architecture debt rather than broadening `.20`.

## Reality validation target

The first `.20` GIANTS Reality test must repeat the exact first-passage case that failed `.19`.

Success requires evidence that:

1. Passage support reaches Decision without stale-picture exhaustion failure;
2. when Passage becomes entry-ready, the expected Commitment/Control path can begin;
3. if Passage genuinely becomes unsupported first, same-relationship Action-Space Regulation can reach Decision/dispatch rather than passive observation;
4. no physical collision occurs through the previously failing sequence; and
5. the runtime does not achieve success by weakening same-picture freshness or by hiding contradictory Situation evidence.

Only after that case passes should wider D-0147/D-0218 and ordinary Passage preservation smokes resume.
