FS25_OuttaMyWay v0.1.12.0 CANONICAL CANDIDATE — D-0188 TERMINATION EVIDENCE COLLAPSE

Authoritative baseline until owner declaration: v0.1.11.0
SHA-256: 944d197b09d2145b49a1502fc0e9721bf2f11a2f5c3ee86d73beaff3a88669d3
Git: 69a19cd116d6dc84286ca623dd5600f52315cae2
Files: 263

Candidate behaviour is the exact live-validated v0.1.11.2 D-0188 state; promotion introduces no further traffic/control algorithm. Positive GIANTS source-job end evidence now ends the Job Episode directly. Natural completion has no `SOURCE_INTENT_TERMINATION` terminal cause; succession remains represented only by `RESTARTED` / `REPLACED`. D-0147 Terminal Occupancy no longer depends on the retired cause string, while Player Claim remains post-completion Terminal Resolution.

TS015 field validation recorded three successful Cooperative Passages, `JOB_EPISODE_ENDED ... terminalCause=nil`, successful D-0147 Terminal Egress and Continuation Renewal, with zero termination-conflict diagnostics and zero divide-by-zero errors.

This package is a canonical candidate only until the owner explicitly declares its exact RRS-produced fingerprint canonical.

---

FS25_OuttaMyWay v0.1.11.0 CANONICAL CANDIDATE — D-0186 REGULATION–HOLD BOUNDARY

Authoritative baseline until owner declaration: v0.1.10.0
SHA-256: 9a3ace6f2c959e5d2b154ca0b89e4e6384f3093e20b367d227a2379cc0e014fa
Git: 30b7e54f9cbb930a9ccb61d954ec3e2c85c301c2
Files: 263

Candidate behaviour is the exact live-validated v0.1.10.1 D-0186 state; promotion introduces no further traffic/control algorithm. Zero-speed Regulation is expressed to GIANTS as Hold (`isAllowedToDrive=false`, `maxSpeed=0`), while positive Regulation—including the deliberate 1.0 km/h native-handover creep—preserves native drive permission.

TS015 field validation ran through natural D-0147 Terminal Egress with successful retreat/continuation and zero GIANTS divide-by-zero errors. The earlier Post-Job Regulation Contamination interpretation is withdrawn. Termination Evidence Diagnostic Ambiguity remains the next cleanup finding.

This package is a canonical candidate only until the owner explicitly declares its exact RRS-produced fingerprint canonical.

---

FS25_OuttaMyWay v0.1.10.0 CANONICAL CANDIDATE — D-0184 LEGACY AUTHORITY CLOSURE C

Authoritative baseline until owner declaration: v0.1.9.0
SHA-256: 3f829d3e7ed322ea6434a9034ae725664d13eea080dc25adb919cd86e84beeb2
Git: 4156e0d86363d524654d53f1e5cc5794484ffb12
Files: 317

Candidate behaviour is the exact live-validated v0.1.9.1 Closure C state; promotion introduces no further traffic/control algorithm. The live tree is reduced to 263 files after dependency-proven archaeology removal.

Owner field validation of v0.1.9.1 ran TS009, TS010S and TS015: all PASS. TS015 was allowed to continue through AI job completion / D-0147 Terminal Egress and passed; when the owner tabbed into Condor during Terminal Egress, runtime recorded `PLAYER_CLAIM` and settled Terminal Egress as `SUPERSEDED_BY_NEW_INTENT`. The combined supplied log contains six D-0146 second whistles and six `COOPERATIVE_PASSAGE_SETTLED terminal=SUCCEEDED` outcomes across those sessions, including an additional successful TS015 Passage after reload.

Known findings carried forward without repair: Post-Job Regulation Contamination during D-0147 direct retreat; Termination Evidence Diagnostic Ambiguity after legitimate Player Claim. `D0123_NATIVE_HANDOVER_CREEP_KMH = 1.0` remains deliberate and is not implicated in the divide-by-zero evidence.

