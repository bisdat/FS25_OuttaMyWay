# ADR-0007 — Delegated Native Configuration Restoration

**Status:** Superseded by ADR-0009 after runtime evidence disproved constrained native-restoration paths; retained as decision history

**Date:** 2026-08-04

## Context

Two v4.6.57 TS015 runs froze at the same physical boundary. Native Reposition had completed rejoin and OuttaMyWay was almost finished unfolding Condor. On the first deployed classification, the controller synchronously restored work/raised state, released its permission hold and requested GIANTS continuation. The logs then recorded only an initial motion sample before forced termination.

The evidence disproved the assumption that one Control capability should own positional restoration, working-configuration actuation, authority release and native continuation as one bundled transition.

## Decision

Adopt **Restoration Obligation–Actuation Separation**.

The Commitment owns the restoration postcondition and its release obligations. Control may satisfy that postcondition either through an explicitly proven OuttaMyWay actuator or by delegating configuration actuation to GIANTS. For native field-worker continuation, GIANTS is the preferred configuration-restoration authority because it owns the job and required working state.

The generic sequence is:

```text
NATIVE_REPOSITION
→ position achieved under retained movement constraint
→ RESTORE
→ return configuration authority to GIANTS
→ request native continuation while movement remains constrained
→ observe native configuration restoration
→ observe stable terminal configuration
→ release movement authority on a later update
→ observe sustained independent continuation
→ Safe Release Point
```

`RESTORE_CONFIGURATION` is therefore a required postcondition, not necessarily an OuttaMyWay command.

## Authority separation

- **Configuration authority:** determines fold, lower, work-on and other job-required assembly state.
- **Movement authority:** determines whether the assembly may translate.
- **Commitment authority:** determines whether restoration evidence is sufficient and whether Safe Release is permitted.

Returning configuration authority does not release movement authority. Releasing movement authority does not complete the Commitment.

## Validation obligations

The delegated mechanism must establish:

1. OuttaMyWay stops issuing configuration commands before native restoration begins.
2. GIANTS can progress configuration while the permission movement hold remains active.
3. Terminal configuration is stable across multiple observations, not one threshold crossing.
4. Movement release occurs on a later update and does not repeat `aiContinue` on the deployment-completion tick.
5. Restore completion requires sustained movement and material travel.
6. Failure to restore or continue remains held and operationally relevant.
7. Safe Release remains a separate Decision/Commitment conclusion.

## Consequences

- Native Reposition ends at positional completion rather than GIANTS handback.
- Restore becomes the explicit owner of configuration-authority return and movement release sequencing.
- The v4.6.57 repeatable freeze is treated as evidence against bundled handback, not as a Condor-specific unfolding defect.
- Other assemblies may use the same authority separation even when their native restoration involves lowering, switching on or another configuration transition.
- A direct OuttaMyWay restoration actuator remains possible only when separately justified and proven safe.
