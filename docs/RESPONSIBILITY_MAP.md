## v0.1.9.0 CANONICAL CANDIDATE — D-0183 responsibility checkpoint

| Concern | Owner | Candidate responsibility |
|---|---|---|
| Transit actuator discovery | D-0179 Representation bootstrap | Selected-runtime cached actuator set |
| Outbound Transit | D-0146 Configuration Authority | Command cached actuators only |
| Pre-Transit endpoint capture | D-0146 Configuration Authority | Capture endpoint for successfully commanded cached actuators |
| Restoration selection | D-0183 Configuration Authority | Restore only cached actuators that physically moved |
| Restoration readiness | D-0146 Control | Requested return endpoint or bounded exhaustion |
| Generic fold rediscovery / aggregate fold state | Historical/prototype evidence | No D-0146 restoration authority |
| Canonical authority | Repository owner | Candidate remains non-canonical until exact fingerprint acceptance |

## v0.1.8.1 TEST — D-0183 restoration authority

| Concern | Current owner | Closure-B responsibility |
|---|---|---|
| Outbound Transit actuator selection | D-0179 Representation bootstrap | Unchanged cached selected-runtime actuators |
| Pre-Transit fold endpoint | Configuration Authority state | Captured only for successfully commanded cached actuators |
| Restoration actuator selection | D-0146 Configuration Authority | Only cached actuators that physically moved from the captured endpoint |
| Restoration readiness | D-0146 Control + cached actuator endpoint evidence | Requested return endpoint or bounded exhaustion |
| Generic `spec_foldable` discovery | Historical/prototype machinery | No D-0146 restoration authority |
| Aggregate `allDeployed` / `allFolded` | Diagnostic/legacy evidence | No D-0146 restoration authority |
| Work/lowered state restoration | D-0146 Configuration Authority | Restore the state captured when Transit authority was acquired |
| Agronomic restoration / orientation | Future work | Explicitly out of Closure B |

## v0.1.8.0 CANONICAL CANDIDATE — D-0181 responsibility checkpoint

| Concern | Owner | Candidate responsibility |
|---|---|---|
| Production Cooperative Passage | D-0146 | Sole live Passage architecture |
| Transit geometry sufficiency | Representation + LocalPassagePlanner | Valid cached `TRANSIT_BASE` required; otherwise no Candidate |
| Historical D-0143 | Repository history/tests | Mechanical/evidence donor only; no runtime authority |
| Transit capability | D-0179 Representation bootstrap | Cached selected-runtime Physical Capability Record, unchanged |
| Passage request/settlement | Cooperative Passage Control | D-0179 cached-actuator behavior unchanged |
| Restoration | Existing inherited restoration path | Explicitly deferred to Closure B |
| Canonical authority | Repository owner | v0.1.8.0 remains non-canonical until exact fingerprint acceptance |

## v0.1.7.1 TEST — D-0181 authority closure

| Concern | Current owner | Closure-A responsibility |
|---|---|---|
| Cooperative Passage representation prerequisite | `AssemblyRepresentationCache` + `LocalPassagePlanner` | Cached `TRANSIT_BASE` required; absence fails closed |
| Cooperative Passage Candidate | D-0146 `LocalPassagePlanner` / `LiveTrafficCandidateSupport` | Single production Candidate architecture |
| Cooperative Passage execution | `CooperativePassageControl` | D-0146 / `TRANSIT_REQUIRED` only |
| D-0143 TS015 Passage | Historical donor/test evidence | No production load, assessment, Candidate, switch or Control authority |
| Missing Transit evidence | Candidate boundary | No fallback architecture; no Passage Candidate |
| Post-passage restoration | inherited configuration authority | **Unchanged in Closure A**; Bootstrap–Restoration Bypass remains Closure B |
| D-0143 literal family | retired with runtime owner | Do not tune obsolete values |
| D-0146 Hold/heartbeat literals | D-0146 Control | Existing 0.25 km/h / 1000 ms values retained pending Literal Audit |

