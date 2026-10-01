--- Evaluates current Bypass frame and blocker stability evidence without granting physical authority.
-- Specification Jurisdictions: `BOUNDED_BYPASS`
OuttaMyWay.BoundedBypassEvidence={}
local Evidence=OuttaMyWay.BoundedBypassEvidence
local V=OuttaMyWay.ValueRecord
local function finite(v) return type(v)=="number" and v==v and math.abs(v)<math.huge end
function Evidence.find(values,id)
    for _,value in V.ipairs(values or {}) do if value.assemblyId==id then return value end end
end
function Evidence.members(picture,operationId)
    for _,situation in V.ipairs(picture.situations or {}) do
        if situation.operationId==operationId then return situation.memberAssemblyIds end
    end
    return {}
end
function Evidence.isMember(picture,operationId,id)
    for _,member in V.ipairs(Evidence.members(picture,operationId)) do if member==id then return true end end
    return false
end
function Evidence.pose(snapshot,reference)
    for _,pose in V.ipairs(snapshot.geometry.currentPhysicalPoseEvidence or {}) do
        if pose.assemblyReferenceKey==reference then return pose end
    end
end
-- Active GIANTS passenger presence does not itself establish Player Claim.
-- Direct player control is authoritative; entry is a claim for a non-active subject.
function Evidence.hasPlayerClaim(snapshot,reference,isActive)
    local player=snapshot.playerControl[reference]
    if player==nil or player.playerControlled==true then return true end
    if isActive==true then return false end
    return player.playerEnteredObserved~=true or player.playerEntered==true
end

-- A current non-turn native continuation plus the current steering heading is a
-- local frame only. No Recovery Trail/Anchor contributes to its direction.
function Evidence.frame(picture,snapshot,knowledge)
    local motion=Evidence.find(picture.motionEvidence,knowledge.assemblyId)
    local continuation=Evidence.find(picture.productiveContinuationKnowledge,knowledge.assemblyId)
    if motion==nil or continuation==nil or motion.sourceJobToken~=knowledge.sourceJobToken
        or continuation.jobToken~=knowledge.sourceJobToken or continuation.productivePositive~=true
        or continuation.isTurn~=false or motion.motionClassification=="TURNING"
        or motion.motionClassification=="REVERSING_OR_OPPOSED_TRAVEL" then return nil end
    local pose=Evidence.pose(snapshot,knowledge.assemblyReferenceKey)
    local x,z=motion.headingX,motion.headingZ
    if pose==nil or not finite(x) or not finite(z) then return nil end
    local length=math.sqrt(x*x+z*z)
    if length<0.001 then return nil end
    return {x=pose.x,z=pose.z,forwardX=x/length,forwardZ=z/length,rightX=z/length,rightZ=-x/length,
        jobEpisodeId=knowledge.jobEpisodeId,sourceJobToken=knowledge.sourceJobToken,observationSnapshotId=snapshot.identity}
end
-- Positive mechanical availability is admission support, not a lease. The actual
-- supporting grant and physical lease must still be acquired before movement.
function Evidence.canHold(runtime,reference)
    local control=runtime.liveControlDispatcher and runtime.liveControlDispatcher.regulationControl
    local drive=control and control.driveMechanism
    return runtime.bubbleBulletTime~=nil and control~=nil and drive~=nil and drive.installed==true
        and type(drive.getRegulationLease)=="function"
        and control:_vehicleForReferenceKey(reference)~=nil
end
function Evidence.stability(runtime,picture,snapshot,blocker,executing)
    local episode=runtime.jobEpisodes:getActiveForAssembly(blocker.assemblyId)
    if Evidence.hasPlayerClaim(snapshot,blocker.assemblyReferenceKey,episode~=nil) then return nil,"BYPASS_BLOCKER_PLAYER_CLAIM_UNRESOLVED_OR_PRESENT" end
    local pose=Evidence.pose(snapshot,blocker.assemblyReferenceKey)
    if pose==nil then return nil,"BYPASS_BLOCKER_CURRENT_POSE_UNAVAILABLE" end
    local motion=Evidence.find(picture.motionEvidence,blocker.assemblyId)
    local ai=snapshot.aiStates[blocker.assemblyReferenceKey]
    if episode~=nil then
        if blocker.kind=="NON_ACTIVE_STATIONARY" then return nil,"BYPASS_BLOCKER_ACTIVITY_CHANGED" end
        if ai==nil or ai.observedActive~=true then return nil,"BYPASS_BLOCKER_ACTIVITY_UNRESOLVED" end
        if not Evidence.isMember(picture,blocker.operationId,blocker.assemblyId)
            or not Evidence.canHold(runtime,blocker.assemblyReferenceKey) then return nil,"BYPASS_BLOCKER_HOLD_UNAVAILABLE" end
        if blocker.jobEpisodeId~=nil and episode.identity~=blocker.jobEpisodeId then return nil,"BYPASS_BLOCKER_JOB_CHANGED" end
        if executing and (motion==nil or motion.motionClassification~="STATIONARY") then return nil,"BYPASS_BLOCKER_NOT_STATIONARY" end
        return {kind="ACTIVE_BLOCKER_HOLD",jobEpisodeId=episode.identity,x=pose.x,z=pose.z}
    end
    if blocker.kind=="ACTIVE_BLOCKER_HOLD" then return nil,"BYPASS_BLOCKER_JOB_ENDED" end
    if ai==nil or ai.aiActiveObserved~=true or ai.aiActive==true or ai.observedActive==true
        or motion==nil or motion.motionClassification~="STATIONARY"
        or not finite(motion.positionDerivedSpeedMps) or not finite(motion.reportedSpeedMps)
        or math.abs(motion.positionDerivedSpeedMps)>=0.05 or math.abs(motion.reportedSpeedMps)>=0.05 then
        return nil,"BYPASS_BLOCKER_STABILITY_UNRESOLVED"
    end
    return {kind="NON_ACTIVE_STATIONARY",x=pose.x,z=pose.z}
end
