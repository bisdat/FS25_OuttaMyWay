# Project Status

Version: 4.6.43 cooperative passage evidence consolidation candidate
Canonical implementation authority: owner-declared v4.6.36, SHA-256 `5ec12f0e16d817f5193264a7003a228ce7ef75b05963f24e05e4968404b7b781`, Git commit `9f9ff7bdbe59945ea8b6ebf789f374262cf0d8e8`
Candidate baseline: exact temporary v4.6.42, SHA-256 `205bb2f435c54bca5e280bffa64d3f1174b9ce4f77d31da23b1f35897d31f64e`
Authority state: Release Candidate proposed for owner review; not canonical until explicit owner declaration
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless the test record states otherwise

## Consolidated validated boundary

Temporary v4.6.39 transferred role, side and movement authority to calculated refuge selection. Runtime subsequently exercised Condor and Patriot as Yield and both physical lateral refuge directions without reintroducing fixed Condor, fixed side, 28 m or 12 m authority.

Temporary v4.6.40 admitted repeatable TS016 while one worker was still manoeuvring and selected the straight-working Patriot as Yield. Temporary v4.6.41 rearmed after a successful encounter, allowing a later independent straight head-on between the same pair to become encounter 2 and complete successfully.

Temporary v4.6.42 corrected Forward-Only Rejoin Singularity. In the TS015 repeat, Condor completed `REJOIN_ORIENTING` in 7.10 s after 6.42 m travel, completed direct rejoin, unfolded, returned to GIANTS, ended the encounter successfully and rearmed. The right-side calculated refuge sequence is therefore supported through handback.

## Two open continuation conflict classes

### TS015 — Headland Turn Overlap / Dual-Manoeuvre Admission Gap

After the successful v4.6.42 passage and handback, Condor began a headland manoeuvre and Patriot began another shortly afterward. Situation Assessment predicted a serious convergence while both were manoeuvring, but no current admission mode accepts that state combination. Both became blocked after contact.

This is not a new failure introduced by Rejoin Orientation. Earlier left-side TS015 evidence using 15 km/h egress/ingress had already recorded a later unresolved headland convergence. Faster movement increases separation, but speed alone has not resolved the encounter class.

### TS016 — Completion-Transition Control Gap

After two active-worker head-ons were resolved, Condor completed its job and transitioned into a static relevant obstacle. Field World retained the assembly and recognised its relationship to Patriot, but the active-worker pair ended and no obstacle-navigation Control consumed the relationship. Patriot became blocked and did not recover.

This belongs to the separate active-worker-versus-completed-obstacle problem. The current two-worker passage controller cannot simply wait for a stationary Progress assembly to pass.

## Immediate next objective

Observe and discuss the TS015 dual-manoeuvre encounter before implementation. Determine what commitment, if any, should exist while both workers are manoeuvring and what evidence identifies the latest safe commitment point. Keep TS016 completed-obstacle navigation architecturally separate.

## Candidate scope

v4.6.43 changes no runtime behaviour from v4.6.42. It consolidates evidence, names the remaining boundaries and provides a coherent candidate breakpoint for owner review and possible Canonicalisation.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently acts as a prototype/release summary. Before publication readiness, restore it to a stable description of the mod and keep increment-specific reporting in the changelog and engineering documents.
