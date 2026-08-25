## v0.1.13.0 CANONICAL CANDIDATE checklist — D-0192 / D-0193

- [x] Behavioural source is exact v0.1.12.4 TEST SHA-256 `67d547dc1965d0942ca4e38aea74b3b539b7a4aad3930527151082c80609de4`, 263 files.
- [x] Implementation ancestry remains owner-declared v0.1.12.0 canonical; v0.1.12.1–v0.1.12.3 are non-ancestral evidence only.
- [x] Field regression: TS009 PASS, TS010S PASS, TS015 PASS, TS016 PASS.
- [x] Combined field log records 4 successful Cooperative Passage settlements, 8 Return Staging Ready, 8 Axis Return Start/Complete, 8 participant wave-ons and 4 pair dissolutions.
- [x] No Axis-Return abort/skip/wait-exhaustion and no restoration exhaustion in the supplied four-scenario log.
- [x] D-0193 records the v0.1.12.1–v0.1.12.3 Literal-Provenance attempt and the Coupled Literal Authority / Encounter-Lookahead-vs-Resolution-Space discoveries.
- [x] Candidate preparation changes release identity/documentation/assertions only; no intended traffic/control algorithm delta from v0.1.12.4.
- [x] Exact packaged candidate passes 99/99 structural, 271/271 Lua replacement-core, 25/25 RRS, 107/107 Lua parse, 262/262 manifest, XML and ZIP checks; deterministic repeat-build verified.
- [ ] Owner reviews and explicitly declares the exact candidate fingerprint canonical.
- [ ] Owner records local Git commit/provenance and synchronises repository independently.

## v0.1.12.0 CANONICAL CANDIDATE checklist

- [x] Starts from exact owner-declared v0.1.11.0 canonical fingerprint.
- [x] Promotes validated v0.1.11.2 D-0188 behavior without additional traffic/control changes.
- [x] Field evidence records three successful D-0146 Passages.
- [x] Natural Job Episode completion records `terminalCause=nil`; no runtime `SOURCE_INTENT_TERMINATION` terminal cause remains.
- [x] D-0147 admits the ended episode, completes Terminal Egress and renews continuation.
- [x] Zero termination-conflict diagnostics and zero divide-by-zero errors.
- [ ] Owner canonical declaration pending exact RRS-produced candidate fingerprint.

## v0.1.11.2 TEST — D-0188 Termination Evidence Collapse

- [x] Starts from owner-declared v0.1.11.0 canonical (`944d197b09d2145b49a1502fc0e9721bf2f11a2f5c3ee86d73beaff3a88669d3`; Git `69a19cd116d6dc84286ca623dd5600f52315cae2`; 263 files).
- [x] Removes Job Episode `SOURCE_INTENT_TERMINATION` cause and sticky source-intent observation state.
- [x] Removes unsourced Job Episode subtype authority (`PLAYER_STOP`, active-job `PLAYER_TAKEOVER`, GIANTS abort/fault).
- [x] Retains positive GIANTS source-job end evidence; unresolved inactivity remains fail-closed.
- [x] Retains `RESTARTED` / `REPLACED` succession and fresh Job Episode identity.
- [x] D-0147 Terminal Occupancy no longer depends on source-intent cause; succession-ended episodes remain excluded.
- [x] Player Claim / Terminal Egress policy unchanged.
- [x] Source validation passes 123/123 Python and 264/264 Lua; exact packaged TEST verification target is 263 files / 262 manifest entries / ZIP integrity clean.
- [ ] Established field completion/Terminal Egress regression passes before promotion.

## v0.1.11.0 CANONICAL CANDIDATE checklist

- [x] Starts from exact owner-declared v0.1.10.0 canonical fingerprint.
- [x] Promotes validated v0.1.10.1 D-0186 behavior without additional control changes.
- [x] D-0123 1.0 km/h Native Handover Creep remains unchanged.
- [x] TS015 natural Terminal Egress field evidence records zero divide-by-zero errors.
- [ ] Owner canonical declaration pending exact RRS-produced candidate fingerprint.

