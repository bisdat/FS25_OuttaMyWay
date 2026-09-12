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
of Configuration. It is identity-only: namespace initialisation followed by
`MOD_NAME` and `VERSION`. It contains no policy, calibration or comments.
There is no generic runtime settings/constants warehouse.

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

`BUILD_LABEL`, `ARCHITECTURE_VERSION` and `RUNTIME_MODE` are retired without
replacement. Startup diagnostics and VersionHud consume `VERSION` only.
Architecture is repository knowledge, not runtime identity; the one accepted
Runtime requires no mode identity. These values are not relocated into settings,
local aliases or another metadata holder.

## Diagnostic HUD implementation ownership

Diagnostic HUD enablement and layout are module-owned implementation values,
not player Configuration. Future Space, Version and Follower Pacing are independent
instrument owners: `FutureSpaceHud`, `VersionHud` and `FollowerPacingHud` each
own their own diagnostic switch, coordinates and presentation sizes; Future Space
also owns line height and Follower Pacing owns its row bound. Equal coordinates
or sizes do not establish shared HUD authority.

Future Space layout uses current Future Space vocabulary. The obsolete lifecycle
and transition HUD gates are deleted without replacement: neither has a current
production consumer or validation contract requiring retention. FutureSpaceHud
itself remains live through PassiveLiveValidator's construction, observation and
draw path. VersionHud continues to consume the legitimate root `VERSION` identity.

The future player HUD visibility concept below remains separate and unimplemented
by these diagnostic switches. No shared diagnostic settings holder or player
setting is introduced by this ownership boundary.

## Cooperative Passage Control implementation ownership

`CooperativePassageControl` owns seven module-local execution calibration and
safety bounds: Passage actuation speed (8.0 km/h), phase watchdog (45000 ms),
captured-axis alignment lateral tolerance (0.50 m) and heading minimum dot
(0.995), physical Hold settlement speed (0.25 km/h), and Control diagnostic /
clearance heartbeat cadence (1000 ms), plus captured-axis station completion
tolerance (1.0 m) for Alignment Runout and Axis Return. These are internal implementation values,
not player tuning or a separate shared Cooperative Passage constants subsystem.

**Spatial Gate Radius != Axis Station Tolerance.** `LocalPassagePlanner` owns
its two-dimensional Crossing-Window guide target radius. Control consumes the
Candidate-supplied `target.radiusM` through `NativeDriveMechanism:setReposition`,
whose completion condition is Euclidean distance to the target. Control's
independent station tolerance reaches `NativeDriveMechanism:setAxisTravel`, whose
completion condition compares projected captured-axis progress plus/minus the
tolerance with the target station. The mechanism materialises each meaning; it
does not establish a shared Passage tolerance owner.

**Value Reuse != Concept Reuse.** Both calibrations remain exactly 1.0 m; equal
literals do not establish shared policy. Neither value is player Configuration.

Local Passage fixed construction values have the Planner owner described below.
Forward Intersection policy has the Situation owner described below.

## Local Passage Planner policy and calibration ownership

`LocalPassagePlanner` owns ten fixed module-local values within Candidate-owned
planning. **Shared Owner != Shared Concept:** these values have one production
owner but distinct meanings; no generic Passage settings object exists or is
justified by this ownership. None is player Configuration.

- Passage construction policy: nominal Inter-Assembly Clearance is 1.0 m,
  supplied by Planner to `PairSpecificPassageClearance` and retained in plan and
  sweep evidence. The accepted Crossing-Window floor is nominal clearance times
  the fixed 0.95 ratio. Represented non-contact remains a separate hard condition.
- Excursion/entry calibration: minimum development is 4.0 m and forward
  development per lateral metre is 2.0; recovery equals development. The 3.0 m
  entry Control allowance remains in `frontOverlap + 2 * development + entryAllowance`.
- Guide calibration: Crossing-Window entry and exit target radii are 1.0 m.
  Development and reacquisition gate maximum radii are independently 2.0 m;
  their radii remain `min(2.0, max(traversalRadius, development * 0.25))` and
  `min(2.0, max(traversalRadius, recovery * 0.25))`, respectively.
- Evidence discretisation: Field World sweep spacing is 2.0 m and pair/third-party
  sweep sampling uses 20 samples per leg as before.

**Counterfactual Test Input != Supported Runtime Policy** refines **Test
Mutability/Injection Seam != Contract Requirement**. A counterfactual floor in
validation does not require production policy configurability. The accepted
0.95 floor is fixed Planner-owned policy, not a runtime experiment seam.

## Local Passage Action-Space Boundary ownership

**Assessment Owns Boundary; Candidate Consumes Evidence.**
`TrajectoryConflictAssessment` owns the fixed 80.0 m Local Passage Action-Space
Boundary as `LOCAL_PASSAGE_ACTION_SPACE_MAX_SEPARATION_M`. Its native-intent
revelation quiescence veto, Current-Excursion Resolution-Space Conservation and
Established-conflict Resolution-Space Conservation use this same boundary.
Established conflict publishes `actionSpaceConservation.maxSeparationM` as
Situation evidence, including when separation exceeds the boundary.

`SituationAssessment` supplies evidence without a boundary policy argument.
`LocalPassagePlanner` consumes `conflict.actionSpaceConservation.maxSeparationM`;
missing or invalid positive finite boundary evidence fails closed. Separation
above the published boundary retains `ESTABLISHED_CONFLICT_NOT_YET_LOCAL`.
Candidate does not select another boundary or supply a fallback.

