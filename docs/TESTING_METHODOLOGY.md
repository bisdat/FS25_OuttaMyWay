# Testing Methodology

## 1. Purpose

**This document defines how OuttaMyWay engineering claims are challenged, how evidence strength increases, and what each validation level can and cannot establish.** It specialises [Engineering Architecture](ENGINEERING_ARCHITECTURE.md) and applies within the [Scope and Validation Envelope](SCOPE_AND_VALIDATION_ENVELOPE.md). It is not a catalogue of test functions or scenario history.

## 2. Validation principles

### Disprove at the Cheapest Valid Abstraction Level

Challenge a claim at the lowest-cost level capable of validly disproving it. An architectural contradiction need not be implemented; a code-walk contradiction need not consume an in-game tranche; an offline behavioural contradiction need not be rediscovered in-game. This does not erase epistemic boundaries: runtime-dependent claims still require runtime Reality.

### Validation Strength Must Match Claim Breadth

Evidence adequate for one fixture supports fixture-bounded conclusions unless broader evidence justifies a broader claim.

### Validation Breadth Should Lag Conceptual Stability; Validation Depth Should Not

While concepts are changing, prefer narrow fixtures with deep scrutiny. Once architecture and implementation are sufficiently stable, broaden validation systematically across the Supported Envelope.

### Failed Validation Is Evidence

A failed hypothesis or test is not wasted work. Ask: **What did we learn, and which assumption or responsibility changed?** Reality remains the final architect; offline tests cannot overrule contrary field Reality.

## 3. Claim and assumption traceability

A supported claim should be human-traceable from scope, through its architectural owner and material assumptions, implementation owner, applicable offline validation, and applicable field Reality evidence. This is governance, not a requirement for a heavyweight requirements database. Material assumptions and scope boundaries are indexed in [Scope and Validation Envelope](SCOPE_AND_VALIDATION_ENVELOPE.md).

## 4. Progressive Validation

The levels below are deliberate but not rigid; especially, architecture bench tests and thought experiments may iterate.

### Level 1 — Architectural Bench Test

Challenge authority, evidence, obligations, termination, invariants, genericity, constraints and counterexamples before implementation. This can disprove architecture; it cannot prove GIANTS runtime behaviour.

### Level 2 — Adversarial Thought Experiment

Challenge missing or incomplete observation, worker completion/succession, player claim, third-worker arrival, configuration failure, unusual assembly geometry, competing responsibilities, constrained space and evidence supersession.

### Level 3 — Implementation / Code Walk

Trace accepted responsibility through source:

```text
Reality source
-> Observation
-> Situation Assessment
-> Responsibility
-> Authority
-> Control
-> Reality
```

Look for hidden authority, duplicated responsibility, stale implementation generations, literals masquerading as architecture, unsupported evidence promotion, special-case accumulation, incorrect ownership and missing release/termination handling. Use the [Implementation Map](IMPLEMENTATION_MAP.md) as the primary navigation aid.

### Level 4 — Executable Offline Bench Validation

The current mechanisms are Python structural/source-contract tests and Lua offline behavioural/conformance tests, documented in [`/tests`](../tests/README.md). Their claim is bounded to: given repository/source structure or simulated/stubbed evidence, the implementation satisfies the asserted contract. They cannot prove GIANTS supplies equivalent evidence or reacts equivalently in-game.

### Continuous Integration Execution Boundary

GitHub Actions owns ordinary execution and reporting of the repository offline
validation suites against pull-request and `main` commits. Implementation
agents retain responsibility for inexpensive implementation-local sanity checks
and ordinarily do not duplicate repository-suite execution. Tests remain
readable executable contract evidence for implementation work: **Test
Visibility Is Not Test Execution Responsibility**.

`Structural contracts` is the required blocking check on protected `main`. A
green result proves only the structural/source contract asserted by that suite;
CI does not interpret the evidence, define architecture, or create owner
acceptance. Engineering owns interpretation, and the repository owner's merge
accepts an Engineering Increment. CI cannot replace appropriately scoped
in-game Reality validation where a claim depends on GIANTS behaviour.

The `Lua offline observation (non-blocking)` job remains observational while its
known failures are being reconciled. It must preserve the raw failure outcome;
the current count must not be encoded as an accepted threshold merely to
manufacture green status. **Validation Execution Separation** and **Independent
Execution Preserves Validation Independence** distinguish implementation-local
checks, independent CI execution, engineering interpretation, owner acceptance,
and in-game Reality evidence without weakening any test to obtain green CI.

### Validation Runtime Contract

Repeatable offline evidence depends on materially relevant execution semantics as well as repository bytes and test inputs. Interpreter name or source version alone is insufficient when build-time semantic options affect the contracts exercised by the suite.

