# Continuation State

Continuation State is the compact, replace-in-place description of the
project's present engineering boundary. Git history preserves prior states; this
is not a changelog, release ledger, or canonical-release record.

## Current engineering concern

Continue reviewing the remaining live documentation responsibility surfaces
after consolidating the evidence roots and reserving Configuration and GUI
architecture responsibilities.

## Established

- **Evidence Responsibility Fragmentation** is reconciled: Research now owns bounded prototype and focused representation investigation evidence beneath `research/prototypes/` and `research/representation/`.
- **Evidence Record ≠ Instrument Record** separates durable questions, methods, findings and limits from temporary logging, HUD, probe and sampling mechanics.
- **Probe Lifetime Follows Question Lifetime** is established as knowledge governance: closed questions preserve their durable result in its responsible home, not permanent documentation authority for the probe. Actual probe or diagnostic implementation sediment remains a future implementation observation/reconstruction question and is not selected here.
- **Diagnostic Documentation Generation Drift** was confirmed in the retired v4.7-era interaction diagnostics. Its final harvest found no additional uniquely current durable discovery.
- **Lifecycle Evidence Asymmetry** is Accepted in Runtime Responsibility Architecture and the Concept Register: positive or complete evidence may establish lifecycle change, while absence under incomplete observation cannot establish termination, supersession or membership loss.
- Root `IMPLEMENTATION_MAP.md` replaces the former `docs/code/` hierarchy and maps accepted architecture to principal current source placement without granting architectural authority to implementation vocabulary.
- **Configuration Architecture** and **GUI Architecture** are explicit Deferred responsibility placeholders. Current `config.lua` and diagnostic/test HUDs remain unreconciled implementation evidence, not accepted architecture.
- No runtime behaviour or tests changed.
- **Structure-Test Responsibility Drift** remains separate: structural tests retain assertions for retired or relocated live documents. The pre-increment baseline was 93 passing and 11 failing tests; ADR retirement had exposed `ADR-0023` as a stale dependency in two tests within that failing set. Knowledge-root consolidation now yields 92 passing and 12 failing tests because `test_v4767_d0138_native_field_worker_drive_command_probe_is_passive_and_sdk_aligned` still addresses `docs/prototypes/PROTOTYPE_32_NATIVE_AI_DRIVE_SIGNAL_SHADOW.md` instead of its Research location. This is stale test authority exposed by the documentation move, not a runtime regression. It is not repaired here and remains a future test-governance concern. Retired or relocated documents must not be restored merely to satisfy stale tests.

## Current boundary

Research is the predictable live home for bounded experimental and
investigative evidence. Instrumentation does not gain a permanent documentation
responsibility, and current implementation persistence does not establish
Configuration or GUI architecture.

## Next boundary

Continue reviewing remaining live documentation responsibility surfaces, then
separately investigate current probe/diagnostic implementation persistence once
the documentation topology is stable.

## Not currently active

- Runtime implementation or test changes.
- Defining the future probe/diagnostic reconstruction increment.
- Release preparation, packaging, publication, or canonicalisation.
- Restoring retired documents to satisfy stale references.
- Reorganising `docs/archive/`.
