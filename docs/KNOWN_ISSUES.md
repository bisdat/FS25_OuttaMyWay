# Known Issues

## TS015 interaction evidence is not reaching Encounter construction

Canonical v4.7.14 retained one Field World and one Operation during a direct Condor–Patriot head-on collision, but no Encounter was created. Situation Assessment does create Encounters when positive interaction evidence is supplied. The rejecting branch is not yet proven. v4.7.15 adds diagnostic evidence only.

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
