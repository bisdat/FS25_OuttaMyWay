# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve prior chronology; this file records what matters for the next decision.

## Repository authority

- Accepted Repository State: `main` at merge commit `c8718d3e951c8f303fd0ce842d9c2b5e9cb9443d` (PR #63).
- Canonical authority remains **v0.3.0.0**.
- Last accepted non-canonical playable identity is **`0.3.0.18 TEST — CONSTRAINT VERDICT OWNERSHIP`**.
- PR #62 Constraint Verdict Ownership passed GitHub Actions Offline Validation Run #173 and an owner-performed GIANTS Reality smoke before merge.
- PR #63 accepted the final Candidate-enumeration / Decision-selection closure-audit finding **Preselection != Candidate Enumeration**.
- Issues #33 and #60 remain closed PASS records for the accepted `.17` obstruction-relocation and normal smoke evidence.

## Strangler programme status

Phase 11 — Reduce `LiveControlDispatcher` to Authorised Control Routing — **COMPLETE**.

Phase 12 — Retire superseded generic Commitment/orchestration only when no supported path relies on it — **COMPLETE**.

Phase 13 — Simplify Candidate/Constraint/Decision only where evidence proves duplication — **IN PROGRESS — FINAL PROSPECTIVE DECISION OWNERSHIP INCREMENT DESIGNED**.

Phase 14 — Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming — **NOT STARTED**.

Phase 15 — Whole-system validation and architecture-to-runtime review — **NOT STARTED**.

## Accepted Phase-13 Constraint result

### Candidate Evidence != Constraint Verdict

PR #62 accepted the bounded `.18` correction:

> Candidate proposes evidence and a feasible option. Constraint owns any claim that the option satisfies a mandatory invariant.

Canonical `CandidateAction` construction no longer carries Candidate-authored Constraint verdict authority. Seven pass-through evaluator modules were retired. The independently owned current Constraint questions remain:

1. `REPRESENTATION_FITNESS`;
2. `RESPONSIBILITY_COMPATIBILITY`;
3. `COMMITMENT_PRECONDITIONS`; and
4. `EFFECTIVE_ACTUATION_COMPOSITION`.

`.18` is accepted and Reality-smoked. Do not reopen Constraint Verdict Ownership without contradictory evidence.

## Accepted final Phase-13 audit finding

### Preselection != Candidate Enumeration

PR #63 accepted that Candidate support still performs prospective policy ordering before `DecisionSelector` sees the Candidate inventory. Candidate construction may plan and describe supportable options; selection policy belongs to Decision.

The correction remains bounded by this distinction:

- an already-owned Current Responsibility, live obligation, settlement duty or accepted lifecycle continuation may legitimately narrow what is supportable now;
- fresh independently supportable purposes must not be ordered by Candidate-support first-success control flow;
- fail-closed ambiguity must remain fail closed when no accepted comparison policy exists;
- existing behavioural precedence should initially be preserved explicitly at Decision rather than silently changed while moving ownership.

## Final `.19` design audit

### Named discovery — Passage Planning != Passage Conflict Selection

`LocalPassagePlanner` owns truthful planning **inside one Established Opposed Corridor Conflict**: it searches configuration-conditioned passage arrangements and selects the least-burden supported arrangement for that one conflict. That remains Candidate planning.

`LocalPassagePlanner.plan()`, however, iterates all Established conflicts ordered by current separation and returns the first supported conflict. Its own provenance says `decisionAuthority=false`, yet `progressiveSearch.conflictSelection` records `NEAREST_LOCAL_ESTABLISHED_CONFLICT_FIRST`.

Therefore:

> **Passage Planning != Passage Conflict Selection**

The arrangement search remains Candidate responsibility. Choosing which supported conflict receives Cooperative Passage belongs to Decision.

### Site classification

#### 1. INCUMBENT LIFECYCLE GATING — preserve

These paths narrow the Candidate space because an existing responsibility or obligation already owns the current lifecycle:

- an existing D-0147 Terminal Occupancy Commitment is reassessed only for its exact terminal episode;
- an existing generic Causal Obstruction Relocation Commitment is reassessed only for its exact blocker responsibility;
- active Guarded Recovery protects an already-owned recovery Commitment;
- existing follower retirement / existing follower Regulation retains its current pair-scoped purpose until positively retired or succeeded;
- current D-0146 Action-Space support rejects creation of a different fresh D-0146 purpose while another live Commitment context owns the lifecycle;
- the accepted generic multi-context Commitment limitation remains fail closed and is not generalised by `.19`.

These are not fresh policy choices and must not be flattened into a prospective competition.

#### 2. FAIL-CLOSED OR NON-COMPARABLE SUPPORT — preserve

The following current multiplicities do not silently choose a peer and therefore are not the ownership defect `.19` is intended to solve:

- multiple active Guarded Recovery contexts;
- multiple Forward Intersection contexts;
- multiple D-0146 Action-Space Conservation contexts;
- equal-best simultaneous follower-boundary contexts under the current accepted follower policy.

`.19` must not invent a new peer-comparison policy merely to make those cases act. They remain fail closed unless a separately justified architecture decision establishes a comparator.

Within one Cooperative Passage conflict, `arrangementCandidates()` also remains Candidate planning rather than Decision selection: all arrangements serve the same governing purpose and the planner chooses the least combined lateral burden, then least maximum participant burden, then stable geometric tie-breaks.

#### 3. PROSPECTIVE POLICY ORDERING — move to Decision

The following fresh ordering is real selection authority and must no longer be hidden in Candidate construction:

- generic Causal Obstruction support returning before fresh warm D-0147 support;
- terminal/obstruction support returning before fresh live-traffic support in `Runtime.processLiveObservation()`;
- fresh D-0147 support selecting only the first eligible terminal record instead of exposing all supported fresh terminal episodes;
- a fresh follower purpose suppressing Forward Intersection before Decision;
- Forward Intersection returning before Passage planning when no follower purpose exists;
- a supported Passage for one conflict suppressing Action-Space Regulation for a different fresh relationship;
- fresh follower vs supported Passage ordering, including the existing same-pair Passage succession rule and unrelated-pair follower precedence;
- `LocalPassagePlanner.plan()` selecting the nearest supported Established conflict instead of exposing one supported Passage Candidate per supported conflict.

## Missing architectural concept — Prospective Decision Portfolio

The repeated implementation problem reveals one missing concept rather than a need for more special cases.

A **Prospective Decision Portfolio** is the complete set of independently supportable **fresh Candidate-support groups** that may truthfully coexist for one current Operational Picture when no incumbent lifecycle context already narrows the decision scope.

A **Candidate-support group** retains its own local support boundary. In particular, Traffic Policeman Candidates must retain their own `governingRequirementKey` and sequential capability-exhaustion semantics; they must not be flattened into one synthetic requirement merely to make aggregation convenient.

```text
Operational Picture
    |
    +-- fresh Causal Obstruction support group
    |
    +-- fresh D-0147 support group
    |
    +-- fresh follower support group
    |
    +-- fresh Forward Intersection support group
    |
    +-- fresh Cooperative Passage support group(s)
    |
    `-- fresh D-0146 Action-Space support group
             |
             v
      Prospective Decision Portfolio
             |
         Constraint
      evaluates every Candidate
             |
          Decision
      owns inter-group policy
      + each group's local policy
```

`CandidateInventory.complete=true` then means complete for the explicitly declared Portfolio boundary. It does not mean all groups share one governing requirement.

## Final bounded Phase-13 Engineering Increment — `.19`

Proposed identity after executable code changes begin:

**`0.3.0.19 TEST — PROSPECTIVE DECISION OWNERSHIP`**

### Design invariants

1. **Incumbent-first scope**
   - If a current Commitment/Responsibility owns the lifecycle, continue using its existing single-purpose Candidate-support path.
   - `.19` does not convert incumbent responsibilities into a fresh competition every observation.

2. **Portfolio only for genuinely fresh scope**
   - Build a Prospective Decision Portfolio only when no incumbent lifecycle context already restricts Candidate support.
   - Each included group must independently prove its own support and retain its local support boundary.

3. **Constraint remains unchanged in authority**
   - All Portfolio Candidates receive the same independently owned mandatory Constraint evaluation introduced by `.18`.
   - No Candidate-authored verdict authority returns.

4. **Decision owns inter-group selection**
   - Existing first-success precedence moves to an explicit Decision policy.
   - The first implementation preserves current behaviour rather than redesigning traffic strategy.
   - A lower-precedence group must not become an accidental fallback merely because a higher-precedence group's Candidate fails or remains unresolved; the old system would have exposed only the higher-precedence group. Preserve that behaviour unless Reality later justifies a different policy.

5. **Traffic Policeman local policy remains per governing requirement**
   - The existing sequential `CONTINUE_OBSERVATION -> REGULATE_SPEED -> HOLD -> REPOSITION -> ESCALATE` exhaustion contract remains intact inside the selected Traffic Policeman support group.
   - Portfolio aggregation must not require one global `governingRequirementKey`.

6. **Dispatch consumes the selected group's support boundary**
   - Existing dispatch hard checks for `D0147_BOUNDED_TERMINAL_EGRESS`, `CAUSAL_OBSTRUCTION_RELOCATION_TEST`, `D0146_COOPERATIVE_PASSAGE_STEP2_TEST`, etc. must resolve against the selected Candidate's group boundary when the top-level inventory is a Portfolio.
   - Single-purpose incumbent inventories continue to behave exactly as today.

### Required Candidate-support changes

#### D-0147 Terminal Egress

Fresh scope:

- enumerate every independently eligible fresh Terminal Occupancy record rather than `selectRecord()` returning the first one;
- build the same existing D-0147 Candidate specification for each record;
- preserve stable current record/reference ordering for compatibility at Decision.

Incumbent scope:

- exact existing terminal episode remains the sole D-0147 lifecycle context;
- Player Claim, source reactivation, compaction, Interior Settlement, Continuation Renewal, Final Boundary Settlement, two-courtesy budget and protected-demand hold mechanics are unchanged.

**Hard preservation constraint:** `.19` does not redesign D-0147 or D-0218 warm/cold semantics, geometry, courtesy policy, authority, lifecycle or physical Control.

#### Generic Causal Obstruction Relocation

Fresh scope already enumerates all eligible non-active unclaimed blocker groups and excludes Terminal-Occupancy-owned blockers. Preserve that behaviour and expose the resulting group to the Portfolio rather than automatically returning before warm D-0147 or live traffic.

Incumbent generic relocation reassessment remains exact and exclusive.

#### Cooperative Passage

Split current `LocalPassagePlanner.plan()` responsibility:

- keep `planConflict()` and arrangement search behaviour unchanged;
- enumerate one supported Passage plan per supported Established conflict;
- retain rejection evidence per conflict;
- remove `NEAREST_LOCAL_ESTABLISHED_CONFLICT_FIRST` as Candidate selection authority;
- express nearest-supported-conflict compatibility precedence at Decision.

This is a responsibility movement, not a Passage geometry redesign.

#### D-0146 Action-Space Regulation

For an Established opposed relationship, Action-Space Regulation remains supportable only when that **same relationship** has no supported Passage expression. Passage support for a different relationship must not make the Action-Space Candidate disappear before Decision.

Same-class multiplicity continues to fail closed under the current policy.

#### Follower / Forward Intersection

Existing follower responsibility remains incumbent lifecycle gating.

A single fresh supported follower purpose, a single fresh Forward Intersection purpose and independently supported Passage/Action-Space purposes may all be represented in the Portfolio. Their existing compatibility precedence moves to Decision.

Same-class ambiguous multiplicity remains fail closed.

## Behaviour-preserving Decision compatibility policy

The first `.19` Decision policy should reproduce the current support-call behaviour explicitly.

At the outer level:

```text
fresh generic Causal Obstruction available
    -> choose from that support family
else fresh D-0147 available
    -> choose from that support family
else
    -> apply live-traffic compatibility policy
```

Within fresh live traffic, preserve the current conditional rules rather than replacing them with a new global numeric priority:

- when a fresh follower purpose exists, current behaviour suppresses Forward Intersection consideration;
- determine the legacy-nearest supported Passage Candidate;
- if that Passage uses the follower pair, Passage succeeds the follower purpose;
- if that Passage is unrelated, the follower purpose retains precedence;
- when no supported Passage exists, a supported D-0146 Action-Space purpose retains precedence over fresh follower fallback;
- with no fresh follower purpose, a single Forward Intersection retains precedence over Passage;
- otherwise the nearest supported Passage retains precedence over Action-Space Regulation;
- existing same-class fail-closed multiplicity remains fail closed.

This policy is **compatibility authority**, not a claim that the precedence is permanently optimal. Phase 15 and later Reality evidence may challenge it once ownership is truthful.

## Expected implementation surfaces

Likely bounded executable surfaces:

- `scripts/candidates/LocalPassagePlanner.lua` — enumerate supported conflict plans while preserving per-conflict planning;
- `scripts/candidates/LiveTrafficCandidateSupport.lua` — expose fresh support groups without cross-purpose first-success selection;
- `scripts/candidates/TerminalEgressCandidateSupport.lua` — enumerate fresh terminal records while preserving incumbent exact-context behaviour;
- `scripts/runtime/ObstructionRelocationRuntimeIntegration.lua` and/or a small Candidate composition helper — expose cold + warm fresh groups without changing their semantics;
- `scripts/runtime/Runtime.lua` — build Portfolio only for fresh scope;
- `scripts/candidates/CandidateSpace.lua` / `scripts/contracts/CandidateInventory.lua` — retain per-group support-boundary membership in the sealed inventory;
- `scripts/decision/DecisionSelector.lua` plus one purpose-specific Decision policy module — own inter-group compatibility precedence and invoke existing Traffic Policeman policy inside the chosen group;
- dispatch boundary lookup — resolve the selected Candidate's retained group support boundary.

Avoid speculative refactoring beyond those ownership seams.

## Validation contract for `.19`

Offline structural contracts should prove at minimum:

1. fresh Portfolio Candidate enumeration contains all supported groups that current first-success flow previously suppressed;
2. incumbent lifecycle paths still produce a single exact support scope;
3. same-class currently fail-closed multiplicity remains fail closed;
4. one supported Passage Candidate is produced per supported Established conflict while per-conflict arrangement selection is unchanged;
5. Decision, not Candidate support, reproduces the legacy nearest-Passage and cross-purpose compatibility precedence;
6. lower-precedence groups do not become accidental fallback after higher-precedence unresolved/failed Constraint evidence;
7. the selected Candidate resolves back to its exact original support boundary for dispatch;
8. D-0147 warm and D-0218 cold Candidate contents, lifecycle bridges and physical Control contracts remain byte/semantic equivalent except for Portfolio membership metadata required by the ownership change.

GIANTS Reality should then use a **behaviour-preservation smoke**, with explicit attention to today's validated D-0147 warm/cold cases plus one ordinary live-traffic path. It is not a new geometry or capability tranche.

## Generic multi-context application cardinality

The known generic Commitment multi-context limitation remains **ACCEPTABLE FAIL-CLOSED LIMIT for current implemented production behaviour**. Revisit it only when a concrete supported consumer requires it, notably Issue #45 Bubble Bullet Time. This is not part of `.19`.

## Separate non-blocking work

- Issue #37 — Category-2 Forward Intersection Reality-validation debt.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.

## Immediate next action

Owner review of this final `.19` design. If accepted, implement one bounded executable increment from accepted `main`, advance to **`0.3.0.19 TEST — PROSPECTIVE DECISION OWNERSHIP`**, add the structural contracts above, run independent GitHub Actions validation, then perform the bounded GIANTS Reality preservation smoke before the final Phase-13 closure audit.
