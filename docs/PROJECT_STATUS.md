# Project Status

> **Current candidate:** v4.7.1 Observation and Job Episode Identity  
> **Implementation baseline:** owner-declared canonical v4.7.0  
> **Canonical v4.7.0 SHA-256:** `08577eb096b6c7555ebda9616fc09160f9ab8266717c6db2e7ad37b5ba38d2d5`  
> **Canonical v4.7.0 Git:** `49c01602b10546c3e61d180703f982e2f0d4d9ef`  
> **Architecture authority:** canonical v4.6.78

## Current implementation state

v4.7.1 preserves the v4.7.0 inert kernel and adds an offline-only Observation and Job Episode identity/admission foundation.

Implemented:

- clean active `scripts/` topology and byte-exact non-executable v4.6.78 archive;
- immutable canonical record contracts;
- deterministic identity and epoch primitives;
- Commitment, Obligation and authority structural kernel;
- stable assembly and component reference identity resolution;
- raw Observation Snapshot publication with semantic-field exclusion;
- Job Episode admission and identity persistence;
- canonical Job Episode continuation through blockage, OuttaMyWay Hold and temporary inactivity;
- canonical Job Episode termination through player stop/takeover, GIANTS abort/fault, restart and replacement;
- deterministic offline conformance tests.

Not implemented:

- a GIANTS live Observation listener or polling loop;
- Operation identity/admission;
- Situation Assessment and Operational Picture construction;
- candidate generation or mandatory constraints;
- Decision selection;
- Control admission or physical capabilities;
- replay fixtures;
- live passive validation;
- gameplay coordination.

## Architectural boundary

Canonical v4.6.78 remains closed. Observation publishes sourced facts only. Job Episode admission applies only the canonical accepted episode rules; absence of evidence never implies termination.

## Candidate status

v4.7.1 remains non-canonical pending owner review and local canonical generation. No live behavioural test is required because the new modules have no GIANTS hook or Control path.
