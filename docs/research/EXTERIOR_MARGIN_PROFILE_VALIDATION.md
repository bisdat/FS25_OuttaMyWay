# Exterior Margin Profile — Falsification Plan

## Status and question

**Architecture discussion / validation plan only.** Neither current TEST `0.5.5.2` nor accepted PATCH `0.5.5.0` computes an Exterior Margin Profile, validates swept-assembly clearance or moves a completed vehicle to a selected parking location.

**Primary question:** Can we observe enough *continuous* outside-field geometry to distinguish a traversable edge-aligned settlement strip from discrete points that merely look free?

The proposed concept and responsibility boundary are in [Exterior Margin Profile Architecture](../../architecture/EXTERIOR_MARGIN_PROFILE.md). Current source observation is [Farm Spatial Context](retired/architecture__FARM_SPATIAL_CONTEXT_OBSERVATION.txt), not a settlement assessor.

## What the existing two runs really established

| Claim | Field 77 `0.5.5.1` | Riverbend `0.5.5.2` | Epistemic status |
| --- | --- | --- | --- |
| Registered polygon and ordered native edge identity | Registered Field 77, **12** edges; owner selects south **edge 9** | Displayed Farmland 2 resolves to native Field **29**, **14** edges; owner selects east **edge 1** | Confirmed for these loaded saves |
| Geometry available along preferred segment | Edge 9 **230.97 m** | Edge 1 **141.99 m** | Segment length only; not guaranteed available travel |
| Native sampled navigation blocking | Edge 9: **39/39** unblocked at each +2/+6/+12 m | Edge 1: **24/24** at +2 and +6 m; **23/24** at +12 m | Confirmed *points*; not continuous physical clearance |
| Registered neighbouring field constraint | +12 m samples may already enter another field; smallest boundary gap **6.88 m** (segment-wide) | Nearest registered other field gap **36.74 m**, but a road separates the nominal inter-field gap | A global minimum does not express local usable width |
| Farmland and access | +6/+12 m exterior points fall in parcel 49, owner 1 | +2/+6/+12 m exterior points on edge 1 remain parcel 2, owner 1 | Land ownership/access does not assert road/parking safety |
| Road and hazards | Top road detected; right hedges incompletely expressed by costmap | Road east of chosen green strip, western vegetation weakly reflected by costmap | Native road-spline inventory incomplete/truncated, collision geometry missing |
| Physical approach and terminal fit | Shallow strip, owner judges parallel occupancy plausible, oblique entry not necessarily | Deeper margin, owner judges direct oblique entry plausible | Human hypotheses; neither assembly-specific swept envelope validated |

Sources: [Field 77 TEST evidence](FIELD77_SPATIAL_PROBE.md) and [Riverbend TEST evidence](RIVERBEND_FIELD2_SPATIAL_PROBE.md). **The owner did not report an executed post-completion parking manoeuvre in either run.**

## Hypotheses to challenge separately

### H1 — Exterior side and identity

For any registered polygon and nominated consecutive-vertex edge, observations can identify which side is truly outside even near a concavity and can preserve *native field ID* separately from displayed farmland identity.

**Counterexample:** outward samples re-enter the polygon, a single farmland contains multiple native fields, or a screenshot-selected edge does not match the registered polygon. Result: unresolved profile rather than a fabricated exterior strip.

**Already learned:** Riverbend 2 ≠ registered Field 2 (it is 29), and Field 77 edge 9 is the south despite an initial human reference to edge 10.

### H2 — Connected lateral and longitudinal margin

From observed exterior geometry, we can express how much space is continuously available at each along-edge position `s`, and which stretches connect without gaps, fields, road surfaces, hedges, ditches or unobserved voids.

**Counterexample:** point samples at +2 and +12 m are unblocked, but a fence, ditch, road shoulder or field incursion lies in between; or contiguous clear stations have an obstruction between them. Result: do not infer a continuous strip from sparse points.

**Field 77 discriminator:** Along edge 9 the gap to neighbouring productive field varies; an all-clear navigation sample report still coexists with registered other-field occupancy at some +12 m positions.

### H3 — Road-bounded exterior depth

