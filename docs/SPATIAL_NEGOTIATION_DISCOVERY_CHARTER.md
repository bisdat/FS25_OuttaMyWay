# Spatial Negotiation Discovery Charter

## Status

This document records the architecture-discovery checkpoint reached after owner-declared v0.1.15.0 canonical. It is deliberately **not an implementation specification**. Runtime behaviour remains governed by the existing canonical architecture until a later engineering increment explicitly implements and validates any part of this model.

The discovery programme is named **Spatial Negotiation Discovery**. Its purpose is to test whether OuttaMyWay is better understood as negotiating temporary spatial claims between traffic parties than as predicting or navigating worker trajectories.

## Problem statement

The v0.1.x line proved several binary mechanisms independently: Regulation, Cooperative Passage, recovery/Axis Return, and Terminal Courtesy. Three-worker TS017 evidence then showed a compositional weakness: an established pairwise resolution can remain sticky enough that a developing external relationship consumes the very Resolution Space the first resolution still requires. The bookended-S416 recollection exposes the complementary pre-coupling case: several binary relationships may develop around one worker, but their geometry can still imply a natural serial order.

The discovery question is therefore:

> Can multi-worker traffic within the supported envelope be represented as a sequence of binary spatial negotiations, with temporarily coupled parties exposed externally as one Interaction Bubble, while GIANTS remains responsible for navigation and manoeuvre execution?

## Discipline

Every claim in this programme must be kept in one of four categories:

- **Fact / observation:** supported by runtime evidence, video, logs, or clearly identified owner recollection.
- **Interpretation:** a proposed explanation of observed Reality.
- **Hypothesis:** a general model that must survive existing evidence and hostile thought experiments.
- **Decision:** an explicitly agreed architectural boundary or policy.

Do not promote hypotheses to implementation merely because they are elegant. Failed tests disprove or refine the model; they do not require fixture-specific repair.

## Provisional vocabulary

### Traffic Party
A controllable participant whose current physical occupancy and/or progression may conflict with another claim. An individual AI worker assembly is a Traffic Party. A completed assembly may remain a Traffic Party because its Occupancy Demand is physically real and can still be moved under bounded authority.

### Spatial Claim
The space a Traffic Party currently occupies or may legitimately require. The current discovery distinguishes:

- **Occupancy Demand** — space physically occupied now; motion is not required.
- **Progression Demand** — space being consumed by the current motion vector.
- **Prospective Demand** — space that current evidence indicates may shortly be required.
- **Committed Resolution Demand** — space already owed to an active coupled resolution.

Productive work is not itself a Spatial Claim. Its architectural value is evidential: GIANTS productive work has a comparatively constrained future continuation (headland direction or productive corridor), whereas `TURNING` can expose a useful current vector while leaving later intent unresolved.

### Negotiation
Temporary allocation or conservation of Resolution Space between incompatible claims. Negotiation decides **who may consume space**, not how a vehicle should steer through it.

Working boundary:

> **GIANTS navigates; OuttaMyWay negotiates.**

This remains a guiding hypothesis until the implementation impact has been tested.

### Interaction Bubble
A provisional abstraction for parties that have entered a committed coupled resolution with jointly dependent persistent obligations. Cooperative Passage is the proved motivating example. Bubble contraction hides the members' external traffic independence; it does not erase their individual physical identity or internal obligations.

Working formation boundary: **committed coupled resolution**.

Working dissolution boundary: **Last-Handoff Dissolution** — burst immediately when the final coupled participant is handed back to GIANTS AI. No relationship-settlement tail is desired.

### Bubble Protection
The requirement that unrelated external traffic must not consume Resolution Space still required by an active Interaction Bubble. Internal persistence must not suppress external negotiation.

### Resolution Epoch
The interval from Bubble formation to Last-Handoff Dissolution.

### Bullet Time
**Architectural decision:** during a Resolution Epoch, every independent external AI Traffic Party progresses at the existing fixed **1 km/h Intent-Revelation Creep** while the Bubble executes normally.

Bullet Time is intentionally simple and conservative. The literal is not a tuning target and the cadence is not to be varied merely to recover throughput. Its purposes are:

1. preserve unresolved Bubble Resolution Space;
2. reduce external claim-consumption rate;
3. continue revealing GIANTS turn intent rather than freezing Reality.

The owner explicitly accepts whole-Operation 1 km/h conservatism over speculative locality or adaptive sophistication.

## Regulation under the new lens

Current evidence suggests that Regulation is an actuator, not a single negotiation type. Across the three selected Regulation families, its common effect is to control the rate at which one Traffic Party consumes Resolution Space:

1. **Longitudinal reserve conflict:** follower progression consumes the leading party's manoeuvre/resolution reserve. Either party may be productive or `TURNING`; current vector matters more than agronomic quality.
2. **Foreseeable Passage conservation:** two productive continuations oppose within the same broad corridor. Reality indicates that Cooperative Passage will ultimately be required, so Regulation protects future Passage space until coupling becomes admissible. This is the Regulation family that directly develops into an Interaction Bubble.
3. **Transverse/oblique reserve conflict:** commonly a `TURNING` party's developing vector intrudes across a comparatively predictable productive continuation. Regulation preserves contested Resolution Space while the less-certain motion reveals itself.

Do not infer a generic rule to "regulate the productive worker". Productive status supplies predictability evidence; precedence should be justified by preservation of Resolution Space.

## Evidence-model results

