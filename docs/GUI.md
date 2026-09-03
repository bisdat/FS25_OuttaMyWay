# GUI — Architecture Responsibility Placeholder

> **Status:** Recognised system-architecture responsibility; architecture not yet reconciled.

## Purpose

This document reserves one authoritative live home for future player-facing GUI, HUD, messaging and interaction architecture.

## Current observation and boundaries

The repository has multiple HUD and message surfaces, many of which are diagnostic or test instrumentation rather than product GUI. Current test HUD existence must not be treated as the desired player interface. Diagnostic/test HUDs remain instrumentation unless deliberately promoted later; GUI architecture does not grant diagnostics architectural authority.

[`LOCALISATION.md`](LOCALISATION.md) remains the separate authority for localisation policy, and user-facing GUI text must respect it. Existing accessibility requirements remain binding, including avoiding red/green-only semantic communication.

Player-facing communication is a real responsibility wherever OuttaMyWay intentionally delays, regulates, waits for evidence, requests intervention, or otherwise behaves in a way that could appear stuck.

## Explicit non-decisions

This placeholder does not decide:

- screen or layout architecture;
- widget hierarchy;
- permanent HUD composition;
- notification queueing or priorities;
- settings UI;
- input bindings;
- interaction workflows;
- final wording;
- colour palette beyond known accessibility constraints;
- whether diagnostic HUD code is reused;
- when or how status messages expire; or
- how much internal state is exposed to the player.

No GUI runtime implementation changes occur here.
