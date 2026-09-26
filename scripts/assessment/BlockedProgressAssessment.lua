--- Interprets current native motion and blockage evidence into Blocked Progress Stall and Recovery Anchor Situation meaning.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

-- This module retains only bounded, purpose-specific Recovery Approach witnesses.
-- It does not create Recovery Candidates, Current Responsibility, Bounded Authority
-- or Control, and it does not retain productive routing/history.

OuttaMyWay.BlockedProgressAssessment={}
local Assessment=OuttaMyWay.BlockedProgressAssessment
Assessment.__index=Assessment

local TRAIL_CAPACITY_COUNT=40
local COLLAPSE_MIN_OBSERVATION_SECONDS=1.0
local TRAIL_MIN_USEFUL_SPAN_M=5.0

local publication=OuttaMyWay.LogPublication.origin("SITUATION_ASSESSMENT")

local function invalidationPayload(track,reason)
    return {
        operation=track.operationId,
        assembly=track.assemblyId,
        jobEpisode=track.jobEpisodeId,
        reason=reason
    }
end

local function clearedPayload(track,reason)
    return {
        operation=track.operationId,
        assembly=track.assemblyId,
        jobEpisode=track.jobEpisodeId,
        reason=reason
    }
end

local function stallPayload(track,anchor)
    return {
        operation=track.operationId,
        assembly=track.assemblyId,
        jobEpisode=track.jobEpisodeId,
        collapseSeconds=track.collapseObservedSeconds,
        trailWitnesses=#track.trail,
        anchorAvailable=anchor~=nil,
        anchorSpanM=anchor and anchor.usefulSpanM or nil
    }
end

local function anchorPayload(track,anchor)
    return {
        operation=track.operationId,
        assembly=track.assemblyId,
        jobEpisode=track.jobEpisodeId,
        anchorObservation=anchor.observationSnapshotId,
        spanM=anchor.usefulSpanM,
        polarity=anchor.travelPolarity
    }
end

local function stallEvidencePayload(track,context,anchor)
    return {
        operation=track.operationId,
        assembly=track.assemblyId,
        jobEpisode=track.jobEpisodeId,
        blockedObservation=track.blockedAssertion and track.blockedAssertion.observationSnapshotId or nil,
        stallObservation=context.observationSnapshotId,
        collapseSeconds=track.collapseObservedSeconds,
        trailWitnesses=#track.trail,
        trailCapacity=TRAIL_CAPACITY_COUNT,
        anchorSpanM=anchor and anchor.usefulSpanM or nil
    }
end

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function distance(ax,az,bx,bz)
    if not finite(ax) or not finite(az) or not finite(bx) or not finite(bz) then return nil end
    local dx,dz=bx-ax,bz-az
    return math.sqrt(dx*dx+dz*dz)
end

local function copyWitness(value)
    if value==nil then return nil end
    return {
        observationSnapshotId=value.observationSnapshotId,
        timestamp=value.timestamp,
        poseX=value.poseX,poseZ=value.poseZ,
        travelDirectionX=value.travelDirectionX,travelDirectionZ=value.travelDirectionZ,
        travelPolarity=value.travelPolarity,
        motionClassification=value.motionClassification,
        configurationProfileId=value.configurationProfileId,
        sourceJobToken=value.sourceJobToken,
        usefulSpanM=value.usefulSpanM,
        minimumUsefulSpanM=value.minimumUsefulSpanM
    }
end

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if type(item.assemblyId)=="string" then result[item.assemblyId]=item end
    end
    return result
end

local function activeEpisodeByAssembly(jobEpisodes)
    local result={}
    for _,episode in OuttaMyWay.ValueRecord.ipairs(jobEpisodes and jobEpisodes:list() or {}) do
        if episode.status=="ACTIVE" and type(episode.assemblyId)=="string" then result[episode.assemblyId]=episode end
    end
    return result
end

local function movementOwnerForAssembly(commitmentContext,assemblyId)
    for _,context in OuttaMyWay.ValueRecord.ipairs(commitmentContext or {}) do
        for _,ownership in OuttaMyWay.ValueRecord.ipairs(context.progressActuationOwnership or {}) do
            if ownership.assemblyId==assemblyId then return context.commitmentId or context.identity end
        end
    end
    return nil
end

local function realizedSpeed(motion)
    local speed=motion and tonumber(motion.positionDerivedSpeedMps) or nil
    if not finite(speed) or speed<0 then return nil end
    return speed
