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

`test_replacement_core_structure.py` validates repository and source contracts: module placement, loading and dependencies; selected forbidden paths, literals and authority boundaries; and legitimate dependencies on live Research evidence. Accepted main entered the CI increment at an all-pass baseline of 96 tests.

`pytest` runs this suite in GitHub Actions and may also be used locally. These assertions do not prove GIANTS runtime behaviour.

## Lua offline conformance and behavioural harness

[`replacement_core/run.lua`](replacement_core/run.lua) loads a broad implementation surface into a stubbed non-game environment. It exercises contracts, lifecycle, authority, assessment, candidate, decision, control and selected behaviour. See its [local README](replacement_core/README.md) for the validated command and limits.

The harness currently contains pre-existing failures. GitHub Actions therefore runs it as an explicitly **non-blocking observation**: the raw harness outcome remains visible, but CI does not encode the current failure count as an accepted threshold. Once those failures are reconciled, the harness can become a blocking contract.

## Replay fixtures

[`replay/HistoricalFixtures.lua`](replay/HistoricalFixtures.lua) contains executable historical reconstruction inputs for ReplayRunner and conformance testing. They are current test evidence. Their historical provenance does not grant them current architectural authority.

## Continuous integration

[`.github/workflows/offline-validation.yml`](../.github/workflows/offline-validation.yml) runs on pull requests targeting `main`, pushes to `main`, and manual dispatch.

- **Structural contracts** are blocking because the structural/source-contract suite has a clean accepted baseline.
- **Lua offline observation** executes the behavioural harness but is non-blocking while its existing failures are being investigated.
- CI executes and reports repeatable repository/offline validation; it does not interpret evidence, define architecture, or replace in-game Reality testing.

This lets implementation work push a commit and receive independent repeatable validation without requiring the implementation agent to spend time rerunning the complete offline suite itself.

## Maintenance boundary

Tests follow current contracts rather than historical topology, and legitimate retained-evidence dependencies follow their responsible live locations. Agent-side static or offline PASS remains distinct from in-game Reality validation.
