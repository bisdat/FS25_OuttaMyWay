--- Publishes each current Situation-owned Operational Picture to incumbent responsibility assessment.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

-- This adapter composes two existing Situation Assessment collaborators without
-- introducing a new semantic owner. It does not alter the Operational Picture.
-- It gives CurrentResponsibilityAssessment the exact current Situation
-- publication needed to interpret retained responsibilities without copying
-- Corner state into Responsibility Transition.
OuttaMyWay.CurrentResponsibilityContextSituationAssessment={}
local Assessment=OuttaMyWay.CurrentResponsibilityContextSituationAssessment
Assessment.__index=Assessment

function Assessment.new(delegate,currentResponsibilityAssessment)
    if delegate==nil or type(delegate.assess)~="function" then
        error("CurrentResponsibilityContextSituationAssessment requires a Situation Assessment delegate",2)
    end
    if currentResponsibilityAssessment==nil or type(currentResponsibilityAssessment.captureOperationalPicture)~="function" then
        error("CurrentResponsibilityContextSituationAssessment requires CurrentResponsibilityAssessment",2)
    end
    return setmetatable({delegate=delegate,currentResponsibilityAssessment=currentResponsibilityAssessment},Assessment)
end

function Assessment:assess(snapshot,episodeResult,operationResult)
    local picture=self.delegate:assess(snapshot,episodeResult,operationResult)
    self.currentResponsibilityAssessment:captureOperationalPicture(picture)
    return picture
end

function Assessment:resetSituationKnowledge()
    self.currentResponsibilityAssessment:clearOperationalPicture()
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
