# Configuration Architecture

## Purpose and architectural boundary

**Configuration is OuttaMyWay's supported player-choice surface.**

Configuration exists to express choices the player is legitimately allowed to make about the product. It does not expose arbitrary implementation variability, manufacture system authority, or turn internal tuning into supported user policy.

> **Configuration as Consent Surface**

This document defines the current accepted Configuration responsibility and its boundaries. The Configuration runtime contract is intentionally incomplete: Issue #139 owns the remaining design-to-implementation investigation.

**Status: Not implemented.**

Configuration is therefore a recognised Deferred Responsibility under the repository documentation standard. No primary `/spec` exists yet, and an empty or speculative Specification must not be created merely for symmetry. A Configuration Specification becomes appropriate only when the unresolved runtime contract has been established sufficiently to state a truthful implementation-facing contract.

The [Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) owns Situation Assessment, Responsibility Transition, Bounded Authority and Control. The [Log Publication Architecture](LOG_PUBLICATION.md) owns runtime log-publication classes, eligibility and publication boundaries. The [GUI/HUD architecture](GUI.md) owns player-facing presentation and interaction architecture. [Localisation](../docs/LOCALISATION.md) owns user-facing localisation policy.

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
- **HUD visibility**; and
- **Debug**.

There is no separate player-facing Logging on/off choice. NORMAL publication is the intrinsic operational journal and therefore part of ordinary product operation rather than optional Configuration.

These are semantic Configuration concepts. Final labels, explanatory text, widgets, layout and interaction mechanics are not owned here.

> **Operational Journal != Optional Logging**

> **Configuration Choice != Publication Class**

### OuttaMyWay enabled

This is the master product-level enable/disable choice.

When enabled, normal OuttaMyWay operation is permitted subject to all independent evidence, responsibility, representation, authority and Control boundaries. The player-facing GUI must expose a persistent **Product Status Indicator** while OuttaMyWay is operationally enabled so the player can tell that the mod is active. The indicator may include version identity, but its exact presentation is GUI responsibility.

When disabled, OuttaMyWay must not acquire new intervention responsibility or initiate new autonomous coordination. In the disabled steady state the Product Status Indicator is absent.

An explicit player change from enabled to disabled is a withdrawal of product consent and therefore a **product-level supersession condition**. It does not wait for a Local Operation, Regulation, Cooperative Passage, Obstruction Relocation or other current intervention to complete its ordinary objective. Responsibility Transition must terminate current OuttaMyWay functional responsibility, dependent Bounded Authority must end, and Control must immediately stop, neutralise or relinquish effects it already owns. Regulation, Passage actuation, Bubble Bullet Time and Obstruction Relocation do not form a shutdown drain.

> **Resolution Commitment != Product Consent**

> **Player Disablement Supersedes Functional Responsibility**

Immediate disablement means immediate semantic termination plus bounded authority-reducing cleanup. It does not mean silently ceasing execution while stale OuttaMyWay effects remain. Cleanup may release holds, speed limits, Bullet Time, Passage/relocation actuation or other owned effects, but it must not invent a new strategic target or continue solving the traffic situation after consent has been withdrawn.

> **Safe Relinquishment != Safe Resolution**

The player may therefore inherit an awkward or unresolved GIANTS AI situation after disablement. GUI/HUD architecture must support a truthful shutdown/hand-back message so the player can review or stop active AI jobs where necessary; exact wording, visibility priority and message lifecycle remain GUI/HUD responsibility.

Configuration expresses player consent. It cannot create Runtime authority, but withdrawal of that consent is authoritative input requiring existing OuttaMyWay responsibility to end.

### HUD visibility

HUD visibility governs **Operational Player Messages**: normal player-facing communication about current OuttaMyWay activity such as Regulation, Cooperative Passage, waiting, obstruction assistance or player-intervention requirements.

It does not govern the Product Status Indicator that shows OuttaMyWay is enabled, and it does not govern diagnostic or test HUDs merely because they are visible on screen.

