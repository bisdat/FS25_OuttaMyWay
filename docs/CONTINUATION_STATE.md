# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #224 Category-1 Evacuation Protection implementation

Accepted Architecture / Specification now defines the Category-1 lifecycle discovered from GIANTS Reality. PR #229 was merged as the documentation authority increment. Accepted executable `main` before this implementation remains **0.3.0.82**; rejected `.83` / `.84` were never merged.

This implementation branch advances executable identity to **0.3.0.85** for the bounded hypothesis described below.

## Established Reality evidence

The primary comparison fixture remains the naturally evolved **Condor / Patriot** Category-1 corner from the `.82 A` run:

```text
14:04:33  Category-1 Forward Intersection identified
           -> Patriot regulated to exact 1 km/h
           -> Condor protected

14:05:07  Condor enters the corner and GIANTS begins TURNING
           -> Patriot should remain regulated

14:05:09  Condor reverses / repositions toward the boundary
           -> Patriot should remain regulated

14:05:17  Condor completes the manoeuvre and resumes productive work
           -> Category-1 protection may discharge
           -> Patriot may be released

14:05:35  later Cooperative Passage develops from fresh Reality
```

The detailed `.82 A` evidence showed that accepted `.82` released Patriot on Forward-Intersection topology change only about 3 ms before GIANTS positively published Condor's fresh A8-quality `SETTLED_CONTINUATION`, `productive=true`, `NON_TURN_LINE_ACTIVE`, `turning=false` state.

The rejected `.84` experiment established:

> **No Positive Contradiction != Positive Dissolution Evidence**

Its realised-travel contradiction veto was not a sufficient Category-1 discharge rule and PR #226 was closed unmerged.

## Accepted Category-1 lifecycle

Category-1 admission and initial yielder/protected selection remain unchanged.

### Category-1 approach allocation

Before the protected worker enters the manoeuvre, the allocation remains prospective. Existing current evidence may continue to support it, positively dissolve it or positively supersede it under the ordinary Forward-Intersection Regulation lifecycle.

### Protected Manoeuvre Entry

While that same Category-1 allocation remains current, the already-protected worker crossing from positively supported A8 productive progression into current GIANTS `TURNING` establishes **Protected Manoeuvre Entry**.

### Category-1 Evacuation Protection

After Protected Manoeuvre Entry:

- the incumbent protected/yielder roles remain authoritative for that pair;
- the protected worker remains free to turn, reverse and reposition under GIANTS ownership;
- Forward Intersection becoming unresolved, geometrically negative, or reappearing with reversed timing roles cannot by itself dissolve or reverse that allocation;
- the existing yielder remains regulated at the accepted Category-1 1 km/h Intent-Revelation Creep; and
- no turn path, corner radius, timer, travelled-distance tail or successor reservation is introduced.

> **Protected Manoeuvre Entry Freezes Roles; It Does Not Freeze Routes.**

### Positive Evacuation Discharge

Fresh A8 reacquisition by that same protected worker after Protected Manoeuvre Entry positively discharges the Category-1 purpose. The old Regulation may then terminate immediately and fresh Situation Assessment owns whatever follows.

> **A8 Reacquisition = Positive Evacuation Discharge**

A8 existing before Protected Manoeuvre Entry is not discharge evidence.

## `.85` implementation hypothesis

The smallest source mapping uses existing production evidence and existing responsibility/authority mechanisms.

1. `SpatialConstraintAssessment` carries two current Situation-owned witnesses on each Forward-Intersection projection:
   - `a8ProductivePositive` from the accepted A8 productive-continuation predicate; and
   - `turningPositive` from current GIANTS `isTurn == true` evidence.
2. `ActionSpaceRegulationResponsibilityTransition` registers the admitted Category-1 allocation with `CurrentResponsibilityAssessment` using the semantic Regulation identity plus the already-selected regulated/protected assembly identities.
3. `CurrentResponsibilityAssessment` retains only responsibility-local Category-1 phase evidence keyed by that Regulation identity:
   - the current pre-manoeuvre evidence phase is A8-positive;
   - Protected Manoeuvre Entry has occurred; and
   - the incumbent regulated/protected identities.
4. Once Protected Manoeuvre Entry occurs, Current Responsibility interpretation returns persistent Category-1 Evacuation Protection regardless of FI negative/unresolved/reversed topology until fresh A8 is observed for the same protected worker.
5. The existing fixed-FI 1 km/h lease remains the physical mechanism. No new Control or speed policy is introduced.
6. If a fresh reversed FI would otherwise request `ROLE_MIGRATION` while Evacuation Protection is active, `ActionSpaceRegulationResponsibilityTransition` refuses that migration **before** any new Commitment/authority application. Existing Bounded-Authority handling therefore leaves the incumbent role/lease maintained.
7. Fresh protected-worker A8 clears the responsibility-local protection state and uses the existing positive Forward-Intersection terminal-evidence path to release the old Regulation.

This state is responsibility-local, not persistent generic pair history. It is seeded by Responsibility Transition and interpreted by Situation Assessment; the physical Regulation lease remains subordinate Control/Bounded-Authority state rather than semantic authority.

## Explicit non-changes

`.85` does not change:

- Category-1 FI admission or initial timing/yielder selection;
- Category-2 semantics;
- open-field FI semantics;
- follower/leader regulation;
- opposed-corridor classification;
- Cooperative Passage geometry, Bubble lifetime or recovery;
- the exact 1 km/h Intent-Revelation Creep;
- GIANTS route, steering, direction or native turning ownership; or
- the supported three-AI-worker Operation envelope.

## Offline validation contract

The implementation adds a focused Lua behavioural contract covering:

- Category-1 approach A8 is not discharge;
- A8 -> TURNING establishes Protected Manoeuvre Entry;
- reversed fresh FI cannot change the incumbent yielder while protection is active;
- ROLE_MIGRATION is rejected before Commitment/authority application;
- fresh A8 from the protected worker positively discharges the old responsibility; and
- pre-entry Category-1 negative dissolution remains unchanged.

The existing structural Forward-Intersection contract is extended to protect the responsibility-local state, A8/TURNING witnesses and role-migration veto. GitHub Actions remains execution authority for offline validation.

## Reality validation required

Offline success cannot establish GIANTS behaviour. The primary `.85` in-game A/B target is the naturally occurring **Condor / Patriot** Category-1 corner represented by the `.82 A` baseline.

Expected causal sequence:

1. Category-1 FI admits Patriot as yielder and Condor as protected worker.
2. Condor enters GIANTS `TURNING`; `CATEGORY_1_PROTECTED_MANOEUVRE_ENTRY` is observed.
3. Patriot remains at 1 km/h while Condor turns/reverses/repositions.
4. FI negative/unresolved or a fresh reversed FI does not release Patriot or regulate Condor while Evacuation Protection remains active.
5. Fresh A8 from Condor produces `CATEGORY_1_EVACUATION_DISCHARGED` and releases the old Patriot Regulation promptly.
6. Fresh Situation Assessment may then independently discover ordinary work, a new FI or Cooperative Passage.
7. Later Condor / Patriot Passage should be judged only after this upstream temporal allocation behaves correctly.

The early Condor / S416 corner remains secondary robustness coverage because its manually introduced/start condition adds a test variable.

## Next bounded engineering step

Interpret exact PR-head GitHub Actions evidence for **0.3.0.85**. If blocking offline contracts pass, perform targeted GIANTS Reality validation against the Condor / Patriot `.82 A` baseline before accepting or merging the executable increment.
