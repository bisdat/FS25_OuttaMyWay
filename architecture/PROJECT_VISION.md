# Project Vision

## Vision

Enable players to trust autonomous workers to complete their work without supervision.

## Mission

Preserve autonomous continuity through the least disruptive justified intervention.

## Blocked-evidence-first recovery direction

For the 0.5 rewrite, prefer positive native GIANTS worker-blocked evidence over continuous OMW collision prediction and anticipatory Regulation. The intended intervention is to free local space through a bounded temporary stop/relocation and then let GIANTS restart and replan productive fieldwork. **Native Replanning Ownership** means OMW does not reconstruct the productive route or insist on an OMW axis-return manoeuvre.

This is a design direction, not an assertion that GIANTS blocked messages identify which worker should yield or that native transport, recovery, collision or blocking-region APIs have been validated. The initial 0.5 implementation deliberately performs **no** AI intervention while those questions are investigated. Future temporary Blocking Regions are hypotheses, not active protection.

## Success Criterion

> A successful autonomous worker is one the player stops thinking about.

OuttaMyWay succeeds when the player can leave autonomous work elsewhere in the world and reasonably expect the activities to complete without babysitting, unexplained long pauses or repeated manual rescue.

## Architectural North Star

For every proposed feature, concept or architectural change, ask:

> **Will this increase the player's confidence to leave autonomous workers unsupervised?**

This Trust Test sits above local measures such as avoidance efficiency, vehicle speed or intervention count. A technically clever response that causes long, unexplained pauses can reduce player trust even when it prevents a collision.

## Autonomous Continuity Principle

> Preserve the uninterrupted progress of autonomous work while requiring no unnecessary attention from the player.

Autonomous continuity does not mean every worker must remain moving. A short, purposeful wait may preserve the continuity of the overall activity better than uninterrupted motion. The architectural concern is whether autonomous work continues toward completion without unnecessary supervision.

## Scope Discipline

The architectural subject remains the generic **worker**. Current implementation experiments must not narrow the whiteboard to harvesters, tractors or any other particular vehicle class.
