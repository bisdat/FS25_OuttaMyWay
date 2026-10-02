--- Interprets causal player-command Observation into retained Player Actuation Claim Situation knowledge.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

OuttaMyWay.PlayerActuationClaimAssessment={}
local Assessment=OuttaMyWay.PlayerActuationClaimAssessment
Assessment.__index=Assessment

local publication=OuttaMyWay.LogPublication.origin("SITUATION_ASSESSMENT")
local function logInfo(code,formatText,...)
    return publication:info("DEBUG",code,formatText,...)
end

local function sortedKeys(values)
    local result={}
    for key in OuttaMyWay.ValueRecord.pairs(values or {}) do result[#result+1]=key end
    table.sort(result)
    return result
end

function Assessment.new()
    return setmetatable({claimsByReference={},consumedSequenceByReference={}},Assessment)
end

function Assessment:reset()
    self.claimsByReference={}
    self.consumedSequenceByReference={}
end

function Assessment:isClaimedReference(referenceKey)
    local claim=self.claimsByReference[referenceKey]
    return claim~=nil and claim.current==true
end

function Assessment:assess(snapshot)
    local knowledge={}
    local currentControls=snapshot and snapshot.playerControl or {}
    local references={}
    for referenceKey,_ in OuttaMyWay.ValueRecord.pairs(currentControls) do references[referenceKey]=true end
    for referenceKey,_ in OuttaMyWay.ValueRecord.pairs(self.claimsByReference) do references[referenceKey]=true end

    for _,referenceKey in OuttaMyWay.ValueRecord.ipairs(sortedKeys(references)) do
        local control=currentControls[referenceKey]
        local controlled=type(control)=="table" and control.playerControlled==true
        local action=type(control)=="table" and control.latestCausalAction or nil
        local sequence=type(action)=="table" and tonumber(action.sequence) or nil
        local consumed=tonumber(self.consumedSequenceByReference[referenceKey]) or 0
        local claim=self.claimsByReference[referenceKey]

        if sequence~=nil and sequence>consumed then
            self.consumedSequenceByReference[referenceKey]=sequence
            if controlled then
                local established=claim==nil or claim.current~=true
                claim={
                    current=true,
                    assemblyReferenceKey=referenceKey,
                    establishedSequence=established and sequence or claim.establishedSequence,
                    latestSequence=sequence,
                    establishedAction=established and action.action or claim.establishedAction,
                    latestAction=action.action,
                    establishedObservationSnapshotId=established and snapshot.identity or claim.establishedObservationSnapshotId,
                    latestObservationSnapshotId=snapshot.identity,
                    provenance={source="PlayerActuationClaimAssessment",authority="PLAYER_ACTUATION_CLAIM"}
                }
                self.claimsByReference[referenceKey]=claim
                if established then
                    logInfo("PLAYER_ACTUATION_CLAIM_ESTABLISHED","ref=%s sequence=%s action=%s",
                        tostring(referenceKey),tostring(sequence),tostring(action.action))
                end
            end
        end

        claim=self.claimsByReference[referenceKey]
        if claim~=nil and claim.current==true and not controlled then
            logInfo("PLAYER_ACTUATION_CLAIM_RELEASED","ref=%s establishedSequence=%s latestSequence=%s reason=PLAYER_CONTROL_RELEASED",
                tostring(referenceKey),tostring(claim.establishedSequence),tostring(claim.latestSequence))
            self.claimsByReference[referenceKey]=nil
            claim=nil
        end

        if claim~=nil and claim.current==true then
            knowledge[#knowledge+1]={
                assemblyReferenceKey=referenceKey,
                current=true,
                establishedSequence=claim.establishedSequence,
                latestSequence=claim.latestSequence,
                establishedAction=claim.establishedAction,
                latestAction=claim.latestAction,
                retainedByCurrentPlayerControl=controlled,
                provenance=claim.provenance
            }
        end
    end

    table.sort(knowledge,function(a,b) return tostring(a.assemblyReferenceKey)<tostring(b.assemblyReferenceKey) end)
    return knowledge
end

function Assessment:claimedMap(knowledge)
    local result={}
    for _,claim in OuttaMyWay.ValueRecord.ipairs(knowledge or {}) do
        if claim.current==true then result[claim.assemblyReferenceKey]=claim end
    end
    return result
end
