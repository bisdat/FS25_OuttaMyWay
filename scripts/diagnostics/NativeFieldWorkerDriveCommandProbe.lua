-- FS25_OuttaMyWay v4.7.67 TEST BUILD.
-- D-0138 passive GIANTS Native Field-Worker Drive Command shadow probe.
--
-- Exact FS25 1.21.1.0 SDK evidence shows AIFieldWorker:updateAIFieldWorker()
-- obtains tX/tZ/moveForwards/maxSpeed/distanceToStop from native drive
-- strategies, applies GIANTS speed constraints, then writes the immediate command
-- into spec_aiFieldWorker.aiDriveParams before converting its world target into
-- steering/reverser-node local space for AIVehicleUtil.driveToPoint.
--
-- D-0137 is falsified: vehicle.aiDriveDirection={0,1} and aiDriveTarget={0,0}
-- are initialization/default fields in AIDriveStrategyFieldCourse, not the native
-- field-worker command surface. They are deliberately not observed here.
--
-- This probe reads only the already-populated aiDriveParams table. It never calls
-- getDriveData(), wraps driveToPoint, selects a Refuge, predicts a route/Future
-- Space, or actuates Regulation/Hold/Reposition/Control.

OuttaMyWay.NativeFieldWorkerDriveCommandProbe={}
local Probe=OuttaMyWay.NativeFieldWorkerDriveCommandProbe
Probe.__index=Probe

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][NATIVE-FIELD-DRIVE-COMMAND] %s",message)
    else
        print("[FS25_OuttaMyWay][NATIVE-FIELD-DRIVE-COMMAND] "..message)
    end
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function referenceKey(vehicle)
    return "vehicle-root:"..tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function nameOf(vehicle)
    local ok,value=safeCall(vehicle,"getName")
    if ok and value~=nil and value~="" then return tostring(value) end
    return tostring(vehicle and (vehicle.name or vehicle.typeName or vehicle.rootNode) or "AI vehicle")
end

local function currentJobToken(vehicle)
    local job=OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
    return OuttaMyWay.LiveAIJobEvidence.jobToken(job)
end

local function ntext(value,precision)
    if not finite(value) then return "n/a" end
    return string.format("%."..tostring(precision or 2).."f",value)
end

function Probe.candidateRelation(command,candidateX,candidateZ)
    if type(command)~="table" or command.valid~=true or not finite(command.targetX) or not finite(command.targetZ) then
        return {status="UNRESOLVED",reason="NATIVE_FIELD_WORKER_COMMAND_TARGET_UNAVAILABLE",authority="DESCRIPTIVE_ONLY"}
    end
    if not finite(candidateX) or not finite(candidateZ) then
        return {status="UNRESOLVED",reason="CANDIDATE_POSITION_UNAVAILABLE",authority="DESCRIPTIVE_ONLY"}
    end
    local dx,dz=candidateX-command.targetX,candidateZ-command.targetZ
    return {
        status="DESCRIBED",
        targetDistanceM=math.sqrt(dx*dx+dz*dz),
        targetDeltaX=dx,targetDeltaZ=dz,
        authority="DESCRIPTIVE_ONLY",routePrediction=false,negativeClearanceAuthority=false
    }
end

function Probe.new(runtime,productiveProbe)
    return setmetatable({runtime=runtime,productiveProbe=productiveProbe,elapsed=0,lastHeartbeatAt={},lastSignature={},latest={}},Probe)
end

function Probe:reset()
    self.elapsed=0; self.lastHeartbeatAt={}; self.lastSignature={}; self.latest={}
end

function Probe:loadMap()
    self:reset()
    logInfo("active=true mode=PASSIVE_SHADOW_ONLY surface=spec_aiFieldWorker.aiDriveParams sdkPath=AIFieldWorker.updateAIFieldWorker observerCallsGetDriveData=false wrapsDriveToPoint=false routePrediction=false futureSpaceAuthority=false refugeSelectionAuthority=false decisionAuthority=false speedAuthority=false controlAuthority=false")
end
function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end

function Probe:_track(ref)
    local source=self.runtime and self.runtime.liveObservationSource or nil
    return source and source.tracks and source.tracks[ref] or nil
end

