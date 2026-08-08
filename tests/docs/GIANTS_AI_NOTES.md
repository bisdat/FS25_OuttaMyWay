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


## Prototype 13A hierarchy notes

- Condor provides direct collision-node mappings for the positive-control boom family.
- Tiger exposes collision-bearing wing descendants beneath separate physics-component roots.
- TopDown exposes unmapped collision-bearing descendants beneath mapped folding-arm anchors inside one physics component.
- Runtime rotations are radians; source-authored I3D/XML rotations are interpreted in their source format and must not be compared without explicit conversion.

## TS004 work-engagement state evidence

For TopDown 600, GIANTS AI used an extended-raised pose for initial positioning and end-of-pass repositioning, then lowered the implement for direct-soil-contact work. The raw foldable timeline held a stable interior value at `0.1250` while raised and moved toward `0.0000` while lowering. `WORKING` phase began before the stable low endpoint was reached.

This evidence is fixture-specific. It supports separating deployment, vertical configuration, terrain contact, functional engagement and AI phase; it does not justify universal numerical meanings for fold animation values.
