# ADR-0001 — Respect the Native AI

- **Status:** Accepted
- **Date:** Historical decision; date not recorded in the recovered source

## Context

Early prototypes explored steering intervention, drive-command interception, recovery manoeuvres and custom execution logic. Although technically possible, each approach duplicated behaviour already implemented by the native GIANTS AI. Complexity increased while compatibility became less certain.

## Decision

OuttaMyWay will extend the native AI wherever suitable extension points exist. The project will prefer participation over replacement.

Native AI systems remain responsible for path following, steering, manoeuvring, course execution and recovery behaviour. OuttaMyWay contributes additional awareness and cooperative decision-making.

## Alternatives Considered

### Direct Steering Control

Rejected because it required duplication of native driving behaviour.

### Command Interception

Rejected because it introduced unnecessary complexity and reduced compatibility.

### Custom AI Controller

Rejected because it would effectively replace significant portions of the native AI.

## Consequences

### Positive

- Excellent compatibility.
- Simpler architecture.
- Reduced maintenance.
- Better cooperation with future game updates.
- Clear separation of responsibilities.

### Negative

- Behaviour remains constrained by native AI capabilities.
- Some limitations must be accepted rather than overridden.

## Evidence

The discovery of the native AI Permission Gate strongly reinforced this decision. Rather than replacing execution, OuttaMyWay could participate in an existing architectural decision already provided by the engine. Subsequent experimentation consistently demonstrated that this approach produced simpler and more robust behaviour.

## Related

- [Engineering Principles](../ENGINEERING_HANDBOOK.md#chapter-2--engineering-principles)
- [The Permission Gate](../ENGINEERING_HANDBOOK.md#chapter-8--the-permission-gate)
- Principle: Respect the Engine

## Review

This is a foundational architectural decision. Reversing it would require fundamental reconsideration of the architecture described throughout the handbook.
