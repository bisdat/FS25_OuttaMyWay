-- Resolution-Space Progression Envelope with Intent-Revelation Creep.
-- Bounded-Authority magnitude policy only. Situation owns the Resolution-Space obligation and
-- role assignment; this module owns the elastic integer Regulation magnitude and unresolved-intent creep floor.

OuttaMyWay.ResolutionSpaceProgressionEnvelope = {}
local Envelope = OuttaMyWay.ResolutionSpaceProgressionEnvelope

-- Resolution-Space Progression Envelope fixed accepted magnitude policy.
-- The reserve is a withheld fraction of positively established usable Resolution
-- Space, not a claimed GIANTS braking distance.
local RESOLUTION_SPACE_CONTINGENCY_RESERVE_FRACTION = 0.75

-- When ordinary Resolution Space is exhausted while intent remains unresolved,
-- retain minimal positive progression rather than Hold so fresh native intent can
-- continue to reveal without spending ordinary Resolution Space authority.
local RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH = 1

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
    local creep=tonumber(state.intentRevelationCreepKmh) or RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH
    if not finite(creep) or creep<RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH then creep=RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH end
    creep=math.floor(creep)
    state.capKmh=math.max(creep,integerCap)
    state.effectClass=integerCap<creep and "INTENT_REVELATION_CREEP" or "REGULATE"
    return state
end

function Envelope.establish(distanceM,speedKmh)
    local distance=tonumber(distanceM)
    local speed=tonumber(speedKmh)
    local reserve=tonumber(RESOLUTION_SPACE_CONTINGENCY_RESERVE_FRACTION)
    local creep=tonumber(RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH)
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
