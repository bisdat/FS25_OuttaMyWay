-- FS25_OuttaMyWay v4.7.121 CANONICAL CANDIDATE — v4.7.120 external-egress mechanical expression retained; broader Terminal Yield policy is not yet implemented here.
-- D-0147 bounded post-job Control. It executes only a Candidate-supplied phase:
-- supported compaction OR one supplied Oblique Boundary Egress Exit Alignment. It
-- does not assess Terminal Occupancy, choose boundaries, search margins or retry.
-- v4.7.119 validated Vehicle Activity Context. v4.7.120 retires fixed-point pursuit:
-- Control holds one Candidate world Exit Alignment direction until Positive
-- Field-Exit Settlement proves the compact assembly is completely clear.

OuttaMyWay.TerminalEgressControl={}
local Control=OuttaMyWay.TerminalEgressControl
Control.__index=Control

local function logInfo(fmt,...)
    local msg=string.format(fmt,...); if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][D0147-CONTROL] %s",msg) else print("[FS25_OuttaMyWay][D0147-CONTROL] "..msg) end
end
local function logWarning(fmt,...)
    local msg=string.format(fmt,...); if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][D0147-CONTROL] %s",msg) else print("[FS25_OuttaMyWay][D0147-CONTROL][WARNING] "..msg) end
end
local function bridgeFor(candidate)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.terminalEgressBridge or nil
    if type(bridge)=="table" and bridge.architecture=="D0147" then return bridge end
    return nil
end
local function tokenFor(runtime,request)
    for _,token in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(request.commitmentId)) do
        if token.identity==request.authorityToken and token.assemblyId==request.assemblyId and token.authorityClass=="POST_JOB_ACTUATION" and runtime.authorities:validate(token)==true then return token end
    end
    return nil
end

local function numberText(value,format)
    if type(value)~="number" then return "nil" end
    return string.format(format or "%.6f",value)
end
local function steeringTelemetryText(telemetry)
    if type(telemetry)~="table" or telemetry.available==false then return "unavailable:"..tostring(telemetry and telemetry.reason) end
    local wheels={}
    for _,wheel in ipairs(telemetry.wheels or {}) do
        wheels[#wheels+1]=string.format("%s[a=%s,min=%s,max=%s,rs=%s,off=%s]",
            tostring(wheel.index),numberText(wheel.steeringAngle,"%.5f"),numberText(wheel.rotMin,"%.5f"),numberText(wheel.rotMax,"%.5f"),numberText(wheel.rotSpeed,"%.5f"),numberText(wheel.steeringOffset,"%.5f"))
    end
    return string.format("rotatedTime=%s minRotTime=%s maxRotTime=%s controlled=%s isActive=%s forceIsActive=%s crabState=%s crabAI=%s steerable=%s wheels={%s}",
        numberText(telemetry.rotatedTime,"%.6f"),numberText(telemetry.minRotTime,"%.6f"),numberText(telemetry.maxRotTime,"%.6f"),tostring(telemetry.controlled),tostring(telemetry.isActive),tostring(telemetry.forceIsActive),tostring(telemetry.crabState),tostring(telemetry.crabAiSteeringModeIndex),tostring(telemetry.steerableWheelCount),table.concat(wheels,";"))
end

local function finite(value) return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge end
local function pointInRing(x,z,ring)
    if type(ring)~="table" then return false end
    local ringLength=OuttaMyWay.ValueRecord.length(ring)
    if ringLength<3 then return false end
    local inside=false; local j=ringLength
    for i=1,ringLength do
        local a,b=ring[i],ring[j]
        if finite(a and a.x) and finite(a and a.z) and finite(b and b.x) and finite(b and b.z) then
            if ((a.z>z)~=(b.z>z)) then
                local crossX=(b.x-a.x)*(z-a.z)/(b.z-a.z)+a.x
                if x<crossX then inside=not inside end
            end
        end
        j=i
    end
    return inside
end
local function pointSegmentDistance(px,pz,a,b)
    local vx,vz=b.x-a.x,b.z-a.z; local denom=vx*vx+vz*vz
    local t=0
    if denom>0.0000001 then t=((px-a.x)*vx+(pz-a.z)*vz)/denom; t=math.max(0,math.min(1,t)) end
    local qx,qz=a.x+t*vx,a.z+t*vz; local dx,dz=px-qx,pz-qz
    return math.sqrt(dx*dx+dz*dz)
