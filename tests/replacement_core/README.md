# Replacement-Core Conformance Tests

v4.7.15 adds bounded interaction-diagnostic conformance while preserving all earlier tests. The suite proves:

- pair identity is unordered and multi-worker capable;
- three workers produce all three unique relationships;
- pair-prediction rejection has one exhaustive principal outcome;
- missing physical radius is explicit and cannot emit interaction evidence;
- qualifying live interaction evidence reaches Situation Assessment and creates an Encounter;
- active-job pose failure remains non-admitted and diagnostic;
- blocked-without-Encounter is visible as a contradiction warning;
- position-derived motion distinguishes forward, reverse, turning and stationary evidence;
- Field World Equivalence Authority, immutable records, admission, Operation, Candidate, Decision, replay and terminal-settlement checks remain active;
- Control remains disabled.

Run from the repository root:

```text
texlua tests/replacement_core/run.lua .
pytest -q
```

The listener never applies the Decision-to-Commitment boundary, never imports archived code and has no physical Control capability.
