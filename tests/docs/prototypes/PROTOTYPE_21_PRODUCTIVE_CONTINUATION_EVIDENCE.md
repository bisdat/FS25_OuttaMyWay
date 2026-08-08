# Prototype 21 — Productive Continuation Evidence Probe

## Status

**LIVE EVIDENCE GATE PASSED AND EXPANDED — v4.7.33 consolidation; passive probe retained**

Passive diagnostic only. It does not classify Traffic Policeman priority, does not create a Commitment and does not exercise Control.

## Question

Can GIANTS-native observations distinguish **Productive Continuation** from non-headland **Transitional/Repositioning Continuation** without treating absolute vehicle speed as semantic authority?

This probe exists because absolute speed is contaminated by assembly-specific implement limits, the player's cruise-control setting, GIANTS course/turn speed demand, terrain/traction and other runtime constraints. The observed Condor values of approximately 25 km/h while working and approximately 15 km/h while repositioning remain fixture evidence within its Native Motion Envelope, not universal thresholds.

## Hypothesis under test

For a continuing GIANTS Job Episode, a useful native semantic seam may exist in the combination of:

- `AIFieldCourse:getActiveSegmentData()` raw segment state, preserving tuple slots including `isTurn` and `isInitial`;
- `AIDriveStrategyFieldCourse.implementData[*].isLowered`, which GIANTS itself uses when starting/ending AI implement work lines;
- field-course strategy state such as `lastContinueWorkState`, `lastMovingDirection` and `toolAlwaysActive`;
- current vehicle/implement speed-limit observations;
- selected/max cruise-control observations; and
- actual physical speed.

No single signal is granted Productive/Transitional authority in advance. In particular, a speed such as 25, 15 or 10 km/h is never classified semantically by itself.

## Probe output

Log prefix:

```text
[FS25_OuttaMyWay][PROBE21]
```

The probe samples active GIANTS AI job vehicles and emits on state change plus a bounded heartbeat. It records:

- worker and native Job Episode identity;
- field-course strategy source;
- raw active-segment `turn`, `initial`, segment/subsegment progress and lengths;
- implement-line evidence as `ACTIVE`, `INACTIVE`, `MIXED`, `UNRESOLVED` or `EMPTY`;
- strategy `toolAlwaysActive`, `lastContinueWorkState` and forward/reverse direction;
- actual km/h;
- cruise-control state, selected speed and maximum speed when exposed;
- `getSpeedLimit(true)` and `getSpeedLimit(false)` when exposed; and
- a deliberately non-semantic evidence label such as `NON_TURN_LINE_ACTIVE`, `NON_TURN_LINE_INACTIVE` or `TURN_SEGMENT`.

The evidence label describes observations only. It is **not** a Productive Continuation classifier.

## Test programme

### P21-A — ordinary productive continuation

Use one worker in a long settled productive pass. Condor on field 77 is suitable but not required. Capture several heartbeat samples before the next manoeuvre.

Question: does a stable native signal identify the productive line independently of absolute speed?

### P21-B — low-cruise falsification

Before starting the AI Job, deliberately leave the vehicle's manual cruise-control maximum unusually low (for example 10 km/h). Start an otherwise ordinary productive Job Episode and capture a settled productive pass.

This is a deliberate falsification case. If the probe would classify the worker as repositioning merely because actual speed is low, the hypothesis fails.

### P21-C — headland/turn contrast

Allow the same Job Episode to pass through a normal GIANTS turn/headland transition and settle again. This is contrast evidence only; the Productive Continuation Preference currently being explored is for roomy non-headland encounters and does not change the established headland/Encounter-Maturation architecture.

### P21-D — naturally occurring non-headland repositioning

If GIANTS naturally performs a diagonal or other non-headland reposition within the same Job Episode, capture the complete transition into, through and out of that motion. Do not force a special OuttaMyWay manoeuvre to create it.

Question: is there a stable native evidence change that distinguishes this transition from productive continuation before/without relying on its characteristic speed?

### P21-E — contrasting assembly

When convenient, repeat productive/transitional observations with a materially different assembly such as a tractor/cultivator. This tests whether any useful signal survives differing implement working speeds and pass counts.

## Interpretation contract

