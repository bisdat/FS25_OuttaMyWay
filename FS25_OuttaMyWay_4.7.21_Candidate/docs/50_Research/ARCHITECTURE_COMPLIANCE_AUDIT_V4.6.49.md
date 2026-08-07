# Architecture Compliance Audit — Active TS015/TS016 Path

**Audit status:** Consolidated evidence for the v4.6.50 Architecture Recovery Candidate; no temporary runtime implementation promoted  
**Audit date:** 2026-08-02  
**Canonical baseline:** owner-declared v4.6.43  
**Canonical ZIP SHA-256:** `c312d74eedb20d800253247b784a992073a4cf44c0413588fa7f382b801cba4c`  
**Implementation under audit:** temporary non-canonical v4.6.49  
**Temporary ZIP SHA-256:** `3bebcaf52cd9ccfc65ccce5a895d65c1df1aee8f6e1427a1a77ce86756d23a4d`

## 1. Purpose

This audit asks whether the active TS015/TS016 implementation still conforms to the accepted architecture, or whether fixture-bounded prototype code has gradually become an alternative operating architecture.

It does **not** decide the next implementation. Its purpose is to identify:

1. where architectural responsibilities currently reside;
2. which architectural constraints are globally enforced, locally enforced, diagnostic only, documented only, or bypassed;
3. which fixed values currently carry behavioural authority;
4. which experimental discoveries and mechanisms must be preserved;
5. what architectural questions must be resolved before another behavioural build.

## 2. Evidence basis

The audit compared the exact v4.6.43 and v4.6.49 packages and reviewed the cumulative runtime evidence from temporary v4.6.44–v4.6.49.

The package delta is substantial but concentrated:

- 32 files changed;
- 2,659 insertions and 142 deletions;
- `TemporalSeparationController.lua` added at 927 lines;
- `RefugeViabilityEvaluator.lua` added at 360 lines;
- `UnilateralSidestepController.lua` expanded by approximately 403 lines and is now 1,787 lines.

This does not prove architectural failure by itself. It is a useful signal that a bounded test actuator accumulated observation, interpretation, decision, commitment and control responsibilities.

## 3. Executive conclusion

The user's concern is supported.

The v4.6.44–v4.6.49 work produced several reusable mechanisms and important architectural discoveries. It should not be discarded. However, the **active TS015/TS016 execution path is not currently architecture-compliant as a unified system**.

The primary issue is not merely that there are many thresholds. The deeper findings are:

### Prototype Boundary Leakage

> A fixture-bounded experiment has gradually become the active operating path, while retaining assumptions, identities and state lifecycles that were intended only for evidence gathering.

### Assessment–Decision–Control Collapse

> Active controllers consume raw observations, interpret the situation, select actions, maintain commitments and execute control inside private state machines.

### Architectural Constraint Enforcement Gap

> Architectural invariants exist in the canonical design, but they are not mandatory admissibility gates for every commitment capable of violating them.

### Fragmented Commitment Ownership

> Admission, temporal separation and sidestep passage each own separate private encounter state; continuity is maintained by manual state transfer rather than one architectural commitment record.

These findings explain the repeated “one more fix” pattern. Each local correction was rational and evidence-based, but the necessary knowledge and responsibility lived inside the current controller. The next observed failure therefore produced another controller branch rather than a correction to a common Situation Assessment → Operational Picture → Decision → Commitment pipeline.

## 4. Canonical obligations used as audit criteria

The canonical v4.6.43 architecture states:

- Decisions consume understanding, not raw observations (`docs/ARCHITECTURAL_MAXIMS.md:7`).
- Situation Assessment is the sole interpreter of observations (`:9`).
- New information returns through the Operational Picture before further decisions (`:10`).
- Responsibilities belong with their natural owner, not the easiest implementation point (`:11`).
- Implementation must not silently narrow worker-level architecture (`:14`).
- Admissibility precedes optimisation (`:25`).
- Situation Assessment judges representation fitness (`:27`).
- Observe broadly; control narrowly (`:33`).
- Repeated local resolution is not proof of Operational Resolution (`:38`).

