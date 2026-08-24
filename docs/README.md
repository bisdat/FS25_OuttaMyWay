# Current project state — v0.1.9.0 CANONICAL CANDIDATE

Owner-declared v0.1.8.0 canonical (`f4aa295d2c7cb1f94cd11d410b4426218bca48706b9b9a2081bf6eba015fac3d`; git `aea77fe388884227e487d96076e9591fe99ce79b`; 317 files) remains authoritative pending explicit owner acceptance. v0.1.9.0 promotes validated D-0183 Closure B without further behavioural change.

Owner field validation of v0.1.8.1 ran TS009 → TS010S → TS015 → TS016, all PASS. The log records six second whistles and six `COOPERATIVE_PASSAGE_SETTLED terminal=SUCCEEDED` outcomes, with zero restoration-fold exhaustion, Transit-fold exhaustion, watchdog, or player-intervention rescue. TS015 also ran through AI job completion and D-0147 Terminal Egress / Infield Retreat passed with continuation renewed.

The active architecture is D-0146-only Cooperative Passage with cached `TRANSIT_BASE`, Job-Start Physical Capability ownership, bounded cached-actuator Transit settlement, and symmetric cached-actuator restoration.

---

# Current project state — v0.1.8.1 TEST — D-0183 Cached-Actuator Restoration Symmetry

Owner-declared **v0.1.8.0 is canonical** (`f4aa295d2c7cb1f94cd11d410b4426218bca48706b9b9a2081bf6eba015fac3d`; Git `aea77fe388884227e487d96076e9591fe99ce79b`; 317 files). Closure B makes D-0146 post-second-whistle restoration consume only the D-0179 cached Transit actuators physically changed by the Passage, with endpoint settlement and bounded exhaustion. Generic fold rediscovery and aggregate `allDeployed`/`allFolded` no longer own D-0146 restoration. Field regression remains required.

---

# Current project state — v0.1.8.0 CANONICAL CANDIDATE

Owner-declared v0.1.7.0 canonical (`ab414f68c29b27a1b350c3e19480dbc69e1b3a1e97824b25db430fd270194a0c`; git `fd3ac332f1a7ba7e501d1e19370b082728bd1fc2`; 317 files) remains canonical pending explicit owner review. v0.1.8.0 promotes the exact live-validated v0.1.7.1 D-0181 behaviour with release/provenance identity only; no further traffic/control behaviour is introduced.

D-0181 closes superseded Passage authority: D-0146 is the single production architecture and fails closed without cached Transit Base geometry; D-0143 TS015 Passage is historical donor/test evidence only. D-0179 Job-Start Physical Capability Record remains unchanged.

Field evidence: TS016, TS015, TS010S and TS009 all passed; six Passage commitments settled successfully with no hidden rescue. TS015 additionally completed the job and successfully exercised D-0147 Terminal Exit.

---

# Current project state — v0.1.7.1 TEST — D-0181 Legacy Authority Closure A

Owner-declared **v0.1.7.0 is canonical** (`ab414f68c29b27a1b350c3e19480dbc69e1b3a1e97824b25db430fd270194a0c`; Git `fd3ac332f1a7ba7e501d1e19370b082728bd1fc2`; 317 files).

v0.1.7.1 closes superseded Cooperative Passage authority: D-0146 now fails closed without cached Transit Base geometry, and D-0143 TS015 Passage is historical donor/test evidence only. Normal D-0179 Transit-first behavior is intended to remain byte-behaviorally equivalent for supported fixtures. Restoration is deliberately deferred to Closure B.

# Current project state — v0.1.7.0 CANONICAL CANDIDATE

Owner-declared v0.1.6.0 remains canonical pending explicit review. v0.1.7.0 promotes the exact live-validated v0.1.6.5 D-0179 behaviour with release/provenance identity only; no further traffic/control behaviour is introduced.

