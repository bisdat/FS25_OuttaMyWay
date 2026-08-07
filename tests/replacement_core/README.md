# Replacement-Core Conformance Tests

v4.7.18 preserves all earlier conformance tests and adds positive evidence-admission coverage. The suite proves:

- configuration-filtered component footprints remain Job Episode/profile cached;
- inactive alternative Condor geometry remains excluded;
- footprint positives can establish current or bounded future interaction;
- unresolved footprint evidence cannot establish clearance or suppress scalar positives;
- footprint-only positive evidence survives source-to-assessment handoff and creates one Encounter even when scalar radius is missing;
- pair identity remains unordered and multi-worker capable;
- Decision, Commitment application and Control remain passive.

Run from the repository root:

```text
texlua tests/replacement_core/run.lua .
pytest -q
```
