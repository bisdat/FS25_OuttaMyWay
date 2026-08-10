# Prototype 32 — Native AI Drive Signal Shadow

**Build:** v4.7.66 TEST BUILD  
**Decision:** D-0137  
**Authority:** passive evidence only

## Research origin

External research of the public Courseplay FS25 repository found that Courseplay explicitly supplies `vehicle.aiDriveDirection` and `vehicle.aiDriveTarget` because GIANTS collision handling consumes those fields. Courseplay owns its course, so that observation does not establish the semantics or reliability of the same fields on a native GIANTS worker. No Courseplay code is copied into OuttaMyWay.

The research lead is therefore empirical:

> Does a native GIANTS AI field worker already expose a sufficiently coherent immediate drive signal that OuttaMyWay can observe without predicting or replacing the native route?

## Probe

For each active native Job Episode, v4.7.66 passively records:

- raw `vehicle.aiDriveDirection` availability, storage shape and value;
- raw `vehicle.aiDriveTarget` availability, storage shape and value;
- normalized drive direction for descriptive comparison only;
- target offset from the observed worker pose;
- drive-direction dot product with observed assembly heading;
- drive-direction dot product with observed physical travel direction when available;
- Productive Continuation evidence, GIANTS Local Intent epoch/classification, moving direction, blocked state and actual speed.

At Refuge candidate evaluation, the existing D-0134 shadow probe also records each Candidate's descriptive relationship to the same raw drive signal:

- signed longitudinal displacement from `aiDriveTarget` along `aiDriveDirection`;
- signed and absolute lateral displacement from that line;
- Euclidean distance from `aiDriveTarget`.

These values do not rank or exclude Candidates.

At D-0136 `RESIDUAL_INTENT_SETTLED`, the probe captures the raw drive signal for the settling worker and each same-Field-World active peer at the exact reassessment event.

## Settlement reassessment visibility correction

v4.7.65 live evidence showed `compared=0` after successful intent settlement. Inspection found a passive-probe plumbing mismatch: `LiveObservationSource` persists activity on retained tracks as `track.active`; `activeObserved` belongs to grouped observation workers rather than the persistent track. v4.7.66 corrects only this passive comparison visibility check. It does not alter Encounter, Decision, Commitment or Control behaviour.

## Questions

1. Are the native fields populated throughout ordinary Productive work?
2. How do they change during normal turns, long native reposition, reverse and blocked states?
3. Are they coherent with the physical travel direction, or with another GIANTS reference direction?
4. At the known good-side/bad-side Refuge choice, do the Candidates have distinguishable relationships to the native signal before selection?
5. At Residual Intent Settlement, does the other worker already expose a useful prospective native signal even when existing coarse Future Space is insufficient?

## Falsification / weakening

The research lead weakens if the fields are absent on native GIANTS workers, remain stale across materially different native behaviours, merely mirror a non-prospective pose without adding useful evidence, or fail to distinguish known good/bad Resulting Situations across repeated observations.

A positive correlation in one run is not selection authority. Any architectural promotion requires repeated native evidence and an explicit Representation Fitness contract.

## Authority boundary

D-0137 does **not**:

- declare an exact GIANTS route or destination;
- create a new Future Space representation;
- establish negative clearance;
- select or reject a Refuge;
- assign PROGRESS/YIELD roles;
- Regulate, Hold or Reposition;
- actuate Control.

The probe measures what GIANTS exposes. Reality determines whether that signal is useful.


## Result — falsified by v4.7.66 live evidence and exact 1.21.1.0 SDK

The probe produced the invariant values `aiDriveDirection=(0,1)` and `aiDriveTarget=(0,0)` across materially different Productive, Transitional, turning and blocked states. Exact SDK inspection subsequently showed these values are initialized in `AIDriveStrategyFieldCourse:setAIVehicle()` and are not the dynamic field-worker command surface.

**Disposition:** D-0137 is falsified. Its derived longitudinal/lateral Candidate relationships were world-origin artefacts and must not be promoted. The implementation discovery is provisionally named **Native Drive Signal Surface Gap**. D-0138 tests `spec_aiFieldWorker.aiDriveParams` instead.
