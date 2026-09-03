# Prototype 15 — Unilateral Sidestep

> **Status:** TS013 capability result supported; TS014 retreat pace and folding-overlap validation pending
>
> **Runtime baseline:** FS25 1.21.1.0 build b40785 revision 81824 until a new test records otherwise
>
> **Control boundary:** exactly one active worker; manually armed; no live conflict resolution

## Evidence from TS013

TS013 successfully completed the complete single-worker sequence:

```text
hold → stop → fold → outward/rearward displacement → pause
→ forward rejoin → deploy → Giants handback
```

The Giants job remained active. After handback, Condor made a small lane correction and resumed useful forward work instead of returning to the intervention point. This is **Forward Route Reacquisition**.

The realised movement also revealed that the smoother handback came from a rearward/outward egress followed by a slightly forward rejoin. The earlier waypoint calculation produced that geometry accidentally because targets were referenced from the arming pose rather than the later stopped pose. TS014 makes it explicit.

## TS014 hypothesis

> Can Condor execute an explicit Retreating Unilateral Sidestep at its native 15 km/h repositioning pace while folding and retreat overlap, then reproduce a controlled forward rejoin and Giants handback?

This remains a single-worker capability experiment. The `foldAnimTime=0.15` egress trigger is an **Egress-Ready Candidate**, not physical clearance authority.

## Architectural sequence

```text
stable work
→ hold requested
→ confirmed stopped pose
→ work off / raise / fold begins
→ Egress-Ready Candidate
→ rearward-outward retreat while folding continues
→ Full Compact Configuration
→ displaced dwell
→ forward/inward rejoin
→ deploy
→ Giants handback
```

**Retreating Unilateral Sidestep** increases longitudinal separation while clearing laterally. **Folding and Retreat Overlap** seeks to avoid treating the complete fold duration as stationary Configuration Latency.

## Manual controls

```text
otmTS014Arm left
otmTS014Arm right
otmTS014Status
otmTS014Cancel
```

Left and right are relative to the worker heading at the confirmed stopped pose. The operator must select the clear outward side.

## State sequence

1. `STABILISING` — one active, unblocked, non-turning WORKING worker above 2 km/h for three seconds.
2. `HOLD_EFFECT` — permission-gate hold and speed below 0.75 km/h for one second.
3. `COMPACTING` — calculate targets from the confirmed stopped pose, stop work, raise and begin folding.
4. `EGRESS` — begin after all observed foldable objects reach the fixture-specific `foldAnimTime >= 0.15` candidate; drive 22 m outward and 12 m rearward.
5. `SIDESTEP_HOLD` — continue folding until the high compact endpoint is confirmed, then dwell for three seconds.
6. `REJOIN` — drive to the original centreline 6 m forward of the confirmed stopped pose.
7. `UNFOLDING` — return foldable objects to the deployed endpoint.
8. `OBSERVE_HANDOFF` — restore work state, release the gate, request Giants continuation and observe for 20 seconds.

Cruise speed is 15 km/h for egress and ingress. Within 6 m of the egress target or 8 m of the rejoin target, maximum speed reduces to 6 km/h.

## Geometry evidence

Prototype 08 is enabled for TS014. It records the live Condor collision-node origin span while the fold animation and retreat overlap.

This does not establish mesh extents or complete swept-envelope clearance. The controller still enforces only a provisional negative control:

> the vehicle centre must not move more than 0.75 m to the unselected side of its confirmed lane centreline.

Logs explicitly state that the full assembly fence is not evaluated.

## Timing evidence

The controller emits individual marks and a final summary for:

- hold request to confirmed stop;
- stop to first fold movement;
- stop to Egress-Ready Candidate;
- fold request to Full Compact Configuration;
- egress duration;
- dwell after compacting;
- rejoin duration;
- deployment duration;
- total intervention duration.

Video timing should still be retained as independent evidence.

## Failure boundary

Timeouts, loss of the single-worker condition or centreline-fence violation enter `FAILED_HELD`. The worker remains stopped and compacting is requested. `otmTS014Cancel` requests restoration and handback.

## Claims deliberately not made

Prototype 15 / TS014 does not establish:

- that `foldAnimTime=0.15` is physically safe beside another assembly;
- complete Behavioural Assembly swept-envelope clearance;
- automatic Progress/Yield selection;
- automatic outward-side selection;
- obstacle or field-boundary refuge suitability;
- Egress Protection Hold;
- safe passage of a second worker;
- production conflict resolution.

## TS014 validated result — v4.6.26

The Condor-only TS014 run succeeded under FS25 1.21.1.0 build b40785 revision 81824.

Observed timings:

- hold request to confirmed stop: approximately 2.10 s;
- confirmed stop to Egress-Ready Candidate: approximately 2.40 s;
- confirmed stop to first useful egress movement: approximately 3.19 s;
- full compacting from fold request: approximately 15.50 s;
- maximum egress speed: approximately 15.03 km/h;
- maximum rejoin speed: approximately 15.04 km/h.

Condor reached the refuge almost simultaneously with Full Compact Configuration. The run therefore supports **Configuration-Latency Hiding**: useful retreat consumed most of the fold duration instead of waiting stationary for complete folding.

Condor rejoined, deployed, returned to GIANTS and completed the full 20-second handoff observation without job loss or centreline-fence violation. Forward Route Reacquisition repeated.

### Known test-command side inversion

The two single-worker runs establish that the test labels are inverted relative to physical motion:

- `otmTS014Arm left` produced physical-right movement;
- `otmTS014Arm right` produced physical-left movement.

This does not invalidate the movement geometry. It demonstrates that local-axis naming is not spatial authority. Production control must preserve Decision-to-Motion Direction Integrity through world-space refuge geometry rather than human-facing left/right labels.
