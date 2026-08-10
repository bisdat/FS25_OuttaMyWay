-- D-0140 Authority Reset: retained D-0131/D-0132/D-0133 committed-transition
-- evidence harness, now PASSIVE SHADOW ONLY. It may retain/seal positive Progress
-- horizon evidence and evaluate the historical bounded timing witness, but it
-- cannot acquire, maintain or release a Regulation lease and carries no
-- boundary-demand, Decision or Control authority. Future reactivation requires
-- Situation-level Representation Fitness plus Candidate/Decision/Commitment.

OuttaMyWay.CommittedTransitionRegulationTestBridge = {}
local Bridge = OuttaMyWay.CommittedTransitionRegulationTestBridge
Bridge.__index = Bridge

local OWNER_TAG = "D0131_COMMITTED_TRANSITION_PROTECTION_TEST"

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][D0131-TRANSITION-REGULATION][INFO] %s",message)
    else print("[FS25_OuttaMyWay][D0131-TRANSITION-REGULATION][INFO] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][D0131-TRANSITION-REGULATION][WARN] %s",message)
    else print("[FS25_OuttaMyWay][D0131-TRANSITION-REGULATION][WARN] "..message) end
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function pose(vehicle)
    if vehicle==nil then return nil end
    local node=nil
    local ok,value=safeCall(vehicle,"getAISteeringNode")
    if ok and value~=nil and value~=0 then node=value end
    node=node or vehicle.rootNode
    if node==nil or node==0 or type(getWorldTranslation)~="function" or type(localDirectionToWorld)~="function" then return nil end
    local okPos,x,y,z=pcall(getWorldTranslation,node)
    local okDir,dx,_,dz=pcall(localDirectionToWorld,node,0,0,1)
    if not okPos or not okDir then return nil end
    local length=math.sqrt(dx*dx+dz*dz)
    if length<=0.0001 then return nil end
    return {node=node,x=x,y=y,z=z,dx=dx/length,dz=dz/length}
end

local function distance(ax,az,bx,bz)
    local dx,dz=(bx or 0)-(ax or 0),(bz or 0)-(az or 0)
    return math.sqrt(dx*dx+dz*dz)
end

local function dot(ax,az,bx,bz) return (ax or 0)*(bx or 0)+(az or 0)*(bz or 0) end

local function progressTrack(capabilityGate,run)
    local source=capabilityGate and capabilityGate.runtime and capabilityGate.runtime.liveObservationSource or nil
    local tracks=source and source.tracks or nil
    return tracks and run and tracks[run.progressReferenceKey] or nil
end

local function productiveEvidence(run)
    local source=OuttaMyWay.runtime and OuttaMyWay.runtime.situationAssessment or nil
    return source and type(source.getEvidence)=="function" and source:getEvidence(run.progressReferenceKey,run.progressStartJobToken) or nil
end

local function fieldBoundary(capabilityGate,run,progressPose)
    local fieldSnapshot=nil
    if capabilityGate and capabilityGate.runtime and capabilityGate.runtime.fieldWorldSnapshots then
        fieldSnapshot=select(1,capabilityGate.runtime.fieldWorldSnapshots:getForVehicle(run.progressVehicle,run.progressStartJobToken))
    end
    if fieldSnapshot~=nil and OuttaMyWay.FieldBoundedFutureSpace~=nil then
        return select(1,OuttaMyWay.FieldBoundedFutureSpace.forwardBoundaryDistance(fieldSnapshot,progressPose))
    end
    return nil
end

