# Release Checklist

## Version Audit

- [ ] Release pipeline completed with PASS results.
- [ ] `modDesc.xml`, `scripts/config.lua` and `docs/PROJECT_STATUS.md` agree.
- [ ] Root and documentation changelogs contain the release entry.
- [ ] SHA-256 release manifest regenerated.
- [ ] ZIP contains `modDesc.xml` directly at its root.
- [ ] Independent Repository Identity Check performed against the packaged ZIP, not only the working tree.

## Empirical Evidence Baseline

- [ ] Every new test record declares FS25 version/build/revision when available.
- [ ] OuttaMyWay version, date, fixture and exact configuration are recorded.
- [ ] Relevant GIANTS update notes and runtime changes were reviewed through Patch Impact Watch.
- [ ] Affected evidence is classified as Current, Version-bound, Revalidation candidate or Invalidated.
- [ ] Targeted Patch Sentinel tests were run when a relevant change reduced confidence.

## Repository Governance

- [ ] Every first-class Markdown document is classified in `docs/README.md`.
- [ ] Canonical filename casing is respected.
- [ ] Current-state version fields match the release.
- [ ] Reference documents do not present stale package versions as their own authority.
- [ ] Compatibility signposts point to both current authority and archived history.
- [ ] Archive documents identify their historical authority and archive release.

## Engineering Continuity

- [ ] Navigation: builder followed the breadcrumb trail without using prior chat context.
- [ ] Prediction: reviewer correctly identified where each class of knowledge should reside.
- [ ] Overall Assessment: repository exposes omissions and supports correct continuation.
- [ ] Project purpose, architecture, current state and next objective are recoverable.
- [ ] Disproved hypotheses and significant decisions are discoverable.
- [ ] A competent engineer can validate and create the next canonical release.
- [ ] Independent reviewer breadcrumb findings will be recorded in the next release.

## Code

- [ ] No Lua errors in repeated test scenarios.
- [ ] Debug-only code disabled or gated.
- [ ] Observer and live modes both verified.
- [ ] Automatic admission requires exactly the active Condor/Patriot fixture pair and does not register `otmTS015Arm`.
- [ ] Admission produces four calculated candidates and one selected Yield/Progress role when geometry resolves.
- [ ] `PROTOTYPE18 COMMITMENT_POINT` states `fixedRole=false fixedSide=false fixed28=false fixed12=false`.
- [ ] Confirmed-stop recalculation evaluates both sides for the selected role and supplies a fresh world-space target.
- [ ] `HOLD_CONFIRMED` logs calculated lateral and rearward values and identifies the selected candidate.
- [ ] No normal-Control reference or fallback remains for fixed Condor Yield, physical-right, 28 m lateral or 12 m rearward movement.
- [ ] Calculation failure withholds admission or enters the existing safe held failure state without substituting former constants.
- [ ] Progress remains under unmodified GIANTS control while the selected Yield performs the sidestep.
- [ ] Hold, work-off, raise/fold, egress, passage confirmation, rejoin, deployment, work restoration and GIANTS handback complete in order.
- [ ] Runtime evidence shows physical passage without contact, `failure=nil` and `fenceViolation=false`.
- [ ] One Encounter Episode Latch prevents a second commitment in the same continuous fixture episode.
- [ ] Representation sources, coverage and confidence are logged for Progress lateral, Yield lateral and Yield forward extents.
- [ ] Conservative working-width fallback remains visibly distinct from compact or discovered representation.
- [ ] Prototype 17 diagnostic records remain distinct from the calculated Control target.
- [ ] Lua syntax and XML validation pass for the packaged release.

## Compatibility

- [ ] Base-game vehicles and implements.
- [ ] Self-propelled wide sprayer.
- [ ] Tractor with small mounted implement.
- [ ] Tractor with towed implement.
- [ ] At least three maps.
- [ ] Partly worked field.
- [ ] Fresh field.

## Multiplayer

- [ ] Host/admin multiplayer smoke test.
- [ ] No network-event errors.
- [ ] Second client test when available; otherwise declare limited verification.

## Localisation

- [ ] English.
- [ ] German.
- [ ] French.
- [ ] Spanish.
- [ ] Italian.

## ModHub package

- [ ] `modDesc.xml` version changed to `1.0.0.0`.
- [ ] Correct current `descVersion` for target game release.
- [ ] ZIP root contains `modDesc.xml` directly.
- [ ] No source archives, logs or private notes included.
- [ ] Icon and screenshots final.
- [ ] Description and controls accurate.
- [ ] Repository remains private until official release.
