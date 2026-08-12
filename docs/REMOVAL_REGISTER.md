# v4.7.98 D-0144 live-runtime retirement boundary

The following historical diagnostics remain in the repository as empirical evidence but are deliberately **not sourced or scheduled by `scripts/main.lua`** in v4.7.98:

- `scripts/diagnostics/DemonstratedProductiveCoverageProbe.lua`
- `scripts/diagnostics/ProductiveCoverageResidualProbe.lua`
- `scripts/diagnostics/RefugeQualificationShadowProbe.lua`

Reason: D-0144 retires chessboard colouring, continuous Productive History reasoning and continuous Refuge qualification from current production responsibilities. No replacement shape/coverage calculation is introduced. Preserve the files until a later repository-history/archive pass can relocate them without obscuring provenance.

# v4.7.0 active-core removal boundary

The complete canonical v4.6.78 active Lua tree was removed from execution and preserved under `scripts/archive/v4_6_78/`. It is not deleted from historical evidence. Active v4.7.x code must not import the archive. Module-level dispositions are recorded in `LEGACY_MODULE_DISPOSITION.csv`.

# Experimental Removal and Donor Register

> **Purpose:** prevent failed branch logic from becoming the replacement core by inheritance.

| Experimental element | Disposition | Reuse condition |
|---|---|---|
| `DecisionEngineActive` procedural action ladder | Remove as governing Decision model | isolated calculations may be donors after Candidate Action and verdict contracts exist |
| current `CommitmentLedger.apply()` transition semantics | Remove/replace | no reuse without enforcing state-machine legality |
| single preferred refuge selected by Situation Assessment | Remove | candidate evidence generation may be retained if all candidates are published |
| generic Hold-unavailable → Leader-reposition fallback | Remove | only an explicit admissible candidate may authorise reposition |
| Intent Expiry as Commitment completion | Remove | intent change becomes Governing Basis reassessment or terminal cause with settlement |
| branch-local post-handover and responsibility guards | Replace with generic obligations and constraints | evidence predicates may be retained as inputs |
| synthetic vocabulary/static ownership tests | Retain only as low-level checks | cannot satisfy composition-validation gate |
| broad Prototype 16 passage controller | Decompose | physical mechanisms may become narrow capabilities |
| Observation adapters | Preserve as donor | must emit immutable facts with provenance |
| Native continuation estimation | Preserve as donor evidence | not authoritative until fitness and uncertainty contract passes |
| Future Space calculations | Preserve as donor | must expose provenance and representation fitness |
| structured architecture traces | Preserve | align with replacement record schemas |
| speed and Hold lease mechanisms | Preserve as capability donors | Commitment owns purpose, lifecycle and release obligations |
| Native Handover mechanism | Preserve as capability donor | operational sufficiency remains Commitment-owned |
| manoeuvre-leg execution | Preserve as capability donor | one committed leg, narrow authority, physical outcomes only |
| refuge candidate evidence generation | Preserve as generator donor | no preselection in Situation Assessment |

Nothing in this register is promoted merely because it worked in one fixture. Reuse requires a named architectural owner, value contract, replay evidence and bounded authority.
