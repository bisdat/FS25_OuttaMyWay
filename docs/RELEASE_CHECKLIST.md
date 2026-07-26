# Release Checklist

## Version Audit

- [ ] Release pipeline completed with PASS results.
- [ ] `modDesc.xml`, `scripts/config.lua` and `docs/PROJECT_STATUS.md` agree.
- [ ] Root and documentation changelogs contain the release entry.
- [ ] SHA-256 release manifest regenerated.
- [ ] ZIP contains `modDesc.xml` directly at its root.
- [ ] Independent Repository Identity Check performed against the packaged ZIP, not only the working tree.

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
