# Project Status

Version: 4.6.50 Architecture Recovery Candidate  
Canonical implementation authority: owner-declared v4.6.43, SHA-256 `c312d74eedb20d800253247b784a992073a4cf44c0413588fa7f382b801cba4c`, Git commit `7dfb9f466566bbae1d47a2a54d66c08177fbae5b`  
Candidate baseline: exact canonical v4.6.43  
Authority state: Release Candidate proposed for owner review; not canonical until explicit owner declaration  
Runtime behaviour: unchanged from v4.6.43  
Runtime evidence environment: FS25 1.21.1.0 build b40785 revision 81824 unless the test record states otherwise

## Current engineering phase

The project is paused at an **Architecture Recovery Baseline**. Temporary v4.6.44–v4.6.49 produced valuable capabilities and decisive runtime evidence, but the Architecture Compliance Audit found that the active TS015/TS016 path had accumulated observation, interpretation, Decision, Commitment and Control responsibilities inside fixture-bounded controllers.

The candidate records the discoveries without promoting the temporary implementation.

## Confirmed architecture

```text
Reality
    ↓
Observation
    ↓
Situation Assessment
    ↓
Operational Picture Knowledge
    ↓
Decision Engine
    ↓
Commitment
    ↓
Control capability
    ↓
Outcome Observation
    ↺ Situation Assessment
```

Situation Assessment remains aware of the complete bounded Field World. It interprets observations and publishes Knowledge. Decision consumes that Knowledge, evaluates candidate actions and continuing Commitments, applies every applicable constraint and selects the least-disruptive justified augmentation. Control executes bounded authority and reports observed outcomes.

## Architecture recovery conclusions

- **Prototype Boundary Leakage:** a fixture-bounded experiment became the active operating path.
- **Assessment–Decision–Control Collapse:** controllers interpreted observations, selected actions and executed them inside private state machines.
- **Architectural Constraint Enforcement Gap:** documented invariants were not universal admissibility gates.
- **Fragmented Commitment Ownership:** multiple private episode records approximated one continuing encounter Commitment.
- Temporary discoveries remain evidence and capability candidates; their present ownership is not promoted.

## Retired underdefined terms

The following v4.3.8 labels are retired because no independent architectural distinction was recovered:

- Relevance Envelope
- Decision-Relevant World
- Decision-Relevant Constraints as a standalone Situation Assessment output
- Decision Readiness
- Option Horizon as a standalone object

Historical references remain as provenance. Current architecture uses Field World, Operational Picture, Situation Relevance, Future Space, Action Space, explicit constraint applicability and action-specific evidence sufficiency.

## Refined Decision principles

- **Sufficiency over Completeness:** available Knowledge must be sufficient for the particular conclusion or action; complete Knowledge is not required.
- **Option Preservation:** Decision considers how continued evolution changes the remaining Action Space.
- **Earliest Sufficient Action:** do not choose unchanged continuation merely to obtain greater certainty when current Knowledge supports a proportionate action and waiting is likely to remove it.
- **Minimum Effective Augmentation:** choose the least disruptive augmentation reasonably expected to preserve or improve safe Action Space.
- **Option-Preserving Augmentation:** a small, proportionate and preferably reversible intervention whose purpose is to preserve or enlarge safe Action Space rather than resolve the complete encounter immediately.
- Frequent reassessment may be normal; frequent intervention is not automatically justified.

## Experimental Capability Corpus

The temporary v4.6.44–v4.6.49 work is retained as evidence, including:

- Temporal Separation Reserve;
- Persistent Speed Authority and exact restoration evidence;
- Observation Ownership evidence for persistent Situation Relevance;
- Post-Passage Continuation evidence;
- Protected Controller Handoff semantics;
- Future Corridor Frame;
- Refuge Reachability and Viability evidence;
- Unknown Is Not Reachable;
- Refuge Occupancy Conflict;
- Commitment Viability Decay;
- hardcoded-authority and responsibility-location evidence.

None of these temporary implementations is active in this candidate.

## Immediate next objective after Canonicalisation

Build a passive shadow path that produces a complete authority trace:

```text
Observation
→ Situation Assessment Knowledge
→ shared Operational Picture
→ Decision evaluation
→ shadow Commitment proposal
→ proposed Control capability
```

The first increment must issue no vehicle-control authority. Existing logs and scenarios should be replayed through the shadow path before any active capability is migrated.

## Open architecture questions

- How should the shared Operational Picture be represented in code without narrowing the accepted architecture?
- What is the minimum durable Commitment record and lifecycle?
- How are action classes bound to mandatory constraint checks?
- How are Safe Release Point and Continuation Safety Horizon applied to both assemblies?
- How does Native Motion Envelope provide assembly-appropriate repositioning behaviour?
- How are fixture-specific geometry assumptions removed before active migration?

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` still acts as an engineering-candidate summary. Before publication readiness, restore it to a stable public description and keep increment-specific reporting in the changelog and engineering documents.
