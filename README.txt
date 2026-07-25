FS25_OuttaMyWay v4.6.6

Prototype 05: Field World Observation — Canonical

The field polygon is the bounded Field World for one Operation.
Full-Envelope Field Containment is an accepted architectural invariant: the
complete vehicle–implement collision envelope, including configuration-dependent
maximum extent and projected swept geometry, must remain wholly inside that
polygon at all times. External hedges, trees and other geometry are therefore
outside normal obstacle scope.

Prototype 05 remained passive and strongly supported the vehicle observation
boundary. In the repeatable TS002 fixture, completed Condor was discovered at
save load as a non-operational Field World Member while Patriot was the sole
Operation member. Condor was initially not relevant, became Situation-relevant
as Patriot approached the shared finishing area, and remained present through
the observed collision and Patriot blocked state.

The evidence confirms that Field World Membership, Operational Membership and
Situation Relevance are separate. It also exposes follow-up work: membership
transition events require latching, existing relationships must be reclassified
when a live worker completes, provisional containment rectangles are noisy, and
exact internal static-object identity and exact maximum collision geometry remain
unvalidated.

Traffic Manager v2 remains disabled and observer-only mode is enforced before
any decision or control consumer. No hold, release, avoidance response,
containment action or Commitment change is included.

Start with docs/README.md. The accepted evidence is recorded in
docs/prototypes/PROTOTYPE_05_FIELD_WORLD_OBSERVATION.md.
