# Configuration Architecture

## Purpose and architectural boundary

**Configuration is OuttaMyWay's supported player-choice surface.**

Configuration exists to express choices the player is legitimately allowed to make about the product. It does not expose arbitrary implementation variability, manufacture system authority, or turn internal tuning into supported user policy.

> **Configuration as Consent Surface**

This document defines the current accepted Configuration responsibility and its boundaries. The Configuration runtime contract is intentionally incomplete: Issue #139 owns the remaining design-to-implementation investigation.

**Status: Not implemented.**

Configuration is therefore a recognised Deferred Responsibility under the repository documentation standard. No primary `/spec` exists yet, and an empty or speculative Specification must not be created merely for symmetry. A Configuration Specification becomes appropriate only when the unresolved runtime contract has been established sufficiently to state a truthful implementation-facing contract.

The [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) owns Situation Assessment, Responsibility Transition, Bounded Authority and Control. The [GUI/HUD architecture](GUI.md) owns player-facing presentation and interaction architecture. [Localisation](LOCALISATION.md) owns user-facing localisation policy.

## Specification Jurisdiction

This architecture declares one Specification Jurisdiction:

| Specification Jurisdiction | Primary architectural responsibility |
| --- | --- |
| **Configuration** | Define supported player choices, their semantic meaning, consent boundaries, defaults requirements, persistence/change obligations and compatibility expectations without creating runtime authority. |

Configuration is not a generic value-ownership jurisdiction. Internal policy, calibration, diagnostics, safety bounds, build identity and validation parameters remain owned by the responsibilities that give them meaning.

## 1. Configuration and other value responsibilities

A value belongs to Configuration because it represents a supported player choice, not because it is numeric, editable, global, easy to expose, or stored in a file whose name suggests configuration.

Classify values by semantic responsibility:

```text
Meaningful supported player choice
    -> Configuration

Architecture-owned behavioural policy
    -> owning architectural responsibility

Implementation calibration
    -> owning Specification / source responsibility

Safety, resource or watchdog bound
    -> owning runtime / Control responsibility

Diagnostic implementation detail
    -> instrumentation / diagnostics

Validation or experimental value
    -> validation / research evidence

Release or build identity
    -> release / build responsibility

GUI / HUD layout mechanics
    -> GUI / HUD responsibility
```

A shared numeric value does not establish a shared concept. Global accessibility does not establish architectural ownership. Technical mutability does not establish supported variability.

> **Negative Configuration Classification != Configuration Ownership**

Determining that a value is *not* player Configuration does not make Configuration architecture the owner of that value's implementation detail.

The durable Configuration concern is the classification rule and consent boundary. Exact module names, constants, formulas, calibration inventories and current source placement belong outside this Architecture.

## 2. Configuration admission test

A proposed setting enters supported player Configuration only when all of the following are true:

1. it represents a meaningful player choice;
2. every offered value is supported behaviour rather than an experiment or engineering convenience;
3. the choice can be explained truthfully without implementation jargon;
4. changing it cannot enlarge OuttaMyWay's architectural or safety authority;
5. an explicit supported default can be defined;
6. persistence and change semantics can be stated deliberately rather than inherited accidentally; and
7. the player benefit justifies the additional UI, compatibility and support burden.

If these conditions are not met, the value remains with its narrower architectural, implementation, diagnostic, validation or build owner.

Future settings, including any future advanced settings, must satisfy the same admission test. No options surface should be populated merely to appear comprehensive.

## 3. Accepted initial player Configuration concepts

The accepted initial conceptual surface is deliberately small:

- **OuttaMyWay enabled**;
- **HUD visibility**;
- **Logging**; and
- **Debug**.

These are semantic Configuration concepts. Final labels, explanatory text, widgets, layout and interaction mechanics are not owned here.

### OuttaMyWay enabled

This is the master product-level enable/disable choice.

When enabled, normal OuttaMyWay operation is permitted subject to all independent evidence, responsibility, representation, authority and Control boundaries.

When disabled, OuttaMyWay must not acquire new intervention responsibility or initiate new autonomous coordination.

Disabling does not require unsafe instantaneous abandonment of already-active physical Control. Existing physical authority must reach an appropriate safe neutralisation or relinquishment boundary before disablement is complete.

The exact runtime mechanism, completion evidence and transition sequence for safe disablement are not yet defined.

Configuration expresses player consent. It does not override Control safety.

### HUD visibility

HUD visibility governs normal player-facing OuttaMyWay operational communication.

It does not govern diagnostic or test HUDs merely because they are visible on screen.

Configuration owns the player's visibility choice. GUI/HUD architecture owns what normal player-facing messages exist, their lifecycle, priority, presentation, accessibility, layout and interaction semantics.

### Logging

Logging is a supported high-level choice for useful normal operational logging suitable for diagnosis and bug-report evidence.

It is not a promise that every internal diagnostic, probe, trace or cadence becomes player-configurable.

The exact runtime logging contract, default and persistence semantics are not yet defined.

### Debug

Debug is a supported high-level choice for substantially more detailed engineering/debug instrumentation.

It does not create player ownership of individual probes, sample periods, diagnostic HUDs or internal instrumentation switches.

The exact relationship between Debug, Logging and existing internal diagnostics remains unresolved. Configuration must eventually define the supported meaning without exposing the internal instrumentation topology as the public contract.

## 4. Core capabilities are not separate Configuration

Master enablement is the product-level consent boundary for supported OuttaMyWay operation.

Core runtime capabilities do not become independent player features merely because they are separately named or implemented.

