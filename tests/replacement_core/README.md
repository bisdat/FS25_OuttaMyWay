# Replacement-Core Conformance Tests

v4.7.21 preserves the previous lifecycle, Shape-Type Gate and diagnostic-throttling coverage and adds Future Space implementation-conformance tests. The suite now proves:

- native GIANTS active-segment turn state drives `SETTLED_CONTINUATION` versus `TURNING` without a behavioural threshold;
- settled Local Intent advances to the forward Job-Seeded Field World boundary;
- native turning expires the straight intent and post-turn settlement creates a new local-intent epoch;
- crossing field-bounded component continuations can positively support Future-Space intersection;
- a turning/unrepresented manoeuvre remains unresolved and cannot establish clearance;
- Situation Assessment publishes field-bounded Future-Space relationship Knowledge without creating an Encounter from that diagnostic evidence;
- the Future Space HUD reports settled, turning and intersecting states;
- previous Encounter lifecycle and Shape-Type Gate contracts remain covered;
- Decision, Commitment application and Control remain passive.

Run from the repository root:

```text
texlua tests/replacement_core/run.lua
pytest -q
```
