--- Executes one authorised two-phase Blocked Worker Recovery cycle.
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
        active=nil,phaseHandler=nil,completionHandler=nil,completedCount=0,failedCount=0
    },Control)
end

function Control:setPhaseHandler(handler) self.phaseHandler=handler end
function Control:setCompletionHandler(handler) self.completionHandler=handler end
function Control:isActive() return self.active~=nil end
function Control:getStatus()
    local a=self.active
    return {
        active=a~=nil,phase=a and a.phase or nil,commitmentId=a and a.commitmentId or nil,
        expectedSuccessorSourceJobToken=a and a.expectedSuccessorSourceJobToken or nil,
        completedCount=self.completedCount,failedCount=self.failedCount
    }
end
function Control:keyEvent() end
function Control:mouseEvent() end
function Control:draw() end
function Control:loadMap()
    local ok,reason=self.driveMechanism:install()
    if not ok then logWarning("NORMAL","BLOCKED_WORKER_RECOVERY_DRIVE_MECHANISM_UNAVAILABLE","reason=%s",tostring(reason)) end
end
function Control:deleteMap() self:relinquishAll("MAP_DELETE") end

function Control:_notifyPhase(state,phaseEvent,evidence)
    if type(self.phaseHandler)~="function" then return end
    local result={
        phaseEvent=phaseEvent,commitmentId=state.commitmentId,assemblyId=state.assemblyId,
        requestId=state.requestId,boundedAuthorityId=state.boundedAuthorityId,
        recoveryKey=state.recoveryKey,evidence=evidence or {}
    }
    local ok,reason=pcall(self.phaseHandler,result)
    if not ok then
        logWarning("NORMAL","BLOCKED_WORKER_RECOVERY_PHASE_HANDLER_FAILED",
            "commitment=%s event=%s reason=%s",tostring(state.commitmentId),tostring(phaseEvent),tostring(reason))
    end
end

function Control:_notify(result)
    if type(self.completionHandler)=="function" then
        local ok,reason=pcall(self.completionHandler,result)
        if not ok then logWarning("NORMAL","BLOCKED_WORKER_RECOVERY_COMPLETION_HANDLER_FAILED","reason=%s",tostring(reason)) end
    end
end

function Control:_clearOwnedPhysicalState(state)
    self.driveMechanism:clearMovementObjective(state.vehicle)
    if type(self.configurationMechanism.clear)=="function" then
        self.configurationMechanism:clear(state.vehicle)
    end
end

function Control:_finish(status,evidence)
    local state=self.active
    if state==nil then return end
    self:_clearOwnedPhysicalState(state)
    self.active=nil
    if status=="SUCCEEDED" then self.completedCount=self.completedCount+1 else self.failedCount=self.failedCount+1 end
    self:_notify({
        status=status,commitmentId=state.commitmentId,assemblyId=state.assemblyId,
        requestId=state.requestId,boundedAuthorityId=state.boundedAuthorityId,
        recoveryKey=state.recoveryKey,evidence=evidence or {}
    })
end

-- Failures before the Recovery Anchor retain the previous cleanup contract:
-- restore any partially created Transit debt before reporting a pre-semantic
-- Control failure.  Normal successful Recovery never restores after the Anchor.
function Control:_failBeforeRecoveryPoint(state,evidence)
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
    self:_clearOwnedPhysicalState(state)
    self.active=nil
    return {released=1,reason=reason}
end

function Control:_activeEpisode(state)
    return self.runtime and self.runtime.jobEpisodes
        and self.runtime.jobEpisodes:getActiveForAssembly(state.assemblyId) or nil
end

function Control:_originatingJobStillCurrent(state)
    local episode=self:_activeEpisode(state)
    return episode~=nil
        and episode.identity==state.jobEpisodeId
        and episode.sourceJobToken==state.sourceJobToken
end

