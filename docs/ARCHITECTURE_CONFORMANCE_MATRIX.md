# Architecture Conformance Matrix

> **Currency:** canonical v4.6.78 Replacement-Core Architecture
>
> **Purpose:** define the boundary conditions that future implementation must satisfy before receiving Control authority.

| Architectural responsibility | Normative requirement | v4.6.71 runtime | v4.6.77 experiment | Required implementation evidence |
|---|---|---|---|---|
| Single authority path | One active Observation → Assessment → Picture → Decision → Commitment → Control route | Not replacement-core implementation | Structurally aligned | dependency and dispatch audit |
| Situation Assessment | Produces Knowledge and fitness, not selected action authority | v4.7.2 candidate | Partial; candidate preference leaked into Assessment | snapshot-to-Knowledge tests |
| Candidate Action Space | Publishes all supportable candidates as explicit records | v4.7.3 publishes complete sealed-fixture inventories | Absent; procedural ladder | complete candidate inventory per decision epoch |
| Mandatory constraints | Every candidate receives explicit `PASS`, `FAIL` or `UNRESOLVED` verdicts | v4.7.3 evaluates all eleven canonical families offline | Local/advisory | negative tests proving failed or unresolved candidates cannot receive authority |
| Decision | Selects only among admissible survivors or explicit non-intervention | v4.7.3 Decision boundary exercised by v4.7.4 replay corpus | Enforced offline | passive-live validation |
| Commitment | Enforcing lifecycle owner with Governing Basis and Obligation Set | Not implemented | Ledger recorded rather than governed | transition-table tests and illegal-transition rejection |
| Safe Release | Required for ordinary success | Documented concept | Violated | no `SUCCEEDED` without Terminal Settlement evidence |
| Intent change | Reassesses Governing Basis; cannot erase obligations | Not implemented | Violated | supersession and source-termination replay cases |
| Obligation Continuity | Every open obligation has exactly one owning Commitment | Not implemented | Violated by renewed Commitment | ownership ledger assertions across every transition |
| Effective Actuation Composition | Validate current and proposed combined effects before actuation | Not implemented | Absent | multi-command and cross-assembly composition tests |
| Progress authority | Exactly one objective-progress actuation owner per assembly | Not implemented | Partial | lease conflict rejection |
| Representation Fitness | Fitness limits which actions may receive authority | v4.7.2 publishes canonical Knowledge states; authority gate not yet implemented | Inconsistent | action-specific fitness verdict tests |
| Control | Executes only authorised capability and returns physical evidence | Legacy controller | Improved but broad | narrow capability contracts and outcome schemas |
| Replay validation | Historical traces prove architecture composition offline | v4.7.4 documented reconstruction suite with deterministic lifecycle reactions and earliest divergence | Implemented for documented evidence; raw trace parser deferred | passive-live gate remains closed until owner canonicalisation |

## Gate interpretation

A row is not considered implemented because a module, field or log message carries the correct name. Conformance requires executable rejection of invalid states and replay evidence that the complete composition respects the contract.