## v0.1.10.1 TEST — D-0186 Regulation–Hold Boundary

- [x] Starts from owner-declared v0.1.10.0 canonical (`9a3ace6f2c959e5d2b154ca0b89e4e6384f3093e20b367d227a2379cc0e014fa`; Git `30b7e54f9cbb930a9ccb61d954ec3e2c85c301c2`; 263 files).
- [x] Behavioral change isolated to REGULATE drive-call permission when effective cap is exactly zero.
- [x] `D0123_NATIVE_HANDOVER_CREEP_KMH = 1.0` unchanged and protected as positive Regulation.
- [x] Bench coverage added for positive cap, 1 km/h creep, zero-speed Hold, and native-disallowed preservation.
- [x] Exact packaged TEST artifact passes structural, Lua, manifest and ZIP verification (263 files; 262/262 manifest; 123/123 Python; 267/267 Lua; ZIP integrity PASS).
- [ ] TS015 Terminal Egress PASS with no GIANTS divide-by-zero spam before promotion.

## v0.1.10.0 CANONICAL CANDIDATE — D-0184 promotion

- [x] Exact baseline is owner-declared v0.1.9.0 canonical SHA-256 `3f829d3e7ed322ea6434a9034ae725664d13eea080dc25adb919cd86e84beeb2`, Git `4156e0d86363d524654d53f1e5cc5794484ffb12`, 317 files.
- [x] Behavioural source is the exact field-validated v0.1.9.1 D-0184 Closure C implementation.
- [x] Field validation: TS009 PASS, TS010S PASS, TS015 PASS; TS015 Terminal Egress PASS; Condor Player Claim correctly superseded Terminal Egress.
- [x] Post-Job Regulation Contamination and Termination Evidence Diagnostic Ambiguity are recorded as separate carried findings, not candidate fixes.
- [x] Candidate preparation changes release identity/provenance/documentation only; no intentional traffic/control algorithm delta.
- [ ] Exact RRS candidate/evidence production passes with zero blockers and deterministic byte-identical candidate rebuild.
- [ ] Exact packaged candidate passes structural/Lua/manifest/ZIP validation.
- [ ] Owner reviews and explicitly canonicalises the exact candidate fingerprint.

## v0.1.9.1 TEST — D-0184 Closure C

- [x] Starts from owner-declared v0.1.9.0 canonical fingerprint.
- [x] `scripts/archive/` and dependency-proven retired implementation removed.
- [x] D-0146 retains only cached-actuator restoration; dead generic restore removed.
- [x] D-0123 Native Handover Creep retained at 1.0 km/h under production naming.
- [x] No D-0147/TS010 behavior or Literal Audit magnitude changed.
- [x] Exact packaged TEST artifact passes structural, Lua, manifest and ZIP verification (263 files; 262/262 manifest entries; 98/98 structural; 266/266 Lua; ZIP integrity PASS).
- [ ] Four-scenario field regression passes before canonical promotion.

# v0.1.9.0 CANONICAL CANDIDATE — D-0183 promotion

- [x] v0.1.8.1 field regression: TS009, TS010S, TS015, TS016 all PASS.
- [x] TS015 AI job completion / D-0147 Terminal Egress regression PASS.
- [ ] Exact RRS candidate/evidence production from owner-declared v0.1.8.0 canonical passes with zero blockers and deterministic byte-identical candidate rebuild.
- [ ] Exact packaged candidate passes structural/Lua/manifest/ZIP validation.
- [ ] Owner review and explicit canonicalisation of exact candidate fingerprint.

## v0.1.8.0 canonical-candidate scope gate — D-0181 Legacy Authority Closure A

