# Bounded Bypass Specification

## Identity and authority

**Specification Jurisdiction:** Bounded Bypass  
**Jurisdiction ID:** `BOUNDED_BYPASS`  
**Parent Jurisdiction:** [`Resolution Lifecycle`](RESOLUTION_LIFECYCLE.md)  
**Primary Architecture Authority:** [`architecture/SPATIAL_NEGOTIATION_MODEL.md`](../architecture/SPATIAL_NEGOTIATION_MODEL.md#specification-jurisdiction--bounded-bypass)

This Specification owns the implementation-facing contract for the single-subject **Bounded Bypass Resolution**: after the simple Blocked Worker Recovery strategy has been positively exhausted at a fresh correlated successor Stall, OuttaMyWay may perform one fixed Transit-first dogleg around one positively established stable Causal Obstruction and then hand the still-current GIANTS Job back.

Bounded Bypass does not own raw blockage observation, Blocked Progress Stall or recurrence interpretation, Causal Obstruction recognition, blocker object classification, productive route generation, arbitrary world navigation, detailed articulated manoeuvre prediction, generic obstacle avoidance, generic Bounded Authority or generic Control mechanics.

It inherits generic persistence, obligation and terminal semantics from [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md).

> **Strategy Exhaustion Removes Replay; It Does Not Remove Fresh Choice.**

> **Fixed Dogleg != General Route Planning.**

## Boundary contract

### Admission inputs

A Bounded Bypass Candidate MUST be grounded in one coherent current evidence context containing all of the following:

- one exact active supported Physical Assembly and current qualifying GIANTS Job Episode;
- a fresh current positive **Blocked Progress Stall** under that Job Episode;
- a current **Correlated Recovery Recurrence** against the immediately preceding successful Recovery for the same Physical Assembly, with **Recovery Strategy Exhausted** established by the Blocked Worker Recovery contract;
- one current positive **Causal Obstruction** relation whose beneficiary is the stalled assembly and whose blocker identity is current;
- a positive **Bypass Blocker Stability** conclusion for that exact blocker and proposed Bypass horizon;
- a fresh positively supported current local continuation frame for the stalled worker's current Job Episode;
- support for requesting and settling the worker into Transit;
- at least one supported **Fixed Bypass Dogleg** side under the reference-guide Field World contract;
- no higher-authority Player Claim or lifecycle state that prevents the proposed autonomous movement;
- no incompatible current movement objective over the bypassing worker; and
- the current responsibility / commitment context required for ordinary Candidate, Constraint, Decision and Responsibility Transition processing.

Recovery Strategy Exhausted is only one admission input. It MUST NOT create Causal Obstruction, blocker stability, a local continuation frame, a Bypass side or movement authority.

A Bounded Bypass Candidate MUST NOT be created while the preceding Blocked Worker Recovery Bubble remains current. BWR terminates first; fresh prospective selection resumes afterwards.

### Bypass Blocker Stability

Bypass Blocker Stability is purpose-specific positive evidence that the represented blocker can be treated as stationary for the bounded Bypass excursion.

The implementation MUST NOT use blocker object class as a substitute for stability.

For a current active GIANTS blocker in the same Local Operation, Bypass Blocker Stability MAY be established only when the proposed Bypass Bubble can positively acquire and retain a **0 km/h Supporting Speed Ceiling** over that blocker before Bypass movement begins.

For a current non-active blocker, stability requires positive current evidence sufficient for the bounded Bypass purpose and MUST be invalidated by positive movement, Player Claim or contradictory lifecycle evidence.

A blocker whose activity/stationarity remains unresolved MUST NOT support Bounded Bypass.

> **Blocker Classification != Bypass Stability.**

> **Current Occupancy != Stationarity Authority.**

### Current local continuation frame

The Bypass frame MUST come from fresh current successor-Job evidence.

- `F` is the positively supported current local forward axis.
- `R` is its perpendicular lateral axis.
- `+R` and `-R` are separate Bypass-side possibilities.

A historical Recovery Approach Trail or Recovery Anchor MUST NOT be reused as the Bypass axis.

If the current local continuation is unavailable, turning/unresolved in a way that does not support a stable frame, or otherwise not fit for this bounded control primitive, Bounded Bypass remains unsupported.

> **Recovery Approach Trail != Bypass Axis.**

### Transit-first execution

After Responsibility Transition, the worker MUST request Transit before any Bypass movement.

The required Transit request MUST settle positively before the first movement leg. Bounded Bypass does not require a predicted articulated Transit manoeuvre enclosure or complete-assembly swept-volume model before movement begins.

Transit is a configuration prerequisite for the simple Dogleg, not proof of future route clearance.

### Fixed Bypass Dogleg

The first implementation contract uses one fixed three-leg guide in the current `F/R` frame.

For selected side sign `S` where `S` is either `+1` or `-1`:

1. **Lateral Departure** — achieve approximately **10 m** lateral displacement in direction `S * R` using a forward-diagonal movement. The movement MUST contain positive forward progression; pure sideways translation is not required.
2. **Bypass Advance** — from the displaced line, progress approximately **10 m** along `F`.
3. **Post-Blockage Axis Rejoin** — achieve approximately **10 m** lateral displacement in direction `-S * R` using another forward-diagonal movement, returning to the original local continuation axis at a forward station later than the excursion start.

The exact positive forward component used by each diagonal leg is an implementation calibration owned by the movement helper. It MUST NOT be interpreted as productive-route reconstruction.

The final leg is an axis rejoin, not restoration of the starting pose.

> **Axis Rejoin != Axis Restoration.**

> **Return To Axis != Return To Start.**

Bounded Bypass MUST NOT command a rearward leg merely to recreate the pre-blockage station.

### Reference-guide Field World support

This first contract deliberately does not require articulated pose prediction, complete-assembly manoeuvre enclosure or detailed swept-route proof.

Candidate Support MUST establish that the fixed Dogleg's commanded targets and bounded reference-guide progression are positively inside the authoritative Field World. Immediate field-margin encroachment is not permitted by this initial contract.

Reference-guide support is purpose-limited. It MUST NOT be described as complete-assembly Field World containment, generic negative clearance, terrain traversability or proof that no unrepresented obstacle exists.

> **Reference-Guide Support != Articulated Sweep Proof.**

If the required fixed guide cannot be supported on a side, that side is not eligible.

### Bypass side support and preference

Each lateral side MUST be considered against the same fixed Dogleg support contract.

- If exactly one side has supported Dogleg targets / reference progression, only that side is eligible.
- If both sides are supported, Decision SHOULD prefer the side with the stronger field-interior relationship / away from the constrained field edge.
- If that preference is materially unresolved, a deterministic tie-break MAY be used.
- A preferred side that fails the fixed-guide Field World contract MUST NOT remain a Candidate.

This is bounded side selection, not global path optimisation.

> **Field-Interior Preference != Bypass-Side Support.**

### Bypass Bubble

Once Bounded Bypass becomes Current Responsibility, it creates one temporary purpose-specific Bubble over the Local Operation.

The Bubble participant policy is:

- bypassing worker — sole Bounded Bypass movement principal;
- positively identified active GIANTS blocker whose hold establishes Bypass Blocker Stability — **0 km/h** Supporting Speed Ceiling;
- any remaining uninvolved active Operation participant — exact **1 km/h Bubble Bullet Time** Supporting Speed Ceiling; and
- non-active blocker — no invented speed authority.

The blocker and uninvolved participant do not join the Bounded Bypass movement responsibility.

Supporting Speed Ceilings MUST NOT acquire route, steering, target or movement-objective authority.

Required Bubble protection MUST be positively established before Bypass movement starts. Failure to establish a required blocker hold or third-party ceiling fails closed.

The Bubble dissolves sharply when the Bounded Bypass Resolution reaches a terminal state.

### Completion and handback

Reaching the final **Post-Blockage Axis Rejoin** target completes the bounded Bypass movement obligation.

Completion means the selected fixed Dogleg was executed. It is not a represented proof that the obstruction has been physically cleared for every possible assembly pose or that GIANTS' next native route will succeed.

> **Bypass Excursion Completion != Proven Obstruction Clearance.**

After completion, OuttaMyWay MUST relinquish the Bypass movement/configuration authority and return movement ownership to the still-current GIANTS Job.

Bounded Bypass MUST NOT perform the Blocked Worker Recovery FIELDWORK Job replacement choreography as part of normal success.

Agronomy debt created by the obstruction and Dogleg is accepted. Bounded Bypass MUST NOT extend its authority to repair missed productive coverage.

Subsequent GIANTS motion, turn choice, course reacquisition or later blockage is fresh Reality.

## Durable invariants

### Bounded Bypass is not Blocked Worker Recovery replay

Correlated Recovery Recurrence vetoes replay of the same BWR strategy for that correlated Stall. Bounded Bypass is a different Candidate family and Resolution Jurisdiction with additional independent evidence requirements.

### Productive routing remains GIANTS-owned

The current local continuation axis is a bounded frame for the fixed intervention, not a retained productive route. Bounded Bypass MUST NOT extend it into a field course or predict the next GIANTS turn.

### One blocker, one fixed excursion

One Bounded Bypass Resolution addresses one current positive Causal Obstruction with one selected side and one fixed Dogleg.

A later Stall or different blocker requires fresh Situation Assessment and fresh prospective selection. There is no automatic Bypass retry loop.

### No articulated route-model prerequisite

Bounded Bypass MUST NOT make detailed articulated pose prediction, a trailer trajectory, universal turning-centre construction or general manoeuvre-sweep planning a prerequisite for this fixed Dogleg.

This does not promote the fixed reference guide into generic clearance authority.

### Fresh Reality remains authoritative

Positive contradiction of blocker stability, supported Field World guide, current Job continuity, Player Claim, required Bubble protection or Bounded Authority must stop/refuse further Bypass movement.

## Failure and uncertainty semantics

- **Recovery Strategy Exhausted without positive Causal Obstruction** — no Bounded Bypass Candidate.
- **Causal Obstruction without Bypass Blocker Stability** — no Bounded Bypass Candidate.
- **Current local continuation frame unresolved** — no Bounded Bypass Candidate.
- **Transit unavailable or unsettled** — fail closed before movement.
- **Neither fixed Dogleg side has supported Field World targets / reference progression** — no autonomous Bypass; Player Intervention remains legitimate.
- **Required blocker hold / Bullet Time cannot be established** — fail closed before movement.
- **Blocker moves or stability becomes unresolved during execution** — stop/refuse further Bypass movement and return to authoritative reassessment/escalation.
- **Current Field World guide support is contradicted** — stop/refuse further movement; do not improvise another route inside Control.
- **Final Axis Rejoin target reached** — complete the bounded excursion and hand back; do not return to the original start.
- **Later GIANTS Stall after handback** — fresh Situation Assessment; no automatic Bypass loop.

## Cross-Jurisdiction dependencies

### Blocked Worker Recovery

[`BLOCKED_WORKER_RECOVERY.md`](BLOCKED_WORKER_RECOVERY.md) owns the fresh Stall / Correlated Recovery Recurrence contract and establishes Recovery Strategy Exhausted. It does not build the Dogleg or grant Bypass authority.

### Situation Assessment

Situation Assessment owns current Blocked Progress, Causal Obstruction and any current semantic evidence from which Bypass Blocker Stability is established. Bounded Bypass consumes those products; it does not reinterpret raw native signals.

### Assessment Representation / Physical Representation

Assessment Representation supplies the current Physical Assembly identity/configuration evidence and Field World relationship used by the bounded fixed-guide question. Bounded Bypass deliberately does not require detailed articulated Manoeuvre Sweep construction.

Reference-guide support MUST retain its claim limits and MUST NOT be promoted into complete-assembly clearance or generic negative-clearance authority.

### Candidate Support, Constraint Evaluation and Decision

Bounded Bypass is an independent prospective Candidate family. Candidate Support constructs only fixed Dogleg sides supported by the current contract. Mandatory constraints may reject a side or the whole strategy. Decision selects among independently supported current alternatives.

Recovery Strategy Exhausted does not give Bounded Bypass precedence over another supported Candidate.

### Responsibility Transition and Resolution Lifecycle

Responsibility Transition establishes the selected Bounded Bypass Current Responsibility. The Resolution inherits generic persistence and terminal semantics from `RESOLUTION_LIFECYCLE`.

### Bounded Authority

Every positive Transit/configuration or movement effect requires current purpose-specific Bounded Authority. Supporting blocker/Bullet-Time ceilings may narrow other participants without acquiring their movement objectives.

### Control

Control realises only the authorised fixed Dogleg side and three movement legs. It may discover infeasibility and fail closed; it MUST NOT invent a different route, enlarge the Dogleg, move rearward toward the starting station or begin another strategy.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/assessment/BoundedBypassEvidence.lua`](../scripts/assessment/BoundedBypassEvidence.lua) | `REALISES` |
| [`scripts/candidates/FixedBypassDogleg.lua`](../scripts/candidates/FixedBypassDogleg.lua) | `REALISES` |
| [`scripts/candidates/BoundedBypassCandidateSupport.lua`](../scripts/candidates/BoundedBypassCandidateSupport.lua) | `REALISES` |
| [`scripts/decision/DecisionSelector.lua`](../scripts/decision/DecisionSelector.lua) | `REALISES` |
| [`scripts/decision/ProspectivePortfolioDecisionPolicy.lua`](../scripts/decision/ProspectivePortfolioDecisionPolicy.lua) | `REALISES` |
| [`scripts/responsibility/BoundedBypassResponsibilityTransition.lua`](../scripts/responsibility/BoundedBypassResponsibilityTransition.lua) | `REALISES` |
| [`scripts/commitment/BoundedBypassCommitmentLifecycle.lua`](../scripts/commitment/BoundedBypassCommitmentLifecycle.lua) | `REALISES` |
| [`scripts/control/BoundedBypassControl.lua`](../scripts/control/BoundedBypassControl.lua) | `REALISES` |
| [`scripts/runtime/BoundedBypassRuntime.lua`](../scripts/runtime/BoundedBypassRuntime.lua) | `REALISES` |
| [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) | `REALISES` |
| [`scripts/candidates/ProspectiveDecisionPortfolioSupport.lua`](../scripts/candidates/ProspectiveDecisionPortfolioSupport.lua) | `SUPPORTS` |
| [`scripts/responsibility/ResponsibilityTransitionAuthority.lua`](../scripts/responsibility/ResponsibilityTransitionAuthority.lua) | `SUPPORTS` |
| [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua) | `SUPPORTS` |
| [`scripts/control/mechanisms/TransitConfigurationMechanism.lua`](../scripts/control/mechanisms/TransitConfigurationMechanism.lua) | `SUPPORTS` |

## Implementation traceability

The production path is explicit:

- `BoundedBypassEvidence` consumes current successor continuation, motion, activity and Player evidence; it does not reuse the Recovery Trail.
- `FixedBypassDogleg` constructs both fixed guides using `ForwardDiagonalSteeringHelper` calibration and checks their reference progression against Field World, including islands.
- `BoundedBypassCandidateSupport` requires the exact correlated Stall, positive Causal Obstruction, stability and Transit support, and publishes purpose-limited guide Representation Fitness. The existing recurrence evaluator and BWR veto remain unchanged.
- `ProspectiveDecisionPortfolioSupport` enumerates Bypass independently. `ProspectivePortfolioDecisionPolicy` refuses unresolved cross-purpose competition; `DecisionSelector` prefers field-interior support among mandatory-admissible Bypass sides, then a deterministic side tie-break.
- `BoundedBypassResponsibilityTransition` preflights the successor semantic product before commitment admission. `BoundedBypassCommitmentLifecycle` owns the excursion-or-escalation obligation and terminal settlement. A terminal attempt cannot be replayed for the same Stall evidence identity.
- `BoundedBypassRuntime`, reached explicitly from `Runtime`, prepares the purpose-specific participant plan through the existing `BubbleBulletTime`, obtains Bounded Authority and dispatches only after required Bubble leases are active.
- `BoundedBypassControl` holds the principal while strict Transit settles, dispatches exactly the selected three forward targets, and checks current evidence and physical protection throughout execution. `TransitConfigurationMechanism` provides opt-in strict work-off/raise/fold settlement, including non-foldable assemblies; existing callers retain their calibration and behavior.

The terminal-dependent obligation admits either observed final Rejoin or explicit Player escalation when the fixed attempt cannot continue. Escalation settles that branch as failure, never as excursion completion or obstruction clearance. Job termination and Player Claim settle through authoritative basis cessation. All terminal paths relinquish physical control and Bubble protection.

`ForwardDiagonalSteeringHelper`, `BubbleBulletTime`, `NativeDriveMechanism` and generic Bounded Authority remain shared mechanism dependencies. Calling them does not by itself create additional Jurisdiction participation.

## Validation route

### Structural / conformance validation

Structural validation must prove:

- Architecture declares exactly one `BOUNDED_BYPASS` Jurisdiction and routes it to this primary Specification;
- this Specification reciprocally names the Spatial Negotiation Architecture;
- declared production participants reciprocally acknowledge `BOUNDED_BYPASS`;
- the fixed guide contains exactly three forward legs with no Job replacement or articulated sweep prerequisite; and
- Blocked Worker Recovery still vetoes BWR replay independently of this new Candidate family.

### Offline behavioural validation for the first implementation increment

Before production acceptance, deterministic validation should challenge at least:

- Strategy Exhausted alone does not create Bypass support;
- no positive Causal Obstruction means no Bypass Candidate;
- unresolved blocker stability fails closed;
- an active same-Operation blocker can support Bypass only when the required 0 km/h hold is establishable;
- a non-active blocker requires positive bounded stationarity evidence and no contradictory Player Claim;
- historical Recovery Trail geometry is not used as the Bypass axis;
- both lateral sides are considered;
- unsupported Field World guide targets reject that side;
- Lateral Departure produces the calibrated ~10 m lateral outcome with positive forward progression;
- Bypass Advance produces the calibrated ~10 m forward progression;
- Post-Blockage Axis Rejoin produces the calibrated ~10 m return lateral outcome with positive forward progression;
- final Rejoin returns to the original lateral axis at a later forward station, not the original start;
- no articulated sweep / route-search prerequisite is introduced;
- Control cannot switch sides, enlarge the fixed Dogleg or add a rearward restoration leg after authority is granted;
- active blocker hold and third-party 1 km/h Bubble Bullet Time are established before movement and released at terminal settlement; and
- later blockage after handback is fresh Reality, not an automatic Bypass retry.

### Targeted in-game Reality validation

The first implementation must be challenged in live GIANTS Reality before the supported capability claim is accepted.

Initial scenarios should include:

1. the motivating correlated-recurrence obstruction theatre, proving the simple BWR replay remains vetoed while a supported Fixed Bypass Dogleg can be independently selected;
2. a near-boundary blocker where one Dogleg side is rejected and the field-interior side is selected;
3. a case where neither side's fixed guide is in-field, proving early fail-closed Player Intervention;
4. an active GIANTS blocker held at 0 km/h plus a third active worker under 1 km/h Bubble Bullet Time;
5. a non-active blocker with positive bounded stationarity evidence;
6. contradictory blocker movement or Player Claim during the protected excursion, proving safe invalidation;
7. articulated and non-articulated mover assemblies, observing whether the deliberately simple forward-diagonal Dogleg remains practically stable without adding route modelling;
8. successful final Post-Blockage Axis Rejoin followed by immediate GIANTS handback; and
9. ordinary BWR, Cooperative Passage and Obstruction Relocation controls proving their existing responsibilities remain unchanged outside Bounded Bypass.

### Outside this Specification's validation claim

Bounded Bypass does not claim arbitrary obstacle navigation, generic free-space planning, complete articulated swept-volume containment, terrain traversability, pathfinding around multiple blockers, field-margin excursion, productive-course repair or universal success of GIANTS after handback.