end
local function positiveRepresentedFieldExit(representation,boundary)
    if type(representation)~="table" or type(boundary)~="table" then
        return false,{kind="D0147_FIELD_EXIT_UNRESOLVED",reason="LIVE_REPRESENTATION_OR_OUTER_BOUNDARY_UNAVAILABLE"}
    end
    local boundaryLength=OuttaMyWay.ValueRecord.length(boundary)
    if boundaryLength<3 then
        return false,{kind="D0147_FIELD_EXIT_UNRESOLVED",reason="LIVE_REPRESENTATION_OR_OUTER_BOUNDARY_UNAVAILABLE"}
    end
    local worldPrimitives=representation.worldPrimitives or {}
    local count=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(worldPrimitives) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) then count=count+1 end
    end
    if count==0 then return false,{kind="D0147_FIELD_EXIT_UNRESOLVED",reason="POSITIVE_TERMINAL_FOOTPRINT_UNAVAILABLE"} end

    -- A represented-footprint AABB wholly beyond the Field World AABB is a
    -- sufficient positive exit witness and avoids depending on a second live
    -- fold-state qualification after COMPACTION_COMPLETE already established
    -- the compact configuration for this Commitment.
    local fieldMinX,fieldMaxX,fieldMinZ,fieldMaxZ=nil,nil,nil,nil
    for _,point in OuttaMyWay.ValueRecord.ipairs(boundary) do
        if finite(point and point.x) and finite(point and point.z) then
            fieldMinX=fieldMinX==nil and point.x or math.min(fieldMinX,point.x); fieldMaxX=fieldMaxX==nil and point.x or math.max(fieldMaxX,point.x)
            fieldMinZ=fieldMinZ==nil and point.z or math.min(fieldMinZ,point.z); fieldMaxZ=fieldMaxZ==nil and point.z or math.max(fieldMaxZ,point.z)
        end
    end
    local bounds=representation.planViewSummary and representation.planViewSummary.bounds or nil
    if bounds and finite(bounds.minX) and finite(bounds.maxX) and finite(bounds.minZ) and finite(bounds.maxZ) and fieldMinX~=nil then
        if bounds.maxX<fieldMinX or bounds.minX>fieldMaxX or bounds.maxZ<fieldMinZ or bounds.minZ>fieldMaxZ then
            return true,{kind="D0147_POSITIVE_REPRESENTED_FIELD_EXIT",witness="DISJOINT_FIELD_WORLD_AABB",primitiveCount=count,representedBounds=bounds,fieldBounds={minX=fieldMinX,maxX=fieldMaxX,minZ=fieldMinZ,maxZ=fieldMaxZ}}
        end
    end

    local minClearance=nil
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(worldPrimitives) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) then
            if pointInRing(primitive.x,primitive.z,boundary) then
                return false,{kind="D0147_FIELD_EXIT_UNRESOLVED",reason="REPRESENTED_PRIMITIVE_CENTRE_INSIDE_FIELD",primitiveId=primitive.identity,primitiveCount=count}
            end
            local distance=nil
            for i=1,boundaryLength do
                local a,b=boundary[i],boundary[(i % boundaryLength)+1]
                if finite(a and a.x) and finite(a and a.z) and finite(b and b.x) and finite(b and b.z) then
                    local d=pointSegmentDistance(primitive.x,primitive.z,a,b)
                    if distance==nil or d<distance then distance=d end
                end
            end
            if distance==nil then return false,{kind="D0147_FIELD_EXIT_UNRESOLVED",reason="OUTER_BOUNDARY_DISTANCE_UNAVAILABLE",primitiveId=primitive.identity} end
            local clearance=distance-primitive.radius
            if minClearance==nil or clearance<minClearance then minClearance=clearance end
            if clearance<=0 then
                return false,{kind="D0147_FIELD_EXIT_UNRESOLVED",reason="REPRESENTED_PRIMITIVE_INTERSECTS_FIELD_WORLD",primitiveId=primitive.identity,clearanceM=clearance,primitiveCount=count}
            end
        end
    end
    return true,{kind="D0147_POSITIVE_REPRESENTED_FIELD_EXIT",witness="ALL_POSITIVE_DISC_PRIMITIVES_OUTSIDE_POLYGON",primitiveCount=count,minBoundaryClearanceM=minClearance}
