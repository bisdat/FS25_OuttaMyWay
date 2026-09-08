# Phase 14.6 — Terminal Egress Execution and Production Vocabulary

## Purpose

Phase 14.6 removes development provenance from the production model and reconciles shared execution vocabulary with current architectural responsibility.

Accepted Repository State baseline for this design is `main` after PR #84 merge:

`57f65c0dccdf39764bca6cfea4bfe082a93852f0`

Canonical authority remains **v0.3.0.0**. Accepted non-canonical playable identity remains:

**`0.3.0.28 TEST — FOLLOWER HUD GLYPH COMPATIBILITY`**

This design increment is documentation-only. It changes no executable mod bytes and consumes no new TEST build identity.

## Governing discoveries

### Trigger Provenance != Terminal Egress Execution

Completed Obstruction and current Causal Obstruction are different reasons for establishing Resolution responsibility. They do not imply different physical Terminal Egress executors.

Trigger-specific meaning belongs upstream in Situation, Candidate, Responsibility Transition, Commitment/Obligation lifecycle and semantic Authority. Once an already-authorised Terminal Egress plan reaches Control, execution should depend on the plan, current physical subject and current Bounded Authority — not on the historical decision that first discovered the trigger.

### Shared Execution Support != Trigger-Specific Mechanism

Protected Yield, configuration handling, fixed-direction bounded movement, Player Claim/source-AI supersession, actuation neutralisation and Vehicle Activity Context are execution support concepts. Their production names and ownership must not remain tied to the trigger that first caused them to be implemented.

### Trigger History != Execution Addressability

Historical Job Episode evidence may establish a Completed Obstruction trigger. It should not remain a prerequisite for physically addressing an already-authorised Terminal Egress subject.

`CurrentPhysicalAssemblySource` observes the current usable GIANTS mission vehicle-root population independently of active Job membership. A currently existing completed assembly is therefore addressable as current physical Reality without Control depending on retained Job-history tracking.

### Prototype Graduation Implies Prototype Retirement

Prototype22 was a transient capability-discovery and manual validation harness. Its Hold, Drive and Configuration mechanisms have graduated to production placement and production consumers.

The prototype is not a durable production responsibility. Repository history and engineering evidence preserve the experiment; production runtime does not need to preserve the experiment itself.

A source audit briefly raised a possible startup dependency because `Prototype22CapabilityGate:loadMap()` installs the shared `NativeDriveMechanism`. That hypothesis was disproved: `CooperativePassageControl:loadMap()` independently installs the same idempotent mechanism. Prototype22 does not uniquely own production hook installation.

### Decision Provenance != Production Vocabulary

D-numbers, TEST labels, Step labels and prototype identifiers may remain as comments or historical provenance where they explain why a current constraint exists. They must not remain the primary names of current production concepts, support boundaries, architecture modes, owner tags, failure reasons, runtime targets or constants merely because those concepts were discovered under a numbered decision or test tranche.

## Current implementation evidence

Current `main` still exposes several development-history seams in production execution:

- `TerminalEgressControl` logs through `[D0147-CONTROL]`, requires `bridge.architecture=="D0147"`, publishes `D0147_*` outcome kinds and emits post-job execution vocabulary.
- `ObstructionRelocationControl` implements another bounded first-courtesy movement path over the same `NonJobActuationMechanism`, `TransitConfigurationMechanism` and Terminal Egress move watchdog.
- `RegulationBoundedAuthority` provides the same zero-speed Protected Yield mechanism to both trigger paths but stores and exposes it as `d0147ProtectedYield...` with owner tag `D0147_PROTECTED_YIELD`.
- `LiveControlDispatcher` distinguishes reposition requests using trigger-history target kinds `D0147_BOUNDED_TERMINAL_EGRESS` and `CAUSAL_OBSTRUCTION_RELOCATION`.
- `LiveTrafficCandidateSupport`, Runtime and related contracts still use production identifiers such as `D0146_COOPERATIVE_PASSAGE_STEP2_TEST`, `D0146_BOUNDED_ACTIVE_TEST`, `D0146_STEP2_ACTIVE_TEST` and similar D-number/TEST vocabulary.
- `Prototype22CapabilityGate`, its `otmP22` console surface, HUD, event-listener registration and `PROTOTYPE_22_*` constants remain present despite mechanism graduation.

