--- Applies and restores a temporary GIANTS Cruise Control ceiling for a Cooperative Passage pair.
-- Specification Jurisdictions: `REGULATION`, `COOPERATIVE_PASSAGE`, `CONTROL`

OuttaMyWay.PassageCruiseControl={}
local Cruise=OuttaMyWay.PassageCruiseControl
Cruise.__index=Cruise

local PASSAGE_CRUISE_CEILING_KMH=10.0

local publication=OuttaMyWay.LogPublication.origin("CONTROL")
local function logInfo(code,formatText,...)
    return publication:info("DEBUG",code,formatText,...)
end
local function logWarning(code,formatText,...)
    return publication:warning("NORMAL",code,formatText,...)
end

local function referenceKey(vehicle)
    return "vehicle-root:"..tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function activeVehicles()
    if OuttaMyWay.LiveAIJobEvidence==nil or type(OuttaMyWay.LiveAIJobEvidence.activeJobVehicles)~="function" then return {} end
    return OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)
end

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

function Cruise.new()
    return setmetatable({leasesByCommitmentId={}},Cruise)
end

function Cruise:_vehicleForReferenceKey(referenceKeyValue)
    if type(referenceKeyValue)~="string" then return nil end
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(activeVehicles()) do
        if referenceKey(vehicle)==referenceKeyValue then return vehicle end
    end
    return nil
end

function Cruise:_snapshot(vehicle)
    local spec=vehicle and vehicle.spec_drivable or nil
    local cruise=spec and spec.cruiseControl or nil
    if type(cruise)~="table" then return nil,"PASSAGE_CRUISE_CONTROL_STATE_UNAVAILABLE" end
    local forward=tonumber(cruise.speed)
    local reverse=tonumber(cruise.speedReverse)
    if not finite(forward) or not finite(reverse) then
        return nil,"PASSAGE_CRUISE_CONTROL_SPEEDS_UNAVAILABLE"
    end
    local state=nil
    if type(vehicle.getCruiseControlState)=="function" then
        local ok,value=pcall(vehicle.getCruiseControlState,vehicle)
        if ok then state=value end
    elseif cruise.state~=nil then
        state=cruise.state
    end
    return {forwardKmh=forward,reverseKmh=reverse,state=state},nil
end

function Cruise:_set(vehicle,forwardKmh,reverseKmh)
    if vehicle==nil or type(vehicle.setCruiseControlMaxSpeed)~="function" then
        return false,"PASSAGE_CRUISE_CONTROL_SETTER_UNAVAILABLE"
    end
    if not finite(forwardKmh) or not finite(reverseKmh) then
        return false,"PASSAGE_CRUISE_CONTROL_TARGET_INVALID"
    end
    local ok,reason=pcall(vehicle.setCruiseControlMaxSpeed,vehicle,forwardKmh,reverseKmh)
    if not ok then return false,"PASSAGE_CRUISE_CONTROL_SET_FAILED:"..tostring(reason) end

    -- GIANTS owns the authoritative AI behaviour. The event mirrors the server-side
    -- configuration to connected clients; the direct setter is the server-side effect.
    if g_server~=nil and SetCruiseControlSpeedEvent~=nil and type(SetCruiseControlSpeedEvent.new)=="function"
        and type(g_server.broadcastEvent)=="function" then
        local eventOk,event=pcall(SetCruiseControlSpeedEvent.new,vehicle,forwardKmh,reverseKmh)
        if eventOk and event~=nil then
            pcall(g_server.broadcastEvent,g_server,event,false,nil,vehicle)
        end
    end
    return true,nil
end

