# Naming conventions

This document is the authoritative repository convention for names in source,
configuration, tests, diagnostics and engineering prose. Its primary objective
is semantic truthfulness, not cosmetic uniformity. Naming should make ownership,
authority and the path from evidence to action predictable to a new contributor.

## Governing principles

- Name a thing for its current responsibility, not its development origin.
- Use the durable vocabulary supplied by accepted architecture.
- Do not imply authority that the named component does not possess.
- Prefer the narrowest name that truthfully describes the responsibility.
- Let architectural discovery establish concepts before naming them. A name must
  not manufacture architecture or make an unresolved responsibility appear
  settled.
- Do not assume that each architectural concept requires a corresponding class,
  module or file. Concepts and implementation units are not one-to-one.
- Treat existing non-conforming names as transitional implementation debt, not
  precedent for new work.

## Architectural terminology

Use accepted architectural terms consistently and preserve their accepted
capitalization in engineering prose. This includes **Field World**, **Job
Episode**, **Local Operation**, **Observation**, **Situation Assessment**,
**Responsibility Transition**, **Current Responsibility**, **GIANTS AI**,
**Regulation**, **Resolution Commitment**, **Bounded Authority**, **Control**,
**Cooperative Passage** and **Physical Assembly**.

The architecture documents own the definitions and relationships of these
concepts. Naming work applies that vocabulary; it does not redefine it. Consult
the [Concept Register](CONCEPT_REGISTER.md) and the applicable documents under
[Architecture](architecture/README.md) when a term's authority is uncertain.

Decision identifiers such as `D-0146` record provenance. They are not primary
production, module or architectural names and must not substitute for a truthful
responsibility name.

## Repository, folder and Lua module names

- Name folders for the responsibility or cohesive subsystem they contain, not
  for the experiment, decision or implementation sequence that produced them.
- Use `PascalCase` for Lua module, type and file names.
- A Lua file and its primary module or type should normally have the same name.
- Give each file one principal responsibility. Keep closely related supporting
  work together when splitting it would create artificial fragmentation or hide
  the execution path.
- Production authority must not remain indefinitely beneath names such as
  `prototypes/` or `diagnostics/`, or carry `Shadow`, `TEST` or similar labels,
  after those labels cease to describe its actual responsibility.

Explicit composition and loading remain preferable where they make startup,
ownership and call paths easier for a human to follow.

## Lua function names and verbs

Use `lowerCamelCase` for Lua functions. Choose a verb that describes the
function's actual semantic effect:

| Verb | Expected meaning |
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
| `authorize` | Grant bounded permission within an already-established purpose or responsibility. It may narrow or refuse permitted action but must not invent strategic purpose. |
| `execute` | Perform an already-authorised action. |
| `dispatch` | Route already-authorised work to the responsible executor. |
| `release` | End a held responsibility, resource or bounded claim through its defined lifecycle. |
| `neutralize` | Put controlled actuation into its safe neutral condition. |
| `settle` | Discharge a defined obligation or procedure using the evidence required by its governing contract. Name what is being settled where ambiguity exists. |

Avoid broad public verbs such as `process`, `handle`, `attach`, `run` and generic
`update` when a more precise architectural verb is available. External or GIANTS
lifecycle APIs may impose such a name; keep that boundary name where required
and use precise internal names behind it.

In particular, `assess` interprets evidence but does not acquire responsibility
or Control; `evaluate` answers a bounded question and does not primarily mutate
lifecycle or authority; `dispatch` routes work whose authority already exists;
and `execute` performs action whose authority already exists.

## Responsibility-bearing nouns

Use responsibility-bearing nouns only for components that actually perform the
corresponding role:

| Noun | Responsibility claimed by the name |
| --- | --- |
| Source | Originates evidence or values from an identified boundary. |
| Adapter | Translates one explicit interface or representation to another without taking domain authority. |
| Assessment | An interpretation of evidence for a stated question and scope. |
| Evaluator | Answers a bounded question according to stated evidence and rules. |
| Authority | Owns the accepted determination or permission for its declared boundary. |
| Registry | Maintains identity-indexed records, lookup or membership representation for a defined population. Storage and lookup do not create semantic authority; that belongs to the responsibility establishing the record or lifecycle fact. |
| Ledger | Records durable facts or transitions with their provenance; it is not automatically the decision owner. |
| Policy | Defines rules for choosing or permitting action, separate from performing it. |
| Planner | Develops candidate future action without granting authority or executing it. |
| Coordinator | Sequences collaborators toward one cohesive responsibility. |
| Dispatcher | Routes already-authorised work to an executor. |
| Control | Realises authorised physical action through available mechanisms. |
| Probe | Collects bounded investigative evidence and has no production semantic or Control authority. |
| Diagnostic | Exposes or records information for investigation and has no production semantic or Control authority. |
| Shadow | Observes or compares without influencing production semantics or Control. |
| Prototype | Implements experimental, non-production responsibility. |

