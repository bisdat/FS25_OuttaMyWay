# Causal Obstruction and Obstruction Relocation — 0.5 Architecture

**Status:** accepted restoration target from archived 0.4.11.0; physical mechanism port begins under [#463](https://github.com/bisdat/FS25_OuttaMyWay/issues/463). The current 0.5.1.3 product does **not** yet perform non-active blocker relocation. This document defines responsibility, not evidence of an implemented live Resolution.

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

Mechanically proven non-job actuation is imported in the first restoration increment, but does **not** yet constitute a complete live Obstruction Relocation implementation. The current blocked-first pair and solo behaviours remain intact until a later **separately admitted** relocation responsibility is implemented and reality-tested.

## Validation discriminators

1. Completed worker in a genuine active path: current evidence nominates it and supports bounded non-job relocation; productive continuation subsequently observed.
2. Completed worker out of the way or a parked assembly during an ordinary turn: no relocation.
3. Cold-loaded completed / formerly unobserved assembly: physical relevance does not depend on pre-existing Job Episode memory.
4. Source AI restarts or current player control becomes true during the move: no stale non-job actuation continues.
5. Another non-active completed vehicle near the move: a beneficiary-clear target is not proven clear of third-party occupancy.
6. GIANTS TS015 pairwise PASS (0.5.1.0) and TS003 solo PASS (0.5.1.3) remain non-regressions.

**Primary Specification:** [Obstruction Relocation](../spec/OBSTRUCTION_RELOCATION.md).
