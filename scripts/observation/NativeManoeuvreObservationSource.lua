OuttaMyWay.NativeManoeuvreObservationSource = {}
local Probe = OuttaMyWay.NativeManoeuvreObservationSource
Probe.__index = Probe

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][NATIVE-MANOEUVRE] %s",message)
    else
        print("[FS25_OuttaMyWay][NATIVE-MANOEUVRE] "..message)
    end
end

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function referenceKey(vehicle)
    return "vehicle-root:"..tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function objectName(vehicle)
    if vehicle~=nil and type(vehicle.getName)=="function" then
        local ok,value=pcall(vehicle.getName,vehicle)
        if ok and value~=nil and value~="" then return tostring(value) end
    end
    return tostring(vehicle and (vehicle.name or vehicle.typeName) or "AI vehicle")
end

local function pose(vehicle)
    local node=vehicle and (vehicle.rootNode or vehicle.components and vehicle.components[1] and vehicle.components[1].node) or nil
    if node==nil or node==0 or type(getWorldTranslation)~="function" or type(localDirectionToWorld)~="function" then return nil end
    local okPos,x,_,z=pcall(getWorldTranslation,node)
    local okDir,dx,_,dz=pcall(localDirectionToWorld,node,0,0,1)
    if not okPos or not okDir or not finite(x) or not finite(z) or not finite(dx) or not finite(dz) then return nil end
    local length=math.sqrt(dx*dx+dz*dz)
    if length<=0.000001 then return nil end
    return {x=x,z=z,dx=dx/length,dz=dz/length}
end

local function speedKmh(vehicle)
    return math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0)*3600
end

local function angleRadians(y,x)
    if math.atan2~=nil then return math.atan2(y,x) end
    if x>0 then return math.atan(y/x) end
    if x<0 and y>=0 then return math.atan(y/x)+math.pi end
    if x<0 and y<0 then return math.atan(y/x)-math.pi end
    if x==0 and y>0 then return math.pi/2 end
    if x==0 and y<0 then return -math.pi/2 end
    return 0
end

local function headingDeltaDegrees(entry,current)
    if entry==nil or current==nil then return nil end
    local dot=entry.dx*current.dx+entry.dz*current.dz
    local cross=entry.dx*current.dz-entry.dz*current.dx
    return math.deg(angleRadians(cross,dot)),dot,cross
end

