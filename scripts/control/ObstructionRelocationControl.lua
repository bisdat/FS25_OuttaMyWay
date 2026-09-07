-- D-0218 bounded Control for a current non-active, unclaimed Causal Obstruction.
-- Semantic authority is OBSTRUCTION_RELOCATION_ACTUATION. The proven
-- PostJobActuationAuthority implementation is reused only as a low-level
-- non-job movement donor; no completed Job Episode is inferred or required.

OuttaMyWay.ObstructionRelocationControl={}
local Control=OuttaMyWay.ObstructionRelocationControl
Control.__index=Control

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION-CONTROL] %s",message) else print("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION-CONTROL] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION-CONTROL] %s",message) else print("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION-CONTROL][WARNING] "..message) end
end

local function bridgeFor(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.obstructionRelocationBridge or nil
    if type(bridge)=="table" and bridge.architecture=="CAUSAL_OBSTRUCTION_RELOCATION" and type(bridge.relocationKey)=="string" then return bridge end
    return nil
end

local function tokenFor(runtime,request)
    for _,token in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(request.commitmentId)) do
        if token.identity==request.authorityToken
            and token.assemblyId==request.assemblyId
            and token.authorityClass=="OBSTRUCTION_RELOCATION_ACTUATION"
            and runtime.authorities:validate(token)==true then
            return token
        end
    end
    return nil
end

function Control.new(runtime,observationSource)
    return setmetatable({
        runtime=runtime,
        source=observationSource,
        movementDonor=OuttaMyWay.PostJobActuationAuthority.new(),
        configurationAuthority=OuttaMyWay.Prototype22ConfigurationAuthority.new(),
        active=nil,
        completionHandler=nil,
        latestObservation=nil,
        startedCount=0,
        completedCount=0,
        failedCount=0
    },Control)
end

function Control:setCompletionHandler(handler) self.completionHandler=handler end
function Control:isActive() return self.active~=nil end
function Control:getControlExecutionObservation() return self.latestObservation end

function Control:_vehicle(referenceKey)
    return self.source and self.source:getCurrentPhysicalObject(referenceKey) or nil
end

