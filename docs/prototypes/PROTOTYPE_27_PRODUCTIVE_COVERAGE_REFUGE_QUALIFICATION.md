# Prototype 27 — Demonstrated Productive Coverage and Refuge Qualification Shadow

**Build:** v4.7.63 TEST BUILD  
**Canonical authority:** owner-declared v4.7.49 remains canonical.  
**Authority:** passive evidence only; no Refuge selection, Decision or Control authority.

## Question

Can OuttaMyWay's existing observations explain why an infield waiting position already productively vacated by the Progress worker is a better Refuge candidate than the current boundary-adjacent fixture positions, without querying GIANTS for an agronomic application map and without introducing a headland no-go rule?

## Demonstrated Productive Coverage

The probe maintains a coarse Job-Episode-scoped grid for each worker. A grid cell is painted only from a swept quadrilateral between two consecutive live working-marker segments while Productive Continuation is positively supported.

Marker evidence is discovered from live `getAIMarkers()` or work-area start/width nodes. This is agronomic Working-Footprint evidence, not Physical Occupancy geometry. The sweep is clipped to the same live source field. A transition, unresolved Productive state, Job Episode change, field change or excessive sampling gap breaks the sweep so the probe cannot paint across an unobserved reposition.

An unpainted cell is **UNKNOWN**. It is not evidence that work remains. A painted cell means only that OuttaMyWay positively witnessed productive work there during this Job Episode. It does not establish that the worker will never return, that the region is Safe Release, or that a Refuge is admissible.

The chessboard metaphor is explanatory only; canonical architecture continues to use Working Footprint, Future Space, Demand, Temporary Slack, Refuge Region and Action Space.

## Refuge Resulting-Situation shadow

At each existing TS015 fixture Refuge selection event, Prototype 27 evaluates without influencing selection:

1. the two existing lateral fixture candidates;
2. infield shadow candidates displaced from Yield toward the captured Field World centroid by temporary probe offsets;
3. same-field fit using the existing fixture sampling radius;
4. intersection with the Progress participant's currently positive field-bounded Future Space;
5. distance to the nearest Field World boundary compared with the Progress participant's demonstrated boundary-manoeuvre entry distance;
6. overlap with the Progress participant's Demonstrated Productive Coverage.

The result is an evidence vector, not a ranking. `NO_POSITIVE_INTERSECTION` retains no negative-clearance authority. Being beyond the demonstrated boundary-manoeuvre entry band is not proof that the candidate is safe. Productive coverage is evidence that productive demand has receded, not evidence that Transitional Demand has disappeared.

## Live evidence target

For the Condor/Patriot sequence, compare `[REFUGE-QUALIFICATION-SHADOW] CANDIDATE` lines for the two fixture candidates and the infield shadow candidates at both Refuge events.

Useful evidence would be:

- boundary-adjacent candidates lie within or near Patriot's demonstrated boundary-manoeuvre entry band;
- one or more infield candidates lie in Patriot's painted productive history;
- infield candidates do not positively intersect Patriot's current Future Space at the relevant Decision epoch;
- the evidence vector explains the operator's observed preference for already-vacated infield space without any change to live selection.

If the representations cannot distinguish the candidates, record the missing Knowledge rather than inventing a headland exclusion or centroid preference.
