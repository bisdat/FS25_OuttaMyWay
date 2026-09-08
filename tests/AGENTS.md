# Tests Working Rules

These instructions apply to the entire `/tests` subtree and specialise the repository-root `AGENTS.md`.

## Responsibility

`/tests` owns source-controlled executable offline validation assets and replay fixtures. GitHub Actions owns ordinary execution of these suites.

**Test Visibility is not Test Execution Responsibility.** Read tests when they help establish the current executable contract, but do not run the repository suites locally during an ordinary Engineering Increment.

## Execution

- Do not run `pytest`, `replacement_core/run.lua`, or equivalent repository test suites unless the repository owner explicitly requests local execution or the task is specifically investigating validation machinery.
- Do not substitute a local agent run for the GitHub Actions result attached to the proposed commit.
- Implementation-local syntax/static sanity checks outside the repository suites remain governed by root `AGENTS.md`.

## Modification

- Tests protect current accepted contracts, not historical repository topology.
- Change a test only when the asserted contract, fixture responsibility, or validation mechanism genuinely changes.
- Do not weaken, delete, skip, or rewrite a test merely to make an implementation change pass CI.
- Preserve failure evidence. A failing test may indicate architecture disproved, implementation defect, architecture/implementation mismatch, invalid test assumption, insufficient instrumentation, or environment/runtime change.
- Keep replay fixtures and validation assets in their responsible `/tests` locations unless a deliberate responsibility change establishes a successor.

## Evidence

GitHub Actions provides the independent execution evidence for ordinary pull requests:

- `Structural contracts` is blocking.
- `Lua offline behavioural contracts` is blocking. Its two inner Lua steps retain `continue-on-error` only so both outcomes are collected; a final enforcement gate fails the job unless both are successful.
- **Evidence Collection != CI Enforcement**: preserving both failure witnesses does not weaken the blocking verdict.
- Neither offline mechanism proves GIANTS in-game Reality.
