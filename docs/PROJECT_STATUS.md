# Project Status

Version: 4.6.33
Canonical implementation authority: owner-declared v4.6.32, SHA-256 `37cfd18d959cdbec43818265c7bcda789b2f3c7ce6df16210daec469b80206c7`
Authority state: Candidate — fixture-bounded Automatic Encounter Admission implemented; runtime validation and repository-owner Canonicalisation pending
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless the test record states otherwise

## Validated incoming evidence

The v4.6.32 Condor/Patriot repeat passed. Physical and policy evidence remained explicitly separate while actuator behaviour remained unchanged:

```text
physicalContactThreshold = 25.37 m
liveReferenceSeparation   = 27.38 m
physicalClearanceReserve  = +2.01 m
policyMarginBudget        = 3.75 m
policyRequiredSeparation  = 29.12 m
policyReserve             = -1.74 m
failure                   = nil
```

Passage, rejoin, GIANTS handback and the complete 20-second observation succeeded. All calculated geometry and clearance fields remained `authority=false`.

The later Condor movement was the already documented Split-Start Pass Recovery / Start-State-Dependent Coverage sequence, not a new encounter discovery.

## Current engineering increment

v4.6.33 introduces **Automatic Encounter Admission** as a Decision-side boundary between Situation Assessment evidence and the existing fixed actuator.

An **Admission Candidate** exists only when:

- exactly two active workers are present;
- the fixture resolves uniquely to Condor Yield and Patriot Progress;
- both workers are straight, working, moving and unblocked;
- headings differ by at least 150 degrees;
- constant-velocity projection is closing, has `tCPA` between 0 and 30 seconds, and `dCPA` no greater than 14 m;
- the evidence persists for three seconds;
- no commitment has already been admitted in the continuous worker episode.

At the **Commitment Point**, the existing Unilateral Sidestep controller begins automatically. `otmTS015Arm` is disabled and no longer registered.

## Protected actuator invariants

- Condor remains fixed Yield.
- Patriot remains fixed, unmodified GIANTS Progress.
- The validated physical-right fixture side remains fixed.
- The actuator remains fixed at 28 m lateral and 12 m rearward.
- Every derived geometry and clearance field remains `authority=false`.
- Automatic admission does not select role, side, movement distance or Progress control.

## Encounter Episode Latch

Prototype 18 permits one automatic commitment per continuous Condor/Patriot worker episode. The latch prevents a second intervention during later GIANTS coverage behaviour, including the known Split-Start Pass Recovery sequence. It resets only after the fixture pair is no longer continuously active for the configured absence interval.

## Exact continuation point

Install v4.6.33 and recreate the established Condor/Patriot same-pass fixture. Enter no OuttaMyWay console command. Capture the complete log and uninterrupted video.

Validate:

1. one `PROTOTYPE18 ADMISSION_CANDIDATE` appears only after the exact pair is straight, working and conflict-relevant;
2. one `PROTOTYPE18 COMMITMENT_POINT` follows after approximately three seconds of sustained evidence;
3. the established 28 m / 12 m passage, rejoin and GIANTS handback complete unchanged;
4. Patriot remains `GIANTS_UNMODIFIED`;
5. all Shadow Clearance output remains `authority=false`;
6. no second activation occurs during later Split-Start Pass Recovery or other non-head-on manoeuvring;
7. no `otmTS015Arm` command is available or required.

A missed encounter, premature trigger, harmless-pass trigger, role/side drift or second activation disproves the admission gate.

## Current limits

Prototype 18 is fixture-bounded, not a production encounter selector. Exactly two active workers are required. Roles, side and movement remain fixed. Constant-velocity projection is admission evidence only. Full assembly swept paths, field/margin refuge feasibility, obstacles, autonomous role/side selection, multiple simultaneous encounters and generalisation beyond Condor/Patriot remain unresolved.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently acts as a prototype/release summary. Before publication readiness, restore it to a stable description of the mod and keep increment-specific reporting in the changelog and engineering documents.
