# Repository Release System

This directory contains the repository-owned implementation of the OuttaMyWay Repository Release System.

The RRS creates a complete candidate from an exact canonical ZIP and a declarative JSON release plan. It records the baseline fingerprint, applies controlled transformations, regenerates the release manifest, compares declared intent with observed effect, classifies repository findings relative to the baseline, and produces deterministic candidate and evidence ZIPs.

## Local workflow

Use the repository evolution command for normal local operation:

```text
python -m rrs evolve --baseline CANONICAL.zip --handoff release-plan.json --output out
```

This single command verifies the supplied baseline, applies the declared transition, regenerates the manifest, validates the candidate, and produces candidate and evidence packages. It does not alter Git state or declare a candidate canonical; those remain explicit engineer-owned actions.

The lower-level `build` command remains available for direct candidate construction and compatibility:

```text
python -m rrs build --baseline CANONICAL.zip --plan release-plan.json --output out
```

A build is blocked when:

- the supplied canonical fingerprint does not match the declared baseline;
- a declared change is missing;
- an undeclared change appears;
- the candidate introduces a repository violation;
- the release manifest is invalid;
- the resulting version does not match the target version.

The evidence package contains the release plan, baseline and candidate inventories, observed delta, classified findings, validation report, package fingerprints, and the exact RRS source used for the build.

## Evidence and workspace lifecycle

Every run creates a controlled workspace named `rrs_workspace` beneath the output directory.

- PASS: candidate and evidence packages are written, then the workspace is removed.
- Validation block: evidence is packaged and the workspace is retained for diagnosis.
- Execution failure: failure evidence is packaged and the workspace is retained for diagnosis.

A retained workspace is never overwritten implicitly. Resolve, move, or remove it before repeating the workflow in the same output directory.

Repository text is read and written as strict UTF-8. Invalid text encoding is treated as an execution failure and recorded in the evidence package rather than silently replaced.
