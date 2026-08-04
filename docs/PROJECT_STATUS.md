# Project Status

Version: 4.6.56 Future-Space and Safe-Release Contract Candidate  
Canonical implementation authority: owner-declared v4.6.50, SHA-256 `a7d6fbde4da9299878926a7d54b29f9665ee4269107f748ff180ba833ead4392`, Git commit `18dc8338ee5e442a5097a366a80c1ac69ad29c4f`  
Candidate baseline: exact canonical v4.6.50  
Authority state: Release Candidate proposed for owner review; not canonical until explicit owner declaration  
Runtime behaviour: unchanged from canonical v4.6.50  
Runtime evidence environment: FS25 1.21.1.0 build b40785 revision 81824 unless the test record states otherwise

## Current engineering phase

The project is paused at **Future-Space and Safe-Release Contract Consolidation**.

Temporary v4.6.51–v4.6.55 activated parts of the recovered architecture and demonstrated one successful TS015 cooperative passage through observed GIANTS handback. They also reproduced fixture-led correction pressure. The decisive v4.6.55 evidence showed that a Commitment could complete on current separation and later be recreated when Condor's next GIANTS headland manoeuvre entered Patriot's path. A speed capability could be mechanically effective while the operational reserve continued to collapse.

v4.6.56 records the generic architecture correction and does not promote the temporary runtime implementation.

## Governing architecture

```text
Reality
→ Observation Adapters
→ Situation Assessment
→ Operational Picture
→ Decision Evaluation
→ Commitment Ledger
→ bounded Control
→ Reality
→ Outcome Observation
```

The complete map is [`ARCHITECTURE_FLOW.md`](ARCHITECTURE_FLOW.md).

## Accepted contract

- **Bounded local Future Space:** through the next material manoeuvre, its sweep and subsequent trajectory settlement; not general route planning.
- **Persistent Situation Relevance:** relationship-label changes do not end one continuing Situation.
- **Intent Expiry:** changed manoeuvre, configuration, participation, representation or Control outcome invalidates stale local intent.
- **Commitment Preconditions:** every material manoeuvre or authority transition requires admissible proposed Future Space.
- **Bounded Observation Contract:** `CONTINUE_OBSERVATION` must preserve a useful option and name its Knowledge gap, evidence source, exhaustion condition and reassessment deadline.
- **Capability Effectiveness–Operational Sufficiency Separation:** realised command response is not proof that the Commitment purpose is being achieved.
- **Capability Completion–Commitment Completion Separation:** one completed capability does not complete persistent intent.
- **Safe Release Point:** normal Commitment completion requires positive continuation clearance through the Continuation Safety Horizon and observed independent GIANTS continuation.
- **Failure remains relevant:** blockage or exhausted Action Space cannot silently become normal operation.

## Evidence interpretation

### Supported

- The recovered architecture can execute a full cooperative-passage sequence in the bounded Condor/Patriot fixture.
- Field-boundary evidence, calculated refuge motion, distance/time speed regulation and observed GIANTS handback are useful capability evidence.
- Current separation and constant-velocity conflict exclusion do not prove safe continuation.
- A mechanically effective speed command can be operationally insufficient.

### Not promoted

- v4.6.51–v4.6.55 runtime modules;
- TS015-specific parallel-headway policy;
- any fixture-specific Decision branch;
- any claim that TS015 as a whole is solved.

## Permanent scope exclusions

- multiple combines;
- combine unloading;
- cross-field coordination;
- general route planning.

Completed-worker static-obstacle navigation and arbitrary modded assembly support remain possible future, separately governed work.

## Immediate next objective after Canonicalisation

Implement ADR-0006 against the recovered architecture in one generic vertical slice:

1. persistent Situation identity across relationship changes;
2. bounded local manoeuvre Future Space;
3. explicit operational-sufficiency assessment;
4. Bounded Observation Contract enforcement;
5. Safe Release Point completion gate;
6. failure aftermath that remains augmentation-relevant.

TS015 is the first validation fixture because it is familiar and repeatable. TS015b, TS016 and TS016b then validate the same contract. No fixture-specific rule is permitted to define the implementation.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` still acts as an engineering-candidate summary. Before publication readiness, restore it to a stable public description and keep increment-specific reporting in the changelog and engineering documents.
