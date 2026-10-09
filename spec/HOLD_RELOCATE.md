# Hold & Relocate Specification

## Identity and authority

**Specification Jurisdiction:** Hold & Relocate
**Jurisdiction ID:** `HOLD_RELOCATE`

**Primary Architecture Authority:** [Hold & Relocate](../architecture/BLOCKED_PROGRESS_QUALIFICATION.md#specification-jurisdiction--hold--relocate)

This contract operationalises the accepted **Hold & Relocate** responsibility in its governing Architecture. It is one cohesive responsibility, not a separate architectural jurisdiction per timing phase or source module. Native blocked Observation and Spatial Pair Inference provide candidates only; **Pair Commitment** and Bounded Authority must independently admit action. GIANTS retains native blockage and productive route decisions.

## Commitment and evidence boundary

A Hold & Relocate coordination request MUST carry an independently issued commitment identity, two distinct current Physical Assembly references and current root positions, a field-polygon centroid, an explicit offset and an evidenced set of nearby blockers that includes the other pair participant. The independent commitment authority MUST positively validate the originating GIANTS Job Episode identity, its continuity and the freshness of the supplied physical evidence; these may be resolved from the authority's current state rather than trusted solely from request fields. The supplied centroid is the field's centroid, not the pair midpoint. The commitment validation mechanism must reject self-declared authority and stale, changed, unsupported or player-controlled circumstances. Missing/contradictory evidence means no intervention; no default offset or invented blocker set.

Of the paired assemblies, the relocator is the one whose root is **nearest to the field centroid** in horizontal X/Z distance, irrespective of which worker first reported blocked. An exact squared-distance tie is broken consistently using current assembly-reference keys; the tie-break does not confer enduring semantic identity on GIANTS node identifiers.

The immediate-vicinity blocker set and a safe physical reverse objective require upstream evidence; proximity is not independent causal proof. The current coordinator consumes these inputs but **does not generate** their authority or discover them. No pair candidate from DEBUG publication directly creates Control.

## Timed physical coordination

The governing Architecture defines the six-stage purpose and fixed policies; the implementation MUST preserve these consequences:

1. Begin egress protection for all validated immediate blockers concurrently with TRANSIT preparation. The **5,000 ms** Hold begins when egress protection is acquired, not after an invented idle phase.
2. TRANSIT readiness must be positively observed before reverse actuation. Missing readiness must not be treated as a success.
3. Release the blocker Hold on expiry of the **5,000 ms** timer alone, not on pair distance, blocker unblocking or geometric clearance. If physical release cannot be verified, retain the unresolved obligation and request intervention; the controller must not claim release.
4. Reverse toward the field centroid, limiting physical travel to **30 m + the explicitly provided offset**. The former BWR **40 m steering horizon** is a local steering reference, not travel permission. Native reverse requires `getAIReverserNode()`, tool-relative target adjustment where available, and local-space `AIVehicleUtil.driveToPoint(..., moveForwards=false, ...)`. A reverse flag on a forward target is insufficient.
5. Only after positive bounded movement completion, end reverse Control and Hold the relocated worker for **10,000 ms**. At timer expiry release that Hold without an additional pairwise clearance gate.
6. Immediately request a single synchronous native FIELDWORK stop/restart operation. The physical interface must report successful native stop and accepted new native start separately. A successful request does **not** prove productive continuation, which remains GIANTS Reality evidence.

The physical Control boundary must establish TRANSIT, reverse steering and displacement observation, Hold acquire/release verification, lifecycle revalidation, and native stop/restart semantics. The coordinator may order those activities but MUST NOT be their authority source.

## Failure and unresolved obligations

Unavailability of a commitment, source GIANTS Job Episode, player consent, clock or native API must fail closed. On actuation failure, disablement or episode/strategy turnover, neutralise commanded movement and release Hold/TRANSIT using the available physical interface.

An external call can fail **after** partly changing GIANTS state. The coordinator MUST track possibly acquired effects before invoking it and must not discard a failed cleanup. Unverified release or job replacement is `UNRESOLVED`, with retained evidence and a supported explicit cleanup retry / player-intervention route. An uncertain native restart is not recast as GIANTS successful continuation even when physical Hold cleanup succeeds.

**Current implementation boundary:** the coordinator and a subordinate native reverse-driving mechanism are loaded but neither is instantiated or called by the shell. There is still no live commitment authority, complete physical Control interface or runtime Hold, Transit, reverse or stop/restart actuation. The coordinator's verified offline behaviour cannot establish GIANTS runtime success. Any future integration MUST validate safe physical release, native reverse geometry, native job recreation, and representative lifecycle interruption in game.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/coordination/HoldRelocateCoordinator.lua`](../scripts/coordination/HoldRelocateCoordinator.lua) | `REALISES` |
| [`scripts/control/mechanisms/NativeReverseMechanism.lua`](../scripts/control/mechanisms/NativeReverseMechanism.lua) | `SUPPORTS` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/hold_relocate.lua`](../tests/shell/hold_relocate.lua) | `CHALLENGES` |
| [`tests/shell/native_reverse_mechanism.lua`](../tests/shell/native_reverse_mechanism.lua) | `CHALLENGES` |

## Implementation traceability and validation scope

The [coordinator](../scripts/coordination/HoldRelocateCoordinator.lua) currently realises role selection, coordination sequencing and conservative unresolved-effect retention. The [native reverse mechanism](../scripts/control/mechanisms/NativeReverseMechanism.lua) is a dormant subordinate: when explicitly commanded, it interposes on GIANTS driveToPoint for only the selected assembly, preserves unrelated calls (including doNotSteer), uses the GIANTS reverser frame and BWR tool-relative correction, and reports cumulative X/Z displacement. Local 8 km/h reverse speed and 1 m point-approach tolerance are implementation-owned calibration. A command or sampled displacement does not prove clearance, useful continuation or exact physical stopping. [Product entry](../scripts/main.lua) sources the module without instantiating it; no production physical adapter exists. The [offline behaviour challenge](../tests/shell/hold_relocate.lua) covers timing, role selection, independent authority, failure recovery and uncertain native hand-back. The [reverse-mechanism offline challenge](../tests/shell/native_reverse_mechanism.lua) checks native call passthrough, reverser frame, available tool correction, measured travel, abort and missing APIs. GIANTS in-game tests, not offline mocks, must validate reverse geometry, physical stopping distance, Hold, Transit readiness and job continuation.
