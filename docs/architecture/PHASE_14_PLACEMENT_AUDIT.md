# Phase 14 Production Placement Audit

## Purpose

Phase 14 owns a bounded architecture-to-runtime reconciliation:

> **Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming.**

This is not a general refactor or cleanup licence. The audit asks whether current source placement and vocabulary truthfully describe already-accepted production responsibilities. It does not redesign traffic policy, Passage geometry, D-0147/D-0218 mechanics, Candidate/Constraint/Decision ownership, or GIANTS job ownership.

Accepted baseline for this audit is `main` after PR #71 merge, commit `bc30156b70a9490425c1052ccaf4b80bd20e23ad`. Canonical authority remains **v0.3.0.0**. Last accepted playable identity remains **`0.3.0.20 TEST — CANDIDATE SUPPORT PROJECTION`**.

## Audit method

For each suspect production surface:

1. identify the behaviour and its current caller;
2. identify the architectural responsibility actually being exercised;
3. determine whether the current name/location claims the same responsibility;
4. distinguish a pure naming/placement mismatch from a mixed-responsibility module;
5. separate behaviour-preserving graduation from any future behavioural change;
6. preserve proven physical mechanics unless Reality contradicts them.

A Probe, Diagnostic, Shadow or Prototype name is not cosmetic. Under the Naming Conventions those nouns explicitly deny production semantic or Control authority. If production depends on such a component, its responsibility has conceptually graduated and the implementation must eventually say so.

## Findings

### Production Observation != Diagnostic Output

`LiveInteractionDiagnostics.lua` is sourced before live Observation and is called directly by `LiveObservationSource`.

Its `deriveMotion()` output enters `raw.motion.progressionEvidence`. Its pair observation contributes positive Current Space interaction evidence, Encounter admission and live closure evidence. The module therefore participates in production Observation even though its current name and directory claim diagnostic-only responsibility.

Disposition: preserve the current calculations; graduate the module to Observation scope under production vocabulary; do not tune thresholds or interaction semantics while doing so.

### Production Capability != Prototype Harness

`Prototype22CapabilityGate` contains a genuine manual experimental harness (`otmP22`, P22 HUD, manual Regulation/Hold/release monitoring) and an accepted live production `REGULATE_SPEED` executor. The Prototype22 enable flag gates the manual harness but does not gate live `executeControlRequest()`.

Cooperative Passage also receives the Prototype22 object as a donor and directly consumes its permission, drive and configuration mechanisms.

Therefore a simple rename would conceal mixed responsibilities. Production Control capability must be separated from the manual Prototype22 harness while preserving the proven physical mechanisms.

### Prototype22 component mechanisms have individually graduated

- `Prototype22PermissionGate` supplies the proven temporary wait/Hold mechanism used by current Passage Control as well as the manual P22 probe.
- `Prototype22DriveAuthority` realises current Regulation leases and Passage movement/Axis Return, while retaining older P22 reposition residue that requires a consumer audit before removal.
- `Prototype22ConfigurationAuthority` supplies current Passage Transit/restoration and is also used by warm D-0147 and cold D-0218 Control.

These mechanisms now require production Control vocabulary. Their physical behaviour is not challenged by this audit.

### Non-Job Actuation != Post-Job Provenance

`PostJobActuationAuthority` supplies the same validated low-level non-job movement/activity/neutralisation mechanics to warm D-0147 and cold D-0218. D-0218 explicitly requires no completed-Job provenance.

Disposition: preserve mechanics; later rename/re-home around actual non-job physical actuation responsibility; keep D-0147 and D-0218 semantic responsibilities separate.

### Strangler Integration != Permanent Runtime Placement

`ObstructionRelocationRuntimeIntegration.lua` and `ProspectiveDecisionPortfolioIntegration.lua` install accepted production responsibilities by wrapping base Runtime/Observation functions after those base modules load.

These seams were useful strangler mechanisms and their behaviour is accepted. They are nevertheless permanent-placement debt because load order now carries architectural meaning.

Disposition: reconcile them into explicit Runtime/Observation composition only after production component names/scopes stabilise, as a separate behaviour-preserving restructure.

### Explicit Compatibility may remain Compatibility

`GuardedRecoveryCompatibility` is active code, but accepted architecture still treats Guarded Recovery as an explicit retained compatibility path. Its `Compatibility` name is therefore not automatically stale. Its `P22_REGULATION_LEASE` production vocabulary should be migrated when Regulation Control graduates.

### True diagnostics remain diagnostics

Active instrumentation is not a deletion target merely because it runs every cycle. For example, `TargetedFieldIdentityProbe` captures/logs field/job state, while `LiveRuntimeCoordinator` does not consume its result for Observation, Situation, Decision or Control. It remains a truthful Probe.

### Development Consent Gate != Responsibility Scope

