# Prototype 10 — Physical Shape Coverage

## Authority state

Runtime evidence accepted from the noncanonical v4.6.12 candidate and consolidated into v4.6.15. The v4.6.12 implementation is not retained as active code because its central selector hypothesis was disproved.

## Observe

Prototype 09 established trustworthy conservative component-local spheres for the eight resolved Condor 36 m boom collision nodes. Prototype 10 attempted to avoid resolving every remaining runtime node by querying all source-catalogued physical asset `shapeId` values through `vehicle.rootNode`.

The source catalogue contained 29 physical `compoundChild` identities:

- eight active 36 m boom shapes;
- sixteen inactive alternative-boom shapes;
- five permanent non-boom physical shapes.

Prototype 10 also selected one geometry-bearing shape absent from the physical catalogue as a nonphysical control.

## Precise hypothesis tested

> Every source-catalogued physical descendant shape can be selected by calling the runtime shape-bound APIs with `vehicle.rootNode + asset shapeId`, while source collision metadata and configuration membership remain the authorities for physical inclusion.

## Runtime result

The calls were internally coherent, but every one of the 29 physical asset IDs returned the same root-local sphere:

```text
centre = 0.000000, 2.253981, 1.032253
radius = 4.363019 m
```

The nonphysical control returned the same sphere. The resulting union remained exactly `8.726038 m` in all three axes through `FOLDED -> TRANSITION -> DEPLOYED`.

This cannot represent the posed 36 m boom geometry.

**Result:** the root-scoped descendant-selection hypothesis is disproved.

## Named discoveries

### Root-Entity Sphere Aliasing

Supplying `vehicle.rootNode` as the first argument caused all tested asset `shapeId` values to return the same geometry associated with the root Entity. An asset scenegraph `shapeId` is not a global descendant selector when paired with the loaded vehicle root.

### Self-Coherence Blind Spot

Geometry-local, general-shape and world spheres can agree perfectly while all describing the wrong Entity. Local-to-world coherence validates a returned bound internally; it does not independently validate intended source identity.

### Source-to-Runtime Shape Resolution

Source Shape Identity and Runtime Entity Identity are separate domains. A source collision catalogue can establish physical membership and configuration class, but a separate bridge must identify the instantiated runtime Entity that owns that shape's geometry and pose.

## What remains valid

- The 29 source physical identities and their membership classes remain valid source evidence.
- Geometry availability does not establish physical membership.
- Prototype 09 remains strongly supported because its distinct results came from distinct resolved runtime collision nodes.
- Bounding-sphere extraction is working; complete runtime identity resolution remains the unsolved coverage problem.

## Rejected implementation route

The following route shall not be used for descendant physical coverage:

```text
vehicle.rootNode + source asset shapeId
```

The v4.6.12 `PhysicalShapeCoverageProbe` is intentionally not carried forward as active code. The evidence and disproval are retained here as architectural knowledge.

## Boundary

Prototype 10 did not establish complete physical coverage or a Physical Occupancy Envelope. No containment, transition sweep, projected motion sweep, Decision, Commitment or Control conclusion follows.
