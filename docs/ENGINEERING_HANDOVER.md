# Engineering Handover

> **Canonical baseline:** v4.7.17  
> **Candidate:** v4.7.18 Positive Filtered-Footprint Encounter Admission  
> **Control authority:** disabled

## Closed gates

- Field World and Operation identity: canonical v4.7.14.
- Exact TS015 non-admission diagnosis: canonical v4.7.15.
- Job Episode geometry cache, configuration filtering and approximately 36 m Condor representation: canonical v4.7.17.

## v4.7.18 boundary

`LiveObservationSource` now composes two positive evidence sources:

```text
unchanged scalar positive ─┐
                           ├─ positive interaction evidence ─→ Situation Assessment ─→ Encounter
filtered footprint positive┘
```

The composition is one-way. `SHADOW_CLEARANCE_UNRESOLVED` produces no negative claim and cannot suppress a scalar positive. Footprint provenance records the component pair, tCPA, dCPA, required separation, configuration filtering and positive-only authority.

Decision remains `CONTINUE_OBSERVATION`; the passive validator still never applies the Decision–Commitment boundary; Control remains disabled.

## Live objective

Run TS015 only until the first filtered-footprint future positive and Encounter are clearly recorded. Confirm evidence emitted=received, Encounter lifecycle CREATED/RETAINED, no handoff contradiction, no live Commitment mutation and `control=false`. Stop before collision if convenient.