- [x] Exact source authority is owner-declared v0.1.7.0 canonical (`ab414f68c29b27a1b350c3e19480dbc69e1b3a1e97824b25db430fd270194a0c`; Git `fd3ac332f1a7ba7e501d1e19370b082728bd1fc2`; 317 files).
- [x] Behavioural source is the exact field-validated v0.1.7.1 D-0181 implementation.
- [x] Candidate preparation changes release identity/provenance/documentation only; no traffic/control algorithm is intentionally changed.
- [x] D-0146 is the sole production Cooperative Passage architecture; missing cached `TRANSIT_BASE` fails closed.
- [x] D-0143 runtime authority and configuration-conditioned fallback remain retired.
- [x] Field evidence records TS016, TS015, TS010S and TS009 all PASS; six second whistles and six successful Passage settlements; TS015 Terminal Exit also PASS.
- [x] Restoration remains unchanged and explicitly deferred to Closure B.
- [ ] Exact RRS candidate/evidence production passes with zero blockers and deterministic byte-identical candidate rebuild.
- [ ] Exact candidate ZIP fingerprint reviewed and explicitly accepted by repository owner.
- [ ] Owner records local canonical ZIP/Git provenance after acceptance.

## v0.1.7.0 canonical-candidate scope gate

- [x] Source authority is owner-declared v0.1.6.0 canonical SHA-256 `dd17f654c73a0941617e49365cc58271f5d09d958e64f1faa235d6eca24141af`, Git `76eab8225bf400d5c168d8e57d6f7ad0c1dfe6a1`, 317 files.
- [x] Behavioural source is the exact live-validated v0.1.6.5 D-0179 implementation.
- [x] Candidate preparation changes release identity/provenance/documentation only; no traffic/control algorithm is intentionally changed.
- [x] TS016, TS015, TS010S and TS009 field evidence is recorded, including the distinction between second-whistle completion and terminal settlement.
- [x] Job-Start Physical Capability Record remains selected-runtime only; no shop-option enumeration is reintroduced.
- [x] Transit Fold Settlement Exhaustion remains bounded, non-semantic and independent of successful compaction.
- [ ] Exact candidate ZIP fingerprint reviewed and explicitly accepted by repository owner.
- [ ] Owner records local Git/canonical provenance after acceptance.

## v0.1.2.0 canonical-candidate scope gate — Resolution-Space Conservation architecture

- [x] Exact baseline is owner-declared canonical v0.1.1.0 SHA-256 `10ad10c0eb5956fbd32f3e82408201513dec6073e72b758db4b6bf394e8316b3`; Git `5cd2ae0c768a1a771b817b5ed5879ca02745f9de`; 316 files.
- [x] Candidate changes architecture/documentation and version identity only; no intentional Situation/Decision/Commitment/Control behavioural algorithm delta.
- [x] Fixed 8 km/h Resolution-Space Regulation is explicitly retained in runtime but retired as selected future generic sufficiency authority.
- [x] Supportable Progression, Resolution-Space Progression Envelope, Resolution Contingency Reserve, Reverse-Created Resolution Reserve and Intent-Revelation Opportunity are recorded consistently.
- [x] Exact contingency percentage remains unresolved explicit policy calibration; historical 0.90 is not silently promoted.
- [x] Manoeuvre-duration prediction, measured braking-response modelling, field-area policy and guessed replacement speed are explicitly excluded from the selected direction.
- [x] Resolution-Space Recovery / Back-Out Recovery is recorded as separate Reposition architecture only; no static-blockage/reverse implementation is bundled.
- [x] Passage-in-extenso remains separate; Resolution Space is not predicated on Passage Space.
- [x] Exact packaged candidate passes behavioural, structural/conformance, RRS, Lua/XML parse, manifest and deterministic-byte verification: 254/254 Lua behavioural, 96/96 structural, 25/25 RRS, 105/105 live Lua parse, XML/version and manifest clean, 316 files, deterministic byte-identical rebuild.
- [ ] Owner reviews exact v0.1.2.0 fingerprint and explicitly declares canonical or rejects it.

---

## v0.1.1.0 canonical-candidate scope gate