### Uncomplicated Cooperative Passage
Before commitment, two independent parties negotiate incompatible future corridor use. At committed Passage they acquire jointly dependent persistent obligations and are naturally represented as one Interaction Bubble. Crossing alone does not dissolve coupling; recovery may include Alignment Runout and Axis Return. The Bubble should burst at final GIANTS handoff, not at physical separation.

### Terminal Courtesy
Terminal Courtesy is a useful **negative Bubble test**. A completed stationary assembly can own Occupancy Demand while an active worker owns Progression Demand through the same region. Courtesy displaces the completed assembly's claim under bounded authority, but the two parties do not acquire jointly dependent persistent obligations. Negotiation therefore does not imply coupling. D-0199's "Courtesy Budget Belongs to the Obstacle" is consistent with claim-owner history rather than persistent pair history.

### TS017 — Bubble plus individual
Observed S416/Condor Passage remained internally alive while Patriot became externally material. Member-level S416/Patriot and Condor/Patriot relationships were detected, but Patriot ultimately occupied Resolution Space needed for the first Bubble's Axis Return. This supports the interpretation:

> **Member Relationship Is Not Bubble Relationship.**

A valid internal Bubble can remain sticky while external negotiation occurs concurrently at the Bubble boundary. The model need not guarantee internal Passage success; it should prevent unrelated external concurrency from accidentally destroying an otherwise viable coupled resolution.

### Bookended S416 — owner recollection / hostile thought experiment
Assumed perfect-storm geometry:

`Patriot ---> S416 <--- Condor`

Patriot/S416 is longitudinal follower/leader and therefore Regulation-only in that orientation. S416/Condor is opposed and develops toward Passage/Bubble #1. During Bubble #1 Patriot enters Bullet Time. After Last-Handoff Dissolution, S416 has moved eastward and Patriot/Condor can naturally become the next opposed relationship and Bubble #2.

This supports, but does not prove, **serialization emerging from geometry** rather than requiring a three-worker manoeuvre or central multi-party scheduler.

## Environmental constraints

Field boundary, constrained headland/corner geometry, terrain, and future environmental evidence such as weather need not become Traffic Parties. They can instead constrain which Spatial Claims are feasible. This allows the same negotiation model to extend without asking OuttaMyWay to navigate around every environmental condition.

The earlier corner-zone idea is therefore retained as a **spatial capacity / warning overlay hypothesis**: constrained Field World regions make manoeuvre space expensive and can justify earlier conservation while uncertain intent develops. It is not yet implemented.

## Explicit architectural decisions

### D-0201 — Supported Traffic Envelope
OuttaMyWay supports a maximum of **three simultaneously active AI worker assemblies within one Operation**, with the supported validation target being workers performing **different agronomic roles**.

- Player-controlled vehicles do **not** count toward the three-worker cap.
- More than three active AI workers may work incidentally but are outside the supported design/validation obligation.
- Multiple workers performing the same agronomy may work incidentally but are outside the supported design/validation obligation. Courseplay already owns the multiple-worker/same-agronomy coordination domain; OuttaMyWay must not expand into overlapping fleet coordination.
- Out-of-envelope failures do not justify special-case architecture unless the same defect is shown within the supported envelope.

Three is intentionally sufficient to exercise composition: individual + pair, Bubble + individual, and competing developing binary relationships. The project does not claim arbitrary fleet coordination.

### D-0202 — 1 km/h Is Bullet Time
During a Resolution Epoch all independent external AI Traffic Parties are regulated to exactly **1 km/h Intent-Revelation Creep**. Do not replace this with variable speeds, adaptive cadence, or locality optimisation merely for throughput. Simplicity, player comprehensibility, Resolution-Space conservation and intent revelation are the architectural purposes.

## Current hypotheses to test, not implementation commitments

- Regulation controls spatial-claim consumption; it does not itself create a Bubble.
- Negotiation does not imply coupling.
- Coupled persistent resolution creates an Interaction Bubble.
- Bubble Formation occurs at committed coupled resolution.
- Last-Handoff Dissolution should remove the Bubble immediately when the last controlled participant returns to GIANTS.
- A Traffic Party participates in at most one coupled resolution at a time while remaining externally negotiable as a whole.
- Internal persistence must not suppress external negotiation.
- Serialization may emerge from relationship geometry rather than a central scheduler.
- Productive state is predictability evidence, not generic yield authority.
- Constrained Field World regions may supply early spatial-warning evidence without route prediction.

## Deliberately unresolved edge cases

1. **Occupied-at-formation:** a third party already materially occupies Resolution Space required by a pair at the instant coupled commitment would otherwise form. Bubble Protection cannot retroactively create missing space; formation authority needs separate examination.
2. **External Bubble representation:** determine the minimum spatial demand an active Bubble must expose without concealing essential member geometry.
3. **Internal infeasibility:** Phase 8/9 Axis Settlement/Axis Return and other internal failures remain valid reasons for a Bubble to fail. Binary external representation does not imply simple internal execution.
4. **Same-agronomy / >3 workers:** explicitly outside supported validation scope unless evidence transfers into the supported envelope.
5. **Bubble-vs-Bubble:** not required by the supported three-AI-worker envelope and must not drive current design.

## Implementation gate

No Spatial Negotiation / Bubble / Resolution Epoch runtime implementation is authorised by this charter. Before code:

1. compare the provisional model against canonical responsibilities and authority layers;
2. identify which existing concepts generalise cleanly and which current pair-first assumptions would conflict;
3. define the smallest implementation tranche that can falsify the model;
4. preserve v0.1.15.0 runtime behaviour as the implementation baseline until that tranche is explicitly agreed.

The objective is not to make the model elegant. The objective is to discover whether it describes Reality better.
