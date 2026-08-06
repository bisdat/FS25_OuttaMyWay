# Project Status

> **Current candidate:** v4.7.0 Replacement-Core Bootstrap  
> **Architecture authority:** owner-declared canonical v4.6.78  
> **Canonical v4.6.78 SHA-256:** `bf7ec80f5cfc7c2690cf0f599fd3acf82fd3df6b197acb1dd7a5950f7b6da9e5`  
> **Canonical v4.6.78 Git:** `a99834bba898a876fcb8315aeb5741833b099d85`

## Current implementation state

v4.7.0 is the first implementation of the closed canonical replacement-core architecture.

Implemented:

- clean active `scripts/` topology;
- byte-exact non-executable v4.6.78 script archive;
- immutable record definitions for all nine canonical inter-layer contracts;
- deterministic identity and epoch primitives;
- `ACTIVE`, `WAITING_FOR_EVIDENCE` and `SETTLING` lifecycle enforcement;
- five terminal dispositions;
- Commitment Registry;
- Obligation Ledger with exactly-one-owner, origin-bound and accepted-transfer enforcement;
- one progress-actuation owner per assembly;
- structural Effective Actuation Composition checks, including `never hold all`;
- inert Runtime with zero Control authority;
- offline Lua and repository structural conformance tests.

Not implemented:

- GIANTS Observation;
- Job Episode admission;
- Situation Assessment and Operational Picture construction;
- candidate generation or mandatory constraints;
- Decision selection;
- Control admission or physical capabilities;
- replay fixtures;
- live passive shadow;
- gameplay coordination.

## Architectural boundary

Canonical v4.6.78 is closed. Legacy code supplies evidence and physical donor mechanisms only. Apparent architectural contradiction is a stop condition; it is never resolved by silent special-case implementation.

## Candidate status

v4.7.0 remains non-canonical pending owner review, local canonical generation and a basic in-game load confirmation.
