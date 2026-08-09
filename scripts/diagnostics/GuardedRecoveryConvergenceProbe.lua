-- FS25_OuttaMyWay v4.7.47 Guarded-Recovery Convergence representation + shadow diagnostics.
--
-- The live probe instance remains diagnostic/read-only and compares parallel
-- hypotheses. Its pure `evaluateCurrentHeadingSignal` representation is also
-- consumed by the bounded v4.7.47 recovery-admission/active-recovery test path.
-- This module itself never alters vehicle state and does not confer production
-- Refuge, Decision, Commitment-settlement or general Control authority.

OuttaMyWay.GuardedRecoveryConvergenceProbe = {}
local Probe = OuttaMyWay.GuardedRecoveryConvergenceProbe
Probe.__index = Probe

local function logInfo(formatText, ...)
    local message = string.format(formatText, ...)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][D0123-SHADOW] %s", message)
    else
        print("[FS25_OuttaMyWay][D0123-SHADOW] " .. message)
    end
end

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end

local function pose(vehicle)
    if vehicle == nil then return nil end
    local node = nil
    local ok, value = safeCall(vehicle, "getAISteeringNode")
    if ok and value ~= nil and value ~= 0 then node = value end
    node = node or vehicle.rootNode
    if node == nil or node == 0 or type(getWorldTranslation) ~= "function" or type(localDirectionToWorld) ~= "function" then return nil end
    local okPos, x, y, z = pcall(getWorldTranslation, node)
    local okDir, dx, _, dz = pcall(localDirectionToWorld, node, 0, 0, 1)
    if not okPos or not okDir then return nil end
    local length = math.sqrt(dx * dx + dz * dz)
    if length <= 0.0001 then return nil end
    return {node=node,x=x,y=y,z=z,dx=dx/length,dz=dz/length}
end

local function actualSpeedKmh(vehicle)
    return math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0) * 3600
end

local function cross(ax, az, bx, bz)
    return ax * bz - az * bx
end

local function pointDistance(px, pz, qx, qz)
    local dx, dz = px - qx, pz - qz
    return math.sqrt(dx * dx + dz * dz)
end

local function pointToSegmentDistance(px, pz, ax, az, bx, bz)
    local abx, abz = bx - ax, bz - az
    local denom = abx * abx + abz * abz
    if denom <= 1e-9 then return pointDistance(px, pz, ax, az) end
    local t = ((px - ax) * abx + (pz - az) * abz) / denom
    t = math.max(0, math.min(1, t))
    return pointDistance(px, pz, ax + abx * t, az + abz * t)
end

local function pointToRayDistance(px, pz, rx, rz, dx, dz)
    local projection = (px - rx) * dx + (pz - rz) * dz
    if projection <= 0 then return pointDistance(px, pz, rx, rz) end
    return pointDistance(px, pz, rx + dx * projection, rz + dz * projection)
end

local function raySegmentIntersects(rx, rz, dx, dz, ax, az, bx, bz)
    local sx, sz = bx - ax, bz - az
    local denominator = cross(dx, dz, sx, sz)
    if math.abs(denominator) <= 1e-9 then return false end
    local arx, arz = ax - rx, az - rz
    local t = cross(arx, arz, sx, sz) / denominator
    local u = cross(arx, arz, dx, dz) / denominator
    return t >= 0 and u >= 0 and u <= 1
end

local function raySegmentDistance(rx, rz, dx, dz, ax, az, bx, bz)
    if raySegmentIntersects(rx, rz, dx, dz, ax, az, bx, bz) then return 0 end
    return math.min(
        pointToRayDistance(ax, az, rx, rz, dx, dz),
        pointToRayDistance(bx, bz, rx, rz, dx, dz),
        pointToSegmentDistance(rx, rz, ax, az, bx, bz)
    )
end

local function directionFromTravel(previousPose, currentPose)
    if previousPose == nil or currentPose == nil then return nil end
    local dx, dz = currentPose.x - previousPose.x, currentPose.z - previousPose.z
    local length = math.sqrt(dx * dx + dz * dz)
    -- Numeric stability only; this carries no speed/policy authority.
    if length <= 0.01 then return nil end
    return {dx=dx/length,dz=dz/length,distance=length}
end

local function recoveryPhase(phase)
    return phase == "TS015_REJOIN_ORIENTING"
        or phase == "TS015_REJOINING"
        or phase == "TS015_REJOIN_SETTLING"
        or phase == "TS015_REJOIN_RESTORING"
end

