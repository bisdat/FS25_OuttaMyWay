# v4.7.24 Cleanup Validation Plan

1. Start from owner-declared canonical v4.7.23.
2. Confirm the runtime loads v4.7.24 with the fixed-horizon future predictor reported removed.
3. Run the familiar TS015/headland-cross setup until `OTM TEST — FUTURE SPACE ENCOUNTER` appears.
4. Confirm Encounter creation is sourced from `FIELD_BOUNDED_FUTURE_SPACE_POSITIVE` or legitimate positive Current Space evidence.
5. Confirm pair diagnostics contain present-state distance/closing/current-footprint evidence but no legacy future/TCPA/DCPA comparison fields.
6. Stop one worker; confirm `JOB_EPISODE_ENDED` termination. Restart; confirm a fresh Job Episode and fresh Encounter identity.
7. Confirm Decision remains `CONTINUE_OBSERVATION`, no live Commitment is applied and `control=false`.
8. After PASS, move to same-Job-Episode Safe Release as a separate substantive increment.
