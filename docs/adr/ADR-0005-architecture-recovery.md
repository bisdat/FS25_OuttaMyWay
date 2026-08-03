# ADR-0005 — Architecture Recovery and Experimental Capability Preservation

Status: Accepted for v4.6.50 candidate; repository authority pending owner Canonicalisation

## Context

Temporary v4.6.44–v4.6.49 produced valuable runtime discoveries and capabilities while pursuing TS015/TS016. The active path gradually accumulated observation, interpretation, Decision, Commitment and Control responsibilities inside fixture-bounded controllers.

The result was a repeated local-correction cycle: each new failure was addressed where the current controller already held the necessary private state. This improved individual scenarios but weakened architectural ownership.

## Decision

Create an Architecture Recovery Baseline from exact canonical v4.6.43.

The baseline:

- preserves v4.6.43 runtime behaviour;
- does not promote temporary v4.6.44–v4.6.49 controller implementations;
- records all durable discoveries, validated capabilities, disproven assumptions and unresolved boundaries;
- restores precedence to the accepted Situation Assessment → Operational Picture → Decision → Commitment → Control architecture;
- requires a passive authority-trace implementation before further active migration.

Temporary work becomes an **Experimental Capability Corpus**.

```text
discovery retained
implementation not promoted
```

## Recovered findings

### Prototype Boundary Leakage

A fixture-bounded experiment became the active operating path while retaining test identities and private state lifecycles.

### Assessment–Decision–Control Collapse

Controllers interpreted observations, created private Knowledge, selected actions, owned episodes and executed Control.

### Architectural Constraint Enforcement Gap

Documented invariants were not mandatory gates for every action capable of violating them.

### Fragmented Commitment Ownership

Multiple controller episodes approximated one continuing operational Commitment.

## Decision principles

The recovery promotes:

- Sufficiency over Completeness;
- Option Preservation;
- Earliest Sufficient Action;
- Minimum Effective Augmentation;
- Option-Preserving Augmentation.

Frequent reassessment may be normal. Frequent intervention is not automatically justified.

## Consequences

- v4.6.50 changes version identity and documentation, not runtime behaviour.
- No further TS015/TS016 behavioural patch is justified before the passive architecture path is reviewed.
- Proven actuators may later be migrated one capability at a time.
- Old and new paths must never own the same relationship simultaneously.
- The next implementation must trace Observation, Knowledge, constraint conclusions, proposed Decision, shadow Commitment and proposed Control capability without moving a vehicle.
