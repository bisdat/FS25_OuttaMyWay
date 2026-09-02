# v4.7.121 D-0147 Terminal Yield commitment addendum

A completed worker's productive Job Episode remains ended while it is Pending Player Reclamation. Each positively admitted Terminal Yield is a bounded Commitment objective tied to one current obstruction/continuation purpose.

- `ACTIVE`: may execute only the selected bounded yield needed for the current admitted conflict.
- `WAITING_FOR_EVIDENCE`: completed vehicle remains passive; no speculative relocation merely to prevent hypothetical future conflict.
- `SETTLING`: reconcile actuation, release authority and establish whether current productive continuation was restored, Player Claim/higher authority transferred responsibility, or the bounded yield failed/exhausted.
- `SUCCEEDED` for one yield does **not** mean the completed vehicle is permanently settled. It returns to Pending Player Reclamation and may later participate in a new Terminal Occupancy Situation if fresh positive conflict evidence appears.
- No terminal-yield timer or maximum-move count is architectural authority.

This refines the historical Terminal Resolution Commitment: stickiness applies to the currently admitted yield obligation, not to finding permanent parking.

---

# Commitment State Machine

> **Authority:** Normative companion to `ARCHITECTURE.md` and ADR-0019.

## States

| State | Progress authority | Retained responsibility | Permitted exits |
|---|---|---|---|
| `ACTIVE` | May initiate validated objective-progress Control | all open obligations, observation, safety and evidence | `WAITING_FOR_EVIDENCE`, `SETTLING` |
| `WAITING_FOR_EVIDENCE` | No speculative progress Control | observation, evidence acquisition, bounded safety and existing safe effects | `ACTIVE`, `SETTLING` |
| `SETTLING` | No objective-progress Control | Control reconciliation, authority release, obligation settlement, transfer and terminal evidence | one terminal disposition |

## Terminal dispositions

- `SUCCEEDED`
- `FAILED`
- `SUPERSEDED_BY_NEW_INTENT`
- `CANCELLED_BY_SOURCE_INTENT_TERMINATION`
- `CANCELLED_BY_OPERATION_TERMINATION`

A terminal disposition is valid only after every owned obligation is satisfied, closed through evidenced basis cessation, or atomically transferred to an eligible accepting Commitment.

## Legal transition table

| From | Trigger | To | Required proof |
|---|---|---|---|
| no Commitment | Decision selects an admissible Candidate Action and establishes enforceable intent | `ACTIVE` | current Operational Picture, verdict set and Preconditions |
| `ACTIVE` | evidence is insufficient for further progress | `WAITING_FOR_EVIDENCE` | evidence contract and retained safety policy |
| `WAITING_FOR_EVIDENCE` | evidence contract is satisfied and Governing Basis remains valid | `ACTIVE` | fresh evidence and candidate revalidation |
| `ACTIVE` or `WAITING_FOR_EVIDENCE` | objective achieved, failed, superseded, source intent ended, or Operation basis ended | `SETTLING` | first authoritative invalidation or objective outcome |
| `SETTLING` | Terminal Settlement Point reached | terminal disposition | complete obligation and authority record |

## Illegal transitions

The enforcing Commitment boundary must reject:

- ordinary completion without Terminal Settlement;
- completion with unresolved origin-bound Control effects;
- replacement without obligation accounting;
- return from `SETTLING` to progress on the ended objective;
- second progress owner for one assembly;
- dispatch from stale Operational Picture, Governing Basis or intent epoch;
- terminal success inferred from elapsed time, inactivity or absent evidence.

## Transition precedence

1. Immediate safety inhibition.
2. Recognition of authoritative agency or intent change.
3. Entry into `SETTLING` where obligations remain.
4. Obligation settlement or transfer.
5. Terminal disposition.

The first authoritative event that invalidates Governing Basis selects the intended terminal cause. Later events may affect settlement but do not rewrite that history.
