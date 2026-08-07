# Current v4.7.24 validation boundary

- The superseded fixed-horizon future predictor is removed from the active replacement core; historical archived implementations remain intentionally as evidence records.
- Same-Job-Episode physical resolution / Safe Release remains deliberately unimplemented. Non-positive Future Space or current-footprint evidence cannot terminate an Encounter.
- The manoeuvre sweep itself is still unrepresented; native `TURNING` therefore remains Future-Space unresolved rather than guessed.
- The lifecycle/Future-Space HUDs are temporary diagnostic instrumentation and should be retired when their current validation purpose is complete.
- Decision is passive; no live Commitment or Control authority exists.

# Current v4.7.21 validation boundary

- Field-bounded straight Local Intent is offline-validated but requires live GIANTS validation through a native `straight → turning → straight` sequence.
- The manoeuvre sweep itself is not yet represented in the replacement core; while `isTurn=true`, Future Space remains explicitly unresolved rather than guessed.
- The historical ten-second scalar/filtered positive interaction probe remains active solely for Encounter-admission continuity. It is not authoritative Future Space and must not migrate into Decision behavior.
- Absence of a positive field-bounded continuation intersection cannot establish negative clearance or Safe Release.
- The v4.7.20 live run exposed a separate lifecycle precedence defect: `MEMBERSHIP_INVALIDATED` can terminate an Encounter one assessment cycle before later Job Episode-end evidence is published. This is not addressed in v4.7.21.
- Decision remains passive, no live Commitment is applied and Control is disabled.

# Current v4.7.20 validation boundary

- The Encounter Exit Contract has offline coverage and a partial live pass, but active Encounter termination followed by fresh Encounter creation still requires one HUD-guided live run.
- The temporary Transition HUD is test instrumentation and is not the production OuttaMyWay HUD design.
- Same-Episode physical clearance remains unresolved; absence of positive evidence cannot terminate an Encounter.
- Shape-class-unresolved nodes are excluded from shape-bound measurement rather than guessed.
- Decision remains passive, no live Commitment is applied and Control is disabled.

## v4.7.19 live-validation boundary

- The Encounter Exit Contract is offline-validated but requires one live TS015 stop/restart lifecycle run.
- Same-Job-Episode physical separation does not terminate an Encounter; negative clearance and Safe Release remain unresolved.
- The legacy scalar warning `REPRESENTATION_UNFIT_BUT_NEGATIVE_RESULT_USED` remains diagnostically stale when the combined result is unresolved; this wording is non-authoritative and should be corrected separately.
- Decision remains passive, no live Commitment is applied and Control is disabled.

## v4.7.18 live-validation boundary

- Positive filtered-footprint evidence admission is offline-validated but not yet live-validated.
- Coverage Closure remains absent; non-positive footprint results cannot establish clearance.
- Future footprint evaluation translates current component discs with observed velocity and does not yet model rotational, articulated or deployment sweeps.
- Encounter creation is Knowledge only; ordinary resolution priority and physical strategy remain outside this increment.
- Scalar representation diagnostics remain structurally invalid for the TS015 sprayers and are retained deliberately for comparison.

## v4.7.17 live-validation boundary

- Configuration-specific primitive participation is implemented offline but not yet live-validated.
- Runtime compound-child state is expected to distinguish active from inactive shop geometry; unexpected unavailable or contradictory evidence must remain unresolved.
- The Condor donor is source-specific. Other assets must be discovered independently and may expose different configuration mechanisms.
- Rotational, articulated and configuration-transition swept geometry remains outside the shadow predictor.
- Coverage Closure remains absent; no negative-clearance authority exists.

## Representation coverage remains incomplete

v4.7.17 can resolve, filter and position conservative component spheres, but Inventory Closure and Coverage Closure are not yet established for arbitrary assemblies. A positive shadow result indicates potential interaction among represented components. Absence of a positive result remains `SHADOW_CLEARANCE_UNRESOLVED`.

## Runtime component discovery requires live validation

Condor source identities are retained from proven donors, but runtime identity and geometry are resolved afresh. Patriot uses independent bounded generic discovery. The v4.7.17 TS015 gate must establish that the purchased 36 m Condor excludes inactive alternative shop geometry while Patriot remains independently resolved under Farming Simulator 25 patch 1.21.1.

## Configuration-profile participation requires live validation

v4.7.17 selects a profile-specific participating primitive set and caches it after first observation. Runtime live transforms remain authoritative during animations. The configuration selector and resulting 36 m Condor span remain to be validated in GIANTS Reality.

# Known Issues

## TS015 interaction evidence is not reaching Encounter construction

Canonical v4.7.15 proved the rejecting branch: both Condor and Patriot lacked width, length and radius, so the scalar predictor returned `MISSING_SUBJECT_RADIUS` before CPA and emitted no interaction evidence. v4.7.17 tests a configuration-filtered component-aware representation in passive shadow.

## Physical representation is incomplete and non-conservative

The current live predictor uses root-vehicle `sizeWidth` and `sizeLength` to derive a circular radius. It does not represent the complete configured assembly, unfolded booms or live collision-node occupancy. Negative pair results cannot establish safe clearance.

## Constant-velocity motion is an implementation approximation

The current predictor uses forward heading multiplied by absolute reported speed. Reversing, turning, lateral displacement and near-stationary rotation can contradict that model. v4.7.15 records position-derived motion for diagnosis but does not change prediction.

## Completed or retained assemblies are excluded from active pair prediction

The live source evaluates only workers currently represented as active with a pose. A completed or unresolved-termination assembly may remain physically relevant. v4.7.15 logs the exclusion; it does not change relevance or Encounter admission.

## Field geometry mutation during active work

OuttaMyWay deliberately does not reconcile field merging or splitting after a Job Episode begins. The Field World Snapshot remains immutable until episode termination.

## Source termination cause classification

A matching `lastJob` transition proves source-intent termination but does not distinguish player stop, GIANTS abort and GIANTS fault. Generic inactivity remains non-terminal.

## Passive-only gameplay behaviour

The current validation line reads live state and publishes diagnostics. It does not coordinate workers and cannot issue physical Control.

## Diagnostic performance is not a production baseline

v4.7.15 avoids broad reflection and per-frame logging. Pair detail is sampled once per second and log output is capped independently from evaluation. Formal performance qualification remains pending.

## Multiplayer remains unverified

Passive sampling is server-side where a server object is present. Replacement-core multiplayer behaviour remains unverified, and no Control is active.
