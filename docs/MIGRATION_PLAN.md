## v4.7.23 Future-Space Encounter-admission live gate

1. Start from canonical v4.7.21 and carry forward the live-passed v4.7.22 incomplete-membership correction.
2. Establish the familiar cross/head-on relation and wait for the HUD `FUTURE SPACE ENCOUNTER`.
3. Confirm the log shows Future-Space-positive Encounter admission and, where geometry permits, `legacyShadowPositive=false` at first creation.
4. Stop either AI worker; confirm the Encounter exits as `JOB_EPISODE_ENDED`, not `MEMBERSHIP_INVALIDATED`.
5. Restart the worker and re-establish the interaction; confirm a fresh Job Episode and fresh Future-Space Encounter.
6. Keep Decision passive, no live Commitment, `control=false`.
7. After PASS, remove the superseded legacy shadow future predictor/messages in a cleanup increment before same-Episode Safe Release work.

> **Canonical baseline:** v4.7.21 (`dc7e1220d12b9d77039d164343a8a530787ccebdd79bdf838a200c3713b27482`)  
> **Current candidate:** v4.7.23  
> **Control authority:** disabled

## v4.7.22 Encounter termination-precedence live gate

- Use the familiar TS015 head-on fixture.
- Follow the transition HUD; do not time the stop from console chatter.
- Wait for `ENCOUNTER ACTIVE`, then manually stop either AI worker.
- The unresolved stop sample may have incomplete Operation-membership evidence; it must retain the existing Encounter rather than terminate as `MEMBERSHIP_INVALIDATED`.
- Confirm the subsequent authoritative Job Episode end closes the Encounter as `JOB_EPISODE_ENDED` with terminal cause evidence.
- Restart the stopped worker when instructed.
- Re-establish the approach and confirm a fresh Encounter identity is created; the terminal Encounter must not resurrect.
- Confirm Decision remains passive, no live Commitment is applied and `control=false`.

> **Canonical baseline:** v4.7.21 (`dc7e1220d12b9d77039d164343a8a530787ccebdd79bdf838a200c3713b27482`)  
> **Historical candidate:** v4.7.22 — live gate PASS, not canonicalised separately  
> **Architecture authority:** existing Encounter Exit Contract and Operation-membership evidence contracts; no new lifecycle architecture

## v4.7.21 Future Space conformance gate

- Use the familiar headland-cross/head-on development sequence without intentional intervention.
- Observe `OTM FUTURE SPACE` while workers are on settled passes, during the native headland turn, and after the turning worker settles.
- Confirm `STRAIGHT → measured Field World boundary`, `TURNING`, then a fresh settled Local Intent epoch.
- Confirm a pair Future-Space intersection is published when the settled continuations geometrically intersect.
- Treat measured metres as evidence only; no time/distance literal governs admission.
- Stop before contact once the sequence is captured.
- Confirm Decision remains passive and `control=false`.

> **Historical baseline:** v4.7.18  
> **Canonicalised result:** v4.7.21  
> **Architecture authority:** canonical repository architecture, especially ADR-0006/ADR-0012; implementation correction D-0041

## v4.7.20 HUD-guided Encounter Exit gate

- Follow the transition HUD rather than scanning continuous console diagnostics.
- Wait for `ENCOUNTER ACTIVE`, then manually stop either AI worker.
- Wait for `ENCOUNTER TERMINATED`, then restart the stopped worker.
- After `NEW JOB EPISODE`, re-establish head-on convergence.
- Stop when `NEW ENCOUNTER CREATED / Test complete` appears.
- Verify the first Encounter is terminal, the second has a different identity, no stale Episode evidence transfers, and `control=false` throughout.
- Confirm no GIANTS shape-bound errors are emitted for transform groups.

> **Canonical baseline:** v4.7.18  
> **Historical candidate:** v4.7.20  
> **Architecture authority:** canonical repository architecture plus D-0039 and diagnostic correction D-0040

## v4.7.19 Encounter Exit Contract gate

- Establish the standard TS015 positive convergence and confirm `EN-00001 CREATED` then `RETAINED`.
- Before contact, manually stop one AI worker.
- Confirm the old Job Episode ends and `EN-00001` reports `TERMINATED reason=JOB_EPISODE_ENDED` with the authoritative terminal cause.
- Restart the stopped worker and confirm a fresh Job Episode identity.
- Confirm no Encounter is inherited before renewed positive evidence.
- Re-establish convergence and confirm a fresh `EN-00002 CREATED`.
- Confirm the old Encounter remains terminal, Decision stays passive, no Commitment is applied and `control=false`.

> **Canonical baseline:** v4.7.18  
> **Current candidate:** v4.7.19  
> **Architecture authority:** canonical repository architecture plus D-0039

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