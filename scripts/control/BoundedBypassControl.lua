--- Executes exactly one authorised bounded Dogleg and relinquishes to the unchanged GIANTS Job.
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
-- A watchdog bounds observation of non-improving target residual. Elapsed time
-- alone is never the failure evidence.
local TARGET_PROGRESS_WATCHDOG_MS=10000
local TARGET_PROGRESS_EPSILON_M=0.10
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
function Control:_beginRepresentationConfigurationAuthority(state)
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    if cache==nil or type(cache.beginOuttaMyWayConfigurationAuthority)~="function" then
        return false,"BYPASS_REPRESENTATION_CONFIGURATION_AUTHORITY_UNAVAILABLE"
    end
    cache:beginOuttaMyWayConfigurationAuthority(state.request.target.bridge.assemblyReferenceKey,
        state.request.target.bridge.sourceJobToken)
    state.representationConfigurationAuthority=true
    return true
end
function Control:_endRepresentationConfigurationAuthority(state)
    if state==nil or state.representationConfigurationAuthority~=true then return end
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    if cache~=nil and type(cache.endOuttaMyWayConfigurationAuthority)=="function" then
        cache:endOuttaMyWayConfigurationAuthority(state.request.target.bridge.assemblyReferenceKey,
            state.request.target.bridge.sourceJobToken)
    end
    state.representationConfigurationAuthority=false
end
function Control:relinquishAll(reason)
    local state=self.active
    if state==nil then return {released=0,reason=reason} end
    self.driveMechanism:clearMovementObjective(state.vehicle)
    self.configurationMechanism:clear(state.vehicle)
    self:_endRepresentationConfigurationAuthority(state)
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
local function membershipSet(values)
    local result={}
    for _,id in V.ipairs(values or {}) do result[id]=true end
    return result
end
-- Fresh execution checks narrow only principal authority, Field World guide and
-- active-participant Bubble protection. Non-active obstruction telemetry is not
-- part of Bypass permission.
function Control:_validate(state)
    local bridge=state.request.target.bridge
    local live=self.runtime.boundedBypassRuntime.currentByOperation[bridge.operationId]
    if live==nil or (tonumber(g_time) or 0)/1000-live.snapshot.timestamp>MAX_EVIDENCE_AGE_S then return false,"BYPASS_CURRENT_EVIDENCE_UNAVAILABLE" end
    local picture,snapshot=live.picture,live.snapshot
    local episode=self.runtime.jobEpisodes:getActiveForAssembly(state.request.assemblyId)
    if episode==nil or episode.identity~=bridge.jobEpisodeId or episode.sourceJobToken~=bridge.sourceJobToken then return false,"BYPASS_JOB_CONTINUITY_LOST" end
    if E.hasPlayerClaim(snapshot,bridge.assemblyReferenceKey,true) then return false,"BYPASS_PLAYER_CLAIM" end
    if self.runtime.boundedAuthority:validateRequest(state.request)~=true then return false,"BYPASS_BOUNDED_AUTHORITY_LOST" end
    if not OuttaMyWay.FixedBypassDogleg.support(snapshot.fieldWorld,bridge.guide) then return false,"BYPASS_FIELD_GUIDE_UNSUPPORTED" end
    local pose=E.pose(snapshot,bridge.assemblyReferenceKey)
    if pose==nil or not OuttaMyWay.FixedBypassDogleg.contains(snapshot.fieldWorld,pose.x,pose.z) then return false,"BYPASS_CURRENT_REFERENCE_OUTSIDE_FIELD" end
    local protection=self.runtime.bubbleBulletTime:getProtection(state.request.commitmentId)
    if protection==nil or (protection.status~="ACTIVE" and protection.status~="NOT_REQUIRED") then return false,"BYPASS_BUBBLE_UNAVAILABLE" end
    local protected={}
    for _,lease in V.ipairs(protection.leases) do
        local regulation=self.runtime.liveControlDispatcher.regulationControl
        local vehicle=regulation:_vehicleForReferenceKey(lease.referenceKey)
        local physical=vehicle and regulation.driveMechanism:getRegulationLease(vehicle,lease.ownerTag)
        if lease.physicalActive~=true or self.runtime.boundedAuthority:get(lease.boundedAuthorityId)==nil
            or physical==nil or physical.speedKmh~=lease.maxSpeedKmh then return false,"BYPASS_BUBBLE_LEASE_LOST" end
        protected[lease.assemblyId]=lease.maxSpeedKmh
    end
    local originalBlockers=membershipSet(bridge.activeCausalBlockerAssemblyIds)
    for _,id in V.ipairs(bridge.activeCausalBlockerAssemblyIds or {}) do
        if not E.isMember(picture,bridge.operationId,id) then return false,"BYPASS_ACTIVE_BLOCKER_CONTEXT_CHANGED" end
    end
    for _,id in V.ipairs(E.activeCausalBlockerIds(self.runtime,picture,bridge.operationId,bridge.assemblyId)) do
        if originalBlockers[id]~=true then return false,"BYPASS_NEW_ACTIVE_BLOCKER_UNPROTECTED" end
    end
    for _,id in V.ipairs(E.members(picture,bridge.operationId)) do
        if id~=bridge.assemblyId then
            local expected=originalBlockers[id] and 0 or 1
            if protected[id]~=expected then return false,"BYPASS_BUBBLE_PROTECTION_MISMATCH" end
        end
    end
    return true
