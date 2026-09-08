-- Provenance-neutral physical Terminal Egress execution.
-- Completed Obstruction and current Causal Obstruction remain distinct upstream
-- Responsibility/Commitment lifecycles. This Control consumes only an authorised
-- Terminal Egress objective, current physical subject and current Bounded Authority.
-- Player Claim and source-AI reactivation remain higher-priority Reality boundaries.

OuttaMyWay.TerminalEgressControl={}
local Control=OuttaMyWay.TerminalEgressControl
Control.__index=Control

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][TERMINAL-EGRESS-CONTROL] %s",message) else print("[FS25_OuttaMyWay][TERMINAL-EGRESS-CONTROL] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][TERMINAL-EGRESS-CONTROL] %s",message) else print("[FS25_OuttaMyWay][TERMINAL-EGRESS-CONTROL][WARNING] "..message) end
end
local function finite(value) return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge end
local function distanceTo(x,z,cx,cz)
    if not finite(x) or not finite(z) or not finite(cx) or not finite(cz) then return nil end
    local dx,dz=x-cx,z-cz
    return math.sqrt(dx*dx+dz*dz)
end
local function tokenFor(runtime,request)
    for _,token in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(request.commitmentId)) do
        if token.identity==request.authorityToken and token.assemblyId==request.assemblyId and runtime.authorities:validate(token)==true then return token end
    end
    return nil
end
local function requestTarget(request)
    local target=request and request.target or nil
    if type(target)~="table" or target.kind~="TERMINAL_EGRESS" then return nil end
    if target.phase~="COMPACT" and target.phase~="INFIELD" then return nil end
    if type(target.assemblyReferenceKey)~="string" then return nil end
    return target
end

function Control.new(runtime,observationSource)
    return setmetatable({
        runtime=runtime,source=observationSource,
        actuationMechanism=OuttaMyWay.NonJobActuationMechanism.new(),
        configurationMechanism=OuttaMyWay.TransitConfigurationMechanism.new(),
        active=nil,completionHandler=nil,latestObservation=nil,
        startedCount=0,completedCount=0,failedCount=0
    },Control)
end
function Control:setCompletionHandler(handler) self.completionHandler=handler end
function Control:isActive() return self.active~=nil end
function Control:getControlExecutionObservation() return self.latestObservation end
function Control:_vehicle(referenceKey)
    return self.source and self.source:getCurrentPhysicalObject(referenceKey) or nil
end
function Control:_publish(state,status,extra)
    local context=state and state.completionContext or {}
    local item={
        kind="TERMINAL_EGRESS_CONTROL_OBSERVATION",
        assemblyReferenceKey=state and state.assemblyReferenceKey or nil,
        assemblyId=state and state.assemblyId or nil,
        commitmentId=state and state.commitmentId or nil,
        phase=state and state.phase or nil,
        status=status,
        active=self.active~=nil,
        terminalEpisodeId=context and context.terminalEpisodeId or nil,
        relocationKey=context and context.relocationKey or nil,
        completionContext=context,
        directDriveCalls=self.actuationMechanism:getDirectDriveCallCount(),
        provenance={source="TerminalEgressControl",physicalExecution="TERMINAL_EGRESS"}
    }
    for key,value in OuttaMyWay.ValueRecord.pairs(extra or {}) do
        if key=="kind" then item.outcomeEvidenceKind=value else item[key]=value end
    end
    self.latestObservation=item
