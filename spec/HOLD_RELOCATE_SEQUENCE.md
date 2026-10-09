# Hold & Relocate Sequence Specification

## Identity and authority

**Specification Jurisdiction:** Hold & Relocate Sequence
**Jurisdiction ID:** `HOLD_RELOCATE_SEQUENCE`

**Primary Architecture Authority:** [Blocked-First Situation Assessment](../architecture/BLOCKED_PROGRESS_QUALIFICATION.md#specification-jurisdiction--hold--relocate-sequence)

This is the **coordination-order implementation**, not GIANTS physical Control. The module consumes a **separately authorised** pair commitment and already established worker, field-centroid, and immediate-vicinity evidence. It does not infer pair causality or promote passive DEBUG candidates to Control.

## Input and role selection

`begin(request, nowMs)` requires `authorized=true`, a non-null commitment identity, exactly two distinct positioned participants with their current vehicles and assembly-root IDs, a finite **field centroid** `x,z`, an explicit non-negative offset in metres, and a nonempty plain-array blocker set including the other member of the pair. The upstream Responsibility boundary MUST provide correct field-polygon centroid, correct Job Episodes and immediate-vicinity blocker membership. No pair midpoint, geometric inference or arbitrary additional neighbour is permitted here.

Choose the participant **nearest the centroid by squared horizontal X/Z distance**, regardless of which worker was originally blocked. Break an exact tie deterministically by root ID string order. Invalid or missing evidence refuses admission **without vehicle action**. The adapter preflight MUST reject unavailable GIANTS control or unverifiable lifecycle context before any Hold begins.

The centroid-directed objective is bounded to `min(distanceToCentroid, 30 m + explicitOffsetM)`; the nominal BWR reverse steering horizon remains 40 m but is **steering only**, never travel permission. The adapter MUST measure travelled displacement, apply the established native reverse target transformation (vehicle AI reverser node and tool-relative adjustment when available) and enforce the travel bound. The sequence checks finite nonnegative distance evidence and refuses over-bound results.

## Timed coordination

1. Immediately Hold every explicitly admitted nearby blocker and request TRANSIT for the selected relocating assembly in the **same begin call**. The five-second egress Hold starts at that instant, **concurrent** with Transit preparation and movement; it is not a pre-movement sleep.
2. The adapter reports `WAITING` or `READY` for Transit. Start reverse only when READY. Unresolved/failed Transit must never be treated as ready.
3. Release each blocker solely at the **5,000 ms** egress clock, whether the selected assembly has moved or not. No pair-distance, native-blocked, clearance or post-egress predicate controls this release.
4. The adapter alone confirms a successfully completed bounded reverse and stops its reverse mechanism. Then Hold the relocated assembly for **10,000 ms**, allowing GIANTS to continue the other worker.
5. On this timer alone, release the relocated assembly and invoke **one synchronous adapter operation** for GIANTS stop followed immediately by GIANTS start. The adapter is responsible for preserving the native FIELDWORK job semantics as established by BWR, with safe abort handling for partial native replacement.
6. After hand-back, retire the sequence. No new pairwise release gate is inserted.

A caller may relinquish responsibility on disablement, player takeover, original Job Episode/strategy loss, invalid time, or failed physical actuation. The adapter's `stillAuthorized` predicate represents **lifecycle and safety** only, not pair-clearance gating. On failure/abort, best-effort cancel owned reverse and Transit and release held workers; failure evidence must be surfaced to the player by the future physical runtime. No simple movement deadline or unverified success inference exists.

## Actuation adapter boundary

The injected adapter must implement `preflight`, `setHold`, `requestTransit`, `transitStatus`, `stillAuthorized`, `startReverse`, `reverseStatus`, `stopReverse`, `cancelReverse`, `cancelTransit` and `restartNativeJob`. Successful command functions return `true`; status functions return the typed `WAITING`/`READY` Transit status or reverse result with `travelledM`, `completed`, `failed`. Missing APIs, exceptions and rejected commands fail closed.

**Current deployment:** the module is explicitly sourced but not instantiated or called by `scripts/main.lua`. There is **no current GIANTS adapter**, no Situation Assessment admission/Pair Commitment producer, no authoritative centroid/membership feed and **no active vehicle Control**. Activation awaits a separately reviewed and GIANTS-tested physical implementation. Offline testing proves sequencing logic only, not movement, physical safety, TRANSIT or native job recreation.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/control/HoldRelocateSequence.lua`](../scripts/control/HoldRelocateSequence.lua) | `REALISES` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/hold_relocate_sequence.lua`](../tests/shell/hold_relocate_sequence.lua) | `CHALLENGES` |

## Authority Triad disposition

**Architecture:** the accepted six-stage sequence and role/timer rules are unchanged; add this narrow sequencer Jurisdiction. **Specification:** specifies the separable admitted-pair coordination mechanism. **Source:** implements ordering and pure boundary calls but no GIANTS side effects. GIANTS Reality validation is still required before physical activation.
