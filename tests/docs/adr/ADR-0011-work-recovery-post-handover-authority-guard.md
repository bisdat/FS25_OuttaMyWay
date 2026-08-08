# ADR-0011 — Work Recovery and Post-Handover Authority Guard

## Status

Accepted architectural rule; supported by the primary v4.6.64 TS015 Encounter; implementation inactive in v4.6.71.

## Context

v4.6.63 removed the hard freeze and executed the formerly failing post-Control Hold path. It also showed two bounded lifecycle defects: the Yield assembly resumed motion while remaining compact, and the Progress assembly remained held solely because Situation identity persisted after current pair evidence disappeared.

## Decision

### Owned Dynamic Configuration Restoration

Temporary Control captures mutable fold, lowered and work state immediately before mutation. Stable dimensions remain job-start Knowledge and are not recaptured. Before handover, Control stops the Yield assembly, restores only mutations it introduced, verifies a work-capable postcondition, then relinquishes authority. Exact route, lane and pose reconstruction remain excluded.

### Post-Handover Authority Guard

Persistent Situation relevance authorises continued assessment, not physical Control. After authority relinquishment, the Commitment enters bounded post-handover observation with `NO_PHYSICAL_CONTROL` preserved. Another capability requires fresh current evidence after the handover grace period: closing motion, a supported or possible current conflict, Future-Space conflict and degrading Action Space. Missing pair evidence cannot maintain or create a Hold.

### Safe Release

Safe Release requires configuration restoration, work-capable recovery, independent GIANTS continuation, no blocked participant and clear relevant Future Spaces. If the pair leaves the observation radius while both participants continue independently, bounded confirmation may complete Safe Release.

## Consequences

- ADR-0009 approximate Native Handover Envelope remains.
- ADR-0010 identity/value separation remains.
- GIANTS still owns exact route reacquisition and job continuation.
- OuttaMyWay owns reversal of its own dynamic configuration mutations.
- Historical Situation identity never substitutes for fresh Commitment Preconditions.
- Repeated post-passage manoeuvring is governed separately by ADR-0012; ADR-0011 remains the work-recovery and authority-release contract.
