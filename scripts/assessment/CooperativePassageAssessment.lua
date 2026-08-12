-- FS25_OuttaMyWay v4.7.99 CANONICAL CANDIDATE — existing bounded D-0143 TS015 Cooperative Passage assessment preserved under D-0146 architecture.
--
-- Situation-owned recognition for the first deliberately narrow production
-- authority envelope.  This module does not select an action and does not
-- actuate Control.  It answers only whether the current Operational Picture
-- positively matches the Condor/Patriot near-collinear TS015 case demonstrated
-- by P23.  Fixture bounds are calibration evidence, not general architecture.

OuttaMyWay.CooperativePassageAssessment = {}
local Assessment = OuttaMyWay.CooperativePassageAssessment

local function indexByAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end

local function physicalByAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end

local function footprintAvailable(item)
    if type(item)~="table" then return false,"BOOTSTRAP_CACHED_FOOTPRINT_UNAVAILABLE" end
    if item.configurationProfileId==nil then return false,"BOOTSTRAP_CACHED_CONFIGURATION_PROFILE_UNAVAILABLE" end
    if type(item.primitives)~="table" or #item.primitives<1 then return false,"BOOTSTRAP_CACHED_FOOTPRINT_PRIMITIVES_UNAVAILABLE" end
    local summary=item.summary or {}
    if (tonumber(summary.physicalPrimitiveCount) or 0)<1 then return false,"BOOTSTRAP_CACHED_PHYSICAL_PRIMITIVES_UNAVAILABLE" end
    return true,nil
end

local function purposeSpecificFitness(record,physical,assemblyId,referenceKey,jobToken,role)
    local representationId="d0143-ts015-cooperative-passage:"..tostring(record.encounterIdentity or record.pairReferenceKey)..":"..tostring(assemblyId)
    local item=physical[assemblyId]
    local available,reason=footprintAvailable(item)
    local summary=item and item.summary or {}
    return {
        representationId=representationId,assemblyId=assemblyId,
        question="D0143_TS015_COOPERATIVE_PASSAGE_EMPIRICAL_ADMISSIBILITY",
        assessmentHorizon="CURRENT_SUPPORTED_TS015_ENCOUNTER_ONLY",
        state=available and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED",
        claimPermissions=available and {"D0143_TS015_COOPERATIVE_PASSAGE_EMPIRICAL_ADMISSIBILITY"} or {},
        coverage={complete=false,conservative=false,underApproximationRisk=true},
        uncertainty=available and {"GENERAL_NEGATIVE_CLEARANCE_NOT_CLAIMED","ASYMMETRIC_GEOMETRY_OUT_OF_SCOPE"} or {reason or "BOOTSTRAP_CACHED_FOOTPRINT_UNAVAILABLE"},
        validityDependencies={"CURRENT_OPERATIONAL_PICTURE","SAME_JOB_EPISODE","SAME_CONFIGURATION_PROFILE","D0143_TS015_NEAR_COLLINEAR_SCOPE","BOOTSTRAP_CACHED_PLAN_VIEW_FOOTPRINT"},
        evidence={
            role=role,assemblyReferenceKey=referenceKey,jobToken=jobToken,
            episodeKey=item and item.episodeKey or nil,configurationProfileId=item and item.configurationProfileId or nil,
            physicalPrimitiveCount=summary and summary.physicalPrimitiveCount or 0,hullPointCount=summary and summary.hullPointCount or 0,
            footprintCoverageComplete=item and item.coverageComplete==true or false,negativeClearanceAuthority=item and item.negativeClearanceAuthority==true or false,
            geometryCalculation="NONE_REUSES_SITUATION_ASSESSMENT_PHYSICAL_SPACE_EVIDENCE"
        },
        provenance={source="CooperativePassageAssessment",layer="SITUATION_ASSESSMENT",authority="D0143_PURPOSE_SPECIFIC_FITNESS_FROM_BOOTSTRAP_CACHE",geometrySource=item and item.provenance or nil}
    }
end

