# Engineering Working Rules

## Repository authority and workflow

- Treat `main` as the last accepted and tested repository state.
- Use clean, current `main` as the normal baseline for ordinary Engineering Increments, even when it is newer than the latest canonical release.
- Do not commit directly to `main`. Work on a short-lived branch and open a pull request for review.
- Do not merge pull requests automatically unless the repository owner explicitly instructs you to do so.
- An ordinary pull-request merge advances Accepted Repository State; it is not canonicalisation.
- Only a pull request explicitly designated in advance as a **Release Declaration PR** can become canonical. The repository owner's merge of that PR is the **Canonical Merge** and declares the resulting exact `main` commit canonical for its named version.
- A Git tag, GitHub Release or package may record or process release material but does not create canonical authority.
- Do not change canonical labels, release identity, or release manifests unless the task explicitly requires it. Non-canonical TEST build identity follows the standing rule below.
- Do not infer that a newer branch is more authoritative than the latest owner-accepted state.

### TEST build identity before push

Every pushed revision that changes executable mod code must carry a fresh non-canonical TEST build identity before that branch revision is published for pull-request review, CI, or Farming Simulator testing. Do not reuse one TEST build identity for materially different executable bytes.

Advance the `BUILD` component once for the coherent pushed code revision under the repository's `0.MINOR.PATCH.BUILD` policy. Current TEST build version has exactly two source owners and both must change atomically:

- `scripts/config.lua`: `OuttaMyWay.VERSION`;
- `modDesc.xml`: the mod version value/text, equal to `OuttaMyWay.VERSION`.

`scripts/main.lua` is the runtime entry point and must not carry a current build-version literal. Behavioural, architectural and source-structure regression tests must not hard-code the current TEST version merely as a provenance sentinel. One dedicated structural **Build Identity Contract** dynamically reads the two owner files, proves their coherence, and proves the current version literal has not leaked back into runtime/test surfaces.

Historical evidence, archived material, journal entries, release records, and other provenance that truthfully name an earlier build must not be renumbered merely to satisfy the current build identity.

Documentation-only, test-only, governance-only, or other non-executable changes do not consume a new TEST `BUILD` unless the repository owner explicitly requests one. A version-only identity correction after already-tested executable bytes likewise does not imply a new behavioural claim; it gives those bytes a unique future-facing identity.

## Engineering method

Use the project loop:

`Observe -> Discuss -> Hypothesise -> Implement -> Validate -> Record -> Repeat`

Keep these activities distinct:

- Architecture defines what the system should achieve and which responsibilities/concepts exist.
- Implementation discovers how those responsibilities can be realised.
- Testing validates or disproves assumptions against Reality.

Do not let implementation convenience dictate architecture. Do not defend existing architecture merely because code already implements it. When evidence contradicts architecture, record the discovery and update the architecture deliberately.

When changing code:

- minimise intentional behavioural change;
- isolate changes so their effects can be attributed;
- preserve architectural intent;
- avoid speculative refactoring;
- keep modules focused on one responsibility;
- prefer generic, constructive fixes over scenario-specific exceptions;
- consider previously validated scenarios before accepting a fix.

A failed hypothesis or test is evidence, not wasted work. Record what was learned.

## Repository Context Bootstrap

Before interpreting a substantive repository task, classifying an observed defect,
proposing implementation, opening an Issue, or reviewing a pull request, reconstruct
the relevant current repository context. Do not rely on chat memory, carry-forward
material, a PR body, or one familiar document as a substitute.

Start in this order:

```text
AGENTS.md
    ↓
docs/README.md
    ↓
docs/ENGINEERING_ARCHITECTURE.md
    +
docs/CONTINUATION_STATE.md
    ↓
task-relevant responsibility routes
```

Follow the responsibility routes that can materially affect the question:

- runtime/system semantics → `docs/architecture/README.md`, then
  `docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md` and applicable
  specialised architecture;
- GIANTS/FS25 runtime behaviour or API assumptions → `docs/engine/README.md`,
  then `docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md` and
  `docs/engine/GIANTS_API_SURFACES.md` where applicable;
- current implementation placement or strangler state →
  `docs/IMPLEMENTATION_MAP.md`;
- Configuration or mixed runtime constants → `docs/CONFIGURATION.md`;
- names, vocabulary, identifiers, or new durable terminology →
  `docs/NAMING_CONVENTIONS.md`;
- validation, regression, fixtures, or evidence strength →
  `docs/TESTING_METHODOLOGY.md`, `tests/AGENTS.md`, and the relevant executable
  contracts;
