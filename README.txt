FS25_OuttaMyWay v4.6.31

Cooperative collision-avoidance research for native GIANTS AI field workers.

Current canonical authority: v4.6.23, SHA-256 87d3548463c2f77b81e26098ecd9faa7dd88b498e628f24b13582738e4766db3
Current package authority: noncanonical consolidation candidate awaiting repository-owner review and Canonicalisation
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless a test record states otherwise

v4.6.31 consolidates the Prototype 14–17 Unilateral Sidestep and Shadow Clearance evidence. Runtime behaviour is the empirically tested v4.6.30 implementation with version metadata only changed for this consolidation.

Established fixture evidence:

- a native permission-gate hold can preserve the Yield worker's GIANTS job;
- an in-lane hold creates a static obstacle rather than resolving the conflict;
- Retreating Unilateral Sidestep can fold, displace, wait, rejoin, redeploy and hand back one worker;
- the 22 m commanded refuge produced about 21.44 m actual lateral displacement and failed complete assembly passage;
- the 28 m command produced about 27.38 m actual lateral displacement and passed, with Patriot unmodified and both jobs preserved;
- TS017-B completed the full 20-second post-handoff observation with failure=nil and passageConfirmed=true.

Shadow Clearance evidence:

- Patriot facing extent: 18.00 m from its live 36 m AI working marker;
- Condor current physical identities: 13/13 resolved;
- runtime bounds: 0/13 available through the tested APIs;
- compact Condor origin extent: 4.87 m;
- explicit unresolved physical allowance: 2.50 m;
- compact Condor facing extent: 7.37 m;
- physical contact threshold: 25.37 m;
- observed successful physical reserve: approximately +2.01 m at 27.38 m reference separation;
- the same model places the failed 21.44 m run approximately 3.93 m inside the contact threshold;
- the provisional 3.75 m policy-margin budget raises the policy target to 29.12 m, leaving a policy reserve of approximately -1.74 m despite successful physical passage.

This establishes Origin Coverage Is Not Bound Coverage and Physical Clearance Is Not Policy Clearance. The 2.50 m allowance, 3.75 m margin budget and 28 m movement remain fixture evidence rather than production constants.

Immediate continuation objective:

Separate physical contact threshold/reserve from policy required separation/reserve in calculation and logging while preserving authority=false and the validated actuator unchanged. Automatic conflict triggering, Yield/Progress selection, refuge-side choice and geometry-derived Control remain deferred.
