# ADR-0022 — Bounded Native Intent Revelation

## Status

Accepted architectural concept; live-supported for Condor Endurance II by non-canonical v4.7.26; production implementation absent from canonical v4.7.24 and v4.7.27 candidate.

## Context

Same-Job-Episode Safe Release exposed an evidence circularity. A held participant cannot demonstrate the native continuation that will exist after Hold while its translation is fully inhibited. The calm state created by Hold is not release evidence, yet the GIANTS engine exposes no demonstrated authoritative Lua traversal cursor from which OuttaMyWay can reconstruct the complete future route.

ADR-0006 already requires Future-Space clearance through the Continuation Safety Horizon and separates capability completion from Commitment completion. ADR-0017 correctly named Counterfactual Hold Release but its v4.6.70 attempt to synthesize native continuation from a supposed retained operating speed was rejected. Historical v4.6.63/v4.6.64 evidence separately showed that Condor could move under GIANTS while compact and could later have OuttaMyWay-owned configuration restored before native handover.

The remaining question was whether those mechanisms could be composed in one unchanged Job Episode so Reality itself supplied the post-Hold intent evidence.

## Decision

Accept **Bounded Native Intent Revelation** as an architectural evidence-acquisition pattern.

A governing Commitment may retain responsibility while Decision authorises a tightly bounded composition that lets GIANTS reveal actual post-intervention Local Intent. OuttaMyWay does not choose the native route. Where required and proven for the Physical Assembly, it may place the assembly in a controllable transit configuration before allowing bounded native progression.

A conforming composition preserves these responsibilities:

```text
active GIANTS Job Episode
        ↓
OuttaMyWay bounded safety / Hold
        ↓
optional proven transit configuration
        ↓
bounded GIANTS-native progression
        ↓
actual native Local Intent evidence
        ↓
reassessment / optional re-Hold
        ↓
restore OuttaMyWay-owned configuration mutations when required
        ↓
unrestricted GIANTS handover only when independently admissible
```

### GIANTS retains native intent ownership

During the revelation interval, GIANTS retains route ownership, steering direction, forward/reverse choice and ordinary job objective. OuttaMyWay may bound available motion authority but may not invent a route merely to obtain evidence.

### Commitment remains responsible

Relaxing or ending a Hold capability is not the Safe Release Point. Native intent revelation is an intermediate evidence event. Situation Assessment must publish the new Reality, Decision must reassess the joint Operational Picture, and the Commitment remains alive until its terminal obligations are positively settled.

### Assembly-specific admissibility

Bounded Native Intent Revelation is available only when the relevant Physical Assembly has sufficiently proven capabilities for the proposed composition. Depending on the assembly this may require:

- a controllable transit/configuration state;
- GIANTS ability to make useful bounded progression while that state is retained;
- supportable re-Hold or other fail-safe inhibition;
- restoration of OuttaMyWay-owned dynamic configuration mutations;
- adequate representation and Effective Actuation Composition for the attempted movement.

A low numerical speed does not independently make unsafe geometry safe. Incomplete Inventory/Coverage Closure, articulation, rotational sweep or configuration transition uncertainty can still make the candidate inadmissible.

### Evidence contract

The bounded interval must identify the unresolved proposition, expected native evidence, permitted authority, exhaustion/fail-safe condition and reassessment trigger. Elapsed time, distance or a fixed speed may be experimental bounds but do not become architecture merely because one fixture passed.

If GIANTS does not reveal useful intent, becomes blocked, changes configuration unexpectedly, the Job Episode ends, or the evidence contract exhausts, the result is unresolved/revision rather than inferred clearance.

## Live evidence

The v4.7.26 Single-Worker Transit Intent probe, Candidate SHA-256 `43e0fc93fcd7810d8460d11e683ad05adef50ada545c8190a3394f015b260ec0`, ran on Farming Simulator 25 1.21.1.0 with Condor Endurance II on field 77.

The same `giants-ai-job-id:0` survived the complete sequence. OuttaMyWay Held translation, requested compact/transit configuration, confirmed full compact after approximately 15.48 s, then passed GIANTS' own drive call through while limiting only the experimental maximum speed to 1 km/h. GIANTS progressed at approximately 1.01–1.06 km/h while native `SETTLED_CONTINUATION` course progress advanced. After the experimental 2 m proving movement, OuttaMyWay re-Held at approximately 2.04 m actual travel, restored its configuration mutation, verified one checked work-state item with zero mismatches, returned the original drive path and observed same-Job independent native continuation. The probe terminated `success=true reason=same-job-native-continuation-observed`.

The 1 km/h and 2 m values are evidence-fixture parameters only.

## Relationship to existing architecture

- **ADR-0006:** preserved. Future Space and the Safe Release Point remain positive obligations. Bounded Native Intent Revelation supplies evidence; it does not waive them.
- **ADR-0008:** preserved. Translation authority can be bounded independently from GIANTS field-worker progression semantics.
- **ADR-0009/ADR-0011:** preserved. Configuration restoration and native handover remain separate obligations.
- **ADR-0012:** preserved. Later materially new convergence may form a fresh Encounter after a prior Commitment truly reaches Safe Release.
- **ADR-0017:** amended. Hold-induced calm is still invalid release evidence; synthetic route/speed projection is not the required way to satisfy the counterfactual knowledge need.

## Wider implications

Cooperative Hold release is the first intended application. The concept may also prove useful for post-intervention route reacquisition or static-obstacle recovery: OuttaMyWay could create an admissible movement opportunity and then permit GIANTS to reveal how it resumes its own job. This does not imply that GIANTS can route around a stationary obstacle and grants no obstacle-avoidance authority by itself.

Other applications are architectural hypotheses until independently discussed and validated.

## Consequences

- OuttaMyWay need not reconstruct a complete GIANTS route merely to learn a held worker's actual post-intervention continuation.
- Counterfactual risk can be resolved through controlled observation of Reality when that observation itself is admissible.
- A transit configuration can be an evidence-acquisition enabler, not merely a refuge/reposition state.
- Capability release, intent revelation, work restoration, native handover and Safe Release remain distinct lifecycle events.
- Production use requires two-worker composition, assembly-capability evidence and complete constraint evaluation; none is authorised by this ADR alone.
- Long evidence-gathering Holds may require explicit future player communication, but UI design is intentionally deferred.
