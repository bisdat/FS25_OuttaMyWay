--- Executes exactly one authorised forward Dogleg and relinquishes to the unchanged GIANTS Job.
-- Specification Jurisdictions: `CONTROL`, `BOUNDED_BYPASS`
OuttaMyWay.BoundedBypassControl={}
local Control=OuttaMyWay.BoundedBypassControl
Control.__index=Control
local E=OuttaMyWay.BoundedBypassEvidence
local V=OuttaMyWay.ValueRecord
local SPEED_KMH=6
local TARGET_RADIUS_M=1
-- Evidence age limits permission, not semantic success or failure of GIANTS.
local MAX_EVIDENCE_AGE_S=1
local MAX_BLOCKER_DRIFT_M=0.25
local BLOCKER_SETTLEMENT_WAIT_MS=2000
function Control.new(runtime,mechanisms)
    return setmetatable({runtime=runtime,driveMechanism=mechanisms.driveMechanism,
        configurationMechanism=mechanisms.configurationMechanism},Control)
end
function Control:isActive() return self.active~=nil end
function Control:getStatus() return {active=self.active~=nil,phase=self.active and self.active.phase} end
function Control:loadMap() self.driveMechanism:install() end
function Control:deleteMap() self:relinquishAll("MAP_DELETE") end
function Control:keyEvent() end
function Control:mouseEvent() end
function Control:draw() end
function Control:relinquishAll(reason)
    local state=self.active
    if state==nil then return {released=0,reason=reason} end
    self.driveMechanism:clearMovementObjective(state.vehicle)
    self.configurationMechanism:clear(state.vehicle)
    self.active=nil
    return {released=1,reason=reason}
end
function Control:_finish(status,reason)
    local state=self.active
    if state==nil then return end
    self:relinquishAll(reason)
    local event
    if reason=="BYPASS_JOB_CONTINUITY_LOST" then event="SOURCE_INTENT_TERMINATED"
    elseif reason=="BYPASS_PLAYER_CLAIM" then event="PLAYER_CLAIM" end
    self.runtime.boundedBypassRuntime:complete({status=status,reason=reason,event=event,commitmentId=state.request.commitmentId})
end
-- Fresh execution checks only narrow the selected guide. Losing the causal
-- overlap as we move is expected; blocker identity/stability remain mandatory.
function Control:_validate(state,requireStationary)
    local bridge=state.request.target.bridge
    local live=self.runtime.boundedBypassRuntime.currentByOperation[bridge.operationId]
    if live==nil or (tonumber(g_time) or 0)/1000-live.snapshot.timestamp>MAX_EVIDENCE_AGE_S then return false,"BYPASS_CURRENT_EVIDENCE_UNAVAILABLE" end
    local picture,snapshot=live.picture,live.snapshot
    local episode=self.runtime.jobEpisodes:getActiveForAssembly(state.request.assemblyId)
    if episode==nil or episode.identity~=bridge.jobEpisodeId or episode.sourceJobToken~=bridge.sourceJobToken then return false,"BYPASS_JOB_CONTINUITY_LOST" end
    if E.hasPlayerClaim(snapshot,bridge.assemblyReferenceKey,true) then return false,"BYPASS_PLAYER_CLAIM" end
    if self.runtime.boundedAuthority:validateRequest(state.request)~=true then return false,"BYPASS_BOUNDED_AUTHORITY_LOST" end
    local stability,reason=E.stability(self.runtime,picture,snapshot,bridge.blocker,requireStationary)
    if stability==nil then return false,reason end
    if (stability.x-bridge.blocker.x)^2+(stability.z-bridge.blocker.z)^2>MAX_BLOCKER_DRIFT_M^2 then return false,"BYPASS_BLOCKER_MOVED" end
    if not OuttaMyWay.FixedBypassDogleg.support(snapshot.fieldWorld,bridge.guide) then return false,"BYPASS_FIELD_GUIDE_UNSUPPORTED" end
    local pose=E.pose(snapshot,bridge.assemblyReferenceKey)
    if pose==nil or not OuttaMyWay.FixedBypassDogleg.contains(snapshot.fieldWorld,pose.x,pose.z) then return false,"BYPASS_CURRENT_REFERENCE_OUTSIDE_FIELD" end
    local protection=self.runtime.bubbleBulletTime:getProtection(state.request.commitmentId)
    if protection==nil or (protection.status~="ACTIVE" and protection.status~="NOT_REQUIRED") then return false,"BYPASS_BUBBLE_UNAVAILABLE" end
    local protected={}
    for _,lease in V.ipairs(protection.leases) do
        local control=self.runtime.liveControlDispatcher.regulationControl
        local vehicle=control:_vehicleForReferenceKey(lease.referenceKey)
        local physical=vehicle and control.driveMechanism:getRegulationLease(vehicle,lease.ownerTag)
        if lease.physicalActive~=true or self.runtime.boundedAuthority:get(lease.boundedAuthorityId)==nil
            or physical==nil or physical.speedKmh~=lease.maxSpeedKmh then return false,"BYPASS_BUBBLE_LEASE_LOST" end
        protected[lease.assemblyId]=lease.maxSpeedKmh
    end
    if bridge.blocker.kind=="ACTIVE_BLOCKER_HOLD" and protected[bridge.blocker.assemblyId]~=0 then return false,"BYPASS_BLOCKER_HOLD_LOST" end
    for _,id in V.ipairs(E.members(picture,bridge.operationId)) do
        if id~=bridge.assemblyId and protected[id]==nil then return false,"BYPASS_UNPROTECTED_PARTICIPANT" end
    end
    return true
