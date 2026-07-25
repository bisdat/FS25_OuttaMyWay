# Prototype 09 — Runtime Shape-Bound Evidence

## Authority state

Runtime evidence accepted from the noncanonical v4.6.11 candidate and consolidated into v4.6.15. v4.6.11 was not declared canonical because its successful-call error text was defective.

## Observe

Prototype 08 established trustworthy physical collision-node identity and authoritative live pose for Condor's purchased 36 m Geometry Family. It did not establish local collision-mesh extent.

A subsequent audit of the official FS25 engine Shape reference identified three documented two-argument functions that Prototype 07 did not test:

- `getShapeGeometryBoundingSphere(entityId, shapeId)`;
- `getShapeBoundingSphere(entityId, shapeId)`;
- `getShapeWorldBoundingSphere(entityId, shapeId)`.

Prototype 07 tested box-oriented calls and correctly disproved that tested route. It did not test this per-shape sphere family or its documented `entityId + shapeId` identity contract.

## Named discoveries

### Shape-Bound Capability Blind Spot

The earlier Direct Geometry Retrieval result covered the APIs and signatures actually tested. It did not establish that every runtime shape-bound route was unavailable.

### Component-Local Sphere Bridge

Prototype 08B supplies source-bound physical membership and mapping identity. Prototype 08A resolves the corresponding runtime collision node and authoritative live pose. Prototype 09 tests whether that resolved runtime Entity exposes conservative component-local geometry bounds.

The source asset `shapeId` is retained as provenance metadata. Prototype 10 later disproved the stronger interpretation that an asset `shapeId` can independently select an arbitrary descendant when paired with the vehicle root.

### Extent Truth–Utility Separation

A geometry representation may be trustworthy but too coarse for the eventual operational use. A sphere can conservatively contain a long thin boom segment while also including substantial empty space. Establishing truthful component-local sphere extent therefore does not establish a sufficiently precise Physical Occupancy Envelope.

## Architectural requirements

A successful component-local extent source must retain:

- physical provenance from a source-identified collision shape;
- exact asset and Geometry Family identity;
- component locality in a stable transform frame;
- pose independence across folding and articulation;
- compatibility with authoritative live node pose;
- conservative coverage without silent under-approximation;
- explicit representation type and resolution;
- separate assessment of truth and operational utility.

## Available evidence and confidence

| Source | Provenance | Confidence before Prototype 09 | Role |
|---|---|---:|---|
| Prototype 08B collision catalogue | source asset, configuration and collision metadata | high | physical shape identity and `shapeId` |
| Prototype 08A resolved runtime nodes | live runtime | high | current component identity and pose |
| documented runtime shape spheres | GIANTS engine API | unknown | candidate local physical extent |
| offline `.i3d.shapes` decoding | proprietary binary asset | unresolved | deferred alternative |
| visible model and boom taper | rendered observation | supporting only | sanity check, never extent source |
| working width and node-origin spacing | agronomic/positional | rejected as extent | comparison only |

## General concept versus Condor fixture

### Generalisable

- a Geometry Family selects active physical shapes;
- a source-bound collision catalogue establishes Physical Shape Membership;
- a Component-Local Extent is static geometry evidence;
- Live Collision Node Pose places that extent in the current world;
- compound occupancy is a later union of transformed component extents;
- every extent carries provenance, coverage, representation and confidence.

### Condor-specific

- the fixture contains eight active 36 m boom collision shapes;
- it has four articulated sections on each side;
- corresponding left/right results can provide a model-specific consistency check;
- observed taper is not a generic foldable-implement assumption.

## Precise hypothesis

> For Condor's identified physical collision shapes, the FS25 runtime exposes finite, non-zero component-local geometry bounding spheres whose local centres and radii remain stable through the complete `FOLDED -> TRANSITION -> DEPLOYED` lifecycle, and whose transformed local shape-bound centres agree with the engine-reported world bounding-sphere centres. If supported, these spheres constitute trustworthy conservative component-local physical extents, but not exact mesh bounds or an authoritative final Physical Occupancy Envelope.

## Implementation

Prototype 09 is an isolated passive probe in `scripts/prototypes/ShapeBoundProbe.lua`.

It consumes Prototype 08 state after 08 has:

- found the Condor Entity;
- selected the 36 m source catalogue;
- resolved each named collision node;
- preserved current live node pose.

It does not independently rediscover vehicle or collision identity.

### Invocation-semantics experiment

For every one of the eight source-identified physical boom shapes, the probe tests four protected candidate identity/frame routes once:

