# Architecture Flow

> **Authority:** Normative replacement-core responsibility and lifecycle map
>
> **Currency:** D-0142 Field World / Chessboard Architecture Consolidation; owner-declared canonical v4.7.76 is the implementation baseline
>
> **Implementation status:** v4.7.77 is architecture/documentation only. The v4.7.76 runtime remains the implementation baseline and is not claimed to conform yet to D-0142. P22/head-on/follower/Guarded-Recovery paths are legacy implementation evidence pending alignment.

## 1. Closed-loop responsibility flow

```text
┌─────────────────────────────────────────────────────────────┐
│                           REALITY                           │
│ GIANTS jobs, assemblies, Field World, motion/configuration │
│ and realised physical effects                              │
└──────────────────────────────┬──────────────────────────────┘
                               │ sampled
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                         OBSERVATION                         │
│ raw facts │ time │ source │ provenance │ uncertainty       │
└──────────────────────────────┬──────────────────────────────┘
                               │ interpreted
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    SITUATION ASSESSMENT                     │
│ Field World │ Productive Regime/Rook │ productive history  │
│ Successor Rook Set │ Transitional Demand │ configuration RF │
│ relevance │ King Reserve │ Resolution-Space state          │
└──────────────────────────────┬──────────────────────────────┘
                               │ publishes Knowledge
                               ▼
┌─────────────────────────────────────────────────────────────┐
│               OPERATIONAL PICTURE KNOWLEDGE                 │
│ immutable current supported interpretation + provenance    │
│ no Candidate specifications or mandatory verdicts          │
└──────────────────────────────┬──────────────────────────────┘
                               │ enumerated
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                  CANDIDATE ACTION SPACE                     │
│ complete supportable actions; no selection or PASS authoring│
└──────────────────────────────┬──────────────────────────────┘
                               │ independently gated
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                  MANDATORY CONSTRAINTS                      │
│ phase fitness │ containment │ demand/obligation compatibility│
│ capability │ authority composition                         │
└──────────────────────────────┬──────────────────────────────┘
                               │ admissible alternatives
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                  TRAFFIC POLICEMAN / DECISION               │
│ temporary ordering │ Conflict Serialization │ admission     │
│ selects action; does not actuate                            │
└──────────────────────────────┬──────────────────────────────┘
                               │ creates/revises
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 COMMITMENT + OBLIGATIONS                    │
│ Governing Basis │ durable selected relation │ Committed Demand│
│ lifecycle │ obligation ownership                           │
└──────────────────────────────┬──────────────────────────────┘
                               │ grants exact phase
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    BOUNDED AUTHORITY                        │
│ exact permitted physical phase/manoeuvre                   │
└──────────────────────────────┬──────────────────────────────┘
                               │ executed
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                          CONTROL                            │
│ Hold │ Regulate │ compact/restore │ bounded displacement   │
│ relinquish │ report physical outcome                       │
└──────────────────────────────┬──────────────────────────────┘
                               │ observed
                               └───────────────────────────────↺
```

## 2. Encounter lifecycle flow

```text
positive interaction evidence
    ↓
Encounter CREATED for Operation + interaction + Job Episode signature
    ↓
positive evidence temporarily absent
    └── RETAINED because absence is not clearance
    ↓
explicit lifecycle evidence
    ├── Job Episode ended
    ├── Operation ended
    ├── membership invalidated
    └── intent superseded
          ↓
Encounter TERMINATED with evidence
          ↓
restart/replacement creates new Job Episode
          ↓
renewed positive evidence creates a fresh Encounter
```

This flow is Knowledge-only. Same-Episode physical clearance is not yet an exit authority.

## 3. Decision admission flow

```text
Operational Picture
    ↓
Is augmentation materially required?
    ├── no → normal GIANTS operation; continue observation
    └── yes
          ↓
Complete supportable Candidate Action Space
          ↓
Evaluate every applicable architectural constraint
          ↓
Evaluate Effective Actuation Composition
          ↓
Any admissible candidate?
    ├── yes → select minimum effective option-preserving action
    │          ↓
    │       create or revise Commitment
    └── no  → WAITING_FOR_EVIDENCE, bounded safety,
              or SETTLING toward FAILED
```

