FS25_OuttaMyWay v4.6.23

Scope Overlay Test-Role Calibration Consolidation — Release Candidate

Implementation baseline: exact canonical v4.6.22
Baseline SHA-256: b636bafdd59afcedba133b2dac65a19286f3dc980734eac63b612c0aaf3a941f
Current package authority: noncanonical candidate awaiting repository-owner review

This increment consolidates the completed Scope Overlay Test-Role Calibration performed through TS005–TS010. It introduces no new gameplay, Decision, Commitment or Control behaviour.

The calibration replaced the assumption that eight proposed roles required eight substantial full-field tests with a bounded evidence model based on Complete Test Configuration, State Sufficiency and Essential Evidence Horizon. Exact configurations support exact conclusions; full completion is required only when the lifecycle claim needs it.

Final role disposition:

- TR-01 Reference Positive — satisfied by TS005;
- TR-02 Dynamic-Extent Positive — satisfied by TS008-P;
- TR-03 Non-Tractor Operational Assembly — satisfied by TS006 and supported by TS008-P;
- TR-04 Material-Chain Boundary — satisfied by TS006 + TS007;
- TR-05 Distinct Spatial-Regime Positive — retired after TS009 exposed Native Crop-System Exclusion;
- TR-06 Asymmetric Working Envelope — satisfied by TS010;
- TR-07 Admission-Rejection Negative — satisfied by TS007 and TS009;
- TR-08 Post-Admission Failure Negative — strongly supported by TS008-N with a declared transient-observation limitation.

The evidence establishes configuration-level and crop-system admission boundaries, an Agronomic State Gate, Material-Chain Control Boundary, Non-Tractor Operational Assembly, Offset Working Envelope, Trajectory–Work Displacement and Work-Envelope-Anchored Routing. Persistent/regrowing crop lifecycle was retired as Agronomic Proxy Drift because OuttaMyWay does not control crop biology.

TS005–TS009 are tagged to FS25 1.21.0.0. TS010 is tagged to the undocumented 1.21.1.0 build b40785. Runtime evidence is now governed as Current, Version-bound, Revalidation candidate or Invalidated, supported by Patch Impact Watch and a small Patch Sentinel Set.

The possible Valid Boundary Straddling interpretation from TS010 is preserved as provisional evidence. It does not yet replace Full-Envelope Field Containment.

No machine-readable Scope Overlay table, runtime eligibility evaluator, Physical Occupancy Envelope, new Resolution Path, Commitment, Control or player UI behaviour is implemented by v4.6.23. Runtime Lua changes are version metadata only.

See docs/SCOPE_OVERLAY_TEST_CALIBRATION.md, docs/SCOPE_OVERLAY_ARCHITECTURE.md, docs/PROJECT_STATUS.md and docs/ENGINEERING_HANDOVER.md.
