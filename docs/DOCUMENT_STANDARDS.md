# Documentation standards

## Purpose and authority

This document is the normative authoring, ownership and cross-surface conformance standard for OuttaMyWay's durable engineering authority surfaces.

It governs the relationship among:

```text
/architecture
System Architecture — what / why
        ⇅
/spec
Specification — implementation-facing contract
        ⇅
/scripts
Source — current mechanism
        |
        v
/tests + Reality
Validation evidence
```

`/architecture`, `/spec` and `/scripts` are distinct authority surfaces. None is a substitute for another.

Tests and Reality challenge the claims made through those surfaces. Tests do not acquire semantic authority merely because they pass. Reality remains capable of disproving Architecture, Specification, implementation and test assumptions.

`/docs` is the separate engineering-knowledge and governance surface. It owns standards, method, continuation, naming, testing methodology, reusable engine knowledge, research/evidence routes, decision records and other project knowledge whose responsibility is not System Architecture, Specification or production mechanism.

Surface READMEs provide entrance, explanation and navigation. They MUST NOT become competing owners of normative standards defined here.

> **Standards Have One Authority; Surface READMEs Provide the Route.**

## Normative language

The terms **MUST** and **MUST NOT** define mandatory repository standards.

**MAY** identifies an intentional choice.

**SHOULD** and **SHOULD NOT** are permitted only where a legitimate class of exception exists. The standard MUST describe that exception. A repository departure from a SHOULD or SHOULD NOT rule MUST record why the stated exception applies.

Normative requirements govern engineering meaning and ownership. They MUST NOT unnecessarily prescribe presentation syntax where several equally clear representations are possible.

Where a small stable syntax is itself the repository interface consumed by structural conformance tooling, this standard MAY prescribe that syntax explicitly. Such syntax is an interface to authoritative meaning; it is not a replacement for the human explanation surrounding it.

> **Normative on semantics; permissive on presentation except where presentation is the contracted machine interface.**

# Semantic authority model

Architecture defines what the system should achieve, why its responsibilities exist and which concepts, constraints and authority relationships govern them.

Specification operationalises Architecture into implementation-facing contracts.

Source provides the current mechanism that attempts to satisfy those contracts.

Tests and Reality validate or disprove the assumptions and behaviour of the preceding surfaces.

```text
Reality
   |
   | may disprove
   v
Architecture
   |
   | operationalised by
   v
Specification
   |
   | realised by
   v
Source
   |
   | produces behaviour in
   v
Reality
```

Implementation behaviour MUST NOT become Architecture merely because it exists.

A current source mechanism MUST NOT become a Specification requirement merely because tests assert it.

A Specification MUST NOT redefine Architecture merely to match existing implementation.

Documentation MUST NOT be changed merely to make current behaviour appear conformant.

Source disagreement with Specification is **implementation drift**.

Specification disagreement with Architecture is **contract drift**.

Reality disagreement with Architecture is **architectural evidence**.

> **Reality is the final architect.**

# Authority Triad Revalidation

`/architecture`, `/spec` and `/scripts` form the implementation **Authority Triad**.

> **Touch One; Validate Three.**

Any proposed accepted change that touches one Authority Triad surface MUST validate the other two before merge.

Validation does not require modification. An unchanged surface MAY be explicitly dispositioned as still correct.

For example:

```text
/scripts       changed
/spec          validated — governing contract remains correct
/architecture  validated — responsibility and system model remain correct
```

A change that exposes a wider semantic correction may instead require:

```text
/architecture  changed
/spec          changed to operationalise revised Architecture
/scripts       changed to conform to revised contract
```

A Specification clarification may legitimately produce:

```text
/spec          changed
/architecture  validated — architectural meaning unchanged
/scripts       validated — existing implementation already conforms
```

The disposition of the other Authority Triad surfaces MUST be explicit enough that an affected authority cannot be silently ignored.

A trivial change MAY receive a correspondingly trivial disposition. The rule exists to force consideration of semantic impact, not to manufacture meaningless edits.

Future tooling MAY assist by identifying implicated Jurisdictions, related Specifications and declared source participants and by requiring disposition of the remaining Authority Triad surfaces.

Tooling MUST NOT claim to establish that the disposition is semantically correct.

> **A Valid Link Is Not Evidence of Semantic Synchronisation.**

> **Tooling Enforces Declared Relationships; Engineering Validates Their Meaning.**

## Validation impact

Tests are not a fourth member of the Authority Triad.

Where a Triad change affects behaviour, contract meaning, evidence interpretation, supported capability or runtime assumptions, the adequacy of existing validation MUST also be reviewed.

A test MUST NOT become normative authority merely because the changed surfaces are validated against it.

> **Tests Are Contract Evidence, Not Contract Authority.**

# Cross-surface traceability and conformance

Traceability exists to preserve navigation and expose drift without duplicating semantic authority.

The preferred authority chain is:

```text
/architecture
architectural meaning
        ⇅
/spec
implementation-facing contract
        ⇅
/scripts
current mechanism
        |
        v
/tests
contract evidence
```

> **Traceability Replaces Duplicated Authority.**

## Stable semantic identity

Architecture Responsibilities and Specification Jurisdictions MUST have stable human-readable semantic identities.

Every Specification Jurisdiction MUST additionally have one canonical machine-stable **Jurisdiction ID** declared by its authoritative Architecture and acknowledged unchanged by its primary Specification.

A Jurisdiction ID MUST be unique repository-wide and MUST remain stable while the same semantic Jurisdiction remains current. IDs use upper-case ASCII words separated by underscores, for example `COOPERATIVE_PASSAGE`.

A Jurisdiction ID MUST NOT be inferred from a Markdown heading, filename, source directory, class or table name, function name or current implementation topology.

