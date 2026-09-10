# Continuation State

Continuation State is the compact, replace-in-place description of the project's
present engineering boundary. Git history, pull requests, Issues and the
Engineering Journal preserve chronology.

## Repository authority

- Accepted Repository State baseline for this increment: `main` after PR #114 merge, commit
  `97bdc75f75e069678313908bff481314d15c79fc`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.41 TEST — CURRENT PAIR ASSESSMENT CORRECTION`**.
- Current Issue #101 executable candidate is
  **`0.3.0.42 TEST — GUARDED RECOVERY ORPHAN RETIREMENT`**; it is not accepted until CI, review, applicable Reality validation and owner merge.
- Protected `main` requires both `Structural contracts` and
  `Lua offline behavioural contracts`.
- Phase 14 is **CLOSED**.
- Phase 15 whole-system architecture <-> code audit is **COMPLETE**.

The closure distinction remains:

> **Strangler Closure Debt != Architecture Audit Debt**

The Phase-15 distinction is:

> **Audit Completion != Reconciliation Completion**

## Phase 15 audit outcome

The audit traversed the current responsibility chain:

```text
Reality
  -> Observation
  -> Situation Assessment
  -> Candidate
  -> Constraint
  -> Decision
  -> Responsibility Transition
  -> Current Responsibility
  -> Bounded Authority
  -> Control
  -> Reality