local function roleEvidenceRecord(referenceKey)
    local source = OuttaMyWay.productiveContinuationProbe
    if source == nil or type(source.getEvidence) ~= "function" then return nil end
    return source:getEvidence(referenceKey)
end

local function roleEvidence(referenceKey)
    local evidence = roleEvidenceRecord(referenceKey)
    return evidence and tostring(evidence.evidenceClass or "UNRESOLVED") or "UNAVAILABLE"
end

local function vulnerableHypotheses(context, recoveryPose, currentRadius)
    local target={x=context.rejoinTargetX,z=context.rejoinTargetZ}
    local anchor={x=context.rejoinAnchorX,z=context.rejoinAnchorZ}
    local deployedRadius=math.max(currentRadius or 0, (context.recoveryInitialSpanM or context.initialSpanM or 0) * 0.5)
    return {
        CURRENT_TO_REJOIN={
            id="VS_CURRENT_TO_REJOIN",
            segments={{ax=recoveryPose.x,az=recoveryPose.z,bx=target.x,bz=target.z,radius=currentRadius}},
            basis="CURRENT_RECOVERY_POSE_TO_KNOWN_REJOIN_TARGET_CURRENT_REALIZED_SPAN"
        },
        CURRENT_TO_ANCHOR={
            id="VS_CURRENT_TO_ANCHOR",
            segments={{ax=recoveryPose.x,az=recoveryPose.z,bx=anchor.x,bz=anchor.z,radius=currentRadius}},
            basis="CURRENT_RECOVERY_POSE_TO_RETAINED_REJOIN_ANCHOR_CURRENT_REALIZED_SPAN"
        },
        COMMITTED_RECOVERY_UNION={
            id="VS_COMMITTED_RECOVERY_UNION",
            segments={
                {ax=recoveryPose.x,az=recoveryPose.z,bx=target.x,bz=target.z,radius=currentRadius},
                {ax=target.x,az=target.z,bx=anchor.x,bz=anchor.z,radius=deployedRadius}
            },
            basis="KNOWN_REMAINING_P22_RECOVERY_LEGS_WITH_CURRENT_AND_PRE_INTERVENTION_REALIZED_SPAN"
        }
    }
end

local function rayAgainstVulnerable(ray, vulnerable, progressRadius)
    if ray == nil then return {resolved=false,positive=false,clearance=nil} end
    local minimumClearance=math.huge
    for _,segment in ipairs(vulnerable.segments or {}) do
        local distance=raySegmentDistance(ray.x,ray.z,ray.dx,ray.dz,segment.ax,segment.az,segment.bx,segment.bz)
        local clearance=distance - ((segment.radius or 0) + (progressRadius or 0))
        minimumClearance=math.min(minimumClearance,clearance)
    end
    return {resolved=minimumClearance<math.huge,positive=minimumClearance<=0,clearance=minimumClearance}
end

function Probe.evaluateGeometry(input)
    local recovery=input and input.recoveryPose or nil
    local progress=input and input.progressPose or nil
    if recovery==nil or progress==nil or input.rejoinTargetX==nil or input.rejoinTargetZ==nil or input.rejoinAnchorX==nil or input.rejoinAnchorZ==nil then
        return {resolved=false,reason="GEOMETRY_INPUT_INCOMPLETE"}
    end
    if input.recoveryCurrentSpanM==nil or input.progressSpanM==nil then
        return {resolved=false,reason="POSITIVE_REPRESENTED_SPAN_UNAVAILABLE"}
    end
    local currentRadius=math.max(0,tonumber(input.recoveryCurrentSpanM) * 0.5)
    local progressRadius=math.max(0,tonumber(input.progressSpanM) * 0.5)
    local vulnerable=vulnerableHypotheses(input,recovery,currentRadius)
    local travel=directionFromTravel(input.previousProgressPose,progress)
    local rays={
        HEADING={id="CP_CURRENT_HEADING",x=progress.x,z=progress.z,dx=progress.dx,dz=progress.dz,basis="CURRENT_REVEALED_HEADING"},
        TRAVEL=travel and {id="CP_OBSERVED_TRAVEL",x=progress.x,z=progress.z,dx=travel.dx,dz=travel.dz,basis="OBSERVED_DISPLACEMENT_DIRECTION"} or nil,
        PREVIOUS_HEADING=input.previousProgressPose and {id="CP_PREVIOUS_HEADING",x=progress.x,z=progress.z,dx=input.previousProgressPose.dx,dz=input.previousProgressPose.dz,basis="PREVIOUSLY_REVEALED_HEADING"} or nil
    }
    local projections={
        CURRENT_HEADING={id="CP_CURRENT_HEADING",rays={rays.HEADING}},
        OBSERVED_TRAVEL={id="CP_OBSERVED_TRAVEL",rays={rays.TRAVEL}},
        REVEALED_TURN_SWEEP={id="CP_REVEALED_TURN_SWEEP",rays={rays.PREVIOUS_HEADING,rays.HEADING}}
    }
    local combinations={}
    for vulnerableKey,v in pairs(vulnerable) do
        for projectionKey,p in pairs(projections) do
            local resolved=false
            local positive=false
            local clearance=math.huge
            for _,ray in ipairs(p.rays or {}) do
                local result=rayAgainstVulnerable(ray,v,progressRadius)
                if result.resolved then
                    resolved=true
                    positive=positive or result.positive
                    clearance=math.min(clearance,result.clearance or math.huge)
                end
            end
            local key=vulnerableKey.."__"..projectionKey
            combinations[key]={
                vulnerableId=v.id,projectionId=p.id,resolved=resolved,positive=positive,
                clearance=resolved and clearance or nil,vulnerableBasis=v.basis
            }
        end
    end
    return {
        resolved=true,
        recoveryRadius=currentRadius,
        progressRadius=progressRadius,
        travel=travel,
        combinations=combinations
    }
