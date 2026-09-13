# Executable Offline Validation

This directory describes the executable offline validation mechanisms and fixtures under `/tests`, how they are run and maintained, and what they can and cannot prove. Project testing philosophy belongs to [`docs/TESTING_METHODOLOGY.md`](../docs/TESTING_METHODOLOGY.md).

## Current structure

```text
tests/
├── README.md
├── test_*_structure.py
├── source_reference_prototype.py
├── source_reference_prototype_manifest.json
├── replacement_core/
│   ├── README.md
│   └── run.lua
└── replay/
    └── HistoricalFixtures.lua
```

## Python structural and source-contract suite

Responsibility-named `test_*_structure.py` modules validate repository and source contracts: module placement, loading and dependencies; selected forbidden paths, literals and authority boundaries; and legitimate dependencies on live Research evidence. Test module names describe the durable contract they protect rather than the engineering phase, Issue or migration that introduced them.

`pytest` runs this suite in GitHub Actions and may also be used locally. These assertions do not prove GIANTS runtime behaviour.

### Source-reference prototype

Issue #141 currently includes one explicitly temporary validation-machinery experiment:

- `source_reference_prototype_manifest.json` is bounded prototype metadata standing in for a future colocated source annotation contract;
- `source_reference_prototype.py` verifies those declarations against real source/Spec paths and emits deterministic non-normative reference; and
- `test_source_reference_prototype_structure.py` checks that the committed prototype output is current.

The experiment is evidence, not permanent tooling authority. Its design record lives at [`docs/research/prototypes/PROTOTYPE_35_SOURCE_DOCUMENTATION_TRACEABILITY.md`](../docs/research/prototypes/PROTOTYPE_35_SOURCE_DOCUMENTATION_TRACEABILITY.md). If a later source-annotation model supersedes the manifest, the temporary fixture should be removed rather than preserved as historical topology.

## Lua offline conformance and behavioural harness

[`replacement_core/run.lua`](replacement_core/run.lua) loads a broad implementation surface into a stubbed non-game environment. It exercises contracts, lifecycle, authority, assessment, candidate, decision, control and selected behaviour. See its [local README](replacement_core/README.md) for the validated command and limits.

Issue #67 reconciled the harness with accepted production topology and Issue #78 removed the sole remaining production failure. The accepted clean baseline is therefore **337 passed / 0 failed** for the main replacement-core harness and **9 passed / 0 failed** for the focused obstruction-relocation harness. GitHub Actions now treats those Lua suites as **blocking behavioural contracts**. No failure-count threshold is accepted.

The harness also has a demonstrated **Validation Runtime Contract** for sealed collections: `pairs()` must honour `__pairs`, and `rawlen()` must be available. PR #24 isolated this from operating-system and LuaJIT source-version differences: stock Ubuntu LuaJIT from upstream commit `c525bcb9024510cad9e170e12b6209aedb330f83` produced **239 passed / 40 failed**, while the same source revision built with `LUAJIT_ENABLE_LUA52COMPAT` produced **266 passed / 13 failed**, matching the local Fedora baseline. CI therefore builds that pinned revision with Lua 5.2 compatibility enabled and reports the semantic profile before running the harness.

## Replay fixtures

[`replay/HistoricalFixtures.lua`](replay/HistoricalFixtures.lua) contains executable historical reconstruction inputs for ReplayRunner and conformance testing. They are current test evidence. Their historical provenance does not grant them current architectural authority.

## Continuous integration

[`.github/workflows/offline-validation.yml`](../.github/workflows/offline-validation.yml) runs on pull requests targeting `main`, pushes to `main`, and manual dispatch.

- **Structural contracts** are blocking because the structural/source-contract suite has a clean accepted baseline.
- **Lua offline behavioural contracts** are blocking because their reconciled accepted baseline is clean. The workflow still lets both inner harnesses run even if one fails, then fails the final enforcement gate if either outcome is non-success.
- **Evidence Collection != CI Enforcement**: complete failure evidence and a blocking CI verdict are compatible.
- CI executes and reports repeatable repository/offline validation; it does not interpret evidence, define architecture, or replace in-game Reality testing.

This lets implementation work push a commit and receive independent repeatable validation without requiring the implementation agent to spend time rerunning the complete offline suite itself.

## Maintenance boundary

Tests follow current contracts rather than historical topology, and legitimate retained-evidence dependencies follow their responsible live locations. Agent-side static or offline PASS remains distinct from in-game Reality validation.
