# Prototype 24 — Follower Maturation Compression Shadow

## Purpose

v4.7.51 tests whether the canonical Maturation Margin / Action-Space Compression requirement can be supported from live demonstrated GIANTS manoeuvre demand rather than an arbitrary following-distance controller.

This is a passive shadow probe. It does not change speed, choose Yield/Progress, create a Commitment, or grant Control authority.

## Preserved evidence from v4.7.50

The owner live run showed three ordinary Condor boundary returns with strongly coherent evidence: turn entry about 28.3–28.5 m from the captured forward Field World boundary, turn-segment duration about 12.2–12.5 s, and about 35.9 m lane-to-lane lateral return with near-180-degree heading reversal. The same run also captured a materially different diagonal catch-up/reposition manoeuvre: about 339.6 m from the forward boundary, about 34.2 s duration, large diagonal displacement, and almost unchanged final heading.

Discovery: GIANTS `TURN_SEGMENT` is not sufficient authority to identify a boundary return. Field World relationship plus realised manoeuvre development materially improves Representation Fitness.

## v4.7.51 hypothesis

A completed, boundary-relevant, heading-reversing native manoeuvre can provide session-local demonstrated demand for a later comparable approach. For a positively Productive trailing participant on the same Field World, the probe can then ask whether unrestricted straight progression will enter that demonstrated sweep before the leading participant can reach the demonstrated turn-entry relation and complete the demonstrated manoeuvre.

The shadow speed is derived from current geometry and demonstrated time. No fixed following-distance or regulation-speed literal is introduced.

## Demonstrated demand

`HeadlandManoeuvreSweepProbe` now retains completed live demonstrations only when:

- the GIANTS turn segment ends positively;
- realised heading reverses;
- a captured forward Field World boundary exists; and
- the forward boundary lies within the realised manoeuvre's longitudinal scale (the entry boundary distance is no greater than the realised longitudinal sweep span).

Multiple demonstrations are composed conservatively for the passive experiment: earliest demonstrated boundary-entry relation, longest demonstrated duration, and unioned realised sweep extrema. This composition is evidence handling for the probe, not production policy.

## Shadow evaluation

`FollowerMaturationCompressionProbe` requires:

- both participants positively Productive and moving forward;
- same positively resolved Field World;
- follower geometrically behind the leader under positively aligned continuation;
- a session-local demonstrated boundary-return demand for the leader; and
- a represented follower Physical Assembly.

It publishes one of:

- `OBSERVE_SUPPORTED`: current follower progression preserves the demonstrated manoeuvre demand, or is laterally decoupled from it;
- `REGULATE_SUPPORTED`: current unrestricted follower progression would reach the demonstrated sweep before the leader's demonstrated demand can be released;
- `UNRESOLVED` / `NOT_APPLICABLE`: evidence is insufficient or the relationship does not match this experiment.

When Regulation is shadow-supported it reports `shadowMaxFollowerSpeed`, derived from the current distance to the demonstrated sweep divided by the current leader approach time plus demonstrated manoeuvre duration.

## Deliberate limitation

`reactionMargin=NOT_YET_MODELLED` is explicit. v4.7.51 therefore tests the geometric/time-demand hypothesis only. A successful-looking shadow speed must not be promoted directly to active Regulation until the live evidence shows the intervention boundary is sensible and the required observation/reaction opportunity is understood.

## Live test

1. Load v4.7.51.
2. Let Condor complete at least one clean ordinary boundary return in the current Job Episode so the session-local demonstration is available.
3. Establish the adjacent leader/follower case with Condor leading and Patriot trailing under normal GIANTS AI.
4. Capture video and log through the approach and Condor's next boundary manoeuvre.
5. Compare `[FOLLOWER-COMPRESSION] ... status=OBSERVE_SUPPORTED/REGULATE_SUPPORTED` and `shadowMaxFollowerSpeed` against the physical loss of useful observation/reaction space visible in the video.

No active speed change is expected in this build.