end


local function positiveContinuingEvidence(classification)
    return classification == "NON_TURN_LINE_ACTIVE" or classification == "TURN_SEGMENT"
end

function Probe.evaluateCurrentHeadingSignal(sample)
    if type(sample) ~= "table" then
        return {status="UNRESOLVED", reason="NO_RECOVERY_SAMPLE"}
    end
    if sample.geometryResolved ~= true or type(sample.combinations) ~= "table" then
        return {status="UNRESOLVED", reason=tostring(sample.geometryReason or "GEOMETRY_UNRESOLVED")}
    end
    local combination = sample.combinations.COMMITTED_RECOVERY_UNION__CURRENT_HEADING
    if type(combination) ~= "table" or combination.resolved ~= true then
        return {status="UNRESOLVED", reason="D0123_COMBINATION_UNRESOLVED"}
    end
    local expectedJob = sample.progressExpectedJobToken
    local evidenceJob = sample.progressEvidenceJobToken
    if expectedJob ~= nil and evidenceJob ~= nil and tostring(expectedJob) ~= tostring(evidenceJob) then
        return {status="INVALIDATED", reason="PROGRESS_JOB_EPISODE_CHANGED", combination=combination}
    end
    if expectedJob == nil or evidenceJob == nil then
        return {status="UNRESOLVED", reason="PROGRESS_JOB_EVIDENCE_UNAVAILABLE", combination=combination}
    end
    if sample.progressMovingDirection ~= 1 then
        return {status="UNRESOLVED", reason=sample.progressMovingDirection == -1 and "REVERSE_REVEALED_DIRECTION_NOT_REPRESENTED_BY_CURRENT_HEADING_TEST" or "CURRENT_NATIVE_MOVEMENT_DIRECTION_UNRESOLVED", combination=combination}
    end
    if not positiveContinuingEvidence(sample.progressEvidenceClass) then
        return {status="UNRESOLVED", reason="POSITIVE_CONTINUING_NATIVE_INTENT_UNRESOLVED", combination=combination}
    end
    if combination.positive == true then
        return {status="POSITIVE", reason="REVEALED_NATIVE_CONTINUATION_INTERSECTS_VULNERABLE_SPACE", combination=combination}
    end
    return {status="NEGATIVE", reason="POSITIVE_CURRENT_HEADING_CLEAR_OF_VULNERABLE_SPACE", combination=combination}
end

function Probe.new()
    return setmetatable({
        active=nil,nextSampleAt=0,nextHeartbeatAt=0,lastCombinationState={},previousProgressPose=nil,latestSample=nil,
        runCount=0,sampleCount=0
    },Probe)
end

function Probe:reset()
    self.active=nil; self.nextSampleAt=0; self.nextHeartbeatAt=0; self.lastCombinationState={}; self.previousProgressPose=nil; self.latestSample=nil
    self.runCount=0; self.sampleCount=0
end

function Probe:_close(nowMs, reason, firstNativeAt)
    if self.active==nil then return end
    logInfo("WINDOW_CLOSE run=%d yield=%s progress=%s elapsedMs=%d reason=%s positiveGiantsReacquisition=%s decisionAuthority=false controlAuthority=false",
        self.active.runNumber,tostring(self.active.yieldName),tostring(self.active.progressName),nowMs-(self.active.openedAt or nowMs),
        tostring(reason),tostring(firstNativeAt~=nil))
    self.active=nil; self.previousProgressPose=nil; self.lastCombinationState={}; self.latestSample=nil; self.nextSampleAt=0; self.nextHeartbeatAt=0