end

function Control.new(runtime,observationSource)
    return setmetatable({runtime=runtime,source=observationSource,postJobAuthority=OuttaMyWay.PostJobActuationAuthority.new(),configurationAuthority=OuttaMyWay.Prototype22ConfigurationAuthority.new(),active=nil,completionHandler=nil,latestObservation=nil,startedCount=0,completedCount=0,failedCount=0},Control)
end
function Control:setCompletionHandler(handler) self.completionHandler=handler end
function Control:isActive() return self.active~=nil end
function Control:_vehicle(referenceKey) return self.source and self.source:getTrackedObject(referenceKey) or nil end
function Control:_publish(state,extra)
    local item={kind="D0147_TERMINAL_EGRESS_CONTROL_OBSERVATION",terminalEpisodeId=state and state.terminalEpisodeId or (extra and extra.terminalEpisodeId),assemblyReferenceKey=state and state.assemblyReferenceKey or (extra and extra.assemblyReferenceKey),commitmentId=state and state.commitmentId or (extra and extra.commitmentId),phase=state and state.phase or (extra and extra.phase),active=self.active~=nil,directDriveCalls=self.postJobAuthority:getDirectDriveCallCount(),provenance={source="TerminalEgressControl",authority="POST_JOB_ACTUATION"}}
    for k,v in OuttaMyWay.ValueRecord.pairs(extra or {}) do item[k]=v end
    self.latestObservation=item
