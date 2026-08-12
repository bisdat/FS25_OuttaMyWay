# v4.7.101 D-0146 Step-2 responsibility-map update

| Responsibility | Owner | v4.7.101 state |
|---|---|---|
| Established Trajectory / Current Excursion | Situation Assessment / `TrajectoryConflictAssessment` | IMPLEMENTED; live supported |
| Potential / Established Opposed Corridor Conflict | Situation Assessment / `TrajectoryConflictAssessment` | IMPLEMENTED; live supported |
| Purpose-specific mechanical passage fitness | Situation Assessment / `PassageCapabilityAssessment` | IMPLEMENTED; P23 Condor/Patriot bounded |
| Local Passage Space / Progressive Passage Search | Candidate responsibility / `LocalPassagePlanner` | IMPLEMENTED ACTIVE TEST |
| Passage Arrangement / Pairwise Passage Economy | Candidate expression, selected through normal Decision | IMPLEMENTED ACTIVE TEST; satisfices |
| Passage Guide | Candidate responsibility | IMPLEMENTED; explicit ordered gates |
| Commitment / movement authority | existing central lifecycle / authority registries | IMPLEMENTED; unchanged authority boundary |
| Execute Passage Guide | `CooperativePassageControl` | IMPLEMENTED ACTIVE TEST; supplied-guide execution only |
| Passage Support Loss / safe reassessment | Control feedback + existing Situation re-entry boundary | IMPLEMENTED safe-abandon/escalate; no silent broadening |
| General vehicle/negative-clearance passage mechanics | Representation layer | NOT CLAIMED |
| Generic Boundary Encroachment search | Candidate/representation | ARCHITECTURALLY VALID; NOT REQUIRED BY CURRENT P23 EXPRESSION |

**Protected abstraction:** Control may reject a supplied gate when current support is lost; it may not discover alternative Local Passage Space.

---

# v4.7.100 D-0146 Step-1 responsibility-map update

| Responsibility | Owner | v4.7.100 state |
|---|---|---|
| Persist Established Trajectory / Current Excursion | Situation Assessment via `TrajectoryConflictAssessment` | IMPLEMENTED PASSIVELY |
| Classify Potential/Established Opposed Corridor Conflict | Situation Assessment via `TrajectoryConflictAssessment` | IMPLEMENTED PASSIVELY |
| Publish trajectory/opposed Knowledge | Operational Picture | IMPLEMENTED |
| Observe transition evidence | PassiveLiveValidator | IMPLEMENTED; diagnostic only |
| Preserve Action Space while conflict matures | Traffic Policeman / D-0141 Regulation | EXISTING LIVE BOUNDED; unchanged |
| Convert new Step-1 Knowledge into Candidate action | Candidate responsibility | NOT WIRED IN THIS BUILD |
| Discover/execute generic passage | existing D-0146 Step-2 owners | NOT IMPLEMENTED GENERICALLY |

No Step-1 module owns route prediction, Candidate selection, Commitment or actuation.

---

# v4.7.99 D-0146 responsibility-map addendum

| Responsibility | Owner | Current implementation state |
|---|---|---|
| Establish persistent observed trajectory / excursions | Situation Assessment / Knowledge | NOT YET IMPLEMENTED GENERICALLY |
| Classify Potential/Established Opposed Corridor Conflict | Situation Assessment | NOT YET IMPLEMENTED GENERICALLY |
| Preserve Action Space while conflict matures | Traffic Policeman / D-0141 Regulation | LIVE BOUNDED |
| Discover sufficient Local Passage Space / Arrangement | Passage assessment under Candidate responsibility | NOT YET IMPLEMENTED GENERICALLY |
| Select among comparable arrangements | Decision / Traffic Policeman using Pairwise Passage Economy | NOT YET IMPLEMENTED GENERICALLY |
| Execute bounded Passage Guide | Control under Commitment/Authority | LIVE ONLY FOR BOUNDED TS015 FIXTURE PATH |
| Detect Passage Support Loss / trigger reassessment | Situation/Control feedback through existing ownership boundaries | NOT YET IMPLEMENTED |
| Player escalation after local passage exhaustion | Decision/Commitment outcome | ARCHITECTURAL, NOT NEWLY IMPLEMENTED |

No diagnostic/probe gains authority merely because D-0146 names these responsibilities.

---

# Responsibility Map — v4.7.98 D-0144 Progressive Situational Sufficiency

> **Architecture authority:** D-0144 over preserved D-0143 Cooperative Passage and D-0141 follower Regulation; older decisions remain historical/supporting where not superseded.  
> **Canonical baseline:** owner-declared v4.7.95.  
> **Current candidate:** v4.7.98; live-successful v4.7.97 behaviour reapplied, then retired diagnostics unsourced.

| Layer | Owns | Must not own |
|---|---|---|
| Reality / GIANTS | native job generation, route/steering, realised motion/configuration | OuttaMyWay traffic policy |
| Observation | raw facts, timestamps, provenance, current native/physical signals | Productive/Transitional interpretation, action selection |
| Situation Assessment | Field World/participation; current Productive or Transitional state; current motion/heading; bootstrap-cached physical/configuration evidence; cooperative relevance; current obligations; optional Turning Rank awareness; bounded Cooperative Passage applicability | route prediction, Successor Rook prediction, chessboard colouring, Candidate selection, actuation |
| Operational Picture | immutable current supported Knowledge and uncertainty | hidden policy or mandatory verdicts |
| Candidate Action Space | complete currently supportable actions, including bounded joint Cooperative Passage `REPOSITION` | selection, fabricated clearance, Control |
| Mandatory Constraints | independent admissibility verdicts from current evidence | optimisation/policy |
| Traffic Policeman / Decision | least-authority temporary ordering; Observe / Regulate / Hold / Reposition choice; strategy succession | route planning, physical execution |
| Commitment / Obligations | governing purpose, durable obligations, Committed Demand, lifecycle/supersession | raw Situation interpretation |
| Bounded Authority | exact currently permitted actuation scope | broader policy |
| Control | Hold; native speed Regulation; compact/restore; selected bounded movement; handoff/outcome reporting | King/Refuge search, Rook/Successor reasoning, Cooperative Passage selection, traffic semantics |

## Retired responsibility claims

No current production layer owns continuous King Reserve, continuous Refuge discovery, chessboard/Productive-History colouring, Successor Rook prediction or a dedicated headland-U-turn solver. Historical diagnostic/control donor files do not regain authority merely because they remain in the repository.

## Retained D-0141 / D-0143 interaction

Follower Regulation may preserve Action Space while native behaviour remains uncertain. If Reality later supports the bounded D-0143 Productive/Productive near-collinear conflict, Cooperative Passage may supersede that follower purpose through the normal Candidate/Decision/Commitment path. Regulation does not itself resolve an established head-on.

## Cooperative Passage health boundary

Production evidence does not yet cover Productive/Transitional opposed encounters, arbitrary asymmetry, other assembly pairs or generic negative-clearance proof. Unsupported cases remain unresolved rather than inheriting authority from TS015.
