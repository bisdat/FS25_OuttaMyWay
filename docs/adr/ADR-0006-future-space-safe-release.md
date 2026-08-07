# ADR-0006 — Future Space, Persistent Situation Relevance and Safe Release

Status: Accepted and canonical in v4.6.56; first active implementation candidate v4.6.57

## Context

Temporary v4.6.51–v4.6.55 attempted to activate the recovered v4.6.50 architecture. The work recovered useful mechanisms, including field-boundary evidence, calculated refuge movement, distance/time-derived speed regulation and observed GIANTS handback. It also reproduced the local-fix pattern identified by ADR-0005.

The decisive v4.6.55 TS015 evidence was:

- the first cooperative-passage Commitment completed through observed GIANTS handback;
- a later Commitment was completed when the workers were separating at approximately 80 m and constant-velocity conflict was excluded;
- Condor then entered its next GIANTS headland manoeuvre and turned into Patriot's path;
- a subsequent speed capability was reported `EFFECTIVE` while separation and time-to-closest-approach continued to collapse until both workers were blocked.

Reality therefore disproved two assumptions:

1. current kinematic clearance proves safe continuation;
2. mechanical effectiveness of one capability proves that the Commitment purpose is being achieved.

## Decision

### 1. Future Space is bounded local continuation Knowledge

Situation Assessment shall publish a bounded set of plausible local continuations for every relevant participant. The minimum useful extent is:

```text
current motion
→ next material manoeuvre
→ manoeuvre sweep
→ subsequent trajectory settlement
```

The system does not reconstruct or replace the GIANTS route. It reasons only far enough to decide whether simultaneous local continuation remains admissible.

Where the plausible continuation cannot yet be bounded and that uncertainty is material, the conclusion is `CLEARANCE_UNRESOLVED`, not safe.

### 2. Situation identity persists across relationship changes

`CROSSING`, `PARALLEL`, `SEPARATING`, `MANOEUVRING` and `OPPOSED` are current Knowledge classifications. They do not create or terminate Situation identity.

An Entity remains relevant while its Current Space or any plausible Future Space within the Continuation Safety Horizon can affect another participant's continuation. This is **Persistent Situation Relevance**.

### 3. Intent Expiry is explicit

Previously useful local intent expires when material evidence changes, including a new manoeuvre, changed configuration, changed participation, changed representation fitness or changed Control outcome. Expired intent cannot continue to support a Commitment without reassessment.

### 4. Commitment Preconditions are universal

Before beginning or materially changing a manoeuvre or authority transition, the proposed Future Space must remain admissible in the current Operational Picture.

The rule applies to speed restoration, hold release, refuge entry, refuge exit, rejoin, configuration change, GIANTS handback and unchanged continuation into an approaching manoeuvre.

### 5. `CONTINUE_OBSERVATION` requires a Bounded Observation Contract

`CONTINUE_OBSERVATION` is admissible only when Decision records:

- the material Knowledge gap;
- the Reality evolution expected to resolve it;
- the useful action preserved while waiting;
- the exhaustion condition;
- the reassessment deadline;
- the Progress participant that remains able to generate the evidence.

If waiting consumes the preserved option or no participant can generate the required evidence, observation is inadmissible.

**Encounter Maturation** is one valid use of this contract. Decision may deliberately preserve bounded GIANTS-native progression while an ambiguous interaction is expected to dissolve or become simpler, but only while supported resolution options remain available. Action-Space Compression therefore supplies relevant evidence for the exhaustion condition: maturation must stop being preferred when continued native progression is consuming rather than preserving the Action Space needed for resolution. A familiar head-on is not a required maturation target.

### 6. Capability effectiveness is separate from operational sufficiency

Control reports whether the requested physical command was realised. Situation Assessment interprets the resulting Reality. Decision judges whether that realised change is sufficient for the Commitment purpose.

```text
requested speed achieved
→ capability EFFECTIVE

required temporal reserve still collapsing
→ operationally INSUFFICIENT
→ Commitment REVISE or FAIL
```

### 7. Capability completion is separate from Commitment completion

A Commitment may require several capabilities over time:

```text
REGULATE_SPEED
→ HOLD
→ REPOSITION
→ RESTORE
```

Completion or release of one capability does not complete the governing Commitment.

### 8. Safe Release Point is the only normal completion gate

A Commitment may complete only when every applicable release obligation is positively satisfied:

- intended operational effect achieved;
- realised Control outcome observed;
- no relevant participant blocked;
- relevant Future Spaces clear through the Continuation Safety Horizon;
- material uncertainty resolved;
- restoration cannot immediately recreate the situation;
- independent GIANTS continuation observed.

