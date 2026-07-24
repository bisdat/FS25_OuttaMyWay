# Project Status

Version: 4.6.6

Authority state: Release Candidate — Prototype 05 passive Field World evidence awaiting in-game validation

Canonical baseline: exact accepted v4.6.5 canonical package

Canonical baseline SHA-256: 3c7cfa56fe0bd74dc3d3aabbcaddf52c1d49e10637b248ce75a7193e264d9431

Current focus: validate Field World observation independently of active Operational Membership before any active Information-Gaining Delay

## Engineering Increment Hypothesis

Prototype 05 asks:

> Can Situation Assessment retain vehicle Field World Members independently of active GIANTS AI membership and identify when inactive, completed or player-controlled vehicles become relevant to an active Operation member's plausible trajectory?

The candidate remains passive. It does not hold or release either worker, select a Commitment, constrain the field boundary or alter GIANTS AI behaviour.

## Recovered Architecture

The field polygon defines the bounded Field World for one field Operation.

**Full-Envelope Field Containment** is an accepted invariant: the complete operational collision envelope of the vehicle and every attached or towed implement, including configuration-dependent maximum extent and projected swept geometry, remains wholly inside the field polygon at all times.

External hedges, trees, ditches and pylons are therefore outside normal obstacle scope. Their removal from TS001 was a workaround for missing containment behaviour, not an acceptable requirement.

The architecture now separates:

- **Field World Membership** — physical presence within the bounded field world;
- **Operational Membership** — active participation in the Operation;
- **Situation Relevance** — current ability to affect an Operation member or plausible future.

## Candidate Implementation

Prototype 05:

- discovers the GIANTS field boundary while observer-only mode is active;
- retains every mission vehicle whose conservative current envelope intersects that polygon;
- observes active, inactive, completed and player-controlled vehicles independently of active-worker state;
- records Operational Membership transitions without discarding physical membership;
- records dynamic relevance using separation, closing rate and closest-approach evidence;
- preserves GIANTS field-island counts and native static-collision signals as limited static-world evidence;
- records conservative current-envelope containment candidates without issuing Control.

The current geometry is a diagnostic rectangle approximation. It does not yet implement exact maximum collision geometry or projected sweep.

## Passive Guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototypes 01 through 05 run before the observer-only return;
- no speed, steering, implement, route, AI-job, Decision, Commitment, hold, release or containment action is permitted.

## Immediate Test

Use the limited TS001 stop/restart scenario:

1. stop Patriot at the previous candidate wait position;
2. verify that it remains a Field World Member after leaving active AI membership;
3. observe Condor's later repositioning toward parked Patriot;
4. move Patriot before collision if desired and restart it after Condor clears;
5. allow Condor to finish and park;
6. observe Patriot's terminal approach to the occupied GIANTS finishing position;
7. upload the complete log and visual observations.

## Expected Evidence

- parked Patriot remains `operationalMember=false` but physically observed;
- Condor-to-Patriot relevance changes to `RELEVANT`;
- moving Patriot is classified as player-controlled rather than disappearing;
- completed Condor remains a Field World Member;
- Patriot-to-Condor terminal relevance becomes visible.

## Known Constraints

- Manual stop/restart contains Job Restart Perturbation.
- Exact full-envelope collision geometry and projected sweep are not implemented.
- Internal static-object identity is incomplete; field islands and native collision signals are evidence only.
- The test map currently lacks the deleted external hedges, so containment itself is not validated.
- Older control code remains in the repository but is bypassed by the observer-only boundary.
