OuttaMyWay.CausalObstructionAssessment = {}
local Assessment = OuttaMyWay.CausalObstructionAssessment
Assessment.__index = Assessment

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][CAUSAL-OBSTRUCTION] %s",message)
    else
        print("[FS25_OuttaMyWay][CAUSAL-OBSTRUCTION] "..message)
    end
end

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function physicalByAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        result[item.assemblyId]=item
    end
    return result
end

local function futureByAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        result[item.assemblyId]=item
    end
    return result
end

local function referencesByAssembly(snapshot)
    local result={}
    for _,assembly in OuttaMyWay.ValueRecord.ipairs(snapshot and snapshot.assemblies or {}) do
        result[assembly.assemblyId]=assembly.referenceKey
    end
    return result
end

local function jobEpisodesByAssembly(jobEpisodes)
    local active,ended={},{}
    for _,episode in OuttaMyWay.ValueRecord.ipairs(jobEpisodes and jobEpisodes:list() or {}) do
        if episode.status=="ACTIVE" then
            active[episode.assemblyId]=episode
        elseif episode.status=="ENDED" then
            local current=ended[episode.assemblyId]
            local currentEpoch=current and tonumber(current.endedEpoch) or -math.huge
            local candidateEpoch=tonumber(episode.endedEpoch) or -math.huge
            if current==nil or candidateEpoch>=currentEpoch then ended[episode.assemblyId]=episode end
        end
    end
    return active,ended
end

local function pointSegmentDistance(px,pz,ax,az,bx,bz)
    local vx,vz=bx-ax,bz-az
    local denom=vx*vx+vz*vz
    local t=denom>0 and (((px-ax)*vx+(pz-az)*vz)/denom) or 0
    t=math.max(0,math.min(1,t))
    local qx,qz=ax+t*vx,az+t*vz
    local dx,dz=px-qx,pz-qz
    return math.sqrt(dx*dx+dz*dz),t,qx,qz
end

local function currentOverlap(blockerPhysical,beneficiaryPhysical)
    if blockerPhysical==nil or beneficiaryPhysical==nil then return nil end
    local result=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap(
        {worldPrimitives=blockerPhysical.primitives},
        {worldPrimitives=beneficiaryPhysical.primitives}
    )
    if result and result.current==true then
        return {
            kind="CURRENT_PHYSICAL_OCCUPANCY",
            distance=result.distance,
            required=result.required,
            blockerPrimitiveId=result.subjectPrimitiveId,
            beneficiaryPrimitiveId=result.otherPrimitiveId,
            authority="POSITIVE_CONFLICT_SUPPORT_ONLY"
        }
    end
    return nil
end

local function futureSweepConflict(blockerPhysical,beneficiaryPhysical,beneficiaryFuture)
    local alternative=beneficiaryFuture
        and beneficiaryFuture.alternatives
        and beneficiaryFuture.alternatives[1]
        or nil
    if alternative==nil
        or not finite(alternative.startX) or not finite(alternative.startZ)
        or not finite(alternative.endX) or not finite(alternative.endZ) then
        return nil
    end

    for _,blockerPrimitive in OuttaMyWay.ValueRecord.ipairs(blockerPhysical and blockerPhysical.primitives or {}) do
        if blockerPrimitive.kind=="DISC"
            and blockerPrimitive.positiveConflictSupport==true
            and finite(blockerPrimitive.x) and finite(blockerPrimitive.z)
            and finite(blockerPrimitive.radius) then
            for _,beneficiaryPrimitive in OuttaMyWay.ValueRecord.ipairs(beneficiaryPhysical and beneficiaryPhysical.primitives or {}) do
                if beneficiaryPrimitive.kind=="DISC"
                    and beneficiaryPrimitive.positiveConflictSupport==true
                    and finite(beneficiaryPrimitive.x) and finite(beneficiaryPrimitive.z)
                    and finite(beneficiaryPrimitive.radius) then
                    local offsetX=beneficiaryPrimitive.x-alternative.startX
                    local offsetZ=beneficiaryPrimitive.z-alternative.startZ
                    local ax,az=alternative.startX+offsetX,alternative.startZ+offsetZ
                    local bx,bz=alternative.endX+offsetX,alternative.endZ+offsetZ
                    local distance,t,qx,qz=pointSegmentDistance(
                        blockerPrimitive.x,blockerPrimitive.z,ax,az,bx,bz
                    )
                    local required=blockerPrimitive.radius+beneficiaryPrimitive.radius
                    if distance<=required then
                        return {
                            kind="CONTINUING_ACTIVE_FUTURE_SPACE",
                            distance=distance,
                            required=required,
                            blockerPrimitiveId=blockerPrimitive.identity,
                            beneficiaryPrimitiveId=beneficiaryPrimitive.identity,
                            segmentFraction=t,
                            closestX=qx,
                            closestZ=qz,
                            authority="POSITIVE_CONFLICT_SUPPORT_ONLY"
                        }
                    end
                end
            end
        end
    end
    return nil