function Bridge.remainingSealedBoundary(sealed,current)
    if type(sealed)~="table" then return nil,"NO_SEALED_PROGRESS_HORIZON" end
    if type(current)~="table" then return nil,"CURRENT_PROGRESS_BASIS_UNAVAILABLE" end
    if current.jobToken==nil or tostring(current.jobToken)~=tostring(sealed.jobToken) then return nil,"SEALED_PROGRESS_JOB_EPISODE_CHANGED" end
    if current.intentEpoch==nil or tonumber(current.intentEpoch)~=tonumber(sealed.intentEpoch) then return nil,"SEALED_PROGRESS_INTENT_EPOCH_CHANGED" end
    if current.intentValid~=true or current.intentClassification~="SETTLED_CONTINUATION" then return nil,"SEALED_PROGRESS_LOCAL_INTENT_NO_LONGER_SETTLED" end
    if current.productivePositive~=true or current.movingDirection~=1 then return nil,"SEALED_PROGRESS_PRODUCTIVE_BASIS_NO_LONGER_POSITIVE" end
    local x,z=tonumber(current.x),tonumber(current.z)
    if x==nil or z==nil then return nil,"CURRENT_PROGRESS_POSE_UNAVAILABLE" end
    local remaining=dot((sealed.boundaryX or 0)-x,(sealed.boundaryZ or 0)-z,sealed.dx,sealed.dz)
    if remaining<0 then return nil,"SEALED_PROGRESS_HORIZON_EXHAUSTED" end
    local source=sealed.sealSource=="RETAINED_PRE_HANDOFF" and "SEALED_FROM_RETAINED_PRE_HANDOFF" or "SEALED_AT_COMMITTED_TRANSITION_ADMISSION"
    return remaining,source
end

local function egressContext(run)
    if run==nil or run.kind~="TS015_RELOCATE" then return false end
    return run.phase=="TS015_COMPACTING" or run.phase=="TS015_MOVING"
end

function Bridge.evaluateSignal(sample)
    if type(sample)~="table" then return {status="UNRESOLVED",reason="NO_TRANSITION_SAMPLE"} end
    if sample.progressExpectedJobToken==nil or sample.progressEvidenceJobToken==nil then
        return {status="UNRESOLVED",reason="PROGRESS_JOB_EVIDENCE_UNAVAILABLE"}
    end
    if tostring(sample.progressExpectedJobToken)~=tostring(sample.progressEvidenceJobToken) then
        return {status="INVALIDATED",reason="PROGRESS_JOB_EPISODE_CHANGED"}
    end
    if sample.progressProductivePositive~=true then
        return {status="UNRESOLVED",reason="POSITIVE_PRODUCTIVE_CONTINUATION_UNAVAILABLE"}
    end
    if sample.progressMovingDirection~=1 then
        return {status="UNRESOLVED",reason=sample.progressMovingDirection==-1 and "PRODUCTIVE_REVERSE_NOT_REPRESENTED_BY_CURRENT_TEST" or "PRODUCTIVE_MOVEMENT_DIRECTION_UNRESOLVED"}
    end
    local entry=tonumber(sample.progressEntryM)
    local boundary=tonumber(sample.progressBoundaryM)
    if entry==nil then return {status="UNRESOLVED",reason="NO_POSITIVE_EGRESS_SWEEP_INTERSECTION_WITNESS"} end
    if boundary==nil then return {status="UNRESOLVED",reason="FIELD_BOUNDED_PROGRESS_HORIZON_UNAVAILABLE",progressEntryM=entry} end
    if entry>boundary then return {status="UNRESOLVED",reason="EGRESS_SWEEP_INTERSECTION_BEYOND_CURRENT_FIELD_BOUNDED_CONTINUATION",progressEntryM=entry,progressBoundaryM=boundary} end
    local progressSpeed=tonumber(sample.progressSpeedMps)
    if progressSpeed==nil or progressSpeed<=0.01 then
        return {status="UNRESOLVED",reason="PROGRESS_RATE_NOT_POSITIVELY_CONSUMING_TRANSITION",progressEntryM=entry,progressBoundaryM=boundary}
    end
    local egressRemaining=tonumber(sample.egressRemainingM)
    local egressCeiling=tonumber(sample.egressSpeedCeilingMps)
    if egressRemaining==nil or egressCeiling==nil or egressCeiling<=0.01 then
        return {status="UNRESOLVED",reason="EGRESS_COMPLETION_LOWER_BOUND_UNAVAILABLE",progressEntryM=entry,progressBoundaryM=boundary}
    end
    local progressEta=entry/progressSpeed
    local idealEgressCompletion=egressRemaining/egressCeiling
    if progressEta<=idealEgressCompletion then
        return {
            status="POSITIVE",
            reason="PROGRESS_ENTRY_NOT_LATER_THAN_IDEAL_EGRESS_COMPLETION_LOWER_BOUND",
            progressEntryM=entry,progressBoundaryM=boundary,progressEtaSec=progressEta,
            egressRemainingM=egressRemaining,idealEgressCompletionSec=idealEgressCompletion
        }
    end
    -- This is not negative-clearance authority. A best-case egress could finish
    -- first, but actual transition completion and later native motion remain
    -- uncertain, so absence of the positive witness cannot retire an active lease.
    return {
        status="UNRESOLVED",
        reason="NO_POSITIVE_TIMING_THREAT_WITNESS",
        progressEntryM=entry,progressBoundaryM=boundary,progressEtaSec=progressEta,
        egressRemainingM=egressRemaining,idealEgressCompletionSec=idealEgressCompletion
    }
