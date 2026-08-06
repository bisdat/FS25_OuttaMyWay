# Replacement-Core Conformance Tests

v4.7.14 adds executable Field World Equivalence Authority conformance. The suite now proves:

- distinct immutable Snapshots with exact canonical geometry resolve to one Field World;
- four non-exact merged-workspace representations form one coherent class;
- positively separated representations form different Field Worlds;
- partial overlap remains unresolved and receives no Operation authority;
- pairwise tolerance chaining cannot enlarge a class;
- inactive classes retire and later captures receive new identity;
- one Operation may retain multiple Snapshot and exact-polygon references;
- Control remains disabled.

All earlier immutable traversal, admission, Operation, Knowledge, Candidate, constraint, Decision, replay and terminal-settlement checks remain active.

Run from the repository root:

```text
texlua tests/replacement_core/run.lua .
pytest -q
```

The listener never applies the Decision-to-Commitment boundary, never imports archived code and has no physical Control capability.
