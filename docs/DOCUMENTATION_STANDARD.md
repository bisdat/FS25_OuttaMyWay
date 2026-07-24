# Documentation Standard

> **Authority:** Canonical  
> **Currency:** Reviewed for candidate release v4.6.1  
> **Owner:** Repository governance

This document defines the mandatory conventions for documentation in the OuttaMyWay repository. It governs presentation and discoverability; it does not redefine engineering architecture or project behaviour.

## Canonical Project Name

The canonical project name is `OuttaMyWay`.

Use `OuttaMyWay` consistently in repository documentation, package names, code identifiers and tooling. Do not insert spaces within the canonical project name.

## Document Identity

The repository supplies project context. A document heading supplies only the document's identity.

Use:

```markdown
# Engineering Journal
```

Do not prefix headings with the project name:

```markdown
# OuttaMyWay — Engineering Journal
```

The first non-metadata heading in each Markdown document must be a single level-one heading.

## Filenames

First-class governance and reference documents use uppercase snake-case Markdown filenames, for example:

```text
ENGINEERING_ARCHITECTURE.md
PROJECT_STATUS.md
DOCUMENTATION_STANDARD.md
```

Architecture Decision Records retain their established `ADR-####` naming convention. Historical filenames may remain unchanged when renaming would damage traceability.

## Metadata

Documents whose authority or currency may be ambiguous should declare metadata immediately below the title.

Supported fields include:

- `Authority`
- `Currency`
- `Lifecycle`
- `Owner`

`Last reviewed for canonical release` records when enduring content was checked. It does not claim that the document originated in, or is versioned identically to, that release.

## Versions

Current-state documents must identify the active canonical release where required by the Canonical Release Contract.

Historical records, changelog entries, decision statuses and archive lifecycle statements retain the version in which the recorded event occurred. They must not be rewritten merely to match the current package.

Commands and package examples in active tooling documentation must use the current canonical version.

## Links and Discoverability

Every first-class Markdown document must appear exactly once in the documentation map, grouped by responsibility.

Use relative links for repository content. A canonical release must contain no broken relative Markdown links.

Archived documents must be linked from the archive section of the documentation map. Removed compatibility paths are not retained unless an identified consumer still requires them.

## Heading Hierarchy

Use headings in descending hierarchy without skipping levels solely for visual effect.

- `#` document title
- `##` major section
- `###` subsection

Do not use headings as captions or emphasis.

## Document Ordering

Each document uses the ordering that best serves its human reader and its responsibility; the repository does not impose one global alphabetical rule.

- glossaries normally favour alphabetical lookup, but the accepted legacy ordering may remain until a deliberate reordering increment is justified;
- decision logs preserve decision identity and place current or newer decisions first;
- changelogs place newer releases first;
- roadmaps follow lifecycle, dependency or priority;
- architecture follows conceptual dependency and explanatory flow.

Reordering must not alter meaning, authority or historical identity.

## Terminology

Use terminology defined by the canonical architectural documents and `GLOSSARY.md`.

Do not create near-synonyms for accepted architectural concepts. When a recurring observation appears to require new terminology, treat it as an architectural discovery candidate rather than silently introducing vocabulary.

## Diagrams and Code Blocks

Use diagrams when they clarify system relationships or engineering flow. Diagrams describe concepts, not implementation convenience.

Fenced code blocks must identify a language where practical. Plain-text structures and command examples may use `text`.

## Archive Policy

Archive preserves superseded knowledge. It does not provide current authority.

An archived document must:

- declare Historical authority or equivalent lifecycle metadata;
- remain discoverable through the documentation map;
- preserve its historical version statements;
- avoid masquerading as a current instruction.

Compatibility signposts are temporary mechanisms, not a default archive feature. They expire when no identified consumer requires the old path.
