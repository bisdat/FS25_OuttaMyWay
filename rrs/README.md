# Repository Release System

This directory contains the repository-owned implementation of the OuttaMyWay Repository Release System.

The RRS creates a complete candidate from an exact Canonical Repository Snapshot and a declarative JSON Engineering Intent handoff. It records the baseline fingerprint, applies controlled transformations, regenerates the release manifest, compares declared intent with observed effect, classifies repository findings relative to the baseline, and produces a byte-deterministic candidate ZIP plus a provenance-bearing evidence ZIP.

## Local workflow

Use the repository evolution command for normal local operation:

```text
python -m rrs evolve --baseline CANONICAL.zip --handoff release-plan.json --output out
```

This single command verifies the supplied baseline fingerprint, applies the declared transition, regenerates the manifest, validates the candidate, and produces candidate and evidence packages. The handoff is valid only for that exact baseline. The command does not alter Git state or declare a candidate canonical; those remain explicit engineer-owned actions.

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

## Candidate determinism

For the same exact baseline ZIP and handoff JSON, supported execution platforms must produce the same candidate SHA-256. The implementation enforces this with:

- relative POSIX-path ordering shared by inventory, manifest and ZIP packaging;
- fixed timestamps and explicit UNIX-origin ZIP metadata;
- fixed regular-file permissions;
- stored ZIP entries rather than platform-dependent compression output.

Evidence ZIPs preserve run provenance and are not required to be byte-identical, but must name the same candidate fingerprint and agree on substantive findings.

### Updating Candidate Production itself

A running RRS process cannot use code changes that exist only in the candidate it is currently packaging. For an increment that changes `rrs/rrs.py`, run the proposed implementation from a separate fingerprinted bootstrap package. Keep the canonical Git repository unchanged, use the same canonical baseline ZIP and handoff, and retain the exact runner source in the evidence package. After accepted review, the candidate promotes that implementation into the repository normally.

## Evidence and workspace lifecycle

Every run creates a controlled workspace named `rrs_workspace` beneath the output directory.

- PASS: candidate and evidence packages are written, then the workspace is removed.
- Validation block: evidence is packaged and the workspace is retained for diagnosis.
- Execution failure: failure evidence is packaged and the workspace is retained for diagnosis.

A retained workspace is never overwritten implicitly. Resolve, move, or remove it before repeating the workflow in the same output directory.

Repository text is read and written as strict UTF-8. Invalid text encoding is treated as an execution failure and recorded in the evidence package rather than silently replaced.


## Current implementation boundary

The recovered implementation owns Candidate Production only. It accepts the exact canonical ZIP and a declarative planning handoff, applies controlled operations, validates declared against observed change, classifies repository findings, regenerates the manifest and emits a byte-deterministic candidate package plus a provenance-bearing evidence package.

It does not yet perform Authority Transformation, enforce the complete ordered authority-state sequence, prove candidate-to-canonical substantive purity, accept review, or declare Canonicalisation. Those remain human-governed or future implementation responsibilities.


## After accepted review

After the repository owner explicitly declares the exact reviewed candidate canonical:

1. retain the candidate and evidence packages as release provenance;
2. synchronise the accepted candidate contents into the local Git repository;
3. inspect `git status` and the staged delta;
4. commit and push the canonical repository state;
5. confirm that the branch is up to date and the working tree is clean before beginning the next Engineering Increment.

Local uncommitted files are not silently incorporated into Candidate Production: the declared ZIP snapshot is the baseline. A future usability enhancement should report a dirty Git working tree before execution so this separation is visible without changing the baseline gate.
