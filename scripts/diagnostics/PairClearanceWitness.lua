-- Finite, passive evidence of paired Egress and physical separation over time.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- Never asserts clearance, controls GIANTS, or changes egress completion.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.PairClearanceWitness={}
local Witness=OuttaMyWay.PairClearanceWitness
Witness.__index=Witness

local MOVE_OFFSETS_MS={1500,3500,5500}
local HOLD_OFFSETS_MS={2000,5000}
local POST_OFFSETS_MS={1000,3000,5000}
local function finite(x)
    return type(x)=="number" and x==x
        and x~=math.huge and x~=-math.huge
end
local function location(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function" then return nil,nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if not ok or not finite(x) or not finite(z) then return nil,nil end
    return x,z
end
local function heading(vehicle)
    if type(vehicle)~="table" or type(vehicle.getAISteeringNode)~="function"
        or type(localDirectionToWorld)~="function" then return nil,nil end
    local ok,node=pcall(vehicle.getAISteeringNode,vehicle)
    if not ok or node==nil then return nil,nil end
    local oriented,x,_,z=pcall(localDirectionToWorld,node,0,0,1)
    if not oriented or not finite(x) or not finite(z) then return nil,nil end
    local len=math.sqrt(x*x+z*z)
    if len<0.00001 then return nil,nil end
    return x/len,z/len
end
local function publish(state,code,payload)
    local publisher=state.publisher
    if type(publisher)~="table"
        or type(publisher.publish)~="function" then return end
    pcall(publisher.publish,publisher,"NORMAL","INFO",code,function()
        payload.version=OuttaMyWay.VERSION
        return payload
    end)
end
local function sample(state,nowMs,milestone)
    local a,b=state.mover,state.peer
    local x,z=location(a.vehicle)
    local px,pz=location(b.vehicle)
    local rootGap=x~=nil and px~=nil
        and math.sqrt((px-x)^2+(pz-z)^2) or nil
    local currentGap,gapReason=nil,nil
    if type(OuttaMyWay.PairTransitRegion)=="table"
        and type(OuttaMyWay.PairTransitRegion.observePairNominalGap)=="function" then
        local ok,gap,reason=pcall(
            OuttaMyWay.PairTransitRegion.observePairNominalGap,
            a.transitFootprint,b.transitFootprint)
        if ok and finite(gap) then currentGap=gap
        else gapReason=ok and reason or "NOMINAL_ENVELOPE_EXCEPTION" end
    else gapReason="NOMINAL_ENVELOPE_API_UNAVAILABLE" end
    local elapsedMs=nowMs-state.startedMs
    local closingMps=nil
    if currentGap~=nil and state.lastGap~=nil
        and finite(nowMs-state.lastAt) and nowMs>state.lastAt then
        closingMps=(state.lastGap-currentGap)*1000/(nowMs-state.lastAt)
    end
    -- A straight-line instantaneous trend only, not predicted collision time.
    local nominalTtcS=nil
    if closingMps~=nil and closingMps>0.05 and currentGap>0 then
        nominalTtcS=currentGap/closingMps
    end
    local progress=x~=nil and type(OuttaMyWay.ProjectedEgressRegion)=="table"
        and OuttaMyWay.ProjectedEgressRegion.progress(
            state.objective.returnRegion,x,z) or nil
    local hx,hz=heading(a.vehicle)
    local phx,phz=heading(b.vehicle)
    publish(state,"PAIR_CLEARANCE_OBSERVATION",{
        commitmentId=state.commitmentId,milestone=milestone,
        elapsedMs=elapsedMs,
        objectiveDistanceM=state.objective.regionTravelM,
        directionSource=state.objective.directionSource,
        moverRoot=tostring(a.assemblyReferenceKey),
        peerRoot=tostring(b.assemblyReferenceKey),
        moverX=x,moverZ=z,peerX=px,peerZ=pz,
        moverHeadingX=hx,moverHeadingZ=hz,
        peerHeadingX=phx,peerHeadingZ=phz,
        rootSeparationM=rootGap,
        nominalMemberEnvelopeGapM=currentGap,
        nominalGapUnavailable=gapReason,
        observedNominalGapClosingMps=closingMps,
        straightLineNominalTimeToZeroS=nominalTtcS,
        projectedMoverTravelM=progress and progress.progressM,
        moverLateralDepartureM=progress and progress.lateralOffsetM,
        evidence="CURRENT_MEMBER_BASE_SIZE_PROXY_NOT_COLLISION_CLEARANCE"
    })
    state.lastAt=nowMs
    state.lastGap=currentGap
end
function Witness.new(publisher)
    return setmetatable({publisher=publisher,active=nil},Witness)
end
function Witness:discard()
    self.active=nil
end
function Witness:finish(nowMs,reason)
    local state=self.active
    if state==nil then return end
    if finite(nowMs) and nowMs>=state.startedMs then
        sample(state,nowMs,reason or "OBSERVATION_FINISHED")
    end
    self.active=nil
end
function Witness:begin(nowMs,state)
    if not finite(nowMs) or type(state)~="table"
        or state.isSingle or state.isStatic
        or type(state.relocator)~="table"
        or type(state.blockers)~="table"
        or type(state.blockers[1])~="table"
        or type(state.objective)~="table" then return false end
    if self.active~=nil then self:finish(nowMs,"SUPERSEDED") end
    self.active={publisher=self.publisher,
        startedMs=nowMs,stageStartMs=nowMs,
        commitmentId=state.commitmentId,
        mover=state.relocator,peer=state.blockers[1],
        objective=state.objective,stage="MOVING",
        nextIndex=1,lastAt=nil,lastGap=nil}
    sample(self.active,nowMs,"EGRESS_STARTED")
    return true
end
function Witness:milestone(nowMs,label)
    local state=self.active
    if state==nil or not finite(nowMs) or nowMs<state.startedMs then return end
    if label=="RETURN_REGION_REACHED" and state.stage=="MOVING" then
        sample(state,nowMs,label)
        state.stage="HOLD";state.stageStartMs=nowMs;state.nextIndex=1
    elseif label=="NATIVE_RESTART_ACCEPTED" then
        sample(state,nowMs,label)
        state.stage="POST_HAND_BACK";state.stageStartMs=nowMs;state.nextIndex=1
    elseif label=="REGULATION_ENDED" then
        sample(state,nowMs,label)
    elseif label=="EGRESS_INTERRUPTED" or label=="CONTROL_INTERRUPTED" then
        self:finish(nowMs,label)
    end
end
function Witness:advance(nowMs)
    local state=self.active
    if state==nil then return end
    if not finite(nowMs) or nowMs<state.stageStartMs then
        self:discard()
        return
    end
    local offsets=state.stage=="MOVING" and MOVE_OFFSETS_MS
        or state.stage=="HOLD" and HOLD_OFFSETS_MS
        or POST_OFFSETS_MS
    local due=offsets[state.nextIndex]
    if due==nil or nowMs-state.stageStartMs<due then return end
    sample(state,nowMs,state.stage.."_OBSERVATION")
    -- Do not batch multiple overdue samples at one moment. A slow update
    -- skips obsolete deadlines rather than inventing independent evidence.
    repeat
        state.nextIndex=state.nextIndex+1
        due=offsets[state.nextIndex]
    until due==nil or nowMs-state.stageStartMs<due
    if due==nil and state.stage=="POST_HAND_BACK" then self:discard() end
end
