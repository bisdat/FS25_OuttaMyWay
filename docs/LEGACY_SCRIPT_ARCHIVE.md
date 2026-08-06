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
