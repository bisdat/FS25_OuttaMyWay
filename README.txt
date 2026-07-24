FS25_OuttaMyWay v4.6.5

Prototype 04: Continuation Intent and Safe Release — Canonical

The limited TS001 run supports the core Prototype 04 distinction: a settled
trajectory provides bounded local intent, not complete route intent. Condor's
local intent epochs expired immediately when later repositioning manoeuvres
began or active observation ended.

Patriot was manually stopped at the candidate wait position, which abandoned
its GIANTS AI job. Condor later repositioned toward the physically parked
Patriot and became blocked until the player moved Patriot. Because the stopped
vehicle had left the active-worker observer, the prototype could not classify
that physical encounter automatically. A later restart after manual relocation
therefore does not establish a Safe Release Point for the original hold site.

Both workers subsequently completed their working paths, but completed Condor
remained parked in the shared GIANTS finishing position and Patriot became
blocked when it attempted to occupy the same place. This confirms that physical
relevance can outlive active AI-worker membership and is evidence for the next
passive observation increment.

Traffic Manager v2 remains disabled and observer-only mode is enforced before
any decision or control consumer. No hold, release, avoidance response or
Commitment change is included.

Start with docs/README.md. The accepted evidence is recorded in
docs/prototypes/PROTOTYPE_04_CONTINUATION_INTENT.md.
