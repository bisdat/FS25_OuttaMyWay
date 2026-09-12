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

`CooperativePassageControl` owns six module-local execution calibration and
safety bounds: Passage actuation speed (8.0 km/h), phase watchdog (45000 ms),
captured-axis alignment lateral tolerance (0.50 m) and heading minimum dot
(0.995), physical Hold settlement speed (0.25 km/h), and Control diagnostic /
clearance heartbeat cadence (1000 ms). These are internal implementation values,
not player tuning or a separate shared Cooperative Passage constants subsystem.

**Value Reuse != Concept Reuse.** The root traversal-gate radius remains consumed
by `LocalPassagePlanner` for Passage-guide traversal and by
`CooperativePassageControl` for Alignment Runout and Axis Return tolerance.
Whether these represent one shared Passage Gate Tolerance concept or two
historically equal calibrations remains unresolved; Control calibration ownership
does not decide that question.

Remaining Local Passage construction, Transit fold settlement and
Forward Intersection Regulation policy remain separate Issue #87 ownership work.

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

Localising this diagnostic does not resolve Local Passage construction ownership.
The 1.0 m traversal-gate shared-semantics question described above remains
unresolved. Transit fold settlement and Forward Intersection Regulation policy
remain separate Issue #87 ownership work.

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

Forward Intersection deliberately bypasses this envelope and retains its
separate fixed 1 km/h root cap. Its deeper ownership relationship remains
unresolved. **Value Reuse != Concept Reuse:** equal literals do not establish
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

## Current Mixed Runtime Constants Surface

The following inventory is implementation evidence, not a rename, relocation or
migration backlog. Categories describe likely current architectural kind; they
do not bless historical names or values. `UNRESOLVED` is deliberate where source
evidence does not establish a responsible owner.

| Likely kind | Representative current values or families | Boundary indicated by current evidence |
| --- | --- | --- |
| PLAYER CONFIGURATION CANDIDATE | no unified player-setting key is currently implemented in this file | The accepted player concepts are master enablement, HUD visibility, Logging and Debug. Internal gates or constants must not be promoted merely because they are editable. |
| SYSTEM / RELEASE IDENTITY | `MOD_NAME`; `VERSION` | These are the only root identities: `MOD_NAME` identifies the system/mod and `VERSION` identifies the executable build. Neither is player Configuration. |
| ARCHITECTURAL / RESPONSIBILITY POLICY | `COOPERATIVE_PASSAGE_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M`, `COOPERATIVE_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO`, `FORWARD_INTERSECTION_REGULATION_SPEED_KMH` | Policy concepts belong with the responsibility that gives them meaning. D-number provenance is not semantic ownership, and accepted exact policy must not become player tuning. |
| IMPLEMENTATION CALIBRATION | Entity-Local Shape Evidence coherence/root-alias calibration; Follower Boundary alignment/retention/clearance/temporal-seed calibration; Trajectory Conflict Assessment sampling/coherence/supersession/opposed-current values; Passage development and gate geometry | Entity-local shape calibration is owned by its shared Resolution evidence predicate; `.61` localises Trajectory Conflict Assessment calibration and `.62` localises Follower Boundary assessment calibration to their evaluators; other empirical mechanics belong with their implementing module or subsystem unless later evidence establishes genuinely shared meaning. |
| SAFETY / RESOURCE BOUND | Passage sweep sample count; fold-settlement bounds | Bounds constrain resource use, responsiveness or physical intervention. They are not player-granted authority. Exact owning implementation/control responsibility may require later decomposition. |
| DIAGNOSTIC | Field Identity, Productive Continuation, Native Drive Command, Native Manoeuvre and Progression Preservation instrument controls | `.60` localises the five live instrument enablement/publication cadences to their owning modules. They remain internal diagnostics, not Player Configuration. Normal Logging and Debug are higher-level player choices, not exposure of each switch. |
| VALIDATION / EXPERIMENTAL | no retained per-capability runtime enable/disable gate | `.63` retires the historical Control, Cooperative Passage and aligned-Follower pseudo-state gates. Core capability availability and prohibition are enforced by Responsibility / Bounded Authority / typed Control topology, not booleans. |
| HUD IMPLEMENTATION | no diagnostic HUD values remain in the mixed root | FutureSpaceHud, VersionHud and FollowerPacingHud independently own their local presentation values under [Diagnostic HUD implementation ownership](#diagnostic-hud-implementation-ownership). Unconsumed lifecycle/transition gates are deleted, not relocated. |
| HISTORICAL RESIDUE | evidence-only remnants whose owning responsibility has expired | Demonstrated Productive Coverage, Productive Coverage Residual, Refuge Qualification, Headland Manoeuvre Sweep and the legacy follower-maturation forensic shadow are retired from shipped runtime/configuration; Git and durable engineering records own that history. Any remaining residue is not Configuration and remains subject to Issue #87 ownership review. |
| UNRESOLVED | some Cooperative Passage development/traversal/reacquisition values | `.63` resolves the per-capability gate question by retirement. Control execution/settlement/alignment/watchdog/heartbeat values are module-owned under [Cooperative Passage Control implementation ownership](#cooperative-passage-control-implementation-ownership). Remaining values still require bounded ownership investigation rather than prefix-based movement. |

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
`.63` follows the existing **Core Resolution Capability != Optional
Configuration** rule through the live traffic stack: Cooperative Passage and
aligned Follower Boundary have no independent enable state beneath master
OuttaMyWay enablement, while unsupported/general Control is prohibited by the
absence of an authorised typed path rather than by a false flag. Passive
diagnostics record actual bounded dispatch outcomes instead of pseudo-authority
state.
The inventory is descriptive; Issue #87 continues ownership-family decomposition
without retuning values merely because their placement changes.

## Implementation boundary

This architecture does not redesign `scripts/config.lua`, implement settings or
persistence, create an options screen, investigate GIANTS APIs, change GUI/HUD
behaviour, relocate constants, or rename historical identifiers. Those require
later bounded Engineering Increments supported by evidence.