Architecture Responsibilities do not acquire machine IDs merely because they are separately named. The Specification Jurisdiction is the cross-surface semantic anchor.

A Specification Jurisdiction is a semantic boundary, not a repository path.

A primary Specification filename provides physical navigation to a Jurisdiction but does not create the Jurisdiction.

A source module MAY participate in several Jurisdictions. A Jurisdiction MAY be realised by several source modules.

> **Specification Jurisdiction Is the Cross-Surface Semantic Anchor.**

> **Primary Specification != Primary Source Module.**

## Contracted machine-readable surface

Structural conformance tooling MUST parse only the explicitly contracted constructs defined in this section and the surface-specific rules below. It MUST NOT attempt to infer semantic relationships from arbitrary prose, imports, call topology, directory placement, filenames or ordinary Markdown links.

The contracted constructs are:

- Architecture-owned `Jurisdiction ID`, `Primary Specification` and optional `Specialises` declarations;
- Specification-owned `Jurisdiction ID`, `Primary Architecture Authority`, `Contract participants` and repository validation-participant declarations;
- source-owned `Specification Jurisdictions:` acknowledgement in module documentation; and
- Authority Triad dispositions belonging to the proposed change set when that enforcement mechanism is adopted.

A parser MAY generate an in-memory or disposable index/graph from these facts. Such a graph is derived and MUST NOT become another authored authority surface.

> **Parse the Contracted Surface; Do Not Interpret the Document.**

> **The Conformance Graph Should Be Derived, Not Authored.**

> **Derived Index != Authority Surface.**

## Architecture-to-Specification relationship

Every implemented Specification Jurisdiction MUST have exactly one primary Specification owner.

Every authoritative Architecture declaration for a Specification Jurisdiction MUST expose these machine-stable facts in the detailed Jurisdiction declaration:

```markdown
**Jurisdiction ID:** `COOPERATIVE_PASSAGE`
**Primary Specification:** [`spec/COOPERATIVE_PASSAGE.md`](../spec/COOPERATIVE_PASSAGE.md)
```

A distinct specialised Jurisdiction MUST additionally declare its parent contract where applicable:

```markdown
**Specialises:** `RESOLUTION_LIFECYCLE`
```

`Specialises` is omitted when no parent specialisation exists. A placeholder such as `NONE` MUST NOT be used.

`SPECIALISES` applies only when one distinct Specification Jurisdiction inherits another distinct Jurisdiction's contract. Architectural specialisation inside the same Jurisdiction does not create a machine `SPECIALISES` edge.

Every `SPECIALISES` target MUST name an existing Jurisdiction ID. A Jurisdiction MUST NOT specialise itself, and the `SPECIALISES` graph MUST remain acyclic.

This standard does not define a general machine `DEPENDS_ON` relationship. Current cross-Jurisdiction prose includes prerequisites, optional contributors, downstream consumers, handoffs and authority boundaries whose semantics are not one uniform graph edge. Those relationships remain human-authored until Architecture establishes a narrower durable relationship class.

Every primary Specification MUST identify exactly one governing Jurisdiction ID and its Primary Architecture Authority.

The governing Architecture's `Primary Specification` path and the corresponding Specification identity MUST agree exactly. The Specification's `Primary Architecture Authority` path MUST reciprocally identify the Architecture that declares the Jurisdiction.

For an implemented Specification Jurisdiction, Architecture MUST route normal implementation-facing navigation through `/spec`.

Architecture MAY additionally link directly to source when that source relationship is itself architecturally meaningful. Such a link MUST NOT replace the primary `/architecture → /spec → /scripts` route.

> **Architectural Specialisation != Jurisdiction Specialisation.**

## Specification-to-source relationship

Every primary Specification MUST provide a discoverable route to the production source that currently participates materially in its contract.

The authoritative machine participant set is owned by the primary Specification under a `## Contract participants` section using exact production-file paths and exactly one participation token per source/Jurisdiction pair:

```markdown
## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/authority/BoundedAuthority.lua`](../scripts/authority/BoundedAuthority.lua) | `REALISES` |
| [`scripts/authority/AuthorityRegistry.lua`](../scripts/authority/AuthorityRegistry.lua) | `SUPPORTS` |
```

The example paths illustrate the `BOUNDED_AUTHORITY` relationship shape; the owning Specification determines the truthful participant set for every Jurisdiction.

The only source-participation relationship classes are:

**`REALISES`**  
The source module directly implements a semantic product, evidence rule, verdict, lifecycle meaning, authority decision, invariant, policy boundary or purpose-specific execution rule whose correctness is governed by that Jurisdiction.

**`SUPPORTS`**  
The source module supplies materially Jurisdiction-specific subordinate infrastructure required by that implementation, but does not itself establish or represent the Jurisdiction-owned semantic boundary.

A source/Jurisdiction pair MUST NOT be both `REALISES` and `SUPPORTS`. `REALISES` is sufficient when the stronger relationship exists.

Every implemented Jurisdiction MUST have at least one `REALISES` participant.

Participant paths MUST identify exact production source files. Directories, globs, generic phrases such as "runtime orchestration", or links whose purpose is merely navigation MUST NOT appear as machine participant rows.

A generic technical utility, upstream producer, downstream consumer, neighbouring authority, import, caller or callee does not acquire a participation edge solely because the Jurisdiction operationally depends upon it.

`SUPPORTS` is direct, not transitive. A mechanism that supports Control does not thereby support every specialised Jurisdiction that ultimately uses Control. A second `SUPPORTS` relationship exists only when that source directly provides subordinate infrastructure belonging to that Jurisdiction's implementation boundary.

A source module may truthfully `REALISE` several Jurisdictions when the same file directly implements several semantic contracts. Directory placement and a module's locally dominant responsibility do not override implemented meaning.

> **Source Participation Follows Implemented Meaning, Not Directory Placement.**

> **Calling a Contract != Implementing the Contract.**

> **Technical Dependency != Contract Support.**

> **Support Is Direct, Not Transitive.**

## Reciprocal source acknowledgement

Production source that materially participates in one or more Specification Jurisdictions MUST acknowledge those Jurisdictions in its module documentation using exactly one visible line of the form:

```lua
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`, `CONTROL`
```

