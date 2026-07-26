# Project Status

Version: 4.6.18

Authority state: Release Candidate — Prototype 13A evidence consolidated; corrected neutral animation-state logging awaiting focused validation and repository-owner review

Implementation baseline: exact tested v4.6.17 candidate

Last canonical baseline: v4.6.16

Current focus: validate the corrected neutral animation logger against TopDown stable interior and moving animation states; do not begin route discovery or footprint construction

## Prototype 13A evidence result and correction candidate

Prototype 13A's declared route hypothesis is supported for the tested matrix. All ten source shapes resolved through A/B route convergence and all ten invalid C controls were rejected. The result validates the tested route mechanisms and common evaluator, not complete physical inventory, footprints or Coverage Closure.

TS004 also disproved the generic `foldState=TRANSITION` label for all interior animation values. TopDown held a stable `foldAnimTime=0.1250` in an extended-raised manoeuvring pose. v4.6.18 therefore logs neutral animation region and motion with semantic state explicitly not inferred.

The current validation objective is one focused TopDown AI cycle confirming `INTERIOR + STABLE` at the raised plateau and `CHANGING` while lowering/raising.

## Established geometry and assembly evidence

Prototype 08 established Condor source collision identity and authoritative live pose. Prototype 09 strongly supported component-local runtime geometry spheres. Prototype 10 disproved vehicle-root source-ID selection. Prototype 11 strongly supported Runtime Entity Geometry Authority. Prototype 12 established the Physical Assembly Search Boundary across one integrated and two attached fixtures.

The accepted search chain remains:

```text
Operational Worker
    -> Current Physical Assembly
    -> Individual Assembly Members
    -> Member-local source/runtime identity resolution
```

## Agreed Physical Representation architecture

- Exact physical identity and usable occupancy are separate claims.
- Physical Representation uses Planar Collision Semantics and excludes height as a current clearance dimension.
- The portfolio supports Component Footprint Sets, Convex Planar Envelopes and conservative member/assembly fallbacks.
- Envelope Anchor Selection remains deferred pending comparative evidence.
- A Job-Scoped Representation Catalogue contains stable templates and expires at job end.
- Pose Realisation updates current plan-view state without rebuilding the catalogue.
- Homologous components share family strategy while retaining individual parameters.
- Heterogeneous Footprint Composition permits mixed precision with smallest-scope fallback and localised uncertainty.
- Folded and working are the principal stable states; deployment is Stationary Configuration Motion governed by a Deployment Clearance Envelope before its Commitment Point.
- Deployment Sweep and Manoeuvre Sweep remain separate. Manoeuvre sweep must account for steering mode and observed kinematics rather than a midpoint-pivot assumption.
- Coverage Closure is distinct from Inventory Closure and may be enumerative, enclosing or hybrid.
- Structural Coverage Closure belongs to the catalogue; Realised Coverage Closure additionally requires current valid pose.
- Partial knowledge continues as Clearance Unresolved wherever a relevant coverage gap prevents safe exclusion.

The authoritative detail is in `PHYSICAL_REPRESENTATION_ARCHITECTURE.md`.

## TS004 contrast evidence

TS004 now contains:

| Unit | Combination | Static structural contrast |
|---|---|---|
| unit1 | Valtra S 416 + Horsch Tiger 8 MT | Multi-component implement with separate wing physics components |
| unit2 | John Deere 8RX 410 + Väderstad TopDown 600 | Single physics component with internally animated collision-bearing descendants |

The contrast establishes that physics-component count, mapping count and working width cannot establish collision inventory or Coverage Closure. Runtime validation remains outstanding.

## Candidate implementation state

- Prototypes 08, 09, 11 and 12 remain disabled after completing their present evidence roles.
- Prototype 10 remains recorded disproval only.
- Prototype 13A remains enabled only to validate corrected neutral animation-state logging; route evidence is already consolidated.
- Four fixture, resolver, evaluator and orchestration modules are isolated under `scripts/prototypes/`.
- No Physical Occupancy Envelope, Coverage Closure, containment, sweep prediction, Decision, Commitment or Control is introduced.
- Repository-native LF text established in v4.6.16 remains intact.

## Next gate

Run the Condor, Tiger 8 MT and TopDown 600 fixture matrix through folded, transition and fully extended states. Review route convergence/disagreement, control rejection, alias evidence, Entity-local geometry and family consistency before considering Prototype 13B automated route discovery.