end

function Bridge.new()
    return setmetatable({active=nil,sealedProgressHorizon=nil,retainedProgressHorizons={},lastStatus=nil,lastReason=nil,nextHeartbeatAt=0,applyCount=0,releaseCount=0},Bridge)
end


function Bridge:retainPositiveProgressHorizon(sample)
    if type(sample)~="table" then return false,"NO_PROGRESS_HORIZON_SAMPLE" end
    local referenceKey=sample.referenceKey
    if referenceKey==nil or sample.jobToken==nil then return false,"PROGRESS_IDENTITY_UNAVAILABLE" end
    if sample.intentValid~=true or sample.intentClassification~="SETTLED_CONTINUATION" or tonumber(sample.intentEpoch)==nil then
        return false,"POSITIVE_SETTLED_LOCAL_INTENT_BASIS_UNAVAILABLE"
    end
    if sample.productivePositive~=true or tonumber(sample.movingDirection)~=1 then
        return false,"POSITIVE_PRODUCTIVE_CONTINUATION_UNAVAILABLE"
    end
    local x,z,dx,dz,boundary=tonumber(sample.x),tonumber(sample.z),tonumber(sample.dx),tonumber(sample.dz),tonumber(sample.boundaryM)
    if x==nil or z==nil or dx==nil or dz==nil or boundary==nil or boundary<0 then return false,"FIELD_BOUNDED_PROGRESS_HORIZON_UNAVAILABLE" end
    local length=math.sqrt(dx*dx+dz*dz)
    if length<=0.0001 then return false,"PROGRESS_DIRECTION_UNAVAILABLE" end
    dx,dz=dx/length,dz/length
    local prior=self.retainedProgressHorizons[referenceKey]
    local record={
        vehicle=sample.vehicle,progressName=sample.progressName,referenceKey=referenceKey,jobToken=sample.jobToken,
        intentEpoch=tonumber(sample.intentEpoch),x=x,z=z,dx=dx,dz=dz,boundaryM=boundary,
        boundaryX=x+dx*boundary,boundaryZ=z+dz*boundary,retainedAt=sample.nowMs or (g_time or 0),
        source=sample.source or "POSITIVE_PRE_HANDOFF_FIELD_BOUNDED_CONTINUATION"
    }
    self.retainedProgressHorizons[referenceKey]=record
    if prior==nil or tostring(prior.jobToken)~=tostring(record.jobToken) or tonumber(prior.intentEpoch)~=tonumber(record.intentEpoch) then
        logInfo("HORIZON_RETENTION_OPEN progress=%s job=%s intentEpoch=%s boundary=%.2fm endpoint=(%.2f,%.2f) source=%s authority=RETAINED_EVIDENCE_ONLY negativeClearanceAuthority=false",
            tostring(record.progressName),tostring(record.jobToken),tostring(record.intentEpoch),record.boundaryM,record.boundaryX,record.boundaryZ,tostring(record.source))
    end
    return true,"RETAINED"
end

