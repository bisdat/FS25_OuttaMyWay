# Causal Obstruction and Obstruction Relocation — 0.5 Architecture

**Jurisdiction ID:** `OBSTRUCTION_RELOCATION`
**Primary Specification:** [Obstruction Relocation](../spec/OBSTRUCTION_RELOCATION.md)

**Status:** TEST `0.5.1.5`, Issue #463, **reconstructs the archived pre-stall Causal Obstruction authority** using the actual archived physical-shape, DISC-overlap, and bounded Realised Motion Demand kernels. TEST `0.5.1.4` failed GIANTS Reality: the native `isBlocked` signal arrived after collision and the non-active blocker did not move. TEST `0.5.1.5` is an **unvalidated GIANTS hypothesis**, not an accepted physical PASS. We deliberately do not import the retired 0.4 general runtime.

**Archive authority investigated:** [Runtime Responsibility Architecture §2, §5, §8](https://github.com/bisdat/FS25_OuttaMyWay/blob/archive/0.4.11.0/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) and [Obstruction Relocation Specification](https://github.com/bisdat/FS25_OuttaMyWay/blob/archive/0.4.11.0/spec/OBSTRUCTION_RELOCATION.md). The archived current contract superseded the earlier D-0147 two-stage Terminal Egress / Double Courtesy model. Mechanical donor evidence remains useful, but completion provenance never creates an independent reason for movement.

## Purpose and semantic boundary

A completed GIANTS AI worker ceases active Job Episode membership, but its Physical Assembly remains part of Reality. A physical vehicle that was never a GIANTS worker is equally relevant where its current presence blocks active supported work.

**Completion Leaves Occupancy, Not Responsibility.** A harmless completed worker stays where GIANTS stopped it. No terminal tidying, speculative moving, parking, mandatory boundary settlement, permanent refuge, or Job resurrection is justified by completion.

**Physical Relevance != Historical Provenance.** A Causal Obstruction is positively established *current* interference by a real physical subject with a supported active beneficiary's continuation, not vehicle identity, elapsed idle time, proximity, or a completed Job Episode. Warm, cold-loaded and previously unobserved non-active physical assemblies must be represented on current Reality terms. Missing old Job history cannot disqualify them.

**Causal Obstruction != Obstruction Relocation.** Situation Assessment identifies the beneficiary and current physical blocker. Only separate admission of a non-active, unclaimed and supportably movable controlled subject may establish an Obstruction Relocation responsibility. Source AI reactivation or current player control can invalidate non-job physical authority, even though the obstruction still physically exists.

## Responsibility and action lifecycle

```text
current GIANTS FIELDWORK beneficiary + current physical subject
    |
    v
positive Causal Obstruction (Situation; no movement permission)
    |
    +-- active GIANTS worker -> existing active-worker Hold & Relocate
    |
    +-- non-active, player-controlled -> no non-job actuation
    |
    +-- non-active, unclaimed, positively admissible
             |
             v
    Obstruction Relocation responsibility + bounded non-job authority
             |
             v
    optional compact/transit -> fixed bounded inward movement
             |
             v
    neutralise / restore leased physical state -> fresh Reality
             |
             +-- positive active continuation -> obligation discharged
             +-- same live obstruction + further supported inward space
             |       -> a *new* bounded actuation may be considered
             +-- unsupported/inconsistent evidence -> unresolved / escalation
```

**Beneficiary != Controlled Subject.** The active worker's productive continuation justifies movement of the non-active blocker; it does not transfer its GIANTS job to that blocker. The non-job actuator MUST NOT create, restart, stop or clone the blocker's FIELDWORK Job. Hold & Relocate's native reverse and stop/start sequence remains for *active* workers only.

**Relocation Is Geometry-Bounded, Not Count-Bounded.** Select a movement direction toward the supported beneficiary's **own** Field World centre, with an offset centre possible where positively supported approach conflicts with a straight centre bearing. A fixed first/second-courtesy quota is not architecture. A physical manoeuvre is a bounded actuation, not a permanent settlement. The archived `60 m` per-actuation cap and `40 m` lateral offset are donor implementation calibrations to be verified on the 0.5 port, **not automatically adopted requirements**.

**Field Ownership Is Not Field Proximity.** The finished worker can lie outside a field; determine the relevant field from the active beneficiary/Operation, not from arbitrary nearest polygons, and never reinstate `SINGLE_OUTSIDE_KNOWN_FIELD_POLYGONS`.

**Physical Relocation != Positive Continuation.** A successful drive request or completed movement does not prove that the obstruction has ceased; require fresh supported beneficiary continuation/discharge. A new obstruction may support a new actuation only through fresh Situation Assessment, never an automatic retry or hidden cooldown.

## Interfaces and coexistence

- **Observation:** current GIANTS Job Episodes, native current physical inventory (including cold-load vehicles), positional/assembly evidence, and current player-control evidence.
- **Situation Assessment:** current positive Causal Obstruction relationship; *does not* grant movement authority.
- **Admission / bounded responsibility:** establishes beneficiary demand, non-active controlled subject, current native authority, bounded inward objective and temporary actuation permission.
- **Control:** mechanically moves a non-job vehicle and reliably neutralises, restoring only states it actually leased. GIANTS remains in charge of active FIELDWORK routing.
- **Reassessment / settlement:** fresh obstruction/continuation evidence determines semantic success or inability to continue.
- **Concurrent action:** archival Relocation Serialization held relevant active beneficiaries at 0 km/h during non-job movement. This is **not** the pairwise 1 km/h Regulation in 0.5. Review its necessity and physical authority separately before introducing it.

**Restored positive Situation evidence:** The `0.4.11.0` `PlanViewFootprint`, `EntityLocalShapeEvidence` and `CurrentPhysicalConflictRepresentation` assess **current GIANTS physical shape world bounding spheres** from vehicle plus child assemblies. The archived `CausalObstructionAssessment` kernels distinguish `CURRENT_PHYSICAL_OCCUPANCY`, `CONTINUING_ACTIVE_FUTURE_SPACE` and `REALISED_MOTION_DEMAND`, all with positive-conflict authority only—never assumed negative path clearance. The current adapter uses actual active-worker coherent physical progression, `TrajectoryConflictAssessment` 0.10 m sample floor, 3 m establishment, coherence 0.94 and persistence 0.85, and `RealisedMotionDemandAssessment` **current aligned-distance-bounded reach**, capped at the archived 100 m. No invented proximity, future-turn classification, field-root membership, or GIANTS `isBlocked` gate defines Obstruction Relocation.

**Responsibility:** A current non-active, unclaimed assembly with exactly one positive Causal Obstruction relationship can be moved **once** under non-job actuation toward the beneficiary's **own GIANTS course field**; the archive's 60 m inward cap and optional 40 m offset centre (when the centroid bearing aligns with the incoming active approach) are both preserved. Native pair/solo BWR remains separately triggered by native blocked evidence. Normal completion of a worker never creates a relocation duty.

**Physical execution evidence:** `OBSTRUCTION_RELOCATION_STARTED` is admission only. Distinguish `PROPULSION_PENDING`, `PROPULSION_READY`, `FIRST_NATIVE_DRIVE_ACCEPTED`, `FIRST_POSITIVE_DISPLACEMENT`, measured progress, physical completion and later beneficiary continuation. GIANTS entity destruction during `deleteMap` makes native wheel/motor cleanup invalid; the archived terminal Control pattern clears mapping state with no GIANTS physics calls at that callback. No assumption that restoring code or a drive call alone proves physical movement.

**Known limits:** the archived prospective Future Space producer and complete multi-beneficiary Resolution lifecycle remain unported; only **current occupancy and bounded realised-motion demand** create live positive evidence. Historic #385 false positives require a negative GIANTS turning/parked-vehicle replay. Third-party path clearance, extended assemblies in actual GIANTS physical representation and useful work resumption remain field hypotheses.

## Validation discriminators

1. Completed worker in a genuine active path: current evidence nominates it and supports bounded non-job relocation; productive continuation subsequently observed.
2. Completed worker out of the way or a parked assembly during an ordinary turn: no relocation.
3. Cold-loaded completed / formerly unobserved assembly: physical relevance does not depend on pre-existing Job Episode memory.
4. Source AI restarts or current player control becomes true during the move: no stale non-job actuation continues.
5. Another non-active completed vehicle near the move: a beneficiary-clear target is not proven clear of third-party occupancy.
6. GIANTS TS015 pairwise PASS (0.5.1.0) and TS003 solo PASS (0.5.1.3) remain non-regressions.


