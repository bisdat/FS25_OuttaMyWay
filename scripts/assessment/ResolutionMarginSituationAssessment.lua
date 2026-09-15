--- Composes Resolution-Margin Demand evidence into the authoritative Situation-owned Operational Picture before publication.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

-- This decorator remains entirely inside Situation Assessment. It preserves the
-- delegate picture identity/epoch and enriches only Situation-owned knowledge;
-- Candidate, Decision, Responsibility, Bounded Authority and Control are not
-- invoked or changed here.
OuttaMyWay.ResolutionMarginSituationAssessment={}
local Assessment=OuttaMyWay.ResolutionMarginSituationAssessment
Assessment.__index=Assessment

function Assessment.new(delegate)
    if delegate==nil or type(delegate.assess)~="function" then error("ResolutionMarginSituationAssessment requires a Situation Assessment delegate",2) end
    return setmetatable({delegate=delegate},Assessment)
end

function Assessment:assess(snapshot,episodeResult,operationResult)
    local picture=self.delegate:assess(snapshot,episodeResult,operationResult)
    local knowledge=OuttaMyWay.ResolutionMarginDemandAssessment.assess({
        observationSnapshotId=picture.observationSnapshotId,
        situations=picture.situations,
        currentSpace=picture.currentSpace,
        futureSpace=picture.futureSpace,
        demand=picture.demand,
        motionEvidence=picture.motionEvidence,
        physicalSpaceEvidence=picture.physicalSpaceEvidence,
        representationFitness=picture.representationFitness
    })
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.resolutionMarginDemandKnowledge=knowledge
    return OuttaMyWay.OperationalPicture.new(values)
end

function Assessment:resetSituationKnowledge()
    if type(self.delegate.resetSituationKnowledge)=="function" then return self.delegate:resetSituationKnowledge() end
end

function Assessment:getEvidence(referenceKeyValue,jobToken)
    if type(self.delegate.getEvidence)=="function" then return self.delegate:getEvidence(referenceKeyValue,jobToken) end
    return nil
end

function Assessment:getPublishedCount()
    if type(self.delegate.getPublishedCount)=="function" then return self.delegate:getPublishedCount() end
    return 0
end
