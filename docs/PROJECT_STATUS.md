# Project Status

Version: 4.6.2
Status: Prototype 01 Release Candidate awaiting TS001 game evidence and independent owner review
Baseline package: canonical v4.6.1
Behavioural mode: passive observation only; no avoidance or vehicle-control action

## Current Focus

Milestone 4 — Architectural Prototyping.

Prototype 01 tests whether Situation Assessment can identify a **Conflict Emergence Point** before two native GIANTS AI workers reach immediate physical conflict.

The existing TS001 save is the unchanged observation fixture. Its two workers follow independent native routes that ultimately converge head-on.

## Architectural Hypothesis Under Test

> Situation Assessment can detect the transition from independent trajectories to a plausible shared Conflict Zone before immediate conflict, using observable position, heading and motion evidence.

The probe records a provisional sequence:

1. independent;
2. converging;
3. conflict-relevant;
4. immediate conflict;
5. encounter outcome.

These labels are diagnostic aids, not accepted architecture and not decisions to intervene.

## Current Architectural Understanding

- Reality exists independently; observations sample it; Knowledge is reconstructed rather than possessed directly.
- Situation Space describes the structured set of possible situations, including entities, states and relationships.
- Current Situation is the system's present estimated point within Situation Space.
- Situation Assessment transforms observations into the maintained Current Situation and remains the sole interpreter of observations.
- Future Space preserves multiple plausible futures rather than committing to one prediction.
- Action Space describes the actions currently available; anticipation is valuable because it preserves Action Space.
- Time is the dimension in which Reality, observations, Knowledge, Future Space and Action Space evolve.
- Conflict Zone remains operationally useful but is a derived phenomenon rather than a root primitive.
- Commitment remains an Accepted concept with creation, maintenance, completion and cancellation lifecycle semantics.
- Execution acts within an active Commitment and validated capability boundaries.
- Outcomes return as observations through Situation Assessment before further decisions.
- Native GIANTS AI remains authoritative unless OuttaMyWay has a specific, bounded reason to intervene.

## Immediate Development Objective

Run Prototype 01 against TS001 and review the resulting evidence before changing thresholds or adding behaviour.

The first evidence review must determine:

- whether the pair is observed early enough;
- whether proximity can be distinguished from convergence;
- whether a Conflict Emergence Point appears before immediate conflict;
- whether the relationship is correctly recognised as head-on;
- whether time and distance at closest approach are stable enough to support Situation Assessment;
- whether GIANTS turns or speed changes cause diagnostic oscillation;
- whether the final encounter outcome can be reconstructed.

## Prototype 01 Implementation Boundary

The candidate adds a read-only `ConflictEmergenceProbe` that consumes the central Observer state and records:

- vehicle identity, position, heading and speed;
- worker phase, turn state and blocked state;
- separation and closing rate;
- heading relationship;
- time to closest approach and distance at closest approach;
- projected closest-approach midpoint;
- provisional stage transitions and thresholds.

No steering, speed, implement, route, priority or AI-job changes are permitted.

## Passive Boundary Ordering Gap

Review of v4.6.1 found that Traffic Manager v2 updated before the runtime reached its `AI_EXPLORER_ONLY` return. The observer-only declaration therefore did not structurally guarantee passivity by itself.

v4.6.2 corrects that ordering, disables Traffic Manager v2 explicitly for Prototype 01, and causes the probe to disable itself if its passive configuration is not satisfied.

## Engineering Baseline

The repository is the source of project knowledge. Authoritative engineering records include:

- `ENGINEERING_ARCHITECTURE.md` — constitution and release contract;
- `ENGINEERING_HANDOVER.md` — current continuation and test guidance;
- `CONCEPT_REGISTER.md` — accepted, deferred and rejected concepts;
- `DECISION_LOG.md` — explicit choices and rationale;
- `ENGINEERING_JOURNAL.md` — durable discoveries;
- `GLOSSARY.md` — current shared vocabulary;
- `prototypes/PROTOTYPE_01_CONFLICT_EMERGENCE.md` — current hypothesis, evidence contract and test procedure;
- `REPOSITORY_RELEASE_SYSTEM.md` and `../rrs/README.md` — repository transition and candidate-production boundary.

## Known Constraints

- Prototype 01 uses constant-velocity closest-approach prediction; this is an evidence instrument, not an accepted predictive model.
- Provisional distance and time thresholds are deliberately exposed in every sample and may be disproved.
- Active GIANTS course-segment mapping remains unreliable through some turns.
- Course-relative ETA and remaining-distance estimates are not yet trustworthy enough for broad live priority decisions.
- Multiplayer testing remains limited.
- Older reactive and recovery systems remain in the repository but are bypassed in observer-only mode.
- A passing repository pipeline validates packaging and selected knowledge invariants, not in-game behaviour.

## Concept Review — v4.6.2

- Accepted concepts remain unchanged.
- `Conflict Relevance Transition` and `Conflict Emergence Point` are Deferred while Prototype 01 seeks evidence for stable boundaries.
- `Commitment Stability Boundary` remains discussion language and is not promoted by this candidate.
- No existing Deferred or Rejected concept changes status.

## Release Character

v4.6.2 adds passive diagnostic instrumentation and strengthens the observer-only execution boundary. It adds no avoidance response and makes no positive vehicle-control intervention.

The candidate must be validated in the unchanged TS001 save before any tuning, Commitment work or Control implementation begins.