```

It also reviewed Field World / Job Episode / Local Operation identity,
Physical Representation, Configuration/GUI boundaries, runtime composition,
diagnostic directionality and live documentation responsibility.

### Accepted reconciliation

- **#99 — Transit complete-assembly authority** is accepted by PR #106.
  - **Budget Exhaustion Must Revoke Completeness Authority**.
  - Physical Representation now withholds the complete-assembly Transit Passage
    envelope whenever assembly-member discovery truncates.
  - `TRANSIT_ASSEMBLY_MEMBERSHIP_TRUNCATED` uses the existing reason channel;
    no downstream Candidate/Constraint/Decision/Control special case was added.
  - Independent CI passed 195 structural contracts, 341 replacement-core
    behavioural contracts, and 9 focused obstruction-relocation contracts.
  - Issue #99 is closed **completed**.

- **#98 — Follower Boundary permissible magnitude** is accepted by PR #108.
  - **Admissible Magnitude Evidence != Permitted Magnitude**.
  - **Admissible Envelope != Authorised Target**.
  - Situation retains the accepted timing/transition/reverse/0.90 admissible
    magnitude envelope but no longer supplies a requested Control target.
  - Candidate projects that evidence envelope; authority-owned
    `FollowerBoundaryMagnitudePolicy` materialises the final permitted cap.
  - Protected CI passed 195 structural contracts, 342 replacement-core
    behavioural contracts, and 9 focused obstruction-relocation contracts.
  - GIANTS Reality exercised APPLY -> UPDATE -> QUIESCENT -> REACTIVATED on the
    same `RS-*`, with physical follower speed returning toward native during
    authority release and returning to the authorised cap after reacquisition.
  - **Authority Release Must Be Physically Observable**.
  - Issue #98 is closed **completed**.

- **#100 — Current Pair Assessment Scope reconciliation** is accepted by PR #113.
  - **Current Pair Assessment Scope != Persistent Pair History**.
  - **Evidence Continuity != Evidence Freshness**.
  - **Absence Is Not Separation**.
  - **Unresolved Evidence Is Non-Authority, Not Universal Prohibition**.
  - Current pair scope is rebuilt from active Operation membership and exact
    active Job Episodes on every Operational Picture; no generic last-positive
    pair lifecycle remains.
  - Protected Structural and Lua offline behavioural contracts passed.
  - Owner-run GIANTS Reality produced an apparent PASS in both cold-start and
    warm-start smoke runs.
  - Warm Reality exercised positive -> `UNRESOLVED` current pair evidence,
    Regulation QUIESCENT -> REACTIVATED continuity, purpose-specific Passage
    admission while generic pair evidence was unresolved, two successful
    Cooperative Passages, and current pair-scope disappearance after one Job
    Episode ended while the surviving committed Passage Leg completed normally.
  - PR #113 merged as `41e24b68ada5ad8e236c0a44ba6c52393b9e1c7e`.
  - Issue #100 is closed **completed**.

### Remaining reconciliation Issue

- **#101 — orphaned / stranded semantic residue**
  - Guarded Recovery compatibility is dependency-proven as **loaded topology without production reachability**; `.42` removes that orphan implementation generation while preserving current Passage recovery/restoration obligations and shared Regulation lifecycle machinery.
  - A stale completed-obstruction Control-observation consumer remains.
  - `FOLLOWER_OWNS_CLOSURE` remains stranded Constraint semantics.
  - Obstruction RTA API naming remains stale defensive/naming debt.
  - `.41` Reality/log review additionally found two stranded Runtime reads of
    retired `bridge.encounterIdentity`: an inert Passage Control-target field
    and the `COOPERATIVE_CONSTRAINT_VERDICT encounter=n/a` diagnostic. They
    carry no demonstrated authority and are recorded on #101 for dependency-
    proven retirement rather than reopening #100.
  - These are retirement/naming questions, not demonstrated gameplay defects.

### Disproven audit finding

- **#97 — Field World authority lifetime** was a Phase-15 code-walk
  misclassification, not an implementation defect.
- Accepted `main` already calls
  `FieldWorldEquivalenceAuthority:resolve(existingSnapshot)` on both retained
  track paths. For an existing immutable Snapshot assignment, that path marks
  the established Field World class relevant without re-evaluating stale
  geometry.
- PR #103 independently exercised the missing composition: retained A survived
  unresolved termination evidence and fresh B resolved into the same Field
  World. The attempted `.38` runtime change was therefore redundant and PR #103
  was closed unmerged.
- No `.38` executable identity entered Accepted Repository State.

> **Failed Audit Hypothesis != Runtime Defect**

## Findings protected from false redesign

The audit does **not** justify reopening these accepted behaviours:

- D-0147 / D-0218 / Cooperative Passage terminal-resolution work;
- participant-scoped Passage Leg handback/vacatur and Last-Leg Dissolution;
- cold Causal Obstruction's bounded human-simple relocation policy;
- multiple cold-blocker enumeration and deterministic Decision tie-break;
- current Candidate -> Constraint -> Decision ownership separation;
- current Regulation quiescence, where semantic responsibility may persist
  while physical Bounded Authority is released;
- the current generic multi-context Commitment application fail-closed limit;
- the supported three-worker envelope as a validation/claim boundary rather
  than a fourth-worker runtime rejection mechanism;
- diagnostic probes as downstream consumers rather than semantic authority.

A useful retained distinction is:

> **Resolution Persistence After Actuation != Authority Persistence**

## Existing separate work

These remain independently owned and are not Phase-15 reconciliation findings:

- **#45 — Bubble Bullet Time**: accepted architecture, unimplemented.
- **#87 — `scripts/config.lua` Mixed Runtime Constants Surface decomposition**.

Issue #65 is completed by PR #105. Current TEST build version has exactly
two source owners (`scripts/config.lua` and `modDesc.xml`), and the dynamic Build
Identity Contract protects that ownership without coupling behavioural tests to
the current version literal.

Configuration and GUI architecture define accepted/deferred future product
responsibilities. Their unimplemented player settings/UI do not by themselves
constitute Phase-15 runtime defects.

## Documentation responsibility

- `docs/IMPLEMENTATION_MAP.md` remains the durable current
  architecture-to-source placement / material-drift map.
- Forward programme sequencing belongs in GitHub Issues, not in the
  Implementation Map.
- `docs/architecture/PHASE_13_CLOSURE_AUDIT.md` no longer owns present-tense
  architecture and is removed from the working tree; Git and PR #71 preserve
  its historical closure evidence.
- No new phase-shaped architecture document is created.

## Next

Validate **Issue #101 `.42 — Guarded Recovery Orphan Retirement`**.

Dependency proof established:

> **Loaded Topology != Production Reachability**

> **Recovery Debt != Guarded-Recovery Compatibility**

The `.42` candidate removes only the orphan Guarded-Recovery Situation / Candidate / compatibility-Control generation and its synthetic contracts. It deliberately preserves Cooperative Passage recovery/restoration debt, shared supporting-Regulation lifecycle helpers, Follower Boundary, Forward Intersection / Action-Space Regulation, obstruction responsibilities, Current Pair Assessment Scope and all GIANTS job ownership.

Validation order:

1. implementation-local syntax/static/diff checks only;
2. independent GitHub `Structural contracts` and `Lua offline behavioural contracts`;
3. targeted GIANTS Reality smoke adequate to challenge unintended current-behaviour change;
4. owner review/merge before `.42` becomes Accepted Repository State.

After `.42` acceptance, continue Issue #101 with the separate leaf-residue increment: stale D-0147 Control-observation consumer, structurally unreachable `FOLLOWER_OWNS_CLOSURE` Constraint branch, and the two non-authoritative `bridge.encounterIdentity` Runtime consumers. Keep the live obstruction RTA seam unchanged; its stale method name belongs to Issue #112.

Do not combine #45, #87, #89 or #112 with this retirement work.