The canonical field and geometry architecture also states:

- complete vehicle–implement geometry, transition extent and projected sweep remain inside the Field World (`docs/ARCHITECTURE.md:94-98`);
- working width shall never substitute for physical geometry (`:120`);
- unknown or partial geometry must remain explicit and cannot become authoritative merely because it is convenient (`:122`);
- the Decision Engine continuously evaluates the current Commitment against the Operational Picture (`:175-176`);
- Situation Assessment produces Operational Picture Knowledge and does not issue Control (`:222-232`);
- partial representation coverage yields unresolved clearance rather than control authority (`:248-250`);
- movement speeds should derive from the assembly's Native Motion Envelope (`:386`);
- the `foldAnimTime=0.15` threshold was diagnostic and granted no complete-sweep authority (`:388`);
- complete Yield sweep must remain outside the Protected Progress Corridor (`:378`);
- refuge selection is viability/clearance first and cost second (`:408-412`).

## 5. Actual active authority path

### Intended architecture

```text
Raw observations
    ↓
Situation Assessment
    ↓
Operational Picture Knowledge
    ↓
Decision Engine
    ↓
Commitment
    ↓
Control capabilities
    ↓
Feedback to Situation Assessment
```

### Current active TS015/TS016 path

```text
Observer.states and direct game queries
    ├── AutomaticEncounterAdmission
    │      interprets phases/turns/kinematics
    │      applies thresholds
    │      owns encounterRecords
    │
    ├── TemporalSeparationController
    │      interprets relationships and geometry change
    │      owns episode
    │      selects regulation/hold/handoff
    │      applies cruise and permission authority
    │
    ├── ShadowRefugeCandidateComparison
    │      builds representations
    │      solves and ranks candidates
    │      grants controlEligible
    │
    └── UnilateralSidestepController
           identifies the fixture
           owns run/phase/commitment state
           interprets passage and continuation
           controls hold/fold/drive/rejoin/cruise/handoff
```

`Runtime.lua:2956-2965` updates the sidestep and temporal-separation controllers directly. When `UNILATERAL_SIDESTEP_EXCLUSIVE` is true, `Runtime.lua:2968-2974` returns before the general `updateDecisionEngine()` call at `Runtime.lua:3044-3049`.

The repository still contains Decision Engine implementations, but the active experimental route deliberately bypasses them. That was initially a legitimate execution boundary for a bounded prototype. It is no longer merely a bounded actuator once it owns the continuing encounter lifecycle.

## 6. Constraint enforcement matrix

| Architectural requirement | Current status | Evidence and interpretation |
|---|---|---|
| Situation Assessment is sole interpreter | **BYPASSED** | Active controllers read `Observer.states`, live phase flags, speeds, fold state and world transforms directly. |
| Decisions consume Operational Picture Knowledge | **BYPASSED** | Admission and controllers operate on raw state tables and locally derived kinematics; no shared knowledge object governs the active path. |
| Decision Engine selects action | **BYPASSED FOR ACTIVE PATH** | Exclusive controller return occurs before the general Decision Engine update. |
| Current Commitment continuously evaluated against Operational Picture | **LOCAL ONLY** | Each controller re-evaluates selected evidence inside its own private `run` or `episode`; there is no single commitment ledger or common validity contract. |
| Full-Envelope Field Containment | **DOCUMENTED GLOBALLY; LOCAL ONLY IN CONTROL** | v4.6.49 checks one compact target and a direct egress segment. It does not govern folding sweep, steering sweep, rejoin orientation, deployment sweep, continuing refuge occupancy or Progress Future Space. |
| Geometry Domain Separation | **PARTIALLY CONTRADICTED** | Live complete discovered envelopes are preferred, but working-marker width, size metadata and fixture templates can become active refuge operands. |
| No Silent Under-Approximation | **PARTIAL** | v4.6.49 correctly withholds unresolved viability, but low-confidence model/metadata evidence can still grant geometry eligibility. Conservative evidence reduces under-approximation risk but does not establish authoritative physical truth. |
| Admissibility before optimisation | **COMPLIANT LOCALLY** | Refuge viability now precedes clearance/cost ranking. This was validated in v4.6.49. |
| Observe broadly; control narrowly | **PROTOTYPE-BOUNDED** | Control is narrow, but observation/admission requires exactly two active workers and explicit Condor/Patriot identity. |
| Architecture speaks about workers | **NOT GENERALISED** | `findFixturePairStates()` recognises only names/assets containing `condor` or `patriot`; admission logs declare the fixture pair explicitly. |
| Native Motion Envelope owns movement speed | **DOCUMENTED ONLY** | Egress, ingress, precision and orientation speeds are fixed controller configuration values. |
| Complete swept envelope outside Progress corridor | **DOCUMENTED; INCOMPLETE IMPLEMENTATION** | Calculated static extents and direct path evidence exist; steering, transition and time-dependent occupancy are not generally assessed. |
| Unknown suitability withholds authority | **COMPLIANT FOR REFUGE VIABILITY** | v4.6.49 requires field containment, egress path and obstacle clearance all to be `CLEAR`. |
| No unresolved all-hold | **LOCALLY PRESERVED** | Current tested sequences hold one participant and retain an active escape commitment. No generic mutual continuation policy exists yet. |
| Job completion ends cooperation, not relevance | **OBSERVED/DOCUMENTED; CONTROL GAP REMAINS** | Relevant for completed obstacles, but not yet a general active control capability. |
| Operation-level outcome | **NOT ESTABLISHED** | Several local encounters now succeed, but the extended run still ends in a later conflict and the architecture explicitly warns against equating repeated local success with Operational Resolution. |

## 7. Detailed findings

### F-01 — Active Decision Engine bypass

**Severity:** Critical architectural finding  
**Classification:** Fact

The active TS015/TS016 prototype path updates the two controllers and returns before `updateDecisionEngine()`.

**Consequence:** The architecture's named decision owner is not governing the active behaviour. Decision policy has migrated into controllers.

**Interpretation:** This was acceptable as a temporary prototype execution boundary. The accumulation from v4.6.44–v4.6.49 means the boundary now encloses a substantial alternative decision system.

### F-02 — Assessment–Decision–Control Collapse

**Severity:** Critical architectural finding  
**Classification:** Fact and interpretation

`UnilateralSidestepController.lua` directly:

- obtains current workers from `Observer.states`;
- identifies Condor and Patriot;
- reads position, direction, speed, worker phase, blocked state and fold state;
- interprets admission, passage, geometry and continuation evidence;
- owns the `run` state machine;
- selects hold, fold, egress, wait, rejoin, deployment, release and failure actions;
- calls the permission gate, cruise setter and drive actuator.

`TemporalSeparationController.lua` similarly owns relationship interpretation, reserve calculation, an `episode`, speed regulation, hold and protected handoff.

**Consequence:** New information cannot naturally update one shared Operational Picture. It is consumed by whichever controller currently owns the private state.

### F-03 — Architectural Constraint Enforcement Gap

**Severity:** Critical safety/architecture finding  
**Classification:** Fact

Full-Envelope Field Containment is a canonical invariant, but canonical v4.6.43 explicitly recorded that active containment was not yet implemented. Active sidestep authority was subsequently developed before a general containment service existed.

v4.6.49 introduced a useful local gate. It checks:

- compact target containment;
- conservative boundary reserve along one straight segment;
- known collision overlap samples along that direct segment.

It does not enforce the invariant across all control commitments.

**Consequence:** A documented invariant can be satisfied by one candidate calculation while later configuration transition, steering, rejoin or continued occupancy violates the same intent.

**Named distinction:** **Local Constraint Gate is not System Invariant Enforcement.**

### F-04 — Representation Authority Escalation

**Severity:** High  
**Classification:** Fact