end
function Control:getControlExecutionObservation() return self.latestObservation end
function Control:_complete(status,evidence)
    local state=self.active
    if state==nil then return end
    local completionEvidence={}
    for k,v in OuttaMyWay.ValueRecord.pairs(evidence or {}) do completionEvidence[k]=v end

    -- A post-job curvature/drive command can leave propulsion physically latched
    -- after this controller stops issuing updates. Whenever OuttaMyWay still owns
    -- the physical assembly, positively neutralise before releasing the D-0147
    -- control path. Player Claim and source reactivation outrank OuttaMyWay, so
    -- no post-claim/post-reactivation actuation is permitted.
    local vehicle=state.vehicle or self:_vehicle(state.assemblyReferenceKey)
    if state.phase=="EGRESS" and state.actuationIssued==true then
        if status=="PLAYER_CLAIM" then
            completionEvidence.neutralization={performed=false,reason="PLAYER_CLAIM_HIGHER_AUTHORITY"}
        elseif status=="SUPERSEDED" then
            completionEvidence.neutralization={performed=false,reason="SOURCE_INTENT_REACTIVATED_HIGHER_AUTHORITY"}
        elseif vehicle==nil then
            completionEvidence.neutralization={performed=false,reason="COMPLETED_ASSEMBLY_RUNTIME_OBJECT_LOST"}
            logWarning("ACTUATION_NEUTRALIZATION_UNAVAILABLE commitment=%s episode=%s reason=%s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),"COMPLETED_ASSEMBLY_RUNTIME_OBJECT_LOST")
        else
            local neutralized,neutralEvidence=self.postJobAuthority:neutralize(vehicle,state.lastDt or 0)
            completionEvidence.neutralization={performed=neutralized==true,evidence=type(neutralEvidence)=="table" and neutralEvidence or nil,reason=neutralized and nil or tostring(neutralEvidence)}
            if neutralized then
                logInfo("ACTUATION_NEUTRALIZED commitment=%s episode=%s status=%s neutralizeCalls=%d %s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(status),self.postJobAuthority:getNeutralizeCallCount(),steeringTelemetryText(type(neutralEvidence)=="table" and neutralEvidence.postNeutralizeSteering or nil))
            else
                logWarning("ACTUATION_NEUTRALIZATION_FAILED commitment=%s episode=%s status=%s reason=%s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(status),tostring(neutralEvidence))
            end
        end
    end

    -- Activity is context, not productive intent. Always relinquish the temporary
    -- forceIsActive assertion when D-0147 leaves EGRESS, including Player Claim and
    -- source reactivation. On owned exits the actuation neutralisation above occurs
    -- first while GIANTS wheel physics is still active.
    if state.phase=="EGRESS" and state.activityContext~=nil then
        if vehicle==nil then
            completionEvidence.activityContext={released=false,reason="COMPLETED_ASSEMBLY_RUNTIME_OBJECT_LOST"}
            logWarning("VEHICLE_ACTIVITY_CONTEXT_RELEASE_UNAVAILABLE commitment=%s episode=%s reason=%s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),"COMPLETED_ASSEMBLY_RUNTIME_OBJECT_LOST")
        else
            local released,releaseEvidence=self.postJobAuthority:releaseVehicleActivityContext(vehicle,state.activityContext)
            completionEvidence.activityContext={released=released==true,evidence=type(releaseEvidence)=="table" and releaseEvidence or nil,reason=released and nil or tostring(releaseEvidence)}
            if released then
                logInfo("VEHICLE_ACTIVITY_CONTEXT_RELEASED commitment=%s episode=%s status=%s releaseCalls=%d restoredForceIsActive=%s %s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(status),self.postJobAuthority:getActivityContextReleaseCallCount(),tostring(releaseEvidence.restoredForceIsActive),steeringTelemetryText(type(releaseEvidence)=="table" and releaseEvidence.postReleaseSteering or nil))
            else
                logWarning("VEHICLE_ACTIVITY_CONTEXT_RELEASE_FAILED commitment=%s episode=%s status=%s reason=%s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(status),tostring(releaseEvidence))
            end
        end
    end

    self.active=nil
    local observation={status=status}
    if status=="COMPACTION_COMPLETE" then observation.compactionComplete=true
    elseif status=="MANOEUVRE_COMPLETE" then observation.manoeuvreCompleted=true
    elseif status=="PLAYER_CLAIM" then observation.playerClaimed=true
    elseif status=="FAILED" then observation.exhausted=true
    elseif status=="SUPERSEDED" then observation.sourceIntentReactivated=true end
    for k,v in OuttaMyWay.ValueRecord.pairs(completionEvidence) do observation[k]=v end
    self:_publish(state,observation)
    if status=="FAILED" then self.failedCount=self.failedCount+1 else self.completedCount=self.completedCount+1 end
    if type(self.completionHandler)=="function" then self.completionHandler({status=status,commitmentId=state.commitmentId,terminalEpisodeId=state.terminalEpisodeId,assemblyId=state.assemblyId,assemblyReferenceKey=state.assemblyReferenceKey,evidence=completionEvidence}) end
end
function Control:_rejectBeforeStart(request,bridge,status,reason)
    local pseudo={commitmentId=request.commitmentId,terminalEpisodeId=bridge.terminalEpisodeId,assemblyId=request.assemblyId,assemblyReferenceKey=bridge.assemblyReferenceKey,phase=bridge.phase}
    self.active=pseudo; self:_complete(status,{kind="D0147_CONTROL_START_REJECTED",reason=reason})
    return false,reason
end
function Control:executeControlRequest(request,candidate)
    OuttaMyWay.ValueRecord.assertType(request,"ControlRequest")
    local bridge=bridgeFor(candidate); if bridge==nil then return false,"D0147_BRIDGE_UNAVAILABLE" end
    if self.active~=nil then return false,"D0147_CONTROL_ALREADY_ACTIVE" end
    if tokenFor(self.runtime,request)==nil then return false,"D0147_VALID_POST_JOB_AUTHORITY_TOKEN_UNAVAILABLE" end
    local vehicle=self:_vehicle(bridge.assemblyReferenceKey); if vehicle==nil then return self:_rejectBeforeStart(request,bridge,"FAILED","COMPLETED_ASSEMBLY_RUNTIME_OBJECT_UNAVAILABLE") end
    if self.postJobAuthority:isPlayerClaimed(vehicle) then return self:_rejectBeforeStart(request,bridge,"PLAYER_CLAIM","PLAYER_CLAIM_AT_CONTROL_BOUNDARY") end
    if self.postJobAuthority:isSourceReactivated(vehicle) then return self:_rejectBeforeStart(request,bridge,"SUPERSEDED","SOURCE_INTENT_REACTIVATED_AT_CONTROL_BOUNDARY") end
    local now=tonumber(g_time) or 0
    local state={commitmentId=request.commitmentId,terminalEpisodeId=bridge.terminalEpisodeId,assemblyId=request.assemblyId,assemblyReferenceKey=bridge.assemblyReferenceKey,phase=bridge.phase,requestId=request.identity,authorityToken=request.authorityToken,startedAt=now,vehicle=vehicle,objective=bridge.objective,configurationOwned=false}
    self.active=state; self.startedCount=self.startedCount+1
    if bridge.phase=="COMPACT" then
        local evidence=self.configurationAuthority:getEvidence(vehicle)
        if evidence.foldableCount==0 or evidence.allFolded==true then
            logInfo("COMPACTION_RETAIN_CURRENT episode=%s assembly=%s foldable=%d",tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey),tonumber(evidence.foldableCount) or 0)
            self:_complete("COMPACTION_COMPLETE",{kind="D0147_SUPPORTED_COMPACTION",mode="RETAIN_CURRENT",configurationEvidence=evidence})
            return true,"COMPACTION_RETAIN_CURRENT"
        end
        if evidence.transitionCount>0 and evidence.unknownCount==0 then
            state.waitingExistingCompaction=true
            self:_publish(state,{status="COMPACTION_IN_PROGRESS",existingMotion=true})
            return true,"COMPACTION_ALREADY_IN_PROGRESS"
        end
        if not evidence.allDeployed or evidence.unknownCount>0 then
            return self:_rejectBeforeStart(request,bridge,"FAILED","SUPPORTED_COMPACTION_UNAVAILABLE")
        end
        local ok,result=self.configurationAuthority:prepareCompact(vehicle)
        if not ok then return self:_rejectBeforeStart(request,bridge,"FAILED","COMPACTION_COMMAND_REJECTED:"..tostring(result)) end
        state.configurationOwned=true
        self:_publish(state,{status="COMPACTION_IN_PROGRESS",existingMotion=false})
        logInfo("COMPACTION_STARTED commitment=%s episode=%s assembly=%s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey))
        return true,"COMPACTION_STARTED"
    elseif bridge.phase=="EGRESS" then
        local objective=bridge.objective
        if type(objective)~="table" or not tonumber(objective.exitDirectionX) or not tonumber(objective.exitDirectionZ) then
            return self:_rejectBeforeStart(request,bridge,"FAILED","OBLIQUE_EGRESS_OBJECTIVE_UNSUPPORTED:"..tostring(bridge.objectiveReason))
        end
        local position=self.postJobAuthority:position(vehicle); if position==nil then return self:_rejectBeforeStart(request,bridge,"FAILED","POST_JOB_POSE_UNAVAILABLE") end
        local activityOk,activityContext=self.postJobAuthority:acquireVehicleActivityContext(vehicle)
        if not activityOk then
            local status=activityContext=="PLAYER_CLAIM" and "PLAYER_CLAIM" or (activityContext=="SOURCE_INTENT_REACTIVATED" and "SUPERSEDED" or "FAILED")
            return self:_rejectBeforeStart(request,bridge,status,"VEHICLE_ACTIVITY_CONTEXT_UNAVAILABLE:"..tostring(activityContext))
        end
        state.activityContext=activityContext
        logInfo("VEHICLE_ACTIVITY_CONTEXT_ACQUIRED commitment=%s episode=%s assembly=%s acquireCalls=%d previousForceIsActive=%s %s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey),self.postJobAuthority:getActivityContextAcquireCallCount(),tostring(activityContext.previousForceIsActive),steeringTelemetryText(activityContext.postAcquireSteering))
        state.exitDirectionX=objective.exitDirectionX; state.exitDirectionZ=objective.exitDirectionZ; state.speedKmh=OuttaMyWay.TERMINAL_EGRESS_SPEED_KMH; state.outerBoundary=objective.outerBoundary
        self:_publish(state,{status="MANOEUVRE_IN_PROGRESS",exitDirectionX=state.exitDirectionX,exitDirectionZ=state.exitDirectionZ,settlement="POSITIVE_FIELD_EXIT_ONLY"})
        logInfo("MANOEUVRE_STARTED commitment=%s episode=%s assembly=%s exitDirection=(%.4f,%.4f) speed=%.2fkmh objective=%s alignment=%s referenceSegment=%s crossingSegment=%s headingOutwardDot=%.3f exitOutwardDot=%.3f settlement=POSITIVE_FIELD_EXIT_ONLY",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey),tonumber(state.exitDirectionX) or 0,tonumber(state.exitDirectionZ) or 0,tonumber(state.speedKmh) or 0,tostring(objective.objectiveKind),tostring(objective.alignmentMode),tostring(objective.referenceSegmentIndex),tostring(objective.segmentIndex),tonumber(objective.headingOutwardDot) or 0,tonumber(objective.exitOutwardDot) or 0)
        logInfo("STEERING_BASELINE commitment=%s episode=%s assembly=%s %s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey),steeringTelemetryText(self.postJobAuthority:steeringTelemetry(vehicle)))
        return true,"MANOEUVRE_STARTED"
    end
    return self:_rejectBeforeStart(request,bridge,"FAILED","UNSUPPORTED_D0147_PHASE:"..tostring(bridge.phase))
end
function Control:update(dt)
    local state=self.active; if state==nil then return end
    state.lastDt=dt
    if tokenFor(self.runtime,state)==nil then self:_complete("FAILED",{kind="D0147_TERMINAL_EGRESS_EXHAUSTION",reason="POST_JOB_AUTHORITY_LOST"}); return end
    local vehicle=self:_vehicle(state.assemblyReferenceKey); if vehicle==nil then self:_complete("FAILED",{kind="D0147_TERMINAL_EGRESS_EXHAUSTION",reason="COMPLETED_ASSEMBLY_RUNTIME_OBJECT_LOST"}); return end
    if self.postJobAuthority:isPlayerClaimed(vehicle) then self:_complete("PLAYER_CLAIM",{kind="D0147_PLAYER_CLAIM",directDriveCallsAtClaim=self.postJobAuthority:getDirectDriveCallCount()}); return end
    if self.postJobAuthority:isSourceReactivated(vehicle) then self:_complete("SUPERSEDED",{kind="D0147_SOURCE_INTENT_REACTIVATED"}); return end
    local elapsed=(tonumber(g_time) or 0)-state.startedAt
    if state.phase=="COMPACT" then
        local evidence=self.configurationAuthority:getEvidence(vehicle)
        if evidence.allFolded==true then
            if state.configurationOwned then self.configurationAuthority:clear(vehicle) end
            self:_complete("COMPACTION_COMPLETE",{kind="D0147_SUPPORTED_COMPACTION",mode="COMPACTED",configurationEvidence=evidence})
            return
        end
        if elapsed>(tonumber(OuttaMyWay.TERMINAL_EGRESS_COMPACTION_TIMEOUT_MS) or 25000) then
            if state.configurationOwned then self.configurationAuthority:clear(vehicle) end
            self:_complete("FAILED",{kind="D0147_TERMINAL_EGRESS_EXHAUSTION",reason="COMPACTION_WATCHDOG_EXPIRED",configurationEvidence=evidence}); return
        end
        self:_publish(state,{status="COMPACTION_IN_PROGRESS",configurationEvidence=evidence})
        return
    end
    if state.phase=="EGRESS" then
        if state.actuationIssued==true then
            local now=tonumber(g_time) or 0
            if state.nextUpdateTelemetryLogged~=true then
                state.nextUpdateTelemetryLogged=true
                logInfo("STEERING_NEXT_UPDATE commitment=%s episode=%s assembly=%s %s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey),steeringTelemetryText(self.postJobAuthority:steeringTelemetry(vehicle)))
            elseif state.lastSteeringHeartbeatAt==nil or now-state.lastSteeringHeartbeatAt>=1000 then
                state.lastSteeringHeartbeatAt=now
                logInfo("STEERING_HEARTBEAT commitment=%s episode=%s assembly=%s %s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey),steeringTelemetryText(self.postJobAuthority:steeringTelemetry(vehicle)))
            end
        end
        local representation=self.source and type(self.source.getTrackedRepresentation)=="function" and self.source:getTrackedRepresentation(state.assemblyReferenceKey) or nil
        local fieldExitPositive,fieldExitEvidence=positiveRepresentedFieldExit(representation,state.outerBoundary)
        if fieldExitPositive then
            self:_complete("MANOEUVRE_COMPLETE",{kind="D0147_OBLIQUE_BOUNDARY_EGRESS_COMPLETE",fieldExitEvidence=fieldExitEvidence,directDriveCalls=self.postJobAuthority:getDirectDriveCallCount()}); return
        end
        local position=self.postJobAuthority:position(vehicle); if position==nil then self:_complete("FAILED",{kind="D0147_TERMINAL_EGRESS_EXHAUSTION",reason="POST_JOB_POSE_LOST"}); return end
        if elapsed>(tonumber(OuttaMyWay.TERMINAL_EGRESS_MOVE_TIMEOUT_MS) or 45000) then
            self:_complete("FAILED",{kind="D0147_TERMINAL_EGRESS_EXHAUSTION",reason="ONE_MANOEUVRE_WATCHDOG_EXPIRED",fieldExitEvidence=fieldExitEvidence}); return
        end
        local ok,result=self.postJobAuthority:driveInWorldDirection(vehicle,dt,state.exitDirectionX,state.exitDirectionZ,state.speedKmh)
        if not ok then
            if result=="PLAYER_CLAIM" then self:_complete("PLAYER_CLAIM",{kind="D0147_PLAYER_CLAIM",directDriveCallsAtClaim=self.postJobAuthority:getDirectDriveCallCount()})
            elseif result=="SOURCE_INTENT_REACTIVATED" then self:_complete("SUPERSEDED",{kind="D0147_SOURCE_INTENT_REACTIVATED"})
            else self:_complete("FAILED",{kind="D0147_TERMINAL_EGRESS_EXHAUSTION",reason=tostring(result)}) end
            return
        end
        state.actuationIssued=true
        if state.directionEvidenceLogged~=true and type(result)=="table" then
            state.directionEvidenceLogged=true
            state.lastSteeringHeartbeatAt=tonumber(g_time) or 0
            logInfo("EXIT_ALIGNMENT_ACTUATION commitment=%s episode=%s assembly=%s localDirection=(%.4f,%.4f) headingErrorDeg=%.2f steeringAngleLimitDeg=%.2f",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey),tonumber(result.localDirectionX) or 0,tonumber(result.localDirectionZ) or 0,tonumber(result.headingErrorDeg) or 0,tonumber(result.steeringAngleLimitDeg) or 0)
            logInfo("STEERING_COMMAND_STATE commitment=%s episode=%s assembly=%s %s",tostring(state.commitmentId),tostring(state.terminalEpisodeId),tostring(state.assemblyReferenceKey),steeringTelemetryText(result.postCommandSteering))
        end
        self:_publish(state,{status="MANOEUVRE_IN_PROGRESS",exitDirectionX=state.exitDirectionX,exitDirectionZ=state.exitDirectionZ,fieldExitEvidence=fieldExitEvidence,directDriveCalls=self.postJobAuthority:getDirectDriveCallCount(),directionEvidence=result})
    end
end
function Control:loadMap() self.active=nil; self.latestObservation=nil; self.configurationAuthority:clearAll() end
function Control:deleteMap() self.active=nil; self.latestObservation=nil; self.configurationAuthority:clearAll() end
function Control:keyEvent() end
function Control:mouseEvent() end
function Control:draw() end
function Control:getStatus() return {active=self.active~=nil,phase=self.active and self.active.phase or nil,terminalEpisodeId=self.active and self.active.terminalEpisodeId or nil,startedCount=self.startedCount,completedCount=self.completedCount,failedCount=self.failedCount,directDriveCalls=self.postJobAuthority:getDirectDriveCallCount(),neutralizeCalls=self.postJobAuthority:getNeutralizeCallCount(),activityContextAcquireCalls=self.postJobAuthority:getActivityContextAcquireCallCount(),activityContextReleaseCalls=self.postJobAuthority:getActivityContextReleaseCallCount()} end
