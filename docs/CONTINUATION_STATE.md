# Continuation State

Continuation State is the compact, replace-in-place description of the project's
present engineering boundary. Git history, pull requests, Issues and the
Engineering Journal preserve chronology.

## Repository authority

- Accepted Repository State baseline: `main` after PR #111 merge, commit
  `40c3a3f01b9d691b8b6b95d007be59173640cdea`.
- Canonical authority remains **v0.3.0.0**.
- This Engineering Increment carries
  **`0.3.0.41 TEST — CURRENT PAIR ASSESSMENT CORRECTION`**.
- Protected `main` requires both `Structural contracts` and
  `Lua offline behavioural contracts`.
- Phase 14 is **CLOSED**.
- Phase 15 whole-system architecture <-> code audit is **COMPLETE**.
- The audit itself introduced no executable change; accepted reconciliation has since advanced TEST identity to `.39`.

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

### Remaining reconciliation Issues

- **#100 — Current Pair Assessment Scope reconciliation**
  - **Current Pair Assessment Scope != Persistent Pair History**.
  - **Evidence Continuity != Evidence Freshness**.
  - **Absence Is Not Separation**.
  - **Unresolved Evidence Is Non-Authority, Not Universal Prohibition**.
  - Accepted design rebuilds current pair scope from the active Operation and
    exact active Job Episodes on every Operational Picture.
  - Generic interaction evidence is current `POSITIVE` or `UNRESOLVED`; no
    last-positive pair state survives.
  - Accepted Regulation/Resolution responsibility owns justified continuity
    after admission; Passage Bubble remains post-commit pairwise owner.
  - `.41` implements this design. Protected Structural and Lua offline
    behavioural contracts are green, and owner-run GIANTS Reality produced an
    apparent PASS in both a cold-start and warm-start smoke run.
  - Warm Reality directly exercised positive -> `UNRESOLVED` pair evidence,
    Regulation QUIESCENT -> REACTIVATED continuity, purpose-specific Passage
    admission while generic pair evidence was unresolved, two successful
    Cooperative Passages, and current pair-scope disappearance after one Job
    Episode ended while the surviving committed Passage Leg completed normally.
  - No known merge-blocking #100 contradiction remains; PR #113 is still
    unmerged and requires explicit owner acceptance.

- **#101 — orphaned / stranded semantic residue**
  - Guarded Recovery compatibility has no demonstrated live production ingress.
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

Issue #65 is completed by PR #105. Current TEST build version now has exactly
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

Complete the **owner acceptance decision for PR #113 / Issue #100**.

`0.3.0.41 TEST — CURRENT PAIR ASSESSMENT CORRECTION` now has green protected
offline validation and targeted cold/warm GIANTS Reality evidence supporting the
Current Pair Assessment Scope architecture. No known merge-blocking #100
contradiction remains. The Reality claim remains smoke/two-worker bounded rather
than whole-Supported-Envelope proof.

Do not merge automatically. If the repository owner explicitly accepts and
merges PR #113, that merge advances Accepted Repository State but does not
canonicalise a release.

After #100 acceptance, unless new Reality changes the order:

1. #101 — dependency-proven retirement/naming cleanup.

Do not bundle these independent responsibilities into one reconciliation tranche.

Issue #90 is closed as completed after PR #102 established the durable
post-strangler documentation responsibility. Issue #97 is a disproven audit
hypothesis whose evidence is preserved in the Issue, PR #103 and Engineering
Journal rather than as current implementation debt.
