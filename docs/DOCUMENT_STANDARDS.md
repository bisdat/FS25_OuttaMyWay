# Documentation standards

## Normative language

The terms **MUST** and **MUST NOT** define mandatory repository standards.

**MAY** identifies an intentional choice.

**SHOULD** and **SHOULD NOT** are permitted only where a legitimate class of exception exists. The standard MUST describe that exception. A repository departure from a SHOULD or SHOULD NOT rule MUST record why the stated exception applies.

Normative requirements govern engineering meaning and ownership. They MUST NOT unnecessarily prescribe presentation syntax where several equally clear representations are possible.

> **Normative on semantics; permissive on presentation.**

# `/docs` — Architecture and engineering knowledge standard

## Purpose

`/docs` owns the human-readable engineering knowledge that explains what OuttaMyWay should achieve, why its responsibilities exist, which concepts and constraints govern them, and where authoritative engineering knowledge is owned.

Architecture MUST describe the system as it should be experienced and reasoned about. It MUST NOT be derived from current implementation structure, and implementation convenience MUST NOT determine architectural boundaries.

A future engineer MUST be able to reconstruct the current architecture directly from the live documentation without reconstructing it from Git history, Issues, pull requests, test runs or source code.

`/docs` MUST remain readable as an engineering surface for humans. Machine-readable traceability MAY support it, but metadata MUST NOT replace the explanation required to understand the architecture.

## Current truth, history and evidence

Live Architecture MUST describe current accepted architecture.

It MUST NOT become a rolling history of how that architecture was discovered, tested or implemented.

Historical investigation, failed hypotheses, implementation migrations, tranche or phase chronology, individual test runs, timestamps and build-by-build evidence MUST remain in their authorised history or validation surfaces, including Git, Issues, pull requests, the Engineering Journal, research material and scenario documentation.

When Reality produces a durable conclusion that materially changes current architecture, Architecture MUST record that conclusion.

Architecture MUST NOT duplicate the evidence trail that established the conclusion.

Where validation evidence is useful to a reader, Architecture MUST route to the authoritative testing or scenario surface rather than maintain a second list of results.

## Architectural semantic roles

Architectural material MUST make its semantic role sufficiently clear that a competent reader does not have to infer whether it defines system ownership, supporting knowledge, policy or evidence.

The principal semantic roles are:

**Responsibility**  
Something the system owns or must perform.

**Specification Jurisdiction**  
A cohesive architectural boundary whose implementation-facing contract is owned by one primary Specification.

Not every Responsibility creates a Specification Jurisdiction.

**Concept**  
A named thing used to reason about the system.

**Constraint**  
A condition limiting acceptable architecture or behaviour.

**Invariant**  
A condition that MUST remain true across valid implementations.

**Evidence Rule**  
A rule governing what evidence can or cannot establish.

**Policy**  
An architectural choice or preference governing supported behaviour.

**Lifecycle**  
The valid progression, persistence or termination semantics of a Responsibility or Concept.

**External Authority**  
Something the implementation answers to but does not implement, such as current Reality.

**Deferred Responsibility**  
An accepted architectural responsibility for which implementation is explicitly not yet required.

These roles do not require identical headings or repetitive metadata on every subsection. Their meaning and ownership MUST nevertheless be locally apparent.

## Responsibility visibility

If a competent reader must infer who owns a behaviour, the Architecture is insufficiently explicit.

An implementation-bearing architectural Responsibility MUST make clear:

- what it owns;
- what it does not own where neighbouring ownership could reasonably be confused;
- its relationship to any parent or surrounding Responsibility;
- which Specification Jurisdiction owns its implementation-facing contract; and
- the primary Specification for that Jurisdiction.

Every implementation-bearing Responsibility MUST explicitly identify its primary Specification Jurisdiction.

Responsibility names MUST represent durable architectural concepts rather than current module, class, function or controller names.

A document heading is presentation and MUST NOT by itself be treated as architectural identity.

## Specification Jurisdictions

A Specification Jurisdiction MUST represent a cohesive architectural boundary that can be understood, changed and debugged as one implementation-facing contract.

Every Specification Jurisdiction MUST be explicitly named and declared by its authoritative Architecture. A Specification Jurisdiction MUST NOT be inferred solely from document structure, headings, source topology or implementation placement.

