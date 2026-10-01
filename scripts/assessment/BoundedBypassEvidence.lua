--- Evaluates current Bypass frame and optional active-blocker coordination evidence without granting physical authority.
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

-- A current positive Causal Obstruction matters to Bypass only when it names an
-- active same-Operation GIANTS participant that requires the 0 km/h Bubble hold.
-- Missing or non-active obstacle identity is not an admission veto.
function Evidence.activeCausalBlockerIds(runtime,picture,operationId,beneficiaryAssemblyId)
    local result,seen={},{}
    for _,relation in V.ipairs(picture.causalObstructionKnowledge or {}) do
        local id=relation.blockerAssemblyId
        if relation.operationId==operationId and relation.beneficiaryAssemblyId==beneficiaryAssemblyId
            and relation.provenance and relation.provenance.authority=="CURRENT_POSITIVE_CAUSAL_OBSTRUCTION"
            and id~=nil and id~=beneficiaryAssemblyId and seen[id]~=true
            and Evidence.isMember(picture,operationId,id)
            and runtime.jobEpisodes:getActiveForAssembly(id)~=nil then
            result[#result+1]=id
            seen[id]=true
        end
    end
    return result
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
