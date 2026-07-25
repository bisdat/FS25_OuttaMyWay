# Engineering Handover

## Canonical baseline

v4.6.10 remains canonical and the implementation baseline. v4.6.11 through v4.6.14 are evidence-bearing noncanonical candidates whose validated discoveries are consolidated into v4.6.15.

## Accepted discoveries

### Prototype 09 — Component-local sphere evidence

Correctly resolved runtime collision nodes expose stable conservative component-local geometry spheres. Exact mesh geometry and operational precision remain unresolved.

### Prototype 10 — Productive disproval

Vehicle-root calls cannot select descendant geometry using source asset `shapeId`. Root-Entity Sphere Aliasing and the Self-Coherence Blind Spot are accepted negative evidence.

### Prototype 11 — Runtime Entity Geometry Authority

The first argument selected the geometry owner in every tested case. Changing the second argument, including to a deliberately invalid high value, did not redirect geometry selection. Source `shapeId` remains provenance metadata rather than a demonstrated runtime selector.

### Prototype 12 — Physical Assembly Discovery

Strongly supported across one integrated and two attached fixtures. The operational worker is the Operation-facing identity; its current Physical Assembly defines the set of member-local asset/runtime hierarchies that must be searched for physical geometry.

- Condor: one member, one asset, one runtime root.
- S 416 + Tiger 8 MT: two members, two assets, two roots, one attachment edge.
- 8RX 410 + TopDown 600: the same attached structure replicated with different assets and hierarchy vocabularies.

### Working-State Motion Divergence

The S 416 remained logically active and reported `WORKING` while effectively stationary for at least fifteen seconds. Manual cultivation disproved simple equipment incapability. The cause remains unresolved. The later 8RX/TopDown run sustained normal work, separating AI progression from assembly discovery.

## Candidate increment

v4.6.15 records the validated evidence and disables Prototype 12 after completion. No new active experiment is introduced.

## Immediate continuation point

Return to **Source-to-Runtime Shape Resolution**, now scoped per assembly member. Before implementation, separate:

1. source collision and configuration authority;
2. member-local asset references and mapping vocabulary;
3. member-local runtime hierarchy evidence;
4. independent identity-validation signals;
5. unresolved-shape handling and alias rejection.

The likely next experiment is **Prototype 13 — Member-Local Runtime Identity Resolution**, but its precise hypothesis and fixture scope must be agreed before code is written. Condor can test completion of its thirteen-member Current Physical Set; TopDown 600 can test whether a materially different attached implement exposes viable evidence inputs without requiring immediate complete coverage.

## Boundary

Do not aggregate a Physical Occupancy Envelope until every included current physical source identity has a trustworthy runtime Entity mapping. Geometry availability, attachment membership and names remain insufficient to establish physical membership.
