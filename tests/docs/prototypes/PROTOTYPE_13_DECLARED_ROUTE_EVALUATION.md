# Prototype 13A — Declared Resolution Path Evaluation

## Status

**Complete for the declared fixture matrix. Runtime Resolution Path hypotheses and the neutral animation diagnostic are supported for the tested fixtures.**

Prototype 13A remains passive. It does not construct a Physical Occupancy Envelope, claim Coverage Closure, predict sweep, assess conflict, create a Commitment or issue Control.

## Terminology note

The original implementation used `route` in filenames, Lua identifiers and log outcomes. In architecture, use **Resolution Path** for a source-to-runtime candidate-generation method and reserve **route** for a worker's navigable field path.

Historical implementation labels such as `DeclaredRouteEvaluationProbe` and `ROUTE_CONVERGENCE` remain unchanged for evidence traceability. They should be interpreted as Resolution Path evidence.

## Question

Can fixture-declared source-to-runtime Resolution Paths be evaluated through one common evidence contract, preserving convergence, disagreement, aliasing and deliberately invalid controls rather than accepting the first successful lookup?

## Architectural boundary

Different assets may use different Resolution Paths while satisfying one class-independent **Resolution Contract**. Path type says how a runtime candidate was proposed; it does not grant physical authority.

The first phase used **Disposable Fixture Declarations** in isolated Lua tables. They stated where to look and remain diagnostic scaffolding. Automated Resolution Path discovery and external configuration remain deferred until wider evidence identifies reusable patterns.

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

Across the matrix, all ten declared source shapes resolved through the legacy implementation reason `ROUTE_CONVERGENCE`; no ambiguity, root alias, cross-source alias, geometry-unproven result or unresolved result was observed. The result supports the declared Resolution Path mechanisms for these fixtures only. It does not establish Inventory Closure or Coverage Closure.

The proprietary GIANTS source assets used to prepare these declarations are not redistributed.

## Resolution Contract supported by 13A

A source physical shape may be classified `RESOLVED` only when one runtime Entity satisfies the mandatory evidence floor:

1. runtime candidate exists;
2. assembly-member ownership is coherent;
3. component and hierarchy evidence is compatible with the source shape;
4. Entity-local physical geometry authority is established;
5. a current valid runtime pose is observable;
6. no unresolved contradictory coherent identity remains.

The result records source identity, runtime identity, geometry and pose authority, supporting evidence, validity dependencies and explicit limits. It does not claim complete physical representation.

## Evidence contribution model

Every real candidate and control records evidence for distinct claims:

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

Resolution Path convergence, negative controls and motion-derived distinctness strengthen the claim but are not universal gates. A decisive contradiction prevents resolution. A found node with unproven physical geometry remains a separate result.

## Outcomes

- `RESOLVED` — one coherent runtime Entity remains.
- `AMBIGUOUS` — coherent Resolution Paths disagree.
- `ALIASED` — a root/shared or cross-source Entity is selected.
- `NODE_RESOLVED_GEOMETRY_UNPROVEN` — node identity is coherent but Entity-local physical geometry is not established.
- `UNRESOLVED` — no coherent candidate remains.

Legacy `ROUTE_CONVERGENCE` and `SINGLE_ROUTE` are evidence reasons within `RESOLVED`; candidate labels A/B/C do not imply priority.

## Disproved diagnostic assumption and v4.6.18 validation

The v4.6.17 logger interpreted any raw `foldAnimTime` value between numerical endpoints as `TRANSITION`. TS004 disproved that generalisation. TopDown remained stably at `foldAnimTime=0.1250` while extended and raised for AI manoeuvring, then moved toward `0.0000` while lowering for work.

v4.6.18 recorded neutral evidence only:

```text
animationSource=foldAnimTime
animationValue=<raw value>
animationRegion=HIGH_ENDPOINT|INTERIOR|LOW_ENDPOINT|UNKNOWN
animationMotion=UNOBSERVED|SETTLING|CHANGING|STABLE|UNKNOWN
semanticState=not-inferred
```

The focused AI cycle confirmed `INTERIOR + STABLE` at the raised plateau, `CHANGING` during actual raising/lowering and no semantic `foldState` field. Deployment, vertical configuration, terrain contact, functional engagement and AI operational phase remain separate architectural dimensions.

## Functional-class result

Tiger and TopDown are both cultivators but expose materially different physical structures and successful Resolution Paths. Prototype 13A therefore decreased confidence in implement-class structural homogeneity and increased confidence in a class-independent Resolution Contract.

Use class information as contextual evidence only. It must not establish component structure, mapping coverage, articulation or a privileged Resolution Path.

## Logging contract

For each source shape, the legacy implementation emits:

```text
PROTOTYPE13A SOURCE_SHAPE
PROTOTYPE13A CANDIDATE
PROTOTYPE13A CONTROL_RESULT
PROTOTYPE13A RESOLUTION_OUTCOME
PROTOTYPE13A MOTION_SAMPLE
```

Each fixture also emits `FIXTURE_ATTACHED`, `FAMILY_SUMMARY` and periodic `FIXTURE_ENUMERATION` records.

## Remaining work

The declared Resolution Path evaluation question is answered for the fixture matrix. Future work should select representation-diverse fixtures that try to disprove the Resolution Contract before automated Resolution Path discovery is implemented.

Automated discovery, complete inventory, footprint construction and Coverage Closure remain separate future activities.
