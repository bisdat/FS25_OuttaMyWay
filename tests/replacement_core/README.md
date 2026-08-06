# Replacement-Core Conformance Tests

v4.7.12 adds deterministic geometry metrics, near-equivalent and split-polygon comparison checks, bounded evidence retention and a guard proving diagnostic equivalence does not merge Operations.

v4.7.11 adds polygon canonicalisation invariance, split-polygon distinction, immutable Job Episode binding, three-Operation concurrent grouping and global Operation trace coverage.

v4.7.10 adds source-field polygon authority, farmland-context negative tests, source-label disagreement handling, positive `lastJob` termination, stale `fieldJob` tolerance and a simulated GIANTS derived Field World containing source fields 68, 69 and 70.

The suite also retains all earlier replay, immutable traversal, admission, Operation, Candidate, constraint, Decision and terminal-settlement checks.

Run from the repository root:

```text
texlua tests/replacement_core/run.lua .
pytest -q
```

The listener never applies the Decision-to-Commitment boundary, never imports archived code and has no physical Control capability.