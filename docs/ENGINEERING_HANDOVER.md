# Engineering Handover

## Authority state

v4.6.18 is the exact canonical baseline for this increment. Canonical SHA-256:

```text
27259e823e3893f2508fd2f526b23ade00a3aad52e4aba18c04f75c73b5cb681
```

v4.6.20 is a noncanonical Prototype 13A Resolution Knowledge Consolidation Completion Patch candidate. It changes documentation and package version metadata only; Prototype 13A runtime behaviour and logging are unchanged.

The earlier v4.6.19 candidate was discarded before canonicalisation because two substantively reviewed documents retained stale v4.6.16 review markers. v4.6.20 is rebuilt from exact canonical v4.6.18 and corrects `docs/README.md` plus `docs/CONCEPT_REGISTER.md`; older review markers remain unchanged where no substantive review occurred.

## Prototype 13A accepted result

The declared fixture matrix produced ten coherent `RESOLVED / ROUTE_CONVERGENCE` implementation outcomes:

- Condor: four representative boom collision shapes;
- Tiger 8 MT: left and right wing `colPart` shapes;
- TopDown 600: left and right folding-arm collision descendants.

Every legitimate A/B pair converged on one runtime Entity. All deliberately invalid C controls were rejected through hierarchy-name or component-ownership evidence. No ambiguity, alias, geometry-unproven or unresolved result occurred. Runtime handles remained stable through observed configuration motion.

The focused v4.6.18 TopDown run validated the corrected neutral logger: `0.1250` remained `INTERIOR + STABLE`, actual raise/lower motion became `CHANGING`, and semantic fold state was not inferred. v4.6.18 was explicitly declared canonical and deterministically regenerated twice from clean Git commit `fd1ae00675f1a9c5817f361a6565d8d1f7586912` with an exact hash match.

## Terminology correction

In architectural language, use **Resolution Path** for a source-to-runtime candidate-generation method. Reserve **route** for a worker's navigable field path.

Historical prototype filenames, Lua symbols and log reasons such as `DeclaredRouteEvaluationProbe` and `ROUTE_CONVERGENCE` remain unchanged for evidence traceability. They should be read as legacy implementation labels for Resolution Paths, not worker navigation routes.

## Resolution Contract

A source physical shape is `RESOLVED` only when one runtime Entity is defensibly established through:

1. candidate existence;
2. assembly-member coherence;
3. compatible component and hierarchy evidence;
4. Entity-local geometry authority;
5. observable current pose authority;
6. absence of unresolved contradictory runtime identity evidence.

The resulting **Resolution Claim Set** records source identity, runtime identity, geometry authority, pose authority, supporting evidence, validity dependencies and explicit limits. Resolution never implies complete inventory, Coverage Closure or footprint correctness.

Resolution Path convergence, negative-control rejection, motion-derived distinctness, symmetry and repeated observation are corroborating evidence. Their absence does not universally prevent resolution; a decisive contradiction does. Confidence remains claim-specific rather than one scalar score.

## Assessment representation boundary

Resolution and Assessment Representation are separate contracts:

```text
Resolution
    establishes defensible identity, geometry and pose claims

Assessment Representation
    supplies the best currently defensible spatial account for the question,
    plausible futures, horizon and time budget
```

Situation Assessment receives a **minimum sufficient defensible portfolio** of complementary representations rather than necessarily one universal geometry. Each layer carries a Representation Passport:

- physical scope;
- evidence authority and provenance;
- validity dependencies;
- coverage statement and underestimation risk;
- freshness and observed change;
- cost profile;
- permitted assessment conclusions.

Admissibility precedes cost optimisation. A partial representation may support `CONFLICT_SUPPORTED` or `CONFLICT_POSSIBLE` while remaining forbidden from supporting `CONFLICT_EXCLUDED`.

## Situation Assessment responsibility

Representations report evidence, dependencies, age and observed changes. Situation Assessment decides whether they are fit for the current question and horizon and may produce knowledge such as:

- `CURRENTLY_FIT`;
- `FIT_FOR_LIMITED_HORIZON`;
- `USABLE_WITH_UNCERTAINTY`;
- `REFRESH_REQUIRED`;
- `STRUCTURALLY_INVALID`.

Assessment-relative staleness does not automatically destroy older evidence. Situation Assessment restricts the claims it may still support. Refresh execution remains part of observation/representation maintenance; Situation Assessment produces Knowledge and does not issue vehicle Control.

## Dependency-scoped invalidation

Refresh occurs at the smallest affected scope:

- speed or heading change invalidates the old future projection;
- normal translation/rotation refreshes pose while retaining stable identity and geometry;
- implement articulation invalidates affected member pose and occupancy;
- attachment/configuration change may invalidate assembly structure and catalogue;
- job completion invalidates active membership and motion expectation but not physical identity or obstacle relevance.

## Implement-class result

Tiger and TopDown are both cultivators yet use materially different physical structures and successful Resolution Paths. Prototype 13A therefore decreased confidence in implement-class structural homogeneity while increasing confidence in one class-independent Resolution Contract.

Use **Class as Context, Not Contract**. Gameplay class may inform likely operational semantics and candidate questions, but source hierarchy, runtime assembly and observed pose remain physical authorities.

## Completion boundary

OuttaMyWay accepts wherever and however GIANTS finishes an AI job. The completed assembly transitions from active cooperative worker to persistent non-member obstacle. Its actual final pose is refreshed and retained in the Operational Picture. OuttaMyWay does not choose a parking location, move it off-field or infer the player's preferred disposition.

**Post-Job Configuration Normalisation**—for example safe in-place raising or folding to reduce footprint—is deferred for later investigation. It requires proven control availability, correct sequence, sweep safety and actual spatial benefit.

**Assessment Deadline Escalation** is also parked. A later Decision Engine session may examine selective hold, emergency freeze or other failsafe responses when useful knowledge cannot be refreshed before decision time expires. No policy is selected here.

## Next session

The repository owner has ideas for future test subjects that may require data mining. Select fixtures for representation diversity and their ability to disprove the Resolution Contract, not simply to add more implement classes.

Useful challenges include:

- one legitimate Resolution Path only;
- similar physical structure across different gameplay classes;
- radically different structures within one class;
- rigid or asymmetric assets where motion or symmetry corroboration is unavailable;
- coherent hierarchy with no Entity-local geometry;
- deliberate root/shared alias cases;
- structural or attachment changes that invalidate prior claims.

Do not begin Prototype 13B implementation until the fixture strategy and disproof questions are agreed.
