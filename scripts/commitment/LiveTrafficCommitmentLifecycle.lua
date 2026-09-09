-- FS25_OuttaMyWay v0.1.10.0 CANONICAL CANDIDATE — D-0184 removes stale D-0143 live provenance; D-0146 lifecycle authority unchanged.
-- Bounded live Commitment lifecycle catch-up for the autonomous initial-head-on
-- test path. It uses the replacement-core Commitment/Obligation/Authority
-- kernel; it does not introduce production Refuge Region or Durable Separation
-- authority.

OuttaMyWay.LiveTrafficCommitmentLifecycle = {}
local Lifecycle = OuttaMyWay.LiveTrafficCommitmentLifecycle

local function logInfo(formatText, ...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][LIVE-COMMITMENT] %s",message)
    else
        print("[FS25_OuttaMyWay][LIVE-COMMITMENT] "..message)
    end
end


local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    if selectedId==nil then return nil end
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

local function appendCopy(values,value)
    local out={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do out[#out+1]=item end
    out[#out+1]=value
    return out
end

local function rebindComposition(candidate,commitmentId)
    local compositionValues=candidate and candidate.evidenceBasis and candidate.evidenceBasis.effectiveActuationComposition or nil
    if type(compositionValues)~="table" then return nil end
    local rebound=OuttaMyWay.ValueRecord.toTable(compositionValues)
    for _,entry in OuttaMyWay.ValueRecord.ipairs(rebound.entries or {}) do
        if entry.commitmentId=="$NEW_COMMITMENT" then entry.commitmentId=commitmentId end
    end
    return OuttaMyWay.EffectiveActuationComposition.create(rebound)
end

local function ownershipCopy(record)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(record.progressActuationOwnership or {}) do
        result[#result+1]={assemblyId=item.assemblyId,authorityTokenId=item.authorityTokenId}
    end
    return result
end

local function compositionForOwnership(runtime,record,ownership,supportAssemblyId)
    local entries,relevant={},{}
    for _,item in OuttaMyWay.ValueRecord.ipairs(ownership or {}) do
        local capability=item.assemblyId==supportAssemblyId and "REGULATE_SPEED" or (record.strategy and record.strategy.capability or "REPOSITION")
        if capability=="CONTINUE_OBSERVATION" or capability=="CONTINUE_UNCHANGED" then capability="REPOSITION" end
        entries[#entries+1]={
            assemblyId=item.assemblyId,commitmentId=record.identity,capability=capability,
            effectClass=capability=="REGULATE_SPEED" and "SPEED_LIMIT" or "MOVE",progressActuation=true
        }
        relevant[#relevant+1]=item.assemblyId
    end
    table.sort(entries,function(a,b) return a.assemblyId<b.assemblyId end)
    table.sort(relevant)
    return OuttaMyWay.EffectiveActuationComposition.create({
        identity=runtime.identities:issue("COMPOSITION"),epoch=runtime.epochs:next(),entries=entries,relevantAssemblyIds=relevant
    })
end

function Lifecycle.acquireSupportingRegulationAuthority(runtime,commitmentId,assemblyId,evidence)
    if runtime==nil or type(commitmentId)~="string" or type(assemblyId)~="string" then return nil,"MISSING_SUPPORTING_AUTHORITY_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or record.state~="ACTIVE" then return nil,"SUPPORTING_AUTHORITY_REQUIRES_ACTIVE_COMMITMENT" end
    local owner=runtime.authorities:ownerOf(assemblyId)
    if owner~=nil and owner~=commitmentId then return nil,"SUPPORTING_ASSEMBLY_OWNED_BY_OTHER_COMMITMENT" end
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitmentId)) do
        if candidateToken.assemblyId==assemblyId then token=candidateToken break end
    end
    local ownership=ownershipCopy(record)
    if token==nil then
        token=runtime.authorities:acquireProgress(assemblyId,commitmentId)
        ownership[#ownership+1]={assemblyId=assemblyId,authorityTokenId=token.identity}
    end
    local composition=compositionForOwnership(runtime,record,ownership,assemblyId)
    record=runtime.commitments:save(OuttaMyWay.CommitmentStateMachine.revise(record,{
        progressActuationOwnership=ownership,effectiveActuationCompositionId=composition.identity,epoch=runtime.epochs:next()
    }))
    logInfo("SUPPORTING_REGULATION_AUTHORITY_ACQUIRED commitment=%s assembly=%s token=%s composition=%s purpose=%s",
        tostring(commitmentId),tostring(assemblyId),tostring(token.identity),tostring(composition.identity),tostring(evidence and evidence.governingPurpose or "UNSPECIFIED"))
    return {commitment=record,authorityToken=token,composition=composition},nil
end

function Lifecycle.releaseSupportingRegulationAuthority(runtime,commitmentId,assemblyId,evidence)
    if runtime==nil or type(commitmentId)~="string" or type(assemblyId)~="string" then return nil,"MISSING_SUPPORTING_AUTHORITY_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"SUPPORTING_AUTHORITY_COMMITMENT_NOT_LIVE" end
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitmentId)) do
        if candidateToken.assemblyId==assemblyId then token=candidateToken break end
    end
    local preserve=evidence and evidence.preserveAuthority==true
    if token~=nil and not preserve then runtime.authorities:release(token) end
    local ownership={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(record.progressActuationOwnership or {}) do
        if preserve or item.assemblyId~=assemblyId then ownership[#ownership+1]={assemblyId=item.assemblyId,authorityTokenId=item.authorityTokenId} end
    end
    local composition=compositionForOwnership(runtime,record,ownership,preserve and assemblyId or nil)
    record=runtime.commitments:save(OuttaMyWay.CommitmentStateMachine.revise(record,{
        progressActuationOwnership=ownership,effectiveActuationCompositionId=composition.identity,epoch=runtime.epochs:next()
    }))
    logInfo("SUPPORTING_REGULATION_AUTHORITY_RELEASED commitment=%s assembly=%s token=%s preservedForOtherPurpose=%s composition=%s reason=%s",
        tostring(commitmentId),tostring(assemblyId),tostring(token and token.identity or "NONE"),tostring(preserve),tostring(composition.identity),tostring(evidence and evidence.reason or "PURPOSE_EXPIRED"))
    return {commitment=record,releasedAuthorityTokenId=(token~=nil and not preserve) and token.identity or nil,preservedAuthorityTokenId=(token~=nil and preserve) and token.identity or nil,composition=composition},nil
end


local function followerBoundaryBridge(candidate)
    local basis=candidate and candidate.evidenceBasis or nil
    local bridge=basis and basis.followerBoundaryBridge or nil
    if type(bridge)=="table" and type(bridge.pairKey)=="string" and type(bridge.followerAssemblyId)=="string" then return bridge end
    return nil
end

local function findFollowerBoundaryObligation(runtime,commitmentId,pairKeyValue)
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        local basis=obligation.basis
        local outcome=obligation.requiredOutcome
        if type(basis)=="table" and basis.kind=="FOLLOWER_BOUNDARY_PROTECTION" and basis.pairKey==pairKeyValue
            and type(outcome)=="table" and outcome.kind=="FOLLOWER_BOUNDARY_ORDERING_PRESERVED_UNTIL_POSITIVE_RETIREMENT" then
            return obligation
        end
    end
    return nil
end

function Lifecycle.ensureFollowerBoundaryObligation(runtime,commitmentId,bridge,evidence)
    if runtime==nil or type(commitmentId)~="string" or type(bridge)~="table" or type(bridge.pairKey)~="string" then return nil,"MISSING_FOLLOWER_OBLIGATION_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or record.state~="ACTIVE" then return nil,"FOLLOWER_OBLIGATION_REQUIRES_ACTIVE_COMMITMENT" end
    local existing=findFollowerBoundaryObligation(runtime,commitmentId,bridge.pairKey)
    if existing~=nil then return {commitment=record,obligation=existing,created=false},nil end
    local obligation=runtime.obligations:create({
        origin={kind="TRAFFIC_INTERVENTION",decision="D-0141",pairKey=bridge.pairKey},
        basis={kind="FOLLOWER_BOUNDARY_PROTECTION",pairKey=bridge.pairKey,
            leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId,
            leaderReferenceKey=bridge.leaderReferenceKey,followerReferenceKey=bridge.followerReferenceKey,
            governingPurpose=bridge.governingPurpose},
        ownerCommitmentId=commitmentId,
        requiredOutcome={kind="FOLLOWER_BOUNDARY_ORDERING_PRESERVED_UNTIL_POSITIVE_RETIREMENT",pairKey=bridge.pairKey},
        requiredAuthority={capabilities={"REGULATE_SPEED"},trafficPoliceman=true},
        evidenceContract={kind="POSITIVE_CURRENT_RELATIONSHIP_INVERSE_OR_PURPOSE_SUCCESSION",absenceDoesNotRetire=true},
        ownershipClass="CONTINUITY",transferPolicy={allowed=false},terminalDependency=true,
        creationEvidence=evidence or {kind="D0141_FOLLOWER_BOUNDARY_PURPOSE_ADMITTED"}
    })
    local ids=appendCopy(record.obligationIds,obligation.identity)
    record=runtime.commitments:save(OuttaMyWay.CommitmentStateMachine.revise(record,{obligationIds=ids,epoch=runtime.epochs:next()}))
    logInfo("FOLLOWER_BOUNDARY_OBLIGATION_CREATED commitment=%s obligation=%s pair=%s",tostring(commitmentId),tostring(obligation.identity),tostring(bridge.pairKey))
    return {commitment=record,obligation=obligation,created=true},nil
end

function Lifecycle.applyFollowerBoundaryDecision(runtime,picture,evaluated)
    if runtime==nil or picture==nil or evaluated==nil or evaluated.decision==nil then return nil,"MISSING_CONTEXT" end
    local candidate=selectedCandidate(evaluated)
    local bridge=followerBoundaryBridge(candidate)
    if bridge==nil then return nil,"SELECTED_FOLLOWER_BOUNDARY_CANDIDATE_UNAVAILABLE" end
    local action=evaluated.decision.commitmentAction
    if action~="CREATE" and action~="MAINTAIN" and action~="REVISE" then return nil,"FOLLOWER_BOUNDARY_DECISION_NOT_APPLICABLE" end

    local application=nil
    local commitment=nil
    if type(bridge.existingCommitmentId)=="string" then
        commitment=runtime.commitments:get(bridge.existingCommitmentId)
    end
    -- A previously admitted follower purpose already owns its Commitment.  An
    -- elastic cap update does not revise that Commitment on every frame.  The
    -- sealed Decision revalidates the purpose; Control magnitude remains below
    -- the purpose lifecycle.
    if commitment==nil or commitment.state~="ACTIVE" then
        application=runtime.decisionCommitmentBoundary:apply(picture,evaluated)
        if application==nil or type(application.commitmentId)~="string" then return nil,"FOLLOWER_BOUNDARY_COMMITMENT_APPLICATION_UNRESOLVED" end
        commitment=runtime.commitments:get(application.commitmentId)
    end
    if commitment==nil or commitment.state~="ACTIVE" then return nil,"FOLLOWER_BOUNDARY_COMMITMENT_NOT_ACTIVE" end

    local obligationResult,obligationReason=Lifecycle.ensureFollowerBoundaryObligation(runtime,commitment.identity,bridge,{kind="D0141_SELECTED_REGULATION",decisionId=evaluated.decision.identity})
    if obligationResult==nil then return nil,obligationReason end
    commitment=obligationResult.commitment
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitment.identity)) do
        if candidateToken.assemblyId==bridge.followerAssemblyId then token=candidateToken break end
    end
    local acquired=false
    if token==nil then
        local result,reason=Lifecycle.acquireSupportingRegulationAuthority(runtime,commitment.identity,bridge.followerAssemblyId,{governingPurpose=bridge.governingPurpose})
        if result==nil then return nil,reason end
        commitment=result.commitment; token=result.authorityToken; acquired=true
    end
    if application~=nil or obligationResult.created or acquired then
        logInfo("FOLLOWER_BOUNDARY_DECISION_APPLIED decision=%s application=%s commitment=%s obligation=%s pair=%s token=%s acquired=%s cap=%.2fkmh",
            tostring(evaluated.decision.identity),tostring(application and application.identity or "REVALIDATED"),tostring(commitment.identity),tostring(obligationResult.obligation.identity),
            tostring(bridge.pairKey),tostring(token and token.identity or "NONE"),tostring(acquired),tonumber(bridge.requestedFollowerCapKmh) or 0)
    end
    return {application=application,commitment=commitment,obligation=obligationResult.obligation,authorityToken=token,authorityAcquired=acquired,bridge=bridge},nil
end

function Lifecycle.applyFollowerBoundaryRetirementDecision(runtime,picture,evaluated)
    if runtime==nil or picture==nil or evaluated==nil or evaluated.decision==nil then return nil,"MISSING_CONTEXT" end
    local candidate=selectedCandidate(evaluated)
    local bridge=followerBoundaryBridge(candidate)
    if bridge==nil or bridge.action~="RETIRE" then return nil,"SELECTED_FOLLOWER_RETIREMENT_UNAVAILABLE" end
    if evaluated.decision.commitmentAction~="MAINTAIN" and evaluated.decision.commitmentAction~="REVISE" then return nil,"FOLLOWER_RETIREMENT_REQUIRES_LIVE_COMMITMENT" end
    local application=runtime.decisionCommitmentBoundary:apply(picture,evaluated)
    if application==nil or type(application.commitmentId)~="string" then return nil,"FOLLOWER_RETIREMENT_COMMITMENT_APPLICATION_UNRESOLVED" end
    local commitment=runtime.commitments:get(application.commitmentId)
    if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then return nil,"FOLLOWER_RETIREMENT_COMMITMENT_NOT_LIVE" end
    return {application=application,commitment=commitment,bridge=bridge},nil
end

function Lifecycle.settleFollowerBoundaryPurpose(runtime,commitmentId,bridge,evidence)
    if runtime==nil or type(commitmentId)~="string" or type(bridge)~="table" then return nil,"MISSING_FOLLOWER_RETIREMENT_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"FOLLOWER_RETIREMENT_COMMITMENT_NOT_LIVE" end
    local obligation=findFollowerBoundaryObligation(runtime,commitmentId,bridge.pairKey)
    local settledId=nil
    if obligation~=nil then
        local mode=bridge.reason=="PROGRESS_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION" and "BASIS_CESSATION" or "SATISFACTION"
        runtime.obligations:settle(obligation.identity,mode,evidence or {kind="D0141_POSITIVE_RETIREMENT",reason=bridge.reason})
        settledId=obligation.identity
    end
    local remaining=runtime.obligations:openForOwner(commitmentId)
    record=runtime.commitments:get(commitmentId)
    local responsibility=record.governingBasis and record.governingBasis.responsibilityKey or ""
    local terminal=nil
    if #remaining==0 and type(responsibility)=="string" and string.sub(responsibility,1,18)=="follower-boundary:" then
        local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind="OBJECTIVE_SATISFIED",evidence=evidence or {kind="D0141_POSITIVE_RETIREMENT"},provenance={source="LiveTrafficCommitmentLifecycle"}})
        local settling=runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
        terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,{kind="FOLLOWER_BOUNDARY_PURPOSE_POSITIVELY_RETIRED",pairKey=bridge.pairKey,reason=bridge.reason})
        record=terminal
    end
    logInfo("FOLLOWER_BOUNDARY_PURPOSE_RETIRED commitment=%s pair=%s obligation=%s remainingObligations=%d terminal=%s reason=%s",
        tostring(commitmentId),tostring(bridge.pairKey),tostring(settledId or "NONE"),#remaining,tostring(terminal and terminal.state or "NO"),tostring(bridge.reason))
    return {commitment=record,settledObligationId=settledId,remainingObligations=remaining,terminal=terminal},nil
end

local function d0146ActionSpaceBridge(candidate)
    local basis=candidate and candidate.evidenceBasis or nil
    local bridge=basis and basis.d0146ActionSpaceRegulationBridge or nil
    if type(bridge)=="table" and type(bridge.conflictIdentity)=="string" and type(bridge.regulatedAssemblyId)=="string" then return bridge end
    return nil
end

local function findD0146ActionSpaceObligation(runtime,commitmentId,conflictIdentity)
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        local basis=obligation.basis
        local outcome=obligation.requiredOutcome
        local supportedBasis=type(basis)=="table" and (basis.kind=="D0146_PASSAGE_ACTION_SPACE_CONSERVATION" or basis.kind=="FORWARD_INTERSECTION_INTENT_REVELATION")
        local supportedOutcome=type(outcome)=="table" and (outcome.kind=="D0146_PASSAGE_ACTION_SPACE_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES" or outcome.kind=="FORWARD_INTERSECTION_DISSOLVED_OR_SUCCEEDED")
        if supportedBasis and basis.conflictIdentity==conflictIdentity and supportedOutcome then
            return obligation
        end
    end
    return nil
end

function Lifecycle.applyD0146ActionSpaceDecision(runtime,picture,evaluated)
    if runtime==nil or picture==nil or evaluated==nil or evaluated.decision==nil then return nil,"MISSING_CONTEXT" end
    local candidate=selectedCandidate(evaluated)
    local bridge=d0146ActionSpaceBridge(candidate)
    if bridge==nil or candidate.capability~="REGULATE_SPEED" then return nil,"SELECTED_D0146_ACTION_SPACE_CANDIDATE_UNAVAILABLE" end
    local action=evaluated.decision.commitmentAction
    local applied=nil
    local record=nil
    if action=="CREATE" then
        local created,reason=Lifecycle.applyInitialDecision(runtime,picture,evaluated)
        if created==nil then return nil,reason end
        applied=created.application; record=created.commitment
    elseif action=="MAINTAIN" or action=="REVISE" then
        applied=runtime.decisionCommitmentBoundary:apply(picture,evaluated)
        if applied==nil or type(applied.commitmentId)~="string" then return nil,"D0146_ACTION_SPACE_COMMITMENT_APPLICATION_UNRESOLVED" end
        record=runtime.commitments:get(applied.commitmentId)
    else
        return nil,"D0146_ACTION_SPACE_DECISION_NOT_CREATE_MAINTAIN_OR_REVISE"
    end
    if record==nil or record.state~="ACTIVE" then return nil,"D0146_ACTION_SPACE_COMMITMENT_NOT_ACTIVE" end
    local responsibility=record.governingBasis and record.governingBasis.responsibilityKey or nil
    if responsibility~=bridge.governingRequirementKey then return nil,"D0146_ACTION_SPACE_GOVERNING_REQUIREMENT_MISMATCH" end

    local obligation=findD0146ActionSpaceObligation(runtime,record.identity,bridge.conflictIdentity)
    if obligation==nil then
        local specification=nil
        for _,item in OuttaMyWay.ValueRecord.ipairs(candidate.obligationsCreated or {}) do
            if type(item.requiredOutcome)=="table" and (item.requiredOutcome.kind=="D0146_PASSAGE_ACTION_SPACE_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES" or item.requiredOutcome.kind=="FORWARD_INTERSECTION_DISSOLVED_OR_SUCCEEDED") then specification=item break end
        end
        if specification==nil then return nil,"D0146_ACTION_SPACE_OBLIGATION_SPECIFICATION_UNAVAILABLE" end
        obligation=runtime.obligations:create({
            origin=specification.origin,basis=specification.basis,ownerCommitmentId=record.identity,
            requiredOutcome=specification.requiredOutcome,requiredAuthority=specification.requiredAuthority or {},
            evidenceContract=specification.evidenceContract,ownershipClass=specification.ownershipClass,
            transferPolicy=specification.transferPolicy or {},terminalDependency=specification.terminalDependency~=false,
            creationEvidence={kind="D0146_ACTION_SPACE_REGULATION_SELECTED",decisionId=evaluated.decision.identity}
        })
        record=runtime.commitments:save(OuttaMyWay.CommitmentStateMachine.revise(record,{obligationIds=appendCopy(record.obligationIds,obligation.identity),epoch=runtime.epochs:next()}))
    end

    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(record.identity)) do
        if candidateToken.assemblyId==bridge.regulatedAssemblyId then token=candidateToken break end
    end
    local acquired=false
    if token==nil then
        local result,reason=Lifecycle.acquireSupportingRegulationAuthority(runtime,record.identity,bridge.regulatedAssemblyId,{governingPurpose=bridge.governingPurpose})
        if result==nil then return nil,reason end
        record=result.commitment; token=result.authorityToken; acquired=true
    end
    if token==nil or runtime.authorities:validate(token)~=true then return nil,"D0146_ACTION_SPACE_VALID_AUTHORITY_TOKEN_UNAVAILABLE" end
    logInfo("D0146_ACTION_SPACE_DECISION_APPLIED decision=%s commitment=%s conflict=%s admission=%s regulated=%s protected=%s obligation=%s token=%s acquired=%s magnitudeAuthority=BOUNDED_AUTHORITY",
        tostring(evaluated.decision.identity),tostring(record.identity),tostring(bridge.conflictIdentity),tostring(bridge.admissionKind or "CURRENT_EXCURSION"),tostring(bridge.regulatedAssemblyId),tostring(bridge.protectedAssemblyId or bridge.excursionAssemblyId),
        tostring(obligation.identity),tostring(token.identity),tostring(acquired))
    return {application=applied,commitment=record,obligation=obligation,authorityToken=token,authorityAcquired=acquired,bridge=bridge},nil
