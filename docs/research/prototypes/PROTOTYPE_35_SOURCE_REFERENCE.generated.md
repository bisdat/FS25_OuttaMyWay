# Generated source-reference prototype

> **Generated prototype evidence — do not edit by hand.** This file is
> deterministic output from `tests/source_reference_prototype.py` and the
> temporary prototype manifest. It reports source facts and traceability; it
> does not own Architecture or Specification semantics.

## [`scripts/assessment/TrajectoryConflictAssessment.lua`](../../../scripts/assessment/TrajectoryConflictAssessment.lua)

- Prototype source role: `semantic-boundary`
- Export: `OuttaMyWay.TrajectoryConflictAssessment`
- Primary Specification: [`spec/SITUATION_ASSESSMENT.md`](../../../spec/SITUATION_ASSESSMENT.md)
- Related Specifications: none
- Declared semantic-boundary symbols: `updateTrajectories`

## [`scripts/authority/AuthorityRegistry.lua`](../../../scripts/authority/AuthorityRegistry.lua)

- Prototype source role: `shared-substrate`
- Export: `OuttaMyWay.AuthorityRegistry`
- Primary Specification: none — shared implementation substrate
- Related Specifications: [`spec/RESOLUTION_LIFECYCLE.md`](../../../spec/RESOLUTION_LIFECYCLE.md), [`spec/BOUNDED_AUTHORITY.md`](../../../spec/BOUNDED_AUTHORITY.md), [`spec/CONTROL.md`](../../../spec/CONTROL.md)
- Declared semantic-boundary symbols: `acquireProgress`, `acquireObstructionRelocation`, `releaseForCommitment`
- Discovered `ValueRecord`: `AuthorityToken`
  - required fields: `identity`, `assemblyId`, `commitmentId`, `authorityClass`, `epoch`, `generation`
  - optional fields: none

## [`scripts/contracts/ControlRequest.lua`](../../../scripts/contracts/ControlRequest.lua)

- Prototype source role: `contract-value`
- Export: `OuttaMyWay.ControlRequest`
- Primary Specification: [`spec/CONTROL.md`](../../../spec/CONTROL.md)
- Related Specifications: none
- Declared semantic-boundary symbols: none
- Discovered `ValueRecord`: `ControlRequest`
  - required fields: `identity`, `commitmentId`, `assemblyId`, `capability`, `target`, `authorityToken`, `operationalPictureEpoch`, `evidenceEpoch`, `effectiveActuationCompositionId`, `preconditions`, `invalidationConditions`
  - optional fields: `boundedAuthorityId`

## [`scripts/control/CooperativePassageControl.lua`](../../../scripts/control/CooperativePassageControl.lua)

- Prototype source role: `semantic-boundary`
- Export: `OuttaMyWay.CooperativePassageControl`
- Primary Specification: [`spec/CONTROL.md`](../../../spec/CONTROL.md)
- Related Specifications: [`spec/COOPERATIVE_PASSAGE.md`](../../../spec/COOPERATIVE_PASSAGE.md)
- Declared semantic-boundary symbols: `vacateParticipant`, `continueAfterParticipantVacatur`, `currentParticipantRequest`, `acceptSurvivorPermission`, `_executeCooperativePassageJointRequests`
