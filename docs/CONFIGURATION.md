# Configuration architecture

## Purpose and scope

**Configuration is the supported player-choice surface of OuttaMyWay.**

**Configuration as Consent Surface** means that Configuration expresses choices
the player is legitimately allowed to make. It does not expose arbitrary
implementation variability and does not create strategic or physical authority.

This document owns:

- which choices the player may make and the semantic meaning of each setting;
- the admission rule for adding settings;
- defaults policy and persistence expectations;
- consent and authority boundaries;
- change semantics requirements; and
- compatibility and migration requirements.

It does not own presentation mechanics or turn internal constants into player
choices. Exact labels, explanatory text, widgets, layout, HUD movement or scale,
and interaction mechanics belong to future [GUI/HUD architecture](GUI.md).

## Configuration and other value responsibilities

Classify a value by the responsibility that gives it meaning:

```text
Meaningful supported player choice
    -> Configuration

Architecture-owned behavioural policy
    -> architectural/responsibility-owned policy

Implementation calibration
    -> owning implementation module/subsystem

Safety/resource/watchdog bound
    -> owning implementation/control responsibility

Diagnostic implementation detail
    -> diagnostics

Validation/prototype/experimental value
    -> validation/research/implementation evidence

Release/build identity
    -> release/build responsibility

HUD/GUI layout mechanics
    -> future GUI/HUD implementation
```

[`scripts/config.lua`](../scripts/config.lua) is not the architectural definition
of Configuration. It is currently a **Mixed Runtime Constants Surface**
containing unrelated responsibilities. Its centrality is implementation evidence,
not desired architecture.

Place a value in the narrowest responsibility that legitimately owns it. Promote
it to shared scope only when multiple components genuinely share the same
semantic concept. A value needed only by one implementation module should
normally become module-local when later implementation work reaches it. A
genuinely shared value belongs to its responsibility or subsystem. Only
genuinely system-wide identity or invariants belong at the root `OuttaMyWay`
namespace.

Global accessibility is an implementation mechanism, not an architectural
responsibility. Do not replace the mixed surface with a generic `globals.lua`
dumping ground. Equal numeric values do not prove shared meaning or ownership.

## Configuration admission test

A value belongs in player Configuration only when every condition below holds:

1. It represents a meaningful player choice.
2. Every offered value is supported behaviour, not an experiment.
3. It can be explained without implementation terminology.
4. Changing it cannot enlarge OuttaMyWay's architectural or safety authority.
5. It can have an explicit supported default and persistence semantics.
6. The player benefit justifies the additional UI and support complexity.

If any condition is not met, the value remains internal. A value is not
Configuration merely because it is numeric, tunable, currently stored in
`config.lua`, or technically possible to expose.

## Initial player Configuration concepts

The initial conceptual surface is deliberately small. These are semantic setting
concepts; final player-facing labels and localisation may be established during
later user-facing work.

### OuttaMyWay enabled

This is the master enable or disable choice.

- Enabled permits normal OuttaMyWay operation subject to every architectural
  evidence, responsibility and authority boundary.
- Disabled prevents acquisition of new OuttaMyWay intervention responsibility
  and autonomous coordination.
- Disabling does not require unsafe instantaneous abandonment of already-active
  physical Control. Safe neutralisation and relinquishment remain a Control
  responsibility.

Configuration expresses player intent; it does not override Control safety.
The runtime transition mechanism remains implementation work.

### HUD

The player may choose whether normal OuttaMyWay player-facing operational
communication is visible. This setting does not encompass diagnostic/test HUDs.
Future GUI/HUD architecture may support visibility, movement and scaling, but
layout, movement, scale and presentation remain deferred to that responsibility.

### Logging

Logging is a supported choice for useful normal operational logging suitable for
diagnosis or bug-report evidence. It does not expose every diagnostic or Probe
toggle.

### Debug

Debug is a supported choice for substantially more detailed engineering/debug
instrumentation. Individual Probe switches, sampling periods, diagnostic HUDs
and instrumentation controls remain internal implementation details. The later
implementation may refine the relationship between Debug and Logging; this
architecture does not require unnecessary coupling between them.

### Completed-obstruction assistance consent

This semantic setting allows or disallows OuttaMyWay intervention that physically
changes a completed AI assembly when fresh architecture independently establishes
a legitimate responsibility on behalf of an active productive beneficiary.

