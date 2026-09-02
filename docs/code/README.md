# Code and implementation documentation

This branch of the engineering documentation describes **how the current
implementation is constructed**. It will cover runtime composition, entry
points, state and responsibility ownership, architecture-to-code mapping, and
important implementation constraints.

## Current implementation breadcrumb

The only established top-level entry path is:

```text
modDesc.xml
    ↓
scripts/main.lua
```

[`modDesc.xml`](../../modDesc.xml) explicitly loads
[`scripts/main.lua`](../../scripts/main.lua).

A detailed code map is a subsequent Repository Comprehension activity. No
deeper module ownership is asserted here before that evidence is established.
