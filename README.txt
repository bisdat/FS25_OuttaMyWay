FS25_OuttaMyWay v4.6.78 — Replacement-Core Architecture Candidate

Status
------
Documentation-only Release Candidate proposed for owner review and Canonicalisation. It is not canonical until the repository owner explicitly declares this exact package canonical.

Canonical source
----------------
Built from exact owner-declared canonical v4.6.71:
SHA-256 c675911413c7898b047252ccf764ee5154ecbcfeb3704b80af58f0b3370a0a4f
Git commit aa9a32846c082d41142558145000dd0971216d7a

Runtime boundary
----------------
The active runtime implementation remains v4.6.56. No Lua runtime, Decision, Commitment or Control behaviour is changed by v4.6.78.

Purpose
-------
This candidate records the completed replacement-core architecture before coding begins.

The normative model now includes:

- ACTIVE, WAITING_FOR_EVIDENCE and SETTLING;
- terminal dispositions including SUPERSEDED_BY_NEW_INTENT;
- Governing Basis and terminal-cause precedence;
- first-class Obligation identity and Obligation Continuity;
- Terminal Settlement, Safe Release and Safe Handover;
- one progress-actuation owner per assembly;
- Effective Actuation Composition validation;
- Terminal Occupancy;
- player takeover;
- Operation termination;
- independent Job Episode admission;
- Continuing Intent Priority;
- Committed Demand, Potential Demand and Temporary Slack.

Architecture snapshots from v4.6.71 are preserved under docs/archive/architecture. The actual v4.6.72–v4.6.77 runtime-validation line is preserved as failed evidence and is not promoted.

Start here
----------
1. docs/PROJECT_VISION.md
2. docs/PROJECT_STATUS.md
3. docs/ENGINEERING_HANDOVER.md
4. docs/ARCHITECTURE.md
5. docs/ARCHITECTURE_FLOW.md
6. docs/adr/ADR-0019-replacement-core-commitment-lifecycle.md
7. docs/ROADMAP.md

Next phase
----------
After owner Canonicalisation, implementation planning begins separately. The first implementation must be passive lifecycle, obligation and authority tracing with deterministic state-transition tests. Physical Control migration follows only after those contracts pass.

The repository remains the source of project knowledge. No chat history is required to understand the continuation point.
