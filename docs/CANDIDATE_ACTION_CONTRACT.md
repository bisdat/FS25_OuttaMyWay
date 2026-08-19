# v4.7.121 D-0147 Terminal Yield Candidate addendum

A Terminal Yield Candidate may exist only when all of the following are positively supported:

1. source productive Job Episode is genuinely ended;
2. completed assembly is Pending Player Reclamation and not Player Claimed;
3. current Terminal Occupancy positively obstructs useful active continuation;
4. Terminal Yield Consent is enabled;
5. one bounded movement expression is supportable from current Reality;
6. the expression does not knowingly create an equal/worse externality, including treating another Field World as free space;
7. all other positively represented assemblies are respected as spatial constraints.

Candidate families may include **External Yield** or **Conflict-Relative Infield Yield**. The field centre and randomness are not Candidate objectives. If multiple materially equivalent supported expressions remain, stable identity may supply deterministic tie-breaking after admissibility, never before it.

Candidate success semantics are **current-continuation purpose**, not permanent parking. Control may execute only the selected bounded expression and may not discover a new refuge/route.

**Current implementation note:** v4.7.121 retains only the v4.7.120 External Yield Candidate expression. This addendum defines the next implementation contract; it does not silently broaden runtime authority.

---

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
| Representation Fitness requirement/evidence reference | the Situation/Operational-Picture fitness evidence required by this action; Candidate does not manufacture the verdict |
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

The list is not a procedural Control ladder. Generators publish candidates from sealed Operational Picture Knowledge; Mandatory Constraints independently evaluate them; Decision selects among candidates that survive those gates. Candidate generators populate/represent `Purpose` from supplied governing context; they do not invent the governing objective, promote Situation Knowledge or own preference policy.

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
- Productive/Transitional/Committed Demand compatibility and Resolution-Space Conservation;
- progress preservation and `never hold all`;
- current responsibility/role relations without scenario-specific ownership shortcuts;
- current Obligation compatibility;
- Commitment Preconditions;
- authority conflicts and Effective Actuation Composition;
- Safe Release and Safe Handover implications.

Optimisation begins only after all mandatory verdicts are `PASS`.