## v0.1.7.0 CANONICAL CANDIDATE — D-0179 responsibility checkpoint

| Concern | Owner | Candidate responsibility |
|---|---|---|
| Physical Assembly discovery | Representation bootstrap | Discover actual Job-Episode members once; shop alternatives excluded |
| DISC/local conservative representation | Representation bootstrap | Cache expensive/static member facts; preserve conservative safety role |
| Transit Passage footprint | Representation bootstrap | Freeze one stable complete-assembly `TRANSIT_BASE` planning abstraction |
| Semantic Transit fold capability | Representation bootstrap | Cache `isFoldable`, selected-runtime active actuators and expected duration |
| Transit request/settlement | Cooperative Passage Control + mechanical donor | Command only cached actuators; wait to requested endpoints or bounded exhaustion |
| Passage safety | Existing Passage/physical evidence | Remains independently authoritative; exhaustion never asserts compaction |
| Candidate authority | Repository owner | v0.1.7.0 remains non-canonical until exact fingerprint acceptance |

## v0.1.6.5 TEST — D-0179 responsibility alignment

| Concern | Owner | v0.1.6.5 responsibility |
|---|---|---|
| Physical Assembly discovery | `AssemblyRepresentationCache` | Job-Episode bootstrap only; revalidation may detect membership drift but does not rebuild capability |
| DISC/local geometry | `AssemblyRepresentationCache` | Cache conservative member geometry once; current transforms remain observation work |
| Transit footprint | `AssemblyRepresentationCache` | Build once from member `base.size` union at first Job-Episode observation; reuse unchanged |
| `isFoldable` / Transit actuators | `AssemblyRepresentationCache` | Cache selected-runtime `spec_foldable.foldingParts` only; require AI-reachable active configuration |
| Transit request | `CooperativePassageControl` + configuration authority | Command only cached actuators; no live capability discovery |
| Fold settlement | Configuration authority | Specific commanded actuator requested endpoint; bounded duration |
| Settlement exhaustion | `CooperativePassageControl` | Remove configuration veto; do not assert compaction |
| Physical Passage safety | existing Representation/constraints | Remains independent of configuration success |

## v0.1.6.4 TEST — D-0178 responsibility alignment

| Concern | Owner | v0.1.6.4 responsibility |
|---|---|---|
| Transit Passage geometry | Representation / Candidate | Cached `TRANSIT_BASE`; planning only, not settlement authority |
| Transit request | Control / configuration authority | Always attempt; command result is non-authoritative |
| Native fold actuation motion | Configuration authority | Observe assembly `foldMoveDirection`; report active motion only |
| Transit settlement | Cooperative Passage Control | Hold while native fold motion is active; release when motion settles |
| Semantic fold endpoint | No `TRANSIT_BASE` Control owner | `allFolded`, `allDeployed`, profiles and geometry similarity do not authorise settlement |
| Legacy fallback/restoration | Existing legacy paths | Unchanged in this tranche |

## v0.1.6.3 TEST — D-0177 responsibility alignment

| Concern | Owner | v0.1.6.3 responsibility |
|---|---|---|
| Transit Passage geometry | Representation / Candidate | Cached `TRANSIT_BASE` envelope remains the selected Passage geometry |
| Transit request | Control / configuration authority | Always attempt Transit; success/failure does not authorise movement |
| Current physical configuration | Representation | Describe current directional occupancy; mechanical fold state may inform representation applicability |
| Transit realisation | Control consuming Representation | Compare current directional occupancy with cached Transit envelope using D-0176 5% similarity |
| GIANTS `allFolded` / `allDeployed` / `transitionCount` | Diagnostics / representation evidence | No `TRANSIT_BASE` Passage readiness authority in Control |
| Passage clearance | Candidate / Constraint | Unchanged; D-0176 tolerance grants no crossing clearance |
| Legacy geometry fallback | Existing legacy path | Unchanged in this tranche |

