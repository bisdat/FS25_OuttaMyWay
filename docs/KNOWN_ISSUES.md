# v4.7.99 explicit incompleteness — D-0146 architecture/implementation gap

- D-0146 trajectory/opposed-corridor architecture is accepted but not implemented in this candidate.
- Existing Productive/Productive TS015 admission remains the live bounded controller; the new Step-1 trajectory model does not yet replace that gate.
- No generic Local Passage Space discovery exists.
- No generic Boundary Encroachment planner exists.
- No generic Manoeuvre Swept Occupancy / nominal-clearance proof exists.
- No dynamic multi-pin/gate Passage Guide constructor exists.
- No Passage Support Loss / Passage Reassessment implementation exists.
- Other assembly configurations and broad asymmetric passage remain unvalidated.
- Wider regression scenarios remain to be engineered.

These are deliberate scope boundaries, not accidental omissions.

---

# Known Issues / Explicit Incompleteness — v4.7.98 canonical candidate

These are authority boundaries, not invitations to widen the current candidate.

- **Cooperative Passage is bounded, not general.** Production evidence covers the TS015 Condor Endurance II / Patriot 4450 near-collinear Productive/Productive class only.
- **Productive/Transitional opposed case unresolved.** The final v4.7.97 encounter looked close to the demonstrated geometry but one participant remained `TURN_SEGMENT`; current authority correctly withheld Cooperative Passage.
- **Asymmetric passage remains unsupported in general.** Earlier P23 evidence showed insufficient lateral clearance for a materially asymmetric encounter.
- **Other assembly combinations unvalidated.** Foldability/compactness alone is not sufficient authority.
- **TS015 numeric geometry is calibration.** 50-70 m, 2 m, +/-6 m, 12 m, 8 m and 8 km/h values are not architecture.
- **General negative-clearance authority remains incomplete.** Current D-0143 fitness is purpose-specific and reuses bootstrap-cached `physicalSpaceEvidence` without new shape calculations.
- **Broader regression suite incomplete.** Historical scenario families still need deliberate re-engineering against D-0144.
- **Turning Rank awareness is architectural but not newly implemented here.** v4.7.98 introduces no turn predictor or Turning Rank geometry calculation.
- **Historical coverage/refuge diagnostic files remain repository debt/evidence.** They are unsourced from live runtime rather than deleted, preserving empirical provenance while removing continuous work.