The former `actionSpaceMaxSeparationM` fixture parameter is removed. Other
focused assessment calibration overrides remain internal validation
parameterisation, not player Configuration or supported runtime variability.

## Forward Intersection Intent-Revelation Creep ownership

**Situation Owns Magnitude; Authority Materialises It**, consistent with
**Policy Owner != Materialisation Site**. `SpatialConstraintAssessment` owns
fixed 1 km/h policy as `FORWARD_INTERSECTION_INTENT_REVELATION_CREEP_KMH`
for `MAXIMISE_FORWARD_INTERSECTION_INTENT_REVELATION_TIME`. It publishes
`regulationSpeedKmh` and `actionSpaceConservation.fixedRegulationSpeedKmh`.

`LiveTrafficCandidateSupport` carries the established magnitude unchanged in
`actionSpaceRegulationBridge.fixedRegulationSpeedKmh`.
`RegulationBoundedAuthority` consumes that Candidate evidence to materialise
Forward Intersection admission and rejects missing or invalid positive finite
magnitudes. Neither Candidate nor Authority independently derives this policy
or supplies a literal fallback.

Ordinary Action-Space Regulation continues through
`ResolutionSpaceProgressionEnvelope`. Forward Intersection
`WAITING_FOR_EVIDENCE` retains its existing fixed-creep authority, with no new
timeout. Temporal allocation, incumbent Follower Boundary precedence and
positive dissolution/supersession semantics are unchanged.

## Transit fold settlement ownership

`AssemblyRepresentationCache` owns Job-Episode bootstrap Transit settlement
timeout derivation from the selected/runtime GIANTS folding configuration's
`maxFoldAnimDuration`. Its module-local duration factor 1.50 and margin 2000 ms
produce `expectedFoldDurationMs * 1.50 + 2000` for positive duration; unavailable
native duration uses its 30000 ms fallback. The derived capability timeout is
capped at 35000 ms and published as `capability.settlementTimeoutMs`.

`TransitConfigurationMechanism` consumes that derived timeout. Its independent
module-local 30000 ms fallback protects missing capability/state timing during
cached Transit preparation, settlement and restoration as a defensive Control
fail-safe. It does not derive capability timing. Equal 30000 ms literals do not
establish shared policy: **Defensive Fallback != Shared Policy Owner** and
**Derived Capability Timeout != Defensive Mechanism Fallback**.

These values are not player Configuration. Cooperative Passage Control consumes
cached capability and settlement results without independently deriving timing.

## Clearance trace diagnostic publication ownership

`LiveTrafficCandidateSupport` owns the module-local 40.0 m clearance-trace
publication bound. Both rejected and selected telemetry paths use it only to
publish already-computed planner evidence within the local approach; telemetry
does not invoke planning, sweeps or geometry or recreate Candidate Search
Amplification.

**Diagnostic Publication Window != Passage Search Horizon**, consistent with
**Diagnostic Distance != Passage Distance**. This bound is not player
Configuration, Passage construction/search/geometry, Passage Entry or Action-Space
admission distance, Nominal Inter-Assembly Clearance or Crossing-Window acceptance
policy, or Control actuation policy.

Diagnostic publication owns none of the Planner construction values described above.

## Resolution-Space Regulation magnitude policy ownership

`ResolutionSpaceProgressionEnvelope` owns the fixed accepted 0.75 contingency
reserve fraction and exact 1 km/h unresolved-intent creep floor. These are
responsibility-owned Regulation magnitude policy, not player Configuration or
tuning. The reserve withholds established usable Resolution Space; it does not
claim a GIANTS braking distance.

**Policy Owner != Materialisation Site.** `RegulationBoundedAuthority`
materialises this policy through the envelope but does not own its values.
`ResolutionSpaceProgressionEnvelope.establish(distanceM, speedKmh)` accepts
current evidence; policy is module-local. **Internal Parameterisation !=
Supported Variability:** the former reserve/creep arguments supplied only the
accepted pair and established no alternate-policy contract. **Test
Mutability/Injection Seam != Contract Requirement** likewise applies to the
former offline fixture arguments.

Forward Intersection deliberately bypasses this envelope and consumes its
separate Situation-owned fixed 1 km/h magnitude described above.
**Value Reuse != Concept Reuse:** equal literals do not establish
common ownership between these policies or authorise their unification.

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

## Current root surface

Issue #87 mixed-runtime ownership decomposition has no remaining unresolved
root constant in current architecture. `scripts/config.lua` contains exactly
the namespace initialisation and two root assignments:

| Identity | Responsibility |
| --- | --- |
| `MOD_NAME` | System/mod identity |
| `VERSION` | Executable build identity, coherent with `modDesc.xml` |

Every surviving internal value belongs to its responsible module or subsystem;
there is no generic settings/constants module. The
[Implementation Map](IMPLEMENTATION_MAP.md) owns source placement.
Supported player Configuration remains separate work under Issue #139.

## Implementation boundary

This architecture does not redesign `scripts/config.lua`, implement settings or
persistence, create an options screen, investigate GIANTS APIs, change GUI/HUD
behaviour, relocate constants, or rename historical identifiers. Those require
later bounded Engineering Increments supported by evidence.
