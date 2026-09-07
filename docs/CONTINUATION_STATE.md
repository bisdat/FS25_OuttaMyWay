# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve prior chronology; this file records what matters for the next decision.

## Repository authority

- Accepted Repository State: `main` at merge commit `197742404a038c9072e3934c57f0be8f71ea6b60` (PR #59).
- Canonical authority remains **v0.3.0.0**.
- Current non-canonical playable identity is **`0.3.0.17 TEST — CAUSAL OBSTRUCTION RELOCATION`**.
- Issue #60 records the post-merge `0.3.0.17` normal smoke validation as **PASS** and is closed.
- Documentation-only work does not consume a new TEST `BUILD`.

## Strangler programme status

Phase 11 — Reduce `LiveControlDispatcher` to Authorised Control Routing — **COMPLETE**.

Phase 12 — Retire superseded generic Commitment/orchestration only when no supported path relies on it — **COMPLETE**.

Phase 13 — Simplify Candidate/Constraint/Decision only where evidence proves duplication — **IN PROGRESS AT CLOSURE AUDIT**.

Phase 14 — Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming — **NOT STARTED**.

Phase 15 — Whole-system validation and architecture-to-runtime review — **NOT STARTED**.

## Phase 13 accepted progress

Phase 13 began as an evidence-led simplification of the semantic path between Situation Assessment and Responsibility Transition. It has already established several boundaries that must not be collapsed again merely for implementation convenience.

### Commitment operation is not responsibility transition

PR #50 established **Commitment Operation != Responsibility Transition**. Retained generic `CREATE` / `MAINTAIN` / `REVISE` operations may remain orchestration substrate, but they are not semantic authority for establishing, preserving or replacing Current Responsibility where independent evidence exists.

### Semantic targetability is not application cardinality

PR #52 made direct Cooperative Passage substrate targeting explicit and established:

- **Sole Context != Semantic Target**;
- **Key Match Is Not Lifecycle Match**; and
- **Semantic Targetability != Application Cardinality**.

A retained Passage substrate can be semantically identifiable even when another independent retained context exists. The current generic Commitment application boundary still has a known multi-context cardinality limitation; that limitation must be assessed separately from semantic identity.

### Passage lifecycle became participant-scoped

Reality during Phase 13 exposed the D-0217 lifecycle defect and temporarily interrupted simplification. PRs #53/#54 established participant-scoped `COOPERATIVE_PASSAGE_LEG` obligations, `HANDED_BACK` / `VACATED` terminal dispositions, Survivor Invariance and Last-Leg Dissolution.

The accepted boundary is that pairwise admission does not require symmetric execution persistence. Positive loss of one still-live Passage Leg vacates that leg without cancelling the survivor's already-committed choreography. Raw Control contradiction is not semantic lifecycle authority.

`0.3.0.17` smoke evidence later reconfirmed the normal PR #54 Passage-Leg / Last-Leg Dissolution path twice.

### Causal Obstruction replaced provenance-first completed-worker reasoning

Issue #33 exposed that the remaining completed-obstruction simplification question was framed around the wrong predicate. The enduring concept is **Causal Obstruction**, not historical completed-worker provenance.

D-0218 establishes:

```text
current positive Causal Obstruction
        +
blocker is not an active qualifying GIANTS AI worker
        +
blocker is not currently Player Claimed
        =
eligible for otherwise-supported bounded obstruction relocation
```

Current accepted consequences:

- **Physical Relevance != Historical Provenance**.
- **Obstruction Recognition != Actuation Authority**.
- **Vehicle Ownership != Obstruction Relocation Authority**.
- **Player Entry Is a Claim Boundary, Not Vehicle Classification**.
- native GIANTS `blocked` is diagnostic only and is not a timely obstruction-admission prerequisite.
- D-0147 remains a validated mechanical donor, not the architectural definition of the blocker.
- compact/fold is opportunistic mechanical aid, not the Resolution purpose or settlement gate.

PRs #56–#59 implemented and validated the bounded path from current Physical Assembly Observation through Causal Obstruction recognition to generic relocation behind truthful `OBSTRUCTION_RELOCATION_ACTUATION` authority.

Issue #33 is now **FULL PASS and closed**. The accumulated `0.3.0.17` Reality evidence covers the intended boundaries:

- a cold non-active assembly can be observed without prior Job Episode provenance;
- an unrelated parked/non-active assembly creates no Resolution merely because it exists;
- a non-active Player Claim is hands-off;
- a current `NON_ACTIVE_UNCLAIMED` causal blocker can acquire one bounded relocation responsibility;
- protected beneficiary hold, one bounded relocation, obstruction cessation, fresh productive continuation and `OBJECTIVE_SATISFIED / SUCCEEDED` occur in sequence;
- two independent cold non-active blockers can receive separate relocation responsibilities when each becomes causally relevant;
- no parking, tidying or general vehicle-management responsibility is created.

The first relocation Reality run also exposed **Post-Manoeuvre Settlement Gap**. The cause was **Control Outcome Envelope Kind != Outcome Evidence Kind**: the completion payload overwrote the outer Observation envelope identity. PR #59 preserves the outer `OBSTRUCTION_RELOCATION_CONTROL_OBSERVATION` kind and carries the narrower completion classification separately. Fresh Reality then settles the Resolution only after obstruction cessation plus positive beneficiary continuation. **Manoeuvre Completion != Obstruction Resolution** remains protected.

## Current Phase 13 boundary

### Discovery — Issue Completion != Phase Completion

Closing Issue #33 removes the major Reality-driven detour, but it does not itself complete Phase 13. The programme now returns to the original Candidate / Constraint / Decision simplification question.

No further runtime implementation is justified until a closure audit establishes whether any proven duplication remains.

### Remaining question 1 — Candidate-Embedded Verdict Authority

The next audit must inspect the live chain:

```text
Situation Assessment
        ↓
Candidate
        ↓
Constraint
        ↓
Decision
        ↓
Responsibility Transition
```

For each boundary ask:

> What genuinely new information, choice, constraint or authority is introduced here?

Candidate planning and Decision selection are not assumed redundant. A simplification is justified only where one layer already embeds a verdict or semantic authority that a later layer merely repeats.

The audit must distinguish at least:

- factual Situation knowledge;
- feasible Candidate construction/planning;
- Constraint rejection or narrowing;
- policy/least-intervention selection;
- semantic Responsibility Transition authority.

If those responsibilities remain distinct in production, they stay distinct even if the implementation feels verbose.

### Remaining question 2 — Generic multi-context application cardinality

PR #52 proved that semantic targetability can be truthful while the retained generic Commitment application boundary still cannot address multiple live contexts.

The closure audit must determine whether this is:

1. a supported-runtime requirement that needs a bounded generic addressing correction;
2. a fail-closed limitation that is acceptable within the supported envelope; or
3. evidence of another missing architectural concept.

Do not generalise the application boundary merely because a more generic API would be aesthetically cleaner.

## Phase 13 closure rule

Phase 13 can be declared complete when the closure audit shows one of the following for every remaining Candidate/Constraint/Decision concern:

- the layers have distinct truthful responsibilities and no simplification is justified; or
- a bounded duplication is proved, removed through one explicit seam, and independently validated.

If the audit exposes a real unresolved architecture-to-runtime mismatch, create one bounded Phase-13 tranche for that mismatch and repeat the audit afterwards.

If it does not, record **Phase 13 COMPLETE** and move deliberately to Phase 14. Do not create implementation work solely to make the phase appear substantial.

## Separate non-blocking work

These are not Phase-13 closure blockers unless new Reality evidence directly invalidates Phase-13 assumptions:

- Issue #37 — Category-2 Forward Intersection Reality-validation debt.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.

## Immediate next action

Perform the **Phase 13 Closure Audit** against current `main` without changing runtime behaviour first.

Expected output of that audit:

1. map each Candidate / Constraint / Decision stage to the new information or authority it contributes;
2. identify any actual duplicate verdict/authority path;
3. decide the status of generic multi-context application cardinality;
4. either propose one bounded correction or recommend Phase 13 completion;
5. update this file and `docs/IMPLEMENTATION_MAP.md` with the result before Phase 14 starts.