`ShadowRefugeCandidateComparison.lua:140-166` prefers a complete discovered Progress envelope, but falls back to half the AI working-marker width and then size metadata.

For Yield geometry, `:175-245` may use:

- a fixture-specific Condor provider;
- a complete live discovered envelope;
- a metadata rectangle at predicted bearing;
- a current working-marker upper bound.

`FacingExtentProvider.lua` is explicitly fixture-bounded and may provide:

- current catalogue node bounds;
- node origins plus a fixed 2.50 m allowance;
- an empirical folded-origin template plus 2.50 m allowance.

`ShadowRefugeCandidateComparison.lua:442-552` does record provenance and confidence, but `geometryEligible` does not require a particular confidence or completeness class. Once geometric reserves and v4.6.49 viability are clear, low-modelled evidence can become `controlEligible`.

**Consequence:** Representation evidence designed to be useful for comparison can be promoted into active movement authority without one central Situation Assessment fitness judgement.

**Nuance:** Many fallbacks are intentionally conservative, so this is not automatically unsafe under-approximation. The compliance issue is authority and domain separation, not simply the size of the estimate.

### F-05 — Fragmented Commitment Ownership

**Severity:** High  
**Classification:** Fact and interpretation

Commitment-like state is distributed across:

- `AutomaticEncounterAdmission.encounterRecords`;
- `TemporalSeparationController.episode`;
- `UnilateralSidestepController.run`.

Protected handoff works by transferring selected data and hold ownership from one private state machine to another.

**Consequence:** Encounter identity, roles, expected corridor, current refuge, release obligations and control leases do not have one architectural owner. A changed situation can be observed but may not be expressible in the current controller phase.

This explains both earlier failures:

- Prototype 20 could not act because no episode existed;
- Prototype 16 observed a changing situation but had no commitment-revalidation branch for Progress turning into the occupied refuge.

### F-06 — Prototype Boundary Leakage

**Severity:** High  
**Classification:** Fact

The active path remains explicitly fixture-bounded:

- names/assets containing `condor` and `patriot` are required;
- exactly two active workers are required;
- the Condor collision catalogue and empirical compact template are special inputs;
- admission modes are calibrated to the TS015/TS016 fixture.

**Consequence:** The successful mechanisms are evidence of capabilities, not proof that TS015/TS016 have been solved for arbitrary workers and assemblies.

**Important:** Fixture-bounded testing is not itself a defect. The defect would be allowing fixture assumptions to become the unexamined production architecture.

### F-07 — Fixed values carry mixed and unclear authority

**Severity:** High  
**Classification:** Fact

The current path contains many fixed values. They are not all problematic. They serve different roles:

- diagnostic cadence;
- safety watchdog;
- evidence-calibrated admission policy;
- actuator command;
- representation uncertainty;
- fixture model;
- semantic proxy.

The risk is that these categories are not enforced in code. A diagnostic or fixture-derived value can gradually become a decision operand.

High-impact examples are listed in section 9 and the companion Hardcoded Authority Register.

### F-08 — Native repositioning speed is not yet an architectural capability

**Severity:** Medium/High  
**Classification:** Fact

Current configured motion values are:

- egress: 15 km/h;
- ingress/rejoin: 15 km/h;
- precision: 6 km/h;
- rejoin orientation: 5 km/h.

The user's observed 5 km/h is therefore not the normal ingress value; it is a special orientation phase. However, the canonical architecture says speed should begin from the assembly's Native Motion Envelope.

**Consequence:** Replacing 5 with 15 would remove one symptom but preserve controller ownership of motion policy.

**Candidate architectural concept:** **Native Repositioning Motion** — Control requests a motion intent such as `REPOSITION`, `PRECISION_POSITION`, `ORIENTATION_RECOVERY` or `EMERGENCY_ARREST`; a motion capability derives an assembly-appropriate speed and steering envelope.

### F-09 — Phase-specific awareness substitutes for generic situation relevance

**Severity:** High  
**Classification:** Interpretation supported by code and runtime evidence