function Bridge:_retainedForAdmission(capabilityGate,run,progressPose,evidence,track)
    local retained=self.retainedProgressHorizons and self.retainedProgressHorizons[run and run.progressReferenceKey or nil] or nil
    if retained==nil then return nil,"NO_RETAINED_PRE_HANDOFF_PROGRESS_HORIZON" end
    if tostring(retained.jobToken)~=tostring(run.progressStartJobToken) then return nil,"RETAINED_PROGRESS_JOB_EPISODE_CHANGED" end
    local epoch=track and tonumber(track.localIntentEpoch) or nil
    if epoch==nil or epoch~=tonumber(retained.intentEpoch) then return nil,"RETAINED_PROGRESS_INTENT_EPOCH_CHANGED" end
    if track.localIntentValid~=true or track.localIntentClassification~="SETTLED_CONTINUATION" then return nil,"RETAINED_PROGRESS_LOCAL_INTENT_NO_LONGER_SETTLED" end
    if evidence==nil or evidence.productivePositive~=true or tonumber(evidence.movingDirection)~=1 then return nil,"RETAINED_PROGRESS_PRODUCTIVE_BASIS_NO_LONGER_POSITIVE" end
    local remaining=dot((retained.boundaryX or 0)-progressPose.x,(retained.boundaryZ or 0)-progressPose.z,retained.dx,retained.dz)
    if remaining<0 then return nil,"RETAINED_PROGRESS_HORIZON_EXHAUSTED" end
    return {
        vehicle=run.progressVehicle,progressName=run.progressVehicleName,referenceKey=run.progressReferenceKey,jobToken=run.progressStartJobToken,
        intentEpoch=epoch,x=retained.x,z=retained.z,dx=retained.dx,dz=retained.dz,boundaryM=remaining,
        boundaryX=retained.boundaryX,boundaryZ=retained.boundaryZ,sealedAt=g_time or 0,
        reason="COMMITTED_REPOSITION_ADMISSION",sealSource="RETAINED_PRE_HANDOFF"
    },"RETAINED_PRE_HANDOFF"
end

function Bridge:_clearSealed(reason)
    local sealed=self.sealedProgressHorizon
    if sealed~=nil then
        logInfo("HORIZON_INVALIDATED progress=%s job=%s intentEpoch=%s reason=%s authority=SEALED_EVIDENCE_ONLY",
            tostring(sealed.progressName),tostring(sealed.jobToken),tostring(sealed.intentEpoch),tostring(reason))
    end
    self.sealedProgressHorizon=nil
end

function Bridge:sealProgressHorizon(capabilityGate,run,reason,nowMs)
    self:_clearSealed("REPLACED_BY_NEW_COMMITTED_TRANSITION_ADMISSION")
    if run==nil or run.progressVehicle==nil then return false,"PROGRESS_PARTICIPANT_UNAVAILABLE" end
    local progressPose=pose(run.progressVehicle)
    if progressPose==nil then return false,"PROGRESS_POSE_UNAVAILABLE" end
    local evidence=productiveEvidence(run)
    local track=progressTrack(capabilityGate,run)
    if evidence==nil or evidence.productivePositive~=true or tonumber(evidence.movingDirection)~=1 then
        return false,"POSITIVE_PRODUCTIVE_CONTINUATION_UNAVAILABLE_AT_ADMISSION"
    end
    if evidence.jobToken==nil or tostring(evidence.jobToken)~=tostring(run.progressStartJobToken) then
        return false,"PROGRESS_JOB_EVIDENCE_UNAVAILABLE_AT_ADMISSION"
    end
    if track==nil or tostring(track.sourceJobToken)~=tostring(run.progressStartJobToken) or track.localIntentValid~=true or track.localIntentClassification~="SETTLED_CONTINUATION" then
        return false,"POSITIVE_SETTLED_LOCAL_INTENT_BASIS_UNAVAILABLE_AT_ADMISSION"
    end
    local epoch=tonumber(track.localIntentEpoch)
    if epoch==nil then return false,"LOCAL_INTENT_EPOCH_UNAVAILABLE_AT_ADMISSION" end

    local boundary=fieldBoundary(capabilityGate,run,progressPose)
    local sealSource="LIVE_AT_ADMISSION"
    if boundary~=nil then
        self.sealedProgressHorizon={
            vehicle=run.progressVehicle,progressName=run.progressVehicleName,referenceKey=run.progressReferenceKey,jobToken=run.progressStartJobToken,
            intentEpoch=epoch,x=progressPose.x,z=progressPose.z,dx=progressPose.dx,dz=progressPose.dz,boundaryM=boundary,
            boundaryX=progressPose.x+progressPose.dx*boundary,boundaryZ=progressPose.z+progressPose.dz*boundary,
            sealedAt=nowMs or (g_time or 0),reason=reason or "COMMITTED_TRANSITION_ADMISSION",sealSource=sealSource
        }
    else
        local retained,retainedReason=self:_retainedForAdmission(capabilityGate,run,progressPose,evidence,track)
        if retained==nil then return false,"FIELD_BOUNDED_PROGRESS_HORIZON_UNAVAILABLE_AT_ADMISSION;"..tostring(retainedReason) end
        retained.sealedAt=nowMs or (g_time or 0)
        retained.reason=reason or "COMMITTED_TRANSITION_ADMISSION"
        self.sealedProgressHorizon=retained
        boundary=retained.boundaryM
        sealSource=retainedReason
    end
    local sealed=self.sealedProgressHorizon
    logInfo("HORIZON_SEALED progress=%s job=%s intentEpoch=%s boundary=%.2fm origin=(%.2f,%.2f) direction=(%.4f,%.4f) reason=%s sealSource=%s authority=SEALED_EVIDENCE_ONLY negativeClearanceAuthority=false",
        tostring(run.progressVehicleName),tostring(run.progressStartJobToken),tostring(epoch),boundary,sealed.x or progressPose.x,sealed.z or progressPose.z,sealed.dx or progressPose.dx,sealed.dz or progressPose.dz,tostring(reason or "COMMITTED_TRANSITION_ADMISSION"),tostring(sealSource))
    return true,"SEALED_"..tostring(sealSource)
