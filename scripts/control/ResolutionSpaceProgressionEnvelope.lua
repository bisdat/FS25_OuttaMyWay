-- FS25_OuttaMyWay v0.1.3.0 CANONICAL CANDIDATE — D-0155 Resolution-Space Progression Envelope with Intent-Revelation Creep.
-- Control-magnitude policy only. Situation owns the Resolution-Space obligation and
-- role assignment; this module owns the elastic integer Regulation magnitude and unresolved-intent creep floor.

OuttaMyWay.ResolutionSpaceProgressionEnvelope = {}
local Envelope = OuttaMyWay.ResolutionSpaceProgressionEnvelope

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function clamp(value,minimum,maximum)
    if value<minimum then return minimum end
    if value>maximum then return maximum end
    return value
end

local function derive(state,separationM)
    local separation=tonumber(separationM)
    if finite(separation) and separation>=0 then
        state.currentPhysicalDistanceM=separation
        if separation<state.conservativeDistanceM then state.conservativeDistanceM=separation end
    end
    state.reverseCreatedReserveM=math.max(0,(tonumber(state.currentPhysicalDistanceM) or state.conservativeDistanceM)-state.conservativeDistanceM)
    state.remainingOrdinaryM=math.max(0,state.conservativeDistanceM-state.contingencyReserveM)

    local startOrdinary=tonumber(state.policyStartOrdinaryM) or 0
    local startSpeed=tonumber(state.policyStartSpeedKmh) or 0
    local raw=0
    if startOrdinary>0 and state.remainingOrdinaryM>0 and startSpeed>0 then
        raw=startSpeed*math.sqrt(clamp(state.remainingOrdinaryM/startOrdinary,0,1))
    end
    state.rawCapKmh=raw
    local integerCap=math.max(0,math.floor(raw+0.0000001))
    local creep=tonumber(state.intentRevelationCreepKmh) or 1
    if not finite(creep) or creep<1 then creep=1 end
    creep=math.floor(creep)
    state.capKmh=math.max(creep,integerCap)
    state.effectClass=integerCap<creep and "INTENT_REVELATION_CREEP" or "REGULATE"
    return state
end

function Envelope.establish(distanceM,speedKmh,reserveFraction,intentRevelationCreepKmh)
    local distance=tonumber(distanceM)
    local speed=tonumber(speedKmh)
    local reserve=tonumber(reserveFraction)
    local creep=tonumber(intentRevelationCreepKmh) or 1
    if not finite(distance) or distance<=0 then return nil,"RESOLUTION_SPACE_INITIAL_DISTANCE_UNAVAILABLE" end
    if not finite(speed) or speed<0 then return nil,"RESOLUTION_SPACE_INITIAL_SPEED_UNAVAILABLE" end
    if not finite(reserve) or reserve<0 or reserve>=1 then return nil,"RESOLUTION_SPACE_RESERVE_FRACTION_INVALID" end
    if not finite(creep) or creep<1 then return nil,"RESOLUTION_SPACE_INTENT_REVELATION_CREEP_INVALID" end
    creep=math.floor(creep)

    local contingency=distance*reserve
    local ordinary=distance-contingency
    local speedMps=speed/3.6
    local state={
        initialDistanceM=distance,reserveFraction=reserve,contingencyReserveM=contingency,
        ordinaryInitialM=ordinary,conservativeDistanceM=distance,currentPhysicalDistanceM=distance,
        reverseCreatedReserveM=0,remainingOrdinaryM=ordinary,intentRevelationCreepKmh=creep,
        policyStartSpeedKmh=speed,policyStartOrdinaryM=ordinary,
        policyDecelerationMps2=ordinary>0 and -(speedMps*speedMps)/(2*ordinary) or 0,
        roleRebaseCount=0
    }
    return derive(state,distance),nil
end

function Envelope.update(state,separationM)
    if type(state)~="table" then return nil,"RESOLUTION_SPACE_ENVELOPE_STATE_UNAVAILABLE" end
    local separation=tonumber(separationM)
    if not finite(separation) or separation<0 then return state,"RESOLUTION_SPACE_CURRENT_DISTANCE_UNAVAILABLE" end
    return derive(state,separation),nil
end

function Envelope.rebaseRole(state,newSpeedKmh,separationM)
    if type(state)~="table" then return nil,"RESOLUTION_SPACE_ENVELOPE_STATE_UNAVAILABLE" end
    local speed=tonumber(newSpeedKmh)
    if not finite(speed) or speed<0 then return state,"RESOLUTION_SPACE_ROLE_REBASE_SPEED_UNAVAILABLE" end
    local updated,reason=Envelope.update(state,separationM)
    if reason~=nil then return updated,reason end
    updated.policyStartSpeedKmh=speed
    updated.policyStartOrdinaryM=updated.remainingOrdinaryM
    local speedMps=speed/3.6
    updated.policyDecelerationMps2=updated.policyStartOrdinaryM>0 and -(speedMps*speedMps)/(2*updated.policyStartOrdinaryM) or 0
    updated.roleRebaseCount=(tonumber(updated.roleRebaseCount) or 0)+1
    return derive(updated,updated.currentPhysicalDistanceM),nil
end

function Envelope.snapshot(state)
    if type(state)~="table" then return nil end
    local result={}
    for key,value in pairs(state) do result[key]=value end
    return result
end