Recent additions introduced valuable but phase-specific awareness:

- Post-Passage Continuation Guard;
- Observation Ownership;
- Protected Controller Handoff;
- Refuge Viability Gate.

The human analogies identify the more general concepts:

#### Persistent Situation Relevance

> An Entity remains relevant while its current or plausible Future Space can still affect another participant's continuation.

#### Commitment Preconditions

> Before beginning or materially changing a manoeuvre, the proposed Future Space must remain admissible in the current Operational Picture.

These apply to passing, turning, folding, unfolding, rejoining, handing back and encountering a completed obstacle. They should not require a separate awareness branch for each controller phase.

### F-10 — Documentation authority is fragmented

**Severity:** Medium  
**Classification:** Fact

`ARCHITECTURAL_MAXIMS.md` says “The handbook is the chart,” but `ENGINEERING_HANDBOOK.md` is correctly marked **Reference** and last reviewed for canonical v4.5.9. Current architecture has evolved substantially in `ARCHITECTURE.md`, `ARCHITECTURAL_MAXIMS.md`, `CONCEPT_REGISTER.md` and decision records.

The repository does label the handbook's currency honestly. The remaining issue is navigation authority: a future engineer could reasonably treat the maxim literally and rely on an outdated ownership model.

**Named discovery:** **Documentation Authority Drift.**

## 8. Authority trace — current final-head-on path

The following trace illustrates the responsibility collapse without judging each local calculation as wrong.

| Stage | Current owner | Input | Output/action | Compliance observation |
|---|---|---|---|---|
| Worker facts | Observer | GIANTS AI state | `Observer.states` | Appropriate observation source. |
| Encounter interpretation | AutomaticEncounterAdmission | raw phases, `isTurn`, speeds, headings, CPA | eligible mode and fixture roles | Situation Assessment/Decision responsibilities combined locally. |
| Candidate representation | ShadowRefugeCandidateComparison and providers | world transforms, discovered geometry, markers, metadata, fixture catalogue | candidate extents and refuge targets | Useful evidence, but fitness and authority are coupled. |
| Viability | RefugeViabilityEvaluator | field polygon, target, direct segment, overlap samples | `CLEAR/BLOCKED/UNKNOWN` | Correct local admissibility gate; not a global invariant service. |
| Commitment | UnilateralSidestepController | admission + selected candidate | private `run` with role/side/targets/phases | Commitment is private controller state. |
| Execution | UnilateralSidestepController | `run.phase` | hold, fold, drive, wait, rejoin, deploy | Appropriate control mechanisms, but controller also owns interpretation and policy. |
| Changed Progress Future Space | raw Observer state and passive conflict evidence | Patriot begins turn | no common commitment invalidation | Knowledge exists but active controller has no generic response. |
| Failure | UnilateralSidestepController | blocked/progress evidence | `FAILED_HELD` | Safe local failure, but not operational resolution. |

## 9. Hardcoded authority review

### 9.1 Values that are mainly diagnostic or watchdogs

Examples include update/log intervals, scan budgets and maximum phase durations. These should remain configurable and documented, but they do not inherently violate the architecture.

Examples:

- update cadence: 100/250/500/1000 ms;
- heartbeats: 15 s;
- arm/fold/drive/passage/observation timeouts;
- geometry scan budgets;
- authority-response telemetry timeout.

### 9.2 Evidence-calibrated prototype policy

These are legitimate experimental values but are not architectural truths:

- head-on threshold: 150°;
- straight admission persistence: 3 s;
- `tCPA` windows: 30 s and 12 s;
- maximum `dCPA`: 14 m;
- minimum commitment `tCPA`: 6 s;
- temporal parallel threshold: 12°;
- reserve bounds: 6–12 s;
- speed-intervention deficit: 0.5 s;
- rearm distance: 35 m and 3 s.

They should eventually be derived from named evidence, assembly capabilities and risk policy rather than silently generalised.

### 9.3 Values currently standing in for richer semantic conclusions

