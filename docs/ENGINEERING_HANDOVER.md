# Engineering Handover

## Current candidate: v4.6.50

v4.6.50 begins from exact owner-declared canonical v4.6.43 (`c312d74eedb20d800253247b784a992073a4cf44c0413588fa7f382b801cba4c`, Git `7dfb9f466566bbae1d47a2a54d66c08177fbae5b`).

It is an architecture-only recovery candidate. Runtime behaviour remains v4.6.43. Temporary v4.6.44–v4.6.49 implementation is not promoted.

## Why the recovery was required

The temporary TS015/TS016 path proved several useful mechanisms but also revealed:

- Prototype Boundary Leakage;
- Assessment–Decision–Control Collapse;
- Architectural Constraint Enforcement Gap;
- Fragmented Commitment Ownership.

Repeated local corrections were rational, but the fixture controller had become the easiest place to add observation, interpretation, Decision and Control. The candidate records this evidence and restores architectural precedence.

## Recovered authority boundary

```text
Observation
→ Situation Assessment
→ Operational Picture Knowledge
→ Decision
→ Commitment
→ Control
→ Outcome Observation
↺ Situation Assessment
```

Situation Assessment remains aware of the complete bounded Field World. Decision applies current Knowledge and every mandatory constraint to each candidate action and continuing Commitment. Control executes bounded requests and cannot decide role, refuge suitability, relevance, passage completion or release.

## Legacy-term disposition

Retired:

- Relevance Envelope
- Decision-Relevant World
- Decision-Relevant Constraints as a standalone Situation Assessment output
- Decision Readiness
- Option Horizon as a standalone object

Preserved and strengthened:

- Sufficiency over Completeness;
- Option Preservation;
- Earliest Sufficient Action;
- Minimum Effective Augmentation;
- Option-Preserving Augmentation.

## Preserved experimental evidence

The v4.6.44–v4.6.49 discoveries and hardcoded-authority audit are retained under `docs/50_Research/` and `research/architecture_recovery/`. They are an Experimental Capability Corpus, not active architecture.

## Continuation after owner review

If the owner declares this exact candidate canonical:

1. synchronise the unchanged package into local and GitHub repositories;
2. record its SHA-256 and Git commit;
3. begin the next increment from v4.6.50 canonical;
4. implement only a passive shadow authority trace;
5. issue no vehicle-control action until replay evidence demonstrates architectural conformance.

Do not resume “one more fix” work on TS015/TS016 before the passive path is reviewed.

## Deferred Publication Readiness Review

**Mod Description Drift:** restore `modDesc.xml` to a stable public description before publication.