function Cruise:acquirePair(commitmentId,participants,ceilingKmh)
    if type(commitmentId)~="string" then return false,"PASSAGE_CRUISE_COMMITMENT_REQUIRED" end
    if self.leasesByCommitmentId[commitmentId]~=nil then return true,"PASSAGE_CRUISE_ALREADY_APPLIED" end
    local ceiling=tonumber(ceilingKmh) or PASSAGE_CRUISE_CEILING_KMH
    if not finite(ceiling) or ceiling<=0 then return false,"PASSAGE_CRUISE_CEILING_INVALID" end
    if OuttaMyWay.ValueRecord.length(participants or {})~=2 then return false,"PASSAGE_CRUISE_REQUIRES_TWO_PARTICIPANTS" end

    local prepared={}
    local seen={}
    for _,participant in OuttaMyWay.ValueRecord.ipairs(participants or {}) do
        local ref=participant and participant.referenceKey or nil
        local assemblyId=participant and participant.assemblyId or nil
        if type(ref)~="string" or type(assemblyId)~="string" or seen[ref] then
            return false,"PASSAGE_CRUISE_PARTICIPANT_CONTEXT_INVALID"
        end
        seen[ref]=true
        local vehicle=self:_vehicleForReferenceKey(ref)
        if vehicle==nil then return false,"PASSAGE_CRUISE_VEHICLE_UNAVAILABLE:"..tostring(ref) end
        local original,reason=self:_snapshot(vehicle)
        if original==nil then return false,reason..":"..tostring(ref) end
        prepared[#prepared+1]={
            assemblyId=assemblyId,referenceKey=ref,vehicle=vehicle,original=original,
            appliedForwardKmh=math.min(original.forwardKmh,ceiling),
            appliedReverseKmh=math.min(original.reverseKmh,ceiling)
        }
    end

    local appliedCount=0
    for _,entry in OuttaMyWay.ValueRecord.ipairs(prepared) do
        local ok,reason=self:_set(entry.vehicle,entry.appliedForwardKmh,entry.appliedReverseKmh)
        if not ok then
            for index=1,appliedCount do
                local applied=prepared[index]
                self:_set(applied.vehicle,applied.original.forwardKmh,applied.original.reverseKmh)
            end
            return false,"PASSAGE_CRUISE_PAIR_APPLY_FAILED:"..tostring(reason)
        end
        appliedCount=appliedCount+1
    end

    self.leasesByCommitmentId[commitmentId]={
        commitmentId=commitmentId,ceilingKmh=ceiling,participants=prepared
    }
    logInfo("PASSAGE_CRUISE_CEILING_APPLIED",
        "commitment=%s ceiling=%.2fkmh A=%s original=%.2f/%.2f applied=%.2f/%.2f B=%s original=%.2f/%.2f applied=%.2f/%.2f",
        tostring(commitmentId),ceiling,
        tostring(prepared[1].assemblyId),prepared[1].original.forwardKmh,prepared[1].original.reverseKmh,prepared[1].appliedForwardKmh,prepared[1].appliedReverseKmh,
        tostring(prepared[2].assemblyId),prepared[2].original.forwardKmh,prepared[2].original.reverseKmh,prepared[2].appliedForwardKmh,prepared[2].appliedReverseKmh)
    return true,"PASSAGE_CRUISE_PAIR_APPLIED"
end

function Cruise:releaseForCommitment(commitmentId,reason)
    local lease=self.leasesByCommitmentId[commitmentId]
    if lease==nil then return false,"PASSAGE_CRUISE_NOT_APPLIED" end
    local restored=0
    for _,entry in OuttaMyWay.ValueRecord.ipairs(lease.participants or {}) do
        local vehicle=self:_vehicleForReferenceKey(entry.referenceKey) or entry.vehicle
        if vehicle~=nil then
            local ok,restoreReason=self:_set(vehicle,entry.original.forwardKmh,entry.original.reverseKmh)
            if ok then
                restored=restored+1
            else
                logWarning("PASSAGE_CRUISE_RESTORE_FAILED","commitment=%s assembly=%s ref=%s reason=%s",
                    tostring(commitmentId),tostring(entry.assemblyId),tostring(entry.referenceKey),tostring(restoreReason))
            end
        end
    end
    self.leasesByCommitmentId[commitmentId]=nil
    logInfo("PASSAGE_CRUISE_CEILING_RESTORED","commitment=%s restored=%d reason=%s",
        tostring(commitmentId),restored,tostring(reason or "PASSAGE_COMPLETE"))
    return true,"PASSAGE_CRUISE_RESTORED"
end

function Cruise:releaseAll(reason)
    local ids={}
    for commitmentId,_ in OuttaMyWay.ValueRecord.pairs(self.leasesByCommitmentId) do ids[#ids+1]=commitmentId end
    for _,commitmentId in OuttaMyWay.ValueRecord.ipairs(ids) do
        self:releaseForCommitment(commitmentId,reason or "PASSAGE_CRUISE_RELEASE_ALL")
    end
    return OuttaMyWay.ValueRecord.length(ids)
end

function Cruise:hasLease(commitmentId)
    return self.leasesByCommitmentId[commitmentId]~=nil
end

function Cruise:getLease(commitmentId)
    return self.leasesByCommitmentId[commitmentId]
end

function Cruise:getCeilingKmh()
    return PASSAGE_CRUISE_CEILING_KMH
end
