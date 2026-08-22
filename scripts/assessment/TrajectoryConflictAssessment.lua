-- FS25_OuttaMyWay v4.7.112 CANONICAL CANDIDATE — v4.7.109 D-0146 trajectory/conflict behaviour preserved; D-0147 is architecture-only.
-- Situation Assessment owns the persistent state supplied to this module. This module
-- consumes only sealed/current Situation evidence and has no Candidate/Decision/Control authority.

OuttaMyWay.TrajectoryConflictAssessment = {}
local Assessment = OuttaMyWay.TrajectoryConflictAssessment

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function clamp(value,minimum,maximum)
    if value<minimum then return minimum end
    if value>maximum then return maximum end
    return value
end

local function normalize(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local length=math.sqrt(x*x+z*z)
    if length<=0.000001 then return nil,nil end
    return x/length,z/length
end

local function dot(ax,az,bx,bz)
    if not finite(ax) or not finite(az) or not finite(bx) or not finite(bz) then return nil end
    return ax*bx+az*bz
end

local function copy(value)
    if type(value)~="table" then return value end
    local result={}
    for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[key]=copy(item) end
    return result
end

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end

local function productiveByAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end

local function threshold(context,name,default)
    local value=context and context[name] or nil
    value=tonumber(value)
    if value==nil then return default end
    return value
end

local function resetCandidate(track,prefix,dx,dz,distance)
    track[prefix.."VectorX"]=dx
    track[prefix.."VectorZ"]=dz
    track[prefix.."DistanceM"]=distance
end

local function accumulateCandidate(track,prefix,dx,dz,distance,coherenceMinDot)
    local currentX=track[prefix.."VectorX"]
    local currentZ=track[prefix.."VectorZ"]
    local currentDistance=tonumber(track[prefix.."DistanceM"]) or 0
    if currentX==nil or currentZ==nil or currentDistance<=0 then
        resetCandidate(track,prefix,dx,dz,distance)
        return dx,dz,distance,true
    end
    local currentDot=dot(currentX,currentZ,dx,dz)
    if currentDot==nil or currentDot<coherenceMinDot then
        resetCandidate(track,prefix,dx,dz,distance)
        return dx,dz,distance,false
    end
    local weightedX=currentX*currentDistance+dx*distance
    local weightedZ=currentZ*currentDistance+dz*distance
    local resultX,resultZ=normalize(weightedX,weightedZ)
    local resultDistance=currentDistance+distance
    track[prefix.."VectorX"]=resultX
    track[prefix.."VectorZ"]=resultZ
    track[prefix.."DistanceM"]=resultDistance
    return resultX,resultZ,resultDistance,true
end

local function clearCandidate(track,prefix)
    track[prefix.."VectorX"]=nil
    track[prefix.."VectorZ"]=nil
    track[prefix.."DistanceM"]=0
end

local function currentMotionSample(motion,minSampleDistanceM)
    local dx,dz=normalize(tonumber(motion.travelDirectionX),tonumber(motion.travelDirectionZ))
    local interval=tonumber(motion.sampleIntervalSeconds)
    local speed=tonumber(motion.positionDerivedSpeedMps)
    local distance=nil
    if interval~=nil and interval>0 and speed~=nil and speed>=0 then distance=interval*speed end
    local meaningful=dx~=nil and distance~=nil and distance>=minSampleDistanceM
    return {
        directionX=dx,directionZ=dz,distanceM=distance,meaningful=meaningful,
        speedMps=speed,classification=motion.motionClassification,reason=motion.motionReason,
        sampleIntervalSeconds=interval
    }
end

local function establish(track,dx,dz,space,snapshotId,timestamp,distanceM,reason)
    track.established=true
    track.establishedDirectionX=dx
    track.establishedDirectionZ=dz
    track.anchorX=space and space.occupancy and tonumber(space.occupancy.x) or track.anchorX
    track.anchorZ=space and space.occupancy and tonumber(space.occupancy.z) or track.anchorZ
    track.establishedAtObservationSnapshotId=snapshotId
    track.establishedAtTimestamp=timestamp
    track.lastAlignedObservationSnapshotId=snapshotId
    track.currentAlignedDistanceM=distanceM or 0
    track.totalAlignedDistanceM=distanceM or 0
    track.currentExcursion=false
    track.currentToEstablishedDot=1
    track.lastTransition=reason or "ESTABLISHED"
    clearCandidate(track,"formation")
    clearCandidate(track,"excursion")
end

local function updateEstablishedDirection(track,dx,dz,distanceM,memoryDistanceM)
    local memory=math.max(0,math.min(tonumber(track.totalAlignedDistanceM) or 0,memoryDistanceM))
    local weightedX=track.establishedDirectionX*memory+dx*distanceM
    local weightedZ=track.establishedDirectionZ*memory+dz*distanceM
    local updatedX,updatedZ=normalize(weightedX,weightedZ)
    if updatedX~=nil then
        track.establishedDirectionX=updatedX
        track.establishedDirectionZ=updatedZ
    end
end

local function updateTrack(track,motion,space,productive,context)
    local minSampleDistanceM=threshold(context,"minSampleDistanceM",0.10)
    local establishDistanceM=threshold(context,"establishDistanceM",3.0)
    local coherenceMinDot=threshold(context,"coherenceMinDot",0.94)
    local persistenceAlignmentMinDot=threshold(context,"persistenceAlignmentMinDot",0.85)
    local supersessionDistanceM=threshold(context,"supersessionDistanceM",4.0)
    local stableMemoryDistanceM=threshold(context,"stableMemoryDistanceM",12.0)
    local snapshotId=context.observationSnapshotId
    local timestamp=context.timestamp
    local sample=currentMotionSample(motion,minSampleDistanceM)
    track.lastObservationSnapshotId=snapshotId
    track.lastTimestamp=timestamp
    track.currentMotion=sample
    track.currentExcursion=false
    track.currentToEstablishedDot=nil
    track.contextEvidenceClass=productive and productive.evidenceClass or "UNRESOLVED"
    track.contextProductivePositive=productive and productive.productivePositive==true or false

    if sample.meaningful~=true then
        track.lastTransition=track.established and "PERSISTED_WITHOUT_MEANINGFUL_DIRECTION_SAMPLE" or "FORMATION_WAITING_FOR_MEANINGFUL_MOTION"
        return
    end

    if track.established~=true then
        local cx,cz,distance=accumulateCandidate(track,"formation",sample.directionX,sample.directionZ,sample.distanceM,coherenceMinDot)
        track.lastTransition="FORMATION_ACCUMULATING"
        if distance>=establishDistanceM then
            establish(track,cx,cz,space,snapshotId,timestamp,distance,"ESTABLISHED_FROM_COHERENT_PHYSICAL_TRAVEL")
        end
        return
    end

    local alignment=dot(track.establishedDirectionX,track.establishedDirectionZ,sample.directionX,sample.directionZ)
    track.currentToEstablishedDot=alignment
    if alignment~=nil and alignment>=persistenceAlignmentMinDot then
        updateEstablishedDirection(track,sample.directionX,sample.directionZ,sample.distanceM,stableMemoryDistanceM)
        track.anchorX=space and space.occupancy and tonumber(space.occupancy.x) or track.anchorX
        track.anchorZ=space and space.occupancy and tonumber(space.occupancy.z) or track.anchorZ
        track.lastAlignedObservationSnapshotId=snapshotId
        track.currentAlignedDistanceM=(tonumber(track.currentAlignedDistanceM) or 0)+sample.distanceM
        track.totalAlignedDistanceM=(tonumber(track.totalAlignedDistanceM) or 0)+sample.distanceM
        track.lastTransition="ESTABLISHED_TRAJECTORY_REINFORCED"
        clearCandidate(track,"excursion")
        return
    end

    track.currentExcursion=true
    track.currentAlignedDistanceM=0
    local ex,ez,excursionDistance=accumulateCandidate(track,"excursion",sample.directionX,sample.directionZ,sample.distanceM,coherenceMinDot)
    track.lastTransition="CURRENT_EXCURSION"
    if excursionDistance>=supersessionDistanceM then
        establish(track,ex,ez,space,snapshotId,timestamp,excursionDistance,"ESTABLISHED_TRAJECTORY_SUPERSEDED_BY_SUSTAINED_CONTRADICTORY_MOTION")
    end
end

local function knowledgeForTrack(track)
    local current=track.currentMotion or {}
    local formationDistance=tonumber(track.formationDistanceM) or 0
    local excursionDistance=tonumber(track.excursionDistanceM) or 0
    return {
        assemblyId=track.assemblyId,
        assemblyReferenceKey=track.assemblyReferenceKey,
        jobToken=track.jobToken,
        status=track.established==true and "ESTABLISHED_TRAJECTORY" or "TRAJECTORY_FORMING",
        established=track.established==true,
        establishedDirectionX=track.establishedDirectionX,
        establishedDirectionZ=track.establishedDirectionZ,
        corridorAnchorX=track.anchorX,
        corridorAnchorZ=track.anchorZ,
        formationDistanceM=formationDistance,
        currentAlignedDistanceM=tonumber(track.currentAlignedDistanceM) or 0,
        totalAlignedDistanceM=tonumber(track.totalAlignedDistanceM) or 0,
        currentMotionClassification=current.classification,
        currentMotionReason=current.reason,
        currentDirectionX=current.directionX,
        currentDirectionZ=current.directionZ,
        currentPositionDerivedSpeedMps=current.speedMps,
        currentSampleDistanceM=current.distanceM,
        currentToEstablishedDot=track.currentToEstablishedDot,
        currentExcursion=track.currentExcursion==true,
        excursionDistanceM=excursionDistance,
        lastTransition=track.lastTransition,
        contextEvidenceClass=track.contextEvidenceClass,
        contextProductivePositive=track.contextProductivePositive==true,
        establishedAtObservationSnapshotId=track.establishedAtObservationSnapshotId,
        lastAlignedObservationSnapshotId=track.lastAlignedObservationSnapshotId,
        provenance={
            source="TrajectoryConflictAssessment",
            layer="SITUATION_KNOWLEDGE",
            authority="D0146_SITUATION_KNOWLEDGE",
            basis="RECENT_PHYSICAL_DISPLACEMENT_WITH_TRAJECTORY_PERSISTENCE",
            productiveContextIsGate=false,
            decisionAuthority=false,
            controlAuthority=false
        }
    }
end

function Assessment.updateTrajectories(tracks,context)
    tracks=tracks or {}
    local motionByAssembly=byAssembly(context.motionEvidence)
    local spaceByAssembly=byAssembly(context.currentSpace)
    local productive=productiveByAssembly(context.productiveKnowledge)
    local records={}
    for _,motion in OuttaMyWay.ValueRecord.ipairs(context.motionEvidence or {}) do
        local assemblyId=motion.assemblyId
        local track=tracks[assemblyId]
        if track==nil or track.jobToken~=motion.sourceJobToken then
            track={
                assemblyId=assemblyId,
                assemblyReferenceKey=motion.assemblyReferenceKey,
                jobToken=motion.sourceJobToken,
                established=false,
                formationDistanceM=0,
                excursionDistanceM=0,
                currentAlignedDistanceM=0,
                totalAlignedDistanceM=0,
                lastTransition="TRACK_CREATED_FOR_JOB_EPISODE"
            }
            tracks[assemblyId]=track
        end
        track.assemblyReferenceKey=motion.assemblyReferenceKey
        updateTrack(track,motionByAssembly[assemblyId],spaceByAssembly[assemblyId],productive[assemblyId],context)
        records[#records+1]=knowledgeForTrack(track)
    end
    table.sort(records,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    return records
end

local function physicalLateralSupport(physical,currentSpace,rightX,rightZ)
    if physical==nil or currentSpace==nil or type(currentSpace.occupancy)~="table" then
        return {resolved=false,reason="CURRENT_PHYSICAL_SPACE_UNAVAILABLE"}
    end
    local originX=tonumber(currentSpace.occupancy.x)
    local originZ=tonumber(currentSpace.occupancy.z)
    if originX==nil or originZ==nil then return {resolved=false,reason="CURRENT_SPACE_POSE_UNAVAILABLE"} end
    local minimum,maximum=nil,nil
    local count=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) and primitive.radius>0 then
            local offset=(primitive.x-originX)*rightX+(primitive.z-originZ)*rightZ
            local low=offset-primitive.radius
            local high=offset+primitive.radius
            minimum=minimum==nil and low or math.min(minimum,low)
            maximum=maximum==nil and high or math.max(maximum,high)
            count=count+1
        end
    end
    if count==0 then return {resolved=false,reason="NO_POSITIVE_CURRENT_PHYSICAL_PRIMITIVES"} end
    return {resolved=true,minOffsetM=minimum,maxOffsetM=maximum,physicalPrimitiveCount=count}
end

local currentClosing

local function currentCorridorOverlapOnAxis(axisTrajectory,aPhysical,bPhysical,aSpace,bSpace)
    local axisX,axisZ=normalize(axisTrajectory and axisTrajectory.establishedDirectionX,axisTrajectory and axisTrajectory.establishedDirectionZ)
    if axisX==nil then return {status="UNRESOLVED",reason="STABLE_TRAJECTORY_AXIS_UNRESOLVED"} end
    local rightX,rightZ=axisZ,-axisX
    local aSupport=physicalLateralSupport(aPhysical,aSpace,rightX,rightZ)
    local bSupport=physicalLateralSupport(bPhysical,bSpace,rightX,rightZ)
    if aSupport.resolved~=true or bSupport.resolved~=true then
        return {
            status="UNRESOLVED",reason=aSupport.resolved~=true and aSupport.reason or bSupport.reason,
            sharedAxisX=axisX,sharedAxisZ=axisZ,sharedRightX=rightX,sharedRightZ=rightZ,
            subjectPhysicalPrimitiveCount=aSupport.physicalPrimitiveCount or 0,otherPhysicalPrimitiveCount=bSupport.physicalPrimitiveCount or 0
        }
    end
    local aX,aZ=tonumber(aSpace and aSpace.occupancy and aSpace.occupancy.x),tonumber(aSpace and aSpace.occupancy and aSpace.occupancy.z)
    local bX,bZ=tonumber(bSpace and bSpace.occupancy and bSpace.occupancy.x),tonumber(bSpace and bSpace.occupancy and bSpace.occupancy.z)
    if not finite(aX) or not finite(aZ) or not finite(bX) or not finite(bZ) then
        return {status="UNRESOLVED",reason="CURRENT_SPACE_POSE_UNAVAILABLE",sharedAxisX=axisX,sharedAxisZ=axisZ,sharedRightX=rightX,sharedRightZ=rightZ}
    end
    local aCentre=aX*rightX+aZ*rightZ
    local bCentre=bX*rightX+bZ*rightZ
    local aMin,aMax=aCentre+aSupport.minOffsetM,aCentre+aSupport.maxOffsetM
    local bMin,bMax=bCentre+bSupport.minOffsetM,bCentre+bSupport.maxOffsetM
    local overlapM=math.min(aMax,bMax)-math.max(aMin,bMin)
    local positive=overlapM>0
    return {
        status=positive and "POSITIVE_CURRENT_CORRIDOR_SUPPORT" or "CURRENT_CORRIDOR_OVERLAP_NOT_SUPPORTED",
        reason=positive and "CURRENT_POSITIVE_PHYSICAL_BANDS_SHARE_STABLE_TRAJECTORY_CORRIDOR" or "CURRENT_POSITIVE_PHYSICAL_BANDS_ARE_LATERALLY_DECOUPLED",
        positive=positive,overlapM=overlapM,sharedAxisX=axisX,sharedAxisZ=axisZ,sharedRightX=rightX,sharedRightZ=rightZ,
        subjectBandMinM=aMin,subjectBandMaxM=aMax,otherBandMinM=bMin,otherBandMaxM=bMax,
        subjectPhysicalPrimitiveCount=aSupport.physicalPrimitiveCount,otherPhysicalPrimitiveCount=bSupport.physicalPrimitiveCount,negativeClearanceAuthority=false
    }
end

local function nativeForwardRateKmh(motion)
    local fieldWork=motion and motion.nativeFieldWork or nil
    local command=fieldWork and fieldWork.nativeDriveCommand or nil
    if type(command)~="table" or command.valid~=true or command.zeroCommand==true or command.moveForwards~=true then return nil end
    local rate=tonumber(command.maxSpeedKmh)
    if not finite(rate) or rate<=0 then return nil end
    return rate
end

-- Established-conflict Resolution-Space role assignment must value what a
-- native command does to this pair, not whether GIANTS chose forward gear.
-- The Regulation actuator already preserves GIANTS' forward/reverse choice and
-- only caps speed, so this Situation-owned calculation projects the commanded
-- motion direction onto the instantaneous subject->other pair axis.
local function nativeClosureContribution(motion,subjectSpace,otherSpace)
    local fieldWork=motion and motion.nativeFieldWork or nil
    local command=fieldWork and fieldWork.nativeDriveCommand or nil
    if type(command)~="table" or command.valid~=true then return nil,"NATIVE_DRIVE_COMMAND_UNAVAILABLE" end
    local moveForwards=command.moveForwards
    if moveForwards~=true and moveForwards~=false then return nil,"NATIVE_DRIVE_DIRECTION_UNAVAILABLE" end
    local rate=tonumber(command.maxSpeedKmh)
    if not finite(rate) or rate<0 then return nil,"NATIVE_DRIVE_RATE_UNAVAILABLE" end

    local occupancy=subjectSpace and subjectSpace.occupancy or nil
    local otherOccupancy=otherSpace and otherSpace.occupancy or nil
    if type(occupancy)~="table" or type(otherOccupancy)~="table" then return nil,"PAIR_POSE_UNAVAILABLE" end
    local subjectX,subjectZ=tonumber(occupancy.x),tonumber(occupancy.z)
    local otherX,otherZ=tonumber(otherOccupancy.x),tonumber(otherOccupancy.z)
    if not finite(subjectX) or not finite(subjectZ) or not finite(otherX) or not finite(otherZ) then return nil,"PAIR_POSE_UNAVAILABLE" end
    local pairX,pairZ=normalize(otherX-subjectX,otherZ-subjectZ)
    if pairX==nil then return nil,"PAIR_AXIS_UNRESOLVED" end

    local headingX,headingZ=normalize(tonumber(motion and motion.headingX) or tonumber(occupancy.headingX),tonumber(motion and motion.headingZ) or tonumber(occupancy.headingZ))
    if headingX==nil then return nil,"NATIVE_CHASSIS_HEADING_UNAVAILABLE" end
    local directionSign=moveForwards and 1 or -1
    local commandDirectionX,commandDirectionZ=headingX*directionSign,headingZ*directionSign
    local signedContribution=rate*dot(commandDirectionX,commandDirectionZ,pairX,pairZ)
    if command.zeroCommand==true then signedContribution=0; rate=0 end
    return {
        nativeRateKmh=rate,moveForwards=moveForwards,commandDirectionX=commandDirectionX,commandDirectionZ=commandDirectionZ,
        pairAxisX=pairX,pairAxisZ=pairZ,signedClosureContributionKmh=signedContribution,
        positiveClosureContributionKmh=math.max(0,signedContribution)
    },nil
end

local function actionSpaceConservation(aTrajectory,bTrajectory,aMotion,bMotion,aPhysical,bPhysical,aSpace,bSpace,aParticipation,bParticipation,context)
    local result={status="NOT_REQUIRED",supported=false,reason="CURRENT_EXCURSION_ACTION_SPACE_CONSERVATION_NOT_REQUIRED",authority="D0146_SITUATION_KNOWLEDGE",decisionAuthority=false,controlAuthority=false}
    local aExcursion=aTrajectory and aTrajectory.currentExcursion==true
    local bExcursion=bTrajectory and bTrajectory.currentExcursion==true
    if aExcursion==bExcursion then
        result.reason=aExcursion and "MULTIPLE_CURRENT_EXCURSIONS_DO_NOT_SUPPORT_UNILATERAL_CONSERVATION_ROLE" or "NO_CURRENT_EXCURSION"
        return result
    end

    local excursionTrajectory,stableTrajectory,excursionMotion,stableMotion,excursionPhysical,stablePhysical,excursionSpace,stableSpace
    if aExcursion then
        excursionTrajectory,stableTrajectory=aTrajectory,bTrajectory
        excursionMotion,stableMotion=aMotion,bMotion
        excursionPhysical,stablePhysical=aPhysical,bPhysical
        excursionSpace,stableSpace=aSpace,bSpace
    else
        excursionTrajectory,stableTrajectory=bTrajectory,aTrajectory
        excursionMotion,stableMotion=bMotion,aMotion
        excursionPhysical,stablePhysical=bPhysical,aPhysical
        excursionSpace,stableSpace=bSpace,aSpace
    end
    result.excursionAssemblyId=excursionTrajectory and excursionTrajectory.assemblyId or nil
    result.excursionReferenceKey=excursionTrajectory and excursionTrajectory.assemblyReferenceKey or nil

    local persistenceAlignmentMinDot=threshold(context,"persistenceAlignmentMinDot",0.85)
    local currentStableDistanceM=threshold(context,"currentStableDistanceM",1.0)
    local stableCurrentDot=stableTrajectory and stableTrajectory.currentToEstablishedDot or nil
    local stableCurrent=stableTrajectory~=nil and stableTrajectory.currentExcursion~=true
        and tonumber(stableTrajectory.currentAlignedDistanceM or 0)>=currentStableDistanceM
        and (stableCurrentDot==nil or stableCurrentDot>=persistenceAlignmentMinDot)
    if not stableCurrent then result.reason="NON_EXCURSION_PARTICIPANT_CURRENT_TRAJECTORY_NOT_STABLE"; return result end

    local closing=currentClosing(excursionMotion,stableMotion,excursionSpace,stableSpace)
    result.currentClosing=copy(closing)
    local minClosingRateMps=threshold(context,"minClosingRateMps",0.05)
    if closing.resolved~=true or not finite(tonumber(closing.closingRateMps)) or closing.closingRateMps<minClosingRateMps then
        result.reason="CURRENT_EXCURSION_PAIR_NOT_POSITIVELY_CLOSING"
        return result
    end
    local maxSeparationM=threshold(context,"actionSpaceMaxSeparationM",80.0)
    result.maxSeparationM=maxSeparationM
    result.separationM=closing.separationM
    if not finite(tonumber(closing.separationM)) or closing.separationM>maxSeparationM then
        result.reason="CURRENT_EXCURSION_PAIR_OUTSIDE_LOCAL_PASSAGE_ACTION_SPACE_ENVELOPE"
        return result
    end

    if stableSpace==nil or excursionSpace==nil or type(stableSpace.occupancy)~="table" or type(excursionSpace.occupancy)~="table" then
        result.reason="CURRENT_EXCURSION_PAIR_SPACE_UNAVAILABLE"
        return result
    end
    local stableX,stableZ=tonumber(stableSpace.occupancy.x),tonumber(stableSpace.occupancy.z)
    local excursionX,excursionZ=tonumber(excursionSpace.occupancy.x),tonumber(excursionSpace.occupancy.z)
    if not finite(stableX) or not finite(stableZ) or not finite(excursionX) or not finite(excursionZ) then
        result.reason="CURRENT_EXCURSION_PAIR_POSE_UNAVAILABLE"
        return result
    end
    local stableAhead=dot(excursionX-stableX,excursionZ-stableZ,stableTrajectory.establishedDirectionX,stableTrajectory.establishedDirectionZ)
    result.regulatedParticipantAheadM=stableAhead
    if not finite(stableAhead) or stableAhead<=0 then
        result.reason="CURRENT_EXCURSION_NOT_AHEAD_ON_STABLE_PARTICIPANT_TRAJECTORY"
        return result
    end

    local overlap=currentCorridorOverlapOnAxis(stableTrajectory,stablePhysical,excursionPhysical,stableSpace,excursionSpace)
    result.currentCorridorOverlap=copy(overlap)
    if overlap.positive~=true then
        result.reason=overlap.status=="UNRESOLVED" and overlap.reason or "CURRENT_EXCURSION_NOT_IN_STABLE_PARTICIPANT_SUPPORTED_CORRIDOR"
        return result
    end

    local aPending=aParticipation and aParticipation.productiveCommencementPending==true
    local bPending=bParticipation and bParticipation.productiveCommencementPending==true
    local regulatedTrajectory,regulatedMotion,regulatedSpace,protectedTrajectory,protectedSpace
    if aPending~=bPending then
        if aPending then
            protectedTrajectory,protectedSpace=aTrajectory,aSpace
            regulatedTrajectory,regulatedMotion,regulatedSpace=bTrajectory,bMotion,bSpace
        else
            protectedTrajectory,protectedSpace=bTrajectory,bSpace
            regulatedTrajectory,regulatedMotion,regulatedSpace=aTrajectory,aMotion,aSpace
        end
        if regulatedTrajectory==nil or protectedTrajectory==nil then result.reason="PRE_PRODUCTIVE_INTENT_REVELATION_ROLE_UNRESOLVED"; return result end
        result.regulatedAssemblyId=regulatedTrajectory.assemblyId
        result.regulatedReferenceKey=regulatedTrajectory.assemblyReferenceKey
        result.protectedAssemblyId=protectedTrajectory.assemblyId
        result.protectedReferenceKey=protectedTrajectory.assemblyReferenceKey
        result.roleBasis="PRESERVE_PRE_PRODUCTIVE_NATIVE_INTENT_REVELATION"
    else
        regulatedTrajectory,regulatedMotion,regulatedSpace=stableTrajectory,stableMotion,stableSpace
        protectedTrajectory,protectedSpace=excursionTrajectory,excursionSpace
        result.regulatedAssemblyId=stableTrajectory and stableTrajectory.assemblyId or nil
        result.regulatedReferenceKey=stableTrajectory and stableTrajectory.assemblyReferenceKey or nil
        result.protectedAssemblyId=result.excursionAssemblyId
        result.protectedReferenceKey=result.excursionReferenceKey
    end

    local nativeRate=nil
    if aPending~=bPending then
        local contribution,contributionReason=nativeClosureContribution(regulatedMotion,regulatedSpace,protectedSpace)
        result.nativeClosureContribution=contribution and copy(contribution) or nil
        result.nativeClosureContributionReason=contributionReason
        local positive=contribution and tonumber(contribution.positiveClosureContributionKmh) or nil
        if not finite(positive) or positive<=0 then result.reason="KNOWN_OPERATION_MEMBER_POSITIVE_NATIVE_CLOSURE_CONTRIBUTION_UNAVAILABLE"; return result end
        nativeRate=contribution.nativeRateKmh
        result.nativeClosureContributionKmh=positive
        result.nativeSignedClosureContributionKmh=contribution.signedClosureContributionKmh
        result.nativeMoveForwards=contribution.moveForwards
    else
        nativeRate=nativeForwardRateKmh(stableMotion)
    end
    result.nativeUnrestrictedKmh=nativeRate
    if nativeRate==nil then result.reason="REGULATED_PARTICIPANT_POSITIVE_NATIVE_FORWARD_RATE_UNAVAILABLE"; return result end
    result.status="REGULATE_SUPPORTED"
    result.supported=true
    result.admissionKind="CURRENT_EXCURSION"
    if result.roleBasis==nil then result.roleBasis="PRESERVE_CURRENT_EXCURSION_NATIVE_REVELATION" end
    result.reason="CURRENT_EXCURSION_OCCUPIES_APPROACHING_STABLE_TRAJECTORY_CORRIDOR_WHILE_LOCAL_PASSAGE_ACTION_SPACE_COMPRESSES"
    if aPending~=bPending then
        result.reason="PRE_PRODUCTIVE_NATIVE_INTENT_REVELATION_REQUIRES_RESOLUTION_SPACE_CONSERVATION"
    end
    result.governingPurpose="PRESERVE_D0146_PASSAGE_ACTION_SPACE_UNTIL_SUPPORTED_PASSAGE_OR_POSITIVE_DISSOLUTION"
    return result
end

-- Once Step 1 has positively Established an opposed conflict, Resolution-Space
-- Conservation no longer depends on the Current Excursion witness that may have
-- revealed the encounter.  This Situation-owned record assigns only a temporary
-- Regulation role; Candidate still decides whether a supported Step-2 Passage
-- expression is already available and therefore superior.
local function establishedConflictConservation(record,aTrajectory,bTrajectory,aMotion,bMotion,aSpace,bSpace,aParticipation,bParticipation,context)
    local result={status="NOT_REQUIRED",supported=false,reason="ESTABLISHED_CONFLICT_RESOLUTION_SPACE_CONSERVATION_NOT_REQUIRED",authority="D0146_SITUATION_KNOWLEDGE",decisionAuthority=false,controlAuthority=false,admissionKind="ESTABLISHED_CONFLICT"}
    if record==nil or record.classification~="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" then return result end
    local closing=record.currentClosing or {}
    local separation=tonumber(closing.separationM)
    local maxSeparationM=threshold(context,"actionSpaceMaxSeparationM",80.0)
    result.maxSeparationM=maxSeparationM; result.separationM=separation; result.currentClosing=copy(closing)
    if not finite(separation) or separation>maxSeparationM then
        result.reason="ESTABLISHED_CONFLICT_PAIR_OUTSIDE_LOCAL_PASSAGE_ACTION_SPACE_ENVELOPE"
        return result
    end
    local overlap=record.supportedCorridorOverlap or {}
    result.currentCorridorOverlap=copy(overlap)
    if overlap.positive~=true then
        result.reason="ESTABLISHED_CONFLICT_POSITIVE_CORRIDOR_SUPPORT_UNAVAILABLE"
        return result
    end

    local aContribution,aContributionReason=nativeClosureContribution(aMotion,aSpace,bSpace)
    local bContribution,bContributionReason=nativeClosureContribution(bMotion,bSpace,aSpace)
    result.subjectNativeClosureContribution=aContribution and copy(aContribution) or nil
    result.otherNativeClosureContribution=bContribution and copy(bContribution) or nil
    result.subjectNativeClosureContributionReason=aContributionReason
    result.otherNativeClosureContributionReason=bContributionReason
    local aPositive=aContribution and tonumber(aContribution.positiveClosureContributionKmh) or nil
    local bPositive=bContribution and tonumber(bContribution.positiveClosureContributionKmh) or nil
    result.subjectNativeClosureContributionKmh=aPositive
    result.otherNativeClosureContributionKmh=bPositive

    local aSettled=record.subjectSettledContinuation==true
    local bSettled=record.otherSettledContinuation==true
    local aPending=aParticipation and aParticipation.productiveCommencementPending==true
    local bPending=bParticipation and bParticipation.productiveCommencementPending==true
    local regulateA
    if aPending~=bPending then
        -- A Job-Episode whose productive intent has not yet been positively
        -- revealed is Situation-relevant but not a cooperative participant.
        -- Preserve GIANTS' native revelation and constrain the known Operation
        -- member; do not fold, reposition, or otherwise replace the pending job.
        regulateA=bPending
        local knownContribution=regulateA and aPositive or bPositive
        if not finite(knownContribution) or knownContribution<=0 then
            result.reason="KNOWN_OPERATION_MEMBER_POSITIVE_NATIVE_CLOSURE_CONTRIBUTION_UNAVAILABLE"
            return result
        end
        result.roleBasis="PRESERVE_PRE_PRODUCTIVE_NATIVE_INTENT_REVELATION"
    elseif aSettled~=bSettled then
        -- Preserve the participant still revealing a GIANTS-native transition;
        -- defer the positively settled participant exactly as Current-Excursion
        -- conservation already does before Establishment.  If that settled
        -- participant is not itself consuming pair separation, Regulation cannot
        -- conserve Resolution Space without constraining the transitional mover.
        regulateA=aSettled
        local settledContribution=regulateA and aPositive or bPositive
        if not finite(settledContribution) or settledContribution<=0 then
            result.reason="SETTLED_PARTICIPANT_POSITIVE_NATIVE_CLOSURE_CONTRIBUTION_UNAVAILABLE"
            return result
        end
        result.roleBasis="PRESERVE_TRANSITIONAL_NATIVE_REVELATION"
    else
        local aUsable=finite(aPositive) and aPositive>0
        local bUsable=finite(bPositive) and bPositive>0
        if not aUsable and not bUsable then
            result.reason="ESTABLISHED_CONFLICT_POSITIVE_NATIVE_CLOSURE_CONTRIBUTION_UNAVAILABLE"
            return result
        elseif not aUsable then
            regulateA=false; result.roleBasis="ONLY_OTHER_POSITIVE_NATIVE_CLOSURE_CONTRIBUTION"
        elseif not bUsable then
            regulateA=true; result.roleBasis="ONLY_SUBJECT_POSITIVE_NATIVE_CLOSURE_CONTRIBUTION"
        elseif math.abs(aPositive-bPositive)>0.001 then
            regulateA=aPositive>bPositive; result.roleBasis="DEFER_GREATER_NATIVE_CLOSURE_CONTRIBUTION"
        else
            regulateA=tostring(aTrajectory.assemblyId)<=tostring(bTrajectory.assemblyId)
            result.roleBasis="DETERMINISTIC_EQUAL_CLOSURE_CONTRIBUTION_TIE_BREAK"
        end
    end

    local regulatedTrajectory=regulateA and aTrajectory or bTrajectory
    local protectedTrajectory=regulateA and bTrajectory or aTrajectory
    local regulatedContribution=regulateA and aContribution or bContribution
    local nativeRate=regulatedContribution and tonumber(regulatedContribution.nativeRateKmh) or nil
    result.regulatedAssemblyId=regulatedTrajectory and regulatedTrajectory.assemblyId or nil
    result.regulatedReferenceKey=regulatedTrajectory and regulatedTrajectory.assemblyReferenceKey or nil
    result.protectedAssemblyId=protectedTrajectory and protectedTrajectory.assemblyId or nil
    result.protectedReferenceKey=protectedTrajectory and protectedTrajectory.assemblyReferenceKey or nil
    result.nativeUnrestrictedKmh=nativeRate
    result.nativeClosureContributionKmh=regulatedContribution and tonumber(regulatedContribution.positiveClosureContributionKmh) or nil
    result.nativeSignedClosureContributionKmh=regulatedContribution and tonumber(regulatedContribution.signedClosureContributionKmh) or nil
    if regulatedContribution~=nil then result.nativeMoveForwards=regulatedContribution.moveForwards end
    if nativeRate==nil then result.reason="SELECTED_REGULATED_PARTICIPANT_NATIVE_RATE_UNAVAILABLE"; return result end

    result.status="REGULATE_SUPPORTED"; result.supported=true
    result.reason="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_CONSUMES_LOCAL_PASSAGE_ACTION_SPACE"
    result.governingPurpose="PRESERVE_D0146_PASSAGE_ACTION_SPACE_UNTIL_SUPPORTED_PASSAGE_OR_POSITIVE_DISSOLUTION"
    return result
end

local function corridorOverlap(aTrajectory,bTrajectory,aPhysical,bPhysical,aSpace,bSpace)
    local axisX,axisZ=normalize(aTrajectory.establishedDirectionX-bTrajectory.establishedDirectionX,aTrajectory.establishedDirectionZ-bTrajectory.establishedDirectionZ)
    if axisX==nil then return {status="UNRESOLVED",reason="COMMON_OPPOSED_AXIS_UNRESOLVED"} end
    local rightX,rightZ=axisZ,-axisX
    local aSupport=physicalLateralSupport(aPhysical,aSpace,rightX,rightZ)
    local bSupport=physicalLateralSupport(bPhysical,bSpace,rightX,rightZ)
    if aSupport.resolved~=true or bSupport.resolved~=true then
        return {
            status="UNRESOLVED",
            reason=aSupport.resolved~=true and aSupport.reason or bSupport.reason,
            sharedAxisX=axisX,sharedAxisZ=axisZ,sharedRightX=rightX,sharedRightZ=rightZ,
            subjectPhysicalPrimitiveCount=aSupport.physicalPrimitiveCount or 0,
            otherPhysicalPrimitiveCount=bSupport.physicalPrimitiveCount or 0
        }
    end
    local aAnchorX,aAnchorZ=tonumber(aTrajectory.corridorAnchorX),tonumber(aTrajectory.corridorAnchorZ)
    local bAnchorX,bAnchorZ=tonumber(bTrajectory.corridorAnchorX),tonumber(bTrajectory.corridorAnchorZ)
    if not finite(aAnchorX) or not finite(aAnchorZ) or not finite(bAnchorX) or not finite(bAnchorZ) then
        return {
            status="UNRESOLVED",reason="ESTABLISHED_TRAJECTORY_CORRIDOR_ANCHOR_UNAVAILABLE",
            sharedAxisX=axisX,sharedAxisZ=axisZ,sharedRightX=rightX,sharedRightZ=rightZ,
            subjectPhysicalPrimitiveCount=aSupport.physicalPrimitiveCount,otherPhysicalPrimitiveCount=bSupport.physicalPrimitiveCount
        }
    end
    local aCentre=aAnchorX*rightX+aAnchorZ*rightZ
    local bCentre=bAnchorX*rightX+bAnchorZ*rightZ
    local aMin,aMax=aCentre+aSupport.minOffsetM,aCentre+aSupport.maxOffsetM
    local bMin,bMax=bCentre+bSupport.minOffsetM,bCentre+bSupport.maxOffsetM
    local overlapM=math.min(aMax,bMax)-math.max(aMin,bMin)
    local positive=overlapM>0
    return {
        status=positive and "POSITIVE_SUPPORTED_CORRIDOR_OVERLAP" or "POSITIVE_OVERLAP_NOT_SUPPORTED",
        reason=positive and "POSITIVE_CURRENT_PHYSICAL_SUPPORT_BANDS_INTERSECT" or "CURRENT_POSITIVE_SUPPORT_BANDS_DO_NOT_INTERSECT",
        positive=positive,
        overlapM=overlapM,
        sharedAxisX=axisX,sharedAxisZ=axisZ,sharedRightX=rightX,sharedRightZ=rightZ,
        subjectBandMinM=aMin,subjectBandMaxM=aMax,otherBandMinM=bMin,otherBandMaxM=bMax,
        subjectPhysicalPrimitiveCount=aSupport.physicalPrimitiveCount,otherPhysicalPrimitiveCount=bSupport.physicalPrimitiveCount,
        negativeClearanceAuthority=false
    }
end

currentClosing=function(aMotion,bMotion,aSpace,bSpace)
    if aMotion==nil or bMotion==nil or aSpace==nil or bSpace==nil or type(aSpace.occupancy)~="table" or type(bSpace.occupancy)~="table" then
        return {resolved=false,reason="CURRENT_MOTION_OR_SPACE_UNAVAILABLE"}
    end
    local ax,az=normalize(tonumber(aMotion.travelDirectionX),tonumber(aMotion.travelDirectionZ))
    local bx,bz=normalize(tonumber(bMotion.travelDirectionX),tonumber(bMotion.travelDirectionZ))
    local aspeed=tonumber(aMotion.positionDerivedSpeedMps)
    local bspeed=tonumber(bMotion.positionDerivedSpeedMps)
    local aX,aZ=tonumber(aSpace.occupancy.x),tonumber(aSpace.occupancy.z)
    local bX,bZ=tonumber(bSpace.occupancy.x),tonumber(bSpace.occupancy.z)
    if ax==nil or bx==nil or aspeed==nil or bspeed==nil or aX==nil or aZ==nil or bX==nil or bZ==nil then
        return {resolved=false,reason="CURRENT_TRAVEL_VECTOR_UNRESOLVED"}
    end
    local rx,rz=bX-aX,bZ-aZ
    local separation=math.sqrt(rx*rx+rz*rz)
    if separation<=0.000001 then return {resolved=true,closingRateMps=0,currentDirectionDot=dot(ax,az,bx,bz),separationM=separation,reason="COINCIDENT_CURRENT_REFERENCE_POSES"} end
    local relativeVelocityX=bx*bspeed-ax*aspeed
    local relativeVelocityZ=bz*bspeed-az*aspeed
    local closingRate=-((rx*relativeVelocityX+rz*relativeVelocityZ)/separation)
    return {resolved=true,closingRateMps=closingRate,currentDirectionDot=dot(ax,az,bx,bz),separationM=separation}
end

local function mutuallyFacing(aTrajectory,bTrajectory,aSpace,bSpace)
    if aSpace==nil or bSpace==nil or type(aSpace.occupancy)~="table" or type(bSpace.occupancy)~="table" then return nil,nil,nil end
    local aX,aZ=tonumber(aSpace.occupancy.x),tonumber(aSpace.occupancy.z)
    local bX,bZ=tonumber(bSpace.occupancy.x),tonumber(bSpace.occupancy.z)
    if not finite(aX) or not finite(aZ) or not finite(bX) or not finite(bZ) then return nil,nil,nil end
    local dx=bX-aX
    local dz=bZ-aZ
    local aAhead=dot(dx,dz,aTrajectory.establishedDirectionX,aTrajectory.establishedDirectionZ)
    local bAhead=dot(-dx,-dz,bTrajectory.establishedDirectionX,bTrajectory.establishedDirectionZ)
    if aAhead==nil or bAhead==nil then return nil,aAhead,bAhead end
    return aAhead>0 and bAhead>0,aAhead,bAhead
end

local function sortedMemberIds(values)
    local result={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[#result+1]=value end
    table.sort(result,function(a,b) return tostring(a)<tostring(b) end)
    return result
end

local function positiveSettledContinuation(trajectory,motion)
    if trajectory==nil or motion==nil then return false end
    return trajectory.contextProductivePositive==true
        and trajectory.contextEvidenceClass=="NON_TURN_LINE_ACTIVE"
        and motion.localIntentClassification=="SETTLED_CONTINUATION"
        and motion.intentValid==true
end

-- Situation-owned positive relationship invalidation for an already-admitted
-- Resolution-Space obligation.  This does not create Control authority.  It
-- distinguishes actual relationship dissolution from a transient change in the
-- Current Motion witness that first exposed the Potential conflict.
local function resolutionSpaceRelationship(record)
    local result={status="UNRESOLVED",positiveDissolution=false,reason="RELATIONSHIP_DISSOLUTION_NOT_POSITIVELY_ESTABLISHED",authority="D0146_SITUATION_KNOWLEDGE",decisionAuthority=false,controlAuthority=false}
    if record.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" or record.classification=="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT" then
        result.status="RELATIONSHIP_REMAINS_ACTIVE"
        result.reason="OPPOSED_CORRIDOR_RELATIONSHIP_REMAINS_ESTABLISHED_OR_POTENTIAL"
        return result
    end
    if record.classification~="NO_OPPOSED_CONFLICT" then return result end

    -- ADR-0006 Safe Release: loss of the current OPPOSED label cannot become
    -- positive dissolution while current Reality still carries contradictory
    -- positive evidence.  A blocked participant may still have valid productive
    -- intent, but blockage cannot prove independent continuation.  Likewise a
    -- positively intersecting relevant Future-Space relationship means the
    -- Continuation Safety Horizon remains coupled even when instantaneous
    -- trajectories are currently non-opposed.
    if record.subjectBlocked==true or record.otherBlocked==true then
        result.status="POSITIVE_DISSOLUTION_VETOED"
        result.reason="D0146_BLOCKED_PARTICIPANT_VETOES_POSITIVE_RELATIONSHIP_DISSOLUTION"
        return result
    end
    if record.relevantFutureSpacePositive==true then
        result.status="POSITIVE_DISSOLUTION_VETOED"
        result.reason="D0146_POSITIVE_FUTURE_SPACE_VETOES_POSITIVE_RELATIONSHIP_DISSOLUTION"
        return result
    end

    if record.reason=="PARTICIPANTS_NOT_MUTUALLY_AHEAD_ON_ESTABLISHED_TRAJECTORIES" then
        result.status="POSITIVELY_DISSOLVED"; result.positiveDissolution=true
        result.reason="D0146_POSITIVE_POST_PASSAGE_RELATIONSHIP_DISSOLUTION"
        return result
    end
    if record.reason=="ESTABLISHED_TRAJECTORIES_NOT_SUBSTANTIALLY_OPPOSED" then
        if record.subjectCurrentExcursion==true or record.otherCurrentExcursion==true then
            result.status="TRANSIENT_RELATIONSHIP_CHANGE"
            result.reason="D0146_TRANSIENT_EXCURSION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION"
            return result
        end
        if record.subjectSettledContinuation~=true or record.otherSettledContinuation~=true then
            result.status="TRANSITIONAL_RELATIONSHIP_CHANGE"
            result.reason="D0146_TRANSITIONAL_CONTINUATION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION"
            return result
        end
        result.status="POSITIVELY_DISSOLVED"; result.positiveDissolution=true
        result.reason="D0146_POSITIVE_SETTLED_TRAJECTORY_RELATIONSHIP_DISSOLUTION"
        return result
    end
    return result
end

local function relevantFutureSpacePositive(situation,aId,bId)
    for _,relationship in OuttaMyWay.ValueRecord.ipairs(situation and situation.futureSpaceRelationships or {}) do
        local subject=relationship.subjectAssemblyId
        local other=relationship.otherAssemblyId
        if ((subject==aId and other==bId) or (subject==bId and other==aId)) and relationship.positiveIntersection==true then
            return true,relationship.outcome,relationship.interactionReferenceKey
        end
    end
    return false,nil,nil
end

function Assessment.classifyPairs(context)
    local trajectoryByAssembly=byAssembly(context.trajectoryKnowledge)
    local motionByAssembly=byAssembly(context.motionEvidence)
    local spaceByAssembly=byAssembly(context.currentSpace)
    local physicalByAssembly=byAssembly(context.physicalSpaceEvidence)
    local opposedMaxDot=threshold(context,"opposedMaxDot",-0.85)
    local currentOpposedMaxDot=threshold(context,"currentOpposedMaxDot",-0.85)
    local persistenceAlignmentMinDot=threshold(context,"persistenceAlignmentMinDot",0.85)
    local currentStableDistanceM=threshold(context,"currentStableDistanceM",1.0)
    local minClosingRateMps=threshold(context,"minClosingRateMps",0.05)
    local result={}

    for _,situation in OuttaMyWay.ValueRecord.ipairs(context.situations or {}) do
        local members=sortedMemberIds(situation.resolutionSpaceAssemblyIds or situation.memberAssemblyIds)
        local participation=situation.resolutionSpaceParticipation or {}
        for i=1,#members-1 do
            for j=i+1,#members do
                local aId,bId=members[i],members[j]
                local aParticipation=participation[aId] or {class="OPERATION_MEMBER",operationMember=true,productiveCommencementPending=false}
                local bParticipation=participation[bId] or {class="OPERATION_MEMBER",operationMember=true,productiveCommencementPending=false}
                if aParticipation.operationMember==true or bParticipation.operationMember==true then
                    local aTrajectory=trajectoryByAssembly[aId]
                    local bTrajectory=trajectoryByAssembly[bId]
                    local record={
                    identity="d0146-opposed:"..tostring(situation.operationId)..":"..tostring(aId)..":"..tostring(bId),
                    operationId=situation.operationId,
                    subjectAssemblyId=aId,otherAssemblyId=bId,
                    subjectAssemblyReferenceKey=aTrajectory and aTrajectory.assemblyReferenceKey or nil,
                    otherAssemblyReferenceKey=bTrajectory and bTrajectory.assemblyReferenceKey or nil,
                    subjectOperationMember=aParticipation.operationMember==true,
                    otherOperationMember=bParticipation.operationMember==true,
                    subjectParticipationClass=aParticipation.class,
                    otherParticipationClass=bParticipation.class,
                    subjectProductiveCommencementPending=aParticipation.productiveCommencementPending==true,
                    otherProductiveCommencementPending=bParticipation.productiveCommencementPending==true,
                    cooperativePassageEligible=aParticipation.operationMember==true and bParticipation.operationMember==true,
                    classification=nil,
                    status="INSUFFICIENT_KNOWLEDGE",
                    reason="ESTABLISHED_TRAJECTORY_NOT_AVAILABLE_FOR_BOTH_PARTICIPANTS",
                    provenance={source="TrajectoryConflictAssessment",layer="SITUATION_KNOWLEDGE",authority="D0146_SITUATION_KNOWLEDGE",decisionAuthority=false,controlAuthority=false}
                }
                if aTrajectory~=nil and bTrajectory~=nil and aTrajectory.established==true and bTrajectory.established==true then
                    local trajectoryDot=dot(aTrajectory.establishedDirectionX,aTrajectory.establishedDirectionZ,bTrajectory.establishedDirectionX,bTrajectory.establishedDirectionZ)
                    record.trajectoryDot=trajectoryDot
                    record.subjectCurrentExcursion=aTrajectory.currentExcursion==true
                    record.otherCurrentExcursion=bTrajectory.currentExcursion==true
                    record.subjectSettledContinuation=positiveSettledContinuation(aTrajectory,motionByAssembly[aId])
                    record.otherSettledContinuation=positiveSettledContinuation(bTrajectory,motionByAssembly[bId])
                    record.subjectBlocked=motionByAssembly[aId]~=nil and motionByAssembly[aId].blocked==true
                    record.otherBlocked=motionByAssembly[bId]~=nil and motionByAssembly[bId].blocked==true
                    local futurePositive,futureOutcome,futureRelationshipKey=relevantFutureSpacePositive(situation,aId,bId)
                    record.relevantFutureSpacePositive=futurePositive==true
                    record.relevantFutureSpaceOutcome=futureOutcome
                    record.relevantFutureSpaceRelationshipKey=futureRelationshipKey
                    record.subjectCurrentToEstablishedDot=aTrajectory.currentToEstablishedDot
                    record.otherCurrentToEstablishedDot=bTrajectory.currentToEstablishedDot
                    local actionSpace=actionSpaceConservation(
                        aTrajectory,bTrajectory,motionByAssembly[aId],motionByAssembly[bId],physicalByAssembly[aId],physicalByAssembly[bId],
                        spaceByAssembly[aId],spaceByAssembly[bId],aParticipation,bParticipation,context)
                    record.actionSpaceConservation=copy(actionSpace)
                    -- Situation owns the distinction between missing closure evidence
                    -- and positive evidence that the pair is no longer closing. Control
                    -- does not require a resolved travel vector merely to maintain an
                    -- already-admitted elastic Resolution-Space magnitude.
                    if type(actionSpace.currentClosing)=="table" then
                        record.currentClosing=copy(actionSpace.currentClosing)
                        local actionClosingRate=tonumber(actionSpace.currentClosing.closingRateMps)
                        if actionSpace.currentClosing.resolved==true and finite(actionClosingRate) then
                            record.currentClosingPositive=actionClosingRate>=minClosingRateMps
                            record.currentNonClosingPositive=actionClosingRate<minClosingRateMps
                        end
                    end
                    if actionSpace.supported==true then
                        record.status="CLASSIFIED"
                        record.classification="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT"
                        record.reason="CURRENT_EXCURSION_CONSUMES_LOCAL_PASSAGE_ACTION_SPACE"
                        record.currentClosingPositive=true
                        record.currentNonClosingPositive=false
                        record.currentOpposed=false
                    elseif trajectoryDot==nil then
                        record.reason="ESTABLISHED_TRAJECTORY_RELATION_UNRESOLVED"
                    elseif trajectoryDot>opposedMaxDot then
                        record.status="CLASSIFIED"
                        record.classification="NO_OPPOSED_CONFLICT"
                        record.reason="ESTABLISHED_TRAJECTORIES_NOT_SUBSTANTIALLY_OPPOSED"
                    else
                        local facing,aAhead,bAhead=mutuallyFacing(aTrajectory,bTrajectory,spaceByAssembly[aId],spaceByAssembly[bId])
                        record.mutuallyFacing=facing==true
                        record.subjectAheadM=aAhead
                        record.otherAheadM=bAhead
                        if facing==false then
                            record.status="CLASSIFIED"
                            record.classification="NO_OPPOSED_CONFLICT"
                            record.reason="PARTICIPANTS_NOT_MUTUALLY_AHEAD_ON_ESTABLISHED_TRAJECTORIES"
                        else
                            local overlap=corridorOverlap(aTrajectory,bTrajectory,physicalByAssembly[aId],physicalByAssembly[bId],spaceByAssembly[aId],spaceByAssembly[bId])
                            record.supportedCorridorOverlap=copy(overlap)
                            local closing=currentClosing(motionByAssembly[aId],motionByAssembly[bId],spaceByAssembly[aId],spaceByAssembly[bId])
                            record.currentClosing=copy(closing)
                            local aStable=aTrajectory.currentExcursion~=true and tonumber(aTrajectory.currentAlignedDistanceM or 0)>=currentStableDistanceM and (aTrajectory.currentToEstablishedDot==nil or aTrajectory.currentToEstablishedDot>=persistenceAlignmentMinDot)
                            local bStable=bTrajectory.currentExcursion~=true and tonumber(bTrajectory.currentAlignedDistanceM or 0)>=currentStableDistanceM and (bTrajectory.currentToEstablishedDot==nil or bTrajectory.currentToEstablishedDot>=persistenceAlignmentMinDot)
                            local currentOpposed=closing.resolved==true and closing.currentDirectionDot~=nil and closing.currentDirectionDot<=currentOpposedMaxDot
                            local closingPositive=closing.resolved==true and tonumber(closing.closingRateMps)~=nil and closing.closingRateMps>=minClosingRateMps
                            local positiveOverlap=overlap.positive==true
                            record.subjectCurrentStable=aStable
                            record.otherCurrentStable=bStable
                            record.currentOpposed=currentOpposed
                            record.currentClosingPositive=closingPositive
                            record.currentNonClosingPositive=closing.resolved==true and finite(tonumber(closing.closingRateMps)) and not closingPositive or false
                            record.status="CLASSIFIED"
                            if facing==true and positiveOverlap and currentOpposed and closingPositive and aStable and bStable then
                                record.classification="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT"
                                record.reason="PERSISTENT_OPPOSED_CLOSING_MOTION_WITH_POSITIVE_SUPPORTED_CORRIDOR_OVERLAP"
                                local establishedConservation=establishedConflictConservation(record,aTrajectory,bTrajectory,motionByAssembly[aId],motionByAssembly[bId],spaceByAssembly[aId],spaceByAssembly[bId],aParticipation,bParticipation,context)
                                record.actionSpaceConservation=copy(establishedConservation)
                            else
                                record.classification="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT"
                                if facing~=true then record.reason="MUTUAL_FACING_RELATION_UNRESOLVED"
                                elseif positiveOverlap~=true then record.reason="POSITIVE_SUPPORTED_CORRIDOR_OVERLAP_NOT_YET_ESTABLISHED"
                                elseif currentOpposed~=true then record.reason="CURRENT_MOTION_NOT_YET_SUBSTANTIALLY_OPPOSED"
                                elseif closingPositive~=true then record.reason="CURRENT_CLOSURE_NOT_YET_POSITIVELY_ESTABLISHED"
                                elseif aStable~=true or bStable~=true then record.reason="CURRENT_OPPOSED_MOTION_NOT_YET_PERSISTENT_STABLE"
                                else record.reason="OPPOSED_CONFLICT_REMAINS_POTENTIAL" end
                            end
                        end
                    end
                end
                    record.resolutionSpaceRelationship=resolutionSpaceRelationship(record)
                    result[#result+1]=record
                end
            end
        end
    end
    table.sort(result,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return result
end
