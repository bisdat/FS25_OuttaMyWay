# ADR-0003 Situation Assessment

Observer -> Situation Assessment -> Decision Engine -> Control -> Recovery

## Decision

Situation Assessment maintains the **most plausible current explanation** of the evolving operational situation.

It infers operational intent from observations, maintains confidence in those explanations, and opens Local Situations when independently operating workers are projected to interact.

Situation Assessment assesses; the Decision Engine decides.

OuttaMyWay does not coordinate cooperative vehicle work.


## Session v4.3.8 Architectural Discoveries

- Decision Readiness
- Sufficiency over Completeness
- Decision-Relevant World
- Decision-Relevant Constraints
- Relevance Envelope
- Option Horizon

Situation Assessment defines the operational constraints within which all valid actions must exist.
