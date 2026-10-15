# Farm Spatial Context Observation — Field-Edge Investigation

## Current status: retired investigation

The completed synchronous Field77/Riverbend spatial survey and adjuncts were removed from production scripts and archived as historical code/fixtures in [Retired Research](../docs/research/retired/README.md). This document records past observations, **not an active startup survey or a product admission criterion**.

## Purpose

For [Completion-Triggered Terminal Egress #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476), discover what GIANTS knows outside the completed worker's source field before proposing any Off-Field Settlement responsibility.

**Concept:** an Edge Segment is the directed line between **two consecutive vertices of the observed source field polygon**. It is a geometric observation unit, NOT a route, candidate parking space or two selected arbitrary points.

The 11 October 2026 annotated Field 77 screenshot is the first human Ground Truth comparison fixture: road corridor across the upper boundary, hedge protrusions at the right, and potentially interesting left/right-lower/bottom edges. The screenshot is not georeferenced and does not prove distances, ownership, clearance or whether a particular field boundary is road-side.

## Specification Jurisdiction — Farm Spatial Context Observation

**Jurisdiction ID:** `FARM_SPATIAL_CONTEXT_OBSERVATION`  
**Historical Specification:** [Farm Spatial Context Observation](../docs/research/retired/spec__FARM_SPATIAL_CONTEXT_OBSERVATION.md)

**Responsibility:** capture, without mutation, each diagnostic target field edge's consecutive endpoints and exterior-side measurements from GIANTS field polygons, farmland ownership/access, road spline samples and vehicle-navigation costmap. Keep original coordinate frames, observation resolution, unavailable evidence and truncation explicit.

Source-backed relationships discovered from supplied FS25 1.24 game scripts and [#420](https://github.com/bisdat/FS25_OuttaMyWay/issues/420):

- `Field.densityMapPolygon` provides ordered boundary vertices; registered fields are not interchangeable with farmland parcels.
- `FarmlandManager` offers positional farmland ID/ownership and access to a **specified farm**, not generic permission to park.
- `AISystem.roadSplines` and native `getSplinePosition(spline,t)` expose sampled road/AI-navigation centreline geometry; neither the visible road surface nor every farm track is guaranteed to be represented.
- `AISystem.navigationMap` and `getVehicleNavigationMapCostAtWorldPos` expose **pointwise native navigation cost/blocking**, not full-swept-assembly clearance or roadside safety.

**Observation is not Settlement Suitability Assessment.** A free cell, access permission, small road-spline distance or polygon-exterior position does not jointly or individually license parking. An apparently attractive Edge Segment is not itself a settlement region.

## Experiment boundary

One selected field per map load, one-shot after map load, server, DIAGNOSTIC publication, and **explicit engineering `spatialSurvey=true` admission** required. A DIAGNOSTIC logging request or experimental Completion Settlement admission alone does **not** commission this research sweep. The survey is normally inactive; its 6-second start is relative to map loading only when explicitly requested, and its synchronous work remains a separately measured engineering-cost risk, not a production bootstrap obligation. The default fixture remains registered Field 77. An optional engineering diagnostics-sidecar `spatialFarmlandId` selects exactly one registered field contained within that farmland; the query rejects ambiguity. A farmland ID is never presumed to be a registered field ID. Log per-segment consecutive vertices and sampled exterior strips at 2, 6 and 12 metres. Detect possible protrusion intervals without claiming which object caused them. Preserve unknowns and budget truncation. The probe must perform **no** field job, native navigation registration, collision mutation, player/configuration mutation, movement or completion-TRANSIT actuation.

Later architecture may discover: a **Settlement Region** (space for an entire Physical Assembly), Route Feasibility and Settlement Control. Their existence and admission are separate decisions and are not established by this experiment.

## Evidence status

The sources and synthetic offline regression fixtures justify the read-only probe. The Field 77 `0.5.5.1` in-game log confirmed 12 field edges and native road geometry along the top but sparse hedge blocking; evidence is recorded in `docs/research/FIELD77_SPATIAL_PROBE.md`. A second `0.5.5.2` experiment on Riverbend Springs Farmland 2 (TS004) **confirmed** the same passive survey on a different field: displayed Farmland 2 resolves to registered Field 29 with 14 polygon edges and 282 external point observations. Owner in-game map preferences now nominate Field 77 **edge 9 (south)** and Riverbend Field 29 **edge 1 (east)**. The two runs reveal different limiting geometry: near-neighbour productive fields versus a road-bounded margin. See [Exterior Margin Profile](EXTERIOR_MARGIN_PROFILE.md) for the resulting architectural evidence question and [Falsification Plan](../docs/research/EXTERIOR_MARGIN_PROFILE_VALIDATION.md) for uncertainty. A negative test is valuable evidence of a representation gap. Source evidence does not turn a navigation-point reading into safety authority.
