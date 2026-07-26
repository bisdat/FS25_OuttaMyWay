# Engineering Handover

## Authority state

v4.6.16 remains the last canonical repository. v4.6.17 was the exact tested noncanonical Prototype 13A candidate. v4.6.18 is a narrow correction candidate built from that exact tested package; it consolidates the evidence and corrects one misleading diagnostic label.

## Prototype 13A result

The declared-route matrix produced ten `RESOLVED / ROUTE_CONVERGENCE` results:

- Condor: four representative boom collision shapes;
- Tiger 8 MT: left and right wing `colPart` shapes;
- TopDown 600: left and right folding-arm collision descendants.

Every A/B route pair converged on one runtime Entity. All ten deliberately invalid C controls were rejected through the expected hierarchy-name or component-ownership evidence. No ambiguity, alias, geometry-unproven or unresolved result occurred. Runtime handles remained stable through observed configuration motion.

This supports the Route-Independent Resolution Contract for the tested fixture routes. It does not establish complete physical inventory, footprint construction or Coverage Closure.

## Disproved assumption and correction

TopDown held a stable raw `foldAnimTime=0.1250` while extended and raised for AI manoeuvring. The v4.6.17 diagnostic labelled all interior values `TRANSITION`; that generalisation is disproved.

v4.6.18 records only:

- raw animation value;
- numerical region: high endpoint, interior or low endpoint;
- observed animation motion: unobserved, settling, changing or stable;
- `semanticState=not-inferred`.

Do not reintroduce semantic fold state from endpoint distance alone.

## Accepted physical-state architecture

Deployment, vertical configuration, terrain contact, functional engagement and GIANTS operational phase are separate dimensions. For TS004 TopDown, AI uses an Extended Manoeuvring State and Work Engagement Cycle: extended-raised for positioning/repositioning, lowered for direct-soil-contact work. GIANTS `WORKING` may begin before the implement reaches its stable low pose.

Raise/lower semantics are family-specific. Direct-soil-contact implements such as ploughs, cultivators and rollers require realised terrain contact for intended ground operation. Towed sprayer boom height is a contrasting non-contact configuration with role-play significance but no soil-contact requirement or crop-damage effect in current gameplay.

Player-controlled assemblies remain inside the Field World only as possible obstacles to AI workers. Their operating behaviour is outside cooperative-worker modelling.

## Immediate validation objective

Run one short AI-controlled 8RX 410 + TopDown 600 cycle:

```text
unfold
→ extended-raised positioning
→ lower for pass
→ raise for reposition
→ lower for next pass
```

Confirm that the v4.6.18 log reports:

- the stable `0.1250` plateau as `animationRegion=INTERIOR animationMotion=STABLE`;
- raising/lowering movement as `animationMotion=CHANGING`;
- no semantic `foldState` field in Prototype 13A motion records.

No Condor or Tiger rerun is required unless the correction unexpectedly affects route resolution.

## Deferred work

- Prototype 13B automated route discovery;
- complete physical inventory and Coverage Closure;
- Physical Occupancy Envelope construction;
- Deployment and Manoeuvre Sweep construction;
- conflict assessment and Decision Engine response to Clearance Unresolved.

None is authorised by v4.6.18.
