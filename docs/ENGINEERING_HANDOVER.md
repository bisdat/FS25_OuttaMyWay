# Engineering Handover

> **Candidate:** v4.7.3 Deterministic Decision Boundary  
> **Implementation baseline:** canonical v4.7.2  
> **Architecture authority:** canonical v4.6.78

## Repository boundary

Active `scripts/` is the replacement core. The exact former tree remains under `scripts/archive/v4_6_78/` and cannot execute.

Do not:

- import archived modules;
- infer candidates or constraints from legacy branches;
- connect v4.7.3 to a live GIANTS update loop;
- allow Candidate generation to select;
- allow Decision to waive `FAIL` or `UNRESOLVED`;
- mutate Commitment state or issue Control from the v4.7.3 Decision path.

## Current foundation

The Runtime accepts a sealed Operational Picture whose candidate-support evidence explicitly declares the complete support boundary and performs:

```text
Operational Picture
    → complete Candidate Action inventory
    → complete mandatory Constraint Verdict Set
    → deterministic Decision Record
```

The Decision Record selects only an all-`PASS` candidate or publishes explicit non-intervention. Control authority remains disabled.

Expected optional game-load log:

```text
FS25_OuttaMyWay v4.7.3 deterministic Decision foundation loaded; Control authority disabled
```

## Validation before canonicalisation

- deterministic RRS candidate production;
- active-tree dependency audit;
- Lua integrated-load and conformance tests;
- Python structural tests;
- archive byte verification;
- complete Candidate inventory assertions;
- all eleven mandatory verdict families for every candidate;
- failed and unresolved candidate exclusion;
- Follower Owns Closure, Representation Fitness, Bounded Observation and `never hold all` negative tests;
- deterministic Decision selection;
- no Commitment mutation or Control implementation.

A live FS25 cycle is not required because no runtime sampling hook or gameplay behaviour has changed.

## Next increment after canonicalisation

Implement the replay-conformance gate using historical positive and negative evidence. The replay runner verifies architecture composition only and receives no physical authority.
