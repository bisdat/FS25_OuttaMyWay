FS25_OuttaMyWay v4.6.43 — Cooperative passage evidence consolidation candidate

Status
------
Release Candidate proposed for owner review and Canonicalisation. It is not canonical until the repository owner explicitly declares this exact package canonical. Owner-declared canonical authority remains v4.6.36 until that decision.

Purpose
-------
This candidate consolidates the v4.6.39–v4.6.42 temporary implementation and runtime evidence without intentional behavioural change from v4.6.42.

Validated boundary
------------------
- Calculated Yield role, refuge side, lateral distance and rearward distance have operated successfully with Condor and Patriot as Yield.
- Both physical lateral refuge directions have been exercised; no fixed role, side, 28 m or 12 m authority remains.
- TS016 manoeuvre-aware admission resolved the first turn-exit head-on, and encounter rearming allowed a later independent straight head-on between the same pair to be admitted and resolved.
- TS015 right-side refuge, rearward-target orientation, direct rejoin, unfolding and GIANTS handback completed successfully.

Open collision classes
----------------------
1. TS015 Headland Turn Overlap / Dual-Manoeuvre Admission Gap: after successful passage and handback, both workers entered interacting headland manoeuvres. Situation Assessment predicted convergence, but no current admission path accepts a conflict once both workers are manoeuvring.
2. TS016 Completion-Transition Control Gap: Condor completed its job and remained a relevant static obstacle, but the two-active-worker pair ended and Patriot received no obstacle-navigation Control.

Faster egress and ingress increase separation as a physical fact, but the earlier 15 km/h left-side TS015 evidence also ended with an unresolved later headland conflict. The 5 km/h orientation phase may alter timing; it is not established as the cause of the final collision.

Next objective
--------------
Discuss and define the TS015 dual-manoeuvre encounter before implementation. Keep the TS016 completed-obstacle case as a separate single-worker obstacle-navigation problem.
