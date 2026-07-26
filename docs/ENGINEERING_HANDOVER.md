# Engineering Handover

## Canonical baseline

v4.6.15 is canonical and the implementation baseline. v4.6.16 is a noncanonical consolidation candidate until independently reviewed and explicitly Canonicalised by the repository owner.

## Accepted architecture

The complete agreed model is owned by `PHYSICAL_REPRESENTATION_ARCHITECTURE.md`. The essential continuation facts are:

1. Exact runtime collision identity and useful occupancy are separate claims.
2. Plan-view representations retain Spatial Core, Validity Context and Evidence Quality.
3. A job-start Representation Catalogue owns stable templates; Situation Assessment realises current pose and state.
4. Component, Convex Planar Envelope and conservative member/assembly representations may coexist.
5. Mixed precision is accepted; fallbacks are introduced at the smallest safe scope and uncertainty stays local.
6. Coverage Closure may be enumerative, enclosing or hybrid. Structural Closure and Realised Closure are distinct.
7. Incomplete relevant coverage produces Clearance Unresolved, not all-clear and not invented conflict.
8. Deployment and manoeuvre sweeps remain separate; steering-mode-dependent manoeuvre kinematics are deferred.

## TS004 fixture

TS004 is now the static contrast fixture:

- unit1: Valtra S 416 + Horsch Tiger 8 MT;
- unit2: John Deere 8RX 410 + Väderstad TopDown 600.

Tiger represents wing articulation through multiple physics components. TopDown represents folding collision-bearing descendants within one physics component. Direct mapping coverage also differs. These assets demonstrate that Prototype 13 cannot assume Condor-style mapping vocabulary or use physics-component count as collision inventory. GIANTS assets are not retained in the repository and must be supplied again when required.

## Immediate continuation point

Discuss the exact Prototype 13 hypothesis before implementation. The next experiment should answer:

> Can configuration-aware source collision identities be connected to distinct runtime Entities inside materially different assembly-member structures, while retaining unresolved identities, alias evidence and independently qualified occupancy fallbacks?

Candidate scope should likely include:

- Condor for known repeated-family resolution;
- Tiger or TopDown for a contrasting member-local hierarchy route;
- no assembly envelope or active containment until the evidence supports it.

## Deferred questions

- Envelope Anchor Selection for the Convex Planar Envelope;
- exact Deployment Clearance Envelope construction;
- manoeuvre sweep, turning radius and steering kinematics;
- representation behaviour for unusual plan-view effects from vertical articulation;
- Decision Engine response to Clearance Unresolved.

## Repository operation

Text files are now governed as LF by `.gitattributes`. The four inherited CRLF files are normalised in v4.6.16. Candidate packaging and release-manifest generation must therefore preserve the LF bytes declared by the repository.
