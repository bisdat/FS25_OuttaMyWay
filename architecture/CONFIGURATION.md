# Configuration Architecture

## Purpose and boundary

**Configuration is OuttaMyWay's supported player-choice and product-consent surface.** It does not decide runtime traffic responsibilities, invent AI capability, own GUI layout or become a container for arbitrary technical values.

**Jurisdiction ID:** `CONFIGURATION`  
**Primary Specification:** [Configuration Specification](../spec/CONFIGURATION.md)

**Owns:** the supported semantic choices, defaults, cross-save lifetime, persistence and recovery boundary, durable change semantics, and separation between user choice and other value domains.

**Does not own:** Log Publication internals, GUI presentation, GIANTS worker control, diagnostic engineering sidecars, future Situation/Recovery authority, savegame data, unsupported multiplayer semantics, or build identity.

The current product includes bounded native-blockage Hold & Relocate, completion-triggered native TRANSIT requests, and independently qualified physical Completion Parking. Resolved master Enabled is prerequisite consent for these runtime responsibilities, **not** a decision to move a vehicle. Each intervention requires its own current GIANTS evidence, Situation Assessment, admission and bounded Control authority. Configuration itself neither assesses worker situations nor commands vehicles.

## Supported choices

The accepted player choices remain deliberately few. Every future choice must pass a **Configuration admission test**: it must be meaningful to the player, offer entirely supported behaviour, have an explicit default, clear persistence and change semantics, not enlarge system/safety authority, and justify its ongoing interface and support burden.

| Choice | Semantic scope | Current product effect |
| --- | --- | --- |
| **Enabled** | Master product consent | When resolved and On, permits independent runtime admission and displays the version-only Product Status Indicator. Off withdraws further admission, requests immediate bounded relinquishment of held effects, hides the indicator, and permits a disabled-startup reminder on subsequent mission load. It does not itself prove physical hand-back. |
| **Operational messages** (`hudVisible`) | Consent to future operational player communications | Retained as a durable choice, but does **not** hide the Product Status Indicator or disabled-startup reminder. The full operational message surface is not implemented. |
| **Debug** | Support-grade logging escalation | False selects NORMAL; true selects DEBUG. NORMAL remains on. It does not activate DIAGNOSTIC instrumentation. |

No per-capability switches for Regulation, Passage or Recovery, no arbitrary tuning options, no player logging-off switch, no player engineering-DIAGNOSTIC option and no Reset Defaults command belong in this initial supported surface.

**Player choice != implementation capability.** A durable Enabled value does not resurrect old traffic modules or turn historical architecture into current functionality.

## Full Completion Parking choice

Full Completion Parking is a separate player choice, default **On**, governing post-completion **physical relocation and parking**. It is subordinate to master Enabled and independent of engineering DIAGNOSTIC publication. Turning it Off must prevent new physical parking and safely supersede any pending or currently held parking Control; it must not disable native successful-completion TRANSIT requests or unrelated interventions.

Configuration defines the supported choice and consent boundary; the [Completion-Triggered Terminal Egress architecture](COMPLETION_TRIGGERED_TERMINAL_EGRESS.md) governs physical responsibility. The dedicated parking choice is accepted but not yet present in the current schema-1 state or General Settings. Until the scoped work in Issue #139 implements it, Completion Parking consumes master Enabled and its own independent admission conditions. Implementation and persistence details belong to the Configuration Specification.

## Lifetime and storage

Configuration belongs to the **local player/profile**, not to a savegame. The three implemented choices persist together across saves in one OuttaMyWay-specific `modSettings` representation; the deferred parking choice is not yet stored.

On first use, the representation is created from supported defaults and persisted before resolved semantic choices are exposed. When an existing representation is malformed, invalid or from an unsupported schema, the whole supported value set is reset to accepted defaults and overwritten. Unsupported historical storage schemas do not carry an automatic field-by-field migration obligation.

A **mechanical storage failure** is different from invalid content. Configuration must not claim that its state was durably resolved if reading/writing the required representation failed. The shell may remain loaded to report the failure, but consumers must not treat an unpersisted fallback as established consent.

Persisted Configuration has no authority to store Job Episodes, physical movement, obligations, prior responsibility or any future AI Runtime state.

> **Persistence Recovery != Storage Success.**

## Player-change semantics

- **Enabled off:** immediately withdraws consent for new runtime admissions and requests bounded relinquishment/neutralisation of existing Hold & Relocate and Completion Parking Control, as well as retirement of pending completion-request state. Failed native neutralisation remains uncertainty, not proven safe resolution. A persistence failure must not falsely claim durable success or retain withdrawn consent.
- **Enabled on:** requires successfully persisted consent before restoring admission eligibility. Already-composed consumers reassess current GIANTS Reality under their independent contracts; Configuration does not start or resume a GIANTS AI job.
- **Operational messages:** change immediately for their future message consumer; the version-only status indicator and disabled reminder are independent. A persistence failure must not be reported as successful durability.
- **Debug:** changes the resolved NORMAL/DEBUG publication policy without changing any runtime worker responsibility. Engineering DIAGNOSTIC remains a separate, unsupported player-sidecar policy.

Configuration exposes resolved semantic state and durable change notifications. Consumers may not inspect the XML schema or path and infer player wishes independently.

## Other value boundaries

Implementation calibration belongs to its narrow source/Specification responsibility; validation tolerances belong to testing; architectural policy belongs to the authority that governs it; source code and release identity are not player Configuration.

An optional engineering `diagnostics.xml` sidecar may share the modSettings directory but is **not** a player Configuration setting. Its lifecycle and priority are described through [Log Publication](LOG_PUBLICATION.md) and its [Specification](../spec/LOG_PUBLICATION.md), not through the Configuration UI.

## Presentation, applicability and uncertainty

[GUI Architecture](GUI.md) owns the version-only status display, disabled reminder and supported General Settings extension. [Log Publication](LOG_PUBLICATION.md) owns event eligibility, severity, rendering and GIANTS logging delivery. [Localisation](../docs/LOCALISATION.md) owns player language rules.

The supported persisted-Configuration envelope is local-profile usage. Multiplayer authority, synchronisation and conflict resolution are **not claimed** without their own Reality tests. Active Hold & Relocate and completion responsibilities consume Configuration consent without becoming Configuration responsibilities; broader coordination beyond their qualified envelopes is not claimed.

The implementation-facing persistence format, ordering, failure outcomes, Settings adapter participation and validation routes are owned by the primary [Configuration Specification](../spec/CONFIGURATION.md).
