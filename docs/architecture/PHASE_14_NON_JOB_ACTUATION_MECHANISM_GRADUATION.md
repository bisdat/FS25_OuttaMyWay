# Phase 14.4 — Non-Job Actuation Mechanism Graduation

## Purpose

Phase 14.4 reconciles a shared physical-actuation donor whose current
`PostJobActuationAuthority` name and `scripts/authority/` placement no longer
describe the responsibility it performs.

Accepted baseline is `main` after PR #75 merge:

`5b13bcc6251d6b482402e6ba1d37e740dd050d8a`

Canonical authority remains **v0.3.0.0**. Last accepted playable identity at
design time is:

**`0.3.0.23 TEST — LIVE INTERACTION OBSERVATION GRADUATION`**

The governing discoveries are:

**Non-Job Actuation != Post-Job Provenance**

and:

**Semantic Authority != Mechanical Safety Guard**

## Current Reality

`scripts/authority/PostJobActuationAuthority.lua` is used by two semantically
distinct production Control paths.

### Warm D-0147

`TerminalEgressControl` validates the existing `POST_JOB_ACTUATION` semantic
authority token and uses the donor for physical mechanics.

Warm D-0147 retains:

- completed-Job semantics;
- Double Courtesy;
- its existing Candidate / Responsibility / Bounded Authority contracts.

### Cold D-0218

`ObstructionRelocationControl` validates the distinct
`OBSTRUCTION_RELOCATION_ACTUATION` semantic authority token and uses the same
donor mechanics.

Cold D-0218 explicitly does not require completed-Job provenance and retains:

- current non-active unclaimed Causal Obstruction semantics;
- one supported first-courtesy relocation;
- fresh-Situation settlement after manoeuvre completion.

## Donor responsibility

The shared donor currently performs mechanical work only:

- Player Claim safety check;
- source-AI reactivation safety check;
- temporary Vehicle Activity Context acquisition/release;
- pose and heading reads;
- native maximum-forward-speed read;
- fixed-world-direction non-job drive command;
- owned-actuation neutralisation;
- steering telemetry and call counters.

The Player Claim and source-AI checks do not create semantic permission to
move. They enforce higher-priority Reality boundaries after a purpose-specific
Control path has already established authority.

The donor does not:

- establish `POST_JOB_ACTUATION`;
- establish `OBSTRUCTION_RELOCATION_ACTUATION`;
- infer completed-Job provenance;
- assess Causal Obstruction;
- construct a Candidate;
- select a Decision;
- establish Responsibility;
- authorise Bounded Authority; or
- choose a movement objective.

## Target placement

Graduate:

`scripts/authority/PostJobActuationAuthority.lua`

to:

**`scripts/control/mechanisms/NonJobActuationMechanism.lua`**

and:

`OuttaMyWay.PostJobActuationAuthority`

to:

**`OuttaMyWay.NonJobActuationMechanism`**

Both `TerminalEgressControl` and `ObstructionRelocationControl` retain separate
mechanism instances. Shared implementation does not create shared lifecycle
state or collapse their semantic authority classes.

Internal Control references graduate to the neutral name
`actuationMechanism`.

`TerminalEgressCandidateSupport` retains
`postJobAuthorityClass="POST_JOB_ACTUATION"` because that field describes the
warm path's semantic authority class.

`ObstructionRelocationCandidateSupport` changes only its implementation
provenance witness from `mechanicalDonor="PostJobActuationAuthority"` to
`mechanicalDonor="NonJobActuationMechanism"`. That is a naming correction, not
new Candidate authority or behaviour.

## Behaviour preservation contract

Phase 14.4 is a placement/naming graduation.

The mechanical implementation must preserve exactly:

- Player Claim precedence;
- source-AI reactivation precedence;
- Vehicle Activity Context behaviour;
- `forceIsActive` restoration;
- steering telemetry;
- pose and heading calculation;
- native maximum-forward-speed calculation;
- fixed-world-direction transformation;
- `AIVehicleUtil.driveInDirection` call shape;
- compatibility `motor` / `cruiseControl` temporary fields and restoration;
- neutralisation behaviour;
- direct-drive / neutralisation / activity-context counters.

Warm D-0147 and cold D-0218 must preserve their existing semantic authority
classes and purpose-specific lifecycle.

No Candidate, Constraint, Decision, Responsibility, Bounded Authority,
Regulation or Cooperative Passage change is permitted.

## Deferred vocabulary

Existing `POST_JOB_*` mechanical failure reason strings remain unchanged in
Phase 14.4.

Those strings are externally observable validation/runtime vocabulary. Renaming
them merely to match the new module would widen this tranche beyond placement.
They belong to the already-agreed Phase 14.6 production-vocabulary cleanup.

## Mechanical validation invariant

The new mechanism body must be byte-equivalent to the accepted
`PostJobActuationAuthority.lua` body after only the lexical type/receiver
graduation:

- `PostJobActuationAuthority` -> `NonJobActuationMechanism`
- local receiver `Authority` -> `Mechanism`

The new top-level header may change to state the truthful shared responsibility.

The two Control consumers must also be byte-equivalent to the accepted baseline
after only their bounded donor/reference renames and the cold-path explanatory
comment correction.

Any other production difference is outside this tranche.

## Validation

Blocking Structural contracts must prove:

- the old authority file is absent;
- the new mechanism file is explicitly sourced;
- warm D-0147 still requires `POST_JOB_ACTUATION`;
- cold D-0218 still requires `OBSTRUCTION_RELOCATION_ACTUATION`;
- both Controls instantiate independent `NonJobActuationMechanism` instances;
- no active source retains the old donor name;
- the deferred `POST_JOB_*` failure reasons remain present;
- Candidate/Constraint/Decision/Responsibility ownership is untouched.

GitHub Actions remains the pytest execution authority.

Local preflight uses LuaJIT for changed production Lua syntax plus deterministic
source/equivalence checks.

## GIANTS Reality validation

After blocking CI passes, Reality validation requires both consumers:

1. one warm D-0147 courtesy demonstrating non-job movement, neutralisation and
   Vehicle Activity Context release;
2. one cold D-0218 relocation demonstrating the same mechanical substrate under
   `OBSTRUCTION_RELOCATION_ACTUATION`, without completed-Job provenance.

No Regulation or Cooperative Passage re-smoke is required because those paths
do not consume this mechanism.
