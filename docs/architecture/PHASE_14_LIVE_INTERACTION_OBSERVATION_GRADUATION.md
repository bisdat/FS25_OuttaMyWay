# Phase 14.3 — Live Interaction Observation Graduation

## Purpose

Phase 14.3 graduates a production Observation dependency whose current
`Diagnostic` name and placement deny the responsibility it already performs.

Accepted baseline is `main` after PR #74 merge:

`16c98a0c5948d99faa082d886de900a56f564f4d`

Canonical authority remains **v0.3.0.0**. Last accepted playable identity at
design time is:

**`0.3.0.22 TEST — PHYSICAL CAPABILITY GRADUATION`**

The governing discovery is:

**Production Observation != Diagnostic Output**

## Current Reality

`scripts/diagnostics/LiveInteractionDiagnostics.lua` is stateless calculation
support called directly by `LiveObservationSource`.

It currently owns three functions:

- `pairReferenceKey()`
- `deriveMotion()`
- `observePairState()`

Those functions are not merely human-facing diagnostics.

`deriveMotion()` contributes worker motion evidence carried into the raw
Observation.

Pair observation contributes bounded pair values used when constructing:

- Current Space interaction evidence;
- Field-Bounded Future Space relationship evidence;
- positive interaction evidence used for Encounter admission; and
- live closure/progression evidence.

The same values may also be copied into the `raw.diagnostics` projection. That
secondary diagnostic projection does not make the producing calculation a
Diagnostic responsibility.

## Target placement

Graduate:

`LiveInteractionDiagnostics`

to:

**`LiveInteractionObservation`**

and move:

`scripts/diagnostics/LiveInteractionDiagnostics.lua`

to:

`scripts/observation/LiveInteractionObservation.lua`

`Observation` is deliberate. The module derives bounded live evidence from
supplied pose/speed/radius inputs. It does not:

- admit Job Episodes or Operations;
- establish identity authority;
- perform Situation Assessment;
- select Candidates or Decisions;
- establish Responsibility;
- authorise or execute Control; or
- own diagnostic presentation.

`pairReferenceKey()` remains a correlation-key helper only. It does not become
architectural identity authority.

## Behaviour preservation contract

Phase 14.3 is a pure graduation.

The moved module must preserve exactly:

- all numeric calculations;
- thresholds;
- classifications;
- reasons;
- returned fields;
- nil/unresolved handling;
- pair key format;
- Current Space meaning;
- closing-rate and relative-velocity meaning.

`LiveObservationSource` must preserve:

- raw Observation schema;
- motion evidence meaning;
- interaction admission semantics;
- Field-Bounded Future Space evidence;
- positive-only Encounter admission authority;
- diagnostic projections.

No traffic policy, Regulation, Passage, D-0147, D-0218, Candidate, Constraint,
Decision, Responsibility or Control behaviour changes are permitted.

## Mechanical validation invariant

The implementation must prove that the new module is byte-equivalent to the
accepted old module after only these lexical substitutions:

- `LiveInteractionDiagnostics` -> `LiveInteractionObservation`
- local receiver `Diagnostics` -> `Observation`

Any other difference is outside this tranche.

## Validation

Blocking Structural contracts must prove:

- the old diagnostics file is absent;
- the new Observation file is explicitly sourced;
- `LiveObservationSource` consumes `LiveInteractionObservation`;
- the three public functions remain present;
- production Observation fields and positive interaction evidence remain wired;
- the module gains no Assessment/Decision/Responsibility/Control ownership.

GitHub Actions remains the pytest execution authority.

Local preflight uses repository-owner-available LuaJIT for changed production
Lua syntax plus deterministic source/topology checks.

## GIANTS Reality validation

After blocking CI passes, one ordinary multi-worker live interaction is
sufficient if the log demonstrates:

1. build `.23` loaded;
2. live workers produce motion Observation;
3. pair Observation produces the same current/future interaction evidence path;
4. Encounter/Situation processing continues normally;
5. no OuttaMyWay Lua error or stack trace.

No D-0147/D-0218 re-smoke is required because Phase 14.3 changes neither
non-job Control nor physical actuation.