Current separation, negative closing rate, a constant-velocity `CLEAR/EXCLUDED` result or one completed capability is insufficient by itself.

### 9. Failure remains operationally relevant

When Action Space is exhausted or participants become blocked, the Situation does not become `NORMAL_OPERATION`. The Commitment must revise to an admissible recovery, remain failed but relevant, or escalate because no authorised recovery exists.

## Named discoveries

### Transient Clearance

Current trajectories are clear or separating while plausible near-term continuations remain mutually unsafe.

### Capability Effectiveness–Operational Sufficiency Separation

A Control capability may physically achieve its command without achieving the governing Commitment's operational purpose.

### Capability Completion–Commitment Completion Separation

A completed Control capability does not complete the persistent intent that requested it.

## Consequences

- Intent Expiry, Safe Release Point and Continuation Safety Horizon move from Deferred to Accepted architecture.
- Persistent Situation Relevance and Commitment Preconditions become explicit governing contracts.
- Constant-velocity clearance remains useful Knowledge but cannot independently authorise completion.
- Relationship-label changes cannot fragment one continuing Situation into fixture-shaped episodes.
- The next implementation must enforce this contract generically before any further TS015/TS016 local correction.
- TS015 remains the first validation fixture because it is familiar and repeatable; it does not define the rule.
- Multiple combines, combine unloading, cross-field coordination and general route planning remain permanently excluded.

## Validation obligations for the next implementation

The next active candidate must demonstrate that:

1. one Situation identity persists through changing relationship classifications;
2. Future Space includes the next material manoeuvre and settlement where locally observable;
3. an effective but insufficient capability forces Commitment revision;
4. `CONTINUE_OBSERVATION` cannot exist without a bounded observation contract;
5. Commitment completion cannot occur before the Safe Release Point gate passes;
6. blockage or exhausted Action Space cannot silently return to normal operation;
7. the same implementation contract is exercised by TS015, TS015b, TS016 and TS016b without fixture-specific Decision branches.


## Subsequent amendments

ADR-0007 clarifies that the restoration obligation belongs to the Commitment while configuration actuation may be delegated to GIANTS under a separately retained movement constraint. This preserves ADR-0006 Safe Release and capability-separation rules.

ADR-0022 adds Bounded Native Intent Revelation. Where a held participant's actual post-intervention Local Intent cannot be known without GIANTS movement, a retained Commitment may acquire that evidence through independently admissible bounded native progression rather than reconstructing the GIANTS route. The resulting intent evidence triggers reassessment; it does not itself satisfy the Safe Release Point.

ADR-0023 refines the Continuation Safety Horizon as Encounter-relative. It must cover unresolved continuation consequences materially belonging to the current Encounter and its interventions, but it does not roll indefinitely through every later manoeuvre of every still-active participant. `SETTLED_CONTINUATION` is a lifecycle/evidence condition, not clearance; positive spatial compatibility with the other participant's occupancy/Action Space remains separately required. Later materially new convergence after true Safe Release is handled through a fresh Encounter under ADR-0012.

## v4.6.71 implementation boundary

This ADR remains canonical architecture. v4.6.71 does not claim that the v4.6.57–v4.6.70 implementations satisfy it; they remain evidence used to refine its preconditions and Safe Release semantics.

## v4.7.29 amendment — staged recovery and terminal release evidence

A successful refuge passage does not itself satisfy Safe Release. Decision may admit bounded Yield ingress/restoration while the governing Commitment remains active. Each admitted recovery stage establishes current Committed Demand that must remain compatible with the Progress participant's supported demand until that stage completes, is superseded or is revoked.

Safe Release for the ordinary two-worker recovery requires fresh current evidence after material Control/configuration changes. Pre-restoration BNIR intent is not presumed authoritative through re-Hold/restoration. Native Handover must reacquire operational Local Intent and demonstrate independent GIANTS continuation; only then can Decision positively establish that supported Encounter-relative demand is decoupled and all applicable obligations are settled.

A supporting speed restriction is not itself a release obligation and must not outlive its named current purpose.

## v4.7.32 amendment — Apparent Departure Reversal

Prototype 21 live evidence adds a concrete native counterexample to release-by-separation. During Transitional Continuation, GIANTS may increase separation and then reverse the same worker back into recently vacated space to satisfy remaining productive demand. Condor and Valtra transition segments both demonstrated forward/reverse course behaviour while the Job Episode remained active.

This **Apparent Departure Reversal** evidence does not create a new release rule; it strengthens ADR-0006. Increasing separation, negative closing rate, visual departure or a currently non-productive transition cannot independently retire Future-Space relevance or satisfy Safe Release. Positive obligation retirement and current applicable continuation evidence remain required.
