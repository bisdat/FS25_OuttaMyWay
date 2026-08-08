# ADR-0010 — Identity Reference–Value Snapshot Separation

**Status:** Accepted architectural and data-safety rule; supported by v4.6.63 runtime evidence; implementation inactive in v4.6.71.

## Context

v4.6.49 and v4.6.55 demonstrated successful active-job refuge movement and GIANTS continuation under FS25 1.21.1. The repeatable freeze begins with the v4.6.57 architecture implementation while the physical movement controller remained materially unchanged.

v4.6.57 introduced generic recursive table copying in Decision and the Commitment Ledger. Hold candidates contain `subjectRef` and `progressSubjectRef`, which are live GIANTS vehicle objects rather than architectural values. GIANTS objects form large, potentially cyclic identity graphs. Recursively copying such an object can occupy the main Lua thread indefinitely without a useful exception.

The project had already agreed that stable assembly dimensions and other durable job-start facts are captured once as Knowledge. That agreement does not require cloning the live vehicle object. Runtime Control still requires an identity reference to address the actual assembly, but identity and value are different architectural categories.

## Decision

1. **Identity references are not values.** Live GIANTS vehicles, jobs, implements, nodes and mission objects may be retained only in explicitly named identity-reference fields.
2. **Identity references are never recursively copied.** They are preserved by exact reference identity and passed only to modules that require them.
3. **Architectural value snapshots are schema-specific.** Safe-release evidence, speed plans, observation contracts, hold geometry and scalar lists are copied only through explicit field allowlists.
4. **Hold candidate separation is explicit.** The hold value snapshot contains IDs, eligibility, stopping distance and clearance evidence. `selectedSubjectRef` and `progressSubjectRef` are carried separately.
5. **Job-start physical knowledge remains value data.** Stable dimensions captured once at job admission remain immutable Knowledge and are not reread through object cloning.
6. **Generic recursive copy utilities are prohibited in Decision and Commitment.** A future nested value schema requires its own named snapshot function.

## Consequences

- Decision and Commitment cannot accidentally traverse GIANTS object graphs.
- Value records are auditable and independent from later Knowledge mutation.
- Control receives exact identity references without treating them as copied evidence.
- The change does not alter refuge geometry, movement, handover, permission interception or Patriot behaviour.
- A cyclic-reference smoke test executes the actual Hold Decision and Commitment path and must preserve exact identities without recursion.

## Validation

Run manually-started TS015. The candidate is supported if the previous post-Control hard freeze disappears and the game remains responsive through subsequent Decision reassessment. A remaining freeze disproves this candidate as the root cause and leaves the separation as a required correctness improvement.
