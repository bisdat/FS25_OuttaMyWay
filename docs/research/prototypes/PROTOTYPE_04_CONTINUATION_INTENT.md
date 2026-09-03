# Prototype 04 — Continuation Intent and Safe Release

> **Status:** Limited TS001 evidence completed; local-intent lifecycle supported; Safe Release Point unresolved
>
> **Release:** Canonical v4.6.5
>
> **Mode:** Passive observation only; player stop, reposition and restart supplied the test stimulus

## Architectural hypothesis

Situation Assessment can distinguish **locally revealed intent** from continuing route intent, expire that knowledge when the Progress Entity begins another manoeuvre, and retrospectively determine whether an observed release remained safe through the next repositioning event.

Prototype 04 asked:

> Does a release that appears safe under the Progress Entity's current settled lane remain safe when its next observed manoeuvre is included?

The prototype never stopped, moved or released either worker. All intervention was performed by the player and includes Job Restart Perturbation.

## Validation result

The core local-intent hypothesis is strongly supported:

- settled straight work produced bounded local intent epochs;
- a new manoeuvre expired the prior epoch immediately;
- worker detachment also expired local intent;
- the same Entity later produced a new epoch after its manoeuvre and trajectory settled;
- no epoch was treated as complete GIANTS route knowledge.

The original candidate hold position was not safe through Condor's later continuation. Condor began a repositioning manoeuvre toward physically parked Patriot and became blocked until the player moved Patriot.

Automatic retrospective classification remained incomplete. Manually stopping Patriot abandoned its AI job and removed it from the active-worker observer. The prototype could no longer see the parked vehicle, and the player moved Patriot before physical collision. A later `SAFE_THROUGH_NEXT_MANOEUVRE` result occurred only after manual relocation and restart; it does not validate a Safe Release Point for the original hold position.

## Accepted evidence sequence

- `t=90.5s`: Patriot was manually stopped and detached from active worker observation;
- `t=93.0s`: Condor local intent epoch 2 was revealed while Patriot remained absent;
- `t=147.7s`: epoch 2 expired at Condor's next manoeuvre;
- `t=160.2s`: that manoeuvre ended;
- `t=166.0s`: Condor local intent epoch 3 was revealed;
- `t=176.0s`: epoch 3 expired at another repositioning manoeuvre;
- `t=200.5s`: Condor became blocked during the manoeuvre;
- the player observed Condor travelling toward parked Patriot and moved Patriot before collision;
- Condor resumed and completed the manoeuvre at `t=212.7s`;
- Patriot later reattached after being manually relocated;
- the later measured continuation remained clear, but it was not the original hold-site counterfactual;
- `t=627.7s`: Condor completed and detached from active-worker observation;
- `t=796.5s`: Patriot became blocked at the shared finishing position occupied by completed Condor.

## Interpretation

### Local Intent Horizon

Supported as bounded knowledge of an Entity's immediate settled path. The observed epochs remained stable during straight work and ended when a new manoeuvre began.

### Intent Expiry

Strongly supported. The probe expired local intent at manoeuvre start and worker detachment rather than preserving stale certainty.

### Encounter Chain

Supported as an explanatory possibility. Removing the original head-on encounter did not eliminate later interaction risk; a repositioning conflict and terminal occupancy conflict followed.

### Safe Release Point

Not established. The unsafe parked encounter was outside the active-worker observer, and the later safe continuation followed manual relocation. Neither can authorise an automatic release policy.

### Continuation Safety Horizon

The next manoeuvre remains a useful limited horizon, but it is meaningful only when all physically relevant participants remain observable. A horizon evaluated against active workers alone is incomplete.

All concepts remain Deferred pending broader evidence and a complete Field World observation boundary.

## Instrumentation findings

Prototype 04 correctly:

- correlated the Progress Entity and hold candidate across worker disappearance and reappearance;
- recorded local intent epochs and explicit expiry;
- distinguished local intent from continuation uncertainty;
- retained the encounter trial while Patriot was absent;
- removed the previously observed Prototype 03 startup contamination, stale `ACTIONABLE` evidence and repeated exhaustion event.

Prototype 04 could not:

- observe the physically parked Patriot after its AI job ended;
- attribute Condor's blocked state to that parked vehicle automatically;
- observe completed Condor after Operational Membership ended;
- classify Patriot's final terminal occupancy conflict as a pair interaction.

These are observation-scope findings, not failures of the local-intent lifecycle.

## Answered validation questions

1. **Yes:** Condor received bounded local intent epochs after settlement.
2. **Yes:** each epoch expired immediately at a new manoeuvre or detachment.
3. **Yes:** Patriot's disappearance and later reappearance were correlated without OuttaMyWay issuing control.
4. **Observed:** local intent existed while Patriot was absent; later restart followed manual relocation.
5. **Visually yes, automatically no:** Condor's later manoeuvre approached parked Patriot, but Patriot was outside the active-worker observer.
6. **Not automatically:** the original release/hold-site safety classification was invalidated by observer scope and manual repositioning.
7. **Observed after relocation:** a later continuation remained clear, but it does not validate the original site.
8. **Yes:** Prototype 03 startup contamination, stale intent and repeated exhaustion evidence were corrected in the tested run.

## Disproved interpretation

> A Progress Entity's current settled lane is sufficient evidence for a safe release.

The tested continuation disproved this. Current settled trajectory is local knowledge only; later manoeuvres may return toward the held position.

## Passive guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototypes 01 through 04 execute before the observer-only return;
- no speed, steering, implement, route, AI-job, Decision, Commitment, hold or release action is permitted.

## Continuation boundary

Before any active Information-Gaining Delay, Situation Assessment must observe physically relevant members of the bounded field world independently of active Operational Membership. The next prototype should begin with parked Patriot and completed Condor as natural positive cases.
