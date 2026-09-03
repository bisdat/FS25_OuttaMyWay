# Prototype 29 — Deferred Native-Sweep Evidence Closure

**Build:** v4.7.56 TEST BUILD  
**Decision record:** D-0127  
**Authority:** passive evidence-lifecycle repair only; no new Control authority

## Problem

The v4.7.55 run exposed a sampling cliff in `HeadlandManoeuvreSweepProbe`: a coherent GIANTS boundary manoeuvre was discarded when TURNING disappeared into one temporarily unresolved sample, even though positive settled continuation appeared about one probe interval later. This prevented the existing demonstrated-demand contract from ever admitting the intended follower pacing.

## Hypothesis

Turn-segment measurement and turn-segment validation should be separable. When the physical measurement is complete but closure evidence is temporarily unresolved, freeze the measurement and wait for positive evidence rather than destroy it.

## Bounded mechanism

1. While GIANTS positively reports TURNING, measure as before.
2. At the first non-TURNING unresolved sample, include that boundary sample, freeze measurement end time and exit pose, and enter `WAITING_FOR_EVIDENCE`.
3. Do not extend the frozen sweep or duration while waiting.
4. Positive `SETTLED_CONTINUATION` validates the frozen measurement.
5. Job Episode change, active-job disappearance, a new turn before settlement, or OMW Control contamination prevents native-demonstration authority.
6. No timeout or elapsed-time threshold creates positive evidence.

## Test isolation

D-0126 remains unchanged at a temporary 0.90 Transition-Clearance factor. Success for Prototype 29 is first that Condor's coherent native sweep survives the sampling boundary and makes the intended Condor-leader / Patriot-follower evaluation possible. Whether 0.90 is adequate is a subsequent observation from the same live run, not part of this evidence-lifecycle mechanism.