The checkpoint establishes the **Job-Start Physical Capability Record**: cache the actual runtime assembly's DISC/local representation, stable Transit footprint, and semantic active Transit actuator set once per Job Episode; Cooperative Passage consumes that cache and bounds fold settlement without interpreting shop alternatives or aggregate GIANTS fold semantics.

Field evidence: TS016, TS015, TS010S and TS009 all passed in one v0.1.6.5 run; no configuration exhaustion/watchdog/player rescue was required.

---

# Current project state — v0.1.1.0 CANONICAL CANDIDATE

Owner-declared v0.1.0.0 remains canonical pending explicit review. v0.1.1.0 carries the exact tested v0.1.0.14 runtime behaviour and changes release/provenance identity only.

The candidate captures the D-0146 small-field architecture/code alignment plateau: Pair-Specific Passage Clearance, configuration-first passage authority, Resolution-Space role migration and reversible Regulate↔Hold, Pre-Productive Intent Relevance, and ADR-0006 Safe Release conformance. It does **not** claim the final TS010 regulation problem is solved; the empirical 8 km/h cap is the first item for the resumed Literal Provenance investigation.

---

# Current project state — v0.1.0.0 CANONICAL CANDIDATE

Owner-declared v4.7.128 is canonical. v0.1.0.0 changes version identity/provenance only and starts the deliberate pre-1.0 `0.MINOR.PATCH.BUILD` line. Canonical releases use BUILD=0; TEST iterations use BUILD; accepted compatible corrections advance PATCH; significant architecture/capability milestones advance MINOR; first public release is `1.0.0.0`. Runtime behaviour is unchanged from v4.7.128.

---

# Current project state — v4.7.128 CANONICAL CANDIDATE

Owner-declared v4.7.121 remains canonical pending explicit review. v4.7.128 carries the fully live-validated v4.7.127 D-0147 behaviour unchanged and exists solely as the audited canonical candidate. Versioning-policy migration remains deferred.

---

# Current project state — v4.7.127 audit-alignment TEST

Owner-declared v4.7.121 remains canonical. v4.7.126 supplied the first fully completed Patriot + Condor + S416 test using D-0147 Bounded Infield Retreat. v4.7.127 preserves that behaviour and closes the architecture/code audit by introducing the explicit D-0147 Courtesy Constraint Exception and correcting proven ValueRecord traversal defects.

Read `ARCHITECTURE.md`, `ARCHITECTURE_CODE_ALIGNMENT.md`, `PROJECT_STATUS.md`, `ENGINEERING_HANDOVER.md`, `KNOWN_ISSUES.md`, and `ROADMAP.md` for the governing current view. Historical v4.7.121 external-egress implementation-gap sections remain provenance only.

---

# Current architecture / implementation lineage — v4.7.112 canonical candidate

Owner-declared canonical is v4.7.109 (`ea0b399e2f73759fa29982fc1b85d5bf446f6fd90eb324dec2902b333c7c6a74`; Git `cd9085ee40343d542a66b84948c27f7dd91a40c7`; 310 files). v4.7.112 records **D-0147 Bounded Terminal Egress** as architecture only; canonical v4.7.109 traffic/passage runtime behaviour is otherwise unchanged.

D-0147 keeps GIANTS Completion Acceptance as the default. Only a completed, unclaimed assembly whose realised Terminal Occupancy positively obstructs continuing active demand may, when the user-enabled policy allows it, compact and attempt one simple bounded outward manoeuvre toward the locally nearest Field Boundary. Player Claim ends authority immediately; unsupported/exhausted cases belong to the player.

Do not interpret D-0147 as parking, Terminal Clearance Region search, field-centre relocation or King/Refuge revival. Disposable v4.7.110/v4.7.111 probes are evidence only.