## v0.1.6.2 TEST — D-0176 responsibility alignment

| Concern | Owner | v0.1.6.2 responsibility |
|---|---|---|
| Transit Passage geometry | Representation / Candidate | Supply and freeze `TRANSIT_BASE` directional envelope at Passage Selection |
| Transit request | Control / configuration authority | Always attempt Transit for `TRANSIT_REQUIRED` participants |
| Successful fold completion | Control | Hold until GIANTS fold evidence reports `allFolded=true` |
| Ignored/inert request realisation | Control + current Representation evidence | Compare current left/right/forward/rear extents to cached Transit extents with 5% similarity tolerance |
| Passage clearance | Candidate / Constraint | Unchanged; D-0176 tolerance grants no additional crossing clearance |

## v0.1.6.1 TEST — D-0175 authority alignment

| Concern | Owner | v0.1.6.1 responsibility |
|---|---|---|
| Passage Transit geometry | `LocalPassagePlanner` | Uses `transitPassageEnvelope`; does not consult legacy compact-profile selection when Transit Base is available. |
| Transit request | `CooperativePassageControl` + existing Configuration Authority | Best-effort request at the existing configuration point. |
| Transit realisation | `CooperativePassageControl` | Successful request waits for `allFolded`; ignored request requires current directional occupancy within planned Transit envelope. |
| Legacy configuration-conditioned fallback | `LocalPassagePlanner` / `CooperativePassageControl` | Retained only when Transit Base geometry is unavailable; not authoritative for `TRANSIT_BASE`. |

## v0.1.1.0 candidate responsibility boundary

| Question | Owner | Current rule |
|---|---|---|
| Who is relevant before productive commencement? | Situation / membership knowledge | active same-Field-World field-work entrant may be Situation-relevant without Cooperative Operation membership |
| Who may be spatially Passaged/configured? | D-0146 Candidate / Passage authority | cooperative Operation members only, with legitimate configuration authority |
| Who is regulated/held? | Situation chooses roles; Control executes purpose-bound lease | pair-relative current evidence, with role migration and reversible Hold |
| When may the Resolution-Space obligation release? | Situation / ADR-0006 Safe Release | no positive dissolution while blockage or relevant Future-Space intersection contradicts release |
| How fast should Regulation permit progression? | **OPEN architecture/literal review** | inherited 8 km/h empirical cap remains implementation calibration, not generic policy |

---

## v0.1.0.14 responsibility clarification — Regulation Sufficiency is pair-state evidence

| Question | Owner | Rule |
|---|---|---|
| Has the bounded Regulation physically taken effect? | Control execution observation | actual regulated participant is within the admitted cap and GIANTS drive output reflects that cap |
| Is material positive pair closure still continuing? | Situation Assessment | current resolved pair-closing evidence; independent of Transitional/Settled continuation class |
| Has Regulation proved insufficient? | D-0146 Control consuming Situation + execution evidence | yes when Regulation is realised and positive closure continues under the same live Resolution-Space obligation |
| May Hold replace Regulation? | Same purpose-bound D-0146 Control authority | yes; tighten the regulated participant's existing lease to 0 km/h |
| When may Hold relax? | Situation Assessment + Control | only positive resolved non-closing evidence; obligation remains live until its own Safe Release/succession |

**Protected abstraction:** Transitional/Settled classification describes continuation knowledge. It does not own generic Regulation Sufficiency.

## v0.1.0.13 responsibility clarification — Safe Release evidence ownership

- **Observation** continues to publish GIANTS blockage and Field-Bounded Future-Space evidence without Decision/Control authority.
- **Situation Assessment** owns whether that evidence contradicts a proposed D-0146 positive relationship dissolution.
- **Commitment/Control** consume only the resulting `positiveDissolution` semantics; they do not independently interpret `blocked`, trajectories, or Future Space.
- **Future-Space positive intersection** is positive coupling evidence only; it is not negative-clearance authority.

