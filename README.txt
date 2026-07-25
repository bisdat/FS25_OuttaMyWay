FS25_OuttaMyWay v4.6.7

Prototype 06: Membership Transition Reclassification — Canonical

Prototype 05 established that Field World Membership, Operational Membership and
Situation Relevance are separate. Prototype 06 now strongly validates the live
transition boundary: a retained Field World Member can leave Operational Membership
once, keep the same Entity identity and cause existing relevance relationships to be
reclassified independently of geometric relevance change.

TS002 passed as the negative control. Condor began and remained non-operational,
produced no false membership or reclassification events, and still became relevant
during Patriot's terminal approach before the observed collision.

TS003 supplied the repeatable positive case. At approximately t=225.5s, Condor
completed while Patriot remained active. The probe emitted exactly one latched
OPERATION_MEMBER -> NON_OPERATION_VEHICLE transition, exactly one role-aware
relationship reclassification with identity preserved, and one explicit retirement
of the obsolete reverse directional relation. No unchanged event repeated.

Several transient relevance and GIANTS blocked episodes cleared without deadlock.
A blocked warning is therefore retained as an operational symptom rather than proof
of deadlock or realised collision.

Traffic Manager v2 remains disabled and observer-only mode is enforced before any
decision or control consumer. No hold, release, containment action, route change,
Commitment or vehicle-control behaviour is included.

Start with docs/README.md. The accepted evidence is recorded in
docs/prototypes/PROTOTYPE_06_MEMBERSHIP_RECLASSIFICATION.md.
