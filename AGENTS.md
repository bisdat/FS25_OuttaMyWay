# Codex Working Rules

## Repository authority and workflow

- Treat `main` as the last accepted and tested repository state.
- Use clean, current `main` as the normal baseline for ordinary Engineering Increments, even when it is newer than the latest canonical release.
- Do not commit directly to `main`. Work on a short-lived branch and open a pull request for review.
- Do not merge pull requests automatically unless the repository owner explicitly instructs you to do so.
- An ordinary pull-request merge advances Accepted Repository State; it is not canonicalisation.
- Only a pull request explicitly designated in advance as a **Release Declaration PR** can become canonical. The repository owner's merge of that PR is the **Canonical Merge** and declares the resulting exact `main` commit canonical for its named version.
- A Git tag, GitHub Release or package may record or process release material but does not create canonical authority.
- Do not change the mod version, canonical labels, release identity, or release manifests unless the task explicitly requires it.
- Do not infer that a newer branch is more authoritative than the latest owner-accepted state.

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

## Current architectural authority

Before changing runtime behaviour, start with `docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`, then read specialised architecture such as `docs/architecture/SPATIAL_NEGOTIATION_MODEL.md`, `docs/CONTINUATION_STATE.md` and applicable current decision material. Treat historical documents as evidence/provenance where they conflict with current accepted architecture.

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

## Validation

**Validation Execution Separation:** GitHub Actions owns execution of the repository offline validation suites under `/tests` for ordinary Engineering Increments. The implementation agent owns inexpensive implementation-local sanity checks and interpretation of the resulting CI evidence; it does not duplicate CI execution.

During an ordinary Engineering Increment:

- do **not** run `pytest`, `tests/replacement_core/run.lua`, or equivalent repository test suites locally unless the repository owner explicitly requests it or the increment is specifically investigating validation machinery;
- tests may be read as executable contract evidence and may be changed when the accepted contract genuinely changes, but must not be weakened or rewritten merely to obtain green CI;
- run Lua syntax checks for changed Lua files;
- run `git diff --check`;
- inspect `git status` and the final diff;
- do not leave temporary files, logs, generated ZIPs, test artefacts or OS/editor files in the repository;
- after pushing the branch, use GitHub Actions as the independent execution authority for repository/offline validation.

`Structural contracts` is the required blocking check on `main`. `Lua offline observation (non-blocking)` remains observational while its existing failures are being reconciled.

Do not claim Farming Simulator field/runtime validation unless it was actually performed and the evidence is available. Implementation-local checks, CI offline validation and in-game Reality validation are separate claims.

The Repository Release System is retired and absent from the current working tree.
Do not reconstruct or reintroduce it without a new explicit engineering decision.

Do not perform test-package production, release packaging, publication validation or external submission unless explicitly requested. Packaging is separate from accepted/canonical source authority.

## Licensing

- The repository is licensed under the Mozilla Public License 2.0 as recorded in `LICENSE`.
- Do not modify `LICENSE` or change the project licence unless explicitly instructed by the repository owner.
- Preserve existing third-party notices, provenance and trademark ownership statements.