Preference exhaustion is not candidate exhaustion.

## 3. Commitment lifecycle

```text
Decision establishes enforceable continuing intent
                         │
                         ▼
                     ┌────────┐
             ┌──────▶│ ACTIVE │◀─────────────┐
             │       └────────┘              │
             │            │                  │
             │            │ evidence         │ evidence
             │            │ insufficient     │ contract met
             │            ▼                  │
             │  ┌──────────────────────┐     │
             └──│ WAITING_FOR_EVIDENCE │─────┘
                └──────────────────────┘
                         │
                         │ objective ends,
                         │ authority changes,
                         │ fail-safe or terminal cause
                         ▼
                    ┌──────────┐
                    │ SETTLING │
                    └──────────┘
                         │
                         │ all obligations accounted for
                         ▼
                  TERMINAL DISPOSITION
```

A Commitment does not normally return from `SETTLING` to `ACTIVE`. A new objective requires a new Commitment.

## 4. Lifecycle authority matrix

| Authority | `ACTIVE` | `WAITING_FOR_EVIDENCE` | `SETTLING` | Terminal |
|---|---:|---:|---:|---:|
| Observe Situation | Yes | Yes | Yes | No active authority |
| Acquire evidence | Yes | Yes | Yes | No |
| Revise strategy | Yes | After sufficient evidence | No | No |
| Initiate objective-progress Control | Yes | No | No | No |
| Continue existing progress Control | While valid | Only if explicitly required for safety | No; reconcile | No |
| Immediate safety inhibition | Yes | Yes | Yes | No |
| Reconcile issued Control | Yes | Yes | Yes | Completed |
| Release capability authority | Yes | Yes | Yes | Completed |
| Satisfy obligations | Yes | Yes | Yes | Completed |
| Transfer eligible obligations | Yes | Yes | Yes | No |
| Enter terminal disposition | No | No | After settlement only | Recorded fact |

## 5. Obligation flow

```text
Obligation created
      │
      ▼
Exactly one owning Commitment
      │
      ├── required outcome achieved and evidenced
      │       → SATISFIED
      │
      ├── authoritative evidence proves basis ended
      │       → BASIS_CEASED
      │
      └── eligible successor accepts atomically
              → TRANSFERRED
```

Until one branch completes, the obligation remains open and terminal entry is forbidden.

### Transfer flow

```text
Predecessor owns obligation
        ↓
transferability confirmed
        ↓
successor basis and eligibility confirmed
        ↓
required authority available or safely deferred
        ↓
successor acceptance recorded atomically
        ↓
successor owns obligation
```

No intermediate ownerless state exists.

## 6. Authority composition flow

```text
Proposed action
    +
existing commands
    +
capability reservations
    +
residual predecessor effects
    +
concurrent relevant-assembly actions
    +
Future-Space interactions
        ↓
Decision composition verdict
        ↓
Commitment authority
        ↓
Control current-composition validation
    ├── unchanged/supportable → actuate
    └── stale/unsafe          → reject or defer
```

Only one Commitment owns objective-progress actuation for an assembly at a time.

## 7. Ordinary successful resolution

```text
ACTIVE Commitment
    ↓
bounded capability sequence
    ↓
objective achieved
    ↓
SETTLING
    ↓
Control reconciled
Configuration Integrity established
authority released
all obligations accounted for
    ↓
SUCCEEDED
```

Capability completion is not Commitment completion.

### Traffic Policeman within Decision