Read `ARCHITECTURE.md` D-0147 first, then `DECISION_LOG.md`, `PROJECT_STATUS.md`, `ARCHITECTURE_CODE_ALIGNMENT.md`, `ENGINEERING_JOURNAL.md`, `KNOWN_ISSUES.md` and `ROADMAP.md`.

---

# Current architecture / implementation lineage — v4.7.109 canonical candidate

Owner-declared canonical remains v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files) until explicit owner canonicalisation. v4.7.109 is a release/provenance-only successor to the live-validated v4.7.108 implementation.

The current D-0146 implementation has live evidence for three-worker Operation-aware Cooperative Passage, third-party Local Spatial Constraints/Passage Support, Optional Configuration Reduction, bounded Resolution-Space Conservation and Settled Relationship Dissolution. Five passages settled successfully in the final v4.7.108 validation run.

Parked refinements and the separate final-few-metres single-worker condition remain outside this candidate.

---

# Current architecture / implementation lineage — v4.7.108 final corrective test build

Owner-declared canonical remains v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files). D-0146 remains governing. v4.7.108 makes one release-contract correction after the otherwise successful v4.7.107 three-worker run: **Transitional trajectory acceptance is not Settled Relationship Dissolution**.

An admitted Resolution-Space obligation now survives non-opposed trajectory acceptance while either participant is still TURN_SEGMENT/TURNING. The non-opposed release path requires positive settled non-turn productive continuation from both participants. Actual post-passage ordering remains immediately authoritative. No headland heuristic or route prediction is introduced.

If live validation is clean, stop corrective work and produce a fresh canonical candidate. Optional enhancements remain post-canonical discussion items.

Read `ARCHITECTURE.md` D-0146 first, then `PROJECT_STATUS.md`, `ENGINEERING_JOURNAL.md`, `ARCHITECTURE_CODE_ALIGNMENT.md`, `KNOWN_ISSUES.md` and `ROADMAP.md`.

---

# Current architecture / implementation lineage — v4.7.107 test build

Owner-declared canonical remains v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files). D-0146 remains governing. v4.7.107 corrects v4.7.106 lease lifetime: a Current Excursion may admit Resolution-Space Conservation, but only positive relationship invalidation or Step-2 succession ends that obligation. No headland heuristic is introduced.

Read `ARCHITECTURE.md` D-0146 first, then `PROJECT_STATUS.md`, `ENGINEERING_JOURNAL.md`, `ARCHITECTURE_CODE_ALIGNMENT.md`, `KNOWN_ISSUES.md` and `ROADMAP.md`.

---

# Current architecture / implementation lineage — v4.7.105 test build

Owner-declared canonical is v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files). D-0146 remains governing. v4.7.105 corrects the v4.7.103 implementation drift that made configuration reduction mandatory for both passage participants: configuration demand is now Candidate-owned and optional per participant, while Control changes and restores only what is required. Operation-aware third-party Passage Support and stale follower-purpose succession remain active.

Read `ARCHITECTURE.md` D-0146 first, then `PROJECT_STATUS.md`, `ENGINEERING_JOURNAL.md`, `ARCHITECTURE_CODE_ALIGNMENT.md`, `KNOWN_ISSUES.md` and `ROADMAP.md`.

---

# Current architecture / implementation lineage — v4.7.103 test build

Owner-declared canonical is v4.7.102 (`f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`; Git `cf51498316714c568b75ee6e65dab544ccbe7af3`; 310 files). D-0146 Step 1 and Step 2 architecture remain governing. v4.7.103 is implementation catch-up from the first three-worker live evidence: vehicle-name passage admission is retired, Local Passage Space is Operation-aware, and positive D-0146 relationship succession retires stale D-0141 follower purpose.

Read `ARCHITECTURE.md` D-0146 first, then `PROJECT_STATUS.md`, `ENGINEERING_JOURNAL.md`, `ARCHITECTURE_CODE_ALIGNMENT.md`, `KNOWN_ISSUES.md` and `ROADMAP.md`.

---

