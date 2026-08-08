# Scope Overlay Test-Role Calibration

> **Authority:** Canonical evidence and architecture since v4.6.23
>
> **Implementation state:** Knowledge and governance only; no new runtime Scope Overlay, Decision, Commitment or Control behaviour

## Purpose

This document records the bounded empirical calibration performed after the v4.6.22 Scope Overlay architecture. The objective was not to test every machine or crop. It was to discover whether the proposed test roles corresponded to real Giants AI behaviour and whether each role exposed an architectural distinction that OuttaMyWay must understand.

The investigation used the sequence:

```text
Observe
    -> Discuss
        -> Hypothesise
            -> Select exact configuration
                -> Execute only the required Evidence Horizon
                    -> Validate or disprove
                        -> Record bounded conclusion
```

## Runtime baselines

Repository baseline for this investigation:

- exact canonical v4.6.22;
- SHA-256 `b636bafdd59afcedba133b2dac65a19286f3dc980734eac63b612c0aaf3a941f`;
- OuttaMyWay v4.6.22 runtime instrumentation.

Game evidence is version-bound:

- TS005 through TS009: FS25 `1.21.0.0`, observed build family `b40525`;
- TS010: FS25 `1.21.1.0`, build `b40785`, revision `81824`.

No separate 1.21.1.0 change description was available during the investigation. This is a **Silent Baseline Transition**. Earlier results are not invalidated automatically; they remain evidence for their declared runtime baseline until a relevant change or contradictory observation requires targeted revalidation.

## Test evidence contract

### Complete Test Configuration

A test conclusion belongs to the complete declared configuration, not to a machine name alone. The minimum record is:

- repository and game baseline;
- map, field and controlled environment;
- agronomic context and exact state;
- operation and Giants AI job type;
- powered vehicle and working assembly;
- required working behaviour;
- relevant pose or configuration;
- scenario role;
- decisive expected observation;
- decisive contradiction;
- Evidence Horizon;
- interpretation boundary and post-test consequence.

Exact tested configuration supports an exact conclusion. Broader category claims require additional contrast or repeatability evidence.

### Candidate ladder

```text
Test-Role Obligation
    -> Agronomic Role Candidate
        -> Configuration Candidate
            -> Verified Test Configuration
```

A candidate is selected only after the architectural obligation is clear. Equipment convenience must not invent the obligation.

### Evidence Horizon

The **Essential Evidence Horizon** ends when the declared claim is decided. Full-field completion is required only when completion, final pass, parking, stopping, post-work configuration or another late lifecycle event is the claim.

This produced two efficiency discoveries:

- **Coverage Compression:** one controlled session may answer several independent claims;
- **Fixture-Generation Evidence:** a preparation operation may also become valid evidence when its exact configuration, state and outcome are sufficiently observed.

### Evidence classes

The calibration distinguishes:

- existence evidence;
- repeatability evidence;
- contrast evidence;
- boundary evidence;
- contradiction evidence.

Negative evidence is valid only after **State Sufficiency**: all known prerequisites for the attempted operation must be satisfied before failure is interpreted.

## Final test-role dispositions

| Role | Final definition | Disposition | Evidence |
|---|---|---|---|
| TR-01 | Reference Positive | Satisfied | TS005 |
| TR-02 | Dynamic-Extent Positive | Satisfied | TS008-P |
| TR-03 | Non-Tractor Operational Assembly | Satisfied | TS006, supported by TS008-P |
| TR-04 | Material-Chain Boundary | Satisfied | TS006 + TS007 |
| TR-05 | Distinct Spatial-Regime Positive | Retired | strongest candidate excluded at admission in TS009 |
| TR-06 | Asymmetric Working Envelope | Satisfied | TS010 |
| TR-07 | Admission-Rejection Negative | Satisfied | TS007 and TS009 |
| TR-08 | Post-Admission Failure Negative | Strongly supported | TS008-N; runtime corroboration incomplete |

The original eight roles were hypotheses about necessary evidence, not a commitment to eight expensive or permanent test categories. Reality retired or replaced roles that did not describe an OuttaMyWay responsibility.

## Scenario evidence

### TS005 — Reference positive

**Fixture:** Riverbend Springs Field 4, approximately 0.99 ha, flat rectangular field, ploughed state.

**Configuration:** DEUTZ-FAHR 6135 C RVshift from the 6C RVshift family, standard tyres, no front attachment, with KNOCHE ECO-CULTIVATOR 300.