Jurisdiction IDs MUST appear as literal inline code so documentation renderers preserve exact identifier text. Declaration order carries no authority and MUST NOT be interpreted as primary ownership or precedence.

The source acknowledgement is intentionally untyped. Source MUST NOT assign itself `REALISES`, `SUPPORTS`, primary ownership, specialisation or other contract authority.

For every Spec-declared source participant, that source MUST acknowledge the same Jurisdiction ID. For every source-side Jurisdiction acknowledgement, that Jurisdiction's primary Specification MUST classify the source exactly once as `REALISES` or `SUPPORTS`.

A production source module that participates in no Specification Jurisdiction does not require an empty acknowledgement.

The human-readable module responsibility explanation and this mechanically inspectable acknowledgement MAY share one documentation block. The acknowledgement MUST remain useful to a human reader without requiring conformance tooling or generated documentation.

> **Reciprocity != Co-Ownership.**

> **Specification Owns Contract-Participation Classification.**

> **Source Acknowledges Participation; It Does Not Assign Itself Contract Authority.**

> **Authoritative Edge, Reciprocal Acknowledgement.**

## Navigation traceability

The machine participant set is deliberately narrower than human implementation navigation.

A primary Specification's ordinary `Implementation traceability` prose MAY continue to route engineers to upstream producers, downstream consumers, neighbouring authorities, shared mechanisms, directories or other useful implementation locations that are not material contract participants for that Jurisdiction.

An ordinary source link MUST NOT be interpreted as `REALISES` or `SUPPORTS` merely because it appears in a Specification.

> **Navigation Trace != Contract Participation.**

## Source descent

Cross-surface repository traceability normally terminates at a stable source-module or equivalent semantic source boundary.

It MUST NOT require every function, local helper or call-graph edge to become a repository governance node.

Once an engineer reaches the correct source module, source documentation owns the further local explanation required to navigate the implementation safely.

> **Cross-Surface Traceability Ends at Stable Source Boundaries; Local Documentation Continues the Descent.**

## Validation routes

Primary Specifications MUST expose discoverable validation routes appropriate to their contracts.

Validation routes MAY identify structural checks, offline behavioural tests, targeted in-game scenarios or other appropriate evidence surfaces.

A validation route establishes where a contract is challenged. It does not transfer normative ownership to the validation surface.

When a primary Specification declares concrete repository validation artefacts for machine conformance, it MUST use exact repository paths under a `## Repository validation participants` section with the relationship `CHALLENGES`:

```markdown
## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py) | `CHALLENGES` |
```

A repository validation artefact does not need a reciprocal self-declaration. The primary Specification names the evidence route; the evidence does not self-certify contract coverage.

Targeted in-game Reality validation, scenario interpretation and other non-file evidence MAY remain human-readable validation prose rather than being forced into pseudo-path identities.

> **A Validation Surface Challenges a Contract; It Does Not Certify It.**

> **A Contract Names Its Evidence Route; Evidence Does Not Self-Certify Its Contract Coverage.**

## Structural conformance

Repository conformance tooling adopted for these relationships MUST be capable of detecting the objectively knowable drift within its declared scope, including:

- duplicate or malformed canonical Jurisdiction IDs;
- an implemented Architecture Jurisdiction with no valid primary Specification;
- Architecture/Specification disagreement over Jurisdiction identity, primary Specification path or Primary Architecture Authority;
- an unknown, self-targeting or cyclic `SPECIALISES` relationship;
- a Spec-declared participant whose production source path does not exist;
- an illegal or duplicate `REALISES` / `SUPPORTS` classification for one source/Jurisdiction pair;
- an implemented Jurisdiction with no `REALISES` participant;
- a Spec-declared participant whose source does not acknowledge that Jurisdiction;
- a source acknowledgement naming an unknown Jurisdiction;
- a source acknowledgement for which the primary Specification supplies no `REALISES` or `SUPPORTS` classification;
- a declared repository validation path that no longer resolves;
- deleted or renamed artefacts leaving unresolved incoming declared relationships;
- broken live traceability routes covered by the tool's explicit link-integrity scope; and
- Authority Triad changes with no disposition of the other surfaces once a change-set disposition mechanism is adopted.

Structural conformance tooling MUST restrict itself to objectively testable repository relationships.

It MUST NOT claim to determine whether Architecture is correct, whether Specification faithfully operationalises Architecture, whether an undeclared semantic participant was omitted, whether a source relationship has been semantically classified correctly, whether a validation surface is adequate, whether source prose accurately explains a mechanism or whether a passing test reflects runtime Reality sufficiently.

A declared relationship that is inconsistent is machine-checkable. A relationship nobody declared, but which engineering judgement says should exist, remains a semantic-completeness question until an authority surface declares it.

> **Tooling Can Prove Declared Closure; Humans Establish Semantic Completeness.**

> **No Speculative Linting in Normative Conformance.**

> **Machine conformance establishes declared structural coherence. Engineering establishes semantic truth.**

## Bounded source-traceability adoption

The cross-surface representation and relationship contract are now selected, but accepted production Architecture, Specifications and source have not yet completed the repository-wide migration to those constructs.

Existing production source MAY therefore temporarily lack the required `Specification Jurisdictions:` acknowledgement, and accepted Architecture/Specifications MAY temporarily lack the new machine-stable declarations and participant tables, while one explicit repository migration owns establishment of the complete graph.

