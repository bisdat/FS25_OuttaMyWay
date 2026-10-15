# Exterior Margin Profile

## Purpose

An Exterior Margin Profile describes the observable geometry and constraints of space adjacent to a selected registered field edge. It makes potential **edge-aligned settlement space** assessable without confusing a nominal polygon gap with a physically driveable or permissible parking corridor.

The profile supplies evidence to a downstream **Settlement Corridor Assessment**. It does not rank parking destinations, claim space, select a manoeuvre, or authorise Control.

## Spatial reference — Edge Station and Outward Depth

A selected ordered field edge defines an **Edge Station** along its length and an **Outward Depth** normal to the source field. This provides a consistent coordinate basis for describing variable exterior margin width, endpoints, corner proximity and longitudinal usable length.

A strip may be wide enough to hold an assembly aligned parallel to an edge yet too narrow for oblique approach. Conversely, an apparently deep strip may include a road or another field. Neither a single width measurement nor a sequence of clear point samples establishes a connected corridor.

## Evidence and provenance requirements

A useful profile must preserve both the measurement and its scope:

- source field identity, ordered polygon, edge identity, station and outward direction;
- separation from other registered productive fields and their boundary uncertainty;
- surface ownership/access evidence independently of registered field membership;
- physical obstacles, roadside boundaries, terrain, ditch and hedge evidence with source and coverage;
- current occupancy and any unresolved traversability between observed locations;
- profile sampling limits, truncation, freshness and unknown intervals.

**A negative obstacle witness is not necessarily positive clearance.** Native navigation costs, road centreline splines, static collisions and terrain samples reveal different aspects of Reality; none alone proves an entire assembly-sized physical margin clear.

## Distinct downstream responsibility — Settlement Corridor Assessment

Settlement Corridor Assessment examines a specific **Physical Assembly** and current situation against three independently required envelopes:

1. **Approach Envelope** — can the assembly actually reach and align with the chosen edge? Feasible infield alignment may reduce the need for exterior manoeuvring room.
2. **Run-Out Envelope** — can the assembly cross and continue forward long enough to straighten without violating other field/physical/demand constraints?
3. **Terminal Envelope** — can the entire actual assembly attain and verify a stopped, exterior, suitably aligned occupation without obstructing productive work, traffic or another claim?

A positive nominal polygon result does not establish any of these complete envelopes. Articulation, current attachments, dynamic occupancy, available steering space and speed/stationarity must be independently considered. The assessment may legitimately remain **WAITING_FOR_EVIDENCE** or refuse a corridor.

**Terminal fit != Approach feasibility != Run-Out feasibility.**

## Specification Jurisdiction — Settlement Corridor Assessment

**Jurisdiction ID:** `SETTLEMENT_CORRIDOR_ASSESSMENT`  
**Primary Specification:** [Settlement Corridor Assessment](../spec/SETTLEMENT_CORRIDOR_ASSESSMENT.md)

A polygon intersection test can be a useful reusable necessary-condition witness, but it cannot be promoted to physical clearance or Control authority. Responsibility for actual vehicle movement, exclusive claim and terminal proof lies with [Completion-Triggered Terminal Egress](COMPLETION_TRIGGERED_TERMINAL_EGRESS.md).

## Evidence boundary and further research

Field 77's shallow southern inter-field space and Riverbend Springs' deeper roadside strip expose different limitations of geometric sampling. The observed measurements, failed hypotheses and validation fixtures belong in [Exterior Margin Research](../docs/research/EXTERIOR_MARGIN_PROFILE_VALIDATION.md) and [Nominal Assembly Evidence](../docs/research/ASSEMBLY_SETTLEMENT_NOMINAL_TEST.md), not in this architecture.

A parking location remains unavailable for Control admission wherever any necessary evidence is unresolved.
