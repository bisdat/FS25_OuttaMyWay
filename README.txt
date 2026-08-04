FS25_OuttaMyWay v4.6.71 — Architecture Consolidation and Experimental Reset Candidate

Status
------
Release Candidate proposed for owner review and Canonicalisation. It is not canonical until the repository owner explicitly declares this exact package canonical.

Canonical implementation baseline
---------------------------------
Built from exact owner-declared canonical v4.6.56:
SHA-256 9e2ed98a89ba7ffb3babb7669abf26a8db52a5f04b97829900c1b0d4a44b8066
Git commit 99ae108ca589a2930b562c19ae560d3ecf580426

Active runtime boundary
-----------------------
The active runtime implementation is v4.6.56. No executable controller, architecture module, smoke test or threshold from temporary v4.6.57–v4.6.70 is promoted into this candidate. Runtime files differ from v4.6.56 only where coherent version identity requires it.

Purpose
-------
This candidate closes the current experimental cycle without pretending that its final implementation is stable. It consolidates durable architecture, named discoveries, disproven hypotheses, candidate fingerprints and runtime conclusions from v4.6.57–v4.6.70 into repository knowledge.

The reset preserves the distinction:

Architecture describes what the cooperative system must achieve.
Implementation hypotheses describe one attempted way to achieve it.
Runtime evidence validates or disproves those hypotheses.

Retained architectural knowledge
--------------------------------
- bounded Future Space and Safe Release;
- Persistent Situation distinct from Encounter and Commitment;
- Intent Expiry and Commitment Preconditions;
- Capability effectiveness distinct from operational sufficiency;
- Native Handover Envelope and Control-to-Awareness Reversion;
- Identity Reference–Value Snapshot Separation;
- Work Recovery and post-handover authority guarding;
- Option Preservation and repeated Encounter handling;
- provisional refuge revalidation;
- endpoint viability distinct from transition executability;
- atomic refuge-transition authority;
- manoeuvre-leg commitment and Reassessment–Redirection Separation;
- settled-pose transition frames;
- bounded manoeuvre-leg orientation;
- coherent Control leases, counterfactual Safe Release and the global never-hold-all invariant.

Experimental reset
------------------
The repository records but does not activate:
- v4.6.57–v4.6.70 architecture/control modules;
- candidate-only Lua/Python lifecycle tests;
- refuge, speed, timing, orientation and hysteresis thresholds;
- the v4.6.70 counterfactual Hold-release implementation;
- cruise-control ceiling as a native continuation-speed estimate;
- non-closing motion as a universal Hold-release precondition.

Next unresolved subject
-----------------------
The next session begins with Observe → Discuss → Hypothesise. The immediate question is how to estimate bounded native GIANTS continuation after temporary Control. Current evidence supports capturing recent unmodified GIANTS operating behaviour; it does not yet support a specific implementation.

Evidence index
--------------
See docs/EXPERIMENTAL_LINEAGE_V4.6.57-V4.6.70.md and ADR-0018.

Permanent scope exclusions remain:
- multiple combines;
- combine unloading;
- cross-field coordination;
- general route planning.

Deferred publication item
-------------------------
Mod Description Drift remains open. The engineering description in this candidate is not the final stable public ModHub description.