1. runtime collision node as `entityId`, asset `shapeId`, runtime-node local frame;
2. vehicle root as `entityId`, asset `shapeId`, vehicle-root local frame;
3. vehicle root as `entityId`, asset `shapeId`, resolved collision-node local frame;
4. runtime collision node as `entityId`, zero `shapeId`, runtime-node local frame as a diagnostic-only route.

Each call is protected. Failure, invalid values and API absence remain evidence rather than runtime errors. The zero-shape route can reveal default-shape semantics but is not eligible for source-bound extent selection because it does not preserve the catalogue `shapeId`.

A source-bound route is selected only when all three sphere functions return finite non-zero data and transforming the local result from that candidate frame agrees with the engine world result within the declared 0.05 m diagnostic tolerance. No route is silently selected from partial evidence.

### Repeated evidence

For a selected route, the probe records:

- geometry-local centre and radius;
- general shape-local centre, radius and `usesGeometry`;
- engine world centre and radius;
- transformed predicted world centre;
- local geometry drift from the first sample;
- local shape-bound drift from the first sample;
- local-to-world centre and radius error;
- geometry-versus-general-shape difference;
- fold state and `foldAnimTime`.

### Control coverage

The canonical 08B runtime catalogue contains the eight active physical boom shapes but not a permanent chassis control set or a deliberately nonphysical render-shape set. Prototype 09 does not invent those identities. Logs state this coverage limitation explicitly. If the first run supports the bridge, separately cataloguing positive chassis and negative render controls becomes a confidence-strengthening follow-up rather than part of the initial identity-semantics test.

## Searchable events

- `PROTOTYPE09 CAPABILITY`
- `PROTOTYPE09 ENTITY_ATTACHED`
- `PROTOTYPE09 INVOCATION_RESULT`
- `PROTOTYPE09 ROUTE_SELECTED`
- `PROTOTYPE09 NO_COHERENT_SOURCE_BOUND_ROUTE`
- `PROTOTYPE09 FOLD_STATE_CHANGED`
- `PROTOTYPE09 SHAPE_BOUND_SAMPLE`
- `PROTOTYPE09 NODE_BOUND`
- `PROTOTYPE09 SOURCE_UNAVAILABLE`

## Validation fixture

Use TS001 with the same persistent purchased 36 m Condor used for Prototype 08A:

1. load with the boom folded and AI inactive;
2. preserve a brief folded endpoint sample;
3. start the AI worker so the complete unfolding transition occurs;
4. preserve stable deployed samples while working;
5. upload the complete game log.

No additional vehicle interaction is required for this hypothesis.

## Result classifications

### Strongly supported

- all three functions are available;
- one coherent identity route resolves for every intended physical shape;
- local geometry centres and radii remain stable through articulation;
- transformed local shape-bound centres agree with world centres;
- physical catalogue provenance is retained;
- no working-width or visual substitution occurs.

### Partially supported

Examples include partial shape coverage, stable local geometry with failed world coherence, overridden general shape bounds, or truthful spheres that appear too coarse for useful containment.

### Unsupported

The route is unsupported if functions are unavailable, no coherent identity route exists, values are invalid or unstable, or returned evidence cannot be tied to the intended physical collision shape.

## Accepted validation result

TS001 captured folded, transition and deployed samples. All three documented functions were available. All eight active physical boom shapes selected a source-bound route, returned finite non-zero geometry/general/world spheres, and reported `usesGeometry=true`.

Across the complete lifecycle:

- maximum component-local centre drift was `0.000000 m` at logged precision;
- maximum component-local radius drift was `0.000000 m` at logged precision;
- transformed local centres agreed with engine world centres to `0.000000 m` at logged precision;
- world/local radius differences remained numerical noise;
- left/right counterpart radii agreed closely;
- the outer `Col04` sphere centre offset demonstrated that node origin and geometry centre are not interchangeable.

**Result:** the core hypothesis is strongly supported for the eight tested Condor 36 m boom shapes. Source collision identity is joined to a correctly resolved runtime collision node, and that runtime Entity exposes a trustworthy conservative component-local sphere. Prototype 10 showed that the source asset `shapeId` must not be treated as an independent descendant selector. Exact mesh dimensions and operational precision remain unresolved.

### Diagnostic defect learned

The v4.6.11 implementation used Lua's `valid and nil or "invalid-return"` idiom. Because `nil` is false, successful calls still emitted `invalid-return`. This Successful-Call Error Residue affected text only; validity, measurements and coherence calculations remained correct. v4.6.13 carries forward the correction.

## Boundary

Prototype 09 tests runtime access, identity semantics, physical provenance, local stability and transform coherence only.

It does not derive a compound Physical Occupancy Envelope, decide sphere utility, calculate containment, create Configuration Transition Sweep or Projected Motion Sweep, or issue Decision, Commitment or Control.
