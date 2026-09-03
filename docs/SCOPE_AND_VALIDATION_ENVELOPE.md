# Scope and Validation Envelope

## 1. Purpose

**This document defines the boundary of the claims OuttaMyWay undertakes to support and therefore the boundary of its validation obligation.** It indexes rather than replaces [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation](architecture/SPATIAL_NEGOTIATION_MODEL.md), [Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md), [Project Vision](PROJECT_VISION.md), or individual decisions.

## 2. Claim classes

| Class | Meaning | Validation consequence |
|---|---|---|
| **SUPPORTED** | Intentionally designed for. | Creates a validation obligation; an in-envelope defect may justify architecture or implementation change. |
| **BOUNDARY CHARACTERISATION** | Deliberately examined to understand failure, safety, assumptions or generalisation. | Success does not expand support; failure does not automatically create a repair obligation. |
| **EXCLUDED / NO CLAIM** | Outside the current design and validation obligation. | Incidental success establishes no support and no systematic completeness claim. |

## 3. Supported design envelope

The current supported claim is bounded to qualifying native GIANTS AI field work in a field-bounded Local Operation containing one to three simultaneously active supported GIANTS AI worker assemblies. Validation targets workers performing different agronomic roles. Player-controlled vehicles do not count toward the AI-worker cap and are not autonomous cooperative-worker participants.

GIANTS retains AI jobs, productive routing and navigation, native turning and productive work. OuttaMyWay owns only the bounded temporary coordination and intervention responsibilities defined by [Runtime Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) and [Spatial Negotiation](architecture/SPATIAL_NEGOTIATION_MODEL.md). Completed or other non-participant assemblies may remain physically relevant where current architecture permits. Player intervention remains a legitimate bounded outcome when no supported autonomous resolution exists.

This summary does not duplicate detailed admission, lifecycle, representation, commitment or control semantics from their architectural owners.

## 4. Environmental and platform boundary

The reviewed semantic evidence baseline is the unmodified FS25 base game. Paid DLC and modded vehicle definitions remain Deferred until deliberately incorporated into the reviewed corpus and validation obligation. Runtime evidence must identify its relevant FS25 build, OuttaMyWay revision, map/fixture and configuration as required by [Engineering Architecture](ENGINEERING_ARCHITECTURE.md#runtime-evidence-governance).

## 5. Governing assumptions

An assumption is a proposition about Reality or available evidence on which a claim relies and which Reality may disprove.

| Material assumption | Owner / boundary | Validation implication |
|---|---|---|
| Partial observability is permanent. | [Runtime Observation](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#11-reality-observation-and-situation-assessment) | Preserve provenance and uncertainty; do not infer unavailable facts. |
| A8 Productive Forward-Line Certainty supports a bounded immediate productive corridor and is falsifiable by contrary Reality. | [Spatial A8](architecture/SPATIAL_NEGOTIATION_MODEL.md#a8--productive-forward-line-certainty) | Revalidate against transitions, turns and contradictory current evidence. |
| GIANTS retains productive route ownership. | [Spatial scope](architecture/SPATIAL_NEGOTIATION_MODEL.md#1-scope) | Intervention tests must not claim replacement-route authority. |
| Physical representation authority is purpose-scoped. | [Physical Representation](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#purpose-scoped-geometry-authority) | Validate the claimed subject, state, purpose and horizon rather than treating geometry as universal. |
| Lifecycle observation may be incomplete; absence under incomplete observation is not termination. | [Lifecycle Evidence Asymmetry](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#lifecycle-evidence-asymmetry) | Test positive completion/succession and incomplete-evidence cases separately. |

**Assumption Traceability:** material assumptions should be identifiable, have an owner, and imply a validation obligation, boundary or revalidation trigger.

## 6. Hard constraints

A constraint is a required design boundary the solution must obey, not a prediction about Reality. Current constraints include:

- physical non-contact and hard safety;
- bounded authority and the least justified intervention;
- positive governing evidence for responsibility;
- no invented certainty from incomplete evidence;
- no dense world or productive-route reconstruction as a performance shortcut;
- intervention-created obligations persist until legitimately discharged or otherwise ended by their governing rules;
- at most one coupled pairwise Resolution Commitment per Operation, with exactly two active AI participants; and
- player intervention remains a legitimate outcome rather than a design failure by definition.

Full semantics belong to [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md), [Spatial Negotiation](architecture/SPATIAL_NEGOTIATION_MODEL.md), and [Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md).

## 7. Explicit exclusions and no-claim boundary

The current envelope makes no support claim for:

- more than three simultaneously active AI workers in one Operation;
- same-agronomy multi-worker or fleet coordination as a supported obligation;
- off-field traffic or navigation;
- replacement productive route/course planning;
- agronomic scheduling or general fleet management;
- player-controlled vehicles as autonomous cooperative workers;
- job classes GIANTS does not admit as qualifying native autonomous field work;
- multi-combine or combine-to-trailer offloading coordination; or
- paid DLC and modded vehicle coverage before deliberate corpus inclusion.

The combine/offloading and corpus boundaries are evidenced in [Vehicle Definition Corpus and Semantic Review](research/VEHICLE_DEFINITION_CORPUS.md#architectural-boundary).

## 8. Boundary-characterisation rule

Out-of-envelope failures do not justify scenario-specific architecture merely because they fail outside support. They matter when they expose a generic defect or the same defect is demonstrated inside the Supported Envelope. Boundary cases may still be valuable evidence about safety, assumptions and possible generalisation.

## 9. Validation obligation

A supported claim should be traceable through:

```text
scope / validation obligation
    -> architectural owner and material assumptions
    -> implementation owner
    -> offline validation where applicable
    -> in-game Reality evidence where applicable
```

Validation strength must match claim breadth. Fixture-specific evidence cannot establish a system-wide claim without broader evidence. The process is defined by [Testing Methodology](TESTING_METHODOLOGY.md).

## 10. Scope-change rule

**Observed incidental success does not expand the Supported Envelope.** Expansion requires deliberate engineering:

```text
evidence
-> discussion
-> explicit scope decision
-> architecture impact review
-> new validation obligation
```

An excluded-case failure is evidence but is not automatically a product defect.