-- Phase 2 preparation and Job Replacement Commitment.  Preparation is entirely
-- reversible; the commitment boundary is the successful call to stopJob.
function Control:_replaceNativeFieldWorkJob(state)
    local mission=g_currentMission
    if mission==nil then
        return false,{kind="NATIVE_JOB_REPLACEMENT_MISSION_UNAVAILABLE",replacementCommitted=false}
    end
    local aiSystem=mission.aiSystem
    local manager=mission.aiJobTypeManager
    if type(aiSystem)~="table" or type(manager)~="table" then
        return false,{kind="NATIVE_JOB_REPLACEMENT_API_UNAVAILABLE",replacementCommitted=false}
    end
    if aiSystem.isServer~=true then
        return false,{kind="NATIVE_JOB_REPLACEMENT_REQUIRES_SERVER",replacementCommitted=false}
    end

    local vehicle=state.vehicle
    if type(vehicle.getJob)~="function" then
        return false,{kind="NATIVE_JOB_REPLACEMENT_CURRENT_JOB_UNAVAILABLE",replacementCommitted=false}
    end
    local currentJob=vehicle:getJob()
    if currentJob==nil then
        return false,{kind="NATIVE_JOB_REPLACEMENT_CURRENT_JOB_UNAVAILABLE",replacementCommitted=false}
    end
    if type(manager.getJobTypeIndexByName)~="function"
        or type(manager.getJobTypeIndex)~="function"
        or type(manager.createJob)~="function" then
        return false,{kind="NATIVE_JOB_REPLACEMENT_MANAGER_API_UNAVAILABLE",replacementCommitted=false}
    end

    local fieldWorkType=manager:getJobTypeIndexByName("FIELDWORK")
    local currentType=manager:getJobTypeIndex(currentJob)
    if fieldWorkType==nil or currentType~=fieldWorkType then
        return false,{
            kind="NATIVE_JOB_REPLACEMENT_NOT_FIELDWORK",
            currentType=currentType,fieldWorkType=fieldWorkType,replacementCommitted=false
        }
    end

    local farmId=nil
    if type(vehicle.getAIJobFarmId)=="function" then farmId=vehicle:getAIJobFarmId() end
    if farmId==nil and type(vehicle.getOwnerFarmId)=="function" then farmId=vehicle:getOwnerFarmId() end
    if farmId==nil then
        return false,{kind="NATIVE_JOB_REPLACEMENT_FARM_UNAVAILABLE",replacementCommitted=false}
    end

    local replacement=manager:createJob(fieldWorkType)
    if replacement==nil then
        return false,{kind="NATIVE_JOB_REPLACEMENT_CREATE_FAILED",replacementCommitted=false}
    end
    local function discardReplacement()
        if type(replacement.delete)=="function" then pcall(replacement.delete,replacement) end
    end

    if type(replacement.applyCurrentState)~="function"
        or type(replacement.setValues)~="function"
        or type(replacement.validate)~="function" then
        discardReplacement()
        return false,{kind="NATIVE_JOB_REPLACEMENT_JOB_API_UNAVAILABLE",replacementCommitted=false}
    end

    local applied,applyReason=pcall(replacement.applyCurrentState,replacement,vehicle,mission,farmId,true)
    if not applied then
        discardReplacement()
        return false,{kind="NATIVE_JOB_REPLACEMENT_APPLY_FAILED",reason=tostring(applyReason),replacementCommitted=false}
    end
    local valuesSet,setReason=pcall(replacement.setValues,replacement)
    if not valuesSet then
        discardReplacement()
        return false,{kind="NATIVE_JOB_REPLACEMENT_SET_VALUES_FAILED",reason=tostring(setReason),replacementCommitted=false}
    end
    local validated,isValid,validationReason=pcall(replacement.validate,replacement,farmId)
    if not validated or isValid~=true then
        discardReplacement()
        return false,{
            kind="NATIVE_JOB_REPLACEMENT_VALIDATE_FAILED",
            reason=tostring(validated and validationReason or isValid),replacementCommitted=false
        }
    end

    if type(aiSystem.stopJob)~="function" or type(aiSystem.startJob)~="function" then
        discardReplacement()
        return false,{kind="NATIVE_JOB_REPLACEMENT_SYSTEM_API_UNAVAILABLE",replacementCommitted=false}
    end

    local oldJobId=currentJob.jobId
    local stopped,stopReason=pcall(aiSystem.stopJob,aiSystem,currentJob,nil)
    if not stopped then
        discardReplacement()
        return false,{
            kind="NATIVE_JOB_REPLACEMENT_STOP_FAILED",reason=tostring(stopReason),
            oldJobId=oldJobId,farmId=farmId,replacementCommitted=false
        }
    end

    local started,startReason=pcall(aiSystem.startJob,aiSystem,replacement,farmId)
    if not started then
        discardReplacement()
        return false,{
            kind="NATIVE_JOB_REPLACEMENT_START_FAILED",reason=tostring(startReason),
            oldJobId=oldJobId,farmId=farmId,replacementCommitted=true
        }
    end

    local newJobId=replacement.jobId
    local evidence={
        kind="NATIVE_JOB_REPLACEMENT_STARTED",
        oldJobId=oldJobId,newJobId=newJobId,
        expectedSourceJobToken=newJobId~=nil and ("giants-ai-job-id:"..tostring(newJobId)) or nil,
        fieldWorkType=fieldWorkType,farmId=farmId,directStart=true,
        stopMessageNil=true,replacementCommitted=true
    }
    logInfo("DEBUG","BLOCKED_WORKER_RECOVERY_NATIVE_JOB_REPLACEMENT_STARTED",
        "commitment=%s assembly=%s oldJob=%s newJob=%s farm=%s directStart=true stopMessage=nil",
        tostring(state.commitmentId),tostring(state.assemblyId),tostring(oldJobId),
        tostring(newJobId),tostring(farmId))
    return true,evidence
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

