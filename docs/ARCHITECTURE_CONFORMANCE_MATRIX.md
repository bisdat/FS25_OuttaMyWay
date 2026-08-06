# Architecture Conformance Matrix

| Concern | Canonical requirement | v4.7.12 state | Status |
|---|---|---|---|
| Field World snapshot | capture once at Job Episode creation | retained immutable | conforming |
| Exact representation | preserve evidence | full canonical root ring and fingerprint | conforming |
| Spatial equivalence | describe experienced workspace | bounded diagnostic metrics only | evidence available; authority deferred |
| Operation grouping | same Field World only | still exact-fingerprint keyed | known provisional limitation |
| Control | disabled | enforced | conforming |

| Concern | Canonical requirement | v4.7.11 state | Validation |
|---|---|---|---|
| Field World identity | Experienced contiguous agronomic polygon | Job-seeded immutable geometry fingerprint | merged/split parallel live run |
| Player locator | Useful map-area communication, not identity | source field or contextual farmland label retained separately | locators 68,69,70,77,77 |
| Operation grouping | Same Field World only | keyed by geometry fingerprint | expected global Operations = 3 |
| Mid-episode mutation | No identity drift | unsupported external mutation; snapshot fixed | structural/offline gate |
| Control | disabled during passive validation | enforced | live `control=false` |

| Concern | Canonical requirement | v4.7.10 state | Status | Next evidence |
|---|---|---|---|---|
| Source field identity | Retained field label requires exact source-field polygon evidence | Polygon-only authority; farmland contextual | Implemented offline | live 68 and 77 |
| Derived Field World | Experienced contiguous workspace may differ from retained source labels | GIANTS field-course boundary probe, diagnostic only | Implemented offline | merged 68–69–70 discovery |
| Job Episode termination | Missing evidence never implies termination | Matching inactive `lastJob` and active-job cessation required | Implemented offline | manual Valtra stop |
| Blockage continuity | Blockage does not end the Job Episode | Stable source token preserved | Enforced | TS015 final blockage |
| Control boundary | No physical authority before passive gates pass | No live Commitment mutation; Control disabled | Enforced | live non-intervention |

> **Currency:** canonical v4.6.78 Replacement-Core Architecture
>
> **Purpose:** define the boundary conditions that future implementation must satisfy before receiving Control authority.

| Architectural responsibility | Normative requirement | v4.6.71 runtime | v4.6.77 experiment | Required implementation evidence |
|---|---|---|---|---|
| Single authority path | One active Observation → Assessment → Picture → Decision → Commitment → Control route | v4.7.10 uses one passive Observation path with explicit immutable traversal; Commitment mutation and Control remain closed | Structurally aligned | first exclusive vertical slice |
| Situation Assessment | Produces Knowledge and fitness, not selected action authority | v4.7.2 candidate | Partial; candidate preference leaked into Assessment | snapshot-to-Knowledge tests |
| Candidate Action Space | Publishes all supportable candidates as explicit records | v4.7.3 publishes complete sealed-fixture inventories | Absent; procedural ladder | complete candidate inventory per decision epoch |
| Mandatory constraints | Every candidate receives explicit `PASS`, `FAIL` or `UNRESOLVED` verdicts | v4.7.3 evaluates all eleven canonical families offline | Local/advisory | negative tests proving failed or unresolved candidates cannot receive authority |
| Decision | Selects only among admissible survivors or explicit non-intervention | v4.7.10 preserves deterministic passive Decision; field diagnostics do not create authority | Enforced offline | owner live passive evidence |
| Commitment | Enforcing lifecycle owner with Governing Basis and Obligation Set | Not implemented | Ledger recorded rather than governed | transition-table tests and illegal-transition rejection |
| Safe Release | Required for ordinary success | Documented concept | Violated | no `SUCCEEDED` without Terminal Settlement evidence |
| Intent change | Reassesses Governing Basis; cannot erase obligations | Not implemented | Violated | supersession and source-termination replay cases |
| Obligation Continuity | Every open obligation has exactly one owning Commitment | Not implemented | Violated by renewed Commitment | ownership ledger assertions across every transition |
| Effective Actuation Composition | Validate current and proposed combined effects before actuation | Not implemented | Absent | multi-command and cross-assembly composition tests |
| Progress authority | Exactly one objective-progress actuation owner per assembly | Not implemented | Partial | lease conflict rejection |
| Representation Fitness | Fitness limits which actions may receive authority | v4.7.2 publishes canonical Knowledge states; authority gate not yet implemented | Inconsistent | action-specific fitness verdict tests |
| Control | Executes only authorised capability and returns physical evidence | Legacy controller | Improved but broad | narrow capability contracts and outcome schemas |
| Replay validation | Historical traces prove architecture composition offline | v4.7.4 canonical replay suite; v4.7.10 adds passive-live identity and lifecycle evidence pending owner validation | Implemented for documented evidence; raw historical parser deferred | passive-live owner evidence |

## Gate interpretation

A row is not considered implemented because a module, field or log message carries the correct name. Conformance requires executable rejection of invalid states and replay evidence that the complete composition respects the contract.