local function physicalDiscs(representation)
    local result={}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(representation and representation.worldPrimitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) then
            result[#result+1]=primitive
        end
    end
    return result
end

local function localEnvelope(entry,representation)
    if entry==nil then return nil end
    local leftX,leftZ=-entry.dz,entry.dx
    local result=nil
    for _,disc in ipairs(physicalDiscs(representation)) do
        local rx,rz=disc.x-entry.x,disc.z-entry.z
        local forward=rx*entry.dx+rz*entry.dz
        local lateral=rx*leftX+rz*leftZ
        local r=disc.radius or 0
        local item={minForward=forward-r,maxForward=forward+r,minLateral=lateral-r,maxLateral=lateral+r}
        if result==nil then
            result=item
        else
            result.minForward=math.min(result.minForward,item.minForward)
            result.maxForward=math.max(result.maxForward,item.maxForward)
            result.minLateral=math.min(result.minLateral,item.minLateral)
            result.maxLateral=math.max(result.maxLateral,item.maxLateral)
        end
    end
    return result
end

local function mergeEnvelope(target,item)
    if item==nil then return target end
    if target==nil then
        return {minForward=item.minForward,maxForward=item.maxForward,minLateral=item.minLateral,maxLateral=item.maxLateral}
    end
    target.minForward=math.min(target.minForward,item.minForward)
    target.maxForward=math.max(target.maxForward,item.maxForward)
    target.minLateral=math.min(target.minLateral,item.minLateral)
    target.maxLateral=math.max(target.maxLateral,item.maxLateral)
    return target
end

local function lineCentreClearance(exitPose,representation)
    if exitPose==nil then return nil end
    local best=nil
    for _,disc in ipairs(physicalDiscs(representation)) do
        local rx,rz=disc.x-exitPose.x,disc.z-exitPose.z
        local lateral=math.abs(rx*(-exitPose.dz)+rz*exitPose.dx)
        local clearance=lateral-(disc.radius or 0)
        if best==nil or clearance<best then best=clearance end
    end
    return best
end

function Probe.evaluateSummary(samples,entryPose,exitPose)
    local summary={sampleCount=0,sweep=nil,firstExitLineCentreContactMs=nil,lastExitLineCentreContactMs=nil}
    for _,sample in OuttaMyWay.ValueRecord.ipairs(samples or {}) do
        summary.sampleCount=summary.sampleCount+1
        summary.sweep=mergeEnvelope(summary.sweep,sample.localEnvelope)
        if exitPose~=nil and sample.representation~=nil then
            local clearance=lineCentreClearance(exitPose,sample.representation)
            if clearance~=nil and clearance<=0 then
                local elapsed=sample.elapsedMs
                if summary.firstExitLineCentreContactMs==nil then summary.firstExitLineCentreContactMs=elapsed end
                summary.lastExitLineCentreContactMs=elapsed
            end
        end
    end
    if entryPose~=nil and exitPose~=nil then
        local rx,rz=exitPose.x-entryPose.x,exitPose.z-entryPose.z
        summary.exitForwardM=rx*entryPose.dx+rz*entryPose.dz
        summary.exitLateralM=rx*(-entryPose.dz)+rz*entryPose.dx
        summary.headingDeltaDeg,summary.headingDot,summary.headingCross=headingDeltaDegrees(entryPose,exitPose)
    end
    return summary
end

function Probe.new(runtime)
    return setmetatable({runtime=runtime,capabilityObservationSource=nil,elapsed=0,states={},runSequence=0,observations={}},Probe)
end

function Probe:reset()
    self.elapsed=0; self.states={}; self.runSequence=0; self.observations={}
end

function Probe:setCapabilityObservationSource(source)
    self.capabilityObservationSource=source
end

function Probe:_observeControlInfluence(state)
    if state==nil or self.capabilityObservationSource==nil or type(self.capabilityObservationSource.getVehicleControlObservation)~="function" then return end
    local drive=self.capabilityObservationSource:getVehicleControlObservation(state.vehicle)
    if drive~=nil and drive.mode~=nil then
        state.controlInfluenced=true
        state.controlMode=tostring(drive.mode or "UNKNOWN")
        state.controlOwner=tostring(drive.ownerTag or "UNSPECIFIED")
    end
end

function Probe:loadMap()
    self:reset()
    logInfo("raw native manoeuvre observation active; TURNING is observation only; boundary-demand Representation Fitness remains UNRESOLVED; no Decision or Control authority")
end

function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end

function Probe:_representation(vehicle,ref,jobToken,nowMs)
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    if cache==nil or jobToken==nil then return nil end
    return cache:observe(vehicle,ref,jobToken,(nowMs or 0)/1000)
end

function Probe:_fieldSnapshot(ref)
    local source=self.runtime and self.runtime.liveObservationSource or nil
    local track=source and source.tracks and source.tracks[ref] or nil
    return track and track.fieldWorldSnapshot or nil
end

function Probe:_start(vehicle,ref,jobToken,observed,nowMs,currentPose,representation)
    self.runSequence=self.runSequence+1
    local fieldSnapshot=self:_fieldSnapshot(ref)
    local boundaryDistance,boundarySource=nil,"FIELD_WORLD_SNAPSHOT_UNAVAILABLE"
    if fieldSnapshot~=nil and currentPose~=nil then boundaryDistance,boundarySource=OuttaMyWay.FieldBoundedFutureSpace.forwardBoundaryDistance(fieldSnapshot,currentPose) end
    local state={
        run=self.runSequence,vehicle=vehicle,ref=ref,name=objectName(vehicle),jobToken=jobToken,startMs=nowMs,
        entryPose=currentPose,entryBoundaryDistanceM=boundaryDistance,entryBoundarySource=boundarySource,
        entrySpeedKmh=speedKmh(vehicle),samples={},sweep=nil,lastSampleLogAt=-math.huge,
        segmentIndex=observed and observed.segmentIndex or nil,controlInfluenced=false,controlMode=nil,controlOwner=nil,
        phase="TURNING",measurementEndMs=nil,measurementExitPose=nil,waitingReason=nil
    }
    self:_observeControlInfluence(state)
    self.states[ref]=state
    logInfo(string.format(
        "START run=%d worker=%s ref=%s job=%s segment=%s entry=(%.2f,%.2f) heading=(%.4f,%.4f) speed=%.2fkmh boundaryDistance=%s boundarySource=%s physicalPrimitives=%s authority=PASSIVE_MEASUREMENT_ONLY",
        state.run,state.name,ref,tostring(jobToken),tostring(state.segmentIndex),
        currentPose and currentPose.x or 0,currentPose and currentPose.z or 0,currentPose and currentPose.dx or 0,currentPose and currentPose.dz or 0,
        state.entrySpeedKmh,boundaryDistance and string.format("%.2fm",boundaryDistance) or "n/a",tostring(boundarySource),
        representation and tostring(representation.physicalPrimitiveCount or 0) or "n/a"))
    return state
end

function Probe:_sample(state,nowMs,currentPose,representation,observed)
    if state==nil or currentPose==nil then return end
    self:_observeControlInfluence(state)
    local envelope=localEnvelope(state.entryPose,representation)
    local elapsed=nowMs-state.startMs
    local headingDeg,headingDot=headingDeltaDegrees(state.entryPose,currentPose)
    local sample={elapsedMs=elapsed,pose=currentPose,representation=representation,localEnvelope=envelope,speedKmh=speedKmh(state.vehicle),headingDeltaDeg=headingDeg,headingDot=headingDot}
    state.samples[#state.samples+1]=sample
    state.sweep=mergeEnvelope(state.sweep,envelope)
    local logInterval=OuttaMyWay.NATIVE_MANOEUVRE_OBSERVATION_LOG_INTERVAL_MS or 250
    if nowMs-(state.lastSampleLogAt or -math.huge)>=logInterval then
        state.lastSampleLogAt=nowMs
        logInfo(string.format(
            "SAMPLE run=%d elapsedMs=%d worker=%s pose=(%.2f,%.2f) speed=%.2fkmh headingDelta=%.2fdeg headingDot=%.4f localForward=[%s,%s] localLateral=[%s,%s] primitives=%s segment=%s",
            state.run,elapsed,state.name,currentPose.x,currentPose.z,sample.speedKmh,headingDeg or 0,headingDot or 0,
            envelope and string.format("%.2f",envelope.minForward) or "n/a",envelope and string.format("%.2f",envelope.maxForward) or "n/a",
            envelope and string.format("%.2f",envelope.minLateral) or "n/a",envelope and string.format("%.2f",envelope.maxLateral) or "n/a",
            representation and tostring(representation.physicalPrimitiveCount or 0) or "n/a",tostring(observed and observed.segmentIndex or state.segmentIndex)))
    end
end

function Probe:_finish(state,nowMs,exitPose,reason)
    local measuredExitPose=state.measurementExitPose or exitPose
    local measuredEndMs=state.measurementEndMs or nowMs
    local summary=Probe.evaluateSummary(state.samples,state.entryPose,measuredExitPose)
    local sweep=summary.sweep
    local durationMs=measuredEndMs-state.startMs
    local positiveClosure=reason=="GIANTS_TURN_SEGMENT_ENDED" or reason=="GIANTS_TURN_SEGMENT_ENDED_AFTER_WAITING_FOR_EVIDENCE"
    if positiveClosure and sweep~=nil and measuredExitPose~=nil then
        local list=self.observations[state.ref] or {}
        local item={
            run=state.run,referenceKey=state.ref,jobToken=state.jobToken,entryPose=state.entryPose,exitPose=measuredExitPose,
            entryBoundaryDistanceM=state.entryBoundaryDistanceM,entryBoundarySource=state.entryBoundarySource,durationMs=durationMs,
            sweep={minForward=sweep.minForward,maxForward=sweep.maxForward,minLateral=sweep.minLateral,maxLateral=sweep.maxLateral},
            exitForwardM=summary.exitForwardM,exitLateralM=summary.exitLateralM,headingDeltaDeg=summary.headingDeltaDeg,headingDot=summary.headingDot,
            headingReversed=summary.headingDot~=nil and summary.headingDot<0,controlInfluenced=state.controlInfluenced==true,controlMode=state.controlMode,controlOwner=state.controlOwner,
            closureReason=reason,representationFitnessForBoundaryDemand="UNRESOLVED",semanticTurnAuthority=false,boundaryDemandAuthority=false,
            provenance={source="NativeManoeuvreObservationSource",layer="OBSERVATION",nativeGIANTS=state.controlInfluenced~=true,semanticAuthority=false}
        }
        list[#list+1]=item; self.observations[state.ref]=list
        logInfo(string.format("OBSERVED run=%d worker=%s ref=%s job=%s closure=%s durationMs=%d entryBoundary=%s exitLateral=%s headingDot=%s sweepForward=[%.2f,%.2f] sweepLateral=[%.2f,%.2f] controlInfluenced=%s representationFitnessForBoundaryDemand=UNRESOLVED semanticTurnAuthority=false boundaryDemandAuthority=false",
            state.run,state.name,state.ref,tostring(state.jobToken),tostring(reason),durationMs,state.entryBoundaryDistanceM and string.format("%.2fm",state.entryBoundaryDistanceM) or "n/a",
            summary.exitLateralM and string.format("%.2fm",summary.exitLateralM) or "n/a",summary.headingDot and string.format("%.4f",summary.headingDot) or "n/a",
            sweep.minForward,sweep.maxForward,sweep.minLateral,sweep.maxLateral,tostring(state.controlInfluenced==true)))
    end
    logInfo(string.format("END run=%d worker=%s ref=%s job=%s reason=%s durationMs=%d samples=%d authority=RAW_OBSERVATION_ONLY",state.run,state.name,state.ref,tostring(state.jobToken),tostring(reason),durationMs,summary.sampleCount))
    self.states[state.ref]=nil
end

function Probe:getObservations(referenceKeyValue,jobToken)
    local result={}
    for _,item in ipairs(self.observations[referenceKeyValue] or {}) do
        if jobToken==nil or item.jobToken==jobToken then
            local copy={}
            for k,v in pairs(item) do if type(v)=="table" then local nested={}; for nk,nv in pairs(v) do nested[nk]=nv end; copy[k]=nested else copy[k]=v end end
            result[#result+1]=copy
        end
    end
    return result
end

function Probe.forensicDemandEnvelope(observations)
    local demand=nil
    for _,item in ipairs(observations or {}) do
        if finite(item.entryBoundaryDistanceM) and finite(item.durationMs) and type(item.sweep)=="table" then
            if demand==nil then
                demand={count=0,entryBoundaryDistanceM=item.entryBoundaryDistanceM,durationMs=item.durationMs,sweep={minForward=item.sweep.minForward,maxForward=item.sweep.maxForward,minLateral=item.sweep.minLateral,maxLateral=item.sweep.maxLateral}}
            else
                demand.entryBoundaryDistanceM=math.max(demand.entryBoundaryDistanceM,item.entryBoundaryDistanceM); demand.durationMs=math.max(demand.durationMs,item.durationMs)
                demand.sweep.minForward=math.min(demand.sweep.minForward,item.sweep.minForward); demand.sweep.maxForward=math.max(demand.sweep.maxForward,item.sweep.maxForward)
                demand.sweep.minLateral=math.min(demand.sweep.minLateral,item.sweep.minLateral); demand.sweep.maxLateral=math.max(demand.sweep.maxLateral,item.sweep.maxLateral)
            end
            demand.count=demand.count+1
        end
    end
    if demand~=nil then demand.representationFitness="UNRESOLVED"; demand.authority="FORENSIC_ONLY"; demand.boundaryDemandAuthority=false end
    return demand
end

function Probe:update(dt)
    if OuttaMyWay.NATIVE_MANOEUVRE_OBSERVATION_ENABLED~=true then return end
    if g_currentMission==nil then return end
    if g_client~=nil and g_server==nil then return end
    self.elapsed=self.elapsed+(dt or 0)
    local interval=OuttaMyWay.NATIVE_MANOEUVRE_OBSERVATION_INTERVAL_MS or 100
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local nowMs=tonumber(g_time) or 0
    local seen={}
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)) do
        local ref=referenceKey(vehicle); seen[ref]=true
        local job=OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
        local jobToken=OuttaMyWay.LiveAIJobEvidence.jobToken(job)
        local currentPose=pose(vehicle)
        local observed=OuttaMyWay.LocalIntentObservation.observe(vehicle)
        local representation=self:_representation(vehicle,ref,jobToken,nowMs)
        local state=self.states[ref]
        if state~=nil and state.jobToken~=jobToken then
            self:_finish(state,nowMs,currentPose,"JOB_EPISODE_CHANGED")
            state=nil
        end
        if state~=nil and state.phase=="WAITING_FOR_EVIDENCE" then
            self:_observeControlInfluence(state)
            if observed.classification=="SETTLED_CONTINUATION" and observed.valid==true then
                logInfo(string.format(
                    "EVIDENCE_CONFIRMED run=%d worker=%s ref=%s job=%s phase=WAITING_FOR_EVIDENCE evidence=SETTLED_CONTINUATION action=VALIDATE_FROZEN_MANOEUVRE",
                    state.run,state.name,state.ref,tostring(state.jobToken)))
                self:_finish(state,nowMs,currentPose,"GIANTS_TURN_SEGMENT_ENDED_AFTER_WAITING_FOR_EVIDENCE")
                state=nil
            elseif observed.classification=="TURNING" and observed.valid==true then
                logInfo(string.format(
                    "EVIDENCE_CONTRADICTED run=%d worker=%s ref=%s job=%s phase=WAITING_FOR_EVIDENCE evidence=NEW_TURN_SEGMENT action=REJECT_FROZEN_MANOEUVRE",
                    state.run,state.name,state.ref,tostring(state.jobToken)))
                self:_finish(state,nowMs,currentPose,"NEW_TURN_SEGMENT_BEFORE_SETTLED_CONTINUATION")
                state=nil
                if currentPose~=nil then
                    state=self:_start(vehicle,ref,jobToken,observed,nowMs,currentPose,representation)
                    self:_sample(state,nowMs,currentPose,representation,observed)
                end
            end
        elseif observed.classification=="TURNING" and observed.valid==true then
            if state==nil and currentPose~=nil then state=self:_start(vehicle,ref,jobToken,observed,nowMs,currentPose,representation) end
            self:_sample(state,nowMs,currentPose,representation,observed)
        elseif state~=nil then
            if currentPose==nil then
                self:_finish(state,nowMs,nil,"TURN_EVIDENCE_ENDED_WITHOUT_EXIT_POSE")
                state=nil
            else
                self:_sample(state,nowMs,currentPose,representation,observed)
                if observed.classification=="SETTLED_CONTINUATION" and observed.valid==true then
                    self:_finish(state,nowMs,currentPose,"GIANTS_TURN_SEGMENT_ENDED")
                    state=nil
                else
                    state.phase="WAITING_FOR_EVIDENCE"
                    state.measurementEndMs=nowMs
                    state.measurementExitPose=currentPose
                    state.waitingReason=tostring(observed.reason or observed.classification or "UNRESOLVED")
                    logInfo(string.format(
                        "WAITING_FOR_EVIDENCE run=%d worker=%s ref=%s job=%s frozenDurationMs=%d frozenExit=(%.2f,%.2f) observed=%s reason=%s evidenceNeeded=POSITIVE_SETTLED_CONTINUATION failureEvidence=JOB_EPISODE_CHANGE_OR_ACTIVE_JOB_DISAPPEARANCE_OR_NEW_TURN",
                        state.run,state.name,state.ref,tostring(state.jobToken),nowMs-state.startMs,currentPose.x,currentPose.z,
                        tostring(observed.classification),tostring(observed.reason or "UNRESOLVED")))
                end
            end
        end
    end
    for ref,state in pairs(self.states) do
        if not seen[ref] then self:_finish(state,nowMs,nil,"ACTIVE_JOB_VEHICLE_DISAPPEARED") end
    end
end