Every implementation-bearing architectural Responsibility MUST belong to exactly one primary Specification Jurisdiction.

A Jurisdiction MAY contain several subordinate Responsibilities, Concepts, Constraints, Invariants, Evidence Rules, Policies or Lifecycles when they form one cohesive implementation-facing contract.

A Concept, Constraint, Invariant, Evidence Rule, Policy or Lifecycle MUST NOT create a separate Specification Jurisdiction solely because it is separately named, separately headed or separately implemented.

Jurisdiction boundaries MUST follow semantic cohesion rather than:

- Markdown heading count;
- source-file count;
- implementation directory structure;
- class boundaries;
- function boundaries; or
- document length.

A broad architectural subject MAY contain several Specification Jurisdictions when it contains genuinely independent implementation-facing contracts.

The number and boundaries of Jurisdictions MUST be discovered from Architecture rather than imposed from repository structure.

Specification Jurisdictions MUST NOT overlap in primary contract ownership. A specialised Jurisdiction MAY depend upon or specialise a contract owned by another Jurisdiction, but it MUST reference that contract rather than independently restate or claim its normative ownership.

## Architecture-to-Specification traceability

Every implemented Specification Jurisdiction MUST have exactly one primary Specification owner.

Every primary Specification MUST identify exactly one governing Specification Jurisdiction.

Every governing Jurisdiction MUST provide a discoverable route to its primary Specification.

The corresponding Specification MUST provide a reciprocal route to its primary architectural authority.

The preferred traceability chain is:

```text
/docs
architectural meaning
        ⇅
/spec
implementation contract
        ⇅
/scripts
implementation mechanism
```

For an implemented Specification Jurisdiction, Architecture MUST route implementation-facing navigation through `/spec`.

Architecture MAY additionally link directly to source when that source relationship is itself architecturally meaningful. Such a direct link MUST NOT replace the primary `/docs → /spec → /scripts` traceability path.

Architecture MUST NOT duplicate ordinary source placement, helper topology, APIs or current implementation mechanics. Those belong to `/spec`, generated implementation reference, source documentation or another explicitly authorised implementation surface.

A Specification MAY cite several architectural sections. It MUST distinguish its **Primary Architecture Authority** from related architectural context.

Traceability MUST replace duplicated authority. `/spec` MUST NOT require Architecture to restate implementation mechanics, and Architecture MUST NOT require `/spec` to duplicate architectural prose merely to remain navigable.

### Bounded standards-adoption exception

Existing live material that predates a required documentation surface MAY temporarily identify its primary traceability target as **pending migration** only while one explicit repository migration owns creation of that surface.

This exception exists solely to permit orderly adoption of this standard without manufacturing empty or speculative artifacts. While the exception applies:

- it MUST NOT be used for a newly introduced Responsibility or Specification Jurisdiction;
- the affected material MUST identify the active migration authority;
- the intended primary Jurisdiction ownership MUST remain explicit even when the target Specification does not yet exist;
- placeholder or empty Specifications MUST NOT be created solely to satisfy structural conformance; and
- the pending marker MUST be removed once the migration establishes the required surface.

This is a migration mechanism, not an alternative steady state. A repository-wide standards adoption MUST define a closure condition after which this exception no longer applies.

## Deferred responsibilities

Current implemented Architecture MUST NOT carry an `implemented` status marker merely to confirm the normal state.

Implementation is the normal expectation for live implementation-bearing Architecture.

An explicit implementation status MUST be used only when the exception is architecturally meaningful, for example:

```text
Status: Not implemented
```

A recognised Deferred Responsibility MAY therefore exist in current Architecture without an implementation Specification.

An empty or speculative Specification MUST NOT be created solely to satisfy structural symmetry.

## Cross-jurisdiction relationships

An architectural rule MAY legitimately govern more than one Specification Jurisdiction.

Such knowledge MUST have one authoritative architectural owner.

Affected Specifications MUST reference that owner rather than independently restating the same normative rule.

Cross-jurisdiction relationships MAY be illustrated with tactical flowcharts when the flow materially improves understanding of responsibility boundaries, handoffs or authority direction.

For example:

```text
Reality
   |
   v
Observation
   |
   v
Situation Assessment
   |
   v
Candidate / Decision
   |
   v
Responsibility Transition
   |
   v
Bounded Authority
   |
   v
Control
   |
   v
Reality
```

