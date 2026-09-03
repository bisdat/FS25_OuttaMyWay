# Code and implementation documentation

This branch of the engineering documentation describes **how the current
implementation is constructed**. It will cover runtime composition, entry
points, state and responsibility ownership, architecture-to-code mapping, and
important implementation constraints.

## Current implementation breadcrumb

The only established top-level entry path is:

```text
modDesc.xml
    ↓
scripts/main.lua
```

[`modDesc.xml`](../../modDesc.xml) explicitly loads
[`scripts/main.lua`](../../scripts/main.lua).

## Physical Representation path

The current implementation has two observable evidence paths into Situation Assessment:

```text
LiveObservationSource
    ├─ metadata/current-space representation
    │     → physicalRepresentationEvidence
    │     → RepresentationFitness
    │     → SituationAssessment
    │
    └─ AssemblyRepresentationCache
          → shadowPlanViewEvidence
          → SituationAssessment.physicalSpaceEvidence
          → PassageCapabilityAssessment
          → LocalPassagePlanner
```

[`PlanViewFootprint`](../../scripts/representation/PlanViewFootprint.lua) provides current represented-plan-view overlap support. [`PairSpecificPassageClearance`](../../scripts/representation/PairSpecificPassageClearance.lua) supplies Passage-specific directional and facing calculations. [`AssemblyRepresentationCache`](../../scripts/representation/AssemblyRepresentationCache.lua) constructs current represented primitives and also carries cached Transit geometry and configuration-profile evidence. `LiveObservationSource` publishes both evidence channels; `SituationAssessment` preserves the latter as `physicalSpaceEvidence`, which `PassageCapabilityAssessment` and `LocalPassagePlanner` consume for Passage capability and planning.

Historical terms such as `shadow`, `TEST`, D-number identifiers and the mixture of generic and purpose-specific authority fields are implementation-vocabulary and contract catch-up candidates, not evidence that current Passage behaviour is wrong. Architecture does not require the two evidence channels above to remain separate. Later bounded implementation reconstruction may reconcile naming, self-description and claim/permission structure while preserving validated behaviour. This documentation increment authorises no runtime change and does not attempt a full repository code map.
