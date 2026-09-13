# Testing Methodology

## 1. Purpose

**This document defines how OuttaMyWay engineering claims are challenged, how evidence strength increases, and what each validation level can and cannot establish.** It specialises [Engineering Architecture](ENGINEERING_ARCHITECTURE.md) and applies within the [Scope and Validation Envelope](SCOPE_AND_VALIDATION_ENVELOPE.md).

It owns durable validation method and evidence-strength rules. It does not own test-function inventories, CI job topology, historical pass/fail counts, Issue or pull-request chronology, scenario history, or the current implementation details of individual validation mechanisms. Those belong to `/tests`, workflow/source surfaces, the Engineering Journal, Research, Git and GitHub provenance as applicable.

> **Testing Methodology != Validation Evidence Ledger**

## 2. Validation principles

### Disprove at the Cheapest Valid Abstraction Level

Challenge a claim at the lowest-cost level capable of validly disproving it. An architectural contradiction need not be implemented; a code-walk contradiction need not consume an in-game tranche; an offline behavioural contradiction need not be rediscovered in-game.

This does not erase epistemic boundaries. Runtime-dependent claims still require runtime Reality.

### Validation Strength Must Match Claim Breadth

Evidence adequate for one fixture supports fixture-bounded conclusions unless broader evidence justifies a broader claim.

### Validation Breadth Should Lag Conceptual Stability; Validation Depth Should Not

While concepts are changing, prefer narrow fixtures with deep scrutiny. Once architecture and implementation are sufficiently stable, broaden validation systematically across the Supported Envelope.

### Failed Validation Is Evidence

A failed hypothesis or test is not wasted work. Ask: **What did we learn, and which assumption, responsibility or validation mechanism changed?** Reality remains the final architect; offline tests cannot overrule contrary field Reality.

### Validation Evidence Does Not Create Authority

Tests may demonstrate that an architecture, implementation or mechanism satisfies an asserted contract. They do not become the owner of that contract merely because they encode it.

> **Tests Are Contract Evidence, Not Contract Authority**

When a test and its governing Architecture or Specification disagree, investigate whether the implementation/test has drifted or whether Reality has disproved the governing contract. Do not silently promote the test into normative authority.

## 3. Claim and assumption traceability

A supported claim should be human-traceable through:

```text
scope / validation obligation
    -> architectural owner and material assumptions
    -> implementation-facing contract
    -> implementation owner
    -> applicable offline validation
    -> applicable in-game Reality evidence
```

The implementation-facing contract is expected to become explicit through `/spec` as Issue #141 establishes that surface. Until then, use the governing Architecture and current source responsibility directly rather than inventing a parallel requirements database.

Material assumptions and scope boundaries are indexed in [Scope and Validation Envelope](SCOPE_AND_VALIDATION_ENVELOPE.md).

## 4. Progressive Validation

The levels below are deliberate but not rigid. Architecture bench tests and thought experiments may iterate, and evidence may send work back to an earlier level.

### Level 1 — Architectural Bench Test

Challenge authority, evidence, obligations, termination, invariants, genericity, constraints and counterexamples before implementation.

This level can disprove Architecture. It cannot prove GIANTS runtime behaviour.

### Level 2 — Adversarial Thought Experiment

Challenge likely failure surfaces before code or runtime cost is paid. Useful adversarial questions include:

- missing, stale or incomplete observation;
- worker completion, restart or succession;
- player claim;
- third-worker arrival;
- configuration failure;
- unusual assembly geometry;
- competing responsibilities;
- constrained space;
- evidence contradiction or supersession; and
- loss of an assumed implementation capability.

Thought experiments expose missing contracts and counterexamples. They remain hypotheses until evidence validates the relevant Reality-dependent assumptions.

### Level 3 — Implementation / Code Walk

Trace the accepted responsibility through implementation boundaries. A typical runtime walk follows:

```text
Reality source
-> Observation
-> Situation Assessment
-> prospective selection where applicable
-> Responsibility Transition
-> Current Responsibility
-> Bounded Authority
-> Control
-> Reality
```

Look for:

- hidden or duplicated authority;
- stale implementation generations;
- literals masquerading as Architecture;
- unsupported evidence promotion;
- special-case accumulation;
- incorrect responsibility placement;
- missing failure, release or termination handling; and
- source behaviour that no longer realises the governing contract.