## v0.1.0.12 responsibility clarification — membership vs intent relevance

| Question | Owner | Rule |
|---|---|---|
| Has productive work commenced in this Job Episode? | Observation | positive native productive witness, latched per Job Episode |
| Is the worker a cooperative Operation member? | Operation Admission | yes only after productive commencement |
| Can an unrevealed active job affect a current Operation? | Situation Assessment | yes when same Field World + active GIANTS field-work job + productive commencement pending |
| Who may be constrained? | D-0146 Situation / Candidate / Control | constrain the known Operation member; preserve pending worker's GIANTS-native intent revelation |
| Can pending worker fold/sidestep/reposition? | Cooperative Passage admission | no |
| Does later productive commencement create a new pair? | Situation identity | no; relationship identity is preserved and eligibility reclassifies |

# v0.1.0.11 participation / Resolution-Space role responsibility update

| Responsibility | Owner | v0.1.0.11 TEST state |
|---|---|---|
| Observe current GIANTS productive-line witness | `NativeFieldWorkObservation` / Live Observation | raw evidence only |
| Remember whether productive work has commenced in this Job Episode | `LiveObservationSource` Job-token-scoped latch | new; reset on replacement/reactivation |
| Admit cooperative Operation membership | Live Observation → `OperationAdmission` | requires latched productive commencement; current turns do not revoke membership |
| Assess current D-0146 regulated/protected roles | Situation / `TrajectoryConflictAssessment` | unchanged authority; roles may evolve as geometry/continuation changes |
| Persist Resolution-Space purpose | Commitment/Obligation lifecycle | same Commitment remains owner |
| Migrate current Regulation/Hold expression | `LiveControlDispatcher` + lifecycle supporting authority | new; apply new role then release old role under same Commitment |
| Regulate↔Hold sufficiency/de-escalation | `LiveControlDispatcher` | v0.1.0.9/.10 behaviour retained |
| Cooperative Passage participant Holds | `CooperativePassageControl` | unchanged |
| D-0147 Protected Yield | D-0147 control path | unchanged |

**Protected abstraction:** participation commencement and current Control role are evidence/state questions; neither becomes a TS010 equipment exception.

# v0.1.0.10 D-0146 reversible Hold responsibility update

| Responsibility | Owner | v0.1.0.10 TEST state |
|---|---|---|
| Determine positive current closing/non-closing | `TrajectoryConflictAssessment` Situation Knowledge | publishes distinct positive witnesses; unresolved is neither |
| Retain/dissolve Resolution-Space obligation | Situation + Commitment lifecycle | unchanged |
| Regulate→Hold on proven insufficiency | `LiveControlDispatcher` | existing v0.1.0.9 behaviour |
| Hold→Regulation on positive non-closing | `LiveControlDispatcher` consuming Situation witness | new reversible expression; Commitment retained |
| Re-escalate if closure returns | `LiveControlDispatcher` | allowed under same purpose/authority |
| Cooperative Passage Holds | `CooperativePassageControl` | unchanged |
| D-0147 Protected Yield Holds | D-0147 dispatcher/control | unchanged |

# v0.1.0.9 D-0146 Regulation Sufficiency responsibility update

| Responsibility | Owner | v0.1.0.9 TEST state |
|---|---|---|
| Positive pair closing / Transitional status | `TrajectoryConflictAssessment` Situation Knowledge | Existing authority; unchanged |
| Initial participant role and 8 km/h cap request | D-0146 Situation/Candidate path | Existing authority; 8 km/h remains calibration |
| Proof that the admitted cap has physically taken effect | `Prototype22CapabilityGate` raw Control observation | Adds actual speed + reference-scoped observation; no traffic semantics |
| Regulate→Hold expression under already-admitted purpose | `LiveControlDispatcher` | Tightens same lease to 0 km/h only from positive Situation + Control-effect evidence |
| Spatial resolution | `LocalPassagePlanner` / Cooperative Passage | Unchanged; Passage supersedes conservation lease |
| Hold release | Existing positive relationship dissolution or Passage succession | Unchanged |

