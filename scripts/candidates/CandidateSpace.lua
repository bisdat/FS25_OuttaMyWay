OuttaMyWay.CandidateSpace = {}
local CandidateSpace=OuttaMyWay.CandidateSpace
CandidateSpace.__index=CandidateSpace

local requiredSpecificationFields={
    "referenceKey","purpose","subject","capability","expectedEffect","evidenceBasis","representationFitness",
    "preconditions","invalidationConditions","reversibility","obligationsCreated","releaseImplications","uncertainty","comparisonCost"
}

local function requireSpecification(specification)
    if type(specification)~="table" then error("Candidate specification must be a table",3) end
    for _,field in OuttaMyWay.ValueRecord.ipairs(requiredSpecificationFields) do
        if specification[field]==nil then error("Candidate specification missing " .. field,3) end
    end
    if type(specification.referenceKey)~="string" or specification.referenceKey=="" then
        error("Candidate specification referenceKey must be a non-empty string",3)
    end
end

-- Candidate support may still carry transitional planning packets that predate
-- Phase 13. Their evidence remains useful, but PASS/FAIL/UNRESOLVED and
-- applicability are Constraint conclusions and must not cross the canonical
-- CandidateAction boundary.
local function candidateEvidenceBasis(specification)
    local source=specification.evidenceBasis or {}
    local result={}
    for key,value in OuttaMyWay.ValueRecord.pairs(source) do
        if key~="constraintEvidence" then result[key]=value end
    end

    local legacy=source.constraintEvidence
    if type(legacy)=="table" then
        local planning={}
        local count=0
        for constraintId,packet in OuttaMyWay.ValueRecord.pairs(legacy) do
            if type(packet)=="table" then
                planning[constraintId]={
                    evidence=packet.evidence or {},
                    reason=packet.reason,
                    provenance=packet.provenance or {},
                    revalidationTrigger=packet.revalidationTrigger or {}
                }
                count=count+1
            end
        end
        if count>0 then result.candidatePlanningEvidence=planning end
    end
    return result
end

function CandidateSpace.new(identityRegistry,epochSequence)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,publishedCount=0},CandidateSpace)
end

function CandidateSpace:generate(operationalPicture)
    OuttaMyWay.ValueRecord.assertType(operationalPicture,"OperationalPicture")
    local support=operationalPicture.candidateSupportEvidence
    if type(support)~="table" or support.complete~=true then
        error("Candidate Action Space requires explicit complete support-boundary evidence",2)
    end
    if type(support.supportBoundary)~="table" then
        error("Candidate Action Space requires supportBoundary",2)
    end
    local specifications={}
    local seen={}
    for _,specification in OuttaMyWay.ValueRecord.ipairs(support.candidateSpecifications or {}) do
        requireSpecification(specification)
        if seen[specification.referenceKey] then error("duplicate candidate referenceKey " .. specification.referenceKey,2) end
        seen[specification.referenceKey]=true
        specifications[#specifications+1]=specification
    end
    table.sort(specifications,function(a,b) return a.referenceKey < b.referenceKey end)

    local candidates={}
    local candidateIds={}
    for _,specification in OuttaMyWay.ValueRecord.ipairs(specifications) do
        local candidate=OuttaMyWay.CandidateAction.new({
            identity=self.identities:issue("CANDIDATE"),
            epoch=self.epochs:next(),
            purpose=specification.purpose,
            subject=specification.subject,
            capability=specification.capability,
            expectedEffect=specification.expectedEffect,
            evidenceBasis=candidateEvidenceBasis(specification),
            representationFitness=specification.representationFitness,
            preconditions=specification.preconditions,
            invalidationConditions=specification.invalidationConditions,
            reversibility=specification.reversibility,
            obligationsCreated=specification.obligationsCreated,
            releaseImplications=specification.releaseImplications,
            uncertainty=specification.uncertainty,
            comparisonCost=specification.comparisonCost
        })
        candidates[#candidates+1]=candidate
        candidateIds[#candidateIds+1]=candidate.identity
    end

    local inventory=OuttaMyWay.CandidateInventory.new({
        identity=self.identities:issue("CANDIDATE_INVENTORY"),
        epoch=self.epochs:next(),
        operationalPictureId=operationalPicture.identity,
        candidateIds=candidateIds,
        complete=true,
        supportBoundary=support.supportBoundary,
        provenance={source="CandidateSpace",operationalPictureId=operationalPicture.identity,supportProvenance=support.provenance}
    })
    self.publishedCount=self.publishedCount+1
    return {inventory=inventory,candidates=candidates}
end

function CandidateSpace:getPublishedCount() return self.publishedCount end
