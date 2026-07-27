FS25_OuttaMyWay v4.6.21

Base-Game Vehicle Semantic Catalogue Consolidation — Release Candidate

Implementation baseline: exact canonical v4.6.20
Baseline SHA-256: 08000f111892e076fe68972ae08a129e652dacea77a8a2428b3739c212847a52
Current package authority: noncanonical candidate awaiting repository-owner review

This increment consolidates the completed base-game vehicle-definition mining and human semantic review
used to select future physical-representation test subjects. It introduces no gameplay behaviour.

The research chain established:

- 606 base-game vehicle and implement definitions from a 1,365-file selected corpus;
- Raw Definition Evidence plus Selected-Field Inheritance Projection for 41 inherited definitions;
- 567/567 English localisation keys resolved through the running GIANTS localisation authority;
- 147 declared-function cohorts refined into 170 review units;
- a complete human review: 166 units approved unchanged, two amended and two resolved through vocabulary
  additions;
- one reviewed semantic profile for every definition, using 11 broad families, 90 primary roles and
  42 capabilities.

The catalogue preserves raw category, declared type, function, inheritance and localisation evidence.
It records what an asset is and what it can do. It deliberately does not assign OuttaMyWay control
eligibility, Operation participation, attached-assembly relevance, obstacle relevance or structural
challenge.

The two review-time vocabulary discoveries are `LIQUID_TANK_TRAILER` and `FUEL_TRAILER`. Approval
Inheritance is explicit: an `APPROVED` review accepts the complete suggested profile unchanged, even
when replacement cells were left blank.

This release names and records Semantic Profile, Not Category; Role–Capability Separation; Function
Cohort Is an Anchor, Not a Decision; Group Decision–Asset Exception; Minimum Sufficient Semantic
Resolution; Scope-Driven Review Depth; Semantic Classification–Scope Separation; Control
Eligibility–Representation Relevance Separation; and Catalogue–Structure Separation.

The next architectural gate is the Scope Overlay. It must distinguish active control, Operation
participation, assembly relevance and obstacle relevance before structural challenge profiling or
Prototype 13B fixture selection begins.

No automated resolution discovery, Physical Occupancy Envelope, Coverage Closure, conflict assessment,
Commitment or Control behaviour is introduced or changed by v4.6.21. Runtime Lua changes are limited
to version metadata.

See docs/50_Research/VEHICLE_DEFINITION_CORPUS.md,
research/vehicle_semantics/README.md and docs/ENGINEERING_HANDOVER.md.