**Observation:** Giants AI admitted the job, sustained cultivation, completed the field, stopped at the north-east area and raised the cultivator.

**Bounded conclusion:** the exact tractor-cultivator configuration is a positive native Giants AI reference under the declared fixture. Repeatability across maps, states or other cultivators was not established.

### TS006 — Specialist assembly and fixture generation

**Fixture:** Field 4, wheat in harvest-ready state.

**Configuration:** CLAAS EVION 450 with CLAAS VARIO 620; straw swath enabled.

**Observation:** Giants AI sustained harvesting, ordinary manoeuvres and completion. The header was an attached operationally essential member. Harvesting produced a persistent straw swath used by TS007.

**Bounded conclusion:** the exact combine-header configuration is Control Eligible for native Giants AI wheat harvesting with straw-swath production. It establishes a Non-Tractor Operational Assembly and valid Fixture-Generation Evidence. It does not establish multiple-combine coordination or combine-to-trailer offloading.

### TS007 — Configuration-level admission rejection

**Fixture:** the TS006 post-harvest wheat-straw field.

**Configuration:** DEUTZ-FAHR 6135 C RVshift with base-game KUHN VB 3190 baler. AI-baler extension available in the installation but not loaded.

**Observation:** manual straw collection succeeded; no suitable native Giants AI baling job could be created.

**Bounded conclusion:** the exact configuration is agriculturally and manually viable but outside native Giants AI Control Eligibility because no job is admitted.

This is the **Admission-Rejection Boundary**:

> A configuration may be agriculturally valid and manually operable while remaining outside Giants AI Control Eligibility because no suitable job can be admitted.

### TS008-N — Execution-time agronomic-state rejection

**Fixture:** Field 4 with wheat initially left at harvest-ready state.

**Configuration:** Condor Endurance II, 36 m working width, intended fertilising operation.

**Observation:** the job was accepted briefly but stopped because the fruit state was incompatible. The event was directly observed by the repository owner; its short lifecycle occurred between current observer samples and was not independently reconstructed from runtime instrumentation.

**Bounded conclusion:** this strongly supports **Execution-Time State Rejection** and the **Agronomic State Gate**:

> A configuration can be Control Eligible while a particular operation remains non-viable because the encountered agronomic state is incompatible.

The result is not an admission rejection. Runtime corroboration remains incomplete because of the **Transient Admission Visibility Gap**.

### TS008-P — Dynamic-extent positive

**Fixture:** the same field changed to wheat `green big` and needing fertiliser.

**Configuration:** Condor Endurance II with liquid fertiliser and no herbicide.

**Observation:** Giants AI attached the worker, unfolded the boom from a compact transport pose to the 36 m working pose, sustained working and manoeuvring, began later passes and completed the short field. Selected outer geometry moved to approximately +15.12 m and -15.12 m relative lateral positions.

**Bounded conclusion:** the exact Condor configuration is a positive native Giants AI crop-care configuration with a materially changing Physical Assembly extent.

Field 4 also exposed **Fixture-to-Assembly Scale Compatibility**: a fixture suitable for a narrow reference implement can be poorly scaled for a 36 m assembly. The Reference Field Fixture is not a Universal Field Fixture.

### TS009 — Crop-system admission rejection

**Fixture:** Field 4 containing three painted north-south olive rows, approximately 5 m headroom at each end, olives in growing state.

**Configuration:** Landini REX 4 GT with AGRISEM DISC-O-Vigne V.

**Observation:** manual inter-row cultivation succeeded. Native Giants AI refused the job with the on-screen message `Grapes and olives not supported`. No worker was admitted.

**Bounded conclusion:** grapes and olives are excluded from native Giants AI field-worker support under the tested baseline even when the exact assembly is manually viable.

This is **Native Crop-System Exclusion**. It disproved the proposed positive permanent-row test before route or corridor behaviour could be tested.

The original TR-05 obligation was retired rather than preserved artificially. The positive spatial-regime premise may return only if future evidence identifies a native Giants AI operation that genuinely uses a materially different spatial model.

### TS010 — Asymmetric working-envelope positive

**Fixture:** Field 4, grass ready to cut.

**Configuration:** DEUTZ-FAHR 6135 C RVshift with base-game SaMASZ XT 390; no front mower.

