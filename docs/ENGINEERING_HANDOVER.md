# Engineering Handover

## Authority

Canonical implementation authority is the owner-declared v4.6.32 package with SHA-256 `37cfd18d959cdbec43818265c7bcda789b2f3c7ce6df16210daec469b80206c7`.

v4.6.33 is the next candidate. It removes the required manual arming command and introduces fixture-bounded Automatic Encounter Admission. Runtime validation and repository-owner Canonicalisation remain pending.

## Incoming validated result

The v4.6.32 repeat empirically validated Physical and Policy Clearance Evidence Separation:

```text
physicalContactThreshold = 25.37 m
physicalClearanceReserve = +2.01 m
policyMarginBudget = 3.75 m
policyRequiredSeparation = 29.12 m
policyReserve = -1.74 m
```

The existing actuator completed passage, rejoin and GIANTS handback with `failure=nil`; every calculated field remained `authority=false`.

## Implemented change

Prototype 18 adds a Decision-side **Automatic Encounter Admission** module. It consumes Observer state and Prototype 01 constant-velocity kinematics but does not own physical representation or Control.

Admission requires the exact exclusive Condor/Patriot pair, straight productive motion, no turn or blockage, opposed headings, positive closing rate, `tCPA` within 30 seconds, `dCPA` within 14 m and three seconds of continuous evidence.

The progression is:

```text
Situation Assessment evidence
→ Admission Candidate
→ sustained confirmation
→ Commitment Point
→ existing Unilateral Sidestep actuator
```

`otmTS015Arm` and its handler are removed from active code and are not registered. `otmTS015Status` and `otmTS015Cancel` remain diagnostic and emergency controls.

## Protected invariants

- Condor remains fixed Yield and Patriot remains fixed GIANTS Progress.
- Patriot receives no hold, steering, speed or implement command.
- The selected side remains the validated physical-right fixture side.
- Control remains fixed at 28 m lateral and 12 m rearward.
- Shadow Clearance remains `authority=false` and cannot trigger or modify the manoeuvre.
- No autonomous role assignment, side selection or geometry-derived movement is introduced.

## Encounter Episode Latch

One automatic commitment is permitted per continuous fixture episode. The same pair cannot re-trigger after handback while it remains continuously active. This protects later known Split-Start Pass Recovery from being mistaken for a new eligible head-on admission.

## Exact continuation point

1. Install the exact v4.6.33 candidate.
2. Recreate the established Condor/Patriot head-on fixture.
3. Enter no OuttaMyWay console command.
4. Capture the complete game log and uninterrupted video.
5. Confirm `ADMISSION_CANDIDATE` appears only for the exact straight-working head-on pair.
6. Confirm one `COMMITMENT_POINT` follows after approximately three seconds.
7. Confirm the validated sidestep, passage, rejoin and complete 20-second handback observation remain successful.
8. Confirm Patriot remains `GIANTS_UNMODIFIED` and every shadow record states `authority=false`.
9. Continue observing through the known Split-Start Pass Recovery and confirm no second automatic activation.
10. Verify `otmTS015Arm` is unavailable and was not needed.

## Failure conditions

The experiment fails if admission occurs during turning, harmless separated work, a non-exclusive fixture, later Split-Start coverage behaviour or more than once in the same episode. It also fails if the expected head-on encounter is missed or if protected actuator behaviour changes.

## Deferred after automatic admission

Only after this gate is validated should shadow comparison of role/side candidates begin. Candidate comparison must remain observer-only until field-margin feasibility, obstacle evidence, complete assembly protection and policy authority are separately justified.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently summarises the active prototype/release. Before publication, return it to a stable mod description and keep release summaries in the changelog and engineering documents.
