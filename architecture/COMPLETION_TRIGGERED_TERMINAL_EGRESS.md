# Completion-Triggered Terminal Egress

## Purpose and boundary

Completion-Triggered Terminal Egress addresses the physical disposition of a Physical Assembly **after GIANTS positively terminates its native FIELDWORK job successfully**. GIANTS retains productive routing, the judgement that the fieldwork job has finished, and the right to start or supersede native jobs. A manual stop, cancelled job, unresolved message or other non-successful termination does not create a completion-parking obligation.

Two distinct responsibilities must remain separate:

- **Completion Transit** requests the existing native TRANSIT configuration after positive native completion. It owns a request, not proof that folding or transport configuration has completed. It neither moves a completed assembly nor waits for verified fold before discharging its responsibility.
- **Completion Parking** may seek safe physical settlement of the now-finished assembly, subject to separate Configuration consent, evidence, feasibility, Control admission and supersession. It receives its own positive-completion notification after independent TRANSIT dispatch, without making request acceptance or folding readback a gate. Neither notification grants movement authority.

Successful completion does **not** imply that all space inside the source field has been released: other productive workers may still occupy or demand it. Completed assemblies may themselves remain obstacles.

## Specification Jurisdiction — Native Job Completion Observation

**Jurisdiction ID:** `NATIVE_JOB_COMPLETION_OBSERVATION`  
**Primary Specification:** [Native Job Completion Observation](../spec/NATIVE_JOB_COMPLETION_OBSERVATION.md)

Native completion evidence must identify the terminated native FIELDWORK job, physical subject and stop reason. A positive `AIMessageSuccessFinishedJob` classification is relevant; disappearance of an AI job or inactive movement alone is not a sufficient completion claim. Observation produces evidence but does not command TRANSIT or parking.

## Specification Jurisdiction — Completion Transit

**Jurisdiction ID:** `COMPLETION_TRANSIT`  
**Primary Specification:** [Completion Transit](../spec/COMPLETION_TRANSIT.md)

Completion Transit requests GIANTS' transport state independently of blocked-worker recovery and parking admission. It does not wait for folding to finish, infer parking safety or restore completed equipment to productive WORKING state. Its request result grants no movement authority and is not inspected by Completion Parking.

## Settlement Corridor — Approach, Run-Out and Terminal

Completion Parking needs a **Settlement Corridor**, not merely a nominal stopping coordinate. Its three separately assessed spatial envelopes are:

1. **Approach Envelope** — a physically and operationally available route for the entire assembly to approach and align with a suitable field edge. Much of the manoeuvre may occur inside the completed source field, but remaining productive workers and their current demand constrain that space.
2. **Run-Out Envelope** — sufficient forward traversal after any necessary infield alignment or shallow boundary crossing for the assembly to straighten. Its required length depends on the actual assembly and current pose, not a universal distance.
3. **Terminal Envelope** — a stopped, complete assembly in exterior space, suitably aligned with the edge, without intersecting the source productive polygon, another productive field, a road, a physical obstacle or another assembly's occupied/claimed space.

**Terminal fit does not establish feasible approach or run-out.** A registered-field polygon gap and a nominal rigid-member sweep are necessary geometric evidence at most, not a proof of native steering, articulation, terrain, hedge, road or dynamic-worker clearance. Unknown evidence must remain unknown; it cannot be treated as open space.

[Exterior Margin Profile](EXTERIOR_MARGIN_PROFILE.md) owns the reusable description of the exterior strip and its observational limits. Physical-assembly geometry and native movement remain separate responsibilities.

## Specification Jurisdiction — Completion Settlement Control

**Jurisdiction ID:** `COMPLETION_SETTLEMENT_CONTROL`  
**Primary Specification:** [Completion Settlement Control](../spec/COMPLETION_SETTLEMENT_CONTROL.md)

Completion Settlement Control owns the admitted physical movement, current command authority, safe interruption and positively verified terminal outcome of a completed assembly. Geometry assessment, destination choice and native FIELDWORK completion evidence are inputs, not movement authority. **Assembly membership is not an admission class:** a tractor with selected attachments is assessed as a complete Physical Assembly, not categorically refused because its member count exceeds one. Existing native forward/reverse Control can drive such an assembly; nominated parking curves remain geometric hypotheses that must be checked against the actual changing member arrangement while executing.

## Pose-Conditioned Terminal Settlement

The **actual pose and current complete assembly** at successful FIELDWORK completion are inputs to Situation Assessment. Parking is not an obligation to traverse a selected edge end to end or reach a fixed point.

**Retained Source Field Association** is spatial evidence scoped to one native FIELDWORK Job Episode and its subsequent Completion Parking, not a permanent property of the Physical Assembly. During active work, a unique registered-polygon root membership is sampled and retained against the exact native job and assembly; unresolved samples may be retried, without substituting course metadata, nearby fields or displayed farmland labels. The association remains available after the last active worker disappears or the completed root crosses the field boundary. A fresh FIELDWORK job requires fresh evidence; unsuccessful termination, disablement and teardown discard unconsumed association. When work-time evidence is unavailable, a unique completion-time registered-polygon observation may still establish identity. Unknown or overlapping membership never authorises parking.

**Source Field Identity != Current Spatial Eligibility.** Retained identity does not establish current parking safety. Live complete-assembly pose, registered neighbouring fields, actual occupancy, qualified Approach/Run-Out/Terminal corridor and independent Control authority govern movement. An exterior root may be assessed locally only inside the existing bounded nominated edge corridor. Extended infield routing from an exterior root requires separate re-entry qualification; the current lattice must not invent a path through unqualified exterior space. **Field edges are candidates, not fixtures:** no registered field ID, edge index or assembly-member count is a categorical eligibility rule.

