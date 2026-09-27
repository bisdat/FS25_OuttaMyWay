--- Diagnostic-only probe for bounded Realised Motion Demand.
-- This instrument consumes already-published Situation/Observation evidence.
-- It creates no Situation meaning, Candidate support, Decision authority or Control authority.

OuttaMyWay.RealisedMotionDemandProbe={}
local Probe=OuttaMyWay.RealisedMotionDemandProbe

local LOOKAHEAD_MAX_M=100.0
local MIN_REALISED_SPEED_MPS=0.05
local TRAJECTORY_ALIGNMENT_MIN_DOT=0.85

Probe.LOOKAHEAD_MAX_M=LOOKAHEAD_MAX_M

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
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

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if type(item.assemblyId)=="string" then result[item.assemblyId]=item end
    end
    return result
end

local function operationByAssembly(picture)
    local result={}
    for _,situation in OuttaMyWay.ValueRecord.ipairs(picture and picture.situations or {}) do
        for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(situation.memberAssemblyIds or {}) do
            result[assemblyId]=situation.operationId
        end
    end
    return result
end

local function blockerClassification(snapshot,physical)
    local referenceKey=physical and physical.assemblyReferenceKey or nil
    local aiState=referenceKey and snapshot and snapshot.aiStates and snapshot.aiStates[referenceKey] or nil
    local player=referenceKey and snapshot and snapshot.playerControl and snapshot.playerControl[referenceKey] or nil

    if type(aiState)~="table" or aiState.aiActiveObserved~=true then
        return "ACTIVITY_UNRESOLVED",false
    end
    if aiState.observedActive==true or aiState.aiActive==true then
        return "ACTIVE_GIANTS_AI",false
    end
    if type(player)~="table" or player.playerEnteredObserved~=true then
        return "PLAYER_CLAIM_UNRESOLVED",false
    end
    if player.playerEntered==true then
        return "NON_ACTIVE_PLAYER_CLAIMED",false
    end
    return "NON_ACTIVE_UNCLAIMED",true
end

local function usableDisc(primitive)
    return type(primitive)=="table"
        and primitive.kind=="DISC"
        and primitive.positiveConflictSupport==true
        and finite(primitive.x) and finite(primitive.z)
        and finite(primitive.radius) and primitive.radius>=0
end

local function firstTouch(beneficiaryPhysical,blockerPhysical,dx,dz,horizonM)
    local best=nil
    for _,beneficiary in OuttaMyWay.ValueRecord.ipairs(beneficiaryPhysical and beneficiaryPhysical.primitives or {}) do
        if usableDisc(beneficiary) then
            for _,blocker in OuttaMyWay.ValueRecord.ipairs(blockerPhysical and blockerPhysical.primitives or {}) do
                if usableDisc(blocker) then
                    local rx,rz=blocker.x-beneficiary.x,blocker.z-beneficiary.z
                    local forward=rx*dx+rz*dz
                    local lateralSquared=math.max(0,rx*rx+rz*rz-forward*forward)
                    local required=beneficiary.radius+blocker.radius
                    local requiredSquared=required*required
                    if lateralSquared<=requiredSquared then
                        local halfChord=math.sqrt(math.max(0,requiredSquared-lateralSquared))
                        local entry=forward-halfChord
                        local exit=forward+halfChord
                        if exit>=0 and entry<=horizonM then
                            local witnessDistance=math.max(0,entry)
                            if witnessDistance<=horizonM and (best==nil or witnessDistance<best.witnessDistanceM) then
                                best={
                                    witnessDistanceM=witnessDistance,
                                    centreForwardDistanceM=forward,
                                    lateralOffsetM=math.sqrt(lateralSquared),
                                    requiredM=required,
                                    beneficiaryPrimitiveId=beneficiary.identity,
                                    blockerPrimitiveId=blocker.identity
                                }
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function demandState(trajectory,motion)
    if trajectory==nil or trajectory.established~=true then
        return nil,"ESTABLISHED_TRAJECTORY_UNAVAILABLE"
    end
    if trajectory.currentExcursion==true then
        return nil,"CURRENT_TRAJECTORY_EXCURSION"
    end

    local speed=motion and tonumber(motion.positionDerivedSpeedMps) or nil
    if not finite(speed) or speed<MIN_REALISED_SPEED_MPS then
        return nil,"POSITIVE_REALISED_MOTION_UNAVAILABLE"
    end

    local currentX,currentZ=normalize(
        motion and tonumber(motion.travelDirectionX) or nil,
        motion and tonumber(motion.travelDirectionZ) or nil)
    local establishedX,establishedZ=normalize(
        tonumber(trajectory.establishedDirectionX),
        tonumber(trajectory.establishedDirectionZ))
    if currentX==nil or establishedX==nil then
        return nil,"CURRENT_OR_ESTABLISHED_DIRECTION_UNAVAILABLE"
    end

    local alignment=dot(currentX,currentZ,establishedX,establishedZ)
    if not finite(alignment) or alignment<TRAJECTORY_ALIGNMENT_MIN_DOT then
        return nil,"CURRENT_MOTION_NOT_ALIGNED_WITH_ESTABLISHED_TRAJECTORY"
    end

    return {
        speedMps=speed,
        directionX=establishedX,directionZ=establishedZ,
        currentDirectionX=currentX,currentDirectionZ=currentZ,
        alignment=alignment
    },nil
end

