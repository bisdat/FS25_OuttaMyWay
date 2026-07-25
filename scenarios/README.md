# Scenario Library

## TS001 — Head-on convergence and continuation

TS001 is the natural multi-worker conflict fixture used by Prototypes 01 through 05. It established harmless proximity, conflict emergence, conflict confidence, the Option Preservation Window, Local Intent Expiry and supporting Field World evidence. Manual stop/restart variants are supporting evidence because timing changes the later route.

## TS002 — Pre-existing completed vehicle relevance

TS002 begins with Condor already completed and parked while Patriot remains active and approaches the same finishing area. It is the clean regression fixture for:

- a non-operational vehicle discovered at save load;
- retained Field World Membership;
- dynamic `NOT_RELEVANT -> RELEVANT`;
- Patriot's later blocked collision.

TS002 does not contain a live Operational Membership transition.

## TS003 — Live completion transition

TS003 is the repeatable save in which Condor and Patriot begin active, Condor completes while Patriot remains active, and no player repositioning is required before completion.

TS003 validates:

- one latched `OPERATION_MEMBER -> NON_OPERATION_VEHICLE` transition;
- preserved Field World identity;
- relationship reclassification after live completion;
- explicit retirement of the obsolete reverse directional relation.

Prototype 06 passed this fixture in v4.6.7.

See `docs/prototypes/PROTOTYPE_06_MEMBERSHIP_RECLASSIFICATION.md`.


## TS004 — Physical configuration change (planned)

Create only after the first Prototype 07 capability run. The fixture should contain one complete Entity whose physical configuration can change repeatably without changing its attachments, for example a folded/unfolded sprayer or articulated combination.

TS004 will test whether the discovered Physical Occupancy Envelope changes because physical geometry changed rather than because the Entity translated or rotated.