- historical investigation or evidence → `docs/ENGINEERING_JOURNAL.md` and the
  responsible `docs/research/` route.

Do not read every branch ceremonially. Read to the depth required to understand
the responsibility being changed or reviewed.

For pull-request review, do not let the PR define its own universe. After the
bootstrap above, read the PR and linked Issue, inspect the changed-file list,
follow the governing responsibility documents for those files, perform the
Relevant Knowledge Sweep below, then assess the complete diff and CI/evidence.

## Relevant Knowledge Sweep

Before calling an observation **new**, proposing a fix for it, or creating a new
Issue, search for prior project knowledge using the observation's important
error strings, identifiers, module names, concepts, and synonyms.

The targeted sweep should cover, where relevant and accessible:

```text
current live documentation
        ↓
current source and executable contracts
        ↓
open GitHub Issues
        ↓
closed GitHub Issues
        ↓
open and merged pull requests
        ↓
Engineering Journal / research evidence
        ↓
Git history when provenance remains unclear
```

Classify the observation before creating new tracking work:

- **NEW** — no materially matching current or historical project knowledge found;
- **KNOWN OPEN** — the same unresolved condition is already recorded;
- **REGRESSION** — a condition recorded as corrected/closed has reappeared;
- **HISTORICAL / NOT CURRENTLY APPLICABLE** — related prior evidence exists but
  does not describe the current responsibility or condition.

Absence of access is not evidence of novelty. If a required Issue/PR/history
source is unavailable in the current environment, state that limitation before
classifying the observation as NEW.

## Current architectural authority

For runtime/system behaviour, the Repository Context Bootstrap must traverse
`docs/architecture/README.md`,
`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`, the applicable
specialised architecture and current Continuation State before implementation.
Treat historical documents as evidence/provenance where they conflict with
current accepted architecture.

Preserve these standing constraints unless an explicit architectural decision changes them:

- GIANTS owns AI jobs, productive routing, native turning and normal navigation. OuttaMyWay negotiates temporary space consumption and bounded intervention rather than replacing productive routing.
- The supported traffic envelope is at most three simultaneously active AI worker assemblies in one Operation, with validation targeted at different agronomic roles. The player vehicle does not count toward that limit.
- Do not resurrect continuous Productive History/Rook-style field reconstruction, dense route prediction, or equivalent high-cost geometry history as an implementation shortcut.
- Do not replace the retired historical `80 m` locality coupling with another universal distance literal without evidence and an explicit architectural reason.
- Do not use native `pairs`, `ipairs`, or `#` on sealed proxy collections where the repository's ValueRecord/proxy traversal rules apply.

## Human traceability

The repository must remain understandable to a fallible human engineer, not only searchable by an agent.

- Prefer explicit composition, ownership and call paths over implicit discovery.
- Do not introduce new dynamic directory/module discovery when explicit loading would make startup and responsibility boundaries easier to follow, unless there is a documented reason.
- When restructuring code, make architectural responsibility boundaries visible in the directory/file/function structure.
- Behaviour-preserving restructuring and behavioural implementation should normally be separate pull requests.
- Update navigation/code-map documentation whenever structural changes would otherwise make the execution path harder to follow.

## Naming authority

`docs/NAMING_CONVENTIONS.md` is the authoritative repository naming convention.
Read and follow it before creating or renaming files, modules, functions, types,
identifiers, configuration keys or durable architectural terminology. Existing
non-conforming source is transitional implementation debt and must not be copied
as precedent.

Do not perform unrelated repository-wide renaming merely to achieve conformity.
Reconcile existing naming only within an explicitly bounded Engineering
Increment or where changed responsibility makes the existing name materially
misleading.

## Configuration authority

`docs/CONFIGURATION.md` is the authoritative Configuration architecture. Read
and follow it before changing player Configuration or the mixed runtime constants
surface currently implemented in `scripts/config.lua`.

## Documentation roles

Protect document responsibilities so documentation does not become another changelog surface:

- root `README`/`README.md`: concise project explanation and navigation;
- `docs/README.md`: engineering start-here map;
- architecture documents: current system responsibilities and concepts;
- decision records/log: durable decisions and rationale;
- engineering journal/research: observations, discoveries, failed hypotheses and evolution;
- `docs/CONTINUATION_STATE.md`: current, replace-in-place engineering continuation point;
- changelog: release history and externally meaningful change chronology.

Prefer one authoritative home for each piece of architectural knowledge. Link to that authority rather than copying the same explanation into multiple documents that can drift independently.