end

function Bridge:reset(capabilityGate,reason)
    self.active=nil
    self:_clearSealed(reason or "RESET")
    self.retainedProgressHorizons={}
    self.lastStatus=nil; self.lastReason=nil; self.nextHeartbeatAt=0
end

function Bridge:_sample(capabilityGate,run)
    local progressPose=pose(run.progressVehicle)
    local yieldPose=pose(run.vehicle)
    if progressPose==nil or yieldPose==nil or run.targetX==nil or run.targetZ==nil then
        return {status="UNRESOLVED",reason="EGRESS_OR_PROGRESS_GEOMETRY_UNAVAILABLE"}
    end
    local progressSpan=select(1,capabilityGate:_representedSpan(run.progressVehicle))
    local yieldSpan=select(1,capabilityGate:_representedSpan(run.vehicle))
    if progressSpan==nil or yieldSpan==nil then return {status="UNRESOLVED",reason="POSITIVE_REPRESENTED_SPAN_UNAVAILABLE"} end

    local evidence=productiveEvidence(run)
    local track=progressTrack(capabilityGate,run)
    local currentBasis={
        jobToken=track and track.sourceJobToken or nil,intentEpoch=track and track.localIntentEpoch or nil,
        intentValid=track and track.localIntentValid==true or false,intentClassification=track and track.localIntentClassification or nil,
        productivePositive=evidence and evidence.productivePositive==true or false,movingDirection=evidence and tonumber(evidence.movingDirection) or nil,
        x=progressPose.x,z=progressPose.z
    }
    local sealedBoundary,sealedReason=Bridge.remainingSealedBoundary(self.sealedProgressHorizon,currentBasis)
    if self.sealedProgressHorizon~=nil and sealedBoundary==nil then self:_clearSealed(sealedReason) end
    local boundary=fieldBoundary(capabilityGate,run,progressPose)
    local boundarySource=boundary~=nil and "LIVE_FIELD_BOUNDED_PROGRESS_HORIZON" or nil
    if boundary==nil and sealedBoundary~=nil then
        boundary=sealedBoundary
        boundarySource=sealedReason
    end

    local combinedRadius=math.max(0,progressSpan*0.5)+math.max(0,yieldSpan*0.5)
    local entry=nil
    if OuttaMyWay.ProgressionGeometry~=nil and type(OuttaMyWay.ProgressionGeometry.rayCapsuleEntry)=="function" then
        entry=select(1,OuttaMyWay.ProgressionGeometry.rayCapsuleEntry(
            progressPose.x,progressPose.z,progressPose.dx,progressPose.dz,
            yieldPose.x,yieldPose.z,run.targetX,run.targetZ,combinedRadius))
    end

    local progressSpeedKmh=math.abs(tonumber(run.progressVehicle and run.progressVehicle.lastSpeedReal) or 0)*3600
    local progressSpeedMps=progressSpeedKmh/3.6
    local egressRemaining=distance(yieldPose.x,yieldPose.z,run.targetX,run.targetZ)
    local egressCeilingKmh=tonumber(run.speedKmh) or tonumber(OuttaMyWay.PROTOTYPE_22_TS015_REPOSITION_SPEED_KMH) or 0
    local sample={
        progressExpectedJobToken=run.progressStartJobToken,
        progressEvidenceJobToken=evidence and evidence.jobToken or nil,
        progressProductivePositive=evidence and evidence.productivePositive==true or false,
        progressMovingDirection=evidence and tonumber(evidence.movingDirection) or nil,
        progressEntryM=entry,progressBoundaryM=boundary,progressBoundarySource=boundarySource,progressBoundaryFallbackReason=sealedReason,progressSpeedMps=progressSpeedMps,
        egressRemainingM=egressRemaining,egressSpeedCeilingMps=egressCeilingKmh/3.6,
        progressSpeedKmh=progressSpeedKmh,egressCeilingKmh=egressCeilingKmh,
        progressSpanM=progressSpan,yieldSpanM=yieldSpan
    }
    local signal=Bridge.evaluateSignal(sample)
    for k,v in pairs(sample) do if signal[k]==nil then signal[k]=v end end
    return signal
