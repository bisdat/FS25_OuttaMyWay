FS25_OuttaMyWay v4.6.32

Cooperative collision-avoidance research for native GIANTS AI field workers.

Current canonical authority: v4.6.31, SHA-256 2f54f3a01aaf41bd6f9fd798ce672e1631dbb9e6c9e811ac4ce6acb0b676c25b
Current package authority: candidate implementing observer-only physical/policy clearance evidence separation; runtime validation and repository-owner Canonicalisation remain pending
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless a test record states otherwise

v4.6.32 changes only Shadow Clearance Knowledge calculation, diagnostics and repository continuity. The validated Condor/Patriot actuator remains behaviourally unchanged.

Protected fixture behaviour:

- Condor remains fixed Yield and Patriot remains fixed, unmodified GIANTS Progress;
- arming remains manual and the selected test side remains forced, including the known inverted console labels;
- movement remains fixed at 28 m lateral and 12 m rearward;
- every geometry-derived value remains `authority=false`.

Separated Shadow Clearance evidence:

```text
physicalContactThreshold
= Progress Facing Clearance Extent
+ compact Yield Facing Clearance Extent

physicalClearanceReserve
= live reference separation
- physicalContactThreshold

policyMarginBudget
= geometry uncertainty
+ tracking tolerance
+ motion allowance
+ policy margin

policyRequiredSeparation
= physicalContactThreshold
+ policyMarginBudget

policyReserve
= live reference separation
- policyRequiredSeparation
```

The established TS017-B evidence predicts a 25.37 m physical contact threshold and approximately +2.01 m physical reserve at the successful 27.38 m reference separation. The separate 3.75 m policy-margin budget predicts a 29.12 m policy requirement and approximately -1.74 m policy reserve. v4.6.32 must repeat that manual run before these separated runtime fields are accepted as validated output.

Automatic conflict triggering, Yield/Progress selection, refuge-side choice and geometry-derived Control remain deferred.

Deferred Publication Readiness Review — **Mod Description Drift**: `modDesc.xml` currently summarises the active prototype. Before publication, it should return to a stable description of the mod while release-specific detail remains in the changelog and engineering documents.
