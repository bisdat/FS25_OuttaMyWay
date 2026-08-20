-- FS25_OuttaMyWay v4.7.105 TEST BUILD — D-0146 Step-2 purpose-specific
-- mechanical Representation Fitness.
--
-- Situation does not pre-classify passage capability by vehicle name.  Once an
-- Established Opposed Corridor Conflict exists, current cached assembly geometry
-- and configuration identity are enough to admit the pair to Candidate-owned
-- Local Passage Space search.  Actual Hold/optional-configuration/Reposition capability remains
-- a Control preflight responsibility and may still disprove the Passage
-- Presumption from Reality.

OuttaMyWay.PassageCapabilityAssessment={}
local Assessment=OuttaMyWay.PassageCapabilityAssessment

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end

local function footprintAvailable(item)
    if type(item)~="table" then return false,"CURRENT_PHYSICAL_SPACE_UNAVAILABLE" end
    if item.configurationProfileId==nil then return false,"CURRENT_CONFIGURATION_PROFILE_UNAVAILABLE" end
    if type(item.primitives)~="table" or OuttaMyWay.ValueRecord.length(item.primitives)<1 then return false,"CURRENT_PHYSICAL_PRIMITIVES_UNAVAILABLE" end
    local summary=item.summary or {}
    if (tonumber(summary.physicalPrimitiveCount) or 0)<1 then return false,"CURRENT_POSITIVE_PHYSICAL_PRIMITIVES_UNAVAILABLE" end
    return true,nil
end

local function record(conflict,motion,physical,assemblyId,otherAssemblyId)
    local m=motion[assemblyId]
    local p=physical[assemblyId]
    local ok,reason=footprintAvailable(p)
    return {
        representationId="d0146-step2-mechanical:"..tostring(conflict.identity)..":"..tostring(assemblyId),
        assemblyId=assemblyId,
        question="D0146_STEP2_OPTIONAL_CONFIGURATION_GUIDED_PASSAGE_MECHANICAL_PREFLIGHT",
        assessmentHorizon="CURRENT_ESTABLISHED_OPPOSED_CONFLICT_ONLY",
        state=ok and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED",
        claimPermissions=ok and {"D0146_STEP2_OPTIONAL_CONFIGURATION_GUIDED_PASSAGE_MECHANICAL_PREFLIGHT"} or {},
        coverage={complete=false,conservative=false,underApproximationRisk=true},
        uncertainty=ok and {
            "CONFIGURATION_REDUCTION_IS_OPTIONAL_AND_CONTROL_REVALIDATED_FROM_CURRENT_VEHICLE_REALITY",
            "GENERIC_NEGATIVE_CLEARANCE_AUTHORITY_NOT_CLAIMED",
            "BOUNDARY_ENCROACHMENT_REQUIRES_SEPARATE_POSITIVE_SUPPORT"
        } or {reason},
        validityDependencies={
            "CURRENT_OPERATIONAL_PICTURE","SAME_JOB_EPISODE","SAME_CONFIGURATION_PROFILE",
            "ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT","CURRENT_POSITIVE_PHYSICAL_PRIMITIVES"
        },
        evidence={
            conflictIdentity=conflict.identity,operationId=conflict.operationId,
            assemblyReferenceKey=m and m.assemblyReferenceKey or nil,jobToken=m and m.sourceJobToken or nil,
            otherAssemblyId=otherAssemblyId,configurationProfileId=p and p.configurationProfileId or nil,
            physicalPrimitiveCount=p and p.summary and p.summary.physicalPrimitiveCount or 0,
            physicalCoverageComplete=p and p.coverageComplete==true or false,
            negativeClearanceAuthority=p and p.negativeClearanceAuthority==true or false,
            controlProfile="D0146_OPTIONAL_CONFIGURATION_GUIDED_PASSAGE_V3",
            vehicleNameAdmissionGate=false,
            configurationReductionAuthority="CANDIDATE_OPTIONAL_CONTROL_PREFLIGHT_FROM_CURRENT_REALITY"
        },
        provenance={
            source="PassageCapabilityAssessment",layer="SITUATION_ASSESSMENT",
            authority="D0146_STEP2_PURPOSE_SPECIFIC_MECHANICAL_PREFLIGHT",
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
            result[#result+1]=record(conflict,motion,physical,aId,bId)
            result[#result+1]=record(conflict,motion,physical,bId,aId)
        end
    end
    table.sort(result,function(a,b) return tostring(a.representationId)<tostring(b.representationId) end)
    return result
end
