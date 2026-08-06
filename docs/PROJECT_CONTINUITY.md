# Project Continuity

## v4.7.14 implementation candidate boundary

v4.7.14 derives from owner-declared canonical v4.7.13:

- ZIP SHA-256: `29b50173f00b5fb48355cadf848eadbaed5f24a13b2bfced558672ee0f21363e`
- Git commit: `d813f5be6f948bd5143b8945c3ab883af397db2d`
- Repository files: 245

The candidate implements ADR-0021 without changing its architecture. It separates immutable Snapshot identity, exact polygon representation and resolved Field World identity; adds pure pairwise evaluation and class-wide authority; groups Operations only by resolved Field World identity; and denies Operation authority to unresolved evidence. Control remains disabled.

The implementation is offline-conformant. Its next gate is passive concurrent validation in the merged 68–69–70 workspace. No live equivalence success is claimed by this candidate.

## v4.7.13 architecture boundary

v4.7.13 closed Field World Equivalence Authority architecture through ADR-0021 and D-0033. It superseded exact-fingerprint identity authority while retaining exact fingerprints as representation provenance.

## v4.7.3 implementation boundary

v4.7.3 derives from owner-declared canonical v4.7.2:

- ZIP SHA-256: `f11597c3b46f1ad5da94cc8c8135400e3b613475701d10559fae65fe8e4bb22f`
- Git commit: `7f89d405ae64afed5b7c29bec40e0b8220e215ad`
- Repository files: 209

The canonical v4.6.78 architecture remains authoritative. v4.7.3 added only the offline Candidate Action, mandatory Constraint Verdict and deterministic Decision boundary.