# v0.1.0.8 D-0146 reverse-conflict responsibility update

| Responsibility | Owner | v0.1.0.8 TEST state |
|---|---|---|
| Observe GIANTS native drive command and chassis heading | Live Observation | existing evidence retained |
| Determine whether native movement consumes pair separation | Situation / `TrajectoryConflictAssessment` | pair-axis forward/reverse projection |
| Assign Established-conflict regulated/protected roles | Situation | greater positive closure contributor when continuation classes are equal |
| Preserve Transitional revelation | Situation | existing Settled-vs-Transitional preference retained |
| Decide whether Passage already supersedes Regulation | Candidate | unchanged |
| Apply speed ceiling while preserving direction/steering/route | Control / P22 Regulation lease | unchanged; reverse already supported |
| Escalate Regulation to Hold if insufficient | not changed in this tranche | pending runtime evidence |

**Protected abstraction:** Situation assesses pair-relative contribution; Control does not infer conflict roles and does not choose forward/reverse direction.

# v0.1.0.7 D-0146 passage-support responsibility update

| Responsibility | Owner | v0.1.0.7 TEST state |
|---|---|---|
| Observe GIANTS `isBlocked` | Live Observation | RETAINED |
| Prove/deny physical Cooperative Passage support | Candidate/representation + Control revalidation | PRESERVED; native blocked alone excluded |
| Fail active D-0146 guide | CooperativePassageControl on actual support/actuation/watchdog failure | CORRECTED |
| Failure configuration | CooperativePassageControl | HOLD CURRENT; no automatic D-0146 restore |

# v0.1.0.6 D-0146 configuration-first responsibility update

| Responsibility | Owner | v0.1.0.6 TEST state |
|---|---|---|
| Observe/cache configuration profiles and provenance | AssemblyRepresentationCache | Stable profile geometry cached assembly-relative; native vs OuttaMyWay observations distinguished |
| Decide whether a compact profile is passage-relevant | LocalPassagePlanner / Candidate | Requires native stable folded profile + positive conflict-side release |
| Compute selected-profile Pair-Specific Passage Clearance | PairSpecificPassageClearance + LocalPassagePlanner | Per passage side; provisional 1 m policy margin retained |
| Authorise exact configuration change | Candidate | `COMPACT_REQUIRED` only with expected compact profile ID |
| Execute fold/restore mechanics | CooperativePassageControl | Existing mechanical donor; no independent configuration choice |
| Verify realised compact profile | AssemblyRepresentationCache + Control | Guide motion waits for expected profile match |
| React to positive blockage during guide | CooperativePassageControl | Fail held; do not brute-force traversal |

---

# v0.1.0.5 D-0146 Resolution-Space Conservation responsibility update

| Responsibility | Owner | v0.1.0.5 TEST state |
|---|---|---|
| Establish Potential / Established Opposed Corridor Conflict | Situation / `TrajectoryConflictAssessment` | unchanged classification authority |
| Determine whether active relationship needs Resolution-Space Regulation | Situation / `TrajectoryConflictAssessment` | broadened to Established conflict inside locality envelope |
| Assign temporary regulated/protected roles | Situation | preserve Transitional peer when known; otherwise defer greater native closure contribution |
| Determine whether a supported Passage already exists | Candidate / `LocalPassagePlanner` | Passage remains preferred; no Regulation Candidate consumed when plan is supported |
| Decide passage feasibility below 50 m | Candidate concrete guide support | 50 m pre-gate removed |
| Select Regulation vs Passage | Candidate / Decision | same pair-scoped governing requirement |
| Own Regulation obligation/authority | Commitment / Authority | existing D-0146 lifecycle reused |
| Apply/release speed lease and hand off to Passage | `LiveControlDispatcher` | existing lease mechanics generalised to protected participant terminology |
| Choose route/geometry | Candidate / Passage planner only | Control still does not choose |

