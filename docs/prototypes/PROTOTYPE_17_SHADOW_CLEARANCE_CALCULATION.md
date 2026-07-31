# Prototype 17 — Shadow Clearance Calculation and Facing Extent Provider

## Scenario

TS017-B reuses the successful TS015-B Condor Endurance II / Patriot 4450 head-on fixture. Condor remains fixed Yield, Patriot remains unmodified GIANTS Progress, arming remains manual and Control remains fixed at 28 m lateral / 12 m rearward.

## Observation from TS017-A

The actuator passed again. Patriot resolved to an 18.00 m facing extent through its live 36 m AI working marker. Condor had no complete discovered envelope and no usable size metadata, so every required-separation field remained `n/a`. The calculator correctly refused to invent an operand.

## Question

> Can fixture-bounded collision identity and runtime pose evidence provide a useful compact Condor Facing Clearance Extent without changing Control?

## Facing Extent Provider

The provider sits between Physical Representation and Shadow Clearance Calculation:

```text
collision identity + live pose/bounds
→ one-sided compact facing extent
→ source, coverage and confidence
→ separate physical-contact and policy-clearance evidence
```

For the exact Condor 36 m fixture it expects 13 current physical catalogue identities: eight active boom collision shapes and five permanent physical controls.

### Live hierarchy

1. Resolve all current catalogue identities through mappings, declared paths or bounded name scan.
2. Prefer GIANTS runtime shape/local/world bounds and project their corners toward Patriot's corridor from the AI steering-node reference.
3. When bounds are incomplete, project live catalogued node origins and add a separately logged 2.50 m unresolved physical allowance.
4. Return unavailable if even the origin evidence cannot be formed.

### Pre-estimate

Before movement, use repeated Prototype 08 folded-origin evidence:

```text
local X: -1.42 .. 1.42 m
local Z: -5.21 .. -1.61 m
```

Project that template at the predicted direct-egress bearing and add the same explicit 2.50 m unresolved physical allowance. This is a fixture model, not an authoritative envelope.

## Separated clearance formula

```text
physicalContactThreshold
= Progress Facing Clearance Extent
+ compact Yield Facing Clearance Extent

physicalClearanceReserve
= live reference separation
- physicalContactThreshold

policyMarginBudget
= geometry uncertainty (0.75 m)
+ tracking tolerance (1.00 m)
+ motion allowance (0.50 m)
+ policy margin (1.50 m)

policyRequiredSeparation
= physicalContactThreshold
+ policyMarginBudget

policyReserve
= live reference separation
- policyRequiredSeparation
```

The physical threshold answers represented contact only. The policy calculation applies explicit operational margins as a separate question.

## Evidence stages

`PRE_ESTIMATE`, `REFUGE_LIVE`, `CLOSEST_APPROACH`, `PASSAGE_CONFIRMED`, then `SHADOW_SUMMARY`.

Each stage logs provider coverage, resolved/expected identities, bounded identities, origin count, origin extent, physical allowance, bound APIs, scan truncation, pose source and confidence. It also exposes `physicalContactThreshold`, `physicalClearanceReserve`, `policyMarginBudget`, `policyRequiredSeparation` and `policyReserve` separately.

## Control boundary

All values remain `authority=false`. The provider cannot select roles or side, alter the 28 m target, trigger movement, hold Patriot, change passage evidence or control handback.

## Validation criteria

- Existing TS015-B actuator behaviour remains unchanged.
- Condor extent is no longer silently unavailable when fixture evidence can support a bounded estimate.
- The log makes complete runtime bounds distinguishable from origin-plus-allowance fallback.
- A derived requirement appears or the remaining missing evidence is explicit.
- Video and log support the same passage result.

## Claims deliberately not made

TS017-B does not prove authoritative full-assembly geometry, a universal allowance, automatic role/side selection, derived movement authority, field/margin feasibility, obstacle avoidance or swept-path safety.

## TS017-B runtime result

The established manual Condor-yields run completed successfully under FS25 1.21.1.0 build b40785 revision 81824:

- 13/13 current Condor physical identities and origins resolved;
- 0/13 exposed usable runtime bounds through the tested APIs;
- live origin extent: 4.87 m;
- unresolved physical allowance: 2.50 m;
- live compact Condor facing extent: 7.37 m;
- Patriot facing extent: 18.00 m;
- physical contact threshold: 25.37 m;
- actual closest reference separation: approximately 27.38 m;
- physical clearance reserve: approximately +2.01 m;
- provisional policy target: 29.12 m;
- policy reserve: approximately -1.74 m;
- passage, rejoin, GIANTS handback and the complete 20-second observation passed with `failure=nil`.

The pre-estimate used a 7.85 m Condor extent and implied a 25.85 m physical threshold, 0.48 m above the live threshold. Its predicted 28 m physical reserve was approximately 2.15 m; the observed reserve was approximately 2.01 m.

The same live physical threshold would classify the failed 21.44 m TS015-A result as approximately 3.93 m inside contact. This is strong fixture-bounded discrimination evidence.

## Consolidated discoveries

**Origin Coverage Is Not Bound Coverage:** resolving every declared physical identity and origin does not establish runtime shape bounds or Coverage Closure.

**Physical Clearance Is Not Policy Clearance:** represented assemblies can have positive physical clearance while a separate policy-margin target remains unmet.

## v4.6.32 implementation and next validation

v4.6.32 implements the five separated fields in the calculator, stage logs, continuous samples, console status and final summary. The ambiguous combined `requiredSeparation` and `reserve` fields are no longer emitted.

The next action is empirical validation, not automation: repeat the established manual Condor-yields run and confirm approximately 25.37 m physical threshold, +2.01 m physical reserve, 3.75 m policy budget, 29.12 m policy requirement and -1.74 m policy reserve while visible passage and the complete actuator sequence remain unchanged.

All values remain `authority=false`. Automatic trigger, role selection, side selection and derived movement remain outside Prototype 17's current authority.
