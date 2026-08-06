# Engineering Handover

> **Candidate:** v4.7.12 Field World Equivalence Evidence

## Immediate continuation

Validate one bounded live run, then canonicalise even if spatial equivalence remains imperfect. The repository now preserves full canonical vertices and comparison metrics needed for the next conversation. Do not silently promote sampled overlap or any tolerance into Field World identity authority.

> **Candidate:** v4.7.12 Field World Equivalence Evidence

## Required live evidence

Stagger starts for workers in 68, 69, 70, upper split-77 and lower split-77. Confirm the first three report one fingerprint and one Operation; the split workers report distinct fingerprints and distinct Operations despite both locators being 77. At steady state passive traces must reach five Job Episodes and `globalOperations=3`. Stop in reverse order and confirm correct lifecycle. Control must remain false.

> **Canonical baseline:** v4.7.4  
> **Candidate:** v4.7.12 Field World Equivalence Evidence  
> **Architecture authority:** canonical v4.6.78  
> **Control authority:** disabled

## Why this candidate exists

v4.7.9 closed the complete passive live pipeline but exposed two residual defects: farmland mapping was treated as field authority, and a manually stopped Job Episode remained unresolved. The user then supplied direct evidence that source fields 68, 69 and 70 can retain individual labels while forming one contiguous worked area.

## Identity model under test

```text
Source Field Identity
    exact retained map/GIANTS source-field polygon label

Farmland Identity
    larger contextual ownership/margin area; never field authority

Derived Field World Identity
    experienced contiguous agronomic workspace; may contain several source labels
```

v4.7.10 keeps provisional Operation grouping by source field while passively discovering the GIANTS-derived boundary. The derived boundary is diagnostic only and cannot yet govern Operation identity or Control.

## Job Episode termination rule under test

A previously active Job Episode ends only when all of the following are observed:

- the same source token is retained as `spec_aiJobVehicle.lastJob`;
- `spec_aiJobVehicle.job` and any exposed current-job slot are empty;
- the previous job is absent from `mission.aiSystem.activeJobs`;
- GIANTS AI and field-work state are inactive.

A stale `spec_aiFieldWorker.fieldJob` reference does not block termination. The terminal cause is recorded generically as `SOURCE_INTENT_TERMINATION`; the adapter does not guess player stop versus GIANTS abort/fault.

## Expected load line

```text
FS25_OuttaMyWay v4.7.10 source-field authority, derived Field World discovery and source-intent termination loaded; Control authority disabled
```

## Useful probe lines

```text
[FS25_OuttaMyWay][FIELD-PROBE] ... sourceFieldId=68 ... source=CURRENT_POSITION_SOURCE_FIELD_POLYGON ... control=false
[FS25_OuttaMyWay][FIELD-WORLD-PROBE] STARTED ... control=false
[FS25_OuttaMyWay][FIELD-WORLD-PROBE] DISCOVERED ... sourceFields=68,69,70 ... control=false
```

The field-77 passive trace should resemble:

```text
field=field-world:provisional-source-field:77 active=2 episodes=2 operations=1 selected=CONTINUE_OBSERVATION decision=CONTINUE_OBSERVATION control=false
```

After the Valtra stop, its trace should show `ended=1`, `episodes=0`, `operations=0` for its provisional field-68 observation.

## Mandatory prohibitions

Do not:

- infer field identity from farmland ID;
- treat a source field label as the final derived Field World identity;
- terminate from inactivity alone;
- terminate on blockage or OuttaMyWay Hold;
- apply live Decisions to Commitments;
- dispatch physical Control;
- import archived runtime modules.