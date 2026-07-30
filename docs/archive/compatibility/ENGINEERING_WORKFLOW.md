# Archived Engineering Workflow

> **Authority:** Historical
>
> **Lifecycle:** Archived in canonical release v4.5.2

This document is retained as evidence of the project’s earlier engineering model. It is not authoritative for current work.

---

# Engineering Workflow

The authoritative workflow is defined by `ENGINEERING_ARCHITECTURE.md`.

## Session Continuity

At the start of a session:

1. Use the latest complete canonical ZIP as the baseline.
2. Read `PROJECT_STATUS.md` and `ENGINEERING_HANDOVER.md`.
3. Follow their references to the relevant architecture, concepts, decisions and evidence.

At the end of a significant session:

1. Record durable discoveries and decisions in their authoritative homes.
2. Update current status and handover.
3. Review Accepted, Deferred and Rejected concepts.
4. Increment the version for every repository change.
5. Run the repository verifier and release pipeline.
6. Share the complete validated ZIP; it becomes the next canonical baseline.

## Commands

```text
python tools/verify_repository.py --version 4.5.0
python tools/release_pipeline.py --version 4.5.0 --output ../FS25_OuttaMyWay_v4.5.0.zip
```

See `tools/README.md` for tooling responsibilities and limits.
