# Spatial Pair Inference Specification

## Identity and authority

**Specification Jurisdiction:** Spatial Pair Inference  
**Jurisdiction ID:** `SPATIAL_PAIR_INFERENCE`

**Primary Architecture Authority:** [`architecture/BLOCKED_PROGRESS_QUALIFICATION.md`](../architecture/BLOCKED_PROGRESS_QUALIFICATION.md#specification-jurisdiction--spatial-pair-inference)

This Specification defines only the accepted **one-second gate and nearest eligible root within 30 m** as a pure evaluator. It does **not** own native blocked-event Observation, encounter continuity, full Situation Assessment, Pair Commitment, GIANTS navigation or worker Control.

## Inputs and evaluation

The caller provides (1) finite **confirmed blocked milliseconds** accumulated within **one positively supported unresolved encounter**, excluding known unblocked intervals; (2) the blocked worker's stable assembly `rootId` and finite world `x,z` position; (3) a **plain array** of present assembly-root records carrying stable `rootId`, finite `x,z`, and an explicit **`eligible=true`** when independently admitted as a possible worker candidate.

The evaluator MUST:

- Return no candidate when blocked time is missing/invalid or **<1000 ms**. At exactly 1000 ms candidate selection is admitted; the evaluator itself MUST NOT accumulate pulses or infer continuity.
- Exclude the blocked assembly itself and any candidates not explicitly eligible or without valid coordinates.
- Compare **horizontal X/Z** world positions of assembly roots, choosing the **nearest eligible other worker at distance ≤30 m**; return no worker candidate when none is inside this radius.
- Return a **candidate identity and approximate root-to-root distance only**, without conferring causal attribution or authorization. Equidistant ties may retain the first record in the supplied plain array.
- Never inspect GIANTS vehicles, discover eligible assemblies, control jobs, create native hooks, predict trajectories, model implement widths or classify A8 passage.

The accepted radius is a pragmatic **owner choice**, not a physical-collision claim. The upstream native sampler now supplies single-pulse inputs, but broader multi-pulse continuity and Operation membership remain unimplemented; downstream settlement responsibilities remain separate and unimplemented; a successful result is **not** permission to relocate or hold.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/assessment/SpatialPairInference.lua`](../scripts/assessment/SpatialPairInference.lua) | `REALISES` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/spatial_pair_inference.lua`](../tests/shell/spatial_pair_inference.lua) | `CHALLENGES` |

## Implementation traceability and limits

[`scripts/main.lua`](../scripts/main.lua) loads the pure evaluator. The passive [Native Blockage Observation](../scripts/observation/NativeBlockageObservation.lua) now calls it when an observed continuous native `isBlocked` pulse reaches one second; this is candidate evidence, not vehicle Control. The offline Lua test challenges the numeric input gate, nearest candidate, 30 m radius, exclusion, and non-authority. It does not validate GIANTS event timing, worker root evidence, blocked pulse continuity, real-world causation, or vehicle behaviour. No in-game test claim follows from offline CI. The previously waived TEST 0.5.0.6 smoke remains a waiver, not a PASS.
