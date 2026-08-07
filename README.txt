FS25_OuttaMyWay v4.7.21 — Future Space Conformance Candidate

Canonical baseline remains owner-declared v4.7.18. Repository review confirmed that Future Space, Local Intent Horizon, Intent Expiry and Option Preservation are already defined by ADR-0006/ADR-0012; v4.7.21 therefore corrects replacement-core implementation conformance rather than inventing new architecture.

For settled native GIANTS FieldCourse segments, the live source now publishes a Job-Seeded Field-World-bounded Local Intent continuation. Native `isTurn=true` invalidates the straight continuation and leaves the manoeuvre sweep unresolved rather than extrapolating it. When the native course settles again, a new local-intent epoch is published. Pair intersections are positive Future-Space Knowledge only; non-intersection never establishes negative clearance.

The temporary HUD now displays `OTM FUTURE SPACE`, worker `STRAIGHT`/`TURNING` state, measured forward boundary extent and pair intersection state. These distances are measurements, not behavioural thresholds. The historical ten-second constant-velocity path remains isolated solely as the legacy positive Encounter probe for continuity.

Decision remains passive. No live Commitment is applied. Control authority is disabled.

Run line: FS25_OuttaMyWay v4.7.21 Future Space conformance loaded; field-bounded Local Intent evidence active; Future Space HUD active; Shape-Type Gate active; Decision passive; Control authority disabled