During that bounded adoption period:

- existing Specification-authored implementation routes remain valid navigation;
- the selected representation MUST be used by the migration rather than inventing a parallel manifest or competing annotation scheme;
- no authored central conformance manifest MUST become a second authority for relationships owned by Architecture, Specification or source;
- a disposable or generated graph/index MAY be produced from the authoritative surfaces for checking, reporting or navigation;
- LDoc, LuaLS/LuaCATS or another documentation/IDE consumer MAY consume compatible source documentation, but generated output MUST remain derived and non-authoritative; and
- steady-state enforcement MUST NOT be declared complete until the migration closure condition below is satisfied.

Migration closure requires all current implemented Specification Jurisdictions to have unique canonical Jurisdiction IDs and exact primary-Spec routes; every primary Specification to acknowledge the correct Jurisdiction/Architecture authority and classify every material production participant by exact source path as `REALISES` or `SUPPORTS`; every participating source module to reciprocally acknowledge the complete set of its Jurisdictions; every implemented Jurisdiction to have at least one `REALISES`; and the derived graph to close with zero unresolved relationships.

Repository validation-participant migration MAY proceed with the same programme but is not required to invent repository evidence where none is currently appropriate. Every declared repository validation path MUST resolve.

After the closure condition is accepted, missing or inconsistent required declarations become ordinary steady-state conformance failures and this bounded exception MUST be removed or rewritten as completed policy rather than preserved as live migration state.

This is a migration mechanism, not an alternative permanent state.

No generated reference system is authorised merely by this exception.

> **Visible Structured Source Metadata; Independent Consumers.**

> **Shared Syntax; Independent Consumers.**

> **Prefer Documentation-Compatible Metadata Over Conformance-Only Metadata.**

# `/architecture` — System Architecture standard

## Purpose

`/architecture` owns the human-readable current system Architecture that explains what OuttaMyWay should achieve, why its responsibilities exist, and which concepts, constraints and authority relationships govern them.

Architecture MUST describe the system as it should be experienced and reasoned about. It MUST NOT be derived from current implementation structure, and implementation convenience MUST NOT determine architectural boundaries.

A future engineer MUST be able to reconstruct the current architecture directly from `/architecture` without reconstructing it from Git history, Issues, pull requests, test runs or source code.

`/architecture` MUST remain readable as an engineering surface for humans. Machine-readable traceability MAY support it, but metadata MUST NOT replace the explanation required to understand the architecture.

`/docs` is the separate engineering-knowledge and governance surface. It owns engineering method, continuation, standards, naming, validation methodology, engine knowledge, research/evidence routes, decision/journal records and other project knowledge whose responsibility is not System Architecture. `/docs` MUST NOT be used as a synonym for Architecture.

> **Documentation Surface != Architecture Surface.**

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

Every Specification Jurisdiction MUST expose one unique canonical `Jurisdiction ID` and one exact `Primary Specification` path using the contracted representation defined above once the bounded migration is complete.

Every implementation-bearing architectural Responsibility MUST belong to exactly one primary Specification Jurisdiction.

A Jurisdiction MAY contain several subordinate Responsibilities, Concepts, Constraints, Invariants, Evidence Rules, Policies or Lifecycles when they form one cohesive implementation-facing contract.

A Concept, Constraint, Invariant, Evidence Rule, Policy or Lifecycle MUST NOT create a separate Specification Jurisdiction solely because it is separately named, separately headed or separately implemented.

Jurisdiction boundaries MUST follow semantic cohesion rather than Markdown heading count, source-file count, implementation directory structure, class boundaries, function boundaries or document length.

A broad architectural subject MAY contain several Specification Jurisdictions when it contains genuinely independent implementation-facing contracts.

The number and boundaries of Jurisdictions MUST be discovered from Architecture rather than imposed from repository structure.

Specification Jurisdictions MUST NOT overlap in primary contract ownership. A specialised Jurisdiction MAY specialise a contract owned by another Jurisdiction, but it MUST reference that contract rather than independently restate or claim its normative ownership.

Human-authored cross-Jurisdiction dependency prose does not automatically create additional machine graph edges.

## Deferred responsibilities

Current implemented Architecture MUST NOT carry an `implemented` status marker merely to confirm the normal state.

Implementation is the normal expectation for live implementation-bearing Architecture.

An explicit implementation status MUST be used only when the exception is architecturally meaningful, for example:

```text
Status: Not implemented
```

A recognised Deferred Responsibility MAY therefore exist in current Architecture without an implementation Specification.

An empty or speculative Specification MUST NOT be created solely to satisfy structural symmetry.

A Deferred Responsibility is not a deferred Specification Jurisdiction merely because it is named. If Architecture later establishes a genuine unimplemented Specification Jurisdiction, its representation and conformance semantics MUST be designed from that evidence rather than inferred from the present Deferred Responsibility mechanism.

> **Deferred Responsibility != Deferred Jurisdiction.**

## Cross-jurisdiction relationships

An architectural rule MAY legitimately govern more than one Specification Jurisdiction.

Such knowledge MUST have one authoritative architectural owner.

Affected Specifications MUST reference that owner rather than independently restating the same normative rule.

Cross-jurisdiction relationships MAY be illustrated with tactical flowcharts when the flow materially improves understanding of responsibility boundaries, handoffs or authority direction.

A flowchart MAY cross several Specification Jurisdictions. Crossing a Responsibility in a flow MUST NOT imply that the document containing the diagram owns that Responsibility.

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

Summary tables MAY provide navigation across Jurisdictions, but they MUST NOT become a second independently maintained machine authority for canonical IDs or topology. The detailed authoritative declaration owns the contracted machine facts.

## Readability and naming