A flowchart MAY cross several Specification Jurisdictions.

Crossing a Responsibility in a flow MUST NOT imply that the document containing the diagram owns that Responsibility.

Diagrams are explanatory and navigational aids. Normative meaning MUST remain available in text and MUST NOT exist only in a diagram.

## Architecture document structure

Architecture documents MUST be organised according to the clearest useful architectural model rather than current implementation topology.

Where applicable, Architecture MUST make discoverable:

- document purpose and architectural boundary;
- Specification Jurisdictions defined or specialised by the document;
- Responsibilities and supporting Concepts;
- governing Constraints, Invariants, Evidence Rules and Policies;
- lifecycle and responsibility relationships;
- explicit ownership boundaries;
- related architectural authorities; and
- downward routes to relevant Specifications.

A document is not required to use a universal heading template when another structure communicates the same architecture more clearly.

Large Architecture documents MUST provide stable navigation sufficient for an engineer to enter at the relevant Responsibility or architectural subject without reconstructing the whole document.

Subsections MUST NOT be treated as independent Specification Jurisdictions merely because they have headings.

## Readability and naming

Architecture is primarily a human engineering surface and MUST remain directly comprehensible without reading source code.

Architecture MUST use accepted architectural vocabulary and explicit ownership where omission would create ambiguity.

A discovery that establishes durable architectural knowledge MUST be given a stable, truthful name when no existing accepted term already owns that meaning.

Architectural names and terminology MUST comply with the repository [Naming Conventions](NAMING_CONVENTIONS.md), which owns semantic naming rules, responsibility-bearing vocabulary, historical-provenance naming and current-versus-development-origin terminology. This standard governs **where architectural meaning and ownership must be explicit**; Naming Conventions governs **how that meaning is named**.

Architecture MUST explain systems, responsibilities and behaviour rather than implementation mechanics.

A tactical flowchart or lifecycle diagram MAY be used when it materially clarifies:

- responsibility boundaries;
- handoffs;
- lifecycle transitions;
- evidence flow;
- jurisdiction crossings; or
- authority direction.

A diagram MUST NOT be added merely as decoration or as a substitute for clear normative prose.

## Architecture and implementation disagreement

Architecture defines what the system should achieve.

Specification defines the implementation-facing contract required to realise that architecture.

Implementation attempts to realise that contract.

Testing challenges the assumptions and behaviour of all three against Reality.

Implementation behaviour MUST NOT become architectural truth merely because it exists in source.

When Reality disproves an architectural assumption, that evidence MUST be evaluated at the architectural level. Where the architecture is disproved, Architecture MUST be deliberately revised before downstream Specification and implementation are treated as corrected.

Documentation MUST NOT be changed merely to make current implementation appear conformant.

Source disagreement with Specification is **implementation drift**.

Specification disagreement with Architecture is **contract drift**.

Reality disagreement with Architecture is **architectural evidence**.

## Prohibited live-architecture content

Live Architecture MUST NOT be the primary owner of:

- implementation chronology;
- migration or tranche history;
- individual PR or Issue narratives;
- build-specific implementation instructions;
- rolling scenario results;
- lists of successful or failed test executions;
- current source-file inventories;
- helper or API documentation;
- module-local calibration catalogues;
- generated implementation reference; or
- unresolved engineering work queues.

Where such information is useful, Architecture MUST route to the surface that legitimately owns it.

## Authority and duplication

Every independently maintained normative statement MUST have one authoritative owner.

Other surfaces MUST reference that authority rather than independently restating it where repetition could create semantic drift.

The same concept MAY appear in explanatory prose on several surfaces only when the authoritative owner remains unambiguous and the repeated prose does not create a second normative statement.

Generated repetition derived deterministically from one authoritative source does not create an additional authority.

## Maintenance principle

Every additional independently maintained statement is a potential drift surface.

Repository documentation MUST prefer one authoritative statement with explicit traceability over repeated normative explanations across `/docs`, `/spec` and `/scripts`.

Architecture MUST preserve durable system meaning while permitting implementation topology, generated reference and validation evidence to evolve beneath it.

The maintenance objective is not minimum documentation.

It is:

> **Minimum duplicated authority with maximum navigability.**