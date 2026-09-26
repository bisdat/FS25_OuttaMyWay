--- Executes one authorised Blocked Worker Recovery manoeuvre to the selected Recovery Anchor.
-- Specification Jurisdictions: `CONTROL`, `BLOCKED_WORKER_RECOVERY`

OuttaMyWay.BlockedWorkerRecoveryControl={}
local Control=OuttaMyWay.BlockedWorkerRecoveryControl
Control.__index=Control

local RECOVERY_SPEED_KMH=8.0
local RECOVERY_ANCHOR_RADIUS_M=1.0
local publication=OuttaMyWay.LogPublication.origin("CONTROL")

local function logInfo(class,code,formatText,...)
    return publication:info(class,code,formatText,...)
end
local function logWarning(class,code,formatText,...)
    return publication:warning(class,code,formatText,...)
end

function Control.new(runtime,mechanisms)
    if type(mechanisms)~="table" or mechanisms.driveMechanism==nil or mechanisms.configurationMechanism==nil then
        error("BlockedWorkerRecoveryControl requires Drive and Configuration mechanisms",2)
    end
    return setmetatable({
        runtime=runtime,driveMechanism=mechanisms.driveMechanism,configurationMechanism=mechanisms.configurationMechanism,
        active=nil,completionHandler=nil,completedCount=0,failedCount=0
    },Control)
end

function Control:setCompletionHandler(handler) self.completionHandler=handler end
function Control:isActive() return self.active~=nil end
function Control:getStatus()
    local a=self.active
    return {active=a~=nil,phase=a and a.phase or nil,commitmentId=a and a.commitmentId or nil,completedCount=self.completedCount,failedCount=self.failedCount}
end
function Control:keyEvent() end
function Control:mouseEvent() end
function Control:draw() end
function Control:loadMap()
    local ok,reason=self.driveMechanism:install()
    if not ok then logWarning("NORMAL","BLOCKED_WORKER_RECOVERY_DRIVE_MECHANISM_UNAVAILABLE","reason=%s",tostring(reason)) end
end
function Control:deleteMap() self:relinquishAll("MAP_DELETE") end

function Control:_notify(result)
    if type(self.completionHandler)=="function" then
        local ok,reason=pcall(self.completionHandler,result)
        if not ok then logWarning("NORMAL","BLOCKED_WORKER_RECOVERY_COMPLETION_HANDLER_FAILED","reason=%s",tostring(reason)) end
    end
end

function Control:_finish(status,evidence)
    local state=self.active
    if state==nil then return end
    self.driveMechanism:clearMovementObjective(state.vehicle)
    self.active=nil
    if status=="SUCCEEDED" then self.completedCount=self.completedCount+1 else self.failedCount=self.failedCount+1 end
    self:_notify({
        status=status,commitmentId=state.commitmentId,assemblyId=state.assemblyId,
        requestId=state.requestId,boundedAuthorityId=state.boundedAuthorityId,
        recoveryKey=state.recoveryKey,evidence=evidence or {}
    })
end

function Control:_failAfterRestore(state,evidence)
    self.driveMechanism:clearMovementObjective(state.vehicle)
    state.pendingFailureEvidence=evidence or {kind="BLOCKED_WORKER_RECOVERY_FAILED"}
    if self.configurationMechanism:getState(state.vehicle)==nil then
        self:_finish("FAILED",state.pendingFailureEvidence)
        return
    end
    local ok,reason=self.configurationMechanism:requestCachedTransitRestore(state.vehicle)
    if not ok then
        local failure=state.pendingFailureEvidence
        failure.restoreFailure=tostring(reason)
        self:_finish("FAILED",failure)
        return
    end
    state.phase="WAITING_FOR_FAILURE_RESTORE"
end

function Control:relinquishAll(reason)
    local state=self.active
    if state==nil then return {released=0,reason=reason} end
    self.driveMechanism:clearMovementObjective(state.vehicle)
    local restoreRequested=false
    if self.configurationMechanism:getState(state.vehicle)~=nil then
        restoreRequested=self.configurationMechanism:requestCachedTransitRestore(state.vehicle)==true
    end
    self.active=nil
    return {released=1,reason=reason,configurationRestoreRequested=restoreRequested}
end

function Control:_jobStillCurrent(state)
    local episode=self.runtime and self.runtime.jobEpisodes and self.runtime.jobEpisodes:getActiveForAssembly(state.assemblyId) or nil
    return episode~=nil and episode.identity==state.jobEpisodeId and episode.sourceJobToken==state.sourceJobToken
end

function Control:_beginMovement(state)
    local ok,reason=self.driveMechanism:setReposition(
        state.vehicle,state.anchorX,state.anchorZ,RECOVERY_SPEED_KMH,RECOVERY_ANCHOR_RADIUS_M,false)
    if not ok then return false,reason end
    state.phase="MOVING_TO_RECOVERY_ANCHOR"
    logInfo("DEBUG","BLOCKED_WORKER_RECOVERY_MOVEMENT_STARTED",
        "commitment=%s assembly=%s anchor=(%.2f,%.2f) speed=%.2f reverse=true",
        tostring(state.commitmentId),tostring(state.assemblyId),state.anchorX,state.anchorZ,RECOVERY_SPEED_KMH)
    return true,nil
end

function Control:_requestTransit(state)
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    local capability=cache and type(cache.getTransitFoldCapability)=="function"
        and cache:getTransitFoldCapability(state.assemblyReferenceKey,state.sourceJobToken) or nil
    local ok,result=self.configurationMechanism:prepareCachedTransit(state.vehicle,capability)
    state.transitRequested=true
    if ok then
        state.transitChanged=true
        state.phase="WAITING_FOR_TRANSIT"
        logInfo("DEBUG","BLOCKED_WORKER_RECOVERY_TRANSIT_REQUESTED",
            "commitment=%s assembly=%s changed=true",tostring(state.commitmentId),tostring(state.assemblyId))
        return true,nil
    end
    state.transitChanged=false
    state.transitReason=tostring(result)
    logInfo("DEBUG","BLOCKED_WORKER_RECOVERY_TRANSIT_REQUESTED",
        "commitment=%s assembly=%s changed=false reason=%s",tostring(state.commitmentId),tostring(state.assemblyId),tostring(result))
    return self:_beginMovement(state)
end

function Control:executeControlRequest(request,candidate)
    if self.active~=nil then return false,"BLOCKED_WORKER_RECOVERY_CONTROL_ALREADY_ACTIVE" end
    local target=request and request.target or nil
    if request==nil or request.capability~="REPOSITION" or type(target)~="table" or target.kind~="BLOCKED_WORKER_RECOVERY" then
        return false,"BLOCKED_WORKER_RECOVERY_REQUEST_INVALID"
    end
    local valid,reason=self.runtime.boundedAuthority:validateRequest(request)
    if valid~=true then return false,reason end
    local vehicle=self.runtime.liveObservationSource:getCurrentPhysicalObject(target.assemblyReferenceKey)
    if vehicle==nil then return false,"BLOCKED_WORKER_RECOVERY_VEHICLE_UNAVAILABLE" end
    local anchor=target.recoveryAnchor
    if type(anchor)~="table" or tonumber(anchor.x)==nil or tonumber(anchor.z)==nil then
        return false,"BLOCKED_WORKER_RECOVERY_ANCHOR_UNAVAILABLE"
    end
    local state={
        commitmentId=request.commitmentId,assemblyId=request.assemblyId,assemblyReferenceKey=target.assemblyReferenceKey,
        jobEpisodeId=target.jobEpisodeId,sourceJobToken=target.sourceJobToken,recoveryKey=target.recoveryKey,
        requestId=request.identity,boundedAuthorityId=request.boundedAuthorityId,vehicle=vehicle,
        anchorX=tonumber(anchor.x),anchorZ=tonumber(anchor.z),phase="REQUEST_TRANSIT",
        transitRequested=false,transitChanged=false,restoreRequested=false
    }
    if not self:_jobStillCurrent(state) then return false,"BLOCKED_WORKER_RECOVERY_JOB_EPISODE_CHANGED" end
    self.active=state
    local started,startReason=self:_requestTransit(state)
    if started~=true then self:_finish("FAILED",{kind="RECOVERY_TRANSIT_OR_MOVEMENT_START_FAILED",reason=startReason}); return false,startReason end
    return true,{phase=state.phase,recoveryKey=state.recoveryKey}
end

