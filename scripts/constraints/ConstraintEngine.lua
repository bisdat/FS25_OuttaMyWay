OuttaMyWay.ConstraintEngine={}
local Engine=OuttaMyWay.ConstraintEngine
Engine.__index=Engine

local evaluatorNames={
    "FieldWorldContainmentConstraint",
    "TransitionClearanceConstraint",
    "RepresentationFitnessConstraint",
    "CapabilityAvailabilityConstraint",
    "ContinuingIntentPriorityConstraint",
    "ProgressPreservationConstraint",
    "ResponsibilityCompatibilityConstraint",
    "ObligationCompatibilityConstraint",
    "CommitmentPreconditionsConstraint",
    "EffectiveActuationCompositionConstraint",
    "ReleaseSafetyConstraint"
}

function Engine.new(identityRegistry,epochSequence)
    local evaluators={}
    for _,name in ipairs(evaluatorNames) do
        local evaluator=OuttaMyWay[name]
        if evaluator==nil then error("missing constraint evaluator " .. name,2) end
        evaluators[#evaluators+1]=evaluator
    end
    return setmetatable({identities=identityRegistry,epochs=epochSequence,evaluators=evaluators,publishedCount=0},Engine)
end

function Engine:evaluate(operationalPicture,candidateResult)
    OuttaMyWay.ValueRecord.assertType(operationalPicture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(candidateResult.inventory,"CandidateInventory")
    if candidateResult.inventory.operationalPictureId~=operationalPicture.identity then
        error("Candidate inventory belongs to a different Operational Picture",2)
    end
    local verdicts={}
    local verdictIds={}
    local constraintIds={}
    for _,evaluator in ipairs(self.evaluators) do constraintIds[#constraintIds+1]=evaluator.id end
    for _,candidate in ipairs(candidateResult.candidates) do
        OuttaMyWay.ValueRecord.assertType(candidate,"CandidateAction")
        for _,evaluator in ipairs(self.evaluators) do
            local outcome=evaluator.evaluate(candidate,operationalPicture)
            local verdict=OuttaMyWay.ConstraintVerdict.new({
                identity=self.identities:issue("VERDICT"),
                epoch=self.epochs:next(),
                constraintId=evaluator.id,
                evaluator=evaluator.owner,
                candidateId=candidate.identity,
                result=outcome.result,
                mandatory=true,
                evidence=outcome.evidence or {},
                provenance=outcome.provenance or {},
                reason=outcome.reason,
                revalidationTrigger=outcome.revalidationTrigger or {}
            })
            verdicts[#verdicts+1]=verdict
            verdictIds[#verdictIds+1]=verdict.identity
        end
    end
    local set=OuttaMyWay.ConstraintVerdictSet.new({
        identity=self.identities:issue("VERDICT_SET"),
        epoch=self.epochs:next(),
        operationalPictureId=operationalPicture.identity,
        candidateInventoryId=candidateResult.inventory.identity,
        verdictIds=verdictIds,
        mandatoryConstraintIds=constraintIds,
        complete=true,
        provenance={source="ConstraintEngine",operationalPictureId=operationalPicture.identity,candidateInventoryId=candidateResult.inventory.identity}
    })
    self.publishedCount=self.publishedCount+1
    return {set=set,verdicts=verdicts}
end

function Engine:getPublishedCount() return self.publishedCount end
