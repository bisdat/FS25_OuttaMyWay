# Project Status

Version: 4.6.78 Replacement-Core Architecture Candidate  
Status: documentation-only Release Candidate; non-canonical until owner declaration  
Canonical repository baseline: v4.6.71 — `c675911413c7898b047252ccf764ee5154ecbcfeb3704b80af58f0b3370a0a4f` — Git `aa9a32846c082d41142558145000dd0971216d7a`  
Active runtime implementation: v4.6.56

## Current engineering phase

Replacement-core architecture closure and documentation synthesis.

No runtime, Control, Decision or behaviour implementation is changed by this candidate.

## Architectural completion

The replacement core has passed a twelve-scenario paper validation without exposing:

- a lifecycle dead end;
- an ownerless obligation;
- conflicting terminal semantics;
- a need for another architectural subsystem.

The validated core now includes:

- three non-terminal Commitment states: `ACTIVE`, `WAITING_FOR_EVIDENCE`, `SETTLING`;
- five terminal dispositions;
- Governing Basis and first-authoritative-invalidation precedence;
- first-class Obligation identity and exactly-one-owner continuity;
- terminal settlement through satisfaction, evidenced basis cessation or accepted transfer;
- one objective-progress actuation owner per assembly;
- Effective Actuation Composition validation;
- Terminal Occupancy;
- player takeover without fictional internal transfer to the player;
- Operation termination with surviving settlement responsibility;
- Intent Supersession and bounded predecessor/successor coexistence;
- independent Job Episode admission;
- Continuing Intent Priority;
- Committed Demand, Potential Demand and Temporary Slack;
- Preference-band exhaustion and Representation Fitness contracts.

## Eight must-not-be-deferred questions

All eight now have normative answers in `ARCHITECTURE.md` and ADR-0019:

1. completed-worker relevance;
2. Continuing Intent Priority;
3. Terminal Occupancy obligations;
4. multi-stage strategy continuity;
5. terminal settlement;
6. player responsibility boundary;
7. route-substitution scope;
8. unresolved remnants after Operation termination.

## Runtime boundary

The active executable implementation remains v4.6.56, as retained in canonical v4.6.71.

Historical v4.6.57–v4.6.70 and v4.6.72–v4.6.77 implementations remain non-authoritative evidence. The replacement architecture is not claimed to be implemented.

## Remaining non-architectural discoveries

These do not block architectural Canonicalisation:

- Native Continuation Speed Estimate;
- Reverse Actuation Discovery;
- action-specific Representation Fitness implementation;
- exact candidate-generation geometry;
- capability adapters and GIANTS extension points;
- numerical thresholds and time budgets;
- runtime validation of Effective Actuation Composition.

## Candidate review condition

Review must confirm that:

- the current normative documents agree;
- historical architecture is preserved in archive snapshots;
- no runtime file changed;
- v4.6.71 is correctly recorded as the canonical source;
- the candidate does not claim implementation;
- RRS reports no blocking findings.

After owner Canonicalisation, implementation planning may begin as a separate engineering activity.

## Intervening release-line disposition

v4.6.72–v4.6.77 were temporary non-canonical runtime-validation increments. Their exact fingerprints and findings are preserved in `EXPERIMENTAL_LINEAGE_V4.6.72-V4.6.77.md`. The v4.6.77 audit concluded that the branch was not architecture-compliant and must not be used as the executable baseline for v4.6.78.
