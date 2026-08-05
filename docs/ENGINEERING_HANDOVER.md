# Engineering Handover

## Candidate

v4.6.78 — Replacement-Core Architecture Candidate.

Source canonical repository:

- Version: v4.6.71
- ZIP SHA-256: `c675911413c7898b047252ccf764ee5154ecbcfeb3704b80af58f0b3370a0a4f`
- Git commit: `aa9a32846c082d41142558145000dd0971216d7a`

## Authority boundary

- **Canonical source:** v4.6.71.
- **Documentation candidate:** v4.6.78.
- **Active runtime implementation:** v4.6.56.
- **Implementation changes in v4.6.78:** none.
- **Historical experimental implementation:** v4.6.57–v4.6.70 and v4.6.72–v4.6.77, evidence only.

## What v4.6.78 establishes

ADR-0019 and the replacement active architecture documents establish:

- the complete Commitment lifecycle;
- the Obligation Set and Obligation Continuity;
- Governing Basis and terminal-cause precedence;
- terminal settlement;
- Effective Actuation Composition;
- Intent Supersession;
- player takeover;
- Terminal Occupancy;
- Operation termination;
- the normative answers to the eight must-not-be-deferred questions.

## Paper validation

The architecture passed paper walkthroughs for:

1. ordinary successful resolution;
2. multi-stage refuge and rejoin;
3. insufficient evidence;
4. preference-band exhaustion;
5. Representation Fitness failure;
6. completed-worker Terminal Occupancy;
7. player takeover;
8. stop, reposition and restart;
9. GIANTS abort/fault;
10. Intent Supersession;
11. Operation termination with unresolved obligations;
12. invalid action composition.

The walkthroughs produced three precision corrections now integrated:

- Governing Basis;
- first authoritative invalidation determines terminal cause;
- Effective Actuation Composition and one progress owner per assembly.

## Next engineering activity after Canonicalisation

Do not begin by restoring the v4.6.57–v4.6.70 or v4.6.72–v4.6.77 controller chains.

Separate architecture from implementation:

1. define passive runtime value contracts and identities;
2. create lifecycle and Obligation Set traces with no physical Control;
3. implement state-transition and terminal-settlement tests;
4. add shadow Effective Actuation Composition validation;
5. migrate one bounded capability only after those contracts pass;
6. validate against Reality and record any disproven assumption.

Native Continuation Speed, reverse actuation, thresholds and geometry algorithms remain implementation discoveries.

## Canonicalisation condition

Only the repository owner may declare the exact reviewed v4.6.78 candidate canonical. Candidate production does not create authority.

## Required implementation companions

Before coding, review `ARCHITECTURE_CONFORMANCE_MATRIX.md`, `COMMITMENT_STATE_MACHINE.md`, `CANDIDATE_ACTION_CONTRACT.md`, `RESPONSIBILITY_MAP.md`, `REPLAY_VALIDATION_SPECIFICATION.md`, `MIGRATION_PLAN.md` and `REMOVAL_REGISTER.md`.

The v4.6.72–v4.6.77 line is preserved only through `EXPERIMENTAL_LINEAGE_V4.6.72-V4.6.77.md` and the v4.6.77 compliance audit.