**Observation:** Giants AI admitted the job, deployed the mower to the tractor's right, kept the mower at the field edge and worked in a spiral or contour-like pattern. Repeated working and manoeuvring phases occurred. The test stopped after the Essential Evidence Horizon and before full completion.

**Bounded conclusion:** the exact configuration is native Giants AI Control Eligible for mowing and has a persistently right-offset active working envelope. Giants displaced the powered-vehicle route so the working envelope followed the required field boundary.

This establishes:

- **Offset Working Envelope** — active work is not necessarily centred on the vehicle trajectory;
- **Trajectory–Work Displacement** — the powered-vehicle path and effective working-area centre may be laterally separated;
- **Work-Envelope-Anchored Routing** — Giants may route the vehicle specifically so an asymmetric working envelope follows the operational boundary.

The result does not establish left-offset, mirrored or reversible asymmetry, nor numerical OuttaMyWay measurement accuracy.

## Cross-scenario architectural discoveries

### Material-Chain Control Boundary

TS006 and TS007 form one **Material-Chain Boundary Pair**:

```text
wheat harvest and straw generation — native Giants AI Control Eligible
    -> straw remains agriculturally valid
        -> downstream base-game baling — manual positive, native AI admission negative
```

> Continuity of an agricultural material chain does not imply continuity of Giants AI Control Eligibility.

The downstream assembly may remain manually useful, physically present, semantically identifiable and obstacle-relevant without becoming an Operation participant.

### Non-Tractor Operational Assembly

A valid Operation participant may be an integrated or specialist machine rather than a tractor towing a rear implement. TS006 establishes a powered machine plus required attached working unit; TS008-P adds an integrated self-propelled working system.

### Agronomic Proxy Drift

The original Persistent/Regrowing Lifecycle role confused a crop characteristic with an OuttaMyWay responsibility.

> Agronomic Proxy Drift occurs when an unusual crop property is mistaken for a system test obligation even though OuttaMyWay neither controls nor reasons about that property.

Grass remained useful only as the fixture that enabled the asymmetric-mower test.

### Valid Boundary Straddling — provisional

TS010 produced repeated conservative-envelope containment warnings while the visible Giants operation appeared valid and the offset mower remained aligned to the field edge. This decreases confidence in any invariant that requires the entire coarse physical rectangle to remain strictly inside the field polygon.

The possible **Valid Boundary Straddling** concept remains provisional. The result may reflect real legitimate margin use, conservative rectangle overreach, or both. It does not yet revise the accepted Full-Envelope Field Containment architecture; it creates a targeted review obligation before containment enforcement.

## Runtime baseline governance

Every empirical result must retain:

- FS25 version, build and revision when available;
- OuttaMyWay version;
- test date;
- map, field and fixture state;
- exact powered vehicle and working assembly;
- declared claim and bounded conclusion.

Evidence states are:

- **Current** — observed on the active runtime baseline;
- **Version-bound** — valid evidence from an earlier baseline with no known contradiction;
- **Revalidation candidate** — a relevant game change may affect the claim;
- **Invalidated** — later evidence directly disproves continued applicability.

### Patch Impact Watch

GIANTS releases are reviewed for changes to:

- vehicle, implement or job categories;
- AI admission, routing, manoeuvring, completion or parking;
- attachments, folding, collision or physics;
- SDK or API information;
- crop-system eligibility;
- any behaviour that intersects a recorded test or architectural assumption.

A patch does not trigger indiscriminate retesting. A relevant change or contradictory sentinel result triggers targeted revalidation.

### Patch Sentinel Set

The initial sentinel set is:

- TS005 — ordinary tractor-implement positive;
- TS008-P — dynamic extent;
- TS010 — asymmetric working envelope;
- TS007 or TS009 — admission rejection boundary;
- TS008-N — post-admission state rejection when practical.

The sentinel set is a governance aid, not a permanent frozen suite. It may change when implementation or architecture changes the highest-value assumptions.

## Calibration closure

The Scope Overlay Test-Role Calibration phase is complete. Every original role is now satisfied, retired by evidence, replaced by a more relevant role, or explicitly bounded by an instrumentation limitation.

This closure does not complete implementation validation, multi-worker conflict testing, intervention testing, performance testing or patch-triggered revalidation. Future tests begin from a named architectural or implementation claim rather than from a desire to accumulate machine coverage.

No machine-readable Scope Overlay table, runtime eligibility evaluator, route change, Decision, Commitment, Control or player UI behaviour is authorised by this consolidation.
