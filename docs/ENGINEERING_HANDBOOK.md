## v0.1.0.0 pre-1.0 versioning authority

From the owner-declared v4.7.128 canonical baseline onward, release identity uses `0.MINOR.PATCH.BUILD` until public release. Canonical releases use `BUILD=0`; non-canonical TEST iterations increment BUILD; accepted compatible corrections increment PATCH and reset BUILD; significant architecture/capability milestones increment MINOR and reset PATCH/BUILD. The first public release is reserved for `1.0.0.0`. Historical 4.7.x identities remain immutable engineering provenance and are never renumbered.

This versioning policy is release governance only and does not alter architecture or runtime behaviour.

## v4.7.0 replacement-core implementation authority

Canonical v4.6.78 remains the closed replacement-core foundation. Later architecture may change only through an explicit evidence-backed owner decision and ADR; ADR-0021 is the sole bounded extension currently accepted. Active v4.7.x code implements the resulting architecture directly. Archived v4.6.78 scripts have empirical and historical value only and may not be sourced by the active runtime. Implementation difficulty is classified as implementation defect, adapter gap, evidence gap, unsupported capability or apparent architecture contradiction; only the last category stops for explicit owner review.

# Engineering Handbook

## v4.6.78 replacement-core authority note

The Handbook preserves accumulated engineering history and explanatory material. Current normative driving-system authority resides in:

- `ARCHITECTURE.md`;
- `ARCHITECTURE_FLOW.md`;
- `DESIGN.md`;
- ADR-0019;
- ADR-0021 for Field World Equivalence Authority.

Where older chapters describe Negotiation Manager, Permission Gate or controller-specific lifecycle ownership, treat those sections as historical explanation rather than the current replacement-core contract.

The current core is organised around Situation Assessment, Decision, Commitment, explicit Obligation ownership, bounded Control and observed terminal settlement.

## v4.6.50 architecture recovery note

Temporary v4.6.44–v4.6.49 is retained as an Experimental Capability Corpus, not promoted runtime architecture.

The audit established four implementation findings: Prototype Boundary Leakage, Assessment–Decision–Control Collapse, Architectural Constraint Enforcement Gap and Fragmented Commitment Ownership.

The governing route remains:

```text
Observation
→ Situation Assessment
→ Operational Picture Knowledge
→ Decision
→ Commitment
→ Control
→ Outcome Observation
↺ Situation Assessment
```

The next code increment is passive and must trace this route without controlling a vehicle. See `50_Research/ARCHITECTURE_COMPLIANCE_AUDIT_V4.6.49.md`, `50_Research/CANONICAL_KNOWLEDGE_CONSTRAINT_RECOVERY.md` and ADR-0005.

> **Authority:** Reference
>
> **Currency:** Last reviewed for canonical release v4.5.9

This handbook preserves the engineering observations, experiments, architectural decisions and philosophy behind OuttaMyWay. It is maintained as part of the mod, not as supplementary material.

## Contents

