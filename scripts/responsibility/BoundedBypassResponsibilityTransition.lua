--- Establishes the single-subject Bounded Bypass Current Responsibility.
-- Specification Jurisdictions: `RESPONSIBILITY_TRANSITION`, `BOUNDED_BYPASS`

OuttaMyWay.BoundedBypassResponsibilityTransition={}
local Transition=OuttaMyWay.BoundedBypassResponsibilityTransition
Transition.__index=Transition

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

function Transition.new(runtime) return setmetatable({runtime=runtime},Transition) end

function Transition:transition(picture,evaluated,readiness,semantics)
    if type(readiness)~="table" or readiness.status~="BOUNDED_BYPASS_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"BOUNDED_BYPASS_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.boundedBypassBridge or nil
    if candidate==nil or type(bridge)~="table" or bridge.architecture~="BOUNDED_BYPASS"
        or candidate.identity~=readiness.candidateId or bridge.bypassKey~=readiness.bypassKey then
        return nil,"BOUNDED_BYPASS_TRANSITION_CONTEXT_MISMATCH"
    end
    local basis=candidate.evidenceBasis and candidate.evidenceBasis.governingBasis or nil
    if type(basis)~="table" or basis.kind~="BOUNDED_BYPASS" or basis.responsibilityKey~=bridge.bypassKey then
        return nil,"BOUNDED_BYPASS_GOVERNING_BASIS_MISMATCH"
    end
    local successorSemantics={
        source="BoundedBypassResponsibilityTransition",
        purpose=candidate.purpose,
        beneficiaryAssemblyIds={bridge.assemblyId},
        controlledSubjectAssemblyIds={bridge.assemblyId},
        resolutionOutcomeKinds={
            "BYPASS_AXIS_REJOIN_OR_PLAYER_ESCALATION"
        },
        responsibilityIdentity=semantics and semantics.responsibilityIdentity or nil
    }
    local preflight,preflightReason=OuttaMyWay.ResolutionCommitmentAdapter.preflightCandidate(candidate,successorSemantics)
    if preflight==nil then
        return nil,"BOUNDED_BYPASS_SUCCESSOR_SEMANTICS_PREFLIGHT_FAILED:"..tostring(preflightReason)
    end

    local applied,reason=OuttaMyWay.BoundedBypassCommitmentLifecycle.applyDecision(self.runtime,picture,evaluated)
    if applied==nil then return nil,reason end
    local current,responsibilityReason=OuttaMyWay.ResolutionCommitmentAdapter.build(
        self.runtime,applied,successorSemantics)
    if current==nil then return nil,responsibilityReason end
    applied.currentResponsibility=current
    return applied,nil
end