end

local function positiveRealizedMovement(motion)
    if realizedSpeed(motion)==nil then return false end
    return motion.motionClassification=="STABLE_FORWARD"
        or motion.motionClassification=="TURNING"
        or motion.motionClassification=="REVERSING_OR_OPPOSED_TRAVEL"
end

local function collapsedRealizedMovement(motion)
    return realizedSpeed(motion)~=nil and motion.motionClassification=="STATIONARY"
end

local function travelPolarity(motion)
    if motion==nil then return nil end
    if motion.motionClassification=="REVERSING_OR_OPPOSED_TRAVEL" then return "REVERSE" end
    local alignment=tonumber(motion.headingToTravelDot)
    if finite(alignment) and alignment< -0.5 then return "REVERSE" end
    if motion.motionClassification=="STABLE_FORWARD" or motion.motionClassification=="TURNING" then return "FORWARD" end
    return nil
end

local function positiveProgressWitness(motion,configurationProfileId,observationSnapshotId,timestamp)
    local polarity=travelPolarity(motion)
    if not positiveRealizedMovement(motion) or polarity==nil then return nil end
    if not finite(motion.poseX) or not finite(motion.poseZ)
        or not finite(motion.travelDirectionX) or not finite(motion.travelDirectionZ) then return nil end
    if type(configurationProfileId)~="string" then return nil end
    return {
        observationSnapshotId=observationSnapshotId,timestamp=timestamp,
        poseX=motion.poseX,poseZ=motion.poseZ,
        travelDirectionX=motion.travelDirectionX,travelDirectionZ=motion.travelDirectionZ,
        travelPolarity=polarity,motionClassification=motion.motionClassification,
        configurationProfileId=configurationProfileId,sourceJobToken=motion.sourceJobToken
    }
end

