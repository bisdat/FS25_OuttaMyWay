# Engineering Handover

## Canonical baseline

The exact reviewed v4.6.4 candidate was tested, accepted and explicitly declared canonical by the repository owner.

Accepted candidate SHA-256:

`11928affbc62d41b3a67534147266ffdfc1a0cdd1915c062010094a9705fc13c`

Every new Engineering Transformation must begin from the complete canonical v4.6.4 package supplied as its immutable baseline.

## Completed increment

Prototype 03 tested:

> Situation Assessment can identify a Candidate Option Preservation Window using manoeuvre ordering, a Progress Entity, an Intent Revelation Point and remaining Response Margin before both trajectories settle into an established conflict.

The unchanged TS001 run strongly supported the hypothesis.

## Accepted evidence

Condor began manoeuvring before Patriot. Patriot began its own manoeuvre before Condor's resulting trajectory had settled, opening a candidate window. Condor's intent was declared sufficiently revealed while Patriot remained approximately 56% through its turn and travelling at about 15 km/h.

Conflict establishment occurred approximately 12.0 s after intent revelation. The provisional stop-time estimate was approximately 2.58 s, leaving about 7.42 s after the exposed 2.0 s safety buffer. The player independently observed that Patriot still had time to wait.

The evidence supports an observable temporal option-preservation interval and demonstrates the Progress Preservation Invariant for this pair: Condor could continue as Progress Entity while Patriot remained the hypothetical hold candidate.

## Disproved release assumption

A manual follow-up stopped Patriot when Condor appeared established in the lane. Stopping abandoned Patriot's GIANTS AI job. Condor initially moved away. After Patriot's AI job restarted and Patriot entered its lane, Condor performed a later repositioning turn across Patriot's path, producing a new crossing conflict.

This disproved the assumption that revelation of the current lane is sufficient evidence for safe release. It also reduced confidence in the simple alternating-lane route model. The result is qualified by Job Restart Perturbation and must not be treated as evidence that a future speed-zero hold would produce the same route sequence.

The next hypothesis must distinguish local intent from continuation intent and identify when previously revealed intent expires.

## Implementation state

- `ConflictEmergenceProbe.lua` retains pair kinematics and emergence evidence.
- `ConflictConfidenceProbe.lua` retains trajectory-settlement and conflict-confidence evidence.
- `OptionPreservationProbe.lua` retains manoeuvre ordering, Progress Entity, Intent Revelation, response-margin and exhaustion evidence.
- all three probes run before the observer-only runtime return;
- Traffic Manager v2 remains disabled;
- no Decision, Commitment or Control behaviour is enabled.

Two instrumentation defects remain recorded for a future declared increment: startup manoeuvre contamination and repeated exhaustion-candidate logging.

## Immediate continuation point

The next single-hypothesis increment should remain passive and test:

> Situation Assessment can distinguish locally revealed intent from continuing route intent, expire stale intent when a new manoeuvre begins, and determine whether a hypothetical release remains safe through the Progress Entity's next repositioning event.

This work should expose the boundary between a Local Intent Horizon and a Safe Release Point. It must not yet implement a hold or release.

## Repository entry point

1. `docs/README.md`
2. `docs/PROJECT_STATUS.md`
3. `docs/prototypes/PROTOTYPE_03_OPTION_PRESERVATION.md`
4. `docs/prototypes/PROTOTYPE_02_CONFLICT_CONFIDENCE.md`
5. `docs/CONCEPT_REGISTER.md`
6. `docs/DECISION_LOG.md`
7. `docs/ENGINEERING_JOURNAL.md`

Continue using:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat
