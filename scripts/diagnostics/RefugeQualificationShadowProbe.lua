-- FS25_OuttaMyWay v4.7.63 TEST BUILD.
-- D-0134 passive Refuge Resulting-Situation Qualification probe.
--
-- Evaluates the existing TS015 fixture Refuge candidates and extra infield
-- shadow candidates without changing selection. Evidence vector: Field World
-- fit, Progress current positive Future Space, demonstrated boundary-manoeuvre
-- entry band, and Progress Demonstrated Productive Coverage. No candidate is
-- selected, rejected or granted Control authority by this module.

OuttaMyWay.RefugeQualificationShadowProbe={}
local Probe=OuttaMyWay.RefugeQualificationShadowProbe
Probe.__index=Probe

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][REFUGE-QUALIFICATION-SHADOW] %s",message)
    else
        print("[FS25_OuttaMyWay][REFUGE-QUALIFICATION-SHADOW] "..message)
    end
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function referenceKey(vehicle)
    return "vehicle-root:"..tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function currentJobToken(vehicle)
    local job=OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
    return OuttaMyWay.LiveAIJobEvidence.jobToken(job)
end

local function pose(vehicle)
    if vehicle==nil then return nil end
    local node=nil
    local ok,value=safeCall(vehicle,"getAISteeringNode")
    if ok and value~=nil and value~=0 then node=value end
    node=node or vehicle.rootNode
    if node==nil or node==0 or type(getWorldTranslation)~="function" or type(localDirectionToWorld)~="function" then return nil end
    local okPos,x,_,z=pcall(getWorldTranslation,node)
    local okDir,dx,_,dz=pcall(localDirectionToWorld,node,0,0,1)
    if not okPos or not okDir then return nil end
    local length=math.sqrt(dx*dx+dz*dz)
    if length<=0.000001 then return nil end
    return {x=x,z=z,dx=dx/length,dz=dz/length}
end

local function fieldAt(x,z)
    if OuttaMyWay.LiveAIJobEvidence==nil or type(OuttaMyWay.LiveAIJobEvidence.fieldAtPosition)~="function" then return nil end
    return OuttaMyWay.LiveAIJobEvidence.fieldAtPosition(g_currentMission,x,z)
end

local function sameSourceField(x,z,sourceFieldId)
    local field=fieldAt(x,z)
    return field~=nil and field.resolved==true and field.sourceFieldId==sourceFieldId
end

local function qualifyField(sourceFieldId,x,z,radius,count)
    count=math.max(4,math.floor(count or 12)); radius=math.max(0,radius or 0)
    local matched=0; local required=count+1
    if sameSourceField(x,z,sourceFieldId) then matched=matched+1 end
    for index=1,count do
        local angle=(index-1)*(math.pi*2/count)
        if sameSourceField(x+math.cos(angle)*radius,z+math.sin(angle)*radius,sourceFieldId) then matched=matched+1 end
    end
    return {qualified=matched==required,matched=matched,required=required,radius=radius}
end

local function pointSegmentDistance(px,pz,ax,az,bx,bz)
    local dx,dz=bx-ax,bz-az
    local lengthSquared=dx*dx+dz*dz
    if lengthSquared<=1e-12 then
        local rx,rz=px-ax,pz-az; return math.sqrt(rx*rx+rz*rz)
    end
    local t=((px-ax)*dx+(pz-az)*dz)/lengthSquared
    if t<0 then t=0 elseif t>1 then t=1 end
    local qx,qz=ax+t*dx,az+t*dz
    local rx,rz=px-qx,pz-qz
    return math.sqrt(rx*rx+rz*rz)
end

