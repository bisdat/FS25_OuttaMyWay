FS25_OuttaMyWay v4.7.1 — Observation and Job Episode Identity Candidate

This candidate begins from owner-declared canonical v4.7.0.

Canonical implementation baseline:
- Version: v4.7.0
- ZIP SHA-256: 08577eb096b6c7555ebda9616fc09160f9ab8266717c6db2e7ad37b5ba38d2d5
- Git commit: 49c01602b10546c3e61d180703f982e2f0d4d9ef

v4.7.1 adds offline-only canonical Observation and identity enforcement:
- stable assembly and component identities from reference keys;
- immutable raw Observation Snapshots;
- rejection of Decision/lifecycle semantics from Observation;
- independently admitted Job Episode identities;
- canonical termination rules for player stop/takeover, GIANTS abort/fault, restart and replacement;
- explicit preservation of Job Episodes through blockage, OuttaMyWay Hold and temporary inactivity.

There is still:
- no GIANTS live observation hook;
- no Situation Assessment or Operational Picture construction;
- no Candidate Action generation;
- no Decision;
- no physical Control.

Expected in-game load evidence, if a load check is performed:
FS25_OuttaMyWay v4.7.1 observation/identity foundation loaded; Control authority disabled

This candidate is not canonical until explicitly declared by the repository owner.