An exterior margin that reaches a road must distinguish the *near-road usable verge* from the road and from land beyond it. A road spline, when present, may only approximate a centreline; it must not be treated as a measured road shoulder.

**Counterexample:** Riverbend's apparent ~37 m inter-field gap is treated as available despite its intervening road; or a missing sampled spline is interpreted as proof the physical road is absent.

**Discovery requirement:** Identify a reliable observational source for actual road/rail occupancy or else report that limiting boundary as `unknown`. Both previous surveys reported incomplete road enumeration. Do not increase a spline budget and silently rename it a road-surface clearance witness.

### H4 — Assembly-specific approach and run-out

Given a sufficiently evidenced margin and a **specific real TRANSIT-configured articulated assembly**, assessment can distinguish:
- whether its complete stopped envelope might fit when parallel;
- whether its *approach swept envelope* can fit with alignment inside the completed field and a shallow crossing;
- whether it has enough forward run-out to straighten and stop fully outside.

**Counterexample:** a tractor-root path clears the verge but the attached implement cuts into another field, crosses the road, jackknifes or remains in the source field after the tractor stops. Another counterexample is sufficient stationary width but no traversable entry angle.

**Owner-accepted option:** interior of the completed field may be used for alignment, subject to other active workers; a deep exterior margin may support greater obliquity. No universal turn radius, 3 m absolute width rule or run-out distance is yet grounded.

### H5 — Operational validity and terminal occupancy

A positive corridor assessment remains current and admissible only if it does not conflict with *other active GIANTS workers' current space demand*, player intervention or separate OuttaMyWay commitment. Final success must be whole-assembly off-field occupancy, not command acceptance or tractor-root arrival.

**Counterexample:** an initially static free margin becomes occupied, a worker turns into the infield alignment region, the player retakes control, or TRANSIT never completes folding. Assessment must become superseded/await new evidence, not carry stale approval into movement.

## Suggested validation order

1. **Observation design first:** survey GIANTS-native representations for field boundaries, road/rail physical occupancy, static collision shapes/ditches and terrain. The [FS25 Physical Margin Constraint Source Review](PHYSICAL_MARGIN_CONSTRAINT_SOURCE_REVIEW.md) identifies `overlapBox`, `raycastAll`, `sweepBoxVector`, terrain height/normal, ROAD collision-group checks and a bounded proposed 1.24 Reality experiment. Its v1.20 engine source is **not runtime validation**. Record which surfaces actually yield *reliable positive physical witnesses* and which only yield hints or unknown road limits. Do not add movement or mutate the navigation map.
2. **Controlled geometry examples:** compare continuous versus disconnected outward depth across both preferred edges, plus a concave source field, adjacent field incursion, road-without-spline and hedge-in-between-samples. A failed case is a useful discovery, not a request to insert special cases.
3. **Assembly evidence design:** obtain dimensions and articulation in requested/verified TRANSIT, then assess hypothetical infield-alignment and exterior run-out envelopes without vehicle commands. A supported static corridor is still not guaranteed executable by GIANTS steering.
4. **Later, separately admitted movement validation:** only after Architecture, Specification and authority/interruption conditions are agreed, test actual forward crossing and full terminal occupancy in-game, including failure/handback. Preserve the original Field 77 and Riverbend baseline runs for regression.

**Exit condition for the current discussion:** agree the evidence dimensions and the separation between (a) world-space profile, (b) assembly/operation-specific corridor assessment and (c) authorised physical Control. Do **not** call a profile 'validated' until an independent continuous physical-boundary witness exists.

## Open evidence questions (not implementation requests)

- Which GIANTS-native world or collision sources can positively delimit a road surface and verge, and distinguish a railway? Does either map represent them consistently?
- Can static collision geometry or terrain discontinuities be queried read-only for an **entire swept envelope**, rather than a root/point cost sample?
- At what locality or freshness boundary can we safely reuse a field-edge profile, and what must always be reassessed for a specific Job Episode?
- How will a target assembly's **actual** TRANSIT envelope and articulation be observed without treating fold commands as verified configuration?
- How will dynamic worker demand and movement commitment be revalidated before any future physical action?

This document records falsifiable needs, not a commitment to a numeric sampling method or a new build.
