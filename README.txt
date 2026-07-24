FS25_OuttaMyWay v4.6.6

Prototype 05: Field World Observation — Release Candidate

The field polygon is now recorded as the bounded Field World for one Operation.
Full-Envelope Field Containment is an accepted architectural invariant: the
complete vehicle–implement collision envelope, including projected swept
geometry, must remain wholly inside that polygon at all times. External hedges,
trees and other geometry are therefore outside normal obstacle scope.

Prototype 05 remains passive. It observes every mission vehicle whose
conservative occupied envelope intersects the field polygon, independently of
whether the vehicle remains an active GIANTS AI worker. It records Field World
Membership, Operational Membership and dynamic Situation Relevance separately.

The immediate TS001 evidence cases are parked Patriot after its AI job is
stopped and completed Condor at the shared finishing position. Static-world
evidence is currently limited to GIANTS field islands and native static-collision
signals; exact static-object identity and exact maximum collision geometry remain
future work.

Traffic Manager v2 remains disabled and observer-only mode is enforced before
any decision or control consumer. No hold, release, avoidance response or
Commitment change is included.

Start with docs/README.md. The candidate hypothesis and test procedure are in
docs/prototypes/PROTOTYPE_05_FIELD_WORLD_OBSERVATION.md.