function Control:_beginNativeReplanning(state)
    local phaseEvidence={
        kind="RECOVERY_ANCHOR_REACHED_IN_TRANSIT",
        anchorX=state.anchorX,anchorZ=state.anchorZ,
        transitRequested=state.transitRequested==true,
        transitChanged=state.transitChanged==true
    }
    self:_notifyPhase(state,"PHYSICAL_RECOVERY_SATISFIED",phaseEvidence)

    local replaced,replacementEvidence=self:_replaceNativeFieldWorkJob(state)
    if replaced~=true then
        state.pendingFailureEvidence={
            kind="RECOVERY_NATIVE_JOB_REPLACEMENT_UNRESOLVED",
            anchorX=state.anchorX,anchorZ=state.anchorZ,
            replacement=replacementEvidence
        }
        if replacementEvidence and replacementEvidence.replacementCommitted==true then
            self:_clearOwnedPhysicalState(state)
            state.phase="UNRESOLVED_NATIVE_REACQUISITION"
        else
            -- The known-failed originating Job still exists.  Keep the already
            -- reached REPOSITION target as the bounded zero-speed state rather
            -- than exposing that failed native plan again.
            state.phase="WAITING_FOR_PLAYER_INTERVENTION"
        end
        logWarning("NORMAL","BLOCKED_WORKER_RECOVERY_NATIVE_JOB_REPLACEMENT_UNRESOLVED",
            "commitment=%s assembly=%s committed=%s reason=%s",
            tostring(state.commitmentId),tostring(state.assemblyId),
            tostring(replacementEvidence and replacementEvidence.replacementCommitted==true),
            tostring(replacementEvidence and replacementEvidence.kind or "UNKNOWN"))
        return
    end

    state.replacementEvidence=replacementEvidence
    state.expectedSuccessorSourceJobToken=replacementEvidence.expectedSourceJobToken
    state.expectedSuccessorNativeJobId=replacementEvidence.newJobId

    -- From this point GIANTS owns all configuration and movement.  Discard OMW
    -- Transit bookkeeping without restoring the former working posture.
    self:_clearOwnedPhysicalState(state)

    if type(state.expectedSuccessorSourceJobToken)~="string" then
        state.phase="UNRESOLVED_NATIVE_REACQUISITION"
        state.pendingFailureEvidence={
            kind="RECOVERY_REPLACEMENT_JOB_ID_UNAVAILABLE",
            replacement=replacementEvidence
        }
        return
    end

    state.phase="WAITING_FOR_REPLACEMENT_JOB_EPISODE"
    logInfo("DEBUG","BLOCKED_WORKER_RECOVERY_WAITING_FOR_SUCCESSOR_JOB_EPISODE",
        "commitment=%s assembly=%s expectedSourceJob=%s",
        tostring(state.commitmentId),tostring(state.assemblyId),tostring(state.expectedSuccessorSourceJobToken))
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
        transitRequested=false,transitChanged=false
    }
    if not self:_originatingJobStillCurrent(state) then return false,"BLOCKED_WORKER_RECOVERY_JOB_EPISODE_CHANGED" end

    self.active=state
    local started,startReason=self:_requestTransit(state)
    if started~=true then
        self:_finish("FAILED",{kind="RECOVERY_TRANSIT_OR_MOVEMENT_START_FAILED",reason=startReason})
        return false,startReason
    end
    return true,{phase=state.phase,recoveryKey=state.recoveryKey}
end

