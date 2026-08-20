# v4.7.128 candidate flow status

No flow change from live-validated v4.7.127. The D-0147 courtesy flow below is carried unchanged into canonical review.

---

# v4.7.127 current D-0147 courtesy flow

```text
GIANTS Job Episode genuinely ends
        ↓
Pending Player Reclamation
        ↓
positive Terminal Occupancy?
   ├─ no → passive / player cleanup
   └─ yes
        ↓
Terminal Yield Consent?
   ├─ no → Player Escalation / native gameplay
   └─ yes
        ↓
D-0147 special-case Candidate
   - fixed one-shot Field World-centre bearing
   - FIELD_WORLD_CONTAINMENT: N/A by Courtesy Constraint Exception
   - TRANSITION_CLEARANCE: N/A by Courtesy Constraint Exception
   - all authority/safety/lifecycle constraints still mandatory
        ↓
Protected Yield holds authorising productive worker
        ↓
completed assembly: forward-only 60 m native-max Bounded Infield Retreat
        ↓
Actuation Neutralisation → release Protected Yield
        ↓
productive continuation resumes?
   ├─ yes → Continuation Renewal; terminal worker passive again
   └─ no → no automatic chaining; reassess/escalate
        ↓
later attributed native block?
   ├─ yes + not broadly central → fresh bounded retreat
   └─ yes + Courtesy Exhaustion → Player Escalation
```

No point pursuit, route planning, future-demand exclusion map, parking search or universal clearance claim is implied.

---

# v4.7.121 D-0147 Terminal Yield lifecycle flow

```text
GIANTS Job Episode genuinely ends
        ↓
Pending Player Reclamation
        ↓
positive current Terminal Occupancy conflict?
        ├─ no  → remain passive / wait for player
        └─ yes
             ↓
      Terminal Yield Consent?
        ├─ no  → Player Escalation / native gameplay
        └─ yes
             ↓
      Candidate: least supported bounded yield
        ├─ legitimate External Yield
        ├─ Conflict-Relative Infield Yield
        └─ no legitimate expression → Player Escalation
             ↓
      Commitment / bounded authority / Control
             ↓
      current productive continuation restored?
        ├─ yes → neutralise/release → Pending Player Reclamation
        └─ no  → reassess only within admitted bounded policy or escalate

Later positive conflict before Player Claim may create a new Reactive Terminal Yield.
No current conflict means no speculative completed-worker movement.
```

**Externality rule:** another Field World is not free clearance. GIANTS native blocked state proves lack of continuation but does not itself grant unlimited relocation authority.

---

# v4.7.99 D-0146 governing flow addendum

```text
Observed physical motion
  → Established Trajectory + Current Motion
  → Trajectory Persistence / Current Excursion
  → Observed Trajectory Corridors
  → Potential Opposed Corridor Conflict
      → Observe / Regulate if Action Space is being consumed
  → Established Opposed Corridor Conflict
  → Passage Presumption
  → Progressive Passage Search over Local Passage Space
  → sufficient Passage Arrangement (Pairwise Passage Economy)
  → Passage Guide
  → protect Nominal Inter-Assembly Clearance through
       Development → Traversal → Reacquisition
  → native continuation / settlement

During execution:
  Passage Support Loss → Passage Reassessment
      → continue | re-express same Commitment | abandon/escalate
```

**Implementation warning:** v4.7.99 records this flow but does not implement the generic D-0146 stages.

---

# Architecture Flow

> **Authority:** D-0144 Progressive Situational Sufficiency over preserved D-0143/D-0141 responsibilities  
> **Canonical baseline:** owner-declared v4.7.95  
> **Candidate:** v4.7.98; successful v4.7.97 bounded production behaviour preserved

## 1. Current closed-loop responsibility flow

```text
REALITY / GIANTS
    ↓
OBSERVATION
raw current facts + provenance
    ↓
SITUATION ASSESSMENT
Field World / participants
current Productive or Transitional state
current motion / heading
bootstrap-cached physical/configuration evidence
cooperative relevance / obligations
optional Turning Rank awareness
    ↓
OPERATIONAL PICTURE
immutable supported current Knowledge
    ↓
CANDIDATE ACTION SPACE
Observe / Regulate / Hold / Reposition candidates as supported
    ↓
MANDATORY CONSTRAINTS
independent admissibility
    ↓
TRAFFIC POLICEMAN / DECISION
least-authority temporary ordering / strategy selection
    ↓
COMMITMENT + OBLIGATIONS
    ↓
BOUNDED AUTHORITY
    ↓
CONTROL
Hold / native speed Regulation / compact / bounded movement / restore / handoff
    ↓
GIANTS / observed Reality ↺
```

No current Situation layer requires Rook/Successor-Rook prediction, chessboard colouring, continuous Productive History, King Reserve, Refuge search or a headland-U-turn scenario class.

## 1A. Current TS015 maturation path

```text
uncertain or non-conflicting interaction
    → Observe

line-astern follower threatens to consume useful Action Space
    → D-0141 Regulate follower while GIANTS retains route/steering

Reality matures into supported near-collinear Productive/Productive opposed conflict
    → D-0143 Cooperative Passage joint REPOSITION
    → Hold both / compact / separated passage / rejoin / restore / immediate GIANTS handoff

unsupported Productive/Transitional, asymmetric or unvalidated assembly case
    → UNRESOLVED; do not infer authority
```

Turning Rank may be useful future/current Situation context for earlier observation/Regulation, but is not turn prediction and v4.7.98 adds no Turning Rank geometry calculation.

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
