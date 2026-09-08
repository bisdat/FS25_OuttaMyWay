# Engineering documentation — Start here

This directory is the live entrance to OuttaMyWay's engineering knowledge.
Each route below states the responsibility of a direct child. The archive is
intentionally absent under the Archive Navigation Exemption.

## How to use this map

Root `../AGENTS.md` requires substantive engineering work to enter through this
map after reading the root working rules. Establish current engineering governance
and continuation first, then follow only the responsibility routes relevant to
the task. Runtime work normally continues through Architecture; GIANTS/FS25
behaviour or API assumptions continue through Engine Knowledge; validation work
continues through Testing Methodology and `/tests`.

Current documentation establishes present responsibility. When an observation
may already be known, the root **Relevant Knowledge Sweep** additionally searches
Issues, pull requests, journal/research evidence and Git provenance before the
observation is classified as new.

## Project direction and engineering state

- [Project Vision](PROJECT_VISION.md) — mission, Trust Test, Autonomous Continuity, scope, and product-level direction.
- [Engineering Architecture](ENGINEERING_ARCHITECTURE.md) — engineering method, repository authority, knowledge governance, and canonicalisation.
- [Current Concept Register](CONCEPT_REGISTER.md) — thin index of accepted, deferred, and rejected current concepts.
- [Continuation State](CONTINUATION_STATE.md) — replace-in-place current concern, established understanding, and next engineering boundary.
- [Scope and Validation Envelope](SCOPE_AND_VALIDATION_ENVELOPE.md) — supported, boundary-characterisation, and no-claim boundaries and their validation obligations.
- [Testing Methodology](TESTING_METHODOLOGY.md) — how claims are challenged and evidence strength increases.

## Decisions, evidence, and policy

- [Decision Log](DECISION_LOG.md) — chronological accepted decisions and their rationale.
- [Engineering Journal](ENGINEERING_JOURNAL.md) — observations, investigations, failed hypotheses, validation evidence, and engineering evolution.
- [Naming Conventions](NAMING_CONVENTIONS.md) — authoritative rules for semantically truthful repository, code, architecture, identity, state, and user-facing names.
- [Localisation Policy](LOCALISATION.md) — live user-facing language and localisation rules.
- [Research](research/README.md) — bounded studies, experiments, prototypes, audits, corpus work, representation investigations, and historical investigative evidence.

## System knowledge

- [Architecture](architecture/README.md) — what the system should achieve and which responsibilities and concepts exist.
- [Implementation Map](IMPLEMENTATION_MAP.md) — where accepted architectural responsibilities presently appear in source and where placement or vocabulary lags.
- [Engine Knowledge](engine/README.md) — reusable observed FS25/GIANTS runtime behaviour, API surfaces, and semantic limits.
- [Configuration](CONFIGURATION.md) — supported player-choice and consent surface, admission rules, defaults, persistence, and authority boundaries.
- [GUI](GUI.md) — Deferred, unreconciled player-facing interface and communication architecture responsibility.

The live root does not link `archive/`; archived material has no current
authority and remains bounded recovery/harvesting material until deletion is
safe.
