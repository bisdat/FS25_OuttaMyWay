--- Applies purpose-specific Native A8 Clearance Exclusion to conservative opposed-corridor Situation relationships.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`, `COOPERATIVE_PASSAGE`

OuttaMyWay.NativeA8ClearanceAssessment={}
local Assessment=OuttaMyWay.NativeA8ClearanceAssessment

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end

local function envelopeBounds(envelope)
    if type(envelope)~="table" or envelope.authority~="PASSAGE_NATIVE_A8_CLEARANCE_EXCLUSION" then
        return nil
    end
    local minRight,maxRight=tonumber(envelope.minRightM),tonumber(envelope.maxRightM)
    local minForward,maxForward=tonumber(envelope.minForwardM),tonumber(envelope.maxForwardM)
    if not finite(minRight) or not finite(maxRight)
        or not finite(minForward) or not finite(maxForward)
        or maxRight<=minRight or maxForward<=minForward then
        return nil
    end
    return {
        minRightM=minRight,maxRightM=maxRight,
        minForwardM=minForward,maxForwardM=maxForward
    }
end

local function spaceFrame(space)
    local occupancy=space and space.occupancy or nil
    local headingX,headingZ=tonumber(occupancy and occupancy.headingX),tonumber(occupancy and occupancy.headingZ)
    if not finite(headingX) or not finite(headingZ) then return nil end
    local length=math.sqrt(headingX*headingX+headingZ*headingZ)
    if length<=0.0001 then return nil end
    headingX,headingZ=headingX/length,headingZ/length
    return {
        forwardX=headingX,forwardZ=headingZ,
        rightX=headingZ,rightZ=-headingX
    }
end

local function projectedSupport(envelope,space,sharedRightX,sharedRightZ)
    local bounds=envelopeBounds(envelope)
    if bounds==nil then return nil,"MAXIMUM_PRODUCTIVE_A8_ENVELOPE_UNAVAILABLE" end
    local frame=spaceFrame(space)
    if frame==nil then return nil,"CURRENT_A8_FRAME_UNAVAILABLE" end

    local axisLength=math.sqrt(sharedRightX*sharedRightX+sharedRightZ*sharedRightZ)
    if not finite(axisLength) or axisLength<=0.0001 then
        return nil,"SHARED_LATERAL_AXIS_UNAVAILABLE"
    end
    sharedRightX,sharedRightZ=sharedRightX/axisLength,sharedRightZ/axisLength

    local minimum,maximum=nil,nil
    for _,corner in OuttaMyWay.ValueRecord.ipairs({
        {bounds.minRightM,bounds.minForwardM},
        {bounds.maxRightM,bounds.minForwardM},
        {bounds.maxRightM,bounds.maxForwardM},
        {bounds.minRightM,bounds.maxForwardM}
    }) do
        local worldX=frame.rightX*corner[1]+frame.forwardX*corner[2]
        local worldZ=frame.rightZ*corner[1]+frame.forwardZ*corner[2]
        local projected=worldX*sharedRightX+worldZ*sharedRightZ
        minimum=minimum==nil and projected or math.min(minimum,projected)
        maximum=maximum==nil and projected or math.max(maximum,projected)
    end
    return {minOffsetM=minimum,maxOffsetM=maximum},nil
end

local function evaluate(record,currentByAssembly,physicalByAssembly)
    local result={
        status="UNRESOLVED",
        positiveExclusion=false,
        reason="NATIVE_A8_CLEARANCE_EXCLUSION_NOT_ESTABLISHED",
        authority="NATIVE_A8_CLEARANCE_EXCLUSION",
        decisionAuthority=false,
        controlAuthority=false,
        negativeClearanceAuthority=false
    }

    if type(record)~="table" or record.classification~="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" then
        result.reason="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_NOT_CURRENT"
        return result
    end
    if record.subjectOperationMember~=true or record.otherOperationMember~=true then
        result.reason="PAIR_NOT_CURRENT_OPERATION_MEMBERS"
        return result
    end
    if record.subjectSettledContinuation~=true or record.otherSettledContinuation~=true then
        result.reason="SETTLED_NATIVE_A8_NOT_CURRENT_FOR_BOTH_PARTICIPANTS"
        return result
    end

    local overlap=record.supportedCorridorOverlap or {}
    local rightX,rightZ=tonumber(overlap.sharedRightX),tonumber(overlap.sharedRightZ)
    if not finite(rightX) or not finite(rightZ) then
        result.reason="SHARED_LATERAL_AXIS_UNAVAILABLE"
        return result
    end

    local aId,bId=record.subjectAssemblyId,record.otherAssemblyId
    local aSpace,bSpace=currentByAssembly[aId],currentByAssembly[bId]
    local aPhysical,bPhysical=physicalByAssembly[aId],physicalByAssembly[bId]
    local aEnvelope=aPhysical and aPhysical.maximumProductiveA8Envelope or nil
    local bEnvelope=bPhysical and bPhysical.maximumProductiveA8Envelope or nil

    local aSupport,aReason=projectedSupport(aEnvelope,aSpace,rightX,rightZ)
    if aSupport==nil then
        result.reason="SUBJECT_"..tostring(aReason)
        return result
    end
    local bSupport,bReason=projectedSupport(bEnvelope,bSpace,rightX,rightZ)
    if bSupport==nil then
        result.reason="OTHER_"..tostring(bReason)
        return result
    end

    local aX,aZ=tonumber(aSpace and aSpace.occupancy and aSpace.occupancy.x),
        tonumber(aSpace and aSpace.occupancy and aSpace.occupancy.z)
    local bX,bZ=tonumber(bSpace and bSpace.occupancy and bSpace.occupancy.x),
        tonumber(bSpace and bSpace.occupancy and bSpace.occupancy.z)
    if not finite(aX) or not finite(aZ) or not finite(bX) or not finite(bZ) then
        result.reason="CURRENT_A8_REFERENCE_POSITION_UNAVAILABLE"
        return result
    end

    local aCentre=aX*rightX+aZ*rightZ
    local bCentre=bX*rightX+bZ*rightZ
    local aMin,aMax=aCentre+aSupport.minOffsetM,aCentre+aSupport.maxOffsetM
    local bMin,bMax=bCentre+bSupport.minOffsetM,bCentre+bSupport.maxOffsetM

    local clearanceM
    if aMax<=bMin then
        clearanceM=bMin-aMax
    elseif bMax<=aMin then
        clearanceM=aMin-bMax
    else
        clearanceM=math.max(aMin,bMin)-math.min(aMax,bMax)
    end

    local nominal=OuttaMyWay.CooperativePassagePolicy
        and tonumber(OuttaMyWay.CooperativePassagePolicy.NOMINAL_INTER_ASSEMBLY_CLEARANCE_M) or nil
    if not finite(nominal) or nominal<=0 then
        result.reason="NOMINAL_PASSAGE_CLEARANCE_POLICY_UNAVAILABLE"
        return result
    end

    result.currentClearanceM=clearanceM
    result.nominalClearanceM=nominal
    result.clearanceReserveM=clearanceM-nominal
    result.subjectBandMinM=aMin
    result.subjectBandMaxM=aMax
    result.otherBandMinM=bMin
    result.otherBandMaxM=bMax
    result.subjectEnvelopeWidthM=aEnvelope.widthM
    result.otherEnvelopeWidthM=bEnvelope.widthM
    result.subjectEnvelopeBasis=aEnvelope.configurationBasis
    result.otherEnvelopeBasis=bEnvelope.configurationBasis

    if clearanceM>=nominal then
        result.status="SUPPORTED"
        result.positiveExclusion=true
        result.reason="MAXIMUM_PRODUCTIVE_A8_ENVELOPES_RETAIN_NOMINAL_NATIVE_CLEARANCE"
    else
        result.status="NOT_EXCLUDED"
        result.reason="MAXIMUM_PRODUCTIVE_A8_ENVELOPES_DO_NOT_PROVE_NOMINAL_NATIVE_CLEARANCE"
    end
    return result
end

function Assessment.apply(context)
    context=context or {}
    local currentByAssembly=byAssembly(context.currentSpace)
    local physicalByAssembly=byAssembly(context.physicalSpaceEvidence)
    local relationships=context.relationships or {}

    for _,record in OuttaMyWay.ValueRecord.ipairs(relationships) do
        local concern=record.subjectOperationMember==true
            and record.otherOperationMember==true
            and record.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT"
        record.passageConcernEstablished=concern

        local exclusion=evaluate(record,currentByAssembly,physicalByAssembly)
        record.nativeA8ClearanceExclusion=exclusion

        if concern and exclusion.positiveExclusion==true then
            record.passageEvaluationReady=false
            record.cooperativePassageEligible=false

            local action={}
            for key,value in OuttaMyWay.ValueRecord.pairs(record.actionSpaceConservation or {}) do
                action[key]=value
            end
            action.status="NOT_REQUIRED"
            action.supported=false
            action.reason="NATIVE_A8_CLEARANCE_EXCLUSION_DISCHARGES_PASSAGE_ACTION_SPACE"
            action.regulatedAssemblyId=nil
            action.protectedAssemblyId=nil
            action.excursionAssemblyId=nil
            action.roleBasis=nil
            action.controlMagnitude=nil
            record.actionSpaceConservation=action

            record.resolutionSpaceRelationship={
                status="POSITIVELY_DISSOLVED",
                positiveDissolution=true,
                reason="NATIVE_A8_CLEARANCE_EXCLUSION_POSITIVELY_DISSOLVES_PASSAGE_ACTION_SPACE",
                authority="NATIVE_A8_CLEARANCE_EXCLUSION",
                decisionAuthority=false,
                controlAuthority=false
            }
        else
            record.passageEvaluationReady=concern
            record.cooperativePassageEligible=concern
        end
    end
    return relationships
end

Assessment.evaluate=evaluate