end
function Control:_releaseConfigurationOwnership(vehicle,state)
    if state~=nil and state.configurationOwned==true and vehicle~=nil then
        self.configurationMechanism:clear(vehicle)
        state.configurationOwned=false
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

    if state.phase=="INFIELD" and state.actuationIssued==true then
        if status=="PLAYER_CLAIM" then
            completionEvidence.neutralization={performed=false,reason="PLAYER_CLAIM_HIGHER_AUTHORITY"}
        elseif status=="SUPERSEDED" then
            completionEvidence.neutralization={performed=false,reason="SOURCE_AI_HIGHER_AUTHORITY"}
        elseif vehicle==nil then
            completionEvidence.neutralization={performed=false,reason="CURRENT_PHYSICAL_OBJECT_LOST"}
            ownedCleanupFailed=true
        else
            local neutralized,neutralEvidence=self.actuationMechanism:neutralize(vehicle,state.lastDt or 0)
            completionEvidence.neutralization={performed=neutralized==true,evidence=type(neutralEvidence)=="table" and neutralEvidence or nil,reason=neutralized and nil or tostring(neutralEvidence)}
            if neutralized~=true then
                ownedCleanupFailed=true
                logWarning("NEUTRALIZATION_FAILED commitment=%s reason=%s",tostring(state.commitmentId),tostring(neutralEvidence))
            end
        end
    end

    if state.phase=="INFIELD" and state.activityContext~=nil then
        if vehicle==nil then
            completionEvidence.activityContext={released=false,reason="CURRENT_PHYSICAL_OBJECT_LOST"}
            if status~="PLAYER_CLAIM" and status~="SUPERSEDED" then ownedCleanupFailed=true end
        else
            local released,releaseEvidence=self.actuationMechanism:releaseVehicleActivityContext(vehicle,state.activityContext)
            completionEvidence.activityContext={released=released==true,evidence=type(releaseEvidence)=="table" and releaseEvidence or nil,reason=released and nil or tostring(releaseEvidence)}
            if released~=true and status~="PLAYER_CLAIM" and status~="SUPERSEDED" then
                ownedCleanupFailed=true
                logWarning("ACTIVITY_CONTEXT_RELEASE_FAILED commitment=%s reason=%s",tostring(state.commitmentId),tostring(releaseEvidence))
            end
        end
    end

    completionEvidence.configurationOwnershipReleased=self:_releaseConfigurationOwnership(vehicle,state)
    local finalStatus=status
    if ownedCleanupFailed and status=="MANOEUVRE_COMPLETE" and state.cleanupFailurePolicy=="FAIL_COMPLETION" then
        finalStatus="FAILED"
        completionEvidence.kind="TERMINAL_EGRESS_CONTROL_FAILURE"
        completionEvidence.reason="OWNED_ACTUATION_CLEANUP_FAILED"
        completionEvidence.manoeuvreTargetReached=true
    end

    self.active=nil
    self:_publish(state,finalStatus,completionEvidence)
    if finalStatus=="FAILED" then self.failedCount=self.failedCount+1 else self.completedCount=self.completedCount+1 end
    logInfo("CONTROL_COMPLETE commitment=%s status=%s phase=%s",tostring(state.commitmentId),tostring(finalStatus),tostring(state.phase))
    if type(self.completionHandler)=="function" then
        local context=state.completionContext or {}
        self.completionHandler({
            status=finalStatus,
            commitmentId=state.commitmentId,
            terminalEpisodeId=context.terminalEpisodeId,
            relocationKey=context.relocationKey,
            completionContext=context,
            assemblyId=state.assemblyId,
            assemblyReferenceKey=state.assemblyReferenceKey,
            boundedAuthorityId=state.boundedAuthorityId,
            evidence=completionEvidence
        })
    end
end
function Control:_rejectBeforeStart(request,target,status,reason)
    local pseudo={
        commitmentId=request.commitmentId,assemblyId=request.assemblyId,
        assemblyReferenceKey=target.assemblyReferenceKey,phase=target.phase,
        boundedAuthorityId=request.boundedAuthorityId,
        completionContext=target.completionContext or {},
        cleanupFailurePolicy=target.cleanupFailurePolicy or "REPORT_ONLY"
    }
    self.active=pseudo
    self:_complete(status,{kind="TERMINAL_EGRESS_CONTROL_START_REJECTED",reason=reason})
    return false,reason
end
function Control:_prepareOpportunisticCompaction(vehicle,state)
    local evidence=self.configurationMechanism:getEvidence(vehicle)
    local result="RETAIN_CURRENT"
    if evidence.foldableCount>0 and evidence.unknownCount==0 and evidence.allDeployed==true then
        local compactOk,compactResult=self.configurationMechanism:prepareCompact(vehicle)
        state.configurationOwned=compactOk==true
        result=compactOk and "COMPACTION_REQUESTED_NO_SETTLEMENT_GATE" or ("COMPACTION_NOT_AVAILABLE:"..tostring(compactResult))
    elseif evidence.foldableCount>0 then
        result="COMPACTION_NOT_OBVIOUSLY_AVAILABLE"
    end
    state.configurationResult=result
    return evidence,result