end

function Bridge:update(capabilityGate,nowMs)
    if capabilityGate==nil then return end
    nowMs=nowMs or (g_time or 0)
    local run=capabilityGate.run
    if not egressContext(run) then
        if run==nil or run.kind~="TS015_RELOCATE" or run.phase~="TS015_SETTLING" then self:_clearSealed("COMMITTED_EGRESS_TRANSITION_COMPLETED_OR_INACTIVE") end
        self.active=nil; self.lastStatus="INACTIVE"; self.lastReason="NO_ACTIVE_COMMITTED_EGRESS_TRANSITION"
        return
    end
    local signal=self:_sample(capabilityGate,run)
    local changed=signal.status~=self.lastStatus or signal.reason~=self.lastReason
    self.lastStatus=signal.status; self.lastReason=signal.reason
    self.active=signal.status=="POSITIVE" and {shadow=true,progressName=run.progressVehicleName,runNumber=run.runNumber or run.identity or "TS015"} or nil
    if changed then
        logInfo("SHADOW_SIGNAL status=%s progress=%s yield=%s phase=%s reason=%s entry=%s progressEta=%s idealEgressCompletionLowerBound=%s fieldBoundSource=%s representationFitness=UNRESOLVED control=false authority=PASSIVE_SHADOW_ONLY",
            tostring(signal.status),tostring(run.progressVehicleName),tostring(run.vehicleName),tostring(run.phase),tostring(signal.reason),
            signal.progressEntryM and string.format("%.2fm",signal.progressEntryM) or "n/a",
            signal.progressEtaSec and string.format("%.3fs",signal.progressEtaSec) or "n/a",
            signal.idealEgressCompletionSec and string.format("%.3fs",signal.idealEgressCompletionSec) or "n/a",
            tostring(signal.progressBoundarySource or signal.progressBoundaryFallbackReason or "n/a"))
    end
    if nowMs>=(self.nextHeartbeatAt or 0) then
        self.nextHeartbeatAt=nowMs+(OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_HEARTBEAT_MS or 500)
        logInfo("SHADOW_SAMPLE progress=%s yield=%s phase=%s status=%s reason=%s actualSpeed=%.2fkmh entry=%s fieldBoundSource=%s control=false",
            tostring(run.progressVehicleName),tostring(run.vehicleName),tostring(run.phase),tostring(signal.status),tostring(signal.reason),signal.progressSpeedKmh or 0,
            signal.progressEntryM and string.format("%.2fm",signal.progressEntryM) or "n/a",tostring(signal.progressBoundarySource or signal.progressBoundaryFallbackReason or "n/a"))
    end
end

function Bridge:getStatus()
    return {active=false,shadowActive=self.active~=nil,lastStatus=self.lastStatus,lastReason=self.lastReason,applyCount=0,releaseCount=0,ownerTag="NONE",authority="PASSIVE_SHADOW_ONLY"}
end