- [x] Exact runtime lineage is tested v0.1.0.14; candidate preparation introduces no intentional traffic/planning/Control behavioural delta.
- [x] Owner-declared v0.1.0.0 remains authoritative until explicit acceptance of this candidate.
- [x] Pair-Specific Passage Clearance, Configuration-First Passage, Resolution-Space role migration/reversible Hold, Pre-Productive Intent Relevance and ADR-0006 Safe Release corrections are recorded as the captured plateau.
- [x] Final v0.1.0.14 TS010 slow-march collision is explicitly retained as evidence; candidate does not claim full TS010 resolution.
- [x] 8 km/h Resolution-Space Regulation is explicitly OPEN under literal/provenance review and is not promoted to policy.
- [x] Guide Development Non-Convergence and D-0147 `<=60 m` Courtesy Exhaustion remain parked and are not changed in candidate preparation.
- [x] Exact packaged candidate passes behavioural, structural/conformance, RRS, Lua/XML parse, manifest and deterministic-byte verification.
- [ ] Owner reviews exact v0.1.1.0 fingerprint and explicitly declares canonical or rejects it.

---

## v0.1.0.0 pre-1.0 versioning transition gate

- [x] Owner-declared v4.7.128 canonical is the exact authority baseline.
- [x] Version identity resets prospectively to `0.1.0.0`; historical 4.7.x records remain unchanged.
- [x] `0.MINOR.PATCH.BUILD` policy is recorded: canonical BUILD=0; TEST uses BUILD; compatible accepted change advances PATCH; significant capability/architecture milestone advances MINOR; public release is `1.0.0.0`.
- [x] Runtime/gameplay behaviour is frozen from canonical v4.7.128.
- [ ] RRS candidate production passes from exact v4.7.128 canonical fingerprint with zero blockers.
- [ ] Candidate package passes structural/RRS/manifest/version/deterministic-byte verification.
- [ ] Owner reviews exact v0.1.0.0 fingerprint and explicitly declares canonical or rejects it.

---

## v4.7.128 canonical-candidate scope gate

- [x] Exact behavioural lineage is live-validated v4.7.127; no D-0147 behavioural delta is intended.
- [x] Candidate derives from owner-declared v4.7.121 canonical through the declared/tested v4.7.122–v4.7.127 lineage.
- [x] Three-Assembly Courtesy Continuation Validation is recorded and scoped to Patriot + Condor + S416.
- [x] v4.7.127 post-audit live run fully completed, confirming audit alignment did not disturb behaviour.
- [x] Courtesy Constraint Exception remains explicit and narrow; normal Candidate mandatory constraints are not weakened.
- [x] ValueRecord traversal standing-order corrections remain present.
- [x] Candidate changes release/version identity, provenance and review records only.
- [x] Pre-1.0 versioning reset remains explicitly deferred until after canonicalisation.
- [ ] Exact RRS candidate/evidence production from owner-declared v4.7.121 canonical passes with zero blockers.
- [ ] Exact packaged candidate passes structural/RRS/manifest/version/deterministic-byte verification.
- [ ] Owner reviews exact candidate fingerprint and explicitly declares canonical or rejects it.

---

## v4.7.127 audit-alignment / canonicalisation gate

- [x] Exact behavioural source is the successfully tested v4.7.126 lineage; no D-0147 movement/calibration change is intended.
- [x] Three-Assembly Courtesy Continuation Validation recorded with Patriot + Condor + S416 scope only.
- [x] D-0147 Courtesy Constraint Exception explicitly excludes predictive `FIELD_WORLD_CONTAINMENT` and `TRANSITION_CLEARANCE` proof without weakening normal Candidate constraints.
- [x] Consent, positive conflict, Protected Yield, authority composition, Player Claim/source supersession, boundedness, Continuation Renewal, Courtesy Exhaustion and Actuation Neutralisation remain mandatory.
- [x] Proven native `#` operations on sealed ValueRecord collections found by the audit are corrected with explicit accessors.
- [x] Governing overview documentation reflects current Bounded Infield Retreat reality; historical architecture records are retained.
- [x] Legacy names/config are intentionally retained; no plumbing rename bundled into the audit.
- [x] Planned versioning reset is explicitly deferred until after canonicalisation.
- [x] Structural/RRS/package validation clean.
- [ ] Owner review and explicit canonical declaration after candidate preparation.