This package is a canonical candidate only until the owner explicitly declares its exact RRS-produced fingerprint canonical.

---

FS25_OuttaMyWay v0.1.9.1 TEST — D-0184 LEGACY AUTHORITY CLOSURE C

Authoritative baseline: v0.1.9.0 canonical
SHA-256: 3f829d3e7ed322ea6434a9034ae725664d13eea080dc25adb919cd86e84beeb2
Git: 4156e0d86363d524654d53f1e5cc5794484ffb12
Files: 317

Closure C removes 54 dependency-proven repository paths (50-file `scripts/archive/` tree plus four retired runtime/test-fixture modules), narrows the P22 capability donor to current mechanisms, and removes stale D-0143 provenance. The 1.0 km/h native handover creep remains deliberately live under `D0123_NATIVE_HANDOVER_CREEP_KMH`. No traffic behavior change is intended. Field regression required.

---

FS25_OuttaMyWay v0.1.9.0 CANONICAL CANDIDATE — D-0183 CACHED-ACTUATOR RESTORATION SYMMETRY

Authoritative baseline until owner declaration: v0.1.8.0
SHA-256: f4aa295d2c7cb1f94cd11d410b4426218bca48706b9b9a2081bf6eba015fac3d
Git: aea77fe388884227e487d96076e9591fe99ce79b
Files: 317

Candidate behaviour is the exact live-validated v0.1.8.1 Closure B state; promotion introduces no further traffic/control algorithm. Outbound Transit and restoration consume the same cached selected-runtime actuator set, and restoration addresses only actuators physically changed by Passage.

Owner field validation of v0.1.8.1 ran TS009 → TS010S → TS015 → TS016, all PASS. The log records six second whistles and six `COOPERATIVE_PASSAGE_SETTLED terminal=SUCCEEDED` outcomes, with zero restoration-fold exhaustion, Transit-fold exhaustion, watchdog, or player-intervention rescue. TS015 also ran through AI job completion and D-0147 Terminal Egress / Infield Retreat passed with continuation renewed.

This package is a canonical candidate only until the owner explicitly declares its exact RRS-produced fingerprint canonical.

---

FS25_OuttaMyWay v0.1.8.0 CANONICAL CANDIDATE — D-0181 LEGACY AUTHORITY CLOSURE A

Authoritative baseline until owner declaration: v0.1.7.0
SHA-256: ab414f68c29b27a1b350c3e19480dbc69e1b3a1e97824b25db430fd270194a0c
Git: fd3ac332f1a7ba7e501d1e19370b082728bd1fc2
Files: 317

Candidate behaviour is the exact live-validated v0.1.7.1 Closure A state; promotion introduces no further traffic/control algorithm. D-0146 is the only production Cooperative Passage architecture and fails closed without cached TRANSIT_BASE. D-0143 is historical donor/test evidence only.

Field regression in order TS016 → TS015 → TS010S → TS009: all PASS. The combined log records six second whistles and six successful Cooperative Passage settlements with no fold-settlement exhaustion or watchdog/player rescue. TS015 also ran through job completion and successfully regression-tested D-0147 Terminal Exit / Bounded Infield Retreat.

Restoration remains unchanged and is explicitly reserved for Closure B. This package is a canonical candidate only until the owner explicitly declares its exact RRS-produced fingerprint canonical.

---

FS25_OuttaMyWay v0.1.7.1 TEST — D-0181 LEGACY AUTHORITY CLOSURE A

Authoritative baseline: owner-declared v0.1.7.0 canonical
SHA-256: ab414f68c29b27a1b350c3e19480dbc69e1b3a1e97824b25db430fd270194a0c
Git: fd3ac332f1a7ba7e501d1e19370b082728bd1fc2
Files: 317