**Protected abstraction:** Situation supplies semantic support and temporary roles; Candidate owns whether a physical passage expression is supportable; Control executes only sealed selected authority.

---

# v0.1.0.4 D-0146 Pair-Specific Passage Clearance responsibility update

| Responsibility | Owner | v0.1.0.4 TEST state |
|---|---|---|
| Establish opposed conflict and shared lateral frame | Situation Assessment / `TrajectoryConflictAssessment` | unchanged |
| Supply current physical primitives / configuration identity | Representation / `AssemblyRepresentationCache` | unchanged bounded evidence |
| Derive side-specific Facing Clearance Extents and contact thresholds | Representation adapter / `PairSpecificPassageClearance` | NEW TEST IMPLEMENTATION |
| Apply Nominal Inter-Assembly Clearance | Candidate policy / `LocalPassagePlanner` | 1.0 m TEST calibration |
| Select passage side and lateral burden | Candidate / `LocalPassagePlanner` | side-specific target; existing burden fractions retained |
| Decide configuration expression | Candidate | `RETAIN_CURRENT` for both participants in this tranche |
| Validate sampled pair/third-party guide support | Candidate | translated represented-DISC test support; no generic negative authority |
| Execute supplied guide / reject unsupported runtime state | `CooperativePassageControl` | unchanged ownership; V4 bridge and per-participant third-party reserve metadata |
| Prove generic Coverage Closure | Representation architecture | not claimed by this TEST |

**Protected abstraction:** Control still does not choose passage geometry. Mechanical foldability still does not imply OuttaMyWay passage-configuration authority.

---

# v4.7.128 candidate responsibility status

No responsibility change from live-validated v4.7.127. Existing D-0147 ownership below is carried unchanged into canonical review.

---

# v4.7.127 D-0147 current responsibility map

| Responsibility | Owner | Current state |
|---|---|---|
| Observe completed worker / Player Claim / source reactivation | Observation | established |
| Establish positive Terminal Occupancy and Continuation Renewal | Situation Assessment | implemented / live-supported |
| Apply Terminal Yield Consent and choose one crude Bounded Infield Retreat | Candidate | implemented |
| Mark generic predictive containment/transition constraints non-applicable for this special case | Candidate contract | explicit D-0147 Courtesy Constraint Exception |
| Preserve normal mandatory constraints outside the special case | Constraint architecture | unchanged |
| Own POST_JOB authority for terminal assembly and PROGRESS/HOLD authority for authorising productive assembly | Commitment / Authority | implemented |
| Hold authorising productive worker during translation | Protected Yield / Control Dispatcher | implemented / live-supported |
| Execute fixed one-shot Infield Alignment and 60 m native-max retreat | Terminal Control / Post-Job Actuation Authority | implemented / live-supported |
| Neutralise before release | Control / Authority | mandatory / live-supported |
| Re-arm only after useful continuation, then later attributed block | Situation / Commitment lifecycle | implemented / live-supported |
| Stop trying near centre | Courtesy Exhaustion → Player Escalation | implemented |
| Final cleanup / any unsupported configuration | Player | governing final housekeeping authority |

**Protected abstraction:** D-0147 owns no parking optimisation, route planner, future-demand exclusion map, third-party sweep guarantee, or permanent settlement claim.

---

# v4.7.121 D-0147 Terminal Yield responsibility update

