# Prototype 33 — Native Field-Worker Drive Command Surface Shadow

**Build:** v4.7.67 TEST BUILD  
**Decision:** D-0138  
**Authority:** passive evidence only

## Source evidence

Exact supplied FS25 1.21.1.0 SDK source shows the native field-worker chain:

`driveStrategy:getDriveData()` → `AIFieldWorker:updateAIFieldWorker()` stopping/speed constraints → `spec_aiFieldWorker.aiDriveParams` → steering/reverser `worldToLocal()` → `AIVehicleUtil.driveToPoint()`.

The table stores `moveForwards`, world-space `tX/tY/tZ`, `maxSpeed` and `valid`. `driveToPoint()` receives a local-space target after the conversion. The D-0138 observer reads the table only after GIANTS has populated it; it never calls `getDriveData()` itself.

## Hypothesis

`spec_aiFieldWorker.aiDriveParams` is a live immediate native field-worker drive-command surface whose values change coherently when GIANTS changes the movement it is presently asking the worker to execute.

This is deliberately weaker than claiming native intent, route or Future Space.

## Probe

For each active native Job Episode record:

- table presence and `valid`;
- `moveForwards`;
- world target `tX/tY/tZ`;
- native post-constraint `maxSpeed`;
- target offset/distance from observed pose;
- target-direction relation to assembly heading and realised travel;
- Productive Continuation, Local Intent, moving-direction, blocked state and actual speed.

At D-0134 Refuge evaluation, record Candidate delta/distance to the current command target only. At D-0136 settlement, snapshot the settling worker and active same-Field-World peer commands. Neither event changes behaviour.

## Fast falsification

The exact SDK provides a high-value discriminating state. `AIDriveStrategyFieldCourse:getDriveData()` initializes its output to `tX=0`, `tZ=0`, `moveForwards=true`, `maxSpeed=0`, `distanceToStop=0`; if the field worker cannot continue or the strategy is blocked it returns that zero command. Ordinary course execution instead delegates to `aiFieldCourse:getDriveData()`.

D-0138 is rejected if live `aiDriveParams` does not materially distinguish those states or otherwise remains stale/invariant. No extra heuristic should be added merely to save the hypothesis.

## Authority boundary

D-0138 does **not**:

- predict the native route;
- create or enlarge Future Space;
- prove negative clearance;
- select/reject a Refuge;
- assign movement priority;
- Regulate, Hold or Reposition;
- call native strategy methods;
- alter `driveToPoint`;
- actuate Control.

## v4.7.67 live result

D-0138 passed its narrow falsification test. `aiDriveParams` varied coherently across Productive work, native turns, reverse and blocked states, including explicit `moveForwards=false` during reverse. The surface is therefore retained as the **Immediate Native Drive Command Surface**.

Two boundaries were also demonstrated. First, zero target/zero speed is not blockage authority without independent blocked evidence (**Zero Command Ambiguity**). Second, the current command target did not discriminate the successful second Refuge from the recurring bad fixture (**Immediate Command != Continuation Horizon**). No Candidate-ranking, Future-Space or route authority is promoted.