local function nearestBoundaryDistance(snapshot,x,z)
    if snapshot==nil or type(snapshot.boundary)~="table" or #snapshot.boundary<2 then return nil end
    local best=nil
    local function ring(points)
        for index=1,#points do
            local nextIndex=(index%#points)+1
            local a,b=points[index],points[nextIndex]
            if a~=nil and b~=nil then
                local d=pointSegmentDistance(x,z,a.x,a.z,b.x,b.z)
                if best==nil or d<best then best=d end
            end
        end
    end
    ring(snapshot.boundary)
    for _,island in OuttaMyWay.ValueRecord.ipairs(snapshot.islands or {}) do ring(island) end
    return best
end

local function physicalDiscs(representation)
    local out={}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(representation and representation.worldPrimitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and type(primitive.x)=="number" and type(primitive.z)=="number" and type(primitive.radius)=="number" then
            out[#out+1]=primitive
        end
    end
    return out
end

local function futureIntersection(track,candidateX,candidateZ,candidateRadius)
    if track==nil then return {status="UNRESOLVED",reason="PROGRESS_TRACK_UNAVAILABLE"} end
    local future=OuttaMyWay.FieldBoundedFutureSpace.build(track)
    if future.bounded~=true then return {status="UNRESOLVED",reason=future.reason or "PROGRESS_FUTURE_SPACE_UNRESOLVED"} end
    local discs=physicalDiscs(track.shadowRepresentation)
    if #discs==0 then return {status="UNRESOLVED",reason="PROGRESS_PHYSICAL_DISCS_UNAVAILABLE"} end
    local best=nil; local requiredAtBest=nil
    for _,disc in ipairs(discs) do
        local ax,az=disc.x,disc.z
        local bx=ax+future.headingX*future.boundaryDistance
        local bz=az+future.headingZ*future.boundaryDistance
        local d=pointSegmentDistance(candidateX,candidateZ,ax,az,bx,bz)
        local required=(disc.radius or 0)+(candidateRadius or 0)
        if best==nil or d<best then best=d; requiredAtBest=required end
        if d<=required then
            return {status="POSITIVE_INTERSECTION",reason="CANDIDATE_OCCUPANCY_INTERSECTS_PROGRESS_FIELD_BOUNDED_FUTURE_SPACE",distance=d,required=required,boundaryDistance=future.boundaryDistance}
        end
    end
    return {status="NO_POSITIVE_INTERSECTION",reason="NON_INTERSECTION_HAS_NO_NEGATIVE_CLEARANCE_AUTHORITY",distance=best,required=requiredAtBest,boundaryDistance=future.boundaryDistance}
end

function Probe.boundaryDemandClass(nearestBoundaryM,entryBoundaryM)
    if type(nearestBoundaryM)~="number" or type(entryBoundaryM)~="number" then return "UNRESOLVED" end
    if nearestBoundaryM<=entryBoundaryM then return "WITHIN_DEMONSTRATED_BOUNDARY_MANOEUVRE_ENTRY_BAND" end
    return "BEYOND_DEMONSTRATED_BOUNDARY_MANOEUVRE_ENTRY_BAND"
end

function Probe.generateInfieldCandidates(origin,centroid,offsets)
    if origin==nil or centroid==nil then return {} end
    local dx,dz=centroid.x-origin.x,centroid.z-origin.z
    local length=math.sqrt(dx*dx+dz*dz)
    if length<=0.000001 then return {} end
    dx,dz=dx/length,dz/length
    local result={}
    for _,offset in ipairs(offsets or {}) do
        offset=tonumber(offset)
        if offset~=nil and offset>0 then
            result[#result+1]={kind="INFIELD_SHADOW",label="INFIELD_"..string.format("%.0fM",offset),targetX=origin.x+dx*offset,targetZ=origin.z+dz*offset,infieldOffsetM=offset}
        end
    end
    return result
end

function Probe.new(runtime,coverageProbe,headlandProbe,nativeCommandProbe)
    return setmetatable({runtime=runtime,coverageProbe=coverageProbe,headlandProbe=headlandProbe,nativeCommandProbe=nativeCommandProbe,evaluationCount=0,lastFixtureSequence=nil},Probe)
end

function Probe:_track(ref)
    local source=self.runtime and self.runtime.liveObservationSource or nil
    return source and source.tracks and source.tracks[ref] or nil
end

function Probe:loadMap() self.evaluationCount=0; self.lastFixtureSequence=nil end
function Probe:deleteMap() self.lastFixtureSequence=nil end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end
function Probe:update(dt)
    if OuttaMyWay.REFUGE_QUALIFICATION_SHADOW_PROBE_ENABLED~=true then return end
    local gate=OuttaMyWay.prototype22CapabilityGate
    local run=gate and gate.run or nil
    local observation=run and run.refugeFixtureObservation or nil
    if observation==nil or observation.sequence==self.lastFixtureSequence then return end
    self.lastFixtureSequence=observation.sequence
    self:evaluateSelection(run,observation.candidates,observation.sourceFieldId)
end

function Probe:evaluateSelection(run,fixtureCandidates,sourceFieldId)
    if OuttaMyWay.REFUGE_QUALIFICATION_SHADOW_PROBE_ENABLED~=true or run==nil then return end
    local yieldPose=pose(run.vehicle); local progressPose=pose(run.progressVehicle)
    if yieldPose==nil or progressPose==nil then
        logInfo("EVALUATION_UNRESOLVED yield=%s progress=%s reason=POSE_UNAVAILABLE authority=PASSIVE_ONLY",tostring(run.vehicleName),tostring(run.progressVehicleName))
        return
    end
    local yieldRef=referenceKey(run.vehicle); local progressRef=referenceKey(run.progressVehicle)
    local progressJob=currentJobToken(run.progressVehicle)
    local progressTrack=self:_track(progressRef); local yieldTrack=self:_track(yieldRef)
    local snapshot=(yieldTrack and yieldTrack.fieldWorldSnapshot) or (progressTrack and progressTrack.fieldWorldSnapshot)
    local metrics=snapshot and snapshot.geometryMetrics or nil
    local centroid=metrics and {x=metrics.centroidX,z=metrics.centroidZ} or nil
    local candidates={}
    for _,candidate in ipairs(fixtureCandidates or {}) do
        candidates[#candidates+1]={kind="EXISTING_FIXTURE",label="FIXTURE_SIDE_"..tostring(candidate.side),targetX=candidate.targetX,targetZ=candidate.targetZ,side=candidate.side,existingFit=candidate.fit,progressDistance=candidate.progressDistance}
    end
    local offsets=OuttaMyWay.REFUGE_QUALIFICATION_SHADOW_INFIELD_OFFSETS_M or {20,35,50}
    for _,candidate in ipairs(Probe.generateInfieldCandidates(yieldPose,centroid,offsets)) do candidates[#candidates+1]=candidate end

    local fitRadius=OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FIT_SAMPLE_RADIUS_M or 8.0
    local fitCount=OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FIT_SAMPLE_COUNT or 12
    local demos=self.headlandProbe and self.headlandProbe:getObservations(progressRef,progressJob) or {}
    local boundaryDemand=OuttaMyWay.NativeManoeuvreObservationSource.forensicDemandEnvelope(demos)
    local mapSummary=self.coverageProbe and self.coverageProbe:getMapSummary(progressRef,progressJob) or {cellCount=0,sweepCount=0,status="UNAVAILABLE"}
    self.evaluationCount=self.evaluationCount+1
    local nativeCommand=self.nativeCommandProbe and self.nativeCommandProbe:logEvent("REFUGE_SELECTION_PROGRESS",run.progressVehicle) or nil
    logInfo("EVALUATION_OPEN index=%d yield=%s progress=%s progressJob=%s candidates=%d productiveCoverageCells=%d productiveCoverageSweeps=%d boundaryDemandProfiles=%d fieldCentroid=%s nativeCommandStatus=%s selectionAuthority=false decisionAuthority=false controlAuthority=false",
        self.evaluationCount,tostring(run.vehicleName),tostring(run.progressVehicleName),tostring(progressJob),#candidates,mapSummary.cellCount or 0,mapSummary.sweepCount or 0,boundaryDemand and boundaryDemand.count or 0,
        centroid and string.format("(%.2f,%.2f)",centroid.x,centroid.z) or "n/a",nativeCommand and nativeCommand.status or "UNRESOLVED")

    for _,candidate in ipairs(candidates) do
        local fit=qualifyField(sourceFieldId,candidate.targetX,candidate.targetZ,fitRadius,fitCount)
        local boundaryDistance=nearestBoundaryDistance(snapshot,candidate.targetX,candidate.targetZ)
        local boundaryClass=Probe.boundaryDemandClass(boundaryDistance,boundaryDemand and boundaryDemand.entryBoundaryDistanceM or nil)
        local future=futureIntersection(progressTrack,candidate.targetX,candidate.targetZ,fitRadius)
        local coverage=self.coverageProbe and self.coverageProbe:evaluateCircle(progressRef,progressJob,candidate.targetX,candidate.targetZ,fitRadius) or {status="UNRESOLVED",demonstrated=0,total=0,ratio=0,mapCellCount=0}
        local nativeRelation=OuttaMyWay.NativeFieldWorkerDriveCommandProbe and OuttaMyWay.NativeFieldWorkerDriveCommandProbe.candidateRelation(nativeCommand,candidate.targetX,candidate.targetZ) or {status="UNRESOLVED"}
        logInfo("CANDIDATE index=%d kind=%s label=%s target=(%.2f,%.2f) fieldFit=%s samples=%d/%d nearestFieldBoundary=%s demonstratedBoundaryEntry=%s boundaryDemandRelation=%s progressFuture=%s futureDistance=%s futureRequired=%s progressProductiveCoverage=%s coverageSamples=%d/%d coverageRatio=%.3f progressDistanceNow=%.2fm nativeCommandRelation=%s nativeCommandTargetDelta=(%s,%s) nativeCommandTargetDistance=%s interpretationAuthority=PASSIVE_EVIDENCE_VECTOR_ONLY nativeCommandRoutePrediction=false negativeClearanceAuthority=false selectionInfluence=false",
            self.evaluationCount,tostring(candidate.kind),tostring(candidate.label),candidate.targetX,candidate.targetZ,tostring(fit.qualified),fit.matched,fit.required,
            boundaryDistance and string.format("%.2fm",boundaryDistance) or "n/a",boundaryDemand and string.format("%.2fm",boundaryDemand.entryBoundaryDistanceM) or "n/a",boundaryClass,
            tostring(future.status),future.distance and string.format("%.2fm",future.distance) or "n/a",future.required and string.format("%.2fm",future.required) or "n/a",
            tostring(coverage.status),coverage.demonstrated or 0,coverage.total or 0,coverage.ratio or 0,
            math.sqrt((candidate.targetX-progressPose.x)^2+(candidate.targetZ-progressPose.z)^2),tostring(nativeRelation.status),
            nativeRelation.targetDeltaX and string.format("%.2fm",nativeRelation.targetDeltaX) or "n/a",nativeRelation.targetDeltaZ and string.format("%.2fm",nativeRelation.targetDeltaZ) or "n/a",nativeRelation.targetDistanceM and string.format("%.2fm",nativeRelation.targetDistanceM) or "n/a")
    end
    logInfo("EVALUATION_CLOSE index=%d result=NO_SELECTION_CHANGE question=DO_EXISTING_KNOWLEDGE_AND_DEMONSTRATED_PRODUCTIVE_HISTORY_EXPLAIN_A_BETTER_RESULTING_SITUATION next=LIVE_EVIDENCE authority=PASSIVE_ONLY",self.evaluationCount)
end
