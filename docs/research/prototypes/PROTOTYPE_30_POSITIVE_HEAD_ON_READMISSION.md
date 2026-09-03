# Prototype 30 — Positive Head-On Re-admission

**Build:** v4.7.57 TEST BUILD  
**Decision record:** D-0128  
**Authority:** bounded Resolution-Strategy evidence repair only; no new production Control authority

## Problem

The v4.7.56 run reached positive GIANTS native reacquisition after the first Refuge, then dispatched a second Refuge about 148 ms later. Current pair evidence was only an obtuse/crossing relationship (`headingDot` about -0.38), not the clean pure head-on required by the playbook.

## Hypothesis

Resolution Strategy succession remains valid if two evidence responsibilities are kept separate:

1. positive native reacquisition may establish that the previous mechanical handoff is no longer unresolved;
2. a fresh head-on Resolution Strategy still requires independent current-picture evidence that a genuine pure head-on now exists.

## Bounded mechanism

1. Current Operational Picture must independently publish `AUTONOMOUS_HEAD_ON_RESOLUTION_TEST`.
2. The bounded head-on Candidate now requires `headingDot <= -0.99`, with both Local Intents settled, both Productive Continuations positive, positive Future-Space interaction and no current physical intersection as before.
3. Only after that independent Candidate exists may a prior Refuge diagnostic monitor with positive native reacquisition be superseded.
4. Active Refuge execution or unresolved handoff still blocks duplicate dispatch.
5. No cooldown or elapsed-time criterion creates eligibility.

## Test isolation

D-0127 and the D-0126 0.90 pacing factor are unchanged. Speed oscillation observed in v4.7.56 is deliberately left untouched. The expected live sequence is: first Refuge → native recovery → no immediate redispatch → leader/follower pacing → native boundary revelation → only a later clean opposed continuation may select the second Refuge.
