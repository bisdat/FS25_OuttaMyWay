# Replacement-Core Conformance Tests

Run from the repository root:

```text
texlua tests/replacement_core/run.lua .
pytest -q
```

v4.7.4 adds the offline replay-conformance gate. The corpus contains documented historical reconstructions for v4.6.49, v4.6.57, v4.6.64, v4.6.70, v4.6.77, TS016, player takeover, Operation termination and no-activity controls.

The fixtures use only facts preserved in canonical documentation. They do not execute archived code, simulate GIANTS physics or grant physical Control authority.