end

function Probe:_open(run, nowMs)
    if run.rejoinTargetX==nil or run.rejoinTargetZ==nil or run.rejoinAnchorX==nil or run.rejoinAnchorZ==nil then return false end
    self.runCount=self.runCount+1
    self.active={
        runNumber=self.runCount,openedAt=nowMs,yieldVehicle=run.vehicle,yieldName=run.vehicleName,yieldReferenceKey=run.referenceKey,
        progressVehicle=run.progressVehicle,progressName=run.progressVehicleName,progressReferenceKey=run.progressReferenceKey,
        rejoinTargetX=run.rejoinTargetX,rejoinTargetZ=run.rejoinTargetZ,rejoinAnchorX=run.rejoinAnchorX,rejoinAnchorZ=run.rejoinAnchorZ,
        initialSpanM=run.initialSpanM,yieldJobToken=run.startJobToken,progressJobToken=run.progressStartJobToken
    }
    self.previousProgressPose=nil; self.lastCombinationState={}; self.latestSample=nil; self.nextSampleAt=0; self.nextHeartbeatAt=0
    logInfo("WINDOW_OPEN run=%d yield=%s yieldRef=%s progress=%s progressRef=%s phase=%s rejoinTarget=(%.2f,%.2f) rejoinAnchor=(%.2f,%.2f) initialSpan=%s architecture=D-0123 mode=PARALLEL_SHADOW_HYPOTHESES decisionAuthority=false controlAuthority=false",
        self.active.runNumber,tostring(run.vehicleName),tostring(run.referenceKey),tostring(run.progressVehicleName),tostring(run.progressReferenceKey),
        tostring(run.phase),run.rejoinTargetX,run.rejoinTargetZ,run.rejoinAnchorX,run.rejoinAnchorZ,
        run.initialSpanM and string.format("%.2fm",run.initialSpanM) or "n/a")
    return true
end

