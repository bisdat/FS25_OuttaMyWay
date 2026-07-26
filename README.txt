FS25_OuttaMyWay v4.6.18

Prototype 13A Evidence Consolidation and Animation-State Correction — Release Candidate

Implementation baseline: exact tested v4.6.17 candidate
Current package authority: noncanonical correction candidate awaiting focused in-game validation and repository-owner review

Prototype 13A successfully demonstrated route convergence for all ten declared source shapes across
Condor, Tiger 8 MT and TopDown 600. Every real A/B route pair converged on one runtime Entity and
every deliberately wrong C control was rejected. Runtime handles remained stable through observed
configuration motion. These findings support the Route-Independent Resolution Contract for the
tested fixtures; they do not establish complete physical inventory, footprints or Coverage Closure.

The TopDown AI run also disproved Prototype 13A's generic interior-value label. A stable
`foldAnimTime=0.1250` plateau represented an extended, raised manoeuvring pose rather than a fold
transition. Prototype 13A now logs neutral animation evidence only: raw value, endpoint/interior
region and observed changing/stable motion. It does not infer deployment, vertical configuration,
terrain contact, functional engagement or AI operational phase from one animation value.

Recorded architecture separates:

- deployment state;
- vertical configuration;
- terrain contact;
- functional engagement;
- AI operational phase.

The TS004 TopDown establishes an AI Work Engagement Cycle: extended-raised for positioning and
repositioning, then lowering for direct-soil-contact work. Certain towed sprayers provide a contrasting
non-contact vertical configuration whose height has role-play significance but no crop-contact effect.
Player-controlled behaviour remains outside cooperative-worker modelling; a player assembly is relevant
only as a potential obstacle to AI workers.

Prototype 13A remains passive. This candidate does not automate route discovery, construct footprints,
claim Coverage Closure, predict sweep, assess conflict, create a Commitment or issue Control.

See docs/prototypes/PROTOTYPE_13_DECLARED_ROUTE_EVALUATION.md and
docs/PHYSICAL_REPRESENTATION_ARCHITECTURE.md.
