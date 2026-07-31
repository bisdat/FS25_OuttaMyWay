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
- [ ] TS018 requires exactly the active Condor/Patriot fixture pair, starts automatically after sustained eligible evidence, and does not register `otmTS015Arm`.
- [ ] Condor remains the fixed Yield Entity; Patriot remains the fixed, unmodified Giants Progress Entity.
- [ ] Runtime `HOLD_CONFIRMED` reports lateral=28.0m, rearward=12.0m and all validated TS015-B movement parameters remain unchanged.
- [ ] Prototype 17 logs `PRE_ESTIMATE`, `REFUGE_LIVE`, `CLOSEST_APPROACH`, `PASSAGE_CONFIRMED` and `SHADOW_SUMMARY` when evidence is available.
- [ ] Every shadow-clearance record states `authority=false` and the fixed 28 m Control target remains independent of the derived result.
- [ ] Progress and Yield Facing Clearance Extents identify their evidence source and confidence.
- [ ] Condor provider records expected/resolved/bounded/origin identity counts, coverage, bound APIs, pose source and scan truncation.
- [ ] Complete runtime bounds and origin-plus-allowance fallback are visibly distinct; the 2.50 m physical allowance is logged separately.
- [ ] Geometry, tracking, motion and policy margins remain explicit and sum only into `policyMarginBudget`; `physicalContactThreshold` excludes them.
- [ ] Stage logs, continuous samples, console status and final summary expose `physicalContactThreshold`, `physicalClearanceReserve`, `policyMarginBudget`, `policyRequiredSeparation` and `policyReserve` without ambiguous combined aliases.
- [ ] Live discovered envelopes are treated as high-confidence inputs only when complete assembly coverage is established; otherwise the calculation declares marker, fixture-provider or metadata fallback.
- [ ] Native permission-gate calls are observed and the Giants AI job remains active through hold and compacting.
- [ ] Condor work-off, raised state, fold motion and the provisional Egress-Ready Candidate are observed before egress.
- [ ] Egress remains on the selected side of the provisional centreline fence.
- [ ] Patriot remains under unmodified Giants control; Condor refuge, positive passage, rejoin, deployment, work restoration and Giants handback are observed.
- [ ] TS017-B evidence records 13/13 origins, 0/13 usable bounds, the 25.37 m physical threshold, +2.01 m physical reserve, 29.12 m policy target and -1.74 m policy reserve as distinct documented interpretations.
- [ ] Legacy Traffic Manager, recovery, reservation and Decision paths remain dormant under the exclusive Prototype 16 actuator boundary.
- [ ] No raw texture/audio performance warnings from this mod.

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
