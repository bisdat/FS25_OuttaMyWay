# Engineering Handover

## Baseline

Prototype 06 Candidate v4.6.7 derives from the owner-supplied clean v4.6.6 canonical package.

Baseline SHA-256:

`9a1c73138ad824ce48cf364f20e2f008f31223d4f3509a7d0f48ac7df0ce1823`

## Current hypothesis

Situation Assessment should preserve one Field World identity while Operational Membership changes, latch the transition once, and reclassify every existing relation whose participant role changed.

## Implementation result

The Field World probe now:

- preserves previous Boolean false membership correctly;
- increments a classification revision only on attach or real class/membership change;
- includes classification revisions in relationship signatures;
- emits explicit membership-transition and relationship-reclassification evidence;
- explicitly retires directional relations whose source is no longer operational.

No control path is enabled.

## Validation order

1. Run TS002 as a regression fixture. Confirm no repeated unchanged Condor membership events and preserve the existing relevance/collision result.
2. Create or use a repeatable live completion fixture (provisionally TS003) where both workers begin active and one completes while the other remains active.
3. Upload the complete game log and record the visual completion event and subsequent vehicle positions.

## Expected searchable evidence

```text
PROTOTYPE06 MEMBERSHIP_TRANSITION
PROTOTYPE06 RELATIONSHIP_RECLASSIFIED
PROTOTYPE06 RELATIONSHIP_REMOVED
```

## Repository entry point

1. `docs/PROJECT_STATUS.md`
2. `docs/prototypes/PROTOTYPE_06_MEMBERSHIP_RECLASSIFICATION.md`
3. `docs/prototypes/PROTOTYPE_05_FIELD_WORLD_OBSERVATION.md`
4. `docs/ARCHITECTURE.md`
5. `docs/ROADMAP.md`

Continue using:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat
