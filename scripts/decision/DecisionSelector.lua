OuttaMyWay.DecisionSelector={}
local Selector=OuttaMyWay.DecisionSelector
Selector.__index=Selector
local nonActuating={CONTINUE_UNCHANGED=true,CONTINUE_OBSERVATION=true,ESCALATE=true}

local function sortedCopy(values)
    local result={}; for _,value in ipairs(values or {}) do result[#result+1]=value end; table.sort(result); return result
end
local function hasUnresolved(verdicts)
    for _,verdict in ipairs(verdicts) do if verdict.result=="UNRESOLVED" then return true end end
    return false
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
    for _,candidate in ipairs(candidateResult.candidates) do byCandidate[candidate.identity]={candidate=candidate,verdicts={}} end
    for _,verdict in ipairs(verdictResult.verdicts) do
        local entry=byCandidate[verdict.candidateId]
        if entry==nil then error("Constraint verdict references unknown candidate",2) end
        entry.verdicts[#entry.verdicts+1]=verdict
    end

    local viable={}
    local unresolvedCandidates={}
    for candidateId,entry in pairs(byCandidate) do
        if #entry.verdicts~=#verdictResult.set.mandatoryConstraintIds then error("candidate lacks a complete mandatory verdict set",2) end
        local pass=true
        for _,verdict in ipairs(entry.verdicts) do if verdict.result~="PASS" then pass=false end end
        if pass then viable[#viable+1]=entry.candidate
        elseif hasUnresolved(entry.verdicts) then unresolvedCandidates[#unresolvedCandidates+1]=candidateId end
    end
    table.sort(viable,function(a,b)
        if a.comparisonCost~=b.comparisonCost then return a.comparisonCost<b.comparisonCost end
        if a.capability~=b.capability then return a.capability<b.capability end
        return a.identity<b.identity
    end)
    table.sort(unresolvedCandidates)

    local viableIds={}; for _,candidate in ipairs(viable) do viableIds[#viableIds+1]=candidate.identity end
    local selected=viable[1]
    local commitmentAction
    local nonIntervention
    local explanation
    if selected~=nil then
        if selected.capability=="CONTINUE_OBSERVATION" then commitmentAction="WAIT"
        elseif selected.capability=="CONTINUE_UNCHANGED" then commitmentAction="MAINTAIN"
        elseif selected.capability=="ESCALATE" then commitmentAction="SETTLE"
        elseif #operationalPicture.commitmentContext==0 then commitmentAction="CREATE"
        elseif selected.evidenceBasis.maintainsExistingCommitment==true then commitmentAction="MAINTAIN"
        else commitmentAction="REVISE" end
        nonIntervention={explicit=nonActuating[selected.capability]==true,classification=selected.capability}
        explanation="Selected minimum-cost candidate after every mandatory verdict passed"
    elseif #unresolvedCandidates>0 then
        commitmentAction="WAIT"
        nonIntervention={explicit=true,classification="WAIT_FOR_EVIDENCE",unresolvedCandidateIds=unresolvedCandidates}
        explanation="No candidate passed every mandatory constraint; unresolved evidence remains"
    else
        commitmentAction="SETTLE"
        nonIntervention={explicit=true,classification="COMPLETE_SUPPORTABLE_SPACE_EXHAUSTED"}
        explanation="Complete supportable Candidate Action Space contains no admissible candidate"
    end

    local ranked={}
    for _,candidate in ipairs(viable) do ranked[#ranked+1]={candidateId=candidate.identity,comparisonCost=candidate.comparisonCost,capability=candidate.capability} end
    local record=OuttaMyWay.DecisionRecord.new({
        identity=self.identities:issue("DECISION"),
        epoch=self.epochs:next(),
        operationalPictureId=operationalPicture.identity,
        candidateInventoryId=candidateResult.inventory.identity,
        mandatoryVerdictSetId=verdictResult.set.identity,
        viableCandidateIds=viableIds,
        selectedCandidateId=selected and selected.identity or nil,
        nonIntervention=nonIntervention,
        comparisonBasis={rule="MINIMUM_COMPARISON_COST_AFTER_MANDATORY_PASS",rankedCandidates=ranked},
        commitmentAction=commitmentAction,
        explanation=explanation,
        provenance={source="DecisionSelector",operationalPictureId=operationalPicture.identity,candidateInventoryId=candidateResult.inventory.identity,verdictSetId=verdictResult.set.identity}
    })
    self.publishedCount=self.publishedCount+1
    return record
end

function Selector:getPublishedCount() return self.publishedCount end
