FS25_OuttaMyWay v4.6.8

Prototype 07: Physical Occupancy Evidence — Canonical

Prototype 07 tested whether GIANTS-accessible collision, physics and bounding evidence
could be aggregated across the complete vehicle–implement Entity into a conservative
current Physical Occupancy Envelope.

The tested Direct Geometry Retrieval route is not supported. In TS003 the runtime
exposed rigid-body type, but not the attempted shape, local or world bounding APIs or
collision-mask query. Condor and Patriot each reached the 800-node hierarchy scan
limit with zero bounded nodes, zero physics-bound nodes, coverage NONE and confidence
UNKNOWN. Across approximately 337 seconds, no physical envelope, pair clearance or
configuration-change evidence could be produced.

This is accepted negative evidence, not a rejection of the architecture. GIANTS uses
physical collision geometry internally, but the tested Lua boundary does not disclose
usable bounds for complete-Entity occupancy derivation. This is named the Runtime
Geometry Access Gap.

No Silent Under-Approximation held: each 36 m working-marker width remained separate
agronomic evidence and was never substituted for unknown physical geometry.

The final sweeping turn, near miss and observed reverse deadlock reinforced the need
for current and swept physical knowledge. Situation Assessment retained parked
Condor as relevant, but could not know the actual clearance or swept occupancy. This
is recorded as Retained Entity, Missing Spatial Truth.

Traffic Manager v2 remains disabled and observer-only mode is enforced before any
decision or control consumer. No containment, projected sweep, safety padding, hold,
release, route change, Commitment or vehicle-control behaviour is included.

Start with docs/README.md. The accepted negative evidence and next investigation
boundary are recorded in docs/prototypes/PROTOTYPE_07_PHYSICAL_OCCUPANCY_EVIDENCE.md.
