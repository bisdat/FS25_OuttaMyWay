# Project Status

> **Current candidate:** v4.7.4 Replay Conformance  
> **Implementation baseline:** owner-declared canonical v4.7.3  
> **Canonical v4.7.3 SHA-256:** `f1a8219f9b538a65abf66e8462f42ebd233f41ac5587295d9317e1b8f2314d90`  
> **Canonical v4.7.3 Git:** `90fab767c9550e45e8f6ff97f78ce07f15956045`  
> **Architecture authority:** canonical v4.6.78

## Current implementation state

v4.7.4 preserves the complete v4.7.3 offline reasoning foundation and implements the replay-conformance gate.

Implemented:

- immutable replay fixture and run-result contracts;
- deterministic replay execution with earliest-divergence reporting;
- enforcing Commitment admission by Governing Basis responsibility;
- Decision-to-Commitment create, maintain, revise, wait and settle application without physical Control;
- Governing Basis evaluation for canonical continuing and terminal events;
- Terminal Settlement enforcement across obligations and progress authority;
- documented historical reconstruction corpus covering the mandatory replay families and lifecycle boundary assertions.

Not implemented:

- live GIANTS Observation;
- raw historical log parser;
- Control admission or physical capabilities;
- passive live validation;
- gameplay coordination.

## Evidence boundary

The replay corpus reconstructs only facts already preserved in canonical documents. It does not infer missing behaviour from archived code and does not simulate GIANTS physics.

## Candidate status

v4.7.4 remains non-canonical pending owner review and local canonical generation. No live behavioural test is required because every new path remains offline-only and Control authority is disabled.
