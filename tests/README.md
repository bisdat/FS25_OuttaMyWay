# Executable Offline Validation

This directory describes the executable offline validation mechanisms and fixtures under `/tests`, how they are run and maintained, and what they can and cannot prove. Project testing philosophy belongs to [`docs/TESTING_METHODOLOGY.md`](../docs/TESTING_METHODOLOGY.md).

## Current structure

```text
tests/
├── README.md
├── test_replacement_core_structure.py
├── replacement_core/
│   ├── README.md
│   └── run.lua
└── replay/
    └── HistoricalFixtures.lua
```

## Python structural and source-contract suite

`test_replacement_core_structure.py` validates repository and source contracts: module placement, loading and dependencies; selected forbidden paths, literals and authority boundaries; and legitimate dependencies on live Research evidence. Accepted main entered this increment at an all-pass baseline of 96 tests.

`pytest` may run it where available. In the current repository environment, the zero-fixture test functions can be invoked by the direct Python harness used in PR validation. These assertions do not prove GIANTS runtime behaviour.

## Lua offline conformance and behavioural harness

[`replacement_core/run.lua`](replacement_core/run.lua) loads a broad implementation surface into a stubbed non-game environment. It exercises contracts, lifecycle, authority, assessment, candidate, decision, control and selected behaviour. See its [local README](replacement_core/README.md) for the validated command and limits.

## Replay fixtures

[`replay/HistoricalFixtures.lua`](replay/HistoricalFixtures.lua) contains executable historical reconstruction inputs for ReplayRunner and conformance testing. They are current test evidence. Their historical provenance does not grant them current architectural authority.

## Maintenance boundary

Tests are run explicitly as part of Engineering Increment and pull-request validation. Repository inspection found no checked-in GitHub Actions workflow that owns their execution. Tests follow current contracts rather than historical topology, and legitimate retained-evidence dependencies follow their responsible live locations.

Agent-side static or offline PASS remains distinct from in-game Reality validation.