```text
NORMAL TRAFFIC
Traffic Policeman dormant
        │
        │ current Reality requires decisive temporary movement ordering
        ▼
TRAFFIC POLICEMAN ACTIVE
        │
        ├── PROGRESS movement priority
        └── YIELD subordinate movement / preservation role
        │
        ▼
1. CONTINUE_OBSERVATION
   useful evidence still emerging
   AND enough Action Space remains to wait?
        │ exhausted
        ▼
2. REGULATE_SPEED
   "proceed / creep" under GIANTS route + steering + direction
   any positive native progression still useful/supportable?
        │ exhausted
        ▼
3. HOLD_AT_SAFE_POINT
   current realised occupancy itself a sufficient waiting place?
        │ no
        ▼
4. NATIVE_REPOSITION
   create a supportable waiting occupancy
   ├── preferred Yield: forward / reverse / composed candidates
   └── alternate admissible Yield: forward / reverse / composed candidates
        │ all supportable spatial candidates exhausted
        ▼
EXPLICIT ESCALATION / PLAYER INTERVENTION

At any stage:
unrestricted cooperative movement independently supportable
        ↓
release purpose-bound traffic restrictions
        ↓
Traffic Policeman dormant
```

The sequence is strict Decision preference, not procedural Control fall-through. Every later primary band requires explicit exhaustion of earlier bands against the same governing traffic requirement in the same Decision epoch; current Knowledge may prove exhaustion without physical trial. A material Reality or Control Outcome starts a fresh epoch from the least-disruptive end. A lower-band supporting capability may coexist with a stronger primary Commitment when independently justified.

`SETTLED_CONTINUATION` supplies a stable native intent reference; positive corridor compatibility remains separately required. A BNIR participant remains a physical obstacle and may be re-Held if its Action Space would consume Progress demand. Role transfer is legitimate only when it reduces/settles unresolved obligations or materially improves admissible resolution; uncertainty ping-pong is Revelation Oscillation, not progress.

`PROGRESS` is preservation priority rather than exclusive movement permission. `YIELD` does not mean immediate Hold: bounded native movement may remain admissible while subordinate to Progress demand. After a positively available refuge-return corridor is established, Yield may receive a bounded ingress/restoration Action Space; once admitted, its current recovery requirement is Committed Demand. Progress may continue normally, or may receive a purpose-bound supporting `REGULATE_SPEED` lease when unrestricted motion would consume that admitted recovery opportunity. The lease ends as soon as its named protection is no longer required.

### Productive Continuation Preference — roomy non-headland encounters

```text
current Operational Picture
        ↓
positive Productive/Transitional Knowledge fit?
   ├── one PRODUCTIVE + one TRANSITIONAL
   │       ↓
   │   initial preference:
   │   PRODUCTIVE → PROGRESS
   │   TRANSITIONAL → YIELD candidate
   │       ↓
   │   does yielding Transitional preserve Action Space / obligations?
   │       ├── YES → use least disruptive supported capability
   │       └── NO  → preference overridden; ordinary Traffic Policeman / maturation reasoning
   └── tie or UNRESOLVED
           ↓
       no productive-status priority; use existing Decision evidence
```

Absolute speed, vehicle class, implement width and arrival order do not break the tie. Transitional Continuation remains fully relevant to Current/Future Space and may reverse; Yield preference is priority semantics, not reduced spatial authority.

### Encounter maturation under compressed Action Space

```text
ambiguous interaction admitted
        ↓
Traffic Policeman assesses available supported options
        ↓
Action Space sufficiently preserved?
   ├── YES: bounded native maturation
   │       ├── CONTINUE_OBSERVATION
   │       └── REGULATE_SPEED only for a named maturation-margin purpose
   │               ↓
   │       Reality dissolves or simplifies interaction
   │               ↓
   │       reassess from fresh authoritative evidence
   └── NO: Action-Space Compression / Preference-Band Exhaustion
           ↓
       stronger supported intervention
```

Action-Space Compression is a derived physical phenomenon, not a new root Space. A crossing at the headland can be highly constrained while similar geometry mid-field can retain abundant alternatives. Maturation therefore aims to preserve/expand supportable options, not to force every interaction toward a head-on.

```text
Yield refuge egress
    ↓
Progress passage → relevant manoeuvre → settlement
    ↓
positive ingress availability
    ↓
Yield ingress / restoration (admitted Committed Demand)
    ↓
BNIR stage evidence
    ↓
re-Hold / configuration restoration may expire that intent
    ↓
Native Handover acquires fresh operational Local Intent
    ↓
positive joint decoupling + obligations settled
    ↓
Safe Release
```

## 8. Multi-stage strategy

