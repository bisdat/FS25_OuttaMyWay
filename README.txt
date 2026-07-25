FS25_OuttaMyWay v4.6.7

Prototype 06: Membership Transition Reclassification — Release Candidate

Prototype 05 established that Field World Membership, Operational Membership and
Situation Relevance are separate. Prototype 06 now tests the transition boundary:
when a retained Field World Member changes between operational and non-operational,
the membership event must occur once and every existing relevance relationship must
be reclassified without losing Entity identity.

This candidate corrects the false-to-nil latching defect that caused repeated
Operational Membership events. Relationship state now includes participant role and
classification revisions, so a live worker completing can produce an explicit
RELATIONSHIP_RECLASSIFIED event even when geometric relevance itself is unchanged.

TS002 remains the regression fixture for a vehicle already non-operational at load.
A repeatable live-completion fixture is still required to validate the full
OPERATION_MEMBER -> NON_OPERATION_VEHICLE transition in game.

Traffic Manager v2 remains disabled and observer-only mode is enforced before any
decision or control consumer. No hold, release, containment action, route change,
Commitment or vehicle-control behaviour is included.

Start with docs/README.md. The current hypothesis and test contract are recorded in
docs/prototypes/PROTOTYPE_06_MEMBERSHIP_RECLASSIFICATION.md.
