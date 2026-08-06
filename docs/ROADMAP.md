# FS25_OuttaMyWay Roadmap

## Current gate — passive live validation of Field World Equivalence Authority

ADR-0021 and D-0033 are implemented passively by the v4.7.14 candidate. Offline conformance is complete; the remaining question is whether live GIANTS captures from concurrent workers in the merged 68–69–70 workspace resolve coherently into one Field World and one Operation.

The live gate must demonstrate:

1. each Job Episode retains its own immutable Snapshot and exact polygon provenance;
2. non-exact but materially equivalent captures receive one resolved Field World identity;
3. the workers join one active Operation;
4. no pairwise-only tolerance chain is used;
5. unresolved evidence receives no Operation authority;
6. Control remains disabled.

> **Current canonical baseline:** v4.7.13  
> **Current implementation candidate:** v4.7.14 Field World Equivalence Authority  
> **Control authority:** disabled

## v4.7.x implementation sequence

1. **Bootstrap kernel** — v4.7.0 canonical.
2. **Observation and identity** — v4.7.1 canonical.
3. **Knowledge boundary** — v4.7.2 canonical.
4. **Deterministic Decision boundary** — v4.7.3 canonical.
5. **Replay conformance** — v4.7.4 canonical.
6. **Passive live validation attempts** — v4.7.5 and v4.7.6 evidence builds.
7. **Live AI state discovery** — v4.7.7 diagnostic evidence build.
8. **Targeted active-job and field evidence** — v4.7.8 evidence build.
9. **GIANTS-compatible immutable traversal and passive pipeline closure** — v4.7.9 evidence build.
10. **Source-field authority, derived Field World discovery and source-intent termination** — v4.7.10 candidate.
11. **Field World Equivalence Authority architecture** — v4.7.13 canonical.
12. **Field World Equivalence Authority implementation** — v4.7.14 candidate; offline gate passed, passive live gate pending.
13. **First exclusive vertical slice** — one bounded Hold/release lifecycle owned entirely by the replacement core, only after the passive gates pass.
14. **Controlled expansion** — one canonical capability or lifecycle boundary per evidence-backed increment.

## Build-economy rule

Offline tests remain mandatory before packaging. Live cycles are reserved for GIANTS Reality questions that offline fixtures cannot answer.

## Standing prohibitions

- no architecture inferred from archived code;
- no broad reflection retained as production observation;
- no active imports from `scripts/archive/`;
- no farmland-to-field identity substitution;
- no guessed Field World identity when evidence is unresolved;
- no tolerance-chain identity class;
- no Control authority during passive validation.