end

local function positiveObstruction(blockerPhysical,beneficiaryPhysical,beneficiaryFuture)
    local current=currentOverlap(blockerPhysical,beneficiaryPhysical)
    if current~=nil then return current end
    return futureSweepConflict(blockerPhysical,beneficiaryPhysical,beneficiaryFuture)
end

local function sortedKeys(map)
    local result={}
    for key in OuttaMyWay.ValueRecord.pairs(map or {}) do result[#result+1]=key end
    table.sort(result)
    return result
end

function Assessment.new(jobEpisodes)
    return setmetatable({jobEpisodes=jobEpisodes,lastSignature=nil},Assessment)
end

function Assessment:reset()
    self.lastSignature=nil
end

function Assessment:assess(snapshot,futureSpace,physicalSpaceEvidence,activeOperationMemberSet,operationByAssembly)
    local physical=physicalByAssembly(physicalSpaceEvidence)
    local future=futureByAssembly(futureSpace)
    local references=referencesByAssembly(snapshot)
    local activeEpisodes,endedEpisodes=jobEpisodesByAssembly(self.jobEpisodes)
    local records={}

    for _,beneficiaryAssemblyId in OuttaMyWay.ValueRecord.ipairs(sortedKeys(activeOperationMemberSet)) do
        local beneficiaryPhysical=physical[beneficiaryAssemblyId]
        local beneficiaryFuture=future[beneficiaryAssemblyId]
        if beneficiaryPhysical~=nil then
            for _,blockerAssemblyId in OuttaMyWay.ValueRecord.ipairs(sortedKeys(physical)) do
                if blockerAssemblyId~=beneficiaryAssemblyId then
                    local evidence=positiveObstruction(
                        physical[blockerAssemblyId],
                        beneficiaryPhysical,
                        beneficiaryFuture
                    )
                    if evidence~=nil then
                        local blockerReferenceKey=references[blockerAssemblyId]
                        local beneficiaryReferenceKey=references[beneficiaryAssemblyId]
                        local aiState=blockerReferenceKey
                            and snapshot.aiStates
                            and snapshot.aiStates[blockerReferenceKey]
                            or nil
                        local player=blockerReferenceKey
                            and snapshot.playerControl
                            and snapshot.playerControl[blockerReferenceKey]
                            or nil
                        local activeEpisode=activeEpisodes[blockerAssemblyId]
                        local endedEpisode=endedEpisodes[blockerAssemblyId]
                        local currentAiPositive=type(aiState)=="table"
                            and (aiState.observedActive==true
                                or (aiState.aiActiveObserved==true and aiState.aiActive==true))
                        local currentAiInactiveObserved=type(aiState)=="table"
                            and aiState.aiActiveObserved==true
                            and aiState.aiActive~=true
                        local nonActiveActivityResolved=endedEpisode~=nil or currentAiInactiveObserved

                        local classification
                        local relocationEligible=false
                        if activeEpisode~=nil then
                            classification="ACTIVE_GIANTS_AI"
                        elseif currentAiPositive then
                            -- Current positive GIANTS activity outranks any older ENDED
                            -- Episode while fresh Job Episode admission catches up.
                            classification="GIANTS_AI_ACTIVE_UNRESOLVED"
                        elseif not nonActiveActivityResolved then
                            classification="ACTIVITY_UNRESOLVED"
                        elseif type(player)~="table" or player.playerEnteredObserved~=true then
                            classification="PLAYER_CLAIM_UNRESOLVED"
                        elseif player.playerEntered==true then
                            classification="NON_ACTIVE_PLAYER_CLAIMED"
                        else
                            classification="NON_ACTIVE_UNCLAIMED"
                            relocationEligible=true
                        end

                        local operationId=operationByAssembly and operationByAssembly[beneficiaryAssemblyId] or nil
                        records[#records+1]={
                            identity="causal-obstruction:"
                                ..tostring(operationId or "no-operation")..":"
                                ..tostring(blockerAssemblyId).."->"..tostring(beneficiaryAssemblyId),
                            operationId=operationId,
                            blockerAssemblyId=blockerAssemblyId,
                            blockerAssemblyReferenceKey=blockerReferenceKey,
                            beneficiaryAssemblyId=beneficiaryAssemblyId,
                            beneficiaryAssemblyReferenceKey=beneficiaryReferenceKey,
                            blockerClassification=classification,
                            relocationEligible=relocationEligible,
                            activeBlockerJobEpisodeId=activeEpisode and activeEpisode.identity or nil,
                            endedBlockerJobEpisodeId=endedEpisode and endedEpisode.identity or nil,
                            activityEvidence={
                                aiActive=type(aiState)=="table" and aiState.aiActive==true or false,
                                aiActiveObserved=type(aiState)=="table" and aiState.aiActiveObserved==true or false,
                                activeJobVehicleMembership=type(aiState)=="table" and aiState.observedActive==true or false,
                                qualifyingJobEpisodeId=activeEpisode and activeEpisode.identity or nil,
                                endedJobEpisodeId=endedEpisode and endedEpisode.identity or nil,
                                nonActiveResolvedBy=endedEpisode~=nil and "ENDED_JOB_EPISODE"
                                    or (currentAiInactiveObserved and "CURRENT_GIANTS_INACTIVITY_OBSERVATION" or nil),
                                source="JobEpisodeAdmission+ObservationSnapshot.aiStates"
                            },
                            playerClaimEvidence={
                                playerEntered=type(player)=="table" and player.playerEntered==true or false,
                                playerEnteredObserved=type(player)=="table" and player.playerEnteredObserved==true or false,
                                source="ObservationSnapshot.playerControl"
                            },
                            obstructionEvidence=evidence,
                            provenance={
                                source="CausalObstructionAssessment",
                                authority="CURRENT_POSITIVE_CAUSAL_OBSTRUCTION",
                                historicalJobProvenanceRequired=false,
                                endedJobEpisodeMayResolveNonActiveActivity=true,
                                currentQualifyingJobEpisodeRequiredForActiveSpatialNegotiation=true,
                                nativeBlockedRequired=false
                            }
                        }
                    end
                end
            end
        end
    end

    table.sort(records,function(a,b) return tostring(a.identity)<tostring(b.identity) end)

    local signatureParts={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(records) do
        signatureParts[#signatureParts+1]=table.concat({
            tostring(record.identity),
            tostring(record.blockerClassification),
            tostring(record.obstructionEvidence and record.obstructionEvidence.kind or "UNRESOLVED"),
            record.relocationEligible==true and "RELOCATION_ELIGIBLE" or "NO_RELOCATION"
        },"|")
    end
    local signature=table.concat(signatureParts,",")
    if signature~=self.lastSignature then
        self.lastSignature=signature
        logInfo("count=%d relations=%s",#records,signature~="" and signature or "none")
    end
    return records
end