Evidence supports promotion toward a Productive Continuation classifier only if the distinction survives the low-cruise falsification and remains meaningful across materially different native speed envelopes.

Possible outcomes:

1. **SUPPORTED:** GIANTS exposes a stable work-line/segment/strategy combination that distinguishes productive continuation from non-headland transition independently of absolute speed.
2. **PARTIAL:** useful evidence exists but is assembly- or configuration-dependent and requires additional corroboration.
3. **DISPROVED:** the observed signals collapse under low-cruise or other normal GIANTS behaviour and cannot support the proposed semantic distinction.
4. **UNRESOLVED:** the required native observations are unavailable or ambiguous.

A disproved hypothesis is a successful Prototype 21 result: it removes an unsafe Traffic Policeman assumption before implementation.

## Live results — 2026-08-07

### P21-A/B — Condor productive work and low-cruise falsification

Normal Condor productive continuation exposed `turn=false`, line `ACTIVE`, implement lowered, `speedLimitTrueKmh=25` and actual speed ~25 km/h. A fresh productive Job Episode with manual cruise deliberately left at 10 km/h preserved the same `turn=false`, line `ACTIVE`, lowered and 25 km/h work-limit evidence while actual speed remained ~10 km/h.

**Result:** absolute/actual speed is disproved as productive-state authority. Cruise settings can constrain productive and transitional motion without changing the native work-line semantics.

### P21-D — Condor diagonal and reverse transition

After productive work, Condor performed a long diagonal reposition plus several reverse transition movements. GIANTS retained `turn=true`, line `INACTIVE`, implement raised across these motions, including substantial reverse travel. Productive continuation resumed with `turn=false`, line `ACTIVE`, implement lowered.

**Result:** the expected `turn=false + line=INACTIVE` reposition signature was disproved. `isTurn=true` is broader than a literal geometric/headland turn (**GIANTS Turn-Segment Breadth**).

A long reverse also demonstrated **Apparent Departure Reversal**: the worker can increase separation and later return into recently vacated space while satisfying remaining work.

### P21-E — Valtra S 416 + lime spreader, field 68

Across multiple up/down passes and several forward/reverse repositions, productive passes consistently exposed `turn=false`, line `ACTIVE`, implement lowered and an ~18 km/h work limit. Transition segments exposed `turn=true`, line `INACTIVE`, implement raised while direction could change between forward and reverse.

**Result:** **Productive-Line Cross-Assembly Replication**. The useful work-line distinction survived a materially different tractor/implement assembly and native productive speed envelope.

### P21-F — John Deere 8RX 410 + cultivator and Valtra S 416 + reversible plough

A TS004 run placed the John Deere/cultivator and Valtra/reversible-plough assemblies on separate Field Worlds. The 8RX productive passes exposed `turn=false`, line `ACTIVE`, implement lowered and a 15 km/h work limit; native transition segments exposed line `INACTIVE`, implement raised and both forward/reverse motion.

The reversible plough productive passes exposed `turn=false`, line `ACTIVE`, implement lowered and an approximately 12.2 km/h work limit. Its native transitions reached approximately 15 km/h while line `INACTIVE` / raised. **Result: Native Speed-Ordering Variability** — transition can be faster than productive work.

Both fixtures also exposed short `turn=false`, line `INACTIVE`, raised boundary samples before the next productive line became active. **Result: Productive-State Evidence Asymmetry** — inactive line alone is not positive Transitional authority.

The reversible plough visibly switched working side after each pass while the same Job Episode continued. Passive representation generated changing configuration/profile tokens and materially changing footprint bounds. The ordinal tokens are retained only as provenance; the spatially meaningful evidence is the realised footprint and configuration-transition sweep.

### Promotion conclusion

Prototype 21 supports promotion of **Productive Continuation Preference** as architecture, with an evidence-fitness boundary: active GIANTS work-line state is demonstrated positive evidence, not a universal one-bit classifier. Situation Assessment must publish coherent Productive/Transitional Knowledge or `UNRESOLVED`. The probe remains diagnostic only and does not assign Traffic Policeman roles.

## Control boundary

Prototype 21 must not call or wrap GIANTS drive/control functions. It must not change cruise control, speed limits, steering, implement state, Job Episode state or worker permissions. It observes only.
