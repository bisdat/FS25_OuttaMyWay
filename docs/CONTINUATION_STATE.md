# Continuation State

Continuation State is the compact, replace-in-place description of the
project's present engineering boundary. Git history preserves prior states; this
is not a changelog, release ledger, or canonical-release record.

## Current engineering concern

The explicit, read-only Resolution Commitment representation has now been
Reality-validated for both migrated Resolution exemplars. The immediate concern
returns to **Observe / Discuss**: use the established representation and new
Reality evidence to bound the later standalone Regulation reconciliation
without importing a corner failure or save-fixture assumption into accepted
architecture prematurely.

## Established

- The accepted [Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) and [Strangler Transition Map](IMPLEMENTATION_MAP.md#detailed-strangler-transition-map) remain authoritative for architecture and programme direction respectively.
- Cooperative Passage upstream transition remains accepted and Reality-validated for one direct `CREATE` episode.
- Completed-obstruction physical responsibility application now occurs upstream of Protected Yield and Control.
- [`CompletedObstructionResponsibilityTransition.lua`](../scripts/responsibility/CompletedObstructionResponsibilityTransition.lua) is the sole live physical owner of `TerminalEgressCommitmentLifecycle.applyDecision()`.
- **No Dual Completed-Obstruction Transition Authority** is structurally protected; `LiveControlDispatcher` no longer applies physical completed-obstruction responsibility.
- Terminal settlement deliberately remains downstream in the existing dispatcher/lifecycle path.
- Protected Yield deliberately remains downstream as Regulation actuation supporting an established Resolution responsibility.
- The retained generic Commitment, Obligation and Authority substrate remains authoritative implementation machinery for both migrated paths.
- [`ResolutionCommitment.lua`](../scripts/contracts/ResolutionCommitment.lua) is a sealed semantic representation whose identity is the retained generic Commitment identity.
- [`ResolutionCommitmentAdapter.lua`](../scripts/responsibility/ResolutionCommitmentAdapter.lua) is read-only: it introduces no registry, lifecycle, admission, settlement, authority-allocation or Control power.
- **No Dual Responsibility Record Authority** is preserved; generic Commitment and Obligation machinery remains the sole lifecycle substrate and record authority.
- Both migrated Responsibility Transition owners construct the view only after successful generic lifecycle application and carry it alongside the unchanged application result.
- Cooperative Passage explicitly supplies both distinct participants as beneficiaries and controlled subjects. Completed obstruction explicitly supplies authorising active demand assemblies as beneficiaries and the completed terminal assembly as controlled subject.
- Authority ownership is not role identity; progress/post-job ownership, authority tokens and Effective Actuation Composition are not role sources.
- GitHub `Structural contracts` and `Lua offline observation (non-blocking)` completed successfully on the `0.3.0.3` PR #34 implementation head.
- GIANTS Reality validated direct Cooperative Passage `CREATE`: `RESOLUTION_COMMITMENT_ESTABLISHED` exposed the retained generic Commitment identity and both coupled workers as beneficiaries and controlled subjects, then the existing Passage Control and participant-handoff settlement completed successfully.
- GIANTS Reality validated completed-obstruction `CREATE` → `COMPACT` → fresh Situation Assessment → `MAINTAIN` the same explicit Resolution identity → Protected Yield → `INFIELD` → terminal `SUCCEEDED` → authority release → Continuation Renewal.
- The `MAINTAIN` observation was `RESOLUTION_COMMITMENT_PERSISTED`, not a second architectural Responsibility Transition.
- Downstream Cooperative Passage and completed-obstruction behaviour remained consistent with the retained mechanics in the observed `0.3.0.3` episode.
- GitHub `Structural contracts` and `Lua offline observation (non-blocking)` completed successfully on the tested `0.3.0.2` PR head.
- GIANTS Reality validated one in-session completed-obstruction episode: `CREATE CM-00005` → `COMPACT` → fresh Situation Assessment → `MAINTAIN CM-00005` → Protected Yield → `INFIELD` → settlement `SUCCEEDED` → authority release → Continuation Renewal.
- The same `CM-00005` persisted across both upstream application events; the `MAINTAIN` event was not a duplicate responsibility acquisition.
- The existing stage-1, fixed-initial-centroid-bearing courtesy remained bounded to `60.00 m` with no continuous course correction.
- No application failure, physical rejection, Player Claim, Protected Yield rejection, altered courtesy geometry or observable regression was identified in the successful episode.
- **Resolution Persistence Across Control Phases** is observed: one Resolution responsibility persisted while permitted physical Control changed from compaction to protected movement.
- **Maintenance Is Not Transition** is observed: fresh Situation Assessment preserving an existing responsibility is architecturally persistence, although the compatibility seam currently delegates the generic `MAINTAIN` action through a transition-shaped module.
- Completed-obstruction `MAINTAIN` now re-exposes the same Resolution identity as persistence. Legacy `CREATE` / `MAINTAIN` / `REVISE` remains diagnostic provenance rather than architectural responsibility state.
- **Transition–Execution Readiness Coupling** now has two independent Resolution exemplars: Cooperative Passage and completed obstruction both retain readiness checks before semantic application.
- **Second Exemplar Before Generalisation** provides evidence from pairwise active-worker Resolution and active-beneficiary/completed-subject Resolution before a common representation is selected.
- A **Cold-Start Physical Relevance Gap** was observed: without current-runtime active-to-ended Job Episode provenance, the cold-loaded completed assembly did not establish Terminal Occupancy or reach the PR #32 seam.
- Cold-start non-active obstruction recognition remains supported intent and in scope, but is separate and unresolved under [issue #33](https://github.com/bisdat/FS25_OuttaMyWay/issues/33).
- A same-saved-game A/B rerun on accepted `0.3.0.2` (`2aa47fda4d6c0e75f24c9e5f2200c8c1c2eae921`) reproduced the later corner sequence: D-0146 Action-Space Regulation, quiescent actuation, mutual blockage and required player intervention. **PR #34 regression suspicion is cleared** for that failure.
- **Saved-State Test Fixture Divergence** is observed: reloading a save created during an uninterrupted GIANTS AI run does not guarantee behaviourally identical continuation, even when visible vehicle and field state appears equivalent. The repeatable saved fixture remains useful evidence, not proof of deterministic continuation.
- **Quiescent Regulation Deadlock** is a working Reality observation for later Regulation reconciliation: unresolved Regulation responsibility may outlive preventative actuation after positive native forward-rate evidence disappears, while a corner or pinch conflict persists and ultimately requires player intervention.
- **Opposed-Corridor Conflict ≠ Corner Conflict** is a narrower working observation from the same episode. Neither observation is promoted to accepted architecture or resolved in PR #34.

## Current boundary

There are two migrated Resolution exemplars and one explicit Resolution
Commitment view, but still no second or replacement lifecycle authority. The
retained generic Commitment substrate remains authoritative implementation
machinery for both paths.

The view represents why Resolution persists; it does not represent current
capability, Control phase, authority tokens or actuation composition. The two
required Resolution exemplars are now positively validated, but this is not
full supported-envelope regression coverage. `CREATE` / `MAINTAIN` / `REVISE`
remain legacy generic lifecycle vocabulary whose mapping to responsibility
acquisition, succession and persistence is not fully reconciled, especially for
Regulation-to-Passage `REVISE`.

The saved-state corner failure is pre-existing A/B evidence and not a Resolution
representation regression. It does not itself establish a Regulation design or
authorise changes to Situation Assessment, D-0146, corner modelling or Control.

## Next boundary

Return to **Observe / Discuss** before authorising another runtime tranche. The
next planned architectural reconciliation area is standalone Regulation. That
discussion should include the existing lifecycle and actuation boundary, the
new Quiescent Regulation Deadlock evidence, the distinction between
opposed-corridor and corner conflict, and when to characterise
Regulation-to-Passage `REVISE`; it must not assume a fix from this one incident.

Same-Commitment Responsibility Fusion and Bounded Authority remain deferred.
Issue #33 remains a separate cold-start non-active obstruction-recognition
investigation and must not absorb the corner evidence.

## Not currently active

- Generic Commitment removal.
- Standalone Regulation redesign.
- Same-Commitment Responsibility Fusion correction.
- Bounded Authority redesign.
- Candidate/Constraint/Decision simplification.
- Issue #33 implementation.
- Prototype22 migration or renaming.
- Diagnostic or probe pruning.
- Broad GUI/HUD work.
- Release preparation, packaging, publication or canonicalisation.