local function appendWitness(track,witness)
    while #track.trail>=TRAIL_CAPACITY_COUNT do table.remove(track.trail,1) end
    track.trail[#track.trail+1]=witness
    track.configurationProfileId=witness.configurationProfileId
    track.travelPolarity=witness.travelPolarity
end

local function trailSummary(track)
    local first=track.trail[1]
    local last=track.trail[#track.trail]
    return {
        witnessCount=#track.trail,
        capacityCount=TRAIL_CAPACITY_COUNT,
        oldestObservationSnapshotId=first and first.observationSnapshotId or nil,
        newestObservationSnapshotId=last and last.observationSnapshotId or nil,
        oldestTimestamp=first and first.timestamp or nil,
        newestTimestamp=last and last.timestamp or nil,
        retainedObservationSeconds=(first and last and finite(first.timestamp) and finite(last.timestamp))
            and math.max(0,last.timestamp-first.timestamp) or nil
    }
end

local function selectAnchor(track,stallPoseX,stallPoseZ)
    local span=0
    local previousX,previousZ=stallPoseX,stallPoseZ
    for index=#track.trail,1,-1 do
        local witness=track.trail[index]
        if witness.configurationProfileId~=track.configurationProfileId
            or witness.travelPolarity~=track.travelPolarity then
            return nil
        end
        local segment=distance(witness.poseX,witness.poseZ,previousX,previousZ)
        if segment==nil then return nil end
        span=span+segment
        previousX,previousZ=witness.poseX,witness.poseZ
    end
    if span<TRAIL_MIN_USEFUL_SPAN_M then return nil end
    local first=track.trail[1]
    if first==nil then return nil end
    local anchor=copyWitness(first)
    anchor.usefulSpanM=span
    anchor.minimumUsefulSpanM=TRAIL_MIN_USEFUL_SPAN_M
    return anchor
end

local function trackKnowledge(track)
    if track==nil or #track.trail==0 then return nil end
    local status="RECOVERY_APPROACH_TRAIL_ACTIVE"
    local reason="POSITIVELY_REALISED_NATIVE_PROGRESS_RETAINED"
    if track.stall~=nil then
        status="BLOCKED_PROGRESS_STALL"
        reason=track.recoveryAnchor~=nil
            and "BLOCKED_PROGRESS_CONTRADICTION_WITH_RECOVERY_ANCHOR"
            or "BLOCKED_PROGRESS_CONTRADICTION_WITHOUT_USEFUL_RECOVERY_ANCHOR"
    elseif track.blockedAssertion~=nil then
        status="BLOCKED_ASSERTION_WITNESSED"
        reason="BLOCKED_ASSERTION_AWAITING_SUFFICIENT_COLLAPSE_OBSERVATION"
    end
    return {
        assemblyId=track.assemblyId,
        assemblyReferenceKey=track.assemblyReferenceKey,
        jobEpisodeId=track.jobEpisodeId,
        sourceJobToken=track.sourceJobToken,
        operationId=track.operationId,
        status=status,
        blockedProgressStall=track.stall~=nil,
        reason=reason,
        recoveryApproachTrail=trailSummary(track),
        blockedAssertion=track.blockedAssertion and {
            observationSnapshotId=track.blockedAssertion.observationSnapshotId,
            timestamp=track.blockedAssertion.timestamp,
            poseX=track.blockedAssertion.poseX,poseZ=track.blockedAssertion.poseZ
        } or nil,
        collapseObservation=track.blockedAssertion and {
            observedSeconds=track.collapseObservedSeconds,
            requiredSeconds=COLLAPSE_MIN_OBSERVATION_SECONDS,
            sufficient=track.collapseObservedSeconds>=COLLAPSE_MIN_OBSERVATION_SECONDS
        } or nil,
        stallEvidence=track.stall and {
            establishedAtObservationSnapshotId=track.stall.observationSnapshotId,
            establishedAtTimestamp=track.stall.timestamp,
            poseX=track.stall.poseX,poseZ=track.stall.poseZ,
            collapseObservedSeconds=track.stall.collapseObservedSeconds
        } or nil,
        recoveryAnchor=copyWitness(track.recoveryAnchor),
        provenance={
            source="BlockedProgressAssessment",
            layer="KNOWLEDGE",
            authority="BLOCKED_PROGRESS_SITUATION_ONLY",
            negativeClearanceAuthority=false
        }
    }
end

local function shouldNarrateInvalidation(track)
    return track~=nil and (track.blockedAssertion~=nil or track.stall~=nil)
end

function Assessment.new(jobEpisodes)
    return setmetatable({jobEpisodes=jobEpisodes,tracks={}},Assessment)
end

function Assessment:reset()
    self.tracks={}
end

function Assessment:_invalidate(assemblyId,reason)
    local track=self.tracks[assemblyId]
    if shouldNarrateInvalidation(track) then
        publication:publish("DEBUG","INFO","RECOVERY_APPROACH_INVALIDATED",invalidationPayload,track,reason)
    end
    self.tracks[assemblyId]=nil
end

function Assessment:_newTrack(assemblyId,motion,episode,operationId,witness)
    local track={
        assemblyId=assemblyId,
        assemblyReferenceKey=motion.assemblyReferenceKey,
        jobEpisodeId=episode.identity,
        sourceJobToken=episode.sourceJobToken,
        operationId=operationId,
        configurationProfileId=witness.configurationProfileId,
        travelPolarity=witness.travelPolarity,
        trail={},
        blockedAssertion=nil,
        collapseObservedSeconds=0,
        stall=nil,
        recoveryAnchor=nil
    }
    appendWitness(track,witness)
    self.tracks[assemblyId]=track
    return track
end

function Assessment:_clearBlockedMeaning(track,reason)
    if track.stall~=nil then
        publication:publish("DEBUG","INFO","BLOCKED_PROGRESS_STALL_CLEARED",clearedPayload,track,reason)
    end
    track.blockedAssertion=nil
    track.collapseObservedSeconds=0
    track.stall=nil
    track.recoveryAnchor=nil
end

function Assessment:_establishStall(track,motion,context)
    local anchor=selectAnchor(track,motion.poseX,motion.poseZ)
    track.recoveryAnchor=anchor
    track.stall={
        observationSnapshotId=context.observationSnapshotId,
        timestamp=context.timestamp,
        poseX=motion.poseX,poseZ=motion.poseZ,
        collapseObservedSeconds=track.collapseObservedSeconds
    }
    publication:publish("DEBUG","INFO","BLOCKED_PROGRESS_STALL_ESTABLISHED",stallPayload,track,anchor)
    if anchor~=nil then
        publication:publish("DEBUG","INFO","RECOVERY_ANCHOR_SELECTED",anchorPayload,track,anchor)
    end
    publication:publish("DIAGNOSTIC","INFO","BLOCKED_PROGRESS_STALL_EVIDENCE",stallEvidencePayload,track,context,anchor)
end

function Assessment:assess(context)
    context=context or {}
    local motionByAssembly=byAssembly(context.motionEvidence)
    local physicalByAssembly=byAssembly(context.physicalSpaceEvidence)
    local episodes=activeEpisodeByAssembly(self.jobEpisodes)
    local currentMembers={}
    local result={}

    for assemblyId,operationId in OuttaMyWay.ValueRecord.pairs(context.operationByAssembly or {}) do
        currentMembers[assemblyId]=true
        local episode=episodes[assemblyId]
        local motion=motionByAssembly[assemblyId]
        local physical=physicalByAssembly[assemblyId]
        local track=self.tracks[assemblyId]

        if episode==nil then
            if track~=nil then self:_invalidate(assemblyId,"ACTIVE_JOB_EPISODE_UNAVAILABLE") end
        elseif motion==nil then
            if track~=nil and track.blockedAssertion~=nil and track.stall==nil then track.collapseObservedSeconds=0 end
        elseif episode.sourceJobToken~=motion.sourceJobToken then
            if track~=nil then self:_invalidate(assemblyId,"JOB_EPISODE_SOURCE_TOKEN_CHANGED") end
        else
            if track~=nil and track.jobEpisodeId~=episode.identity then
                self:_invalidate(assemblyId,"JOB_EPISODE_CHANGED")
                track=nil
            end

            local movementOwner=movementOwnerForAssembly(context.commitmentContext,assemblyId)
            if movementOwner~=nil then
                if track~=nil then self:_invalidate(assemblyId,"OUTTAMYWAY_PROGRESS_ACTUATION_OWNED") end
                track=nil
            else
                local configurationProfileId=physical and physical.configurationProfileId or nil
                if track~=nil and type(configurationProfileId)=="string"
                    and configurationProfileId~=track.configurationProfileId then
                    self:_invalidate(assemblyId,"CONFIGURATION_PROFILE_CHANGED")
                    track=nil
                end

                if type(configurationProfileId)~="string" then
                    if track~=nil and track.blockedAssertion~=nil and track.stall==nil then track.collapseObservedSeconds=0 end
                else
                    local realizedMovement=positiveRealizedMovement(motion)
                    local witness=positiveProgressWitness(
                        motion,configurationProfileId,context.observationSnapshotId,context.timestamp)

                    if realizedMovement then
                        if track~=nil then self:_clearBlockedMeaning(track,"POSITIVE_NATIVE_PROGRESSION_RESUMED") end
                        if witness~=nil then
                            if track~=nil and track.travelPolarity~=witness.travelPolarity then
                                self:_invalidate(assemblyId,"NATIVE_TRAVEL_DIRECTION_REVERSED")
                                track=nil
                            end
                            if track==nil then
                                track=self:_newTrack(assemblyId,motion,episode,operationId,witness)
                            else
                                track.operationId=operationId
                                track.assemblyReferenceKey=motion.assemblyReferenceKey
                                appendWitness(track,witness)
                            end
                        end
                    end

                    local assertedThisCycle=false
                    if motion.blocked==true and track~=nil and #track.trail>0 and track.blockedAssertion==nil then
                        track.blockedAssertion={
                            observationSnapshotId=context.observationSnapshotId,
                            timestamp=context.timestamp,
                            poseX=motion.poseX,poseZ=motion.poseZ
                        }
                        track.collapseObservedSeconds=0
                        assertedThisCycle=true
                    end

                    if track~=nil and track.blockedAssertion~=nil and track.stall==nil and not realizedMovement then
                        local interval=tonumber(motion.sampleIntervalSeconds)
                        if not assertedThisCycle and collapsedRealizedMovement(motion)
                            and finite(interval) and interval>0 then
                            track.collapseObservedSeconds=track.collapseObservedSeconds+interval
                        elseif not assertedThisCycle then
                            track.collapseObservedSeconds=0
                        end
                        if track.collapseObservedSeconds>=COLLAPSE_MIN_OBSERVATION_SECONDS then
                            self:_establishStall(track,motion,context)
                        end
                    end
                end
            end
        end

        track=self.tracks[assemblyId]
        local knowledge=trackKnowledge(track)
        if knowledge~=nil then result[#result+1]=knowledge end
    end

    local retired={}
    for assemblyId,_ in next,self.tracks do
        if currentMembers[assemblyId]~=true then retired[#retired+1]=assemblyId end
    end
    table.sort(retired)
    for _,assemblyId in ipairs(retired) do self:_invalidate(assemblyId,"OPERATION_MEMBERSHIP_ENDED") end

    table.sort(result,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    return result
end

return Assessment
