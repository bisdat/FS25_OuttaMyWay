# Engineering Handover

## Current candidate: v4.6.56

v4.6.56 begins from exact owner-declared canonical v4.6.50 (`a7d6fbde4da9299878926a7d54b29f9665ee4269107f748ff180ba833ead4392`, Git `18dc8338ee5e442a5097a366a80c1ac69ad29c4f`).

It is a documentation-governance candidate. Runtime behaviour remains canonical v4.6.50. Temporary v4.6.51–v4.6.55 implementation is not promoted.

## Why this contract was required

The temporary active path recovered useful mechanisms and achieved one complete TS015 cooperative passage. The later continuation disproved fixture-led completion logic:

- `CM-00002` completed when current motion was separating at approximately 80 m;
- Condor's next GIANTS headland manoeuvre then entered Patriot's path;
- `CM-00003` reported speed regulation `EFFECTIVE` while distance and time reserve continued to collapse;
- both workers became blocked.

The missing responsibility was not another TS015 trigger. It was a generic Future-Space and Commitment-release contract.

## Governing decisions

Read in this order:

1. [`adr/ADR-0006-future-space-safe-release.md`](adr/ADR-0006-future-space-safe-release.md)
2. [`ARCHITECTURE_FLOW.md`](ARCHITECTURE_FLOW.md)
3. [`ARCHITECTURE.md`](ARCHITECTURE.md)
4. [`PROJECT_STATUS.md`](PROJECT_STATUS.md)

The accepted rules are:

- Future Space extends through the next material local manoeuvre and subsequent trajectory settlement.
- Situation identity persists across relationship-label changes.
- Intent Expiry invalidates stale local continuation evidence.
- Commitment Preconditions govern every material transition.
- `CONTINUE_OBSERVATION` requires a Bounded Observation Contract.
- Control effectiveness and operational sufficiency are separate conclusions.
- Control capability completion and Commitment completion are separate lifecycles.
- Safe Release Point is the only normal Commitment-completion gate.
- failed or blocked Reality remains augmentation-relevant.

## Continuation after owner review

If the owner declares this exact candidate canonical:

1. synchronise the package into local and GitHub repositories;
2. record its SHA-256 and Git commit;
3. begin the next increment from v4.6.56 canonical;
4. design the implementation against ADR-0006 before changing Control behaviour;
5. preserve useful v4.6.51–v4.6.55 mechanisms only as Observation adapters or bounded Control capabilities;
6. validate first with TS015, then with TS015b, TS016 and TS016b against the same generic contract.

Do not add a special rule for the second TS015 headland, a longer hold, a new distance threshold or a fixture-specific relationship sequence. Any implementation proposal must state which ADR-0006 obligation it fulfils.

## Permanent scope exclusions

- multiple combines;
- combine unloading;
- cross-field coordination;
- general route planning.

## Deferred Publication Readiness Review

**Mod Description Drift:** restore `modDesc.xml` to a stable public description before publication.