---

## v4.7.121 canonical-candidate scope gate — D-0147 Terminal Yield

- [x] Exact authority baseline remains owner-declared canonical v4.7.112 (`f4018e7ab468adfb5ef83293aa4e472bf31efb9d937ea6ae72b448f4bdeb780e`; Git `c7867fe9d1baea74cab406a0caf25c2d14d64beb`; 310 files).
- [x] v4.7.120 live-tested external-egress mechanics are carried forward without intentional traffic/control behavioural change.
- [x] Pending Player Reclamation, Terminal Yield Consent, Continuity Not Settlement, Reactive Terminal Yield, No Final Settlement Requirement and Egress Externality Constraint are recorded consistently.
- [x] Conflict-Relative Infield Yield is architecture only; no random/field-centre implementation is introduced.
- [x] Legacy `AUTOMATIC_TERMINAL_EGRESS` remains `true` for development testing by owner request; player-facing automatic Terminal Yield is documented as explicit opt-in/default-off.
- [x] Architecture/code mismatch is explicit: current runtime still implements external egress only.
- [ ] Owner review and explicit canonical declaration.
- [ ] Owner applies candidate to local repository, records canonical ZIP SHA-256/Git provenance and synchronises GitHub independently.

---

## v4.7.112 canonical-candidate scope gate

- [x] Exact baseline is owner-declared canonical v4.7.109 SHA-256 `ea0b399e2f73759fa29982fc1b85d5bf446f6fd90eb324dec2902b333c7c6a74`.
- [x] D-0147 architecture is recorded without Terminal Egress production implementation.
- [x] Historical GIANTS Completion Acceptance remains default; only positively obstructive Terminal Occupancy is eligible for the optional exception.
- [x] Supported compaction precedes translation and may itself settle the obligation.
- [x] Translational objective is boundary-relative, not always vehicle-forward.
- [x] Egress is limited to one simple continuous bounded outward manoeuvre; exhaustion escalates to player instead of search.
- [x] Player Claim is absolute/sticky for the same Terminal Occupancy episode.
- [x] Automatic Terminal Egress is required to be user-configurable; default remains undecided.
- [x] Disposable v4.7.110/v4.7.111 code is excluded from production lineage; only evidence is recorded.
- [x] Optional FieldCourseSettings are non-prerequisite evidence and default-start safety is preserved.
- [ ] RRS Candidate Production from exact v4.7.109 baseline passes with zero blockers.
- [ ] Exact packaged candidate passes behavioural, structural/conformance, RRS, manifest, XML/version and deterministic-byte checks.

---

## v4.7.109 canonical-candidate scope gate

- [x] Exact baseline is owner-declared canonical v4.7.102 SHA-256 `f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`.
- [x] v4.7.103–v4.7.108 implementation increment is carried forward from the tested lineage.
- [x] v4.7.108 live evidence records five successful Cooperative Passages, 25/25 gates, zero Passage Reassessment/escalation and no OuttaMyWay error stack.
- [x] v4.7.109 introduces no intentional traffic/planning/Control behavioural algorithm change from v4.7.108.
- [x] Parked enhancements remain outside candidate scope.
- [ ] RRS candidate/evidence production from exact v4.7.102 baseline passes with zero blockers.
- [ ] Exact packaged candidate passes behavioural, structural/conformance, RRS, manifest, XML/version and deterministic-byte checks.

---

## v4.7.105 test-build scope gate

- [x] Baseline remains owner-declared canonical v4.7.102.
- [x] No D-0146 architecture reopened; optional configuration reduction was already accepted architecture.
- [x] No S 416 or vehicle-name exception introduced.
- [x] Candidate owns per-participant configuration demand; Control only actuates/revalidates it.
- [x] Restoration is selective to configuration actually changed.
- [x] v4.7.103 third-party Passage Support and stale follower-purpose corrections preserved.
- [ ] Live three-worker validation demonstrates mixed configuration passage.

