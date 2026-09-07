# Phase 14.2 — Physical Capability Graduation

## Purpose

Phase 14.1 established **Production Capability != Prototype Harness**.

Phase 14.2 graduates the proven physical mechanisms themselves from Prototype
placement without redesigning their behaviour.

Additional discoveries:

- **Mechanical Capability != Prototype Experiment Surface**
- **Prototype Container != Production Composition Root**
- **Shared Mechanism != Prototype Lifecycle Ownership**
- **Prototype Residue != Unused Capability**

Baseline: accepted `main` after PR #73,
`38699140270cee29836c22124b4199a5087031c7`.

Canonical authority remains **v0.3.0.0**. Last accepted playable identity at
design time is **`0.3.0.21 TEST — REGULATION CONTROL BOUNDARY`**.

## Current Reality

Three proven physical mechanisms still live under Prototype22 names:

- `Prototype22PermissionGate`
- `Prototype22DriveAuthority`
- `Prototype22ConfigurationAuthority`

Production uses them for:

- Cooperative Passage Hold;
- Regulation leases;
- Passage forward point Reposition;
- Passage captured-axis runout / Axis Return;
- Passage cached Transit configuration and symmetric restoration;
- D-0147 warm opportunistic compaction;
- D-0218 cold opportunistic compaction.

The generic configuration surface is therefore not dead prototype residue.
D-0147 and D-0218 are current consumers and their semantics must remain intact.

## Target placement

The production mechanisms become:

- `scripts/control/mechanisms/FieldWorkHoldMechanism.lua`
- `scripts/control/mechanisms/NativeDriveMechanism.lua`
- `scripts/control/mechanisms/TransitConfigurationMechanism.lua`

`Mechanism` is deliberate: these modules perform bounded physical integration
below Control. They do not choose Candidates, establish Responsibility, create
Commitments, grant Bounded Authority or infer semantic success.

## Production composition

`main.lua` becomes the production composition root.

It constructs one shared:

- `FieldWorkHoldMechanism`;
- `NativeDriveMechanism`;

and one Passage-owned:

- `TransitConfigurationMechanism`.

The Hold and Drive instances are shared with the manual P22 harness, Regulation
Control and Cooperative Passage exactly as the accepted implementation shares
their underlying state today.

D-0147 and D-0218 continue to construct independent
`TransitConfigurationMechanism` instances. Phase 14.2 must not collapse those
state lifetimes into one global configuration owner.

## Prototype22 after graduation

`Prototype22CapabilityGate` remains a genuine Prototype: manual `otmP22`
experiment, HUD and release monitoring.

It becomes a client of injected Hold/Drive mechanisms rather than the
production mechanism factory or donor container.

When injected with production-shared mechanisms, its lifecycle may clear only
effects belonging to its own active manual run. It must not globally clear
shared mechanism state.

## Mechanism responsibilities

### FieldWorkHoldMechanism

Owns transparent `getCanAIFieldWorkerContinueWork` interception and per-vehicle
Hold bookkeeping. It never overrules a pre-existing GIANTS/mod refusal.

### NativeDriveMechanism

Owns the single `AIVehicleUtil.driveToPoint` interception for:

- composable Regulation leases;
- zero-cap Regulation/Hold boundary;
- forward point Reposition;
- captured-axis travel;
- state inspection and neutralisation.

The uncalled historical `REPOSITION_ORIENT` surface is retired.

### TransitConfigurationMechanism

Owns the existing GIANTS work/raise/fold integration.

It retains both accepted capability families:

- cached Transit prepare/settlement/restore for Cooperative Passage;
- generic fold evidence/compact behaviour used by D-0147 and D-0218.

No configuration semantics are reinterpreted.

## Behaviour preservation contract

Phase 14.2 preserves:

- exact GIANTS integration points;
- one shared drive interception for Regulation and Passage;
- Regulation lease composition and zero-cap semantics;
- Passage Hold acquisition/release;
- Passage point-Reposition geometry;
- D-0192/D-0195 captured-axis travel;
- cached Transit configuration/restoration;
- D-0147 warm compaction/courtesy behaviour;
- D-0218 cold compaction/relocation behaviour;
- Player Claim and GIANTS source-reactivation precedence;
- Candidate / Constraint / Decision / Responsibility boundaries;
- every speed, distance, clearance, timeout and traffic-policy value.

## Validation contract

Blocking offline validation must prove:

- old Prototype22 mechanism files are absent from active source;
- the three mechanism modules are explicitly sourced;
- `main.lua`, not P22, constructs the production shared mechanisms;
- Regulation and Passage receive the same `NativeDriveMechanism`;
- Passage and P22 receive the same `FieldWorkHoldMechanism`;
- D-0147 and D-0218 retain independent configuration mechanism instances;
- P22 cannot globally clear shared production mechanism state;
- `REPOSITION_ORIENT` is absent;
- mechanism modules gain no semantic pipeline authority.

After blocking CI, use the familiar Reality preservation smoke covering:

1. Regulation apply/update/release;
2. Cooperative Passage Hold/movement/hand-back;
3. cached Transit configuration where available;
4. warm D-0147;
5. cold D-0218 with the extra assembly.

A failed Reality observation disproves the implementation.