Closure A makes D-0146 the only production Cooperative Passage architecture. Missing cached TRANSIT_BASE evidence fails closed with no Cooperative Passage Candidate; no configuration-conditioned fallback exists. Historical D-0143 TS015 Passage is no longer production-loaded, assessed, candidate-published, switchable or executable. D-0179 Transit behavior and restoration are otherwise unchanged; restoration symmetry is reserved for Closure B.

Field regression: TS016, TS015, TS010S, TS009.

---

FS25_OuttaMyWay v0.1.7.0 CANONICAL CANDIDATE — D-0179 JOB-START PHYSICAL CAPABILITY RECORD

Authoritative baseline until owner declaration: v0.1.6.0
SHA-256: dd17f654c73a0941617e49365cc58271f5d09d958e64f1faa235d6eca24141af
Git: 76eab8225bf400d5c168d8e57d6f7ad0c1dfe6a1
Files: 317

Candidate behaviour is the exact live-validated v0.1.6.5 state; promotion introduces no further traffic/control algorithm. Job-Episode bootstrap caches DISC/local representation, one stable TRANSIT_BASE footprint, and active-runtime Transit fold capability for the actually instantiated selected configuration only. Passage consumes that cache, commands only cached actuators, and uses bounded endpoint settlement. Shop alternatives and aggregate fold-state semantics have no Transit Passage authority.

Field regression in order TS016 → TS015 → TS010S → TS009: all four PASS. No Transit fold settlement exhaustion, configuration watchdog, or player-intervention rescue occurred. TS016 and TS009 reached terminal SUCCEEDED; TS015/TS010S reached second whistle before the user reloaded during restoration.

This package is a canonical candidate only until the owner explicitly declares its exact fingerprint canonical.

---

FS25_OuttaMyWay v0.1.6.5 TEST — D-0179 JOB-START PHYSICAL CAPABILITY RECORD

Baseline: owner-declared v0.1.6.0 canonical; incremental test line through v0.1.6.4.

Field evidence entering this build:
- v0.1.6.4 TS009 PASS, TS010S PASS, TS015 PASS
- v0.1.6.4 TS016 FAIL: K105 retained fold intent without visible fold progress
- D-0178 foldMoveDirection settlement is withdrawn

Purpose:
- cache DISC/local geometry, stable Transit Base footprint, and active-runtime `isFoldable`/Transit actuators once per Job Episode;
- never enumerate unselected shop folding configurations for Passage capability;
- freeze Transit Base union at first Job-Episode observation;
- command only cached active Transit actuators;
- wait for each commanded actuator's requested fold endpoint;
- bound that wait from cached active animation duration, capped at 35 s with 30 s fallback;
- on settlement exhaustion, remove configuration veto without asserting compaction;
- preserve existing physical Passage safety as the backstop.

Primary field order: TS016, TS009, TS015, TS010S.

FS25_OuttaMyWay v0.1.6.0 CANONICAL CANDIDATE — NATIVE BASE TRANSIT GEOMETRY CHECKPOINT

Authoritative baseline until owner declaration: v0.1.5.0
SHA-256: 4ac4438a0ab89dc903d5f4d0fde799a141b666d6d49ccbb916aba98411f5148f
Files: 317

Candidate traffic behaviour is v0.1.5.3 unchanged. Cooperative Passage prefers a directional Transit envelope assembled from each discovered Physical Assembly member's GIANTS `vehicle.base.size` width/length/offsets and runtime transform. DISC/current physical representation remains separate conservative occupancy/sweep evidence.

Field evidence: TS010S PASS; TS015 PASS; TS016 PASS; TS009 FAIL with small physical contact before Passage resumed. TS009 used TRANSIT_BASE but the MF 7S.210 assembly logged only two discovered members, `coverageComplete=false` and `underApproximationRisk=true` despite the physical tractor + front mower + rear mower combination.

Primary carry-forward discovery: TRANSIT GEOMETRY COMPLETENESS REQUIRES PHYSICAL ASSEMBLY COMPLETENESS. Complete base-size metadata for all discovered members is not sufficient if assembly discovery itself is incomplete. Investigate TS009 membership first; do not add Entry margin or change Passage timing yet.