end
function Control:executeControlRequest(request,candidate)
    OuttaMyWay.ValueRecord.assertType(request,"ControlRequest")
    local target=requestTarget(request)
    if target==nil then return false,"TERMINAL_EGRESS_TARGET_UNAVAILABLE" end
    if self.active~=nil then return false,"TERMINAL_EGRESS_CONTROL_ALREADY_ACTIVE" end
    if tokenFor(self.runtime,request)==nil then return false,"TERMINAL_EGRESS_CURRENT_AUTHORITY_TOKEN_UNAVAILABLE" end
    local grantOk,grantReason=self.runtime.boundedAuthority:validateRequest(request)
    if grantOk~=true then return false,grantReason end

    local vehicle=self:_vehicle(target.assemblyReferenceKey)
    if vehicle==nil then return self:_rejectBeforeStart(request,target,"FAILED","CURRENT_PHYSICAL_OBJECT_UNAVAILABLE") end
    if self.actuationMechanism:isPlayerClaimed(vehicle) then return self:_rejectBeforeStart(request,target,"PLAYER_CLAIM","PLAYER_CLAIM_AT_CONTROL_BOUNDARY") end
    if self.actuationMechanism:isSourceReactivated(vehicle) then return self:_rejectBeforeStart(request,target,"SUPERSEDED","SOURCE_AI_REACTIVATED_AT_CONTROL_BOUNDARY") end

    local state={
        commitmentId=request.commitmentId,assemblyId=request.assemblyId,
        assemblyReferenceKey=target.assemblyReferenceKey,phase=target.phase,
        requestId=request.identity,boundedAuthorityId=request.boundedAuthorityId,
        authorityToken=request.authorityToken,startedAt=tonumber(g_time) or 0,
        vehicle=vehicle,objective=target.objective,
        completionContext=target.completionContext or {},
        configurationPolicy=target.configurationPolicy or "RETAIN_CURRENT",
        cleanupFailurePolicy=target.cleanupFailurePolicy or "REPORT_ONLY",
        configurationOwned=false,actuationIssued=false
    }
    self.active=state
    self.startedCount=self.startedCount+1

    if state.phase=="COMPACT" then
        local evidence=self.configurationMechanism:getEvidence(vehicle)
        if evidence.foldableCount==0 or evidence.allFolded==true then
            self:_complete("COMPACTION_COMPLETE",{kind="TERMINAL_EGRESS_COMPACTION",mode="RETAIN_CURRENT",configurationEvidence=evidence})
            return true,"COMPACTION_RETAIN_CURRENT"
        end
        if evidence.transitionCount>0 and evidence.unknownCount==0 then
            state.waitingExistingCompaction=true
            self:_publish(state,"COMPACTION_IN_PROGRESS",{existingMotion=true,configurationEvidence=evidence})
            return true,"COMPACTION_ALREADY_IN_PROGRESS"
        end
        if not evidence.allDeployed or evidence.unknownCount>0 then
            return self:_rejectBeforeStart(request,target,"FAILED","SUPPORTED_COMPACTION_UNAVAILABLE")
        end
        local ok,result=self.configurationMechanism:prepareCompact(vehicle)
        if not ok then return self:_rejectBeforeStart(request,target,"FAILED","COMPACTION_COMMAND_REJECTED:"..tostring(result)) end
        state.configurationOwned=true
        self:_publish(state,"COMPACTION_IN_PROGRESS",{existingMotion=false,configurationEvidence=evidence})
        return true,"COMPACTION_STARTED"
    end

    local objective=state.objective
    if type(objective)~="table"
        or tonumber(objective.infieldDirectionX)==nil
        or tonumber(objective.infieldDirectionZ)==nil
        or tonumber(objective.targetProgressM)==nil
        or tonumber(objective.targetX)==nil
        or tonumber(objective.targetZ)==nil then
        return self:_rejectBeforeStart(request,target,"FAILED","TERMINAL_EGRESS_OBJECTIVE_INCOMPLETE")
    end
    if objective.courtesyExhausted==true then
        return self:_rejectBeforeStart(request,target,"FAILED","COURTESY_ALREADY_EXHAUSTED")
    end

    local position=self.actuationMechanism:position(vehicle)
    if position==nil then return self:_rejectBeforeStart(request,target,"FAILED","NON_JOB_POSE_UNAVAILABLE") end
    local activityOk,activityContext=self.actuationMechanism:acquireVehicleActivityContext(vehicle)
    if not activityOk then
        local status=activityContext=="PLAYER_CLAIM" and "PLAYER_CLAIM" or (activityContext=="SOURCE_INTENT_REACTIVATED" and "SUPERSEDED" or "FAILED")
        return self:_rejectBeforeStart(request,target,status,"VEHICLE_ACTIVITY_CONTEXT_UNAVAILABLE:"..tostring(activityContext))
    end
    state.activityContext=activityContext

    local configurationEvidence=nil
    if state.configurationPolicy=="OPPORTUNISTIC_NO_SETTLEMENT_GATE" then
        configurationEvidence=select(1,self:_prepareOpportunisticCompaction(vehicle,state))
    else
        state.configurationResult="RETAIN_CURRENT"
    end

    local maximumSpeedKmh,speedReason=self.actuationMechanism:maximumForwardSpeedKmh(vehicle)
    if maximumSpeedKmh==nil then
        self:_releaseConfigurationOwnership(vehicle,state)
        self.actuationMechanism:releaseVehicleActivityContext(vehicle,activityContext)
        state.activityContext=nil
        return self:_rejectBeforeStart(request,target,"FAILED","TERMINAL_EGRESS_NATIVE_MAX_SPEED_UNAVAILABLE:"..tostring(speedReason))
    end

    state.startX=position.x; state.startZ=position.z
    state.infieldDirectionX=tonumber(objective.infieldDirectionX); state.infieldDirectionZ=tonumber(objective.infieldDirectionZ)
    state.targetX=tonumber(objective.targetX); state.targetZ=tonumber(objective.targetZ)
    state.targetProgressM=tonumber(objective.targetProgressM)
    state.retreatDistanceM=tonumber(objective.retreatDistanceM) or state.targetProgressM
    state.courtesyStage=tonumber(objective.courtesyStage) or 1
    state.destinationKind=objective.destinationKind
    state.objectiveKind=objective.objectiveKind
    state.speedKmh=maximumSpeedKmh

    self:_publish(state,"MANOEUVRE_IN_PROGRESS",{
        courtesyStage=state.courtesyStage,destinationKind=state.destinationKind,
        fixedDirectionX=state.infieldDirectionX,fixedDirectionZ=state.infieldDirectionZ,
        targetX=state.targetX,targetZ=state.targetZ,targetProgressM=state.targetProgressM,
        speedKmh=state.speedKmh,speedPolicy="NATIVE_MAX_FORWARD",continuousCourseCorrection=false,
        configurationResult=state.configurationResult,configurationEvidence=configurationEvidence
    })
    logInfo("CONTROL_STARTED commitment=%s assembly=%s targetProgress=%.2fm speed=%.2fkmh configuration=%s",
        tostring(state.commitmentId),tostring(state.assemblyReferenceKey),state.targetProgressM,state.speedKmh,tostring(state.configurationResult))
    return true,"MANOEUVRE_STARTED"
