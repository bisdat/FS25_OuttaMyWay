# Project Status

Version: 4.6.5

Authority state: Canonical — Prototype 04 evidence reviewed; local-intent lifecycle supported; Safe Release Point unresolved

Canonical source: exact accepted v4.6.5 candidate

Accepted candidate SHA-256: 3ec478110839e25f2d38c07ae0e5eb521da5ca54021d2378eeda9edae62c94ee

Current focus: recover Full-Envelope Field Containment and observe the Field World independently of active Operational Membership before any active Information-Gaining Delay

## Engineering Increment Result

Prototype 04 asked:

> Can Situation Assessment distinguish locally revealed intent from continuing route intent, expire stale intent when a new manoeuvre begins, and determine retrospectively whether an observed release remained safe through the Progress Entity's next repositioning event?

**Result:** The local-intent and Intent Expiry portions are strongly supported. The original candidate wait position was shown unsafe through a later Condor repositioning, but automatic Safe Release classification remained incomplete because manually stopping Patriot removed it from active AI-worker observation and the player moved it before collision.

The canonical release remains passive. It does not hold or release either worker, select a Commitment or alter GIANTS AI behaviour.

## Accepted Evidence

The limited TS001 run produced the following sequence:

- `t=90.5s`: Patriot was manually stopped; its GIANTS AI job ended and it left the active-worker observer while remaining physically parked in the field;
- `t=93.0s`: Condor received a new bounded local intent epoch;
- `t=147.7s`: that epoch expired immediately when Condor began another repositioning manoeuvre;
- `t=166.0s`: Condor's next settled work segment produced another local intent epoch;
- `t=176.0s`: the epoch expired at the next manoeuvre;
- `t=200.5s`: Condor became blocked during that manoeuvre while the player observed it travelling directly toward parked Patriot;
- the player repositioned Patriot before collision and Condor resumed, completing the manoeuvre at `t=212.7s`;
- Patriot later restarted after being moved, so the subsequent clear continuation was not a test of the original hold position;
- `t=627.7s`: Condor completed work and left the active-worker observer;
- `t=796.5s`: Patriot became blocked at the normal shared finishing position already occupied by completed Condor.

The player's observations provide the causal interpretation that the first blocked state was caused by parked Patriot and the final blocked state by completed Condor occupying the shared GIANTS parking position.

## Interpretation

Prototype 04 supports:

- **Local Intent Horizon** as bounded knowledge of the immediate settled path;
- **Intent Expiry** at a new manoeuvre or loss of active observation;
- the conclusion that current-lane intent is not route-continuation knowledge;
- the possibility of an **Encounter Chain**, where avoiding one conflict exposes a later conflict.

Prototype 04 does not establish a Safe Release Point. The observed safe continuation after Patriot restarted followed manual relocation, while the physically unsafe parked encounter could not be evaluated automatically after Patriot left Operational Membership.

## Passive Guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototypes 01 through 04 run before the observer-only return;
- no speed, steering, implement, route, AI-job, Decision, Commitment, hold or release action is permitted.

## Next Evidence Boundary

The next declared Engineering Increment should:

1. recover and promote the previously agreed **Full-Envelope Field Containment** invariant: the maximum collision geometry of the complete vehicle–implement combination, including projected sweep, remains wholly inside the field polygon at all times;
2. distinguish Field World Membership from Operational Membership and dynamic Situation Relevance;
3. retain physically relevant vehicles after their GIANTS AI job ends;
4. detect parked-Patriot and completed-Condor conflicts as natural TS001 evidence cases;
5. later extend the same observation boundary to moving player-controlled vehicles and static objects inside the field polygon.

These are continuation requirements, not behaviour implemented by v4.6.5.

## Known Constraints

- Manual stop/restart contains Job Restart Perturbation.
- Manual repositioning prevented automatic validation of the original physical collision.
- Prototype 04 observes active GIANTS workers, not the complete physical Field World.
- Safe/unsafe continuation classification is invalid when a relevant physical participant disappears from the observer.
- The complete GIANTS route remains unknown and must not be inferred from a simple alternating-lane description.
- Older control code remains in the repository but is bypassed by the observer-only boundary.