Separate inherited observation: optional mower Transit was ignored because the configuration probe required a fully deployed start. Do not combine that configuration-authority debt with assembly membership in the next experiment.

Withdrawn/non-ancestry: v0.1.5.1/v0.1.5.2 Native Deployment Pair shadows; v0.1.4.1-v0.1.4.3 post-compaction replanning; v0.1.4.5 exhaustive Candidate backfill.

This package is a canonical candidate only until the owner explicitly declares its exact fingerprint canonical.

---

FS25_OuttaMyWay v0.1.5.3 TEST — NATIVE BASE TRANSIT PASSAGE GEOMETRY

Owner-declared canonical baseline: v0.1.5.0 SHA-256 4ac4438a0ab89dc903d5f4d0fde799a141b666d6d49ccbb916aba98411f5148f, 317 files.

Cooperative Passage now prefers a complete directional Transit envelope assembled from each member's GIANTS `vehicle.base.size` width/length/offsets and current assembly transforms. This geometry is used only for Transit Passage planning; current DISC/physical evidence remains conservative occupancy support. Missing member base-size evidence falls back to the canonical configuration-conditioned planner. Existing configuration selection remains temporarily only to preserve validated Control semantics.

FS25_OuttaMyWay v0.1.5.0 CANONICAL CANDIDATE — MINIMAL TRANSIT PASSAGE CHECKPOINT

Authoritative baseline: owner-declared canonical v0.1.4.0
SHA-256: 681573c2edd6256b092ab00d5955af72bbc5f231903ef81b3fc6d625929f437e
Git: 77695913f0af72960194f8f9ad13397d59e2dadb
Files: 317

Candidate behaviour is the validated v0.1.4.8 state with no new traffic algorithm: preserve v0.1.4.0 Passage timing/guide execution; always attempt Transit at the existing configuration point; keep Candidate-required compaction strict; make inert RETAIN_CURRENT Transit non-blocking; keep 1.00 m nominal Crossing-Window construction with a 0.95 m policy floor and hard represented non-contact.

Field regression: TS009 PASS (start-position caveat), controlled TS010S PASS, random-start TS010 PASS, TS015 PASS, TS016 PASS (start-position caveat).

Next focused question after canonicalisation: Zero-Development Entry Compression — straight/zero-deficit Passage may begin visually close because zero lateral Development provides no incidental longitudinal approach reserve.

Withdrawn: v0.1.4.1-v0.1.4.3 post-compaction replanning; v0.1.4.5 exhaustive Candidate backfill.

Still open: complex-assembly coverage authority, inherited invalid allowUnfoldingByAI XML-path probing, agronomic restoration/Restoration Alignment, 8 km/h guide speed and other parked literals.

This package is a canonical candidate only until the owner explicitly declares its exact fingerprint canonical.

---

FS25_OuttaMyWay v0.1.4.8 TEST — OPPORTUNISTIC TRANSIT NON-VETO

Behaviour remains v0.1.4.7 except for one Control correction exposed by TS016: Candidate-required COMPACT_REQUIRED participants still have to positively complete compaction, but a successful RETAIN_CURRENT Transit request is non-authoritative. Passage waits while Reality shows that optional configuration is physically transitioning; an accepted but inert optional request cannot hold the Passage in CONFIGURING.

Primary regression: TS016 first, then TS010S/TS015/TS009.

---

FS25_OuttaMyWay v0.1.4.7 TEST — NOMINAL PASSAGE CLEARANCE POLICY BAND

Behaviour remains v0.1.4.4 plus v0.1.4.6 telemetry. Passage construction still targets 1.00 m nominal Crossing-Window clearance; validation now accepts an initial 0.95 m policy floor while represented non-contact remains hard. No timing, sampling or guide-geometry change.

Primary field comparison: controlled TS010S active-worker save, then TS015.

---

