# Bounded Bypass Specification

## Identity and authority

**Specification Jurisdiction:** Bounded Bypass  
**Jurisdiction ID:** `BOUNDED_BYPASS`  
**Parent Jurisdiction:** [`Resolution Lifecycle`](RESOLUTION_LIFECYCLE.md)  
**Primary Architecture Authority:** [`architecture/SPATIAL_NEGOTIATION_MODEL.md`](../architecture/SPATIAL_NEGOTIATION_MODEL.md#specification-jurisdiction--bounded-bypass)  
This Specification owns the implementation-facing contract for the single-subject **Bounded Bypass Resolution**: after the simple Blocked Worker Recovery strategy has been positively exhausted at a fresh correlated successor Stall, OuttaMyWay may perform one fixed Transit-first dogleg in the local **Blockage Theatre** and then hand the still-current GIANTS Job back.

Bounded Bypass does not own raw blockage observation, Blocked Progress Stall or recurrence interpretation, complete obstacle discovery, blocker-object modelling, blocker classification, productive route generation, arbitrary world navigation, detailed articulated manoeuvre prediction, generic obstacle avoidance, generic Bounded Authority or generic Control mechanics.

It inherits generic persistence, obligation and terminal semantics from [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md).

> **Strategy Exhaustion Removes Replay; It Does Not Remove Fresh Choice.**

> **Bypass Acts On The Blockage Theatre, Not The Blocker Object.**

> **Fixed Dogleg != General Route Planning.**

## Boundary contract

### Admission inputs

A Bounded Bypass Candidate MUST be grounded in one coherent current evidence context containing all of the following:

- one exact active supported Physical Assembly and current qualifying GIANTS Job Episode;
- a fresh current positive **Blocked Progress Stall** under that Job Episode;
- a current **Correlated Recovery Recurrence** against the immediately preceding successful Recovery for the same Physical Assembly, with **Recovery Strategy Exhausted** established by the Blocked Worker Recovery contract;
- positive **Successful Recovery Excursion Evidence** from that immediately preceding Recovery demonstrating at least the retreat magnitude required for Bypass Launch Separation;
- a fresh positively supported current local continuation frame for the stalled worker's current Job Episode;
- a one-shot Transit request immediately before Bypass movement; Transit capability, settlement and persistence are not admission gates;
- at least one supported **Fixed Bypass Dogleg** side, including its Launch Separation segment, under the reference-guide Field World contract;
- no higher-authority Player Claim over the bypassing worker or lifecycle state that prevents the proposed autonomous movement;
- no incompatible current movement objective over the bypassing worker; and
- the current responsibility / commitment context required for ordinary Candidate, Constraint, Decision and Responsibility Transition processing.

Recovery Strategy Exhausted is the strategy-succession gate. Successful Recovery Excursion Evidence may bound Launch Separation magnitude, but neither recurrence nor historical Recovery geometry may create the current local continuation frame, Bypass side, current reverse-clearance conclusion or movement authority. Transit capability is not required for Bypass admission.

A positive Causal Obstruction relation, blocker identity, blocker pose, blocker stationarity conclusion or Player-Claim state for a non-active obstruction is **not** an admission prerequisite.

A Bounded Bypass Candidate MUST NOT be created while the preceding Blocked Worker Recovery Bubble remains current. BWR terminates first; fresh prospective selection resumes afterwards.

### Blockage Theatre and obstacle-model boundary

The Blockage Theatre is the local repeated-stall circumstance established by the successful BWR/native retry followed by the fresh correlated successor Stall. It is not a required runtime object and does not claim complete knowledge of the physical causes of the Stall.

A current positive Causal Obstruction MAY contribute active-participant coordination evidence, but Bounded Bypass MUST NOT require it to enumerate every physical obstacle in the theatre.

A non-active physical obstruction MUST NOT be required to provide:

- a Bypass-specific pose;
- Player Claim / entered-state evidence;
- worker-style motion classification;
- a stationarity classification;
- a recognised object class; or
- mission-vehicle identity

in order for the fixed Dogleg to be attempted.

> **Blockage Trigger != Obstacle Model.**

> **Obstacle Representation Completeness != Bypass Admission.**

A parked implement, bale, placeable, scenery object or other unmodelled physical contributor may therefore exist in the theatre without gaining Bypass semantic identity.

If current Causal Obstruction positively identifies a current active same-Operation GIANTS participant as blocking the Bypass principal, that identity is used only to establish the required Bubble hold.

> **Active Blocker Identity Is Coordination Evidence, Not Bypass Geometry Evidence.**

### Current local continuation frame

The Bypass frame MUST come from fresh current successor-Job evidence.

- `F` is the positively supported current local forward axis.
- `R` is its perpendicular lateral axis.
- `+R` and `-R` are separate Bypass-side possibilities.

A historical Recovery Approach Trail or Recovery Anchor MUST NOT be reused as the Bypass axis.

If the current local continuation is unavailable, turning/unresolved in a way that does not support a stable frame, or otherwise not fit for this bounded control primitive, Bounded Bypass remains unsupported.

> **Recovery Approach Trail != Bypass Axis.**

The immediately preceding successful Recovery MAY contribute only its positively demonstrated retreat magnitude as Launch Separation support. The fresh successor frame still supplies Bypass direction.

> **Recovery Outcome Magnitude != Recovery Axis Reuse.**

### Transit request before execution

After Responsibility Transition, the worker MUST request Transit once before any Bypass movement.

The request is unconditional and best-effort: Control issues it even when no cached Transit capability exists or no configuration change is available. Bounded Bypass MUST NOT wait for Transit settlement, require a positive Transit result, or continuously re-check Transit state after movement begins.

The sequence is explicit:

`second correlated Stall -> request Transit -> reverse Launch Separation -> Dogleg`

The Transit request does not prove future route clearance and does not create a persistent configuration-state obligation for Bypass.

> **Transit Request != Transit State Contract.**

### Fixed Bypass Dogleg

The first implementation contract uses one fixed four-leg guide in the current `F/R` frame.

For selected side sign `S` where `S` is either `+1` or `-1`:

1. **Bypass Launch Separation** — reverse along `-F` by the positive forward distance required by the Lateral Departure calibration. This magnitude MUST be no greater than the demonstrated retreat magnitude retained from the immediately preceding successful Recovery.
2. **Lateral Departure** — from the launch station, achieve approximately **10 m** lateral displacement in direction `S * R` using a forward-diagonal movement. The movement MUST contain positive forward progression; pure sideways translation is not required.
3. **Bypass Advance** — from the displaced line, progress approximately **10 m** along `F`.
4. **Post-Blockage Axis Rejoin** — achieve approximately **10 m** lateral displacement in direction `-S * R` using another forward-diagonal movement, returning to the original local continuation axis at a forward station later than the recurrent Stall.

The exact positive forward component used by each diagonal leg is an implementation calibration owned by the movement helper. Launch Separation MUST be derived from that same component rather than introducing an unrelated longitudinal literal. It MUST NOT be interpreted as productive-route reconstruction.

The prior successful Recovery supplies only a demonstrated magnitude bound. It does not prove the current reverse Launch segment clear; current execution progress remains authoritative.

> **Demonstrated Retreat Magnitude != Current Reverse Clearance.**

The final leg is an axis rejoin, not restoration of the starting pose.

> **Axis Rejoin != Axis Restoration.**

> **Return To Axis != Return To Start.**

Bounded Bypass MUST NOT command any rearward movement beyond the authorised Launch Separation merely to recreate the pre-blockage station.

### Reference-guide Field World support

This first contract deliberately does not require articulated pose prediction, complete-assembly manoeuvre enclosure, obstacle-map construction or detailed swept-route proof.

Candidate Support MUST establish that the fixed Dogleg's commanded targets and bounded reference-guide progression, including the rearward Launch Separation segment, are positively inside the authoritative Field World. Immediate field-margin encroachment is not permitted by this initial contract.

Reference-guide support is purpose-limited. It MUST NOT be described as complete-assembly Field World containment, generic negative clearance, terrain traversability, obstacle clearance or proof that no unrepresented obstacle exists.

> **Reference-Guide Support != Articulated Sweep Proof.**

If the required fixed guide cannot be supported on a side, that side is not eligible.

### Bypass side support and preference

Each lateral side MUST be considered against the same fixed Dogleg support contract.

- If exactly one side has supported Dogleg targets / reference progression, only that side is eligible.
- If both sides are supported, Decision SHOULD prefer the side with the stronger field-interior relationship / away from the constrained field edge.
- If that preference is materially unresolved, a deterministic tie-break MAY be used.
- A preferred side that fails the fixed-guide Field World contract MUST NOT remain a Candidate.

The side decision MUST NOT depend on discovering, classifying or reconstructing the complete physical obstacle set.

This is bounded side selection, not global path optimisation.

> **Field-Interior Preference != Bypass-Side Support.**

### Bypass Bubble

Once Bounded Bypass becomes Current Responsibility, it creates one temporary purpose-specific Bubble over the Local Operation.

The Bubble participant policy is:

- bypassing worker — sole Bounded Bypass movement principal;
- each positively identified current active same-Operation GIANTS participant that current Causal Obstruction identifies as blocking the Bypass principal — **0 km/h Supporting Speed Ceiling**;
- every remaining uninvolved active Operation participant — exact **1 km/h Bubble Bullet Time Supporting Speed Ceiling**; and
- non-active physical obstacles — no invented speed authority and no object-level stability / Player-Claim gate.

A positive Causal Obstruction is therefore optional Bypass coordination evidence, not Bypass admission evidence.

If no active GIANTS blocker is positively identified, Bounded Bypass MUST NOT invent a 0 km/h blocker hold. Other active Operation participants still receive the required 1 km/h Bubble Bullet Time ceiling.

The held blocker and uninvolved active participants do not join the Bounded Bypass movement responsibility.

Supporting Speed Ceilings MUST NOT acquire route, steering, target or movement-objective authority.

Every required active-participant ceiling MUST be positively established before Bypass movement starts. Failure to establish a required active-blocker hold or third-party ceiling fails closed.

The Bubble dissolves sharply when the Bounded Bypass Resolution reaches a terminal state.

### Execution progress and unmodelled obstruction

The fixed reference guide is not negative-clearance proof. A physical object that was not represented during admission may block a commanded Dogleg leg.

Control MUST observe whether the authorised movement is making progress toward its current target. Positive non-progress under the current command MUST terminate the bounded attempt through its failure/escalation path.

Elapsed time alone MUST NOT establish the semantic failure. A watchdog MAY bound observation of non-improving commanded movement, but it MUST be tied to current target-progress evidence.

On such failure Control MUST NOT search around the new object, switch sides, enlarge the Dogleg or start another Bypass attempt.

> **Unmodelled Obstacle Is An Execution Failure, Not An Admission Problem.**

### Completion and handback

Reaching the final **Post-Blockage Axis Rejoin** target completes the bounded Bypass movement obligation.

Completion means the selected fixed Dogleg was executed. It is not a represented proof that every obstruction in the theatre has been physically cleared or that GIANTS' next native route will succeed.

> **Bypass Excursion Completion != Proven Obstruction Clearance.**

After completion, OuttaMyWay MUST relinquish the Bypass movement/configuration authority and return movement ownership to the still-current GIANTS Job.

Bounded Bypass MUST NOT perform the Blocked Worker Recovery FIELDWORK Job replacement choreography as part of normal success.

Agronomy debt created by the blockage and Dogleg is accepted. Bounded Bypass MUST NOT extend its authority to repair missed productive coverage.

Subsequent GIANTS motion, turn choice, course reacquisition or later blockage is fresh Reality.

## Durable invariants

### Bounded Bypass is not Blocked Worker Recovery replay

Correlated Recovery Recurrence vetoes replay of the same BWR strategy for that correlated Stall. Bounded Bypass is a different Candidate family and Resolution Jurisdiction with additional independent movement-support requirements.

### Productive routing remains GIANTS-owned

The current local continuation axis is a bounded frame for the fixed intervention, not a retained productive route. Bounded Bypass MUST NOT extend it into a field course or predict the next GIANTS turn.

### One recurrent theatre, one fixed excursion

One correlated Recovery Strategy Exhausted condition may support at most one Bounded Bypass attempt for that Stall evidence identity.

The attempt is not keyed to one blocker object and does not require a complete obstacle inventory.

A later Stall requires fresh Situation Assessment and fresh prospective selection. There is no automatic Bypass retry loop.

### No obstacle-model prerequisite

Bounded Bypass MUST NOT make complete obstacle enumeration, per-object non-active stability, Player Claim over non-active obstructions, detailed articulated pose prediction, a trailer trajectory, universal turning-centre construction or general manoeuvre-sweep planning a prerequisite for this fixed Dogleg.

This does not promote the fixed reference guide into generic clearance authority.

### Fresh Reality remains authoritative

Positive contradiction of the supported Field World guide, current Job continuity, Player Claim over the bypassing worker, required active-participant Bubble protection, Bounded Authority or current Dogleg progress must stop/refuse further Bypass movement.

## Failure and uncertainty semantics

- **Recovery Strategy Exhausted with no positive Causal Obstruction** — Bounded Bypass may still be supported when the remaining admission contract is satisfied.
- **Non-active obstruction lacks pose / Player Claim / worker-motion evidence** — not a Bypass veto.
- **Current local continuation frame unresolved** — no Bounded Bypass Candidate.
- **Immediately preceding successful Recovery did not positively demonstrate the retreat magnitude required by Launch Separation** — no Bounded Bypass Candidate.
- **Neither fixed Dogleg side has supported Field World targets / reference progression** — no autonomous Bypass; Player Intervention remains legitimate.
- **A positively identified active same-Operation causal blocker cannot be held at 0 km/h** — fail closed before movement.
- **Required third-party Bubble Bullet Time cannot be established** — fail closed before movement.
- **Unrepresented obstruction prevents progress toward the current Dogleg target** — fail the bounded attempt and escalate; do not invent another route.
- **Current Field World guide support is contradicted** — stop/refuse further movement; do not improvise another route inside Control.
- **Player takes control of the bypassing worker** — relinquish Bypass authority through the normal higher-authority path.
- **Final Axis Rejoin target reached** — complete the bounded excursion and hand back; do not return to the original start.
- **Later GIANTS Stall after handback** — fresh Situation Assessment; no automatic Bypass loop.

## Cross-Jurisdiction dependencies

### Blocked Worker Recovery

[`BLOCKED_WORKER_RECOVERY.md`](BLOCKED_WORKER_RECOVERY.md) owns the fresh Stall / Correlated Recovery Recurrence contract, establishes Recovery Strategy Exhausted and may expose bounded Successful Recovery Excursion Evidence from the immediately preceding completed Recovery. Bypass may consume the demonstrated retreat magnitude as a Launch Separation bound; BWR does not build the Dogleg, supply the current Bypass axis or grant Bypass authority.

### Situation Assessment

Situation Assessment owns Blocked Progress and any current Causal Obstruction meaning. Bounded Bypass consumes Recovery Strategy Exhausted as its strategy-succession gate.

Current Causal Obstruction may additionally identify an active same-Operation GIANTS participant that requires a Bypass Bubble hold. It is not required to provide a complete obstacle model and is not itself a Bypass admission prerequisite.

### Assessment Representation / Physical Representation

Assessment Representation supplies the current bypassing Physical Assembly identity/configuration evidence and Field World relationship used by the bounded fixed-guide question. Bounded Bypass deliberately does not require a representation of every obstruction in the Blockage Theatre or detailed articulated Manoeuvre Sweep construction.

Reference-guide support MUST retain its claim limits and MUST NOT be promoted into complete-assembly clearance or generic negative-clearance authority.

### Candidate Support, Constraint Evaluation and Decision

Bounded Bypass is an independent prospective Candidate family. Candidate Support constructs only fixed Dogleg sides supported by the current contract. Mandatory constraints may reject a side or the whole strategy. Decision selects among independently supported current alternatives.

Recovery Strategy Exhausted does not give Bounded Bypass precedence over another supported Candidate.

### Responsibility Transition and Resolution Lifecycle

Responsibility Transition establishes the selected Bounded Bypass Current Responsibility. The Resolution inherits generic persistence and terminal semantics from `RESOLUTION_LIFECYCLE`.

### Bounded Authority

Every positive Transit/configuration or movement effect requires current purpose-specific Bounded Authority. Supporting active-participant ceilings may narrow other participants without acquiring their movement objectives.

### Control

Control realises only the authorised fixed Dogleg side and three movement legs. It monitors current progress and may discover execution infeasibility. It MUST NOT invent a different route, enlarge the Dogleg, switch sides, move rearward toward the starting station or begin another strategy.

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

- `BoundedBypassEvidence` consumes the current successor continuation and principal Player evidence and extracts only optional active same-Operation causal-blocker identities for Bubble coordination. It does not require a non-active obstruction's pose, Player state, motion evidence or stationarity.
- `FixedBypassDogleg` derives Launch Separation from the same `ForwardDiagonalSteeringHelper` calibration used for Lateral Departure, constructs both four-leg fixed guides and checks their reference progression against Field World, including islands.
- `BoundedBypassCandidateSupport` requires the exact correlated Stall / Recovery Strategy Exhausted condition, sufficient demonstrated retreat magnitude from the immediately preceding successful Recovery, current successor Job/frame and at least one Field-World-supported four-leg Dogleg side. Transit capability is not an admission prerequisite. Causal Obstruction is not an admission prerequisite.
- `ProspectiveDecisionPortfolioSupport` enumerates Bypass independently. `ProspectivePortfolioDecisionPolicy` refuses unresolved cross-purpose competition; `DecisionSelector` prefers field-interior support among mandatory-admissible Bypass sides, then a deterministic side tie-break.
- `BoundedBypassResponsibilityTransition` preflights the successor semantic product before commitment admission. `BoundedBypassCommitmentLifecycle` owns the excursion-or-escalation obligation and terminal settlement. A terminal attempt cannot be replayed for the same Stall evidence identity.
- `BoundedBypassRuntime`, reached explicitly from `Runtime`, maps each positively identified active same-Operation causal blocker to the shared Bubble's 0 km/h hold and every other uninvolved active participant to 1 km/h Bubble Bullet Time before principal movement is authorised.
- `BoundedBypassControl` requests cached Transit once and does not inspect the request result or later settlement state; it then dispatches the selected reverse Launch Separation followed by exactly three forward targets, validates current principal/Field World/Bubble authority, and fails the one bounded attempt when fresh target-distance evidence shows no meaningful progress for the implementation-owned watchdog interval. It does not inspect or control non-active obstruction objects.
- `TransitConfigurationMechanism` receives the one-shot Bypass Transit request. Bypass does not adopt its settlement result as a lifecycle condition; existing callers retain their own behaviour.

The terminal-dependent obligation admits either observed final Rejoin or explicit Player escalation when the fixed attempt cannot continue. Escalation settles that branch as failure, never as excursion completion or obstruction clearance. Job termination and Player Claim over the bypassing worker settle through authoritative basis cessation. All terminal paths relinquish physical control and Bubble protection.

`ForwardDiagonalSteeringHelper`, `BubbleBulletTime`, `NativeDriveMechanism` and generic Bounded Authority remain shared mechanism dependencies. Calling them does not by itself create additional Jurisdiction participation.

## Validation route

### Structural / conformance validation

Structural validation must prove:

- Architecture declares exactly one `BOUNDED_BYPASS` Jurisdiction and routes it to this primary Specification;
- this Specification reciprocally names the Spatial Negotiation Architecture;
- declared production participants reciprocally acknowledge `BOUNDED_BYPASS`;
- the implementation traceability preserves the blockage-theatre admission boundary and active-participant-only Bubble coordination; and
- Blocked Worker Recovery still vetoes BWR replay independently of this new Candidate family.

### Offline behavioural validation for the first implementation increment

Before production acceptance, deterministic validation should challenge at least:

- Recovery Strategy Exhausted remains necessary for Bypass;
- Recovery Strategy Exhausted can support Bypass without any positive Causal Obstruction when the current Job/frame/Field World contract is otherwise satisfied;
- missing blocker pose, entered-state, worker-motion or stationarity evidence for a non-active obstruction does not veto Bypass;
- an unrepresented physical obstruction is not required to acquire Bypass semantic identity;
- historical Recovery Trail geometry is not used as the Bypass axis;
- Transit is requested once before movement even when no cached capability exists, and neither request failure nor later settlement drift blocks the already-authorised Bypass;
- both lateral sides are considered;
- unsupported Field World guide targets reject that side;
- Lateral Departure produces the calibrated ~10 m lateral outcome with positive forward progression;
- Bypass Advance produces the calibrated ~10 m forward progression;
- Post-Blockage Axis Rejoin produces the calibrated ~10 m return lateral outcome with positive forward progression;
- final Rejoin returns to the original lateral axis at a later forward station, not the original start;
- no obstacle-map / articulated-sweep / route-search prerequisite is introduced;
- Control cannot switch sides, enlarge the fixed Dogleg or add a rearward restoration leg after authority is granted;
- a positively identified active same-Operation causal blocker receives 0 km/h and failure to establish that hold prevents movement;
- every remaining uninvolved active participant receives 1 km/h Bubble Bullet Time;
- absence of an identified active blocker does not invent a 0 km/h hold;
- positive non-progress toward a commanded Dogleg target terminates/escalates rather than causing route search or an autonomous retry;
- Bubble protection releases at terminal settlement; and
- later blockage after handback is fresh Reality, not an automatic Bypass retry.

### Targeted in-game Reality validation

The first implementation must be challenged in live GIANTS Reality before the supported capability claim is accepted.

Initial scenarios should include:

1. the motivating correlated-recurrence theatre with a parked physical obstruction and an additional unmodelled physical object, proving the Dogleg can be admitted without complete obstacle identity;
2. the same theatre proving the fixed Dogleg is actually attempted after Recovery Strategy Exhausted;
3. a near-boundary theatre where one Dogleg side is rejected and the field-interior side is selected;
4. a case where neither side's fixed guide is in-field, proving early fail-closed Player Intervention;
5. an active GIANTS causal blocker held at 0 km/h plus a third active worker under 1 km/h Bubble Bullet Time;
6. no identified active blocker, proving other active participants receive Bubble Bullet Time without an invented blocker hold;
7. a Dogleg leg physically blocked by an unrepresented object, proving positive non-progress terminates/escalates without route invention;
8. articulated and non-articulated mover assemblies, observing whether the deliberately simple forward-diagonal Dogleg remains practically stable without adding route modelling;
9. successful final Post-Blockage Axis Rejoin followed by immediate GIANTS handback; and
10. ordinary BWR, Cooperative Passage and Obstruction Relocation controls proving their existing responsibilities remain unchanged outside Bounded Bypass.

### Outside this Specification's validation claim

Bounded Bypass does not claim arbitrary obstacle discovery, object classification, obstacle navigation, generic free-space planning, complete articulated swept-volume containment, terrain traversability, pathfinding around multiple blockers, field-margin excursion, productive-course repair or universal success of GIANTS after handback.
