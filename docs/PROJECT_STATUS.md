# Project Status

Version: 4.6.7

Authority state: Release Candidate — Prototype 06 membership transition and relationship reclassification awaiting passive in-game evidence

Canonical baseline: owner-supplied clean v4.6.6 canonical package

Canonical baseline SHA-256: 9a1c73138ad824ce48cf364f20e2f008f31223d4f3509a7d0f48ac7df0ce1823

Current focus: validate one latched live `OPERATION_MEMBER -> NON_OPERATION_VEHICLE` transition and explicit reclassification of the retained relationship

## Engineering Increment

Prototype 06 asks:

> Can Situation Assessment latch Operational Membership transitions to one real state change and reclassify existing Situation Relevance relationships when a retained Field World Member changes operational role?

The candidate corrects the false-to-nil latching defect and adds classification revisions to retained members and relation signatures. A role change can now be logged independently of whether geometric relevance changes.

## Regression boundary

TS002 remains the repeatable pre-existing non-operational vehicle relevance fixture. It must continue to discover completed Condor at load, retain Patriot as the sole Operation member and promote Condor to Situation-relevant during Patriot's terminal approach.

## New evidence requirement

A repeatable live completion-transition fixture is still required. Both workers should begin active, one should complete shortly after load, and the other should remain active. This fixture may be named TS003.

Expected evidence:

- one `PROTOTYPE06 MEMBERSHIP_TRANSITION`;
- retained Field World identity;
- one `PROTOTYPE06 RELATIONSHIP_RECLASSIFIED`;
- explicit retirement of the obsolete reverse directional relation;
- no repeated unchanged membership event.

## Passive guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototypes 01 through 06 execute before the observer-only return;
- no speed, steering, implement, route, AI-job, Decision, Commitment, hold, release or containment action is permitted.

## Unchanged unresolved boundaries

- exact maximum collision geometry and projected swept geometry;
- active Full-Envelope Field Containment;
- complete identity of internal static objects;
- Conflict Realisation;
- active Information-Gaining Delay and Safe Release.