A Coordinator must not silently accumulate unrelated domain authority. Probe,
Diagnostic and Shadow explicitly claim no production semantic or Control
authority. When production runtime depends on a Prototype mechanism, that
mechanism has conceptually graduated; rename and re-home it in an appropriate
later bounded Engineering Increment.

## Evidence and outcome vocabulary

Keep the path from Reality to action explicit:

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

An actuator command or target is a Request or execution input, not evidence that
the intended semantic Outcome occurred. Success must come back through Reality,
Observation and the appropriate assessment.

## Identity vocabulary

- `...Id` is stable semantic identity within its declared scope.
- `...ReferenceKey` is a value used to resolve or correlate an external/runtime
  reference; it is not architectural identity without independent authority.
- `...Token` is an opaque capability, lease, continuation or correlation value
  whose meaning belongs to its issuer.
- `...Key` is a lookup or association key with explicitly documented scope.
- `...Index` is a position in an ordered collection or representation.
- `...Count` is a quantity of items, never an identity or position.

A runtime or external reference key must not silently become architectural
identity. If the implementation needs both, represent and name them separately.

## State vocabulary

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

Persistence does not promote a procedural Phase into an architectural Current
Responsibility. Use the term matching the concept's actual authority and
lifecycle.

## Booleans, numbers and units

Name booleans as clear predicates, such as `isActive`, `hasAuthority`,
`canProceed` or `shouldRelease`. Avoid ambiguous nouns and inverted names whose
truth value is difficult to read at a call site.

Include units where they are not otherwise unambiguous. Preferred forms include
`distanceM`, `speedMps`, `speedKmh`, `elapsedMs` and `durationSec`; constants use
forms such as `_DISTANCE_M`, `_SPEED_KMH`, `_INTERVAL_MS`, `_FRACTION` and
`_COUNT`.

Do not share a constant merely because two concepts currently have the same
numeric value. Shared ownership requires shared semantic meaning.

## Constants and Configuration

Player Configuration is distinct from implementation constants and policy. A
value used by one module should normally be module-local. A genuinely shared
value belongs to the responsibility or subsystem that gives it meaning. Only
truly system-wide identity and invariants belong on the root `OuttaMyWay`
namespace. Do not create generic global-variable dumping grounds.

These conventions do not redesign `scripts/config.lua` or decide deferred
Configuration architecture.

## Historical provenance

Git owns chronology. Do not add rolling `TEST`, `CANONICAL CANDIDATE`, release
version or D-number headers to production modules merely to record their history.
Retain a historical comment only when it materially explains a current
constraint or a discovered GIANTS behaviour that a maintainer needs in order to
change the code safely.

## User-facing terminology

Player-facing names describe player choices and observable behaviour. Do not
expose internal architecture, implementation jargon or historical experiment
names as player concepts. This convention does not define GUI or HUD design;
that architecture remains deferred.

## Transitional non-conformance

Adopting this convention does not trigger an immediate repository-wide rename.
Known implementation lag includes production mechanics under `Prototype22...`,
semantic Observation support under `LiveInteractionDiagnostics`, generic
Commitment vocabulary where current architecture distinguishes Regulation and
Resolution Commitment, D-number/prototype/test vocabulary in runtime surfaces,
and broad public verbs such as `attach()` where the responsibility is larger
than the verb suggests.

Track divergence through architecture and implementation review and the
[Implementation Map](IMPLEMENTATION_MAP.md), not by turning this document into a
rename backlog.

During later strangler or recomposition work:

1. New or extracted code follows this convention immediately.
2. Moved code is renamed when its responsibility is genuinely clarified.
3. Untouched legacy code may temporarily retain old naming.
4. Compatibility aliases are used only where genuinely required.
5. Behavioural changes are not justified merely to achieve naming uniformity.

A rename should improve the predictability of responsibility.

## Naming review test

Before accepting a new or changed name, ask:

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
