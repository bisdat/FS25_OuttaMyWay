# Continuation State

Continuation State is the compact, replace-in-place description of the
project's present engineering boundary. Git history preserves prior states; this
is not a changelog, release ledger, or canonical-release record.

## Current engineering concern

The second standalone Regulation strangler seam is implemented for review.
Action-Space Regulation responsibility application/revalidation now occurs
upstream of physical Control for initial application, reactivation and
regulated-role migration. The immediate concern is independent GitHub and
GIANTS Reality validation of that ownership extraction before the two
Regulation exemplars are compared.

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
- [`FollowerBoundaryResponsibilityTransition.lua`](../scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua) is the sole production owner invoking `LiveTrafficCommitmentLifecycle.applyFollowerBoundaryDecision()` for D-0141 `APPLY`.
- `LiveControlDispatcher` retains existing APPLY routing/readiness checks, then returns a non-mutating handoff to Runtime; Runtime invokes the transition and calls the dedicated dispatcher continuation with already-applied responsibility.
- D-0141 authority-token validation, elastic speed request construction, owner-tag lease mechanics, physical Control, update counting, quiescence, reactivation, outcomes and rejection rollback remain downstream and are intended to behave unchanged.
- Revalidated retained follower purpose is distinguished from initial application in upstream diagnostics; repeated `APPLY` is not asserted to be a new architectural Responsibility Transition.
- D-0141 RETIRE/termination deliberately remains downstream, including retirement application, physical lease release, purpose-bound authority release and follower-obligation settlement.
- [`ActionSpaceRegulationResponsibilityTransition.lua`](../scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua) is the sole production owner invoking `LiveTrafficCommitmentLifecycle.applyD0146ActionSpaceDecision()` for initial/current application, quiescent reactivation and regulated-role migration.
- `LiveControlDispatcher` retains Action-Space bridge and Control readiness checks and returns a non-mutating handoff to Runtime before application/revalidation. Runtime invokes the purpose-specific transition and supplies its result to the dedicated continuation.
- Initial establishment and retained revalidation are distinguished in architecture-facing diagnostics. Reactivation and role migration preserve the retained responsibility identity; they are not claimed as new architectural transitions.
- **Responsibility Roles ≠ Regulation Actuation Roles**: the unresolved interaction and current action-space-preservation purpose form the durable responsibility core, while the currently regulated and protected participants belong to the mutable execution envelope.
- Progression-envelope establishment/update, current subject selection, elastic speed magnitude, supporting authority, quiescence/reactivation mechanics, role migration, leases, outcomes and physical Control remain downstream and are intended unchanged.
- Action-Space acquisition/revalidation is upstream while purpose settlement/termination remains deliberately downstream legacy ownership.
- Regulation is **Successor-Agnostic**: current Situation and purpose justify it; fresh Situation Assessment independently determines any successor. Action-Space Regulation preserves current usable action space and does not predict Cooperative Passage.
- No generic Regulation representation, registry or lifecycle has been introduced. D-0146 is now the implemented second standalone exemplar. GitHub Structural contracts passed and the Lua harness returned to its expected observational profile of `266 passed / 13 failed` after its composition correction.
- The saved-corner GIANTS Reality attempt was **inconclusive for the Action-Space transition seam**: no Action-Space Regulation responsibility was selected, no `ACTION_SPACE_REGULATION_TRANSITION_UPSTREAM` marker or D0155 progression-envelope Regulation occurred, and Cooperative Passage was admitted directly. The changed seam was bypassed upstream, so the attempt supplies no contrary evidence of the extraction and does not demonstrate a PR #36 regression.
- **Incidental Regulation ≠ Spatial Regulation**: earlier incidental capture of the saved-corner interaction by opposed-corridor machinery did not prove that the architecture's Category-1 spatial Regulation existed.
- The broader **Spatial Constraint Overlay Implementation Gap**, including Category-1 corner and Category-2 headland/boundary manifestations, is tracked separately in [issue #37](https://github.com/bisdat/FS25_OuttaMyWay/issues/37). Existing boundary, Future Space, opposed-corridor and follower-boundary mechanisms are not equivalent to the architecture's explicit overlay.
- GIANTS Reality validated initial follower-boundary responsibility establishment upstream for Patriot 4450 leading Condor Endurance II: application `AP-00001` established `CM-00001` / `OB-00001`, then `FOLLOWER_BOUNDARY_TRANSITION_UPSTREAM` reported `legacyAction=CREATE`, `responsibilityDisposition=ESTABLISHED` and `beforePhysicalDispatch=true` before downstream `D0141_APPLY` at `5.15 km/h`.
- The same run repeatedly revalidated `CM-00001` without responsibility churn. Approximately one `ESTABLISHED` and 44 `REVALIDATED` upstream markers accompanied one physical APPLY and 43 elastic updates; an observed update raised the current cap to `6.21 km/h` while retaining the same Commitment and obligation identity.
- Two observed quiescence events released temporary Regulation authority while the follower purpose remained. Later reactivation acquired `AU-00002` and applied `11.40 km/h` under the same `CM-00001`, with `responsibilityDisposition=REVALIDATED` and one `D0141_ACTUATION_REACTIVATED`.
- The episode supports **Maintenance Is Not Transition** for follower Regulation and demonstrates Current Responsibility persistence independently of temporary Bounded Authority. No contrary evidence of changed GIANTS productive routing or steering ownership was observed.
- Positive D-0141 retirement was **not observed / not required for this tranche**. It is not a failed validation; retirement and termination remain intentionally downstream and unchanged.
- D-number runtime vocabulary such as `D0141_APPLY` and `D0141_ACTUATION_QUIESCENT` is transitional implementation debt, not accepted Regulation terminology. The architecture-facing seam uses current responsibility names; retained downstream names remain only for behavioural isolation during strangler recomposition.
- A separate **Follower HUD Glyph Compatibility Leak** was observed: follower-regulation HUD text still uses the unsupported `•` texture-font glyph. It is unrelated to Regulation responsibility or PR #35 acceptance and remains deferred UI implementation debt.

## Current boundary

There are two migrated and Reality-validated Resolution exemplars plus two
implemented standalone Regulation acquisition/revalidation seams. The retained
generic Commitment, Obligation and Authority substrate remains authoritative
implementation machinery; no second Regulation lifecycle or explicit generic
Regulation representation exists.

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

The D-0141 intermediate asymmetry is explicit and validated for the observed
episode: acquisition/revalidation is upstream, while PRESERVE/quiescence
mechanics and RETIRE/termination remain on their downstream legacy ownership.
Elastic magnitude updates, quiescence and reactivation behaved normally under
one responsibility identity. Retirement was not naturally observed and remains
outside the required evidence for this tranche.

The Action-Space intermediate asymmetry is also explicit: application and
revalidation are upstream across initial, reactivation and role-migration
contexts, while the mutable execution envelope and purpose settlement remain
downstream. Role migration changes the current actuation role, not Regulation
responsibility identity. Physical behaviour is intended unchanged. Offline
validation completed, but the GIANTS Reality attempt was inconclusive because
upstream selection bypassed Action-Space Regulation entirely.

This does not complete standalone Regulation reconciliation or yet justify a
generic Regulation representation. D-number vocabulary is
not promoted to architecture, and neither Quiescent Regulation Deadlock nor the
Follower HUD glyph leak is addressed here.

## Next boundary

Validate the D-0146 Action-Space ownership seam before returning to **Observe /
Discuss** to compare the two standalone Regulation exemplars. The saved-corner
fixture is no longer a reliable seam-validation fixture until the Spatial
Constraint Overlay gap is addressed or another fixture reliably selects
Action-Space Regulation. The observed direct Cooperative Passage path neither
validates nor disproves the ownership extraction.

The later comparison must distinguish responsibility persistence from temporary
authority and actuation, and should determine stable semantic vocabulary before
retiring or renaming remaining D-number runtime terms. Historical D-identifiers
may remain where they truthfully record decision provenance. The Quiescent
Regulation Deadlock and opposed-corridor/corner distinction remain evidence for
later reconciliation, not current implementation work.

Same-Commitment Responsibility Fusion and Bounded Authority remain deferred.
Issue #33 remains a separate cold-start non-active obstruction-recognition
investigation and must not absorb the corner evidence. Quiescent Regulation
Deadlock and the Follower HUD Glyph Compatibility Leak also remain separate.

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
- Follower HUD glyph correction.
- Release preparation, packaging, publication or canonicalisation.