**Assembly Field Occupancy** is a fresh observation made after the ordinary native TRANSIT request, against the Source Field established for the completed Job Episode. It uses the currently selected tractor-and-attached-member nominal base-size rectangles, not root-point membership or optional folding/boom-state readback. Three supported outcomes are **INSIDE**, **STRADDLING** (at least some selected-member extent intersects the field boundary), and **CLEAR** (none intersects that Source Field); unavailable selected-member geometry remains unknown. **CLEAR** discharges the need for new Completion Parking Control: it is not an invented physical parking manoeuvre or proof of unrelated external safety conditions. A queued completion must be reassessed when its turn begins.

For INSIDE or STRADDLING, select a feasible terminal region and an attainable approach **jointly** from the actual current Physical Assembly pose, then choose a pose-conditioned entry manoeuvre under the available Control contract. A hypothetical local entry and terminal do not establish a claimable destination until the actual approach is also qualified. A STRADDLING start may use a qualified local boundary egress; do not silently assume the infield-only extended lattice can begin outside. If no actual-pose-connected route exists, refuse without claiming or moving. A nominally qualified entry pose is not proof the vehicle will arrive there with the needed heading.

The order of responsibility is:

- **Destination Situation Assessment** considers still-working assemblies' positions and relevant potential demand, other completed assemblies, available field edges, exterior constraints, and necessary travel before selecting a destination.
- **Available Terminal Region** describes space with suitable complete-assembly stopping potential; it is not yet allocated or an executable route.
- **Qualified Entry Pose** is a candidate actual-pose-reachable connection between approach, run-out and terminal envelopes. Its justification must cover relevant occupancy and admissible motion.
- **Parking Region Claim** reserves one qualified region exclusively for a completing assembly while that claim remains credible. Other claims and current scene occupancy must be honoured independently.
- **Completion Settlement Control** may actuate only an admitted, bounded route whose evidence and exclusive ownership remain applicable.

A convenient nearby point is not preferable when it inevitably intersects a productive worker's future path. Destination selection precedes and informs local feasibility; the first completed worker's freedom of choice should not be consumed by a strategically poor parking allocation.

## Spatial currency and serial settlement

Current physical occupancy is distinct from productive demand and from a completed-job status. The complete actual vehicle/attachment footprint continues to occupy space after a successful native job stop.

Multiple completions may require **serial settlement**. An assembly unable to complete an originally guided approach must attain and verify a stable stop before yielding its Control claim. The next completing assembly may then settle under independent assessment. A prior participant may be replanned from a **fresh actual pose**, rather than its discarded nominal arrival pose, after the competing claim is released.

The stop, parking claim, route plan and completed terminal are distinct facts. Reporting a successful stop is not reporting physical parking. The terminal outcome must use fresh full-member occupancy evidence and measured native stationarity; root-point arrival alone is insufficient.

**Terminal Arrival Envelope** separates an ordinary intermediate guidance waypoint from the final native point at which braking and stop may begin. A nominal exterior terminal coordinate is insufficient when the native arrival contract permits stopping short or laterally displaced from it. Before admitting final guidance, the complete assembly's *permitted final-position neighbourhood* and stopping run-out must be screened, not just its ideal endpoint. Positional screening is a bounded nominal geometry hypothesis; it does not certify actual native yaw, hitch articulation, terrain or obstacles. An observed final heading outside the edge-alignment band or any member straddling the Source Field remains a refused physical terminal, regardless of target proximity.

**Manoeuvrable Pose** is a *physically observed intermediate assembly state* from which another actual-pose route assessment may become possible when no complete direct Settlement Corridor qualified. A bounded infield repositioning movement is not terminal parking and does not justify claiming a future terminal. To admit it, the complete assembly's proposed infield movement must have positive nominal containment and occupancy evidence under its own finite Control lease. Actual native steering, stop and full-member pose must then be observed before subsequent parking assessment. Only a finite number of independently justified reposition attempts are permitted; failure to establish a safer or more manoeuvrable actual pose requires refusal, not unbounded motion.

## Control and interruption

Completion Settlement Control holds an independent bounded lease; it must not share an actuator lease or hidden state with active Hold & Relocate. Its movement can be superseded by master Configuration disablement, newer GIANTS AI work, player control, another admitted Control responsibility, invalidated physical occupancy or a failed safety condition.

A moving assembly must not silently release its claimed region until safe neutralisation is evidenced. Interrupted guidance must reach a safe stop or report that neutralisation is unconfirmed. No safety violation can be repaired by declaring a merely nominal candidate to have become physically feasible. Re-enable does not retroactively replay consumed successful-completion evidence.

## Player Configuration boundary

Master Enabled is the overriding consent for OuttaMyWay Control. A distinct **Full Completion Parking** choice, default On, governs physical parking only; turning it Off must interrupt this responsibility safely without disabling the separate Completion Transit request. DIAGNOSTIC publication is neither player consent nor physical movement authority.

The dedicated parking choice and the broader supported-field envelope have independent validation obligations. An accepted design intent is not automatically a demonstrated GIANTS capability.

## Evidence limits

Nominal registered-polygon screening, single-member motion, road and exterior margin evidence, physical obstacles, articulated reverse and stopping, field-to-field portability, active-worker interactions and mid-guidance neutralisation have different validation envelopes. No result for one may be promoted to general physical safety for the others.

The current field-agnostic implementation and tests are governed by the [Completion Settlement Control Specification](../spec/COMPLETION_SETTLEMENT_CONTROL.md) and [Completion Parking Research](../docs/research/COMPLETION_SETTLEMENT_PROTOTYPE_TEST.md); the unresolved wider qualification programme belongs to [Issue #484](https://github.com/bisdat/FS25_OuttaMyWay/issues/484).