end
function Control:_beginLeg(state,index)
    local target=state.request.target.bridge.guide.targets[index]
    local ok,reason=self.driveMechanism:setReposition(state.vehicle,target.x,target.z,SPEED_KMH,TARGET_RADIUS_M,target.moveForwards~=false)
    if not ok then self:_finish("FAILED",reason); return false end
    state.legIndex=index; state.phase=target.kind
    state.progressBestResidualM=nil
    state.progressLastImprovementAtMs=tonumber(g_time) or 0
    return true
end
function Control:_targetProgressStalled(state)
    local live=self.runtime.boundedBypassRuntime.currentByOperation[state.request.target.bridge.operationId]
    local target=state.request.target.bridge.guide.targets[state.legIndex]
    local pose=live and E.pose(live.snapshot,state.request.target.bridge.assemblyReferenceKey) or nil
    if target==nil or pose==nil then return false end
    local dx,dz=target.x-pose.x,target.z-pose.z
    local residual=math.max(0,math.sqrt(dx*dx+dz*dz)-TARGET_RADIUS_M)
    local nowMs=tonumber(g_time) or 0
    if state.progressBestResidualM==nil or state.progressBestResidualM-residual>=TARGET_PROGRESS_EPSILON_M then
        state.progressBestResidualM=residual
        state.progressLastImprovementAtMs=nowMs
        return false
    end
    if residual<=0 then
        state.progressBestResidualM=0
        state.progressLastImprovementAtMs=nowMs
        return false
    end
    return nowMs-(state.progressLastImprovementAtMs or nowMs)>=TARGET_PROGRESS_WATCHDOG_MS
end
function Control:executeControlRequest(request)
    if self.active~=nil then return false,"BYPASS_ALREADY_ACTIVE" end
    if request.capability~="REPOSITION" or request.target.kind~="BOUNDED_BYPASS" then return false,"BYPASS_REQUEST_INVALID" end
    if self.runtime.boundedAuthority:validateRequest(request)~=true then return false,"BYPASS_REQUEST_NOT_AUTHORISED" end
    local bridge=request.target.bridge
    local vehicle=self.runtime.liveObservationSource:getCurrentPhysicalObject(bridge.assemblyReferenceKey)
    if vehicle==nil then return false,"BYPASS_VEHICLE_UNAVAILABLE" end
    local state={request=request,vehicle=vehicle,phase="WAITING_FOR_TRANSIT",startedAtMs=tonumber(g_time) or 0}
    local valid,reason=self:_validate(state)
    if not valid then return false,reason end
    local f=bridge.guide.frame
    local held,holdReason=self.driveMechanism:setAxisTravel(vehicle,f.x,f.z,f.forwardX,f.forwardZ,0,0,true,1)
    if not held then return false,holdReason end
    self.active=state
    local marked,markReason=self:_beginRepresentationConfigurationAuthority(state)
    if not marked then self:_finish("FAILED",markReason); return false,markReason end
    local capability=self.runtime.assemblyRepresentationCache:getTransitFoldCapability(bridge.assemblyReferenceKey,bridge.sourceJobToken)
    local ok,transitReason=self.configurationMechanism:prepareCachedTransit(vehicle,capability,true)
    if not ok then self:_finish("FAILED",transitReason); return false,transitReason end
    return true,{phase=state.phase}
end
function Control:update()
    local state=self.active
    if state==nil then return end
    local valid,reason=self:_validate(state)
    if not valid then self:_finish("FAILED",reason); return end
    if self.configurationMechanism:getState(state.vehicle)==nil then self:_finish("FAILED","BYPASS_TRANSIT_AUTHORITY_LOST"); return end
    local settlement=self.configurationMechanism:getCachedTransitSettlement(state.vehicle)
    if settlement.exhausted==true then self:_finish("FAILED","BYPASS_TRANSIT_FAILED"); return end
    if settlement.settled~=true then
        if state.legIndex~=nil then self:_finish("FAILED","BYPASS_TRANSIT_SETTLEMENT_LOST") end
        return
    end
    if state.legIndex==nil then
        self:_beginLeg(state,1)
        return
    end
    local drive=self.driveMechanism:getState(state.vehicle)
    if drive==nil or drive.invalidReason~=nil then self:_finish("FAILED","BYPASS_MOVEMENT_UNAVAILABLE"); return end
    if self:_targetProgressStalled(state) then self:_finish("FAILED","BYPASS_TARGET_PROGRESS_STALLED"); return end
    if drive.targetReached==true then
        if state.legIndex==4 then self:_finish("SUCCEEDED","POST_BLOCKAGE_AXIS_REJOIN_REACHED")
        else self:_beginLeg(state,state.legIndex+1) end
    end
end
return Control