local function encounterByInteraction(encounters)
    local result={}
    for _,encounter in OuttaMyWay.ValueRecord.ipairs(encounters or {}) do
        local key=encounter.evidence and encounter.evidence.interactionReferenceKey or nil
        if key~=nil then result[key]=encounter end
    end
    return result
end

local function normalize(x,z)
    local length=math.sqrt(x*x+z*z)
    if length<=0.0001 then return nil,nil end
    return x/length,z/length
end

local function dot(ax,az,bx,bz) return ax*bx+az*bz end

local function supportedPairNames(a,b)
    local an=tostring(a and a.name or "")
    local bn=tostring(b and b.name or "")
    if an=="Condor Endurance II" and bn=="Patriot 4450" then return a,b end
    if an=="Patriot 4450" and bn=="Condor Endurance II" then return b,a end
    return nil,nil
end

local function rejected(base,reason,extra)
    local record={
        status="UNSUPPORTED",
        reason=reason,
        authority="D0143_TS015_SCOPE_REJECTION",
        pairReferenceKey=base and base.pairReferenceKey or nil,
        encounterIdentity=base and base.encounterIdentity or nil,
        provenance={source="CooperativePassageAssessment",layer="SITUATION_ASSESSMENT",decisionAuthority=false,controlAuthority=false}
    }
    for key,value in OuttaMyWay.ValueRecord.pairs(extra or {}) do record[key]=value end
    return record
end