function Probe:sampleVehicle(vehicle)
    local ref=referenceKey(vehicle)
    local spec=vehicle and vehicle.spec_aiFieldWorker or nil
    local params=spec and spec.aiDriveParams or nil
    local valid=params~=nil and params.valid==true
    local targetX=params and tonumber(params.tX) or nil
    local targetY=params and tonumber(params.tY) or nil
    local targetZ=params and tonumber(params.tZ) or nil
    local maxSpeed=params and tonumber(params.maxSpeed) or nil
    local moveForwards=nil
    if params~=nil then moveForwards=params.moveForwards end
    if not finite(targetX) then targetX=nil end
    if not finite(targetY) then targetY=nil end
    if not finite(targetZ) then targetZ=nil end
    if not finite(maxSpeed) then maxSpeed=nil end

    local track=self:_track(ref)
    local evidence=self.productiveProbe and self.productiveProbe:getEvidence(ref,currentJobToken(vehicle)) or nil
    local pose=track and track.pose or nil
    local motion=track and track.motionDiagnostic or nil
    local offsetX,offsetZ,targetDistance,targetHeadingDot,targetTravelDot=nil,nil,nil,nil,nil
    if valid and targetX~=nil and targetZ~=nil and pose~=nil and finite(pose.x) and finite(pose.z) then
        offsetX=targetX-pose.x; offsetZ=targetZ-pose.z
        targetDistance=math.sqrt(offsetX*offsetX+offsetZ*offsetZ)
        if targetDistance>0.000001 then
            local ux,uz=offsetX/targetDistance,offsetZ/targetDistance
            if finite(pose.dx) and finite(pose.dz) then targetHeadingDot=ux*pose.dx+uz*pose.dz end
            if motion~=nil and finite(motion.travelDirectionX) and finite(motion.travelDirectionZ) then
                targetTravelDot=ux*motion.travelDirectionX+uz*motion.travelDirectionZ
            end
        end
    end

    local localIntent=track and track.localIntent or nil
    local blocked=spec~=nil and spec.isBlocked==true
    local turning=false
    local turningOk,turningValue=safeCall(vehicle,"getAIFieldWorkerIsTurning")
    if turningOk then turning=turningValue==true end
    local zeroTarget=valid and targetX==0 and targetZ==0
    local commandState="UNAVAILABLE"
    if params~=nil then
        commandState=valid and "VALID" or "PRESENT_INVALID"
        if valid and blocked and maxSpeed==0 and zeroTarget then commandState="VALID_BLOCKED_ZERO_COMMAND" end
    end

    return {
        referenceKey=ref,workerName=nameOf(vehicle),jobToken=currentJobToken(vehicle),
        status=commandState,paramsPresent=params~=nil,valid=valid,moveForwards=moveForwards,
        targetX=targetX,targetY=targetY,targetZ=targetZ,maxSpeed=maxSpeed,
        targetOffsetX=offsetX,targetOffsetZ=offsetZ,targetDistanceM=targetDistance,
        targetHeadingDot=targetHeadingDot,targetTravelDot=targetTravelDot,
        productivePositive=evidence and evidence.productivePositive==true or false,
        evidenceClass=evidence and evidence.evidenceClass or "UNRESOLVED",
        movingDirection=evidence and evidence.movingDirection or nil,
        localIntentClassification=localIntent and localIntent.classification or (track and track.localIntentClassification) or "UNRESOLVED",
        localIntentEpoch=localIntent and localIntent.intentEpoch or (track and track.localIntentEpoch) or nil,
        localIntentValid=localIntent and localIntent.intentValid==true or (track and track.localIntentValid==true),
        blocked=blocked,turning=turning,zeroTarget=zeroTarget,
        actualSpeedKmh=math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0)*3600,
        authority="PASSIVE_EVIDENCE_ONLY",routePrediction=false,futureSpaceAuthority=false,decisionAuthority=false,controlAuthority=false
    }
end

function Probe:_logSample(event,command)
    logInfo("%s worker=%s ref=%s job=%s status=%s paramsPresent=%s valid=%s moveForwards=%s targetWorld=(%s,%s,%s) targetOffsetFromPose=(%s,%s) targetDistance=%sm targetHeadingDot=%s targetTravelDot=%s nativeMaxSpeed=%skmh productive=%s evidenceClass=%s movingDirection=%s localIntent=%s intentEpoch=%s intentValid=%s turning=%s blocked=%s zeroTarget=%s actualSpeed=%.2fkmh interpretation=IMMEDIATE_NATIVE_FIELD_WORKER_DRIVE_COMMAND_ONLY frameTiming=CURRENT_OR_PREVIOUS_NATIVE_UPDATE routePrediction=false futureSpaceAuthority=false decisionAuthority=false controlAuthority=false",
        tostring(event),command.workerName,command.referenceKey,tostring(command.jobToken),command.status,tostring(command.paramsPresent),tostring(command.valid),tostring(command.moveForwards),
        ntext(command.targetX,2),ntext(command.targetY,2),ntext(command.targetZ,2),ntext(command.targetOffsetX,2),ntext(command.targetOffsetZ,2),ntext(command.targetDistanceM,2),
        ntext(command.targetHeadingDot,3),ntext(command.targetTravelDot,3),ntext(command.maxSpeed,2),tostring(command.productivePositive),tostring(command.evidenceClass),
        tostring(command.movingDirection),tostring(command.localIntentClassification),tostring(command.localIntentEpoch),tostring(command.localIntentValid),tostring(command.turning),tostring(command.blocked),tostring(command.zeroTarget),command.actualSpeedKmh or 0)
end

function Probe:logEvent(event,vehicle)
    if OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_ENABLED~=true or vehicle==nil then return nil end
    local command=self:sampleVehicle(vehicle)
    self.latest[command.referenceKey]=command
    self:_logSample(event or "EVENT",command)
    return command
end

function Probe:getLatest(ref) return self.latest[ref] end

function Probe:update(dt)
    if OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_ENABLED~=true or g_currentMission==nil then return end
    if g_client~=nil and g_server==nil then return end
    self.elapsed=self.elapsed+(dt or 0)
    local interval=OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_INTERVAL_MS or 250
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local nowMs=tonumber(g_time) or 0
    local heartbeat=OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_HEARTBEAT_MS or 1000
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)) do
        local command=self:sampleVehicle(vehicle)
        self.latest[command.referenceKey]=command
        local signature=table.concat({command.status,tostring(command.valid),tostring(command.moveForwards),ntext(command.targetX,2),ntext(command.targetZ,2),ntext(command.maxSpeed,2),tostring(command.productivePositive),tostring(command.evidenceClass),tostring(command.movingDirection),tostring(command.localIntentClassification),tostring(command.localIntentEpoch),tostring(command.localIntentValid),tostring(command.turning),tostring(command.blocked),tostring(command.zeroTarget)},"|")
        local due=self.lastHeartbeatAt[command.referenceKey]==nil or nowMs-self.lastHeartbeatAt[command.referenceKey]>=heartbeat
        local changed=self.lastSignature[command.referenceKey]~=signature
        if changed or due then
            self.lastSignature[command.referenceKey]=signature; self.lastHeartbeatAt[command.referenceKey]=nowMs
            self:_logSample(changed and "STATE_CHANGE" or "SAMPLE",command)
        end
    end
end
