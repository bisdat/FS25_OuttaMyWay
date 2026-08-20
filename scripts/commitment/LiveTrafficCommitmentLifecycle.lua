-- FS25_OuttaMyWay v4.7.106 TEST BUILD — live Commitment lifecycle including D-0146 Potential Action-Space Conservation succession.
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

local function isRecoverySpecification(specification)
    local outcome=specification and specification.requiredOutcome or nil
    return type(outcome)=="table" and outcome.kind=="NATIVE_CONTINUATION_RESTORED_AND_GIANTS_REACQUIRED"
end

local function hasOpenDurableSeparation(runtime,commitmentId)
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        local outcome=obligation.requiredOutcome
        if type(outcome)=="table" and outcome.kind=="DURABLE_SEPARATION_SUPPORTED" then return true end
    end
    return false
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

-- Apply a proven head-on Resolution Strategy through the real Commitment
-- boundary. CREATE is the first stage. REVISE is a later head-on within the same
-- unresolved traffic responsibility; it creates only the fresh displacement
-- recovery obligation and reacquires Yield actuation authority. The continuing
-- Durable Separation obligation is not duplicated.
function Lifecycle.applyHeadOnDecision(runtime,picture,evaluated)
    if runtime==nil or picture==nil or evaluated==nil or evaluated.decision==nil then return nil,"MISSING_CONTEXT" end
    local decision=evaluated.decision
    if decision.commitmentAction=="CREATE" then return Lifecycle.applyInitialDecision(runtime,picture,evaluated) end
    if decision.commitmentAction~="REVISE" then return nil,"DECISION_NOT_CREATE_OR_REVISE" end
    local contexts=picture.commitmentContext or {}
    if OuttaMyWay.ValueRecord.length(contexts)~=1 or type(contexts[1].commitmentId)~="string" then return nil,"UNRESOLVED_COMMITMENT_CONTEXT" end
    local candidate=selectedCandidate(evaluated)
    if candidate==nil or candidate.capability~="REPOSITION" then return nil,"SELECTED_HEAD_ON_REPOSITION_UNAVAILABLE" end

    local application=runtime.decisionCommitmentBoundary:apply(picture,evaluated)
    if application==nil or application.commitmentId~=contexts[1].commitmentId then return nil,"COMMITMENT_REVISION_UNRESOLVED" end
    local commitmentId=application.commitmentId
    local record=runtime.commitments:get(commitmentId)
    if record==nil or record.state~="ACTIVE" then return nil,"REVISED_COMMITMENT_NOT_ACTIVE" end

    local createdObligationIds={}
    for _,specification in OuttaMyWay.ValueRecord.ipairs(candidate.obligationsCreated or {}) do
        local create=isRecoverySpecification(specification)
        local outcome=specification.requiredOutcome
        if type(outcome)=="table" and outcome.kind=="DURABLE_SEPARATION_SUPPORTED" then
            create=not hasOpenDurableSeparation(runtime,commitmentId)
        end
        if create then
            local obligation=runtime.obligations:create({
                origin=specification.origin,basis=specification.basis,ownerCommitmentId=commitmentId,
                requiredOutcome=specification.requiredOutcome,requiredAuthority=specification.requiredAuthority or {},
                evidenceContract=specification.evidenceContract,ownershipClass=specification.ownershipClass,
                transferPolicy=specification.transferPolicy or {},terminalDependency=specification.terminalDependency~=false,
                creationEvidence={kind="RESOLUTION_STRATEGY_STAGE_REVISED",decisionId=decision.identity}
            })
            createdObligationIds[#createdObligationIds+1]=obligation.identity
        end
    end

    local ownership={}
    local authorityTokens={}
    local reusedAuthorityTokens={}
    local requestedOwnership=candidate.evidenceBasis and candidate.evidenceBasis.progressActuationOwnership or nil
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(requestedOwnership and requestedOwnership.assemblyIds or {}) do
        local owner=runtime.authorities:ownerOf(assemblyId)
        local token=nil
        if owner~=nil then
            if owner~=commitmentId then return nil,"YIELD_PROGRESS_AUTHORITY_ALREADY_OWNED_BY_OTHER_COMMITMENT" end
            -- Same-Commitment strategy succession may legitimately change the
            -- capability exercised by an already-owned assembly (for example,
            -- D-0141 supporting Regulation -> head-on Yield/Reposition).  The
            -- AuthorityToken is generic progress-actuation ownership, so reuse
            -- that live token rather than rejecting the REVISE Decision.
            for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitmentId)) do
                if candidateToken.assemblyId==assemblyId then token=candidateToken break end
            end
            if token==nil or runtime.authorities:validate(token)~=true then return nil,"SAME_COMMITMENT_AUTHORITY_TOKEN_UNAVAILABLE" end
            reusedAuthorityTokens[#reusedAuthorityTokens+1]=token
        else
            token=runtime.authorities:acquireProgress(assemblyId,commitmentId)
            authorityTokens[#authorityTokens+1]=token
        end
        ownership[#ownership+1]={assemblyId=assemblyId,authorityTokenId=token.identity}
    end

    local obligationIds={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(record.obligationIds or {}) do obligationIds[#obligationIds+1]=id end
    for _,id in ipairs(createdObligationIds) do obligationIds[#obligationIds+1]=id end
    local composition=rebindComposition(candidate,commitmentId)
    local changes={obligationIds=obligationIds,progressActuationOwnership=ownership,epoch=runtime.epochs:next()}
    if composition~=nil then changes.effectiveActuationCompositionId=composition.identity end
    record=runtime.commitments:save(OuttaMyWay.CommitmentStateMachine.revise(record,changes))
    logInfo("REVISE_HEAD_ON decision=%s application=%s commitment=%s state=%s newRecoveryObligations=%d acquiredAuthorityTokens=%d reusedAuthorityTokens=%d continuingDurableSeparation=%s strategySuccession=true productionControlAuthority=false",
        tostring(decision.identity),tostring(application.identity),tostring(commitmentId),tostring(record.state),#createdObligationIds,#authorityTokens,#reusedAuthorityTokens,tostring(hasOpenDurableSeparation(runtime,commitmentId)))
    return {application=application,commitment=record,createdObligationIds=createdObligationIds,authorityTokens=authorityTokens,reusedAuthorityTokens=reusedAuthorityTokens},nil
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
        if type(basis)=="table" and basis.kind=="D0146_PASSAGE_ACTION_SPACE_CONSERVATION" and basis.conflictIdentity==conflictIdentity
            and type(outcome)=="table" and outcome.kind=="D0146_PASSAGE_ACTION_SPACE_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES" then
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
            if type(item.requiredOutcome)=="table" and item.requiredOutcome.kind=="D0146_PASSAGE_ACTION_SPACE_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES" then specification=item break end
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
    logInfo("D0146_ACTION_SPACE_DECISION_APPLIED decision=%s commitment=%s conflict=%s regulated=%s excursion=%s obligation=%s token=%s acquired=%s cap=%.2fkmh",
        tostring(evaluated.decision.identity),tostring(record.identity),tostring(bridge.conflictIdentity),tostring(bridge.regulatedAssemblyId),tostring(bridge.excursionAssemblyId),
        tostring(obligation.identity),tostring(token.identity),tostring(acquired),tonumber(bridge.requestedCapKmh) or 0)
    return {application=applied,commitment=record,obligation=obligation,authorityToken=token,authorityAcquired=acquired,bridge=bridge},nil
end

function Lifecycle.settleD0146ActionSpacePurpose(runtime,commitmentId,bridge,evidence)
    if runtime==nil or type(commitmentId)~="string" or type(bridge)~="table" or type(bridge.conflictIdentity)~="string" then return nil,"MISSING_D0146_ACTION_SPACE_SETTLEMENT_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"D0146_ACTION_SPACE_COMMITMENT_NOT_LIVE" end
    local obligation=findD0146ActionSpaceObligation(runtime,commitmentId,bridge.conflictIdentity)
    local settledId=nil
    if obligation~=nil then
        local mode=bridge.reason=="COOPERATIVE_PASSAGE_SUPERSEDES_D0146_ACTION_SPACE_REGULATION" and "BASIS_CESSATION" or "SATISFACTION"
        runtime.obligations:settle(obligation.identity,mode,evidence or {kind="D0146_ACTION_SPACE_PURPOSE_EXPIRED",reason=bridge.reason})
        settledId=obligation.identity
    end
    local remaining=runtime.obligations:openForOwner(commitmentId)
    record=runtime.commitments:get(commitmentId)
    local responsibility=record.governingBasis and record.governingBasis.responsibilityKey or ""
    local terminal=nil
    if #remaining==0 and type(responsibility)=="string" and string.sub(responsibility,1,26)=="d0146-cooperative-passage:" then
        local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind="OBJECTIVE_SATISFIED",evidence=evidence or {kind="D0146_ACTION_SPACE_PURPOSE_EXPIRED"},provenance={source="LiveTrafficCommitmentLifecycle.settleD0146ActionSpacePurpose"}})
        runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
        terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,{kind="D0146_ACTION_SPACE_RELATIONSHIP_POSITIVELY_DISSOLVED",conflictIdentity=bridge.conflictIdentity,reason=bridge.reason})
        record=terminal
    end
    logInfo("D0146_ACTION_SPACE_PURPOSE_SETTLED commitment=%s conflict=%s obligation=%s remainingObligations=%d terminal=%s reason=%s",
        tostring(commitmentId),tostring(bridge.conflictIdentity),tostring(settledId or "NONE"),#remaining,tostring(terminal and terminal.state or "NO"),tostring(bridge.reason))
    return {commitment=record,settledObligationId=settledId,remainingObligations=remaining,terminal=terminal},nil
end

local function clearReleasedOwnership(runtime,record)
    local composition=OuttaMyWay.EffectiveActuationComposition.create({identity=runtime.identities:issue("COMPOSITION"),epoch=runtime.epochs:next(),entries={},relevantAssemblyIds={}})
    return runtime.commitments:save(OuttaMyWay.CommitmentStateMachine.revise(record,{
        progressActuationOwnership={},effectiveActuationCompositionId=composition.identity,epoch=runtime.epochs:next()
    }))
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

local function isRecoveryObligation(obligation)
    local outcome=obligation and obligation.requiredOutcome or nil
    return type(outcome)=="table" and outcome.kind=="NATIVE_CONTINUATION_RESTORED_AND_GIANTS_REACQUIRED"
end

function Lifecycle.markActuationStartFailed(runtime, commitmentId, evidence)
    if runtime==nil or commitmentId==nil then return nil,"MISSING_COMMITMENT_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"COMMITMENT_NOT_LIVE" end
    local released=runtime.authorities:releaseForCommitment(commitmentId)
    if record.state=="ACTIVE" then
        record=OuttaMyWay.CommitmentStateMachine.transition(record,"WAITING_FOR_EVIDENCE",{epoch=runtime.epochs:next()},runtime.obligations)
        record=runtime.commitments:save(record)
    end
    record=clearReleasedOwnership(runtime,record)
    local remaining=runtime.obligations:openForOwner(commitmentId)
    logInfo("ACTUATION_START_FAILED commitment=%s state=%s remainingObligations=%d releasedProgressAuthority=%d responsibilityRetained=true evidence=%s",
        tostring(commitmentId),tostring(record.state),#remaining,#released,tostring(evidence and evidence.reason or "UNSPECIFIED"))
    return {commitment=record,remainingObligations=remaining,releasedAuthorityTokenIds=released},nil
end

function Lifecycle.markNativeReacquisition(runtime, commitmentId, evidence)
    if runtime==nil or commitmentId==nil then return nil,"MISSING_COMMITMENT_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"COMMITMENT_NOT_LIVE" end
    local settled={}
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        if isRecoveryObligation(obligation) then
            runtime.obligations:settle(obligation.identity,"SATISFACTION",evidence or {kind="POSITIVE_GIANTS_REACQUISITION"})
            settled[#settled+1]=obligation.identity
        end
    end
    local released=runtime.authorities:releaseForCommitment(commitmentId)
    record=runtime.commitments:get(commitmentId)
    if record.state=="ACTIVE" then
        record=OuttaMyWay.CommitmentStateMachine.transition(record,"WAITING_FOR_EVIDENCE",{epoch=runtime.epochs:next()},runtime.obligations)
        record=runtime.commitments:save(record)
    end
    record=clearReleasedOwnership(runtime,record)
    local remaining=runtime.obligations:openForOwner(commitmentId)
    logInfo("NATIVE_REACQUISITION commitment=%s state=%s settledRecoveryObligations=%d remainingObligations=%d releasedProgressAuthority=%d trafficSettlementComplete=false",
        tostring(commitmentId),tostring(record.state),#settled,#remaining,#released)
    return {commitment=record,settledObligationIds=settled,remainingObligations=remaining,releasedAuthorityTokenIds=released},nil
end


local function isCooperativePassageObligation(obligation)
    local outcome=obligation and obligation.requiredOutcome or nil
    return type(outcome)=="table" and outcome.kind=="COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK"
end

-- D-0143 joint Cooperative Passage admission/revision. CREATE uses the normal
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
        local specification=(candidate.obligationsCreated or {})[1]
        if type(specification)~="table" or type(specification.requiredOutcome)~="table" or specification.requiredOutcome.kind~="COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK" then
            return nil,"COOPERATIVE_PASSAGE_OBLIGATION_SPECIFICATION_UNAVAILABLE"
        end
        obligation=runtime.obligations:create({
            origin=specification.origin,basis=specification.basis,ownerCommitmentId=commitmentId,
            requiredOutcome=specification.requiredOutcome,requiredAuthority=specification.requiredAuthority or {},
            evidenceContract=specification.evidenceContract,ownershipClass=specification.ownershipClass,
            transferPolicy=specification.transferPolicy or {},terminalDependency=specification.terminalDependency~=false,
            creationEvidence={kind="D0143_COOPERATIVE_PASSAGE_REVISE",decisionId=evaluated.decision.identity}
        })
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
    if not seen[obligation.identity] then obligationIds[#obligationIds+1]=obligation.identity end
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
            runtime.obligations:settle(obligation.identity,"SATISFACTION",evidence or {kind="D0143_POSITIVE_RESTORATION_AND_HANDOFF"})
            settled[#settled+1]=obligation.identity
        end
    end
    local remaining=runtime.obligations:openForOwner(commitmentId)
    if #remaining>0 then
        return nil,"COOPERATIVE_PASSAGE_COMPLETION_BLOCKED_BY_OTHER_OPEN_OBLIGATIONS"
    end
    local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind="OBJECTIVE_SATISFIED",evidence=evidence or {},provenance={source="LiveTrafficCommitmentLifecycle.completeCooperativePassage",decision="D-0143"}})
    local settling=runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
    local terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,evidence or {kind="D0143_POSITIVE_RESTORATION_AND_HANDOFF"})
    logInfo("COOPERATIVE_PASSAGE_SETTLED commitment=%s terminal=%s settledObligations=%d releasedAuthorityTokens=%d cooldown=false",tostring(commitmentId),tostring(terminal.state),#settled,#(settling.releasedAuthorityTokenIds or {}))
    return {commitment=terminal,settledObligationIds=settled,releasedAuthorityTokenIds=settling.releasedAuthorityTokenIds or {}},nil
end

function Lifecycle.getStatus(runtime, commitmentId)
    if runtime==nil or commitmentId==nil then return nil end
    local record=runtime.commitments:get(commitmentId)
    if record==nil then return nil end
    return {commitment=record,openObligations=runtime.obligations:openForOwner(commitmentId),authorityTokens=runtime.authorities:tokensForCommitment(commitmentId)}
end
