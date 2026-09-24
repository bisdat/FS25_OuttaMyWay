# Configuration Specification

## Identity and authority

**Specification Jurisdiction:** Configuration  
**Jurisdiction ID:** `CONFIGURATION`

**Primary Architecture Authority:** [`architecture/CONFIGURATION.md`](../architecture/CONFIGURATION.md#specification-jurisdiction--configuration)

**Implementation Status:** `NOT_IMPLEMENTED`

This Specification owns the implementation-facing contract for the supported local-profile player Configuration state, its persistence lifecycle, first-use materialisation, invalid-representation recovery, immediate semantic changes and handoff to consuming subsystems.

It does not own GUI layout, player-message lifecycle, Log Publication internals, Runtime authority, diagnostic engineering controls, savegame state or multiplayer Configuration semantics.

## Supported semantic state

Configuration exposes exactly three supported player values:

| Semantic value | Type | Supported default | Primary consumer |
| --- | --- | --- | --- |
| `enabled` | boolean | `true` | product lifecycle |
| `hudVisible` | boolean | `true` | GUI/HUD Operational Player Messages |
| `debug` | boolean | `false` | Log Publication policy resolution |

No fourth player logging switch exists. NORMAL publication remains the ordinary operational journal. `debug=false` resolves publication policy to NORMAL; `debug=true` resolves it to DEBUG.

DIAGNOSTIC is not a Configuration value.

Consumers MUST obtain semantic values through the Configuration interface. They MUST NOT read the persisted XML directly, construct the persistence path independently, interpret schema versions, or derive subsystem behaviour from storage representation.

## Persistence location

The supported local-profile persistence directory is:

```text
getUserProfileAppPath() .. "modSettings/" .. MOD_NAME .. "/"
```

The supported player Configuration file is:

```text
configuration.xml
```

The resulting logical path is therefore:

```text
<user profile>/modSettings/<modName>/configuration.xml
```

The implementation MUST derive the directory from `getUserProfileAppPath()`, ensure the mod-scoped directory exists with the GIANTS folder-creation surface, and use the GIANTS file/XML surfaces rather than unrestricted Lua filesystem I/O.

The first-use branch MUST distinguish absence using the engine file-existence surface before attempting a normal XML load. Existing Configuration MUST be loaded through a registered `XMLSchema`. Creation/replacement MUST use `XMLFile.create(...)`, persist through the XMLFile save lifecycle, and release XML handles after use.

The Configuration file is profile/mod scoped and MUST NOT be written into or loaded from an individual savegame directory.

## Persisted representation

The current persisted schema version is **1**.

The canonical representation is:

```xml
<outtaMyWayConfiguration schemaVersion="1">
    <settings
        enabled="true"
        hudVisible="true"
        debug="false"
    />
</outtaMyWayConfiguration>
```

The persistence layer MUST define a typed GIANTS `XMLSchema` for:

- `outtaMyWayConfiguration#schemaVersion` as an integer;
- `outtaMyWayConfiguration.settings#enabled` as a boolean;
- `outtaMyWayConfiguration.settings#hudVisible` as a boolean; and
- `outtaMyWayConfiguration.settings#debug` as a boolean.

All four persisted values are required for a representation to be accepted as current and valid.

The Configuration schema version is independent of the OuttaMyWay product version.

> **Product Version != Configuration Schema Version**

A product version change MUST NOT invalidate persisted Configuration unless the persistence representation contract itself changes.

## Startup lifecycle

Configuration persistence MUST resolve during the product-shell startup path before normal Runtime bootstrap is considered.

The ordered contract is:

```text
product shell startup
        |
        v
construct Configuration persistence path
        |
        v
ensure modSettings/<modName>/ exists
        |
        v
does configuration.xml exist?
        |
        +-- no --> materialise schema 1 defaults
        |          -> save
        |          -> expose semantic state
        |
        `-- yes -> load + validate
                   |
                   +-- current + valid
                   |      -> expose persisted semantic state
                   |
                   `-- invalid / malformed / unsupported schema
                          -> materialise schema 1 defaults
                          -> overwrite
                          -> expose default semantic state
        |
        v
resolved enabled value decides whether normal Runtime may bootstrap
```

No consumer may observe partially loaded Configuration state.

## First-use contract

If `configuration.xml` does not exist:

1. absence MUST be treated as normal first use, not as an error;
2. all three supported values MUST be initialised to their accepted defaults;
3. the schema-1 representation MUST be created and saved;
4. only after successful persistence may the default semantic state be exposed to normal consumers; and
5. Runtime bootstrap may then proceed only if the resolved `enabled` value permits it.

Defaults MUST NOT remain only as volatile in-memory state after a successful first-use startup.

## Existing-file validation and recovery

An existing representation is accepted only when:

- XML loading succeeds;
- the root/schema version is present and equals `1`;
- all three settings are present;
- all three settings are valid booleans under the registered schema.

Any malformed XML, missing required persisted value, invalid persisted value, or schema version other than `1` MUST trigger full recovery to the accepted defaults.

Recovery MUST:

1. discard all three persisted values as a set;
2. materialise the current schema-1 defaults;
3. overwrite `configuration.xml`;
4. save successfully; and
5. expose the recovered default semantic state only after that persistence succeeds.

The initial contract has no field-by-field or version-to-version migration obligation.

> **Unsupported Schema != Migration Obligation**

## Storage-failure contract

Invalid persisted content is recoverable. Failure of the storage mechanism itself is not equivalent to invalid content.

A storage failure includes inability to establish the required directory, inability to load an existing file sufficiently to execute the required recovery path, inability to create/replace the XML representation, or failure to persist the required new/recovered representation.

When Configuration cannot establish its durable persisted representation:

- normal Runtime bootstrap MUST NOT proceed;
- Configuration MUST NOT report the new/recovered state as successfully persisted;
- the product shell MAY remain available;
- an operational error MUST be surfaced through a product-shell-safe error path that does not require normal Runtime bootstrap or successful Configuration persistence; and
- no persisted setting may be silently treated as authoritative merely because an in-memory fallback exists.

> **Configuration Invalidity Is Recoverable; Configuration Storage Failure Is Not**

The exact user-facing HUD treatment of this failure remains GUI/HUD responsibility.

## Runtime change contract

### Enabled

A deliberate player change to `enabled=false` applies immediately as product-consent withdrawal.

Configuration owns the value change and notification. Product lifecycle / Responsibility Transition / Control own the resulting termination of OuttaMyWay functional responsibility and bounded release/neutralisation of already-owned effects.

Consent withdrawal takes effect immediately even if persisting `enabled=false` fails. A storage failure MUST NOT keep OuttaMyWay active merely to preserve consistency with the old persisted value. The current session remains disabled, the failure is surfaced, and durable success MUST NOT be claimed.

A deliberate change to `enabled=true` requests immediate re-enablement, but fresh Runtime bootstrap MUST NOT occur until the new enabled state has been persisted successfully. If persistence fails, the product remains disabled and the failure is surfaced. Successful re-enablement MUST bootstrap from current GIANTS Reality and MUST NOT resume pre-disable Situation, Operation, Responsibility, Commitment or Authority state.

### HUD visibility

A deliberate change to `hudVisible` applies immediately to the current-session semantic Configuration state and MUST be persisted. GUI/HUD consumes the value for Operational Player Messages only. If persistence fails, the current-session visibility change MAY remain effective, but durable success MUST NOT be claimed and the storage failure must be surfaced.

The Product Status Indicator is not governed by `hudVisible`.

### Debug

A deliberate change to `debug` applies immediately to the current-session semantic Configuration state and MUST be persisted. If persistence fails, the current-session publication-policy change MAY remain effective, but durable success MUST NOT be claimed and the storage failure must be surfaced.

Log Publication resolves:

```text
debug=false -> NORMAL
debug=true  -> DEBUG
```

Changing `debug` MUST NOT activate DIAGNOSTIC instrumentation.

## Change notification

Configuration MUST provide a bounded means for interested product-shell consumers to observe a committed semantic value change without reading persistence directly.

A change notification MUST identify which supported semantic value changed and its committed new value. It MUST NOT carry XML keys, file paths or schema mechanics as consumer-facing semantics.

A notification MUST distinguish an effective current-session change from durable persistence success when the two differ because of storage failure. Consumers MUST NOT infer persistence success merely from observing a changed semantic value.

This Specification does not require one callback, event-bus or observer implementation.

## Diagnostic engineering sidecar exclusion

An engineering-only file such as:

```text
<user profile>/modSettings/<modName>/diagnostics.xml
```

may exist under the same mod-scoped directory for internal DIAGNOSTIC control.

That file is outside the `CONFIGURATION` Jurisdiction:

- it MUST NOT add a fourth supported Configuration value;
- it MUST NOT be represented inside `configuration.xml`;
- it MUST NOT be exposed as a supported player GUI setting;
- its absence MUST mean DIAGNOSTIC off;
- it has no player-facing migration guarantee.

Issue #303 owns that engineering-control mechanism.

> **Shared Persistence Location != Shared Configuration Contract**

## Multiplayer boundary

This Specification defines the validated local player/profile contract only.

It makes no claim about host/client ownership, server authority, propagation or conflict resolution of Configuration values in multiplayer.

An implementation MUST NOT invent those semantics merely to generalise the local contract.

## Configuration / consumer boundaries

Configuration owns:
- semantic supported values;
- defaults;
- persisted representation validation;
- first-use creation;
- invalid-representation recovery;
- persistence of accepted changes;
- semantic change notification.

Consumers own:
- Product lifecycle interpretation of `enabled`;
- GUI/HUD interpretation of `hudVisible`;
- Log Publication interpretation of `debug`.

Configuration MUST NOT directly establish Situation meaning, Current Responsibility, Bounded Authority, Control targets, GUI message lifecycle or log-event meaning.

## Contract participants

No production source currently realises this Jurisdiction.

## Implementation traceability

Issue #139 owns the first production implementation. When that implementation is accepted, this Specification must in the same Engineering Increment:

- remove the `NOT_IMPLEMENTED` declaration;
- add at least one truthful `REALISES` production participant;
- add reciprocal `Specification Jurisdictions: \`CONFIGURATION\`` acknowledgement to each participant; and
- add validation participants that challenge this contract.

The existing `scripts/config.lua` file is not a Configuration implementation. It currently owns root product identity only and MUST NOT be repopulated as a generic player-settings/constants surface.

## Engine dependency

The persistence mechanism relies on the FS25 user-profile/XML surfaces recorded in [GIANTS API Surfaces](../docs/engine/GIANTS_API_SURFACES.md#user-profile-persistence-surfaces), including user-profile path resolution, file existence checks, folder creation, typed `XMLSchema`, and `XMLFile` create/load/save/delete lifecycle.

Those engine surfaces supply mechanics only. They do not own Configuration semantics.

## Validation route

Before the first implementation is accepted, offline validation SHOULD challenge at least:

- first-use absence creating schema-1 defaults;
- current valid representation loading all three values;
- missing required value causing full reset/overwrite;
- malformed/invalid representation causing full reset/overwrite;
- schema version other than `1` causing full reset/overwrite;
- product version change not invalidating schema-1 Configuration;
- savegame changes not changing the Configuration path or semantic state;
- consumers receiving semantic state without direct storage access;
- Debug mapping only to NORMAL/DEBUG;
- DIAGNOSTIC sidecar remaining outside Configuration;
- storage failure preventing normal Runtime bootstrap;
- disable/re-enable change semantics;
- persistence failure not being reported as committed success.

In-game validation MUST separately establish the GIANTS filesystem/XML behaviour that cannot be proven by the offline harness, especially first-use creation, cross-save reuse, replacement of invalid XML and storage-failure observations that can be reproduced safely.
