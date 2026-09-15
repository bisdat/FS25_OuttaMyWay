# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #216 Resolution-Margin Demand

Issue #216 is the active concern after accepted build **0.3.0.78** positively validated the Issue #45 Bubble Bullet Time behaviour and later exposed a separate two-worker collision.

PR #215 merged the `.78` Bubble Bullet Time implementation to accepted `main`; post-merge Offline Validation #496 passed on that merge. Issue #45 is completed and closed. In the subsequent `.78` Reality run, the formation-time independent third worker received the required fixed 1 km/h Bubble protection during the active Cooperative Passage Resolution Epoch, ordinary third-party negotiation remained deferred, and the Bubble effect released when the Resolution Epoch ended.

The later failure occurs outside that Bubble and after the subsequent two-worker Cooperative Passage had also completed and dissolved. Patriot and S 416 then entered an ordinary Action-Space Regulation relationship. The player observed a physical collision while S 416 remained in GIANTS-owned turning motion.

## Current evidence and discoveries

The decisive `.78` evidence does not support treating the collision as a narrow Bubble or Passage regression.

Before Action-Space Regulation was admitted, the retained non-authoritative `ProgressionPreservationProbe` already reported Patriot's supported native progression intersecting S 416's represented Current Space within only a few metres. Candidate Support still published no temporal-coordination action because the current production Action-Space path primarily depended on a Current-Excursion/opposed-corridor proxy.

When Action-Space Regulation was later admitted, `ResolutionSpaceProgressionEnvelope` was initialised from roughly 26 m of reference-pose separation even though the positive represented Current-Space witness lay only a few metres ahead on Patriot's supported progression. The authorised cap therefore remained close to native speed. The physical effect then became quiescent when the Current Excursion was no longer ahead on the stable participant trajectory, while current spatial demand had not positively dissolved.

This supports two durable distinctions:

> **Current Excursion != Resolution-Margin Demand.**

> **Reference-Point Separation != Usable Resolution Space.**

The earlier Issue #93 investigation also constrains interpretation: generic positive bounding-disc overlap is not proof of actual machine contact and does not carry negative-clearance authority. In #216, the represented spatial witness and the player's observed collision are therefore separate evidence claims.

## Authority classification

Current Architecture remains coherent.

Spatial Negotiation Architecture already establishes that time consumes options, that Regulation may preserve Resolution Space while GIANTS keeps routing authority, and that Situation Assessment owns current option-space / Resolution-Margin meaning. The Runtime Responsibility Architecture already keeps Situation meaning, Candidate/Decision, Responsibility Transition, Bounded Authority and Control separate.

The missing boundary is implementation-facing Specification detail. `spec/SITUATION_ASSESSMENT.md` now defines **Resolution-Margin Demand Evidence** as the Situation-owned positive evidence product for the question of whether currently supported native progression consumes represented Current Space, Committed Demand or Potential Demand within its bounded local progression horizon.

The contract preserves these limits:

- a positive witness-entry distance is one-sided evidence, not safe clearance;
- Current Excursion and other recognised relationships may contribute evidence but do not define the demand;
- reference-pose separation cannot substitute for a nearer positive represented witness when the question is usable Resolution Margin;
- no target turn path or future route is predicted;
- no Productive History or persistent pair baseline is required;
- Situation Assessment does not select a Candidate, regulated subject or speed; and
- Bounded Authority remains the owner of current physical subject and permitted magnitude.

## Authority Triad disposition for the Specification tranche

This branch intentionally changes only the implementation-facing contract and current continuation record.

- **Architecture — validated unchanged.** Existing Runtime Responsibility and Spatial Negotiation architecture already own the required Resolution-Margin and Regulation semantics.
- **Specification — changed.** Situation Assessment now operationalises the missing Resolution-Margin Demand Evidence boundary.
- **Source — validated as not yet conforming to the clarified contract.** Production still exposes related positive progression/intersection geometry only through a non-authoritative diagnostic while active Action-Space Regulation relies primarily on Current-Excursion/opposed-corridor interpretation and reference-pose separation.

This is deliberate specification-first work. The branch does not weaken Architecture to match the implementation and does not promote diagnostic output into authority.

## Validation boundary — Touch One; Validate Three

The eventual implementation must preserve a three-part behavioural guardrail:

1. **Target case:** supported native progression positively intersects represented Current Space/Demand while the other worker is manoeuvring; Resolution-Margin Demand follows that represented claim before, during and after any narrower Current-Excursion proxy window.
2. **Negative neighbour:** a nearby or `TURNING` worker whose represented Current Space/Demand does not positively intersect the subject's supported progression does not trigger Regulation merely from proximity, turn state, shared Operation membership or a generic zone classification.
3. **Established regression:** existing Current-Excursion/opposed-corridor Action-Space behaviour preserves its accepted relationship interpretation, role allocation, elastic Regulation lifecycle, quiescence/reactivation semantics and Passage succession when equivalent evidence remains available.

Repository offline suites remain GitHub Actions' execution responsibility. A Specification-only change consumes no new TEST build identity.

## Next bounded engineering step

After this Specification tranche is reviewed and accepted, return to **Hypothesise** before changing executable code.

The next question is:

> What is the smallest production Situation Assessment mechanism that can publish Resolution-Margin Demand Evidence from current sealed evidence, and how should existing Regulation Candidate Support consume it without importing diagnostic authority or changing GIANTS routing ownership?

Only after that mechanism and its evidence contract are agreed should an executable implementation increment begin. Any pushed executable revision must then receive a fresh TEST build identity beyond `.78` and must be validated against the three-part guardrail above before in-game Reality testing.

Issues #170, #174 and #176 remain parked standards-work conformance concerns. Issue #210 remains a parked generated-source-reference improvement. Issue #45 and Issue #172 are completed and closed.
