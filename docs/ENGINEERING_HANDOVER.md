# Engineering Handover

> **Candidate:** v4.7.1 Observation and Job Episode Identity  
> **Implementation baseline:** canonical v4.7.0  
> **Architecture authority:** canonical v4.6.78

## Repository boundary

Active `scripts/` is the replacement core. The exact former tree remains under `scripts/archive/v4_6_78/` and cannot execute.

Do not:

- import archived modules;
- infer Job Episode meaning from old observer code;
- connect v4.7.1 to a live GIANTS update loop;
- add Situation Assessment, Decision or Control to this increment;
- treat absence, blockage, Hold or temporary inactivity as Job Episode termination.

## Current foundation

The Runtime now instantiates:

- stable assembly/component identity resolution;
- raw Observation Snapshot publication;
- Job Episode admission and lifecycle evidence classification;
- the canonical v4.7.0 Commitment, Obligation and authority structural kernel.

It registers no game listener and issues no physical command.

Expected optional game-load log:

```text
FS25_OuttaMyWay v4.7.1 observation/identity foundation loaded; Control authority disabled
```

## Validation before canonicalisation

- deterministic RRS candidate production;
- active-tree dependency audit;
- Lua integrated-load and conformance tests;
- Python structural tests;
- archive byte verification;
- Observation semantic-exclusion tests;
- all canonical Job Episode continuation and termination fixtures.

A live FS25 cycle is not required because no runtime sampling hook or gameplay behaviour has changed.

## Next increment after canonicalisation

Implement Situation Assessment, Operational Picture publication, complete Candidate Action Space, mandatory Constraint Verdicts and deterministic Decision selection using only sealed fixture inputs. Control remains disabled.
