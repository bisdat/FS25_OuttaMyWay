# Configuration Architecture

## Purpose and architectural boundary

**Configuration is OuttaMyWay's supported player-choice surface.**

Configuration exists to express choices the player is legitimately allowed to make about the product. It does not expose arbitrary implementation variability, manufacture system authority, or turn internal tuning into supported user policy.

> **Configuration as Consent Surface**

This document defines the current accepted Configuration responsibility and its boundaries. The implementation-facing contract is now mature and is operationalised by the primary Configuration Specification.

**Status: Contract defined; production implementation not yet accepted.**

The primary Specification carries `NOT_IMPLEMENTED` until production source realises this Jurisdiction. Issue #139 owns the bounded implementation work.

The [Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) owns Situation Assessment, Responsibility Transition, Bounded Authority and Control. The [Log Publication Architecture](LOG_PUBLICATION.md) owns runtime log-publication classes, eligibility and publication boundaries. The [GUI/HUD architecture](GUI.md) owns player-facing presentation and interaction architecture. [Localisation](../docs/LOCALISATION.md) owns user-facing localisation policy.

## Specification Jurisdiction — Configuration

**Owns:** supported player choices, their semantic state, defaults, player-change semantics, cross-save persistence contract, first-use materialisation, invalid-representation recovery, and the boundary between persisted Configuration and consuming subsystems.

**Does not own:** Runtime authority, subsystem interpretation of choices, GUI presentation, Log Publication internals, diagnostic engineering controls, savegame state, multiplayer Configuration semantics, or arbitrary implementation constants.

**Jurisdiction ID:** `CONFIGURATION`  
**Primary Specification:** [`spec/CONFIGURATION.md`](../spec/CONFIGURATION.md)

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

The initial supported surface contains only these three value choices. It does not include a global **Reset to Defaults** command. Defaults are part of each setting's contract; a reset command would be a separate player action with its own behavioural consequences, particularly because resetting master enablement to its default would enable OuttaMyWay and bootstrap Runtime.

> **Operational Journal != Optional Logging**

> **Configuration Choice != Publication Class**

> **Configuration Value != Configuration Action**

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

An engineering-only diagnostic sidecar MAY exist under the same mod-scoped `modSettings` directory, but it is not part of `configuration.xml`, is not exposed as supported player Configuration, and has no player-facing persistence or migration promise.

> **Player Configuration != Engineering Control**

> **Shared Persistence Location != Shared Configuration Contract**

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

## 5. Configuration runtime state and authority boundary

Configuration owns one current semantic preference state for the supported local player/profile:

- `enabled`;
- `hudVisible`; and
- `debug`.

It owns the accepted defaults, validation of supported values, application of deliberate player changes, persistence of those values through the Configuration storage boundary, and notification that a semantic Configuration value has changed.

> **Configuration State != Configuration Storage**

The current semantic Configuration state is the interface consumed by the rest of the product. Runtime and GUI consumers must not read XML, construct `modSettings` paths, interpret schema versions or derive settings from storage representation directly.

Storage is subordinate to Configuration. It persists and restores the supported representation; it does not decide what Enabled, HUD visibility or Debug mean.

> **Configuration Owns Choice; Consumer Owns Interpretation**

Consumers receive semantic values, not implementation addresses or derived subsystem policy:

```text
modSettings persistence
        |
        v
Configuration
  enabled
  hudVisible
  debug
        |
        +--> Product lifecycle
        |      consumes enabled
        |
        +--> GUI / HUD
        |      consumes hudVisible
        |
        `--> Log Publication
               consumes debug
               resolves NORMAL / DEBUG