function Control:update(dt)
    local state=self.active
    if state==nil then return end

    if state.phase=="WAITING_FOR_REPLACEMENT_JOB_EPISODE" then
        local episode=self:_activeEpisode(state)
        if episode==nil then return end
        if episode.sourceJobToken==state.expectedSuccessorSourceJobToken then
            self:_finish("SUCCEEDED",{
                kind="RECOVERY_INTENDED_SUCCESSOR_JOB_EPISODE_ADMITTED",
                originatingJobEpisodeId=state.jobEpisodeId,
                successorJobEpisodeId=episode.identity,
                expectedSuccessorSourceJobToken=state.expectedSuccessorSourceJobToken,
                observedSuccessorSourceJobToken=episode.sourceJobToken,
                nativeJobReplacement=state.replacementEvidence
            })
            return
        end
        if episode.identity==state.jobEpisodeId and episode.sourceJobToken==state.sourceJobToken then
            return
        end
        self:_finish("SUPERSEDED",{
            kind="RECOVERY_UNEXPECTED_SUCCESSOR_JOB_EPISODE",
            expectedSuccessorSourceJobToken=state.expectedSuccessorSourceJobToken,
            observedJobEpisodeId=episode.identity,observedSourceJobToken=episode.sourceJobToken
        })
        return
    end

    if state.phase=="UNRESOLVED_NATIVE_REACQUISITION" then
        local episode=self:_activeEpisode(state)
        if episode~=nil and type(state.expectedSuccessorSourceJobToken)=="string"
            and episode.sourceJobToken==state.expectedSuccessorSourceJobToken then
            self:_finish("SUCCEEDED",{
                kind="RECOVERY_INTENDED_SUCCESSOR_JOB_EPISODE_ADMITTED",
                originatingJobEpisodeId=state.jobEpisodeId,
                successorJobEpisodeId=episode.identity,
                expectedSuccessorSourceJobToken=state.expectedSuccessorSourceJobToken,
                observedSuccessorSourceJobToken=episode.sourceJobToken,
                nativeJobReplacement=state.replacementEvidence
            })
        elseif episode~=nil and episode.sourceJobToken~=state.sourceJobToken then
            self:_finish("SUPERSEDED",{
                kind="RECOVERY_UNEXPECTED_JOB_AFTER_REACQUISITION_FAILURE",
                observedJobEpisodeId=episode.identity,observedSourceJobToken=episode.sourceJobToken
            })
        end
        return
    end

    if not self:_originatingJobStillCurrent(state) then
        -- Before the intentional replacement boundary, source-Job termination is
        -- external/new authority.  Relinquish immediately and do not restore.
        self:_finish("SUPERSEDED",{kind="RECOVERY_SOURCE_JOB_TERMINATED_BEFORE_REPLACEMENT_COMMITMENT"})
        return
    end

    if state.phase=="WAITING_FOR_PLAYER_INTERVENTION" then
        return
    end

    if state.phase=="WAITING_FOR_TRANSIT" then
        local settlement=self.configurationMechanism:getCachedTransitSettlement(state.vehicle)
        if settlement.settled~=true then return end
        if settlement.exhausted==true then
            self:_failBeforeRecoveryPoint(state,{kind="RECOVERY_TRANSIT_SETTLEMENT_FAILED",reason=settlement.reason})
            return
        end
        local ok,reason=self:_beginMovement(state)
        if not ok then self:_failBeforeRecoveryPoint(state,{kind="RECOVERY_MOVEMENT_START_FAILED",reason=reason}) end
        return
    end

    if state.phase=="MOVING_TO_RECOVERY_ANCHOR" then
        local drive=self.driveMechanism:getState(state.vehicle)
        if drive==nil then self:_failBeforeRecoveryPoint(state,{kind="RECOVERY_MOVEMENT_AUTHORITY_LOST"}); return end
        if drive.invalidReason~=nil then self:_failBeforeRecoveryPoint(state,{kind="RECOVERY_MOVEMENT_FAILED",reason=drive.invalidReason}); return end
        if drive.targetReached~=true then return end
        self:_beginNativeReplanning(state)
        return
    end

    if state.phase=="WAITING_FOR_FAILURE_RESTORE" then
        local settlement=self.configurationMechanism:getCachedRestoreSettlement(state.vehicle)
        if settlement.settled~=true then return end
        local ok,result=self.configurationMechanism:finishCachedTransitRestore(state.vehicle)
        if not ok then
            local evidence=state.pendingFailureEvidence or {kind="RECOVERY_CLEANUP_FAILED"}
            evidence.restoreFailure=tostring(result)
            self:_finish("FAILED",evidence)
            return
        end
        self:_finish("FAILED",state.pendingFailureEvidence)
    end
end

return Control