These deserve the highest scrutiny:

| Current value | Current meaning in code | Architectural concern |
|---:|---|---|
| `35 m` | passage/rearm clear distance | Centre-based distance is being asked to represent complete passage and safe continuation. Latest runtime evidence disproved that sufficiency. |
| `20 m` | progress behind stop anchor | Reference-point progression is not complete-assembly passage. |
| `0.15 foldAnimTime` | egress-ready trigger | Canonical architecture explicitly classified this as diagnostic, not complete swept-envelope authority. |
| `5 km/h` | rejoin orientation speed | Controller phase owns speed instead of Native Motion Envelope. |
| `6 km/h` | precision speed | Same ownership issue; may be useful but should be capability-derived. |
| `7.5 km/h` | minimum regulated cap | Provisional policy/actuator floor; not assembly-derived. |
| `36 m` | TS017 shadow working-width fallback | Diagnostic in the shadow calculator, but closely related working-marker evidence can also enter active refuge calculation. |
| `2.50 m` | Condor origin allowance | Fixture model supporting active extent authority. |
| `0.5 s` | speed intervention deficit | Now correctly separated from encounter existence; remains a provisional regulation threshold. |
| `14 m` | admission dCPA ceiling | Fixture-calibrated conflict gate, not a general physical-clearance model. |

### 9.4 Hidden implementation literals

Several important literals sit outside the central config:

- direct obstacle path sampling capped at 128 steps;
- 4 m height fallback for obstacle overlap;
- direct-path sample spacing based on compact half-length, minimum 0.25 m;
- size metadata accepted only within 0.25–150 m;
- 0.70 orientation-alignment dot for live longitudinal extent;
- fixed solver iterations and tolerances;
- turn-sign, movement-detection and restore timing literals.

The issue is not that every literal must disappear. The audit requirement is that any value capable of altering decision or control has a named owner, evidence basis and scope.

## 10. What must be preserved

The audit does not recommend reverting to v4.6.43 behaviour or deleting the temporary work. The following have strong reusable value:

1. **Persistent Speed Authority**
   - capture/apply/restore selected cruise setpoints;
   - preserve reverse speed;
   - confirm physical response.

2. **Temporal Separation Reserve**
   - treat time/separation as a resource;
   - use a stable pre-regulation reference to prevent self-satisfaction.

3. **Observation Ownership**
   - a relevant relationship can exist without immediate intervention.

4. **Post-Passage Continuation evidence**
   - passage does not automatically end relevance.

5. **Protected Controller Handoff semantics**
   - preserve encounter identity, role assignment and hold continuity across control transfer.

6. **Future Corridor Frame**
   - base decisions on the relevant corridor rather than a transient vehicle pose.

7. **Both-side refuge generation**
   - no fixed physical side.

8. **Viability before ranking**
   - unknown or blocked candidates do not receive movement authority.

9. **Field-boundary and known-obstacle evidence providers**
   - valuable assessment inputs, though not yet complete invariant enforcement.

10. **Structured evidence logging**
    - the logs made every disproven hypothesis discoverable.

These should be treated as candidate services/capabilities beneath the architecture, not retained automatically as top-level autonomous controllers.

## 11. Target responsibility map for discussion

This is an architectural responsibility proposal, not an implementation plan:

```text
Observation and representation providers
    - worker state
    - physical/configuration geometry
    - field boundary
    - known obstacles
    - live kinematics
    - native motion capabilities
        ↓
Situation Assessment
    - current situation
    - Future Spaces and transition sweeps
    - representation fitness and uncertainty
    - persistent relevance
    - constraint/admissibility conclusions
        ↓
Operational Picture / Encounter Knowledge
    - participants and relationships
    - current commitments
    - expected progress corridor
    - refuge occupancy and validity
    - unresolved uncertainty
        ↓
Decision / Negotiation
    - maintain, revise or cancel commitment
    - select least-disruptive admissible action
    - define release obligations and control leases
        ↓
Commitment Ledger
    - one owner for encounter identity, roles, obligations and lifecycle
        ↓
Control capabilities
    - Hold
    - Speed Regulate
    - Reposition
    - Fold/Deploy
    - Restore/Handback
        ↓
Control feedback returns to Situation Assessment
```