# Current architecture / implementation lineage — v4.7.102 canonical candidate

Owner-declared canonical baseline is v4.7.99 (`c3f1f6493fd0e44c8447637827989117daa77a20ba80816cf34270484e5eea8d`; 307 files). D-0146 governs trajectory-based Opposed Corridor Conflict and Local Cooperative Passage. Step 1 and the bounded Condor/Patriot Step-2 implementation are now live-supported: the 2026-08-12 TS015 run completed three D-0146 passages successfully.

v4.7.101 remains test evidence only because its candidate ZIP byte identity disagreed between producer and repository owner. v4.7.102 is the fresh RRS canonical candidate; no Step-2 behavioural algorithm changes were introduced during provenance recovery.

Read `ARCHITECTURE.md` D-0146 first, then `PROJECT_STATUS.md`, `ENGINEERING_HANDOVER.md`, `KNOWN_ISSUES.md` and `ROADMAP.md`. General vehicle/configuration passage authority remains incomplete, and the final-few-metres single-worker blocked-zero-command condition is a separate unresolved issue.

---

# Current architecture / implementation lineage — v4.7.99 canonical candidate

Owner-declared canonical is v4.7.98 (`105462f44b902312e5dc63c6176d44f848f15c1466d942a4bee70635ced6cd69`; Git `982992b926839c854f6d4d7979fe24885e267eae`; 307 files). D-0146 now governs the **architecture** of opposed-corridor recognition and local Cooperative Passage; the **implementation** remains the bounded live-proven v4.7.98 TS015 path.

Read `ARCHITECTURE.md` D-0146 first, then `PROJECT_STATUS.md`, `ENGINEERING_HANDOVER.md` and `KNOWN_ISSUES.md`. The central continuity warning is: **accepted architecture is ahead of implementation; general Cooperative Passage is still incomplete.**

---

# Current architecture / implementation lineage — v4.7.98 canonical candidate

Owner-declared canonical baseline is v4.7.95 (`1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`; Git `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`; 305 files).

v4.7.98 is a consolidation candidate governed by **D-0144 Progressive Situational Sufficiency** over the still-valid D-0143 Cooperative Passage and D-0141 follower-Regulation decisions. The candidate reapplies the live-successful v4.7.97 production implementation over exact canonical v4.7.95, then retires stale governing machinery that the successful TS015 path no longer needs.

**Current status: bounded Cooperative Passage production capability demonstrated; general Cooperative Passage incomplete.** Two near-collinear Condor/Patriot Productive/Productive encounters were automatically resolved through Situation Assessment → Candidate → Constraints → Decision → Commitment → Control in the v4.7.97 live run. D-0141 follower Regulation was also exercised and was cleanly superseded by Cooperative Passage.

D-0144 retains Productive/Transitional state, current motion/heading, current bootstrap-cached physical representation, cooperative relevance, obligations, and Turning Rank as optional spatial Situation Knowledge. It retires Rook/Successor-Rook governing prediction, chessboard colouring and continuous Productive History reasoning. King Reserve, continuous Refuge discovery and headland-U-turn-specific solving remain retired.

The live runtime no longer sources `DemonstratedProductiveCoverageProbe.lua`, `ProductiveCoverageResidualProbe.lua` or `RefugeQualificationShadowProbe.lua`. They remain historical evidence files only. No replacement geometry calculations are introduced.

**Known incompleteness:** Transitional/Productive opposed Cooperative Passage authority is unresolved; asymmetric passage is not generally supported; other vehicle/implement combinations are unvalidated; current movement/gate literals remain TS015 calibration; generic negative-clearance authority and broader regression coverage remain incomplete.

Start with `ARCHITECTURE.md`, `PROJECT_STATUS.md`, `DECISION_LOG.md`, `RESPONSIBILITY_MAP.md`, `ROADMAP.md` and `ENGINEERING_HANDOVER.md` for current authority and continuation.