Configuration owns the player's Operational Player Message visibility choice. GUI/HUD architecture owns which messages exist, their lifecycle, priority, presentation, accessibility, layout and interaction semantics.

> **Product Status Indicator != Operational Player Messaging**

> **HUD Visibility Governs Operational Messages, Not Product Status**

### Debug

Debug is the supported player escalation from the intrinsic NORMAL operational journal to substantially more detailed support-grade causal publication.

The supported default is **Debug off**.

The Configuration mapping is:

```text
Debug=false
    -> resolved Log Publication policy = NORMAL

Debug=true
    -> resolved Log Publication policy = DEBUG
```

NORMAL remains active when Debug is off. Configuration does not expose NORMAL, DEBUG or DIAGNOSTIC as player-selectable publication-class names; it exposes the semantic player choice **Debug** and maps that choice internally.

DIAGNOSTIC remains targeted engineering instrumentation for development and narrowed investigation. It is not a supported player Configuration choice and is not enabled merely because Debug is enabled. Any internal diagnostic-instrument activation mechanism remains outside Configuration responsibility.

Debug does not create player ownership of individual probes, sample periods, diagnostic HUDs or internal instrumentation switches.

> **Player Debug != Engineering Diagnostics**

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
   |      -> enabled permits normal OuttaMyWay operation
   |         subject to independent runtime authority
   |      -> disabling supplies product-level supersession
   |         -> terminate functional responsibility
   |         -> relinquish owned physical effects
   |         -> stop Runtime coordination
   |      -> enabled steady state shows Product Status Indicator
   |      -> disabled steady state hides Product Status Indicator
   |
   |-- HUD visibility
   |      -> controls Operational Player Messages only
   |      -> does not hide Product Status Indicator
   |
   `-- Debug
          -> false maps to NORMAL publication
          -> true maps to DEBUG publication

DIAGNOSTIC remains internal engineering instrumentation
outside supported player Configuration.
```

Configuration does not:

- establish Reality;
- create Observation evidence;
- determine Situation meaning;
- directly establish Current Responsibility;
- grant Bounded Authority;
- waive mandatory constraints;
- override representation fitness or hard-safety evidence;
- override GIANTS productive-job ownership;
- override current Player Claim; or
- turn unsupported Control into supported Control.

Configuration may constrain or withdraw product consent. Responsibility Transition remains the authority that makes resulting Current Responsibility termination authoritative.

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

The supported Debug default is **off**, which resolves ordinary Log Publication to NORMAL.

Supported defaults for **OuttaMyWay enabled** and **HUD visibility** remain unresolved and must be established deliberately before implementation. They must not be inherited from current development/test behaviour.

## 8. Persistence and ownership scope

Persistence is part of the Configuration contract, but the persistence mechanism and lifecycle ownership are not yet established.

The eventual design must use an evidence-supported FS25 mechanism rather than assuming storage design from convenience.

The following remain unresolved:

- whether a given preference belongs to player, mod, save, server or another supported lifecycle scope;
- which settings, if any, are persisted independently;
- multiplayer and server/client authority;
- schema/version ownership; and
- migration semantics for persisted values.

The persisted master-enabled choice has one accepted lifecycle consequence even though the storage mechanism is unresolved: when startup resolves `enabled=false`, the product shell may load Configuration, Log Publication and required settings/GUI integration, but normal Runtime bootstrap must not occur. Job Episodes, Local Operations, Situation, Current Responsibility, Commitments and Bounded Authority are runtime semantic state and must not be resurrected from a prior enabled session.

If the player later re-enables OuttaMyWay, Runtime performs a fresh bootstrap from current GIANTS Reality. An immediate off-then-on sequence likewise starts a new Runtime interpretation rather than resuming a pre-disable Passage, Regulation, Relocation or Local Operation record.

> **Product Shell != Runtime Bootstrap**

Configuration must not invent simulated Field World meaning merely because a preference is persisted.

## 9. Change and disablement semantics

