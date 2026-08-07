# Replacement-Core Conformance Tests

v4.7.17 preserves all earlier conformance tests and adds configuration-participation evidence. The suite proves:

- layered plan-view composition preserves non-rectangular extents;
- complete geometry inventory is distinct from profile participation;
- inactive 54 m alternative Condor geometry cannot contaminate a selected 36 m profile;
- runtime compound-child evidence can select a different purchased geometry family without hard-coded truncation;
- shadow component convergence supports only positive potential conflict;
- incomplete coverage never grants negative clearance;
- compound offset and articulated members retain their own live poses;
- expensive local geometry APIs are not repeated on cache hits;
- assembly membership drift invalidates the Job Episode representation;
- pair identity remains unordered and multi-worker capable;
- live predictor, Encounter admission and Control remain unchanged.

Run from the repository root:

```text
texlua tests/replacement_core/run.lua .
pytest -q
```