end
function Control:update(dt)
    local state=self.active
    if state==nil then return end
    state.lastDt=dt
    if self.runtime.boundedAuthority:isCurrent(state.boundedAuthorityId)~=true then self:_complete("FAILED",{kind="TERMINAL_EGRESS_CONTROL_FAILURE",reason="BOUNDED_AUTHORITY_LOST"}); return end
    if tokenFor(self.runtime,state)==nil then self:_complete("FAILED",{kind="TERMINAL_EGRESS_CONTROL_FAILURE",reason="AUTHORITY_TOKEN_LOST"}); return end

    local vehicle=self:_vehicle(state.assemblyReferenceKey)
    if vehicle==nil then self:_complete("FAILED",{kind="TERMINAL_EGRESS_CONTROL_FAILURE",reason="CURRENT_PHYSICAL_OBJECT_LOST"}); return end
    if self.actuationMechanism:isPlayerClaimed(vehicle) then self:_complete("PLAYER_CLAIM",{kind="CURRENT_PLAYER_CLAIM"}); return end
    if self.actuationMechanism:isSourceReactivated(vehicle) then self:_complete("SUPERSEDED",{kind="CURRENT_SOURCE_AI_REACTIVATION"}); return end

    local elapsed=(tonumber(g_time) or 0)-state.startedAt
    if state.phase=="COMPACT" then
        local evidence=self.configurationMechanism:getEvidence(vehicle)
        if evidence.allFolded==true then
            self:_releaseConfigurationOwnership(vehicle,state)
            self:_complete("COMPACTION_COMPLETE",{kind="TERMINAL_EGRESS_COMPACTION",mode="COMPACTED",configurationEvidence=evidence})
            return
        end
        if elapsed>(tonumber(OuttaMyWay.TERMINAL_EGRESS_COMPACTION_TIMEOUT_MS) or 25000) then
            self:_releaseConfigurationOwnership(vehicle,state)
            self:_complete("FAILED",{kind="TERMINAL_EGRESS_CONTROL_FAILURE",reason="COMPACTION_WATCHDOG_EXPIRED",configurationEvidence=evidence})
            return
        end
        self:_publish(state,"COMPACTION_IN_PROGRESS",{configurationEvidence=evidence})
        return
    end

    local position=self.actuationMechanism:position(vehicle)
    if position==nil then self:_complete("FAILED",{kind="TERMINAL_EGRESS_CONTROL_FAILURE",reason="NON_JOB_POSE_LOST"}); return end
    local dx,dz=position.x-state.startX,position.z-state.startZ
    local realisedProgress=dx*state.infieldDirectionX+dz*state.infieldDirectionZ
    local targetDistance=distanceTo(position.x,position.z,state.targetX,state.targetZ)
    if realisedProgress>=state.targetProgressM then
        self:_complete("MANOEUVRE_COMPLETE",{
            kind="TERMINAL_EGRESS_MANOEUVRE_COMPLETE",courtesyStage=state.courtesyStage,
            destinationKind=state.destinationKind,targetX=state.targetX,targetZ=state.targetZ,
            targetProgressM=state.targetProgressM,realisedProgressM=realisedProgress,
            finalTargetDistanceM=targetDistance,fixedDirectionX=state.infieldDirectionX,fixedDirectionZ=state.infieldDirectionZ,
            continuousCourseCorrection=false,directDriveCalls=self.actuationMechanism:getDirectDriveCallCount(),freshSituationRequired=true
        })
        return
    end
    if elapsed>(tonumber(OuttaMyWay.TERMINAL_EGRESS_MOVE_TIMEOUT_MS) or 45000) then
        self:_complete("FAILED",{kind="TERMINAL_EGRESS_CONTROL_FAILURE",reason="BOUNDED_MOVE_WATCHDOG_EXPIRED",courtesyStage=state.courtesyStage,realisedProgressM=realisedProgress,targetProgressM=state.targetProgressM})
        return
    end

    local ok,result=self.actuationMechanism:driveInWorldDirection(vehicle,dt,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh)
    if not ok then
        if result=="PLAYER_CLAIM" then self:_complete("PLAYER_CLAIM",{kind="CURRENT_PLAYER_CLAIM"})
        elseif result=="SOURCE_INTENT_REACTIVATED" then self:_complete("SUPERSEDED",{kind="CURRENT_SOURCE_AI_REACTIVATION"})
        else self:_complete("FAILED",{kind="TERMINAL_EGRESS_CONTROL_FAILURE",reason=tostring(result)}) end
        return
    end
    state.actuationIssued=true
    self:_publish(state,"MANOEUVRE_IN_PROGRESS",{
        courtesyStage=state.courtesyStage,destinationKind=state.destinationKind,
        realisedProgressM=realisedProgress,targetProgressM=state.targetProgressM,currentTargetDistanceM=targetDistance,
        fixedDirectionX=state.infieldDirectionX,fixedDirectionZ=state.infieldDirectionZ,
        continuousCourseCorrection=false,directionEvidence=result,configurationResult=state.configurationResult
    })
end
function Control:loadMap() self.active=nil; self.latestObservation=nil; self.configurationMechanism:clearAll() end
function Control:deleteMap() self.active=nil; self.latestObservation=nil; self.configurationMechanism:clearAll() end
function Control:keyEvent() end
function Control:mouseEvent() end
function Control:draw() end
function Control:getStatus()
    return {
        active=self.active~=nil,phase=self.active and self.active.phase or nil,
        startedCount=self.startedCount,completedCount=self.completedCount,failedCount=self.failedCount,
        directDriveCalls=self.actuationMechanism:getDirectDriveCallCount(),
        neutralizeCalls=self.actuationMechanism:getNeutralizeCallCount(),
        activityContextAcquireCalls=self.actuationMechanism:getActivityContextAcquireCallCount(),
        activityContextReleaseCalls=self.actuationMechanism:getActivityContextReleaseCallCount()
    }
end
