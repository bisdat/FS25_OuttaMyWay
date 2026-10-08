# Scope and Validation Envelope

This document distinguishes current implemented support from design intent and GIANTS Reality evidence. [Testing Methodology](TESTING_METHODOLOGY.md) governs validation strength; [Project Vision](../architecture/PROJECT_VISION.md) governs why the capability is sought.

## Current implemented envelope — 0.5 shell

- Persistent Configuration, DEBUG/DIAGNOSTIC publication policy, normal log publication, version-only HUD when enabled, and the disabled-startup reminder.
- **No** GIANTS worker observation, interference, movement, regulation, AI-job management or automatic recovery.
- Offline tests validate shell structure and its configuration/logging behaviour; owner-reported in-game smoke validates the visible current-shell experience only. These tests do not validate a worker-coordination system.

## Target design envelope — not yet implemented

Work remains directed at field-local cooperation between GIANTS AI workers, with no replacement of GIANTS-owned productive routing. Prior tests considered at most **three active AI worker assemblies per Local Operation**, targeting different agronomic roles; this is a historical design/validation bound, not an asserted 0.5 runtime capability.

The adjacent-opposed-A8 transient blockage example and native blocked/unblocked retry oscillation are unresolved qualification cases ([issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440)). Positive native blocked flags do not by themselves establish a permanent stall, a causal blocker, necessary intervention or a safe resolution.

The completed native-state experiment is preserved as [research evidence](research/NATIVE_BLOCKED_STATE_PROBE.md); version-qualified engine conclusions reside in [GIANTS Runtime Knowledge](engine/GIANTS_RUNTIME_KNOWLEDGE.md).

## Claim limits

- Prior 0.4 worker-control results and source contracts do not transfer as accepted 0.5 capabilities.
- An offline PASS cannot establish native GIANTS navigation outcomes.
- Logs of raw blocked flags cannot establish the player's visible blockage message, physical clearance, completed agronomic work or native recovery action without independent evidence.
- Any new runtime responsibility must be defined under Architecture, operationalised in Specification, implemented in Source and challenged by scenario Reality before acceptance.