```

Configuration does not directly bootstrap Runtime, terminate Responsibility, render HUD messages or publish logs merely because one of its values changed. The responsible consumer owns the resulting subsystem behaviour under its own architecture. Configuration supplies the accepted choice and its change boundary.

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

Configuration constrains operation at the boundary relevant to the setting. It does not replace any stage in that authority chain, and its consumers must not bypass the Configuration state interface by reaching into persistence.

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

The accepted supported defaults are:

- **OuttaMyWay enabled: on**;
- **Operational Player Messages / HUD visibility: on**; and
- **Debug: off**, which resolves ordinary Log Publication to NORMAL.

These defaults define the intended first-run/absence-of-persisted-choice behaviour. They are product decisions, not inherited values from current development, validation or diagnostic implementation.

## 8. Persistence and ownership scope

The initial OuttaMyWay Configuration is a **cross-save product preference set**, not savegame state. A player configures the product once and the same supported choices remain in force while loading, leaving, creating or switching savegames unless the player changes them.

> **Configuration Lifetime != Savegame Lifetime**

For the normal local-player/profile case, the supported persistence surface is the FS25 `modSettings` area. OuttaMyWay owns one mod-scoped persisted Configuration representation there rather than copying the three settings into individual savegames.

All three initial supported values are persisted together as Configuration:

- OuttaMyWay enabled;
- Operational Player Messages / HUD visibility; and
- Debug.

A savegame must neither own nor silently override these values.

At product-shell startup, Configuration must resolve persistence **before any normal Runtime bootstrap decision**. If the expected persisted Configuration file does not exist, Configuration treats this as first use: it creates the mod-scoped persisted representation, populates all supported settings with the accepted defaults, persists that representation, and exposes the resulting semantic Configuration state to consumers.

```text
product shell loads
      |
      v
Configuration persistence check
      |
      +-- file exists ------> load / validate persisted representation
      |
      `-- file missing -----> materialise accepted defaults
                                -> persist new Configuration file
                                -> expose semantic state
                                      |
                                      v
                              enabled decides Runtime bootstrap
```

> **Missing Configuration != Configuration Error**

> **Defaults Become Persisted State on First Use**

File absence is therefore not a transient in-memory fallback. The first successful startup with no Configuration file establishes the durable cross-save preference set immediately.

This architecture selects the persistence **surface, lifetime and first-use materialisation rule**, not an exact XML filename, element layout or GIANTS API call sequence. Those belong to the Configuration Specification and implementation once the persisted representation is defined.

An existing persisted representation whose **content cannot be parsed, fails Configuration validation, or declares an unsupported/older schema** is recovered immediately by replacing it with a fresh representation populated from the accepted defaults. The recovered defaults become the current semantic Configuration state and the replacement is persisted before Runtime bootstrap is considered.

```text
existing Configuration file
        |
        +-- current + valid ------> load semantic state
        |
        `-- malformed / invalid /
            unsupported schema --> reset all supported values to defaults
                                  -> overwrite with current representation
                                  -> expose default semantic state
