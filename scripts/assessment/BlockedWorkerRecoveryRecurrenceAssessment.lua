--- Correlates a fresh Blocked Progress Stall with the immediately preceding successful Recovery without retaining Recovery authority.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`, `BLOCKED_WORKER_RECOVERY`

OuttaMyWay.BlockedWorkerRecoveryRecurrenceAssessment={}
local Assessment=OuttaMyWay.BlockedWorkerRecoveryRecurrenceAssessment
Assessment.__index=Assessment

local RECOVERY_RECURRENCE_RADIUS_M=5.0
local RECOVERY_RECURRENCE_HORIZON_S=60.0

local publication=OuttaMyWay.LogPublication.origin("SITUATION_ASSESSMENT")

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function planarDistance(ax,az,bx,bz)
    if not finite(ax) or not finite(az) or not finite(bx) or not finite(bz) then return nil end
    local dx,dz=bx-ax,bz-az
    return math.sqrt(dx*dx+dz*dz)
end

function Assessment.new()
    return setmetatable({
        successfulRecoveryByAssembly={},
        correlatedCount=0,
        lastResult=nil,
        lastPublishedByAssembly={}
    },Assessment)
end

function Assessment:reset()
    self.successfulRecoveryByAssembly={}
    self.correlatedCount=0
    self.lastResult=nil
    self.lastPublishedByAssembly={}
end

function Assessment:recordSuccessfulRecovery(values)
    if type(values)~="table"
        or type(values.assemblyId)~="string"
        or type(values.successorJobEpisodeId)~="string"
        or type(values.successorSourceJobToken)~="string"
        or not finite(values.stallTimestamp)
        or not finite(values.stallX)
        or not finite(values.stallZ) then
        return false,"RECOVERY_RECURRENCE_SUCCESS_PROVENANCE_INCOMPLETE"
    end
    self.successfulRecoveryByAssembly[values.assemblyId]={
        assemblyId=values.assemblyId,
        recoveryKey=values.recoveryKey,
        stallTimestamp=values.stallTimestamp,
        stallX=values.stallX,
        stallZ=values.stallZ,
        successorJobEpisodeId=values.successorJobEpisodeId,
        successorSourceJobToken=values.successorSourceJobToken
    }
    return true,nil
end

function Assessment:assess(knowledge)
    local stall=knowledge and knowledge.stallEvidence or nil
    local assemblyId=knowledge and knowledge.assemblyId or nil
    if type(assemblyId)~="string" or knowledge.blockedProgressStall~=true or type(stall)~="table" then
        return {correlated=false,status="NOT_APPLICABLE",reason="FRESH_BLOCKED_PROGRESS_STALL_REQUIRED"}
    end

    local prior=self.successfulRecoveryByAssembly[assemblyId]
    if prior==nil then
        return {correlated=false,status="NO_PRECEDING_SUCCESSFUL_RECOVERY",reason="NO_PASSIVE_RECOVERY_CORRELATION_MEMORY"}
    end

    if knowledge.jobEpisodeId~=prior.successorJobEpisodeId
        or knowledge.sourceJobToken~=prior.successorSourceJobToken then
        self.successfulRecoveryByAssembly[assemblyId]=nil
        return {correlated=false,status="SUCCESSOR_LINEAGE_CHANGED",reason="CURRENT_JOB_EPISODE_IS_NOT_INTENDED_RECOVERY_SUCCESSOR"}
    end

    local timestamp=tonumber(stall.establishedAtTimestamp)
    local x,z=tonumber(stall.poseX),tonumber(stall.poseZ)
    if not finite(timestamp) or not finite(x) or not finite(z) then
        return {correlated=false,status="UNRESOLVED",reason="FRESH_STALL_CORRELATION_EVIDENCE_INCOMPLETE"}
    end

    local elapsed=timestamp-prior.stallTimestamp
    if not finite(elapsed) or elapsed<0 then
        return {correlated=false,status="UNRESOLVED",reason="STALL_TO_STALL_TIME_INVALID"}
    end
    if elapsed>RECOVERY_RECURRENCE_HORIZON_S then
        self.successfulRecoveryByAssembly[assemblyId]=nil
        return {
            correlated=false,status="OUTSIDE_CORRELATION_HORIZON",reason="STALL_TO_STALL_TIME_EXCEEDS_RECURRENCE_HORIZON",
            elapsedSeconds=elapsed,horizonSeconds=RECOVERY_RECURRENCE_HORIZON_S
        }
    end

    local separation=planarDistance(prior.stallX,prior.stallZ,x,z)
    if separation==nil then
        return {correlated=false,status="UNRESOLVED",reason="STALL_TO_STALL_DISTANCE_UNAVAILABLE"}
    end
    if separation>RECOVERY_RECURRENCE_RADIUS_M then
        return {
            correlated=false,status="OUTSIDE_CORRELATION_RADIUS",reason="STALL_TO_STALL_DISTANCE_EXCEEDS_RECURRENCE_RADIUS",
            separationM=separation,radiusM=RECOVERY_RECURRENCE_RADIUS_M,elapsedSeconds=elapsed
        }
    end

    local result={
        correlated=true,status="RECOVERY_STRATEGY_EXHAUSTED",reason="CORRELATED_RECOVERY_RECURRENCE",
        assemblyId=assemblyId,recoveryKey=prior.recoveryKey,
        priorStallTimestamp=prior.stallTimestamp,priorStallX=prior.stallX,priorStallZ=prior.stallZ,
        successorJobEpisodeId=prior.successorJobEpisodeId,successorSourceJobToken=prior.successorSourceJobToken,
        currentStallTimestamp=timestamp,currentStallX=x,currentStallZ=z,
        separationM=separation,radiusM=RECOVERY_RECURRENCE_RADIUS_M,
        elapsedSeconds=elapsed,horizonSeconds=RECOVERY_RECURRENCE_HORIZON_S,
        currentStallObservationSnapshotId=stall.establishedAtObservationSnapshotId
    }
    self.lastResult=result
    local publishKey=table.concat({
        tostring(assemblyId),tostring(prior.successorJobEpisodeId),
        tostring(stall.establishedAtObservationSnapshotId or timestamp)
    },"|")
    if self.lastPublishedByAssembly[assemblyId]~=publishKey then
        self.lastPublishedByAssembly[assemblyId]=publishKey
        self.correlatedCount=self.correlatedCount+1
        publication:warning(
            "NORMAL","BLOCKED_WORKER_RECOVERY_STRATEGY_EXHAUSTED",
            "assembly=%s successorJobEpisode=%s stallSeparation=%.2fm stallElapsed=%.2fs recoveryVeto=true playerInterventionMayBeRequired=true",
            tostring(assemblyId),tostring(prior.successorJobEpisodeId),separation,elapsed)
    end
    return result
end

function Assessment:getLastResult() return self.lastResult end
function Assessment:getCorrelatedCount() return self.correlatedCount end
