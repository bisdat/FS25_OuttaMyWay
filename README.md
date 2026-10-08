# OuttaMyWay

OuttaMyWay is a work-in-progress Farming Simulator 25 mod intended to preserve autonomous GIANTS fieldwork when workers compete for local space. GIANTS retains productive routing and normal AI jobs; the product goal is to minimise justified intervention and return authority as soon as possible.

## Current product

The accepted **0.5 rewrite shell** contains only persistent Configuration, Log Publication, the version-only HUD/status presentation and the disabled-startup reminder. **It neither observes nor controls GIANTS workers.** It does not predict encounters, regulate speed, hold vehicles, relocate obstacles or stop/restart AI jobs.

The completed native blocked-state probe has been retired. Its evidence remains in [Research](docs/research/NATIVE_BLOCKED_STATE_PROBE.md) and the version-qualified [GIANTS Engine Knowledge](docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md). Experimental findings are not runtime capabilities.

## Engineering breadcrumbs

- [Architecture](architecture/README.md) — the small current responsibility model and product vision.
- [Specification](spec/README.md) — implementation-facing contracts for active responsibilities.
- [Engineering start here](docs/README.md) — standards, validation methodology, engine evidence and research.
- [Current source entry](scripts/main.lua) — the explicit source/entry-point composition of the shell.
- [Executable contract tests](tests/README.md) — the current CI boundary and historical fixture status.

The last complete pre-rewrite implementation is preserved in the immutable [archive/0.4.11.0 Git branch](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). It is historical evidence, **not** another live implementation or an authority over the 0.5 rewrite. Git history retains subsequent experiments as well.

Blocked Progress Qualification remains an [unresolved engineering investigation](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). It must mature architecturally and contractually before worker-control code is reintroduced.
