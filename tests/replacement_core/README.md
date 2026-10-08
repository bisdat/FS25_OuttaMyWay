# Replacement-Core Historical Validation Fixtures

This directory retains pre-rewrite Lua offline conformance fixtures, including `run.lua`. They refer to much of the retired 0.4 worker-control source graph.

**Status:** historical evidence only. The 0.5 shell does not load these traffic modules. The full legacy fixture harness is not a current CI gate and is **not expected to run** against today's minimal `scripts/` directory.

Current supported offline scripts in this directory are `configuration.lua`, `diagnostic_publication_policy_source.lua`, and `log_publication.lua`; they run individually under [current CI](../../.github/workflows/offline-validation.yml) and depend on retained active source.

For reproducible original traffic-era implementation and tests, use the immutable [archive/0.4.11.0 Git branch](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). Historical Lua fixtures cannot dictate future 0.5 architecture.