```text
ACTIVE Commitment
    ↓
speed shaping
    ↓
hold or refuge selection
    ↓
manoeuvre leg
    ↓
settled-boundary reassessment
    ↓
additional leg / orientation / handover
    ↓
Safe Release
```

The Commitment identity, Governing Basis and Obligation Set persist across stages.

## 9. Evidence insufficiency

```text
ACTIVE
    ↓ evidence no longer supports progress
WAITING_FOR_EVIDENCE
    ├── contract satisfied → ACTIVE
    ├── objective invalidated → SETTLING
    └── autonomous resolution unsupported → SETTLING / intended FAILED
```

Missing evidence does not prove safety or success.

## 10. Intent Supersession

```text
Predecessor ACTIVE or WAITING_FOR_EVIDENCE
        ↓
new Job Episode independently admitted
        ↓
new intent becomes authoritative
        ├── successor Commitment owns new progress
        └── predecessor enters SETTLING
                ↓
        reconcile predecessor Control
        satisfy origin-bound obligations
        transfer eligible continuity obligations
        close obsolete intent-relative obligations by evidence
                ↓
        predecessor → SUPERSEDED_BY_NEW_INTENT
```

### Supersession Handover Interval

```text
Governing Successor
- owns new intent
- observes and assesses immediately
- actuates only available authority

Settling Predecessor
- no old objective progress
- reconciles its own effects
- retains origin-bound obligations
- transfers only through acceptance
```

Lifecycle coexistence is permitted. Conflicting progress authority is not.

## 11. Player takeover

```text
player gains control
    ↓
affected AI Job Episode ends
    ↓
OuttaMyWay progress authority over that assembly ends
    ↓
Commitment enters SETTLING
    ↓
reconcile OuttaMyWay Control
release authority
close obsolete intent-relative obligations
retain/transfer continuing AI-coordination obligations
    ↓
CANCELLED_BY_SOURCE_INTENT_TERMINATION
```

The player is not an internal Obligation owner. The assembly remains observable and obstacle-relevant while active AI demand exists.

## 12. Terminal Occupancy

```text
worker Job Episode completes
    ↓
ordinary Operation Participation may end
    ↓
does occupancy affect active Committed/Potential Demand?
    ├── no → no Terminal Occupancy Commitment required
    └── yes
          ↓
       Terminal Occupancy Commitment
          ↓
       resolve occupancy
       OR transfer to eligible Commitment
       OR active demand demonstrably ceases
          ↓
       terminal settlement
```

Job completion ends ordinary cooperation, not necessarily physical relevance.

## 13. Operation termination with unresolved obligations

```text
ordinary Operation membership reaches zero
    ↓
reassess obligation bases
    ├── demand-dependent spatial obligations may cease
    └── origin-bound Control, authority, stability and evidence remain
             ↓
          Commitment remains SETTLING
             ↓
          obligations settled
             ↓
          CANCELLED_BY_OPERATION_TERMINATION
          or more precise earlier terminal cause
```

The first authoritative invalidation of the Governing Basis determines the cause.

## 14. Terminal disposition matrix

| Objective condition | Governing event | Terminal disposition after settlement |
|---|---|---|
| Objective achieved | No replacement | `SUCCEEDED` |
| Objective remains applicable but cannot be achieved | Autonomous resolution unavailable | `FAILED` |
| New authoritative intent replaces Governing Basis | Intent replacement | `SUPERSEDED_BY_NEW_INTENT` |
| Source Job Episode ends without replacement | Player stop/takeover, GIANTS abort/fault | `CANCELLED_BY_SOURCE_INTENT_TERMINATION` |
| Operation basis ends | Operation termination | `CANCELLED_BY_OPERATION_TERMINATION` |

## 15. Implementation sequence boundary

```text
normative documents accepted
        ↓
passive identities and value contracts
        ↓
lifecycle + Obligation Set trace
        ↓
state-transition and terminal-settlement tests
        ↓
shadow Effective Actuation Composition
        ↓
one isolated bounded capability
        ↓
runtime validation
        ↓
record, revise and repeat
```

No stage authorises copying the v4.6.57–v4.6.70 experimental controller chain into the replacement core.
