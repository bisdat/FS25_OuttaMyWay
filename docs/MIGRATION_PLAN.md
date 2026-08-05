# Replacement-Core Migration Plan

> **Boundary:** This is an implementation sequence, not implementation itself.

## Gate 0 — canonical architecture

- review and owner-canonicalise the exact v4.6.78 documentation candidate;
- preserve v4.6.71 runtime authority and v4.6.72–v4.6.77 as failed evidence;
- prohibit behavioural edits during architecture review.

## Gate 1 — offline Architecture Kernel

Implement deterministic value contracts without GIANTS actuation:

1. Observation Snapshot;
2. Knowledge and Operational Picture;
3. Candidate Action;
4. Constraint Verdict Set;
5. Decision;
6. enforcing Commitment state machine and Obligation Set;
7. Control Outcome schema;
8. replay runner and conformance assertions.

Exit condition: the named historical replay suite passes, including negative v4.6.77 lifecycle evidence.

## Gate 2 — passive live shadow

- observe live TS015 and TS016 with zero Control authority;
- publish candidates, verdicts, decisions and lifecycle traces;
- compare live traces with replay expectations;
- correct mismatches offline before another game build.

Exit condition: one TS015 and one TS016 passive run agree with kernel contracts and produce no illegal transition.

## Gate 3 — active vertical slice

Grant authority to one complete TS015 Encounter lifecycle only:

- both viable refuge sides must be supportable;
- one Commitment remains owner through all manoeuvre legs;
- Terminal Settlement and Safe Release must be evidenced;
- repeated Encounter handling, TS016 completion obstacles and broader fixtures remain inactive.

Exit condition: Encounter 1 reaches Safe Release reliably from both viable refuge sides.

## Gate 4 — controlled expansion

Expand one architectural responsibility at a time, with replay and passive evidence preceding active authority.

## Standing prohibition

Implementation convenience must not redefine the architecture. Repeated local branch fixes are evidence of a missing or unenforced contract and must be resolved at the correct abstraction level.
