# Engineering Handover

> **Candidate:** v4.7.0 Replacement-Core Bootstrap  
> **Architecture authority:** canonical v4.6.78

## Repository boundary

Active `scripts/` is the new replacement core. The exact former tree is preserved under `scripts/archive/v4_6_78/` and cannot execute.

Do not:

- restore the archived loader;
- import archived modules;
- infer architectural meaning from old code;
- add GIANTS Observation or Control to v4.7.0;
- add a fourth non-terminal Commitment state, another terminal disposition or another obligation settlement mode.

## Current kernel

The active Runtime instantiates identity, epoch, Commitment, Obligation, authority and trace services only. It registers no game listener and issues no physical command.

Expected game log:

```text
FS25_OuttaMyWay v4.7.0 inert replacement core loaded; Control authority disabled
```

## Validation before canonicalisation

- deterministic RRS candidate production;
- archive byte verification;
- active-tree dependency audit;
- Lua syntax/load and conformance tests;
- Python structural tests;
- RRS test suite;
- one basic FS25 mod-load confirmation.

## Next increment after canonicalisation

Implement clean runtime Observation records and Job Episode identity/admission evidence without Decision or Control authority. No old observer module is imported wholesale.