function Probe.evaluate(picture,snapshot)
    local demands={}
    local relations={}
    if type(picture)~="table" or type(snapshot)~="table" then
        return {demands=demands,relations=relations,lookaheadMaxM=LOOKAHEAD_MAX_M,diagnosticOnly=true}
    end

    local operationByMember=operationByAssembly(picture)
    local motionByMember=byAssembly(picture.motionEvidence)
    local physicalByMember=byAssembly(picture.physicalSpaceEvidence)
    local trajectoryByMember=byAssembly(picture.trajectoryKnowledge)

    local beneficiaryIds={}
    for assemblyId in OuttaMyWay.ValueRecord.pairs(operationByMember) do beneficiaryIds[#beneficiaryIds+1]=assemblyId end
    table.sort(beneficiaryIds)

    local blockerIds={}
    for assemblyId in OuttaMyWay.ValueRecord.pairs(physicalByMember) do blockerIds[#blockerIds+1]=assemblyId end
    table.sort(blockerIds)

    for _,beneficiaryId in ipairs(beneficiaryIds) do
        local operationId=operationByMember[beneficiaryId]
        local motion=motionByMember[beneficiaryId]
        local trajectory=trajectoryByMember[beneficiaryId]
        local physical=physicalByMember[beneficiaryId]
        local state,reason=demandState(trajectory,motion)
        local demand={
            beneficiaryAssemblyId=beneficiaryId,
            beneficiaryReferenceKey=physical and physical.assemblyReferenceKey or (motion and motion.assemblyReferenceKey) or nil,
            operationId=operationId,
            status=state~=nil and "ACTIVE" or "UNRESOLVED",
            reason=reason or "ESTABLISHED_REALISED_TRAJECTORY_WITH_BOUNDED_LOCAL_LOOKAHEAD",
            lookaheadM=LOOKAHEAD_MAX_M,
            speedMps=state and state.speedMps or nil,
            alignment=state and state.alignment or nil,
            currentAlignedDistanceM=trajectory and trajectory.currentAlignedDistanceM or nil,
            currentMotionClassification=motion and motion.motionClassification or nil,
            localIntentClassification=motion and motion.localIntentClassification or nil,
            productiveContextPositive=trajectory and trajectory.contextProductivePositive==true or false,
            positiveIntersectionCount=0,
            relocationEligibleIntersectionCount=0,
            nearestWitnessDistanceM=nil,
            nearestTimeToWitnessSeconds=nil,
            authority="DIAGNOSTIC_ONLY",
            decisionAuthority=false,controlAuthority=false,semanticAuthority=false
        }

        if state~=nil and physical~=nil then
            for _,blockerId in ipairs(blockerIds) do
                if blockerId~=beneficiaryId then
                    local blockerPhysical=physicalByMember[blockerId]
                    local classification,relocationEligible=blockerClassification(snapshot,blockerPhysical)
                    if classification~="ACTIVE_GIANTS_AI" then
                        local touch=firstTouch(
                            physical,blockerPhysical,
                            state.directionX,state.directionZ,
                            LOOKAHEAD_MAX_M)
                        if touch~=nil then
                            local timeToWitness=state.speedMps>0 and touch.witnessDistanceM/state.speedMps or nil
                            local relation={
                                identity="diagnostic-realised-motion-demand:"..tostring(beneficiaryId).."->"..tostring(blockerId),
                                operationId=operationId,
                                beneficiaryAssemblyId=beneficiaryId,
                                beneficiaryReferenceKey=demand.beneficiaryReferenceKey,
                                blockerAssemblyId=blockerId,
                                blockerReferenceKey=blockerPhysical and blockerPhysical.assemblyReferenceKey or nil,
                                blockerClassification=classification,
                                relocationEligible=relocationEligible==true,
                                positive=true,
                                lookaheadM=LOOKAHEAD_MAX_M,
                                witnessDistanceM=touch.witnessDistanceM,
                                timeToWitnessSeconds=timeToWitness,
                                closingRateMps=state.speedMps,
                                centreForwardDistanceM=touch.centreForwardDistanceM,
                                lateralOffsetM=touch.lateralOffsetM,
                                requiredM=touch.requiredM,
                                beneficiaryPrimitiveId=touch.beneficiaryPrimitiveId,
                                blockerPrimitiveId=touch.blockerPrimitiveId,
                                alignment=state.alignment,
                                currentMotionClassification=motion and motion.motionClassification or nil,
                                localIntentClassification=motion and motion.localIntentClassification or nil,
                                productiveContextPositive=trajectory and trajectory.contextProductivePositive==true or false,
                                authority="DIAGNOSTIC_ONLY",
                                decisionAuthority=false,controlAuthority=false,semanticAuthority=false
                            }
                            relations[#relations+1]=relation
                            demand.positiveIntersectionCount=demand.positiveIntersectionCount+1
                            if relocationEligible==true then
                                demand.relocationEligibleIntersectionCount=demand.relocationEligibleIntersectionCount+1
                            end
                            if demand.nearestWitnessDistanceM==nil or touch.witnessDistanceM<demand.nearestWitnessDistanceM then
                                demand.nearestWitnessDistanceM=touch.witnessDistanceM
                                demand.nearestTimeToWitnessSeconds=timeToWitness
                            end
                        end
                    end
                end
            end
        end

        demands[#demands+1]=demand
    end

    table.sort(relations,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return {
        demands=demands,
        relations=relations,
        lookaheadMaxM=LOOKAHEAD_MAX_M,
        diagnosticOnly=true
    }
end