After a significant discovery, decision, behavioural change, or structural change, update the relevant repository documentation as part of the same engineering increment.

### Documentation Creation Gate — Malicious Compliance guard

A request to "record", "document", "audit", "design", "capture the phase", or "update the architecture" is **not** permission to create another live documentation file. Local compliance with one instruction must not violate the repository's higher-order document responsibilities.

Before creating any new live file under `docs/`, all of the following must be true:

1. **Name the durable responsibility.** State in one sentence what enduring responsibility the proposed file would own after the current Issue, phase, tranche, experiment or migration has ended.
2. **Prove there is no existing owner.** Follow the Repository Context Bootstrap and show why the current responsible document cannot truthfully own the knowledge by update-in-place.
3. **Classify the content.** Current architecture/state may belong in a live responsible document. Engineering chronology, tranche boundaries, migration plans, implementation hypotheses, audit evidence, validation history and closure narratives belong in Git/PR/Issue history, `CONTINUATION_STATE.md`, `ENGINEERING_JOURNAL.md`, `research/`, or another already-authorised evidence/history surface as appropriate.
4. **Reject phase-shaped architecture containers.** A Phase/Step/Tranche/Increment/Audit/Closure document does not become live architecture merely because it contains architectural reasoning. Do not create `PHASE_*`, `STEP_*`, tranche-specific or equivalent live architecture files to record engineering progression unless the repository owner explicitly authorises a new durable document responsibility.
5. **Record significant discoveries by ownership, not proliferation.** The instruction to record a significant discovery means update its existing authoritative home and, where useful, the Journal/Continuation/PR. It does not mean create a new document.
6. **Do not justify a file by breadcrumbing it.** First establish durable responsibility; only then add navigation. A README link cannot manufacture authority for a file whose responsibility does not exist.
7. **Current architecture must be directly readable.** A future engineer must not have to replay Phase N.1 -> N.2 -> N.3 documents or apply chronological deltas to reconstruct the present system. **Current Architecture Should Not Require Historical Reconstruction.**

If any condition is unresolved, **do not create the new live document**. Update the existing responsible owner, use the authorised history/evidence surfaces, or leave the question in Continuation/PR review until ownership is established.

This is the operational form of **Engineering Increment Documentation != Durable Architecture** and the repository's existing Stranded Live Knowledge / stale-responsibility rules.

## Validation

**Validation Execution Separation:** GitHub Actions owns execution of the repository offline validation suites under `/tests` for ordinary Engineering Increments. The implementation agent owns inexpensive implementation-local sanity checks and interpretation of the resulting CI evidence; it does not duplicate CI execution.

During an ordinary Engineering Increment:

- do **not** run `pytest`, `tests/replacement_core/run.lua`, or equivalent repository test suites locally unless the repository owner explicitly requests it or the increment is specifically investigating validation machinery;
- tests may be read as executable contract evidence and may be changed when the accepted contract genuinely changes, but must not be weakened or rewritten merely to obtain green CI;
- run Lua syntax checks for changed Lua files;
- for changed text rendered through a GIANTS texture-font surface, run a **Known Rendered Glyph Check** against known unsupported glyphs recorded in `docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md`; this checks demonstrated renderability knowledge and does not establish a generic non-ASCII ban;
- run `git diff --check`;
- inspect `git status` and the final diff;
- do not leave temporary files, logs, generated ZIPs, test artefacts or OS/editor files in the repository;
- after pushing the branch, use GitHub Actions as the independent execution authority for repository/offline validation.

`Structural contracts` and `Lua offline behavioural contracts` are blocking CI contracts on `main`. The Lua job deliberately collects both inner harness outcomes before a final enforcement gate fails the job if either outcome is not successful. Neither offline contract proves GIANTS in-game Reality.

Do not claim Farming Simulator field/runtime validation unless it was actually performed and the evidence is available. Implementation-local checks, CI offline validation and in-game Reality validation are separate claims.

The Repository Release System is retired and absent from the current working tree.
Do not reconstruct or reintroduce it without a new explicit engineering decision.

Do not perform test-package production, release packaging, publication validation or external submission unless explicitly requested. Packaging is separate from accepted/canonical source authority.

## Licensing

- The repository is licensed under the Mozilla Public License 2.0 as recorded in `LICENSE`.
- Do not modify `LICENSE` or change the project licence unless explicitly instructed by the repository owner.
- Preserve existing third-party notices, provenance and trademark ownership statements.