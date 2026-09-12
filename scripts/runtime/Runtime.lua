OuttaMyWay.Runtime = {}
local Runtime = OuttaMyWay.Runtime
Runtime.__index = Runtime

local function cooperativeLog(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][COOPERATIVE-PRODUCTION] %s",message) else print("[FS25_OuttaMyWay][COOPERATIVE-PRODUCTION] "..message) end
end
local function runtimeLogWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][RUNTIME] %s",message) else print("[FS25_OuttaMyWay][RUNTIME][WARNING] "..message) end
end
local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] %s",message) else print("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] %s",message) else print("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION][WARNING] "..message) end
end
local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    if selectedId==nil then return nil end
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated.candidates or {}) do if candidate.identity==selectedId then return candidate end end
    return nil
end
local function followerBoundaryBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.followerBoundaryBridge or nil
    if type(bridge)=="table" and type(bridge.pairKey)=="string" and type(bridge.followerAssemblyId)=="string" then return bridge end
    return nil
end
local function actionSpaceBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.actionSpaceRegulationBridge or nil
    if type(bridge)=="table" and type(bridge.conflictIdentity)=="string" and type(bridge.regulatedAssemblyId)=="string" then return bridge end
    return nil
end
local function cooperativePassageBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.cooperativePassageBridge or nil
    if type(bridge)~="table" or bridge.architecture~="COOPERATIVE_PASSAGE" then return nil end
    if type(bridge.subjectReferenceKey)=="string" and type(bridge.otherReferenceKey)=="string" and type(bridge.passageGuide)=="table" then return bridge end
    return nil
