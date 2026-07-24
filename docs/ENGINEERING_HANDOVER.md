# Engineering Handover

## Canonical baseline

The exact reviewed v4.6.5 candidate was tested, accepted and explicitly declared canonical by the repository owner.

Accepted candidate SHA-256:

`3ec478110839e25f2d38c07ae0e5eb521da5ca54021d2378eeda9edae62c94ee`

Every new Engineering Transformation must begin from the complete canonical v4.6.5 package supplied as its immutable baseline.

## Completed increment

Prototype 04 tested whether Situation Assessment could separate local settled intent from route continuation, expire stale intent at a new manoeuvre, and assess release through a limited continuation horizon.

The local-intent lifecycle is strongly supported. A settled path produced bounded epochs, and each epoch expired when Condor began a later manoeuvre or left active observation.

## Accepted evidence

Patriot was manually stopped at the prior candidate wait position, abandoning its GIANTS AI job. Condor first continued away, later settled into another work segment, then began a new repositioning manoeuvre toward the physically parked Patriot. Condor became blocked until the player moved Patriot.

The stop removed Patriot from the active-worker observer. Prototype 04 therefore preserved the Progress Entity and encounter correlation but could not see the parked physical participant or classify the unsafe encounter automatically.

After manual relocation, Patriot was restarted and both workers continued without a working-path conflict. Condor eventually completed and parked. Patriot later became blocked when GIANTS attempted to use the same finishing position already occupied by completed Condor.

## Architectural result

- Local Intent Horizon is useful only for the immediate settled path.
- Intent Expiry at a new manoeuvre is supported.
- Current-lane intent is not complete route intent.
- A later clear continuation after manual relocation does not validate the original Safe Release Point.
- Active-worker observation is insufficient for Situation Assessment because physically relevant vehicles can leave Operational Membership while remaining inside the field.

The final point is evidence for the next hypothesis; v4.6.5 does not yet observe the complete Field World.

## Immediate continuation

The next substantive increment should remain passive and should:

1. recover **Full-Envelope Field Containment** into the authoritative architecture: the maximum collision geometry of vehicle plus every attached or towed implement, including projected swept geometry, remains wholly inside the field polygon at all times;
2. define the field polygon as the bounded Field World for the Operation;
3. separate Field World Membership, Operational Membership and Situation Relevance;
4. observe active, inactive, completed and player-controlled vehicles within that boundary;
5. validate parked Patriot and completed Condor as non-operational but physically relevant conflict participants;
6. defer static internal objects and broader scenarios until the vehicle cases establish the observation boundary.

Do not implement an active Information-Gaining Delay until a physically complete Situation Assessment can observe both the Progress Entity and the held Entity throughout the hold/release lifecycle.

## Repository entry point

1. `docs/README.md`
2. `docs/PROJECT_STATUS.md`
3. `docs/prototypes/PROTOTYPE_04_CONTINUATION_INTENT.md`
4. `docs/CONCEPT_REGISTER.md`
5. `docs/DECISION_LOG.md`
6. `docs/ENGINEERING_JOURNAL.md`
7. `docs/ROADMAP.md`

Continue using:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat
