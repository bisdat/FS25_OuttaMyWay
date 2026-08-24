# Legacy Script Archive — historical record

> **Current status:** in-tree archive removed by D-0184 / v0.1.9.1 TEST.

At the v4.7.0 replacement-core bootstrap, the v4.6.78 active script tree was preserved byte-exactly under `scripts/archive/v4_6_78/` as a non-executable donor/failure record. That served its migration purpose.

D-0184 removes the executable-looking archive from the live repository after dependency and authority closure. Git history, canonical release artifacts, `LEGACY_MODULE_DISPOSITION.csv`, ADR-0020, the Decision Log and Removal Register now provide the historical evidence.

## Current rule

- no `scripts/archive/` directory is shipped;
- retired implementation is recovered from Git/canonical artifacts when historical review is genuinely required;
- active code may not recreate legacy authority by copying old modules back into the runtime;
- donor mechanisms require a current named architectural owner and focused reimplementation.

## Historical provenance

# Legacy Script Archive

> **Current series:** v4.7.x replacement-core implementation  
> **Architecture authority:** owner-declared canonical v4.6.78

The complete 48-file v4.6.78 active script tree is preserved byte-exactly under `scripts/archive/v4_6_78/`.

## Rules

- archived code is not loaded or called;
- active code may not import the archive;
- old Decision, lifecycle, authority and fallback semantics have no implementation authority;
- a proven physical mechanism may be mined only through function-level review and reimplemented behind a canonical interface;
- every extracted mechanism must record its source path, empirical purpose and excluded legacy semantics.

`SHA256SUMS.txt` inside the archive provides file-level byte verification.

The disposition of each former active module is recorded in `LEGACY_MODULE_DISPOSITION.csv`.
