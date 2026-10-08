# Spatial Pair Inference — Minimal Proximity Candidate Study

**Owner decision (8 October 2026):** The locality policy is now **nearest other eligible worker within 30 m horizontal X/Z assembly-root radius** of the blocked worker, without further geometric precision. See [accepted Architecture](../../architecture/BLOCKED_PROGRESS_QUALIFICATION.md) and [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). The threshold is an owner-selected pragmatic rule, **not an experimentally calibrated collision distance**. The historical investigation below predates this decision: claims that *no numeric radius has been chosen* describe prior uncertainty, **not the current policy**.

**Research status:** original source/bench study retained, not a working observer or permission to control GIANTS. TEST **0.5.0.6** remains control-free.

## Question

Given one worker A for which GIANTS reports `isBlocked` and the owner-agreed **≥1.000 s accumulated-confirmed-blocked-time gate** has been met, what is the **smallest spatial observation** that can identify *another worker B worth assessing* as a possible blocker?

The task is **candidate discovery**, **not** independent collision detection or proof that B caused A to be blocked. GIANTS has already decided A's blocked state. No additional native `isBlocked` assertion is required from B. In particular, do not reinstate the retired 0.5.0.5 event tap, build an A8 classifier, predict future routes, measure agronomic progress, or reconstruct physical mesh contact.

## Known source and Reality boundaries

### GIANTS and OMW source-derived observations

- In the published GIANTS [Vehicle scripting v1.20](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=91&class=888&version=script), `Vehicle:getRootVehicle()` resolves the assembly root. The same source uses `getWorldTranslation(self.rootNode)` for current root coordinates.
- The published [AICollisionTriggerHandler](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=3&class=146&version=script) is an *engine-owned collision mechanism*, not an invitation for OMW to generate another handler or claim collider identity from proximity. It inspects collision callbacks and can recognise root vehicles, but `isBlocked` itself does **not** provide the blocking worker identity in the completed 0.5.0.5 observations.
- [GIANTS Engine Knowledge](../engine/GIANTS_RUNTIME_KNOWLEDGE.md) documents `mission.vehicleSystem.vehicles` as the current vehicle population, root/child vehicle identity, and live positions. **Population membership does not prove Operational membership or eligibility.** It also explicitly records **Origin Coverage ≠ Physical Bound Coverage**: resolving a root or component position does not establish complete assembly occupancy.
- The completed [Native Blocked State Probe](NATIVE_BLOCKED_STATE_PROBE.md) and [Native Event Tap study](NATIVE_BLOCKED_EVENT_TAP.md) observed genuine native blocked/unblocked oscillation on FS25 1.24.0.0, **not** the causal worker or a validated separation distance.

### Hypothesis: Nearest Local Candidate

A simple, deliberately **provisional** pair-inference policy could be:

1. **Admit only after the existing native blockage gate** for worker A. When confirmed blocked time is **<1 s**, do nothing further; the expected brief opposed A8 transient needs no classifier.
2. **Enumerate current in-scope local worker/assembly identities** near A from the GIANTS vehicle population and accepted Job Episode/Operation context where available. Deduplicate vehicle attachments by root, exclude A's own assembly, and retain worker identity/lifecycle provenance. A completed worker still physically occupying local space is a possible *obstacle candidate* subject to future policy; do not equate that with permission to command it. Similarly a player-controlled assembly cannot be assigned OMW Control merely because it is nearby.
3. **Read one current world-space anchor per candidate root**, including A. Compare **horizontal X/Z separation only**; terrain height does not define plan-view local proximity. This is **candidate ranking**, not a hull/implement clearance computation.
4. **Consider only workers within a bounded local neighbourhood** of A; otherwise there is **no plausible worker-pair candidate**. Rank those candidates by current separation and tentatively name the nearest. Without an empirically supported neighbourhood limit, this is a **shape of a rule**, not an implementable final distance test.
5. **Publish a possible partner, not a causal verdict.** If multiple neighbours are comparably close, or the only neighbour is plausibly incidental, Situation Assessment retains uncertainty. If no credible candidate exists, do not invent a pair: allow GIANTS' native attempts or a separately established *single-worker obstruction* path.
6. **Recheck current eligibility/positions at downstream Commitment**. Being near at the one-second gate is not evidence that the same neighbour remains relevant after movement, player intervention, job change, or other lifecycle discontinuity.

The policy does **not** require both workers to report `isBlocked`, coincident timestamps, matching headings, predicted course intersection, a collision-trigger query, assembly geometry enumeration, or GIANTS route-progress measurement.

