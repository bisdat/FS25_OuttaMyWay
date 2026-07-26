# GIANTS AIFieldCourse Notes

## Purpose

This file records observations from the deterministic TS001 save. Versions 4.1.x are diagnostic-only.

## Known native methods

- `getActiveSegmentData()`
- `getNextSegmentData()`
- `getActiveSegmentSideOffset()`
- `getIsCornerCutOutActive()`
- `getDriveData(...)`
- `getPositionOffsetToActiveSegment(x, z)`
- `skipCurrentSubSegment(distance)`
- `update(dt)`

## Safety decision

The explorer does not call native `getDriveData()` itself because that method may advance or mutate the native cursor. Instead it observes `AIDriveStrategyFieldCourse.lastVehiclePosition` and `lastTargetPosition`, which are populated by the base-game strategy after its normal drive call.

## Prototype 12 assembly and motion observations

- Condor exposed one integrated runtime assembly member.
- S 416 + Tiger 8 MT and 8RX 410 + TopDown 600 exposed two-member attached assemblies with independent assets and roots.
- In the first attached run, GIANTS retained active `WORKING` state while measured movement remained effectively zero for at least fifteen seconds.
- The same equipment cultivated manually, disproving simple equipment incapability without revealing the AI cause.
- The second attached fixture sustained normal work, so assembly discovery and AI progression must remain separate concerns.

## TS001 objective

Correlate changes in active/next segment return values with the repeatable Condor/Patriot encounter and identify the engine-owned traversal cursor.


## Explorer 4.1.1 observations

`getActiveSegmentData()` includes continuously changing progress values. Those values must not be included in a general state signature or every sample appears to be a state transition. Explorer 4.1.1 therefore records structural native changes separately from 10% progress milestones and steering-target bearing changes.
## Prototype 03 continuation observation

A manual stop/restart test showed that a worker's settled current lane is not a complete prediction of its subsequent route. Condor completed the observed lane, later performed additional repositioning, and then crossed Patriot's resumed lane. The stop/restart introduced Job Restart Perturbation, so the exact continuation cannot be assumed deterministic, but the observation establishes that immediate kinematic intent and route continuation are separate evidence responsibilities.

## TS004 stationary deployment and asset-structure contrast

The repository owner observed that GIANTS AI holds the base vehicle stationary until a foldable implement is fully extended or lowered. This creates two principal stable occupancy states, folded and working, separated by stationary configuration motion whose Deployment Clearance Envelope must be assessed before commitment.

Static TS004 source examination found:

- Tiger 8 MT: multi-component wing articulation;
- TopDown 600: one physics component with internally animated collision-bearing descendants;
- materially different direct mapping coverage;
- base width and working width with different physical meanings.

These are static asset observations, not runtime identity-resolution proof.