function Assessment.buildKnowledge(context)
    context=context or {}
    if OuttaMyWay.COOPERATIVE_PASSAGE_TS015_ENABLED~=true then return {} end
    local current=indexByAssembly(context.currentSpace)
    local motion=indexByAssembly(context.motionEvidence)
    local productive=indexByAssembly(context.productiveKnowledge)
    local physical=physicalByAssembly(context.physicalSpaceEvidence)
    local encounters=encounterByInteraction(context.encounters)
    local records,fitnessRecords={},{}

    for _,situation in OuttaMyWay.ValueRecord.ipairs(context.situations or {}) do
        local members=situation.memberAssemblyIds or {}
        for _,relationship in OuttaMyWay.ValueRecord.ipairs(situation.futureSpaceRelationships or {}) do
            if relationship.positiveIntersection==true then
                local subject=motion[relationship.subjectAssemblyId]
                local other=motion[relationship.otherAssemblyId]
                local condor,patriot=supportedPairNames(subject,other)
                if condor~=nil and patriot~=nil then
                    local encounter=encounters[relationship.interactionReferenceKey]
                    local base={pairReferenceKey=relationship.interactionReferenceKey,encounterIdentity=encounter and encounter.identity or nil}
                    if #members~=2 then
                        records[#records+1]=rejected(base,"TS015_REQUIRES_EXACTLY_TWO_ACTIVE_OPERATION_MEMBERS",{operationId=situation.operationId,memberCount=#members})
                    elseif encounter==nil or encounter.lifecycleState~="ACTIVE" then
                        records[#records+1]=rejected(base,"PAIR_NOT_ACTIVE_ENCOUNTER",{operationId=situation.operationId})
                    elseif encounter.evidence and encounter.evidence.currentSpaceIntersects==true then
                        records[#records+1]=rejected(base,"CURRENT_PHYSICAL_INTERACTION_ALREADY_BEGUN",{operationId=situation.operationId})
                    else
                        local condorSpace=current[condor.assemblyId]
                        local patriotSpace=current[patriot.assemblyId]
                        local condorProductive=productive[condor.assemblyId]
                        local patriotProductive=productive[patriot.assemblyId]
                        if condorSpace==nil or patriotSpace==nil or type(condorSpace.occupancy)~="table" or type(patriotSpace.occupancy)~="table" then
                            records[#records+1]=rejected(base,"CURRENT_SPACE_UNAVAILABLE",{operationId=situation.operationId})
                        elseif condor.localIntentClassification~="SETTLED_CONTINUATION" or patriot.localIntentClassification~="SETTLED_CONTINUATION" then
                            records[#records+1]=rejected(base,"PAIR_NOT_SETTLED_CONTINUATION",{operationId=situation.operationId})
                        elseif condorProductive==nil or condorProductive.productivePositive~=true or condorProductive.jobToken~=condor.sourceJobToken then
                            records[#records+1]=rejected(base,"CONDOR_PRODUCTIVE_CONTINUATION_NOT_POSITIVE",{operationId=situation.operationId})
                        elseif patriotProductive==nil or patriotProductive.productivePositive~=true or patriotProductive.jobToken~=patriot.sourceJobToken then
                            records[#records+1]=rejected(base,"PATRIOT_PRODUCTIVE_CONTINUATION_NOT_POSITIVE",{operationId=situation.operationId})
                        else
                            local co=condorSpace.occupancy
                            local po=patriotSpace.occupancy
                            local headingDot=nil
                            if tonumber(condor.headingX) and tonumber(condor.headingZ) and tonumber(patriot.headingX) and tonumber(patriot.headingZ) then
                                headingDot=dot(condor.headingX,condor.headingZ,patriot.headingX,patriot.headingZ)
                            end
                            local maximumDot=OuttaMyWay.COOPERATIVE_PASSAGE_TS015_MAX_HEADING_DOT or -0.99
                            local dx,dz=po.x-co.x,po.z-co.z
                            local separation=math.sqrt(dx*dx+dz*dz)
                            local axisX,axisZ=normalize(condor.headingX-patriot.headingX,condor.headingZ-patriot.headingZ)
                            if headingDot==nil or headingDot>maximumDot or axisX==nil then
                                records[#records+1]=rejected(base,"PAIR_HEADINGS_OUTSIDE_TS015_OPPOSED_SCOPE",{operationId=situation.operationId,headingDot=headingDot,maximumHeadingDot=maximumDot,separationM=separation})
                            else
                                local rightX,rightZ=axisZ,-axisX
                                local lateralSigned=dot(dx,dz,rightX,rightZ)
                                local lateral=math.abs(lateralSigned)
                                local condorAhead=dot(dx,dz,condor.headingX,condor.headingZ)
                                local patriotAhead=dot(-dx,-dz,patriot.headingX,patriot.headingZ)
                                local minSeparation=OuttaMyWay.COOPERATIVE_PASSAGE_TS015_MIN_START_SEPARATION_M or 50.0
                                local maxSeparation=OuttaMyWay.COOPERATIVE_PASSAGE_TS015_MAX_START_SEPARATION_M or 70.0
                                local maxLateral=OuttaMyWay.COOPERATIVE_PASSAGE_TS015_MAX_INITIAL_LATERAL_OFFSET_M or 2.0
                                if condorAhead<=0 or patriotAhead<=0 then
                                    records[#records+1]=rejected(base,"PAIR_NOT_MUTUALLY_FACING",{operationId=situation.operationId,separationM=separation,lateralOffsetM=lateral,headingDot=headingDot})
                                elseif separation>maxSeparation then
                                    records[#records+1]=rejected(base,"PAIR_NOT_YET_INSIDE_TS015_COMMITMENT_WINDOW",{operationId=situation.operationId,separationM=separation,minSeparationM=minSeparation,maxSeparationM=maxSeparation,lateralOffsetM=lateral,headingDot=headingDot})
                                elseif separation<minSeparation then
                                    records[#records+1]=rejected(base,"PAIR_TOO_CLOSE_FOR_PROVEN_TS015_ENTRY",{operationId=situation.operationId,separationM=separation,minSeparationM=minSeparation,maxSeparationM=maxSeparation,lateralOffsetM=lateral,headingDot=headingDot})
                                elseif lateral>maxLateral then
                                    records[#records+1]=rejected(base,"INITIAL_LATERAL_OFFSET_OUTSIDE_PROVEN_TS015_SCOPE",{operationId=situation.operationId,separationM=separation,lateralOffsetM=lateral,maxInitialLateralOffsetM=maxLateral,headingDot=headingDot})
                                else
                                    local condorFootprintOk,condorFootprintReason=footprintAvailable(physical[condor.assemblyId])
                                    local patriotFootprintOk,patriotFootprintReason=footprintAvailable(physical[patriot.assemblyId])
                                    if not condorFootprintOk or not patriotFootprintOk then
                                        records[#records+1]=rejected(base,"PURPOSE_SPECIFIC_FOOTPRINT_EVIDENCE_UNAVAILABLE",{
                                            operationId=situation.operationId,separationM=separation,lateralOffsetM=lateral,headingDot=headingDot,
                                            condorFootprintReason=condorFootprintReason,patriotFootprintReason=patriotFootprintReason
                                        })
                                    else
                                    local supportedRecord={
                                        status="SUPPORTED",
                                        reason="D0143_TS015_NEAR_COLLINEAR_COOPERATIVE_PASSAGE_SUPPORTED",
                                        authority="D0143_P23_EMPIRICALLY_BOUNDED_TS015",
                                        operationId=situation.operationId,
                                        pairReferenceKey=relationship.interactionReferenceKey,
                                        encounterIdentity=encounter.identity,
                                        assemblyIds={condor.assemblyId,patriot.assemblyId},
                                        condorAssemblyId=condor.assemblyId,
                                        patriotAssemblyId=patriot.assemblyId,
                                        condorReferenceKey=condor.assemblyReferenceKey,
                                        patriotReferenceKey=patriot.assemblyReferenceKey,
                                        condorJobToken=condor.sourceJobToken,
                                        patriotJobToken=patriot.sourceJobToken,
                                        condorName=condor.name,
                                        patriotName=patriot.name,
                                        separationM=separation,
                                        headingDot=headingDot,
                                        initialLateralOffsetM=lateral,
                                        initialLateralSignedM=lateralSigned,
                                        sharedAxisX=axisX,sharedAxisZ=axisZ,
                                        sharedRightX=rightX,sharedRightZ=rightZ,
                                        scope={
                                            vehiclePair="CONDOR_ENDURANCE_II__PATRIOT_4450",
                                            nearCollinear=true,
                                            minStartSeparationM=minSeparation,maxStartSeparationM=maxSeparation,
                                            maxInitialLateralOffsetM=maxLateral,maxHeadingDot=maximumDot,
                                            calibrationAuthority="P23_V4_7_92_TO_V4_7_94"
                                        },
                                        representationFitnessIds={
                                            "d0143-ts015-cooperative-passage:"..tostring(encounter.identity)..":"..tostring(condor.assemblyId),
                                            "d0143-ts015-cooperative-passage:"..tostring(encounter.identity)..":"..tostring(patriot.assemblyId)
                                        },
                                        footprintEvidence={
                                            source="SITUATION_ASSESSMENT_PHYSICAL_SPACE_EVIDENCE",
                                            condorConfigurationProfileId=physical[condor.assemblyId].configurationProfileId,
                                            patriotConfigurationProfileId=physical[patriot.assemblyId].configurationProfileId,
                                            noAdditionalGeometryCalculation=true
                                        },
                                        provenance={
                                            source="CooperativePassageAssessment",layer="SITUATION_ASSESSMENT",
                                            basis="D0143_CONFIGURATION_RELEASED_SPACE_AND_COOPERATIVE_PASSAGE",
                                            negativeClearanceAuthority=false,generalVehicleAuthority=false,
                                            decisionAuthority=false,controlAuthority=false
                                        }
                                    }
                                    records[#records+1]=supportedRecord
                                    fitnessRecords[#fitnessRecords+1]=purposeSpecificFitness(supportedRecord,physical,condor.assemblyId,condor.assemblyReferenceKey,condor.sourceJobToken,"CONDOR")
                                    fitnessRecords[#fitnessRecords+1]=purposeSpecificFitness(supportedRecord,physical,patriot.assemblyId,patriot.assemblyReferenceKey,patriot.sourceJobToken,"PATRIOT")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(records,function(a,b)
        if tostring(a.status)~=tostring(b.status) then return tostring(a.status)<tostring(b.status) end
        return tostring(a.pairReferenceKey)<tostring(b.pairReferenceKey)
    end)
    table.sort(fitnessRecords,function(a,b) return tostring(a.representationId)<tostring(b.representationId) end)
    return records,fitnessRecords
end