end
local function ownershipAssemblyIds(candidate)
    local ownership=candidate and candidate.evidenceBasis and candidate.evidenceBasis.progressActuationOwnership or nil
    local ids={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(ownership and ownership.assemblyIds or {}) do ids[#ids+1]=id end
    table.sort(ids)
    return ids
end
local function actionSpaceRelation(picture,current)
    if current==nil then return nil end
    local conflictIdentity=current.provenance and current.provenance.conflictIdentity or nil
    if conflictIdentity==nil then return nil end
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        if relation.identity==conflictIdentity then return relation end
    end
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        for _,relation in OuttaMyWay.ValueRecord.ipairs(knowledge.pairRelationships or {}) do
            if relation.identity==conflictIdentity then return relation end
        end
    end
    return nil
end

local function relocationBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.obstructionRelocationBridge or nil
    if type(bridge)=="table" and bridge.architecture=="CAUSAL_OBSTRUCTION_RELOCATION" and type(bridge.relocationKey)=="string" then return bridge end
    return nil
end

local function selectedGroupBoundary(evaluated)
    local inventory=evaluated and evaluated.candidateInventory or nil
    local boundary=inventory and inventory.supportBoundary or nil
    if type(boundary)~="table" or boundary.mode~="PROSPECTIVE_DECISION_PORTFOLIO" then return boundary end
    local candidate=selectedCandidate(evaluated)
    local group=candidate and candidate.evidenceBasis and candidate.evidenceBasis.candidateSupportGroup or nil
    return type(group)=="table" and group.supportBoundary or nil
end

function Runtime.new()
    local identities=OuttaMyWay.IdentityRegistry.new(); local epochs=OuttaMyWay.EpochSequence.new(0)
    local commitments=OuttaMyWay.CommitmentRegistry.new(identities,epochs)
    local obligations=OuttaMyWay.ObligationLedger.new(identities,epochs,commitments)
    local authorities=OuttaMyWay.AuthorityRegistry.new(identities,epochs,commitments)
    local fieldWorldSnapshots=OuttaMyWay.FieldWorldSnapshotRegistry.new()
    local fieldWorldEquivalenceEvaluator=OuttaMyWay.FieldWorldEquivalenceEvaluator.new()
    local fieldWorldEquivalenceAuthority=OuttaMyWay.FieldWorldEquivalenceAuthority.new(identities,fieldWorldEquivalenceEvaluator)
    local assemblyRepresentationCache=OuttaMyWay.AssemblyRepresentationCache.new()
    local currentPhysicalAssemblySource=OuttaMyWay.CurrentPhysicalAssemblySource.new()
    local currentPhysicalConflictRepresentation=OuttaMyWay.CurrentPhysicalConflictRepresentation.new()
    local jobEpisodes=OuttaMyWay.JobEpisodeAdmission.new(identities,epochs)
    local operations=OuttaMyWay.OperationAdmission.new(identities,epochs,jobEpisodes)
    local admission=OuttaMyWay.CommitmentAdmission.new(identities,epochs,commitments,obligations,authorities)
    local governingBasis=OuttaMyWay.GoverningBasisEvaluator.new(identities,epochs)
    local terminalSettlement=OuttaMyWay.TerminalSettlementEvaluator.new(epochs,commitments,obligations,authorities)
    local causalObstructionAssessment=OuttaMyWay.CausalObstructionAssessment.new(jobEpisodes)
    local runtime=setmetatable({
        identities=identities,epochs=epochs,observationAdapter=OuttaMyWay.RuntimeObservationAdapter.new(identities,epochs),jobEpisodes=jobEpisodes,operations=operations,
        commitments=commitments,obligations=obligations,authorities=authorities,boundedAuthority=nil,commitmentAdmission=admission,governingBasisEvaluator=governingBasis,terminalSettlementEvaluator=terminalSettlement,currentResponsibilityAssessment=OuttaMyWay.CurrentResponsibilityAssessment.new(),
        situationAssessment=OuttaMyWay.SituationAssessment.new(identities,epochs,jobEpisodes,operations,commitments,obligations,causalObstructionAssessment),
        candidateSpace=OuttaMyWay.CandidateSpace.new(identities,epochs),constraintEngine=OuttaMyWay.ConstraintEngine.new(identities,epochs),decisionSelector=OuttaMyWay.DecisionSelector.new(identities,epochs),
        targetedFieldIdentityProbe=OuttaMyWay.TargetedFieldIdentityProbe.new(),fieldWorldSnapshots=fieldWorldSnapshots,fieldWorldEquivalenceEvaluator=fieldWorldEquivalenceEvaluator,fieldWorldEquivalenceAuthority=fieldWorldEquivalenceAuthority,assemblyRepresentationCache=assemblyRepresentationCache,currentPhysicalAssemblySource=currentPhysicalAssemblySource,currentPhysicalConflictRepresentation=currentPhysicalConflictRepresentation,causalObstructionAssessment=causalObstructionAssessment,passiveCandidateSupport=OuttaMyWay.PassiveLiveCandidateSupport.new(identities,epochs),
        trace=OuttaMyWay.ArchitectureTrace.new(),initialized=false,cooperativeVerdictTraceKey=nil
    },Runtime)
    runtime.liveObservationSource=OuttaMyWay.LiveObservationSource.new(runtime.fieldWorldSnapshots,runtime.fieldWorldEquivalenceAuthority,runtime.assemblyRepresentationCache,runtime.currentPhysicalAssemblySource,runtime.currentPhysicalConflictRepresentation)
    runtime.boundedAuthority=OuttaMyWay.BoundedAuthority.new(runtime)
    terminalSettlement.boundedAuthority=runtime.boundedAuthority
    runtime.liveTrafficCandidateSupport=OuttaMyWay.LiveTrafficCandidateSupport.new(identities,epochs,runtime.passiveCandidateSupport)
    runtime.liveControlDispatcher=OuttaMyWay.LiveControlDispatcher.new(runtime)
    runtime.regulationBoundedAuthority=OuttaMyWay.RegulationBoundedAuthority.new(runtime)
    runtime.decisionCommitmentBoundary=OuttaMyWay.DecisionCommitmentBoundary.new(identities,epochs,admission,commitments,obligations,authorities,governingBasis,terminalSettlement)
    runtime.responsibilityTransitionAuthority=OuttaMyWay.ResponsibilityTransitionAuthority.new(runtime)
    terminalSettlement.responsibilityTransitionAuthority=runtime.responsibilityTransitionAuthority
    runtime.followerBoundaryResponsibilityTransition=OuttaMyWay.FollowerBoundaryResponsibilityTransition.new(runtime)
    runtime.actionSpaceRegulationResponsibilityTransition=OuttaMyWay.ActionSpaceRegulationResponsibilityTransition.new(runtime)
    runtime.cooperativePassageResponsibilityTransition=OuttaMyWay.CooperativePassageResponsibilityTransition.new(runtime)
    runtime.replayRunner=OuttaMyWay.ReplayRunner.new(runtime)
    runtime.passiveLiveValidator=OuttaMyWay.PassiveLiveValidator.new(runtime)
    runtime.currentPhysicalPoseSource=OuttaMyWay.CurrentPhysicalPoseSource.new()
    runtime.liveObservationSource.currentPhysicalPoseSource=runtime.currentPhysicalPoseSource
    runtime.obstructionRelocationCandidateSupport=OuttaMyWay.ObstructionRelocationCandidateSupport.new(runtime.identities,runtime.epochs)
    runtime.obstructionRelocationResponsibilityTransition=OuttaMyWay.ObstructionRelocationResponsibilityTransition.new(runtime)
    runtime.prospectiveDecisionPortfolioSupport=OuttaMyWay.ProspectiveDecisionPortfolioSupport.new(
        runtime.identities,runtime.epochs,
        runtime.obstructionRelocationCandidateSupport,
        runtime.liveTrafficCandidateSupport,
        runtime.passiveCandidateSupport)
    return runtime
end
function Runtime:initialize()
    if self.initialized then return end; self.initialized=true
    -- Physical Control remains typed, responsibility-bound and Bounded-Authority-gated; no generic Control path exists.
    -- Trajectory Situation Knowledge and Established Opposed Conflict feed Candidate-owned Local Passage Search, Passage Guide, Commitment and Control.
    self.trace:append("PROGRESSIVE_SITUATIONAL_SUFFICIENCY_INITIALIZED",self.epochs:next(),"obstructionRelocationResponsibilityConsolidated=true;geometryBoundedRelocation=true;obstructionRelocationCoreCapability=true;trajectorySituationKnowledge=true;trajectoryPersistence=true;opposedCorridorClassification=true;cooperativePassageOperationAware=true;retiredPrototypePassageSourced=false;followerBoundaryRegulation=true;turningRankAwarenessRetained=true;successorRookRetired=true;continuousProductiveHistoryRetired=true;kingRetired=true;continuousRefugeRetired=true;runtimeOwnedCycle=true;situationOwnsCurrentKnowledge=true;diagnosticsAuthority=false;typedBoundedControl=true")
    print(string.format("FS25_OuttaMyWay %s loaded; Obstruction Relocation core capability: non-active unclaimed blockers relocate <=60 m toward Field World centroid per actuation while fresh positive Causal Obstruction persists; no move-count courtesy budget",tostring(OuttaMyWay.VERSION)))
end

function Runtime:setRegulationControl(control)
    self.liveControlDispatcher:setRegulationControl(control)
    if self.regulationBoundedAuthority~=nil then self.regulationBoundedAuthority:setRegulationControl(control) end
end
function Runtime:markAutonomousHeadOnDispatched(governingRequirementKey)
    self.liveTrafficCandidateSupport:markAutonomousHeadOnDispatched(governingRequirementKey)
end
function Runtime:resetAutonomousHeadOnState()
    self.liveTrafficCandidateSupport:resetAutonomousState()
end
function Runtime:resetSituationKnowledge()
    if self.situationAssessment and type(self.situationAssessment.resetSituationKnowledge)=="function" then self.situationAssessment:resetSituationKnowledge() end
end
function Runtime:publishObservation(raw) return self.observationAdapter:publish(raw) end
function Runtime:admitJobEpisodes(snapshot) return self.jobEpisodes:observe(snapshot) end
function Runtime:admitOperation(snapshot,episodeResult) return self.operations:observe(snapshot,episodeResult) end
function Runtime:assessOperationalPicture(snapshot,episodeResult,operationResult) return self.situationAssessment:assess(snapshot,episodeResult,operationResult) end
function Runtime:processSealedObservation(raw)
    local snapshot=self:publishObservation(raw)
    local episodes=self:admitJobEpisodes(snapshot)
    local operation=self:admitOperation(snapshot,episodes)
    -- Reconcile the complete sealed Cooperative Passage participant-loss set at
    -- Passage-Leg scope before whole-purpose Job Episode dependency collapse handles
    -- non-Passage traffic responsibilities. This prevents one lost participant from
    -- collapsing the survivor and prevents same-observation dual loss from transiently
    -- restarting a doomed survivor.
    local passageParticipantVacatur=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyCooperativePassageParticipantLosses(self,episodes,snapshot)
    -- Whole-purpose Job Episode dependency collapse applies only to non-Passage traffic responsibilities.
    local trafficCommitmentCollapse=OuttaMyWay.LiveTrafficCommitmentLifecycle.collapseEndedJobEpisodeDependencies(self,episodes,snapshot)
    local picture=self:assessOperationalPicture(snapshot,episodes,operation)
    return {snapshot=snapshot,jobEpisodes=episodes,operation=operation,picture=picture,passageParticipantVacatur=passageParticipantVacatur,trafficCommitmentCollapse=trafficCommitmentCollapse}
end
function Runtime:evaluateSealedOperationalPicture(picture)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    local candidates=self.candidateSpace:generate(picture)
    local verdicts=self.constraintEngine:evaluate(picture,candidates)
    local decision=self.decisionSelector:select(picture,candidates,verdicts)
    return {picture=picture,candidateInventory=candidates.inventory,candidates=candidates.candidates,verdictSet=verdicts.set,verdicts=verdicts.verdicts,decision=decision}
end

function Runtime:setCooperativePassageControl(control)
    self.liveControlDispatcher:setCooperativePassageControl(control)
    if control~=nil and type(control.setCompletionHandler)=="function" then
        control:setCompletionHandler(function(result) self:onCooperativePassageCompletion(result) end)
    end
end

function Runtime:setObstructionRelocationControl(control)
    self.liveControlDispatcher:setObstructionRelocationControl(control)
    if control~=nil and type(control.setCompletionHandler)=="function" then
        control:setCompletionHandler(function(result) self:onObstructionRelocationControlCompletion(result) end)
    end
end

function Runtime:_authorizeBoundedAuthority(currentResponsibility,commitment,token,values)
    if currentResponsibility==nil then return nil,"CURRENT_RESPONSIBILITY_REQUIRED_FOR_BOUNDED_AUTHORITY" end
    if self.boundedAuthority==nil then return nil,"BOUNDED_AUTHORITY_UNAVAILABLE" end
    return self.boundedAuthority:authorize({
        responsibilityId=currentResponsibility.identity,commitmentId=commitment.identity,assemblyId=values.assemblyId,capability=values.capability,
        target=values.target,authorityToken=token.identity,operationalPictureEpoch=values.operationalPictureEpoch,evidenceEpoch=values.evidenceEpoch,
        effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,preconditions=values.preconditions or {},invalidationConditions=values.invalidationConditions or {},
        provenance=values.provenance or {}
    })
end

function Runtime:_materializeBoundedAuthorityRequest(picture,evaluated,candidate,grant,target)
    return self.boundedAuthority:materializeRequest({
        boundedAuthorityId=grant.identity,target=target,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
        preconditions=candidate and candidate.preconditions or grant.preconditions or {},
        invalidationConditions=candidate and candidate.invalidationConditions or grant.invalidationConditions or {}
    })
end

function Runtime:_jointCooperativePassageRequests(picture,evaluated,candidate,commitment,currentResponsibility,bridge)
    local ids=ownershipAssemblyIds(candidate)
    if #ids~=2 then return nil,"COOPERATIVE_PASSAGE_REQUIRES_EXACTLY_TWO_PROGRESS_ACTUATION_ASSEMBLIES" end
    local requests={}
    local function releaseCreated(reason)
        for _,request in ipairs(requests) do self.boundedAuthority:release(request.boundedAuthorityId,reason) end
    end
    for _,assemblyId in ipairs(ids) do
        local token=nil
        for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.authorities:tokensForCommitment(commitment.identity)) do
            if candidateToken.assemblyId==assemblyId then token=candidateToken break end
        end
        if token==nil or self.authorities:validate(token)~=true then releaseCreated("COOPERATIVE_PASSAGE_REQUEST_CREATION_FAILED"); return nil,"VALID_JOINT_COMMITMENT_AUTHORITY_TOKEN_UNAVAILABLE" end
        local target={kind="COOPERATIVE_PASSAGE",conflictIdentity=bridge.conflictIdentity,governingRequirementKey=bridge.governingRequirementKey,
            subjectReferenceKey=bridge.subjectReferenceKey,otherReferenceKey=bridge.otherReferenceKey,passageGuideId=bridge.passageGuide and bridge.passageGuide.identity,controlProfile=bridge.controlProfile}
        local grant,grantReason=self:_authorizeBoundedAuthority(currentResponsibility,commitment,token,{
            assemblyId=assemblyId,capability="REPOSITION",target=target,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
            preconditions=candidate.preconditions or {},invalidationConditions=candidate.invalidationConditions or {},
            provenance={source="Runtime",exemplar="COOPERATIVE_PASSAGE",candidateId=candidate.identity}
        })
        if grant==nil then releaseCreated("COOPERATIVE_PASSAGE_REQUEST_CREATION_FAILED"); return nil,grantReason end
        local request,requestReason=self:_materializeBoundedAuthorityRequest(picture,evaluated,candidate,grant,target)
        if request==nil then releaseCreated("COOPERATIVE_PASSAGE_REQUEST_CREATION_FAILED"); return nil,requestReason end
        requests[#requests+1]=request
    end
    return requests,nil
end

function Runtime:failCooperativePassageSurvivorAuthority(commitmentId,reason)
    local failure="SURVIVOR_AUTHORITY_REBIND_FAILED:"..tostring(reason)
    local control=self.liveControlDispatcher and self.liveControlDispatcher.cooperativePassageControl
    if control~=nil and control.run~=nil and control.run.commitmentId==commitmentId then
        control:_failHeld(failure)
    end
    -- Emergency narrowing ends ordinary survivor execution. Retire only BA
    -- grants belonging to still-open survivor Passage Legs; the same RS/CM and
    -- surviving AU may remain as semantic/mechanical substrate while fail-closed.
    local released={}
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(self.obligations:openForOwner(commitmentId)) do
        local basis=obligation.basis or {}
        if basis.kind=="COOPERATIVE_PASSAGE_LEG" and type(basis.assemblyId)=="string" then
            for _,grantId in OuttaMyWay.ValueRecord.ipairs(self.boundedAuthority:releaseForCommitmentAssembly(commitmentId,basis.assemblyId,failure)) do
                released[#released+1]=grantId
            end
        end
    end
    table.sort(released)
    runtimeLogWarning("COOPERATIVE_PASSAGE_SURVIVOR_AUTHORITY_FAILED commitment=%s reason=%s releasedSurvivorBA=%d",tostring(commitmentId),failure,#released)
    return {failureReason=failure,releasedBoundedAuthorityGrantIds=released}
end

function Runtime:refreshCooperativePassageSurvivorAuthority(commitmentId,settled)
    local current=self.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId)
    local commitment=self.commitments:get(commitmentId)
    if current==nil or commitment==nil or commitment.state~="ACTIVE" then return nil,"SURVIVOR_RESPONSIBILITY_NOT_CURRENT" end
    local survivorAssemblyId=nil
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(settled and settled.remainingObligations or self.obligations:openForOwner(commitmentId)) do
        local basis=obligation.basis or {}
        if basis.kind=="COOPERATIVE_PASSAGE_LEG" and type(basis.assemblyId)=="string" then
            if survivorAssemblyId~=nil then return nil,"MULTIPLE_SURVIVOR_PASSAGE_LEGS_UNSUPPORTED" end
            survivorAssemblyId=basis.assemblyId
        end
    end
    if survivorAssemblyId==nil then return nil,"SURVIVOR_PASSAGE_LEG_UNAVAILABLE" end
    local refreshedResolution,refreshResolutionReason=self.responsibilityTransitionAuthority:refreshCooperativePassageResolutionCommitment(commitmentId)
    if refreshedResolution==nil then return nil,refreshResolutionReason end
    current=refreshedResolution
    local control=self.liveControlDispatcher and self.liveControlDispatcher.cooperativePassageControl or nil
    if control==nil or type(control.currentParticipantRequest)~="function" or type(control.acceptSurvivorPermission)~="function" then
        return nil,"SURVIVOR_CONTROL_REBIND_UNAVAILABLE"
    end
    local predecessorRequest=control:currentParticipantRequest(commitmentId,survivorAssemblyId)
    if predecessorRequest==nil then return nil,"SURVIVOR_CONTROL_REQUEST_UNAVAILABLE" end
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.authorities:tokensForCommitment(commitmentId)) do
        if candidateToken.assemblyId==survivorAssemblyId then token=candidateToken break end
    end
    if token==nil or self.authorities:validate(token)~=true then return nil,"SURVIVOR_AUTHORITY_TOKEN_UNAVAILABLE" end
    local grant,grantReason=self:_authorizeBoundedAuthority(current,commitment,token,{
        assemblyId=survivorAssemblyId,capability=predecessorRequest.capability,target=predecessorRequest.target,
        operationalPictureEpoch=predecessorRequest.operationalPictureEpoch,evidenceEpoch=predecessorRequest.evidenceEpoch,
        preconditions=predecessorRequest.preconditions or {},invalidationConditions=predecessorRequest.invalidationConditions or {},
        provenance={source="Runtime.refreshCooperativePassageSurvivorAuthority",predecessorBoundedAuthorityId=predecessorRequest.boundedAuthorityId}
    })
    if grant==nil then return nil,grantReason end
    local request,requestReason=self.boundedAuthority:materializeRequest({
        boundedAuthorityId=grant.identity,target=predecessorRequest.target,
        operationalPictureEpoch=predecessorRequest.operationalPictureEpoch,evidenceEpoch=predecessorRequest.evidenceEpoch,
        preconditions=predecessorRequest.preconditions or {},invalidationConditions=predecessorRequest.invalidationConditions or {}
    })
    if request==nil then self.boundedAuthority:release(grant.identity,"SURVIVOR_REQUEST_MATERIALIZATION_FAILED"); return nil,requestReason end
    local accepted,acceptReason=control:acceptSurvivorPermission(commitmentId,survivorAssemblyId,request)
    if accepted~=true then self.boundedAuthority:release(grant.identity,"SURVIVOR_CONTROL_REBIND_REJECTED"); return nil,acceptReason end
    if predecessorRequest.boundedAuthorityId~=nil then self.boundedAuthority:release(predecessorRequest.boundedAuthorityId,"COOPERATIVE_PASSAGE_SURVIVOR_AUTHORITY_REPLACED") end
    return {assemblyId=survivorAssemblyId,boundedAuthorityId=grant.identity,controlRequestId=request.identity,effectiveActuationCompositionId=request.effectiveActuationCompositionId,responsibilityId=current.identity},nil
end

function Runtime:_continueCooperativePassage(picture,evaluated,applied)
    local candidate=selectedCandidate(evaluated)
    local bridge=cooperativePassageBridge(candidate)
    if candidate==nil or candidate.capability~="REPOSITION" or bridge==nil or type(applied)~="table" or applied.commitment==nil then
        return {status="NO_DISPATCH",reason="COOPERATIVE_PASSAGE_ESTABLISHED_RESPONSIBILITY_MISMATCH"}
    end
    local requests,requestReason=self:_jointCooperativePassageRequests(picture,evaluated,candidate,applied.commitment,applied.currentResponsibility,bridge)
    if requests==nil then
        self:onCooperativePassageCompletion({status="FAILED",commitmentId=applied.commitment.identity,evidence={kind="COOPERATIVE_PASSAGE_JOINT_CONTROL_REQUEST_CREATION_FAILED",reason=requestReason}})
        return {status="NO_DISPATCH",reason=requestReason,candidateId=candidate.identity,commitmentId=applied.commitment.identity}
    end
    local started,result=self.liveControlDispatcher:dispatchJoint(requests[1],requests[2],candidate)
    if started~=true then
        self.boundedAuthority:release(requests[1].boundedAuthorityId,"COOPERATIVE_PASSAGE_START_REJECTED")
        self.boundedAuthority:release(requests[2].boundedAuthorityId,"COOPERATIVE_PASSAGE_START_REJECTED")
        self:onCooperativePassageCompletion({status="FAILED",commitmentId=applied.commitment.identity,evidence={kind="COOPERATIVE_PASSAGE_CONTROL_START_REJECTED",reason=tostring(result)}})
        local outcomes={
            self.liveControlDispatcher:notifyRejected(requests[1],result,{kind="NO_PHYSICAL_EFFECT_OBSERVED"}),
            self.liveControlDispatcher:notifyRejected(requests[2],result,{kind="NO_PHYSICAL_EFFECT_OBSERVED"})
        }
        runtimeLogWarning("COOPERATIVE_REJECTED commitment=%s candidate=%s detail=%s",tostring(applied.commitment.identity),tostring(candidate.identity),tostring(result))
        return {status="REJECTED",reason=tostring(result),requests=requests,outcomes=outcomes,commitment=applied.commitment,candidate=candidate}
    end
    local outcomes={
        self.liveControlDispatcher:notifyAccepted(requests[1],{kind="COOPERATIVE_PASSAGE_JOINT_REPOSITION_DISPATCH_ACCEPTED",capability="REPOSITION"}),
        self.liveControlDispatcher:notifyAccepted(requests[2],{kind="COOPERATIVE_PASSAGE_JOINT_REPOSITION_DISPATCH_ACCEPTED",capability="REPOSITION"})
    }
    cooperativeLog("COOPERATIVE_ACCEPTED architecture=%s decision=%s candidate=%s commitment=%s requestA=%s requestB=%s subject=%s other=%s result=%s",
        tostring(bridge.architecture),tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(applied.commitment.identity),tostring(requests[1].identity),tostring(requests[2].identity),
        tostring(bridge.subjectReferenceKey),tostring(bridge.otherReferenceKey),tostring(result))
    return {status="ACCEPTED",requests=requests,outcomes=outcomes,commitment=applied.commitment,candidate=candidate,result=result}
end

function Runtime:_assessCurrentActionSpaceRegulation(picture,current)
    if current==nil then return nil,nil end
    return self.currentResponsibilityAssessment:assessActionSpaceRegulation(current,actionSpaceRelation(picture,current)),actionSpaceRelation(picture,current)
end

function Runtime:_terminateActionSpaceRegulation(picture,evaluated,current,assessment)
    local commitmentId=current and current.provenance and current.provenance.retainedCommitmentId or nil
    local conflictIdentity=current and current.provenance and current.provenance.conflictIdentity or nil
    if type(commitmentId)~="string" or type(conflictIdentity)~="string" then return {status="NO_DISPATCH",reason="ACTION_SPACE_REGULATION_CURRENT_RESPONSIBILITY_INCOMPLETE",actionSpaceRegulation=true} end
    local forward=current.provenance and current.provenance.admissionKind=="FORWARD_INTERSECTION"
    if forward
        and assessment.terminationEvidenceKind~="FORWARD_INTERSECTION_POSITIVE_DISSOLUTION"
        and assessment.terminationEvidenceKind~="FORWARD_INTERSECTION_POSITIVE_SUPERSESSION" then
        return {
            status="NO_DISPATCH",
            reason="FORWARD_INTERSECTION_TERMINATION_EVIDENCE_REQUIRED",
            detail=assessment.reason,
            actionSpaceRegulation=true,
            forwardIntersection=true,
            commitmentId=commitmentId
        }
    end
    local status=self.regulationBoundedAuthority:getActionSpaceRegulationStatus()
    local physical=self.regulationBoundedAuthority:neutralizeActionSpaceRegulationPhysical(picture,evaluated,assessment.reason)
    local commitment=self.commitments:get(commitmentId)
    if commitment~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self,commitmentId,status and status.regulatedAssemblyId,{reason=assessment.reason,preserveAuthority=false})
        local settlementKind=forward and assessment.terminationEvidenceKind or "ACTION_SPACE_REGULATION_POSITIVE_PURPOSE_EXPIRY"
        OuttaMyWay.LiveTrafficCommitmentLifecycle.settleActionSpaceRegulationPurpose(self,commitmentId,{conflictIdentity=conflictIdentity,reason=assessment.reason},{
            kind=settlementKind,
            reason=assessment.reason,
            conflictIdentity=conflictIdentity,
            positiveDissolution=settlementKind=="FORWARD_INTERSECTION_POSITIVE_DISSOLUTION",
            positiveSupersession=settlementKind=="FORWARD_INTERSECTION_POSITIVE_SUPERSESSION"
        })
    end
    self.responsibilityTransitionAuthority:terminateActionSpaceRegulation(commitmentId,conflictIdentity)
    return physical
end

function Runtime:_terminateFollowerBoundaryRegulation(picture,evaluated,current,record,assessment)
    local commitmentId=current and current.provenance and current.provenance.retainedCommitmentId or nil
    local pairKey=current and current.provenance and current.provenance.pairKey or nil
    if type(commitmentId)~="string" or type(pairKey)~="string" then return {status="NO_DISPATCH",reason="FOLLOWER_REGULATION_CURRENT_RESPONSIBILITY_INCOMPLETE",followerBoundary=true} end
    local applied,applyReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyFollowerBoundaryRetirementDecision(self,picture,evaluated)
    if applied==nil then return {status="NO_DISPATCH",reason=applyReason,followerBoundary=true} end
    local physical=self.regulationBoundedAuthority:neutralizeFollowerBoundaryPhysical(picture,evaluated,selectedCandidate(evaluated),assessment.reason)
    local commitment=applied.commitment
    if commitment~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self,commitment.identity,record and record.followerAssemblyId,{reason=assessment.reason,preserveAuthority=false})
        OuttaMyWay.LiveTrafficCommitmentLifecycle.settleFollowerBoundaryPurpose(self,commitment.identity,record or {pairKey=pairKey},{kind="FOLLOWER_BOUNDARY_POSITIVE_RETIREMENT",reason=assessment.reason,pairKey=pairKey})
    end
    self.responsibilityTransitionAuthority:terminateRegulation(commitmentId)
    return physical
