# Phase 14.1 — Production Regulation Control Boundary

## Purpose

Phase 14 established **Production Capability != Prototype Harness**.

The first bounded engineering increment separates the already-accepted production
`REGULATE_SPEED` Control responsibility from `Prototype22CapabilityGate` without
changing Regulation policy or the proven physical drive mechanism.

This is a **behaviour-preserving responsibility separation**. It is not the
physical-capability graduation of Phase 14.2 and it does not redesign traffic
policy, Bounded Authority, Cooperative Passage, D-0147, D-0218 or GIANTS job
ownership.

Baseline is accepted `main` after PR #72 merge,
`0f6d8aca7f3765d90ac07c580f08dec67f3d7779`. Canonical authority remains
**v0.3.0.0**. The last accepted playable identity at design time is
**`0.3.0.20 TEST — CANDIDATE SUPPORT PROJECTION`**.

## Current mixed responsibility

Before 14.1 the production path is:

```text
RegulationBoundedAuthority / GuardedRecoveryCompatibility
        |
        v
LiveControlDispatcher
        |
        v
Prototype22CapabilityGate:executeControlRequest()
        |
        v
Prototype22DriveAuthority regulation lease
        |
        v
GIANTS AIVehicleUtil.driveToPoint
```

The same `Prototype22CapabilityGate` object also owns the genuine manual
`otmP22` experiment, its HUD and release monitor, and acts as a donor container
for Cooperative Passage permission/drive/configuration mechanisms.

The prototype enable flag gates the manual harness but does not gate production
`executeControlRequest()`. A Prototype-named object therefore carries real
production Control authority.

## Target responsibility

14.1 introduces one production component:

### `RegulationControl`

`RegulationControl` consumes an **already-authorised** `ControlRequest` whose
capability is `REGULATE_SPEED`.

It owns only:

1. validation that the referenced Commitment remains live;
2. validation that the request's Effective Actuation Composition is current;
3. validation of the request Authority token;
4. validation of an existing Bounded Authority grant where the current owner
   class requires one;
5. validation of the Regulation lease target and operation;
6. resolving the current active GIANTS AI vehicle reference used by the existing
   physical mechanism;
7. applying or clearing the existing drive Regulation lease;
8. exposing the same raw per-vehicle Control-execution observation used to mark
   diagnostic/native-manoeuvre evidence as Control-influenced; and
9. fail-safe reference-scoped lease cleanup that can only relax already-owned
   Control.

It does **not**:

- choose a Candidate;
- establish Regulation policy or speed magnitude;
- create a Commitment or Current Responsibility;
- acquire Bounded Authority;
- create a `ControlRequest`;
- own manual console commands, HUDs or release-monitor experiments;
- own Passage movement, Hold permission or configuration actuation; or
- discover a new physical drive mechanism.

## Target call graph

```text
RegulationBoundedAuthority / GuardedRecoveryCompatibility
        |
        v
LiveControlDispatcher
        |
        v
RegulationControl
        |
        v
existing Prototype22DriveAuthority instance
        |
        v
GIANTS AIVehicleUtil.driveToPoint
```

`NativeManoeuvreObservationSource` receives raw Control-influence observation
from `RegulationControl`, not from the P22 harness.

## Temporary mechanical dependency

14.1 deliberately **does not rename or re-home** `Prototype22DriveAuthority`.
That mechanism is shared by production Regulation and Cooperative Passage and is
the subject of Phase 14.2.

For 14.1, `RegulationControl` and the manual P22/Passage donor container receive
the **same existing `Prototype22DriveAuthority` instance**. This preserves:

- the single installed `AIVehicleUtil.driveToPoint` interception;
- existing Regulation lease composition;
- existing Passage movement and Axis Return behaviour; and
- the existing interaction between manual P22 experiments and the shared donor.

The dependency is explicit transitional placement debt, not a claim that a
Prototype owns production Regulation semantics.

## P22 harness after the split

`Prototype22CapabilityGate` remains temporarily as:

- the manual `otmP22` experimental harness;
- P22 HUD and same-Job release-monitor instrumentation; and
- the existing donor container supplied to `CooperativePassageControl`.

It must no longer implement:

- production `executeControlRequest()`;
- production per-vehicle Control observation; or
- production fail-safe Regulation lease cleanup.

The permission, drive and configuration donor names remain unchanged until 14.2.

## Production identifier graduation

The typed production Regulation target kind becomes:

`REGULATION_LEASE`

The validation-origin name `P22_REGULATION_LEASE` no longer describes a
Prototype experiment once the request is consumed by a production Control
component.

This identifier change is semantic vocabulary only. The request fields,
operations, owner tags, Bounded Authority requirements and Regulation magnitudes
remain unchanged.

Guarded Recovery remains an explicit Compatibility path, but its Regulation
request is routed through the same production `RegulationControl` boundary.

## Observation preservation

The existing per-vehicle raw Control observation remains observational only. It
may report current drive mode/owner and measured/command telemetry, but it does
not establish traffic meaning or escalation authority.

14.1 does not introduce a new aggregate Control-outcome signal. The existing
coordinator-level optional observation path remains behaviourally unchanged.

## Behaviour preservation contract

14.1 must preserve:

- every current Regulation magnitude and owner-tag policy;
- Regulation lease composition and least-permissive physical cap;
- follower Regulation apply/update/quiesce/reactivate/release semantics;
- Forward Intersection and Action-Space Regulation semantics;
- D-0147 protected-yield Hold semantics;
- Guarded Recovery's accepted compatibility behaviour;
- Bounded Authority and Authority-token validation;
- the exact `Prototype22DriveAuthority` physical implementation;
- Cooperative Passage's existing P22 donor container and physical Control;
- GIANTS route, steering, direction, Job Episode and productive-work ownership;
  and
- all Phase-13 Candidate/Constraint/Decision/Responsibility boundaries.

No lower-level physical Control file for Passage, D-0147 or D-0218 is changed by
this increment.

## Validation contract

Offline validation must prove structurally that:

- `RegulationControl` is the production `REGULATE_SPEED` executor;
- `Prototype22CapabilityGate` no longer carries those production methods;
- Runtime, `LiveControlDispatcher`, `RegulationBoundedAuthority`, Guarded Recovery
  and native-manoeuvre Control-influence observation are wired to
  `RegulationControl`;
- production request vocabulary uses `REGULATION_LEASE`;
- Cooperative Passage still receives the unchanged P22 donor container; and
- the existing physical mechanism modules are untouched.

GitHub Actions remains the offline execution authority.

After blocking CI passes, GIANTS Reality validation should be a narrow
behaviour-preservation smoke:

1. one ordinary live Regulation episode that positively applies and releases a
   Regulation lease at the expected magnitude; and
2. one ordinary Cooperative Passage to prove the shared drive donor has not been
   disturbed by the ownership split.

A failed smoke is evidence against the separation and must not be explained away
by redefining expected behaviour.