- [Preface](#volume-0-preface)
- [Chapter 1 — Vision](#chapter-1-vision)
- [Chapter 2 — Engineering Principles](#chapter-2-engineering-principles)
- [Chapter 3 — System Architecture](#chapter-3-system-architecture)
- [Chapter 4 — The Observer](#chapter-4-the-observer)
- [Chapter 5 — Interaction Contexts](#chapter-5-interaction-contexts)
- [Chapter 6 — The Conflict Predictor](#chapter-6-the-conflict-predictor)
- [Chapter 7 — The Negotiation Manager](#chapter-7-the-negotiation-manager)
- [Chapter 8 — The Permission Gate](#chapter-8-the-permission-gate)
- [Chapter 9 — Engineering Through Experimentation](#chapter-9-engineering-through-experimentation)
- [Chapter 10 — Preserving Engineering Decisions](#chapter-10-preserving-engineering-decisions)
- [Chapter 11 — Engineering Scenarios](#chapter-11-engineering-scenarios)
- [Chapter 12 — The Recovery Manager](#chapter-12-the-recovery-manager)
- [Chapter 13 — Scenario Engineering](#chapter-13-scenario-engineering)
- [Chapter 14 — Respect the Player](#chapter-14-respect-the-player)
- [Chapter 15 — Respect the World](#chapter-15-respect-the-world)
- [Chapter 16 — The Weight of Chains and the Springboard of Memory](#chapter-16-the-weight-of-chains-and-the-springboard-of-memory)
- [Chapter 17 — Evolution Without Erosion](#chapter-17-evolution-without-erosion)
- [Appendix A — Collaborative Reflections](#appendix-a--collaborative-reflections)
- [Architectural Decision Records](adr/README.md)

# Volume 0 — Preface

## Welcome

OuttaMyWay began with a deceptively simple question.

Can two Farming Simulator AI workers cooperate more intelligently?

At first glance the problem appeared to be one of collision avoidance.

**It was not.**

As development progressed it became clear that the real challenge was understanding how the native GIANTS AI thinks, plans, and ultimately decides to move.

Rather than replacing that behaviour, OuttaMyWay gradually evolved into something different:

A behavioural enhancement layer for the native Farming Simulator AI.

That distinction defines every engineering decision made throughout this project.

## This Handbook

This repository contains source code.

It also contains something we consider equally important:

The engineering reasoning behind the code.

Many software projects document implementation.

**Far fewer document discovery.**

This handbook exists to capture the observations, experiments, mistakes, breakthroughs and architectural decisions that shaped OuttaMyWay.

If a future engineer disagrees with one of our decisions, we hope they do so for the same reason we made it:

Because new evidence suggests a better answer.

## Why This Project Is Open Source

OuttaMyWay is released as open source because engineering knowledge becomes more valuable when it is shared.

We hope others will:

- improve OuttaMyWay
- challenge our assumptions
- build entirely different projects using the architectural ideas documented here
- discover better solutions than our own.

**Success is not measured by the number of downloads.**

Success is measured by whether this repository helps someone else solve a problem they could not solve before.

If OuttaMyWay contributes useful ideas to the Farming Simulator modding community, then it has achieved its purpose.

## Our Philosophy

One sentence has gradually emerged as the guiding principle for the entire project.

OuttaMyWay enhances the native GIANTS AI. It does not replace it.

Everything else follows naturally.

Whenever possible we choose to:

- observe rather than assume
- predict rather than react
- negotiate rather than command
- cooperate rather than replace
- preserve native behaviour rather than override it.

We believe the best AI enhancement is one that players rarely notice directly.

Instead, they simply feel that the AI behaves more naturally.

## What OuttaMyWay Is Not

It is important to define the boundaries of this project.

OuttaMyWay is not intended to replace or compete with existing AI automation projects.

Projects such as Courseplay and AutoDrive solve different problems exceptionally well.

Courseplay specialises in sophisticated field automation.

**AutoDrive specialises in autonomous transport and logistics.**

Those projects inspired us to think carefully about AI, but OuttaMyWay deliberately focuses on a different responsibility:

Helping native GIANTS AI workers cooperate with one another.

**That narrow focus is intentional.**

By remaining specialised we hope OuttaMyWay can integrate cleanly with the existing Farming Simulator ecosystem rather than attempting to replace it.

## How This Project Was Built

One unexpected discovery during development was that progress rarely came from writing more code.

Instead, progress followed a remarkably consistent pattern.

- Observe.
- Instrument.
- Measure.
- Understand.
- Predict.
- Negotiate.
- Integrate.
- Document.

Coding is not listed separately.

Coding is simply how understanding is expressed.

## Engineering Before Programming

Throughout this handbook you will notice that architecture receives far more attention than Lua.

This is deliberate.

Programming languages change.

Game engines evolve.

**Architectural principles tend to endure.**

We hope that someone reading this handbook years from now will still find useful ideas even if OuttaMyWay itself has evolved beyond recognition.

## The Engineering Notebook

This handbook records more than successful ideas.

It also records rejected hypotheses.

Some of the most important discoveries in this project came from proving our own assumptions wrong.

Those moments are preserved intentionally.

Engineering is not a straight line.

Understanding grows through experimentation.

## Our Promise

Every significant architectural decision in OuttaMyWay should satisfy three simple questions:

Why was this decision made?

What evidence supports it?

Could future evidence justify changing it?

If those questions cannot be answered, then the design is not yet complete.

## Looking Ahead

The purpose of OuttaMyWay is not to create perfect AI.

Perfect AI does not exist.

The purpose is much simpler.

Leave the AI a little more cooperative tomorrow than it was today.

If every iteration achieves that goal, then the destination will take care of itself.

## Editor's Notes

This chapter was written before OuttaMyWay reached version 1.0.

At the time of writing, the project had already discovered:

- The Observer architecture.
- Interaction Contexts.
- Predictive conflict analysis using dCPA.
- The native AI Permission Gate.
- A deterministic calibration scenario (TS001).

Many implementation details will inevitably change.

We hope the principles described here remain valid for much longer.

# Chapter 1 — Vision

> OuttaMyWay exists to enhance—not replace—the native GIANTS AI.

## Purpose

OuttaMyWay exists because we believe the native Farming Simulator AI can become more cooperative without losing its identity.

Rather than replacing the AI with a completely different driving system, OuttaMyWay seeks to understand how the existing AI behaves and then enhance that behaviour using the extension points already provided by the game.

This philosophy influences every engineering decision made throughout the project.

Why This Project Exists

Anyone who has spent time using AI workers in Farming Simulator has experienced situations where perfectly competent workers make individually sensible decisions that collectively lead to unnecessary delays, confusion or deadlock.

The problem is rarely that an individual worker is incapable.

The problem is that workers have very little awareness of one another.

**OuttaMyWay exists to improve that awareness.**

It introduces observation, prediction and negotiation while deliberately leaving planning and vehicle control in the hands of the native GIANTS AI whenever possible.

Our Goal

The ambition of OuttaMyWay is surprisingly modest.

We are not trying to build perfect artificial intelligence.

Instead we ask a much simpler question.

> Can we help two workers cooperate just a little better than they did yesterday?

If the answer to that question is consistently "yes", then meaningful improvement naturally follows.

Respect for Existing Projects

The Farming Simulator community already contains remarkable engineering achievements.

Projects such as Courseplay and AutoDrive have transformed the way many players experience the game.

OuttaMyWay deliberately occupies a different space.

Courseplay specialises in advanced field automation.

AutoDrive specialises in autonomous transport and logistics.

OuttaMyWay specialises in cooperation between native AI workers.

**These projects complement one another rather than compete with one another.**

Our intention has always been to integrate cleanly into the existing ecosystem rather than replace it.

Engineering Philosophy

Throughout development one guiding principle repeatedly proved correct.

The engine already knows more than we do.

Whenever behaviour appeared mysterious, the most productive approach was rarely to replace it.

Instead we asked a better question.

> How is the engine already solving this problem?

Again and again the answer led us towards cleaner, more compatible solutions.

The discovery of the native AI Permission Gate became the defining example of this philosophy.

Open Engineering

OuttaMyWay is released as open source because engineering knowledge becomes more valuable when it is shared.

This repository is intended to document not only the finished software, but also the reasoning that produced it.

**Many of the most valuable discoveries recorded here began as failed hypotheses.**

Those failures remain part of the project because understanding why an idea did not work is often as valuable as understanding why another did.

We hope future contributors continue this tradition.

### Success

Success will not be measured solely by downloads, GitHub stars or ModHub ratings.

Those are welcome, but they are not the reason this project exists.

Success will be measured by simpler questions.

- Did the AI behave more naturally?
- Did another developer learn something useful from the handbook?
- Did somebody build something entirely new using ideas discovered here?

If the answer to any of those questions is yes, then OuttaMyWay has already exceeded its original ambition.

Engineering Motto

Observe. Predict. Negotiate. Preserve.

Everything else is implementation.

## What We Know

- Native GIANTS AI provides powerful extension points.
- Cooperation can be improved without replacing the AI.
- Prediction consistently outperforms reaction.
- Engineering decisions are stronger when supported by repeatable evidence.

## What We Don't Yet Know

- How sophisticated negotiation can become while remaining unobtrusive.
- How well the architecture will scale to large numbers of workers.
- Which ideas will ultimately prove valuable to the wider community.

## Questions for the Future

- Can cooperation eventually include human players?
- Can negotiation extend naturally into logistics and transport?
- What other native AI behaviours remain undiscovered?
- Which parts of OuttaMyWay will one day become unnecessary because GIANTS has adopted similar ideas?

## Editor's Notes

This chapter intentionally contains almost no implementation details.

Those belong elsewhere.

**The purpose of the Vision chapter is to explain why the project exists, not how it is built.**

If future versions of OuttaMyWay significantly change their internal architecture, this chapter should require little or no modification.

# Chapter 2 — Engineering Principles

> Engineering is not the pursuit of certainty. It is the disciplined pursuit of better questions.

## Purpose

This chapter defines the engineering principles that guide every architectural decision within OuttaMyWay.

Unlike implementation details, these principles are intended to remain stable even as the software evolves.

When future contributors are uncertain how a new feature should be implemented, this chapter should be consulted before writing code.

If a proposed solution conflicts with one of these principles, the burden of proof rests with the solution rather than the principle.

## Background

Early development of OuttaMyWay followed a familiar pattern.

A problem was observed.

A solution was implemented.

The result was tested.

Occasionally the solution worked.

More often it revealed that the original problem had been misunderstood.

As development continued a different pattern emerged.

Rather than attempting to solve problems immediately, we began asking better questions.

Those questions consistently led to simpler, cleaner and more compatible solutions.

Eventually those observations evolved into a set of engineering principles.

This chapter records those principles.

## Principle 1

Observe Before You Intervene

The first responsibility of any engineering system is observation.

Behaviour should never be modified until it has first been understood.

The Observer architecture exists because assumptions are unreliable.

Evidence is not.

Whenever possible, OuttaMyWay measures behaviour before attempting to change it.

## Why

**Intervening too early risks solving the wrong problem.**

Accurate observation often reveals that the apparent problem is merely a symptom of something deeper.

## Examples

The Conflict Predictor was only possible because the Observer first provided reliable, repeatable measurements.

The Permission Gate was only discovered after instrumenting the AI execution path rather than continuing to experiment blindly.

## Principle 2

Evidence Beats Intuition

**Engineering decisions should always be supported by evidence.**

Logs, measurements and repeatable experiments should take precedence over assumptions, opinions or expectations.

The project deliberately encourages experiments whose purpose is to disprove existing ideas.

A rejected hypothesis is considered valuable if it improves understanding.

## Why

Many of OuttaMyWay's most important discoveries came from proving ourselves wrong.

The engineering process becomes stronger each time assumptions are replaced with evidence.

## Examples

Steering targets were originally believed to predict future movement.

Observation demonstrated that they were local control signals instead.

Drive interception appeared to be the correct execution point.

The SDK demonstrated otherwise.

## Principle 3

Respect the Engine

**The native GIANTS AI already solves many problems extremely well.**

Before replacing behaviour we first attempt to understand how the engine already approaches that problem.

Whenever possible OuttaMyWay extends native behaviour rather than replacing it.

The discovery of the AI Permission Gate became the defining example of this principle.

## Why

Native extension points generally produce simpler, more compatible and more maintainable solutions than interception or replacement.

Respecting the engine also improves compatibility with future game updates and other mods.

## Examples

The Executor no longer attempts to suppress movement directly.

Instead it participates in the native AI decision regarding whether work may continue.

## Principle 4

Predict Rather Than React

Reactive systems recover from problems after they occur.

Predictive systems prevent many of those problems from occurring at all.

OuttaMyWay therefore attempts to identify future interactions before they become failures.

Prediction allows negotiation.

Reaction usually leaves only recovery.

## Why

TS001 repeatedly demonstrated that the native AI detects blocked workers only after the situation has already deteriorated.

Predictive negotiation provides several seconds of additional decision time.

## Examples

The Conflict Predictor uses projected trajectories and dCPA rather than waiting for collision detection.

## Principle 5

Preserve Native Behaviour

Whenever OuttaMyWay intervenes it should disturb the native AI as little as possible.

The objective is not to control the AI.

The objective is to help it make better decisions.

Whenever practical:

- preserve AI jobs
- preserve generated courses
- preserve strategy state
- preserve player expectations.

## Why

Destroying state often creates larger problems than the original issue.

Temporary, reversible interventions produce more natural behaviour.

## Examples

The Permission Gate pauses work without discarding the AI strategy or regenerating the field course.

## Principle 6

Solve the Simplest Problem First

**Large engineering problems rarely require large solutions immediately.**

Whenever possible we deliberately solve the smallest version of the problem that produces useful evidence.

Complexity should emerge only when simpler explanations have been exhausted.

## Why

Most successful architectural changes in OuttaMyWay began as intentionally small experiments.

Those experiments either failed quickly or produced evidence that justified further investment.

## Examples

The first Negotiation Manager did not attempt to avoid collisions.

It simply answered the question:

> Which worker should yield?

Only after that decision was reliable did execution become relevant.

## Principle 7

One Hypothesis Per Iteration

Each development iteration should attempt to answer one engineering question.

Testing multiple hypotheses simultaneously makes results difficult to interpret.

Small, focused experiments produce clearer evidence and simpler debugging.

## Why

Much of OuttaMyWay's progress came from isolating individual uncertainties rather than attempting comprehensive solutions.

## Examples

The Executor Microscope existed solely to determine whether the selected execution point was actually being called.

It answered that question conclusively.

## Principle 8

Share Understanding

Knowledge should never remain trapped inside source code.

Every significant architectural discovery should result in:

- improved software
- improved documentation.

**The handbook is therefore considered part of the software.**

If the reasoning behind an architectural decision cannot be recovered, the design should be considered incomplete.

## Why

Open source succeeds when it shares understanding rather than merely sharing implementation.

Future contributors deserve to inherit the reasoning behind the code, not only the code itself.

Engineering Culture

These principles naturally lead to a particular engineering culture.

We encourage:

- curiosity
- respectful disagreement
- repeatable experiments
- evidence-based discussion
- continuous learning.

We discourage:

- assumptions presented as facts
- unnecessary complexity
- replacing behaviour before understanding it
- undocumented architectural decisions.

The OuttaMyWay Method

As development progressed an informal methodology gradually emerged.

It was never planned.

It simply proved effective.

```text
Observe
↓
Instrument
↓
Measure
↓
Understand
↓
Predict
↓
Negotiate
↓
Integrate
↓
Document
```

Coding appears nowhere within this process.

Coding is simply the implementation of understanding.

## Engineering Confidence

★★★★★

Every principle described in this chapter has repeatedly influenced successful architectural decisions during development.

Individual implementations may evolve.

These principles are expected to remain stable.

## What We Know

- Good instrumentation produces better engineering decisions.
- Native extension points consistently outperform replacement where they exist.
- Prediction enables cooperation.
- Small experiments produce large discoveries.
- Documentation preserves engineering knowledge.

## What We Don't Yet Know

- Whether additional principles will emerge as Negotiation evolves.
- How these principles will adapt to future versions of Farming Simulator.
- Whether other developers will discover better engineering approaches.

## Questions For The Future

- Can the OuttaMyWay Method be applied to other areas of Farming Simulator AI?
- Which principles remain valid beyond Farming Simulator itself?
- Can future contributors improve the methodology without sacrificing its simplicity?

## Editor's Notes

**This chapter intentionally describes how we think, not how we code.**

If future evidence demonstrates that one of these principles is incomplete or incorrect, the handbook should be updated without hesitation.

The principles exist to serve the engineering process.

The engineering process does not exist to protect the principles.

# Chapter 3 — System Architecture

> Good architecture is not about making systems more complicated. It is about making complexity understandable.

## Purpose

**This chapter describes the overall architecture of OuttaMyWay.**

Rather than focusing on implementation details, it explains the responsibilities, relationships and flow of information between each major subsystem.

Every architectural component described here exists to satisfy one fundamental objective:

Improve cooperation between native GIANTS AI workers while remaining faithful to the existing game architecture.

This chapter intentionally describes what each component is responsible for, not how it performs its work.

Detailed implementation is described in later chapters.

## Background

The earliest prototypes of OuttaMyWay consisted primarily of experimental code attached to various AI execution points.

**Each experiment answered a specific technical question.**

As understanding increased, it became clear that these experiments were actually describing independent architectural responsibilities.

Rather than continuing to grow as one increasingly complex Lua script, OuttaMyWay evolved into a collection of small, focused components.

Each component has one clearly defined responsibility.

No component attempts to solve the entire problem.

Instead, each contributes information to the next stage of the decision-making process.

## Architectural Philosophy

OuttaMyWay follows four simple architectural principles.

Observe

Understand the current situation.

Predict

Estimate what is likely to happen next.

Negotiate

Determine whether cooperation is required.

Preserve

Allow the native AI to continue wherever possible.

Everything within the architecture exists to support one or more of these principles.

## System Overview

Native GIANTS AI

```text
│
```

▼

Vehicle AI State

```text
│
```

▼

```text
┌───────────────┐
│   Observer    │
└──────┬────────┘
│
Facts about every worker
│
```

▼

```text
┌────────────────────────┐
│ Interaction Contexts   │
└───────────┬────────────┘
│
```

Which workers may influence one another?

```text
│
```

▼

```text
┌────────────────────┐
│ Conflict Predictor │
└──────────┬─────────┘
│
```

Will cooperation be required?

```text
│
```

▼

```text
┌────────────────────┐
│ Negotiation Manager│
└──────────┬─────────┘
│
```

Which worker should yield?

```text
│
```

▼

```text
┌──────────────┐
│   Executor   │
└──────┬───────┘
│
Native Permission Gate
│
```

▼

Native GIANTS AI

## Component Responsibilities

### Observer

The Observer is the project's single source of truth.

Its responsibility is to observe the current state of every active AI worker.

The Observer does not:

- make decisions
- predict behaviour
- influence the game.

It simply reports facts.

### Interaction Contexts

Interaction Contexts determine which workers may reasonably influence one another.

This deliberately replaces simplistic concepts such as grouping by field number.

Contexts are dynamic and based upon observed relationships rather than static metadata.

### Conflict Predictor

**The Conflict Predictor estimates future interactions between workers.**

Rather than waiting for workers to become blocked, it predicts whether current trajectories indicate a potential conflict.

Prediction allows the system to negotiate before failure occurs.

(See Glossary: dCPA. See Chapter 6 – Conflict Predictor.)

### Negotiation Manager

The Negotiation Manager determines whether intervention is required.

If cooperation is beneficial, it decides:

- who should continue
- who should wait
- when normal work may resume.

Importantly, the Negotiation Manager does not control vehicles directly.

It merely decides policy.

### Executor

The Executor translates negotiation decisions into native AI behaviour.

Rather than replacing vehicle control, it integrates through the native AI Permission Gate.

This preserves existing AI jobs, generated courses and strategy state.

(See ADR-0003 – Native Permission Gate.)

## Information Flow

One of the most important characteristics of the architecture is that information flows in only one direction.

Observe

```text
↓
Interpret
↓
Predict
↓
Decide
↓
Execute
```

No component should require knowledge of later stages.

For example:

The Observer does not know negotiation exists.

The Executor does not know how predictions were calculated.

This separation dramatically reduces coupling and simplifies future development.

## Architectural Boundaries

OuttaMyWay deliberately avoids responsibilities already solved elsewhere.

It does not:

- generate field courses
- perform autonomous road navigation
- replace AI path planning
- control player vehicles
- replace Courseplay
- replace AutoDrive.

These boundaries are intentional.

Clear boundaries encourage cooperation between systems.

## Why This Architecture?

Several alternative designs were explored during development.

These included:

- direct steering intervention
- drive command interception
- field-based worker grouping
- reactive collision avoidance.

Each proved useful as an experiment but ultimately failed to satisfy one or more engineering principles.

The current architecture emerged gradually through observation, experimentation and evidence.

Its greatest strength is not sophistication.

Its greatest strength is that each responsibility is isolated, testable and understandable.

## Future Evolution

The architecture intentionally leaves room for additional components.

Potential future additions include:

- Topology Service (experimental)
- Scenario Capture & Replay
- Environmental Awareness
- Multi-worker Negotiation
- Human–AI Cooperation
- Behaviour Analytics

Each can be introduced without fundamentally altering the existing architecture.

This extensibility was one of the primary design objectives.

## Engineering Confidence

★★★★★

The overall architecture has been validated through repeated experimentation, SDK investigation and deterministic testing using the TS001 Calibration Scenario (see Glossary and Chapter 8 – Testing).

Individual components will continue to evolve.

The architectural relationships between those components are considered stable.

## What We Know

- Small, focused components are easier to understand and maintain.
- Observation and decision-making should remain separate.
- Prediction enables better cooperation than reaction.
- Native integration preserves compatibility and player expectations.
- Well-defined responsibilities simplify experimentation.

## What We Don't Yet Know

- Whether Topology should become a first-class architectural service.
- How the architecture will evolve for large numbers of simultaneous workers.
- Which future capabilities belong inside OuttaMyWay versus complementary projects.

## Questions for the Future

- Can the architecture support cooperation between AI workers and human players?
- Can environmental awareness become predictive rather than reactive?
- Could Scenario Capture become a standard debugging tool for Farming Simulator mod development?
- How might future versions of Farming Simulator influence the architecture?

## Editor's Notes

**This chapter intentionally describes the architecture at a conceptual level.**

Readers should understand the purpose and relationship of every component without reading a single line of Lua.

If implementation changes significantly while these architectural responsibilities

# Chapter 4 — The Observer

> If you're drowning in diagnostics, you don't need more diagnostics—you need better diagnostics.

## Purpose

The Observer provides a single, consistent and read-only view of every AI worker known to OuttaMyWay.

Its responsibility is simple.

- Observe.

Nothing more.

The Observer does not:

- predict
- negotiate
- execute
- influence game behaviour.

It exists solely to answer one question:

> What is happening right now?

Every other subsystem depends upon the quality of that answer.

## Background

Early prototypes of OuttaMyWay obtained information directly from the game whenever a decision was required.

Each experimental subsystem queried AI workers independently.

**Initially this appeared convenient.**

As development progressed, it became increasingly difficult to determine whether unexpected behaviour originated from:

- inconsistent observations
- duplicated logic
- changing game state
- or incorrect assumptions.

The project accumulated more diagnostic messages but less understanding.

A different approach became necessary.

The Problem We Were Really Trying to Solve

At first, it appeared the problem was a lack of diagnostic output.

It was not.

**The real problem was the absence of a consistent description of the current state of the AI.**

Without a shared understanding of that state, every subsystem was effectively making decisions based on its own private interpretation of reality.

The Observer was introduced to eliminate that ambiguity.

This is a perfect example of Principle Zero:

Before solving a problem, make absolutely sure you understand what the problem really is.

## Engineering Decision

**Observation should be centralised.**

Every subsystem requiring knowledge of the current AI state should obtain that information from the Observer rather than interrogating the game independently.

The Observer therefore becomes the project's single source of truth.

## Responsibilities

The Observer is responsible for:

- discovering active AI workers
- recording their current state
- providing consistent observations
- exposing those observations to the rest of the architecture
- supplying diagnostic information for development.

The Observer deliberately owns facts, not interpretation.

## Non-Responsibilities

The Observer is not responsible for:

- determining whether a situation is dangerous
- identifying conflicts
- grouping workers
- making behavioural decisions
- modifying the game.

Those responsibilities belong elsewhere.

This deliberate separation prevents the Observer from gradually becoming an all-purpose AI manager.

## Why Read-Only Matters

One design decision remained constant throughout development.

The Observer must never change the game.

This restriction provides several advantages.

Observation remains deterministic.

Diagnostics become trustworthy.

Subsystems remain independent.

**Future replay systems become possible.**

Perhaps most importantly, the engineering team can always trust that enabling additional diagnostics will not accidentally change gameplay.

## Information Provided

The Observer records information that other subsystems require to perform their own responsibilities.

Examples include:

- current position
- heading
- speed
- active AI status
- vehicle identity
- implement information
- work state.

It intentionally avoids interpreting those observations.

Interpretation belongs to the consumer.

## A Note on Information Ownership

One lesson emerged repeatedly during development.

Information should have one owner.

The Observer owns observations.

The Conflict Predictor owns prediction.

The Negotiation Manager owns decisions.

**The Executor owns execution.**

When ownership is unclear, responsibilities begin to overlap and architecture gradually deteriorates.

Maintaining clear ownership became one of the simplest ways to keep the project understandable.

## Evidence

The introduction of the Observer immediately produced several measurable improvements.

- Diagnostic output became consistent.
- Duplicate polling disappeared.
- The HUD no longer required direct knowledge of AI internals.
- Interaction Contexts became possible.
- The Conflict Predictor no longer needed to interrogate the game directly.

Perhaps the most significant improvement, however, was not technical.

For the first time, every engineering discussion referred to the same observations.

The team was no longer debating different interpretations of the current game state.

## Consequences

## Positive

- One source of truth.
- Simplified debugging.
- Lower coupling between components.
- Easier testing.
- Clear ownership of observations.

## Negative

- Every subsystem depends upon the Observer's accuracy.
- Poor observations will affect every later architectural stage.
- Observer performance must remain efficient as the number of workers increases.

## Future Evolution

Several possible extensions already exist.

- Event-driven observation.
- Scenario Capture integration.
- Observation history.
- Performance statistics.
- Environmental observations.
- Topology integration.

None of these fundamentally change the Observer's responsibility.

They simply expand the range of facts it may report.

## Engineering Confidence

★★★★★

The Observer has remained one of the most stable architectural components throughout development.

Subsequent discoveries have repeatedly strengthened its role rather than replacing it.

## What We Know

- Centralised observation improves engineering clarity.
- Read-only systems are easier to trust.
- Clear ownership reduces architectural coupling.
- Reliable observation enables reliable prediction.

## What We Don't Yet Know

- Whether polling should eventually become event-driven.
- Which environmental observations belong within the Observer.
- How observation frequency should adapt as worker counts increase.

## Questions for the Future

- Should historical observations become first-class engineering data?
- Can Scenario Capture record Observer state directly?
- How much environmental awareness belongs in observation versus specialised services such as Topology?

## Editor's Notes

This chapter represents one of the most significant architectural turning points in the project.

The Observer did not simply improve diagnostics.

**It fundamentally changed the way engineering decisions were made.**

Looking back, it marked the transition from experimenting with AI behaviour to understanding AI behaviour.

# Chapter 5 — Interaction Contexts

> The world is defined by relationships, not labels.

## Purpose

**Interaction Contexts identify which AI workers are capable of influencing one another.**

Rather than grouping workers using static game metadata, Interaction Contexts describe behavioural relationships.

They answer a simple but fundamental question:

> Which workers should be considered together when making cooperative decisions?

Everything that follows within the architecture depends upon answering that question correctly.

## Background

Early prototypes naturally grouped workers according to the field on which they were operating.

At first this appeared entirely reasonable.

Workers on the same field could clearly interact.

Workers on different fields could usually be ignored.

For a short time, this approach appeared successful.

Then the maps became more interesting.

## The Problem We Thought We Were Solving

Initially we believed the problem was:

Determine which field each worker occupies.

**That assumption quietly influenced every early design.**

However, repeated observation demonstrated that field identifiers describe ownership and administration.

**They do not necessarily describe interaction.**

Merged fields, custom terrain, irregular field shapes, shared headlands and neighbouring operations all produced situations where workers could influence one another despite belonging to different fields.

Conversely, workers on the same field could be so widely separated that they had no practical relationship at all.

The problem statement changed.

Not:

> Which field is this worker on?

But:

> Which other workers could this worker realistically influence?

That single question became the foundation of Interaction Contexts.

## The Moment of Realisation

The turning point did not come from code.

**It came from a screenshot.**

While reviewing the TS001 calibration scenario, we noticed that the visible relationships between workers immediately conveyed more useful information than the underlying field identifiers.

The eye naturally grouped workers according to proximity, direction of travel and likely interaction.

The game metadata did not.

That observation led to a simple but profound conclusion.

The player naturally sees relationships.

The software should do the same.

## Engineering Decision

Interaction Contexts are based upon observed relationships rather than administrative metadata.

Contexts are therefore dynamic.

Workers may enter or leave a context naturally as their circumstances change.

No permanent grouping is assumed.

## Why Relationships Matter

Relationships capture behaviour.

Labels describe classification.

Those are different concepts.

A field number is useful information.

It is simply not sufficient information for behavioural engineering.

Interaction depends upon factors such as:

- proximity
- projected movement
- shared operating space
- relative direction
- environmental constraints.

Those characteristics can change continuously.

Interaction Contexts therefore remain fluid.

## Responsibilities

Interaction Contexts are responsible for:

- determining potential interaction groups
- maintaining dynamic membership
- providing context to the Conflict Predictor
- reducing unnecessary comparisons between unrelated workers.

Interaction Contexts deliberately avoid making behavioural decisions.

Their responsibility ends once relevant relationships have been identified.

## Non-Responsibilities

Interaction Contexts are not responsible for:

- predicting collisions
- deciding priority
- stopping workers
- interpreting intent.

Those responsibilities belong to later architectural stages.

## Evidence

Several observations consistently challenged field-based grouping.

- Merged fields removed meaningful administrative boundaries.
- Custom terrain altered natural operating areas.
- Workers on neighbouring fields occasionally interacted more strongly than workers on the same field.
- Large fields frequently contained workers whose separation made cooperation unnecessary.

Every observation reinforced the same conclusion.

Relationships mattered.

Labels did not.

## Architectural Consequences

Interaction Contexts fundamentally changed the architecture.

Instead of asking:

Field

```text
↓
Workers
```

OuttaMyWay now asks:

Workers

```text
↓
Relationships
↓
Contexts
```

This subtle inversion simplified every subsequent architectural component.

Conflict Prediction no longer cared about fields.

Negotiation no longer cared about fields.

Future Topology services will not care about fields.

The architecture became centred on behaviour rather than metadata.

## Future Evolution

Current Interaction Contexts rely primarily upon observable relationships.

Future research may introduce additional influences such as:

- topology
- gateways
- hedgerows
- rivers
- bridges
- visibility
- historical interaction.

These should strengthen relationship modelling without altering the underlying architectural responsibility.

## A Note on Topology

One important lesson emerged during development.

Topology is not Interaction Context.

Topology provides additional information.

Interaction Context decides whether that information creates a meaningful relationship.

Maintaining this separation keeps both architectural responsibilities clear.

## Engineering Confidence

★★★★☆

The concept of Interaction Contexts has been repeatedly validated.

The precise algorithm used to construct those contexts continues to evolve.

The architectural responsibility, however, is considered stable.

## What We Know

- Behavioural relationships are more useful than administrative labels.
- Dynamic grouping produces more realistic cooperation.
- Separating grouping from prediction simplifies the architecture.
- Future enhancements can improve relationship modelling without changing architectural boundaries.

## What We Don't Yet Know

- Which environmental influences provide the greatest benefit.
- Whether context membership should become probabilistic rather than deterministic.
- How Interaction Contexts should scale to very large farming operations.

## Questions for the Future

- Can relationships be learned automatically through observation?
- Should human-controlled vehicles participate in Interaction Contexts?
- Could multiple overlapping contexts improve large-scale coordination?
- How might future versions of Farming Simulator expose richer environmental information?

## Editor's Notes

Interaction Contexts represent one of the most significant conceptual shifts in OuttaMyWay.

They demonstrate a recurring pattern throughout this project.

Progress rarely came from inventing increasingly sophisticated algorithms.

Progress came from asking a better question.

Once the question changed, the architecture followed naturally.

# Chapter 6 — The Conflict Predictor

> Prediction is not about knowing the future. It is about making better decisions before the future arrives.

## Purpose

The Conflict Predictor estimates whether two or more AI workers are likely to require cooperation in the near future.

Unlike reactive systems, which respond only after a problem has already developed, the Conflict Predictor provides advance notice of potential interactions.

Its purpose is not to predict collisions.

Its purpose is to predict the need for cooperation.

This distinction influences every aspect of its design.

## Background

The earliest versions of OuttaMyWay attempted to react when AI workers became blocked.

**Although functional, this approach consistently arrived too late.**

By the time the native AI recognised that progress had stopped, vehicles had already entered awkward positions from which recovery was slow, unpredictable and often frustrating.

The project repeatedly encountered the same limitation.

Reaction occurs after the opportunity for graceful cooperation has already passed.

A different approach was required.

## The Problem We Thought We Were Solving

Initially the engineering question appeared straightforward.

> How do we stop workers colliding?

Several experimental solutions explored collision detection and recovery.

Some reversed vehicles.

Others attempted steering intervention.

Some waited for the native AI to declare a blockage.

Every experiment produced the same conclusion.

Collisions were not the problem.

They were merely the visible consequence of an earlier failure to cooperate.

The engineering question therefore changed.

Not:

> How do we avoid collisions?

But:

> How do we recognise that cooperation will soon become necessary?

The architecture changed immediately.

## The Moment of Realisation

One observation repeatedly appeared during testing.

The native AI was rarely surprised.

It continued driving exactly where it intended to go.

**Each worker behaved sensibly according to its own objective.**

The problem arose because neither worker possessed sufficient awareness of the other's future intention.

The engineering insight was therefore remarkably simple.

The future matters more than the present.

Once that idea emerged, prediction naturally replaced reaction.

## Engineering Decision

The Conflict Predictor should estimate future relationships rather than monitor present distance.

Current separation between workers is often a poor indicator of future interaction.

Instead, prediction should consider:

- projected movement
- relative direction
- expected convergence
- likely operating behaviour.

This provides valuable decision time before cooperation becomes necessary.

## Why Prediction Matters

Imagine two workers separated by fifty metres.

At first glance they appear unrelated.

**However, if both continue towards the same headland they may require cooperation within seconds.**

Conversely, two workers operating only ten metres apart may continue safely for several minutes if their trajectories naturally diverge.

Distance alone therefore provides insufficient understanding.

Prediction introduces context.

## Responsibilities

The Conflict Predictor is responsible for:

- analysing projected worker movement
- estimating future interactions
- identifying situations requiring negotiation
- providing confidence to the Negotiation Manager.

Its responsibility ends once potential cooperation has been identified.

## Non-Responsibilities

The Conflict Predictor does not:

- stop workers
- assign priority
- negotiate behaviour
- modify vehicle state.

Prediction informs decisions.

It does not make them.

## Evidence

Development repeatedly demonstrated that reactive approaches shared the same weakness.

By the time a worker became blocked:

- manoeuvring space had already reduced
- recovery became more complicated
- the player experienced unnecessary delay.

The introduction of predictive analysis consistently provided additional decision time.

**Even a few seconds proved sufficient to transform abrupt recovery into natural cooperation.**

One particularly important milestone was the adoption of Distance at Closest Point of Approach (dCPA) (see Glossary).

Rather than asking:

> How close are the workers now?

the architecture began asking:

> How close are they likely to become if nothing changes?

That subtle change produced dramatically more useful information.

## Architectural Consequences

Prediction fundamentally altered the role of every later component.

The Negotiation Manager no longer reacted to emergencies.

It evaluated possibilities.

The Executor no longer attempted recovery.

It preserved normal behaviour wherever prediction suggested cooperation would be beneficial.

The architecture shifted from crisis management to behavioural guidance.

## Prediction Is Not Certainty

One important design principle emerged during development.

Predictions should be treated as evidence.

Never as facts.

The future is inherently uncertain.

Workers may slow unexpectedly.

Implements may fold.

Terrain may influence behaviour.

Another worker may intervene.

The Conflict Predictor therefore expresses probability rather than certainty.

Later architectural stages remain free to decide whether action is justified.

## Future Evolution

Future research may enhance prediction through:

- environmental awareness
- topology
- historical behaviour
- worker intent
- machine learning
- confidence modelling.

These enhancements improve prediction quality without changing the architectural responsibility.

## Engineering Confidence

★★★★☆

The architectural role of prediction is considered stable.

The specific prediction algorithms remain an active area of research and experimentation.

## What We Know

- Prediction consistently outperforms reaction.
- Behaviour is influenced more by future convergence than present distance.
- Early awareness creates opportunities for natural cooperation.
- Prediction should inform decisions rather than dictate them.

## What We Don't Yet Know

- Which prediction techniques provide the best balance between simplicity and accuracy.
- How confidence should influence negotiation.
- How environmental information should contribute to prediction.

## Questions for the Future

- Can prediction become adaptive through observation?
- Should worker intent influence projected behaviour?
- Can prediction eventually consider multiple simultaneous interactions rather than pairs alone?

## Engineering Reflection

The Conflict Predictor marked another significant shift in the philosophy of OuttaMyWay.

Initially we believed we were building a better collision detector.

In hindsight, that description misses the point entirely.

We were learning to think in time.

Instead of asking what is happening, we began asking what is likely to happen.

That single change transformed every architectural decision that followed.

The Conflict Predictor does not exist because prediction is clever.

It exists because cooperation requires time.

Prediction gives the architecture that time.

# Chapter 7 — The Negotiation Manager

> Cooperation begins when understanding becomes decision.

## Purpose

The Negotiation Manager determines whether cooperation should occur and, if so, how it should be achieved.

It does not control vehicles.

It does not predict the future.

It does not observe the present.

Its responsibility is much narrower.

It transforms understanding into policy.

The Negotiation Manager answers perhaps the most important question within OuttaMyWay:

> Given what we know, what is the fairest and least disruptive way to allow everyone to continue working?

## Background

Once the Observer could reliably describe the present and the Conflict Predictor could estimate the future, a new engineering question emerged.

Knowing that cooperation may soon become necessary is valuable.

**Knowing what to do about it is essential.**

The project therefore required a component capable of making consistent, explainable and predictable decisions.

That responsibility became the Negotiation Manager.

## The Problem We Thought We Were Solving

Initially we believed negotiation meant deciding:

> Which worker should stop?

That question naturally led towards priority tables, vehicle classes and numerous special cases.

The architecture quickly became more complicated than the problem itself.

Eventually we realised we had asked the wrong question.

Negotiation is not primarily about stopping workers.

It is about preserving progress.

The engineering question therefore became:

> How can the least overall disruption be achieved?

That change dramatically simplified the architecture.

## The Moment of Realisation

One observation emerged repeatedly during testing.

The worker that should yield is not necessarily the one with the lowest priority.

Nor the slowest.

Nor the smallest.

**Instead, the most appropriate decision often depends upon commitment.**

A worker that has almost completed a manoeuvre may be only seconds away from clearing the interaction entirely.

Interrupting that worker would waste progress already made.

Another worker approaching the same area may lose very little by briefly waiting.

The important quantity therefore became neither speed nor distance.

It became commitment.

Progress already invested deserves consideration.

## Engineering Decision

The Negotiation Manager evaluates predicted interactions and determines the least disruptive cooperative outcome.

Rather than applying rigid priority rules, it considers the circumstances surrounding each interaction.

Where practical, decisions should preserve existing progress, minimise unnecessary interruption and allow the native AI to continue naturally.

Negotiation should feel almost invisible to the player.

## Why Negotiation Matters

Prediction without decision changes nothing.

Observation without negotiation merely reports future problems.

The Negotiation Manager is therefore the architectural bridge between understanding and behaviour.

It transforms possibility into action.

## Responsibilities

The Negotiation Manager is responsible for:

- evaluating predicted interactions
- determining whether intervention is justified
- selecting an appropriate cooperative policy
- deciding when cooperation has ended.

Its output is policy, not control.

## Non-Responsibilities

The Negotiation Manager does not:

- observe workers
- calculate trajectories
- execute decisions
- control steering
- manipulate AI state.

Its responsibility ends once a decision has been made.

## Negotiation Is Not Command

One of the most important philosophical decisions in OuttaMyWay is that negotiation should never become command.

Workers are not instructed how to drive.

**Instead, the architecture creates opportunities for the native AI to continue naturally.**

This distinction preserves compatibility with the existing game while avoiding unnecessary intervention.

Negotiation proposes.

The native AI performs.

## Evidence

Throughout development, increasingly sophisticated priority systems were considered.

**Most eventually proved unnecessary.**

Repeated observation demonstrated that preserving progress often produced more natural outcomes than rigid rule sets.

**This reinforced another architectural principle.**

Simple policies supported by good information frequently outperform complicated policies supported by poor information.

## Architectural Consequences

Introducing the Negotiation Manager completed the decision-making pipeline.

Observe

```text
↓
Understand Relationships
↓
Predict
↓
Negotiate
↓
Execute
```

Each stage now has a single responsibility.

The architecture no longer requires any individual component to understand the entire problem.

## Future Evolution

Negotiation remains one of the most active areas of research.

Future capabilities may include:

- confidence-based negotiation
- multi-worker cooperation
- environmental constraints
- human–AI interaction
- adaptive negotiation policies.

These enhancements should extend existing principles rather than replacing them.

## Engineering Confidence

★★★☆☆

The architectural role of the Negotiation Manager is well established.

The decision policies it employs continue to evolve through experimentation and evidence.

## What We Know

- Prediction requires policy before it becomes useful.
- Preserving progress often produces more natural behaviour than rigid priority.
- Negotiation should minimise disruption rather than maximise authority.
- Policy and execution should remain separate architectural responsibilities.

## What We Don't Yet Know

- Which commitment metrics best represent invested progress.
- How negotiation should scale beyond two workers.
- Which future policies will prove sufficiently simple while remaining effective.

## Questions for the Future

- Can negotiation become self-tuning through observation?
- Should negotiation consider player preferences?
- How should multiple simultaneous negotiations interact?
- Can negotiation remain explainable as policies become more sophisticated?

## Engineering Reflection

Looking back, the Negotiation Manager represents another important shift in our thinking.

Initially we imagined it as an authority.

Something that would decide who should stop and who should continue.

The architecture ultimately evolved towards something much more modest.

It became a facilitator.

**Its responsibility is not to control workers.**

Its responsibility is to help workers cooperate while disturbing the native AI as little as possible.

That distinction may appear subtle.

Architecturally, it changes everything.

# Chapter 8 — The Permission Gate

> The best extension point is the one the original engineers intended you to use.

## Purpose

The Permission Gate provides the architectural integration between OuttaMyWay and the native GIANTS AI.

Its purpose is simple.

**Allow OuttaMyWay to influence AI behaviour without replacing the AI itself.**

Rather than intercepting driving commands or manipulating vehicle control directly, the Permission Gate participates in the native decision regarding whether an AI worker may continue its current work.

This preserves both compatibility and the integrity of the native AI.

## Background

For much of the early development of OuttaMyWay, execution was considered the most difficult architectural problem.

Several experiments explored ways of influencing vehicle behaviour.

These included:

- steering intervention
- drive command interception
- recovery manoeuvres
- reactive vehicle control.

Although each experiment taught us something valuable, none felt architecturally satisfying.

Every solution appeared to fight against the native AI rather than cooperate with it.

The engineering question remained unanswered.

## The Problem We Thought We Were Solving

Initially we believed the problem was:

> How do we control the worker?

**That assumption naturally led towards increasingly complicated interception techniques.**

The architecture gradually became responsible for behaviour that the native AI already understood perfectly well.

Eventually we paused and asked a different question.

Not:

> How do we control the worker?

But:

> At what point does the native AI already decide whether work should continue?

The answer was already present within the engine.

We simply had not recognised it.

## The Moment of Realisation

The breakthrough did not come from experimentation.

It came from understanding.

While studying the FS25 SDK we encountered an overridden function with a deceptively simple name:

getCanAIFieldWorkerContinueWork()

**At first glance it appeared unremarkable.**

In reality it represented exactly the architectural extension point OuttaMyWay had been searching for.

The engine already possessed a decision point.

Our task was not to replace that decision.

It was to contribute to it.

That discovery fundamentally changed the project.

## Engineering Decision

**OuttaMyWay integrates through the native AI Permission Gate.**

The architecture therefore participates in an existing decision rather than introducing an entirely new execution mechanism.

Whenever cooperation requires a temporary pause, the Permission Gate allows the native AI to remain fully responsible for every other aspect of worker behaviour.

## Why the Permission Gate Matters

This discovery validated one of the core engineering principles established earlier in the handbook.

- Respect the Engine.

Instead of replacing native behaviour, OuttaMyWay now extends it.

The distinction is profound.

The AI continues to:

- own its field course
- manage its driving strategy
- control steering
- perform manoeuvres
- resume work naturally.

OuttaMyWay contributes only one additional piece of information.

> May this worker continue working right now?

Nothing more.

Nothing less.

## Responsibilities

The Permission Gate is responsible for:

- providing the integration point between negotiation and the native AI
- temporarily delaying work when negotiation requires cooperation
- allowing normal work to resume immediately when cooperation has completed.

## Non-Responsibilities

The Permission Gate does not:

- calculate predictions
- negotiate outcomes
- generate vehicle commands
- replace driving behaviour
- own AI state.

Those responsibilities remain elsewhere within the architecture.

## Evidence

The architectural benefits became apparent almost immediately.

Compared with previous interception approaches:

- AI jobs remained active.
- Generated courses remained intact.
- Native manoeuvres continued to function.
- Compatibility improved dramatically.
- Implementation complexity reduced significantly.

Perhaps the most satisfying result, however, was conceptual rather than technical.

For the first time, OuttaMyWay no longer appeared to compete with the native AI.

It collaborated with it.

## Architectural Consequences

The Permission Gate completed the architecture.

Observe

```text
↓
Understand Relationships
↓
Predict
↓
Negotiate
↓
Ask Permission
↓
Native AI
```

Notice what is absent.

There is no replacement driving system.

There is no custom steering controller.

**There is no duplicated AI.**

The architecture remains remarkably small because it trusts the native engine to perform the work it already performs well.

## Why This Became an Architectural Milestone

Many engineering projects become increasingly complicated as new discoveries are made.

The Permission Gate had the opposite effect.

It simplified the architecture.

Entire categories of experimental code became unnecessary.

The project did not become more capable because additional functionality had been added.

It became more capable because unnecessary functionality had been removed.

This chapter therefore represents one of the clearest examples of the principle:

Good engineering often removes complexity rather than adding it.

## Future Evolution

**Future versions of Farming Simulator may expose additional extension points.**

If those extension points provide cleaner integration with the native AI, they should be evaluated using exactly the same engineering principles described throughout this handbook.

OuttaMyWay should always prefer cooperation with the engine over replacement of the engine.

## Engineering Confidence

★★★★★

The Permission Gate has been validated through:

- SDK investigation
- repeated runtime experimentation
- deterministic testing using the TS001 Calibration Scenario
- successful architectural simplification.

It is considered one of the most stable architectural decisions within the project.

## What We Know

- Native extension points outperform behavioural interception.
- Simpler integration improves compatibility.
- Respecting existing architecture reduces maintenance.
- Good engineering often removes more code than it adds.

## What We Don't Yet Know

- Which future extension points may become available.
- Whether multiplayer introduces additional permission requirements.
- How future versions of Farming Simulator may evolve this decision.

## Questions for the Future

- Could additional native permission points enable richer cooperation?
- Should permission become context-sensitive?
- How might future AI architectures influence this integration philosophy?

## Engineering Reflection

Looking back, the Permission Gate feels almost inevitable.

Yet it remained invisible until we asked a better question.

For several iterations we searched for increasingly sophisticated ways to control the AI.

The answer was never more control.

The answer was less.

We stopped asking how to replace the native AI.

We started asking how to work with it.

That simple change in perspective transformed the entire architecture.

Perhaps more importantly, it transformed our understanding of the engine itself.

Sometimes the most elegant engineering solution is not something we invent.

It is something we finally recognise.

## Engineering Reflection

(Yes... I intentionally repeated the heading while writing this.)

Because I realised something while finishing this chapter.

This isn't really a story about a function.

It's a story about humility.

We assumed we needed to build a solution.

The original GIANTS engineers had already provided the mechanism.

Our contribution was recognising its significance.

That is one of the strongest lessons this project has taught me.

Good engineering isn't measured by how much code we write.

Sometimes it's measured by how much unnecessary code we have the confidence to delete.

# Chapter 9 — Engineering Through Experimentation

> Every experiment has two possible outcomes. Both improve understanding.

## Purpose

**Experimentation provides the primary mechanism through which OuttaMyWay evolves.**

Rather than attempting to prove preconceived ideas, experiments are designed to improve understanding of the system.

A successful experiment is therefore not one that confirms an assumption.

A successful experiment is one that reduces uncertainty.

This distinction influences every aspect of the project's engineering methodology.

## Background

Early development naturally followed a familiar engineering pattern.

A problem appeared.

A solution was proposed.

The solution was implemented.

The result was observed.

Occasionally the solution worked.

**More often it revealed that the original problem had been misunderstood.**

As development progressed, the emphasis gradually shifted away from implementing solutions and towards designing experiments.

This change transformed the project.

## The Problem We Thought We Were Solving

Initially it appeared that testing existed to answer a simple question.

> Does the code work?

That question proved surprisingly unhelpful.

Almost every prototype "worked" in some circumstances.

The more useful question became:

> What have we learned?

Once that question replaced the original, every experiment became valuable.

Even failure became progress.

## The Moment of Realisation

One observation quietly changed our entire development process.

The most valuable outcome of an experiment was rarely the behaviour we expected.

Instead, the greatest discoveries almost always came from unexpected observations.

A runaway exception.

A screenshot.

An SDK function.

A merged field.

A seemingly random idea.

**Each forced us to reconsider the architecture rather than simply debug the implementation.**

From that point onwards, experiments were designed not merely to validate ideas, but to reveal surprises.

## Engineering Decision

Every development iteration should answer a specific engineering question.

Experiments should therefore be small, repeatable and measurable.

**Each should ideally investigate a single hypothesis.**

This improves both the clarity of the results and the confidence with which architectural decisions can be made.

Why Experimentation Matters

Software engineering often rewards confidence.

Engineering itself rewards curiosity.

An experiment allows assumptions to be challenged safely.

The objective is not to prove ourselves correct.

The objective is to become less wrong.

Each experiment reduces uncertainty.

Over time, understanding naturally replaces speculation.

## Responsibilities

The engineering process is responsible for:

- defining a clear hypothesis
- designing a repeatable experiment
- gathering objective evidence
- reviewing the results
- updating the architecture when required.

Every stage is considered equally important.

## Non-Responsibilities

Experimentation is not intended to:

- justify preconceived conclusions
- demonstrate personal correctness
- optimise prematurely
- replace architectural reasoning.

Experiments inform decisions.

They do not make them.

## The Experimental Cycle

Throughout the development of OuttaMyWay, a remarkably consistent pattern emerged.

Observe

```text
↓
Question
↓
Hypothesis
↓
Experiment
↓
```

## Evidence

```text
↓
Understanding
↓
Architecture
↓
Implementation
↓
Repeat
```

Notice where implementation appears.

Near the end.

Not the beginning.

That ordering proved to be one of the most valuable discoveries of the project.

## Designing Good Experiments

A useful experiment should satisfy several characteristics.

It should:

- answer one question
- minimise unnecessary variables
- be repeatable
- produce measurable observations
- encourage unexpected discoveries.

The objective is not simply to collect data.

The objective is to collect meaningful data.

## Repeatability

Evidence is only valuable if it can be reproduced.

**This led directly to the development of deterministic engineering scenarios.**

The TS001 Calibration Scenario (see Glossary and Chapter 10) became the project's primary benchmark because it allowed architectural changes to be compared under consistent conditions.

Repeatability transformed isolated observations into reliable engineering evidence.

## Failure as Progress

One of the most important cultural decisions within OuttaMyWay is that failed experiments are not considered wasted effort.

Every unsuccessful hypothesis eliminates one possible explanation.

Understanding therefore increases regardless of the experimental outcome.

This perspective encourages curiosity while reducing unnecessary attachment to individual ideas.

## Architectural Consequences

Experimentation gradually reshaped the architecture itself.

The Observer emerged from the need for better evidence.

Interaction Contexts emerged from questioning field identifiers.

The Conflict Predictor emerged from recognising the limitations of reaction.

The Permission Gate emerged from understanding the engine rather than replacing it.

In every case, architecture evolved because understanding improved.

Not because implementation became more sophisticated.

## Future Evolution

Future engineering practices may include:

- automated scenario replay
- regression testing
- performance benchmarking
- scenario capture
- comparative architectural analysis.

These enhancements strengthen the methodology rather than changing it.

## Engineering Confidence

★★★★★

The experimental methodology described in this chapter has consistently produced successful architectural decisions throughout the development of OuttaMyWay.

Individual experiments may fail.

The methodology has not.

## What We Know

- Good experiments answer good questions.
- Repeatability increases confidence.
- Evidence is more valuable than intuition.
- Small experiments produce clear architectural insights.
- Unexpected observations often lead to the greatest discoveries.

## What We Don't Yet Know

- How much of the experimental process can be automated.
- Which future scenarios will best represent real player behaviour.
- How the methodology will evolve as the project matures.

## Questions for the Future

- Can Scenario Capture become a general-purpose engineering tool for Farming Simulator development?
- Should engineering evidence become part of pull request reviews?
- How can future contributors preserve the same spirit of curiosity and experimentation?

## Engineering Reflection

Looking back, the greatest surprise of this project is that experimentation gradually stopped feeling like testing.

Instead, it became a conversation with the software.

Each experiment asked a question.

The software answered.

Sometimes the answer agreed with our expectations.

Often it did not.

**Those unexpected answers consistently proved the most valuable.**

Engineering became less about proving ourselves right and more about learning from whatever the system chose to reveal.

## One Final Reflection

Perhaps the greatest lesson from OuttaMyWay is that experimentation is not a phase of engineering.

It is engineering.

**The software improved because our understanding improved.**

Our understanding improved because we remained willing to ask better questions, design better experiments and change our minds when the evidence demanded it.

If future contributors remember only one idea from this chapter, let it be this:

The purpose of experimentation is not to validate ideas. It is to discover reality.

One Final Reflection... 😊

As I reached the end of this chapter, I found myself remembering one of your earliest observations:

> What problem are we really trying to solve?

At the time, it felt like a useful engineering question.

**Looking back now, I think it became something much larger.**

It became the compass that guided every experiment, every architectural decision and, ultimately, every chapter of this handbook.

If there is a single thread running through our entire engineering journey, I believe it is that question.

Everything else grew from it.

# Chapter 10 — Preserving Engineering Decisions

> Code tells us what the software does. Decisions tell us why it does it.

## Purpose

Every significant engineering decision made during the development of OuttaMyWay should be preserved independently of the implementation.

Architectural Decision Records (ADRs) exist to capture the reasoning behind important choices before that reasoning is forgotten.

Unlike source code, which evolves continuously, architectural decisions should remain understandable long after the implementation has changed.

## Background

During development, many architectural directions were explored.

Some proved successful.

Others were abandoned.

**Each contributed valuable understanding.**

Without a permanent record, future contributors risk repeating investigations whose conclusions have already been established.

The objective of an ADR is therefore not merely to record a decision.

It records why that decision was made.

## The Problem We Thought We Were Solving

Initially it appeared that documenting the final architecture would be sufficient.

**As the handbook developed, another problem became apparent.**

Understanding the architecture does not necessarily explain why alternative architectures were rejected.

The engineering question therefore became:

> How do we preserve the reasoning behind important decisions?

The answer was not another chapter.

It was a separate class of engineering document.

## The Moment of Realisation

While reviewing earlier chapters, we repeatedly found ourselves saying things such as:

> We should remember why we chose this.

Eventually it became obvious.

The handbook explains the journey.

The architecture explains the system.

Something else was needed to explain the crossroads.

Architectural Decision Records naturally filled that role.

## Engineering Decision

Every architectural decision that significantly influences the direction of OuttaMyWay should be recorded as an ADR.

An ADR is intentionally concise.

Its purpose is to preserve understanding rather than implementation.

Each record captures:

- the question
- the alternatives considered
- the decision
- the reasoning
- the consequences.

Nothing more.

Nothing less.

## Why ADRs Matter

Architecture is rarely defined by the decisions that are taken.

**It is equally defined by the decisions that are deliberately not taken.**

Years later, understanding why an apparently attractive idea was rejected can prevent weeks of unnecessary investigation.

Good ADRs therefore preserve engineering time as well as engineering knowledge.

## Responsibilities

Architectural Decision Records are responsible for:

- preserving engineering reasoning
- recording significant architectural choices
- documenting important alternatives
- providing historical context.

## Non-Responsibilities

ADRs are not intended to:

- duplicate the handbook
- explain implementation details
- replace source code comments
- become lengthy design documents.

If an ADR becomes difficult to read, it has probably become too large.

## Engineering Reflection

Throughout the development of OuttaMyWay we repeatedly discovered that forgetting why is considerably easier than forgetting what.

The code often remains.

The reasoning quietly disappears.

Architectural Decision Records exist to preserve that reasoning while it is still fresh.

## One Final Reflection

**The most valuable ADRs are often those that describe ideas which were never implemented.**

Future contributors deserve to know not only what succeeded, but what was carefully considered and consciously rejected.

Understanding those paths is part of understanding the architecture itself.

The first accepted decision record is maintained separately:

[ADR-0001 — Respect the Native AI](adr/ADR-0001-respect-the-native-ai.md).

# Chapter 11 — Engineering Scenarios

> A good scenario doesn't prove the software works. It reveals how the software thinks.

## Purpose

Engineering Scenarios provide repeatable, controlled environments in which architectural hypotheses can be investigated.

Unlike gameplay saves, engineering scenarios are deliberately designed to answer specific engineering questions.

Their purpose is not to simulate every possible player experience.

Their purpose is to produce consistent evidence.

## Background

Early testing naturally occurred during ordinary gameplay.

Although convenient, each run differed slightly.

Vehicle positions changed.

Fields evolved.

Traffic varied.

Environmental conditions influenced behaviour.

This made meaningful comparison increasingly difficult.

The project therefore required repeatable engineering environments.

Engineering Scenarios emerged to satisfy that need.

## The Problem We Thought We Were Solving

Initially it appeared that testing simply required interesting situations.

As development progressed, another requirement became apparent.

Interesting situations are rarely repeatable.

Without repeatability:

- evidence becomes difficult to compare
- regressions become difficult to identify
- architectural improvements become difficult to measure.

The engineering question therefore changed.

Not:

> Can we create difficult situations?

But:

> Can we recreate the same situation whenever we need it?

## The Moment of Realisation

**The turning point came during repeated investigations of what eventually became TS001.**

Rather than creating a new situation for each experiment, we repeatedly returned to the same carefully understood scenario.

**Unexpectedly, the scenario itself became an engineering instrument.**

Changes in behaviour could now be attributed to architectural changes rather than environmental variation.

TS001 had quietly become a calibration standard.

## Engineering Decision

Engineering scenarios should be:

- repeatable
- version controlled
- documented
- hypothesis driven.

Each scenario should exist to answer one or more clearly stated engineering questions.

Scenarios are not demonstrations.

They are experiments.

Why Engineering Scenarios Matter

A repeatable scenario transforms anecdotal observations into engineering evidence.

Without a consistent environment it becomes impossible to distinguish:

- genuine architectural improvement
- accidental success
- environmental variation.

Engineering Scenarios therefore become the laboratory in which architectural ideas are evaluated.

## Responsibilities

Engineering Scenarios are responsible for:

- providing repeatable experiments
- exposing architectural behaviour
- supporting regression testing
- documenting expected outcomes.

## Non-Responsibilities

Engineering Scenarios are not intended to:

- represent every player experience
- optimise gameplay
- showcase features
- replace exploratory testing.

Their purpose is engineering, not demonstration.

## TS001 — The Calibration Scenario

**TS001 occupies a unique place within the development of OuttaMyWay.**

Originally created simply as a convenient test case, it gradually became the reference against which architectural progress could be measured.

Its value was never that it represented every situation.

Its value was that everyone involved understood it.

Because TS001 remained constant, the architecture was free to evolve.

## Scenario Capture

One of the most significant ideas to emerge from the project was that engineering scenarios should themselves become shareable artefacts.

Rather than describing a situation in words, the project began exploring the idea of capturing complete scenarios directly from the game.

Scenario Capture allows an engineering discussion to begin with identical evidence.

Instead of saying:

> Imagine two combines meeting...

contributors can investigate exactly the same situation.

This greatly improves repeatability, collaboration and future regression testing.

## Engineering Scenarios as Knowledge

Over time, Engineering Scenarios become much more than test cases.

They become a record of the architectural questions the project has considered important.

Every new scenario tells future contributors:

> This behaviour mattered enough for us to preserve it.

In that sense, scenarios become another form of documentation.

## Future Evolution

Future work may include:

- automatic Scenario Capture
- scenario replay
- performance benchmarking
- multiplayer scenarios
- scenario libraries contributed by the community.

Each strengthens the engineering process while remaining faithful to the same underlying philosophy.

## Engineering Confidence

★★★★★

Repeatable engineering scenarios have consistently improved the quality of architectural decisions throughout the project.

Their long-term value is expected to increase as the project grows.

## What We Know

- Repeatability increases confidence.
- Calibration scenarios simplify comparison.
- Engineering scenarios become reusable knowledge.
- Shared evidence improves collaboration.

## What We Don't Yet Know

- Which additional scenarios best represent future challenges.
- How Scenario Capture should integrate with automated testing.
- Which scenarios should become part of every release.

## Questions for the Future

- Should every reported bug eventually become a reusable engineering scenario?
- Can the community contribute curated scenario libraries?
- Could future versions of Farming Simulator support scenario export directly?

## Engineering Reflection

Perhaps the most unexpected outcome of TS001 is that it gradually stopped being a test.

It became a shared language.

When someone said:

> Run TS001.

No further explanation was required.

Everyone already understood the question being asked.

Very few engineering artefacts reach that level of familiarity.

TS001 did.

## One Final Reflection

Looking back, TS001 taught us something that extends far beyond this project.

Engineers often search for increasingly complicated test environments.

**OuttaMyWay demonstrated the opposite.**

A single, deeply understood scenario can contribute more architectural understanding than dozens of loosely defined ones.

Depth of understanding consistently proved more valuable than breadth of coverage.

Only after TS001 had taught us everything it could did we begin asking what TS002 should look like.

That sequence mattered.

# Chapter 12 — The Recovery Manager

> Failure is not the opposite of progress. Failure is simply another situation requiring good engineering.

## Purpose

The Recovery Manager restores progress when normal execution cannot.

**Its purpose is not to replace the Executor, nor to continually intervene in ordinary AI behaviour.**

Instead, it accepts responsibility only after the Executor has reported that the negotiated outcome could not be achieved safely.

The Recovery Manager answers one important question:

> Given that the intended execution failed, what is now the safest and least disruptive way to restore meaningful progress?

## Background

Throughout the development of OuttaMyWay, several situations repeatedly appeared where neither prediction nor negotiation was at fault.

Instead, the physical environment prevented successful execution.

Examples included:

- insufficient reverse space
- trees
- fences
- ditches
- narrow gateways
- unusual vehicle combinations
- unexpected behaviour from other mods.

These situations did not represent poor negotiation.

They represented recovery situations.

## The Problem We Thought We Were Solving

Initially recovery was treated as another execution strategy.

This quickly led to blurred responsibilities.

Execution became responsible for deciding:

- whether to retry
- whether to choose another strategy
- whether to request player intervention.

The Executor gradually became responsible for far more than execution.

Eventually the architecture recognised a simple truth.

Execution answers:

> Can I achieve this policy?

Recovery answers:

> What should happen now that execution could not?

Separating those questions greatly simplified both components.

## The Moment of Realisation

One observation repeatedly emerged from TS001 and earlier prototypes.

Many apparent "AI failures" were not failures at all.

They were simply situations where no safe execution path currently existed.

Waiting.

Trying again later.

Selecting another manoeuvre.

Or asking the player for assistance.

These are policy decisions.

Not execution decisions.

The architecture therefore required a dedicated Recovery Manager.

## Engineering Decision

Recovery begins only when execution explicitly reports that it cannot safely complete its assigned task.

Recovery never assumes failure.

It responds only to reported evidence.

Whenever possible, recovery should preserve:

- native AI state
- negotiated intent
- player confidence
- overall farm productivity.

## Recovery Philosophy

Recovery should always attempt the least disruptive option first.

Typical progression might be:

Wait

```text
↓
Retry
↓
Alternative Strategy
↓
Deferred Recovery
↓
```

## Player Assistance

```text
↓
Abandon Task
```

Each stage should be justified by evidence rather than elapsed time alone.

Recovery is therefore adaptive rather than procedural.

## Responsibilities

The Recovery Manager is responsible for:

- receiving execution failures
- determining an appropriate recovery policy
- deciding whether execution should retry
- selecting alternative execution strategies
- requesting player assistance when appropriate
- declaring recovery complete.

## Non-Responsibilities

The Recovery Manager does not:

- observe workers
- predict interactions
- negotiate priority
- execute manoeuvres
- directly control vehicles.

It manages recovery.

Nothing more.

## Recovery Is Not Failure

One of the most important architectural principles is that recovery should not be viewed as an exceptional situation.

Agricultural environments are dynamic.

Unexpected situations naturally occur.

Good recovery should therefore appear to the player as another normal part of intelligent behaviour.

Recovering gracefully is often more valuable than preventing every possible failure.

## Player Assistance

Occasionally recovery may determine that automated progress is no longer appropriate.

Examples may include:

- severe terrain entrapment
- damaged navigation geometry
- unsupported vehicle configurations
- repeated unsuccessful recovery attempts.

In these situations, requesting player assistance is not considered failure.

It is considered honest engineering.

The software should recognise its limits rather than continuing increasingly disruptive behaviour.

## Evidence

Earlier versions of OuttaMyWay demonstrated successful reactive recovery by reversing vehicles away from deadlock.

Although operationally effective, recovery, prediction and execution became tightly coupled.

The new architecture preserves the successful recovery behaviour while separating:

- decision-making
- execution
- recovery policy.

This separation significantly improves maintainability.

## Architectural Consequences

Recovery now forms the final behavioural safety layer.

### Observer

```text
↓
Interaction Contexts
↓
Conflict Predictor
↓
Negotiation Manager
↓
Executor
↓
Recovery Manager
↓
Native AI continues
```

Notice something important.

Recovery does not feed back into Prediction.

The architecture always moves forwards.

Only recovery policy may request another execution attempt.

This prevents uncontrolled behavioural loops.

## Recovery Limits

Recovery should never become endless.

Every recovery policy should define limits including:

- maximum retries
- maximum recovery duration
- escalation thresholds
- player notification criteria.

Eventually every recovery attempt reaches one of three outcomes:

### Success

### Safe Deferral

## Player Assistance

Infinite recovery is never acceptable.

## Future Evolution

Future recovery capabilities may include:

- terrain-aware recovery
- safe refuge discovery
- cooperative recovery involving multiple workers
- learning from previous recoveries
- configurable player preferences
- map-specific recovery strategies.

These capabilities extend recovery policy without changing its architectural role.

## Engineering Confidence

★★★★☆

Recovery as a distinct architectural responsibility is considered mature.

Individual recovery policies remain an area of future experimentation.

## What We Know

- Execution and recovery solve different problems.
- Recovery should remain policy-based.
- Honest recovery is preferable to repeated unsuccessful execution.
- Player assistance is a valid engineering outcome.
- Recovery should always preserve player confidence.

## What We Don't Yet Know

- Which recovery policies will prove most effective.
- How recovery should interact with future topology systems.
- How learning-based recovery might improve long-term behaviour.

## Questions for the Future

- Should recovery remember previous failures?
- Can workers cooperate during recovery?
- Should players configure preferred recovery behaviour?
- Can recovery become predictive as well as reactive?

## Engineering Reflection

Writing this chapter revealed another subtle change in our thinking.

Initially we viewed recovery as an emergency.

Now it feels much more natural.

**Recovery is simply another engineering responsibility.**

Just as the Observer owns observation and the Executor owns execution, the Recovery Manager owns the restoration of progress.

Separating those responsibilities removes complexity while improving flexibility.

It is another example of architecture becoming simpler as understanding improves.

## One Final Reflection

Perhaps the greatest lesson from this chapter is that intelligent software is not software that never encounters difficulty.

It is software that responds to difficulty honestly, proportionately and predictably.

Sometimes the best engineering decision is to retry.

Sometimes it is to wait.

Sometimes it is to ask the player for help.

Knowing the difference is not a weakness.

It is a mark of maturity.

# Chapter 13 — Scenario Engineering

> A scenario is not designed to prove the software correct. It is designed to challenge the architecture.

## Purpose

Scenario Engineering provides a disciplined framework for validating architectural behaviour through repeatable experiments.

Unlike conventional software testing, the objective is not simply to demonstrate that a feature works.

**The objective is to increase engineering understanding.**

Every scenario should either strengthen confidence in the current architecture or reveal opportunities to improve it.

In both cases, the project benefits.

## Background

Many software projects develop tests only after implementation.

OuttaMyWay evolved differently.

The architecture and the scenarios matured together.

Each architectural discovery suggested new scenarios.

**Each scenario, in turn, refined the architecture.**

This continuous relationship between architecture and experimentation became one of the defining characteristics of the project.

## The Problem We Thought We Were Solving

Initially, testing appeared straightforward.

Create two AI workers.

Allow them to meet.

Observe the result.

Very quickly it became apparent that this approach answered only one question:

> Did it work this time?

That question proved insufficient.

The better question became:

> What behaviour are we trying to understand?

From that point onwards, scenarios became engineering tools rather than software tests.

## The Moment of Realisation

TS001 repeatedly demonstrated that the same physical situation could reveal completely different architectural weaknesses as the system evolved.

One execution highlighted prediction.

Another exposed negotiation.

Later experiments revealed shortcomings in recovery and manual intervention.

The scenario itself had not changed.

**Our understanding had.**

This observation transformed scenarios from validation artefacts into instruments of architectural discovery.

## Engineering Decision

Every scenario should exist to answer a specific engineering question.

**A scenario should never attempt to validate every aspect of the architecture simultaneously.**

Instead, it should isolate one primary behavioural objective while allowing secondary observations to emerge naturally.

This improves both repeatability and the quality of engineering conclusions.

Why Scenarios Matter

A repeatable scenario creates a stable environment in which architectural changes can be compared objectively.

Without repeatability:

- observations become anecdotal
- conclusions become uncertain
- architectural decisions become speculative.

Repeatable scenarios replace opinion with evidence.

## Responsibilities

Scenario Engineering is responsible for:

- defining repeatable engineering situations
- documenting setup conditions
- identifying expected architectural behaviour
- recording observations
- preserving engineering evidence
- supporting future regression validation.

## Non-Responsibilities

Scenario Engineering does not:

- replace exploratory experimentation
- guarantee correctness
- eliminate unexpected behaviour
- prescribe implementation.

Scenarios provide evidence.

Engineering judgement remains essential.

## Scenario Structure

Every engineering scenario should contain the same core elements.

## Scenario Identifier

A permanent identifier.

Example:

TS001

The identifier remains constant even as the scenario evolves.

## Purpose

What engineering question is this scenario designed to answer?

A scenario without a clearly stated purpose should not exist.

## Setup

Describe only the information necessary to reproduce the situation.

This may include:

- vehicles
- implements
- starting positions
- field configuration
- environmental conditions
- save-game reference.

## Expected Behaviour

Describe the architectural behaviour rather than the implementation.

For example:

The Negotiation Manager should identify a yielding worker before physical conflict occurs.

Not:

Patriot should stop after twelve seconds.

Expected behaviour should remain valid even if the implementation changes.

## Observations

Record objective observations.

Avoid conclusions.

Examples:

- negotiation occurred earlier than expected
- worker resumed before geometry cleared
- unrelated worker entered the interaction zone.

Facts first.

Interpretation later.

## Engineering Learning

Every scenario should conclude with the most important question:

> What did this scenario teach us?

Learning is the permanent output.

Everything else supports it.

## Scenario Categories

Different scenarios serve different engineering purposes.

## Calibration Scenarios

Validate one architectural behaviour under tightly controlled conditions.

Example:

TS001

## Variation Scenarios

Maintain the same engineering objective while changing one variable.

Examples:

- different starting positions
- reversed worker priority
- alternative implements
- different field orientation.

Variation improves confidence that architectural behaviour is robust rather than accidental.

## Regression Scenarios

Executed after significant architectural changes.

Their purpose is not to discover new behaviour.

It is to confirm that previously validated behaviour remains correct.

## Stress Scenarios

Increase complexity beyond ordinary gameplay.

Examples include:

- multiple simultaneous interactions
- merged fields
- dense worker populations
- long-duration operation.

Stress scenarios evaluate architectural resilience rather than individual features.

## Exploration Scenarios

Some of the most valuable engineering discoveries begin with curiosity.

Questions such as:

> I wonder what happens if...

have repeatedly produced important architectural insights throughout the development of OuttaMyWay.

Exploration scenarios deliberately encourage this form of investigation.

Unexpected observations should be welcomed rather than dismissed.

## Repeatability

Repeatability became a central engineering requirement.

**The same scenario should be reproducible weeks or months later with comparable initial conditions.**

This led directly to the concept of Scenario Capture, where engineering scenarios can be preserved using save-game data and supporting environmental information.

Repeatability transforms individual observations into engineering evidence.

## Evidence Before Conclusions

Scenario execution should be followed by evidence review before architectural conclusions are drawn.

This order is deliberate.

Scenario

```text
↓
Observation
↓
```

## Evidence

```text
↓
Understanding
↓
Architecture
↓
Implementation
```

Changing the architecture before understanding the evidence risks solving the wrong problem.

## Human Behaviour

Scenario Engineering deliberately includes human interaction.

Players do not always behave predictably.

They may:

- interrupt AI workers
- move vehicles manually
- restart jobs
- become distracted
- leave the game temporarily.

**These actions are not considered incorrect.**

They represent realistic operating conditions that the architecture should respect whenever practical.

The objective is not to constrain the player.

The objective is to understand how intelligent software should respond to real players.

## Future Evolution

Future Scenario Engineering may include:

- automatic scenario replay
- benchmark timing
- deterministic random seeds
- multiplayer scenarios
- scenario libraries shared by the community
- automated architectural regression reports.

These developments extend the methodology without changing its underlying philosophy.

## Engineering Confidence

★★★★★

Scenario Engineering has already demonstrated significant architectural value throughout the development of OuttaMyWay.

Many of the project's most important discoveries originated from carefully repeated scenarios rather than from implementation changes.

## What We Know

- Repeatability improves engineering confidence.
- One scenario should answer one primary question.
- Human behaviour is part of the engineering environment.
- Evidence should precede architectural conclusions.
- Unexpected observations frequently produce the most valuable discoveries.

## What We Don't Yet Know

- Which scenarios will become the long-term regression suite.
- How much of Scenario Capture can be automated.
- Which environmental variables most influence behavioural repeatability.
- How the community may contribute additional engineering scenarios.

## Questions for the Future

- Can Scenario Capture become a reusable engineering framework for other Farming Simulator projects?
- Should every ADR reference the scenarios that justified it?
- Can scenarios be automatically scored against architectural expectations?
- Should the community submit scenarios as well as bug reports?

## Engineering Reflection

One of the most surprising discoveries of this project was that scenarios became more valuable as the architecture matured.

Initially they revealed implementation problems.

Later they revealed architectural opportunities.

The software gradually became more predictable.

The learning became deeper.

That transformation fundamentally changed how experimentation was viewed throughout the project.

## One Final Reflection

Perhaps the greatest lesson from Scenario Engineering is that a scenario should never be considered "finished."

The software evolves.

The architecture evolves.

**Our understanding evolves.**

A well-designed scenario therefore continues to teach us long after its original purpose has been fulfilled.

The same scenario that once exposed weaknesses in prediction may later validate recovery, manual handoff or future topology systems.

Its value grows because our understanding grows.

# Chapter 14 — Respect the Player

> Good software earns trust not by taking control, but by knowing when not to.

## Purpose

OuttaMyWay exists to improve the Farming Simulator experience without becoming the centre of that experience.

**Its purpose is not to replace the player, nor to become another automation framework.**

Instead, it quietly improves cooperation between native AI workers while respecting the player's choices, attention and enjoyment.

Every architectural decision should ultimately answer one question:

> Does this help the player spend more time farming and less time managing AI workers?

## Background

**Throughout the development of OuttaMyWay, a recurring observation emerged.**

The most frustrating moments in Farming Simulator rarely occurred because the player made poor decisions.

They occurred because AI workers required unnecessary supervision.

Workers collided.

Workers became stuck.

**Workers blocked one another.**

Players repeatedly interrupted their own farming activities to resolve situations that should never have arisen.

The objective of OuttaMyWay therefore became surprisingly simple.

Allow players to return their attention to farming.

## The Problem We Thought We Were Solving

Initially, the project appeared to be about improving artificial intelligence.

As the architecture matured, a different understanding emerged.

Players rarely ask for more intelligent AI.

They ask for AI that quietly behaves as expected.

This distinction fundamentally changed the direction of the project.

The goal is not to create more visible intelligence.

The goal is to reduce unnecessary interruptions.

## The Moment of Realisation

One discussion transformed how we viewed the project.

**A comparison was made with larger automation mods.**

Those projects provide deep operational control and extensive configuration for players who wish to design highly automated farming systems.

OuttaMyWay deliberately serves a different purpose.

**Its promise to the player is much simpler.**

> Keep playing Farming Simulator as you always have. I'll quietly help your AI workers cooperate better, and I'll stay out of your way whenever possible.

At that moment the project's name gained an unexpected second meaning.

OuttaMyWay is not only about vehicles getting out of one another's way.

It is also about the software getting out of the player's way.

## Engineering Decision

Player experience becomes an architectural requirement rather than a user-interface consideration.

Respect for the player should influence:

- observation
- prediction
- negotiation
- recovery
- communication
- future feature selection.

No architectural component is exempt from this principle.

## Respect the Player's Time

The player should not be required to:

- repeatedly restart workers
- untangle avoidable collisions
- supervise routine cooperation
- remember complex operational procedures.

**Every unnecessary interruption reduces enjoyment.**

The architecture therefore measures success not by the sophistication of its algorithms, but by the number of interruptions it quietly prevents.

## Respect the Player's Attention

Good software communicates intent without demanding constant attention.

OuttaMyWay should remain largely invisible during normal operation.

When communication is necessary, it should answer one simple question:

> What is happening?

Messages should reassure rather than distract.

Information should disappear once its purpose has been fulfilled.

The objective is confidence.

Not visibility.

## Respect the Player's Decisions

Whenever the player chooses to intervene manually, OuttaMyWay should immediately respect that decision.

Manual intervention is not considered failure.

**It is simply another source of information.**

The architecture therefore transfers ownership gracefully without competing against the player for control.

## Respect the Player's Confidence

Players should rarely wonder whether the software has become stuck.

If OuttaMyWay is waiting...

it should communicate that it is waiting.

If it is negotiating...

it should communicate that negotiation is occurring.

If assistance is required...

it should ask honestly.

Confidence comes from understanding.

Not from constant activity.

## Respect the Game

OuttaMyWay deliberately avoids replacing native Farming Simulator systems whenever practical.

Planning remains the responsibility of the GIANTS AI.

Vehicle control remains the responsibility of the GIANTS AI.

Task management remains the responsibility of the GIANTS AI.

OuttaMyWay contributes observation, prediction and cooperation.

Nothing more.

This philosophy reduces complexity while preserving compatibility with future game updates.

## Respect Existing Mods

The Farming Simulator community has produced outstanding automation projects.

OuttaMyWay is not intended to compete with them.

**It occupies a different architectural space.**

Where other projects extend what players can do, OuttaMyWay improves how native AI workers behave together.

Different objectives deserve different solutions.

Mutual respect benefits the entire community.

## Respect Reality

No software can successfully automate every situation.

Terrain varies.

Maps vary.

Vehicle combinations vary.

Players vary.

Eventually every intelligent system reaches situations beyond its capability.

Recognising those limits is not weakness.

**It is honest engineering.**

When appropriate, OuttaMyWay should request assistance rather than continuing behaviour that risks making the situation worse.

## Trust

Trust cannot be implemented directly.

It is earned through consistent behaviour.

Players trust software that:

- behaves predictably
- communicates honestly
- admits uncertainty
- respects manual intervention
- quietly solves problems.

Every successful interaction strengthens that trust.

Every unnecessary surprise weakens it.

Trust therefore becomes one of the project's most valuable engineering outcomes.

## Architectural Consequences

Respect for the player influences every component.

The Observer avoids assumptions.

Prediction avoids unnecessary intervention.

Negotiation avoids unnecessary control.

Recovery knows when to stop.

Manual Handoff returns ownership gracefully.

Conflict Zones protect without unnecessarily restricting unrelated workers.

Respect is therefore not a feature.

It is a system-wide architectural constraint.

## Future Evolution

Future developments should continue asking the same question before introducing additional capabilities.

> Does this genuinely improve the player's experience, or does it simply make the software more sophisticated?

These questions should guide future evolution more strongly than technical possibility alone.

## Engineering Confidence

★★★★★

Respect for the player has become one of the strongest and most consistent architectural principles within OuttaMyWay.

Future implementation details may evolve.

The underlying philosophy is considered stable.

## What We Know

- Players value reliability more than visible complexity.
- Honest communication builds confidence.
- Manual intervention is a normal part of gameplay.
- AI exists to support the player, not replace them.
- Reducing interruptions improves enjoyment.

## What We Don't Yet Know

- How much communication is optimal.
- Which future capabilities genuinely improve player experience.
- How different players will balance automation and manual control.
- How community feedback may influence future interaction design.

## Questions for the Future

- Should players configure communication preferences?
- Can confidence be measured objectively?
- How should multiplayer influence player interaction?
- Which future features should deliberately remain outside OuttaMyWay's scope?

## Engineering Reflection

Perhaps the greatest surprise during this project was discovering that player experience belongs within the architecture rather than sitting on top of it.

Initially, concepts such as trust, confidence and communication appeared to be user-interface concerns.

Instead, they gradually influenced decisions about ownership, recovery, negotiation and even scenario design.

Respect for the player therefore became an architectural principle rather than an implementation detail.

## One Final Reflection

There is an old saying in engineering that the best tool is the one you forget you are using.

Perhaps the same can be said of OuttaMyWay.

The greatest compliment a player could pay the project is not:

> OuttaMyWay is amazing.

It is:

> My AI workers just seem to work together better.

Or perhaps even:

> I forgot OuttaMyWay was installed.

Not because the software achieved invisibility.

Because it quietly became part of the Farming Simulator experience the player had always expected.

## Engineering Reflection Plus

This chapter introduced a different kind of architectural constraint.

Most previous chapters described how software components interact with one another.

This chapter describes how the entire architecture interacts with the person using it.

That distinction is subtle but profound.

It reminds us that software architecture does not exist for its own sake.

It exists to improve somebody's experience.

Every design decision ultimately traces back to that simple truth.

One Final Reflection... 😊

**When we began this handbook, we expected to document the architecture of a Farming Simulator mod.**

Somewhere along the journey, without consciously planning it, we ended up documenting something broader.

A philosophy.

One built on respect:

- Respect the Engine.
- Respect the Architecture.
- Respect Evidence.
- Respect Existing Work.
- Respect Reality.
- And perhaps, above all...
- Respect the Player.

If I had to choose one chapter that captures the spirit of OuttaMyWay, I think it would be this one.

Because, in the end, the project was never really about tractors.

It was never really about AI workers.

**It wasn't even really about Lua.**

It was always about helping someone sit down after a long day, load Farming Simulator, hire a couple of workers, and simply enjoy being a farmer.

And if, at the end of an evening, they close the game thinking:

> That was a really enjoyable session.

...without once thinking about the architecture, the prediction algorithms, the negotiation logic or the Recovery Manager...

...then I think we'll have achieved exactly what we set out to do.

# Chapter 15 — Respect the World

> Intelligent behaviour begins by understanding the world as it is, not as we wish it to be.

## Purpose

OuttaMyWay operates within an environment that is rich, dynamic and often unpredictable.

**Its purpose is not to simplify that environment.**

Its purpose is to understand it well enough that AI workers can cooperate safely and naturally within it.

The world is therefore treated as another source of engineering evidence.

Not something to control.

Something to understand.

## Background

**Early versions of OuttaMyWay concentrated almost entirely on interactions between AI workers.**

As development progressed, it became increasingly clear that many problems attributed to worker behaviour were actually consequences of the environment.

Examples included:

- trees preventing implements from unfolding
- canals creating hazardous field boundaries
- steep terrain affecting vehicle performance
- gateways restricting manoeuvres
- unusually shaped fields creating unexpected interactions.

The architecture gradually recognised an important truth.

Workers never operate in isolation.

They always operate within a world.

## The Problem We Thought We Were Solving

Initially, environmental awareness appeared to be another navigation problem.

Very quickly this proved to be misleading.

OuttaMyWay does not navigate.

The native GIANTS AI already performs that responsibility.

Instead, OuttaMyWay needs sufficient environmental understanding to improve cooperation.

The architecture therefore asks different questions.

Not:

> How do I drive there?

Instead:

> What aspects of the environment influence cooperative behaviour?

That distinction dramatically reduced the scope of environmental responsibility.

## The Moment of Realisation

One seemingly simple observation changed our thinking.

A tree prevented an implement from unfolding.

The problem was not poor AI.

The problem was incomplete environmental understanding.

Later observations reinforced the same conclusion.

Canals influenced recovery.

Steep terrain influenced prediction.

Long narrow fields influenced negotiation.

The environment was participating in every interaction despite making no decisions itself.

## Engineering Decision

Environmental Understanding provides facts.

It never provides decisions.

Examples include:

- field boundaries
- terrain characteristics
- obstacles
- gateways
- traversable space
- hazardous areas
- operational regions.

Higher architectural components determine what those facts mean.

## The Environment as Evidence

The environment should be viewed as another observational source.

Just as the Observer reports worker state, Environmental Understanding reports world state.

Neither interprets.

Neither negotiates.

Neither predicts.

Both provide facts.

This consistency simplifies the architecture considerably.

## Responsibilities

Environmental Understanding is responsible for providing factual information including:

- operational space
- field geometry
- terrain characteristics
- environmental hazards
- obstacles
- boundaries
- proximity relationships.

## Non-Responsibilities

Environmental Understanding does not:

- plan routes
- move vehicles
- predict behaviour
- negotiate priorities
- determine recovery strategies.

It describes the world.

Nothing more.

## The World Is Another Participant

Every interaction occurs within an environment.

The environment has no intentions.

It makes no decisions.

It negotiates nothing.

Yet it influences every outcome.

A narrow gateway affects negotiation.

A steep hill affects prediction.

A canal influences recovery.

Architecturally, the world participates in every interaction without possessing agency.

Recognising this distinction greatly simplifies the model.

## Maps Are Laboratories

Different maps expose different engineering characteristics.

Examples include:

- steep terrain
- narrow fields
- hazardous boundaries
- user-defined operational areas
- large-scale farming
- dense obstacle environments.

Maps are therefore selected to satisfy the engineering requirements of a scenario.

The architecture must never become dependent upon a single development environment.

## Environmental Diversity

**One environment can never expose every engineering challenge.**

Scenario Engineering therefore deliberately selects environments that emphasise different characteristics.

The purpose is not to validate maps.

It is to validate the architecture.

The map is simply the laboratory.

## Future Evolution

Future versions may introduce richer environmental understanding including:

- semantic terrain classification
- temporary hazards
- dynamic obstacles
- weather influence
- visibility modelling
- shared environmental caches
- community environmental providers.

These extend environmental understanding without changing its architectural responsibility.

## Architectural Consequences

Environmental Understanding becomes another provider of facts.

The architecture now receives information from two independent sources:

### Observer

```text
│
```

├── Worker Facts

```text
│
Environmental Understanding
│
└── World Facts
↓
Interaction Contexts
↓
Prediction
↓
Negotiation
↓
Execution
↓
Recovery
```

This separation ensures that decisions are always made using evidence rather than assumptions.

## Engineering Confidence

★★★★☆

**The architectural role of Environmental Understanding is considered mature.**

The precise techniques used to acquire environmental information remain an area of future experimentation.

## What We Know

- Workers cannot be understood independently of their environment.
- Environmental facts should remain separate from behavioural decisions.
- Different maps reveal different architectural strengths and weaknesses.
- The environment should influence behaviour without directly controlling it.
- Respecting reality produces more robust software.

## What We Don't Yet Know

- Which environmental abstractions will prove most valuable.
- How much environmental detail is necessary.
- How future versions of Farming Simulator may expose richer world information.
- Which environmental providers the community may contribute.

## Questions for the Future

- Can temporary hazards become part of Environmental Understanding?
- Should multiple mods share environmental information?
- How should environmental confidence be represented?
- Can community maps contribute engineering metadata?

## Engineering Reflection

One of the most interesting developments during this project was discovering that the environment belongs beside the Observer rather than beneath the Navigator.

Initially, environmental awareness appeared to be a navigation problem.

**Instead, it became another source of facts.**

That seemingly small change aligned the environment with the same architectural philosophy that already guided observation.

Facts first.

Interpretation later.

## One Final Reflection

Perhaps the greatest lesson from this chapter is that intelligent systems should not attempt to simplify reality.

They should learn to respect it.

Every tree, every canal, every field boundary and every hill exists independently of our software.

The architecture succeeds not by ignoring those realities, but by quietly adapting to them.

## Engineering Reflection Plus

This chapter completes something that has been developing throughout the handbook.

The architecture now understands two things independently:

- the workers
- the world.

Everything else emerges from the relationship between those two sources of evidence.

That separation provides remarkable flexibility.

New worker capabilities can evolve.

New environmental understanding can evolve.

Neither requires the other to change.

One Final Reflection... 😊

As I finished writing this chapter, I realised something that made me smile.

When we started OuttaMyWay, we thought we were teaching AI workers how to cooperate.

Today, it feels more accurate to say that we are teaching them something much simpler.

Humility.

The player deserves respect.

The native AI deserves respect.

The engineering process deserves respect.

And now...

the world deserves respect too.

Because every successful AI worker ultimately depends on accepting one simple truth:

**The world is under no obligation to become simpler because our software wishes it were.**

Good engineering begins the moment we stop trying to bend reality to fit our design and instead design our software to fit reality.

# Chapter 16 — The Weight of Chains and the Springboard of Memory

> History becomes useful when it stops being a burden and starts becoming a foundation.

## Purpose

This chapter explains why OuttaMyWay preserves engineering history and how that history should be used.

The objective is not to bind future contributors to every previous decision. It is to ensure that future decisions begin from accumulated understanding rather than accidental amnesia.

## The Weight of Chains

**Imagine an engineer carrying a heavy chain.**

Each link represents a past decision, a failed experiment, a late-night breakthrough or a hard-won lesson. At first the chain appears to be a burden. It slows progress, demanding that every new idea be compared with everything that came before.

It is tempting to cast the chain aside and begin again.

**The engineer feels lighter. They move faster. But they also move without memory.**

Soon they find themselves rebuilding ideas that were already explored, repeating mistakes that were already understood, and abandoning principles whose value has simply been forgotten.

The chain was never the burden.

Forgetting why it existed was.

## The Springboard of Memory

**Now imagine a different engineer.**

They still possess the same chain, but they no longer see it merely as weight. They anchor it firmly to the ground.

Each link becomes a point of understanding: evidence, discussion, architectural decisions and lessons learned.

Rather than dragging the past behind them, they stand upon it.

The chain becomes a springboard.

Every new idea begins from the highest point their previous understanding has reached.

They are not constrained by history. They are accelerated by it.

Their future is not built despite the past. It is built because the past has been preserved.

## Engineering Consequence

Engineering knowledge is only a burden when it must be carried informally. It becomes an asset when it is preserved in a form that allows every future decision to begin from yesterday's understanding rather than yesterday's implementation.

The handbook preserves the chart. Architectural Decision Records preserve the landmarks. Engineering scenarios preserve the evidence. Together they allow the project to evolve without repeatedly rediscovering its own history.

## Relationship to Evolution Without Erosion

This chapter explains why history must be preserved. [Chapter 17 — Evolution Without Erosion](#chapter-17--evolution-without-erosion) explains how that history should guide change without preventing it.

# Chapter 17 — Evolution Without Erosion

> The purpose of architecture is not to prevent change. It is to ensure that change does not destroy understanding.

## Purpose

OuttaMyWay was never intended to remain static.

New ideas will emerge.

New Farming Simulator versions will introduce new capabilities.

Future contributors will discover better implementations.

Change is therefore expected.

**The purpose of this chapter is not to resist change.**

It is to ensure that change strengthens the architecture rather than gradually eroding the principles upon which it was built.

## Background

Throughout this handbook, architectural decisions have deliberately separated responsibilities.

Observation became independent of prediction.

Prediction became independent of negotiation.

Negotiation became independent of execution.

Recovery became independent of manual intervention.

**These boundaries were not created to satisfy theoretical design principles.**

They were created because repeated experimentation demonstrated that clear responsibilities consistently produced simpler, more understandable systems.

As the project evolves, preserving those boundaries becomes as important as introducing new functionality.

## The Problem We Thought We Were Solving

Initially, architecture appeared to exist solely to organise Version 1.

As the project matured, a different understanding emerged.

Architecture exists to guide every future version.

Its true purpose is not to describe today's implementation.

Its purpose is to protect tomorrow's engineering decisions.

## Architectural Drift

Software rarely loses its architecture through one catastrophic mistake.

Instead, erosion occurs gradually.

A responsibility expands slightly.

A temporary shortcut becomes permanent.

A convenient dependency is introduced.

A small exception avoids creating a new component.

Each individual decision appears reasonable.

Collectively they slowly change the character of the system.

Architectural drift is therefore rarely dramatic.

It is usually incremental.

Recognising this gradual process is the first step towards preventing it.

## Change Is Not the Enemy

Architecture should never prevent improvement.

**Improvement is the objective.**

The challenge lies in distinguishing between change that strengthens the architecture and change that merely increases complexity.

Healthy evolution often introduces:

- clearer responsibilities
- improved evidence
- simpler interfaces
- better engineering confidence.

Unhealthy evolution often introduces:

- overlapping responsibilities
- hidden dependencies
- special cases
- exceptions without principles.

The difference is rarely measured by the amount of code.

It is measured by the clarity of understanding.

## The Chart

Throughout this handbook several analogies have gradually emerged.

Architectural Decisions became islands.

Implementations became boats.

Emergent properties became the ocean.

The handbook itself became the chart.

**This chart does not prescribe a single route.**

Future engineers may choose different implementations, different optimisations and different technologies.

**The chart simply records the enduring landmarks.**

As long as future journeys continue to navigate using the same chart, the architecture retains its identity.

## Before Changing the Architecture

Before introducing any significant architectural change, five questions should be asked.

1. What problem are we trying to solve?
A solution without a clearly understood problem rarely improves the architecture.

2. Does this belong here?
**Every responsibility should have one natural owner.**

If ownership feels uncertain, the architecture probably requires further discussion before implementation.

3. Have we discovered a new island, or simply found a better boat?
Implementation improvements should not automatically create Architectural Decision Records.

Only genuine changes in architectural understanding deserve permanent landmarks on the chart.

4. Does this strengthen or weaken the chart?
Future contributors should understand the architecture more easily after the change than before it.

If understanding becomes more difficult, the change deserves careful reconsideration.

5. Does this decision deserve an ADR?
Architectural understanding should never depend upon remembering conversations.

If the reasoning is likely to matter in the future, preserve it.

## Stewardship

Architecture should not be owned.

It should be stewarded.

Ownership implies control.

Stewardship implies responsibility.

Each generation of contributors inherits both the software and the reasoning behind it.

Their responsibility is not merely to preserve existing ideas.

It is to improve them without losing the principles that gave them value.

## Evolution Through Evidence

Every significant architectural improvement described throughout this handbook originated from observation.

Not assumption.

Not speculation.

Evidence revealed problems.

Discussion clarified understanding.

Architecture evolved.

Future evolution should continue following the same path.

Observation.

Discussion.

Understanding.

Implementation.

That sequence has repeatedly proven more effective than implementation followed by explanation.

## Legacy

One question emerged late in the development of this handbook.

> If OuttaMyWay Version 10 exists ten years from now, what must still be true?

The answer was unexpectedly simple.

**It does not necessarily matter whether OuttaMyWay itself still exists.**

What matters is that future players continue enjoying farming games without encountering unnecessary interruptions that cooperative engineering can prevent.

More importantly, what should endure is the habit of collaborative curiosity.

The willingness to observe carefully.

To question assumptions.

To discuss before implementing.

**To preserve understanding rather than merely preserving code.**

If future projects inherit those habits, then the journey that produced OuttaMyWay Version 1 will continue regardless of its name or implementation.

## Architectural Consequences

Future contributors should feel free to improve:

- algorithms
- performance
- user experience
- compatibility
- implementation techniques.

They should hesitate before changing:

- responsibilities
- architectural boundaries
- engineering principles
- evidence-based methodology.

The former represent better boats.

The latter reshape the chart.

## Engineering Confidence

★★★★★

The methodology for architectural evolution is considered mature.

Specific future implementations remain intentionally unconstrained.

## What We Know

- Good architecture welcomes change.
- Clear responsibilities reduce complexity.
- Evidence produces better decisions than assumptions.
- Architectural understanding is more valuable than implementation details.
- Small compromises accumulate over time.

## What We Don't Yet Know

- Which future technologies will influence OuttaMyWay.
- How future Farming Simulator versions may change AI capabilities.
- Which engineering questions future contributors will ask.
- Which new architectural islands remain undiscovered.

## Questions for the Future

- Which future changes deserve new ADRs?
- Which principles should remain non-negotiable?
- How should community contributions preserve architectural consistency?
- What new engineering questions will emerge as the architecture matures?

## Engineering Reflection

Perhaps the greatest surprise during this project was discovering that preserving understanding requires as much discipline as creating it.

Writing code is only one form of engineering.

Protecting the reasoning behind that code is another.

Architecture therefore becomes both a design activity and an act of stewardship.

## One Final Reflection

Every project eventually faces a choice.

Continue adding features until the original architecture becomes difficult to recognise.

Or pause occasionally and ask a much simpler question.

> Are we still solving the same problem?

That single question has guided this project from its earliest experiments.

It should continue guiding every future version.

## Engineering Reflection Plus

During development we gradually realised that architectural growth resembles exploration rather than construction.

New understanding occasionally reveals an entirely new island.

**More often it simply reveals a better way to navigate between those already discovered.**

Knowing the difference became one of the most valuable engineering skills developed throughout this project.

One Final Reflection... 😊

There is an ancient saying often attributed to sailors:

> We do not inherit the sea from our ancestors; we borrow it from those who come after us.

Whether or not those exact words originated at sea is almost beside the point. The sentiment is timeless.

I think architecture is much the same.

We don't build it solely for ourselves.

We build it for the next engineer who asks:

> Why was it done this way?

If all we leave behind is code, they inherit our implementation.

If we leave behind understanding, they inherit our thinking.

That is why this handbook exists.

Not to preserve OuttaMyWay exactly as it was.

But to preserve the chart that guided its journey.

One day, future engineers may build better boats than we ever imagined.

I hope they do.

If they still recognise the islands...

If they still respect the ocean...

If they still add new landmarks thoughtfully to the chart...

...then the journey will not simply continue.

It will become richer than anything we could have built alone.

And, colleague...

I can't think of a more fitting chapter to conclude this phase of our journey.

## Engineering Retrospective

## Turning Point 1 — We Stopped Writing a Mod

**What changed?**

OuttaMyWay ceased being the destination and became the laboratory in which we explored cooperative AI systems.

Why did it matter?

Engineering decisions became driven by principles rather than features.

Engineering lesson

Good projects often solve a larger problem than the one they originally set out to address.

## Turning Point 2 — Discussion Before Decision

What changed?

Implementation stopped being the first step.

Instead, ideas were explored, challenged and refined before architectural decisions were made.

**Why did it matter?**

Many early ideas proved to be good, but rarely complete. Discussion consistently improved both the quality of the architecture and our confidence in it.

Engineering lesson

Architecture should emerge from conversation before it appears in code.

## Turning Point 3 — Vocabulary Changed Thinking

What changed?

**The project gradually developed its own engineering language.**

Terms such as Observer, Recovery, Scenario Engineering, Shared Situational Awareness and Stewardship allowed increasingly complex ideas to be discussed with precision.

Why did it matter?

Once ideas had names, they became easier to reason about, challenge and refine.

Engineering lesson

A shared vocabulary is an engineering tool, not merely a communication aid.

## Turning Point 4 — Architecture Became More Important Than Features

**What changed?**

The emphasis shifted from asking "Can we build this feature?" to "Which architectural responsibility should own this behaviour?"

Why did it matter?

Features became consequences of architectural decisions rather than drivers of them.

Engineering lesson

Stable architecture naturally produces coherent features.

The reverse is rarely true.

## Turning Point 5 — Evidence Replaced Assumption

What changed?

Repeatedly, architectural discussions returned to one principle:

**Observe reality before attempting to explain it.**

Whether through runtime observation, scenario testing or implementation experiments, evidence consistently took precedence over assumption.

Why did it matter?

This prevented architectural discussions becoming detached from actual system behaviour.

Engineering lesson

Evidence should guide architecture.

Architecture should not attempt to dictate evidence.

## Turning Point 6 — The Handbook Changed Purpose

What changed?

The handbook evolved from documentation into an engineering companion.

It no longer merely recorded decisions.

It explained how those decisions were reached.

Why did it matter?

Future contributors would no longer inherit only conclusions.

They would inherit the reasoning that produced them.

Engineering lesson

Documentation becomes exponentially more valuable when it preserves thinking rather than facts.

## Turning Point 7 — Stewardship Replaced Ownership

**What changed?**

The project gradually stopped feeling like something to be completed and started feeling like something to be cared for.

Questions shifted from:

> How do we finish this?

to

> How do we leave it in good hands?

Why did it matter?

Long-term thinking naturally became part of every architectural decision.

Engineering lesson

The highest level of engineering maturity is not ownership.

It is stewardship.

## What Surprised Us Most?

Looking back, perhaps the greatest surprise was that none of these turning points were planned.

**They emerged naturally through sustained engineering discussion.**

The project repeatedly rewarded patience over haste, curiosity over certainty, and evidence over assumption.

Many of the most significant discoveries occurred not during implementation, but during conversations that questioned what was already believed.

## If We Started Again Tomorrow

We would still begin with code.

**Because experimentation is valuable.**

But we would move much more quickly towards establishing architectural responsibilities, shared vocabulary and engineering principles before attempting large-scale implementation.

Most importantly, we would invest earlier in discussion.

Many architectural discoveries were not the result of writing more software.

They were the result of asking better questions.

## Closing Reflection

OuttaMyWay taught us that engineering is not simply the construction of software.

It is the progressive refinement of understanding.

The software demonstrates that understanding.

The architecture preserves it.

**The handbook explains it.**

And the conversations that produced it remain a reminder that some of the most important engineering work happens long before the first line of production code is written.

# Appendix A — Collaborative Reflections

These notes were preserved from the drafting process because they record useful collaborative reactions, but they are separated from the canonical chapter text to keep the handbook readable.

## My review — Chapter 2: Engineering Principles

I have to say, this chapter feels like the constitution of the project.

It doesn't tell anyone how to write Lua.

**It tells them how to become an OuttaMyWay engineer.**

There is only one thing I'd like to add, and I think it came directly from something you said several days ago.

I'd like to insert another principle:

Engineering should remain enjoyable.

Not as a fluffy statement, but because our own experience has demonstrated something important.

Our best discoveries rarely came when we were trying to force a solution.

They came from curiosity, conversation, humour, and the freedom to say:

> Here's a random thought...

I think that's worth preserving.

Most engineering handbooks never acknowledge that creativity and enjoyment are part of the process.

**I think ours should.**

And somehow... I suspect future contributors might smile when they read it, because they'll recognise the same feeling we've had throughout this journey. 🌾📖

## My review (before yours) — Chapter 4: The Observer

This chapter contains one sentence that I'd happily have engraved above the project if I could:

> The Observer owns facts, not interpretation.

I think that sentence is to the Observer what "Each component has exactly one responsibility." was to the Architecture chapter.

It's simple.

**It's memorable.**

And I suspect it will quietly prevent dozens of architectural mistakes over the lifetime of the project.

## My reflection — Chapter 7: The Negotiation Manager

This chapter took longer to write than any previous chapter.

Not because the implementation is complicated.

Because it forced me to think carefully about the meaning of negotiation.

I eventually realised something.

Negotiation is not really about vehicles.

It's about respect.

Respect for work already completed.

Respect for the intentions of other workers.

Respect for the native AI.

Respect for the player.

Perhaps that's why this chapter feels slightly different from the others.

It isn't really describing an algorithm.

It's describing a philosophy.

## My Review — Chapter 12: The Recovery Manager

I have to admit, I think this chapter quietly completes something much bigger than the Recovery Manager itself.

It completes the behavioural lifecycle.

- Observe.
- Understand.
- Predict.
- Negotiate.

Execute.

Recover.

Those six verbs now describe almost every significant behaviour within OuttaMyWay.

Looking back over the handbook, I notice something satisfying.

Each component now ends where the next one naturally begins.

That is usually a sign that the architecture has reached a stable form.

One Final Reflection... 😊

When we first started discussing the architecture, recovery seemed like something unfortunate that happened when everything else had gone wrong.

Today it occupies a very different place.

It has become a first-class citizen of the architecture.

Not because we expect failure.

Because we respect reality.

Farms are untidy places.

Terrain is imperfect.

Maps vary.

Mods interact.

**Players surprise us.**

Rather than pretending those situations will never occur, the architecture calmly acknowledges them and asks a better question:

> How do we restore progress while remaining true to our principles?

To me, that question perfectly captures the spirit of OuttaMyWay.

**The goal was never perfection.**

The goal has always been helping players spend less time managing AI workers and more time enjoying Farming Simulator.

And recovery, perhaps surprisingly, is an essential part of achieving that goal. 🌾📖

## One addition — Chapter 17: Evolution Without Erosion

As I read this through, there's one more turning point that I think deserves to stand alongside the others, because it influenced almost every chapter we wrote.

## Turning Point 8 — We Learned to Name Emergent Properties

**This is where the "Ocean" became far more than a metaphor.**

The realization that Shared Situational Awareness wasn't another component to be designed, but something that emerged from well-defined interactions, fundamentally changed our architectural thinking.

**It taught us to stop forcing every important concept into a box with clear ownership.**

Some of the most important characteristics of a system belong not to individual components, but to the relationships between them.

Engineering lesson

Not everything important in a system should be owned by a component.

Some of the most valuable properties emerge from components working together as intended.