| Responsibility | Owner | Candidate state |
|---|---|---|
| Observe completed passive assembly / Player Claim | Observation | existing substrate / live-supported |
| Establish positive current Terminal Occupancy conflict | Situation Assessment | existing D-0147 substrate |
| Determine whether automatic yield is permitted | Candidate + Terminal Yield Consent | legacy config gate only; broader policy accepted |
| Select supported External vs Conflict-Relative Infield Yield | Candidate Action Space | external only implemented; infield not implemented |
| Enforce Egress Externality Constraint / other-assembly constraints | Candidate mandatory constraints | not implemented |
| Choose among materially equivalent supported alternatives | Decision; deterministic identity tie-break only if needed | not implemented |
| Own current admitted yield purpose | Commitment | existing Terminal Resolution machinery; semantics require refinement to current-conflict continuity |
| Execute selected bounded movement | Control + Post-Job Actuation Authority | external v4.7.120 live-supported |
| Determine when current productive continuation is restored | Situation/Observation feeding settlement | architecture accepted; current implementation still uses field exit |
| Return completed vehicle to passive Pending Player Reclamation | Commitment/Control settlement | concept accepted; repeated-cycle implementation absent |
| Player cleanup / irreducible conflict | Player | governing final housekeeping authority |

**Protected abstraction:** neither Candidate nor Control owns permanent parking, global completed-worker placement, random wandering or another-field occupation.

---

# v4.7.105 D-0146 Optional Configuration Reduction responsibility update

| Responsibility | Owner | v4.7.105 test state |
|---|---|---|
| Decide whether each participant requires configuration reduction for the selected passage expression | Candidate / `LocalPassagePlanner` | `COMPACT_REQUIRED` or `RETAIN_CURRENT` from current positive represented envelope |
| Carry the selected per-participant configuration demand | Candidate → Decision → Commitment bridge | Explicit `passageConfiguration` |
| Revalidate and actuate required configuration change | Central `CooperativePassageControl` + ConfigurationAuthority | Only `COMPACT_REQUIRED` participants are commanded/waited upon |
| Restore configuration | Central Control + ConfigurationAuthority | Only configuration actually changed by the Commitment is restored |
| Decide Local Passage Space including other active assemblies | Candidate / `LocalPassagePlanner` | Operation-aware; unchanged from v4.7.103 |
| Retire stale follower purpose under stronger opposed/passed relationship evidence | Situation/Candidate relationship succession | Active; unchanged from v4.7.103 |

---

# v4.7.103 D-0146 Operation-aware responsibility update

| Responsibility | Owner | v4.7.103 test state |
|---|---|---|
| Established Trajectory / opposed relationship | Situation Assessment / `TrajectoryConflictAssessment` | unchanged; live supported |
| Purpose-specific passage mechanical preflight | Situation Assessment / `PassageCapabilityAssessment` | vehicle-name independent; current representation/configuration evidence only |
| Actual Hold/compact/Reposition capability | Control mechanical donors | revalidated from current vehicle Reality; may disprove Passage Presumption |
| Local Passage Space / Progressive Passage Search | Candidate / `LocalPassagePlanner` | pairwise search constrained by every other active Operation assembly's positive current occupancy |
| Third-party assembly role | Local Spatial Constraint | not a hidden Commitment participant; not controlled by pair passage |
| Passage Guide | Candidate | records selected third-party support as part of candidate evidence |
| Dynamic third-party Passage Support | Control | reject/reassess if positive current occupancy conflicts with pair current positions, gate target or active guide leg |
| D-0141 purpose succession | Situation / `FollowerBoundaryDemandAssessment` | positive D-0146 opposed/post-passage evidence retires stale follower purpose before Candidate selection |
| Replacement passage geometry after support loss | Candidate after reassessment | Control explicitly forbidden to invent it |
| D-0143/TS015 mechanics | historical regression/mechanical donor | no competing semantic decision authority while D-0146 Step 2 is enabled |

**Protected abstraction:** pairwise passage does not imply pair-isolated Reality. Other Operation assemblies constrain support without being silently recruited into the pair Commitment.

---

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
