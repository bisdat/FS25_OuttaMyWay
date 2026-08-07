# v4.7.18 Positive Encounter-Admission Conformance

| Concern | Requirement | v4.7.18 evidence | Status |
|---|---|---|---|
| Monotonic evidence | footprint uncertainty cannot suppress scalar positives | pure one-way composition fixture | PASS offline |
| Positive permission | filtered represented components may support current/future interaction | footprint-only source-to-Encounter fixture | PASS offline |
| Negative prohibition | non-positive footprint cannot prove clearance | zero negative authority retained | PASS offline |
| Handoff | emitted evidence must be received and create Encounter | integration fixture with missing scalar radius | PASS offline |
| Provenance | source and represented component basis remain visible | evidence packet and pair diagnostics | PASS offline |
| Decision boundary | Encounter does not imply physical strategy | passive candidate support unchanged | PASS |
| Control | no actuation authority | `control=false`; no boundary apply | PASS |

# v4.7.17 Configuration-Participation Conformance

| Concern | Requirement | v4.7.17 evidence | Status |
|---|---|---|---|
| Inventory separation | available asset geometry must not equal current occupancy by default | inventory and profile participation sets are separate | PASS offline |
| Current participation | active primitives require runtime or matched donor evidence | `getIsCompoundChild`; matched donor fallback | PASS offline |
| Alternative configuration | inactive shop geometry must remain excluded | explicit 36 m versus 54 m fixture | PASS offline |
| Cache cost | geometry calls remain Job Episode-scoped | geometry cache reuse retained; activity checks profile-scoped | PASS offline |
| Uncertainty | unresolved activity cannot grant positive or negative authority | unresolved inventory retained outside positioned physical set | PASS offline |
| Behaviour isolation | no live predicate or Control change | shadow path only | PASS |

# v4.7.16 Representation-Shadow Conformance

| Concern | Requirement | v4.7.16 evidence | Status |
|---|---|---|---|
| Archive isolation | Donors may be extracted but archived modules must remain inactive | active loader sources only new replacement-core representation modules | PASS |
| Job-scoped structure | Assembly membership and local geometry are discovered once per Job Episode | `AssemblyRepresentationCache` with episode key and cache-hit tests | PASS |
| Compound shape | Attached and offset members retain their own poses | recursive assembly graph and articulated mock fixture | PASS |
| Non-rectangular occupancy | T-shaped/component composition must not flatten to one box | layered primitives plus hull fixture | PASS |
| Runtime identity | Geometry must be selected by resolved runtime Entity and root aliases rejected | direct mapping/path/name routes plus coherence and alias checks | PASS |
| Configuration reuse | encountered material states receive reusable profiles | configuration-profile cache | PASS |
| Uncertainty | incomplete coverage cannot establish negative clearance | `SHADOW_CLEARANCE_UNRESOLVED`; no negative authority | PASS |
| Behaviour isolation | shadow evidence must not emit live interaction evidence or Control | source records shadow fields only; predictor and Control unchanged | PASS |

# Architecture Conformance Matrix

| Concern | Requirement | Canonical v4.7.14 state | v4.7.15 diagnostic effect | Status |
|---|---|---|---|---|
| Snapshot evidence | immutable per Job Episode | live-validated | observed only | conforming |
| Exact representation | provenance, not identity authority | live-validated | unchanged | conforming |
| Field World authority | coherent positive spatial equivalence | merged, split and contiguous gates passed | unchanged | live-conforming |
| Operation grouping | consume resolved Field World identity | live-validated | unchanged | live-conforming |
| Unresolved evidence | no Operation or Control authority | live-validated | unchanged | conforming |
| Multi-worker assessment | no two-worker scope limit | Operations may contain multiple members | all unordered pairs enumerated | conforming diagnostically |
| Observation purity | facts only; no Decision authority | retained | diagnostic branch labels only | conforming |
| No Silent Under-Approximation | incomplete representation cannot prove clearance | current live metadata is unfit for negative clearance | contradiction is exposed | implementation defect visible; not corrected |
| Encounter construction | positive interaction evidence becomes Encounter Knowledge | proven offline | source/handoff counters added | conforming offline; live source pending diagnosis |
| Control | disabled until passive evidence is trustworthy | enforced | unchanged | conforming |

## v4.7.15 offline fixtures

- exhaustive pair-prediction outcome labels;
- forward, reverse, turning and stationary observed-motion diagnostics;
- three workers produce three unique unordered relationships;
- missing radius remains a non-qualifying result and is preserved through assessment;
- qualifying live pair produces one Encounter with complete handoff counts;
- active-job pose failure is explicit without admission;
- mutually blocked same-Operation pair without Encounter creates a diagnostic warning;
- all previous Field World, admission, Decision and lifecycle tests remain green.

> **Architecture currency:** canonical v4.6.78 Replacement-Core Architecture as extended by ADR-0021.  
> **Implementation baseline:** owner-declared canonical v4.7.15; the retained lower table records the v4.7.15 diagnostic comparison against canonical v4.7.14.  
> **Control authority:** disabled.
