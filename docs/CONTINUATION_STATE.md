# Continuation State

Continuation State is the compact, replace-in-place description of the
project's present engineering boundary. Git history preserves prior states; this
is not a changelog, release ledger, or canonical-release record.

## Current engineering concern

Establish independent GitHub Actions execution for repeatable offline validation
before the diagnostic/probe implementation investigation.

## Established

- Accepted root responsibilities are now explicit: `/tests` owns executable offline validation machinery and replay fixtures; `docs/research/` owns bounded human evidence; root implementation containers exist only for demonstrated implementation responsibility.
- Root `/gui` was retired under **Unreferenced Asset Persistence**. Its orphan HUD background had no current runtime, XML, GUI-architecture or repository dependency. Deferred GUI architecture remains in `docs/GUI.md` without speculative implementation topology.
- Root `/scenarios` was retired by responsibility succession under **Scenario Responsibility Conflation**. The reconciled Research Scenario Library owns human Repeatable Reality Fixture knowledge, while executable historical replay data is now under `tests/replay/`.
- A Scenario is reproducible starting Reality; a Test is a question asked using it. Scenario identity follows materially stable starting Reality, and fixture repeatability strengthens attribution rather than claim breadth.
- `/tests` now documents its Python structural suite, stubbed Lua offline conformance harness and replay-fixture responsibilities. Offline PASS remains distinct from GIANTS field Reality.
- The Python structural suite passes **96/96**. The available LuaJIT offline harness reports **266 passed / 13 failed**, identical to exact starting `main`; replay relocation created no new failure. That pre-existing behavioural-harness baseline is evidence for later responsibility review, not authority for an unrelated fix here.
- GitHub Actions now owns independent repeatable execution/reporting of the structural suite on PR and `main` commits. The Lua harness also runs automatically as an explicitly non-blocking observation while its existing failures remain unreconciled; CI does not encode 13 failures as an accepted threshold.
- **Validation Runtime Contract** was demonstrated during CI establishment: the sealed-collection Lua harness requires LuaJIT semantics where `pairs()` honours `__pairs` and `rawlen()` is available. Stock Ubuntu LuaJIT at upstream `c525bcb...` produced **239/40**; rebuilding the same revision with `LUAJIT_ENABLE_LUA52COMPAT` restored the pre-existing **266/13** baseline exactly. CI now makes that semantic profile explicit before running the harness.
- `TESTING_METHODOLOGY.md` owns progressive validation, claim/assumption traceability, Repeatable Reality Fixtures, regression selection and Failure-Driven Fixture Promotion.
- `SCOPE_AND_VALIDATION_ENVELOPE.md` owns the Supported, Boundary Characterisation and Excluded/No-Claim index and resulting validation obligation.
- Current validation remains depth-first while concepts and implementation are evolving. Level 7 systematic supported-envelope coverage, Scope Overlay and a mature validation matrix remain future work.
- **Test-Sustained Implementation Persistence** remains an observation for the later diagnostic/probe investigation; no diagnostic or probe implementation was pruned.
- The root documentation and repository responsibility review is complete unless contrary evidence appears.
- No runtime behaviour changed.

## Current boundary

Repository knowledge, scope, methodology, fixtures and executable validation
now have distinct owners, and repeatable offline checks can execute independently
of the implementation agent. Broader validation can grow from explicit claim
boundaries without treating every successful coverage case as a permanent saved
fixture.

## Next boundary

Begin observation-led diagnostic/probe implementation persistence
investigation, including Test-Sustained Implementation Persistence, now that
root/document/test responsibilities are explicit.

## Not currently active

- Runtime implementation changes.
- Diagnostic/probe pruning or defining its implementation increment.
- Test-suite modularisation.
- Scope Overlay or mature supported-envelope validation-matrix construction.
- Release preparation, packaging, publication, or canonicalisation.
- Restoring retired documents to satisfy stale references.
- Reorganising `docs/archive/`.
