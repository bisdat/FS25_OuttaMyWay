# Prototype 25 — Active Follower Maturation Regulation (v4.7.52)

## Basis

Owner-declared canonical baseline remains v4.7.49. v4.7.50 and v4.7.51 are evidence probes, not canonical releases.

v4.7.51 live evidence positively supported the hypothesis that unrestricted follower progression can consume space required by a leading participant's demonstrated native boundary manoeuvre before that demand can be released. The passive shadow transitioned from `OBSERVE_SUPPORTED` to `REGULATE_SUPPORTED`, while deliberately applying no speed control; the resulting run reproduced the expected boundary deadlock.

## Test implementation

- uses only completed, boundary-relevant, heading-reversing demonstrated manoeuvres that were not influenced by any OuttaMyWay drive authority;
- requires both participants to have positive `NON_TURN_LINE_ACTIVE` Productive evidence and valid `SETTLED_CONTINUATION`;
- applies a temporary representation-fitness test gate for the adjacent co-directional case; the gate is implementation-test evidence only, not architectural policy;
- derives the follower speed cap from current geometry plus demonstrated turn-entry distance, swept demand and manoeuvre duration;
- preserves GIANTS route, steering and direction; only the speed ceiling is bounded;
- holds the last derived cap while the leader's GIANTS turn is actually revealed, then releases when that manoeuvre settles or the context invalidates;
- refuses to overwrite any other OMW drive-authority owner;
- leaves `reactionMargin=NOT_YET_MODELLED` explicit.

## Live hypothesis

If the follower obeys the derived cap, sufficient maturation Action Space should remain for the leader's native boundary manoeuvre, avoiding the boundary deadlock reproduced under v4.7.51 while allowing Reality to reveal the successor Situation for ordinary Traffic Policeman handling.
