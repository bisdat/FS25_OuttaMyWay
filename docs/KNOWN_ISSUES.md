# Known Issues

## Exact fingerprint is not a complete Field World identity relation

Live evidence shows multiple exact fingerprints for seeds inside the same merged agronomic workspace. v4.7.12 retains exact-fingerprint Operation grouping only as a documented provisional limitation. Spatial equivalence measurements are diagnostic and do not merge Operations.

## Field geometry mutation during active work

OuttaMyWay deliberately does not detect or reconcile field merging/splitting after a Job Episode has begun. The Field World Snapshot is immutable until episode termination.

## Fingerprint tolerance

Identity canonicalisation quantises coordinates to 0.1 m to remove insignificant generation/order variation. Raw polygon coordinates are retained separately. A runtime fingerprint collision is treated as unresolved evidence rather than grouping distinct worlds.

## Derived Field World identity

Source field polygon identity is implemented. The GIANTS field-course boundary is diagnostic-only in v4.7.10 and does not yet replace provisional source-field grouping. Merged-field identity must be validated live before it governs Operation identity.

## Source termination cause classification

A matching `lastJob` transition proves source intent termination but does not distinguish player stop, GIANTS abort and GIANTS fault. That distinction is unnecessary for ending the Job Episode but may remain useful diagnostic knowledge.

## Physical authority

Control remains intentionally disabled.

## GIANTS immutable traversal requires live confirmation

v4.7.9 replaces implicit proxy traversal with explicit ValueRecord accessors. Offline GIANTS-style fixtures pass, but the complete live pipeline still requires confirmation in TS015.

## Field identity requires live confirmation

v4.7.9 retains farmland-to-field mapping and adds exact containment against `FieldManager.fields` polygons. Map-edge overlap may produce multiple matches; that state deliberately remains unresolved rather than selecting a field.

## Passive live Job Episode termination classification

Player takeover can be evidenced directly. When a previously active job vehicle leaves `activeJobVehicles` without player control, the live source preserves `JOB_EPISODE_TERMINATION_CAUSE` as unresolved until player stop, GIANTS abort/fault and transient loss can be distinguished. Missing evidence does not terminate the episode.

## Passive-only gameplay behaviour

The current validation line reads live state and publishes diagnostics. It does not coordinate workers and cannot issue physical Control.

## Physical representation is intentionally incomplete

Live size metadata and bounded current-motion extrapolation support observation only. They are incomplete and non-conservative and cannot justify conflict exclusion or actuation.

## Performance is not yet a production baseline

v4.7.7 proved that broad reflection can cause regular game-thread stalls. v4.7.8 removed that broad probe and the owner observed no stutters. Passive tracing has still not received formal performance qualification.

## Multiplayer remains unverified

Passive sampling is server-side where a server object is present. Replacement-core multiplayer behaviour remains unverified, and no Control is active.