Architecture is primarily a human engineering surface and MUST remain directly comprehensible without reading source code.

Architecture MUST use accepted architectural vocabulary and explicit ownership where omission would create ambiguity.

A discovery that establishes durable architectural knowledge MUST be given a stable, truthful name when no existing accepted term already owns that meaning.

Architectural names and terminology MUST comply with the repository [Naming Conventions](NAMING_CONVENTIONS.md), which owns semantic naming rules, responsibility-bearing vocabulary, historical-provenance naming and current-versus-development-origin terminology. This standard governs **where architectural meaning and ownership must be explicit**; Naming Conventions governs **how that meaning is named**.

Architecture MUST explain systems, responsibilities and behaviour rather than implementation mechanics.

A tactical flowchart or lifecycle diagram MAY be used when it materially clarifies responsibility boundaries, handoffs, lifecycle transitions, evidence flow, jurisdiction crossings or authority direction.

A diagram MUST NOT be added merely as decoration or as a substitute for clear normative prose.

## Architecture and implementation disagreement

Architecture defines what the system should achieve.

Specification defines the implementation-facing contract required to realise that architecture.

Implementation attempts to realise that contract.

Testing challenges the assumptions and behaviour of all three against Reality.

Implementation behaviour MUST NOT become architectural truth merely because it exists in source.

When Reality disproves an architectural assumption, that evidence MUST be evaluated at the architectural level. Where the architecture is disproved, Architecture MUST be deliberately revised before downstream Specification and implementation are treated as corrected.

Documentation MUST NOT be changed merely to make current implementation appear conformant.

## Prohibited live-architecture content

Live Architecture MUST NOT be the primary owner of implementation chronology, migration or tranche history, individual PR or Issue narratives, build-specific implementation instructions, rolling scenario results, lists of successful or failed test executions, current source-file inventories, helper or API documentation, module-local calibration catalogues, generated implementation reference or unresolved engineering work queues.

Where such information is useful, Architecture MUST route to the surface that legitimately owns it.

## Architecture authority and duplication

Every independently maintained normative architectural statement MUST have one authoritative owner.

Other surfaces MUST reference that authority rather than independently restating it where repetition could create semantic drift.

The same concept MAY appear in explanatory prose on several surfaces only when the authoritative owner remains unambiguous and the repeated prose does not create a second normative statement.

Generated repetition derived deterministically from one authoritative source does not create an additional authority.

# `/spec` — Specification standard

## Purpose

`/spec` is OuttaMyWay's implementation-facing contract surface.

A primary Specification defines what an implementation of one declared Specification Jurisdiction must preserve, expose, reject, sequence or report in order to realise its governing Architecture.

> **Specification Operationalises Architecture; It Does Not Paraphrase It.**

A Specification MUST NOT become a second copy of Architecture and MUST NOT redefine architectural meaning merely to match current source.

Specification documents MUST describe durable implementation-facing obligations rather than incidental mechanism.

## Primary ownership

Every implemented Specification Jurisdiction declared by Architecture MUST have exactly one primary Specification.

Every primary Specification MUST:

- acknowledge exactly one canonical `Jurisdiction ID` declared by Architecture;
- identify its Primary Architecture Authority;
- distinguish related architectural context from primary authority;
- own one cohesive implementation-facing contract;
- provide a discoverable route toward current implementation; and
- provide a discoverable validation route.

A primary Specification MUST NOT be created from a source file, class, helper, document heading or implementation subsystem merely because that unit exists. Specification identity follows the architectural Jurisdiction.

A specialised Jurisdiction MAY inherit another Jurisdiction's contract. Its Specification MUST reference the parent contract rather than restating or claiming ownership of that contract.

A recognised Deferred Responsibility with no implementation requirement MAY remain without a Specification. Placeholder, empty or speculative Specifications MUST NOT be created for symmetry.

## Specification contract spine

Primary Specifications do not require one rigid Markdown heading template. They MUST, however, make the following semantic obligations directly discoverable.

### Identity and authority

A primary Specification MUST expose its canonical Jurisdiction acknowledgement and Primary Architecture Authority using the contracted constructs defined above.

It MUST make clear what implementation-facing responsibility it owns and which neighbouring responsibilities it deliberately does not own where confusion is plausible.

The responsibility statement MUST be implementation-facing rather than a pasted architectural summary.

### Boundary contracts

A primary Specification MUST define the semantic boundary by which its Jurisdiction participates in the wider system.

As applicable, this includes accepted inputs or upstream products, identity/freshness/provenance requirements, produced outcomes or guarantees, downstream consumers, ownership of state or identity crossing the boundary, and preconditions required before stronger conclusions are permitted.

Boundary contracts describe semantic obligations. They MUST NOT be reduced to a current Lua function signature or helper call graph.

### Durable invariants

A primary Specification MUST identify the implementation-facing invariants necessary to preserve the governing Architecture.

An invariant belongs in Specification when an implementation could plausibly violate it while appearing locally convenient.

Where Architecture already owns the normative rule, the Specification MUST reference that authority and express the implementation obligation created by it rather than independently redefine the architectural rule.

> **Traceability Replaces Duplicated Authority.**

### Failure and uncertainty semantics

Every primary Specification MUST define how the Jurisdiction behaves when required evidence, capability, representation, consistency or execution preconditions are absent, contradictory, stale or unsupported.

It MUST make clear which relevant outcomes are positively supported, positively contradicted, unresolved, unavailable, rejected, fail-closed, retryable through fresh evidence or reassessment, or terminal within the Jurisdiction where terminal semantics legitimately exist.

Failure semantics MUST preserve architectural authority boundaries. Failure MUST NOT manufacture a stronger conclusion merely to keep implementation active.

### Contract participants

