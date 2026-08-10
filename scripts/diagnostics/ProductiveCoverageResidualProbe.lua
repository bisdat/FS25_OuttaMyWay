-- FS25_OuttaMyWay v4.7.69 TEST BUILD. D-0136 retained; D-0138 remains passive native field-worker drive-command context.
-- v4.7.68 repairs the passive settlement Future-Space representation seam discovered in the v4.7.67 live run.
-- D-0136 passive intent-based Productive Coverage Residual settlement witness.
--
-- A residual is not every unpainted cell. The probe opens at the first positively
-- Productive sample of a Job Episode only when a coherent continuation of that
-- observed working corridor exists behind the starting sample to the captured
-- Field World boundary. Cells in that corridor that are not yet demonstrated as
-- productively covered are recorded as worker-specific Potential Demand evidence.
-- The probe observes later convergence and intent-lifecycle settlement only. It grants
-- no Decision, Regulation, Hold, Reposition, Refuge or Control authority. Geometric
-- fill percentage is supporting evidence only and never defines settlement authority.

OuttaMyWay.ProductiveCoverageResidualProbe={}
local Probe=OuttaMyWay.ProductiveCoverageResidualProbe
Probe.__index=Probe

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][PRODUCTIVE-RESIDUAL] %s",message)
    else
        print("[FS25_OuttaMyWay][PRODUCTIVE-RESIDUAL] "..message)
    end
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
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

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function norm(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local length=math.sqrt(x*x+z*z)
    if length<=0.000001 then return nil,nil end
    return x/length,z/length
end

local function distance(x1,z1,x2,z2)
    local dx,dz=x2-x1,z2-z1
    return math.sqrt(dx*dx+dz*dz)
end

local function mapKey(ref,jobToken) return tostring(ref).."|"..tostring(jobToken) end

local function segmentMidpoint(segment)
    if segment==nil or segment.left==nil or segment.right==nil then return nil end
    return {x=(segment.left.x+segment.right.x)*0.5,z=(segment.left.z+segment.right.z)*0.5}
end

local function cellsAsSet(cells)
    local out={}
    for _,cell in ipairs(cells or {}) do out[cell.key]=true end
    return out
end

local function sourceFieldAt(x,z)
    if OuttaMyWay.LiveAIJobEvidence==nil or type(OuttaMyWay.LiveAIJobEvidence.fieldAtPosition)~="function" then return nil end
    local field=OuttaMyWay.LiveAIJobEvidence.fieldAtPosition(g_currentMission,x,z)
    if field~=nil and field.resolved==true then return field.sourceFieldId end
    return nil
end

local function shiftedSegment(segment,dx,dz,distanceM)
    return {
        left={x=segment.left.x+dx*distanceM,z=segment.left.z+dz*distanceM},
        right={x=segment.right.x+dx*distanceM,z=segment.right.z+dz*distanceM},
        width=segment.width,source=segment.source
    }
end

function Probe.residualClass(total,covered)
    total=tonumber(total) or 0; covered=tonumber(covered) or 0
    if total<=0 then return "NO_COHERENT_PRODUCTIVE_COVERAGE_RESIDUAL" end
    if covered>=total then return "RESIDUAL_GEOMETRICALLY_FILLED" end
    if covered>0 then return "RESIDUAL_PARTIALLY_FILLED" end
    return "RESIDUAL_OPEN"
end

function Probe.trackIsActive(track)
    return type(track)=="table" and track.active==true
end

-- LiveObservationSource persistent tracks and FieldBoundedFutureSpace observation
-- workers are deliberately different representations. D-0136 settlement reassessment
-- operates over persistent tracks, so adapt explicitly instead of mutating a track or
-- teaching FieldBoundedFutureSpace about persistence-layer fields.
function Probe.futureSpaceWorkerFromTrack(track)
    if type(track)~="table" then return nil end
    return {
        activeObserved=Probe.trackIsActive(track),
        localIntent=track.localIntent,
        fieldWorldSnapshot=track.fieldWorldSnapshot,
        pose=track.pose,
        shadowRepresentation=track.shadowRepresentation
    }
end

function Probe.intentSettlementEligible(state,previousEvidence,currentEvidence)
    if type(state)~="table" then return false end
    if state.productiveReentryObserved~=true or state.returnConsumptionObserved~=true or state.originReacquired~=true then return false end
    if type(previousEvidence)~="table" or previousEvidence.productivePositive~=true then return false end
    if type(currentEvidence)~="table" or currentEvidence.productivePositive==true then return false end
    return currentEvidence.evidenceClass=="TURN_SEGMENT"
end

function Probe.sweepIntersectsCellSet(previous,current,cellSize,cellSet)
    if previous==nil or current==nil or type(cellSet)~="table" then return false end
    for _,cell in ipairs(OuttaMyWay.DemonstratedProductiveCoverageProbe.rasterizeQuadCells(previous,current,cellSize)) do
        if cellSet[cell.key]==true then return true end
    end
    return false
end

function Probe.new(runtime,productiveProbe,coverageProbe,nativeCommandProbe)
    return setmetatable({runtime=runtime,productiveProbe=productiveProbe,coverageProbe=coverageProbe,nativeCommandProbe=nativeCommandProbe,elapsed=0,states={},lastHeartbeatAt={}},Probe)
end

function Probe:reset()
    self.elapsed=0; self.states={}; self.lastHeartbeatAt={}
end

function Probe:loadMap()
    self:reset()
    logInfo("active=true mode=PASSIVE_SHADOW_ONLY residualBasis=FIRST_POSITIVE_PRODUCTIVE_CORRIDOR_BACK_TO_FIELD_WORLD_BOUNDARY unpaintedIsNotDemand=true residualSupportsPotentialDemandOnly=true settlementBasis=PRODUCTIVE_REENTRY_PLUS_RETURN_CONSUMPTION_PLUS_ORIGIN_REACQUISITION_PLUS_PRODUCTIVE_TO_TURN geometricCompletionIsNotSettlement=true settlementFutureSpaceInput=PERSISTENT_TRACK_TO_OBSERVATION_ADAPTER settlementAuthority=REASSESSMENT_EVIDENCE_ONLY decisionAuthority=false controlAuthority=false")
end
function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end

function Probe:_track(ref)
    local source=self.runtime and self.runtime.liveObservationSource or nil
    return source and source.tracks and source.tracks[ref] or nil
end

function Probe:_open(vehicle,ref,jobToken,evidence,track,nowMs)
    local key=mapKey(ref,jobToken)
    if self.states[key]~=nil then return self.states[key] end
    local state={ref=ref,jobToken=jobToken,workerName=nameOf(vehicle),phase="NO_RESIDUAL",cells={},cellCount=0,coveredCount=0,openedAt=nowMs,lastDistance=nil,convergenceObserved=false,intentSettled=false,geometricallyFilled=false,productiveReentryObserved=false,returnConsumptionObserved=false,originReacquired=false,lastProductiveSegment=nil,previousEvidence=nil}
    self.states[key]=state
    if track==nil or track.fieldWorldSnapshot==nil or track.pose==nil then
        state.reason="FIELD_WORLD_OR_POSE_UNAVAILABLE_AT_FIRST_PRODUCTIVE_SAMPLE"
        logInfo("RESIDUAL_UNRESOLVED worker=%s ref=%s job=%s reason=%s potentialDemandAuthority=false",state.workerName,ref,tostring(jobToken),state.reason)
        return state
    end
    local hx,hz=norm(track.pose.dx,track.pose.dz)
    if hx==nil then
        state.reason="PRODUCTIVE_HEADING_UNAVAILABLE"
        logInfo("RESIDUAL_UNRESOLVED worker=%s ref=%s job=%s reason=%s potentialDemandAuthority=false",state.workerName,ref,tostring(jobToken),state.reason)
        return state
    end
    local segment=self.coverageProbe and self.coverageProbe:getWorkingSegment(vehicle) or nil
    if segment==nil then
        state.reason="WORKING_FOOTPRINT_MARKERS_UNRESOLVED"
        logInfo("RESIDUAL_UNRESOLVED worker=%s ref=%s job=%s reason=%s potentialDemandAuthority=false",state.workerName,ref,tostring(jobToken),state.reason)
        return state
    end
    local backwardDistance,boundarySource=OuttaMyWay.FieldBoundedFutureSpace.forwardBoundaryDistance(track.fieldWorldSnapshot,{x=track.pose.x,z=track.pose.z,dx=-hx,dz=-hz})
    if not finite(backwardDistance) then
        state.reason=boundarySource or "BACKWARD_FIELD_BOUNDARY_UNAVAILABLE"
        logInfo("RESIDUAL_UNRESOLVED worker=%s ref=%s job=%s reason=%s potentialDemandAuthority=false",state.workerName,ref,tostring(jobToken),state.reason)
        return state
    end
    local cellSize=OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_CELL_SIZE_M or 5.0
    state.backwardBoundaryM=backwardDistance; state.boundarySource=boundarySource; state.fieldId=sourceFieldAt(track.pose.x,track.pose.z)
    state.startX=track.pose.x; state.startZ=track.pose.z; state.headingX=hx; state.headingZ=hz; state.markerWidth=segment.width
    state.originSegment={left={x=segment.left.x,z=segment.left.z},right={x=segment.right.x,z=segment.right.z},width=segment.width,source=segment.source}
    state.originMidpoint=segmentMidpoint(state.originSegment)
    local originBack=shiftedSegment(state.originSegment,-hx,-hz,cellSize*0.5)
    local originAhead=shiftedSegment(state.originSegment,hx,hz,cellSize*0.5)
    state.originAnchorCells=cellsAsSet(OuttaMyWay.DemonstratedProductiveCoverageProbe.rasterizeQuadCells(originBack,originAhead,cellSize))
    if backwardDistance<cellSize then
        state.reason="BACKWARD_CORRIDOR_SHORTER_THAN_DIAGNOSTIC_CELL"
        logInfo("RESIDUAL_NONE worker=%s ref=%s job=%s backwardBoundary=%.2fm cellSize=%.2fm reason=%s",state.workerName,ref,tostring(jobToken),backwardDistance,cellSize,state.reason)
        return state
    end
    local boundarySegment=shiftedSegment(segment,-hx,-hz,backwardDistance)
    local candidateCells=OuttaMyWay.DemonstratedProductiveCoverageProbe.rasterizeQuadCells(boundarySegment,segment,cellSize)
    local sumX,sumZ=0,0
    for _,cell in ipairs(candidateCells) do
        if state.fieldId~=nil and sourceFieldAt(cell.x,cell.z)==state.fieldId then
            local demonstrated=self.coverageProbe and self.coverageProbe:isCellDemonstrated(ref,jobToken,cell.ix,cell.iz) or false
            if not demonstrated then
                state.cells[cell.key]=cell; state.cellCount=state.cellCount+1; sumX=sumX+cell.x; sumZ=sumZ+cell.z
            end
        end
    end
    if state.cellCount<=0 then
        state.reason="NO_UNPAINTED_CELLS_IN_BACKWARD_PRODUCTIVE_CORRIDOR"
        logInfo("RESIDUAL_NONE worker=%s ref=%s job=%s backwardBoundary=%.2fm candidateCells=%d reason=%s",state.workerName,ref,tostring(jobToken),backwardDistance,#candidateCells,state.reason)
        return state
    end
    state.centroidX=sumX/state.cellCount; state.centroidZ=sumZ/state.cellCount; state.phase="OPEN"
    state.lastDistance=distance(track.pose.x,track.pose.z,state.centroidX,state.centroidZ)
    logInfo("RESIDUAL_OPEN worker=%s ref=%s job=%s field=%s start=(%.2f,%.2f) productiveHeading=(%.3f,%.3f) markerWidth=%.2fm backwardBoundary=%.2fm boundarySource=%s residualCells=%d centroid=(%.2f,%.2f) originAnchorCells=%d interpretation=POTENTIAL_PRODUCTIVE_DEMAND_ONLY geometricCompletionIsNotSettlement=true routePrediction=false decisionAuthority=false controlAuthority=false",
        state.workerName,ref,tostring(jobToken),tostring(state.fieldId),state.startX,state.startZ,hx,hz,segment.width,backwardDistance,tostring(boundarySource),state.cellCount,state.centroidX,state.centroidZ,(function() local n=0 for _ in pairs(state.originAnchorCells or {}) do n=n+1 end return n end)())
    return state
end

function Probe:_coverage(state)
    local covered=0
    for _,cell in pairs(state.cells) do
        if self.coverageProbe and self.coverageProbe:isCellDemonstrated(state.ref,state.jobToken,cell.ix,cell.iz) then covered=covered+1 end
    end
    return covered
end

function Probe:_settlementReassessment(state,settlingTrack)
    local source=self.runtime and self.runtime.liveObservationSource or nil
    local tracks=source and source.tracks or {}
    local anyPositive=false; local compared=0
    if self.nativeCommandProbe~=nil and settlingTrack~=nil and settlingTrack.object~=nil then self.nativeCommandProbe:logEvent("RESIDUAL_INTENT_SETTLED_SUBJECT",settlingTrack.object) end
    for otherRef,otherTrack in pairs(tracks) do
        if otherRef~=state.ref and Probe.trackIsActive(otherTrack) then
            local sameWorld=settlingTrack and settlingTrack.fieldWorldResolution and otherTrack.fieldWorldResolution and settlingTrack.fieldWorldResolution.fieldWorldReferenceKey~=nil and settlingTrack.fieldWorldResolution.fieldWorldReferenceKey==otherTrack.fieldWorldResolution.fieldWorldReferenceKey
            if sameWorld then
                compared=compared+1
                if self.nativeCommandProbe~=nil and otherTrack.object~=nil then self.nativeCommandProbe:logEvent("RESIDUAL_INTENT_SETTLED_OTHER",otherTrack.object) end
                local settlingWorker=Probe.futureSpaceWorkerFromTrack(settlingTrack)
                local otherWorker=Probe.futureSpaceWorkerFromTrack(otherTrack)
                local settlingFuture=OuttaMyWay.FieldBoundedFutureSpace.build(settlingWorker)
                local otherFuture=OuttaMyWay.FieldBoundedFutureSpace.build(otherWorker)
                local pair=OuttaMyWay.FieldBoundedFutureSpace.evaluatePair(settlingWorker,otherWorker,settlingFuture,otherFuture)
                local status=pair.positive==true and "POSITIVE_COARSE_FUTURE_INTERSECTION" or "UNRESOLVED_OR_NO_POSITIVE_INTERSECTION"
                if pair.positive==true then anyPositive=true end
                logInfo("SETTLEMENT_REASSESSMENT worker=%s ref=%s job=%s other=%s otherRef=%s sameFieldWorld=true settlingFuture=%s otherFuture=%s coarsePair=%s distance=%s required=%s interpretation=%s action=NO_ACTUATION",
                    state.workerName,state.ref,tostring(state.jobToken),tostring(otherTrack.name or otherTrack.objectName or otherRef),otherRef,
                    settlingFuture.bounded==true and "BOUNDED" or (settlingFuture.reason or "UNRESOLVED"),otherFuture.bounded==true and "BOUNDED" or (otherFuture.reason or "UNRESOLVED"),status,
                    pair.distance and string.format("%.2fm",pair.distance) or "n/a",pair.required and string.format("%.2fm",pair.required) or "n/a",
                    pair.positive==true and "TRAFFIC_POLICEMAN_REASSESSMENT_WARRANTED_SHADOW_ONLY" or "CURRENT_COARSE_KNOWLEDGE_INSUFFICIENT_FOR_INTERVENTION")
            end
        end
    end
    logInfo("RESIDUAL_SETTLEMENT_SUMMARY worker=%s ref=%s job=%s compared=%d anyPositiveCoarseFutureIntersection=%s recommendation=%s authority=PASSIVE_ONLY",
        state.workerName,state.ref,tostring(state.jobToken),compared,tostring(anyPositive),anyPositive and "REASSESS_AT_SETTLEMENT_SHADOW" or "NO_POSITIVE_EARLY_INTERSECTION_WITNESS")
end

function Probe:_observeState(vehicle,state,evidence,track,nowMs)
    if state.phase~="OPEN" and state.phase~="PARTIAL" and state.phase~="GEOMETRICALLY_FILLED" then return end
    local previousEvidence=state.previousEvidence
    local isProductive=evidence~=nil and evidence.productivePositive==true
    local currentSegment=isProductive and self.coverageProbe and self.coverageProbe:getWorkingSegment(vehicle) or nil
    local originDistance=nil
    if currentSegment~=nil and state.originMidpoint~=nil then
        local midpoint=segmentMidpoint(currentSegment)
        if midpoint~=nil then originDistance=distance(midpoint.x,midpoint.z,state.originMidpoint.x,state.originMidpoint.z) end
    end

    local covered=self:_coverage(state)
    if covered~=state.coveredCount then
        local previousCovered=state.coveredCount
        state.coveredCount=covered
        local class=Probe.residualClass(state.cellCount,covered)
        logInfo("RESIDUAL_PROGRESS worker=%s ref=%s job=%s covered=%d/%d ratio=%.3f state=%s evidenceClass=%s movingDirection=%s geometricCompletionAuthority=false authority=PASSIVE_ONLY",
            state.workerName,state.ref,tostring(state.jobToken),covered,state.cellCount,state.cellCount>0 and covered/state.cellCount or 0,class,tostring(evidence and evidence.evidenceClass),tostring(evidence and evidence.movingDirection))
        if isProductive and covered>previousCovered then
            if state.productiveReentryObserved~=true then
                state.productiveReentryObserved=true
                state.reentryCoveredCount=covered
                state.reentryOriginDistance=originDistance
                logInfo("PRODUCTIVE_REENTRY_OBSERVED worker=%s ref=%s job=%s covered=%d/%d originDistance=%s interpretation=NATIVE_PRODUCTIVE_WORK_REENTERED_SUPPORTED_RESIDUAL action=NO_ACTUATION",
                    state.workerName,state.ref,tostring(state.jobToken),covered,state.cellCount,originDistance and string.format("%.2fm",originDistance) or "n/a")
            elseif state.returnConsumptionObserved~=true and covered>(state.reentryCoveredCount or 0) and originDistance~=nil and state.reentryOriginDistance~=nil and originDistance<state.reentryOriginDistance then
                state.returnConsumptionObserved=true
                logInfo("COHERENT_RETURN_CONSUMPTION_OBSERVED worker=%s ref=%s job=%s covered=%d/%d reentryOriginDistance=%.2fm currentOriginDistance=%.2fm interpretation=PRODUCTIVE_RESIDUAL_CONSUMPTION_PROGRESSING_TOWARD_ORIGIN action=NO_ACTUATION",
                    state.workerName,state.ref,tostring(state.jobToken),covered,state.cellCount,state.reentryOriginDistance,originDistance)
            end
        end
        if covered>=state.cellCount and state.geometricallyFilled~=true then
            state.geometricallyFilled=true; state.phase="GEOMETRICALLY_FILLED"
            logInfo("RESIDUAL_GEOMETRICALLY_FILLED worker=%s ref=%s job=%s residualCells=%d interpretation=SUPPORTING_COVERAGE_EVIDENCE_ONLY intentSettlement=false potentialDemandRetirementAuthority=false action=NO_ACTUATION",
                state.workerName,state.ref,tostring(state.jobToken),state.cellCount)
        elseif state.phase~="GEOMETRICALLY_FILLED" then
            state.phase="PARTIAL"
        end
    end

    if isProductive and currentSegment~=nil then
        local cellSize=OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_CELL_SIZE_M or 5.0
        if state.productiveReentryObserved==true and state.originReacquired~=true and state.lastProductiveSegment~=nil and Probe.sweepIntersectsCellSet(state.lastProductiveSegment,currentSegment,cellSize,state.originAnchorCells) then
            state.originReacquired=true
            logInfo("ORIGINATING_PRODUCTIVE_REGION_REACQUIRED worker=%s ref=%s job=%s covered=%d/%d originDistance=%s representationCell=%.2fm interpretation=RETURNING_PRODUCTIVE_SWEEP_REACQUIRED_ORIGIN_REGION action=NO_ACTUATION",
                state.workerName,state.ref,tostring(state.jobToken),state.coveredCount,state.cellCount,originDistance and string.format("%.2fm",originDistance) or "n/a",cellSize)
        end
        state.lastProductiveSegment=currentSegment
    else
        state.lastProductiveSegment=nil
    end

    if Probe.intentSettlementEligible(state,previousEvidence,evidence) then
        state.phase="INTENT_SETTLED"; state.intentSettled=true; state.settledAt=nowMs
        logInfo("RESIDUAL_INTENT_SETTLED worker=%s ref=%s job=%s covered=%d/%d ratio=%.3f settledAt=%d witness=PRODUCTIVE_REENTRY_PLUS_RETURN_CONSUMPTION_PLUS_ORIGIN_REACQUISITION_PLUS_PRODUCTIVE_TO_TURN interpretation=PREVIOUS_RESIDUAL_SUPPORTED_POTENTIAL_DEMAND_APPARENTLY_SATISFIED nextNativePurpose=UNRESOLVED geometricCompletionRequired=false regulationAuthority=false holdAuthority=false action=NO_ACTUATION",
            state.workerName,state.ref,tostring(state.jobToken),state.coveredCount,state.cellCount,state.cellCount>0 and state.coveredCount/state.cellCount or 0,nowMs)
        self:_settlementReassessment(state,track)
        state.previousEvidence=evidence and {productivePositive=evidence.productivePositive==true,evidenceClass=evidence.evidenceClass} or nil
        return
    end

    if track~=nil and track.pose~=nil and state.centroidX~=nil then
        local currentDistance=distance(track.pose.x,track.pose.z,state.centroidX,state.centroidZ)
        if state.lastDistance~=nil and currentDistance+0.25<state.lastDistance and evidence~=nil and (evidence.movingDirection==1 or evidence.movingDirection==-1) then
            if state.convergenceObserved~=true then
                state.convergenceObserved=true
                logInfo("NATIVE_CONVERGENCE_OBSERVED worker=%s ref=%s job=%s evidenceClass=%s movingDirection=%s distanceToResidual=%.2fm previous=%.2fm interpretation=COARSE_DISTANCE_TREND_TOWARD_SUPPORTED_RESIDUAL routePrediction=false action=NO_ACTUATION",
                    state.workerName,state.ref,tostring(state.jobToken),tostring(evidence.evidenceClass),tostring(evidence.movingDirection),currentDistance,state.lastDistance)
            end
        end
        state.lastDistance=currentDistance
    end
    local heartbeat=OuttaMyWay.PRODUCTIVE_COVERAGE_RESIDUAL_HEARTBEAT_MS or 2000
    if self.lastHeartbeatAt[mapKey(state.ref,state.jobToken)]==nil or nowMs-self.lastHeartbeatAt[mapKey(state.ref,state.jobToken)]>=heartbeat then
        self.lastHeartbeatAt[mapKey(state.ref,state.jobToken)]=nowMs
        logInfo("RESIDUAL_SAMPLE worker=%s ref=%s job=%s state=%s covered=%d/%d distanceToResidual=%s productive=%s evidenceClass=%s movingDirection=%s reentry=%s returnConsumption=%s originReacquired=%s action=NO_ACTUATION",
            state.workerName,state.ref,tostring(state.jobToken),state.phase,state.coveredCount,state.cellCount,state.lastDistance and string.format("%.2fm",state.lastDistance) or "n/a",tostring(isProductive),tostring(evidence and evidence.evidenceClass),tostring(evidence and evidence.movingDirection),tostring(state.productiveReentryObserved==true),tostring(state.returnConsumptionObserved==true),tostring(state.originReacquired==true))
    end
    state.previousEvidence=evidence and {productivePositive=evidence.productivePositive==true,evidenceClass=evidence.evidenceClass} or nil
end

function Probe:update(dt)
    if OuttaMyWay.PRODUCTIVE_COVERAGE_RESIDUAL_PROBE_ENABLED~=true or g_currentMission==nil then return end
    if g_client~=nil and g_server==nil then return end
    self.elapsed=self.elapsed+(dt or 0)
    local interval=OuttaMyWay.PRODUCTIVE_COVERAGE_RESIDUAL_PROBE_INTERVAL_MS or 250
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local nowMs=tonumber(g_time) or 0
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)) do
        local ref=referenceKey(vehicle); local jobToken=currentJobToken(vehicle)
        if jobToken~=nil then
            local evidence=self.productiveProbe and self.productiveProbe:getEvidence(ref,jobToken) or nil
            local track=self:_track(ref)
            local key=mapKey(ref,jobToken); local state=self.states[key]
            if state==nil and evidence~=nil and evidence.productivePositive==true then state=self:_open(vehicle,ref,jobToken,evidence,track,nowMs) end
            if state~=nil then self:_observeState(vehicle,state,evidence,track,nowMs) end
        end
    end
end