---

## v4.7.103 test-build scope gate

- [ ] Exact baseline is owner-declared canonical v4.7.102 SHA-256 `f85256ddba7cdf4b0be84ef53cc011c0e907237e86dadf137ce2b065a91b597b`.
- [ ] No D-0146 architecture change is introduced.
- [ ] Condor/Patriot name admission is absent from D-0146 Passage Fitness / Local Passage Planner.
- [ ] Other active Operation assemblies constrain Local Passage Space from positive current physical occupancy.
- [ ] Third-party Passage Support is revalidated by Control without Control-side replanning.
- [ ] Positive D-0146 opposed/post-passage relationship evidence retires stale D-0141 follower purpose before Candidate selection.
- [ ] D-0143/TS015 remains only a regression/mechanical donor under active D-0146 Step 2.
- [ ] Lua behavioural, Python structural/conformance, RRS, Lua/XML parse, manifest and exact packaged-ZIP checks pass.

---

## v4.7.102 canonical-candidate scope gate

- [ ] Candidate begins from exact owner-declared canonical v4.7.99 SHA-256 `c3f1f6493fd0e44c8447637827989117daa77a20ba80816cf34270484e5eea8d`.
- [ ] Complete v4.7.100 Step-1 + v4.7.101 Step-2 engineering increment is reproduced from the canonical baseline.
- [ ] No Step-2 planning/assessment/Candidate/Decision/Commitment/Control behavioural algorithm changes are introduced during v4.7.102 provenance recovery.
- [ ] v4.7.101 is explicitly blocked from canonicalisation because producer/owner candidate ZIP hashes disagreed.
- [ ] Current release identity is v4.7.102 and candidate authority is not presented as canonical.
- [ ] Known Python validation count is 79/79, not the previously reported 104/104.
- [ ] Lua behavioural, Python structural/conformance, RRS, Lua parse, manifest, ZIP-integrity and deterministic rebuild checks pass against the exact packaged candidate.

---

## v4.7.99 candidate-scope acceptance gate

- [ ] Exact baseline is owner-declared canonical v4.7.98 SHA-256 `105462f44b902312e5dc63c6176d44f848f15c1466d942a4bee70635ced6cd69`.
- [ ] Candidate changes architecture/documentation/version/provenance only; no intentional traffic/control behavioural delta.
- [ ] D-0146 Step-1/Step-2 architecture is recorded consistently.
- [ ] Health warning states D-0146 generic capabilities are not implemented.
- [ ] Any positive supported corridor overlap is recorded as categorical Step-1 overlap; no percentage/metre admission threshold.
- [ ] Boundary Encroachment permits straddling only; wholly extra-field remains outside Cooperative Passage.
- [ ] Passage Presumption, Pairwise Passage Economy, Passage Sufficiency and Passage Reassessment are recorded without inventing implementation algorithms.
- [ ] Existing Python/Lua behavioural and syntax tests pass unchanged in substance.
- [ ] RRS/manifest/re-extraction validation passes.

---

## v4.7.98 candidate-scope acceptance gate

- [ ] Exact baseline is owner-declared canonical v4.7.95.
- [ ] Successful v4.7.97 Cooperative Passage implementation is reapplied over the canonical baseline, not treated as a new canonical source.
- [ ] Cooperative Passage admission calibration, physical geometry, Control sequence and D-0141 follower Regulation are unchanged from live-successful v4.7.97.
- [ ] `DemonstratedProductiveCoverageProbe.lua`, `ProductiveCoverageResidualProbe.lua` and `RefugeQualificationShadowProbe.lua` remain present but are absent from live `scripts/main.lua`.
- [ ] No new footprint, polygon, sweep or shape calculation is introduced.
- [ ] D-0144 retires Rook/Successor-Rook governing prediction, chessboard/continuous Productive History, King Reserve, continuous Refuge search and headland-U-turn-specific solving.
- [ ] Documentation prominently states Cooperative Passage Scope Boundary / incompleteness.
- [ ] Productive/Transitional opposed support remains unresolved rather than silently broadened.
- [ ] Python/Lua/XML/repository/package validation passes and release manifest is regenerated.