Every primary Specification MUST own the complete current material production-source participant set for its Jurisdiction using the contracted `Contract participants` representation after the bounded migration is complete.

Classification MUST follow the `REALISES` / `SUPPORTS` meanings in this standard rather than source directory placement, import topology or convenience.

A primary Specification MUST NOT classify a module merely because it is useful navigation. Human navigation belongs in Implementation traceability.

### Implementation traceability

Every primary Specification MUST provide a discoverable human route to the production implementation and neighbouring implementation locations useful for understanding its contract.

Exact source-file, function and helper placement are traceability facts rather than normative contract meaning.

A primary Specification does not imply one primary source module. One Jurisdiction MAY be realised by several modules, and one source module MAY participate in several neighbouring contracts when ownership remains explicit and traceable.

> **Primary Specification != Primary Source Module.**

Implementation traceability MUST remain distinguishable from the authoritative machine participant table and from authored contract meaning. It MAY include broader navigation routes that intentionally create no contract-participation edge.

Any future generated reference MAY expose implementation facts but MUST NOT become owner of Specification semantics.

When implementation topology changes without changing the contract, the Specification's normative meaning SHOULD remain stable. The legitimate exception is a topology change that demonstrates that the Specification had accidentally named an implementation mechanism rather than a durable contract boundary. That is contract-design evidence and the Specification SHOULD then be deliberately corrected.

### Validation route

Every primary Specification MUST identify how its contract is challenged.

The route MUST distinguish, as applicable, structural or source-contract validation, offline behavioural or conformance validation, targeted in-game Reality validation, and evidence outside the claim of the Specification.

Concrete repository validation artefacts that participate in machine conformance MUST be declared by exact path as `CHALLENGES` under the contracted repository-validation representation.

A Specification MUST NOT maintain rolling pass/fail counts, build-by-build evidence, scenario chronology or CI run history.

A test link establishes a validation route. It does not transfer contract ownership to the test.

## Conditional contract obligations

The contract spine defines semantic obligations, not mandatory headings. Additional material becomes mandatory when the Jurisdiction actually owns the corresponding semantics.

### Lifecycle or ordered flow

When a Jurisdiction owns progression, persistence, atomic replacement, obligation discharge, terminal disposition or order-sensitive processing, its Specification MUST define that lifecycle or ordered flow sufficiently for implementation and debugging.

This requirement MUST NOT force artificial state machines onto contracts that do not own lifecycle progression.

A tactical flowchart MAY be used where it materially clarifies the contract. Normative meaning MUST remain available in text.

### Semantic data contracts

Where a Jurisdiction publishes or consumes durable semantic products, its Specification MUST define the fields or properties whose meaning is contractually significant.

This MAY include identity, provenance, evidence quality, freshness, completeness, claim permissions, terminal disposition, support provenance or exact-picture binding.

A semantic data contract MUST describe meaning and required relationships. It MUST NOT become an exhaustive dump of current object members merely because those members exist in source.

### Cross-Jurisdiction dependencies

Where a contract depends on another Jurisdiction, the Specification MUST identify that dependency and the assumption made about the neighbouring contract in human-readable prose.

It MUST NOT copy the neighbouring contract into its own text. Cross-Jurisdiction architectural rules retain one architectural owner; affected Specifications reference that authority.

The heading or prose relationship `Cross-Jurisdiction dependencies` does not automatically create a machine `DEPENDS_ON` graph edge.

## Architecture, Specification and implementation values

Architecture owns architectural policy and system responsibility. Specification owns implementation-facing obligations required to realise that Architecture. Source owns current mechanism and calibration unless a value is itself part of the accepted contract.

> **Accepted Implementation Value != Specification Requirement.**

A literal, threshold, timeout, sample count, tolerance, geometry constant or algorithm parameter MUST NOT become a Specification requirement solely because current source uses it or tests currently assert it.

A value belongs in normative Specification only when changing it would violate explicit Architecture, an accepted cross-boundary contract, a required compatibility/interoperability condition or another durable implementation-facing invariant.

Where Architecture owns an exact value or policy, the Specification MUST reference that architectural authority and express its implementation obligation without claiming independent ownership of the value.

Implementation-local calibration belongs in source documentation unless later evidence demonstrates that a stronger contract exists.

## Current truth, history and unresolved work

A primary Specification describes the current accepted implementation-facing contract.

It MUST NOT become primary owner of engineering chronology, PR or Issue narratives, migration or tranche history, rolling test results, build identity history, unresolved work queues, speculative future APIs, abandoned implementation generations or source trivia with no contract significance.

Issues own unresolved work. Git, pull requests, the Engineering Journal, Research and scenario records own historical evidence as applicable.

A supported limitation MAY be stated in Specification when it is part of the accepted current contract. An unresolved idea MUST NOT be promoted into Specification merely because implementation work is expected later.

## Source-documentation boundary

Specification is not source documentation.

Specification owns the implementation-facing contract. Source documentation owns colocated explanation of current mechanism where names and structure alone do not communicate how that mechanism realises, protects, limits or hands off semantic responsibility.

Specification MUST NOT duplicate ordinary helper topology, private algorithm steps or exhaustive APIs when those facts can change without changing the contract.

Public visibility is not itself the governing documentation criterion. Public interfaces are strong candidates for documentation because they often represent semantic boundaries, but private mechanisms MUST also be documented when their semantic weight, authority effect, evidence effect, runtime interaction or risk of misinterpretation makes explanation necessary.

> **Semantic Boundary Requires Documentation.**

## Specification review test

A primary Specification should remain meaningful if its internal implementation mechanism were substantially replaced, unless Reality or architectural change demonstrates that the contract itself was wrong.

