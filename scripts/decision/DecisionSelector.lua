OuttaMyWay.DecisionSelector={}
local Selector=OuttaMyWay.DecisionSelector
Selector.__index=Selector
local nonActuating={CONTINUE_UNCHANGED=true,CONTINUE_OBSERVATION=true,ESCALATE=true}

local function hasUnresolved(verdicts)
    for _,verdict in OuttaMyWay.ValueRecord.ipairs(verdicts) do if verdict.result=="UNRESOLVED" then return true end end
    return false
end

local function candidateGroupKey(candidate)
    local group=candidate and candidate.evidenceBasis and candidate.evidenceBasis.candidateSupportGroup or nil
    return type(group)=="table" and group.groupKey or nil
end

local function portfolioBoundary(inventory)
    local boundary=inventory and inventory.supportBoundary or nil
    if type(boundary)=="table" and boundary.mode=="PROSPECTIVE_DECISION_PORTFOLIO" then return boundary end
    return nil
end

local function groupBoundary(inventory,groupKey)
    local boundary=portfolioBoundary(inventory)
    if boundary==nil then return nil end
    for _,group in OuttaMyWay.ValueRecord.ipairs(boundary.groups or {}) do
        if group.groupKey==groupKey then return group.supportBoundary end
    end
    return nil
end

local function projectedInventory(inventory,candidates,groupKey,boundary)
    local candidateIds={}
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(candidates or {}) do
        if candidateGroupKey(candidate)==groupKey then candidateIds[#candidateIds+1]=candidate.identity end
    end
    return OuttaMyWay.CandidateInventory.new({
        identity=inventory.identity,epoch=inventory.epoch,operationalPictureId=inventory.operationalPictureId,
        candidateIds=candidateIds,complete=true,supportBoundary=boundary,
        provenance={source="DecisionSelector",portfolioProjection=true,portfolioCandidateInventoryId=inventory.identity,selectedGroupKey=groupKey}
    })
end

function Selector.new(identityRegistry,epochSequence)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,publishedCount=0},Selector)
end

function Selector:select(operationalPicture,candidateResult,verdictResult)
    OuttaMyWay.ValueRecord.assertType(operationalPicture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(candidateResult.inventory,"CandidateInventory")
    OuttaMyWay.ValueRecord.assertType(verdictResult.set,"ConstraintVerdictSet")
    if verdictResult.set.candidateInventoryId~=candidateResult.inventory.identity then
        error("Constraint verdict set belongs to a different Candidate inventory",2)
    end

    local byCandidate={}
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(candidateResult.candidates) do byCandidate[candidate.identity]={candidate=candidate,verdicts={}} end
    for _,verdict in OuttaMyWay.ValueRecord.ipairs(verdictResult.verdicts) do
        local entry=byCandidate[verdict.candidateId]
        if entry==nil then error("Constraint verdict references unknown candidate",2) end
        entry.verdicts[#entry.verdicts+1]=verdict
    end

    local viable={}
    local unresolvedCandidates={}
    for candidateId,entry in OuttaMyWay.ValueRecord.pairs(byCandidate) do
        if #entry.verdicts~=OuttaMyWay.ValueRecord.length(verdictResult.set.mandatoryConstraintIds) then error("candidate lacks a complete mandatory verdict set",2) end
        local pass=true
        for _,verdict in OuttaMyWay.ValueRecord.ipairs(entry.verdicts) do if verdict.result~="PASS" then pass=false end end
        if pass then viable[#viable+1]=entry.candidate
        elseif hasUnresolved(entry.verdicts) then unresolvedCandidates[#unresolvedCandidates+1]=candidateId end
    end
    table.sort(viable,function(a,b)
        if a.comparisonCost~=b.comparisonCost then return a.comparisonCost<b.comparisonCost end
        if a.capability~=b.capability then return a.capability<b.capability end
        return a.identity<b.identity
    end)
    table.sort(unresolvedCandidates)

    local viableIds={}; for _,candidate in OuttaMyWay.ValueRecord.ipairs(viable) do viableIds[#viableIds+1]=candidate.identity end

    local inventoryForLocalPolicy=candidateResult.inventory
    local selectable=viable
    local selectedUnresolved=unresolvedCandidates
    local portfolioChoice=nil
    local portfolioSelectionMissing=false
    if portfolioBoundary(candidateResult.inventory)~=nil then
        portfolioChoice=OuttaMyWay.ProspectivePortfolioDecisionPolicy:selectGroup(candidateResult.inventory)
        if portfolioChoice==nil or type(portfolioChoice.groupKey)~="string" then
            portfolioSelectionMissing=true
            selectable={}
            selectedUnresolved={}
        else
            local groupKey=portfolioChoice.groupKey
            local filtered={}
            for _,candidate in OuttaMyWay.ValueRecord.ipairs(viable) do if candidateGroupKey(candidate)==groupKey then filtered[#filtered+1]=candidate end end
            selectable=filtered
            local unresolved={}
            for _,candidateId in OuttaMyWay.ValueRecord.ipairs(unresolvedCandidates) do
                local entry=byCandidate[candidateId]
                if entry~=nil and candidateGroupKey(entry.candidate)==groupKey then unresolved[#unresolved+1]=candidateId end
            end
            selectedUnresolved=unresolved
            local boundary=groupBoundary(candidateResult.inventory,groupKey)
            if type(boundary)~="table" then error("Prospective Decision Portfolio selected group lacks support boundary",2) end
            inventoryForLocalPolicy=projectedInventory(candidateResult.inventory,candidateResult.candidates,groupKey,boundary)
        end
    end

    local trafficPolicy=nil
    if not portfolioSelectionMissing then
        trafficPolicy=OuttaMyWay.TrafficPolicemanDecisionPolicy:select(operationalPicture,inventoryForLocalPolicy,selectable)
    end
    local selected=trafficPolicy and trafficPolicy.selected or selectable[1]
    local commitmentAction
    local nonIntervention
    local explanation
    if portfolioSelectionMissing then
        commitmentAction="WAIT"
        nonIntervention={explicit=true,classification="PROSPECTIVE_PORTFOLIO_POLICY_UNRESOLVED"}
        explanation="Prospective Decision Portfolio was complete but compatibility policy could not identify one governing support group"
    elseif trafficPolicy~=nil and trafficPolicy.waitForPreferenceEvidence==true then
        selected=nil
        commitmentAction="WAIT"
        nonIntervention={explicit=true,classification="WAIT_FOR_PREFERENCE_EXHAUSTION_EVIDENCE",governingRequirementKey=trafficPolicy.governingRequirementKey,blockedCandidates=trafficPolicy.blocked,selectedGroupKey=portfolioChoice and portfolioChoice.groupKey or nil}
        explanation="Traffic Policeman later-band candidate lacks explicit same-picture exhaustion evidence for every earlier preference band"
    elseif selected~=nil then
        if selected.capability=="CONTINUE_OBSERVATION" then
            if selected.evidenceBasis and selected.evidenceBasis.maintainsExistingCommitment==true and selected.evidenceBasis.existingProgressMayContinue==true then commitmentAction="MAINTAIN" else commitmentAction="WAIT" end
        elseif selected.capability=="CONTINUE_UNCHANGED" then commitmentAction="MAINTAIN"
        elseif selected.capability=="ESCALATE" then commitmentAction="SETTLE"
        elseif OuttaMyWay.ValueRecord.length(operationalPicture.commitmentContext)==0 then commitmentAction="CREATE"
        elseif selected.evidenceBasis.maintainsExistingCommitment==true then commitmentAction="MAINTAIN"
        else commitmentAction="REVISE" end
        nonIntervention={explicit=nonActuating[selected.capability]==true,classification=selected.capability}
        if portfolioChoice~=nil then
            explanation="Prospective Decision Portfolio compatibility policy selected the governing support group; local group policy then selected without lower-precedence Constraint fallback"
        else
            explanation=trafficPolicy~=nil and "Selected earliest supportable Traffic Policeman preference band after explicit earlier-band exhaustion, then minimum comparison cost within that band" or "Selected minimum-cost candidate after every mandatory verdict passed"
        end
    elseif #selectedUnresolved>0 then
        commitmentAction="WAIT"
        nonIntervention={explicit=true,classification="WAIT_FOR_EVIDENCE",unresolvedCandidateIds=selectedUnresolved,selectedGroupKey=portfolioChoice and portfolioChoice.groupKey or nil}
        explanation="No candidate in the selected governing support group passed every mandatory constraint; unresolved evidence remains and lower-precedence groups are not fallback"
    else
        commitmentAction="SETTLE"
        nonIntervention={explicit=true,classification="COMPLETE_SUPPORTABLE_SPACE_EXHAUSTED",selectedGroupKey=portfolioChoice and portfolioChoice.groupKey or nil}
        explanation=portfolioChoice~=nil and "Selected governing support group contains no admissible candidate; lower-precedence groups are intentionally not fallback" or "Complete supportable Candidate Action Space contains no admissible candidate"
    end

    local ranked={}
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(selectable) do ranked[#ranked+1]={candidateId=candidate.identity,comparisonCost=candidate.comparisonCost,capability=candidate.capability} end
    local localBasis=trafficPolicy and {rule=trafficPolicy.rule,governingRequirementKey=trafficPolicy.governingRequirementKey,rankedCandidates=trafficPolicy.ranked,blockedCandidates=trafficPolicy.blocked or {}} or {rule="MINIMUM_COMPARISON_COST_AFTER_MANDATORY_PASS",rankedCandidates=ranked}
    local comparisonBasis=localBasis
    if portfolioChoice~=nil then
        comparisonBasis={
            rule=OuttaMyWay.ProspectivePortfolioDecisionPolicy.KIND,selectedGroupKey=portfolioChoice.groupKey,selectedFamily=portfolioChoice.family,
            compatibilityRule=portfolioChoice.rule,compatibilityDetail=portfolioChoice.detail,lowerPrecedenceConstraintFallback=false,localSelection=localBasis
        }
    elseif portfolioSelectionMissing then
        comparisonBasis={rule=OuttaMyWay.ProspectivePortfolioDecisionPolicy.KIND,selection="UNRESOLVED",lowerPrecedenceConstraintFallback=false}
    end

    local record=OuttaMyWay.DecisionRecord.new({
        identity=self.identities:issue("DECISION"),
        epoch=self.epochs:next(),
        operationalPictureId=operationalPicture.identity,
        candidateInventoryId=candidateResult.inventory.identity,
        mandatoryVerdictSetId=verdictResult.set.identity,
        viableCandidateIds=viableIds,
        selectedCandidateId=selected and selected.identity or nil,
        nonIntervention=nonIntervention,
        comparisonBasis=comparisonBasis,
        commitmentAction=commitmentAction,
        explanation=explanation,
        provenance={source="DecisionSelector",operationalPictureId=operationalPicture.identity,candidateInventoryId=candidateResult.inventory.identity,verdictSetId=verdictResult.set.identity,prospectivePortfolio=portfolioChoice~=nil}
    })
    self.publishedCount=self.publishedCount+1
    return record
end

function Selector:getPublishedCount() return self.publishedCount end
