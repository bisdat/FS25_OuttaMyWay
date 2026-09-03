# Configuration — Architecture Responsibility Placeholder

> **Status:** Recognised system-architecture responsibility; architecture not yet reconciled.

## Purpose

This document reserves one authoritative live home for future Configuration architecture. It does not accept the current implementation layout as the desired architecture.

## Current observation

[`scripts/config.lua`](../scripts/config.lua) is the current central configuration and constants surface. It presently mixes build/release identity, runtime feature and authority switches, implementation calibration, empirical/test constants, diagnostic/probe toggles and cadence, HUD layout/test display values, and player-consent behaviour. That organisation is implementation evidence and must not be treated as the desired Configuration architecture merely because it exists.

## Explicit non-decisions

This placeholder does not decide:

- which values are player-configurable;
- which are immutable implementation constants;
- which are architectural policy;
- which are runtime calibration;
- which are test/probe-only;
- persistence or storage format;
- defaults, migration or versioning;
- settings UI;
- multiplayer/server/client ownership;
- reload semantics;
- mod-setting integration;
- permission or consent beyond already accepted decisions; or
- whether `config.lua` remains the eventual implementation form.

No runtime configuration is redesigned or changed here.