This map preserves controller exclusivity while preventing exclusive controllers from becoming private Situation Assessment and Decision systems.

## 12. Audit decisions recommended for discussion

The audit supports the following immediate decisions:

1. Freeze behavioural builds at temporary v4.6.49 until the responsibility model is agreed.
2. Keep v4.6.43 canonical.
3. Preserve v4.6.44–v4.6.49 as experimental evidence and capability implementations.
4. Do not tune the latest collision using passage distance, lateral distance or another phase-specific branch.
5. Do not simply replace the 5 km/h literal with 15 km/h; first assign native movement-speed ownership.
6. Define a common commitment model before deciding whether Prototype 16 should be refactored, replaced or reduced to a control capability.
7. Define how architectural invariants become mandatory admissibility gates rather than documentation-only constraints.
8. Define representation fitness classes that may and may not grant active Control authority.
9. Define Persistent Situation Relevance and Commitment Preconditions as generic Situation Assessment knowledge.
10. Resolve documentation authority so the current architectural chart is unambiguous.

## 13. Questions deliberately left open

The audit does not yet decide:

- whether the current legacy Decision Engine should be evolved or replaced by a new common Decision/Negotiation layer;
- the exact data structure for the Operational Picture or Commitment Ledger;
- how far Future Space prediction must extend;
- whether Progress may be regulated or repositioned during every encounter class;
- how Native Motion Envelope values are discovered from GIANTS and assembly state;
- which low-confidence representations may support conservative control, and under what risk policy;
- the production replacement for fixture-based worker selection;
- how TS015 active-active cooperation and TS016 active-static navigation remain architecturally separate while sharing awareness and constraint services.

Those are the appropriate subjects for the next architectural discussion. They should not be answered by another temporary behavioural patch.

## 14. Overall audit judgement

**Current status:** materially non-compliant with the intended responsibility architecture, while remaining highly valuable as a controlled experimental implementation.

The temporary implementation has not invalidated the architecture. It has revealed where the architecture was not yet operationally enforceable.

The most important lesson is:

> The project does not currently lack another collision-avoidance rule. It lacks a single architecture-governed route by which observations become shared knowledge, knowledge constrains commitments, and commitments select reusable control capabilities.

That is the underlying disease indicated by the sequence of successful local fixes and later failures.

## 15. Repository disposition in v4.6.50

The owner and architectural review accepted the audit conclusion that the temporary implementation must not be promoted as the operating architecture.

v4.6.50 therefore:

- begins from exact canonical v4.6.43 rather than from temporary v4.6.49;
- preserves v4.6.43 runtime behaviour;
- retains v4.6.44–v4.6.49 discoveries and capabilities as evidence;
- records controller ownership, constraint-enforcement and hardcoded-authority findings;
- requires a passive Situation Assessment → Operational Picture → Decision → shadow Commitment trace before active migration.

The audit does not invalidate the successful mechanisms. It invalidates their use as private top-level Decision owners.

## 16. Five-term recovery outcome

The subsequent architecture recovery review examined five named-but-underdefined v4.3.8 terms.

| Legacy term | Final disposition |
| --- | --- |
| Relevance Envelope | Retired; Field World, Operational Picture, Situation Relevance and Future Space already cover the concern. |
| Decision-Relevant World | Retired; Decision determines which available Knowledge is material to each candidate action or continuing Commitment. |
| Decision-Relevant Constraints | Retired as a standalone Situation Assessment output; constraint applicability and enforcement are strengthened instead. |
| Decision Readiness | Retired; evidence sufficiency is conclusion- and action-specific. |
| Option Horizon | Retired as a standalone object; Option Preservation and action-specific expiry remain. |

Historical references remain provenance. They must not become runtime filtering layers or new subsystems.