function Control:_publish(state,status,extra)
    local item={
        kind="OBSTRUCTION_RELOCATION_CONTROL_OBSERVATION",
        relocationKey=state and state.relocationKey or nil,
        assemblyReferenceKey=state and state.assemblyReferenceKey or nil,
        commitmentId=state and state.commitmentId or nil,
        phase=state and state.phase or nil,
        status=status,
        active=self.active~=nil,
        directDriveCalls=self.movementDonor:getDirectDriveCallCount(),
        provenance={source="ObstructionRelocationControl",authority="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false}
    }
    for key,value in OuttaMyWay.ValueRecord.pairs(extra or {}) do item[key]=value end
    self.latestObservation=item
end

function Control:_releaseConfigurationOwnership(vehicle,state)
    if state~=nil and state.configurationOwned==true and vehicle~=nil then
        -- Compaction is an opportunistic aid, not a restoration obligation.
        -- Release bookkeeping without issuing a new configuration command.
        self.configurationAuthority:clear(vehicle)
        return true
    end
    return false
end

function Control:_complete(status,evidence)
    local state=self.active
    if state==nil then return end
    local completionEvidence={}
    for key,value in OuttaMyWay.ValueRecord.pairs(evidence or {}) do completionEvidence[key]=value end
    local vehicle=state.vehicle or self:_vehicle(state.assemblyReferenceKey)
    local ownedCleanupFailed=false

    if state.actuationIssued==true then
        if status=="PLAYER_CLAIM" then
            completionEvidence.neutralization={performed=false,reason="PLAYER_CLAIM_HIGHER_AUTHORITY"}
        elseif status=="SUPERSEDED" then
            completionEvidence.neutralization={performed=false,reason="SOURCE_AI_HIGHER_AUTHORITY"}
        elseif vehicle==nil then
            completionEvidence.neutralization={performed=false,reason="CURRENT_PHYSICAL_OBJECT_LOST"}
            ownedCleanupFailed=true
        else
            local neutralized,neutralEvidence=self.movementDonor:neutralize(vehicle,state.lastDt or 0)
            completionEvidence.neutralization={performed=neutralized==true,evidence=type(neutralEvidence)=="table" and neutralEvidence or nil,reason=neutralized and nil or tostring(neutralEvidence)}
            if neutralized~=true then
                ownedCleanupFailed=true
                logWarning("NEUTRALIZATION_FAILED commitment=%s relocation=%s reason=%s",tostring(state.commitmentId),tostring(state.relocationKey),tostring(neutralEvidence))
            end
        end
    end

    if state.activityContext~=nil then
        if vehicle==nil then
            completionEvidence.activityContext={released=false,reason="CURRENT_PHYSICAL_OBJECT_LOST"}
            if status~="PLAYER_CLAIM" and status~="SUPERSEDED" then ownedCleanupFailed=true end
        else
            local released,releaseEvidence=self.movementDonor:releaseVehicleActivityContext(vehicle,state.activityContext)
            completionEvidence.activityContext={released=released==true,evidence=type(releaseEvidence)=="table" and releaseEvidence or nil,reason=released and nil or tostring(releaseEvidence)}
            if released~=true and status~="PLAYER_CLAIM" and status~="SUPERSEDED" then
                ownedCleanupFailed=true
                logWarning("ACTIVITY_CONTEXT_RELEASE_FAILED commitment=%s relocation=%s reason=%s",tostring(state.commitmentId),tostring(state.relocationKey),tostring(releaseEvidence))
            end
        end
    end

    completionEvidence.configurationOwnershipReleased=self:_releaseConfigurationOwnership(vehicle,state)
    local finalStatus=status
    if ownedCleanupFailed and status=="MANOEUVRE_COMPLETE" then
        finalStatus="FAILED"
        completionEvidence.kind="OBSTRUCTION_RELOCATION_CONTROL_FAILURE"
        completionEvidence.reason="OWNED_ACTUATION_CLEANUP_FAILED"
        completionEvidence.manoeuvreTargetReached=true
        completionEvidence.semanticResolutionNotInferred=true
    end

    self.active=nil
    self:_publish(state,finalStatus,completionEvidence)
    if finalStatus=="FAILED" then self.failedCount=self.failedCount+1 else self.completedCount=self.completedCount+1 end
    logInfo("CONTROL_COMPLETE commitment=%s relocation=%s status=%s freshSituationRequired=%s",tostring(state.commitmentId),tostring(state.relocationKey),tostring(finalStatus),tostring(finalStatus=="MANOEUVRE_COMPLETE"))
    if type(self.completionHandler)=="function" then
        self.completionHandler({
            status=finalStatus,
            commitmentId=state.commitmentId,
            relocationKey=state.relocationKey,
            assemblyId=state.assemblyId,
            assemblyReferenceKey=state.assemblyReferenceKey,
            boundedAuthorityId=state.boundedAuthorityId,
            evidence=completionEvidence
        })
    end
end

function Control:executeControlRequest(request,candidate)
    OuttaMyWay.ValueRecord.assertType(request,"ControlRequest")
    local bridge=bridgeFor(candidate)
    if bridge==nil or bridge.phase~="INFIELD" then return false,"OBSTRUCTION_RELOCATION_BRIDGE_UNAVAILABLE" end
    if self.active~=nil then return false,"OBSTRUCTION_RELOCATION_CONTROL_ALREADY_ACTIVE" end
    if tokenFor(self.runtime,request)==nil then return false,"OBSTRUCTION_RELOCATION_ACTUATION_AUTHORITY_TOKEN_UNAVAILABLE" end
    local grantOk,grantReason=self.runtime.boundedAuthority:validateRequest(request)
    if grantOk~=true then return false,grantReason end

    local vehicle=self:_vehicle(bridge.blockerAssemblyReferenceKey)
    if vehicle==nil then return false,"CURRENT_BLOCKER_RUNTIME_OBJECT_UNAVAILABLE" end
    if self.movementDonor:isPlayerClaimed(vehicle) then return false,"PLAYER_CLAIM_AT_CONTROL_BOUNDARY" end
    if self.movementDonor:isSourceReactivated(vehicle) then return false,"SOURCE_AI_REACTIVATED_AT_CONTROL_BOUNDARY" end

    local objective=bridge.objective
    if type(objective)~="table"
        or tonumber(objective.infieldDirectionX)==nil
        or tonumber(objective.infieldDirectionZ)==nil
        or tonumber(objective.targetProgressM)==nil
        or tonumber(objective.targetX)==nil
        or tonumber(objective.targetZ)==nil then
        return false,"OBSTRUCTION_RELOCATION_OBJECTIVE_INCOMPLETE"
    end
    if tonumber(objective.courtesyStage)~=1 then return false,"OBSTRUCTION_RELOCATION_ONLY_FIRST_COURTESY_SUPPORTED" end

    local position=self.movementDonor:position(vehicle)
    if position==nil then return false,"OBSTRUCTION_RELOCATION_START_POSE_UNAVAILABLE" end
    local activityOk,activityContext=self.movementDonor:acquireVehicleActivityContext(vehicle)
    if not activityOk then return false,"OBSTRUCTION_RELOCATION_ACTIVITY_CONTEXT_UNAVAILABLE:"..tostring(activityContext) end

    local configurationOwned=false
    local configurationEvidence=self.configurationAuthority:getEvidence(vehicle)
    local configurationResult="RETAIN_CURRENT"
    if configurationEvidence.foldableCount>0 and configurationEvidence.unknownCount==0 and configurationEvidence.allDeployed==true then
        local compactOk,compactResult=self.configurationAuthority:prepareCompact(vehicle)
        configurationOwned=compactOk==true
        configurationResult=compactOk and "COMPACTION_REQUESTED_NO_SETTLEMENT_GATE" or ("COMPACTION_NOT_AVAILABLE:"..tostring(compactResult))
    elseif configurationEvidence.foldableCount>0 then
        configurationResult="COMPACTION_NOT_OBVIOUSLY_AVAILABLE"
    end

    local maximumSpeedKmh,speedReason=self.movementDonor:maximumForwardSpeedKmh(vehicle)
    if maximumSpeedKmh==nil then
        if configurationOwned then self.configurationAuthority:clear(vehicle) end
        self.movementDonor:releaseVehicleActivityContext(vehicle,activityContext)
        return false,"OBSTRUCTION_RELOCATION_NATIVE_MAX_SPEED_UNAVAILABLE:"..tostring(speedReason)
    end

    local state={
        commitmentId=request.commitmentId,
        relocationKey=bridge.relocationKey,
        assemblyId=request.assemblyId,
        assemblyReferenceKey=bridge.blockerAssemblyReferenceKey,
        phase="INFIELD",
        requestId=request.identity,
        boundedAuthorityId=request.boundedAuthorityId,
        authorityToken=request.authorityToken,
        startedAt=tonumber(g_time) or 0,
        vehicle=vehicle,
        activityContext=activityContext,
        configurationOwned=configurationOwned,
        configurationResult=configurationResult,
        startX=position.x,startZ=position.z,
        infieldDirectionX=tonumber(objective.infieldDirectionX),infieldDirectionZ=tonumber(objective.infieldDirectionZ),
        targetX=tonumber(objective.targetX),targetZ=tonumber(objective.targetZ),targetProgressM=tonumber(objective.targetProgressM),
        speedKmh=maximumSpeedKmh,
        actuationIssued=false
    }
    self.active=state
    self.startedCount=self.startedCount+1
    self:_publish(state,"MANOEUVRE_IN_PROGRESS",{
        targetX=state.targetX,targetZ=state.targetZ,targetProgressM=state.targetProgressM,
        fixedDirectionX=state.infieldDirectionX,fixedDirectionZ=state.infieldDirectionZ,
        speedKmh=state.speedKmh,continuousCourseCorrection=false,
        configurationResult=configurationResult,configurationEvidence=configurationEvidence
    })
    logInfo("CONTROL_STARTED commitment=%s relocation=%s assembly=%s targetProgress=%.2fm fixedDirection=(%.4f,%.4f) speed=%.2fkmh configuration=%s historicalJobProvenanceRequired=false",
        tostring(state.commitmentId),tostring(state.relocationKey),tostring(state.assemblyReferenceKey),state.targetProgressM,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh,tostring(configurationResult))
    return true,"OBSTRUCTION_RELOCATION_MANOEUVRE_STARTED"
end

function Control:update(dt)
    local state=self.active
    if state==nil then return end
    state.lastDt=dt
    if self.runtime.boundedAuthority:isCurrent(state.boundedAuthorityId)~=true then self:_complete("FAILED",{kind="OBSTRUCTION_RELOCATION_CONTROL_FAILURE",reason="BOUNDED_AUTHORITY_LOST"}); return end
    if tokenFor(self.runtime,state)==nil then self:_complete("FAILED",{kind="OBSTRUCTION_RELOCATION_CONTROL_FAILURE",reason="OBSTRUCTION_RELOCATION_AUTHORITY_LOST"}); return end

    local vehicle=self:_vehicle(state.assemblyReferenceKey)
    if vehicle==nil then self:_complete("FAILED",{kind="OBSTRUCTION_RELOCATION_CONTROL_FAILURE",reason="CURRENT_PHYSICAL_OBJECT_LOST"}); return end
    if self.movementDonor:isPlayerClaimed(vehicle) then self:_complete("PLAYER_CLAIM",{kind="CURRENT_PLAYER_CLAIM"}); return end
    if self.movementDonor:isSourceReactivated(vehicle) then self:_complete("SUPERSEDED",{kind="CURRENT_SOURCE_AI_REACTIVATION"}); return end

    local position=self.movementDonor:position(vehicle)
    if position==nil then self:_complete("FAILED",{kind="OBSTRUCTION_RELOCATION_CONTROL_FAILURE",reason="CURRENT_POSE_LOST"}); return end
    local dx,dz=position.x-state.startX,position.z-state.startZ
    local realisedProgress=dx*state.infieldDirectionX+dz*state.infieldDirectionZ
    if realisedProgress>=state.targetProgressM then
        self:_complete("MANOEUVRE_COMPLETE",{kind="BOUNDED_RELOCATION_MANOEUVRE_COMPLETE",realisedProgressM=realisedProgress,targetProgressM=state.targetProgressM,freshSituationRequired=true,semanticResolutionNotInferred=true})
        return
    end

    local elapsed=(tonumber(g_time) or 0)-state.startedAt
    if elapsed>(tonumber(OuttaMyWay.TERMINAL_EGRESS_MOVE_TIMEOUT_MS) or 45000) then
        self:_complete("FAILED",{kind="OBSTRUCTION_RELOCATION_CONTROL_FAILURE",reason="BOUNDED_MOVE_WATCHDOG_EXPIRED",realisedProgressM=realisedProgress,targetProgressM=state.targetProgressM})
        return
    end

    local ok,result=self.movementDonor:driveInWorldDirection(vehicle,dt,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh)
    if not ok then
        if result=="PLAYER_CLAIM" then self:_complete("PLAYER_CLAIM",{kind="CURRENT_PLAYER_CLAIM"})
        elseif result=="SOURCE_INTENT_REACTIVATED" then self:_complete("SUPERSEDED",{kind="CURRENT_SOURCE_AI_REACTIVATION"})
        else self:_complete("FAILED",{kind="OBSTRUCTION_RELOCATION_CONTROL_FAILURE",reason=tostring(result)}) end
        return
    end
    state.actuationIssued=true
    self:_publish(state,"MANOEUVRE_IN_PROGRESS",{
        realisedProgressM=realisedProgress,targetProgressM=state.targetProgressM,
        fixedDirectionX=state.infieldDirectionX,fixedDirectionZ=state.infieldDirectionZ,
        continuousCourseCorrection=false,directionEvidence=result,configurationResult=state.configurationResult
    })
end

function Control:loadMap() self.active=nil; self.latestObservation=nil; self.configurationAuthority:clearAll() end
function Control:deleteMap() self.active=nil; self.latestObservation=nil; self.configurationAuthority:clearAll() end
function Control:keyEvent() end
function Control:mouseEvent() end
function Control:draw() end
function Control:getStatus()
    return {
        active=self.active~=nil,
        relocationKey=self.active and self.active.relocationKey or nil,
        startedCount=self.startedCount,
        completedCount=self.completedCount,
        failedCount=self.failedCount,
        directDriveCalls=self.movementDonor:getDirectDriveCallCount(),
        neutralizeCalls=self.movementDonor:getNeutralizeCallCount(),
        activityContextAcquireCalls=self.movementDonor:getActivityContextAcquireCallCount(),
        activityContextReleaseCalls=self.movementDonor:getActivityContextReleaseCallCount()
    }
end