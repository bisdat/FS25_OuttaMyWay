# Engineering Handover

> **Candidate:** v4.7.4 Replay Conformance  
> **Implementation baseline:** canonical v4.7.3  
> **Architecture authority:** canonical v4.6.78

## Repository boundary

Active `scripts/` is the replacement core. The exact former tree remains under `scripts/archive/v4_6_78/` and cannot execute.

Do not:

- import archived modules;
- infer replay facts from legacy branches;
- connect v4.7.4 to a live GIANTS update loop;
- treat documented reconstruction as physics simulation;
- add Control dispatch to the replay runner;
- waive open obligations or existing progress ownership during settlement.

## Current foundation

v4.7.4 executes the canonical offline composition:

```text
sealed Observation / Operational Picture
    → complete Candidate and mandatory Verdicts
    → deterministic Decision
    → enforcing Commitment reaction
    → Obligation and authority history
    → replay conformance or earliest divergence
```

Expected optional game-load log:

```text
FS25_OuttaMyWay v4.7.4 replay-conformance foundation loaded; Control authority disabled
```

## Validation before canonicalisation

- all documented replay fixtures pass twice from fresh Runtime state with byte-identical records;
- v4.6.77 illegal completion and duplicate responsibility are rejected;
- v4.6.57 and v4.6.70 evidence wait rather than manufacture success;
- v4.6.64 completes only after all obligations settle;
- TS016 enforces Follower Owns Closure;
- player takeover and Operation termination preserve internal responsibility;
- no GIANTS listener or physical Control path exists.

## Next increment after canonicalisation

Implement passive live validation with zero replacement Control authority. Live observations are compared against canonical trace contracts, not against the archived Decision core.
