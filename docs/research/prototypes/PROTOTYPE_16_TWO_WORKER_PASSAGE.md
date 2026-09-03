# Prototype 16 — Two-Worker Passage

## Scenario

TS015 uses the established Condor Endurance II / Patriot 4450 same-working-pass head-on fixture.

- Condor is the fixed Yield Entity.
- Patriot is the fixed Progress Entity.
- Both original jobs remain GIANTS field-worker jobs.
- Patriot remains completely under GIANTS control.
- The operator manually arms the previously validated Condor sidestep.

## Question

> Can the validated Retreating Unilateral Sidestep create sufficient physical passage for Patriot to continue uninterrupted, after which Condor can rejoin and resume its original GIANTS job?

## TS015-A result — 22 m lateral target

TS015-A partially supported the hypothesis. The control sequence succeeded, but physical passage failed.

Observed runtime evidence:

- Condor reached refuge with approximately 164.05 m pair separation;
- actual refuge displacement was approximately 21.44 m lateral and 11.45 m rearward;
- Full Compact Configuration followed at approximately 159.34 m pair separation;
- Patriot remained near 25 km/h until closest approach;
- Patriot's centre moved approximately 5.17 m beyond Condor's stop anchor;
- Patriot became blocked and stopped at approximately 22.33 m centre separation;
- Condor remained compact in `FAILED_HELD`.

The result establishes:

- **Vehicle-Centre Passage Is Not Assembly Passage** — reference-point progression does not prove the complete Behavioural Assembly has cleared;
- **Clearance Budget Underrun** — 22 m commanded lateral displacement was insufficient for the deployed Patriot assembly plus compact Condor and uncertainty margin.

Because Condor was already at refuge while Patriot remained far away, this was not an egress-time failure and does not support adding Egress Protection Hold for the same geometry.

## TS015-B hypothesis — 28 m lateral target

Increasing only the commanded lateral refuge from 22 m to 28 m will create sufficient complete-assembly passage while preserving the otherwise validated TS015-A sequence.

## Preserved behaviour

TS015-B retains:

- confirmed stopped pose as waypoint frame;
- 12 m rearward egress;
- 6 m forward rejoin;
- 15 km/h egress and ingress cruise;
- 6 km/h precision speed;
- provisional egress start at `foldAnimTime >= 0.15`;
- Full Compact Configuration before rejoin;
- vehicle-centre virtual fence;
- unchanged positive passage evidence;
- no Patriot hold.

The only movement change is:

```text
commanded lateral refuge: 22 m → 28 m
```

The known console-side inversion remains deliberately retained so lateral depth is the only new behavioural variable.

## Positive passage evidence

Condor remains compact at refuge until Patriot continuously satisfies all of the following:

1. Patriot is at least 20 m behind Condor's confirmed stop anchor along Condor's original working direction.
2. Centre-to-centre separation is at least 35 m.
3. Separation is increasing by at least 0.20 m/s.
4. Patriot remains active, moving and unblocked.
5. The conditions persist for 1.5 seconds.

A further one-second post-confirmation dwell precedes Condor rejoin. These are fixture-calibrated observation thresholds, not complete-assembly clearance authority.

## Diagnostic geometry

The existing Physical Envelope Evidence adapter remains non-authoritative because current coverage and mesh precision are incomplete. Uninterrupted video is required to judge boom-to-boom clearance, folding sweep and rejoin safety.

## Failure boundary

Before passage confirmation, Patriot blockage, an unexpected third worker, fence violation, worker loss or timeout leaves Condor in `FAILED_HELD` and compact. Patriot is never held. `otmTS015Cancel` requests Condor restoration before handback.

## Commands

```text
otmTS015Arm left
otmTS015Arm right
otmTS015Status
otmTS015Cancel
```

Known test mapping:

```text
command left  → observed physical right
command right → observed physical left
```

## Evidence contract

Retain the complete game log and uninterrupted video from before arming through at least 20 seconds after Condor handback. Record the chosen physical refuge side and approximate times of hold, first egress, refuge, closest pass, passage completion, rejoin and resumed work.

## Claims deliberately not made

Prototype 16 does not establish automatic conflict detection, automatic role or side selection, Egress Protection Hold, authoritative swept-envelope clearance, obstacle/field-boundary refuge suitability, a general displacement algorithm, generalisation beyond Condor and Patriot, or production cooperation.
## TS015-B result — 28 m lateral target

TS015-B fully supported the fixture hypothesis. The 28 m command produced approximately 27.38 m actual lateral and 11.56 m rearward displacement. Patriot remained under GIANTS control, passed the compact Condor without blockage, and continued working. Condor rejoined, deployed and returned to GIANTS; both original jobs remained active and unblocked after the complete 20-second observation.

The closest centre separation was approximately 27.39 m. This brackets the fixture boundary between the failed 21.44 m actual separation and successful 27.38 m actual separation, but does not make 28 m a production constant.

A later convergence near the opposite headland was a new conflict formed by new GIANTS intentions, not failure of the completed working-pass encounter. Encounter identity is the current Future-Space convergence, not the persistent entity pair.

A later run recorded from Patriot's viewpoint still selected Condor because the fixture roles were hard-coded. Perspective Is Not Role Authority.
## Temporary v4.6.41 repeated-encounter integration

The passage actuator is unchanged. The controller now preserves the admission encounter ID and reports the final outcome before clearing the run. A successful passage and handback allow admission to begin rearming; a failed passage retains the encounter latch. This separates actuator completion from admission readiness and permits a later independent encounter between the same workers.

## Temporary v4.6.40 admission integration

TS016 may now start the same passage controller while the Progress worker is still manoeuvring. The straight-working worker is held immediately after live conflict admission. Side, lateral distance, rearward distance and target are still recalculated from the confirmed stopped pose. The passage sequence itself is unchanged. `FAILED_HELD` is terminal and logged once.


## Temporary v4.6.42 Rejoin Orientation correction

The v4.6.41 TS015 regression reached a calculated right-side refuge and confirmed passage, then failed before handback. At rejoin start the target was almost exactly behind Condor. The forward-only command provided no turn bias, heading remained stable and target distance grew until timeout. This establishes Forward-Only Rejoin Singularity.

v4.6.42 adds `REJOIN_ORIENTING` only for rearward targets. The phase turns slowly until the target enters the forward hemisphere, then returns to the existing direct rejoin. Time, travel and target-progress limits prevent another long uncontrolled departure. TS015 runtime repetition is required.

## v4.6.42 runtime result — right-side refuge and rearward rejoin

The unchanged TS015 fixture selected Condor as Yield and a calculated physical-right refuge. Passage completed. Because the final rejoin target lay behind Condor, Control entered `REJOIN_ORIENTING`, completed the orientation in 7.10 s after 6.42 m travel, then completed direct rejoin, unfolding, GIANTS handback and the successful observation interval. The encounter subsequently rearmed.

This supports the v4.6.42 correction and closes Forward-Only Rejoin Singularity for the tested geometry.

A later independent collision occurred during overlapping headland turns. This does not invalidate the completed passage episode. It repeats the previously observed later headland-convergence boundary from the earlier left-side 15 km/h TS015 work. When the collision prediction became compelling, both workers were manoeuvring and Automatic Encounter Admission had no eligible mode. The remaining issue is **Headland Turn Overlap / Dual-Manoeuvre Admission Gap**.

