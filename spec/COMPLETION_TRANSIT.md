# Completion TRANSIT Specification

## Identity and authority

**Specification Jurisdiction:** Completion Transit  
**Jurisdiction ID:** `COMPLETION_TRANSIT`

**Primary Architecture Authority:** [Completion-Triggered Terminal Egress](../architecture/COMPLETION_TRIGGERED_TERMINAL_EGRESS.md#specification-jurisdiction--completion-transit)

This restricted TEST increment can request GIANTS TRANSIT configuration for a completed FIELDWORK assembly. It must not drive, reverse, navigate, hold, regulate, select a parking position, or claim that TRANSIT is physically settled.

## Admission and supersession

Only a native `AI_JOB_STOPPED` event for an `AIJobFieldWork` instance with positive `AIMessageSuccessFinishedJob` class identity may reach this Control consumer. Manual stop, cancelled/unknown reasons and OMW-induced restart are ineligible. Do not audit agronomy.

Require authoritative server, resolved and enabled profile Configuration, valid non-deleted assembly, and no positively observed newer current AI job. One request attempt per physical root object during the current map lifetime is the conservative TEST boundary. Refuse if a request was already made; missing capabilities or plans fail visibly rather than inferring configuration success.

## Mechanism and retirement

Use the established native solo/static TRANSIT plan construction and `NativeTransitRequestMechanism` in a **separate instance**, never borrowing the existing Hold & Relocate Control plan cache or mechanism state. Requests may command work-off, raise and supported fold operations, but no readiness assertion follows from an accepted request.

When product is disabled or the map tears down, relinquish the completion request state without applying WORKING restoration commands to a completed machine. A newer AI job prevents admission, but ownership after a started request is not a validated future parking/control lifecycle.

**TEST-only Configuration limitation:** this increment is temporarily gated by overall `enabled`. Issue #476 requires a dedicated persisted player choice before integration into a released capability. It is **not approved for merge into main** until that choice and associated interruption contract are implemented.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/control/CompletionTransitRuntime.lua`](../scripts/control/CompletionTransitRuntime.lua) | `REALISES` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/completion_transit.lua`](../tests/shell/completion_transit.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |

## Validation route

Offline: positive success invokes at most one request, nil/manual termination never requests, disabled configuration denies, a newer current job denies, relinquish never restores WORKING posture. GIANTS Reality: test natural completion and verify requested posture, no movement, no manual-stop or BWR false activation, then repeat with machines requiring fold/raise and with active competing work.

An accepted native command request is not evidence of actual fully folded TRANSIT or physical off-field settlement.