Use current Architecture, source responsibility naming and colocated source documentation as the primary evidence. `IMPLEMENTATION_MAP.md` may assist while it remains a transitional bootstrap surface, but it is not normative and is scheduled for retirement once `/spec` and source traceability replace its legitimate navigation role.

### Level 4 — Executable Offline Bench Validation

Executable offline validation challenges repository/source contracts and behaviour in controlled non-game environments.

Current mechanisms and fixtures are documented in [`/tests`](../tests/README.md). Their claim is bounded to the contract actually exercised: given the repository/source structure, simulated evidence, stubs and validation runtime used by the suite, the implementation satisfies the asserted offline contract.

Offline validation cannot prove that GIANTS supplies equivalent evidence, timing, physics or behaviour in-game.

#### Independent execution and CI

Ordinary repository offline suites are executed and reported independently by CI. Implementation agents remain responsible for inexpensive implementation-local sanity checks and ordinarily do not duplicate the complete repository suites merely to reproduce CI.

> **Test Visibility Is Not Test Execution Responsibility**

CI execution, engineering interpretation, repository-owner acceptance and in-game Reality validation are distinct responsibilities:

```text
implementation-local sanity check
        |
        v
independent CI execution / evidence collection
        |
        v
engineering interpretation
        |
        v
owner acceptance by merge
        |
        v
in-game Reality validation where the claim requires it
```

A green CI result proves only the contracts asserted by the executed suites. CI does not define Architecture, interpret evidence, create owner acceptance or replace runtime Reality.

#### Evidence collection and enforcement

A validation system may continue collecting independent outcomes after one sub-check fails and still produce a blocking final verdict.

> **Evidence Collection != CI Enforcement**

Preserving complete diagnostic evidence is compatible with fail-closed enforcement.

Once a suite has been reconciled against accepted production responsibility and has a clean accepted baseline, a new failure is a regression signal until investigation establishes one of the following:

- implementation regression;
- legitimate change to the governing contract;
- legitimate change to the validation mechanism or fixture; or
- invalid environmental/runtime assumptions in the validation setup.

No historical failure count is an accepted threshold.

> **Regression Authority != Runtime Reality Authority**

Offline regression authority concerns the asserted offline contract only. It does not establish equivalent GIANTS runtime behaviour.

#### Validation Runtime Contract

Repeatable offline evidence depends on materially relevant execution semantics as well as repository bytes and fixture inputs.

When interpreter build options, language compatibility modes, runtime libraries or other execution semantics materially affect the asserted contract, validation must identify and control those dependencies rather than assuming that executables with the same product name or source version are semantically equivalent.

The current executable profile and mechanism-specific requirements belong in `/tests` and workflow/source documentation.

#### Validation Dependency Must Be Causally Relevant

A blocking validation job should depend only on environment capabilities materially required to construct and execute its declared validation runtime.

A missing required compiler, interpreter capability or source dependency is a validation-environment failure. An unrelated package repository or service outage is not evidence about OuttaMyWay and should not block validation when all causally required capabilities are already available.

This principle must not be used to weaken pinned runtime semantics or skip a genuinely required prerequisite.

#### Build identity validation

> **Behaviour Regression Contract != Build Identity Contract**

Behavioural, architectural and source-structure regressions should fail because the responsibility they name changed, not merely because a new TEST build received a new version identity.

Where build identity coherence is validated, tests should read the authoritative identity owners and compare them rather than distributing the current literal through unrelated behavioural tests or runtime surfaces.

> **Identity Coherence Without Distributed Sentinels**

Exact identity-owner files and the current executable test mechanism are implementation facts, not Testing Methodology.

### Level 5 — Targeted In-Game Reality Test

Define a bounded question before spending an in-game tranche. Capture, where applicable:

```text
Question
Hypothesis
Scenario / Repeatable Reality Fixture
FS25 runtime baseline
OuttaMyWay revision
relevant configuration
required instrumentation
expected confirming evidence
expected disconfirming evidence
observations
conclusion
limits
```

“Run TSxxx and see whether it works” is not a sufficient test definition.

The test should make clear what observation could disprove the hypothesis and what claim breadth a successful run would legitimately support.

### Level 6 — Relevant Regression Portfolio

Select regressions causally:

```text
changed responsibility
-> affected assumptions / contracts
-> relevant prior scenarios / sentinels
```

Do not rerun every historical scenario ceremonially when the change cannot affect it, and do not validate a fix only against the newest failing fixture when earlier scenarios exercise the affected assumptions.

Game/runtime updates do not automatically invalidate all evidence. Revalidate affected assumptions and sentinels, broadening only when evidence warrants it.

### Level 7 — Mature Supported-Envelope Validation

Once conceptual stability is sufficient, validation should broaden systematically across the Supported Envelope using representative agronomy, assembly, configuration and spatial variation justified by reviewed evidence.

The current reviewed corpus and its machine-readable evidence are owned by [Vehicle Definition Corpus and Semantic Review](research/VEHICLE_DEFINITION_CORPUS.md) and related Research surfaces. Corpus size, composition and deferred external-definition coverage are research facts, not Testing Methodology.

Mature validation does not require every Cartesian combination and does not imply that a comprehensive static validation matrix already exists or is required. Coverage design should follow material variation and the Supported Envelope rather than combinatorial ceremony.

## 5. Repeatable Reality Fixtures

A **Repeatable Reality Fixture** is a saved in-game state selected or constructed so a materially equivalent starting condition can be rerun across implementation iterations. It controls starting Reality and improves attribution across fix/build/test cycles.

> **A Scenario is a reproducible starting Reality. A Test is a question asked of Reality using that Scenario.**

One Scenario may support several Tests. Fixture repeatability strengthens attribution; it does not increase claim breadth.

**Scenario Identity Follows Starting Reality:** a materially changed starting state should normally become a variant or new scenario rather than silently redefining its TS identifier.

The [Scenario Library](research/SCENARIO_LIBRARY.md) owns human fixture descriptions and current scenario-specific evidence.

### Scenario retention

- **Active:** deliberately retained because it serves a current discovery or regression purpose.
- **Retired:** no current validation obligation requires the saved fixture; historical findings remain valid within their recorded limits.

Saved state is a proving instrument, not necessarily permanent repository knowledge. Durable findings survive in their responsible records.

## 6. Failure-Driven Fixture Promotion

```text
coverage case
    -> satisfactory
        -> record coverage; no saved fixture required
    -> materially interesting failure / boundary
        -> investigate reproducibility
        -> preserve a Repeatable Reality Fixture when controlled repetition is useful
        -> retain as a Regression Sentinel only while ongoing value justifies it
```

- **Coverage Case:** one sampled point in the Supported Envelope.
- **Repeatable Reality Fixture:** preserved starting Reality with controlled-repetition value.
- **Regression Sentinel:** retained fixture protecting a materially important previously failed assumption or behaviour.

**Coverage breadth does not imply fixture retention. Failure-Driven Fixture Promotion** preserves a coverage case when investigation, correction or regression protection requires controlled reproduction.

A varying terrain, slope, implement family or other property becomes an architectural or validation dimension only if repeated evidence shows that it materially changes a responsibility, assumption or supported claim.

## 7. Failure interpretation and recording

Useful interpretations include:

- Architecture disproved;
- implementation defect;
- implementation / Architecture mismatch;
- invalid test assumption;
- invalid or insufficiently controlled fixture;
- insufficient instrumentation;
- validation mechanism defect;
- environment/runtime change;
- boundary-characterisation observation; and
- inconclusive evidence.

These are reasoning aids, not a mandatory enum.

Record the question, evidence, conclusion and limits in the responsible repository home. Validation Methodology owns the process; `/tests` owns executable offline mechanisms and fixtures; Research/Scenario surfaces own bounded studies and in-game fixture evidence; the Engineering Journal owns investigation/evolution evidence; Architecture and Specification own current normative meaning.

Preserve failures because they narrow uncertainty and guide later regression selection.

## 8. What each level cannot prove

- Architecture and thought experiments cannot prove engine behaviour.
- Code walks cannot prove execution or field outcomes.
- Structural tests cannot prove behavioural correctness.
- Stubbed or offline behavioural tests cannot prove equivalent GIANTS evidence or response.
- One in-game fixture cannot prove the whole Supported Envelope.
- Repetition cannot compensate for insufficient claim breadth.
- A passing test cannot enlarge the authority of the contract it exercises.

Only appropriately scoped runtime Reality evidence supports runtime-dependent claims.