end
function Control:_beginLeg(state,index)
    local target=state.request.target.bridge.guide.targets[index]
    local ok,reason=self.driveMechanism:setReposition(state.vehicle,target.x,target.z,SPEED_KMH,TARGET_RADIUS_M,true)
    if not ok then self:_finish("FAILED",reason); return false end
    state.legIndex=index; state.phase=target.kind
    return true
end
function Control:executeControlRequest(request)
    if self.active~=nil then return false,"BYPASS_ALREADY_ACTIVE" end
    if request.capability~="REPOSITION" or request.target.kind~="BOUNDED_BYPASS" then return false,"BYPASS_REQUEST_INVALID" end
    if self.runtime.boundedAuthority:validateRequest(request)~=true then return false,"BYPASS_REQUEST_NOT_AUTHORISED" end
    local bridge=request.target.bridge
    local vehicle=self.runtime.liveObservationSource:getCurrentPhysicalObject(bridge.assemblyReferenceKey)
    if vehicle==nil then return false,"BYPASS_VEHICLE_UNAVAILABLE" end
    local state={request=request,vehicle=vehicle,phase="WAITING_FOR_TRANSIT",startedAtMs=tonumber(g_time) or 0}
    local valid,reason=self:_validate(state,false)
    if not valid then return false,reason end
    -- A zero-station, zero-speed objective holds the principal during Transit.
    -- This is configuration protection, not an additional movement leg.
    local f=bridge.guide.frame
    local held,holdReason=self.driveMechanism:setAxisTravel(vehicle,f.x,f.z,f.forwardX,f.forwardZ,0,0,true,1)
    if not held then return false,holdReason end
    self.active=state
    local capability=self.runtime.assemblyRepresentationCache:getTransitFoldCapability(bridge.assemblyReferenceKey,bridge.sourceJobToken)
    local ok,transitReason=self.configurationMechanism:prepareCachedTransit(vehicle,capability,true)
    if not ok then self:_finish("FAILED",transitReason); return false,transitReason end
    return true,{phase=state.phase}
end
function Control:update()
    local state=self.active
    if state==nil then return end
    local valid,reason=self:_validate(state,state.legIndex~=nil)
    if not valid then self:_finish("FAILED",reason); return end
    if self.configurationMechanism:getState(state.vehicle)==nil then self:_finish("FAILED","BYPASS_TRANSIT_AUTHORITY_LOST"); return end
    local settlement=self.configurationMechanism:getCachedTransitSettlement(state.vehicle)
    if settlement.exhausted==true then self:_finish("FAILED","BYPASS_TRANSIT_FAILED"); return end
    if settlement.settled~=true then
        if state.legIndex~=nil then self:_finish("FAILED","BYPASS_TRANSIT_SETTLEMENT_LOST") end
        return
    end
    if state.legIndex==nil then
        -- An acquired hold may still be braking the blocker. No motion begins
        -- until current observed stationarity corroborates the supporting lease.
        local supported=self:_validate(state,true)
        if supported then self:_beginLeg(state,1)
        elseif (tonumber(g_time) or 0)-state.startedAtMs>BLOCKER_SETTLEMENT_WAIT_MS then
            self:_finish("FAILED","BYPASS_BLOCKER_SETTLEMENT_UNRESOLVED")
        end
        return
    end
    local drive=self.driveMechanism:getState(state.vehicle)
    if drive==nil or drive.invalidReason~=nil then self:_finish("FAILED","BYPASS_MOVEMENT_UNAVAILABLE"); return end
    if drive.targetReached==true then
        if state.legIndex==3 then self:_finish("SUCCEEDED","POST_BLOCKAGE_AXIS_REJOIN_REACHED")
        else self:_beginLeg(state,state.legIndex+1) end
    end
end
return Control
