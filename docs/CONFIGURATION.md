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

### Core resolution capabilities are not separate player options

A supported non-active, unclaimed Causal Obstruction is handled through normal
OuttaMyWay Obstruction Relocation when current Situation, responsibility,
Bounded Authority and Control evidence justify that response.

Obstruction Relocation is therefore a core resolution capability, not a separate
player consent setting. Enabling OuttaMyWay as a whole is sufficient product
consent for that capability. This does not make arbitrary parked vehicles
movable: harmless occupancy creates no responsibility, current Player Claim is
hands-off, active GIANTS workers remain under active spatial negotiation, and
unsupported or unsafe relocation still fails closed or escalates.

> **Core Resolution Capability != Optional Configuration**

> **Master Enablement Is Sufficient Consent for Core Obstruction Relocation**

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
    |-- master enablement
    |      -> permits or prevents normal OuttaMyWay operation subject to all
    |         independent evidence, responsibility, authority and Control bounds
    |
    `-- HUD / Logging / Debug
           -> presentation and instrumentation only
```

Configuration does not establish Reality, Observation evidence or Situation
meaning. Master enablement governs whether OuttaMyWay operates as a product; it
does not selectively grant or veto individual core resolution capabilities.
HUD, Logging and Debug affect presentation or instrumentation, not Responsibility
Transition. Configuration never enlarges responsibility or Bounded Authority.

Configuration does not:

- prove Reality;
- establish Observation evidence;
- create Situation meaning;
- establish Responsibility Transition;
- create Current Responsibility;
- grant Bounded Authority;
- override representation fitness or safety evidence;
- override GIANTS job ownership or player takeover; or
- turn an unsupported action into a supported one.

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
| PLAYER CONFIGURATION CANDIDATE | no unified player-setting key is currently implemented in this file | The accepted player concepts are master enablement, HUD visibility, Logging and Debug. Internal gates or constants must not be promoted merely because they are editable. |
| SYSTEM / RELEASE IDENTITY | `MOD_NAME`; `VERSION`, `BUILD_LABEL` | `MOD_NAME` identifies the system/mod. `VERSION` and `BUILD_LABEL` carry release/build identity. None is player Configuration. |
| ARCHITECTURAL / RESPONSIBILITY POLICY | `COOPERATIVE_PASSAGE_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M`, `COOPERATIVE_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO`, `RESOLUTION_SPACE_CONTINGENCY_RESERVE_FRACTION`, exact `RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH` | Policy concepts belong with the responsibility that gives them meaning. D-number provenance is not semantic ownership, and accepted exact policy must not become player tuning. |
| IMPLEMENTATION CALIBRATION | Entity-Local Shape Evidence coherence/root-alias calibration; Follower Boundary alignment/retention/clearance/temporal-seed calibration; Trajectory Conflict Assessment sampling/coherence/supersession/opposed-current values; Passage development and gate geometry; Control effect-speed calibration | Entity-local shape calibration is owned by its shared Resolution evidence predicate; `.61` localises Trajectory Conflict Assessment calibration and `.62` localises Follower Boundary assessment calibration to their evaluators; other empirical mechanics belong with their implementing module or subsystem unless later evidence establishes genuinely shared meaning. |
| SAFETY / RESOURCE BOUND | Passage sweep sample count and phase watchdog; fold-settlement bounds | Bounds constrain resource use, responsiveness or physical intervention. They are not player-granted authority. Exact owning implementation/control responsibility may require later decomposition. |
| DIAGNOSTIC | Field Identity, Productive Continuation, Native Drive Command, Native Manoeuvre and Progression Preservation instrument controls; lifecycle/transition/future-space and version/follower HUD flags and coordinates | `.60` localises the five live instrument enablement/publication cadences to their owning modules. They remain internal diagnostics, not Player Configuration. Normal Logging and Debug are higher-level player choices, not exposure of each switch. |
| VALIDATION / EXPERIMENTAL | `CONTROL_AUTHORITY_ENABLED`; `COOPERATIVE_PASSAGE_ENABLED` | Current gates and test values are implementation or validation evidence. They do not define the master enabled setting and grant no production authority by location. |
| HUD IMPLEMENTATION | `TRANSITION_HUD_*`, `VERSION_HUD_*`, `FOLLOWER_PACING_HUD_*` | Coordinates, sizes, rows and diagnostic display flags belong to HUD/diagnostic implementation, not Configuration architecture. |
| HISTORICAL RESIDUE | evidence-only remnants whose owning responsibility has expired | Demonstrated Productive Coverage, Productive Coverage Residual, Refuge Qualification, Headland Manoeuvre Sweep and the legacy follower-maturation forensic shadow are retired from shipped runtime/configuration; Git and durable engineering records own that history. Any remaining residue is not Configuration and remains subject to Issue #87 ownership review. |
| UNRESOLVED | `ARCHITECTURE_VERSION`; `RUNTIME_MODE`; `FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED`; some Cooperative Passage development/traversal/reacquisition and hold/heartbeat values | `.62` proves the Follower Boundary enable gate is not assessment calibration: it remains a separate Candidate-expression gate pending its own ownership classification. Other unresolved values likewise require bounded investigation rather than prefix-based movement. |

Field World ownership is now decomposed by meaning rather than common prefix:
`FieldWorldSnapshotRegistry` owns Snapshot-generation budget plus fingerprint
quantisation/schema; `FieldWorldEquivalenceEvaluator` owns the spatial
equivalence interpretation thresholds; and `FieldWorldEquivalenceAuthority`
owns retained comparison/resolution evidence-history bounds. Those values are
internal implementation evidence, not player Configuration, and no longer
occupy the mixed root surface. Existing Obstruction Relocation, Runtime,
Representation and Entity-Local Shape Evidence ownership remains unchanged.
Fold-settlement bounds remain internal safety/control values. `.59` retires the
legacy follower-maturation forensic shadow and all `FOLLOWER_MATURATION_*`
root residue because that diagnostic no longer answers a current engineering
question; the aligned `FOLLOWER_BOUNDARY_*` production path remains unchanged.
`.60` further removes the twelve live diagnostic instrument values from the mixed
root surface without changing their booleans or cadences: Field Identity,
Productive Continuation, Native Drive Command, Native Manoeuvre and Progression
Preservation each own the controls that only govern their own observation or
publication. Runtime's 250 ms cycle remains independently owned.
`.61` removes the ten trajectory/opposed-current calibration values from the
mixed root and makes `TrajectoryConflictAssessment` their explicit owner.
`SituationAssessment` supplies evidence and external Passage Action-Space context,
but no longer couriers evaluator-private calibration.
`.62` likewise removes six Follower Boundary assessment calibrations from the
mixed root and makes `FollowerBoundaryDemandAssessment` their explicit owner.
The separate `FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED` Candidate-expression
gate remains distinct and unchanged.
The inventory is descriptive; Issue #87 continues ownership-family decomposition
without retuning values merely because their placement changes.

## Implementation boundary

This architecture does not redesign `scripts/config.lua`, implement settings or
persistence, create an options screen, investigate GIANTS APIs, change GUI/HUD
behaviour, relocate constants, or rename historical identifiers. Those require
later bounded Engineering Increments supported by evidence.
