# Candidate Action and Constraint Verdict Contract

> **Authority:** Normative implementation-facing schema.

## Candidate Action

A Candidate Action is one complete proposed intervention or explicit non-intervention. It is not an already-selected flag.

Each record must identify:

| Field | Required meaning |
|---|---|
| Identity | stable identity for one decision epoch |
| Purpose | operational result the candidate seeks; must be traceable to current governing Decision/Commitment context and has no independent objective-setting authority |
| Subject | assembly or assemblies affected |
| Capability | requested bounded Control capability |
| Expected effect | predicted physical and operational consequence |
| Evidence basis | Knowledge supporting the candidate |
| Representation Fitness | purpose-specific fitness and provenance |
| Preconditions | facts that must remain true before dispatch |
| Invalidation conditions | facts that revoke admissibility |
| Reversibility | whether and how effects may be withdrawn |
| Obligations created | expected safety, authority, configuration, spatial and evidence obligations |
| Release implications | candidate-specific Safe Release or Handover requirements |
| Uncertainty | unresolved evidence and conservative limits |
| Comparison cost | disruption/cost only after mandatory admissibility |

## Candidate classes

The Action Space may include, where supported:

- `CONTINUE_UNCHANGED`;
- `CONTINUE_OBSERVATION`;
- `REGULATE_SPEED` for either participant;
- `HOLD` for either participant;
- each independently supportable `REPOSITION` candidate;
- `RESTORE_CONFIGURATION`;
- `HANDOVER_TO_GIANTS`;
- `ESCALATE`.

The list is not a procedural Control ladder. Generators publish candidates; Decision selects among candidates that survive all mandatory constraints. Candidate generators populate/represent `Purpose` from supplied governing context; they do not invent the governing objective or own preference policy.

Within an active Traffic Policeman primary-resolution Decision, the surviving classes are then evaluated through the strict preference sequence:

```text
CONTINUE_OBSERVATION
→ REGULATE_SPEED
→ HOLD_AT_SAFE_POINT
→ NATIVE_REPOSITION
```

A later primary band may be selected only after every earlier band is explicitly exhausted against the same current governing traffic requirement in the same Decision epoch. Exhaustion may be proved without physical trial. A material Reality/Control change creates a fresh epoch and reevaluation from the least-disruptive end. This Decision ordering does not prohibit an independently justified supporting lower-band capability from coexisting with a stronger primary Commitment.

## Constraint Verdict Set

Every mandatory constraint produces exactly one verdict:

- `PASS` — evidence supports admissibility;
- `FAIL` — evidence proves inadmissibility;
- `UNRESOLVED` — evidence is insufficient; active authority is withheld unless the constraint explicitly defines a conservative safe action.

Each verdict records:

- constraint identity and owner;
- candidate identity;
- result;
- evidence and provenance;
- validity epoch;
- reason;
- revalidation trigger.

## Mandatory constraint families

At minimum, applicable candidates are evaluated against:

- Field World containment;
- complete-envelope clearance and transition sweep;
- Representation Fitness;
- Control capability availability;
- Continuing Intent Priority;
- progress preservation and `never hold all`;
- responsibility relations, including Follower Owns Closure;
- current Obligation compatibility;
- Commitment Preconditions;
- authority conflicts and Effective Actuation Composition;
- Safe Release and Safe Handover implications.

Optimisation begins only after all mandatory verdicts are `PASS`.
