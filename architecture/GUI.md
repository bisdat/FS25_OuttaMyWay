# GUI — Player Interface Architecture

> **Status:** Partially reconciled. Configuration Section architecture is accepted; Operational Player Messages and Help / Reference remain open under #89 and #293.

## Purpose

This document reserves one authoritative live home for future player-facing GUI, HUD, messaging and interaction architecture.

## Current observation and boundaries

The repository has multiple HUD and message surfaces, many of which are diagnostic or test instrumentation rather than product GUI. Current test HUD existence must not be treated as the desired player interface. Diagnostic/test HUDs remain instrumentation unless deliberately promoted later; GUI architecture does not grant diagnostics architectural authority.

[`LOCALISATION.md`](../docs/LOCALISATION.md) remains the separate authority for localisation policy, and user-facing GUI text must respect it. Existing accessibility requirements remain binding, including avoiding red/green-only semantic communication.

Player-facing GUI has two distinct HUD responsibilities:

1. **Product Status Indicator** — a persistent indication that OuttaMyWay is operationally enabled. It is visible in the enabled steady state and absent in the disabled steady state. It may include version identity, but exact content and presentation remain GUI decisions.
2. **Operational Player Messages** — transient/current communication explaining OuttaMyWay activity such as Regulation, Cooperative Passage, waiting, obstruction assistance or player-intervention requirements.

> **Product Status Indicator != Operational Player Messaging**

The Configuration **HUD visibility** choice governs Operational Player Messages only. It does not hide the Product Status Indicator while OuttaMyWay remains enabled, and it does not suppress Product Status notices whose purpose is to explain whether the product itself is operational.

Master OuttaMyWay enablement governs whether the Product Status Indicator exists. Explicit disablement immediately supersedes OuttaMyWay functional responsibility and triggers bounded release/neutralisation of effects the mod already owns; there is no long-lived shutdown-drain state. The Product Status Indicator must disappear when that immediate hand-back has completed rather than remain visible for an unrelated GIANTS Job or Local Operation lifetime.

A disable action may leave active GIANTS AI jobs in an awkward or unresolved physical situation because **Safe Relinquishment != Safe Resolution**. The current bounded shutdown/hand-back notification therefore confirms that OuttaMyWay has stopped and tells the player to review active workers. It uses the GIANTS blinking-warning surface for 2000 ms and remains governed by the existing Operational messages visibility choice. Broader Operational Player Message queueing and prioritisation remain #89 work.

### Disabled Startup Reminder

When a mission starts or loads with resolved Configuration state `enabled=false`, the product shell presents one transient **Disabled Startup Reminder**:

> **OuttaMyWay disabled. Review General Settings.**

The reminder:

- uses the same GIANTS blinking-warning presentation surface and position as the shutdown/hand-back notification;
- has an explicit duration of **5000 ms**;
- appears at most once for that mission load;
- waits until the mission warning surface is available rather than requiring normal Runtime bootstrap;
- is not shown when Configuration is unresolved;
- is cancelled if Configuration becomes enabled before the warning can be presented; and
- is **not** suppressed by `hudVisible`, because it reports product operational status rather than an Operational Player Message.

> **Disabled Startup Reminder != Operational Player Message**

Although the GIANTS warning presentation is visually red/flashing, the semantic state is carried explicitly by the localized text; colour is not the sole carrier of meaning.

Reality validation of TEST 0.4.2.7 showed that a nominal 2000 ms blinking-warning lifetime produced materially less readable exposure than its wall-clock duration: the reminder was visible around 08:27:37 and effectively gone by 08:27:38. The startup reminder therefore uses 5000 ms.

> **Warning Lifetime != Readable Exposure**

Player-facing communication is a real responsibility wherever OuttaMyWay intentionally delays, regulates, waits for evidence, requests intervention, hands responsibility back on disablement, reports disabled product status on startup, or otherwise behaves in a way that could appear stuck.

## Configuration Section

OuttaMyWay exposes supported player Configuration through one dedicated **OuttaMyWay Configuration Section** inside the existing GIANTS **General Settings** layout.

> **Configuration Section != Configuration Authority**

The section owns presentation and player interaction only. It MUST consume the semantic `Configuration` interface and MUST NOT read, write or interpret `configuration.xml`, schema versions, persistence paths or Runtime state directly.

The initial section exposes exactly the three accepted player choices:

| Player-facing label | Configuration value | Meaning |
| --- | --- | --- |
| **Enabled** | `enabled` | Master OuttaMyWay consent. Off immediately relinquishes all OuttaMyWay control. On requests fresh Runtime bootstrap after durable persistence succeeds. |
| **Operational messages** | `hudVisible` | Shows or hides Operational Player Messages only. It does not hide the Product Status Indicator. |
| **Debug** | `debug` | Adds bounded troubleshooting detail to the normal operational log. It does not expose engineering DIAGNOSTIC mode. |

Each choice is a simple **On / Off** option. No per-capability switches, tuning values, Logging switch, DIAGNOSTIC switch or Reset Defaults action belong in the initial section.

The section extends `InGameMenuSettingsFrame.generalSettingsLayout` rather than registering a new top-level `TabbedMenu` page or input binding. This preserves GIANTS ownership of Settings navigation, focus, lifetime and shutdown teardown.

> **Configuration Integration != Menu Ownership**

The section follows the lifetime of the GIANTS Settings frame and is installed by extending its existing callbacks. It MUST NOT be registered as a map event listener and MUST NOT mutate the top-level tab registry during `loadMap()` or `deleteMap()`.

> **Settings Extension != Map Lifecycle Participant**


Reality validation of TEST 0.4.2.5 disproved the top-level-page approach: it appeared as an empty separate pause-menu page and its map-lifecycle tab teardown left GIANTS `TabbedMenu` in an inconsistent state during game shutdown.

The Configuration area remains the architectural host for a future discoverable **Help / Reference** route. #293 owns the destination, content and navigation contract; until that responsibility is resolved, the Configuration Section MUST NOT expose an inert or misleading Help control.

### English source wording

English is the localisation source language under [`docs/LOCALISATION.md`](../docs/LOCALISATION.md). Initial Configuration Section wording is:

- section title: **OuttaMyWay**
- **Enabled** — “Allow OuttaMyWay to coordinate supported GIANTS AI field workers. Turning this off immediately returns all control to GIANTS AI.”
- **Operational messages** — “Show messages that explain OuttaMyWay activity and waiting. This does not hide the OuttaMyWay status indicator.”
- **Debug** — “Add extra troubleshooting detail to the log. Normal operational logging remains enabled.”
- persistence warning — “OuttaMyWay could not save this setting. The current value is shown in the menu.”

All user-facing strings use stable localisation keys and the required first-release language set. Colour is not used as the sole carrier of setting meaning.

## Explicit non-decisions

The remaining GUI architecture does not yet decide:

- screen or layout architecture beyond the accepted Configuration Section;
- widget hierarchy beyond the accepted three-option Configuration Section;
- permanent HUD composition beyond the accepted Product Status Indicator / Operational Player Message responsibility split;
- notification queueing or priorities;
- additional GUI input bindings beyond standard GIANTS menu navigation;
- Operational Player Message and Help / Reference interaction workflows;
- final wording outside the accepted Configuration Section and Disabled Startup Reminder source text;
- colour palette beyond known accessibility constraints;
- whether diagnostic HUD code is reused;
- when or how status messages expire; or
- how much internal state is exposed to the player.

