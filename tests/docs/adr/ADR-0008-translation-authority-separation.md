# ADR-0008 — Translation Authority and Field-Worker Progression Separation

**Status:** Constraint Semantics Mismatch retained; zero-speed Translation Authority Lease rejected by runtime evidence; implementation path superseded by ADR-0009

## Context

v4.6.58 returned configuration authority to GIANTS while retaining the Traffic Permission Gate. GIANTS never began unfolding the compact assembly. After 25 seconds, delegated restoration timed out and the controller entered a failure state. The game became unresponsive at the same boundary.

The gate overwrites `getCanAIFieldWorkerContinueWork`. Reality therefore showed that it is not a translation-only constraint: it can suppress the broader field-worker progression that owns native configuration restoration.

The failure path also exposed that repeated toggle-based compact requests are unsafe after configuration authority has been returned.

## Decision

Name the discovery **Constraint Semantics Mismatch**.

Distinguish:

- **Configuration authority** — fold, lower, work-state and other native assembly configuration.
- **Translation authority** — physical vehicle displacement.
- **Field-worker progression authority** — permission for the GIANTS field-worker state machine to advance.

During delegated native restoration:

1. OuttaMyWay first acquires a reversible zero-speed translation lease.
2. OuttaMyWay returns configuration authority to GIANTS.
3. The Traffic Permission Gate is released, enabling field-worker progression.
4. `aiContinue` is requested once.
5. GIANTS configuration restoration is observed while translation remains constrained.
6. Stable terminal configuration permits later release of the translation lease.
7. Sustained native continuation remains required before Restore completes.

A restoration failure becomes **inert**: retain the last safe translation state, issue no fold/unfold/work-state command, issue no repeated continuation request, and require explicit operator recovery.

## Deferred non-decision

This ADR neither adopts nor rejects a future architecture that returns fully to GIANTS without any temporary speed or translation constraint. That question is explicitly reserved for later architectural discussion.

## Consequences

- The Traffic Permission Gate is no longer described as a movement-only constraint.
- The attempted zero-speed Translation Authority Lease was rejected by v4.6.59 Reality and is not an active capability.
- Repeated `requestCompact()` calls are prohibited in terminal failure states.
- The implementation remains generic; no Condor, Patriot, TS015 or TS016 identity is used in the authority policy.
