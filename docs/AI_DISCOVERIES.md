# AI discoveries

1. `getNextSegmentData()` does not expose a useful future traversal cursor in TS001.
2. `getActiveSegmentData()` reliably exposes turn state, progress and segment length.
3. GIANTS steering targets are short-horizon control signals, not a complete route plan.
4. The native blocked state arrives too late for predictive traffic management.
5. Speed must be treated as observed runtime intent. Cruise control, terrain, traction, implements and other mods may all alter it.
6. A low actual/requested speed ratio is meaningful only when combined with progress and target trends.
7. A settled working trajectory reveals only local intent; later GIANTS repositioning can cross another worker's resumed lane without being explained by a simple alternating-lane model.
