-- FS25_OuttaMyWay v4.7.101 TEST BUILD — D-0146 Step-2 purpose-specific
-- mechanical Representation Fitness.
--
-- This module does not choose a Passage Arrangement or Passage Guide.  It only
-- states whether the current pair has the already-demonstrated compact/hold/
-- forward-reposition mechanical profile available to a later Candidate-owned
-- D-0146 passage search.  General vehicle authority is deliberately not
-- inferred from the P23 Condor/Patriot evidence.

OuttaMyWay.PassageCapabilityAssessment={}
local Assessment=OuttaMyWay.PassageCapabilityAssessment

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end

local function supportedPair(a,b)
    local an=tostring(a and a.name or "")
    local bn=tostring(b and b.name or "")
    return (an=="Condor Endurance II" and bn=="Patriot 4450") or
           (an=="Patriot 4450" and bn=="Condor Endurance II")
end

local function footprintAvailable(item)
    if type(item)~="table" then return false,"CURRENT_PHYSICAL_SPACE_UNAVAILABLE" end
    if item.configurationProfileId==nil then return false,"CURRENT_CONFIGURATION_PROFILE_UNAVAILABLE" end
    if type(item.primitives)~="table" or #item.primitives<1 then return false,"CURRENT_PHYSICAL_PRIMITIVES_UNAVAILABLE" end
    local summary=item.summary or {}
    if (tonumber(summary.physicalPrimitiveCount) or 0)<1 then return false,"CURRENT_POSITIVE_PHYSICAL_PRIMITIVES_UNAVAILABLE" end
    return true,nil
end

local function record(conflict,motion,physical,assemblyId,otherAssemblyId)
    local m=motion[assemblyId]
    local p=physical[assemblyId]
    local ok,reason=footprintAvailable(p)
    return {
        representationId="d0146-step2-p23-mechanical:"..tostring(conflict.identity)..":"..tostring(assemblyId),
        assemblyId=assemblyId,
        question="D0146_STEP2_P23_COMPACT_GUIDED_PASSAGE_MECHANICAL_SUPPORT",
        assessmentHorizon="CURRENT_ESTABLISHED_OPPOSED_CONFLICT_ONLY",
        state=ok and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED",
        claimPermissions=ok and {"D0146_STEP2_P23_COMPACT_GUIDED_PASSAGE_MECHANICAL_SUPPORT"} or {},
        coverage={complete=false,conservative=false,underApproximationRisk=true},
        uncertainty=ok and {
            "GENERAL_VEHICLE_AUTHORITY_NOT_CLAIMED",
            "GENERIC_NEGATIVE_CLEARANCE_AUTHORITY_NOT_CLAIMED",
            "BOUNDARY_ENCROACHMENT_REQUIRES_SEPARATE_POSITIVE_SUPPORT"
        } or {reason},
        validityDependencies={
            "CURRENT_OPERATIONAL_PICTURE","SAME_JOB_EPISODE","SAME_CONFIGURATION_PROFILE",
            "ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT","P23_CONDOR_PATRIOT_MECHANICAL_PROFILE"
        },
        evidence={
            conflictIdentity=conflict.identity,operationId=conflict.operationId,
            assemblyReferenceKey=m and m.assemblyReferenceKey or nil,jobToken=m and m.sourceJobToken or nil,
            otherAssemblyId=otherAssemblyId,configurationProfileId=p and p.configurationProfileId or nil,
            physicalPrimitiveCount=p and p.summary and p.summary.physicalPrimitiveCount or 0,
            controlProfile="D0146_P23_COMPACT_GUIDED_PASSAGE_V1",
            pairSpecificMechanicalCalibration=true
        },
        provenance={
            source="PassageCapabilityAssessment",layer="SITUATION_ASSESSMENT",
            authority="D0146_STEP2_PURPOSE_SPECIFIC_MECHANICAL_FITNESS",
            decisionAuthority=false,controlAuthority=false,generalVehicleAuthority=false,
            negativeClearanceAuthority=false
        }
    }
end

function Assessment.buildFitness(context)
    context=context or {}
    local motion=byAssembly(context.motionEvidence)
    local physical=byAssembly(context.physicalSpaceEvidence)
    local result={}
    for _,conflict in OuttaMyWay.ValueRecord.ipairs(context.opposedCorridorKnowledge or {}) do
        if conflict.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" then
            local aId,bId=conflict.subjectAssemblyId,conflict.otherAssemblyId
            local a,b=motion[aId],motion[bId]
            if supportedPair(a,b) then
                result[#result+1]=record(conflict,motion,physical,aId,bId)
                result[#result+1]=record(conflict,motion,physical,bId,aId)
            end
        end
    end
    table.sort(result,function(a,b) return tostring(a.representationId)<tostring(b.representationId) end)
    return result
end