```

> **Invalid Persisted Configuration != Runtime Failure**

> **Unsupported Schema != Migration Obligation**

The initial Configuration contract therefore carries **no persisted-value migration obligation**. Unsupported historical schemas are replaced rather than transformed field-by-field. With only three supported values, preserving a potentially ambiguous older representation is not worth allowing stale or partially interpreted preference meaning into Runtime.

A mechanical storage failure is different. If Configuration cannot establish its durable representation because the persistence API cannot read required content, create/replace the representation, or successfully save it, normal Runtime bootstrap must not proceed. The product shell may remain available so the failure can be surfaced through ordinary product/logging facilities, but autonomous traffic responsibility must not start from Configuration state whose persistence contract was not established.

> **Persistence Recovery != Storage Success**

> **Configuration Invalidity Is Recoverable; Configuration Storage Failure Is Not**

The initial supported Configuration scope is the **local player/profile** case. Multiplayer/server-client Configuration ownership, propagation, conflict resolution and authority are intentionally outside the current support claim because they cannot presently be validated against Reality.

> **No Validation Route != Permission to Invent Semantics**

> **Unvalidated Multiplayer Configuration != Unsupported Multiplayer Runtime**

This boundary says nothing about whether OuttaMyWay runtime behaviour can operate in multiplayer generally. It says only that the project does not yet claim Configuration semantics for questions such as whose Enabled choice governs, whether Configuration is server-authoritative, or how host/client preferences interact.

Future multiplayer Configuration work must be added from evidence without changing the local profile preference set into savegame-scoped state.

The persisted representation must expose enough schema identity for Configuration to distinguish the current supported representation from an unsupported one. Exact schema identifier/version syntax belongs to the Configuration Specification. Unsupported schemas are reset and overwritten rather than migrated.

When startup resolves `enabled=false`, the product shell may load Configuration, Log Publication and required settings/GUI integration, but normal Runtime bootstrap must not occur. Job Episodes, Local Operations, Situation, Current Responsibility, Commitments and Bounded Authority are runtime semantic state and must not be resurrected from a prior enabled session.

If the player later re-enables OuttaMyWay, Runtime performs a fresh bootstrap from current GIANTS Reality. An immediate off-then-on sequence likewise starts a new Runtime interpretation rather than resuming a pre-disable Passage, Regulation, Relocation or Local Operation record.

> **Product Shell != Runtime Bootstrap**

Persisted Configuration must never contain or imply Runtime semantic authority merely because it survives between saves.

## 9. Change and disablement semantics

Each implemented setting must define explicit change semantics appropriate to its behavioural consequences. There is no architectural requirement that all settings share one reload rule.

Master disablement applies immediately as product-consent withdrawal: no new OuttaMyWay responsibility may be acquired, existing functional responsibility is superseded, dependent authority is invalidated, owned physical effects are released/neutralised, and Runtime coordination stops. No waiting-for-completion, Passage drain, shutdown timeout or Local Operation completion gate is part of this contract.

The implementation must preserve authority ordering while doing so: semantic responsibility ends through Responsibility Transition, and downstream cleanup may only narrow/release OuttaMyWay effects. Disablement must not use cleanup as authority to complete, redirect or replace the interrupted intervention.

Re-enablement applies through fresh Runtime bootstrap from current Reality rather than continuation of pre-disable semantic state.

HUD visibility changes apply immediately to Operational Player Message publication/presentation. They do not alter Runtime responsibility or the Product Status Indicator.

Debug changes apply immediately to the resolved Log Publication policy: off resolves to NORMAL and on resolves to DEBUG. Changing Debug does not activate or deactivate DIAGNOSTIC instruments and does not alter Runtime semantic authority.

> **Observability Change != Runtime Authority Change**

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

## 11. Configuration contract maturity

The initial local-profile Configuration contract is mature enough for implementation and is operationalised by the primary [Configuration Specification](../spec/CONFIGURATION.md).

The Specification owns the exact `modSettings` filename, XML representation, schema identifier, GIANTS persistence API obligations and storage-failure mechanics beneath this Architecture.

Multiplayer/server-client Configuration semantics remain outside the current validated support scope. DIAGNOSTIC engineering controls remain outside supported player Configuration.

Issue #139 now owns implementation and validation against this contract rather than further architectural invention.

## 12. Architectural boundaries

This architecture does not authorise:

- a generic global settings/constants warehouse;
- consumers reading or interpreting persisted Configuration representation directly instead of consuming semantic Configuration state;
- persistence storage deciding subsystem meaning or Runtime authority;
- resurrection of per-capability rollout gates;
- player tuning of internal Passage, Regulation, representation or Control calibration merely because those values exist;
- a player Logging on/off switch that suppresses the NORMAL operational journal;
- exposing NORMAL, DEBUG or DIAGNOSTIC publication-class names as the player Configuration contract;
- exposing DIAGNOSTIC engineering instrumentation as a supported player setting;
- treating diagnostics as player Configuration by default;
- treating in-game Help content as another Configuration setting merely because the settings surface links to it;
- adding a global Reset to Defaults action to the initial three-toggle Configuration surface;
- assuming current implementation defaults are player defaults;
- treating a missing first-use Configuration file as an error or leaving defaults only in volatile memory;
- attempting to preserve or partially interpret malformed, invalid or unsupported-schema Configuration instead of replacing it with accepted defaults;
- claiming persisted recovery succeeded when the storage mechanism failed to read/write the replacement;
- persisting supported Configuration inside individual savegames;
- allowing savegame state to override the cross-save Configuration preference set;
- claiming multiplayer/server-client Configuration ownership, propagation or authority without validation evidence;
- waiting for Regulation, Passage, Relocation or Local Operation completion after explicit player disablement;
- abandoning owned physical effects without authority-reducing release/neutralisation;
- using shutdown cleanup to continue or invent a strategic resolution after consent withdrawal;
- resurrecting pre-disable Runtime semantic state on re-enable;
- GUI/HUD layout, Help presentation or message-lifecycle decisions; or
- implementation work under this documentation reconciliation.

Current implementation placement belongs outside this Architecture. Issue #139 owns the design-to-implementation work required to establish the still-missing Configuration contract and runtime surface.