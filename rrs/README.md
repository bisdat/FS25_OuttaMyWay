# Repository Release System

This directory contains the repository-owned implementation of the OuttaMyWay Repository Release System.

The RRS creates a complete candidate from an exact canonical ZIP and a declarative JSON release plan. It records the baseline fingerprint, applies controlled transformations, regenerates the release manifest, compares declared intent with observed effect, classifies repository findings relative to the baseline, and produces deterministic candidate and evidence ZIPs.

## Usage

```text
python -m rrs.rrs build --baseline CANONICAL.zip --plan release-plan.json --output out
```

A build is blocked when:

- the supplied canonical fingerprint does not match the declared baseline;
- a declared change is missing;
- an undeclared change appears;
- the candidate introduces a repository violation;
- the release manifest is invalid;
- the resulting version does not match the target version.

The evidence package contains the release plan, baseline and candidate inventories, observed delta, classified findings, validation report, package fingerprints, and the exact RRS source used for the build.
