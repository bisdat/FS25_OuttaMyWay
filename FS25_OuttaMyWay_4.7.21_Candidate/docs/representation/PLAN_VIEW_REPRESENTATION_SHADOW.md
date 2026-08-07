# Plan-View Representation and Positive Encounter Admission

> **Implementation:** v4.7.21 candidate (representation authority unchanged from canonical v4.7.18; v4.7.21 adds separate Future Space conformance evidence)  
> **Canonical baseline:** v4.7.18  
> **Authority:** positive interaction support only

## Current permission

The configuration-filtered footprint may now support exactly two conclusions:

- `CURRENT_SPACE_INTERACTION`;
- `FUTURE_SPACE_CONVERGENCE` within the bounded horizon.

It may not support negative clearance. `SHADOW_CLEARANCE_UNRESOLVED` remains an explicit unresolved result.

## One-way evidence composition

```text
scalar positive OR filtered-footprint positive
        ↓
positive interaction evidence
        ↓
Encounter Knowledge
```

An unresolved footprint cannot erase scalar evidence. It also cannot terminate an active Encounter because it does not prove clearance. When both sources are positive, one packet records both bases. No result from this module selects a Yield worker, strategy, Commitment or Control action.

# Historical v4.7.17 Plan-View Representation Shadow

> **Implementation:** v4.7.17 canonical  
> **Historical baseline:** v4.7.15  
> **Authority at that increment:** passive shadow only

## Purpose

Recover the proven compound plan-view representation mechanisms without allowing incomplete evidence to affect Encounter admission or Control.

## Cache hierarchy

```text
Job Episode
├── immutable assembly graph
├── complete local geometry inventory
├── cached material configuration profiles
└── transient positioned plan-view footprints
```

Expensive hierarchy resolution and local geometry measurement occur once per Job Episode. Cheap runtime participation checks occur when a new material profile is first encountered. Reused profiles transform only their cached participating primitives through current authoritative poses.

## Inventory–participation separation

The complete inventory answers **what geometry is available in the instantiated asset**. A configuration profile answers **what geometry currently participates in physical occupancy**.

The v4.7.16 live run disproved treating these as the same set: inactive alternative Condor shop geometry inflated a 36 m machine to approximately 54 m.

v4.7.17 uses:

1. runtime `getIsCompoundChild` state as principal participation evidence;
2. matching purchased configuration plus donor membership only as a fallback when runtime evidence is unavailable;
3. explicit inactive and unresolved inventories;
4. no positive authority from generic primitives whose current participation is unresolved.

## Condor donor

The source-derived 36 m donor retains all 29 known physical compound-child identities:

- eight 36 m boom components;
- five permanent physical controls;
- sixteen alternative boom components belonging to other shop configurations.

Alternative identities remain cached and logged. They enter a profile only if current runtime physics identifies them as participating.

## Shadow outcomes

- `SHADOW_CURRENT_INTERACTION_POSITIVE`
- `SHADOW_FUTURE_CONVERGENCE_POSITIVE`
- `SHADOW_CLEARANCE_UNRESOLVED`

Only positive interaction involving participating represented components is supportable. No profile grants negative-clearance authority while Coverage Closure is absent.

## Live gate

Use TS015 and confirm:

- Condor selector evidence identifies the purchased folding configuration;
- full inventory and active/inactive counts are explicit;
- the deployed Condor bounds are broadly consistent with 36 m rather than 54 m;
- Patriot is independently runtime-filtered;
- geometry API counts do not rise on profile reuse;
- activity-check counts rise only when a new profile is created;
- no shadow result creates live interaction evidence or an Encounter;
- Control remains disabled.