end

function Lifecycle.settleD0146ActionSpacePurpose(runtime,commitmentId,bridge,evidence)
    if runtime==nil or type(commitmentId)~="string" or type(bridge)~="table" or type(bridge.conflictIdentity)~="string" then return nil,"MISSING_D0146_ACTION_SPACE_SETTLEMENT_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"D0146_ACTION_SPACE_COMMITMENT_NOT_LIVE" end
    local responsibility=record.governingBasis and record.governingBasis.responsibilityKey or ""
    local forward=type(responsibility)=="string" and string.sub(responsibility,1,32)=="forward-intersection-regulation:"
    local settlementMode=nil
    if bridge.reason=="COOPERATIVE_PASSAGE_SUPERSEDES_D0146_ACTION_SPACE_REGULATION" then
        settlementMode="BASIS_CESSATION"
    elseif forward then
        local evidenceKind=evidence and evidence.kind or nil
        if evidenceKind=="FORWARD_INTERSECTION_POSITIVE_DISSOLUTION" then
            settlementMode="SATISFACTION"
        elseif evidenceKind=="FORWARD_INTERSECTION_POSITIVE_SUPERSESSION" then
            settlementMode="BASIS_CESSATION"
        else
            return nil,"FORWARD_INTERSECTION_SETTLEMENT_REQUIRES_POSITIVE_DISSOLUTION_OR_SUPERSESSION"
        end
    else
        settlementMode="SATISFACTION"
    end

    local obligation=findD0146ActionSpaceObligation(runtime,commitmentId,bridge.conflictIdentity)
    local settledId=nil
    if obligation~=nil then
        runtime.obligations:settle(obligation.identity,settlementMode,evidence or {kind="D0146_ACTION_SPACE_PURPOSE_EXPIRED",reason=bridge.reason})
        settledId=obligation.identity
    end
    local remaining=runtime.obligations:openForOwner(commitmentId)
    record=runtime.commitments:get(commitmentId)
    local terminal=nil
    local ownedTrafficPurpose=type(responsibility)=="string" and (string.sub(responsibility,1,26)=="d0146-cooperative-passage:" or forward)
    if #remaining==0 and ownedTrafficPurpose then
        local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind="OBJECTIVE_SATISFIED",evidence=evidence or {kind="D0146_ACTION_SPACE_PURPOSE_EXPIRED"},provenance={source="LiveTrafficCommitmentLifecycle.settleD0146ActionSpacePurpose"}})
        runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
        local terminalEvidenceKind="D0146_ACTION_SPACE_RELATIONSHIP_POSITIVELY_DISSOLVED"
        if forward then
            terminalEvidenceKind=(evidence and evidence.kind=="FORWARD_INTERSECTION_POSITIVE_SUPERSESSION")
                and "FORWARD_INTERSECTION_RESPONSIBILITY_POSITIVELY_SUPERSEDED"
                or "FORWARD_INTERSECTION_POSITIVELY_DISSOLVED"
        end
        terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,{kind=terminalEvidenceKind,conflictIdentity=bridge.conflictIdentity,reason=bridge.reason})
        record=terminal
    end
    logInfo("D0146_ACTION_SPACE_PURPOSE_SETTLED commitment=%s conflict=%s obligation=%s remainingObligations=%d terminal=%s reason=%s",
        tostring(commitmentId),tostring(bridge.conflictIdentity),tostring(settledId or "NONE"),#remaining,tostring(terminal and terminal.state or "NO"),tostring(bridge.reason))
    return {commitment=record,settledObligationId=settledId,remainingObligations=remaining,terminal=terminal},nil
end

-- D-0217 Cooperative Passage participant loss is participant-scoped. A sealed
-- observation first establishes the complete set of still-open Passage Legs
-- whose exact original GIANTS Job Episode has authoritatively ended. Why the
-- Job Episode ended is provenance, not a second Passage lifecycle: player entry
-- or control-like evidence while the Job Episode remains active cannot vacate a
-- Passage Leg. All active OMW physical effects for the ended-Episode loss set
-- are neutralised before any corresponding BA/AU release. Survivor authority
-- and choreography are refreshed only after the whole sealed loss set is settled.
local function endedEpisodeSet(episodeResult)
    local result={}
    for _,episodeId in OuttaMyWay.ValueRecord.ipairs(episodeResult and episodeResult.endedEpisodeIds or {}) do result[episodeId]=true end
    return result
end

local function d0146TrafficResponsibility(record)
    local responsibility=record and record.governingBasis and record.governingBasis.responsibilityKey or nil
    return type(responsibility)=="string" and (string.sub(responsibility,1,26)=="d0146-cooperative-passage:" or string.sub(responsibility,1,32)=="forward-intersection-regulation:")
end

local function endedDependency(record,ended)
    local basis=record and record.governingBasis or nil
    for _,episodeId in OuttaMyWay.ValueRecord.ipairs(basis and basis.dependentJobEpisodeIds or {}) do
        if ended[episodeId] then return episodeId end
    end
    return nil
end

local isCooperativePassageLegObligation
local hasCooperativePassageLegObligations
local findCooperativePassageLegObligation

local function passageLossForOpenLeg(runtime,record,obligation,ended,snapshot,episodeResult)
    local basis=obligation and obligation.basis or {}
    local assemblyId=basis.assemblyId
    local jobEpisodeId=basis.jobEpisodeId
    if type(assemblyId)~="string" or type(jobEpisodeId)~="string" then return nil end
    local recordBasis=record.governingBasis or {}
    local observationSnapshotId=snapshot and snapshot.identity or (episodeResult and episodeResult.observationSnapshotId or nil)

    if ended[jobEpisodeId] then
        local episode=runtime.jobEpisodes and runtime.jobEpisodes.get and runtime.jobEpisodes:get(jobEpisodeId) or nil
        local terminalCause=episode and episode.terminalCause or nil
        local kind=terminalCause=="RUNTIME_SUBJECT_REMOVED" and "POSITIVE_VEHICLE_RUNTIME_REMOVAL" or "JOB_EPISODE_DEPENDENCY_CEASED"
        return {
            assemblyId=assemblyId,jobEpisodeId=jobEpisodeId,endedJobEpisodeId=jobEpisodeId,
            evidence={
                kind=kind,commitmentId=record.identity,encounterIdentity=recordBasis.dependentEncounterId,
                endedJobEpisodeId=jobEpisodeId,participantJobEpisodeId=jobEpisodeId,
                jobEpisodeTerminalCause=terminalCause,dependentJobEpisodeIds=recordBasis.dependentJobEpisodeIds,
                observationSnapshotId=observationSnapshotId,basisCessation=true,
                positiveRemoval=terminalCause=="RUNTIME_SUBJECT_REMOVED"
            }
        }
    end

    return nil
end

function Lifecycle.applyCooperativePassageParticipantLosses(runtime,episodeResult,snapshot)
    if runtime==nil or episodeResult==nil then return {} end
    local ended=endedEpisodeSet(episodeResult)
    if next(ended)==nil then return {} end

    local outcomes={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(runtime.commitments:list()) do
        if not OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) and record.state~="SETTLING"
            and hasCooperativePassageLegObligations(runtime,record.identity) then
            local losses={}
            for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(record.identity)) do
                if isCooperativePassageLegObligation~=nil and isCooperativePassageLegObligation(obligation) then
                    local loss=passageLossForOpenLeg(runtime,record,obligation,ended,snapshot,episodeResult)
                    if loss~=nil then losses[#losses+1]=loss end
                end
            end
            table.sort(losses,function(a,b)
                if a.assemblyId~=b.assemblyId then return tostring(a.assemblyId)<tostring(b.assemblyId) end
                return tostring(a.jobEpisodeId)<tostring(b.jobEpisodeId)
            end)

            if #losses>0 then
                local control=runtime.liveControlDispatcher and runtime.liveControlDispatcher.cooperativePassageControl or nil
                local activeControl=control~=nil and control.run~=nil and control.run.commitmentId==record.identity
                logInfo("COOPERATIVE_PASSAGE_PARTICIPANT_LOSS_SET commitment=%s losses=%d activeControl=%s sealedObservation=%s",
                    tostring(record.identity),#losses,tostring(activeControl),tostring(snapshot and snapshot.identity or episodeResult.observationSnapshotId))

                local neutralizationFailure=nil
                if activeControl then
                    for _,loss in OuttaMyWay.ValueRecord.ipairs(losses) do
                        local ok,result,reason=pcall(control.vacateParticipant,control,record.identity,loss.assemblyId,loss.evidence)
                        if not ok then reason=tostring(result); result=nil end
                        if result==nil or (result.disposition~="VACATED" and result.disposition~="ALREADY_TERMINAL") then
                            neutralizationFailure="PASSAGE_PHYSICAL_VACATUR_FAILED:"..tostring(reason or (result and result.disposition) or "UNRESOLVED")
                            if type(control._failHeld)=="function" then control:_failHeld(neutralizationFailure) end
                            break
                        end
                    end
                end

                if neutralizationFailure~=nil then
                    outcomes[#outcomes+1]={
                        commitmentId=record.identity,participantLossCount=#losses,
                        physicalNeutralizationFailed=true,failureReason=neutralizationFailure
                    }
                else
                    local settledLosses={}
                    local lastSettled=nil
                    local settlementFailure=nil
                    for _,loss in OuttaMyWay.ValueRecord.ipairs(losses) do
                        local settled,reason=Lifecycle.settleCooperativePassageLeg(runtime,record.identity,loss.assemblyId,"VACATED",loss.evidence)
                        if settled==nil then
                            settlementFailure="PASSAGE_LEG_SETTLEMENT_FAILED:"..tostring(reason)
                            break
                        end
                        if settled.alreadyTerminal~=true then
                            settledLosses[#settledLosses+1]={loss=loss,settled=settled}
                            lastSettled=settled
                        end
                    end

                    if settlementFailure~=nil then
                        if activeControl and control.run~=nil and control.run.commitmentId==record.identity and type(control._failHeld)=="function" then
                            control:_failHeld(settlementFailure)
                        end
                        outcomes[#outcomes+1]={
                            commitmentId=record.identity,participantLossCount=#losses,
                            settlementFailed=true,failureReason=settlementFailure
                        }
                    else
                        local survivorAuthority=nil
                        local survivorFailure=nil
                        if lastSettled~=nil and lastSettled.terminal==nil then
                            survivorAuthority,survivorFailure=runtime:refreshCooperativePassageSurvivorAuthority(record.identity,lastSettled)
                            if survivorAuthority==nil then
                                runtime:failCooperativePassageSurvivorAuthority(record.identity,survivorFailure)
                            elseif activeControl and type(control.continueAfterParticipantVacatur)=="function" then
                                control:continueAfterParticipantVacatur(record.identity,losses[1].assemblyId)
                            end
                        end

                        for _,item in OuttaMyWay.ValueRecord.ipairs(settledLosses) do
                            local loss=item.loss
                            local settled=item.settled
                            outcomes[#outcomes+1]={
                                commitmentId=record.identity,
                                terminalState=settled.commitment and settled.commitment.state or nil,
                                encounterIdentity=record.governingBasis and record.governingBasis.dependentEncounterId or nil,
                                endedJobEpisodeId=loss.endedJobEpisodeId,participantJobEpisodeId=loss.jobEpisodeId,
                                vacatedAssemblyId=loss.assemblyId,participantLossKind=loss.evidence.kind,
                                settledObligationIds=settled.settledObligationId and {settled.settledObligationId} or {},
                                releasedAuthorityTokenIds=settled.releasedAuthorityTokenIds or {},
                                partialPassageBasisCessation=true,survivorAuthority=survivorAuthority,
                                failureReason=survivorFailure
                            }
                            logInfo("COOPERATIVE_PASSAGE_LEG_VACATED commitment=%s encounter=%s jobEpisode=%s assembly=%s loss=%s terminal=%s survivorAuthority=%s",
                                tostring(record.identity),tostring(record.governingBasis and record.governingBasis.dependentEncounterId or "NONE"),
                                tostring(loss.jobEpisodeId),tostring(loss.assemblyId),tostring(loss.evidence.kind),
                                tostring(settled.terminal and settled.terminal.state or "NO"),tostring(survivorAuthority and survivorAuthority.boundedAuthorityId or "NO"))
                        end
                    end
                end
            end
        end
    end
    return outcomes
end

-- D-0200 Job Episode Dependency Collapse remains the whole-purpose collapse
-- path for non-Passage D-0146 traffic responsibilities. Cooperative Passage
-- participant loss is reconciled above at Passage-Leg scope and must never be
-- promoted back into whole-Commitment basis cessation.
function Lifecycle.collapseEndedJobEpisodeDependencies(runtime,episodeResult,snapshot)
    if runtime==nil or episodeResult==nil then return {} end
    local ended=endedEpisodeSet(episodeResult)
    if next(ended)==nil then return {} end

    local collapsed={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(runtime.commitments:list()) do
        if not OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) and record.state~="SETTLING"
            and d0146TrafficResponsibility(record)
            and not hasCooperativePassageLegObligations(runtime,record.identity) then
            local endedDependentEpisodeId=endedDependency(record,ended)
            if endedDependentEpisodeId~=nil then
                local basis=record.governingBasis or {}
                local settlementEvidence={
                    kind="JOB_EPISODE_DEPENDENCY_CEASED",
                    commitmentId=record.identity,
                    encounterIdentity=basis.dependentEncounterId,
                    endedJobEpisodeId=endedDependentEpisodeId,
                    dependentJobEpisodeIds=basis.dependentJobEpisodeIds,
                    observationSnapshotId=snapshot and snapshot.identity or episodeResult.observationSnapshotId,
                    basisCessation=true
                }
                local settledIds={}
                for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(record.identity)) do
                    runtime.obligations:settle(obligation.identity,"BASIS_CESSATION",settlementEvidence)
                    settledIds[#settledIds+1]=obligation.identity
                end
                local verdict=runtime.governingBasisEvaluator:evaluate(record,{
                    kind="OBJECTIVE_SATISFIED",evidence=settlementEvidence,
                    provenance={source="LiveTrafficCommitmentLifecycle.collapseEndedJobEpisodeDependencies",authority="D0200_JOB_EPISODE_DEPENDENCY_COLLAPSE"}
                })
                if runtime.regulationBoundedAuthority~=nil and type(runtime.regulationBoundedAuthority.retireTrafficLeasesForCommitment)=="function" then
                    runtime.regulationBoundedAuthority:retireTrafficLeasesForCommitment(record.identity,"JOB_EPISODE_DEPENDENCY_CEASED")
                end
                local settling=runtime.terminalSettlementEvaluator:enterSettling(record.identity,verdict)
                local terminal=runtime.terminalSettlementEvaluator:attemptTerminal(record.identity,settlementEvidence)
                collapsed[#collapsed+1]={
                    commitmentId=record.identity,terminalState=terminal.state,encounterIdentity=basis.dependentEncounterId,
                    endedJobEpisodeId=endedDependentEpisodeId,settledObligationIds=settledIds,
                    releasedAuthorityTokenIds=settling.releasedAuthorityTokenIds or {}
                }
                logInfo("JOB_EPISODE_DEPENDENCY_COLLAPSE commitment=%s encounter=%s endedEpisode=%s obligations=%d releasedAuthority=%d terminal=%s",
                    tostring(record.identity),tostring(basis.dependentEncounterId or "NONE"),tostring(endedDependentEpisodeId),
                    #settledIds,#(settling.releasedAuthorityTokenIds or {}),tostring(terminal.state))
            end
        end
    end
    return collapsed
end

function Lifecycle.applyInitialDecision(runtime, picture, evaluated)
    if runtime==nil or picture==nil or evaluated==nil or evaluated.decision==nil then return nil,"MISSING_CONTEXT" end
    if evaluated.decision.commitmentAction~="CREATE" then return nil,"DECISION_NOT_CREATE" end
    local application=runtime.decisionCommitmentBoundary:apply(picture,evaluated)
    if application==nil or application.commitmentId==nil then return nil,"COMMITMENT_APPLICATION_UNRESOLVED" end
    local record=runtime.commitments:get(application.commitmentId)
    if record==nil then return nil,"COMMITMENT_RECORD_UNAVAILABLE" end
    logInfo("CREATE decision=%s application=%s commitment=%s state=%s obligations=%d authorityTokens=%d responsibility=%s productionControlAuthority=false",
        tostring(evaluated.decision.identity),tostring(application.identity),tostring(record.identity),tostring(record.state),
        #(application.createdObligationIds or {}),#(application.authorityTokenIds or {}),tostring(record.governingBasis and record.governingBasis.responsibilityKey or "n/a"))
    return {application=application,commitment=record},nil
end

local function isCooperativePassageObligation(obligation)
    local outcome=obligation and obligation.requiredOutcome or nil
    return type(outcome)=="table" and (outcome.kind=="COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK" or outcome.kind=="COOPERATIVE_PASSAGE_LEG_HANDED_BACK")
end

isCooperativePassageLegObligation=function(obligation)
    local basis=obligation and obligation.basis or nil
    local outcome=obligation and obligation.requiredOutcome or nil
    return type(basis)=="table" and basis.kind=="COOPERATIVE_PASSAGE_LEG"
        and type(basis.assemblyId)=="string"
        and type(outcome)=="table" and outcome.kind=="COOPERATIVE_PASSAGE_LEG_HANDED_BACK"
end

findCooperativePassageLegObligation=function(runtime,commitmentId,assemblyId)
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        if isCooperativePassageLegObligation(obligation) and obligation.basis.assemblyId==assemblyId then return obligation end
    end
    return nil
end

hasCooperativePassageLegObligations=function(runtime,commitmentId)
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        if isCooperativePassageLegObligation(obligation) then return true end
    end
    return false
end

local function assemblyForDependentEpisode(record,endedEpisodeId)
    return nil,nil
end

local function reviseOwnershipAfterParticipantRelease(runtime,record,assemblyId)
    local ownership={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(record.progressActuationOwnership or {}) do
        if item.assemblyId~=assemblyId then ownership[#ownership+1]={assemblyId=item.assemblyId,authorityTokenId=item.authorityTokenId} end
    end
    local composition=compositionForOwnership(runtime,record,ownership,nil)
    return runtime.commitments:save(OuttaMyWay.CommitmentStateMachine.revise(record,{
        progressActuationOwnership=ownership,effectiveActuationCompositionId=composition.identity,epoch=runtime.epochs:next()
    })),composition
end

function Lifecycle.settleCooperativePassageLeg(runtime,commitmentId,assemblyId,disposition,evidence)
    if runtime==nil or type(commitmentId)~="string" or type(assemblyId)~="string" then return nil,"MISSING_COOPERATIVE_PASSAGE_LEG_CONTEXT" end
    if disposition~="HANDED_BACK" and disposition~="VACATED" then return nil,"COOPERATIVE_PASSAGE_LEG_DISPOSITION_UNSUPPORTED" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"COOPERATIVE_PASSAGE_COMMITMENT_NOT_LIVE" end
    local obligation=findCooperativePassageLegObligation(runtime,commitmentId,assemblyId)
    if obligation==nil then return {commitment=record,alreadyTerminal=true,assemblyId=assemblyId,disposition=disposition},nil end

    local settlementEvidence={}
    for key,value in OuttaMyWay.ValueRecord.pairs(evidence or {}) do settlementEvidence[key]=value end
    settlementEvidence.kind=settlementEvidence.kind or "D0146_COOPERATIVE_PASSAGE_LEG_TERMINAL"
    settlementEvidence.commitmentId=commitmentId
    settlementEvidence.assemblyId=assemblyId
    settlementEvidence.passageLegDisposition=disposition
    local mode=disposition=="HANDED_BACK" and "SATISFACTION" or "BASIS_CESSATION"
    runtime.obligations:settle(obligation.identity,mode,settlementEvidence)

    local releasedBounded={}
    if runtime.boundedAuthority~=nil and type(runtime.boundedAuthority.releaseForCommitmentAssembly)=="function" then
        releasedBounded=runtime.boundedAuthority:releaseForCommitmentAssembly(commitmentId,assemblyId,"COOPERATIVE_PASSAGE_LEG_"..disposition)
    end
    local releasedTokens={}
    for _,token in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitmentId)) do
        if token.assemblyId==assemblyId and runtime.authorities:validate(token)==true then
            runtime.authorities:release(token)
            releasedTokens[#releasedTokens+1]=token.identity
        end
    end
    table.sort(releasedTokens)
    record=runtime.commitments:get(commitmentId)
    local composition=nil
    record,composition=reviseOwnershipAfterParticipantRelease(runtime,record,assemblyId)

    local remaining=runtime.obligations:openForOwner(commitmentId)
    local terminal=nil
    if #remaining==0 then
        local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind="OBJECTIVE_SATISFIED",evidence=settlementEvidence,provenance={source="LiveTrafficCommitmentLifecycle.settleCooperativePassageLeg",decision="D-0146"}})
        local settling=runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
        terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,settlementEvidence)
        record=terminal
        for _,id in OuttaMyWay.ValueRecord.ipairs(settling.releasedAuthorityTokenIds or {}) do releasedTokens[#releasedTokens+1]=id end
    end
    logInfo("COOPERATIVE_PASSAGE_LEG_SETTLED commitment=%s assembly=%s disposition=%s obligation=%s mode=%s remainingObligations=%d releasedAuthority=%d releasedBoundedAuthority=%d terminal=%s",
        tostring(commitmentId),tostring(assemblyId),tostring(disposition),tostring(obligation.identity),tostring(mode),#remaining,#releasedTokens,#releasedBounded,tostring(terminal and terminal.state or "NO"))
    return {commitment=record,settledObligationId=obligation.identity,remainingObligations=remaining,releasedAuthorityTokenIds=releasedTokens,releasedBoundedAuthorityGrantIds=releasedBounded,terminal=terminal,composition=composition},nil
end

-- D-0146 joint Cooperative Passage admission/revision. CREATE uses the normal
-- DecisionCommitmentBoundary. REVISE is needed only when an already-live traffic
-- purpose (for example D-0141 follower protection) is succeeded by the joint
-- TS015 Reposition; the fresh restoration/handoff obligation and both progress
-- authority tokens are then attached to that same Commitment.
function Lifecycle.applyCooperativePassageDecision(runtime,picture,evaluated)
    if runtime==nil or picture==nil or evaluated==nil or evaluated.decision==nil then return nil,"MISSING_CONTEXT" end
    local candidate=selectedCandidate(evaluated)
    if candidate==nil or candidate.capability~="REPOSITION" or type(candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge)~="table" then
        return nil,"SELECTED_COOPERATIVE_PASSAGE_UNAVAILABLE"
    end
    local action=evaluated.decision.commitmentAction
    if action=="CREATE" then
        local result,reason=Lifecycle.applyInitialDecision(runtime,picture,evaluated)
        if result~=nil then
            logInfo("COOPERATIVE_PASSAGE_CREATE commitment=%s owners=%d",tostring(result.commitment.identity),OuttaMyWay.ValueRecord.length(candidate.evidenceBasis.progressActuationOwnership and candidate.evidenceBasis.progressActuationOwnership.assemblyIds or {}))
        end
        return result,reason
    end
    if action~="REVISE" then return nil,"COOPERATIVE_PASSAGE_DECISION_NOT_CREATE_OR_REVISE" end

    local application=runtime.decisionCommitmentBoundary:apply(picture,evaluated)
    if application==nil or type(application.commitmentId)~="string" then return nil,"COOPERATIVE_PASSAGE_COMMITMENT_REVISION_UNRESOLVED" end
    local commitmentId=application.commitmentId
    local record=runtime.commitments:get(commitmentId)
    if record==nil or record.state~="ACTIVE" then return nil,"COOPERATIVE_PASSAGE_REVISED_COMMITMENT_NOT_ACTIVE" end

    local obligation=nil
    for _,open in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        if isCooperativePassageObligation(open) then obligation=open break end
    end
    if obligation==nil then
        for _,specification in OuttaMyWay.ValueRecord.ipairs(candidate.obligationsCreated or {}) do
            if type(specification)~="table" or type(specification.requiredOutcome)~="table" or specification.requiredOutcome.kind~="COOPERATIVE_PASSAGE_LEG_HANDED_BACK" then
                return nil,"COOPERATIVE_PASSAGE_OBLIGATION_SPECIFICATION_UNAVAILABLE"
            end
            local created=runtime.obligations:create({
                origin=specification.origin,basis=specification.basis,ownerCommitmentId=commitmentId,
                requiredOutcome=specification.requiredOutcome,requiredAuthority=specification.requiredAuthority or {},
                evidenceContract=specification.evidenceContract,ownershipClass=specification.ownershipClass,
                transferPolicy=specification.transferPolicy or {},terminalDependency=specification.terminalDependency~=false,
                creationEvidence={kind="D0146_COOPERATIVE_PASSAGE_REVISE",decisionId=evaluated.decision.identity}
            })
            obligation=obligation or created
        end
    end

    local ownership={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(candidate.evidenceBasis.progressActuationOwnership and candidate.evidenceBasis.progressActuationOwnership.assemblyIds or {}) do
        local owner=runtime.authorities:ownerOf(assemblyId)
        local token=nil
        if owner~=nil then
            if owner~=commitmentId then return nil,"COOPERATIVE_PASSAGE_ASSEMBLY_OWNED_BY_OTHER_COMMITMENT" end
            for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitmentId)) do
                if candidateToken.assemblyId==assemblyId then token=candidateToken break end
            end
            if token==nil or runtime.authorities:validate(token)~=true then return nil,"COOPERATIVE_PASSAGE_EXISTING_AUTHORITY_TOKEN_UNAVAILABLE" end
        else
            token=runtime.authorities:acquireProgress(assemblyId,commitmentId)
        end
        ownership[#ownership+1]={assemblyId=assemblyId,authorityTokenId=token.identity}
    end
    table.sort(ownership,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)

    local obligationIds={}
    local seen={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(record.obligationIds or {}) do obligationIds[#obligationIds+1]=id; seen[id]=true end
    for _,open in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        if isCooperativePassageObligation(open) and not seen[open.identity] then obligationIds[#obligationIds+1]=open.identity; seen[open.identity]=true end
    end
    local composition=rebindComposition(candidate,commitmentId)
    local changes={obligationIds=obligationIds,progressActuationOwnership=ownership,epoch=runtime.epochs:next()}
    if composition~=nil then changes.effectiveActuationCompositionId=composition.identity end
    record=runtime.commitments:save(OuttaMyWay.CommitmentStateMachine.revise(record,changes))
    logInfo("COOPERATIVE_PASSAGE_REVISE decision=%s commitment=%s obligation=%s owners=%d",tostring(evaluated.decision.identity),tostring(commitmentId),tostring(obligation.identity),#ownership)
    return {application=application,commitment=record,cooperativePassageObligation=obligation},nil
end

-- Positive mechanical completion is also the bounded objective completion for
-- this first TS015 Commitment: both assemblies have been restored with the same
-- Job Episodes and handed back to GIANTS.  No forensic observer owns authority
-- afterwards and there is no cooldown.  A later convergence is a fresh
-- Encounter/Commitment.
function Lifecycle.completeCooperativePassage(runtime,commitmentId,evidence)
    if runtime==nil or type(commitmentId)~="string" then return nil,"MISSING_COOPERATIVE_PASSAGE_COMPLETION_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"COOPERATIVE_PASSAGE_COMMITMENT_NOT_LIVE" end
    local settled={}
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        if isCooperativePassageObligation(obligation) then
            runtime.obligations:settle(obligation.identity,"SATISFACTION",evidence or {kind="D0146_POSITIVE_RESTORATION_AND_HANDOFF"})
            settled[#settled+1]=obligation.identity
        end
    end
    local remaining=runtime.obligations:openForOwner(commitmentId)
    if #remaining>0 then
        return nil,"COOPERATIVE_PASSAGE_COMPLETION_BLOCKED_BY_OTHER_OPEN_OBLIGATIONS"
    end
    local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind="OBJECTIVE_SATISFIED",evidence=evidence or {},provenance={source="LiveTrafficCommitmentLifecycle.completeCooperativePassage",decision="D-0146"}})
    local settling=runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
    local terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,evidence or {kind="D0146_POSITIVE_RESTORATION_AND_HANDOFF"})
    logInfo("COOPERATIVE_PASSAGE_SETTLED commitment=%s terminal=%s settledObligations=%d releasedAuthorityTokens=%d cooldown=false",tostring(commitmentId),tostring(terminal.state),#settled,#(settling.releasedAuthorityTokenIds or {}))
    return {commitment=terminal,settledObligationIds=settled,releasedAuthorityTokenIds=settling.releasedAuthorityTokenIds or {}},nil
end

function Lifecycle.cooperativePassageAssemblyForEndedEpisode(runtime,record,endedEpisodeId)
    if runtime==nil or record==nil or type(endedEpisodeId)~="string" then return nil end
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(record.identity)) do
        if isCooperativePassageLegObligation(obligation) then
            local basis=obligation.basis or {}
            if basis.jobEpisodeId==endedEpisodeId then return basis.assemblyId end
        end
    end
    local episode=runtime.jobEpisodes and runtime.jobEpisodes.get and runtime.jobEpisodes:get(endedEpisodeId) or nil
    if episode~=nil and type(episode.assemblyId)=="string" then return episode.assemblyId end
    local mapped=assemblyForDependentEpisode(record,endedEpisodeId)
    return mapped
end

function Lifecycle.getStatus(runtime, commitmentId)
    if runtime==nil or commitmentId==nil then return nil end
    local record=runtime.commitments:get(commitmentId)
    if record==nil then return nil end
    return {commitment=record,openObligations=runtime.obligations:openForOwner(commitmentId),authorityTokens=runtime.authorities:tokensForCommitment(commitmentId)}
end
