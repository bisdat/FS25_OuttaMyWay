# FS25_OuttaMyWay Project Status

> **Canonical baseline:** v4.7.4 Replay Conformance  
> **Current candidate:** v4.7.12 Field World Equivalence Evidence  
> **Control authority:** disabled

## Closure gate

Run short serial starts in merged areas 68, 69 and 70, plus both disconnected parts of split 77. Confirm `GEOMETRY` and `COMPARE` evidence is emitted, exact 70 mismatches are measurable rather than lost, split 77 remains clearly spatially distinct, no Operation merging occurs from diagnostic equivalence, and all Job Episodes terminate cleanly. After this bounded gate, canonicalise v4.7.12 with the exact-fingerprint limitation explicitly retained.

> **Canonical baseline:** v4.7.4 Replay Conformance  
> **Current candidate:** v4.7.12 Field World Equivalence Evidence  
> **Control authority:** disabled

## v4.7.11 canonicalisation gate

Run five concurrent workers with staggered starts: three seeded in merged areas 68, 69 and 70, plus one in each disconnected part of split field 77. Expected steady state: five active Job Episodes, three geometry Field Worlds and three active Operations. Stop workers individually and confirm independent split-77 settlement plus persistence of the merged Operation until its final member ends.

> **Canonical baseline:** v4.7.4 Replay Conformance  
> **Current candidate:** v4.7.12 Field World Equivalence Evidence  
> **Candidate lineage:** exact v4.7.9 candidate bytes  
> **Architecture authority:** canonical v4.6.78  
> **Control authority:** disabled

## Current understanding

v4.7.9 achieved **Live Replacement-Pipeline Closure**: real GIANTS active-job evidence crossed immutable Observation, Job Episode admission, field grouping, Operation admission and deterministic passive Decision with `control=false`.

Two implementation boundaries remained:

1. farmland-to-field mapping produced numerically correct labels but gave farmland contextual evidence too much authority;
2. a manually stopped Valtra Job Episode remained open because generic inactivity correctly did not prove termination.

The user additionally confirmed that source fields 68, 69 and 70 retain individual map labels while forming one contiguous agronomic area.

## v4.7.10 test boundary

v4.7.10 therefore:

- establishes **Source Field Identity** only through exact source-field polygon containment;
- records farmland identity as contextual containment only;
- labels source-field Operation grouping as provisional;
- passively invokes GIANTS `FieldCourseField.generateAtPosition` to discover the separate **Derived Field World Identity**;
- reports the retained source field labels contained by that derived boundary;
- ends a Job Episode only when its previous token matches `lastJob`, the authoritative active job slot is empty, the job is absent from mission active jobs and GIANTS AI state is inactive;
- preserves unresolved inactivity and blockage as non-terminal;
- performs no live Commitment mutation and no Control.

## Required live evidence

Repeat the Valtra field-68 stop followed by Condor and Patriot on field 77. The target result is:

- source field 68 and 77 established from polygon evidence;
- Valtra Job Episode and field-68 provisional Operation end after positive source-intent termination evidence;
- Condor and Patriot retain stable Job Episodes through blockage;
- one provisional source-field-77 Operation remains active;
- GIANTS derived Field World probe completes without intervention;
- merged 68–69–70 may be reported as one derived Field World containing three source labels;
- all traces remain `control=false`.

v4.7.10 remains non-canonical pending owner live evidence and explicit declaration.