These are implementation observations, not separate architectural concepts.

## Target architecture

```text
Completed Obstruction ──────┐
                            │
Causal Obstruction ─────────┤
                            ▼
                  Responsibility / Authority
                            │
                            ▼
                   Terminal Egress Plan
                            │
                            ▼
                   TerminalEgressControl
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
       Configuration   Protected Yield   Non-job Actuation
                            │
                            ▼
                          Reality
```

### Trigger-specific responsibility remains distinct

Completed Obstruction and current Causal Obstruction remain distinct upstream semantic triggers.

Their Candidate admission, governing basis, beneficiary/controlled-subject semantics, Commitment/Obligation lifecycle, continuation evidence, settlement conditions and semantic Authority classes may remain different where Reality requires them to be different.

Phase 14.6 does not erase these distinctions.

### Terminal Egress execution becomes provenance-neutral

One production `TerminalEgressControl` should execute already-authorised Terminal Egress plans.

Control should consume a truthful execution contract containing the current physical subject, execution phase/objective and bounded permission. It should not branch on D-0147 versus D-0218 provenance merely to decide how to perform the same physical movement.

The existing `ObstructionRelocationControl` has no durable independent execution responsibility once its trigger-specific semantics remain upstream. Its physical behaviour should be absorbed into the generic Terminal Egress execution path, then the duplicate Control retired.

### Current physical addressability

Terminal Egress Control should resolve its subject through current physical addressability rather than retained Job-history object lookup.

This does not weaken trigger evidence. Historical completion evidence may still be required upstream for Completed Obstruction responsibility; it simply ends before physical execution.

### Protected Yield

The existing zero-speed beneficiary hold is a Terminal Egress execution support concept.

Names such as `_applyD0147ProtectedYield`, `_releaseD0147ProtectedYield`, `d0147ProtectedYieldLeases` and `D0147_PROTECTED_YIELD` should graduate to provenance-neutral Terminal Egress/Protected Yield vocabulary while preserving the existing lease composition and release behaviour.

### Execution constants

One execution policy owns one execution constant.

`TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M` and `TERMINAL_EGRESS_MOVE_TIMEOUT_MS` are acceptable generic execution-owned names if they continue to describe the actual Terminal Egress policy. Do not clone equivalent constants per trigger merely because different triggers use the same execution.

Equal numeric values do not by themselves prove shared ownership for unrelated policies.

## Prototype22 disposition

Phase 14.6 should retire the Prototype22 runtime surface after an exact dependency scan confirms no remaining unique consumer.

Expected retirement scope:

- `scripts/prototypes/Prototype22CapabilityGate.lua`;
- `main.lua` sourcing, construction and event-listener registration;
- `otmP22` console command and P22 HUD;
- `PROTOTYPE_22_*` configuration values;
- tests/contracts whose sole purpose is protecting the obsolete prototype surface.

Production Hold, Drive and Configuration mechanisms remain. Their current production consumers remain.

## Production vocabulary rule

The Phase 14.6 audit applies this discriminator:

**Historical provenance may name a decision. Current production identity must name a current concept.**

Examples of provenance that may remain:

```text
D-0155 established the exact 1 km/h Intent-Revelation Creep policy.
D-0194/D-0199 explain the origin of the bounded courtesy policy.
```

Examples of production identity that should graduate to semantic names:

```text
D0146_COOPERATIVE_PASSAGE_STEP2_TEST
D0146_BOUNDED_ACTIVE_TEST
D0146_STEP2_ACTIVE_TEST
D0147_PROTECTED_YIELD
D0147_BOUNDED_TERMINAL_EGRESS
CAUSAL_OBSTRUCTION_RELOCATION_TEST
POST_JOB_POSE_UNAVAILABLE
```

