# Repository Release System — Legacy Tooling

> **Status:** The implementation in this directory is legacy tooling retained pending an independent tooling audit. Its package-transform workflow is no longer the project's engineering or canonicalisation process. Current governance lives in [Engineering Architecture](../docs/ENGINEERING_ARCHITECTURE.md).

Do not use `rrs evolve` or `rrs build` for normal Engineering Increments or Canonical Merge. Current engineering evolves clean/current `main` through short-lived branches and reviewed pull requests. Only the repository owner's merge of an explicitly designated Release Declaration PR can declare a named canonical Git checkpoint; no RRS run can confer that authority.

The commands and implementation notes below document the existing tool and support explicit legacy-tool investigation only. They do not define a replacement packaging workflow. A later audit will determine whether individual capabilities should be kept, merged, extracted or deleted.

## Existing commands

The legacy repository-evolution command accepts a canonical ZIP baseline and declarative JSON handoff:

```text
python -m rrs evolve --baseline CANONICAL.zip --handoff release-plan.json --output out
```

The lower-level compatibility command builds directly from a plan:

```text
python -m rrs build --baseline CANONICAL.zip --plan release-plan.json --output out
```

These commands verify their declared baseline, apply controlled transformations, regenerate the legacy release manifest, compare declared intent with observed effects, classify findings and produce candidate/evidence packages. Those behaviours describe the retained implementation; they are not current repository governance.

The tool blocks a build when its baseline fingerprint does not match, a declared change is missing, an undeclared change appears, a candidate violates its encoded repository rules, its release manifest is invalid, or the resulting version does not match its target.

## Existing determinism model

For the same baseline ZIP and handoff JSON, the implementation attempts to emit the same candidate SHA-256 across supported platforms through:

- relative POSIX-path ordering shared by inventory, manifest and ZIP packaging;
- fixed timestamps and explicit UNIX-origin ZIP metadata;
- fixed regular-file permissions; and
- stored ZIP entries rather than platform-dependent compression.

Evidence ZIPs retain run provenance and need not be byte-identical, but the implementation expects them to name the same candidate fingerprint and substantive findings.

These package properties do not create or identify current canonical source authority.

## Existing workspace lifecycle

Each run creates `rrs_workspace` beneath its output directory.

- PASS: candidate and evidence packages are written, then the workspace is removed.
- Validation block: evidence is packaged and the workspace is retained for diagnosis.
- Execution failure: failure evidence is packaged and the workspace is retained for diagnosis.

A retained workspace is not overwritten implicitly. Repository text is processed as strict UTF-8; invalid encoding is recorded as execution failure.

## Audit boundary

Do not modify or invoke this tooling merely because a normal Engineering Increment or release declaration is underway. Use it only when an explicit task is investigating the legacy implementation itself.

The future tooling audit may classify capabilities as KEEP, MERGE, EXTRACT or DELETE. This README does not prejudge that outcome and no code or tests are changed by the governance retirement.
