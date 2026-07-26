# AI discoveries

1. `getNextSegmentData()` does not expose a useful future traversal cursor in TS001.
2. `getActiveSegmentData()` reliably exposes turn state, progress and segment length.
3. GIANTS steering targets are short-horizon control signals, not a complete route plan.
4. The native blocked state arrives too late for predictive traffic management.
5. Speed must be treated as observed runtime intent. Cruise control, terrain, traction, implements and other mods may all alter it.
6. A low actual/requested speed ratio is meaningful only when combined with progress and target trends.
7. A settled working trajectory reveals only local intent; later GIANTS repositioning can cross another worker's resumed lane without being explained by a simple alternating-lane model.
8. An operational AI worker may own a multi-member Physical Assembly containing separate attached runtime assets and roots.
9. GIANTS `WORKING` state does not by itself prove sustained physical progression; declared state and measured motion are separate evidence.
10. GIANTS AI keeps the base vehicle stationary until an implement has unfolded or lowered into its working state; configuration motion can still occupy changing plan-view space.
11. Physics-component count is not a universal inventory of plan-view articulation: Tiger 8 MT uses separate wing components while TopDown 600 moves collision-bearing descendants inside one physics component.
12. Direct `i3dMapping` coverage varies by asset and cannot establish collision inventory or Coverage Closure.
13. Working width, base size and AI course offsets are state-scoped operational evidence, not automatic collision authority.
14. Two implements in the same gameplay class may expose materially different physics-component, hierarchy, mapping and articulation structures; class is not structural authority.
15. GIANTS job completion ends active worker membership but leaves the physical assembly in its final pose as a potentially significant obstacle.
16. GIANTS does not necessarily fold wide implements at job completion; OuttaMyWay currently accepts that final configuration and leaves relocation to the player.

## Mapping and hierarchy evidence relevant to Prototype 13A

GIANTS vehicle loading uses components and `i3dMappings` as node-resolution inputs, while physically relevant descendants may remain unmapped and inherit changing world poses from mapped ancestors. Mappings are therefore useful anchors, not physical inventories or proof of Coverage Closure. Prototype 13A tests this interpretation at runtime.

## TS004 TopDown AI work-engagement observation

The AI-controlled 8RX 410 + TopDown 600 unfolded, retained an extended-raised pose while moving forward and reversing into its start position, lowered for a working pass, raised for repositioning, then lowered for the next pass. The same run showed GIANTS phase `WORKING` before the TopDown reached its stable low animation endpoint. AI operational phase is therefore not authoritative physical-pose evidence.

The stable `foldAnimTime=0.1250` manoeuvring plateau disproved the assumption that every interior animation value is a transition. Prototype 13A now records neutral animation region and motion rather than semantic fold state.
