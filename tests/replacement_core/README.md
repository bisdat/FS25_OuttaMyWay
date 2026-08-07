# Replacement-Core Conformance Tests

v4.7.23 carries forward canonical v4.7.21 Future Space and the live-passed v4.7.22 termination-precedence correction. The suite now proves:

- positive field-bounded Future Space may emit interaction evidence and admit an Encounter without any fixed-horizon future predictor;
- that admission can occur while the historical ten-second future probe remains negative;
- legacy future convergence alone is shadow evidence and cannot admit an Encounter;
- positive Current Space interaction still admits an Encounter immediately;
- incomplete Operation-membership evidence cannot remove previously admitted members;
- later authoritative Job Episode terminal evidence closes the Encounter as `JOB_EPISODE_ENDED`;
- restart/non-resurrection and the Future-Space lifecycle HUD remain covered;
- no negative-clearance authority is introduced;
- Decision, Commitment application and Control remain passive.

Run from the repository root:

```text
texlua tests/replacement_core/run.lua
pytest -q
```
