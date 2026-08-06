# Architecture Conformance Matrix

| Concern | ADR-0021 requirement | v4.7.13 candidate state | Status |
|---|---|---|---|
| Snapshot evidence | immutable per Job Episode | retained unchanged | conforming |
| Exact representation | provenance, not independent identity authority | canonical polygon and fingerprint retained | conforming |
| Field World authority | coherent positive spatial equivalence | architecture recorded; runtime not implemented | implementation gap |
| Authority outcomes | same, different or unresolved | architecture recorded; diagnostics currently non-authoritative | implementation gap |
| Coherence | evaluate accepted Field World evidence as a whole | no authoritative class-wide resolver | implementation gap |
| Operation grouping | consume resolved Field World identity | still exact-fingerprint keyed | known provisional non-conformance |
| Unresolved evidence | no Operation or Control authority | Control disabled; Operation admission path requires redesign | partially conforming |
| Mid-episode mutation | unsupported; Snapshot fixed | retained immutable | conforming |
| Control | disabled until identity authority is validated | enforced | conforming |

## Preserved validation fixtures

| Fixture | Required result | Preserved evidence |
|---|---|---|
| merged 68–69–70 | `SAME_FIELD_WORLD` | four distinct exact fingerprints; identical bounds/topology; near-identical spatial measures |
| disconnected split 77 | `DIFFERENT_FIELD_WORLD` | materially different geometry and separation; zero sampled overlap |
| ambiguous or contradictory geometry | `UNRESOLVED` | no authority; dedicated implementation fixture still required |

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