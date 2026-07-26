# Project Status

Version: 4.6.16

Authority state: Release Candidate — Physical Representation architecture consolidation awaiting repository-owner review

Canonical baseline: v4.6.15

Current focus: define and validate Member-Local Physical Resolution without making exact shape identity a prerequisite for all useful occupancy

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
- No Prototype 13 code is enabled.
- No Physical Occupancy Envelope, containment, sweep prediction, Decision, Commitment or Control is introduced.
- `.gitattributes` establishes repository-native LF text; four inherited CRLF files are normalised.

## Next gate

Agree the precise **Prototype 13 — Member-Local Runtime Identity Resolution** hypothesis and fixture scope. The prototype should test more than one source structure, retain unresolved current shapes explicitly, reject runtime aliases and distinguish identity resolution from fallback occupancy construction.
