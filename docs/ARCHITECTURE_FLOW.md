# Architecture Flow

> **Authority:** Normative replacement-core responsibility and lifecycle map
>
> **Currency:** v4.7.24 Legacy Fixed-Horizon Predictor Cleanup Candidate; canonical v4.7.23 is the implementation baseline
>
> **Implementation status:** canonical v4.7.23 live-validates Future-Space-driven Encounter admission plus termination precedence and fresh identity; v4.7.24 removes the superseded fixed-horizon future predictor from active runtime while preserving present-state evidence; live Commitment mutation and Control remain unimplemented

## 1. Closed-loop responsibility flow

```text
┌─────────────────────────────────────────────────────────────┐
│                           REALITY                           │
│ workers, assemblies, field, motion, configuration, player, │
│ GIANTS Job Episodes and realised Control effects           │
└──────────────────────────────┬──────────────────────────────┘
                               │ sampled
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                         OBSERVATION                         │
│ sourced facts, timestamps, provenance and uncertainty      │
└──────────────────────────────┬──────────────────────────────┘
                               │ interpreted
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    SITUATION ASSESSMENT                     │
│ identity │ participation │ relevance │ representation      │
│ Current/Future Space │ demand │ constraints │ outcomes     │
└──────────────────────────────┬──────────────────────────────┘
                               │ publishes Knowledge
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    OPERATIONAL PICTURE                      │
│ current supported interpretation; no action selection      │
└──────────────────────────────┬──────────────────────────────┘
                               │ evaluated
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                          DECISION                           │
│ complete supportable Candidate Action Space                │
│ mandatory constraints + Effective Actuation Composition    │
│ maintain / revise / create / settle Commitment             │
└──────────────────────────────┬──────────────────────────────┘
                               │ grants bounded authority
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                        COMMITMENT                           │
│ objective │ Governing Basis │ lifecycle │ Obligation Set   │
│ progress owner │ reservations │ evidence contracts         │
└──────────────────────────────┬──────────────────────────────┘
                               │ requests capability
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                          CONTROL                            │
│ validates current authority and composition                │
│ executes bounded capability; reports physical outcome      │
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
