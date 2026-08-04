# Architecture Flow

> **Authority:** Governing driving-system responsibility map
>
> **Currency:** Future-Space and Safe-Release Contract Candidate v4.6.56
>
> **Runtime note:** v4.6.56 changes documentation and version identity only. Temporary v4.6.51–v4.6.55 active implementations are evidence and are not promoted.

```text
┌──────────────────────────────────────────────────────────────┐
│                           REALITY                            │
│  GIANTS workers, vehicles, implements, field, obstacles,    │
│  motion, configuration and realised Control outcomes        │
└──────────────────────────────┬───────────────────────────────┘
                               │ sampled/exposed
                               ▼
┌──────────────────────────────────────────────────────────────┐
│                    OBSERVATION ADAPTERS                      │
│  Runtime state │ geometry │ environment │ Control feedback  │
└──────────────────────────────┬───────────────────────────────┘
                               │ factual, sourced observations
                               ▼
┌──────────────────────────────────────────────────────────────┐
│                    SITUATION ASSESSMENT                      │
│                                                              │
│  ┌─────────────────┐  ┌─────────────────┐                   │
│  │ Assembly and    │  │ Motion and      │                   │
│  │ representation  │  │ relationship    │                   │
│  │ assessment      │  │ assessment      │                   │
│  └─────────────────┘  └─────────────────┘                   │
│                                                              │
│  ┌─────────────────┐  ┌─────────────────┐                   │
│  │ Space and       │  │ Constraint and  │                   │
│  │ Future Space    │  │ outcome         │                   │
│  │ assessment      │  │ assessment      │                   │
│  └─────────────────┘  └─────────────────┘                   │
└──────────────────────────────┬───────────────────────────────┘
                               │ produces Knowledge
                               ▼
┌──────────────────────────────────────────────────────────────┐
│                    OPERATIONAL PICTURE                       │
│                                                              │
│  Current Situation                                           │
│  Field World membership and participation                    │
│  assemblies, relationships and Situation Relevance           │
│  Current/Future Spaces and reserves                          │
│  constraints and representation fitness                      │
│  uncertainty, provenance and material change                 │
└──────────────────────────────┬───────────────────────────────┘
                               │ one coherent revision
                               ▼
                 ┌─────────────────────────────┐
                 │       DECISION ENGINE       │
                 │                             │
                 │  ┌───────────────────────┐  │
                 │  │  DECISION EVALUATION  │◄─┼──────────────┐
                 │  │                       │  │              │
                 │  │ evaluate current      │  │              │
                 │  │ Commitment            │  │              │
                 │  │ evaluate unchanged    │  │              │
                 │  │ continuation          │  │              │
                 │  │ generate/evaluate     │  │              │
                 │  │ candidate actions     │  │              │
                 │  │ apply sufficiency     │  │              │
                 │  │ apply admissibility   │  │              │
                 │  │ compare effective     │  │              │
                 │  │ augmentations         │  │              │
                 │  └───────────┬───────────┘  │              │
                 └──────────────┼──────────────┘              │
                                │ lifecycle conclusion          │
                                │ CREATE / MAINTAIN / REVISE    │
                                │ COMPLETE / CANCEL / FAIL      │
                                ▼                               │
┌──────────────────────────────────────────────────────────────┐
│                     COMMITMENT LEDGER                        │
│                                                              │
│  purpose │ scope │ obligations │ relied-upon Knowledge       │
│  validity conditions │ intended effect │ release/recovery    │
└──────────────────────────────┬───────────────────────────────┘
                               │ bounded capability request
                               ▼
┌──────────────────────────────────────────────────────────────┐
│                         CONTROL                              │
│                                                              │
│  speed regulation │ hold │ native reposition │ configuration │
│  authority lease │ execution state │ restoration/handback   │
└──────────────────────────────┬───────────────────────────────┘
                               │ changes Reality
                               ▼
                            REALITY
                               │
                               └──── realised outcomes return
                                     through Observation



Observation reports what Reality exposed.

Situation Assessment determines what the evidence means.

Operational Picture publishes one coherent understanding.

Decision Engine determines what should be done.

Decision Evaluation performs one temporary assessment.

Commitment preserves selected intent over time.

Control executes only bounded, admissible capability requests.

Outcome Observation returns realised behaviour to Situation Assessment.
```

## Governing lifecycle rule

The flow is closed by Outcome Observation, but the lifecycle is governed by Commitment rather than by one Control capability:

```text
Relevant Situation
→ Commitment CREATE
→ capability REQUESTED / ACKNOWLEDGED / EFFECTIVE / COMPLETED or FAILED
→ Situation Assessment interprets realised effect
→ Decision judges operational sufficiency
→ Commitment MAINTAIN / REVISE / COMPLETE / CANCEL / FAIL
```

A capability may be mechanically effective and still operationally insufficient. A capability may complete while the governing Commitment remains active and requests a different capability.

## Future-Space responsibility

Situation Assessment publishes bounded plausible local continuations through each relevant participant's next material manoeuvre and subsequent trajectory settlement. This is not route planning. It is the minimum local continuation Knowledge required to determine whether simultaneous GIANTS continuation remains admissible.

## Safe-release responsibility

Decision may complete a Commitment only when the Safe Release Point gate is positively satisfied. Current separation, negative closing rate, a `CLEAR` constant-velocity prediction or completion of one actuator phase is insufficient by itself.

## Observation responsibility

`CONTINUE_OBSERVATION` is an active Decision only when it declares:

- the unresolved material Knowledge;
- the expected evidence source;
- the useful action preserved while waiting;
- the exhaustion condition;
- the reassessment deadline;
- the participant that remains able to generate the evidence.

Without that bounded contract, passive observation is not admissible.