Before acceptance, reviewers MUST be able to determine whether the governing Jurisdiction and primary Architecture are clear, the text defines an implementation-facing contract rather than paraphrasing Architecture, boundary products and failure semantics are sufficiently explicit, owned lifecycle or ordering semantics are present where applicable, neighbouring contracts are referenced rather than duplicated, material source participation is truthfully classified, broader implementation navigation remains distinguishable from participation, validation routes exist without embedding validation history, and implementation values have not become requirements merely because they exist.

# `/scripts` — Production Source Documentation standard

## Purpose

Production source documentation exists to make the current implementation safely navigable and maintainable by an experienced Lua engineer.

It MUST explain system meaning where that meaning cannot be recovered reliably from names, structure and ordinary language competence alone.

It MUST NOT teach Lua, narrate obvious syntax, duplicate Architecture or Specification authority, or preserve repository chronology inside production code.

> **Assume Language Competence; Document System Meaning.**

## Source authority

`/scripts` owns the current implementation mechanism.

Source documentation MAY explain how that mechanism realises, protects, limits, validates, transfers or relinquishes semantic responsibility.

Source documentation MUST NOT redefine Architecture or Specification requirements.

Where source behaviour is governed by a Specification Jurisdiction, that Specification remains the implementation-facing contract.

> **Code Documentation Is Colocated Mechanism Explanation, Not System Authority.**

## Module responsibility

A production source module MUST identify its responsibility when its semantic responsibility is not sufficiently clear from its canonical name, namespace and structure.

The responsibility explanation MUST describe semantic purpose and boundary rather than enumerate functions or implementation steps.

Where omission could cause a module to be mistaken for authority it does not possess, the module documentation MUST identify the important exclusion.

Module-level documentation MUST remain concise enough to orient an experienced engineer without reproducing the implementation. A competent engineer reading the module MUST be able to understand why the module exists before reconstructing that purpose from its implementation.

## Specification participation

A source module that materially participates in one or more Specification Jurisdictions MUST expose exactly one `Specification Jurisdictions:` acknowledgement in its module documentation after the bounded migration is complete.

The acknowledgement MUST contain canonical Jurisdiction IDs only, represented as literal inline code and separated by commas when several apply.

The acknowledgement MUST NOT contain `REALISES`, `SUPPORTS`, `SPECIALISES`, primary-owner language or any other source-authored relationship classification.

Declaration order carries no authority.

Many-to-many Specification/source participation MUST remain representable.

A source module that materially participates in no Specification Jurisdiction MUST NOT add a fake empty declaration merely for uniformity.

The human-readable explanation and mechanically inspectable relationship MAY share one representation, but machine metadata MUST NOT replace the human explanation required to understand the module.

The representation is intentionally compatible with ordinary source-documentation tooling. A renderer such as LDoc MAY consume the same documentation, but conformance MUST NOT depend on generated documentation existing.

> **Human-Readable Meaning; Machine-Readable Relationships.**

> **Source Acknowledges Participation; It Does Not Assign Itself Contract Authority.**

> **Declaration Order Carries No Authority.**

## Function and local-mechanism documentation

Module-level traceability does not remove the requirement for local source comprehensibility.

A function or local mechanism MUST receive concise explanatory documentation when its purpose or semantic effect is not self-evident and misunderstanding it could reasonably cause an unsafe or semantically incorrect modification.

Documentation is particularly required when a function or mechanism:

- establishes, transforms, validates, narrows, relinquishes or terminates authority;
- establishes, transforms or interprets significant evidence;
- performs a lifecycle transition or semantic handoff;
- interacts materially with GIANTS runtime behaviour;
- implements non-obvious conservative or fail-closed behaviour;
- has a return value or effect whose semantic meaning is narrower than a superficial reading would suggest; or
- exists because of a non-obvious ordering, compatibility or runtime constraint.

Required documentation MUST be limited to what is necessary to understand the mechanism safely: purpose, significant effect, material constraint and important interpretation limit.

It MUST NOT narrate implementation line by line.

Self-evident mechanical helpers require no explanatory annotation solely because they are functions.

> **Traceability Must Survive the Descent into Source.**

> **Document Purpose and Semantics; Do Not Narrate Syntax.**

> **Self-Evident Mechanics Need No Commentary.**

Function visibility is not the governing criterion. Semantic weight and risk of misunderstanding determine documentation need.

## Source navigation expectation

Production source documentation MUST make it possible for an experienced engineer to descend through:

```text
Architecture
    ↓
Specification
    ↓
source module
    ↓
runtime/public operation
    ↓
internal semantic operation
    ↓
local mechanism
```

without reconstructing design intent from implementation archaeology.

The standard does not require every edge of the Lua call graph to be documented. Comments are required at the semantic junctions where meaning would otherwise be lost.

## Inline comments

Where an inline comment is required to explain a non-obvious mechanism, ordering choice, fallback or constraint, it MUST explain why that mechanism exists rather than narrate syntax.

Source comments MUST assume that the reader can interpret ordinary Lua constructs, method invocation, local functions, iteration, conditionals and other normal language mechanics.

They MUST NOT restate obvious assignments, branches, loops, calls or syntax.

The objective is concise engineering navigation and preservation of implementation meaning, not comment density.

There MUST NOT be a blanket requirement to comment every function, private helper, branch or implementation step.

## Consistency of annotation

Where documentation is required at equivalent semantic boundaries, the repository MUST use a consistent concise annotation form so that engineers know where to look and future tooling can recognise structure where appropriate.

Consistency MUST NOT force irrelevant boilerplate.

A documented function need not contain empty parameter, return, precondition or failure sections when those concepts are self-evident or irrelevant.

The exact annotation syntax for ordinary function documentation remains intentionally unselected. The module-level `Specification Jurisdictions:` acknowledgement is the narrow exception because its syntax is part of the cross-surface conformance interface.