Each implemented setting must define explicit change semantics appropriate to its behavioural consequences. There is no architectural requirement that all settings share one reload rule.

Master disablement applies immediately as product-consent withdrawal: no new OuttaMyWay responsibility may be acquired, existing functional responsibility is superseded, dependent authority is invalidated, owned physical effects are released/neutralised, and Runtime coordination stops. No waiting-for-completion, Passage drain, shutdown timeout or Local Operation completion gate is part of this contract.

The implementation must preserve authority ordering while doing so: semantic responsibility ends through Responsibility Transition, and downstream cleanup may only narrow/release OuttaMyWay effects. Disablement must not use cleanup as authority to complete, redirect or replace the interrupted intervention.

Re-enablement applies through fresh Runtime bootstrap from current Reality rather than continuation of pre-disable semantic state.

Change semantics for HUD visibility and Debug remain to be finalised.

## 10. Presentation and localisation boundary

Configuration owns the semantic choices made available to the player.

GUI/HUD architecture owns:

- settings presentation;
- widgets and layout;
- interaction mechanics;
- Product Status Indicator presentation;
- Operational Player Message presentation and lifecycle;
- in-game Help / Reference presentation and navigation; and
- visual accessibility behaviour.

Localisation owns user-facing wording/localisation policy.

Configuration does not own enduring product explanation merely because Help is reached from a settings/menu surface.

> **Configuration Choice != Product Explanation**

A future OuttaMyWay settings/menu surface must provide a discoverable route to the in-game Help / Reference responsibility tracked by Issue #293. Help content itself is not another Configuration setting. It explains enduring product concepts and supported behaviour, while #89 owns transient operational communication about what OuttaMyWay is doing now.

Diagnostic/test HUDs remain instrumentation unless deliberately promoted through the GUI/HUD responsibility. The existence of a visible diagnostic control does not make it part of HUD visibility Configuration.

## 11. Deferred Configuration contract areas

The following Configuration contract areas are intentionally unresolved rather than silently inferred:

- supported defaults for OuttaMyWay enabled and Operational Player Message visibility;
- runtime interface shape and ownership boundary;
- persistence API and storage mechanism;
- preference lifecycle scope;
- multiplayer/server-client ownership;
- persisted schema/version/migration semantics; and
- per-setting change/reload behaviour.

The Debug publication mapping is no longer unresolved: Debug off maps to NORMAL and Debug on maps to DEBUG. DIAGNOSTIC has no supported player Configuration mapping.

Issue #139 owns the active investigation that must resolve these questions before Configuration implementation is accepted.

These are unresolved contract areas, not permission to preserve current implementation behaviour as architecture.

## 12. Architectural boundaries

This architecture does not authorise:

- a generic global settings/constants warehouse;
- resurrection of per-capability rollout gates;
- player tuning of internal Passage, Regulation, representation or Control calibration merely because those values exist;
- a player Logging on/off switch that suppresses the NORMAL operational journal;
- exposing NORMAL, DEBUG or DIAGNOSTIC publication-class names as the player Configuration contract;
- exposing DIAGNOSTIC engineering instrumentation as a supported player setting;
- treating diagnostics as player Configuration by default;
- treating in-game Help content as another Configuration setting merely because the settings surface links to it;
- assuming current implementation defaults are player defaults;
- assuming a persistence mechanism or multiplayer owner without GIANTS evidence;
- waiting for Regulation, Passage, Relocation or Local Operation completion after explicit player disablement;
- abandoning owned physical effects without authority-reducing release/neutralisation;
- using shutdown cleanup to continue or invent a strategic resolution after consent withdrawal;
- resurrecting pre-disable Runtime semantic state on re-enable;
- GUI/HUD layout, Help presentation or message-lifecycle decisions; or
- implementation work under this documentation reconciliation.

Current implementation placement belongs outside this Architecture. Issue #139 owns the design-to-implementation work required to establish the still-missing Configuration contract and runtime surface.