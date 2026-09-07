# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve prior chronology; this file records what matters for the next decision.

## Repository authority

- Accepted Repository State: `main` at merge commit `0329cc853d7897aff1d6a83fffbda6239ca4b605` (PR #62).
- Canonical authority remains **v0.3.0.0**.
- Last accepted non-canonical playable identity is **`0.3.0.18 TEST — CONSTRAINT VERDICT OWNERSHIP`**.
- PR #62 Constraint Verdict Ownership passed GitHub Actions Offline Validation Run #173 and an owner-performed GIANTS Reality smoke before merge.
- Issues #33 and #60 remain closed PASS records for the accepted `.17` obstruction-relocation and normal smoke evidence.

## Strangler programme status

Phase 11 — Reduce `LiveControlDispatcher` to Authorised Control Routing — **COMPLETE**.

Phase 12 — Retire superseded generic Commitment/orchestration only when no supported path relies on it — **COMPLETE**.

Phase 13 — Simplify Candidate/Constraint/Decision only where evidence proves duplication — **IN PROGRESS — FINAL CANDIDATE / DECISION OWNERSHIP CORRECTION REQUIRED**.

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

## Final Phase-13 audit — Preselection != Candidate Enumeration

The post-`.18` closure audit found one remaining ownership mismatch.

### Facts from accepted source

`CandidateInventory` requires `complete=true` and describes itself as the complete supportable Candidate Action Space for its declared support boundary.

`CandidateSpace` does not choose among purpose contexts. It materialises every `candidateSpecification` supplied by the current `OperationalPicture` and publishes those Candidate identities into the inventory.

`DecisionSelector` genuinely owns downstream viability filtering and selection. `TrafficPolicemanDecisionPolicy` applies the explicit capability order and requires current exhaustion evidence before a later capability band may win.

Before either layer sees the inventory, however, Candidate-support composition performs purpose/context ordering:

- the generic Causal Obstruction support wrapper returns before legacy Terminal Egress support whenever it publishes a Candidate space;
- `Runtime.processLiveObservation()` uses Terminal Egress / obstruction support before live traffic support;
- `LiveTrafficCandidateSupport` gives an existing follower retirement path precedence;
- then active Guarded Recovery precedence;
- absent a follower purpose, Forward Intersection is considered before Passage planning;
- after Passage planning fails, action-space Regulation is considered before follower fallback;
- when Passage planning succeeds, an unrelated follower purpose can still replace that prospective Passage Candidate space;
- follower support itself ranks actionable follower contexts before publishing one best context and fails closed on equal-best multiplicity.

The result is that Candidate support often publishes one already-preselected purpose/context and then marks that bounded Candidate space complete. `DecisionSelector` can choose only among the alternatives that survived this earlier ordering.

### Architectural distinction

Not every narrowing is a defect.

An already-owned Current Responsibility, live Resolution obligation, settlement duty or other incumbent lifecycle constraint may legitimately restrict what is supportable now. That is not a competing prospective policy choice merely because Candidate enumeration becomes smaller.

The mismatch is **prospective independent purpose preselection**: when more than one fresh, independently supportable Situation relationship could justify a new action, Candidate construction must not silently decide which governing purpose is considered before Decision.

This confirms the existing named discovery:

> **Preselection != Candidate Enumeration**

Candidate construction may plan and describe supportable options. Selection policy belongs to Decision. If existing precedence is still the correct behavioural policy, preserve that ordering explicitly at the Decision boundary rather than relying on first-success Candidate-support control flow.

### Why Phase 13 cannot close yet

Current source splits selection authority:

```text
Situation Assessment
    -> publishes multiple interpreted Situation relationships

Candidate-support composition
    -> chooses which prospective purpose/context gets a Candidate space

CandidateSpace / Constraint
    -> materialise and independently evaluate that narrowed space

Decision
    -> selects only within the preselected space
```

This does not satisfy the intended Candidate / Decision ownership boundary. Phase 13 therefore remains open.

## Final bounded Phase-13 implementation hypothesis

> Candidate support should enumerate every independently supportable prospective Candidate within the explicitly valid current support scope. Decision should own the policy that selects among those prospective alternatives. Incumbent responsibility and obligation constraints may still narrow the support scope where architecture requires persistence or settlement.

The intended correction is **ownership-preserving and behaviour-preserving**:

- do not redesign Situation Assessment geometry or classification;
- do not change existing Traffic Policeman capability preference merely because its current placement is wrong;
- do not weaken Current Responsibility persistence, Passage obligations, Causal Obstruction settlement or terminal lifecycle rules;
- do not make all responsibilities globally exclusive;
- do not generalise the separately accepted generic Commitment multi-context fail-closed limit;
- expose currently suppressed prospective alternatives to the Decision boundary where they are genuinely simultaneous and supportable;
- express any retained deterministic precedence as explicit Decision policy/evidence rather than Candidate-support call order;
- preserve fail-closed behaviour where the source cannot truthfully establish a complete or comparable Candidate set.

The implementation design must first distinguish incumbent lifecycle gating from prospective policy ordering before moving code.

## Generic multi-context application cardinality

The known generic Commitment multi-context limitation remains **ACCEPTABLE FAIL-CLOSED LIMIT for current implemented production behaviour**. Revisit it only when a concrete supported consumer requires it, notably Issue #45 Bubble Bullet Time. This is not part of the final Phase-13 Candidate / Decision correction.

## Separate non-blocking work

- Issue #37 — Category-2 Forward Intersection Reality-validation debt.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.

## Immediate next action

Design one final bounded Phase-13 Engineering Increment for **Preselection != Candidate Enumeration**. Audit each current preselection site as either:

1. **INCUMBENT LIFECYCLE GATING** — legitimately narrows what can be considered;
2. **MUTUALLY EXCLUSIVE SITUATION SUPPORT** — alternatives cannot truthfully coexist, so no policy selection exists; or
3. **PROSPECTIVE POLICY ORDERING** — independently supportable alternatives are being suppressed and must reach Decision.

Move only category 3 ordering to the Decision boundary, preserve existing behavioural preference unless architecture or Reality disproves it, add executable contracts for inventory completeness/selection ownership, then validate independently.

If that correction is accepted and the repeated closure audit finds no further duplicated or fragmented Candidate/Constraint/Decision authority, record **Phase 13 COMPLETE** and proceed deliberately to Phase 14.
