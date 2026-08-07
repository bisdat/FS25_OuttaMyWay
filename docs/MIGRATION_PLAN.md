## v4.7.18 positive-evidence admission gate

- Repeat TS015 from the canonical fixture.
- Confirm the scalar path still reports missing radius.
- Confirm the filtered footprint reports future convergence and `interactionEvidenceSource=FILTERED_PLAN_VIEW_POSITIVE`.
- Confirm emitted and received counters both become one and one Encounter is created before contact.
- Confirm Encounter retention while positive evidence persists and bounded loss when it clears or the Job Episode ends.
- Confirm Decision remains passive, no Commitment is applied and `control=false`.

> **Canonical baseline:** v4.7.17  
> **Current candidate:** v4.7.18  
> **Architecture authority:** canonical repository architecture plus D-0038

## Historical v4.7.17 configuration-participation gate

- Repeat TS015 with the purchased 36 m Condor and 36 m Patriot.
- Confirm the Condor retains its complete cached inventory while excluding inactive alternative shop geometry from the current profile.
- Confirm the deployed Condor lateral span is broadly consistent with 36 m rather than approximately 54 m.
- Confirm Patriot remains independently resolved and configuration-filtered.
- Confirm geometry API measurement counts remain stable after Job Episode cache construction; new profile activity checks occur only when a profile is first encountered.
- Preserve passive shadow authority, unchanged Encounter predicates and `control=false`.

> **Historical canonical baseline:** v4.7.15  
> **Accepted candidate:** v4.7.17  
> **Architecture authority:** canonical repository architecture plus accepted D-0037 implementation correction

## Historical migration gates

# Migration Plan

## v4.7.12 closure validation

- Capture merged 68, 69 and at least two seeds in old 70.
- Confirm canonical vertices and spatial comparison metrics are logged.
- Capture both split-77 polygons and confirm low overlap/high separation evidence.
- Confirm diagnostic comparisons do not merge Operations.
- Confirm termination, performance and `control=false`, then canonicalise with the limitation documented.

## v4.7.11 validation

- Prove seed-invariant identity across merged 68–69–70.
- Prove distinct identities for both split-77 areas.
- Prove five concurrent Job Episodes produce three active Operations.
- Prove reverse-order termination settles each Operation correctly.
- Preserve no-stutter performance and `control=false`.

> **Historical gate:** v4.7.10 field identity and lifecycle evidence

- Validate exact source-field polygon labels for 68 and 77.
- Validate the derived GIANTS field boundary and retained labels for the merged 68–69–70 area.
- Validate `lastJob` source-intent termination closes the Valtra Job Episode and Operation.
- Preserve blockage continuity for Condor and Patriot.
- Keep Commitment mutation and Control disabled.

> **Architecture authority:** canonical v4.6.78  
> **Historical gate:** v4.7.9 GIANTS-compatible immutable traversal and polygon field identity

## Completed gates

- Gate 0 — clean implementation boundary: v4.7.0.
- Gate 1 — Observation and identity: v4.7.1.
- Gate 2A — Knowledge boundary: v4.7.2.
- Gate 2B — deterministic Decision boundary: v4.7.3.
- Gate 2C — replay conformance: v4.7.4.

## Gate 3 — passive live validation

- v4.7.5: listener and zero-Control PASS; Job Episode admission FAIL.
- v4.7.6: broader assembly discovery PASS; guessed activity evidence FAIL.
- v4.7.7: diagnostic PASS; discovered active-job membership, stable job identity, blockage continuity and probe-induced sampling stall.
- v4.7.8: targeted raw job evidence and performance PASS; sealed-value traversal and field identity FAIL.
- v4.7.9: validate explicit immutable traversal, Job Episode admission, polygon field identity, unresolved-field bounded observation and zero Control.

Gate 3 passes only when the live trace shows the expected Job Episodes and, where field identity is supportable, the expected Operation without intervention or false terminal inference.

## Gate 4 — first exclusive vertical slice

Blocked until Gate 3 passes and the passive evidence path is recorded as canonical implementation knowledge.

## Stop condition

An apparent contradiction with canonical v4.6.78 stops the affected path for owner review. It does not authorise a special case or new architecture.