end

function Runtime:onCooperativePassageCompletion(result)
    if type(result)~="table" or type(result.commitmentId)~="string" then return end
    if result.status=="PARTICIPANT_HANDED_BACK" or result.status=="PARTICIPANT_VACATED" then
        local disposition=result.status=="PARTICIPANT_HANDED_BACK" and "HANDED_BACK" or "VACATED"
        local assemblyId=result.assemblyId or (result.assemblyIds and result.assemblyIds[1])
        local settled,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.settleCooperativePassageLeg(self,result.commitmentId,assemblyId,disposition,result.evidence)
        if settled==nil then
            runtimeLogWarning("COOPERATIVE_PASSAGE_LEG_SETTLEMENT_UNRESOLVED commitment=%s assembly=%s disposition=%s reason=%s",tostring(result.commitmentId),tostring(assemblyId),tostring(disposition),tostring(reason))
        else
            if settled.terminal==nil and settled.alreadyTerminal~=true then
                local refreshed,refreshReason=self:refreshCooperativePassageSurvivorAuthority(result.commitmentId,settled)
                if refreshed==nil then self:failCooperativePassageSurvivorAuthority(result.commitmentId,refreshReason) end
            end
            cooperativeLog("COOPERATIVE_PASSAGE_LEG_TERMINAL commitment=%s assembly=%s disposition=%s terminal=%s survivorAuthorityPreserved=%s",
                tostring(result.commitmentId),tostring(assemblyId),tostring(disposition),tostring(settled.terminal and settled.terminal.state or "NO"),tostring((settled.remainingObligations and #settled.remainingObligations>0) or false))
        end
        return
    end
    for _,grantId in OuttaMyWay.ValueRecord.ipairs(result.boundedAuthorityIds or {}) do self.boundedAuthority:release(grantId,"COOPERATIVE_PASSAGE_"..tostring(result.status)) end
    if result.status=="SUCCEEDED" then
        if not self.obligations:hasOpenObligations(result.commitmentId) then
            cooperativeLog("COOPERATIVE_COMPLETION commitment=%s terminalAlreadySettledByPassageLegs=true cooldown=false",tostring(result.commitmentId))
            return
        end
        local settled,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.completeCooperativePassage(self,result.commitmentId,result.evidence)
        if settled==nil then
            runtimeLogWarning("COOPERATIVE_COMPLETION_UNRESOLVED commitment=%s reason=%s",tostring(result.commitmentId),tostring(reason))
        else
            cooperativeLog("COOPERATIVE_COMPLETION commitment=%s terminal=%s authorityReleased=true cooldown=false",tostring(result.commitmentId),tostring(settled.commitment and settled.commitment.state or "n/a"))
        end
    elseif result.status=="FAILED" then
        local record=self.commitments:get(result.commitmentId)
        if record~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then
            for _,obligation in OuttaMyWay.ValueRecord.ipairs(self.obligations:openForOwner(result.commitmentId)) do
                local outcome=obligation.requiredOutcome
                if type(outcome)=="table" and (outcome.kind=="COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK" or outcome.kind=="COOPERATIVE_PASSAGE_LEG_HANDED_BACK") then
                    self.obligations:settle(obligation.identity,"BASIS_CESSATION",result.evidence or {kind="COOPERATIVE_PASSAGE_FAILED"})
                end
            end
            local verdict=self.governingBasisEvaluator:evaluate(record,{kind="OBJECTIVE_FAILED",evidence=result.evidence or {},provenance={source="Runtime"}})
            local settling=self.terminalSettlementEvaluator:enterSettling(result.commitmentId,verdict)
            if not self.obligations:hasOpenObligations(result.commitmentId) then
                self.terminalSettlementEvaluator:attemptTerminal(result.commitmentId,result.evidence or {kind="COOPERATIVE_PASSAGE_FAILED"})
            end
            runtimeLogWarning("COOPERATIVE_ABORT_SETTLEMENT commitment=%s releasedAuthority=%d",tostring(result.commitmentId),#(settling.releasedAuthorityTokenIds or {}))
        end
    end
end

function Runtime:onObstructionRelocationControlCompletion(result)
    if type(result)~="table" then return end
    local context=result.completionContext or {}
    if context.triggerKind~="CURRENT_CAUSAL_OBSTRUCTION" then
        runtimeLogWarning("OBSTRUCTION_RELOCATION_COMPLETION_CONTEXT_UNRESOLVED commitment=%s trigger=%s",tostring(result.commitmentId),tostring(context.triggerKind))
        return
    end
    self:onObstructionRelocationCompletion(result)
end

function Runtime:_obstructionRelocationRequest(picture,evaluated,candidate,applied,bridge)
    local target={
        kind="OBSTRUCTION_RELOCATION",phase=bridge.phase,assemblyReferenceKey=bridge.blockerAssemblyReferenceKey,objective=bridge.objective,
        configurationPolicy="OPPORTUNISTIC_NO_SETTLEMENT_GATE",cleanupFailurePolicy="FAIL_COMPLETION",
        completionContext={triggerKind="CURRENT_CAUSAL_OBSTRUCTION",relocationKey=bridge.relocationKey,historicalJobProvenanceRequired=false}
    }
    local grant,grantReason=self:_authorizeBoundedAuthority(applied.currentResponsibility,applied.commitment,applied.authorityToken,{
        assemblyId=bridge.blockerAssemblyId,capability="REPOSITION",target=target,
        operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
        preconditions=candidate.preconditions or {},invalidationConditions=candidate.invalidationConditions or {},
        provenance={source="ObstructionRelocationRuntimeIntegration",candidateId=candidate.identity,relocationKey=bridge.relocationKey,authorityClass="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false}
    })
    if grant==nil then return nil,grantReason end
    return self:_materializeBoundedAuthorityRequest(picture,evaluated,candidate,grant,target)
end

function Runtime:onObstructionRelocationCompletion(result)
    if type(result)~="table" or type(result.commitmentId)~="string" then return end
    self.regulationBoundedAuthority:_releaseRelocationSerialization(result.commitmentId,"OBSTRUCTION_RELOCATION_CONTROL_"..tostring(result.status))
    if type(result.boundedAuthorityId)=="string" then self.boundedAuthority:release(result.boundedAuthorityId,"OBSTRUCTION_RELOCATION_CONTROL_"..tostring(result.status)) end

    if result.status=="MANOEUVRE_COMPLETE" then
        logInfo("MANOEUVRE_COMPLETE commitment=%s relocation=%s freshSituationRequired=true semanticResolutionNotInferred=true",tostring(result.commitmentId),tostring(result.relocationKey))
        return
    end

    local eventKind=nil
    if result.status=="FAILED" then eventKind="OBJECTIVE_FAILED"
    elseif result.status=="PLAYER_CLAIM" then eventKind="PLAYER_CLAIM"
    elseif result.status=="SUPERSEDED" then eventKind="NEW_AUTHORITATIVE_INTENT" end
    if eventKind~=nil then
        local terminal,reason=OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,result.commitmentId,eventKind,result.evidence)
        if terminal==nil then logWarning("CONTROL_SETTLEMENT_FAILED commitment=%s event=%s reason=%s",tostring(result.commitmentId),tostring(eventKind),tostring(reason)) end
    end
end

function Runtime:_dispatchObstructionRelocation(picture,evaluated,candidate,bridge)
    local boundary=evaluated.candidateInventory and evaluated.candidateInventory.supportBoundary or nil
    if type(boundary)~="table" or boundary.mode~="CAUSAL_OBSTRUCTION_RELOCATION_TEST" then
        return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_SUPPORT_BOUNDARY_MISMATCH"}
    end

    if bridge.terminalEvent~=nil then
        local commitmentId=bridge.existingCommitmentId
        if type(commitmentId)~="string" then return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_SETTLEMENT_WITHOUT_COMMITMENT"} end
        self.regulationBoundedAuthority:_releaseRelocationSerialization(commitmentId,"OBSTRUCTION_RELOCATION_SITUATION_SETTLEMENT")
        local terminal,reason=OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,commitmentId,bridge.terminalEvent,{kind="CAUSAL_OBSTRUCTION_RELOCATION_SITUATION_SETTLEMENT",relocationKey=bridge.relocationKey,reason=bridge.terminalReason})
        return {status=terminal and "SETTLED" or "NO_DISPATCH",reason=reason,obstructionRelocation=true,terminalEvent=bridge.terminalEvent,commitment=terminal}
    end

    if bridge.phase=="WAITING_FOR_EVIDENCE" then
        return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_WAITING_FOR_POSITIVE_CONTINUATION",obstructionRelocation=true,commitmentId=bridge.existingCommitmentId}
    end
    if candidate.capability~="REPOSITION" then return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_NON_REPOSITION_CANDIDATE",obstructionRelocation=true} end
    local control=self.liveControlDispatcher.obstructionRelocationControl
    if control==nil then return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_CONTROL_UNAVAILABLE",obstructionRelocation=true} end
    if type(control.isActive)=="function" and control:isActive() then return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_CONTROL_ALREADY_ACTIVE",obstructionRelocation=true} end

    local readiness={status="OBSTRUCTION_RELOCATION_RESPONSIBILITY_TRANSITION_REQUIRED",candidateId=candidate.identity,relocationKey=bridge.relocationKey}
    -- Obstruction Relocation Resolution exposure seam. RS identity/current-responsibility
    -- ownership and the single provenance-neutral transition are aligned before dispatch.
    local applied,reason=self.responsibilityTransitionAuthority:transitionObstructionRelocationResolution(
        picture,evaluated,readiness,self.obstructionRelocationResponsibilityTransition)
    if applied==nil then
        return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_RESPONSIBILITY_APPLICATION_FAILED",detail=reason,obstructionRelocation=true,candidateId=candidate.identity}
    end

    local protected,protectedReason=self.regulationBoundedAuthority:_applyRelocationSerialization(
        picture,evaluated,candidate,applied.commitment,applied.currentResponsibility,bridge)
    if protected~=true then
        self.regulationBoundedAuthority:_releaseRelocationSerialization(applied.commitment.identity,"OBSTRUCTION_RELOCATION_SERIALIZATION_START_FAILED")
        local terminal=OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,applied.commitment.identity,"OBJECTIVE_FAILED",{kind="OBSTRUCTION_RELOCATION_SERIALIZATION_START_FAILED",reason=protectedReason})
        return {status="REJECTED",reason=protectedReason,obstructionRelocation=true,commitment=terminal or applied.commitment}
    end

    local request,requestReason=self:_obstructionRelocationRequest(picture,evaluated,candidate,applied,bridge)
    if request==nil then
        self.regulationBoundedAuthority:_releaseRelocationSerialization(applied.commitment.identity,"OBSTRUCTION_RELOCATION_REQUEST_FAILED")
        OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,applied.commitment.identity,"OBJECTIVE_FAILED",{kind="OBSTRUCTION_RELOCATION_REQUEST_FAILED",reason=requestReason})
        return {status="NO_DISPATCH",reason=requestReason,obstructionRelocation=true,commitment=applied.commitment}
    end

    local started,result=self.liveControlDispatcher:dispatch(request,candidate)
    local outcome=started and self.liveControlDispatcher:notifyAccepted(request,{kind="OBSTRUCTION_RELOCATION_CONTROL_ACCEPTED",authorityClass="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false})
        or self.liveControlDispatcher:notifyRejected(request,result,{kind="NO_PHYSICAL_EFFECT_CONFIRMED",authorityClass="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false})
    if started~=true then
        self.boundedAuthority:release(request.boundedAuthorityId,"OBSTRUCTION_RELOCATION_START_REJECTED")
        self.regulationBoundedAuthority:_releaseRelocationSerialization(applied.commitment.identity,"OBSTRUCTION_RELOCATION_START_REJECTED")
        local eventKind=result=="PLAYER_CLAIM_AT_CONTROL_BOUNDARY" and "PLAYER_CLAIM" or (result=="SOURCE_AI_REACTIVATED_AT_CONTROL_BOUNDARY" and "NEW_AUTHORITATIVE_INTENT" or "OBJECTIVE_FAILED")
        OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,applied.commitment.identity,eventKind,{kind="OBSTRUCTION_RELOCATION_START_REJECTED",reason=tostring(result)})
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,obstructionRelocation=true,commitment=applied.commitment}
    end

    logInfo("ACCEPTED commitment=%s responsibility=%s relocation=%s blocker=%s request=%s beneficiaries=%d authority=OBSTRUCTION_RELOCATION_ACTUATION",
        tostring(applied.commitment.identity),tostring(applied.currentResponsibility.identity),tostring(bridge.relocationKey),tostring(bridge.blockerAssemblyReferenceKey),tostring(request.identity),OuttaMyWay.ValueRecord.length(bridge.relocationSerializationBeneficiaries or {}))
    return {status="ACCEPTED",request=request,outcome=outcome,commitment=applied.commitment,candidate=candidate,currentResponsibility=applied.currentResponsibility,obstructionRelocation=true,result=result}
end

function Runtime:dispatchEvaluatedOperationalPicture(picture,evaluated)
    if picture==nil or evaluated==nil or evaluated.decision==nil then return {status="NO_DISPATCH",reason="MISSING_SEALED_DECISION"} end

    local inventory=evaluated and evaluated.candidateInventory or nil
    local boundary=inventory and inventory.supportBoundary or nil
    if type(boundary)=="table" and boundary.mode=="PROSPECTIVE_DECISION_PORTFOLIO" then
        local localBoundary=selectedGroupBoundary(evaluated)
        if type(localBoundary)~="table" then
            return {status="NO_DISPATCH",reason="SELECTED_PORTFOLIO_CANDIDATE_SUPPORT_BOUNDARY_UNAVAILABLE"}
        end
        local values=OuttaMyWay.ValueRecord.toTable(inventory)
        values.supportBoundary=localBoundary
        values.provenance={source="ProspectiveDecisionPortfolioIntegration",portfolioCandidateInventoryId=inventory.identity,selectedGroupBoundary=true}
        local projected=OuttaMyWay.CandidateInventory.new(values)
        local normalized={}
        for key,value in pairs(evaluated) do normalized[key]=value end
        normalized.candidateInventory=projected
        evaluated=normalized
    end

    local candidate=selectedCandidate(evaluated)
    local obstructionBridge=relocationBridge(candidate)
    if obstructionBridge~=nil then
        return self:_dispatchObstructionRelocation(picture,evaluated,candidate,obstructionBridge)
    end
    local followerBridge=followerBoundaryBridge(candidate)
    local currentFollower=followerBridge and self.responsibilityTransitionAuthority:findRegulation("pairKey",followerBridge.pairKey) or nil
    local followerAssessment=nil
    if currentFollower~=nil then
        followerAssessment=self.currentResponsibilityAssessment:assessFollowerBoundary(followerBridge)
        if followerAssessment.disposition=="TERMINATE" then
            return self:_terminateFollowerBoundaryRegulation(picture,evaluated,currentFollower,followerBridge,followerAssessment)
        end
    end
    local bridge=cooperativePassageBridge(candidate)
    local dispatch=nil
    if candidate~=nil and candidate.capability=="REPOSITION" and bridge~=nil then
        if self.liveControlDispatcher.cooperativePassageControl==nil then return {status="NO_DISPATCH",reason="COOPERATIVE_PASSAGE_CONTROL_UNAVAILABLE",candidateId=candidate.identity} end
        local inventory=evaluated.candidateInventory
        local boundary=inventory and inventory.supportBoundary or nil
        if type(boundary)~="table" or boundary.mode~="COOPERATIVE_PASSAGE" then
            return {status="NO_DISPATCH",reason="COOPERATIVE_PASSAGE_SUPPORT_BOUNDARY_MISMATCH",candidateId=candidate.identity}
        end
        if type(self.liveControlDispatcher.cooperativePassageControl.isActive)=="function" and self.liveControlDispatcher.cooperativePassageControl:isActive() then
            return {status="NO_DISPATCH",reason="COOPERATIVE_PASSAGE_CONTROL_ALREADY_ACTIVE",candidateId=candidate.identity}
        end
        dispatch={status="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED",candidateId=candidate.identity}
    end

    local actionBridge=actionSpaceBridge(candidate)
    local currentAction=actionBridge and self.responsibilityTransitionAuthority:findRegulation("conflictIdentity",actionBridge.conflictIdentity) or self.responsibilityTransitionAuthority:getCurrentActionSpaceRegulation()
    local actionAssessment=nil
    if currentAction~=nil then
        actionAssessment=self.currentResponsibilityAssessment:assessActionSpaceRegulation(currentAction,actionSpaceRelation(picture,currentAction))
        if actionAssessment.disposition=="TERMINATE" then
            return self:_terminateActionSpaceRegulation(picture,evaluated,currentAction,actionAssessment)
        end
    end
    if dispatch==nil then dispatch=self.regulationBoundedAuthority:assessActionSpaceRegulationPermission(picture,evaluated,candidate,actionAssessment) end
    if dispatch==nil or dispatch.status=="QUIESCENT" then
        local follower=self.regulationBoundedAuthority:assessFollowerBoundaryPermission(picture,evaluated,candidate,followerAssessment)
        if follower~=nil then dispatch=follower end
    end
    if dispatch==nil then
        if candidate==nil then return {status="NO_DISPATCH",reason="NO_SELECTED_PHYSICAL_CANDIDATE"} end
        return {status="NO_DISPATCH",reason="PHYSICAL_CANDIDATE_NOT_ALIGNED_FOR_LIVE_CONTROL",candidateId=candidate.identity}
    end
    if dispatch.status=="FOLLOWER_BOUNDARY_RESPONSIBILITY_TRANSITION_REQUIRED" then
        local applied,reason=self.followerBoundaryResponsibilityTransition:transition(picture,evaluated,dispatch)
        if applied==nil then
            return {status="NO_DISPATCH",reason="FOLLOWER_BOUNDARY_RESPONSIBILITY_APPLICATION_FAILED",detail=reason,candidateId=dispatch.candidateId,followerBoundary=true}
        end
        local continued=self.regulationBoundedAuthority:continueFollowerBoundary(picture,evaluated,applied)
        continued.currentResponsibility=applied.currentResponsibility
        return continued
    end
    if dispatch.status=="ACTION_SPACE_REGULATION_RESPONSIBILITY_TRANSITION_REQUIRED" then
        local applied,reason=self.actionSpaceRegulationResponsibilityTransition:transition(picture,evaluated,dispatch)
        if applied==nil then return self.regulationBoundedAuthority:actionSpaceRegulationTransitionFailed(dispatch,reason) end
        local continued=self.regulationBoundedAuthority:continueActionSpaceRegulation(picture,evaluated,applied,dispatch)
        continued.currentResponsibility=applied.currentResponsibility
        return continued
    end
    if dispatch.status=="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED" then
        local applied,reason=nil,nil
        if self.responsibilityTransitionAuthority:matchesActionSpacePassage(evaluated) then
            applied,reason=self.responsibilityTransitionAuthority:replaceActionSpaceRegulationWithCooperativePassage(
                picture,evaluated,dispatch,self.cooperativePassageResponsibilityTransition,self.regulationBoundedAuthority)
        elseif self.responsibilityTransitionAuthority:matchesFollowerPassage(picture,evaluated) then
            applied,reason=self.responsibilityTransitionAuthority:replaceFollowerRegulationWithCooperativePassage(
                picture,evaluated,dispatch,self.cooperativePassageResponsibilityTransition,self.regulationBoundedAuthority)
        else
            applied,reason=self.responsibilityTransitionAuthority:transitionCooperativePassageResolution(
                picture,evaluated,dispatch,self.cooperativePassageResponsibilityTransition)
        end
        if applied==nil then
            return {status="NO_DISPATCH",reason="COMMITMENT_APPLICATION_FAILED",detail=reason,candidateId=dispatch.candidateId}
        end
        local continued=self:_continueCooperativePassage(picture,evaluated,applied)
        continued.currentResponsibility=applied.currentResponsibility
        return continued
    end
    return dispatch
end

function Runtime:processLiveObservation(raw)
    local processed=self:processSealedObservation(raw)
    local supported=nil
    if OuttaMyWay.ValueRecord.length(processed.picture.commitmentContext or {})>0 then
        -- Incumbent lifecycle gating remains exactly on the accepted path.
        supported=self.obstructionRelocationCandidateSupport:attach(processed.picture,processed.snapshot)
        if supported==nil then supported=self.liveTrafficCandidateSupport:attach(processed.picture,processed.snapshot) end
    else
        supported=self.prospectiveDecisionPortfolioSupport:attach(processed.picture,processed.snapshot)
        if supported==nil then
            -- Conservative escape hatch only; a fresh Portfolio helper normally
            -- returns either a Portfolio or the existing passive support.
            supported=self.obstructionRelocationCandidateSupport:attach(processed.picture,processed.snapshot)
            if supported==nil then supported=self.liveTrafficCandidateSupport:attach(processed.picture,processed.snapshot) end
        end
    end

    local evaluated=self:evaluateSealedOperationalPicture(supported)
    local boundary=selectedGroupBoundary(evaluated)
    if type(boundary)=="table" and (boundary.mode=="TS015_COOPERATIVE_PASSAGE_PRODUCTION_TEST" or boundary.mode=="COOPERATIVE_PASSAGE") then
        local candidate=selectedCandidate(evaluated)
        if candidate~=nil then
            local bridge=candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
            local traceKey=tostring(bridge and bridge.conflictIdentity or candidate.identity)
            if self.cooperativeVerdictTraceKey~=traceKey then
                self.cooperativeVerdictTraceKey=traceKey
                local summary={}
                for _,verdict in OuttaMyWay.ValueRecord.ipairs(evaluated.verdicts or {}) do
                    if verdict.candidateId==candidate.identity then summary[#summary+1]=tostring(verdict.constraintId).."="..tostring(verdict.result) end
                end
                table.sort(summary)
                cooperativeLog("COOPERATIVE_CONSTRAINT_VERDICT conflict=%s candidate=%s decision=%s selected=true verdicts=%s",
                    tostring(bridge and bridge.conflictIdentity or "n/a"),tostring(candidate.identity),tostring(evaluated.decision and evaluated.decision.identity or "n/a"),table.concat(summary,","))
            end
        end
    else
        self.cooperativeVerdictTraceKey=nil
    end

    local dispatch=self:dispatchEvaluatedOperationalPicture(supported,evaluated)
    return {
        snapshot=processed.snapshot,jobEpisodes=processed.jobEpisodes,operation=processed.operation,picture=supported,
        candidateInventory=evaluated.candidateInventory,candidates=evaluated.candidates,verdictSet=evaluated.verdictSet,verdicts=evaluated.verdicts,decision=evaluated.decision,
        controlDispatch=dispatch
    }
end

function Runtime:runReplay(fixture) return self.replayRunner:run(fixture) end
function Runtime:getStatus()
    return {initialized=self.initialized,
        observationCount=self.observationAdapter:getPublishedCount(),jobEpisodeCount=#self.jobEpisodes:list(),operationCount=#self.operations:list(),operationalPictureCount=self.situationAssessment:getPublishedCount(),candidateInventoryCount=self.candidateSpace:getPublishedCount(),constraintVerdictSetCount=self.constraintEngine:getPublishedCount(),decisionCount=self.decisionSelector:getPublishedCount(),commitmentApplicationCount=self.decisionCommitmentBoundary:getPublishedCount(),governingBasisVerdictCount=self.governingBasisEvaluator:getPublishedCount(),replayRunCount=self.replayRunner:getRunCount(),passiveCandidateSupportCount=self.passiveCandidateSupport:getPublishedCount(),liveTrafficCandidateSupportCount=self.liveTrafficCandidateSupport:getPublishedCount(),liveTrafficCandidateSupportStatus=self.liveTrafficCandidateSupport:getLastStatus(),obstructionRelocationCandidateSupportStatus=self.obstructionRelocationCandidateSupport:getLastStatus(),obstructionRelocationCandidateSupportCount=self.obstructionRelocationCandidateSupport:getPublishedCount(),liveControlDispatchCount=self.liveControlDispatcher:getDispatchCount(),regulationAuthorityDispatchCount=self.regulationBoundedAuthority and self.regulationBoundedAuthority:getDispatchCount() or 0,cooperativePassageControlStatus=(self.liveControlDispatcher.cooperativePassageControl and self.liveControlDispatcher.cooperativePassageControl:getStatus() or nil),obstructionRelocationControlStatus=(self.liveControlDispatcher.obstructionRelocationControl and self.liveControlDispatcher.obstructionRelocationControl:getStatus() or nil),liveRuntimeCoordinatorCycleCount=self.liveRuntimeCoordinator and self.liveRuntimeCoordinator:getCycleCount() or 0,liveRuntimeCoordinatorErrorCount=self.liveRuntimeCoordinator and self.liveRuntimeCoordinator:getErrorCount() or 0,passiveTraceCount=#self.passiveLiveValidator:getRecords(),passiveErrorCount=self.passiveLiveValidator:getErrorCount(),fieldIdentityProbeSampleCount=self.targetedFieldIdentityProbe:getSampleCount(),fieldWorldSnapshotCount=self.fieldWorldSnapshots:getRecordCount(),fieldWorldComparisonCount=self.fieldWorldEquivalenceAuthority:getComparisonRecordCount(),fieldWorldResolutionCount=self.fieldWorldEquivalenceAuthority:getResolutionRecordCount(),activeFieldWorldCount=self.fieldWorldEquivalenceAuthority:getActiveClassCount(),representationCacheRetiredCount=self.assemblyRepresentationCache.retiredCount or 0,activeOperationCount=#self.operations:listActive(),commitmentCount=#self.commitments:list(),traceCount=self.trace:count()}
end