# Release Checklist

## Version Audit

- [ ] Release pipeline completed with PASS results.
- [ ] `modDesc.xml`, `scripts/config.lua` and `docs/PROJECT_STATUS.md` agree.
- [ ] Root and documentation changelogs contain the release entry.
- [ ] SHA-256 release manifest regenerated.
- [ ] ZIP contains `modDesc.xml` directly at its root.
- [ ] Independent Repository Identity Check performed against the packaged ZIP, not only the working tree.

## Empirical Evidence Baseline

- [ ] Every new test record declares FS25 version/build/revision when available.
- [ ] OuttaMyWay version, date, fixture and exact configuration are recorded.
- [ ] Relevant GIANTS update notes and runtime changes were reviewed through Patch Impact Watch.
- [ ] Affected evidence is classified as Current, Version-bound, Revalidation candidate or Invalidated.
- [ ] Targeted Patch Sentinel tests were run when a relevant change reduced confidence.

## Repository Governance

- [ ] Every first-class Markdown document is classified in `docs/README.md`.
- [ ] Canonical filename casing is respected.
- [ ] Current-state version fields match the release.
- [ ] Reference documents do not present stale package versions as their own authority.
- [ ] Compatibility signposts point to both current authority and archived history.
- [ ] Archive documents identify their historical authority and archive release.

## Engineering Continuity

- [ ] Navigation: builder followed the breadcrumb trail without using prior chat context.
- [ ] Prediction: reviewer correctly identified where each class of knowledge should reside.
- [ ] Overall Assessment: repository exposes omissions and supports correct continuation.
- [ ] Project purpose, architecture, current state and next objective are recoverable.
- [ ] Disproved hypotheses and significant decisions are discoverable.
- [ ] A competent engineer can validate and create the next canonical release.
- [ ] Independent reviewer breadcrumb findings will be recorded in the next release.

## Code / candidate-scope gate — v4.7.95

- [ ] Candidate begins from exact owner-declared canonical v4.7.77.
- [ ] Runtime behaviour is unchanged apart from release/version/provenance identity.
- [ ] No P23 prototype module is sourced or copied into the candidate implementation.
- [ ] No King/King-Reserve/continuous Refuge implementation is added or promoted.
- [ ] `modDesc.xml`, `scripts/config.lua`, `scripts/main.lua` and version assertions identify v4.7.95.
- [ ] Documentation records D-0143, P23 evidence closure, asymmetric scope boundary and TS015 production objective.
- [ ] Structural/conformance tests pass.
- [ ] Lua/XML/package validation passes.
- [ ] Release manifest is regenerated from candidate bytes.

**Next behavioural release gate after canonicalisation:** the first production implementation must route supported TS015 Cooperative Passage through Situation Assessment → Candidate → Constraints → Decision → Commitment → Bounded Authority → Control without a P23 arming command or parallel prototype controller. Unsupported asymmetric geometry remains outside that tranche.

## Compatibility

- [ ] Base-game vehicles and implements.
- [ ] Self-propelled wide sprayer.
- [ ] Tractor with small mounted implement.
- [ ] Tractor with towed implement.
- [ ] At least three maps.
- [ ] Partly worked field.
- [ ] Fresh field.

## Multiplayer

- [ ] Host/admin multiplayer smoke test.
- [ ] No network-event errors.
- [ ] Second client test when available; otherwise declare limited verification.

## Localisation

- [ ] English.
- [ ] German.
- [ ] French.
- [ ] Spanish.
- [ ] Italian.

## ModHub package

- [ ] `modDesc.xml` version changed to `1.0.0.0`.
- [ ] Correct current `descVersion` for target game release.
- [ ] ZIP root contains `modDesc.xml` directly.
- [ ] No source archives, logs or private notes included.
- [ ] Icon and screenshots final.
- [ ] Description and controls accurate.
- [ ] Repository remains private until official release.