The exact replacement identifiers must be chosen from current responsibility ownership rather than by blind textual substitution.

## Engineering sequence

### Phase 14.6A — Terminal Egress Execution Consolidation and Prototype Retirement

This is a behaviour-preserving structural increment.

Target effects:

- one provenance-neutral `TerminalEgressControl`;
- completed-obstruction and Causal-Obstruction trigger semantics remain upstream and distinct;
- `ObstructionRelocationControl` retired after its physical behaviour is absorbed;
- generic Terminal Egress Protected Yield vocabulary;
- current-physical execution addressability;
- provenance-neutral non-job mechanical failure vocabulary;
- Prototype22 runtime surface and constants retired;
- production Hold/Drive/Configuration behaviour unchanged.

Because executable Lua changes, the first pushed coherent implementation revision must consume the next TEST identity after `.28`.

### Phase 14.6B — Production Vocabulary and Constants Scope

After execution consolidation is accepted, reconcile remaining production D-number/TEST/Step/prototype vocabulary across Cooperative Passage, Regulation, Guarded Recovery, Action-Space Regulation and related Runtime/contracts.

This increment should also relocate or rename constants only where current ownership is established. Unresolved mixed constants must not be moved merely for aesthetic consistency.

### Phase 14 closure audit

Do not declare Phase 14 complete merely because 14.6A/14.6B merge.

Perform a final source/architecture audit for:

- surviving prototype/diagnostic production responsibility;
- duplicate execution ownership;
- load-order/runtime patching seams;
- primary production D-number/TEST/Step vocabulary;
- mixed constants with misleading ownership;
- stale implementation-map or continuation guidance;
- validation debt created by the structural changes.

## Behaviour preservation contract for 14.6A

The implementation must preserve:

- GIANTS Job Episode, productive route, steering and normal navigation ownership;
- Completed Obstruction versus current Causal Obstruction trigger semantics;
- beneficiary / controlled-subject separation;
- Bounded Authority and ControlRequest narrowing;
- existing first-courtesy 60 m maximum Interior Settlement policy;
- completed-obstruction second-courtesy Final Boundary Settlement rules;
- current Causal Obstruction first-courtesy-only scope and fresh-Situation reassessment;
- Protected Yield zero-speed beneficiary protection;
- Player Claim and source-AI supersession;
- compaction/configuration behaviour;
- forward-only bounded movement mechanics;
- actuation neutralisation and Vehicle Activity Context release;
- Regulation and Cooperative Passage behaviour;
- no new route planning or negative-clearance authority.

## Validation hypothesis

The primary 14.6A hypothesis is:

**For an already-authorised Terminal Egress plan, physical execution depends on the plan and current physical subject, not on whether Completed Obstruction or Causal Obstruction triggered the responsibility.**

Offline Structural/Lua contracts must verify the responsibility boundary and preservation of existing executable contracts.

GIANTS Reality must then exercise at least:

1. completed-obstruction Terminal Egress, including the accepted courtesy lifecycle;
2. current Causal Obstruction Terminal Egress;
3. Regulation after Prototype22 retirement; and
4. Cooperative Passage after Prototype22 retirement/shared-drive-mechanism consolidation.

A failure in either trigger path disproves the consolidation hypothesis or exposes an unmodelled trigger-specific execution dependency. Such evidence updates the architecture; it must not be hidden behind compatibility special cases.

## Non-goals

Phase 14.6 does not:

- merge Completed Obstruction and Causal Obstruction into one trigger;
- weaken historical evidence requirements where they establish trigger meaning;
- implement player-facing Configuration or choose release defaults;
- implement Issue #45 Bullet Time;
- reopen Cooperative Passage geometry;
- change Regulation magnitude/policy;
- introduce generic route planning;
- create parallel per-trigger copies of Terminal Egress constants;
- remove useful D-number provenance from documentation merely to make the repository number-free.
