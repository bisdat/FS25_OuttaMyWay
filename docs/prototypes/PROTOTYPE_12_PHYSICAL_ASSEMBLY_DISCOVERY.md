# Prototype 12 — Physical Assembly Discovery

## Status

Strongly supported by integrated and attached base-game runtime evidence from noncanonical candidate v4.6.14 and consolidated into v4.6.15.

Prototype 12 follows the strongly supported Prototype 11 result and the tractor–cultivator contrast reconnaissance performed with the v4.6.13 candidate.

## Observation that changed the experiment boundary

Condor is a self-propelled sprayer whose powered vehicle and articulated working equipment are integrated into one asset. A base-game Valtra S 416 with a separately attached Horsch Tiger 8 MT exposed a different arrangement:

- the operational AI worker was reported as the S 416;
- the observer reported two components in the working combination;
- the tractor and cultivator were loaded from separate vehicle assets;
- the cultivator unfolded while the tractor remained the operational worker identity.

This produced **Operational Entity–Physical Assembly Separation**:

> The Entity that owns the AI job is not necessarily the complete physical assembly whose geometry must eventually be represented.

The same contrast run also produced **Fixture-Absence Warning Noise**: the Condor-specific Prototype 08 probe emitted repeated warnings when its test fixture was intentionally absent. Completed Condor-specific Prototypes 08, 09 and 11 are therefore disabled during Prototype 12 rather than treating a different test subject as a fault.

## Architectural requirement

Before resolving collision nodes, component extents or a Physical Occupancy Envelope, OuttaMyWay must know the current runtime objects that constitute the worker's physical assembly.

The assembly may contain:

- one integrated self-propelled vehicle;
- a powered vehicle and one attached implement;
- a powered vehicle and a chain of attached implements;
- future arrangements whose ownership structure is not yet known.

The operational worker remains the Operation-facing identity. Physical assembly members remain separate runtime identities beneath that operational context.

## Evidence authorities

| Question | Authority |
|---|---|
| Is this an active operational worker? | GIANTS AI field-worker runtime state |
| Which runtime objects are currently attached? | Protected runtime attachment APIs and attachment-specialisation state |
| What asset instantiated each member? | Each runtime object's configuration filename |
| What is each member's runtime search root? | Each runtime object's own `rootNode` |
| Is a member physical or which collision shapes belong to it? | Not answered by this prototype |
| What is the member's physical extent? | Not answered by this prototype |

Attachment presence does not itself prove collision membership. Runtime hierarchy size does not itself prove physical importance.

## Hypothesis

> From an active AI field worker, the runtime exposes a traversable current physical assembly containing the operational worker and its attached vehicle or implement objects as distinct members. Each member retains its own asset identity and runtime root, providing the correct member-local search boundary for later source-to-runtime collision-node resolution.

## Implementation boundary

The passive probe:

1. enumerates active field workers from both mission vehicle collections;
2. deduplicates operational workers by runtime object identity;
3. begins an assembly at the operational worker;
4. recursively follows protected attachment evidence from:
   - `getAttachedImplements`;
   - `getAttachedVehicles`;
   - `getChildVehicles`;
   - `spec_attacherJoints.attachedImplements`;
5. records one member entry per distinct runtime object;
6. records attachment edges and the discovery source;
7. records each member's asset, runtime root, component count, mapping-table count and bounded hierarchy summary;
8. detects attachment-graph changes;
9. records continuous worker speed and displacement so declared AI state can be compared with demonstrated motion.

It does not:

- identify collision nodes;
- infer physical membership from names, mappings or attachment status;
- call sphere APIs;
- aggregate occupancy;
- perform containment or projected sweep;
- issue Decision, Commitment or Control behaviour.

## Member classifications

- `INTEGRATED_SINGLE_MEMBER` — the operational worker is the only discovered runtime member.
- `ATTACHED_MULTI_MEMBER` — one or more attached runtime objects are discovered beneath the operational worker.

These classifications describe current runtime structure, not vehicle type or agricultural function.

## Success criteria

For an observed assembly:

- at least one active operational worker is discovered;
- every member has an asset identity;
- every member has its own non-zero runtime root;
- runtime roots are unique across members;
- the hierarchy beneath every member root is traversable;
- a multi-member assembly contains attachment evidence connecting its members;
- member identity remains stable through folding and work;
- the probe remains passive.

A formal cross-fixture result requires at least:

1. one integrated fixture such as Condor;
2. one attached fixture such as tractor plus folding cultivator.

## Searchable log contract

```text
PROTOTYPE12 WORKER_ENUMERATION
PROTOTYPE12 OPERATIONAL_WORKER
PROTOTYPE12 ASSEMBLY_MEMBER
PROTOTYPE12 ATTACHMENT_EDGE
PROTOTYPE12 ASSEMBLY_SUMMARY
PROTOTYPE12 ASSEMBLY_CHANGED
PROTOTYPE12 WORKER_MOTION_SAMPLE
PROTOTYPE12 OPERATIONAL_WORKER_REMOVED
```

## Result interpretation

### Supported for one observed assembly

The runtime assembly is traversable, all members retain distinct asset/root identity, and relationship evidence is coherent.

### Strongly supported across contrast fixtures

Both integrated and attached arrangements satisfy the same architectural member model while exposing different asset vocabularies and hierarchy structures.

### Partial

The operational worker is found but one or more attached members lack stable identity, unique runtime roots or coherent attachment evidence.

### Unsupported

A visibly attached implement cannot be reached from the operational worker through any tested runtime attachment evidence.

## Accepted runtime result

Three fixtures supported the same assembly model:

- Condor Endurance II: `INTEGRATED_SINGLE_MEMBER`, one asset, one runtime root and no attachment edge.
- Valtra S 416 plus Horsch Tiger 8 MT: `ATTACHED_MULTI_MEMBER`, two assets, two distinct roots and one `getAttachedImplements` edge.
- John Deere 8RX 410 plus Väderstad TopDown 600: the same attached classification replicated across different manufacturers, mapping vocabularies, component counts and hierarchy sizes.

The 8RX/TopDown fixture sustained normal AI work after unfolding. The S 416/Tiger fixture remained logically active and reported `WORKING` while motion samples stayed effectively zero for at least fifteen seconds. The same combination cultivated manually, disproving simple equipment incapability without identifying the GIANTS AI cause. Assembly identity remained coherent in both cases.

This establishes:

- **Physical Assembly Search Boundary** — begin at the operational worker, enumerate the current assembly, then resolve geometry independently inside each member-local asset/runtime hierarchy.
- **Attached-Assembly Replication** — the same assembly structure transferred across materially different attached equipment.
- **Working-State Motion Divergence** — declared `WORKING` state and demonstrated physical progression are separate observations.

No OuttaMyWay runtime error or control intervention occurred. Three raw HUD texture performance warnings were judged unrelated and are not part of the architectural result.

**Result:** Prototype 12 is strongly supported and disabled after completion.

## Next gate

Define **Member-Local Physical Resolution** and the precise Prototype 13 hypothesis before attempting source-to-runtime collision-node resolution inside each assembly member.
