# Replacement-Core Offline Conformance Harness

`run.lua` loads a broad implementation surface into a stubbed, non-game Lua environment and exercises contracts, lifecycle, authority, assessment, candidate, decision, control, and selected behavioural relationships. It is executable offline implementation validation; it cannot prove that GIANTS supplies equivalent evidence or behaves equivalently in-game.

Run from the repository root with the locally validated LuaJIT interpreter:

```bash
luajit tests/replacement_core/run.lua
```

The harness is currently a monolithic file of approximately 407 KB. This increment documents its responsibility and does not modularise it. Git retains earlier version-specific suite claims and chronology.