In particular, current architecture does not define separate player enable switches for:

- Regulation;
- Cooperative Passage; or
- Obstruction Relocation.

These capabilities remain governed by current Situation, Current Responsibility, Bounded Authority, representation, safety and Control contracts.

> **Core Resolution Capability != Optional Configuration**

A harmless parked vehicle does not become movable because OuttaMyWay is enabled. A player-controlled subject does not lose Player Claim. Unsupported or unsafe action remains unsupported or unsafe. Configuration supplies consent to operate the product; it does not manufacture the evidence or authority required for any particular intervention.

## 5. Configuration and runtime authority

Reality is independent of player Configuration.

The normal runtime responsibility path remains:

```text
Reality
   |
   v
Observation
   |
   v
Situation Assessment
   |
   v
Responsibility Transition
   |
   v
Current Responsibility
   |
   v
Bounded Authority
   |
   v
Control
   |
   v
Reality
```

Configuration constrains operation at the boundary relevant to the setting. It does not replace any stage in that authority chain.

```text
Configuration
   |-- master enablement
   |      -> permits or prevents normal OuttaMyWay operation
   |         subject to independent runtime authority
   |
   `-- HUD / Logging / Debug
          -> presentation and instrumentation choices only
```

Configuration does not:

- establish Reality;
- create Observation evidence;
- determine Situation meaning;
- establish or supersede Current Responsibility;
- grant Bounded Authority;
- waive mandatory constraints;
- override representation fitness or hard-safety evidence;
- override GIANTS productive-job ownership;
- override current Player Claim; or
- turn unsupported Control into supported Control.

> **Configuration Can Constrain Authority; It Cannot Create Authority.**

## 6. Explicitly non-Configuration value classes

The following classes are not currently player Configuration merely because they may be represented as tunable values in implementation:

- Passage clearance and planning calibration;
- trajectory or spatial thresholds;
- Control speeds and station tolerances;
- watchdog or settlement bounds;
- resource, scan or sampling budgets;
- representation tolerances;
- Intent-Revelation Creep and other responsibility-owned policy magnitudes;
- diagnostic publication periods or windows;
- individual probe or diagnostic-HUD switches; and
- validation fixture parameters.

A future proposal to expose any such value must pass the Configuration admission test as a genuine supported player choice. Current implementation mutability or test injection does not establish that contract.

## 7. Defaults

Every implemented player setting must have an explicit supported default.

Defaults represent the intended normal player experience. They must not be inherited accidentally from development, validation, diagnostic or implementation values.

No supported defaults for the four initial Configuration concepts are established by this Architecture yet.

## 8. Persistence and ownership scope

Persistence is part of the Configuration contract, but the persistence mechanism and lifecycle ownership are not yet established.

The eventual design must use an evidence-supported FS25 mechanism rather than assuming storage design from convenience.

The following remain unresolved:

- whether a given preference belongs to player, mod, save, server or another supported lifecycle scope;
- which settings, if any, are persisted independently;
- multiplayer and server/client authority;
- schema/version ownership; and
- migration semantics for persisted values.

Configuration must not invent simulated Field World meaning merely because a preference is persisted.

## 9. Change and disablement semantics

Each implemented setting must define explicit change semantics appropriate to its behavioural consequences.

A setting may eventually apply immediately, at a safe responsibility boundary, at another evidence-defined transition, or next session. There is no architectural requirement that all settings share one reload rule.

Safety and responsibility boundaries outrank UI immediacy.

Master disablement is the highest-risk case. Accepted architecture already requires that disabling prevent new intervention responsibility while avoiding unsafe abandonment of already-active Control. The exact neutralisation/relinquishment contract remains unresolved and must be established before implementation is accepted.

## 10. Presentation and localisation boundary

Configuration owns the semantic choices made available to the player.

GUI/HUD architecture owns:

- settings presentation;
- widgets and layout;
- interaction mechanics;
- normal player-facing operational messaging; and
- visual accessibility behaviour.

Localisation owns user-facing wording/localisation policy.

Diagnostic/test HUDs remain instrumentation unless deliberately promoted through the GUI/HUD responsibility. The existence of a visible diagnostic control does not make it part of HUD visibility Configuration.

## 11. Deferred Configuration contract areas

The following Configuration contract areas are intentionally unresolved rather than silently inferred:

- supported defaults for the initial four settings;
- safe disablement completion evidence and transition sequence;
- runtime interface shape and ownership boundary;
- Logging versus Debug semantics and their relationship to internal diagnostics;
- persistence API and storage mechanism;
- preference lifecycle scope;
- multiplayer/server-client ownership;
- persisted schema/version/migration semantics; and
- per-setting change/reload behaviour.

Issue #139 owns the active investigation that must resolve these questions before Configuration implementation is accepted.

These are unresolved contract areas, not permission to preserve current implementation behaviour as architecture.

## 12. Architectural boundaries

This architecture does not authorise:

- a generic global settings/constants warehouse;
- resurrection of per-capability rollout gates;
- player tuning of internal Passage, Regulation, representation or Control calibration merely because those values exist;
- treating diagnostics as player Configuration by default;
- assuming current implementation defaults are player defaults;
- assuming a persistence mechanism or multiplayer owner without GIANTS evidence;
- unsafe instantaneous abandonment of active Control on disablement;
- GUI/HUD layout or message-lifecycle decisions; or
- implementation work under this documentation reconciliation.

Current implementation placement belongs outside this Architecture. Issue #139 owns the design-to-implementation work required to establish the still-missing Configuration contract and runtime surface.