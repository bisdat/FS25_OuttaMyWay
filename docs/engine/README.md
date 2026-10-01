# Engine Knowledge

This subtree records reusable FS25/GIANTS behaviour and API/surface knowledge
established through runtime observation, supplied SDK inspection, asset
inspection, or validated implementation use.

It does not define OuttaMyWay architecture, grant runtime authority, replace
the Decision Log, Engineering Journal, or research evidence, or claim to be a
complete FS25 API reference. Engine behaviour and architectural permission are
separate responsibilities.

## Versioned evidence

Engine knowledge is version-sensitive evidence. When the exact FS25 runtime or
inspected source-package version is known, durable findings should identify that
baseline rather than using an unqualified "current FS25". Live Reality evidence
should retain Game-Version and, when available, Build-Id / Build-Revision;
source inspection should retain the inspected package version.

A game/runtime update is a revalidation trigger for assumptions and engine
surfaces that can materially affect the claim. It does not automatically
invalidate every earlier finding. Validation breadth remains causal as defined
by [Testing Methodology](../TESTING_METHODOLOGY.md).

## Breadcrumbs

- [GIANTS Runtime Knowledge](GIANTS_RUNTIME_KNOWLEDGE.md) — what observed
  engine behaviour means, and what it does not establish.
- [GIANTS API Surfaces](GIANTS_API_SURFACES.md) — observed and inspected engine
  fields, methods, helpers, and their interpretation limits.
