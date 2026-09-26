--- Owns authoritative Current Responsibility establishment, termination, atomic replacement and semantic identity continuity.
-- Specification Jurisdictions: `RESPONSIBILITY_TRANSITION`, `BLOCKED_WORKER_RECOVERY`

OuttaMyWay.ResponsibilityTransitionAuthority = {}
local Authority = OuttaMyWay.ResponsibilityTransitionAuthority
Authority.__index = Authority

local publication=OuttaMyWay.LogPublication.origin("RESPONSIBILITY_TRANSITION")

local function joinValues(values,separator)
    local result={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        result[#result+1]=tostring(value)
    end
    return table.concat(result,separator or ",")
end

local function cooperativePassageParticipantIds(runtime,current,commitmentId)
    local result,seen={},{}
    local commitment=runtime and runtime.commitments and runtime.commitments:get(commitmentId) or nil
    for _,obligationId in OuttaMyWay.ValueRecord.ipairs(commitment and commitment.obligationIds or {}) do
        local obligation=runtime.obligations and runtime.obligations:get(obligationId) or nil
        local basis=obligation and obligation.basis or nil
        if basis and basis.kind=="COOPERATIVE_PASSAGE_LEG" and type(basis.assemblyId)=="string"
            and seen[basis.assemblyId]~=true then
            seen[basis.assemblyId]=true
            result[#result+1]=basis.assemblyId
        end
    end
    if #result==0 then
        for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(current and current.beneficiaryAssemblyIds or {}) do
            if type(assemblyId)=="string" and seen[assemblyId]~=true then
                seen[assemblyId]=true
                result[#result+1]=assemblyId
            end
        end
    end
    table.sort(result)
    return result
end
local function logInfo(code,formatText,...)
    return publication:info("DEBUG",code,formatText,...)
end
local function logWarning(code,formatText,...)
    return publication:warning("NORMAL",code,formatText,...)
end

local function hasPrefix(value,prefix)
    return type(value)=="string"
        and type(prefix)=="string"
        and string.sub(value,1,string.len(prefix))==prefix
end

local function fieldForOperation(runtime,operationId)
    if type(operationId)~="string" or runtime==nil or runtime.operations==nil then return nil end
    local operation=type(runtime.operations.get)=="function" and runtime.operations:get(operationId) or nil
    if operation==nil or runtime.jobEpisodes==nil then return nil end
    for _,episodeId in OuttaMyWay.ValueRecord.ipairs(operation.memberJobEpisodeIds or {}) do
        local episode=runtime.jobEpisodes:get(episodeId)
        if episode~=nil and episode.playerFacingFieldId~=nil then return episode.playerFacingFieldId end
    end
    return nil
end

local function regulationPayload(runtime,current,reason)
    local provenance=current and current.provenance or {}
    local operationId=provenance.operationId
    return {
        operation=operationId,
        field=fieldForOperation(runtime,operationId),
        responsibility=current and current.identity or nil,
        commitment=provenance.retainedCommitmentId,
        regulated=provenance.regulatedAssemblyId or provenance.followerAssemblyId,
        protected=provenance.protectedAssemblyId or provenance.leaderAssemblyId,
        pair=provenance.pairKey,
        admission=provenance.admissionKind,
        reason=reason
    }
end

local function resolutionKind(current)
    local purpose=current and current.purpose or nil
    return type(purpose)=="table" and purpose.kind or nil
end

local function resolutionOperationId(current)
    local ids=current and current.governingBasis and current.governingBasis.operationIds or nil
    if OuttaMyWay.ValueRecord.length(ids or {})==1 then return ids[1] end
    return nil
end

local function resolutionEventCode(current,suffix)
    local kind=resolutionKind(current)
    if kind=="COOPERATIVE_PASSAGE" then return "COOPERATIVE_PASSAGE_"..suffix end
    if kind=="CAUSAL_OBSTRUCTION_RELOCATION" then return "OBSTRUCTION_RELOCATION_"..suffix end
    if kind=="BLOCKED_WORKER_RECOVERY" then return "BLOCKED_WORKER_RECOVERY_"..suffix end
    return nil
end

local function resolutionPayload(runtime,current,commitmentId,reason)
    local operationId=resolutionOperationId(current)
    local kind=resolutionKind(current)
    local payload={
        operation=operationId,
        field=fieldForOperation(runtime,operationId),
        responsibility=current and current.identity or nil,
        commitment=commitmentId,
        purpose=kind,
        reason=reason
    }
    if kind=="COOPERATIVE_PASSAGE" then
        payload.participants=joinValues(cooperativePassageParticipantIds(runtime,current,commitmentId),",")
    elseif kind=="CAUSAL_OBSTRUCTION_RELOCATION" then
        payload.blocker=(current.controlledSubjectAssemblyIds or {})[1]
        payload.beneficiaries=joinValues(current.beneficiaryAssemblyIds,",")
    elseif kind=="BLOCKED_WORKER_RECOVERY" then
        payload.worker=(current.controlledSubjectAssemblyIds or {})[1]
    end
    local commitment=runtime and runtime.commitments and runtime.commitments:get(commitmentId) or nil
    if commitment~=nil and OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then payload.outcome=commitment.state end
    return payload
end

local function publishRegulation(runtime,current,suffix,reason)
    if current==nil then return end
    publication:publish("NORMAL","INFO","REGULATION_"..suffix,regulationPayload,runtime,current,reason)
end

local function publishResolution(runtime,current,commitmentId,suffix,reason)
    local code=resolutionEventCode(current,suffix)
    if code~=nil then publication:publish("NORMAL","INFO",code,resolutionPayload,runtime,current,commitmentId,reason) end
end

local function selectedBridge(evaluated,name)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then
            local evidence=candidate.evidenceBasis
            return evidence and evidence[name] or nil
        end
    end
    return nil
end

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

local function ownershipAssemblyIds(candidate)
    local ownership=candidate and candidate.evidenceBasis and candidate.evidenceBasis.progressActuationOwnership or nil
    local ids={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(ownership and ownership.assemblyIds or {}) do ids[#ids+1]=id end
    table.sort(ids)
    return ids
end

function Authority.new(runtime)
    return setmetatable({runtime=runtime,regulationsByCommitmentId={},resolutionsByCommitmentId={}},Authority)
end

function Authority:preflightActionSpaceRegulation(picture,evaluated,readiness)
    local bridge=selectedBridge(evaluated,"actionSpaceRegulationBridge")
    local context=readiness and readiness.applicationContext or nil
    local current=self:findRegulation("conflictIdentity",bridge and bridge.conflictIdentity)
    if bridge==nil or readiness==nil or bridge.conflictIdentity~=readiness.conflictIdentity then
        return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_PREFLIGHT_CONTEXT_MISMATCH"
    end
    if context=="INITIAL" then
        for _,item in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
            local retained=self:getCurrentRegulation(item.commitmentId)
            if retained~=nil and retained~=current then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_ALREADY_CURRENT" end
        end
        if current~=nil then
            local targeted=false
            for _,item in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
                if item.commitmentId==current.provenance.retainedCommitmentId then targeted=true break end
            end
            if targeted~=true then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTINUITY_NOT_TARGETED" end
        end
        return {context=context,current=current,conflictIdentity=bridge.conflictIdentity,admissionKind=bridge.admissionKind,cornerKey=bridge.cornerKey,
            operationId=bridge.operationId,regulatedAssemblyId=bridge.regulatedAssemblyId,protectedAssemblyId=bridge.protectedAssemblyId},nil
    end
    if context~="REACTIVATION" and context~="ROLE_MIGRATION" then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTEXT_UNSUPPORTED" end
    if current==nil or current.kind~="REGULATION" or current.provenance.conflictIdentity~=bridge.conflictIdentity
        or current.provenance.retainedCommitmentId~=readiness.commitmentId then
        return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTINUITY_MISMATCH"
    end
    return {context=context,current=current,conflictIdentity=bridge.conflictIdentity,commitmentId=readiness.commitmentId,admissionKind=bridge.admissionKind,cornerKey=bridge.cornerKey,
        operationId=bridge.operationId,regulatedAssemblyId=bridge.regulatedAssemblyId,protectedAssemblyId=bridge.protectedAssemblyId},nil
end

-- INITIAL establishes the semantic responsibility. REACTIVATION and
-- ROLE_MIGRATION preserve it; neither mutable actuation event is a transition.
function Authority:establishOrPreserveActionSpaceRegulation(preflight,applied)
    local commitment=applied and applied.commitment or nil
    if preflight==nil or commitment==nil then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTEXT_MISSING" end
    local context=preflight.context
    local current=preflight.current or self:getCurrentRegulation(commitment.identity)
    if context=="INITIAL" then
        if current~=nil then
            if current.provenance.conflictIdentity==preflight.conflictIdentity and current.provenance.retainedCommitmentId==commitment.identity then return current,nil end
            return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_ALREADY_CURRENT"
        end
        current=OuttaMyWay.Regulation.new({
            identity=self.runtime.identities:issue("RESPONSIBILITY"),kind="REGULATION",
            governingBasis=commitment.governingBasis,
            provenance={source="ActionSpaceRegulationResponsibilityTransition",conflictIdentity=preflight.conflictIdentity,retainedCommitmentId=commitment.identity,
                admissionKind=preflight.admissionKind,cornerKey=preflight.cornerKey,operationId=preflight.operationId,
                regulatedAssemblyId=preflight.regulatedAssemblyId,protectedAssemblyId=preflight.protectedAssemblyId}
        })
        self.regulationsByCommitmentId[commitment.identity]=current
        publishRegulation(self.runtime,current,"STARTED","ESTABLISHED")
        return current,nil
    end
    if context~="REACTIVATION" and context~="ROLE_MIGRATION" then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTEXT_UNSUPPORTED" end
    if current==nil or current.provenance.retainedCommitmentId~=commitment.identity then
        return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTINUITY_MISMATCH"
    end
    return current,nil
end

local function sameTwoParticipants(current,bridge)
    local provenance=current and current.provenance or nil
    local ids=bridge and bridge.assemblyIds or nil
    if provenance==nil or OuttaMyWay.ValueRecord.length(ids or {})~=2 then return false end
    local regulated=provenance.regulatedAssemblyId
    local protected=provenance.protectedAssemblyId
    if type(regulated)~="string" or type(protected)~="string" or regulated==protected then return false end
    local seen={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(ids) do
        if type(id)~="string" or seen[id] then return false end
        seen[id]=true
    end
    return seen[regulated]==true and seen[protected]==true
end

local function passagePairKey(evaluated)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    local ids={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(bridge and bridge.assemblyIds or {}) do
        if type(id)~="string" then return nil end
        ids[#ids+1]=id
    end
    if #ids~=2 or ids[1]==ids[2] then return nil end
    table.sort(ids)
    return table.concat(ids,"|")
end

local function cooperativePassageCandidateConsistent(candidate,bridge)
    if candidate==nil or candidate.capability~="REPOSITION" or type(bridge)~="table" then
        return false,"COOPERATIVE_PASSAGE_SUCCESSOR_CONTEXT_INVALID"
    end
    local owned=ownershipAssemblyIds(candidate)
    if #owned~=2 or owned[1]==owned[2] then
        return false,"COOPERATIVE_PASSAGE_SUCCESSOR_OWNERSHIP_INVALID"
    end
    local participants={}
    local participantCount=0
    for _,id in OuttaMyWay.ValueRecord.ipairs(bridge.assemblyIds or {}) do
        if type(id)~="string" or participants[id] then
            return false,"COOPERATIVE_PASSAGE_SUCCESSOR_PARTICIPANTS_INVALID"
        end
        participants[id]=true
        participantCount=participantCount+1
    end
    if participantCount~=2 or not participants[owned[1]] or not participants[owned[2]] then
        return false,"COOPERATIVE_PASSAGE_SUCCESSOR_PARTICIPANTS_MISMATCH"
    end
    return true,nil
end

function Authority:actionSpacePassagePredecessor(picture,evaluated)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    if bridge==nil or bridge.architecture~="COOPERATIVE_PASSAGE" then return nil end
    local exact=self:findRegulation("conflictIdentity",bridge.conflictIdentity)
    if exact~=nil then return exact,"SAME_CONFLICT_IDENTITY" end

    local matched=nil
    local matchedKind=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        local current=self:getCurrentRegulation(context.commitmentId)
        local kind=current and current.provenance and current.provenance.admissionKind or nil
        local participantScoped=kind=="CORNER_RIGHT_OF_WAY" or kind=="FORWARD_INTERSECTION"
        if current~=nil and participantScoped
            and sameTwoParticipants(current,bridge)
            and (current.provenance.operationId==nil or bridge.operationId==nil or current.provenance.operationId==bridge.operationId) then
            if matched~=nil and matched.identity~=current.identity then return nil,"MULTIPLE_PARTICIPANT_SCOPED_PASSAGE_PREDECESSORS" end
            matched=current
            matchedKind=kind
        end
    end
    if matched~=nil then
        return matched,matchedKind=="CORNER_RIGHT_OF_WAY" and "SAME_PAIR_CORNER_RIGHT_OF_WAY" or "SAME_PAIR_FORWARD_INTERSECTION"
    end
    return nil
end

-- A Passage may succeed either the established opposed-conflict Regulation
-- carrying the same conflict identity or a participant-scoped Corner Right-of-Way /
-- Forward Intersection Regulation over the same two current participants.
-- Situation identity is evidence provenance; it is not Responsibility succession identity.
function Authority:replaceActionSpaceRegulationWithCooperativePassage(picture,evaluated,readiness,passageTransition,regulationAuthority)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    local current=self:actionSpacePassagePredecessor(picture,evaluated)
    if current==nil or bridge==nil or bridge.architecture~="COOPERATIVE_PASSAGE" then
        return nil,"ACTION_SPACE_PASSAGE_RESPONSIBILITY_PREDECESSOR_MISMATCH"
    end
    local preflight,preflightReason=self:preflightActionSpaceRegulationForCooperativePassage(picture,evaluated,readiness)
    if preflight==nil then return nil,preflightReason end
    if preflight.commitmentId~=current.provenance.retainedCommitmentId or preflight.conflictIdentity~=current.provenance.conflictIdentity then
        return nil,"ACTION_SPACE_PASSAGE_RESPONSIBILITY_SUBSTRATE_MISMATCH"
    end
    if regulationAuthority==nil or type(regulationAuthority.preflightActionSpaceNeutralization)~="function" then
        return nil,"ACTION_SPACE_PASSAGE_PREFLIGHT_CONTEXT_MISMATCH"
    end
    local physicalPreflight,physicalReason=regulationAuthority:preflightActionSpaceNeutralization(preflight.commitmentId,preflight.conflictIdentity)
    if physicalPreflight==nil then return nil,physicalReason end
    local targeted=false
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if context.commitmentId==preflight.commitmentId then targeted=true break end
    end
    if targeted~=true then
        return nil,"ACTION_SPACE_PASSAGE_RESPONSIBILITY_SUCCESSION_NOT_TARGETED"
    end
    return self:replaceRegulationWithCooperativePassage(current,preflight,picture,evaluated,readiness,passageTransition,regulationAuthority,
        self.supersedeActionSpaceRegulationForCooperativePassage)
end

-- Shared semantic commit point. A successor is exposed only after subordinate
-- retained revision and predecessor cleanup have both succeeded.
function Authority:replaceRegulationWithCooperativePassage(current,preflight,picture,evaluated,readiness,passageTransition,regulationAuthority,cleanupMethod)
    local successorIdentity=self.runtime.identities:issue("RESPONSIBILITY")
    local applied,reason=passageTransition:transition(picture,evaluated,readiness,{
        responsibilityIdentity=successorIdentity,deferResponsibilityExposureLog=true,
        rebindCommitmentPurpose=preflight.rebindCommitmentPurpose==true
    })
    if applied==nil then return nil,reason end
    if applied.commitment.identity~=preflight.commitmentId then
        return nil,"REGULATION_PASSAGE_RETAINED_COMMITMENT_CHANGED"
    end
    local retired,retireReason=cleanupMethod(self,applied.commitment,evaluated,regulationAuthority,picture)
    if retired==nil or retired.settled==nil then return nil,retireReason or (retired and retired.reason) or "REGULATION_PREDECESSOR_CLEANUP_FAILED" end
    self.regulationsByCommitmentId[preflight.commitmentId]=nil
    self.resolutionsByCommitmentId[preflight.commitmentId]=applied.currentResponsibility
    publishRegulation(self.runtime,current,"ENDED","REPLACED_BY_COOPERATIVE_PASSAGE")
    publishResolution(self.runtime,applied.currentResponsibility,applied.commitment.identity,"STARTED","REPLACED_REGULATION")
    logInfo("RESPONSIBILITY_REPLACED","predecessor=%s predecessorKind=REGULATION successor=%s successorKind=RESOLUTION_COMMITMENT commitment=%s atomic=true beforePhysicalDispatch=true",
        tostring(current.identity),tostring(applied.currentResponsibility.identity),tostring(applied.commitment.identity))
    return applied,nil
end

function Authority:matchesActionSpacePassage(picture,evaluated)
    local current=self:actionSpacePassagePredecessor(picture,evaluated)
    return current~=nil
end

-- These keys locate implementation substrate; RS-* remains the identity.
function Authority:findRegulation(provenanceKey,value)
    if value==nil then return nil end
    for _,current in pairs(self.regulationsByCommitmentId) do
        if current.provenance[provenanceKey]==value then return current end
    end
    return nil
end

function Authority:getCurrentRegulation(commitmentId)
    return self.regulationsByCommitmentId[commitmentId]
end

function Authority:getCurrentResolutionCommitment(commitmentId)
    return self.resolutionsByCommitmentId[commitmentId]
end

-- Maintenance of the same Cooperative Passage semantic view, without a
-- Responsibility Transition or RS-* identity churn.
function Authority:refreshCooperativePassageResolutionCommitment(commitmentId)
    local current=self:getCurrentResolutionCommitment(commitmentId)
    if current==nil then return nil,"COOPERATIVE_PASSAGE_RESOLUTION_NOT_CURRENT" end
    local responsibility=current.governingBasis and current.governingBasis.responsibilityKey or nil
    if not hasPrefix(responsibility,"cooperative-passage:") then
        return nil,"COOPERATIVE_PASSAGE_RESOLUTION_CONTEXT_MISMATCH"
    end
    local obligationIds,assemblyIds,seenAssemblies={},{},{}
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(self.runtime.obligations:openForOwner(commitmentId)) do
        obligationIds[#obligationIds+1]=obligation.identity
        local basis=obligation.basis or {}
        if basis.kind=="COOPERATIVE_PASSAGE_LEG" and type(basis.assemblyId)=="string" and seenAssemblies[basis.assemblyId]~=true then
            seenAssemblies[basis.assemblyId]=true
            assemblyIds[#assemblyIds+1]=basis.assemblyId
        end
    end
    table.sort(obligationIds)
    table.sort(assemblyIds)
    local refreshed=OuttaMyWay.ResolutionCommitment.new({
        identity=current.identity,kind=current.kind,purpose=current.purpose,governingBasis=current.governingBasis,
        beneficiaryAssemblyIds=assemblyIds,controlledSubjectAssemblyIds=assemblyIds,
        openResolutionObligationIds=obligationIds,provenance=current.provenance
    })
    self.resolutionsByCommitmentId[commitmentId]=refreshed
    return refreshed,nil
end

function Authority:terminateRegulation(commitmentId,reason)
    local current=self.regulationsByCommitmentId[commitmentId]
    if current~=nil and self.runtime.boundedAuthority~=nil then self.runtime.boundedAuthority:releaseForResponsibility(current.identity,"REGULATION_RESPONSIBILITY_TERMINATED") end
    self.regulationsByCommitmentId[commitmentId]=nil
    if current~=nil then publishRegulation(self.runtime,current,"ENDED",reason or "RESPONSIBILITY_TERMINATED") end
    return true
end

function Authority:terminateResolutionCommitment(commitmentId,reason)
    local current=self.resolutionsByCommitmentId[commitmentId]
    if current~=nil and self.runtime.boundedAuthority~=nil then self.runtime.boundedAuthority:releaseForResponsibility(current.identity,"RESOLUTION_RESPONSIBILITY_TERMINATED") end
    self.resolutionsByCommitmentId[commitmentId]=nil
    if current~=nil then publishResolution(self.runtime,current,commitmentId,"ENDED",reason or "RESPONSIBILITY_TERMINATED") end
    return true
end

function Authority:terminateAll(reason)
    local commitmentIds,seen={},{}
    for commitmentId,_ in OuttaMyWay.ValueRecord.pairs(self.regulationsByCommitmentId) do
        if seen[commitmentId]~=true then seen[commitmentId]=true; commitmentIds[#commitmentIds+1]=commitmentId end
    end
    for commitmentId,_ in OuttaMyWay.ValueRecord.pairs(self.resolutionsByCommitmentId) do
        if seen[commitmentId]~=true then seen[commitmentId]=true; commitmentIds[#commitmentIds+1]=commitmentId end
    end
    table.sort(commitmentIds)
    local regulations,resolutions=0,0
    for _,commitmentId in OuttaMyWay.ValueRecord.ipairs(commitmentIds) do
        if self.regulationsByCommitmentId[commitmentId]~=nil then regulations=regulations+1; self:terminateRegulation(commitmentId,reason) end
        if self.resolutionsByCommitmentId[commitmentId]~=nil then resolutions=resolutions+1; self:terminateResolutionCommitment(commitmentId,reason) end
    end
    return {commitmentCount=#commitmentIds,regulationCount=regulations,resolutionCount=resolutions}
end

function Authority:terminateSemanticResponsibilitiesForTerminalCommitment(commitmentId)
    local regulation=self.regulationsByCommitmentId[commitmentId]
    local resolution=self.resolutionsByCommitmentId[commitmentId]
    if self.runtime.boundedAuthority~=nil then
        if regulation~=nil then self.runtime.boundedAuthority:releaseForResponsibility(regulation.identity,"TERMINAL_COMMITMENT_RESPONSIBILITY_TERMINATED") end
        if resolution~=nil then self.runtime.boundedAuthority:releaseForResponsibility(resolution.identity,"TERMINAL_COMMITMENT_RESPONSIBILITY_TERMINATED") end
    end
    self.regulationsByCommitmentId[commitmentId]=nil
    self.resolutionsByCommitmentId[commitmentId]=nil
    if regulation~=nil then publishRegulation(self.runtime,regulation,"ENDED","TERMINAL_COMMITMENT") end
    if resolution~=nil then publishResolution(self.runtime,resolution,commitmentId,"ENDED","TERMINAL_COMMITMENT") end
    return true
end

local function cooperativePassageTargetContext(picture,bridge)
    local contexts=picture and picture.commitmentContext or {}
    local match=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(contexts) do
        local basis=context.governingBasis
        if type(basis)=="table" and basis.responsibilityKey==bridge.governingRequirementKey then
            if match~=nil then return nil,"MULTIPLE_COOPERATIVE_PASSAGE_RETAINED_SUBSTRATES" end
            match=context
        end
    end
    if match==nil then
        if OuttaMyWay.ValueRecord.length(contexts)>0 then
            return nil,"COOPERATIVE_PASSAGE_RETAINED_SUBSTRATE_NOT_TARGETED"
        end
        return nil,nil
    end
    -- Semantic targeting may already be unambiguous even when another
    -- independent retained context exists. The current generic Commitment
    -- application boundary nevertheless accepts only one context, so fail
    -- closed without misclassifying that implementation limit as semantic
    -- target ambiguity.
    if OuttaMyWay.ValueRecord.length(contexts)~=1 then
        return nil,"COOPERATIVE_PASSAGE_MULTI_CONTEXT_APPLICATION_UNSUPPORTED"
    end
    return match,nil
end

local function currentCooperativePassagePairEpisodes(runtime,bridge)
    local registry=runtime and runtime.jobEpisodes or nil
    if registry==nil
        or type(registry.getActiveForAssembly)~="function"
        or type(registry.get)~="function" then
        return nil,"COOPERATIVE_PASSAGE_JOB_EPISODE_AUTHORITY_UNAVAILABLE"
    end

    local subject=registry:getActiveForAssembly(bridge.subjectAssemblyId)
    local other=registry:getActiveForAssembly(bridge.otherAssemblyId)
    if subject==nil or other==nil
        or subject.status~="ACTIVE" or other.status~="ACTIVE"
        or subject.identity==other.identity then
        return nil,"COOPERATIVE_PASSAGE_CURRENT_JOB_EPISODE_UNAVAILABLE"
    end

    if bridge.subjectJobToken~=nil and subject.sourceJobToken~=bridge.subjectJobToken then
        return nil,"COOPERATIVE_PASSAGE_CURRENT_JOB_EPISODE_MISMATCH"
    end
    if bridge.otherJobToken~=nil and other.sourceJobToken~=bridge.otherJobToken then
        return nil,"COOPERATIVE_PASSAGE_CURRENT_JOB_EPISODE_MISMATCH"
    end

    return {subjectId=subject.identity,otherId=other.identity},nil
end

local function retainedCooperativePassagePairEpisodesMatch(runtime,basis,bridge,current)
    local retainedSubject=nil
    local retainedOther=nil

    for _,episodeId in OuttaMyWay.ValueRecord.ipairs(basis and basis.sourceIntentIds or {}) do
        local episode=runtime.jobEpisodes:get(episodeId)
        if episode~=nil and episode.assemblyId==bridge.subjectAssemblyId then
            if retainedSubject~=nil then
                return false,"COOPERATIVE_PASSAGE_RETAINED_SUBSTRATE_JOB_EPISODE_AMBIGUOUS"
            end
            retainedSubject=episode.identity
        elseif episode~=nil and episode.assemblyId==bridge.otherAssemblyId then
            if retainedOther~=nil then
                return false,"COOPERATIVE_PASSAGE_RETAINED_SUBSTRATE_JOB_EPISODE_AMBIGUOUS"
            end
            retainedOther=episode.identity
        end
    end

    if retainedSubject~=current.subjectId or retainedOther~=current.otherId then
        return false,"COOPERATIVE_PASSAGE_RETAINED_SUBSTRATE_JOB_EPISODE_MISMATCH"
    end

    local dependencies=basis and basis.dependentJobEpisodeIds or {}
    if OuttaMyWay.ValueRecord.length(dependencies)>0 then
        local subjectDependency=false
        local otherDependency=false
        for _,episodeId in OuttaMyWay.ValueRecord.ipairs(dependencies) do
            if episodeId==current.subjectId then subjectDependency=true end
            if episodeId==current.otherId then otherDependency=true end
        end
        if OuttaMyWay.ValueRecord.length(dependencies)~=2
            or subjectDependency~=true or otherDependency~=true then
            return false,"COOPERATIVE_PASSAGE_RETAINED_SUBSTRATE_DEPENDENCY_MISMATCH"
        end
    end

    return true,nil
end

-- Direct Cooperative Passage substrate targeting is a transition-boundary
-- consistency question, not Responsibility continuation authority.  The
-- retained purpose must first target the selected Cooperative Passage governing requirement
-- and the same two current Job Episodes.  Only then may an already-current
-- Resolution responsibility be reused.
function Authority:evaluateDirectCooperativePassageSubstrate(picture,evaluated)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    if type(bridge)~="table"
        or bridge.architecture~="COOPERATIVE_PASSAGE"
        or type(bridge.governingRequirementKey)~="string"
        or type(bridge.subjectAssemblyId)~="string"
        or type(bridge.otherAssemblyId)~="string"
        or bridge.subjectAssemblyId==bridge.otherAssemblyId then
        return nil,"COOPERATIVE_PASSAGE_SUBSTRATE_CONTEXT_INVALID"
    end

    local target,targetReason=cooperativePassageTargetContext(picture,bridge)
    if targetReason~=nil then return nil,targetReason end
    if target==nil then
        return {bridge=bridge,commitmentId=nil,currentResolution=nil},nil
    end

    if type(target.commitmentId)~="string" or target.commitmentId=="" then
        return nil,"COOPERATIVE_PASSAGE_RETAINED_SUBSTRATE_IDENTITY_INVALID"
    end

    local retained=self.runtime.commitments:get(target.commitmentId)
    if retained==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(retained.state) then
        return nil,"COOPERATIVE_PASSAGE_RETAINED_SUBSTRATE_NOT_LIVE"
    end

    local basis=retained.governingBasis
    if type(basis)~="table"
        or basis.responsibilityKey~=bridge.governingRequirementKey then
        return nil,"COOPERATIVE_PASSAGE_RETAINED_SUBSTRATE_PURPOSE_MISMATCH"
    end

    local currentEpisodes,episodeReason=currentCooperativePassagePairEpisodes(self.runtime,bridge)
    if currentEpisodes==nil then return nil,episodeReason end

    local episodeMatch,matchReason=retainedCooperativePassagePairEpisodesMatch(
        self.runtime,basis,bridge,currentEpisodes)
    if episodeMatch~=true then return nil,matchReason end

    local current=self:getCurrentResolutionCommitment(retained.identity)
    if current==nil then
        return nil,"RESOLUTION_RESPONSIBILITY_CONTINUITY_MISSING"
    end

    local currentBasis=current.governingBasis
    if current.kind~="RESOLUTION_COMMITMENT"
        or type(currentBasis)~="table"
        or currentBasis.responsibilityKey~=bridge.governingRequirementKey then
        return nil,"COOPERATIVE_PASSAGE_CURRENT_RESPONSIBILITY_SUBSTRATE_MISMATCH"
    end

    return {
        bridge=bridge,
        commitmentId=retained.identity,
        currentResolution=current
    },nil
end

function Authority:resolutionIdentityForCommitment(commitmentId,action)
    local current=self:getCurrentResolutionCommitment(commitmentId)
    if current~=nil then return current.identity,true,nil end
    if action=="MAINTAIN" or action=="REVISE" then return nil,nil,"RESOLUTION_RESPONSIBILITY_CONTINUITY_MISSING" end
    return self.runtime.identities:issue("RESPONSIBILITY"),false,nil
end

function Authority:transitionCooperativePassageResolution(picture,evaluated,readiness,passageTransition)
    local substrate,substrateReason=self:evaluateDirectCooperativePassageSubstrate(picture,evaluated)
    if substrate==nil then return nil,substrateReason end

    local current=substrate.currentResolution
    local identity=current and current.identity or self.runtime.identities:issue("RESPONSIBILITY")
    local responsibilityAlreadyCurrent=current~=nil

    local applied,reason=passageTransition:transition(picture,evaluated,readiness,{
        responsibilityIdentity=identity,responsibilityAlreadyCurrent=responsibilityAlreadyCurrent
    })
    if applied==nil then return nil,reason end

    if substrate.commitmentId~=nil
        and (applied.commitment==nil or applied.commitment.identity~=substrate.commitmentId) then
        return nil,"COOPERATIVE_PASSAGE_RETAINED_COMMITMENT_CHANGED"
    end

    self.resolutionsByCommitmentId[applied.commitment.identity]=applied.currentResponsibility
    if not responsibilityAlreadyCurrent then
        publishResolution(self.runtime,applied.currentResponsibility,applied.commitment.identity,"STARTED","ESTABLISHED")
    end
    return applied,nil
end

function Authority:transitionBlockedWorkerRecoveryResolution(picture,evaluated,readiness,recoveryTransition)
    local identity=self.runtime.identities:issue("RESPONSIBILITY")
    local applied,reason=recoveryTransition:transition(picture,evaluated,readiness,{
        responsibilityIdentity=identity,responsibilityAlreadyCurrent=false
    })
    if applied==nil then return nil,reason end
    self.resolutionsByCommitmentId[applied.commitment.identity]=applied.currentResponsibility
    publishResolution(self.runtime,applied.currentResponsibility,applied.commitment.identity,"STARTED","ESTABLISHED")
    return applied,nil
end

function Authority:transitionObstructionRelocationResolution(picture,evaluated,readiness,relocationTransition)
    local commitmentId=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if type(context.commitmentId)=="string" then commitmentId=context.commitmentId break end
    end
    local identity=nil
    local responsibilityAlreadyCurrent=false
    if type(commitmentId)=="string" then
        local reason=nil
        identity,responsibilityAlreadyCurrent,reason=self:resolutionIdentityForCommitment(commitmentId,evaluated and evaluated.decision and evaluated.decision.commitmentAction)
        if identity==nil then return nil,reason end
    else
        identity=self.runtime.identities:issue("RESPONSIBILITY")
    end
    local applied,reason=relocationTransition:transition(picture,evaluated,readiness,{
        responsibilityIdentity=identity,responsibilityAlreadyCurrent=responsibilityAlreadyCurrent
    })
    if applied==nil then return nil,reason end
    self.resolutionsByCommitmentId[applied.commitment.identity]=applied.currentResponsibility
    if not responsibilityAlreadyCurrent then
        publishResolution(self.runtime,applied.currentResponsibility,applied.commitment.identity,"STARTED","ESTABLISHED")
    end
    return applied,nil
end

function Authority:terminateActionSpaceRegulation(commitmentId,conflictIdentity)
    local current=self:getCurrentRegulation(commitmentId)
    if current==nil then return true end
    if current.provenance.conflictIdentity~=conflictIdentity then return false end
    return self:terminateRegulation(commitmentId)
end

-- Compatibility observation for the original single-exemplar callers. With
-- several Action-Space instances the caller must supply its substrate key.
function Authority:getCurrentActionSpaceRegulation(commitmentId)
    if commitmentId~=nil then
        local current=self:getCurrentRegulation(commitmentId)
        return current and current.provenance.conflictIdentity~=nil and current or nil
    end
    local result=nil
    for _,current in pairs(self.regulationsByCommitmentId) do
        if current.provenance.conflictIdentity~=nil then
            if result~=nil then return nil end
            result=current
        end
    end
    return result
end

function Authority:preflightFollowerRegulation(picture,evaluated)
    local bridge=selectedBridge(evaluated,"followerBoundaryBridge")
    if bridge==nil or bridge.action~="APPLY" then return nil,"FOLLOWER_REGULATION_PREFLIGHT_CONTEXT_MISMATCH" end
    local current=self:findRegulation("pairKey",bridge.pairKey)
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        local targeted=self:getCurrentRegulation(context.commitmentId)
        if targeted~=nil and targeted~=current then return nil,"FOLLOWER_REGULATION_PREFLIGHT_SUBSTRATE_MISMATCH" end
    end
    local retained=bridge.existingCommitmentId and self:getCurrentRegulation(bridge.existingCommitmentId) or nil
    if retained~=nil and retained~=current then return nil,"FOLLOWER_REGULATION_PREFLIGHT_SUBSTRATE_MISMATCH" end
    if current~=nil and current.provenance.retainedCommitmentId~=bridge.existingCommitmentId then
        return nil,"FOLLOWER_REGULATION_PREFLIGHT_CONTINUITY_MISMATCH"
    end
    return {current=current,pairKey=bridge.pairKey,operationId=bridge.operationId,
        leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId},nil
end

function Authority:establishOrPreserveFollowerRegulation(preflight,applied)
    local commitment=applied and applied.commitment or nil
    if preflight==nil or commitment==nil then return nil,"FOLLOWER_REGULATION_CONTEXT_MISSING" end
    local current=preflight.current or self:getCurrentRegulation(commitment.identity)
    if current~=nil then
        if current.provenance.pairKey~=preflight.pairKey or current.provenance.retainedCommitmentId~=commitment.identity then
            return nil,"FOLLOWER_REGULATION_CONTINUITY_MISMATCH"
        end
        return current,nil
    end
    current=OuttaMyWay.Regulation.new({identity=self.runtime.identities:issue("RESPONSIBILITY"),kind="REGULATION",
        governingBasis=commitment.governingBasis,
        provenance={source="FollowerBoundaryResponsibilityTransition",pairKey=preflight.pairKey,retainedCommitmentId=commitment.identity,
            operationId=preflight.operationId,leaderAssemblyId=preflight.leaderAssemblyId,followerAssemblyId=preflight.followerAssemblyId}})
    self.regulationsByCommitmentId[commitment.identity]=current
    publishRegulation(self.runtime,current,"STARTED","ESTABLISHED")
    return current,nil
end

function Authority:matchesFollowerPassage(picture,evaluated)
    local targetPairKey=passagePairKey(evaluated)
    if targetPairKey==nil then return false end
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        local current=self:getCurrentRegulation(context.commitmentId)
        if current~=nil and current.provenance.pairKey==targetPairKey then return true end
    end
    return false
end

function Authority:independentRegulationPassagePredecessor(picture,evaluated)
    local candidate=selectedCandidate(evaluated)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    local consistent=cooperativePassageCandidateConsistent(candidate,bridge)
    if consistent~=true then return nil end
    if self:actionSpacePassagePredecessor(picture,evaluated)~=nil or self:matchesFollowerPassage(picture,evaluated) then return nil end
    local contexts=picture and picture.commitmentContext or {}
    if OuttaMyWay.ValueRecord.length(contexts)~=1 then return nil end
    local context=contexts[1]
    if type(context.commitmentId)~="string" then return nil end
    return self:getCurrentRegulation(context.commitmentId)
end

function Authority:matchesIndependentRegulationPassage(picture,evaluated)
    return self:independentRegulationPassagePredecessor(picture,evaluated)~=nil
end

function Authority:replaceIndependentRegulationWithCooperativePassage(picture,evaluated,readiness,passageTransition,regulationAuthority)
    local current=self:independentRegulationPassagePredecessor(picture,evaluated)
    local candidate=selectedCandidate(evaluated)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    if current==nil or candidate==nil or bridge==nil or readiness==nil
        or readiness.status~="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED"
        or candidate.identity~=readiness.candidateId then
        return nil,"INDEPENDENT_REGULATION_PASSAGE_PREFLIGHT_CONTEXT_MISMATCH"
    end
    local consistent,consistencyReason=cooperativePassageCandidateConsistent(candidate,bridge)
    if consistent~=true then return nil,consistencyReason end
    local predecessorId=current.provenance and current.provenance.retainedCommitmentId or nil
    if type(predecessorId)~="string" then return nil,"INDEPENDENT_REGULATION_PASSAGE_PREDECESSOR_COMMITMENT_UNAVAILABLE" end
    local predecessor=self.runtime.commitments:get(predecessorId)
    if predecessor==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(predecessor.state) then
        return nil,"INDEPENDENT_REGULATION_PASSAGE_PREDECESSOR_NOT_LIVE"
    end
    if regulationAuthority==nil then return nil,"INDEPENDENT_REGULATION_PASSAGE_REGULATION_AUTHORITY_UNAVAILABLE" end

    local neutralized=nil
    if type(current.provenance.pairKey)=="string" then
        local preflight,preflightReason=regulationAuthority:preflightFollowerBoundaryNeutralization(predecessorId,current.provenance.pairKey)
        if preflight==nil then return nil,preflightReason end
        neutralized=regulationAuthority:neutralizeFollowerBoundaryPhysical(
            picture,evaluated,candidate,"COOPERATIVE_PASSAGE_SUPERSEDES_UNRELATED_TACTICAL_REGULATION")
    else
        local conflictIdentity=current.provenance and current.provenance.conflictIdentity or nil
        if type(conflictIdentity)~="string" then return nil,"INDEPENDENT_REGULATION_PASSAGE_PREDECESSOR_CONFLICT_UNAVAILABLE" end
        local preflight,preflightReason=regulationAuthority:preflightActionSpaceNeutralization(predecessorId,conflictIdentity)
        if preflight==nil then return nil,preflightReason end
        neutralized=regulationAuthority:neutralizeActionSpaceRegulationPhysical(
            picture,evaluated,"COOPERATIVE_PASSAGE_SUPERSEDES_UNRELATED_TACTICAL_REGULATION")
    end
    if neutralized==nil or neutralized.status~="RELEASED" then
        return nil,"INDEPENDENT_REGULATION_PASSAGE_PHYSICAL_NEUTRALIZATION_FAILED"
    end

    -- Release predecessor progress ownership before Bubble Formation so the
    -- successor pair and its third-party Bullet Time can acquire fresh authority.
    for _,token in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(predecessorId)) do
        if self.runtime.authorities:validate(token)==true then
            OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(
                self.runtime,predecessorId,token.assemblyId,
                {reason="COOPERATIVE_PASSAGE_CROSS_CONTEXT_PREDECESSOR_NEUTRALIZED",preserveAuthority=false})
        end
    end

    local successorIdentity=self.runtime.identities:issue("RESPONSIBILITY")
    local applied,reason=passageTransition:transition(picture,evaluated,readiness,{
        responsibilityIdentity=successorIdentity,deferResponsibilityExposureLog=true,
        freshReplacementPredecessorCommitmentId=predecessorId
    })
    if applied==nil then return nil,reason end

    local retired,retireReason=nil,nil
    if type(current.provenance.pairKey)=="string" then
        retired,retireReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.settleFollowerBoundaryPurpose(
            self.runtime,predecessorId,
            {pairKey=current.provenance.pairKey,reason="COOPERATIVE_PASSAGE_SUPERSEDES_UNRELATED_TACTICAL_REGULATION"},
            {kind="COOPERATIVE_PASSAGE_CROSS_CONTEXT_SUPERSESSION",successorCommitmentId=applied.commitment.identity})
    else
        retired,retireReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.settleActionSpaceRegulationPurpose(
            self.runtime,predecessorId,
            {conflictIdentity=current.provenance.conflictIdentity,reason="COOPERATIVE_PASSAGE_SUPERSEDES_ACTION_SPACE_REGULATION"},
            {kind="COOPERATIVE_PASSAGE_CROSS_CONTEXT_SUPERSESSION",successorCommitmentId=applied.commitment.identity})
    end
    if retired==nil or retired.terminal==nil then
        if type(self.runtime.onCooperativePassageCompletion)=="function" then
            self.runtime:onCooperativePassageCompletion({
                status="FAILED",commitmentId=applied.commitment.identity,
                evidence={kind="PREDECESSOR_REGULATION_SUPERSESSION_FAILED",reason=retireReason}
            })
        end
        return nil,retireReason or "INDEPENDENT_REGULATION_PASSAGE_PREDECESSOR_SETTLEMENT_FAILED"
    end

    self.regulationsByCommitmentId[predecessorId]=nil
    self.resolutionsByCommitmentId[applied.commitment.identity]=applied.currentResponsibility
    publishRegulation(self.runtime,current,"ENDED","REPLACED_BY_COOPERATIVE_PASSAGE")
    publishResolution(self.runtime,applied.currentResponsibility,applied.commitment.identity,"STARTED","REPLACED_REGULATION")
    logInfo("RESPONSIBILITY_REPLACED","predecessor=%s predecessorKind=REGULATION predecessorCommitment=%s successor=%s successorKind=RESOLUTION_COMMITMENT successorCommitment=%s crossContext=true atomicCycle=true beforePhysicalDispatch=true",
        tostring(current.identity),tostring(predecessorId),tostring(applied.currentResponsibility.identity),tostring(applied.commitment.identity))
    return applied,nil
end

function Authority:replaceFollowerRegulationWithCooperativePassage(picture,evaluated,readiness,passageTransition,regulationAuthority)
    local preflight,reason=self:preflightFollowerRegulationForCooperativePassage(picture,evaluated,readiness)
    if preflight==nil then return nil,reason end
    local current=self:getCurrentRegulation(preflight.commitmentId)
    if current==nil or current.provenance.pairKey~=preflight.pairKey then return nil,"FOLLOWER_PASSAGE_PREDECESSOR_MISMATCH" end
    if regulationAuthority==nil or type(regulationAuthority.preflightFollowerBoundaryNeutralization)~="function" then
        return nil,"FOLLOWER_PASSAGE_PREFLIGHT_CONTEXT_MISMATCH"
    end
    local physicalPreflight,physicalReason=regulationAuthority:preflightFollowerBoundaryNeutralization(preflight.commitmentId,preflight.pairKey)
    if physicalPreflight==nil then return nil,physicalReason end
    local targeted=false
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if context.commitmentId==preflight.commitmentId then targeted=true break end
    end
    if not targeted or OuttaMyWay.ValueRecord.length(picture.commitmentContext)~=1 then return nil,"FOLLOWER_PASSAGE_SUCCESSION_NOT_TARGETED" end
    return self:replaceRegulationWithCooperativePassage(current,preflight,picture,evaluated,readiness,passageTransition,regulationAuthority,
        self.supersedeFollowerRegulationForCooperativePassage)
end

function Authority:preflightActionSpaceRegulationForCooperativePassage(picture,evaluated,readiness)
    local candidate=selectedCandidate(evaluated)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    local current=self:actionSpacePassagePredecessor(picture,evaluated)
    if current==nil or bridge==nil or candidate==nil or readiness==nil or readiness.status~="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED"
        or bridge.architecture~="COOPERATIVE_PASSAGE" or current.provenance.retainedCommitmentId==nil
        or candidate.identity~=readiness.candidateId then
        return nil,"ACTION_SPACE_PASSAGE_PREFLIGHT_CONTEXT_MISMATCH"
    end
    local targeted=false
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if context.commitmentId==current.provenance.retainedCommitmentId then targeted=true break end
    end
    if targeted~=true or OuttaMyWay.ValueRecord.length(picture.commitmentContext or {})~=1 then
        return nil,"ACTION_SPACE_PASSAGE_RESPONSIBILITY_SUCCESSION_NOT_TARGETED"
    end

    local corner=current.provenance.admissionKind=="CORNER_RIGHT_OF_WAY"
    local forwardIntersection=current.provenance.admissionKind=="FORWARD_INTERSECTION"
    if corner and not sameTwoParticipants(current,bridge) then
        return nil,"CORNER_PASSAGE_PREFLIGHT_PARTICIPANTS_MISMATCH"
    end
    if forwardIntersection and not sameTwoParticipants(current,bridge) then
        return nil,"FORWARD_INTERSECTION_PASSAGE_PREFLIGHT_PARTICIPANTS_MISMATCH"
    end

    local obligationId=nil
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(self.runtime.obligations:openForOwner(current.provenance.retainedCommitmentId)) do
        local basis=obligation.basis
        local outcome=obligation.requiredOutcome
        local actionSpace=type(basis)=="table" and basis.kind=="ACTION_SPACE_REGULATION"
            and type(outcome)=="table" and outcome.kind=="ACTION_SPACE_REGULATION_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES"
        local forwardIntersectionIntent=type(basis)=="table" and basis.kind=="FORWARD_INTERSECTION_INTENT_REVELATION"
            and type(outcome)=="table" and outcome.kind=="FORWARD_INTERSECTION_DISSOLVED_OR_SUCCEEDED"
        local cornerRightOfWay=type(basis)=="table" and basis.kind=="CORNER_RIGHT_OF_WAY"
            and type(outcome)=="table" and outcome.kind=="CORNER_RIGHT_OF_WAY_PRESERVED_UNTIL_COMPETING_DEMAND_DISSOLVES"
        if (actionSpace or forwardIntersectionIntent or cornerRightOfWay) and basis.conflictIdentity==current.provenance.conflictIdentity then
            obligationId=obligation.identity
            break
        end
    end
    if obligationId==nil then return nil,"ACTION_SPACE_PASSAGE_PREFLIGHT_OPEN_PREDECESSOR_OBLIGATION_UNAVAILABLE" end
    return {
        commitmentId=current.provenance.retainedCommitmentId,
        conflictIdentity=current.provenance.conflictIdentity,
        obligationId=obligationId,
        predecessorAdmissionKind=current.provenance.admissionKind,
        rebindCommitmentPurpose=corner or forwardIntersection
    },nil
end

function Authority:supersedeActionSpaceRegulationForCooperativePassage(commitment,evaluated,regulationAuthority,picture)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    local current=self:getCurrentRegulation(commitment and commitment.identity)
    if current==nil or bridge==nil then return nil,"ACTION_SPACE_PASSAGE_PREDECESSOR_MISMATCH" end
    local corner=current.provenance.admissionKind=="CORNER_RIGHT_OF_WAY"
    local forwardIntersection=current.provenance.admissionKind=="FORWARD_INTERSECTION"
    if corner and not sameTwoParticipants(current,bridge) then return nil,"CORNER_PASSAGE_PREDECESSOR_PARTICIPANTS_MISMATCH" end
    if forwardIntersection and not sameTwoParticipants(current,bridge) then return nil,"FORWARD_INTERSECTION_PASSAGE_PREDECESSOR_PARTICIPANTS_MISMATCH" end
    if not corner and not forwardIntersection and current.provenance.conflictIdentity~=bridge.conflictIdentity then return nil,"ACTION_SPACE_PASSAGE_PREDECESSOR_MISMATCH" end

    local supersessionReason=corner
        and "COOPERATIVE_PASSAGE_SUPERSEDES_CORNER_RIGHT_OF_WAY"
        or "COOPERATIVE_PASSAGE_SUPERSEDES_ACTION_SPACE_REGULATION"
    local neutralized=regulationAuthority and regulationAuthority:neutralizeActionSpaceRegulationPhysical(picture,evaluated,supersessionReason) or nil
    if neutralized==nil or neutralized.status~="RELEASED" then return nil,"ACTION_SPACE_PASSAGE_PHYSICAL_CLEANUP_FAILED" end
    local settled,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.settleActionSpaceRegulationPurpose(self.runtime,commitment.identity,{
        conflictIdentity=current.provenance.conflictIdentity,reason=supersessionReason
    },{
        kind=corner and "COOPERATIVE_PASSAGE_CORNER_RIGHT_OF_WAY_SUCCESSION" or "COOPERATIVE_PASSAGE_ESTABLISHED_CONFLICT_SUCCESSION",
        conflictIdentity=current.provenance.conflictIdentity,
        successorConflictIdentity=bridge.conflictIdentity
    })
    if settled==nil then
        logWarning("REGULATION_PASSAGE_SUPERSESSION_FAILED","commitment=%s conflict=%s physicalLeaseCleared=true obligationSettlement=%s",tostring(commitment.identity),tostring(current.provenance.conflictIdentity),tostring(reason))
    end
    return {settled=settled,reason=reason,physical=neutralized},nil
end

function Authority:preflightFollowerRegulationForCooperativePassage(picture,evaluated,readiness)
    local candidate=selectedCandidate(evaluated)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    if candidate==nil or candidate.capability~="REPOSITION" or readiness==nil
        or readiness.status~="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED"
        or candidate.identity~=readiness.candidateId or bridge==nil then
        return nil,"FOLLOWER_PASSAGE_PREFLIGHT_CONTEXT_MISMATCH"
    end
    local ids=ownershipAssemblyIds(candidate)
    local participants={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(bridge.assemblyIds or {}) do
        if type(id)~="string" or participants[id] then
            return nil,"FOLLOWER_PASSAGE_PREFLIGHT_PARTICIPANTS_INVALID"
        end
        participants[id]=true
    end
    if #ids~=2 or ids[1]==ids[2] or OuttaMyWay.ValueRecord.length(bridge.assemblyIds or {})~=2 then
        return nil,"FOLLOWER_PASSAGE_PREFLIGHT_PARTICIPANTS_INVALID"
    end
    if not participants[ids[1]] or not participants[ids[2]] then
        return nil,"FOLLOWER_PASSAGE_PREFLIGHT_PARTICIPANTS_MISMATCH"
    end
    local current=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        local targeted=self:getCurrentRegulation(context.commitmentId)
        if targeted~=nil and targeted.provenance.pairKey~=nil then current=targeted break end
    end
    if current==nil then return nil,"FOLLOWER_PASSAGE_PREFLIGHT_CURRENT_RESPONSIBILITY_UNAVAILABLE" end
    local commitment=self.runtime.commitments:get(current.provenance.retainedCommitmentId)
    if commitment==nil or commitment.state~="ACTIVE" then return nil,"FOLLOWER_PASSAGE_PREFLIGHT_COMMITMENT_NOT_ACTIVE" end
    for _,id in ipairs(ids) do
        local owner=self.runtime.authorities:ownerOf(id)
        if owner~=nil then
            if owner~=commitment.identity then return nil,"FOLLOWER_PASSAGE_PREFLIGHT_AUTHORITY_CONFLICT" end
            local valid=false
            for _,token in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(owner)) do
                if token.assemblyId==id and self.runtime.authorities:validate(token)==true then valid=true break end
            end
            if not valid then return nil,"FOLLOWER_PASSAGE_PREFLIGHT_AUTHORITY_INVALID" end
        end
    end
    local successorObligation=(candidate.obligationsCreated or {})[1]
    if successorObligation==nil or successorObligation.requiredOutcome==nil
        or (successorObligation.requiredOutcome.kind~="COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK" and successorObligation.requiredOutcome.kind~="COOPERATIVE_PASSAGE_LEG_HANDED_BACK") then
        return nil,"FOLLOWER_PASSAGE_PREFLIGHT_SUCCESSOR_OBLIGATION_UNAVAILABLE"
    end
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(self.runtime.obligations:openForOwner(commitment.identity)) do
        local basis,outcome=obligation.basis,obligation.requiredOutcome
        if basis and basis.kind=="FOLLOWER_BOUNDARY_PROTECTION" and basis.pairKey==current.provenance.pairKey
            and outcome and outcome.kind=="FOLLOWER_BOUNDARY_ORDERING_PRESERVED_UNTIL_POSITIVE_RETIREMENT" then
            if type(basis.leaderAssemblyId)~="string" or type(basis.followerAssemblyId)~="string"
                or not participants[basis.leaderAssemblyId] or not participants[basis.followerAssemblyId] then
                return nil,"FOLLOWER_PASSAGE_PREFLIGHT_PARTICIPANTS_MISMATCH"
            end
            return {commitmentId=commitment.identity,pairKey=current.provenance.pairKey,obligationId=obligation.identity},nil
        end
    end
    return nil,"FOLLOWER_PASSAGE_PREFLIGHT_OPEN_PREDECESSOR_OBLIGATION_UNAVAILABLE"
end

function Authority:supersedeFollowerRegulationForCooperativePassage(commitment,evaluated,regulationAuthority,picture)
    local current=self:getCurrentRegulation(commitment and commitment.identity)
    if current==nil or current.provenance.pairKey==nil then return nil,"FOLLOWER_PASSAGE_PREDECESSOR_MISMATCH" end
    local neutralized=regulationAuthority and regulationAuthority:neutralizeFollowerBoundaryPhysical(picture,evaluated,selectedCandidate(evaluated),"COOPERATIVE_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION") or nil
    if neutralized==nil or neutralized.status~="RELEASED" then return nil,"FOLLOWER_PASSAGE_PHYSICAL_CLEANUP_FAILED" end
    local settled,settleReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.settleFollowerBoundaryPurpose(self.runtime,commitment.identity,{
        pairKey=current.provenance.pairKey,reason="COOPERATIVE_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION"
    },{kind="COOPERATIVE_PASSAGE_ROLE_SUCCESSION",pairKey=current.provenance.pairKey,assemblyIds=ownershipAssemblyIds(selectedCandidate(evaluated))})
    return {settled=settled,reason=settleReason,physical=neutralized},nil
end
