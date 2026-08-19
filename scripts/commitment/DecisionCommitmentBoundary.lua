OuttaMyWay.DecisionCommitmentBoundary = {}
local Boundary = OuttaMyWay.DecisionCommitmentBoundary
Boundary.__index = Boundary

local physical = {REGULATE_SPEED=true,HOLD=true,REPOSITION=true,RESTORE_CONFIGURATION=true,HANDOVER_TO_GIANTS=true}

local function selectedCandidate(decision,candidates)
    if decision.selectedCandidateId == nil then return nil end
    for _, candidate in OuttaMyWay.ValueRecord.ipairs(candidates or {}) do
        if candidate.identity == decision.selectedCandidateId then return candidate end
    end
    error("Decision selected a candidate absent from the supplied Candidate inventory",3)
end

local function targetContext(picture)
    local contexts = picture.commitmentContext or {}
    if #contexts == 0 then return nil end
    if #contexts ~= 1 then error("Commitment application requires one unambiguous target context",3) end
    if type(contexts[1].commitmentId) ~= "string" then error("Commitment context requires commitmentId",3) end
    return contexts[1]
end

local function situationDependencies(picture)
    local result = {}
    for _, situation in OuttaMyWay.ValueRecord.ipairs(picture.situations or {}) do result[#result+1] = situation.identity end
    for _, encounter in OuttaMyWay.ValueRecord.ipairs(picture.encounters or {}) do result[#result+1] = encounter.identity end
    table.sort(result)
    return result
end

local function validatePhysicalOwnershipAgainstComposition(progressOwnership,postJobOwnership,compositionValues)
    if type(compositionValues)~="table" then return end
    local progressDeclared,postJobDeclared,progressComposed,postJobComposed={},{},{},{}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(progressOwnership and progressOwnership.assemblyIds or {}) do
        if type(assemblyId)~="string" or assemblyId=="" then error("progress-actuation ownership requires assembly identity",3) end
        progressDeclared[assemblyId]=true
    end
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(postJobOwnership and postJobOwnership.assemblyIds or {}) do
        if type(assemblyId)~="string" or assemblyId=="" then error("post-job-actuation ownership requires assembly identity",3) end
        postJobDeclared[assemblyId]=true
    end
    for _,entry in OuttaMyWay.ValueRecord.ipairs(compositionValues.entries or {}) do
        if entry.progressActuation==true then progressComposed[entry.assemblyId]=true end
        if entry.postJobActuation==true then postJobComposed[entry.assemblyId]=true end
    end
    local function same(a,b,label)
        for id in pairs(a) do if not b[id] then error("physical selected Candidate "..label.." ownership disagrees with Effective Actuation Composition",3) end end
        for id in pairs(b) do if not a[id] then error("physical selected Candidate "..label.." ownership disagrees with Effective Actuation Composition",3) end end
    end
    same(progressDeclared,progressComposed,"progress-actuation")
    same(postJobDeclared,postJobComposed,"post-job-actuation")
    for id in pairs(progressDeclared) do if postJobDeclared[id] then error("one assembly cannot simultaneously own progress and post-job actuation",3) end end
end

function Boundary.new(identityRegistry,epochSequence,admission,commitmentRegistry,obligationLedger,authorityRegistry,governingBasisEvaluator,terminalSettlementEvaluator)
    return setmetatable({
        identities=identityRegistry,epochs=epochSequence,admission=admission,commitments=commitmentRegistry,
        obligations=obligationLedger,authorities=authorityRegistry,governingBasisEvaluator=governingBasisEvaluator,terminalSettlement=terminalSettlementEvaluator,publishedCount=0
    },Boundary)
end

function Boundary:_admitFromCandidate(picture,decision,candidate)
    if candidate == nil then error("Commitment creation requires selected Candidate",3) end
    local basis = candidate.evidenceBasis.governingBasis
    if type(basis) ~= "table" then error("selected Candidate requires explicit Governing Basis",3) end
    local progressAssemblyIds,postJobAssemblyIds={},{}
    local progressOwnership=candidate.evidenceBasis.progressActuationOwnership
    local postJobOwnership=candidate.evidenceBasis.postJobActuationOwnership
    if physical[candidate.capability] then
        local progressCount=type(progressOwnership)=="table" and type(progressOwnership.assemblyIds)=="table" and #progressOwnership.assemblyIds or 0
        local postJobCount=type(postJobOwnership)=="table" and type(postJobOwnership.assemblyIds)=="table" and #postJobOwnership.assemblyIds or 0
        if progressCount+postJobCount==0 then error("physical selected Candidate requires explicit actuation ownership",3) end
        if progressCount>0 and postJobCount>0 then error("physical selected Candidate must select one actuation authority class",3) end
        for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(progressOwnership and progressOwnership.assemblyIds or {}) do progressAssemblyIds[#progressAssemblyIds+1]=assemblyId end
        for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(postJobOwnership and postJobOwnership.assemblyIds or {}) do postJobAssemblyIds[#postJobAssemblyIds+1]=assemblyId end
    end
    local compositionValues=candidate.evidenceBasis.effectiveActuationComposition
    if physical[candidate.capability] then validatePhysicalOwnershipAgainstComposition(progressOwnership,postJobOwnership,compositionValues) end
    local admitted = self.admission:admit({
        objective=candidate.purpose,
        governingBasis=basis,
        strategy={selectedCandidateId=candidate.identity,capability=candidate.capability,expectedEffect=candidate.expectedEffect},
        situationDependencies=situationDependencies(picture),
        evidenceContracts=candidate.preconditions.evidenceContracts or {},
        obligationSpecifications=candidate.obligationsCreated,
        progressAssemblyIds=progressAssemblyIds,postJobAssemblyIds=postJobAssemblyIds,
        effectiveActuationCompositionId=nil
    })
    if type(compositionValues) == "table" then
        local rebound = OuttaMyWay.ValueRecord.toTable(compositionValues)
        for _, entry in OuttaMyWay.ValueRecord.ipairs(rebound.entries or {}) do
            if entry.commitmentId == "$NEW_COMMITMENT" then entry.commitmentId = admitted.commitment.identity end
        end
        local composition = OuttaMyWay.EffectiveActuationComposition.create(rebound)
        local revised = OuttaMyWay.CommitmentStateMachine.revise(admitted.commitment,{
            effectiveActuationCompositionId=composition.identity,
            epoch=self.epochs:next()
        })
        admitted.commitment = self.commitments:save(revised)
        admitted.effectiveActuationCompositionId = composition.identity
    end
    return admitted
end

function Boundary:apply(picture,decisionResult)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    local decision = decisionResult.decision
    OuttaMyWay.ValueRecord.assertType(decision,"DecisionRecord")
    if decision.operationalPictureId ~= picture.identity then error("Decision belongs to another Operational Picture",2) end
    if decision.candidateInventoryId ~= decisionResult.candidateInventory.identity then error("Decision inventory mismatch",2) end
    if decision.mandatoryVerdictSetId ~= decisionResult.verdictSet.identity then error("Decision verdict-set mismatch",2) end
    local candidate = selectedCandidate(decision,decisionResult.candidates)
    local context = targetContext(picture)
    local previousState, resultingState, commitmentId, compositionId
    local createdObligationIds, authorityTokenIds = {}, {}
    local explanation
    local action = decision.commitmentAction

    if action == "CREATE" then
        if context ~= nil then error("CREATE Decision cannot target an existing Commitment",2) end
        local admitted = self:_admitFromCandidate(picture,decision,candidate)
        commitmentId=admitted.commitment.identity; resultingState=admitted.commitment.state
        createdObligationIds=admitted.obligationIds
        for _, token in OuttaMyWay.ValueRecord.ipairs(admitted.authorityTokens) do authorityTokenIds[#authorityTokenIds+1]=token.identity end
        compositionId=admitted.commitment.effectiveActuationCompositionId
        explanation="Admitted one new Commitment from an all-PASS selected Candidate"
    elseif action == "MAINTAIN" or action == "REVISE" then
        if context == nil then
            action="NO_MUTATION"; explanation="No existing Commitment was available for non-creating Decision"
        else
            local record=self.commitments:get(context.commitmentId)
            if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then error("Decision targets no live Commitment",2) end
            if record.state=="SETTLING" then error("SETTLING Commitment cannot maintain or revise objective-progress strategy",2) end
            previousState=record.state; commitmentId=record.identity
            if record.state=="WAITING_FOR_EVIDENCE" then
                record=OuttaMyWay.CommitmentStateMachine.transition(record,"ACTIVE",{epoch=self.epochs:next()},self.obligations)
                record=self.commitments:save(record)
            end
            local strategy=OuttaMyWay.ValueRecord.toTable(record).strategy
            strategy.selectedCandidateId=candidate and candidate.identity or strategy.selectedCandidateId
            strategy.capability=candidate and candidate.capability or strategy.capability
            strategy.expectedEffect=candidate and candidate.expectedEffect or strategy.expectedEffect
            local revised=OuttaMyWay.CommitmentStateMachine.revise(record,{strategy=strategy,epoch=self.epochs:next()})
            record=self.commitments:save(revised)
            resultingState=record.state
            explanation=action=="REVISE" and "Revised strategy inside the same unresolved Commitment" or "Maintained the existing Commitment"
        end
    elseif action == "WAIT" then
        if context == nil and candidate ~= nil then
            local admitted=self:_admitFromCandidate(picture,decision,candidate)
            local waiting=OuttaMyWay.CommitmentStateMachine.transition(admitted.commitment,"WAITING_FOR_EVIDENCE",{epoch=self.epochs:next()},self.obligations)
            waiting=self.commitments:save(waiting)
            commitmentId=waiting.identity; resultingState=waiting.state
            createdObligationIds=admitted.obligationIds
            for _, token in OuttaMyWay.ValueRecord.ipairs(admitted.authorityTokens) do authorityTokenIds[#authorityTokenIds+1]=token.identity end
            if #authorityTokenIds>0 then error("WAITING_FOR_EVIDENCE cannot retain newly acquired actuation authority",2) end
            explanation="Admitted an evidence-bound Commitment and entered WAITING_FOR_EVIDENCE"
        elseif context == nil then
            action="NO_MUTATION"; explanation="Explicit WAIT required no Commitment mutation"
        else
            local record=self.commitments:get(context.commitmentId)
            if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then error("WAIT targets no live Commitment",2) end
            previousState=record.state; commitmentId=record.identity
            if record.state=="ACTIVE" then
                record=OuttaMyWay.CommitmentStateMachine.transition(record,"WAITING_FOR_EVIDENCE",{epoch=self.epochs:next()},self.obligations)
                record=self.commitments:save(record)
            elseif record.state~="WAITING_FOR_EVIDENCE" then error("SETTLING Commitment cannot return to evidence waiting",2) end
            resultingState=record.state
            explanation="Preserved responsibility while speculative progress remained prohibited"
        end
    elseif action == "SETTLE" then
        if context == nil then
            action="NO_MUTATION"; explanation="Complete supportable space exhausted before a Commitment existed"
        else
            local directive=context.settlementDirective
            if type(directive)~="table" then error("SETTLE requires explicit settlementDirective in Commitment context",2) end
            local record=self.commitments:get(context.commitmentId)
            if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then error("SETTLE targets no live Commitment",2) end
            previousState=record.state; commitmentId=record.identity
            if type(directive.eventKind) ~= "string" then error("settlementDirective requires canonical eventKind",2) end
            local verdict=self.governingBasisEvaluator:evaluate(record,{kind=directive.eventKind,evidence=directive.evidence or {},provenance=directive.provenance or {}})
            if not verdict.invalidated then error("settlementDirective event does not invalidate Governing Basis",2) end
            if directive.intendedTerminalDisposition ~= nil and directive.intendedTerminalDisposition ~= verdict.intendedTerminalDisposition then
                error("settlementDirective disposition contradicts canonical Governing Basis event",2)
            end
            if directive.terminalCause ~= nil and directive.terminalCause ~= verdict.terminalCause then
                error("settlementDirective cause contradicts canonical Governing Basis event",2)
            end
            local result=self.terminalSettlement:enterSettling(record.identity,verdict)
            resultingState=result.commitment.state
            for _, id in OuttaMyWay.ValueRecord.ipairs(result.releasedAuthorityTokenIds) do authorityTokenIds[#authorityTokenIds+1]=id end
            explanation="Ended objective-progress authority and entered SETTLING"
        end
    else error("unsupported Decision Commitment action " .. tostring(action),2) end

    local application=OuttaMyWay.CommitmentApplicationRecord.new({
        identity=self.identities:issue("COMMITMENT_APPLICATION"),epoch=self.epochs:next(),decisionId=decision.identity,
        action=action,commitmentId=commitmentId,selectedCandidateId=candidate and candidate.identity or nil,
        previousState=previousState,resultingState=resultingState,createdObligationIds=createdObligationIds,
        authorityTokenIds=authorityTokenIds,effectiveActuationCompositionId=compositionId,
        explanation=explanation,provenance={source="DecisionCommitmentBoundary",operationalPictureId=picture.identity}
    })
    self.publishedCount=self.publishedCount+1
    return application
end
function Boundary:getPublishedCount() return self.publishedCount end