## Historical distance uncertainty — resolved by owner policy

We can rank roots by distance, but cannot legitimately assert which root-to-root distance is 'near enough' across all supported assemblies:

- A large sprayer's implement may extend well away from the tractor/root while working. A root-only fixed **small** distance can miss a real nearby obstruction; a universal **large** distance may nominate irrelevant neighbours. This is a *counterexample hypothesis*, not evidence for a particular metre value.
- The tested GIANTS root position is an **anchor**, not a physical contact envelope. Shop working width, configured AI marker width, collision-trigger width, and geometry bounds have different proven semantics in [GIANTS Engine Knowledge](../engine/GIANTS_RUNTIME_KNOWLEDGE.md); substituting one as an arbitrary collision radius would reintroduce the complexity the owner rejected.
- The nearest worker can still be too far away to cause the blockage. Therefore **'pick the nearest worker in the field' is not a sufficient rule**.
- Root/worker positions may be stale, identities superseded, or several neighbours similarly placed. Ranking does not resolve these evidential uncertainties.

**Earlier research recommendation (superseded):** originally leave the radius unselected. **Accepted owner decision:** select the closest eligible worker within **30 m** of the blocked worker's assembly root; do not add implement-width adjustments or collision geometry. Any later mismatch is Reality evidence to revisit, not a reason to prebuild a complex detector.

## Adversarial bench cases (positions schematic, NOT calibrated metres)

| Case | Expected candidate result | What it disproves |
| --- | --- | --- |
| A blocked; B clearly local; C much farther away | B is first candidate; not yet proof of causation | Treating simultaneous `isBlocked` as necessary for both |
| A blocked by hedge; B passes nearby | B may be a **false candidate**; Situation must not equate ranking with causation | 'Nearest worker caused the GIANTS blocked state' |
| A blocked; only another worker across the field | No pair once locality is enforced | Unbounded nearest-neighbour selection |
| A blocked between B and C at similar distances | Ambiguous candidate set rather than inventing a single uniquely responsible worker | Forced unique blocker attribution |
| A blocked by a wide deployed implement while B's root is farther away | Do not dismiss as impossible on root distance alone; test locality guard | Arbitrary small fixed root distance for all assemblies |
| A blocked near a completed stationary worker | Candidate may still be a physical obstacle; downstream eligibility/control is separate | Assuming only active Job Episodes can be obstacles |
| A blocked; player takes control of B | Reassess candidate/authority; no automatic OMW hold/relocation of B | Proximity implies control permission |
| A's blockage remains but B moves away before Commitment | Refresh the candidate; old ranking confers no ongoing authority | Sticky pair from obsolete positions |
| Opposed A8 passage remains <1 s native blocked | No proximity inference or A8-specific work at all | Needing another special-case classifier |

## Provenance and falsifiable next measurement

A narrow future **source/Reality validation**, if independently agreed, should check whether simple current X/Z root distance actually ranks the true obstruction partner in representative TS015 Condor/Patriot and other differently-sized worker cases. Record the blocked worker's Job Episode, confirmed native blocked duration, each candidate's root identity/position, relative separation, and **owner-identified physical context** (true pair / hedge or other non-worker obstacle / incidental neighbour). Include completed and player-controlled nearby assemblies where applicable. Do not retrospectively claim those observations exist in the earlier 0.5.0.5 event logs.

Any later test should challenge the **accepted 30 m root-radius rule** when Reality warrants it, **not** attempt to invent another geometry subsystem. A negative result is actionable architectural evidence: revise or retire root-only proximity rather than add scenario-specific code.

## Authority Triad and disposition

**Architecture:** existing blocked-first Situation Assessment remains authoritative. This paper proposes no new jurisdiction, mandatory metric or independent blocked-state proof.

**Specification:** Configuration and Log Publication Specifications remain unchanged; a Spatial Pair Inference contract is not yet mature for normative authoring.

**Source:** current TEST 0.5.0.6 eight-script shell unchanged. No native hook, worker sampling loop, proximity code, version bump, or Control.

**Validation:** this is a *source-grounded research/bench study*, not an in-game PASS. The owner waived 0.5.0.6's diagnostic-removal smoke, not subsequent GIANTS-dependent worker-observation validation. Structural documentation checks are appropriate. Before approving production pair selection or movement, validate candidate locality and mistaken-neighbour cases in Reality.

**Accepted policy in #440:** 30 m root-to-root horizontal radius, nominate nearest eligible worker. The bound is **decided**, though not yet GIANTS-Reality-validated. Unresolved: candidate eligibility/attribution and behaviour if the simple approximation fails in practice.
