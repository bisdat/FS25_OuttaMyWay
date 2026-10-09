# Executable Offline Validation

This directory contains current CI contracts and retained **historical** tests. Testing methodology is owned by [Testing Methodology](../docs/TESTING_METHODOLOGY.md); passing a test never creates Architecture or a Specification.

## Current active shell contracts

- [Shell structural contracts](test_product_shell_structure.py) — exact explicit `scripts/main.lua` module inventory, no orphan production Lua, two presentation listeners and passive native observer, dormant Hold & Relocate coordinator, dynamic version-only HUD, and coherent TEST identity.
- [Shell bootstrap smoke](shell/main_smoke.lua) — no GIANTS runtime or vehicle Control; enabled/disabled status behaviour.
- [Spatial Pair Inference](shell/spatial_pair_inference.lua) — pure 1000 ms gate and 30 m nearest eligible root.
- [Native Reverse Mechanism](shell/native_reverse_mechanism.lua) — mocked GIANTS drive interception, native reverser/tool correction, displacement evidence and unchanged native-call passthrough; not GIANTS Reality validation.
- [Hold & Relocate](shell/hold_relocate.lua) — independently validated pair commitment, centroid-nearest worker, 5 s / 10 s timer release, bounded reverse command and single-call native restart evidence through independently mocked authority and physical Control; no production vehicle actuation.
- [Native Blockage Observation](shell/native_blockage_observation.lua) — passive GIANTS field-course blocked-state sampling, single-pulse gate, candidate publication and lifecycle under mocked engine evidence; no AI Control.
- [Configuration](shell/configuration_persistence.lua), [diagnostic publication policy](replacement_core/diagnostic_publication_policy_source.lua) and [Log Publication](replacement_core/log_publication.lua) — independently retained supporting runtime contracts.
- [GitHub Actions](../.github/workflows/offline-validation.yml) — runs the blocking shell structural and Lua suites. Generated LDoc is a derived non-authoritative reference.

The native observer invokes Spatial Pair Inference only on qualifying single blocked pulses; offline tests do not establish in-game event-fidelity or player-visible behaviour. The completed `NativeBlockedProbe` and `NativeBlockedEventTap` fixtures and instruments are retired. The 0.5.0.5 experiment remains reconstructable from Git history; no diagnostic observer remains in current source.

## Historical evidence — not active CI

`replacement_core/` and `replay/` retain pre-rewrite offline fixtures and former traffic-contract structure tests. Most reference sources retired from the current `scripts/` tree. Their prior passing results are **historical evidence only**; these suites are no longer runnable against the current shell and must not be described as current regression gates.

The preserved prior-era implementation and its valid corresponding contracts live at [archive/0.4.11.0](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). A future reintroduction requires a distinct architectural decision and new Specification/validation applicability, **not** opportunistic restoration of old tests.

## Maintenance boundary

Active validation protects only currently accepted implemented contracts. GIANTS-dependent claims need in-game Reality tests; offline assertions cannot establish native blockage semantics, worker clearance or useful autonomous fieldwork.
