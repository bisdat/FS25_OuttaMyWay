# Naming conventions

## Purpose and authority

This document is the authoritative repository standard for names in source,
configuration, tests, diagnostics and engineering prose.

Its purpose is semantic truthfulness: names must make responsibility, authority,
evidence and the path from evidence to action predictable to a contributor who
did not participate in the implementation history.

This standard **applies** accepted architectural and engineering vocabulary. It
does not define that vocabulary or create new architectural responsibility.
Architecture owns concepts and their relationships; this document governs how
repository names express them.

> **Naming Standard Applies Vocabulary; It Does Not Own Vocabulary**

The normative terms **MUST**, **MUST NOT** and **MAY** have the meanings defined
by [Documentation Standards](DOCUMENT_STANDARDS.md#normative-language).

## Governing principles

Repository naming MUST follow these rules:

- name a thing for its current responsibility, not its development origin;
- use durable vocabulary supplied by accepted Architecture and other responsible
  engineering authorities;
- do not imply authority the named component does not possess;
- use the narrowest name that truthfully describes the responsibility;
- let architectural discovery establish concepts before naming them; a name
  MUST NOT manufacture architecture or make an unresolved responsibility appear
  settled;
- do not assume each architectural concept requires a corresponding class,
  module or file; concepts and implementation units are not one-to-one; and
- treat existing non-conforming current names as implementation debt, not
  precedent for new work.

Naming conformance MUST improve semantic predictability. It MUST NOT be used to
justify unrelated behavioural change or speculative repository restructuring.

## Architectural terminology

Accepted architectural terms MUST be used consistently and preserve their
accepted capitalisation in engineering prose.

Examples include **Field World**, **Job Episode**, **Local Operation**,
**Observation**, **Situation Assessment**, **Responsibility Transition**,
**Current Responsibility**, **GIANTS AI**, **Regulation**, **Resolution
Commitment**, **Bounded Authority**, **Control**, **Cooperative Passage**,
**Physical Assembly**, **Physical Identity Resolution**, **Assessment
Representation**, **Candidate Support**, **Constraint Evaluation** and
**Decision**.

This list is illustrative, not a second vocabulary catalogue. The architecture
documents own definitions and relationships. The [Concept Register](CONCEPT_REGISTER.md)
and [Architecture](architecture/README.md) provide current discovery routes when
a term's authority is uncertain.

Historical decision identifiers such as `D-0146` are provenance, not current
semantic names. Sourced production identifiers, comments, telemetry and status
that describe current responsibility MUST use current architectural or
implementation vocabulary rather than development-origin decision IDs.

Deliberately historical evidence MAY retain decision identifiers where their
provenance is materially useful. Validation MAY retain a historical identifier
when the identifier itself is the asserted payload or fixture provenance.

## Repository, folder and Lua module names

- Folders MUST be named for the responsibility or cohesive subsystem they
  contain, not the experiment, decision, tranche or implementation sequence that
  produced them.
- OuttaMyWay-owned Lua module, type and file names MUST use `PascalCase`.
- A Lua file exporting one primary module or type MUST use the same basename as
  that primary export. A file intentionally containing no single primary export
  is exempt from this same-name rule.
- Each production file MUST have one principal responsibility. Closely related
  supporting work MAY remain colocated when splitting it would create artificial
  fragmentation or obscure the execution path.
- Production authority MUST NOT remain indefinitely beneath names such as
  `prototypes/` or `diagnostics/`, or retain `Shadow`, `TEST`, `Prototype` or
  similar labels, after those labels cease to describe the component's actual
  responsibility.

Repository naming does not require one file per concept or one folder per
Specification Jurisdiction.

## Lua function names and verbs

OuttaMyWay-owned Lua functions MUST use `lowerCamelCase`. A GIANTS callback,
external interface or compatibility boundary MAY retain an externally required
name; precise internal names MUST be used behind that boundary where the
external name would otherwise obscure responsibility.

When the following verbs are used, their semantic claim MUST match the stated
meaning:

| Verb | Semantic claim |
| --- | --- |
| `observe` | Obtain current evidence from Reality without interpreting it as a decision. |
| `capture` | Record a bounded snapshot or value for an explicit scope. |
| `assess` | Interpret evidence without acquiring responsibility or Control. |
| `evaluate` | Answer a bounded question without primarily mutating lifecycle or authority. |
| `build` | Construct a value or structure from supplied inputs. |
| `materialize` | Realise a previously described or selected representation in concrete form. |
| `plan` | Develop candidate future action without authorising or performing it. |
| `select` | Choose among supported alternatives. |
| `admit` | Accept a subject into a defined lifecycle or eligibility boundary. |
| `transition` | Apply an already-justified change of responsibility or state. |
| `authorize` | Grant bounded permission within an already-established purpose or responsibility. It may narrow or refuse permitted action but does not invent strategic purpose. |
| `execute` | Perform an already-authorised action. |
| `dispatch` | Route already-authorised work to the responsible executor. |
| `release` | End a held responsibility, resource or bounded claim through its defined lifecycle. |
| `neutralize` | Put controlled actuation into its safe neutral condition. |
| `settle` | Discharge a defined obligation or procedure using the evidence required by its governing contract. |

A public OuttaMyWay-owned function MUST NOT use a broad verb such as `process`,
`handle`, `attach`, `run` or generic `update` when an accepted narrower verb
truthfully describes its effect. Externally prescribed callback names are exempt
at the external boundary.

In particular:

- `assess` interprets evidence but does not acquire responsibility or Control;
- `evaluate` answers a bounded question but does not primarily mutate lifecycle
  or authority;
- `dispatch` routes work whose authority already exists; and
- `execute` performs action whose authority already exists.

## Responsibility-bearing nouns

A responsibility-bearing noun MUST be used only when the named component
actually performs the corresponding role:

| Noun | Responsibility claimed by the name |
| --- | --- |
| Source | Originates evidence or values from an identified boundary. |
| Adapter | Translates one explicit interface or representation to another without taking domain authority. |
| Assessment | Interprets evidence for a stated question and scope. |
| Evaluator | Answers a bounded question according to stated evidence and rules. |
| Authority | Owns the accepted determination or permission for its declared boundary. |
| Registry | Maintains identity-indexed records, lookup or membership representation for a defined population. Storage and lookup do not create semantic authority. |
| Ledger | Records durable facts or transitions with provenance; it is not automatically the decision owner. |
| Policy | Defines rules for choosing or permitting action, separate from performing it. |
| Planner | Develops candidate future action without granting authority or executing it. |
| Coordinator | Sequences collaborators toward one cohesive responsibility. |
| Dispatcher | Routes already-authorised work to an executor. |
| Control | Realises authorised physical action through available mechanisms. |
| Probe | Collects bounded investigative evidence and has no production semantic or Control authority. |
| Diagnostic | Exposes or records information for investigation and has no production semantic or Control authority. |
| Shadow | Observes or compares without influencing production semantics or Control. |
| Prototype | Implements experimental, non-production responsibility. |

A Coordinator MUST NOT silently accumulate unrelated domain authority. `Probe`,
`Diagnostic` and `Shadow` explicitly claim no production semantic or Control
authority. A mechanism on which production runtime depends MUST NOT remain named
or housed as a `Prototype` once it has become accepted production responsibility.

## Evidence and outcome vocabulary

The path from Reality to action MUST remain explicit in names and engineering
prose:

- **Evidence** is an observed fact, signal or claim together with its limits and
  provenance.
- A **Snapshot** is evidence captured for a stated scope and time; it is not
  necessarily current later.
- **Knowledge** is evidence whose support and limits justify reuse for a stated
  question.
- A **Classification** assigns a subject to a defined semantic category.
- A **Verdict** is a bounded conclusion answering a specified question.
- A **Decision** selects or establishes a supported course or responsibility
  from supported alternatives. It does not imply that physical actuation
  authority already exists; Bounded Authority remains downstream of Current
  Responsibility.
- A **Request** asks an authority or executor to perform bounded work; it does
  not prove acceptance or completion.
- An **Outcome** reports what actually resulted, including failure, partial
  completion or neutralisation.

An actuator command or target MUST NOT be named or interpreted as evidence that
the intended semantic Outcome occurred. Success returns through Reality,
Observation and the appropriate assessment.

## Identity vocabulary

Identity suffixes MUST preserve their declared semantics:

- `...Id` — stable semantic identity within its declared scope;
- `...ReferenceKey` — a value used to resolve or correlate an external/runtime
  reference; not architectural identity without independent authority;
- `...Token` — an opaque capability, lease, continuation or correlation value
  whose meaning belongs to its issuer;
- `...Key` — a lookup or association key with explicitly documented scope;
- `...Index` — a position in an ordered collection or representation; and
- `...Count` — a quantity of items, never an identity or position.

An external/runtime reference key MUST NOT silently become architectural
identity. When both concepts are required, they MUST be represented and named
separately.

## State vocabulary

State-related nouns MUST match the authority and lifecycle actually represented:

- `Kind` distinguishes stable semantic variants of a concept.
- `Class` or `Classification` records an interpreted category under stated
  criteria.
- `State` records a meaningful condition with defined transitions and
  invariants.
- `Status` reports current progress or condition and may be observational rather
  than lifecycle authority.
- `Phase` is a procedural step within a process.
- `Mode` selects an operating strategy or behaviour within one responsibility.
- `Cause` identifies the producing event or condition.
- `Reason` explains the rationale for a conclusion, decision or action.
- `Disposition` records the decided handling or terminal treatment of a subject.

Persistence MUST NOT promote a procedural `Phase` into an architectural Current
Responsibility. The name must describe the concept's actual authority and
lifecycle.

## Booleans, numbers and units

OuttaMyWay-owned boolean names MUST read as clear predicates such as `isActive`,
`hasAuthority`, `canProceed` or `shouldRelease`. An externally fixed schema name
is exempt at the external boundary.

A numeric name MUST include its unit when the unit is not fixed unambiguously by
the surrounding type, API or contract. Suitable forms include `distanceM`,
`speedMps`, `speedKmh`, `elapsedMs` and `durationSec`; constants may use forms
such as `_DISTANCE_M`, `_SPEED_KMH`, `_INTERVAL_MS`, `_FRACTION` and `_COUNT`.

A constant MUST NOT be shared merely because two concepts currently have the
same numeric value. Shared ownership requires shared semantic meaning.

## Constants and Configuration

Player Configuration is distinct from implementation constants and policy.

A value MAY be module-local when its meaning is local to that module. A shared
constant MUST have an identifiable shared semantic owner. A generic global
constants/settings namespace MUST NOT be created merely to centralise unrelated
values.

Only responsibilities that are genuinely system-wide may place names on the
root `OuttaMyWay` namespace. The owning Architecture or Specification determines
whether a value is genuinely system-wide; this Naming standard does not create
that authority.

These conventions do not redesign `scripts/config.lua` or duplicate the
[Configuration architecture](CONFIGURATION.md).

## Historical provenance

Git owns chronology.

Production modules MUST NOT carry rolling `TEST`, `CANONICAL CANDIDATE`, release
version, Issue, PR or decision-ID headers merely to record development history.

Historical explanation MAY remain in current engineering surfaces when it is
necessary to understand a still-current external constraint or observed GIANTS
behaviour, but current source explanation MUST express the constraint using
current concepts rather than development-origin labels.

Deliberately historical or research evidence MAY retain provenance identifiers
where they remain materially useful. Historical provenance does not grant current
semantic authority.

## Validation vocabulary

> **Current Validation Contract != Historical Assertion Payload**

Current validation test names, helpers, local concept identifiers and explanatory
comments MUST use current architectural or implementation vocabulary when they
express a current contract.

A historical identifier MAY remain when validation intentionally:

- asserts that a retired production token is absent;
- preserves historical fixture/evidence provenance; or
- examines deliberately historical evidence whose identity remains materially
  meaningful.

Historical text inside an assertion is payload, not automatically current
validation identity.

> **Validation Vocabulary Closure != Historical Evidence Erasure**

Historical identifiers MUST NOT be removed through a blanket test-tree
prohibition when their historical meaning is part of the evidence being tested.
Conversely, historical probes MUST NOT be cosmetically promoted into current
production concepts merely to satisfy naming uniformity.

## User-facing terminology

Player-facing names MUST describe player choices and observable behaviour. They
MUST NOT expose internal architecture, implementation jargon or historical
experiment names as player concepts.

This standard does not define GUI or HUD design; that responsibility remains with
the appropriate GUI/HUD architecture.

## Transitional non-conformance

Adopting this convention does not require cosmetic rewriting of genuine
historical or research provenance.

For current implementation:

1. new or extracted code MUST follow this convention immediately;
2. moved or substantially changed code MUST be renamed when its responsibility
   is clarified by the change;
3. historical/research material MAY retain provenance where it remains useful
   evidence;
4. compatibility aliases MAY be retained only when an actual compatibility
   boundary requires them; and
5. behavioural changes MUST NOT be introduced merely to achieve naming
   uniformity.

Existing current names that still diverge from this standard remain ordinary
implementation debt. They are discovered and corrected through bounded
architecture/source review or the future Architecture -> Specification -> source
traceability route; this document MUST NOT become a rename backlog.

A rename must improve the predictability of responsibility.

## Naming review test

Before accepting a new or changed name, verify:

- What responsibility does the name claim?
- Does the implementation actually own that responsibility?
- Does the name imply authority the component lacks?
- Is the term architectural, implementation, validation or historical
  vocabulary?
- Would a new contributor predict its repository location?
- Would they know whether it observes, interprets, decides, authorises or acts?
- Does it describe current meaning rather than development origin?
- Is an accepted architectural term already available?
- Would the name survive a change in implementation mechanism?

If those questions cannot be answered truthfully, the name is not ready to be
accepted.