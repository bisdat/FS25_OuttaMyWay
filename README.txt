FS25_OuttaMyWay v4.6.10

Prototype 08: Collision Node Pose and Model-Derived Catalogue — Canonical

Prototype 08 separates collision-node identity and live pose from collision-mesh
extent. The corrected TS001 run enumerated Condor through the authoritative vehicle
system collection, attached one persistent Entity and resolved all eight physical
boom collision nodes active for its purchased 36 m Geometry Family.

The complete live fold lifecycle was observed. `foldAnimTime=1.0` corresponded to the
stationary folded endpoint; manual AI start produced one continuous transition; and
`foldAnimTime=0.0` corresponded to stable deployed work. The collision-node origin
span changed from approximately 2.8237 m folded to 30.2403 m deployed while all node
identities remained resolved.

The offline catalogue correctly establishes 29 physical compound-child shapes,
configuration membership, eight active 36 m boom nodes and the principal folded and
deployed lateral spans. Its complete endpoint pose reconstruction is not
authoritative: the folded outer `Col04` longitudinal prediction was materially wrong
and stable deployed per-node comparison retained approximately 0.55 m RMS error.
Runtime node transforms are therefore the authoritative pose source.

Condor has four boom sections per side and appears progressively thinner toward the
tips, supporting a segmented tapered compound representation for this machine only.
Other foldable implements may use entirely different geometry and must be discovered
from their own model, configuration and live pose evidence.

Binary `.i3d.shapes` local mesh extents remain unresolved. Collision-node origins are
not mesh bounds, working width is not physical occupancy, and no Physical Occupancy
Envelope, containment, projected sweep, hold, release or vehicle-control behaviour is
claimed. Traffic Manager v2 remains disabled and observer-only mode is enforced.

Start with docs/README.md and
docs/prototypes/PROTOTYPE_08_COLLISION_NODE_POSE_AND_CATALOGUE.md.