function Control:update(dt)
    local state=self.active
    if state==nil then return end
    if state.phase~="WAITING_FOR_SUPERSEDED_RESTORE" and not self:_jobStillCurrent(state) then
        self.driveMechanism:clearMovementObjective(state.vehicle)
        if self.configurationMechanism:getState(state.vehicle)~=nil then
            self.configurationMechanism:requestCachedTransitRestore(state.vehicle)
            state.pendingSupersededEvidence={kind="RECOVERY_JOB_EPISODE_CHANGED"}
            state.phase="WAITING_FOR_SUPERSEDED_RESTORE"
        else
            self:_finish("SUPERSEDED",{kind="RECOVERY_JOB_EPISODE_CHANGED"})
        end
        return
    end

    if state.phase=="WAITING_FOR_TRANSIT" then
        local settlement=self.configurationMechanism:getCachedTransitSettlement(state.vehicle)
        if settlement.settled~=true then return end
        if settlement.exhausted==true then
            self:_failAfterRestore(state,{kind="RECOVERY_TRANSIT_SETTLEMENT_FAILED",reason=settlement.reason})
            return
        end
        local ok,reason=self:_beginMovement(state)
        if not ok then self:_failAfterRestore(state,{kind="RECOVERY_MOVEMENT_START_FAILED",reason=reason}) end
        return
    end

    if state.phase=="MOVING_TO_RECOVERY_ANCHOR" then
        local drive=self.driveMechanism:getState(state.vehicle)
        if drive==nil then self:_failAfterRestore(state,{kind="RECOVERY_MOVEMENT_AUTHORITY_LOST"}); return end
        if drive.invalidReason~=nil then self:_failAfterRestore(state,{kind="RECOVERY_MOVEMENT_FAILED",reason=drive.invalidReason}); return end
        if drive.targetReached~=true then return end
        self.driveMechanism:clearMovementObjective(state.vehicle)
        if state.transitChanged~=true or self.configurationMechanism:getState(state.vehicle)==nil then
            self:_finish("SUCCEEDED",{kind="RECOVERY_ANCHOR_REACHED_RESTORED_AND_HANDED_BACK",anchorX=state.anchorX,anchorZ=state.anchorZ})
            return
        end
        local ok,reason=self.configurationMechanism:requestCachedTransitRestore(state.vehicle)
        if not ok then
            self:_finish("FAILED",{kind="RECOVERY_RESTORE_REQUEST_FAILED",reason=reason})
            return
        end
        state.restoreRequested=true
        state.phase="WAITING_FOR_RESTORE"
        logInfo("DEBUG","BLOCKED_WORKER_RECOVERY_RESTORE_REQUESTED","commitment=%s assembly=%s",tostring(state.commitmentId),tostring(state.assemblyId))
        return
    end

    if state.phase=="WAITING_FOR_RESTORE" then
        local settlement=self.configurationMechanism:getCachedRestoreSettlement(state.vehicle)
        if settlement.settled~=true then return end
        local ok,result=self.configurationMechanism:finishCachedTransitRestore(state.vehicle)
        if not ok then
            self:_finish("FAILED",{kind="RECOVERY_RESTORE_FINISH_FAILED",reason=result})
            return
        end
        self:_finish("SUCCEEDED",{kind="RECOVERY_ANCHOR_REACHED_RESTORED_AND_HANDED_BACK",anchorX=state.anchorX,anchorZ=state.anchorZ,restoreSettlementExhausted=settlement.exhausted==true})
        return
    end

    if state.phase=="WAITING_FOR_FAILURE_RESTORE" or state.phase=="WAITING_FOR_SUPERSEDED_RESTORE" then
        local settlement=self.configurationMechanism:getCachedRestoreSettlement(state.vehicle)
        if settlement.settled~=true then return end
        local ok,result=self.configurationMechanism:finishCachedTransitRestore(state.vehicle)
        if not ok then
            local evidence=state.pendingFailureEvidence or state.pendingSupersededEvidence or {kind="RECOVERY_CLEANUP_FAILED"}
            evidence.restoreFailure=tostring(result)
            self:_finish(state.phase=="WAITING_FOR_SUPERSEDED_RESTORE" and "SUPERSEDED" or "FAILED",evidence)
            return
        end
        if state.phase=="WAITING_FOR_SUPERSEDED_RESTORE" then
            self:_finish("SUPERSEDED",state.pendingSupersededEvidence)
        else
            self:_finish("FAILED",state.pendingFailureEvidence)
        end
    end
end

return Control
