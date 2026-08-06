# Engineering Handover

> **Candidate:** v4.7.2 Operational Picture  
> **Implementation baseline:** canonical v4.7.1  
> **Architecture authority:** canonical v4.6.78

## Repository boundary

Active `scripts/` is the replacement core. The exact former tree remains under `scripts/archive/v4_6_78/` and cannot execute.

Do not:

- import archived modules;
- infer Knowledge or fitness from old observer/controller code;
- connect v4.7.2 to a live GIANTS update loop;
- add Candidate, Decision or Control responsibilities to Situation Assessment;
- treat missing Operation membership evidence as membership zero;
- represent unknown or partial geometry as smaller or exact.

## Current foundation

The Runtime accepts sealed fixture input and performs:

```text
Observation Snapshot
    → Job Episode admission
    → Operation admission
    → Situation Assessment
    → immutable Operational Picture
```

The Operational Picture publishes identities, relationships, spaces, demand classes, responsibility Knowledge, uncertainty, Representation Fitness, outcome evidence and read-only Commitment context. It registers no game listener and issues no physical command.

Expected optional game-load log:

```text
FS25_OuttaMyWay v4.7.2 Operational Picture foundation loaded; Control authority disabled
```

## Validation before canonicalisation

- deterministic RRS candidate production;
- active-tree dependency audit;
- Lua integrated-load and conformance tests;
- Python structural tests;
- archive byte verification;
- Operation identity and membership fixtures;
- snapshot-to-picture deterministic tests;
- all five canonical Representation Fitness states;
- No Silent Under-Approximation assertions;
- no Candidate, Decision or Control implementation.

A live FS25 cycle is not required because no runtime sampling hook or gameplay behaviour has changed.

## Next increment after canonicalisation

Implement the complete supportable Candidate Action Space, explicit mandatory Constraint Verdicts and deterministic Decision Records using only sealed Operational Picture fixtures. Control remains disabled.