- Enabling it does not grant responsibility or movement authority.
- Completion creates no parking, tidying or cleanup duty.
- A harmless completed assembly remains where GIANTS left it.
- Configuration may withhold consent for this intervention class but cannot
  manufacture its governing basis.

This is a semantic name, not a final player-facing label. Legacy Terminal Egress,
Terminal Yield Consent, D-number and implementation terminology do not determine
that label; later localisation and GUI work does. The development value
`AUTOMATIC_TERMINAL_EGRESS = true` provides no evidence for an eventual release
default.

## Configuration and authority

Reality is independent of player Configuration. The normal runtime responsibility
path remains:

```text
Reality
    |
Observation
    |
Situation Assessment
    |
Responsibility Transition
    |
Current Responsibility
    |
Bounded Authority
    |
Control
    |
Reality
```

Configuration applies only as an external constraint or input at the boundary
relevant to each setting:

```text
Configuration
    |-- intervention consent
    |      -> may prohibit acquisition of an otherwise-supported optional
    |         intervention; never supplies its governing basis or authority
    |
    `-- HUD / Logging / Debug
           -> presentation and instrumentation only
```

Configuration does not establish Reality, Observation evidence or Situation
meaning. Consent settings may constrain whether an optional intervention already
supported by independent evidence can be acquired. HUD, Logging and Debug
settings affect presentation or instrumentation, not Responsibility Transition.
Configuration never enlarges responsibility or Bounded Authority.

Configuration may prohibit a class of optional behaviour within architectural
bounds. Absence of a prohibition is not a grant of authority. Configuration does
not:

- prove Reality;
- establish Observation evidence;
- create Situation meaning;
- establish Responsibility Transition;
- create Current Responsibility;
- grant Bounded Authority;
- override representation fitness or safety evidence;
- override GIANTS job ownership or player takeover; or
- turn an unsupported action into a supported one.

For example, `completed-obstruction assistance = enabled` means only that player
consent does not prohibit that intervention when all independent architectural
conditions establish it. It does not permit OuttaMyWay to move completed
vehicles whenever it chooses.

## Advanced Configuration

Architecture may allow a future Advanced section, but a setting enters it only
when the same Configuration admission test proves it is a legitimate supported
player choice. Do not populate an options surface merely to make it appear
comprehensive.

Passage clearance values, trajectory thresholds, Passage or Control speeds,
sweep sample counts, watchdog durations, Field World equivalence tolerances,
representation scan/resource budgets, Intent-Revelation Creep magnitude, fold
timing bounds and diagnostic sample intervals are not currently player
Configuration. Depending on the value, they are architectural policy,
implementation calibration, safety/resource bounds or diagnostics. Later
ownership follows evidence and responsibility rather than current file placement.

## Defaults and compatibility

Every player setting must have an explicit supported default before player-facing
implementation. Defaults represent the intended normal player experience and
must not be inherited accidentally from development, validation or diagnostic
switches. Current `config.lua` values are not evidence of final player defaults
unless architecture explicitly establishes them.

When the settings schema evolves, migrations and versioning must preserve the
defined meaning of player Configuration. Compatibility aliases or conversions
exist only where a supported persisted setting actually requires them.

## Persistence

Player Configuration should persist across game sessions through an appropriate
supported FS25 settings mechanism. The exact GIANTS API and storage mechanism
remain deferred until implementation investigation.

Configuration is player/mod preference. It is not automatically part of
simulated Field World Reality or a farm/save lifecycle. Multiplayer and
server/client ownership remain unresolved pending evidence about FS25's supported
settings semantics; this architecture does not choose an owner prematurely.

## Change and reload semantics

Each implemented setting must define explicit change semantics appropriate to
its behavioural implications: for example, immediate application, application
at the next safe responsibility boundary, or application next session. There is
no universal requirement that all changes take effect immediately. Safety and
responsibility boundaries outrank UI immediacy; exact mechanisms remain deferred
to implementation.

## Current Mixed Runtime Constants Surface

The following inventory is implementation evidence, not a rename, relocation or
migration backlog. Categories describe likely current architectural kind; they
do not bless historical names or values. `UNRESOLVED` is deliberate where source
evidence does not establish a responsible owner.

| Likely kind | Representative current values or families | Boundary indicated by current evidence |
| --- | --- | --- |
| PLAYER CONFIGURATION CANDIDATE | `AUTOMATIC_TERMINAL_EGRESS` | Candidate only for completed-obstruction assistance consent semantics. Its development value is not a release default. The other initial concepts have no equivalent unified setting in this file. |
| SYSTEM / RELEASE IDENTITY | `MOD_NAME`; `VERSION`, `BUILD_LABEL` | `MOD_NAME` identifies the system/mod. `VERSION` and `BUILD_LABEL` carry release/build identity. None is player Configuration. |
| ARCHITECTURAL / RESPONSIBILITY POLICY | `D0146_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M`, `D0146_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO`, `D0146_RESOLUTION_SPACE_CONTINGENCY_RESERVE_FRACTION`, exact `D0146_RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH` | Policy concepts belong with the responsibility that gives them meaning. D-number provenance is not semantic ownership, and accepted exact policy must not become player tuning. |
| IMPLEMENTATION CALIBRATION | representation coherence/root-alias tolerances; follower alignment, retention and clearance factors; trajectory sampling/coherence/supersession values; Passage development and gate geometry; Control effect-speed calibration | Empirical mechanics belong with their implementing module or subsystem unless later evidence establishes genuinely shared meaning. |
| SAFETY / RESOURCE BOUND | representation member/hierarchy budgets and revalidation cadence; `LIVE_RUNTIME_CONTROL_INTERVAL_MS`; Passage sweep sample count and phase watchdog; fold-settlement bounds; completed-obstruction movement distance and watchdogs; Field World generation/comparison/resolution budgets | Bounds constrain resource use, responsiveness or physical intervention. They are not player-granted authority. Exact owning implementation/control responsibility may require later decomposition. |
| DIAGNOSTIC | passive sampling, heartbeat and pair-log limits; Field Identity, Productive Continuation, Native Drive Command, Guarded Recovery, Native Manoeuvre, progression and other Probe flags/intervals; lifecycle/transition/future-space and version/follower HUD flags and coordinates | Diagnostic instruments and their cadence/layout remain internal. Normal Logging and Debug are higher-level player choices, not exposure of each switch. |
| VALIDATION / EXPERIMENTAL | `CONTROL_AUTHORITY_ENABLED`; follower maturation test controls; `D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED`; `PROTOTYPE_22_CAPABILITY_GATE_ENABLED`; `PROTOTYPE_22_*` regulation/release controls | Current gates and test/prototype values are implementation or validation evidence. They do not define the master enabled setting and grant no production authority by location. |
| HUD IMPLEMENTATION | `TRANSITION_HUD_*`, `VERSION_HUD_*`, `FOLLOWER_PACING_HUD_*`, `PROTOTYPE_22_HUD_*` | Coordinates, sizes, rows and diagnostic display flags belong to HUD/diagnostic implementation, not Configuration architecture. |
| HISTORICAL RESIDUE | disabled Demonstrated Productive Coverage, Productive Coverage Residual and Refuge Qualification values; retained historical follower-shadow values; obsolete headers and donor comments | Retained forensic/replay values and historical vocabulary have no current production or Configuration authority. This inventory neither authorises deletion nor continued retention. |
| UNRESOLVED | `ARCHITECTURE_VERSION`; `RUNTIME_MODE`; `FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED`; some D-0146 development/traversal/reacquisition and hold/heartbeat values; `FIELD_WORLD_FINGERPRINT_VERSION` | Current placement and comments do not establish whether each is identity, policy, calibration, compatibility or residue. Later bounded investigation should resolve ownership without assuming that common location or numeric equality supplies it. |

Field World fingerprint/equivalence calibration, including quantisation, sampling,
area/perimeter/centroid/bounds/boundary/Jaccard tolerances and comparison limits,
belongs across implementation calibration and safety/resource bounds; it is not
player Configuration. Fold-settlement and completed-obstruction watchdogs are
likewise internal safety/control bounds. No item is renamed, moved, deleted or
retuned by this inventory.

## Implementation boundary

This architecture does not redesign `scripts/config.lua`, implement settings or
persistence, create an options screen, investigate GIANTS APIs, change GUI/HUD
behaviour, relocate constants, or rename historical identifiers. Those require
later bounded Engineering Increments supported by evidence.