function Probe:update(capabilityGate, nowMs)
    if OuttaMyWay.GUARDED_RECOVERY_CONVERGENCE_PROBE_ENABLED~=true or capabilityGate==nil then return end
    local run=capabilityGate.run
    local monitor=capabilityGate.releasedMonitor

    if self.active==nil then
        if run~=nil and run.kind=="TS015_RELOCATE" and recoveryPhase(run.phase) then self:_open(run,nowMs) end
        return
    end

    if monitor~=nil and monitor.kind=="TS015_RELOCATE" and monitor.firstNativeAt~=nil then
        self:_close(nowMs,"POSITIVE_GIANTS_REACQUISITION_OBSERVED",monitor.firstNativeAt)
        return
    end
    if run==nil and monitor==nil then
        self:_close(nowMs,"RECOVERY_CONTEXT_ENDED_WITHOUT_REACQUISITION",nil)
        return
    end

    if nowMs < (self.nextSampleAt or 0) then return end
    self.nextSampleAt=nowMs+(OuttaMyWay.GUARDED_RECOVERY_CONVERGENCE_PROBE_INTERVAL_MS or 100)

    local active=self.active
    local recoveryPose=pose(active.yieldVehicle)
    local progressPose=pose(active.progressVehicle)
    local recoverySpan=select(1,capabilityGate:_representedSpan(active.yieldVehicle))
    local progressSpan=select(1,capabilityGate:_representedSpan(active.progressVehicle))
    local currentPhase=run and run.phase or "POST_HANDOFF_PRE_REACQUISITION"
    local geometry=Probe.evaluateGeometry({
        recoveryPose=recoveryPose,progressPose=progressPose,previousProgressPose=self.previousProgressPose,
        recoveryCurrentSpanM=recoverySpan,recoveryInitialSpanM=active.initialSpanM,progressSpanM=progressSpan,
        rejoinTargetX=active.rejoinTargetX,rejoinTargetZ=active.rejoinTargetZ,rejoinAnchorX=active.rejoinAnchorX,rejoinAnchorZ=active.rejoinAnchorZ
    })
    local progressEvidence=roleEvidenceRecord(active.progressReferenceKey)
    self.latestSample={
        atMs=nowMs,runNumber=active.runNumber,phase=currentPhase,
        yieldVehicle=active.yieldVehicle,yieldName=active.yieldName,yieldReferenceKey=active.yieldReferenceKey,
        progressVehicle=active.progressVehicle,progressName=active.progressName,progressReferenceKey=active.progressReferenceKey,
        progressExpectedJobToken=active.progressJobToken,
        progressEvidenceJobToken=progressEvidence and progressEvidence.jobToken or nil,
        progressEvidenceClass=progressEvidence and tostring(progressEvidence.evidenceClass or "UNRESOLVED") or "UNAVAILABLE",
        progressMovingDirection=progressEvidence and tonumber(progressEvidence.movingDirection) or nil,
        geometryResolved=geometry.resolved==true,geometryReason=geometry.reason,combinations=geometry.combinations,
        recoverySpanM=recoverySpan,progressSpanM=progressSpan
    }
    self.sampleCount=self.sampleCount+1

    if geometry.resolved then
        local anyPositive=false
        local stateParts={}
        local keys={}; for key in pairs(geometry.combinations or {}) do keys[#keys+1]=key end; table.sort(keys)
        for _,key in ipairs(keys) do
            local result=geometry.combinations[key]
            anyPositive=anyPositive or result.positive
            stateParts[#stateParts+1]=string.format("%s=%s/%s",key,result.resolved and (result.positive and "POS" or "NEG") or "UNRESOLVED",result.clearance and string.format("%.2fm",result.clearance) or "n/a")
            local previous=self.lastCombinationState[key]
            local state=result.resolved and (result.positive and "POSITIVE" or "NEGATIVE") or "UNRESOLVED"
            if previous~=state then
                self.lastCombinationState[key]=state
                logInfo("INTERSECTION_CHANGE run=%d phase=%s hypothesis=%s vulnerable=%s projection=%s state=%s clearance=%s observeExhaustionShadow=%s decisionAuthority=false controlAuthority=false",
                    active.runNumber,tostring(currentPhase),key,tostring(result.vulnerableId),tostring(result.projectionId),state,
                    result.clearance and string.format("%.2fm",result.clearance) or "n/a",tostring(result.positive==true))
            end
        end
        local due=nowMs>=(self.nextHeartbeatAt or 0)
        if due then
            self.nextHeartbeatAt=nowMs+(OuttaMyWay.GUARDED_RECOVERY_CONVERGENCE_PROBE_HEARTBEAT_MS or 500)
            logInfo("SAMPLE run=%d elapsedMs=%d phase=%s yield=%s yieldPos=(%s,%s) yieldSpan=%s progress=%s progressPos=(%s,%s) progressSpeed=%.2f progressEvidence=%s progressHeading=(%s,%s) observedTravel=(%s,%s) progressSpan=%s anyPositive=%s hypotheses={%s} fixedHorizon=false tcpa=false dcpa=false decisionAuthority=false controlAuthority=false",
                active.runNumber,nowMs-(active.openedAt or nowMs),tostring(currentPhase),tostring(active.yieldName),
                recoveryPose and string.format("%.2f",recoveryPose.x) or "n/a",recoveryPose and string.format("%.2f",recoveryPose.z) or "n/a",
                recoverySpan and string.format("%.2fm",recoverySpan) or "n/a",tostring(active.progressName),
                progressPose and string.format("%.2f",progressPose.x) or "n/a",progressPose and string.format("%.2f",progressPose.z) or "n/a",
                actualSpeedKmh(active.progressVehicle),roleEvidence(active.progressReferenceKey),
                progressPose and string.format("%.4f",progressPose.dx) or "n/a",progressPose and string.format("%.4f",progressPose.dz) or "n/a",
                geometry.travel and string.format("%.4f",geometry.travel.dx) or "n/a",geometry.travel and string.format("%.4f",geometry.travel.dz) or "n/a",
                progressSpan and string.format("%.2fm",progressSpan) or "n/a",tostring(anyPositive),table.concat(stateParts,","))
        end
    else
        if nowMs>=(self.nextHeartbeatAt or 0) then
            self.nextHeartbeatAt=nowMs+(OuttaMyWay.GUARDED_RECOVERY_CONVERGENCE_PROBE_HEARTBEAT_MS or 500)
            logInfo("SAMPLE run=%d phase=%s result=UNRESOLVED reason=%s decisionAuthority=false controlAuthority=false",active.runNumber,tostring(currentPhase),tostring(geometry.reason))
        end
    end

    if progressPose~=nil then
        self.previousProgressPose={x=progressPose.x,z=progressPose.z,dx=progressPose.dx,dz=progressPose.dz}
    end
end

function Probe:getLatestSample()
    return self.latestSample
end

function Probe:getStatus()
    return {active=self.active~=nil,runCount=self.runCount,sampleCount=self.sampleCount}
end
