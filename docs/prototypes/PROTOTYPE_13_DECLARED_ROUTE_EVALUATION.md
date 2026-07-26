# Prototype 13A — Declared Route Evaluation

## Status

**Runtime route hypothesis supported for the tested fixtures; animation-state correction active in v4.6.18.**

Prototype 13A remains passive. It does not construct a Physical Occupancy Envelope, claim Coverage Closure, predict sweep, assess conflict, create a Commitment or issue Control.

## Question

Can fixture-declared source-to-runtime routes be evaluated through one common evidence contract, preserving convergence, disagreement, aliasing and deliberately invalid controls rather than accepting the first successful lookup?

## Architectural boundary

Different assets may use different resolution routes while producing one **Route-Independent Resolution Contract**. Route type says how a runtime candidate was found; it does not grant physical authority.

The first phase uses **Disposable Fixture Declarations** in isolated Lua tables. They state where to look and remain diagnostic scaffolding. Automated route discovery and external configuration remain deferred until evidence identifies reusable patterns.

## Fixtures and runtime result

### Condor 36 m — direct-mapping positive control

Four active boom shapes were tested: one inner and one outer left/right pair.

- Candidate A: direct mapping.
- Candidate B: component-root descendant path.
- Candidate C: opposite-side sibling path as a negative control.

**Observed:** all four A/B pairs converged on one distinct runtime Entity per source shape. All four C controls were rejected by hierarchy-name evidence.

### TS004 unit1 — Tiger 8 MT

Corresponding active `colPart` shapes on the two wing physics components were tested.

- Candidate A: physics-component root plus descendant path.
- Candidate B: mapped component anchor plus the same descendant path.
- Candidate C: the correct path beneath the opposite physics component as a negative control.

**Observed:** both A/B pairs converged. Both C controls were rejected by physics-component ownership evidence.

### TS004 unit2 — TopDown 600

Corresponding collision-bearing descendants beneath the internally animated folding arms were tested.

- Candidate A: mapped arm anchor plus descendant path.
- Candidate B: main component root plus full descendant path.
- Candidate C: the opposite mapped arm anchor as a negative control.

**Observed:** both A/B pairs converged. Both C controls were rejected by hierarchy-name evidence. Selected runtime handles remained stable through unfolding, raising and lowering motion.

Across the matrix, all ten declared source shapes resolved through `ROUTE_CONVERGENCE`; no ambiguity, root alias, cross-source alias, geometry-unproven result or unresolved result was observed. The result supports the declared route mechanisms for these fixtures only. It does not establish Inventory Closure or Coverage Closure.

The proprietary GIANTS source assets used to prepare these declarations are not redistributed.

## Common evidence checks

Every real candidate and control records:

1. runtime-node existence;
2. assembly-member ownership;
3. expected physics-component ownership;
4. runtime hierarchy/name coherence where observable;
5. Entity-local geometry response;
6. local-to-world sphere coherence;
7. rejection of a member-root alias signature;
8. current pose validity;
9. cross-source runtime-handle reuse;
10. motion-derived corroboration through observed runtime pose change.

A separate result is retained when a runtime node is found but physical geometry authority is unproven.

## Outcomes

- `RESOLVED` — one coherent runtime Entity remains.
- `AMBIGUOUS` — coherent routes disagree.
- `ALIASED` — a root/shared or cross-source Entity is selected.
- `NODE_RESOLVED_GEOMETRY_UNPROVEN` — node identity is coherent but Entity-local physical geometry is not established.
- `UNRESOLVED` — no coherent candidate remains.

`ROUTE_CONVERGENCE` and `SINGLE_ROUTE` are evidence reasons within `RESOLVED`; candidate labels A/B/C do not imply priority.

## Disproved diagnostic assumption

The v4.6.17 logger interpreted any raw `foldAnimTime` value between its numerical endpoints as `TRANSITION`. TS004 disproved that generalisation. TopDown remained stably at `foldAnimTime=0.1250` while extended and raised for AI manoeuvring, then moved toward `0.0000` while lowering for work.

This is **Stable Interior Animation State**: an interior numerical value can be a stable operational pose rather than incomplete movement. TopDown also demonstrates a **Compound Animation Timeline** in which one implementation timeline appears to encode both deployment and vertical configuration.

Prototype 13A therefore records neutral evidence only:

```text
animationSource=foldAnimTime
animationValue=<raw value>
animationRegion=HIGH_ENDPOINT|INTERIOR|LOW_ENDPOINT|UNKNOWN
animationMotion=UNOBSERVED|SETTLING|CHANGING|STABLE|UNKNOWN
semanticState=not-inferred
```

Deployment, vertical configuration, terrain contact, functional engagement and AI operational phase are not inferred from this field.

## Logging contract

For each source shape:

```text
PROTOTYPE13A SOURCE_SHAPE
PROTOTYPE13A CANDIDATE        # A, B and control C
PROTOTYPE13A CONTROL_RESULT
PROTOTYPE13A RESOLUTION_OUTCOME
PROTOTYPE13A MOTION_SAMPLE
```

Each fixture also emits `FIXTURE_ATTACHED`, `FAMILY_SUMMARY` and periodic `FIXTURE_ENUMERATION` records.

## Remaining validation

The route-evaluation question is answered for the declared matrix. v4.6.18 requires only a focused TopDown observation confirming that the corrected logger reports the stable `0.1250` plateau as `animationRegion=INTERIOR` and `animationMotion=STABLE`, not as a semantic fold transition.

Automated route discovery and footprint construction remain separate future activities.