> **Structure Enough for Navigation and Tooling; No Boilerplate for Its Own Sake.**

## GIANTS and external runtime constraints

Where GIANTS behaviour or another external runtime constraint materially affects how source must be interpreted or safely modified, its local consequence MUST be documented close to the affected mechanism.

Reusable engine knowledge MUST remain in the repository surface responsible for engine knowledge rather than being copied repeatedly into source.

Source documentation MUST state the local consequence. It MAY additionally route to reusable engine knowledge where that route assists maintenance.

A successful native invocation MUST NOT be described as stronger semantic evidence than the runtime actually establishes.

## Failure-conservative semantics

Where a mechanism deliberately rejects, holds, preserves uncertainty, relinquishes authority or fails conservatively because stronger evidence is unavailable, that semantic reason MUST be documented when ordinary source inspection could reasonably suggest that the mechanism is incomplete or unnecessarily restrictive.

Source comments MUST distinguish mechanical success from semantic success where the two differ.

## Implementation-owned values

Non-obvious implementation calibrations, tolerances and literals MUST identify their units, local ownership and semantic scope where those facts are not otherwise clear.

Source documentation MUST distinguish implementation-owned calibration from Architecture or Specification requirement.

A value does not become a contract requirement merely because it appears in production source.

## Current-state documentation

Production source comments MUST describe current mechanism and current constraints.

They MUST NOT accumulate PR numbers, Issue chronology, tranche history, build history, migration narrative or obsolete implementation behaviour solely to preserve development history.

Git and designated historical, research, decision or evidence surfaces own chronology.

A source comment MAY route to durable external knowledge where that knowledge is necessary to understand the current mechanism.

## Diagnostics and probes

A live diagnostic or investigative probe MAY document the question it is testing and the interpretation limits of the evidence it produces.

When the investigative question is resolved, durable findings MUST move to their responsible Architecture, Specification, engine-knowledge, research or evidence surface as appropriate.

A diagnostic mechanism MUST NOT remain in production solely to preserve historical explanation.

## Source review test

Production source documentation is sufficient when an experienced engineer can navigate and modify the mechanism without being forced to infer system meaning that should have been stated locally.

A source review MUST consider:

- whether the module's semantic responsibility is clear;
- whether its complete governing Specification participation can be discovered through the canonical acknowledgement;
- whether important authority, evidence, lifecycle and handoff boundaries are explained;
- whether non-obvious GIANTS/runtime constraints are visible where they matter;
- whether a return value or successful native call could be mistaken for stronger evidence;
- whether local calibrations are distinguishable from contract requirements;
- whether comments explain why, constraint and ownership rather than syntax; and
- whether unnecessary commentary has been avoided.

# Tests, validation and Reality

Tests provide evidence about Architecture, Specification and implementation.

They MUST NOT become alternate semantic owners of the contracts they test.

A test may encode an expected observable consequence of a Specification. That expectation MUST remain traceable to the governing contract rather than becoming an independently invented requirement.

When a test and Specification disagree, the disagreement MUST be investigated rather than automatically resolving in favour of either surface.

When Reality disproves a test assumption, the test MUST be corrected even when it previously passed consistently.

When Reality disproves Architecture, Architecture MUST be reconsidered and deliberately revised before downstream surfaces are declared corrected.

> **Testing Validates or Disproves Assumptions.**

# Tooling boundary

This document now defines the semantic relationships and the narrow machine-readable constructs required for cross-surface structural conformance.

A minimal repository parser/checker MAY consume only those contracted constructs to derive a conformance graph, validate declared closure and report deterministic failures described by this standard.

That responsibility does not authorise the checker to infer semantic meaning beyond declared facts.

This standard does not require generated source-reference documentation, LDoc, LuaLS/LuaCATS, a checked-in central manifest, function-level repository indexing, call-graph reconstruction or a general annotation framework.

LDoc, LuaLS/LuaCATS or another documentation/IDE system MAY consume compatible source documentation independently. A generated product MAY reproduce authoritative facts deterministically without acquiring authority over those facts.

A checked-in authored manifest MUST NOT duplicate the Architecture/Specification/source relationship facts merely to make parsing easier. A generated or disposable graph/index MAY exist as a derived diagnostic or presentation product.

Any permanent CI, pre-commit or root-governance enforcement mechanism remains a separate adoption decision after the bounded migration proves the representation over the whole repository.

Tooling MUST NOT own semantic meaning that belongs to Architecture, Specification or source documentation.

> **Source Documentation Need != Generated Reference Need.**

> **Documentation Renderer != Documentation Authority.**

> **Tooling Enforces Relationships; It Does Not Own Meaning.**

# Authority and duplication

Every independently maintained normative statement MUST have one authoritative owner.

Other surfaces MUST reference that authority rather than independently restating it where repetition could create semantic drift.

The same concept MAY appear in explanatory prose on several surfaces only when the authoritative owner remains unambiguous and the repeated prose does not create a second independently maintained normative statement.

Generated repetition derived deterministically from one authoritative source does not create an additional authority.

Surface READMEs MAY summarise responsibilities for navigation but MUST route normative authoring and conformance requirements back to this document.

# Maintenance principle

Every additional independently maintained statement is a potential drift surface.

Repository documentation MUST prefer one authoritative statement with explicit traceability over repeated normative explanations across `/architecture`, `/docs`, `/spec` and `/scripts`.

Architecture MUST preserve durable system meaning while permitting Specification detail, source topology and validation evidence to evolve beneath it.

Specification MUST preserve durable implementation-facing contracts while allowing internal mechanism to change.

Source documentation MUST preserve sufficient local mechanism meaning for safe engineering without converting implementation detail into higher authority.

The maintenance objective is not minimum documentation.

It is:

> **Minimum duplicated authority with maximum navigability.**