FS25_OuttaMyWay v0.1.4.6 TEST — PASSAGE CLEARANCE TELEMETRY

Behaviour is v0.1.4.4 unchanged. This TEST adds diagnostic `D0146_PASSAGE_CLEARANCE_TRACE` output only, using values already computed by ordinary Passage Candidate assessment. It performs no extra planner or sweep calls.

Primary comparison: controlled TS010S active-worker save, then TS015.

---

FS25_OuttaMyWay v0.1.4.4 TEST — MINIMAL TRANSIT COMPACTION RESET

Baseline: exact owner-declared canonical v0.1.4.0. This TEST preserves v0.1.4.0 Passage geometry/timing and changes only the configuration policy: every Passage participant is asked to compact at the existing configuration point. Unsupported opportunistic compaction for a RETAIN_CURRENT guide is ignored; Candidate-required compaction remains fail-safe.

The v0.1.4.1-v0.1.4.3 replanning branch is intentionally not carried forward.

---

FS25_OuttaMyWay v0.1.4.0 CANONICAL CANDIDATE — COOPERATIVE PASSAGE CHECKPOINT

Authoritative baseline: owner-declared canonical v0.1.3.0
SHA-256: 818507fc054484c2fe1a92bd4f6147cc849516f892642c0169f9055788d41de9
Git: 6e39cb443dd2cb313beac3ddf367f6521317947a
Files: 317

Purpose of this candidate:
- consolidate the cumulative v0.1.3.1-v0.1.3.7 Cooperative Passage development line into a reviewable checkpoint;
- introduce no further traffic-behaviour algorithm after v0.1.3.7;
- preserve successful Passage discoveries while explicitly retaining the unresolved TS009 safety failure as a known issue;
- establish a clean authority boundary before continuing in a new engineering chat.

Field-supported progress carried forward:
- Resolution-Space -> Passage authority handoff is immediate again; delayed physical Passage Entry lives inside Passage Approach;
- Execution-Origin Capture prevents short guide targets becoming stale after settling/configuration;
- Hold-Witness Deadlock is corrected: active Passage Hold + physical settlement is sufficient, regardless of causal GIANTS/OMW veto provenance;
- Nominal ~1 m Passage Clearance is a Crossing-Window contract; Development/Recovery require non-contact, not the full nominal margin;
- GIANTS directional width/length evidence substantially improves Condor/Patriot clearance planning versus isotropic component spheres;
- directional multi-member geometry produced successful TS016 and TS010 passages, including generic unilateral displacement and materially reduced agronomic debt.

Known unresolved safety issue:
- TS009 front/rear SaMASZ mower combination versus S416 was authorised as a straight RETAIN_CURRENT Passage with claimed +0.87 m reserve, then physically collided/tangled. This candidate does NOT claim that current multi-member negative-clearance authority is safe for arbitrary complex assemblies.
- the same TS009 observation reported assemblyMembers=2 for a physical tractor + front mower + rear mower combination; the meaning/cause of that membership result is unresolved and must be investigated before widening Passage further.

Selected next architecture (NOT implemented here):
- Transit-First, Reality-Verified Passage.
- Passage attempts a plausible Transit preparation where available unless positive configuration knowledge excludes it; missing allowUnfoldingByAI metadata is not a prohibition.
- the actual achieved configuration, not an assumed XML/API capability, owns subsequent Passage geometry.
- failure to achieve Transit does not justify hypothetical compact geometry; replan conservatively from verified Reality.
- defer fold-vs-don't-fold optimisation/productive-Passage sophistication until the fail-safe Transit-first path is sound.

Still parked:
- exact finishing orientation / Restoration Alignment;
- straight-reverse agronomic restoration and how much debt to recover;
- 8 km/h Passage guide speed;
- deeper candidate burden/configuration economy;
- offset-plough challenge until complex-assembly membership/coverage is understood;
- TS010 <=60 m terminal/locality literal and other previously parked literal work.