PR #24 demonstrated this for the sealed-collection harness. Stock Ubuntu LuaJIT at upstream commit `c525bcb9024510cad9e170e12b6209aedb330f83` did not honour `__pairs` and did not expose `rawlen()`, producing **239 passed / 40 failed**. Rebuilding the same source revision with `LUAJIT_ENABLE_LUA52COMPAT` changed only those interpreter semantics and restored **266 passed / 13 failed**, exactly matching the local Fedora result.

For this harness, the validation runtime therefore requires a semantic profile in which `pairs()` honours `__pairs` and `rawlen()` is available. CI should make that profile observable rather than silently assuming that any executable labelled LuaJIT is equivalent.

### Level 5 — Targeted In-Game Reality Test

Define a bounded question before spending an in-game tranche. Capture where applicable:

```text
Question
Hypothesis
Scenario / Repeatable Reality Fixture
FS25 runtime baseline
OuttaMyWay commit/version
relevant configuration
required instrumentation
expected confirming evidence
expected disconfirming evidence
observations
conclusion
limits
```

“Run TSxxx and see whether it works” is not a sufficient test definition.

### Level 6 — Relevant Regression Portfolio

Select regressions causally:

```text
changed responsibility
-> affected assumptions/contracts
-> relevant prior scenarios/sentinels
```

Do not rerun every historical scenario ceremonially when the change cannot affect it, and do not validate a fix only against the newest failing fixture when earlier scenarios exercise the affected assumptions. Game/runtime updates do not automatically invalidate all evidence: revalidate affected assumptions and sentinels, broadening only when evidence warrants it.

### Level 7 — Mature Supported-Envelope Validation

Once conceptual stability is sufficient, validation should broaden systematically across the Supported Envelope using a scope-filtered agronomy/assembly/configuration/spatial coverage model derived from the reviewed game corpus. The [Vehicle Definition Corpus](research/VEHICLE_DEFINITION_CORPUS.md) records 606 reviewed base-game definitions, 90 used primary roles and 42 used capabilities; the machine-readable corpus is under [`../research/vehicle_semantics/`](../research/vehicle_semantics/). Scope Overlay, paid DLC and modded definitions remain Deferred.

This does not require every Cartesian combination of 606 definitions and creates neither a Scope Overlay nor a validation matrix. **No current comprehensive validation matrix is implied or required by this section.**

## 5. Repeatable Reality Fixtures

A **Repeatable Reality Fixture** is a saved in-game state selected or constructed so a materially equivalent starting condition can be rerun across implementation iterations. It controls starting Reality and improves attribution across fix/build/test cycles.

**A Scenario is a reproducible starting Reality. A Test is a question asked of Reality using that Scenario.** One Scenario may support several Tests. Fixture repeatability strengthens attribution; it does not increase claim breadth. **Scenario Identity Follows Starting Reality:** a materially changed starting state should normally become a variant or new scenario rather than silently redefining its TS identifier.

The [Scenario Library](research/SCENARIO_LIBRARY.md) owns human fixture descriptions.

### Scenario retention

- **Active:** deliberately retained because it serves a current discovery or regression purpose.
- **Retired:** no current validation obligation requires the saved fixture; historical findings remain valid within their recorded limits.

Saved state is a proving instrument, not necessarily permanent repository knowledge. Durable findings survive in their responsible records.

## 6. Failure-Driven Fixture Promotion

```text
coverage case
    -> satisfactory
        -> record coverage; no saved fixture required
    -> materially interesting failure/boundary
        -> investigate reproducibility
        -> preserve a Repeatable Reality Fixture when controlled repetition is useful
        -> retain as a Regression Sentinel only while ongoing value justifies it
```

- **Coverage Case:** one sampled point in the Supported Envelope.
- **Repeatable Reality Fixture:** preserved starting Reality with controlled-repetition value.
- **Regression Sentinel:** retained fixture protecting a materially important previously failed assumption or behaviour.

**Coverage breadth does not imply fixture retention. Failure-Driven Fixture Promotion** preserves a coverage case when investigation, correction or regression protection requires controlled reproduction. A varying terrain, slope or other property becomes an architectural dimension only if repeated evidence shows that it materially changes a responsibility or claim.

## 7. Failure interpretation and recording

Useful interpretations include architecture disproved, implementation defect, implementation/architecture mismatch, invalid test assumption, invalid or insufficiently controlled fixture, insufficient instrumentation, environment/runtime change, boundary-characterisation observation, and inconclusive evidence. These are reasoning aids, not a mandatory enum.

Record the question, evidence, conclusion and limits in the responsible repository home. Preserve failures because they narrow uncertainty and guide later regression selection.

## 8. What each level cannot prove

- Architecture and thought experiments cannot prove engine behaviour.
- Code walks cannot prove execution or field outcomes.
- Structural tests cannot prove behavioural correctness.
- Stubbed Lua tests cannot prove equivalent GIANTS evidence or response.
- One in-game fixture cannot prove the whole Supported Envelope.
- Repetition cannot compensate for insufficient claim breadth.

Only appropriately scoped runtime Reality evidence supports runtime-dependent claims.
