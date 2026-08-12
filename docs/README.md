# Current architecture / implementation lineage — v4.7.98 canonical candidate

Owner-declared canonical baseline is v4.7.95 (`1eaf0af3abafb5310a17a60437df0d161ad00943dee5f504cf79f0d3586050e1`; Git `f1a3ec95d2cfd554c7c3f2715090b48e4576706b`; 305 files).

v4.7.98 is a consolidation candidate governed by **D-0144 Progressive Situational Sufficiency** over the still-valid D-0143 Cooperative Passage and D-0141 follower-Regulation decisions. The candidate reapplies the live-successful v4.7.97 production implementation over exact canonical v4.7.95, then retires stale governing machinery that the successful TS015 path no longer needs.

**Current status: bounded Cooperative Passage production capability demonstrated; general Cooperative Passage incomplete.** Two near-collinear Condor/Patriot Productive/Productive encounters were automatically resolved through Situation Assessment → Candidate → Constraints → Decision → Commitment → Control in the v4.7.97 live run. D-0141 follower Regulation was also exercised and was cleanly superseded by Cooperative Passage.

D-0144 retains Productive/Transitional state, current motion/heading, current bootstrap-cached physical representation, cooperative relevance, obligations, and Turning Rank as optional spatial Situation Knowledge. It retires Rook/Successor-Rook governing prediction, chessboard colouring and continuous Productive History reasoning. King Reserve, continuous Refuge discovery and headland-U-turn-specific solving remain retired.

The live runtime no longer sources `DemonstratedProductiveCoverageProbe.lua`, `ProductiveCoverageResidualProbe.lua` or `RefugeQualificationShadowProbe.lua`. They remain historical evidence files only. No replacement geometry calculations are introduced.

**Known incompleteness:** Transitional/Productive opposed Cooperative Passage authority is unresolved; asymmetric passage is not generally supported; other vehicle/implement combinations are unvalidated; current movement/gate literals remain TS015 calibration; generic negative-clearance authority and broader regression coverage remain incomplete.

Start with `ARCHITECTURE.md`, `PROJECT_STATUS.md`, `DECISION_LOG.md`, `RESPONSIBILITY_MAP.md`, `ROADMAP.md` and `ENGINEERING_HANDOVER.md` for current authority and continuation.
