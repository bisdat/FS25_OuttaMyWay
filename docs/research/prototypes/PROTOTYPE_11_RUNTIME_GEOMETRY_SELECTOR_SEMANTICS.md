# Prototype 11 — Runtime Geometry Selector Semantics

## Authority state

Strongly supported by repeated TS001 runtime evidence from noncanonical candidate v4.6.13 and consolidated into v4.6.15.

## Observe

Prototype 09 returned distinct stable component-local spheres when each resolved runtime collision node was supplied as the first shape-bound API argument. Prototype 10 returned one repeated vehicle-root sphere for every source asset `shapeId` when the vehicle root was supplied instead.

The remaining uncertainty is no longer whether runtime geometry bounds exist. It is which argument selects the geometry and what role, if any, the second `shapeId` argument performs.

## Architectural separation

Three identities must remain distinct:

1. **Source Shape Identity** — asset name, hierarchy, source `shapeId`, collision metadata and configuration membership.
2. **Runtime Entity Identity** — the instantiated node that owns current geometry and pose.
3. **Geometry-Bound Identity** — the geometry returned by the shape-bound API for a particular invocation.

Internal bound coherence is not identity proof. Selector semantics require cross-invocation and cross-Entity comparison.

## Precise hypothesis

> For a correctly resolved runtime collision node, the first API argument determines the component geometry returned. Changing the second `shapeId` between zero, the node's own source asset ID and another component's source asset ID does not select sibling geometry. Calls on different resolved runtime nodes return different component bounds, while equivalent calls on `vehicle.rootNode` alias to root-Entity geometry. A deliberately invalid second argument may be rejected or accepted; its behaviour is diagnostic and is not required to support the core hypothesis.

## Implementation

`RuntimeGeometrySelectorProbe.lua` consumes only Prototype 08's resolved runtime nodes and source catalogue. It does not infer physical membership from shape-bound success.

### Initial selector matrix

For all eight resolved active 36 m boom collision nodes, the probe tests:

- `shapeId = 0`;
- the node's own source asset `shapeId`;
- a sibling component's source asset `shapeId`;
- a deliberately invalid high `shapeId`.

The same known-ID comparison is performed on `vehicle.rootNode`.

Every route records:

- geometry-local sphere;
- general shape sphere and `usesGeometry`;
- world sphere;
- local-to-world coherence;
- errors or invalid returns;
- equality with the own-ID result.

### Independent identity evidence

The probe counts distinct local and world sphere signatures across resolved runtime nodes. Support requires more than self-coherence:

- known second-argument variants must be invariant on each resolved node;
- different resolved nodes must produce differentiated geometry/world evidence;
- known second-argument variants on the vehicle root must alias consistently to root geometry.

### Lifecycle check

Four representative resolved nodes are rechecked through folded, transition and deployed states. The test asks whether selector semantics remain stable while world pose changes. It does not aggregate occupancy.

## Searchable events

- `PROTOTYPE11 CAPABILITY`
- `PROTOTYPE11 SELECTOR_RESULT`
- `PROTOTYPE11 ENTITY_SELECTOR_SUMMARY`
- `PROTOTYPE11 HYPOTHESIS_SUMMARY`
- `PROTOTYPE11 LIFECYCLE_NODE_CHECK`
- `PROTOTYPE11 FOLD_STATE_CHANGED`
- `PROTOTYPE11 LIFECYCLE_SUMMARY`
- `PROTOTYPE11 SOURCE_UNAVAILABLE`

## Validation fixture

Use TS001 with the purchased 36 m Condor:

1. load folded and stationary;
2. retain several folded samples;
3. start AI and observe the complete unfolding transition;
4. retain stable deployed samples;
5. upload the complete game log.

## Result classifications

### Strongly supported

- zero, own and sibling known IDs return the same coherent bound on every resolved node;
- different resolved nodes produce multiple distinct component-local signatures and distinct world placements;
- vehicle-root known-ID calls remain aliased to one root-Entity geometry;
- selector behaviour remains stable through articulation.

### Partially supported

Examples include invariant selector behaviour on only some nodes, cross-Entity differentiation without consistent known-ID invariance, or state-dependent behaviour.

### Unsupported

The hypothesis is unsupported if second-argument changes select sibling geometry, resolved nodes do not differentiate geometry, or the result cannot distinguish runtime Entity identity from root aliasing.

## Boundary

Prototype 11 tests runtime selector semantics only. It does not resolve the five permanent physical nodes, establish complete physical coverage, derive a Physical Occupancy Envelope, or authorise containment, sweep, Decision, Commitment or Control.


## Accepted runtime result

All eight resolved collision nodes were invariant across zero, own, sibling and invalid-high second arguments. Seven distinct local signatures and eight distinct world signatures preserved cross-Entity differentiation. The vehicle root remained aliased across known IDs. Representative lifecycle checks remained stable through folded, transition and deployed states.

This strongly supports Runtime Entity Geometry Authority and Second-Argument Non-Authority for the tested APIs and Entity types. It does not prove that the second argument is universally meaningless.