`AUTOMATIC_TERMINAL_EGRESS` is a mixed development-consent switch and is temporarily reused by D-0218 despite generic cold Causal Obstruction not depending on completed-Job provenance.

Configuration architecture already classifies `scripts/config.lua` as a Mixed Runtime Constants Surface. Record this as scoped debt; do not invent a player setting or release default while doing Phase-14 placement work.

### Production Identifier != Validation Provenance

Production surfaces still contain validation-origin identifiers including `P22_REGULATION_LEASE`, `CAUSAL_OBSTRUCTION_RELOCATION_TEST` and `D0146_COOPERATIVE_PASSAGE_STEP2_TEST`. D-number provenance may remain, but Prototype/Test vocabulary should not be the primary durable production concept.

Identifier migration should follow ownership graduation and remain separate from behavioural work.

## Classification summary

| Surface | Current reality | Phase-14 classification |
| --- | --- | --- |
| `LiveInteractionDiagnostics` | production Observation dependency | GRADUATE / rename-rehome |
| `Prototype22CapabilityGate` | mixed manual harness + production Regulation Control/donor container | SPLIT RESPONSIBILITIES |
| `Prototype22PermissionGate` | production wait/Hold mechanism + P22 use | GRADUATE after boundary split |
| `Prototype22DriveAuthority` | production Regulation/Passage drive mechanism + historical residue | GRADUATE; audit old modes separately |
| `Prototype22ConfigurationAuthority` | production Passage/D-0147/D-0218 configuration mechanism + P22 provenance | GRADUATE |
| `PostJobActuationAuthority` | shared non-job movement donor for warm and cold Control | RENAME/REHOME around actual mechanical scope |
| `GuardedRecoveryCompatibility` | intentionally retained compatibility path | RETAIN classification; clean dependent production vocabulary later |
| `TargetedFieldIdentityProbe` | diagnostic logging only | PRESERVE as Probe |
| D-0218 / Portfolio integration files | accepted strangler integration implementing production responsibility | LATER RUNTIME PLACEMENT RECONCILIATION |
| `AUTOMATIC_TERMINAL_EGRESS` cross-use | development gate with mixed semantic scope | DEFER bounded configuration/runtime-scope design |

## Proposed Phase-14 sequence

### 14.1 — Production Regulation Control boundary

First isolate the live `REGULATE_SPEED` executor, execution observation and lease cleanup from `Prototype22CapabilityGate`.

The increment should create a production Regulation Control boundary consuming already-authorised `ControlRequest` values; preserve the existing drive lease mechanism and exact Regulation behaviour; wire `LiveControlDispatcher`, Regulation observation and Guarded Recovery compatibility through it; and leave the manual P22 harness plus Passage movement/configuration unchanged.

This is a behaviour-preserving responsibility separation.

### 14.2 — Physical capability mechanism graduation

Graduate the permission, drive and configuration mechanisms to truthful production Control vocabulary, while retaining the manual P22 harness as an explicit Prototype/Probe dependent on production mechanics. Audit old P22-only reposition modes before retaining or retiring them.

### 14.3 — Production Observation graduation

Move `LiveInteractionDiagnostics` to truthful Observation vocabulary/placement without changing calculations or evidence meaning. This may be implemented earlier if source review proves complete independence, but it remains a distinct tranche.

### 14.4 — Non-job movement donor naming/placement

Reconcile `PostJobActuationAuthority` with its actual shared non-job mechanical scope while preserving D-0147/D-0218 semantic separation and exact physical mechanics.

### 14.5 — Runtime integration consolidation

After production components have stable scopes, fold accepted D-0218 and Prospective Portfolio integration into explicit Runtime/Observation composition and remove load-order monkey-patching where no longer needed.

### 14.6 — Production vocabulary and constants-scope cleanup

Finally audit P22/TEST support-boundary identifiers, obsolete prototype/test comments/logs, module-local constants in `config.lua`, development-consent scoping, and unsourced historical source. Do not tune values or add player Configuration merely while relocating ownership.

## Behaviour preservation contract

Unless a separate architecture decision explicitly says otherwise, Phase-14 graduation must preserve:

- GIANTS Job Episode and productive-route ownership;
- Candidate/Constraint/Decision/Responsibility boundaries;
- Traffic Policeman precedence and Regulation magnitudes;
- Cooperative Passage geometry, Transit-First behaviour, participant obligations and Last-Leg Dissolution;
- D-0147 warm courtesy semantics/mechanics;
- D-0218 cold Causal Obstruction semantics/first-courtesy mechanics;
- Player Claim and source-AI supersession;
- Bounded Authority / ControlRequest validation;
- the supported three-active-worker Operation envelope.

A failed preservation test is evidence against the tranche, not a reason to redefine expected behaviour after the fact.

## Immediate next decision

Review this audit and sequence. If accepted, design **14.1 — Production Regulation Control boundary** precisely before source movement or TEST build changes.