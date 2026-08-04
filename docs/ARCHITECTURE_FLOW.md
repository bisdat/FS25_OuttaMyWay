## v4.6.71 active flow and experimental boundary

```text
active runtime: v4.6.56
        ↓
normal v4.6.56 Observation / Decision / Control behaviour

repository knowledge: ADR-0006–ADR-0018
        ↓
next Observe → Discuss → Hypothesise cycle
        ↓
future isolated implementation candidate
```

The historical flows below record attempted compositions. They are evidence and design knowledge, not executable v4.6.71 authority.

## Historical v4.6.70 leg orientation and coherent Hold flow

```text
leg start anchored
→ ORIENTATION ENVELOPE
   fixed target; bounded time/travel/reverse lateral
→ positive refuge-side progress
→ directional fence armed
→ leg target reached

Hold lease active
→ project native post-release motion
   unsafe/unresolved: maintain same lease
   admissible and stable: RESTORE once
→ observe independent GIANTS continuation
```

## v4.6.69 settled-pose transition-frame flow

```text
leg 1 SETTLED
→ calculate replacement from current Reality
→ publish exact transition start pose
→ validate endpoint + path + time + frame closure
→ Control verifies start-pose freshness
   stale/unresolved: retain current refuge unchanged
   verified: atomically commit target + side + leg-local anchor
→ leg 2 ACTIVE
→ settle and reassess
```

## v4.6.68 manoeuvre-leg flow

```text
continuous Knowledge updates
→ current refuge leg ACTIVE
   → better candidate: advisory only; mark reassessment pending
   → demonstrated loss of admissibility: separate interruption authority
→ current refuge leg SETTLED
   → reassess from current pose
   → current refuge viable: remain
   → replacement transition viable: atomically commit one next leg
→ repeat until passage and Safe Release
```

## v4.6.66 provisional-refuge flow

## v4.6.67 atomic refuge-transition flow

```text
fresh candidate geometry
→ endpoint viable
→ assess current-pose transition
   path clear + field-contained + Progress-preserving
   required Control time <= available temporal reserve
→ unsafe/unresolved: retain current refuge; temporal support only when admissible
→ viable: Decision authorises exact candidate
          → Control validates same evidence
          → atomically commit target and side frame
          → authorised side transition uses temporary fence frame
→ continue passage assessment
```

```text
select viable refuge
→ move and occupy provisional refuge
→ observe current pair intent
→ material intent change?
    no: continue passage observation
    yes: invalidate refuge assessment cache
         → reassess current-role candidates from current Reality
         → current refuge still viable: remain
         → material additional travel required: revise same Commitment
              → continue movement from current pose
→ supporting speed remains purpose-bound while viability/passage unresolved
→ positive passage
→ work restoration and Native Handover
→ Safe Release
```

## v4.6.65 repeated-Encounter flow

```text
Persistent Situation
→ Encounter EN-n / Commitment CM-n
→ material manoeuvre creates Intent Expiry
→ Option Preservation Window
→ supporting REGULATE_SPEED or safe wait
→ refuge only if temporal shaping is insufficient
→ work restoration and native handover
→ Safe Release completes EN-n
→ later material manoeuvre creates EN-(n+1)
→ roles and options reassessed from current Reality
```

## v4.6.64 TS015 lifecycle

```text
Situation admission
→ Yield/Progress Commitment
→ capture dynamic configuration
→ compact and refuge
→ positive passage
→ approximate Native Handover Envelope
→ stop under temporary Control
→ restore owned fold/lowered/work mutations
→ verify work-capable state
→ relinquish authority
→ bounded NO_PHYSICAL_CONTROL observation
→ independent GIANTS continuation
→ Safe Release
```

## v4.6.63 identity/value flow

```text
Job start → stable physical facts captured once → immutable Knowledge values
Runtime observation → live vehicle identity reference retained without traversal
Decision → explicit value snapshot + named identity references
Commitment → independent value snapshot + exact identity references
Control → addresses the live assembly through identity only
```

## v4.6.62 authority-release boundary

```text
Control acquires vehicle-specific permission interception
→ hold is exercised
→ release condition occurs
→ hold record is removed
→ exact pre-intervention permission method is restored
→ configuration bookkeeping is relinquished without actuation
→ Native Handover / normal Situation Assessment
```

Command release and execution-path restoration are separate obligations.

# Architecture Flow


## v4.6.60 Native Handover flow

```text
Operational Picture identifies admissible refuge need
        ↓
Decision grants NATIVE_REPOSITION
        ↓
Control clears conflict and enters refuge
        ↓
Observation establishes positive passage
        ↓
Control performs purpose-derived approximate return
        ↓
Native Handover Envelope passes
        ↓
Control removes movement + configuration + job-progression constraints without restarting GIANTS
        ↓
GIANTS owns exact recovery
        ↓
Control-to-Awareness Reversion
        ↓
Normal Situation Assessment updates the Operational Picture
        ↓
Decision maintains, revises or completes the same Commitment through Safe Release
```

There is no active delegated-configuration Restore sequence, translation lease, deployment controller, `aiContinue`/continuation-event restart burst, retry or nudge in this path.

## v4.6.59 translation-authority amendment

Reality disproved the assumption that the Traffic Permission Gate constrains translation only. ADR-0008 separates configuration authority, translation authority and field-worker progression authority. Delegated restoration now enables GIANTS field-worker progression under a separate reversible zero-speed translation lease. Terminal restoration failure is inert. A future unrestricted return-to-GIANTS architecture remains explicitly undecided.

> **Authority:** Governing driving-system responsibility map
>
> **Currency:** Translation-Authority Separation Candidate v4.6.59
>
> **Runtime note:** v4.6.59 retains the generic ADR-0006/ADR-0007 slice and implements ADR-0008 by enabling GIANTS field-worker progression under a separate reversible zero-speed translation lease.

## Restore capability authority sequence

```text
NATIVE_REPOSITION position achieved
→ Commitment REVISE to RESTORE
→ acquire zero-speed translation authority lease
→ return configuration authority to GIANTS
→ release the Traffic Permission Gate
→ request native continuation once
→ observe stable native configuration while translation remains constrained
→ restore normal translation authority on a later update
→ observe sustained continuation
→ Safe Release remains a separate Decision conclusion
```

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
