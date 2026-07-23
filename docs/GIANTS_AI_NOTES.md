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

## TS001 objective

Correlate changes in active/next segment return values with the repeatable Condor/Patriot encounter and identify the engine-owned traversal cursor.


## Explorer 4.1.1 observations

`getActiveSegmentData()` includes continuously changing progress values. Those values must not be included in a general state signature or every sample appears to be a state transition. Explorer 4.1.1 therefore records structural native changes separately from 10% progress milestones and steering-target bearing changes.
